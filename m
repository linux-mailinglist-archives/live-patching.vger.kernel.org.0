Return-Path: <live-patching+bounces-418-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B75409402D2
	for <lists+live-patching@lfdr.de>; Tue, 30 Jul 2024 02:55:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BE86A1C2133F
	for <lists+live-patching@lfdr.de>; Tue, 30 Jul 2024 00:55:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D0D5D33E8;
	Tue, 30 Jul 2024 00:54:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mWNO4laJ"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DD00C2C6;
	Tue, 30 Jul 2024 00:54:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722300899; cv=none; b=V5hoXLUSW5y9a0SM3zZne3OY0OcIuDaDPkbjZc93tguvQr+8iPAmUG1bzzWa0IzWtZaWHN4on1h1PVdlpjHzUzX9/GePmwJXkvrjTDnIynNwPyUHIJk/7DHP+k34Ha3FIpgMEyzirqJarxBDPgsdGGsi2hXPCi998ceZXYwZj4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722300899; c=relaxed/simple;
	bh=bVMhb29bKic+8kXfwnvb7g3zkaGOGr5ivu5L90mSt5s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mkPEh6sHIndv9SEy81C4dA+7+2ue16K/q1ntS+1DU78ZjugaXbATBr1Fb3Ddg57q3rzw8ZPkm58at9KrgixaSyygyPd+fcxsr7UiLZ+f+708G/tMjAs1EvDcfiL69oYgpejN58Qk8Of7YfQtO4JAJ+jSwrVzq+EkjbcB80xQbzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mWNO4laJ; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BCE2C32786;
	Tue, 30 Jul 2024 00:54:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722300899;
	bh=bVMhb29bKic+8kXfwnvb7g3zkaGOGr5ivu5L90mSt5s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mWNO4laJlL513lNwUaEH2u81ihF+9FlWZbHk3tAtEau4/BYLMu0AZQiM7hSKy2I15
	 o3B0Z8LVawdEaIMKh8NAYxPKS8QjbrrtJ9hcW2ow/Uo/I+w/m/vHBP/T6Qg0xLuzlG
	 4I9owC4pBoCOJOu3poii+yWNE21Av1kR6woqfDh6ms1Mei5jl8mV1CWYCm8vT7Hctz
	 miqo+/YpGOP9vfrO7CNYWlbrlJ8SQNYweu8mmp1w8smdDxfiK/7LBv8fUpXKko5O6S
	 s25OKJ4FBAWZD0XrLHTwWPu7c+CpGJdw3DGPA8nIi0XTnD0o4/rtVgSqk8vrdFaj40
	 Ci6lBkqN3vMMw==
From: Song Liu <song@kernel.org>
To: live-patching@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org
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
	song@kernel.org,
	mmaurer@google.com,
	samitolvanen@google.com,
	mhiramat@kernel.org,
	rostedt@goodmis.org
Subject: [PATCH 2/3] kallsyms: Add APIs to match symbol without .llmv.<hash> suffix.
Date: Mon, 29 Jul 2024 17:54:32 -0700
Message-ID: <20240730005433.3559731-3-song@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240730005433.3559731-1-song@kernel.org>
References: <20240730005433.3559731-1-song@kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

With CONFIG_LTO_CLANG=y, the compiler may add suffix to function names
to avoid duplication. This causes confusion with users of kallsyms.
On one hand, users like livepatch are required to match the symbols
exactly. On the other hand, users like kprobe would like to match to
original function names.

Solve this by splitting kallsyms APIs. Specifically, existing APIs now
should match the symbols exactly. Add two APIs that matches the full
symbol, or only the part without .llvm.suffix. Specifically, the following
two APIs are added:

1. kallsyms_lookup_name_or_prefix()
2. kallsyms_on_each_match_symbol_or_prefix()

These APIs will be used by kprobe.

Also cleanup some code and adjust kallsyms_selftests accordingly.

Signed-off-by: Song Liu <song@kernel.org>
---
 include/linux/kallsyms.h   | 14 +++++++
 kernel/kallsyms.c          | 83 ++++++++++++++++++++++++++------------
 kernel/kallsyms_selftest.c | 22 +---------
 3 files changed, 73 insertions(+), 46 deletions(-)

diff --git a/include/linux/kallsyms.h b/include/linux/kallsyms.h
index c3f075e8f60c..09b2d2099107 100644
--- a/include/linux/kallsyms.h
+++ b/include/linux/kallsyms.h
@@ -74,9 +74,12 @@ int kallsyms_on_each_symbol(int (*fn)(void *, const char *, unsigned long),
 			    void *data);
 int kallsyms_on_each_match_symbol(int (*fn)(void *, unsigned long),
 				  const char *name, void *data);
