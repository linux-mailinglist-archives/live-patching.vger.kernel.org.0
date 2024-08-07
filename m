Return-Path: <live-patching+bounces-463-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E6A5C94B2B4
	for <lists+live-patching@lfdr.de>; Thu,  8 Aug 2024 00:06:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 14BFA1C213E9
	for <lists+live-patching@lfdr.de>; Wed,  7 Aug 2024 22:06:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE597155336;
	Wed,  7 Aug 2024 22:06:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="anquUQfp"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A20DF146599;
	Wed,  7 Aug 2024 22:06:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723068405; cv=none; b=CUiqDHP8nwW8oXQCPDH3dnO5dlZzNIzV8UoZlNsvs7wOOP/aKGmjJ9Q3WTOD3A2vKGW4iawllpIKkSk/vptbMgkZw6/vT8784FINcaA/FzxvakTGrlKmbrqJNmT+iRdpSZcpBUWD+45+KIpPgovrKdu3EAHp7zVMsIffuhZJRWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723068405; c=relaxed/simple;
	bh=mo5cCI52YxBS4frh3l+KA2nX1q9ZcrMkE2ErnP/Qf8A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PVQc+8cpWE1vexu5+9oNY6LKS1xOV50/MfoFgWJWYXZBZrHYzrIMZ0fjtm6VKfw8B0P9GXmVCgGPkXGWmfenJddB7ZGuLNlD+pZRtaiybT5iS3cdH3Q4WbXJetNO6VL1fegTnswaklpC19wM5DX/V3EhmFEW/aQ3iI41HHTsIWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=anquUQfp; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6E2DC32782;
	Wed,  7 Aug 2024 22:06:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723068405;
	bh=mo5cCI52YxBS4frh3l+KA2nX1q9ZcrMkE2ErnP/Qf8A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=anquUQfp0kf6tx02UCWUPtvNh6GCGXtww2I9YTVz824oDuszPrePU2Ji49Ubulszx
	 3tx66uabjRqSP0u4NFANSYV4WE2EoVVy7pLGr63IC+ZdnXygWavMvmcqgSygvwyCDp
	 so2pPGsXW0vEcBE0N6iEM+YXWPy38u+DcwqHJMikJhN1SsluzTSdITk+uXXtuylF4d
	 xHRv4mrtm7AfPSFwiMBpmNbWA75O7EqYlZR3TVhpcsL7cTKxlPkPwtce4KoEJciy0D
	 eExbV41HlFt7fA7JPJt1EOXYhMLTDXXquA9QxC6Dbfn4YX/goeTOwjmArqRU1K+zBQ
	 s7pNICnJ6h5Tg==
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
Subject: [PATCH v3 2/2] kallsyms: Match symbols exactly with CONFIG_LTO_CLANG
Date: Wed,  7 Aug 2024 15:05:13 -0700
Message-ID: <20240807220513.3100483-3-song@kernel.org>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20240807220513.3100483-1-song@kernel.org>
References: <20240807220513.3100483-1-song@kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

With CONFIG_LTO_CLANG=y, the compiler may add .llvm.<hash> suffix to
function names to avoid duplication. APIs like kallsyms_lookup_name()
and kallsyms_on_each_match_symbol() tries to match these symbol names
without the .llvm.<hash> suffix, e.g., match "c_stop" with symbol
c_stop.llvm.17132674095431275852. This turned out to be problematic
for use cases that require exact match, for example, livepatch.

Fix this by making the APIs to match symbols exactly.

Also cleanup kallsyms_selftests accordingly.

Signed-off-by: Song Liu <song@kernel.org>
---
 kernel/kallsyms.c          | 55 +++++---------------------------------
 kernel/kallsyms_selftest.c | 22 +--------------
 2 files changed, 7 insertions(+), 70 deletions(-)

