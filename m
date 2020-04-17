Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F4521ADF15
	for <lists+live-patching@lfdr.de>; Fri, 17 Apr 2020 16:10:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730847AbgDQOE6 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 17 Apr 2020 10:04:58 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:60430 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730843AbgDQOE5 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 17 Apr 2020 10:04:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587132294;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2TGDJ9LsKfboNACQHj6QkDgjDTs16M7bX2fjjOCq2xg=;
        b=AGSN7cqimm+rvfj3X1FcETBQUQWWUj6FF2Ss26hJJvtR6AlvNIWKuKzXFXlFTv2VaSzbpW
        ykZG38zNjl0Kre5bdKvQOOORGsvy0VzDMXuXjgJEsCj+8nq7LA80qaxf+FEHtXnAAq4CLK
        ed7obCTid3Uhimo7ldR3/wknlqpP4Qs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-96-eiFu_nbSNW-CaA7kDjW4uQ-1; Fri, 17 Apr 2020 10:04:52 -0400
X-MC-Unique: eiFu_nbSNW-CaA7kDjW4uQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 18BFADB62;
        Fri, 17 Apr 2020 14:04:51 +0000 (UTC)
Received: from treble.redhat.com (ovpn-116-146.rdu2.redhat.com [10.10.116.146])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2785A5C1C5;
        Fri, 17 Apr 2020 14:04:50 +0000 (UTC)
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     live-patching@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Jessica Yu <jeyu@kernel.org>, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com
Subject: [PATCH v2 6/9] s390/module: Use s390_kernel_write() for late relocations
Date:   Fri, 17 Apr 2020 09:04:31 -0500
Message-Id: <18266eb2c2c9a2ce0033426837d89dcb363a85d3.1587131959.git.jpoimboe@redhat.com>
In-Reply-To: <cover.1587131959.git.jpoimboe@redhat.com>
References: <cover.1587131959.git.jpoimboe@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Content-Transfer-Encoding: quoted-printable
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

Because of late module patching, a livepatch module needs to be able to
apply some of its relocations well after it has been loaded.  Instead of
playing games with module_{dis,en}able_ro(), use existing text poking
mechanisms to apply relocations after module loading.

So far only x86, s390 and Power have HAVE_LIVEPATCH but only the first
two also have STRICT_MODULE_RWX.

This will allow removal of the last module_disable_ro() usage in
livepatch.  The ultimate goal is to completely disallow making
executable mappings writable.

Also, for the late patching case, use text_mutex, which is supposed to
be held for all runtime text patching operations.

[ jpoimboe: Split up patches.  Use mod state to determine whether
	    memcpy() can be used.  Add text_mutex.  Make it build. ]

Cc: linux-s390@vger.kernel.org
Cc: heiko.carstens@de.ibm.com
Suggested-by: Josh Poimboeuf <jpoimboe@redhat.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
---
 arch/s390/kernel/module.c | 125 ++++++++++++++++++++++++--------------
 1 file changed, 79 insertions(+), 46 deletions(-)

diff --git a/arch/s390/kernel/module.c b/arch/s390/kernel/module.c
index ba8f19bb438b..2798329ebb74 100644
--- a/arch/s390/kernel/module.c
+++ b/arch/s390/kernel/module.c
@@ -19,6 +19,7 @@
 #include <linux/kasan.h>
 #include <linux/moduleloader.h>
 #include <linux/bug.h>
+#include <linux/memory.h>
 #include <asm/alternative.h>
 #include <asm/nospec-branch.h>
 #include <asm/facility.h>
@@ -174,10 +175,12 @@ int module_frob_arch_sections(Elf_Ehdr *hdr, Elf_Sh=
dr *sechdrs,
 }
