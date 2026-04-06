Return-Path: <live-patching+bounces-2305-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id eEzdF90A1GnmpAcAu9opvQ
	(envelope-from <live-patching+bounces-2305-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Mon, 06 Apr 2026 20:52:13 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id CB4713A6658
	for <lists+live-patching@lfdr.de>; Mon, 06 Apr 2026 20:52:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 77CEC3028F58
	for <lists+live-patching@lfdr.de>; Mon,  6 Apr 2026 18:50:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 54D15396B7F;
	Mon,  6 Apr 2026 18:50:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KL8iQ+tb"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0383439657C
	for <live-patching@vger.kernel.org>; Mon,  6 Apr 2026 18:50:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775501435; cv=none; b=L/ho1YpQzR1EeYWX21bNFI2Y7VTispkQQi2eNtd2FDild+B+eUgQuJUGSNfi53ISDym7Ah6j2X94lf4EmcQwoXAByMWUjOYYSM/m6Vj8LVN2Cpsq9Bo9nrb59KJMWSiqULugfa8I9MnUXTy5ZFGucTruZtoAZkP0Eax2IHO50Hk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775501435; c=relaxed/simple;
	bh=+Nyb1e8zdiJwGD2eyvjV3Ua8oed1PtJ2SYHQkBs3gp4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=FUqIrv96/CGdCD0XrNaRgd+iB8/c+s6MeDPOkvHqc0MbK31tM3gjUz4aRL7MU2xrQe0mUKdlaBdUxPQZ6JTcEoNap7NHqYuJibT7QyOUArKbGhrfgjsHxVjI+13ZjU8Cb4FfDOzVmzpcKSSqr2HvdP4+Sjz2eGO68xhUIsC2YoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--dylanbhatch.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=KL8iQ+tb; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--dylanbhatch.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-c7691378914so1841279a12.0
        for <live-patching@vger.kernel.org>; Mon, 06 Apr 2026 11:50:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1775501433; x=1776106233; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=4f5UDmcibonmjOEiHrPfd3SDxe+C+ut81zyQMBFE3jI=;
        b=KL8iQ+tbrnYrh78jCLeudYgQtX7srb/EvtmqBzYC99UaXAdbA3EYrl2Xgr2NYBeShd
         /qdyxUeqX4ZWjf6QjBrVmGVRpiRNvbeg5y54fJFoRiEzgT3S2d7Ia7Wj2uG9m4Cf7mFX
         v1mnbWJEcVRQ/Z29uiI3WgiF/SrkTqDZLvxvjdGVPZdGlm86k/WYnLUScKfyqwdaeKe+
         fraOF4WfNfTz7JjLeeShZ8kAlibAuXIRM0H4qKPkKRgP9v/mByFOSLlRaOYgg2VOZFvF
         35Fvx+eLqpFPg8/h1uJbYuUUGk6d3j9iDK8Rh+cwLSup66CDtTfZYgzUWRMC5Sc2MAmk
         EPQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775501433; x=1776106233;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4f5UDmcibonmjOEiHrPfd3SDxe+C+ut81zyQMBFE3jI=;
        b=o7tX4Z9A4MMnLF8jB5f19Tw7lreeJ5Elwv84+zVQh/lpWD/SvrEUl3JSZMG+JxWoYv
         vsZkzkTCEFXZF3o3QGHTKuyGHxGfB05Rj69vCHyZ9364G7xpzNooHMYxUNGSPMIGDKtI
         Yf3vkaqd8koCr6hbsGcOPzWNz3y46mDLe/ecKs+IkNVnV/1UN3NL0ZT8UVlJmkW0io9X
         yfbCZaQUGnCZHFY+mzRei7uTsFNPaYqsbIG/r57FYGGXaw2OIvCvRkoN5N6L4V2ngBpK
         Vs8mGK54Epfn332KA7yIwmlFYtzNIhKhvqdudbO5xs13o5ojan+nekaw4ccq3zHZV3Vs
         MNSw==
X-Forwarded-Encrypted: i=1; AJvYcCVGzlly+jxZpCQaGospSv3pJbUOdfLMgbtsq2ezBqanVqpqpROzrrZO881KHbrDel+8KEwexJuLj6LZHIBY@vger.kernel.org
X-Gm-Message-State: AOJu0YwFgW9KQu1f57iCzroQcfnFgZT42JSNFinmQbzdU/INTC+g/vl8
	/7Qo8Ark00MXKCfNu0D4YQbm3sCt/gTu/SS90nofL61dWW/ocY1eO2vsvUXfXVG95LUoylH5i4W
	BGk1rExpFkZ63/NkSbWfAOZeQkw==
X-Received: from pfob2.prod.google.com ([2002:aa7:8702:0:b0:829:880b:b4])
 (user=dylanbhatch job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:bc0b:b0:82a:64c7:8c6d with SMTP id d2e1a72fcca58-82d0dacdbcemr13772509b3a.25.1775501432995;
 Mon, 06 Apr 2026 11:50:32 -0700 (PDT)
Date: Mon,  6 Apr 2026 18:49:59 +0000
In-Reply-To: <20260406185000.1378082-1-dylanbhatch@google.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260406185000.1378082-1-dylanbhatch@google.com>
X-Mailer: git-send-email 2.53.0.1213.gd9a14994de-goog
Message-ID: <20260406185000.1378082-8-dylanbhatch@google.com>
Subject: [PATCH v3 7/8] sframe: Introduce in-kernel SFRAME_VALIDATION.
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
	TAGGED_FROM(0.00)[bounces-2305-lists,live-patching=lfdr.de];
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
X-Rspamd-Queue-Id: CB4713A6658
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Generalize the __safe* helpers to support a non-user-access code path.
Allow for kernel FDE read failures due to the presence of .rodata.text.
This section contains code that can't be executed by the kernel
direclty, and thus lies ouside the normal kernel-text bounds.

Signed-off-by: Dylan Hatch <dylanbhatch@google.com>
---
 arch/Kconfig           |  2 +-
 kernel/unwind/sframe.c | 20 ++++++++++++++++++++
 2 files changed, 21 insertions(+), 1 deletion(-)

diff --git a/arch/Kconfig b/arch/Kconfig
index c87e489fa978..6e9f21231b98 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -503,7 +503,7 @@ config HAVE_UNWIND_USER_SFRAME
 
 config SFRAME_VALIDATION
 	bool "Enable .sframe section debugging"
-	depends on HAVE_UNWIND_USER_SFRAME
+	depends on SFRAME_LOOKUP
 	depends on DYNAMIC_DEBUG
 	help
 	  When adding an .sframe section for a task, validate the entire
diff --git a/kernel/unwind/sframe.c b/kernel/unwind/sframe.c
index 180f64040846..7096e0a244b4 100644
--- a/kernel/unwind/sframe.c
+++ b/kernel/unwind/sframe.c
@@ -638,6 +638,9 @@ static int safe_read_fde(struct sframe_section *sec,
 {
 	int ret;
 
+	if (sec->sec_type == SFRAME_KERNEL)
+		return __read_fde(sec, fde_num, fde);
+
 	if (!user_read_access_begin((void __user *)sec->sframe_start,
 				    sec->sframe_end - sec->sframe_start))
 		return -EFAULT;
@@ -653,6 +656,9 @@ static int safe_read_fre(struct sframe_section *sec,
 {
 	int ret;
 
+	if (sec->sec_type == SFRAME_KERNEL)
+		return __read_fre(sec, fde, fre_addr, fre);
+
 	if (!user_read_access_begin((void __user *)sec->sframe_start,
 				    sec->sframe_end - sec->sframe_start))
 		return -EFAULT;
@@ -667,6 +673,9 @@ static int safe_read_fre_datawords(struct sframe_section *sec,
 {
 	int ret;
 
+	if (sec->sec_type == SFRAME_KERNEL)
+		return __read_fre_datawords(sec, fde, fre);
+
 	if (!user_read_access_begin((void __user *)sec->sframe_start,
 				    sec->sframe_end - sec->sframe_start))
 		return -EFAULT;
@@ -690,6 +699,13 @@ static int sframe_validate_section(struct sframe_section *sec)
 		int ret;
 
 		ret = safe_read_fde(sec, i, &fde);
+		/*
+		 * Code in .rodata.text is not considered part of normal kernel
+		 * text, but there is no easy way to prevent sframe data from
+		 * being generated for it.
+		 */
+		if (ret && sec->sec_type == SFRAME_KERNEL)
+			continue;
 		if (ret)
 			return ret;
 
@@ -1015,6 +1031,8 @@ void __init init_sframe_table(void)
 
 	if (WARN_ON(sframe_read_header(&kernel_sfsec)))
 		return;
+	if (WARN_ON(sframe_validate_section(&kernel_sfsec)))
+		return;
 
 	sframe_init = true;
 }
@@ -1032,6 +1050,8 @@ void sframe_module_init(struct module *mod, void *sframe, size_t sframe_size,
 
 	if (WARN_ON(sframe_read_header(&sec)))
 		return;
+	if (WARN_ON(sframe_validate_section(&sec)))
+		return;
 
 	mod->arch.sframe_sec = sec;
 	mod->arch.sframe_init = true;
-- 
2.53.0.1213.gd9a14994de-goog


