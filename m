Return-Path: <live-patching+bounces-1075-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A3FA6A1FFF1
	for <lists+live-patching@lfdr.de>; Mon, 27 Jan 2025 22:35:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0F4D41655A8
	for <lists+live-patching@lfdr.de>; Mon, 27 Jan 2025 21:35:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 634491DDA35;
	Mon, 27 Jan 2025 21:33:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="3C5M9N0x"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E00C71DDA0E
	for <live-patching@vger.kernel.org>; Mon, 27 Jan 2025 21:33:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738013626; cv=none; b=DyleJNzaSho+gAJoyAn/oQedMBoZkVeoNBLrVHYqAk4Tm1lsl/1Eod8q7yfx0rORoSvwzTUNb44cEqf+PeDZl2Z+lbyoPAygibLi7ODyZ82toeco7Jf6PVQ+Hb05D7QGMx153A0aJ5VlYB5gP4KucHxS8w2K1iW75rxayirflzM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738013626; c=relaxed/simple;
	bh=pI3FZDlF646LxEDSftCYlwDERzfFSfxkeBl5dFk7tWo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=O+/gs0tNASyS/gV9l94HA/W9CVPP4bjDaAY2XiiUcXdSymaILjNTpzgEtQlkwNSU4TmuoekNEkSUQQJ2wD5uE4hSI7wXMRDrkRKdNAPhAeAAltbklHomQ4ZNbISgtKKbgOasVb5Y8etp3zDkFI/4DfMofeIv85jyWo3BkSOaQac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--wnliu.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=3C5M9N0x; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--wnliu.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2ef9204f898so9423219a91.2
        for <live-patching@vger.kernel.org>; Mon, 27 Jan 2025 13:33:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1738013624; x=1738618424; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=rDc9oon22Zy8JtV6oJyK3eShWNaKTPBJnRLwhRmq6mE=;
        b=3C5M9N0xNULISmGFd/fTiZuWZvO/EzaEtFt5ztUdecJEdBoWdTBi5fvE1RyO/zwA4q
         L/43idHs/7qP0Ph292HIt6P4slCDb2UlNu5dTyeFH/U7Mo/GFmcBSjAOPPuaRPybwICy
         t7QXoh5VAug70Veelhkm/QOWoIhuUCfTqAJnx9MtJT/hgOEBu8FAw/Osi4L6PAQUVud2
         QmMieWtzGbmpKifrM0xAf/rGaBT8ddxZ6SeE8AsEpCyfppKDii+srQ4A4+yM+GsOKUD2
         P5sVGTEbpn+mKL/wqi/IiEtEI/hxW6WjbZN4nAXfSwyWl0kEB3yJcfOQtap1IXPAMoye
         VrKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738013624; x=1738618424;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rDc9oon22Zy8JtV6oJyK3eShWNaKTPBJnRLwhRmq6mE=;
        b=g6U4O6rxQVw+MjBYJ+gzMG9KwDo90aZbS7R5+14vrcSLQzwBdVPZdQtuGptgffeEmN
         7XZOD9zU+iYhVyx5bPPX3Mq9StTGCdkFXdWYXyDJixUoBdR5ASYw2yKxDLzK2+zVkWXk
         qCY4arLGKHx8qW4Wcalo7dA+yIBewjBIhLL8YA4GQlesA2ZdInq6dQi2ld+yoGkxkRHE
         /7Spvx+4WrIx7JlJOJv6ojPY6Aklnhjnv1pCR+z75G/EZbSEpJKKFnOuzvG5igxESISW
         3PIkxS35Bvk+fE7DvFvyhJmZW/7FDzNVkNMYVytqEUTfPRJEJzblXM2gO4xMmZzpubvD
         3UIQ==
X-Forwarded-Encrypted: i=1; AJvYcCVn1OjxHbJgEr3k5IcjFISPT/+S+80E/2Ud1F/9K31h4W2cS0sbRdWxyKyt7uJF/KYpMmChD9slDY9G7Qwf@vger.kernel.org
X-Gm-Message-State: AOJu0YwbkPWXkuD5FomdncvfYtNfNUCv9KN+sKlWXD6g4XAQ8F7iLWU/
	vv9vkmNGgUYV3Ip9kPIkeB+T5xfz3dyeUemU3/cWcAunc9paM8JlWbQbZglAbSpDWRhLRD8gRA=
	=
X-Google-Smtp-Source: AGHT+IEfHevdTTJtb6AigZBRpVD2FnhyEzVTYMnATEtYpNkPmzEcW9Tro1KWiXPv1Vj43sJ3+gY4o9DCZA==
X-Received: from pjbqo13.prod.google.com ([2002:a17:90b:3dcd:b0:2f4:47fc:7f17])
 (user=wnliu job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2808:b0:2ee:5edc:4b2
 with SMTP id 98e67ed59e1d1-2f782cc0114mr60880084a91.20.1738013624271; Mon, 27
 Jan 2025 13:33:44 -0800 (PST)
Date: Mon, 27 Jan 2025 21:33:10 +0000
In-Reply-To: <20250127213310.2496133-1-wnliu@google.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250127213310.2496133-1-wnliu@google.com>
X-Mailer: git-send-email 2.48.1.262.g85cc9f2d1e-goog
Message-ID: <20250127213310.2496133-9-wnliu@google.com>
Subject: [PATCH 8/8] arm64: Enable livepatch for ARM64
From: Weinan Liu <wnliu@google.com>
To: Josh Poimboeuf <jpoimboe@kernel.org>, Steven Rostedt <rostedt@goodmis.org>, 
	Indu Bhagat <indu.bhagat@oracle.com>, Peter Zijlstra <peterz@infradead.org>
Cc: Mark Rutland <mark.rutland@arm.com>, roman.gushchin@linux.dev, 
	Will Deacon <will@kernel.org>, Ian Rogers <irogers@google.com>, linux-toolchains@vger.kernel.org, 
	linux-kernel@vger.kernel.org, live-patching@vger.kernel.org, 
	joe.lawrence@redhat.com, linux-arm-kernel@lists.infradead.org, 
	Weinan Liu <wnliu@google.com>
Content-Type: text/plain; charset="UTF-8"

Since SFrame is considered as reliable stacktrace, enable livepatch in
arch/arm64/Kconfig

Signed-off-by: Weinan Liu <wnliu@google.com>
---
 arch/arm64/Kconfig | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 100570a048c5..c292bc73b65c 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -271,6 +271,8 @@ config ARM64
 	select HAVE_SOFTIRQ_ON_OWN_STACK
 	select USER_STACKTRACE_SUPPORT
 	select VDSO_GETRANDOM
+	select HAVE_RELIABLE_STACKTRACE if SFRAME_UNWINDER
+	select HAVE_LIVEPATCH		if HAVE_DYNAMIC_FTRACE_WITH_ARGS && HAVE_RELIABLE_STACKTRACE
 	help
 	  ARM 64-bit (AArch64) Linux support.
 
@@ -2498,3 +2500,4 @@ source "drivers/acpi/Kconfig"
 
 source "arch/arm64/kvm/Kconfig"
 
+source "kernel/livepatch/Kconfig"
-- 
2.48.1.262.g85cc9f2d1e-goog


