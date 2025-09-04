Return-Path: <live-patching+bounces-1626-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A57DB449CE
	for <lists+live-patching@lfdr.de>; Fri,  5 Sep 2025 00:39:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 43DA816C1E7
	for <lists+live-patching@lfdr.de>; Thu,  4 Sep 2025 22:39:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6159B2ECE95;
	Thu,  4 Sep 2025 22:39:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LNCqNpGR"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D517B2ECD12
	for <live-patching@vger.kernel.org>; Thu,  4 Sep 2025 22:39:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757025560; cv=none; b=GPLUBSmoO05nUyhTaQFIEWmyaryLBdXiAJpQW2zqw7ai4JFpttgoqUuSaa6ffHTQPHEoDj1od9hSqq+86oPb1OCDNLm8cPCG6l6UTJSEHaEh/SvVUpYhGtHW5c6TKlYnYVq7tGD63UvS5To5YByUkVaSIeaWtHcF8n7mkR+Ky4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757025560; c=relaxed/simple;
	bh=xnlkf0BdWeK6D1DOdzra4zgNbxjdYbPxVOi1fszhAWM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=n2R34RAj9v8anH3MLHVZmx/Q9di85DCTu7+onqQXHO9bZbHXED6v7MGTOsmZFR9EcThlttozIWmA9m/5hwEAAUw+lnbSVyx7+SF06c/Fx7nA+0Fd6PEUqlJLvRFQq3bNCUAhjKnC32VLFTelU0ESO0Mp/cr3CqjjxGruBzIW19o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--dylanbhatch.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=LNCqNpGR; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--dylanbhatch.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-32b51b26802so1300967a91.2
        for <live-patching@vger.kernel.org>; Thu, 04 Sep 2025 15:39:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757025558; x=1757630358; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=EwoyDNtF8aplk2UKsRnTrhjyV0ajLd9EcSIYMNuhcao=;
        b=LNCqNpGRwGf1vbqhjoJkFtCERBxk7xFzYWKOlaegL/Sde4SngB3unOFLsdSq8V2pCs
         KQLFD8/pSKDP4hyo3otwvTK45vN2cWEvqDJAxx00JW9fcAga2vpR8XUGYn3Nyt6FBKyi
         FVORTIzYR9oGz5MzKDubORIRugTrQO2eEvkftZcRuftjT2uqOYBaKwyzFy6nWPntnnkz
         4RNJrbYfOJiEX8x1B3hJJLoK/Rtel2ZF1acWgdmib92UW2J3LAsCJI0hZOHB9MLFxyo5
         +6tWuQ0SgO80aE1hSxZRakoP6z4KOPBrfsZiURVcAWfTMua7RmP7pecGJLl/ripwtHD5
         Z34Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757025558; x=1757630358;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EwoyDNtF8aplk2UKsRnTrhjyV0ajLd9EcSIYMNuhcao=;
        b=lMqpuxoQYETP3BytvRORhw/+pz/HNLorKRIVo1xwGR1GshIHNzFTD6dzAACqbZxkeP
         +IxUXFjI+y1n+R92TZccVlY9ggaZ4c37nYyR0hwM4TZYZuiSopjPLaYxE7xrzAphOodZ
         eLGUuqMrWqZiCsdACl5jMBijjZdTB+G5WfqgLlBGUUCKOlswe8Rmf2YqeouAbGvl8rEi
         O8EpqvIgrsLS/CSvM86hHgfuK5jEwgnR+3KmesT65PP5EmkgV7QfCvNfQS6XxI39ANGf
         Jr+MIttko86kco4VszI2J9jI3DXiWtxQBTme58UopMdABVtUvLQ21Mt0QuYG/ypNOv9b
         H5Gg==
X-Forwarded-Encrypted: i=1; AJvYcCWVHZDoiWR4JlLyMUhOlRXezoenxBLAQxA5Ijwfzkq72gctdVhGB1TPDJtsDMb1m4s5MIWBUpEfs46ghcCx@vger.kernel.org
X-Gm-Message-State: AOJu0Yyu2dqbyNlOZGOwpZkAg6aVd6+DaV4q6Emb8yj0grq2WiKD9EKS
	HmW3h/dmN+dWnVz90NPagvPtf/rle1ss+48rGThgN1hztEx+QqOttSL2keEyi5SAcyB58Dl6Enh
	rC72TIxoJ2wtN/sKePJZPQ8qq/A==
X-Google-Smtp-Source: AGHT+IG7LIyWvYU3YC2gAf7gR5JcEes7dNZngeNd+zYZ0BktekgBZQfRfAdsbGLuA2OZMC4Xg5mySNnpvS3fkIoA9Q==
X-Received: from pjyd12.prod.google.com ([2002:a17:90a:dfcc:b0:31f:b2f:aeed])
 (user=dylanbhatch job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:2802:b0:32b:9506:1773 with SMTP id 98e67ed59e1d1-32b950618b8mr5636335a91.33.1757025558182;
 Thu, 04 Sep 2025 15:39:18 -0700 (PDT)
Date: Thu,  4 Sep 2025 22:38:46 +0000
In-Reply-To: <20250904223850.884188-1-dylanbhatch@google.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250904223850.884188-1-dylanbhatch@google.com>
X-Mailer: git-send-email 2.51.0.355.g5224444f11-goog
Message-ID: <20250904223850.884188-3-dylanbhatch@google.com>
Subject: [PATCH v2 2/6] arm64: entry: add unwind info for various kernel entries
From: Dylan Hatch <dylanbhatch@google.com>
To: Josh Poimboeuf <jpoimboe@kernel.org>, Steven Rostedt <rostedt@goodmis.org>, 
	Indu Bhagat <indu.bhagat@oracle.com>, Peter Zijlstra <peterz@infradead.org>, 
	Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Jiri Kosina <jikos@kernel.org>
Cc: Dylan Hatch <dylanbhatch@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Weinan Liu <wnliu@google.com>, Mark Rutland <mark.rutland@arm.com>, Ian Rogers <irogers@google.com>, 
	linux-toolchains@vger.kernel.org, linux-kernel@vger.kernel.org, 
	live-patching@vger.kernel.org, joe.lawrence@redhat.com, 
	Puranjay Mohan <puranjay@kernel.org>, Song Liu <song@kernel.org>
Content-Type: text/plain; charset="UTF-8"

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
2.51.0.355.g5224444f11-goog


