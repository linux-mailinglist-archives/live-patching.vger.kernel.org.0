Return-Path: <live-patching+bounces-435-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id BCD489464D8
	for <lists+live-patching@lfdr.de>; Fri,  2 Aug 2024 23:09:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6C0AF1F227C1
	for <lists+live-patching@lfdr.de>; Fri,  2 Aug 2024 21:09:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 953CB1339A2;
	Fri,  2 Aug 2024 21:09:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pnauKxwb"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 683B4132116;
	Fri,  2 Aug 2024 21:09:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722632951; cv=none; b=NYjXJI/UlafUmFuoDp3VRff4q++EO4TISGHlhMHXMnjrT0qJHQX9e1p4oxdsJihPm/QQAAOpKnQmVfIvLXT3mFvMfW9ARYBnrHXOz1w5k6uP1IW4hv1SfLClmUabYtGOUVTNAr4T/yj6pBZjpN1OT6DrLSKHJDPepmMmEHqs+6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722632951; c=relaxed/simple;
	bh=wSgBrkC0s9VfLt3cNhMld8TVeciJRDopmo/jk6FLqrA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FagvSkFaNJ5ZVjeGol8nQz1rRe00baeKRKjjDcIAa9bs+D8ym+ZZ94JUtjDydMxRXhHfg9+VgUOUasJg9XUMZ2+jju9CEKUOAwAXOvO1acwnxvtdimaEgzb8rvDbRuZT59j+bqq+D3dc2dCOfzJuwA7RDXvZasP9HoJQ21FK3JY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pnauKxwb; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCEAEC4AF0A;
	Fri,  2 Aug 2024 21:09:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722632951;
	bh=wSgBrkC0s9VfLt3cNhMld8TVeciJRDopmo/jk6FLqrA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pnauKxwbrdbBR+VxAYGejfu2s56HQwIyB0A837TBxAWpfGkY8Bl4ygKbjUpY/4n+b
	 tBEfjJFtLaqVJM9u0IuzifVtekyBQ7sFh1ketqs0TcEJuSSPsD2DtKM1i02qB0FhMH
	 TGFQ5RI3+qiFsyCduGBlOW12igwNpZnH98aIaJUz+aDXrvg4bTsqYpJZBEsyuYmXRt
	 B3pmwwAwTHKFKJoRCYuvrEdagZ8di6MpS3zoQ5ZNCXpPJ2CHCYXfV2AyS6/pOjy8ec
	 x+V8inj+xFHuDrWGANKJHRJfjpiu+nH029ixLD3Pc7e/MMtWX+aVk/ACjt97i7MqID
	 FrF7GO+P3WCTg==
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
Subject: [PATCH v2 3/3] tracing/kprobes: Use APIs that matches symbols without .XXX suffix
Date: Fri,  2 Aug 2024 14:08:35 -0700
Message-ID: <20240802210836.2210140-4-song@kernel.org>
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

Use the new kallsyms APIs that matches symbols name with .XXX
suffix. This allows userspace tools to get kprobes on the expected
function name, while the actual symbol has a .llvm.<hash> suffix.

This only effects kernel compile with CONFIG_LTO_CLANG.

Signed-off-by: Song Liu <song@kernel.org>
---
 kernel/kprobes.c            |  6 +++++-
 kernel/trace/trace_kprobe.c | 11 ++++++++++-
 2 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index e85de37d9e1e..99102283b076 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -70,7 +70,11 @@ static DEFINE_PER_CPU(struct kprobe *, kprobe_instance);
 kprobe_opcode_t * __weak kprobe_lookup_name(const char *name,
 					unsigned int __unused)
 {
-	return ((kprobe_opcode_t *)(kallsyms_lookup_name(name)));
+	unsigned long addr = kallsyms_lookup_name(name);
+
+	if (IS_ENABLED(CONFIG_LTO_CLANG) && !addr)
+		addr = kallsyms_lookup_name_without_suffix(name);
+	return ((kprobe_opcode_t *)(addr));
 }
 
 /*
diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index 61a6da808203..d2ad0c561c83 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -203,6 +203,10 @@ unsigned long trace_kprobe_address(struct trace_kprobe *tk)
 	if (tk->symbol) {
 		addr = (unsigned long)
 			kallsyms_lookup_name(trace_kprobe_symbol(tk));
+
+		if (IS_ENABLED(CONFIG_LTO_CLANG) && !addr)
+			addr = kallsyms_lookup_name_without_suffix(trace_kprobe_symbol(tk));
+
 		if (addr)
 			addr += tk->rp.kp.offset;
 	} else {
@@ -766,8 +770,13 @@ static unsigned int number_of_same_symbols(const char *mod, const char *func_nam
 {
 	struct sym_count_ctx ctx = { .count = 0, .name = func_name };
 
-	if (!mod)
+	if (!mod) {
 		kallsyms_on_each_match_symbol(count_symbols, func_name, &ctx.count);
+		if (IS_ENABLED(CONFIG_LTO_CLANG) && !ctx.count) {
+			kallsyms_on_each_match_symbol_without_suffix(
+				count_symbols, func_name, &ctx.count);
+		}
+	}
 
 	module_kallsyms_on_each_symbol(mod, count_mod_symbols, &ctx);
 
-- 
2.43.0


