Return-Path: <live-patching+bounces-2856-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id IPFoOjcIDGoRUQUAu9opvQ
	(envelope-from <live-patching+bounces-2856-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Tue, 19 May 2026 08:50:31 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 9E8AB5785E8
	for <lists+live-patching@lfdr.de>; Tue, 19 May 2026 08:50:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id AC72F3028EE8
	for <lists+live-patching@lfdr.de>; Tue, 19 May 2026 06:50:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E7703A1E69;
	Tue, 19 May 2026 06:50:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GQ0CpSrh"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C725B39FCC7
	for <live-patching@vger.kernel.org>; Tue, 19 May 2026 06:50:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779173413; cv=none; b=IcEUsAugG7YhxdCtUnXcUwVgNjYw7Nue9Cokh3SCd2dTyA8hTt/5l0lIHKYJWR26knL63TMJR8QpY8cEvjVXgz43jSlu+NL5iJhYho9IPUK511lt6B4I4/ZC/RfVXjyT27h3SSphDiYWjgu50gT6zZDA2u5jorCCOvpBHkjX/O4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779173413; c=relaxed/simple;
	bh=QPZlDoBeN5r7i/6i6lVlWNxNy9qNlw6uNRopAySy1HM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=O7HPFLqdIN6saObjBZltoKPWscC5NXo9Exvj7bqX2bHJO4bAJPETDG0ZqBgln0FgSq7Niz9p+en1sAHOMNIYknisLZ+dscP/2GWs2fmsBOCPnQsmzIpNdulMIgd9gJ5Z6YH/pU8UYnuPSuwCvTs1epnQW6QAVBBBV3Rf6fjbApo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--dylanbhatch.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=GQ0CpSrh; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--dylanbhatch.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-82f6b984b3aso1700168b3a.3
        for <live-patching@vger.kernel.org>; Mon, 18 May 2026 23:50:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779173411; x=1779778211; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=086D5frAOVBWnalU1CQBdAMt78W31bnAcSL8E1jh81w=;
        b=GQ0CpSrhn6Bx56+rEnuQdoVu7POZK19OnFF1nyv9d2Zg2/ZWylIOJJu5XmeGDEd5uH
         L5etXmJ2foDebr+qbKfpuyKYUlvzCVY8aXGJ5KYqFI2Db/F2L9cWlfeKEBbsUSofmScf
         SMyDaU62ccxPsazoI8yvzUORIW628zOQo+9sOlt9JQzp0B+KsW+SW/Lqj2c2X4Y+0Fg9
         FSbwhKnKbgrnfTajcsvlK0wV9SDPI2rCSPCEDvb/YPD+R9TYJ4K5s/I161RE6vmhJvGK
         YlYSggfN1BBV9f4d/lqbysTzSvpQVzAPdUp3QNkZ32U1yWX8Z867TpLurdXTameehOxy
         Nchw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779173411; x=1779778211;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=086D5frAOVBWnalU1CQBdAMt78W31bnAcSL8E1jh81w=;
        b=L5xCib3TDU4h1iE4ABPui2M7NenhxlFnTzZHhoy7k7dIvS/056cBrCg1bmx9CMOdYR
         F+A4+4bPOSuQrpYFngX/Uz9uQ0XjvKQvBADqamqbp9q7/poI7lqn4HJsC1nrowz7CVei
         p5JwKH3pds1tuOUe269rSdfOAZHxXPC3wAgjUcesMqnF75jR7qTEBYdMu5PoHS0O+m8P
         7ong3oTS0sDcjqgJCNGz+1ytLm8Iw+bYoCGU+0zjLAkHRuIjYqoTUk8lxHv2p0WIgFd6
         gyXZpe1oeS0w6M2rzYvEIb44/9DaHUAoA35GLBexIo8Wr7UNgtVCTLsoyF5ejNM/aCqh
         7u0Q==
X-Forwarded-Encrypted: i=1; AFNElJ9V0vbkj0njys0qlcOqbwarBqlpxR9lOdF0v3jBnVoatQp+1L9HkdlqDRQxgBhHnVY7l4I+NQqsUqMnszC4@vger.kernel.org
X-Gm-Message-State: AOJu0YzsieXWhSsqFIZXzPyI1FKaOEFVsYN8EgjEQvh7dHa0SdfjKOGn
	xgTAJfYcWSEUaQkjXwS13De1+OPbIATTvsimYlka/rV3h/xt5i96GCaNXvS/dD58erz1sxK4b4P
	mDyTAiF3NRSIwEzvTynmZtS4iPQ==
X-Received: from pfoo3.prod.google.com ([2002:a05:6a00:1a03:b0:82f:d8c0:fef8])
 (user=dylanbhatch job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:e11:b0:837:a211:4ed0 with SMTP id d2e1a72fcca58-83f33de8025mr17898871b3a.41.1779173410955;
 Mon, 18 May 2026 23:50:10 -0700 (PDT)
Date: Tue, 19 May 2026 06:49:44 +0000
In-Reply-To: <20260519064950.493949-1-dylanbhatch@google.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260519064950.493949-1-dylanbhatch@google.com>
X-Mailer: git-send-email 2.54.0.563.g4f69b47b94-goog
Message-ID: <20260519064950.493949-4-dylanbhatch@google.com>
Subject: [PATCH v6 3/9] arm64: entry: add unwind info for call_on_irq_stack()
From: Dylan Hatch <dylanbhatch@google.com>
To: Roman Gushchin <roman.gushchin@linux.dev>, Weinan Liu <wnliu@google.com>, 
	Will Deacon <will@kernel.org>, Josh Poimboeuf <jpoimboe@kernel.org>, 
	Indu Bhagat <ibhagatgnu@gmail.com>, Peter Zijlstra <peterz@infradead.org>, 
	Steven Rostedt <rostedt@goodmis.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Jiri Kosina <jikos@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
	Jens Remus <jremus@linux.ibm.com>
Cc: Dylan Hatch <dylanbhatch@google.com>, Prasanna Kumar T S M <ptsm@linux.microsoft.com>, 
	Puranjay Mohan <puranjay@kernel.org>, Song Liu <song@kernel.org>, joe.lawrence@redhat.com, 
	linux-toolchains@vger.kernel.org, linux-kernel@vger.kernel.org, 
	live-patching@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	Randy Dunlap <rdunlap@infradead.org>, Mostafa Saleh <smostafa@google.com>, 
	Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_DKIM_ALLOW(-0.20)[google.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_TO(0.00)[linux.dev,google.com,kernel.org,gmail.com,infradead.org,goodmis.org,arm.com,linux.ibm.com];
	RCPT_COUNT_TWELVE(0.00)[24];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[dylanbhatch@google.com,live-patching@vger.kernel.org];
	TAGGED_FROM(0.00)[bounces-2856-lists,live-patching=lfdr.de];
	TAGGED_RCPT(0.00)[live-patching];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:rdns,sto.lore.kernel.org:helo]
X-Rspamd-Queue-Id: 9E8AB5785E8
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

From: Weinan Liu <wnliu@google.com>

DWARF CFI (Call Frame Information) specifies how to recover the return
address and callee-saved registers at each PC in a given function.
Compilers are able to generate the CFI annotations when they compile
the code to assembly language. For handcrafted assembly, we need to
annotate them by hand.

Frame pointers alone are usually sufficient to recover stack frames
(without CFI), except at the exception boundary, where more information
is needed to determine if the LR is live.

Since an exception can be taken from call_on_irq_stack(), annotate it
with CFI. The actual entry assembly functions are left untouched, since
they are not expected to take exceptions themselves.

Signed-off-by: Weinan Liu <wnliu@google.com>
Suggested-by: Jens Remus <jremus@linux.ibm.com>
Reviewed-by: Jens Remus <jremus@linux.ibm.com>
Signed-off-by: Dylan Hatch <dylanbhatch@google.com>
---
 arch/arm64/kernel/entry.S | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
index e0db14e9c843..5f4172ba4274 100644
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
@@ -870,6 +876,7 @@ NOKPROBE(ret_from_fork)
  * Calls func(regs) using this CPU's irq stack and shadow irq stack.
  */
 SYM_FUNC_START(call_on_irq_stack)
+	.cfi_startproc
 	save_and_disable_daif x9
 #ifdef CONFIG_SHADOW_CALL_STACK
 	get_current_task x16
@@ -880,6 +887,9 @@ SYM_FUNC_START(call_on_irq_stack)
 	/* Create a frame record to save our LR and SP (implicit in FP) */
 	stp	x29, x30, [sp, #-16]!
 	mov	x29, sp
+	.cfi_def_cfa 29, 16
+	.cfi_offset 29, -16
+	.cfi_offset 30, -8
 
 	ldr_this_cpu x16, irq_stack_ptr, x17
 
@@ -895,9 +905,13 @@ SYM_FUNC_START(call_on_irq_stack)
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
2.54.0.563.g4f69b47b94-goog


