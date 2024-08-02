Return-Path: <live-patching+bounces-434-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2E9849464D4
	for <lists+live-patching@lfdr.de>; Fri,  2 Aug 2024 23:09:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 518021C21886
	for <lists+live-patching@lfdr.de>; Fri,  2 Aug 2024 21:09:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D85577764E;
	Fri,  2 Aug 2024 21:09:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iXyuW2hA"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC2F174BED;
	Fri,  2 Aug 2024 21:09:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722632943; cv=none; b=QFInGaLJbxIX3zksbLhCkPmSw1MQwJ0J2CiRyOE9pr5ukI/ffc8FCPc5REcygteBcrTuwEjFMaLSzbhM+G5cWL8rr+vN7/Est5woLeZfVGM0W7aXvCURP2YJUZgmN7yukdH5E9uDK8RdmVI39kOEUcWWEGsXdoI3b620teTrCxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722632943; c=relaxed/simple;
	bh=mPOYboxDlB+DBh4vNdMxSRk3eUhDf8x+e+4dj7v+24o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Aiu6BmzzV+380ckCS/uq5GErh9u4CbBlp6gpLdpOHv5kHVStCEO2gz0K2bWtx7fe9Lrw9/ZAS9+3uNG+4zVnarHLoD5VYpMTbnGsebjE4mYrEG2uDSjZVm2OiKAnc8VWJ9Yqy6f/Rx/MRUZG3rNK2oQvpbh3+59UNMJXI6byLXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iXyuW2hA; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56390C32782;
	Fri,  2 Aug 2024 21:09:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722632943;
	bh=mPOYboxDlB+DBh4vNdMxSRk3eUhDf8x+e+4dj7v+24o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iXyuW2hAXSCTQiEzJGj6lNASsTGFAbbJBsbc6lOMrRQyRdrUfpPghy6D2CC4K863C
	 WB30HQIeKFEnvCh8QjTpGsHUsaJd+x1xEEYZXuB2Gkk/UnDFUpFgl3X5cvJxxQ9Vit
	 euhDjMaIRWcJhMR3AvLvFH7ajN+4EByDh2Kqqe4V+fziwJICt9duOSOed6vfG7xUpM
	 XvkIfzH2pKCmAPUvq0YdHQ/k/3H+BZFWfj2eDo2m2pAtv3GzJWzRFrJcd67n+E1/qr
	 DPjQVCy9EEwY30NAa+lwU9NBkF22lInHDf2qOR28+7HkyOarpAG/z3O1Ws2u3Z8etk
	 L/JSrFPP2OgWg==
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
Subject: [PATCH v2 2/3] kallsyms: Add APIs to match symbol without .XXXX suffix.
Date: Fri,  2 Aug 2024 14:08:34 -0700
Message-ID: <20240802210836.2210140-3-song@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240802210836.2210140-1-song@kernel.org>
References: <20240802210836.2210140-1-song@kernel.org>
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
should match the symbols exactly. Add two APIs that match only the part
without .XXXX suffix. Specifically, the following two APIs are added.

1. kallsyms_lookup_name_without_suffix()
2. kallsyms_on_each_match_symbol_without_suffix()

These APIs will be used by kprobe.

Also cleanup some code and update kallsyms_selftests accordingly.

Signed-off-by: Song Liu <song@kernel.org>
---
 include/linux/kallsyms.h   | 14 ++++++
 kernel/kallsyms.c          | 88 ++++++++++++++++++++++++++------------
 kernel/kallsyms_selftest.c | 75 +++++++++++++++++++++++---------
 3 files changed, 128 insertions(+), 49 deletions(-)

diff --git a/include/linux/kallsyms.h b/include/linux/kallsyms.h
index c3f075e8f60c..9ef2a944a993 100644
--- a/include/linux/kallsyms.h
+++ b/include/linux/kallsyms.h
@@ -74,9 +74,12 @@ int kallsyms_on_each_symbol(int (*fn)(void *, const char *, unsigned long),
 			    void *data);
 int kallsyms_on_each_match_symbol(int (*fn)(void *, unsigned long),
 				  const char *name, void *data);
+int kallsyms_on_each_match_symbol_without_suffix(int (*fn)(void *, unsigned long),
+						 const char *name, void *data);
 
 /* Lookup the address for a symbol. Returns 0 if not found. */
 unsigned long kallsyms_lookup_name(const char *name);
+unsigned long kallsyms_lookup_name_without_suffix(const char *name);
 
 extern int kallsyms_lookup_size_offset(unsigned long addr,
 				  unsigned long *symbolsize,
@@ -104,6 +107,11 @@ static inline unsigned long kallsyms_lookup_name(const char *name)
 	return 0;
 }
 
+static inline unsigned long kallsyms_lookup_name_without_suffix(const char *name)
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
+static inline int kallsyms_on_each_match_symbol_without_suffix(int (*fn)(void *, unsigned long),
+							       const char *name, void *data)
+{
+	return -EOPNOTSUPP;
+}
 #endif /*CONFIG_KALLSYMS*/
 
 static inline void print_ip_sym(const char *loglvl, unsigned long ip)
