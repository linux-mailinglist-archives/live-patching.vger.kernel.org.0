Return-Path: <live-patching+bounces-322-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C96048FC224
	for <lists+live-patching@lfdr.de>; Wed,  5 Jun 2024 05:21:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E81941C21015
	for <lists+live-patching@lfdr.de>; Wed,  5 Jun 2024 03:21:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E28A261FD6;
	Wed,  5 Jun 2024 03:21:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uTH+VKDo"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6C2F79DE;
	Wed,  5 Jun 2024 03:21:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717557714; cv=none; b=bMket+WSnFYquo1L2uVS1VJXdvD5kkvrRHRXxQkQ6MjlssPOYhpc5KXD5bsx7LGGeTDNdiA0Yx/U6y9Wca7Vw0wORxnKfYwj6co1bApy8sJdOrJ9BdzvRvDPV5fADLdhokKEdDhO1QBnPRhzlNKlV0wGkkIs8QUOWVBEtq7LW98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717557714; c=relaxed/simple;
	bh=XXmGYhr/asAtu28FiZdJhn7l0dn1aN/YIqMkca+f7JE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=OYb1KLB+4vOUJw4bZyrgCev+Yb2b2uXTZiZzYcI9RbHybrsKAkIVAm3rQlZOyLkRt8EhElZG6e2b7gAqFkBMQ9xQHcxzMXwvqlN8xvjlQIa1Dxboxfy5mi5qlTQrj81eGOrjHRXvul9I6IWV0eUvBqOGS5TPYx8b32hMlj2JBvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uTH+VKDo; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5ECBC32781;
	Wed,  5 Jun 2024 03:21:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717557714;
	bh=XXmGYhr/asAtu28FiZdJhn7l0dn1aN/YIqMkca+f7JE=;
	h=From:To:Cc:Subject:Date:From;
	b=uTH+VKDo86rqriq+2tGeiI7GDLHqZyU6gpJv5Gb4oh4x147MTH9CRncEJcUS16Im1
	 zwY3xS9Se9/6NRsglKZufswbeuKwXEDxXgDxkGNGfYDwaBV6wPEe4QgyL48vfpkOzX
	 BxUyxVysug7fAW36wbeAYeEO9eGuybI3K+lQiuuB86UeupXkzYcUr3TfXcjasB1tvu
	 pWWTZFxpKomQcMqR+4tj4Xe2fpD9lmNOYH3TaH5G3caDqm7WYMVdYJyifthaainz87
	 0+acwJhNxXYQq19ZQXGnggDddTePod1+kZv7Qd37SGugKvHkrFxBr3RrSN8tvnQcoy
	 hBTZKDds+cyew==
From: Song Liu <song@kernel.org>
To: live-patching@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: jpoimboe@kernel.org,
	jikos@kernel.org,
	mbenes@suse.cz,
	pmladek@suse.com,
	joe.lawrence@redhat.com,
	nathan@kernel.org,
	morbo@google.com,
	justinstitt@google.com,
	mcgrof@kernel.org,
	thunder.leizhen@huawei.com,
	kees@kernel.org,
	kernel-team@meta.com,
	Song Liu <song@kernel.org>
Subject: [PATCH] kallsyms, livepatch: Fix livepatch with CONFIG_LTO_CLANG
Date: Tue,  4 Jun 2024 20:21:20 -0700
Message-ID: <20240605032120.3179157-1-song@kernel.org>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

With CONFIG_LTO_CLANG, the compiler may postfix symbols with .llvm.<hash>
to avoid symbol duplication. scripts/kallsyms.c sorted the symbols
without these postfixes. The default symbol lookup also removes these
postfixes before comparing symbols.

On the other hand, livepatch need to look up symbols with the full names.
However, calling kallsyms_on_each_match_symbol with full name (with the
postfix) cannot find the symbol(s). As a result, we cannot livepatch
kernel functions with .llvm.<hash> postfix or kernel functions that use
relocation information to symbols with .llvm.<hash> postfixes.

Fix this by calling kallsyms_on_each_match_symbol without the postfix;
and then match the full name (with postfix) in klp_match_callback.

Signed-off-by: Song Liu <song@kernel.org>
---
 include/linux/kallsyms.h | 13 +++++++++++++
 kernel/kallsyms.c        | 21 ++++++++++++++++-----
 kernel/livepatch/core.c  | 32 +++++++++++++++++++++++++++++++-
 3 files changed, 60 insertions(+), 6 deletions(-)

diff --git a/include/linux/kallsyms.h b/include/linux/kallsyms.h
index c3f075e8f60c..d7d07a134ae4 100644
--- a/include/linux/kallsyms.h
+++ b/include/linux/kallsyms.h
@@ -97,6 +97,10 @@ extern int sprint_backtrace_build_id(char *buffer, unsigned long address);
 
 int lookup_symbol_name(unsigned long addr, char *symname);
 
+int kallsyms_lookup_symbol_full_name(unsigned long addr, char *symname);
+
+void kallsyms_cleanup_symbol_name(char *s);
+
 #else /* !CONFIG_KALLSYMS */
 
 static inline unsigned long kallsyms_lookup_name(const char *name)
