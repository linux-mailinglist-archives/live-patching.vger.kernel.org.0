Return-Path: <live-patching+bounces-2593-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 4C8lIJD+8GnubgEAu9opvQ
	(envelope-from <live-patching+bounces-2593-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Tue, 28 Apr 2026 20:38:08 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 0ADA448ABBD
	for <lists+live-patching@lfdr.de>; Tue, 28 Apr 2026 20:38:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 2F1B130C0388
	for <lists+live-patching@lfdr.de>; Tue, 28 Apr 2026 18:37:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED04647B41D;
	Tue, 28 Apr 2026 18:37:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rqQx3dAd"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 963E6125AA
	for <live-patching@vger.kernel.org>; Tue, 28 Apr 2026 18:37:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777401436; cv=none; b=eWjz9fdj8kPbAEUEzIriTxcaWqJfglvgni4n63B9ZpsM6qqvi3YtcNs6FpJxIXyhjFfQVygjTxE1wDdrbkfNiX3Zm7kjt9pJ0AZLvBIxAAiuhVilzLEm7mdu6zj33O5turr0hCO3NI2mcEHDnnudB4J+1r4UF1stks/P9cO01O8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777401436; c=relaxed/simple;
	bh=tefadcmVpwT/xUVJDO57dtYdiK3vwLPkO5vSZsjgUdk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Tkf1LC2Q0uIF6F3FvDADbZYAibzNy5IgcXuox5lcFO9ul5qMyhKkbvtmhruWO3WhKr2ofznOFoJWUPSeCg2xMitmfxYs2djzGIAZht/EfHcYhMiEIlLIUAkQasehSXteqseF4gDrvZ1O2PnogcQgbYxuW1wNRKWpwKBWTfMPSPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--dylanbhatch.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=rqQx3dAd; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--dylanbhatch.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-35da4795b3cso22941469a91.2
        for <live-patching@vger.kernel.org>; Tue, 28 Apr 2026 11:37:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777401435; x=1778006235; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=rEpxSS5AT7sZwZhISlQ7XtXed3JthTvzY7OBT2Phvm0=;
        b=rqQx3dAd/ZXH5/17SVRgTl/JkHFXzU8byZNT00J97UJk+aU1evq09GDHXvI1yKYyN0
         qTALV0aykEdUJcVtkkpWidN39NoE5KzOZvr6aePhQTS7chLF1axB5TVZfU92Foh1mQym
         3KAIPenmQI1hO10E5CHsHvzvnsl5Wi8p6rTFigydrqH0yUrTL2a56QBteJSk35XvjkrD
         vbD4uQjVO1gPS+fep4iW0ea2S3IMERkAh2PE+DYbYisdsSYFvrpWyY+uY8C9G6tUcyle
         Zc27OpA7jwC3oUnSjtEqJP1/Vs8cjmp57M804JVrUNt140wWAIH293btd/8otWZ3b1VQ
         lBAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777401435; x=1778006235;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rEpxSS5AT7sZwZhISlQ7XtXed3JthTvzY7OBT2Phvm0=;
        b=DuGQDquq5ZGBuMiWAUTlqJy0tU8atKgtSwyuVzlAK+vceiMSA4Ylbb4L+NghPUh1sB
         cUHr+0zcxlwsTc1zg4J+gtD0VpjVsH7sDNw1isq8C8OPix6z34pzEFCgtAnEtld7HuhU
         qY+R6at8DPLaa/m2ze5mt3LvCVuHOiSZNRvaF+IPi+UvTh6Bxys2FrvBKzhVxiP9e8UR
         Z6NLtUwrZki304iC9tq5c7Qo9gdDbgTbDk9OQKLL722N2MA1/4j/GZqbTvvKE+hReGjJ
         1MSIetnETGUaIqR9qhtJ9nKdWSE/DL0KvTzLhgb+zV0TgjqHiTmgfTgPiI5YtabE6mNJ
         nx8w==
X-Forwarded-Encrypted: i=1; AFNElJ8VVx/HtqVMI5kHjYsxbhSeMxk/6UZoiYXLEY7qmzvWOiSG6nIRsmEa7pcIp7XiBV0TdoOTlr3KDQHLn7WL@vger.kernel.org
X-Gm-Message-State: AOJu0YzKiVLrQpyPF4R8ySMWSfYKYxnTWmFk3pjRrRvshzZhB113za+s
	dZvbm+zqRcrctWRLrla36oQj8unXNqulICCePwcKspsf6EkrflEqn2bPhmeP1TBAjwCXSMeAzHv
	KlXWDjsL6jcM1LtHFq5OpbchEbw==
X-Received: from pfuw1.prod.google.com ([2002:a05:6a00:14c1:b0:82f:a366:f295])
 (user=dylanbhatch job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a21:6d89:b0:3a2:ebc1:4620 with SMTP id adf61e73a8af0-3a39c33cdeemr5030967637.38.1777401434645;
 Tue, 28 Apr 2026 11:37:14 -0700 (PDT)
Date: Tue, 28 Apr 2026 18:36:38 +0000
In-Reply-To: <20260428183643.3796063-1-dylanbhatch@google.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260428183643.3796063-1-dylanbhatch@google.com>
X-Mailer: git-send-email 2.54.0.545.g6539524ca2-goog
Message-ID: <20260428183643.3796063-4-dylanbhatch@google.com>
Subject: [PATCH v5 3/8] arm64: entry: add unwind info for various kernel entries
From: Dylan Hatch <dylanbhatch@google.com>
To: Roman Gushchin <roman.gushchin@linux.dev>, Weinan Liu <wnliu@google.com>, 
	Will Deacon <will@kernel.org>, Josh Poimboeuf <jpoimboe@kernel.org>, 
	Indu Bhagat <ibhagatgnu@gmail.com>, Peter Zijlstra <peterz@infradead.org>, 
	Steven Rostedt <rostedt@goodmis.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Jiri Kosina <jikos@kernel.org>, Jens Remus <jremus@linux.ibm.com>
Cc: Dylan Hatch <dylanbhatch@google.com>, Mark Rutland <mark.rutland@arm.com>, 
	Prasanna Kumar T S M <ptsm@linux.microsoft.com>, Puranjay Mohan <puranjay@kernel.org>, 
	Song Liu <song@kernel.org>, joe.lawrence@redhat.com, linux-toolchains@vger.kernel.org, 
	linux-kernel@vger.kernel.org, live-patching@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, Randy Dunlap <rdunlap@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 0ADA448ABBD
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FREEMAIL_TO(0.00)[linux.dev,google.com,kernel.org,gmail.com,infradead.org,goodmis.org,arm.com,linux.ibm.com];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[21];
	TAGGED_FROM(0.00)[bounces-2593-lists,live-patching=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[dylanbhatch@google.com,live-patching@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TAGGED_RCPT(0.00)[live-patching];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]

From: Weinan Liu <wnliu@google.com>

DWARF CFI (Call Frame Information) specifies how to recover the return
address and callee-saved registers at each PC in a given function.
Compilers are able to generate the CFI annotations when they compile
the code to assembly language. For handcrafted assembly, we need to
annotate them by hand.

Annotate minimal CFI to enable stacktracing using SFrame for kernel
exception entries through el1*_64_*() paths and irq entries through
call_on_irq_stack()

Signed-off-by: Weinan Liu <wnliu@google.com>
Suggested-by: Jens Remus <jremus@linux.ibm.com>
Reviewed-by: Jens Remus <jremus@linux.ibm.com>
Signed-off-by: Dylan Hatch <dylanbhatch@google.com>
---
 arch/arm64/kernel/entry.S | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
index f8018b5c1f9a..dc55b0b19cfa 100644
--- a/arch/arm64/kernel/entry.S
+++ b/arch/arm64/kernel/entry.S
@@ -30,6 +30,12 @@
 #include <asm/asm-uaccess.h>
 #include <asm/unistd.h>
 
+/*
+ * Do not generate .eh_frame.  Only generate .debug_frame and optionally
+ * .sframe (via assembler option --gsframe[-N]).
+ */
+	.cfi_sections .debug_frame
+
 	.macro	clear_gp_regs
 	.irp	n,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29
 	mov	x\n, xzr
@@ -575,7 +581,16 @@ SYM_CODE_START_LOCAL(el\el\ht\()_\regsize\()_\label)
 	.if \el == 0
 	b	ret_to_user
 	.else
+	/*
+	 * Minimal DWARF CFI for unwinding across the call above.
+	 * Enable unwinding for el1*_64_*() path only.
+	 */
+	.cfi_startproc
+	.cfi_def_cfa_offset PT_REGS_SIZE
+	.cfi_offset 29, S_FP - PT_REGS_SIZE
+	.cfi_offset 30, S_LR - PT_REGS_SIZE
 	b	ret_to_kernel
+	.cfi_endproc
 	.endif
 SYM_CODE_END(el\el\ht\()_\regsize\()_\label)
 	.endm
@@ -872,6 +887,7 @@ NOKPROBE(ret_from_fork)
  * Calls func(regs) using this CPU's irq stack and shadow irq stack.
  */
 SYM_FUNC_START(call_on_irq_stack)
+	.cfi_startproc
 	save_and_disable_daif x9
 #ifdef CONFIG_SHADOW_CALL_STACK
 	get_current_task x16
@@ -882,6 +898,9 @@ SYM_FUNC_START(call_on_irq_stack)
 	/* Create a frame record to save our LR and SP (implicit in FP) */
 	stp	x29, x30, [sp, #-16]!
 	mov	x29, sp
+	.cfi_def_cfa 29, 16
+	.cfi_offset 29, -16
+	.cfi_offset 30, -8
 
 	ldr_this_cpu x16, irq_stack_ptr, x17
 
@@ -897,9 +916,13 @@ SYM_FUNC_START(call_on_irq_stack)
 	 */
 	mov	sp, x29
 	ldp	x29, x30, [sp], #16
+	.cfi_restore 29
+	.cfi_restore 30
+	.cfi_def_cfa 31, 0
 	scs_load_current
 	restore_irq x9
 	ret
+	.cfi_endproc
 SYM_FUNC_END(call_on_irq_stack)
 NOKPROBE(call_on_irq_stack)
 
-- 
2.54.0.545.g6539524ca2-goog