=20
 static int apply_rela_bits(Elf_Addr loc, Elf_Addr val,
-			   int sign, int bits, int shift)
+			   int sign, int bits, int shift,
+			   void *(*write)(void *dest, const void *src, size_t len))
 {
 	unsigned long umax;
 	long min, max;
+	void *dest =3D (void *)loc;
=20
 	if (val & ((1UL << shift) - 1))
 		return -ENOEXEC;
@@ -194,26 +197,33 @@ static int apply_rela_bits(Elf_Addr loc, Elf_Addr v=
al,
 			return -ENOEXEC;
 	}
=20
-	if (bits =3D=3D 8)
-		*(unsigned char *) loc =3D val;
-	else if (bits =3D=3D 12)
-		*(unsigned short *) loc =3D (val & 0xfff) |
+	if (bits =3D=3D 8) {
+		unsigned char tmp =3D val;
+		write(dest, &tmp, 1);
+	} else if (bits =3D=3D 12) {
+		unsigned short tmp =3D (val & 0xfff) |
 			(*(unsigned short *) loc & 0xf000);
-	else if (bits =3D=3D 16)
-		*(unsigned short *) loc =3D val;
-	else if (bits =3D=3D 20)
-		*(unsigned int *) loc =3D (val & 0xfff) << 16 |
-			(val & 0xff000) >> 4 |
-			(*(unsigned int *) loc & 0xf00000ff);
-	else if (bits =3D=3D 32)
-		*(unsigned int *) loc =3D val;
-	else if (bits =3D=3D 64)
-		*(unsigned long *) loc =3D val;
+		write(dest, &tmp, 2);
+	} else if (bits =3D=3D 16) {
+		unsigned short tmp =3D val;
+		write(dest, &tmp, 2);
+	} else if (bits =3D=3D 20) {
+		unsigned int tmp =3D (val & 0xfff) << 16 |
+			(val & 0xff000) >> 4 | (*(unsigned int *) loc & 0xf00000ff);
+		write(dest, &tmp, 4);
+	} else if (bits =3D=3D 32) {
+		unsigned int tmp =3D val;
+		write(dest, &tmp, 4);
+	} else if (bits =3D=3D 64) {
+		unsigned long tmp =3D val;
+		write(dest, &tmp, 8);
+	}
 	return 0;
 }
