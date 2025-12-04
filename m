Return-Path: <live-patching+bounces-1896-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 8424ACA2424
	for <lists+live-patching@lfdr.de>; Thu, 04 Dec 2025 04:32:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id BAF023005681
	for <lists+live-patching@lfdr.de>; Thu,  4 Dec 2025 03:32:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0DC77314A75;
	Thu,  4 Dec 2025 03:32:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RI+eAnMb"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6F583128C2;
	Thu,  4 Dec 2025 03:32:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764819152; cv=none; b=E9lcY8MCr0k8HmSkwk2VfXzKalttfVj4JS/rTKC0K/AmymoVpOV9wF7OEiIo9IxKU3jAAX4b5UqRNCpULrmmbkAQb1rKcLMD2ZFt0GRYkojGTvCq7iqboNy/OUM7ebQt5ZCOr6GR5uize0nhoD/kW8+MiKOjdx0EFRodPxtzQsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764819152; c=relaxed/simple;
	bh=SLkkaavShBRgwwTQr3WXw+gnG4olkqmXKxVcZJeylvE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZanNDaCYAOTm5hhdrfhq4zWeT6TcZQLddRIjPeS0cKEUsyHadekCGSiVcsBavHAzjzkFRF2T3AQn7j4hRcMR/tQu99hhGYSiGz0NKjp1IGxglBGxEEAFgkoI9ptF1yRDG2vN/97PMtGzuorYbTVQV6TA2IXnLkGb2wJwDiTonJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RI+eAnMb; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3C71C113D0;
	Thu,  4 Dec 2025 03:32:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764819151;
	bh=SLkkaavShBRgwwTQr3WXw+gnG4olkqmXKxVcZJeylvE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RI+eAnMbOeXV9VrXuF3NkNTkzWCN/0C4+soag4VjRI5Te1tyvZAecMTY+8bm7hOkO
	 xVrIVqOsuX/BrOO459dWLkPLHPOtgAutn2wdTfpFmZsGCsWyoY7O3Rs19pcjw3tsgJ
	 7Q3uXIXGlYoFV+BvYF0Zl96gsh2LY+DJFImm0q36R4P1ENcLsLRs4dW3j8w0ptWPZd
	 T3X7f64JXXWJ9DSpSxgtrEPKZtiEFczmQzC011SR56S7lajemmJgZJFL+len/swjKA
	 wPwUMDgdSautHGcVTSaMoWnSV2JIvDLwJgSAZfeRyZ7BF964gTtTintsTw09sfbjty
	 wSryD3QjQ+NZw==
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org,
	live-patching@vger.kernel.org,
	bpf@vger.kernel.org,
	Andrey Grodzovsky <andrey.grodzovsky@crowdstrike.com>,
	Petr Mladek <pmladek@suse.com>,
	Song Liu <song@kernel.org>,
	Raja Khan <raja.khan@crowdstrike.com>,
	Miroslav Benes <mbenes@suse.cz>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Andrii Nakryiko <andrii@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH v2 2/2] x86/unwind/orc: Support reliable unwinding through BPF stack frames
Date: Wed,  3 Dec 2025 19:32:16 -0800
Message-ID: <a18505975662328c8ffb1090dded890c6f8c1004.1764818927.git.jpoimboe@kernel.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <cover.1764818927.git.jpoimboe@kernel.org>
References: <cover.1764818927.git.jpoimboe@kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

BPF JIT programs and trampolines use a frame pointer, so the current ORC
unwinder strategy of falling back to frame pointers (when an ORC entry
is missing) usually works in practice when unwinding through BPF JIT
stack frames.

However, that frame pointer fallback is just a guess, so the unwind gets
marked unreliable for live patching, which can cause livepatch
transition stalls.

Make the common case reliable by calling the bpf_has_frame_pointer()
helper to detect the valid frame pointer region of BPF JIT programs and
trampolines.

Fixes: ee9f8fce9964 ("x86/unwind: Add the ORC unwinder")
Reported-by: Andrey Grodzovsky <andrey.grodzovsky@crowdstrike.com>
Closes: https://lore.kernel.org/0e555733-c670-4e84-b2e6-abb8b84ade38@crowdstrike.com
Acked-by: Song Liu <song@kernel.org>
Acked-and-tested-by: Andrey Grodzovsky<andrey.grodzovsky@crowdstrike.com>
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 arch/x86/kernel/unwind_orc.c | 39 +++++++++++++++++++++++++-----------
 1 file changed, 27 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kernel/unwind_orc.c b/arch/x86/kernel/unwind_orc.c
index 977ee75e047c..f610fde2d5c4 100644
--- a/arch/x86/kernel/unwind_orc.c
+++ b/arch/x86/kernel/unwind_orc.c
@@ -2,6 +2,7 @@
 #include <linux/objtool.h>
 #include <linux/module.h>
 #include <linux/sort.h>
+#include <linux/bpf.h>
 #include <asm/ptrace.h>
 #include <asm/stacktrace.h>
 #include <asm/unwind.h>
@@ -172,6 +173,25 @@ static struct orc_entry *orc_ftrace_find(unsigned long ip)
 }
 #endif
 
+/* Fake frame pointer entry -- used as a fallback for generated code */
+static struct orc_entry orc_fp_entry = {
+	.type		= ORC_TYPE_CALL,
+	.sp_reg		= ORC_REG_BP,
+	.sp_offset	= 16,
+	.bp_reg		= ORC_REG_PREV_SP,
+	.bp_offset	= -16,
+};
+
+static struct orc_entry *orc_bpf_find(unsigned long ip)
+{
+#ifdef CONFIG_BPF_JIT
+	if (bpf_has_frame_pointer(ip))
+		return &orc_fp_entry;
+#endif
+
+	return NULL;
+}
+
 /*
  * If we crash with IP==0, the last successfully executed instruction
  * was probably an indirect function call with a NULL function pointer,
@@ -186,15 +206,6 @@ static struct orc_entry null_orc_entry = {
 	.type = ORC_TYPE_CALL
 };
 
-/* Fake frame pointer entry -- used as a fallback for generated code */
-static struct orc_entry orc_fp_entry = {
-	.type		= ORC_TYPE_CALL,
-	.sp_reg		= ORC_REG_BP,
-	.sp_offset	= 16,
-	.bp_reg		= ORC_REG_PREV_SP,
-	.bp_offset	= -16,
-};
-
 static struct orc_entry *orc_find(unsigned long ip)
 {
 	static struct orc_entry *orc;
@@ -238,6 +249,11 @@ static struct orc_entry *orc_find(unsigned long ip)
 	if (orc)
 		return orc;
 
+	/* BPF lookup: */
+	orc = orc_bpf_find(ip);
+	if (orc)
+		return orc;
+
 	return orc_ftrace_find(ip);
 }
 
@@ -495,9 +511,8 @@ bool unwind_next_frame(struct unwind_state *state)
 	if (!orc) {
 		/*
 		 * As a fallback, try to assume this code uses a frame pointer.
-		 * This is useful for generated code, like BPF, which ORC
-		 * doesn't know about.  This is just a guess, so the rest of
-		 * the unwind is no longer considered reliable.
+		 * This is just a guess, so the rest of the unwind is no longer
+		 * considered reliable.
 		 */
 		orc = &orc_fp_entry;
 		state->error = true;
-- 
2.51.1