@@ -165,6 +169,15 @@ static inline int kallsyms_on_each_match_symbol(int (*fn)(void *, unsigned long)
 {
 	return -EOPNOTSUPP;
 }
+
+static inline int kallsyms_lookup_symbol_full_name(unsigned long addr, char *symname)
+{
+	return -ERANGE;
+}
+
+static inline void kallsyms_cleanup_symbol_name(char *s)
+{
+}
 #endif /*CONFIG_KALLSYMS*/
 
 static inline void print_ip_sym(const char *loglvl, unsigned long ip)
diff --git a/kernel/kallsyms.c b/kernel/kallsyms.c
index 22ea19a36e6e..f0d04fa1bbb4 100644
--- a/kernel/kallsyms.c
+++ b/kernel/kallsyms.c
@@ -163,7 +163,7 @@ unsigned long kallsyms_sym_address(int idx)
 	return kallsyms_relative_base - 1 - kallsyms_offsets[idx];
 }
 
-static void cleanup_symbol_name(char *s)
+void kallsyms_cleanup_symbol_name(char *s)
 {
 	char *res;
 
@@ -191,7 +191,7 @@ static int compare_symbol_name(const char *name, char *namebuf)
 	 * To ensure correct bisection in kallsyms_lookup_names(), do
 	 * cleanup_symbol_name(namebuf) before comparing name and namebuf.
 	 */
-	cleanup_symbol_name(namebuf);
+	kallsyms_cleanup_symbol_name(namebuf);
 	return strcmp(name, namebuf);
 }
 
@@ -426,7 +426,7 @@ static const char *kallsyms_lookup_buildid(unsigned long addr,
 						offset, modname, namebuf);
 
 found:
-	cleanup_symbol_name(namebuf);
+	kallsyms_cleanup_symbol_name(namebuf);
 	return ret;
 }
 
@@ -446,7 +446,7 @@ const char *kallsyms_lookup(unsigned long addr,
 				       NULL, namebuf);
 }
 
-int lookup_symbol_name(unsigned long addr, char *symname)
+static int __lookup_symbol_name(unsigned long addr, char *symname, bool cleanup)
 {
 	int res;
 
@@ -468,10 +468,21 @@ int lookup_symbol_name(unsigned long addr, char *symname)
 		return res;
 
 found:
-	cleanup_symbol_name(symname);
+	if (cleanup)
+		kallsyms_cleanup_symbol_name(symname);
 	return 0;
 }
 
+int lookup_symbol_name(unsigned long addr, char *symname)
+{
+	return __lookup_symbol_name(addr, symname, true);
+}
+
+int kallsyms_lookup_symbol_full_name(unsigned long addr, char *symname)
+{
+	return __lookup_symbol_name(addr, symname, false);
+}
+
 /* Look up a kernel symbol and return it in a text buffer. */
 static int __sprint_symbol(char *buffer, unsigned long address,
 			   int symbol_offset, int add_offset, int add_buildid)
diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
index 52426665eecc..284220e04801 100644
--- a/kernel/livepatch/core.c
+++ b/kernel/livepatch/core.c
@@ -128,6 +128,19 @@ struct klp_find_arg {
 static int klp_match_callback(void *data, unsigned long addr)
 {
 	struct klp_find_arg *args = data;
+#ifdef CONFIG_LTO_CLANG
+	char full_name[KSYM_NAME_LEN];
+
+	/*
+	 * With CONFIG_LTO_CLANG, we need to compare the full name of the
+	 * symbol (with .llvm.<hash> postfix).
+	 */
+	if (kallsyms_lookup_symbol_full_name(addr, full_name))
+		return 0;
+
+	if (strcmp(args->name, full_name))
+		return 0;
+#endif
 
 	args->addr = addr;
 	args->count++;
@@ -145,10 +158,12 @@ static int klp_match_callback(void *data, unsigned long addr)
 
 static int klp_find_callback(void *data, const char *name, unsigned long addr)
 {
+#ifndef CONFIG_LTO_CLANG
 	struct klp_find_arg *args = data;
 
 	if (strcmp(args->name, name))
 		return 0;
+#endif
 
 	return klp_match_callback(data, addr);
 }
@@ -162,11 +177,26 @@ static int klp_find_object_symbol(const char *objname, const char *name,
 		.count = 0,
 		.pos = sympos,
 	};
+	const char *lookup_name = name;
+#ifdef CONFIG_LTO_CLANG
+	char short_name[KSYM_NAME_LEN];
+
+	/*
+	 * With CONFIG_LTO_CLANG, the symbol name make have .llvm.<hash>
+	 * postfix, e.g. show_cpuinfo.llvm.12345.
+	 * Call kallsyms_on_each_match_symbol with short_name, e.g.
+	 * show_cpuinfo, args->name is still the full name, which is used
+	 * checked in klp_match_callback.
+	 */
+	strscpy(short_name, name, sizeof(short_name));
+	kallsyms_cleanup_symbol_name(short_name);
+	lookup_name = short_name;
+#endif
 
 	if (objname)
 		module_kallsyms_on_each_symbol(objname, klp_find_callback, &args);
 	else
-		kallsyms_on_each_match_symbol(klp_match_callback, name, &args);
+		kallsyms_on_each_match_symbol(klp_match_callback, lookup_name, &args);
 
 	/*
 	 * Ensure an address was found. If sympos is 0, ensure symbol is unique;
-- 
2.43.0


