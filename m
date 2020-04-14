Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9EFB1A8506
	for <lists+live-patching@lfdr.de>; Tue, 14 Apr 2020 18:32:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391610AbgDNQcU (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 14 Apr 2020 12:32:20 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:26969 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2391619AbgDNQ3Q (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 14 Apr 2020 12:29:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586881748;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZOl4gvwUQNfJhPnPSLsb7hfqt8/TBu9hAvFbDAoKS5Y=;
        b=JlQiyNVsTthmQit6bYnOXki9QNtelBcYNc0E9jXnsbGovQ9DOqE3Ij4NnRImF5B29CnX80
        SK4C5/4pisR/CaEeCNd3+dCd3e4VqxyG+JyEX+6jh49ThkfCUg9HuPCZM4qpoNXFlWPlV+
        h9btEAKYN5kpezgsWXZKWvDa65HgDKE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-251-tYp5-msVPTyiubAwKDOxYg-1; Tue, 14 Apr 2020 12:29:00 -0400
X-MC-Unique: tYp5-msVPTyiubAwKDOxYg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 68EFD802560;
        Tue, 14 Apr 2020 16:28:59 +0000 (UTC)
Received: from treble.redhat.com (ovpn-116-146.rdu2.redhat.com [10.10.116.146])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AAFF85DA66;
        Tue, 14 Apr 2020 16:28:58 +0000 (UTC)
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     live-patching@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Jessica Yu <jeyu@kernel.org>
Subject: [PATCH 3/7] livepatch: Prevent module-specific KLP rela sections from referencing vmlinux symbols
Date:   Tue, 14 Apr 2020 11:28:39 -0500
Message-Id: <9d572c8aa26776e878c14b219b65a360ec6a21cf.1586881704.git.jpoimboe@redhat.com>
In-Reply-To: <cover.1586881704.git.jpoimboe@redhat.com>
References: <cover.1586881704.git.jpoimboe@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
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
---
 kernel/livepatch/core.c | 39 ++++++++++++++++++++++++++++-----------
 1 file changed, 28 insertions(+), 11 deletions(-)

diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
index af8f06382e43..817676caddee 100644
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
@@ -301,7 +317,8 @@ int klp_write_relocations(Elf_Ehdr *ehdr, Elf_Shdr *s=
echdrs,
 		if (strcmp(objname ? objname : "vmlinux", sec_objname))
 			continue;
=20
-		ret =3D klp_resolve_symbols(sechdrs, strtab, symndx, sec);
+		ret =3D klp_resolve_symbols(sechdrs, strtab, symndx, sec,
+					  sec_objname);
 		if (ret)
 			break;
=20
--=20
2.21.1