+int kallsyms_on_each_match_symbol_or_prefix(int (*fn)(void *, unsigned long),
+					    const char *name, void *data);
 
 /* Lookup the address for a symbol. Returns 0 if not found. */
 unsigned long kallsyms_lookup_name(const char *name);
+unsigned long kallsyms_lookup_name_or_prefix(const char *name);
 
 extern int kallsyms_lookup_size_offset(unsigned long addr,
 				  unsigned long *symbolsize,
@@ -104,6 +107,11 @@ static inline unsigned long kallsyms_lookup_name(const char *name)
 	return 0;
 }
 
+static inline unsigned long kallsyms_lookup_name_or_prefix(const char *name)
+{
+	return 0;
+}
+
 static inline int kallsyms_lookup_size_offset(unsigned long addr,
 					      unsigned long *symbolsize,
 					      unsigned long *offset)
@@ -165,6 +173,12 @@ static inline int kallsyms_on_each_match_symbol(int (*fn)(void *, unsigned long)
 {
 	return -EOPNOTSUPP;
 }
+
+static inline int kallsyms_on_each_match_symbol_or_prefix(int (*fn)(void *, unsigned long),
+							  const char *name, void *data)
+{
+	return -EOPNOTSUPP;
+}
 #endif /*CONFIG_KALLSYMS*/
 
 static inline void print_ip_sym(const char *loglvl, unsigned long ip)
diff --git a/kernel/kallsyms.c b/kernel/kallsyms.c
index fb2c77368d18..4285dd85d814 100644
--- a/kernel/kallsyms.c
+++ b/kernel/kallsyms.c
@@ -164,9 +164,6 @@ static void cleanup_symbol_name(char *s)
 {
 	char *res;
 
-	if (!IS_ENABLED(CONFIG_LTO_CLANG))
-		return;
-
 	/*
 	 * LLVM appends various suffixes for local functions and variables that
 	 * must be promoted to global scope as part of LTO.  This can break
@@ -181,13 +178,13 @@ static void cleanup_symbol_name(char *s)
 	return;
 }
 
-static int compare_symbol_name(const char *name, char *namebuf)
+static int compare_symbol_name(const char *name, char *namebuf, bool exact_match)
 {
-	/* The kallsyms_seqs_of_names is sorted based on names after
-	 * cleanup_symbol_name() (see scripts/kallsyms.c) if clang lto is enabled.
-	 * To ensure correct bisection in kallsyms_lookup_names(), do
-	 * cleanup_symbol_name(namebuf) before comparing name and namebuf.
-	 */
+	int ret = strcmp(name, namebuf);
+
+	if (exact_match || !ret)
+		return ret;
+
 	cleanup_symbol_name(namebuf);
 	return strcmp(name, namebuf);
 }
@@ -204,13 +201,17 @@ static unsigned int get_symbol_seq(int index)
 
 static int kallsyms_lookup_names(const char *name,
 				 unsigned int *start,
-				 unsigned int *end)
+				 unsigned int *end,
+				 bool exact_match)
 {
 	int ret;
 	int low, mid, high;
 	unsigned int seq, off;
 	char namebuf[KSYM_NAME_LEN];
 
+	if (!IS_ENABLED(CONFIG_LTO_CLANG))
+		exact_match = true;
+
 	low = 0;
 	high = kallsyms_num_syms - 1;
 
@@ -219,7 +220,7 @@ static int kallsyms_lookup_names(const char *name,
 		seq = get_symbol_seq(mid);
 		off = get_symbol_offset(seq);
 		kallsyms_expand_symbol(off, namebuf, ARRAY_SIZE(namebuf));
-		ret = compare_symbol_name(name, namebuf);
+		ret = compare_symbol_name(name, namebuf, exact_match);
 		if (ret > 0)
 			low = mid + 1;
 		else if (ret < 0)
@@ -236,7 +237,7 @@ static int kallsyms_lookup_names(const char *name,
 		seq = get_symbol_seq(low - 1);
 		off = get_symbol_offset(seq);
 		kallsyms_expand_symbol(off, namebuf, ARRAY_SIZE(namebuf));
-		if (compare_symbol_name(name, namebuf))
+		if (compare_symbol_name(name, namebuf, exact_match))
 			break;
 		low--;
 	}
@@ -248,7 +249,7 @@ static int kallsyms_lookup_names(const char *name,
 			seq = get_symbol_seq(high + 1);
 			off = get_symbol_offset(seq);
 			kallsyms_expand_symbol(off, namebuf, ARRAY_SIZE(namebuf));
-			if (compare_symbol_name(name, namebuf))
+			if (compare_symbol_name(name, namebuf, exact_match))
 				break;
 			high++;
 		}
@@ -268,13 +269,35 @@ unsigned long kallsyms_lookup_name(const char *name)
 	if (!*name)
 		return 0;
 
-	ret = kallsyms_lookup_names(name, &i, NULL);
+	ret = kallsyms_lookup_names(name, &i, NULL, true);
 	if (!ret)
 		return kallsyms_sym_address(get_symbol_seq(i));
 
 	return module_kallsyms_lookup_name(name);
 }
 
+/*
+ * Lookup the address for this symbol.
+ *
+ * With CONFIG_LTO_CLANG=y, if there is no exact match, also try lookup
+ * symbol.llvm.<hash>.
+ */
+unsigned long kallsyms_lookup_name_or_prefix(const char *name)
+{
+	unsigned long addr;
+
+	addr = kallsyms_lookup_name(name);
+
+	if (!addr && IS_ENABLED(CONFIG_LTO_CLANG)) {
+		int ret, i;
+
+		ret = kallsyms_lookup_names(name, &i, NULL, false);
+		if (!ret)
+			addr = kallsyms_sym_address(get_symbol_seq(i));
+	}
+	return addr;
+}
+
 /*
  * Iterate over all symbols in vmlinux.  For symbols from modules use
  * module_kallsyms_on_each_symbol instead.
@@ -303,7 +326,25 @@ int kallsyms_on_each_match_symbol(int (*fn)(void *, unsigned long),
 	int ret;
 	unsigned int i, start, end;
 
-	ret = kallsyms_lookup_names(name, &start, &end);
+	ret = kallsyms_lookup_names(name, &start, &end, true);
+	if (ret)
+		return 0;
+
+	for (i = start; !ret && i <= end; i++) {
+		ret = fn(data, kallsyms_sym_address(get_symbol_seq(i)));
+		cond_resched();
+	}
+
+	return ret;
+}
+
+int kallsyms_on_each_match_symbol_or_prefix(int (*fn)(void *, unsigned long),
+					    const char *name, void *data)
+{
+	int ret;
+	unsigned int i, start, end;
+
+	ret = kallsyms_lookup_names(name, &start, &end, false);
 	if (ret)
 		return 0;
 
@@ -450,8 +491,6 @@ const char *kallsyms_lookup(unsigned long addr,
 
 int lookup_symbol_name(unsigned long addr, char *symname)
 {
-	int res;
-
 	symname[0] = '\0';
 	symname[KSYM_NAME_LEN - 1] = '\0';
 
@@ -462,16 +501,10 @@ int lookup_symbol_name(unsigned long addr, char *symname)
 		/* Grab name */
 		kallsyms_expand_symbol(get_symbol_offset(pos),
 				       symname, KSYM_NAME_LEN);
-		goto found;
+		return 0;
 	}
 	/* See if it's in a module. */
