Return-Path: <live-patching+bounces-462-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B97C94B2B2
	for <lists+live-patching@lfdr.de>; Thu,  8 Aug 2024 00:06:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 484DA1F220C7
	for <lists+live-patching@lfdr.de>; Wed,  7 Aug 2024 22:06:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 520FF14EC5D;
	Wed,  7 Aug 2024 22:06:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f6DEQAIo"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D5AB146599;
	Wed,  7 Aug 2024 22:06:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723068399; cv=none; b=eoADpEakWSjnHy3E7f0TDhABKj/5OYuMrBOhOr92EVl71n5UCCMwUvyE0DhOqaXscPE9U7ljqgF0T9dbqa2WfSGl5klbL/SAYCzJewJh+qyVaQFyhpQeHLKXeG/6vrkIRO2BmefbEOE12EXQLjx8MTyC60yxc+K+YjDviOwl7A0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723068399; c=relaxed/simple;
	bh=C15tDhSI3QPR1JBSkACmGrTRgJ4aWChur1EUXRjeLko=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gUj8QmapOyDtBijYyPkiAmaCTSQuPAVS4dBZV05VD++EQRLtOoBpiyE4MqHvDdXu3N7/9DtTzSTgAaFCuCUOPuVmna/CKqiJYK3e9YOUIHMeANkPKZSf5EX+3QY6+5jdqhUt6Bk7PappbW+GBo/vvjDynheHmfC0mXrKqS0oEZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=f6DEQAIo; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19766C32781;
	Wed,  7 Aug 2024 22:06:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723068398;
	bh=C15tDhSI3QPR1JBSkACmGrTRgJ4aWChur1EUXRjeLko=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f6DEQAIopy7kBA+7Gvmq1h4s5zsyP1FlsCEdOZYAdas2ba+PRSpUcRuDHl8gOKTfS
	 naKxtCgAcq4dR54MA6XEvIsdqSR7nNQGhAI62bQnd6rNE/t1T+ScqdFWPejVxy+4vE
	 QWbTkbeXIcQdIWYB1Bz83JgcfpyHruq2vTu2XGBJ1nxsWyM1at2nJYnHQW1HnkVPSb
	 8hXS9I8Mu0ZQ9mj0SJYzB7wtya8N/CI1dW/pJTqbEwgt/Wq+mez/ZzSo9mo48bGAcm
	 PQxm/pNsNeJROGQzdyIJwDQNPt0sR0Btu+/ermcQnO4BCgHq7yTic0wO6cUG4Or7Y8
	 QiC4e0yXn4M8A==
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
Subject: [PATCH v3 1/2] kallsyms: Do not cleanup .llvm.<hash> suffix before sorting symbols
Date: Wed,  7 Aug 2024 15:05:12 -0700
Message-ID: <20240807220513.3100483-2-song@kernel.org>
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

Cleaning up the symbols causes various issues afterwards. Let's sort
the list based on original name.

Signed-off-by: Song Liu <song@kernel.org>
---
 scripts/kallsyms.c      | 31 ++-----------------------------
 scripts/link-vmlinux.sh |  4 ----
 2 files changed, 2 insertions(+), 33 deletions(-)

diff --git a/scripts/kallsyms.c b/scripts/kallsyms.c
index 0ed873491bf5..123dab0572f8 100644
--- a/scripts/kallsyms.c
+++ b/scripts/kallsyms.c
@@ -5,8 +5,7 @@
  * This software may be used and distributed according to the terms
  * of the GNU General Public License, incorporated herein by reference.
  *
- * Usage: kallsyms [--all-symbols] [--absolute-percpu]
- *                         [--lto-clang] in.map > out.S
+ * Usage: kallsyms [--all-symbols] [--absolute-percpu]  in.map > out.S
  *
  *      Table compression uses all the unused char codes on the symbols and
  *  maps these to the most used substrings (tokens). For instance, it might
@@ -62,7 +61,6 @@ static struct sym_entry **table;
 static unsigned int table_size, table_cnt;
 static int all_symbols;
 static int absolute_percpu;
-static int lto_clang;
 
 static int token_profit[0x10000];
 
@@ -73,8 +71,7 @@ static unsigned char best_table_len[256];
 
 static void usage(void)
 {
-	fprintf(stderr, "Usage: kallsyms [--all-symbols] [--absolute-percpu] "
-			"[--lto-clang] in.map > out.S\n");
+	fprintf(stderr, "Usage: kallsyms [--all-symbols] [--absolute-percpu] in.map > out.S\n");
 	exit(1);
 }
 
@@ -344,25 +341,6 @@ static bool symbol_absolute(const struct sym_entry *s)
 	return s->percpu_absolute;
 }
 
-static void cleanup_symbol_name(char *s)
-{
-	char *p;
-
-	/*
-	 * ASCII[.]   = 2e
-	 * ASCII[0-9] = 30,39
-	 * ASCII[A-Z] = 41,5a
-	 * ASCII[_]   = 5f
-	 * ASCII[a-z] = 61,7a
-	 *
-	 * As above, replacing the first '.' in ".llvm." with '\0' does not
-	 * affect the main sorting, but it helps us with subsorting.
-	 */
-	p = strstr(s, ".llvm.");
-	if (p)
-		*p = '\0';
-}
-
 static int compare_names(const void *a, const void *b)
 {
 	int ret;
@@ -526,10 +504,6 @@ static void write_src(void)
 	output_address(relative_base);
 	printf("\n");
 
-	if (lto_clang)
-		for (i = 0; i < table_cnt; i++)
-			cleanup_symbol_name((char *)table[i]->sym);
-
 	sort_symbols_by_name();
 	output_label("kallsyms_seqs_of_names");
 	for (i = 0; i < table_cnt; i++)
@@ -807,7 +781,6 @@ int main(int argc, char **argv)
 		static const struct option long_options[] = {
 			{"all-symbols",     no_argument, &all_symbols,     1},
 			{"absolute-percpu", no_argument, &absolute_percpu, 1},
-			{"lto-clang",       no_argument, &lto_clang,       1},
 			{},
 		};
 
diff --git a/scripts/link-vmlinux.sh b/scripts/link-vmlinux.sh
index f7b2503cdba9..22d0bc843986 100755
--- a/scripts/link-vmlinux.sh
+++ b/scripts/link-vmlinux.sh
@@ -156,10 +156,6 @@ kallsyms()
 		kallsymopt="${kallsymopt} --absolute-percpu"
 	fi
 
-	if is_enabled CONFIG_LTO_CLANG; then
-		kallsymopt="${kallsymopt} --lto-clang"
-	fi
-
 	info KSYMS "${2}.S"
 	scripts/kallsyms ${kallsymopt} "${1}" > "${2}.S"
 
-- 
2.43.5