=20
 static int apply_rela(Elf_Rela *rela, Elf_Addr base, Elf_Sym *symtab,
-		      const char *strtab, struct module *me)
+		      const char *strtab, struct module *me,
+		      void *(*write)(void *dest, const void *src, size_t len))
 {
 	struct mod_arch_syminfo *info;
 	Elf_Addr loc, val;
@@ -241,17 +251,17 @@ static int apply_rela(Elf_Rela *rela, Elf_Addr base=
, Elf_Sym *symtab,
 	case R_390_64:		/* Direct 64 bit.  */
 		val +=3D rela->r_addend;
 		if (r_type =3D=3D R_390_8)
-			rc =3D apply_rela_bits(loc, val, 0, 8, 0);
+			rc =3D apply_rela_bits(loc, val, 0, 8, 0, write);
 		else if (r_type =3D=3D R_390_12)
-			rc =3D apply_rela_bits(loc, val, 0, 12, 0);
+			rc =3D apply_rela_bits(loc, val, 0, 12, 0, write);
 		else if (r_type =3D=3D R_390_16)
-			rc =3D apply_rela_bits(loc, val, 0, 16, 0);
+			rc =3D apply_rela_bits(loc, val, 0, 16, 0, write);
 		else if (r_type =3D=3D R_390_20)
-			rc =3D apply_rela_bits(loc, val, 1, 20, 0);
+			rc =3D apply_rela_bits(loc, val, 1, 20, 0, write);
 		else if (r_type =3D=3D R_390_32)
-			rc =3D apply_rela_bits(loc, val, 0, 32, 0);
+			rc =3D apply_rela_bits(loc, val, 0, 32, 0, write);
 		else if (r_type =3D=3D R_390_64)
-			rc =3D apply_rela_bits(loc, val, 0, 64, 0);
+			rc =3D apply_rela_bits(loc, val, 0, 64, 0, write);
 		break;
 	case R_390_PC16:	/* PC relative 16 bit.  */
 	case R_390_PC16DBL:	/* PC relative 16 bit shifted by 1.  */
@@ -260,15 +270,15 @@ static int apply_rela(Elf_Rela *rela, Elf_Addr base=
, Elf_Sym *symtab,
 	case R_390_PC64:	/* PC relative 64 bit.	*/
 		val +=3D rela->r_addend - loc;
 		if (r_type =3D=3D R_390_PC16)
-			rc =3D apply_rela_bits(loc, val, 1, 16, 0);
+			rc =3D apply_rela_bits(loc, val, 1, 16, 0, write);
 		else if (r_type =3D=3D R_390_PC16DBL)
-			rc =3D apply_rela_bits(loc, val, 1, 16, 1);
+			rc =3D apply_rela_bits(loc, val, 1, 16, 1, write);
 		else if (r_type =3D=3D R_390_PC32DBL)
-			rc =3D apply_rela_bits(loc, val, 1, 32, 1);
+			rc =3D apply_rela_bits(loc, val, 1, 32, 1, write);
 		else if (r_type =3D=3D R_390_PC32)
-			rc =3D apply_rela_bits(loc, val, 1, 32, 0);
+			rc =3D apply_rela_bits(loc, val, 1, 32, 0, write);
 		else if (r_type =3D=3D R_390_PC64)
-			rc =3D apply_rela_bits(loc, val, 1, 64, 0);
+			rc =3D apply_rela_bits(loc, val, 1, 64, 0, write);
 		break;
 	case R_390_GOT12:	/* 12 bit GOT offset.  */
 	case R_390_GOT16:	/* 16 bit GOT offset.  */
@@ -293,23 +303,23 @@ static int apply_rela(Elf_Rela *rela, Elf_Addr base=
, Elf_Sym *symtab,
 		val =3D info->got_offset + rela->r_addend;
 		if (r_type =3D=3D R_390_GOT12 ||
 		    r_type =3D=3D R_390_GOTPLT12)
-			rc =3D apply_rela_bits(loc, val, 0, 12, 0);
+			rc =3D apply_rela_bits(loc, val, 0, 12, 0, write);
 		else if (r_type =3D=3D R_390_GOT16 ||
 			 r_type =3D=3D R_390_GOTPLT16)
-			rc =3D apply_rela_bits(loc, val, 0, 16, 0);
+			rc =3D apply_rela_bits(loc, val, 0, 16, 0, write);
 		else if (r_type =3D=3D R_390_GOT20 ||
 			 r_type =3D=3D R_390_GOTPLT20)
-			rc =3D apply_rela_bits(loc, val, 1, 20, 0);
+			rc =3D apply_rela_bits(loc, val, 1, 20, 0, write);
 		else if (r_type =3D=3D R_390_GOT32 ||
 			 r_type =3D=3D R_390_GOTPLT32)
-			rc =3D apply_rela_bits(loc, val, 0, 32, 0);
+			rc =3D apply_rela_bits(loc, val, 0, 32, 0, write);
 		else if (r_type =3D=3D R_390_GOT64 ||
 			 r_type =3D=3D R_390_GOTPLT64)
-			rc =3D apply_rela_bits(loc, val, 0, 64, 0);
+			rc =3D apply_rela_bits(loc, val, 0, 64, 0, write);
 		else if (r_type =3D=3D R_390_GOTENT ||
 			 r_type =3D=3D R_390_GOTPLTENT) {
 			val +=3D (Elf_Addr) me->core_layout.base - loc;
-			rc =3D apply_rela_bits(loc, val, 1, 32, 1);
+			rc =3D apply_rela_bits(loc, val, 1, 32, 1, write);
 		}
 		break;
 	case R_390_PLT16DBL:	/* 16 bit PC rel. PLT shifted by 1.  */
@@ -357,17 +367,17 @@ static int apply_rela(Elf_Rela *rela, Elf_Addr base=
, Elf_Sym *symtab,
 			val +=3D rela->r_addend - loc;
 		}
 		if (r_type =3D=3D R_390_PLT16DBL)
-			rc =3D apply_rela_bits(loc, val, 1, 16, 1);
+			rc =3D apply_rela_bits(loc, val, 1, 16, 1, write);
 		else if (r_type =3D=3D R_390_PLTOFF16)
-			rc =3D apply_rela_bits(loc, val, 0, 16, 0);
+			rc =3D apply_rela_bits(loc, val, 0, 16, 0, write);
 		else if (r_type =3D=3D R_390_PLT32DBL)
-			rc =3D apply_rela_bits(loc, val, 1, 32, 1);
+			rc =3D apply_rela_bits(loc, val, 1, 32, 1, write);
 		else if (r_type =3D=3D R_390_PLT32 ||
 			 r_type =3D=3D R_390_PLTOFF32)
-			rc =3D apply_rela_bits(loc, val, 0, 32, 0);
+			rc =3D apply_rela_bits(loc, val, 0, 32, 0, write);
 		else if (r_type =3D=3D R_390_PLT64 ||
 			 r_type =3D=3D R_390_PLTOFF64)
-			rc =3D apply_rela_bits(loc, val, 0, 64, 0);
+			rc =3D apply_rela_bits(loc, val, 0, 64, 0, write);
 		break;
 	case R_390_GOTOFF16:	/* 16 bit offset to GOT.  */
 	case R_390_GOTOFF32:	/* 32 bit offset to GOT.  */
@@ -375,20 +385,20 @@ static int apply_rela(Elf_Rela *rela, Elf_Addr base=
, Elf_Sym *symtab,
 		val =3D val + rela->r_addend -
 			((Elf_Addr) me->core_layout.base + me->arch.got_offset);
 		if (r_type =3D=3D R_390_GOTOFF16)
-			rc =3D apply_rela_bits(loc, val, 0, 16, 0);
+			rc =3D apply_rela_bits(loc, val, 0, 16, 0, write);
 		else if (r_type =3D=3D R_390_GOTOFF32)
-			rc =3D apply_rela_bits(loc, val, 0, 32, 0);
+			rc =3D apply_rela_bits(loc, val, 0, 32, 0, write);
 		else if (r_type =3D=3D R_390_GOTOFF64)
-			rc =3D apply_rela_bits(loc, val, 0, 64, 0);
+			rc =3D apply_rela_bits(loc, val, 0, 64, 0, write);
 		break;
 	case R_390_GOTPC:	/* 32 bit PC relative offset to GOT. */
 	case R_390_GOTPCDBL:	/* 32 bit PC rel. off. to GOT shifted by 1. */
 		val =3D (Elf_Addr) me->core_layout.base + me->arch.got_offset +
 			rela->r_addend - loc;
 		if (r_type =3D=3D R_390_GOTPC)
-			rc =3D apply_rela_bits(loc, val, 1, 32, 0);
+			rc =3D apply_rela_bits(loc, val, 1, 32, 0, write);
 		else if (r_type =3D=3D R_390_GOTPCDBL)
-			rc =3D apply_rela_bits(loc, val, 1, 32, 1);
+			rc =3D apply_rela_bits(loc, val, 1, 32, 1, write);
 		break;
 	case R_390_COPY:
 	case R_390_GLOB_DAT:	/* Create GOT entry.  */
@@ -412,9 +422,10 @@ static int apply_rela(Elf_Rela *rela, Elf_Addr base,=
 Elf_Sym *symtab,
 	return 0;
 }
=20
-int apply_relocate_add(Elf_Shdr *sechdrs, const char *strtab,
+static int __apply_relocate_add(Elf_Shdr *sechdrs, const char *strtab,
 		       unsigned int symindex, unsigned int relsec,
-		       struct module *me)
+		       struct module *me,
+		       void *(*write)(void *dest, const void *src, size_t len))
 {
 	Elf_Addr base;
 	Elf_Sym *symtab;
@@ -430,13 +441,35 @@ int apply_relocate_add(Elf_Shdr *sechdrs, const cha=
r *strtab,
 	n =3D sechdrs[relsec].sh_size / sizeof(Elf_Rela);
=20
 	for (i =3D 0; i < n; i++, rela++) {
-		rc =3D apply_rela(rela, base, symtab, strtab, me);
+		rc =3D apply_rela(rela, base, symtab, strtab, me, write);
 		if (rc)
 			return rc;
 	}
 	return 0;
 }
=20
+int apply_relocate_add(Elf_Shdr *sechdrs, const char *strtab,
+		       unsigned int symindex, unsigned int relsec,
+		       struct module *me)
+{
+	int ret;
+	bool early =3D me->state =3D=3D MODULE_STATE_UNFORMED;
+	void *(*write)(void *, const void *, size_t) =3D memcpy;
+
+	if (!early) {
+		write =3D s390_kernel_write;
+		mutex_lock(&text_mutex);
+	}
+
+	ret =3D __apply_relocate_add(sechdrs, strtab, symindex, relsec, me,
+				   write);
+
+	if (!early)
+		mutex_unlock(&text_mutex);
+
+	return ret;
+}
+
 int module_finalize(const Elf_Ehdr *hdr,
 		    const Elf_Shdr *sechdrs,
 		    struct module *me)
--=20
2.21.1