-	res = lookup_module_symbol_name(addr, symname);
-	if (res)
-		return res;
-
-found:
-	cleanup_symbol_name(symname);
-	return 0;
+	return lookup_module_symbol_name(addr, symname);
 }
 
 /* Look up a kernel symbol and return it in a text buffer. */
diff --git a/kernel/kallsyms_selftest.c b/kernel/kallsyms_selftest.c
index 2f84896a7bcb..873f7c445488 100644
--- a/kernel/kallsyms_selftest.c
+++ b/kernel/kallsyms_selftest.c
@@ -187,31 +187,11 @@ static void test_perf_kallsyms_lookup_name(void)
 		stat.min, stat.max, div_u64(stat.sum, stat.real_cnt));
 }
 
-static bool match_cleanup_name(const char *s, const char *name)
-{
-	char *p;
-	int len;
-
-	if (!IS_ENABLED(CONFIG_LTO_CLANG))
-		return false;
-
-	p = strstr(s, ".llvm.");
-	if (!p)
-		return false;
-
-	len = strlen(name);
-	if (p - s != len)
-		return false;
-
-	return !strncmp(s, name, len);
-}
-
 static int find_symbol(void *data, const char *name, unsigned long addr)
 {
 	struct test_stat *stat = (struct test_stat *)data;
 
-	if (strcmp(name, stat->name) == 0 ||
-	    (!stat->perf && match_cleanup_name(name, stat->name))) {
+	if (!strcmp(name, stat->name)) {
 		stat->real_cnt++;
 		stat->addr = addr;
 
-- 
2.43.0


