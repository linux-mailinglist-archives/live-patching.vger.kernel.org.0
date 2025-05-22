Return-Path: <live-patching+bounces-1454-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B4D1AC15AA
	for <lists+live-patching@lfdr.de>; Thu, 22 May 2025 22:52:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 102A81BC3F76
	for <lists+live-patching@lfdr.de>; Thu, 22 May 2025 20:52:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0AA4424BD0C;
	Thu, 22 May 2025 20:52:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="YK1QFmJP"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86F4324BC14
	for <live-patching@vger.kernel.org>; Thu, 22 May 2025 20:52:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747947143; cv=none; b=kjsGgzctA9rFL/rkWo22TNAp64f3lNJXmsREQyQxaTOM//jPi4beQw7DrAniiPNHHupbFmrvKbxhM2vB5Ol8FfUR8kwUC7PH9qH/hvivwQoBuM2lz7W8u+Xbrn/AdfAD5PYuF12U0IbyKSif0vlUBQ7oLXFiESlYat/8KEn6xo4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747947143; c=relaxed/simple;
	bh=tbPJgSIr/YhJdBnyaqqp97VKp6bOrOObJg8YK6VTBt4=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=XJ0305BC1kXLIwuVuAPZopX4GGWUtHpVP6tJtNKLTMe0mG9+k265D/8hSA0rPgrLHAT5VVOLDP2LfujsRfOByOOPT1lrvYFoBQAB7eccbXvkTy7CSgEe8hQm8aMFlryfoiCp1WWi0FbqsVXeQSHwNblC/561SsmwszcomO5+vMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--dylanbhatch.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=YK1QFmJP; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--dylanbhatch.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-742c9c92bb1so4512390b3a.3
        for <live-patching@vger.kernel.org>; Thu, 22 May 2025 13:52:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747947142; x=1748551942; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=lh/Utffd02T/FBnV2lu48AGTTpPeHOAZMAviTbyobKM=;
        b=YK1QFmJPDKMdQSrADzvhMdZ1/XRJ4nRDgNBQlaZiqguD53+vToFWQ1nXwgIvIdDJz2
         om5Xzh4G4/km3DowOrGy5uPgXVKsAGGI+6bdWLGYc+Q9BoXywksSA1RSRg4aSObzXvln
         64wYOAopd3bB6NnJ83Xg0tBlg3vkqC2JWnWbWUl6W+7HFrEhzkib/cPaMwkaFLzOXbCk
         FiQKPFTjhNtu9e1uzWQDVOqcDDzL18wviRDBJGA2FTdegFSN31OYWYKFl2A2vIaKxLqy
         wmve2P2vYksb4kWebt5cWgpnWlvHLY5rAxZIG3B57Qp7uAJiOnOTrEFqV409doJ5C84/
         ZmKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747947142; x=1748551942;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lh/Utffd02T/FBnV2lu48AGTTpPeHOAZMAviTbyobKM=;
        b=U678Zwz3MsH8pX3ax2oQDp+nC+XkdZllkJ94SrscMa/+hsLIFTf/R6VodvT0Job3N9
         dXgKhIQL57A+vjFedIL/ztJWmKKbwBf6GFvDxS/orMpWaRV1FoQx1J2BKLRvTDSEj5zi
         aL4ynAOV/0L2g4GX0XgDB7Al0sp4Ad3S9APnNvMfnBLfn+WyrhnBg+1nOZXxdRwfL24U
         YJKYJyJ/88ru7/36D2IPfPKvid4PTCQBo+HRD1Hjc3MGe1krLwl2mhclt4fsRkOVnGHA
         n9kuFwY7VhWyga3sUlHBENqDN3Z5Xy0Wi/p2so/P4MnpzcMc0QwlWJSgG8KMMh4uhFXw
         3byg==
X-Forwarded-Encrypted: i=1; AJvYcCXQT+J+TkOQ9xcWUj5qa11NlTCy9zGjCyHzecgiME72sB8reB41FZRYlaqhlifn4qhmVuk9i+w2TWFhljrM@vger.kernel.org
X-Gm-Message-State: AOJu0YwJRiRHD6hHH8FE4JkyW9ZmKVvoDQ9Tq7f04jpiW8CnT75EFT70
	796+ElRWksdPVRou0GIcPX0IrmSTMTUXCug8zYWxg7HXyP5+HLYIDs7oa0mR+nwR1SUM0QmHLiF
	tp2eEh72BxH+6z2IYg8xpA5LXYA==
X-Google-Smtp-Source: AGHT+IGaQtir2ZcxSVyI64xvDdmjTxVFWoE0lsudMVLTodH3E4q06fZUd41aCTAVUHFHXDY94DC0IVeURvd0KoYhEA==
X-Received: from pfbgm7.prod.google.com ([2002:a05:6a00:6407:b0:741:8e1a:2d09])
 (user=dylanbhatch job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a20:6a22:b0:216:1476:f71 with SMTP id adf61e73a8af0-2187a6f5113mr342227637.39.1747947141756;
 Thu, 22 May 2025 13:52:21 -0700 (PDT)
Date: Thu, 22 May 2025 20:52:03 +0000
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.49.0.1151.ga128411c76-goog
Message-ID: <20250522205205.3408764-1-dylanbhatch@google.com>
Subject: [PATCH v4 0/2] livepatch, arm64/module: Enable late module relocations.
From: Dylan Hatch <dylanbhatch@google.com>
To: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Josh Poimboeuf <jpoimboe@kernel.org>, Jiri Kosina <jikos@kernel.org>, 
	Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>, 
	Joe Lawrence <joe.lawrence@redhat.com>
Cc: Dylan Hatch <dylanbhatch@google.com>, Song Liu <song@kernel.org>, 
	Ard Biesheuvel <ardb@kernel.org>, Sami Tolvanen <samitolvanen@google.com>, 
	Peter Zijlstra <peterz@infradead.org>, "Mike Rapoport (Microsoft)" <rppt@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Dan Carpenter <dan.carpenter@linaro.org>, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	live-patching@vger.kernel.org, Roman Gushchin <roman.gushchin@linux.dev>, 
	Toshiyuki Sato <fj6611ie@aa.jp.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"

Late relocations (after the module is initially loaded) are needed when
livepatches change module code. This is supported by x86, ppc, and s390.
This series borrows the x86 methodology to reach the same level of
support on arm64, and moves the text-poke locking into the core livepatch
code to reduce redundancy.

Dylan Hatch (2):
  livepatch, x86/module: Generalize late module relocation locking.
  arm64/module: Use text-poke API for late relocations.

 arch/arm64/kernel/module.c | 113 ++++++++++++++++++++++---------------
 arch/x86/kernel/module.c   |   8 +--
 kernel/livepatch/core.c    |  18 ++++--
 3 files changed, 84 insertions(+), 55 deletions(-)

-- 
2.49.0.1151.ga128411c76-goog


