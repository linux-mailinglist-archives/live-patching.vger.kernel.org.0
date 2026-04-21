Return-Path: <live-patching+bounces-2415-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id kLaCMSUA6GlJEAIAu9opvQ
	(envelope-from <live-patching+bounces-2415-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Wed, 22 Apr 2026 00:54:29 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 6771744050E
	for <lists+live-patching@lfdr.de>; Wed, 22 Apr 2026 00:54:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id EFB1A3057623
	for <lists+live-patching@lfdr.de>; Tue, 21 Apr 2026 22:52:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C14553A6B74;
	Tue, 21 Apr 2026 22:52:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cxYHOJ4G"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09DC43A6EF4
	for <live-patching@vger.kernel.org>; Tue, 21 Apr 2026 22:52:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776811938; cv=none; b=DyjEo5VnR/YNDX+GWBT6lsZaYTyutFMKyF3pMvgCF2yzCUUkjzbv34tk/MbNO9Rn5jopJwNUGxbrfJxhD+ZDxVoBeTg5iE7oczCW4y4e6KEZhcQi5Zw7THEl/D6w8DPO7bL94ryCnhjAmzY5SCMsoNZw5LLMXST5rMGvwWsU8nI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776811938; c=relaxed/simple;
	bh=udffv3jNsveJNyWjHMP0HSXsJ23lIpfFHViHlEMIDZw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=qABhuJGqDNga/Hr+ml+Cwuz1oCLWxJrT/Wt9IrMgWNwOBqRLYCvWgrmkqCWiPwrHlVoGBA0t3ak/UB4s33vbnjFSLDgfdn6vyo70WSDIGUeZ69QbqFxeViJsj79Ub9gPnnhBpQ8EYTugxuQT0pT/DFfnmSVif+VecExApnBq3uE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--dylanbhatch.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=cxYHOJ4G; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--dylanbhatch.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-35da97f6a6dso4619400a91.0
        for <live-patching@vger.kernel.org>; Tue, 21 Apr 2026 15:52:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1776811936; x=1777416736; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=zNlZDyegmOFELN70B6bCpVLxtkFdBX1CWXSw170KDZw=;
        b=cxYHOJ4GQCzreXIoW6ThkcALOWw/RI0kOF1PrS/i5Uw8PUytIb1G2tBKEgNtZY31jx
         txGw1RywitrFtM7laUfnIUdeUzTswHBSPKjvUE+7da0uP+7qN7f8yMhqcM/oyZqmXy0K
         panydf9zqInBnlHgvWWSdQx2Ki9YdfhAmc9KeINastyt7SMKz29Hz1MU37kco5RnLloN
         8Zn+gpzL00cGjisWqA4LZ6YIKLN38FHaWPSae5Qav5SZHkrfoRQAAluZV3Z+3dCityEs
         qSwyrch1bjFWUyh91BIKzuRREhlwOiFrNhKjglAUgk2X98MGx1jbe97XjsYaC9dyTLM1
         rGeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776811936; x=1777416736;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zNlZDyegmOFELN70B6bCpVLxtkFdBX1CWXSw170KDZw=;
        b=Mw0FXSBzecdKNT4GILXJNZJp9ycBXBf/WyaXk70HMeT0FTWplcz1zyiB+QQHtuOjIe
         j7HkJn47Dib6tRQuHGJuWu9mdErWa3KFKFFEay7RZppG/4zpi6YJbuiFAT6+xjtkl2I9
         161PnkafULDEsjCnXZYOxYveiOq5JFeJqqaXdj7cnI68oOSqVhtCRKNVwJrgp7n9a00N
         WKX+0sdzjMJWnCdsLiAV+NLXQD+tmezuipyIU11Bcujlg8YM5scNavQGQgGVhEw5N8qS
         cXtYuxFfuLA6d0ECL1Cbq3LffkWbgjFWPda42SxZsvnu7Wi289DoRJnrg90WYTuYR5ie
         fZSg==
X-Forwarded-Encrypted: i=1; AFNElJ+h0UqR/uov/wS+QrlXlPWYnMF8aiaNMTu7/IxHiiTlgL1zDoqIo+7CfQ4xA0EZ3K4XOpHqAFveX28qmPmK@vger.kernel.org
X-Gm-Message-State: AOJu0Yy+D6RVL9LEzIzbIQrZFIblwF1UQ1TUvkEZrumVbcKxfU4CMo4o
	x7JoU+2nJY7nInbI69h5Ps95q0uuuQaq/Iw0K1NvN9uCF22lZhfxxgS8nvnL7OE/CPKyql8b+Ft
	Hv6100IxKT0oWjUMstWT4z3L1BA==
X-Received: from pjrx9.prod.google.com ([2002:a17:90a:bc89:b0:35d:9dbb:bda8])
 (user=dylanbhatch job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:3811:b0:35f:c729:de9f with SMTP id 98e67ed59e1d1-361404c2053mr20137572a91.27.1776811936241;
 Tue, 21 Apr 2026 15:52:16 -0700 (PDT)
Date: Tue, 21 Apr 2026 22:51:55 +0000
In-Reply-To: <20260421225200.1198447-1-dylanbhatch@google.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260421225200.1198447-1-dylanbhatch@google.com>
X-Mailer: git-send-email 2.54.0.rc1.555.g9c883467ad-goog
Message-ID: <20260421225200.1198447-4-dylanbhatch@google.com>
Subject: [PATCH v4 3/8] arm64: entry: add unwind info for various kernel entries
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
	TAGGED_FROM(0.00)[bounces-2415-lists,live-patching=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[dylanbhatch@google.com,live-patching@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TAGGED_RCPT(0.00)[live-patching];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 6771744050E
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

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
Signed-off-by: Dylan Hatch <dylanbhatch@google.com>
Suggested-by: Jens Remus <jremus@linux.ibm.com>
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
2.54.0.rc1.555.g9c883467ad-goog


