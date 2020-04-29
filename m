Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE2A91BE2A0
	for <lists+live-patching@lfdr.de>; Wed, 29 Apr 2020 17:26:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727798AbgD2PZR (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 29 Apr 2020 11:25:17 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:55059 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727115AbgD2PZR (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 29 Apr 2020 11:25:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588173915;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=12sAA+Q7OR1BCGg0GMFHZz3qLrjI5+ZRoPX/pJYnNDw=;
        b=bGA6unNB/J9s43mIF3jXEow6T8M5JBSNCtMXu1fPa7iaAQQjzRwHCfkTbswNCgc/kmN2OY
        nODaFfCO7ZteTIaWW5R5YUMvmkxhfFhpT6vflVpwn+3RUMyhmqntQkMF6DXCzs/stWtOo8
        ASnE8MfmJxiPM6BfJiy25dvbMuzaxew=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-233--AIK9TM5P8Gd4mN-JVBcDw-1; Wed, 29 Apr 2020 11:25:13 -0400
X-MC-Unique: -AIK9TM5P8Gd4mN-JVBcDw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 81C678014D9;
        Wed, 29 Apr 2020 15:25:05 +0000 (UTC)
Received: from treble.redhat.com (ovpn-113-19.rdu2.redhat.com [10.10.113.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B10695C2FA;
        Wed, 29 Apr 2020 15:25:04 +0000 (UTC)
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     live-patching@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Jessica Yu <jeyu@kernel.org>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Miroslav Benes <mbenes@suse.cz>
Subject: [PATCH v4 04/11] livepatch: Prevent module-specific KLP rela sections from referencing vmlinux symbols
Date:   Wed, 29 Apr 2020 10:24:46 -0500
Message-Id: <62e132c258390a28232f3396a3492faedb0eaa66.1588173720.git.jpoimboe@redhat.com>
In-Reply-To: <cover.1588173720.git.jpoimboe@redhat.com>
References: <cover.1588173720.git.jpoimboe@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Content-Transfer-Encoding: quoted-printable
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Prevent module-specific KLP rela sections from referencing vmlinux
symbols.  This helps prevent ordering issues with module special section
initializations.  Presumably such symbols are exported and normal relas
can be used instead.

Suggested-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: Joe Lawrence <joe.lawrence@redhat.com>
Acked-by: Miroslav Benes <mbenes@suse.cz>
---
 kernel/livepatch/core.c | 38 +++++++++++++++++++++++++++-----------
 1 file changed, 27 insertions(+), 11 deletions(-)

diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
index 16632e75112a..f9ebb54affab 100644
--- a/kernel/livepatch/core.c
+++ b/kernel/livepatch/core.c
@@ -192,17 +192,20 @@ static int klp_find_object_symbol(const char *objna=
me, const char *name,
 }
=20
 static int klp_resolve_symbols(Elf64_Shdr *sechdrs, const char *strtab,
-			       unsigned int symndx, Elf_Shdr *relasec)
+			       unsigned int symndx, Elf_Shdr *relasec,
+			       const char *sec_objname)
 {
-	int i, cnt, vmlinux, ret;
-	char objname[MODULE_NAME_LEN];
-	char symname[KSYM_NAME_LEN];
+	int i, cnt, ret;
+	char sym_objname[MODULE_NAME_LEN];
+	char sym_name[KSYM_NAME_LEN];
 	Elf_Rela *relas;
 	Elf_Sym *sym;
 	unsigned long sympos, addr;
+	bool sym_vmlinux;
+	bool sec_vmlinux =3D !strcmp(sec_objname, "vmlinux");
=20
 	/*
-	 * Since the field widths for objname and symname in the sscanf()
+	 * Since the field widths for sym_objname and sym_name in the sscanf()
 	 * call are hard-coded and correspond to MODULE_NAME_LEN and
 	 * KSYM_NAME_LEN respectively, we must make sure that MODULE_NAME_LEN
 	 * and KSYM_NAME_LEN have the values we expect them to have.
@@ -223,20 +226,33 @@ static int klp_resolve_symbols(Elf64_Shdr *sechdrs,=
 const char *strtab,
 			return -EINVAL;
 		}
=20
-		/* Format: .klp.sym.objname.symname,sympos */
+		/* Format: .klp.sym.sym_objname.sym_name,sympos */
 		cnt =3D sscanf(strtab + sym->st_name,
 			     ".klp.sym.%55[^.].%127[^,],%lu",
-			     objname, symname, &sympos);
+			     sym_objname, sym_name, &sympos);
 		if (cnt !=3D 3) {
 			pr_err("symbol %s has an incorrectly formatted name\n",
 			       strtab + sym->st_name);
 			return -EINVAL;
 		}
=20
+		sym_vmlinux =3D !strcmp(sym_objname, "vmlinux");
+
+		/*
+		 * Prevent module-specific KLP rela sections from referencing
+		 * vmlinux symbols.  This helps prevent ordering issues with
+		 * module special section initializations.  Presumably such
+		 * symbols are exported and normal relas can be used instead.
+		 */
+		if (!sec_vmlinux && sym_vmlinux) {
+			pr_err("invalid access to vmlinux symbol '%s' from module-specific li=
vepatch relocation section",
+			       sym_name);
+			return -EINVAL;
+		}
+
 		/* klp_find_object_symbol() treats a NULL objname as vmlinux */
-		vmlinux =3D !strcmp(objname, "vmlinux");
-		ret =3D klp_find_object_symbol(vmlinux ? NULL : objname,
-					     symname, sympos, &addr);
+		ret =3D klp_find_object_symbol(sym_vmlinux ? NULL : sym_objname,
+					     sym_name, sympos, &addr);
 		if (ret)
 			return ret;
=20
@@ -294,7 +310,7 @@ int klp_apply_section_relocs(struct module *pmod, Elf=
_Shdr *sechdrs,
 	if (strcmp(objname ? objname : "vmlinux", sec_objname))
 		return 0;
=20
-	ret =3D klp_resolve_symbols(sechdrs, strtab, symndx, sec);
+	ret =3D klp_resolve_symbols(sechdrs, strtab, symndx, sec, sec_objname);
 	if (ret)
 		return ret;
=20
--=20
2.21.1

