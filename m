Return-Path: <live-patching+bounces-1069-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7558CA1FFE5
	for <lists+live-patching@lfdr.de>; Mon, 27 Jan 2025 22:33:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C54E73A401E
	for <lists+live-patching@lfdr.de>; Mon, 27 Jan 2025 21:33:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1AD661DA617;
	Mon, 27 Jan 2025 21:33:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pS88lsUR"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B2831DA31F
	for <live-patching@vger.kernel.org>; Mon, 27 Jan 2025 21:33:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738013610; cv=none; b=UAZ6um8rC+SMahVX0uELcf1NG975xP06tAV10xPEtF9JpvR67KarFiM5d8NrSzJsrvf7mNqSNEiRpCQpZQTwy4S3TfYsdNZLE9doo8lW/zcRBFN4Fc3znlBrGc1QUQUrh4GTbEbCjkPgpcSkKVJ0S7gXE+03XEVFNlxeuvPuco8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738013610; c=relaxed/simple;
	bh=DX6VfTUkhmdwfT2T+n2rZJh1HOTw0vszP61D/bfXh1s=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=V5osRkh/ABzBtKblvm/42SPdHGUXwrDo1+FsSkukNmDveCHY3FFS6hkLXKJbhTf5iaP2WzvxENUZybZvQOYqi9u983bgo27uqQHFZb2zmq7Zx5Vx8l9SQd9V9Oia1Ln3RIhogTW1NRtlHUpX/623myL9oTWj4dIqeinJ1IYmi5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--wnliu.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=pS88lsUR; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--wnliu.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2ef775ec883so9437790a91.1
        for <live-patching@vger.kernel.org>; Mon, 27 Jan 2025 13:33:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1738013608; x=1738618408; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=jWq1XbSkyOkuYcVulfJjVxpq/eHKTQbF0thAv0NyIGs=;
        b=pS88lsURchmPTsYeFFtLfp/TSvv2isJAirB0RxDD+uMJeM8QfQ9TFiZQYS4nDyWXI9
         zqE4qRShEoMi9ftj9oB5ds+ruJu3MLE+VIJcH3lPpLVHAQd2AW0bB0+qOVFKbgSFTups
         wfF/JXbBzt6iB0B0msq89fOZMjX6BBNJhoGKWq93WJpov/s2doVtQQAs9frjU+c5icGn
         qu1mBIeWFLmeYnKbOkfkI4QaSmQyC7X+ed3T9r7HGRbgEVWAs916lTgIlkQ9bJRaNblN
         jJXiexMK8viYNIDFmQIyLotf33WP3wCHkIFTLd+rb1kRiBehu1boBGtUBMoGtR2XSow0
         TzBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738013608; x=1738618408;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jWq1XbSkyOkuYcVulfJjVxpq/eHKTQbF0thAv0NyIGs=;
        b=T7aOKxb9PdEckVsAEODlTOtf+swPNi9kS2CbSuJu7tWGlGGC25BgWT9Q0+LsGmDSJ5
         28DLfNda3TKrbQZlHWczUspqaiYVvbVc1S7EFTesUjNydbMq8/PTW+db7rC19sImZTJK
         TAS7ZTlydXQuWjsNxN/4YrbAsbmASmPIfxhij57nYjwNRsbIO7r6I0n6lXzlyOhbxBGn
         SlyMcHR0qvg+y3wiiviii7+ubvhCM7shuRaJJ2UhJjakv/R5zQBobeeSqKmRTXiiXHmT
         mJLyEDjkXOW/MpiXbFVFSVHNHgmRF9Dpt8Wr+/UklHLjopgakLxNyxOrjOFv56717oxV
         f8tg==
X-Forwarded-Encrypted: i=1; AJvYcCWUEsA9yj6/jAFtAceJnXtPVwFq6u/Qz/9nJYhmqHG0sEIHBkn55m4u0ze/QwL25z+rZXIoP3+wOPBDSi4u@vger.kernel.org
X-Gm-Message-State: AOJu0YyaXZ9vyeoI3GbPJLN6oIcZYhbClqrcRfn22Pm7u/Iyu+j/YTOn
	PS6CCg1q8UWuCxcCLyrwRuXR6qMVLHLA2b/ybl7Dyx46ona0VvzIrOzip+IauD/o5yQx3Mq10A=
	=
X-Google-Smtp-Source: AGHT+IGsA2oXsBLBU6n+vsGTmoyiK5KDPDDibU+y8Mvqe4ndlxlznHpYDael7KmNjQ8dikt+jPZ/Btay/Q==
X-Received: from pjbse3.prod.google.com ([2002:a17:90b:5183:b0:2ea:4139:e72d])
 (user=wnliu job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:6c6:b0:2ee:889b:b11e
 with SMTP id 98e67ed59e1d1-2f782d972eamr59541677a91.30.1738013607746; Mon, 27
 Jan 2025 13:33:27 -0800 (PST)
Date: Mon, 27 Jan 2025 21:33:04 +0000
In-Reply-To: <20250127213310.2496133-1-wnliu@google.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250127213310.2496133-1-wnliu@google.com>
X-Mailer: git-send-email 2.48.1.262.g85cc9f2d1e-goog
Message-ID: <20250127213310.2496133-3-wnliu@google.com>
Subject: [PATCH 2/8] arm64: entry: add unwind info for various kernel entries
From: Weinan Liu <wnliu@google.com>
To: Josh Poimboeuf <jpoimboe@kernel.org>, Steven Rostedt <rostedt@goodmis.org>, 
	Indu Bhagat <indu.bhagat@oracle.com>, Peter Zijlstra <peterz@infradead.org>
Cc: Mark Rutland <mark.rutland@arm.com>, roman.gushchin@linux.dev, 
	Will Deacon <will@kernel.org>, Ian Rogers <irogers@google.com>, linux-toolchains@vger.kernel.org, 
	linux-kernel@vger.kernel.org, live-patching@vger.kernel.org, 
	joe.lawrence@redhat.com, linux-arm-kernel@lists.infradead.org, 
	Weinan Liu <wnliu@google.com>
Content-Type: text/plain; charset="UTF-8"

DWARF CFI (Call Frame Information) specifies how to recover the return
address and callee-saved registers at each PC in a given function.
Compilers are able to generate the CFI annotations when they compile
the code to assembly language. For handcrafted assembly, we need to
annotate them by hand.

Annotate CFI unwind info for assembly for interrupt and exception
handlers.

Signed-off-by: Weinan Liu <wnliu@google.com>
---
 arch/arm64/kernel/entry.S | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
index 5ae2a34b50bd..fe3e3e29ee5d 100644
--- a/arch/arm64/kernel/entry.S
+++ b/arch/arm64/kernel/entry.S
@@ -579,7 +579,12 @@ SYM_CODE_START_LOCAL(el\el\ht\()_\regsize\()_\label)
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
 	/* Move to the new stack and call the function there */
 	add	sp, x16, #IRQ_STACK_SIZE
 	blr	x1
+	.cfi_startproc
+	.cfi_def_cfa 29, 16
+	.cfi_offset 29, -16
+	.cfi_offset 30, -8
 
 	/*
 	 * Restore the SP from the FP, and restore the FP and LR from the frame
@@ -898,6 +907,7 @@ SYM_FUNC_START(call_on_irq_stack)
 	ldp	x29, x30, [sp], #16
 	scs_load_current
 	ret
+	.cfi_endproc
 SYM_FUNC_END(call_on_irq_stack)
 NOKPROBE(call_on_irq_stack)
 
-- 
2.48.1.262.g85cc9f2d1e-goog