diff --git a/kernel/kallsyms.c b/kernel/kallsyms.c
index fb2c77368d18..a9a0ca605d4a 100644
--- a/kernel/kallsyms.c
+++ b/kernel/kallsyms.c
@@ -160,38 +160,6 @@ unsigned long kallsyms_sym_address(int idx)
 	return kallsyms_relative_base - 1 - kallsyms_offsets[idx];
 }
 
-static void cleanup_symbol_name(char *s)
-{
-	char *res;
-
-	if (!IS_ENABLED(CONFIG_LTO_CLANG))
-		return;
-
-	/*
-	 * LLVM appends various suffixes for local functions and variables that
-	 * must be promoted to global scope as part of LTO.  This can break
-	 * hooking of static functions with kprobes. '.' is not a valid
-	 * character in an identifier in C. Suffixes only in LLVM LTO observed:
-	 * - foo.llvm.[0-9a-f]+
-	 */
-	res = strstr(s, ".llvm.");
-	if (res)
-		*res = '\0';
-
-	return;
-}
-
-static int compare_symbol_name(const char *name, char *namebuf)
-{
-	/* The kallsyms_seqs_of_names is sorted based on names after
-	 * cleanup_symbol_name() (see scripts/kallsyms.c) if clang lto is enabled.
-	 * To ensure correct bisection in kallsyms_lookup_names(), do
-	 * cleanup_symbol_name(namebuf) before comparing name and namebuf.
-	 */
-	cleanup_symbol_name(namebuf);
-	return strcmp(name, namebuf);
-}
-
 static unsigned int get_symbol_seq(int index)
 {
 	unsigned int i, seq = 0;
@@ -219,7 +187,7 @@ static int kallsyms_lookup_names(const char *name,
 		seq = get_symbol_seq(mid);
 		off = get_symbol_offset(seq);
 		kallsyms_expand_symbol(off, namebuf, ARRAY_SIZE(namebuf));
-		ret = compare_symbol_name(name, namebuf);
+		ret = strcmp(name, namebuf);
 		if (ret > 0)
 			low = mid + 1;
 		else if (ret < 0)
@@ -236,7 +204,7 @@ static int kallsyms_lookup_names(const char *name,
 		seq = get_symbol_seq(low - 1);
 		off = get_symbol_offset(seq);
 		kallsyms_expand_symbol(off, namebuf, ARRAY_SIZE(namebuf));
-		if (compare_symbol_name(name, namebuf))
+		if (strcmp(name, namebuf))
 			break;
 		low--;
 	}
@@ -248,7 +216,7 @@ static int kallsyms_lookup_names(const char *name,
 			seq = get_symbol_seq(high + 1);
 			off = get_symbol_offset(seq);
 			kallsyms_expand_symbol(off, namebuf, ARRAY_SIZE(namebuf));
-			if (compare_symbol_name(name, namebuf))
+			if (strcmp(name, namebuf))
 				break;
 			high++;
 		}
@@ -407,8 +375,7 @@ static int kallsyms_lookup_buildid(unsigned long addr,
 		if (modbuildid)
 			*modbuildid = NULL;
 
-		ret = strlen(namebuf);
-		goto found;
+		return strlen(namebuf);
 	}
 
 	/* See if it's in a module or a BPF JITed image. */
@@ -422,8 +389,6 @@ static int kallsyms_lookup_buildid(unsigned long addr,
 		ret = ftrace_mod_address_lookup(addr, symbolsize,
 						offset, modname, namebuf);
 
-found:
-	cleanup_symbol_name(namebuf);
 	return ret;
 }
 
@@ -450,8 +415,6 @@ const char *kallsyms_lookup(unsigned long addr,
 
 int lookup_symbol_name(unsigned long addr, char *symname)
 {
-	int res;
-
 	symname[0] = '\0';
 	symname[KSYM_NAME_LEN - 1] = '\0';
 
@@ -462,16 +425,10 @@ int lookup_symbol_name(unsigned long addr, char *symname)
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
2.43.5


