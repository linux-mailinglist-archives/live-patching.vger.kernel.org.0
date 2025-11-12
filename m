Return-Path: <live-patching+bounces-1848-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 4CB3BC54D62
	for <lists+live-patching@lfdr.de>; Thu, 13 Nov 2025 00:49:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 540D5348EC3
	for <lists+live-patching@lfdr.de>; Wed, 12 Nov 2025 23:48:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A1F0F2F290B;
	Wed, 12 Nov 2025 23:48:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="H20MCncK"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 799992F1FDE;
	Wed, 12 Nov 2025 23:48:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762991280; cv=none; b=LBa9cI361gzPUoy5kvBbgU9H65HFz84QOSqJMBTcUtZdPMFzHuy6iAGCU+AHPc4gBqzP7NwJYwlDMsVSFnIPkUgqpnmRMZZJMQxaSuZ/x931DLPzr5zMYWsqQnasgx5EhfaR2WDxRtCdgqZXoy6k3xqmOOGslyf0vDbXH+rNnQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762991280; c=relaxed/simple;
	bh=bLa5wT6Q9MoJLKpOwPOyb0MAjQDFxxCojERb/PzbZrc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JHqBThlI5zutxXyfEeNVh/LlQm/tkN0D8T69yPM/iUXO+ELxQJcyvzOklEoN5lBfj+Sng4A/9v0BHgz13AWeqLxNF2iLa5gDGBeUij2kqU2AMikba+j17ajh0ot/5UkNaIjRlwnosA3r/P0KTfVcO4CPOyFc2qrQUNWluREJ7xo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=H20MCncK; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D430EC4CEF1;
	Wed, 12 Nov 2025 23:47:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762991280;
	bh=bLa5wT6Q9MoJLKpOwPOyb0MAjQDFxxCojERb/PzbZrc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H20MCncKA6NA1aMlT5lO0QljycPGIcbHTn/hjsYiL5WvF4HBO3bRloVNfbn8ah+QQ
	 vmF0lSTkRHshaSBWRaYe3J6uDVEQ4YEuwx00mLSzgtN9PT7zH8lmC/w6FoTyMkNAIv
	 yws+87UB+rhFKRNM76qkqkLsLuWCItIeDBXkbYa002rEDDU045VSbyrX89WKrIO6+a
	 jvd+qVKwK2XVGq1YzNpimIXVhXgUPvogVW8d50+0/1qqorSR25mn/gFzYXnNJ8RlfD
	 aqyM6FNLJEFt3JHt72zLuUBUNspslZ8FYsYb7prFdUqXWvmYlKPMmdK+1OOD76mfAJ
	 z2deXErZ/sloA==
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org,
	Peter Zijlstra <peterz@infradead.org>,
	live-patching@vger.kernel.org
Subject: [PATCH 4/4] objtool: Warn on functions with ambiguous -ffunction-sections section names
Date: Wed, 12 Nov 2025 15:47:51 -0800
Message-ID: <65fedea974fe14be487c8867a0b8d0e4a294ce1e.1762991150.git.jpoimboe@kernel.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <cover.1762991150.git.jpoimboe@kernel.org>
References: <cover.1762991150.git.jpoimboe@kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When compiled with -ffunction-sections, a function named startup() will
be placed in .text.startup.  However, .text.startup is also used by the
compiler for functions with __attribute__((constructor)).

That creates an ambiguity for the vmlinux linker script, which needs to
differentiate those two cases.

Similar naming conflicts exist for functions named exit(), split(),
unlikely(), hot() and unknown().

One potential solution would be to use '#ifdef CC_USING_FUNCTION_SECTIONS'
to create two distinct implementations of the TEXT_MAIN macro.  However,
-ffunction-sections can be (and is) enabled or disabled on a per-object
basis (for example via ccflags-y or AUTOFDO_PROFILE).

So the recently unified TEXT_MAIN macro (commit 1ba9f8979426
("vmlinux.lds: Unify TEXT_MAIN, DATA_MAIN, and related macros")) is
necessary.  This means there's no way for the linker script to
disambiguate things.

