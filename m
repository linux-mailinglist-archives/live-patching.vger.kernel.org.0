Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F1E21A84FB
	for <lists+live-patching@lfdr.de>; Tue, 14 Apr 2020 18:32:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391696AbgDNQbe (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 14 Apr 2020 12:31:34 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:26382 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2391614AbgDNQ3R (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 14 Apr 2020 12:29:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586881747;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SDOntVpJ2wIX8xc8jWrCMYRJV9gG7vNugW7XYn0v5+k=;
        b=BSbO2uBpU6JWS89wXHHrwCQLQstCPhUay2zv5MuvL5Bq3UDcN+tXEhieqC6WDeHaFR/8l/
        UKwnArIFp7I83bSPYWArJl3kAYD+UgkVw6NWWfKP2OYeOxmnSVQz28GrzMR66C26aVxJvi
        p7I2QgT3Y3oOyODgStIFc95r1HC1Eao=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-156-FtjNr5VWMxa35jaLXC5NoQ-1; Tue, 14 Apr 2020 12:29:02 -0400
X-MC-Unique: FtjNr5VWMxa35jaLXC5NoQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 797A8107ACC7;
        Tue, 14 Apr 2020 16:29:01 +0000 (UTC)
Received: from treble.redhat.com (ovpn-116-146.rdu2.redhat.com [10.10.116.146])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A37885DA66;
        Tue, 14 Apr 2020 16:29:00 +0000 (UTC)
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     live-patching@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Jessica Yu <jeyu@kernel.org>, x86@kernel.org
Subject: [PATCH 5/7] x86/module: Use text_poke() for relocations
Date:   Tue, 14 Apr 2020 11:28:41 -0500
Message-Id: <bd80e3695203179a7ad12fa2b9ff7d5f1b38f024.1586881704.git.jpoimboe@redhat.com>
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

[ jpoimboe: Split up patches.  Use mod state to determine whether
	    memcpy() can be used.  Implement text_poke() for UML. ]

Cc: x86@kernel.org
Suggested-by: Josh Poimboeuf <jpoimboe@redhat.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
---
 arch/um/kernel/um_arch.c | 16 ++++++++++++++++
 arch/x86/kernel/module.c | 34 +++++++++++++++++++++++++++-------
 2 files changed, 43 insertions(+), 7 deletions(-)

diff --git a/arch/um/kernel/um_arch.c b/arch/um/kernel/um_arch.c
index 0f40eccbd759..375ab720e4aa 100644
--- a/arch/um/kernel/um_arch.c
+++ b/arch/um/kernel/um_arch.c
@@ -362,3 +362,19 @@ void __init check_bugs(void)
 void apply_alternatives(struct alt_instr *start, struct alt_instr *end)
 {
 }
+
+void *text_poke(void *addr, const void *opcode, size_t len)
+{
+	/*
+	 * In UML, the only reference to this function is in
+	 * apply_relocate_add(), which shouldn't ever actually call this
+	 * because UML doesn't have live patching.
+	 */
+	WARN_ON(1);
+
+	return memcpy(addr, opcode, len);
+}
+
+void text_poke_sync(void)
+{
+}
diff --git a/arch/x86/kernel/module.c b/arch/x86/kernel/module.c
index d5c72cb877b3..b67ec70cf35b 100644
--- a/arch/x86/kernel/module.c
+++ b/arch/x86/kernel/module.c
@@ -126,11 +126,12 @@ int apply_relocate(Elf32_Shdr *sechdrs,
 	return 0;
 }
 #else /*X86_64*/
-int apply_relocate_add(Elf64_Shdr *sechdrs,
+static int __apply_relocate_add(Elf64_Shdr *sechdrs,
 		   const char *strtab,
 		   unsigned int symindex,
 		   unsigned int relsec,
-		   struct module *me)
+		   struct module *me,
+		   void *(*write)(void *dest, const void *src, size_t len))
 {
 	unsigned int i;
 	Elf64_Rela *rel =3D (void *)sechdrs[relsec].sh_addr;
@@ -162,19 +163,19 @@ int apply_relocate_add(Elf64_Shdr *sechdrs,
 		case R_X86_64_64:
 			if (*(u64 *)loc !=3D 0)
 				goto invalid_relocation;
-			*(u64 *)loc =3D val;
+			write(loc, &val, 8);
 			break;
 		case R_X86_64_32:
 			if (*(u32 *)loc !=3D 0)
 				goto invalid_relocation;
-			*(u32 *)loc =3D val;
+			write(loc, &val, 4);
 			if (val !=3D *(u32 *)loc)
 				goto overflow;
 			break;
 		case R_X86_64_32S:
 			if (*(s32 *)loc !=3D 0)
 				goto invalid_relocation;
-			*(s32 *)loc =3D val;
+			write(loc, &val, 4);
 			if ((s64)val !=3D *(s32 *)loc)
 				goto overflow;
 			break;
@@ -183,7 +184,7 @@ int apply_relocate_add(Elf64_Shdr *sechdrs,
 			if (*(u32 *)loc !=3D 0)
 				goto invalid_relocation;
 			val -=3D (u64)loc;
-			*(u32 *)loc =3D val;
+			write(loc, &val, 4);
 #if 0
 			if ((s64)val !=3D *(s32 *)loc)
 				goto overflow;
@@ -193,7 +194,7 @@ int apply_relocate_add(Elf64_Shdr *sechdrs,
 			if (*(u64 *)loc !=3D 0)
 				goto invalid_relocation;
 			val -=3D (u64)loc;
-			*(u64 *)loc =3D val;
+			write(loc, &val, 8);
 			break;
 		default:
 			pr_err("%s: Unknown rela relocation: %llu\n",
@@ -215,6 +216,25 @@ int apply_relocate_add(Elf64_Shdr *sechdrs,
 	       me->name);
 	return -ENOEXEC;
 }
+
+int apply_relocate_add(Elf64_Shdr *sechdrs,
+		   const char *strtab,
+		   unsigned int symindex,
+		   unsigned int relsec,
+		   struct module *me)
+{
+	int ret;
+	bool early =3D me->state =3D=3D MODULE_STATE_UNFORMED;
+
+	ret =3D __apply_relocate_add(sechdrs, strtab, symindex, relsec, me,
+				   early ? memcpy : text_poke);
+
+	if (!ret && !early)
+		text_poke_sync();
+
+	return ret;
+}
+
 #endif
=20
 int module_finalize(const Elf_Ehdr *hdr,
--=20
2.21.1