diff --git a/kernel/kallsyms.c b/kernel/kallsyms.c
index fb2c77368d18..64fdff6cde85 100644
--- a/kernel/kallsyms.c
+++ b/kernel/kallsyms.c
@@ -164,30 +164,27 @@ static void cleanup_symbol_name(char *s)
 {
 	char *res;
 
-	if (!IS_ENABLED(CONFIG_LTO_CLANG))
-		return;
-
 	/*
 	 * LLVM appends various suffixes for local functions and variables that
 	 * must be promoted to global scope as part of LTO.  This can break
 	 * hooking of static functions with kprobes. '.' is not a valid
-	 * character in an identifier in C. Suffixes only in LLVM LTO observed:
-	 * - foo.llvm.[0-9a-f]+
+	 * character in an identifier in C, so we can just remove the
+	 * suffix.
 	 */
-	res = strstr(s, ".llvm.");
+	res = strstr(s, ".");
 	if (res)
 		*res = '\0';
 
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
@@ -268,7 +269,28 @@ unsigned long kallsyms_lookup_name(const char *name)
 	if (!*name)
 		return 0;
 
-	ret = kallsyms_lookup_names(name, &i, NULL);
+	ret = kallsyms_lookup_names(name, &i, NULL, true);
+	if (!ret)
+		return kallsyms_sym_address(get_symbol_seq(i));
+
+	return module_kallsyms_lookup_name(name);
+}
+
+/*
+ * Lookup the address for this symbol.
+ * Remove .XXX suffix from the symbole before comparing against
+ * the name to lookup.
+ */
+unsigned long kallsyms_lookup_name_without_suffix(const char *name)
+{
+	int ret;
+	unsigned int i;
+
+	/* Skip the search for empty string. */
+	if (!*name)
+		return 0;
+
+	ret = kallsyms_lookup_names(name, &i, NULL, false);
 	if (!ret)
 		return kallsyms_sym_address(get_symbol_seq(i));
 
@@ -303,7 +325,25 @@ int kallsyms_on_each_match_symbol(int (*fn)(void *, unsigned long),
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
+int kallsyms_on_each_match_symbol_without_suffix(int (*fn)(void *, unsigned long),
+						 const char *name, void *data)
+{
+	int ret;
+	unsigned int i, start, end;
+
+	ret = kallsyms_lookup_names(name, &start, &end, false);
 	if (ret)
 		return 0;
 
@@ -450,8 +490,6 @@ const char *kallsyms_lookup(unsigned long addr,
 
 int lookup_symbol_name(unsigned long addr, char *symname)
 {
-	int res;
-
 	symname[0] = '\0';
 	symname[KSYM_NAME_LEN - 1] = '\0';
 
@@ -462,16 +500,10 @@ int lookup_symbol_name(unsigned long addr, char *symname)
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
index 2f84896a7bcb..929270f4ed55 100644
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
 
@@ -327,12 +307,28 @@ static int test_kallsyms_basic_function(void)
 		}
 	}
 
+	prefix = "kallsyms_on_each_match_symbol() for";
+	for (i = 0; i < ARRAY_SIZE(test_items); i++) {
+		memset(stat, 0, sizeof(*stat));
+		stat->max = INT_MAX;
+		stat->name = test_items[i].name;
+		kallsyms_on_each_match_symbol(match_symbol, test_items[i].name, stat);
+		if (stat->addr != test_items[i].addr || stat->real_cnt != 1) {
+			nr_failed++;
+			pr_info("%s %s failed: count=%d, addr=%lx, expect %lx\n",
+				prefix, test_items[i].name,
+				stat->real_cnt, stat->addr, test_items[i].addr);
+		}
+	}
+
 	if (nr_failed) {
 		kfree(stat);
 		return -ESRCH;
 	}
 
 	for (i = 0; i < kallsyms_num_syms; i++) {
+		char *p;
+
 		addr = kallsyms_sym_address(i);
 		if (!is_ksym_addr(addr))
 			continue;
@@ -415,6 +411,43 @@ static int test_kallsyms_basic_function(void)
 				goto failed;
 			}
 		}
+
+		if (IS_ENABLED(CONFIG_LTO_CLANG))
+			continue;
+
+		p = strstr(namebuf, ".");
+
+		/*
+		 * If the symbol contains a "." and it not started with
+		 * ".", test the no suffix lookup.
+		 */
+		if (!p || namebuf[0] != '.')
+			continue;
+
+		*p = '\0';
+
+		/*
+		 * kallsyms_lookup_name_without_suffix should return a
+		 * value, but it may not match the address of this symbol,
+		 * as the name without suffix may not be unique.
+		 */
+		addr = kallsyms_lookup_name_without_suffix(namebuf);
+		if (!addr) {
+			pr_info("%s: kallsyms_lookup_name_without_suffix cannot find the symbol\n",
+				namebuf);
+			goto failed;
+		}
+
+		memset(stat, 0, sizeof(*stat));
+		stat->max = INT_MAX;
+		stat->name = namebuf;
+		kallsyms_on_each_match_symbol_without_suffix(
+			match_symbol, namebuf, stat);
+		if (!stat->real_cnt) {
+			pr_info("%s: kallsyms_on_each_match_symbol_without_suffix cannot find the symbol\n",
+				namebuf);
+			goto failed;
+		}
 	}
 
 	kfree(stat);
-- 
2.43.0


