Return-Path: <live-patching+bounces-2301-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id gHrQL5QA1GnmpAcAu9opvQ
	(envelope-from <live-patching+bounces-2301-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Mon, 06 Apr 2026 20:51:00 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 790633A6606
	for <lists+live-patching@lfdr.de>; Mon, 06 Apr 2026 20:51:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 1EA4C3023306
	for <lists+live-patching@lfdr.de>; Mon,  6 Apr 2026 18:50:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9746238E5EB;
	Mon,  6 Apr 2026 18:50:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XSHxQpQE"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B7AF396560
	for <live-patching@vger.kernel.org>; Mon,  6 Apr 2026 18:50:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775501424; cv=none; b=T7mcToaklAv39FywjWFTH41SgZlBnVUe59N3rS9M11KvRvIW+iYQCUjANl55CdFr5IUVZiqw5jqY5EMioEn98nDfXWm/Pn8edF1PdU2z9x/I6u7c9nXy3EO1dpVRr3zDSok4PrAiG1GM5tkvAsGQvwtKNeiTPmtbRqKACckJkyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775501424; c=relaxed/simple;
	bh=vd8O0jH2VtUEtuEWk5SdTGbr5Ex9xC/ioNfDJLXyYCc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=bejxSCLFJaMaZWGHX8SXo9Tz9AQT9C9DMgvW1ZbISP74ut44BsIFXr3RXg0BMRnxVrdMT3XCFVrwk3rFTahzB9oCGVSfrDd1Y3LpoW61ZZsdCzRJeZGPgzxDPgQh5YaB0p5NwhMFdGWIzzQ7cAVCHZbHtNEZp6So5pSdRtY7hL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--dylanbhatch.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=XSHxQpQE; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--dylanbhatch.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-82c675116f1so6177741b3a.2
        for <live-patching@vger.kernel.org>; Mon, 06 Apr 2026 11:50:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1775501423; x=1776106223; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=8HXbZLR5ZhYSlqgeT0xflWnaF053OqDtzxDl5bISse0=;
        b=XSHxQpQEfSP/bX6anOyMR/V4dyQIyZiXqutH25E7FtIqGGgR8vL4ELeNsGQ2IYoajh
         KwQVZpGGESyYLjZSGH6pnS8ixTNMfYr5O9SmN8ibl7u59XquNDHk0rzn13BzlQTkY5BR
         vjk6gA1yIwO3lTsPdDkEsJSYvlcZp1RaPVx+lRW98MsKGLkR7Tn6ysSbdOoWAnEXa981
         vc3JKbbd5y2GCVphFBpmTCVZhPkLtw7U9SRTxJ+smVCNjxFGQwOQ5RA03DclKSf8XMIn
         T5ugQzQ7Q2Na3b59XVpyEIBzcnEcsXGNXephShf//7two+xY1x7jOEfZSschaIA7l9aw
         c0tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775501423; x=1776106223;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8HXbZLR5ZhYSlqgeT0xflWnaF053OqDtzxDl5bISse0=;
        b=R7oqIMv2+3bcZPCbbqSxzlWORLg/qm0abxu88fA3yUwBMJ4jiz5UbQwpDNMKmKqM2S
         f3WgSEq4mqEi+v2MVTJDPSrqoYmXFn9lDUwp0Arhp9FBGTJ5e/R86pdslfEKQBh5AqO0
         0avUFCmPlnXvWRfSKxooODSijeVkspghkz2J+XV7qfnFrvfDoOefh013Bg7VWlmZNXUO
         VAwR7qGyHZktIaMkB6kR3lKRm1ihAEBhdxQ8Oe0GXex224dPf3u1orNLNVRtHy0Mc/2d
         t3DhntWqVt35KltncZJztNBujJMgI2MOu1H1S/Kbe4+DMXZbtqTFNCf2wcaLfMg1jc3N
         bnHA==
X-Forwarded-Encrypted: i=1; AJvYcCXEEl4eFq+c1BjRysVi0LYvA2W5YvF7p/CeGcEoZfagY28vkr7cRKY4BMmi3OtvLhmz/SVTGzHFq+NNpoSt@vger.kernel.org
X-Gm-Message-State: AOJu0YwQFIHIRWYbqBaVBFpAr2sd9J1GB7uRu37g015Yr1nEZDq5wsef
	a4cwrFon13x6ZiO7NRSt57p2FfcmFZm8kaesP7VBPMVEjrNCC/t/XKbqAabqydtycmxppJUJyma
	W6rDLqgU5EEBRhHWeiC8LNaomGQ==
X-Received: from pfx19.prod.google.com ([2002:a05:6a00:a453:b0:82a:5e62:7b95])
 (user=dylanbhatch job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:800a:b0:82a:6461:6d15 with SMTP id d2e1a72fcca58-82d0dbbc24dmr13636080b3a.46.1775501422424;
 Mon, 06 Apr 2026 11:50:22 -0700 (PDT)
Date: Mon,  6 Apr 2026 18:49:55 +0000
In-Reply-To: <20260406185000.1378082-1-dylanbhatch@google.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260406185000.1378082-1-dylanbhatch@google.com>
X-Mailer: git-send-email 2.53.0.1213.gd9a14994de-goog
Message-ID: <20260406185000.1378082-4-dylanbhatch@google.com>
Subject: [PATCH v3 3/8] arm64: entry: add unwind info for various kernel entries
From: Dylan Hatch <dylanbhatch@google.com>
To: Roman Gushchin <roman.gushchin@linux.dev>, Weinan Liu <wnliu@google.com>, 
	Will Deacon <will@kernel.org>, Josh Poimboeuf <jpoimboe@kernel.org>, 
	Indu Bhagat <indu.bhagat@oracle.com>, Peter Zijlstra <peterz@infradead.org>, 
	Steven Rostedt <rostedt@goodmis.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Jiri Kosina <jikos@kernel.org>
Cc: Dylan Hatch <dylanbhatch@google.com>, Mark Rutland <mark.rutland@arm.com>, 
	Prasanna Kumar T S M <ptsm@linux.microsoft.com>, Puranjay Mohan <puranjay@kernel.org>, 
	Song Liu <song@kernel.org>, joe.lawrence@redhat.com, linux-toolchains@vger.kernel.org, 
	linux-kernel@vger.kernel.org, live-patching@vger.kernel.org, 
	Jens Remus <jremus@linux.ibm.com>, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-2301-lists,live-patching=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[20];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[dylanbhatch@google.com,live-patching@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	TAGGED_RCPT(0.00)[live-patching];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 790633A6606
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

From: Weinan Liu <wnliu@google.com>

DWARF CFI (Call Frame Information) specifies how to recover the return
address and callee-saved registers at each PC in a given function.
Compilers are able to generate the CFI annotations when they compile
the code to assembly language. For handcrafted assembly, we need to
annotate them by hand.

Annotate CFI unwind info for assembly for interrupt and exception
handlers.

Signed-off-by: Weinan Liu <wnliu@google.com>
Signed-off-by: Dylan Hatch <dylanbhatch@google.com>
---
 arch/arm64/kernel/entry.S | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
index f8018b5c1f9a..3148ede8c2c6 100644
--- a/arch/arm64/kernel/entry.S
+++ b/arch/arm64/kernel/entry.S
@@ -575,7 +575,12 @@ SYM_CODE_START_LOCAL(el\el\ht\()_\regsize\()_\label)
 	.if \el == 0
 	b	ret_to_user
 	.else
+	.cfi_startproc
+	.cfi_def_cfa_offset PT_REGS_SIZE
+	.cfi_offset 29, S_FP - PT_REGS_SIZE
+	.cfi_offset 30, S_LR - PT_REGS_SIZE
 	b	ret_to_kernel
+	.cfi_endproc
 	.endif
 SYM_CODE_END(el\el\ht\()_\regsize\()_\label)
 	.endm
@@ -889,6 +894,10 @@ SYM_FUNC_START(call_on_irq_stack)
 	add	sp, x16, #IRQ_STACK_SIZE
 	restore_irq x9
 	blr	x1
+	.cfi_startproc
+	.cfi_def_cfa 29, 16
+	.cfi_offset 29, -16
+	.cfi_offset 30, -8
 
 	save_and_disable_daif x9
 	/*
@@ -900,6 +909,7 @@ SYM_FUNC_START(call_on_irq_stack)
 	scs_load_current
 	restore_irq x9
 	ret
+	.cfi_endproc
 SYM_FUNC_END(call_on_irq_stack)
 NOKPROBE(call_on_irq_stack)
 
-- 
2.53.0.1213.gd9a14994de-goog


