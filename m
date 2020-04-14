Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD35A1A8505
	for <lists+live-patching@lfdr.de>; Tue, 14 Apr 2020 18:32:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391722AbgDNQcT (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 14 Apr 2020 12:32:19 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:50794 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2391610AbgDNQ3Q (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 14 Apr 2020 12:29:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586881744;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JlW/L4NqGuAjoL/mgajqooLREyVZURHsH+9BI9EDDaE=;
        b=OwwIsVK8xD8KM7fhWST7qLVdWmsigjL+27GGkpFtmjqtPeib1tlEAeGPWNgVrfqUMUKcEP
        c8oR5tewkEVsOwyWijySG5R5T+M7QzmOK8R1PgpEN1rbmj55J0DYTnACo1e7NJxzvBgrq0
        54Xga3iA57HdML91iJTRUEkv+zw3mF4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-379-zyjFVHmrP6mNwpquyUWPTA-1; Tue, 14 Apr 2020 12:29:02 -0400
X-MC-Unique: zyjFVHmrP6mNwpquyUWPTA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 785DCDB8E;
        Tue, 14 Apr 2020 16:29:00 +0000 (UTC)
Received: from treble.redhat.com (ovpn-116-146.rdu2.redhat.com [10.10.116.146])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 955A85DA66;
        Tue, 14 Apr 2020 16:28:59 +0000 (UTC)
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     live-patching@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Jessica Yu <jeyu@kernel.org>, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com
Subject: [PATCH 4/7] s390/module: Use s390_kernel_write() for relocations
Date:   Tue, 14 Apr 2020 11:28:40 -0500
Message-Id: <e7f2ad87cf83dcdaa7b69b4e37c11fa355bdfe78.1586881704.git.jpoimboe@redhat.com>
In-Reply-To: <cover.1586881704.git.jpoimboe@redhat.com>
References: <cover.1586881704.git.jpoimboe@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Content-Transfer-Encoding: quoted-printable
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

Instead of playing games with module_{dis,en}able_ro(), use existing
text poking mechanisms to apply relocations after module loading.

So far only x86, s390 and Power have HAVE_LIVEPATCH but only the first
two also have STRICT_MODULE_RWX.

This will allow removal of the last module_disable_ro() usage in
livepatch.  The ultimate goal is to completely disallow making
executable mappings writable.

[ jpoimboe: Split up patches. Use mod state to determine whether
	    memcpy() can be used. ]

Cc: linux-s390@vger.kernel.org
Cc: heiko.carstens@de.ibm.com
Suggested-by: Josh Poimboeuf <jpoimboe@redhat.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
---
 arch/s390/kernel/module.c | 106 ++++++++++++++++++++++----------------
 1 file changed, 61 insertions(+), 45 deletions(-)

diff --git a/arch/s390/kernel/module.c b/arch/s390/kernel/module.c
index ba8f19bb438b..e85e378f876e 100644
--- a/arch/s390/kernel/module.c
+++ b/arch/s390/kernel/module.c
@@ -174,7 +174,8 @@ int module_frob_arch_sections(Elf_Ehdr *hdr, Elf_Shdr=
 *sechdrs,
 }
=20
 static int apply_rela_bits(Elf_Addr loc, Elf_Addr val,
-			   int sign, int bits, int shift)
+			   int sign, int bits, int shift,
+			   void (*write)(void *dest, const void *src, size_t len))
 {
 	unsigned long umax;
 	long min, max;
@@ -194,26 +195,29 @@ static int apply_rela_bits(Elf_Addr loc, Elf_Addr v=
al,
 			return -ENOEXEC;
 	}
=20
-	if (bits =3D=3D 8)
-		*(unsigned char *) loc =3D val;
-	else if (bits =3D=3D 12)
-		*(unsigned short *) loc =3D (val & 0xfff) |
+	if (bits =3D=3D 8) {
+		write(loc, &val, 1);
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
+		write(loc, &tmp, 2);
+	} else if (bits =3D=3D 16) {
+		write(loc, &val, 2);
+	} else if (bits =3D=3D 20) {
+		unsigned int tmp =3D (val & 0xfff) << 16 |
+			(val & 0xff000) >> 4 | (*(unsigned int *) loc & 0xf00000ff);
+		write(loc, &tmp, 4);
+	} else if (bits =3D=3D 32) {
+		write(loc, &val, 4);
+	} else if (bits =3D=3D 64) {
+		write(loc, &val, 8);
+	}
 	return 0;
 }
=20
 static int apply_rela(Elf_Rela *rela, Elf_Addr base, Elf_Sym *symtab,
-		      const char *strtab, struct module *me)
+		      const char *strtab, struct module *me,
+		      void (*write)(void *dest, const void *src, size_t len))
 {
 	struct mod_arch_syminfo *info;
 	Elf_Addr loc, val;
@@ -241,17 +245,17 @@ static int apply_rela(Elf_Rela *rela, Elf_Addr base=
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
@@ -260,15 +264,15 @@ static int apply_rela(Elf_Rela *rela, Elf_Addr base=
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
@@ -293,23 +297,23 @@ static int apply_rela(Elf_Rela *rela, Elf_Addr base=
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
@@ -357,17 +361,17 @@ static int apply_rela(Elf_Rela *rela, Elf_Addr base=
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
@@ -375,20 +379,20 @@ static int apply_rela(Elf_Rela *rela, Elf_Addr base=
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
@@ -412,9 +416,10 @@ static int apply_rela(Elf_Rela *rela, Elf_Addr base,=
 Elf_Sym *symtab,
 	return 0;
 }
=20
-int apply_relocate_add(Elf_Shdr *sechdrs, const char *strtab,
+static int __apply_relocate_add(Elf_Shdr *sechdrs, const char *strtab,
 		       unsigned int symindex, unsigned int relsec,
-		       struct module *me)
+		       struct module *me,
+		       void (*write)(void *dest, const void *src, size_t len))
 {
 	Elf_Addr base;
 	Elf_Sym *symtab;
@@ -437,6 +442,17 @@ int apply_relocate_add(Elf_Shdr *sechdrs, const char=
 *strtab,
 	return 0;
 }
=20
+int apply_relocate_add(Elf_Shdr *sechdrs, const char *strtab,
+		       unsigned int symindex, unsigned int relsec,
+		       struct module *me)
+{
+	int ret;
+	bool early =3D me->state =3D=3D MODULE_STATE_UNFORMED;
+
+	return __apply_relocate_add(sechdrs, strtab, symindex, relsec, me,
+				    early ? memcpy : s390_kernel_write);
+}
+
 int module_finalize(const Elf_Ehdr *hdr,
 		    const Elf_Shdr *sechdrs,
 		    struct module *me)
--=20
2.21.1