Instead, use objtool to warn on any function names whose resulting
section names might create ambiguity when the kernel is compiled (in
whole or in part) with -ffunction-sections.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 include/asm-generic/vmlinux.lds.h       | 15 +++++++++++
 tools/objtool/Documentation/objtool.txt |  7 ++++++
 tools/objtool/check.c                   | 33 +++++++++++++++++++++++++
 3 files changed, 55 insertions(+)

diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index 20695bc8f174..57aa01d24087 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -97,6 +97,21 @@
  * Other .text.* sections that are typically grouped separately, such as
  * .text.unlikely or .text.hot, must be matched explicitly before using
  * TEXT_MAIN.
+ *
+ * NOTE: builds *with* and *without* -ffunction-sections are both supported by
+ * this single macro.  Even with -ffunction-sections, there may be some objects
+ * NOT compiled with the flag due to the use of a specific Makefile override
+ * like cflags-y or AUTOFDO_PROFILE_foo.o.  So this single catchall rule is
+ * needed to support mixed object builds.
+ *
+ * One implication is that functions named startup(), exit(), split(),
+ * unlikely(), hot(), and unknown() are not allowed in the kernel due to the
+ * ambiguity of their section names with -ffunction-sections.  For example,
+ * .text.startup could be __attribute__((constructor)) code in a *non*
+ * ffunction-sections object, which should be placed in .init.text; or it could
+ * be an actual function named startup() in an ffunction-sections object, which
+ * should be placed in .text.  Objtool will detect and complain about any such
+ * ambiguously named functions.
  */
 #define TEXT_MAIN							\
 	.text								\
diff --git a/tools/objtool/Documentation/objtool.txt b/tools/objtool/Documentation/objtool.txt
index 9e97fc25b2d8..f88f8d28513a 100644
--- a/tools/objtool/Documentation/objtool.txt
+++ b/tools/objtool/Documentation/objtool.txt
@@ -456,6 +456,13 @@ the objtool maintainers.
     these special names and does not use module_init() / module_exit()
     macros to create them.
 
+13. file.o: warning: func() function name creates ambiguity with -ffunctions-sections
+
+    Functions named startup(), exit(), split(), unlikely(), hot(), and
+    unknown() are not allowed due to the ambiguity of their section
+    names when compiled with -ffunction-sections.  For more information,
+    see the comment above TEXT_MAIN in include/asm-generic/vmlinux.lds.h.
+
 
 If the error doesn't seem to make sense, it could be a bug in objtool.
 Feel free to ask objtool maintainers for help.
diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index d071fbf73e4c..ac78f6ec9758 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -2662,6 +2662,37 @@ static int decode_sections(struct objtool_file *file)
 	return 0;
 }
 
+/*
+ * Certain function names are disallowed due to section name ambiguities
+ * introduced by -ffunction-sections.
+ *
+ * See the comment above TEXT_MAIN in include/asm-generic/vmlinux.lds.h.
+ */
+static int validate_function_names(struct objtool_file *file)
+{
+	struct symbol *func;
+	int warnings = 0;
+
+	for_each_sym(file->elf, func) {
+		if (!is_func_sym(func))
+			continue;
+
+		if (!strcmp(func->name, "startup")	|| strstarts(func->name, "startup.")	||
+		    !strcmp(func->name, "exit")		|| strstarts(func->name, "exit.")	||
+		    !strcmp(func->name, "split")	|| strstarts(func->name, "split.")	||
+		    !strcmp(func->name, "unlikely")	|| strstarts(func->name, "unlikely.")	||
+		    !strcmp(func->name, "hot")		|| strstarts(func->name, "hot.")	||
+		    !strcmp(func->name, "unknown")	|| strstarts(func->name, "unknown.")) {
+
+			WARN("%s() function name creates ambiguity with -ffunction-sections",
+			     func->name);
+			warnings++;
+		}
+	}
+
+	return warnings;
+}
+
 static bool is_special_call(struct instruction *insn)
 {
 	if (insn->type == INSN_CALL) {
@@ -4928,6 +4959,8 @@ int check(struct objtool_file *file)
 	if (!nr_insns)
 		goto out;
 
+	warnings += validate_function_names(file);
+
 	if (opts.retpoline)
 		warnings += validate_retpoline(file);
 
-- 
2.51.1


