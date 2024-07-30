Return-Path: <live-patching+bounces-419-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6F86B9402D4
	for <lists+live-patching@lfdr.de>; Tue, 30 Jul 2024 02:55:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 16E5B1F22879
	for <lists+live-patching@lfdr.de>; Tue, 30 Jul 2024 00:55:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EFE1B1373;
	Tue, 30 Jul 2024 00:55:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="L+n6hk3g"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5C98DDBC;
	Tue, 30 Jul 2024 00:55:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722300906; cv=none; b=DcxxH3NV3b0D8q69cSM4abaD+LsSXDVt+OrLKlNNWNwZNxtJ+8lmCU47MCozoB7VcWB5up2N1/vWrLebwLQV97nxAltznNUrc7Zwxb0NoLQqQ/Z165/nkz08k5MuT3TtUIyIoM3T8OJjoXlwN4P7Dd2zFglFsuhvwkchYZSuZaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722300906; c=relaxed/simple;
	bh=/OpeTm/YKTNnJ+pITyoC+SupkMdf0BnvgwwNZMCcjPI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uRYMid0GvCnfpqcfTv1OUr3cREf3D6xc+O97NRz7v6LTgtiWKNTfiZJ1N091CvRc5n0i8GJxYbcSp49mSx6PWh6zdAsNzGb+yLfVW5ZP6GiuriUjWMbDnyiFrZGvmMGEbOL1DAhBHsPdARApwu+Qw77RlpPE9D+hvfBVA5ZW5kw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=L+n6hk3g; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 758C6C4AF0B;
	Tue, 30 Jul 2024 00:55:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722300906;
	bh=/OpeTm/YKTNnJ+pITyoC+SupkMdf0BnvgwwNZMCcjPI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L+n6hk3g1+Idcaxk+ZF6oRozb9Fp2rVfjxAM+YIfKd+msio201ZUqdd8mcOw2rU2m
	 /Tcx6caiuE4EIcMsj173cPdzbE0ujdB+BM2ZIS14qmgfmIQrC/2TXt3MIm+u4JWWxJ
	 RkksQTSIGZWe86rNP5Rot6ds/zFeXtxD6oGVQvv6LA/8/GZu4KgPzjpm907Y7IT7sr
	 BORRX36pCwNvgzaSS0pYV+IU4EHuAPbR6UwnEvWL+0jHgGLG/MKzONTzShTQGZvodu
	 73Yu/5lyA6ifBL8gnSxlexvr8wrVQAFHHEpmA/oTcbdmltrJ5N7lnXyc04IvFQLXss
	 LR84+50UqzaCw==
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
Subject: [PATCH 3/3] tracing/kprobes: Use APIs that matches symbols with .llvm.<hash> suffix
Date: Mon, 29 Jul 2024 17:54:33 -0700
Message-ID: <20240730005433.3559731-4-song@kernel.org>
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

Use the new kallsyms APIs that matches symbols name with .llvm.<hash>
suffix. This allows userspace tools to get kprobes on the expected
function name, while the actual symbol has a .llvm.<hash> suffix.

This only effects kernel compared with CONFIG_LTO_CLANG.

Signed-off-by: Song Liu <song@kernel.org>
---
 kernel/trace/trace_kprobe.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index 61a6da808203..c319382c1a09 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -202,7 +202,8 @@ unsigned long trace_kprobe_address(struct trace_kprobe *tk)
 
 	if (tk->symbol) {
 		addr = (unsigned long)
-			kallsyms_lookup_name(trace_kprobe_symbol(tk));
+			kallsyms_lookup_name_or_prefix(trace_kprobe_symbol(tk));
+
 		if (addr)
 			addr += tk->rp.kp.offset;
 	} else {
@@ -766,8 +767,13 @@ static unsigned int number_of_same_symbols(const char *mod, const char *func_nam
 {
 	struct sym_count_ctx ctx = { .count = 0, .name = func_name };
 
-	if (!mod)
+	if (!mod) {
 		kallsyms_on_each_match_symbol(count_symbols, func_name, &ctx.count);
+		if (IS_ENABLED(CONFIG_LTO_CLANG) && !ctx.count) {
+			kallsyms_on_each_match_symbol_or_prefix(
+				count_symbols, func_name, &ctx.count);
+		}
+	}
 
 	module_kallsyms_on_each_symbol(mod, count_mod_symbols, &ctx);
 
-- 
2.43.0


