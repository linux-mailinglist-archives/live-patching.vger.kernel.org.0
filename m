Return-Path: <live-patching+bounces-1356-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B21AA8478F
	for <lists+live-patching@lfdr.de>; Thu, 10 Apr 2025 17:17:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ACC6F8A3C65
	for <lists+live-patching@lfdr.de>; Thu, 10 Apr 2025 15:17:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EFB811E5B93;
	Thu, 10 Apr 2025 15:17:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Y3MQp1cb"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15A1314884C
	for <live-patching@vger.kernel.org>; Thu, 10 Apr 2025 15:17:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744298249; cv=none; b=YpY9WdfAm6Nh9k0qqaTB5j97JlRDHLLT0lUcPNa87qGAgf8mOuTMqNX8KF7TR4n7y1jkyGBM4xvZP6F1jqGCynhakzGDsISRvjrXMtIu8ZfY1kqHiIDgInQ2tEHeReNgw18PSNL62opO2nxDANPacG0DpH36clQzS1ujVw/5xpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744298249; c=relaxed/simple;
	bh=hLk6XTKcmMABoUGjVeKBYfaEJiteVf593gjpM78Fd2s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oMkjlBknbrKBwByYiuozz+ZQaxPkOGutsE9lj6V2I89P5fyeHwn7amk8/FjAkQSmWmBwtkGIFdt9zX3lVoLQqDPUZ/v3n4PgJZQQzaAY8R9gNVF3c6q1AG0BagDK0RDodxSiA31XN4jdEiF/dAYaw2e1uQX5eLaY4W+y9+VWOTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Y3MQp1cb; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4394a823036so9686295e9.0
        for <live-patching@vger.kernel.org>; Thu, 10 Apr 2025 08:17:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1744298245; x=1744903045; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=f6cj/et3tJLOi8nZABzE1bZ8So47tTX91IayHIgQTo4=;
        b=Y3MQp1cb2Mc+wnp9DYt3+gTXVATPrVfdmgxgdIBd6HnHKn81edOxIdLyQBw9XkI/MA
         X5Z6jp0hR3/7UtliArk2HJPIFqFnjoCdWyBK+ATL7VhItipOQygwcB9/HNdC20q8iDV4
         nhTReiEPieyX/mjWs3c8Nyc/sgqP7UiY53VwT0xgMzyzlWrjuXrZOBELZPGzr/MFf2AX
         QeOga/oPDJSFAWZeM9Al1TjE3dr2thJU3Fpl0z3vxfSR7pDIwGuCvBaV93pWJgtgSTjr
         EnAs3ULgxXvJvoBzyF3X9lcrl9hvjQ0bjP19H3kww2p0vu/zYCSwch+WecbKIyn4na8Z
         YMXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744298245; x=1744903045;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=f6cj/et3tJLOi8nZABzE1bZ8So47tTX91IayHIgQTo4=;
        b=dwflGGuPkl7emdn17XX2es16bbxQgKJ/EofqGVy/ZTGc4FDg0k120LNIKbVSKvWKxA
         sviAaIW2EOhXQ6iTrQdXrMym73DOwVd9pjmoKVYi124suI8Ns+yxVcf3y/t21hS5zdmF
         Op+Q4s/tE7kCj7bsWOhuvBAHhdEyeocMPZJChHptEddKsrUNGIDZqh7HqS4kcaVOGZIl
         HLreNSnr8lWUNrCBPNHPYecpDPoyBa9k2Ptg2Kt8xoYThIqbxZCCx1BMkYtLANo8rKt9
         UJxpvtjujyLuac97aIAmp7d8Os276bnUFDIEt1AXWW9qQhIP53tbsIWOQ9l4fzIGJv5p
         7Rlw==
X-Forwarded-Encrypted: i=1; AJvYcCV5KbrsMVzZR7R36acCihIcP0B9Aehv3GR99tA901m18kWfPZqnRDiny0cHC0BftVyVRmyrpZ8YQ6bTg+ak@vger.kernel.org
X-Gm-Message-State: AOJu0YyGSMovgX7XfgXcSJEPua2EZGIsrge32+gUwsKzbuajsOxWvKe5
	Ev44erpVmZmm1TkwHL3AI8bIlLZcEk4l0y+XC+TTGgt0bVftcgg1IYMCfVOI0xI=
X-Gm-Gg: ASbGncvOHflgCh5YJpTa8jwUmT8o6SrIk5+LD4GpwXeBBeinjNzeZPIOQsUX0qs+OmF
	xm4+ZR4rQFEqVRVZo54pNvtMGRBekBDuRlWtIx49wcjir9xFFNkyMw+n0S/I6CMmWvzfZMO0aZj
	4zVmTiuXwkNQx3kSgi0QSAIOR3NuJSOGbazNVgBzlVUWd6WUeJioS5ORUk3wIvCGxw3r2a28Cx2
	MvzE4W8Qf5wTOvz/3xw7P4BECCH+oL4/jDo+gpSO+5gSvTf/XEMZ0LM4wIDAivkP2stXv4yp/c6
	uq1QbznQZEyNbqpQR5xBwFoqZoHeTo3U+QbwEkukxDKpBjKWhs5xbw==
X-Google-Smtp-Source: AGHT+IG+NzZVvrmsCa4ZlEdd9DFX82PR77L8xEbBogXJLZfgAsJhybLCQSoboxlSlXUt/tEoUyKrwA==
X-Received: by 2002:a05:600c:5023:b0:43c:f87c:24d3 with SMTP id 5b1f17b1804b1-43f2d9529aemr28961245e9.20.1744298245314;
        Thu, 10 Apr 2025 08:17:25 -0700 (PDT)
Received: from pathway.suse.cz ([176.114.240.130])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43f20625eeesm58156015e9.11.2025.04.10.08.17.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Apr 2025 08:17:24 -0700 (PDT)
Date: Thu, 10 Apr 2025 17:17:23 +0200
From: Petr Mladek <pmladek@suse.com>
To: Song Liu <song@kernel.org>, mark.rutland@arm.com
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-toolchains@vger.kernel.org, live-patching@vger.kernel.org,
	indu.bhagat@oracle.com, puranjay@kernel.org, wnliu@google.com,
	irogers@google.com, joe.lawrence@redhat.com, jpoimboe@kernel.org,
	peterz@infradead.org, roman.gushchin@linux.dev, rostedt@goodmis.org,
	will@kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v3 0/2] arm64: livepatch: Enable livepatch without sframe
Message-ID: <Z_fhAyzPLNtPf5fG@pathway.suse.cz>
References: <20250320171559.3423224-1-song@kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250320171559.3423224-1-song@kernel.org>

On Thu 2025-03-20 10:15:57, Song Liu wrote:
> There are recent efforts to enable livepatch for arm64, with sframe [1] or
> without sframe [2]. This set tries to enable livepatch without sframe. Some
> of the code, however, are from [1].
> 
> Although the sframe implementation is more promising in longer term, it
> suffers from the following issues:
> 
>   1. sframe is not yet supported in llvm;
>   2. There is still bug in binutil [3], so that we cannot yet use sframe
>      with gcc;
>   3. sframe unwinder hasn't been fully verified in the kernel.
> 
> On the other hand, arm64 processors have become more and more important in
> the data center world. Therefore, it is getting critical to support
> livepatching of arm64 kernels.
> 
> With recent change in arm64 unwinder [4], it is possible to reliably
> livepatch arm64 kernels without sframe. This is because we do not need
> arch_stack_walk_reliable() to get reliable stack trace in all scenarios.
> Instead, we only need arch_stack_walk_reliable() to detect when the
> stack trace is not reliable, then the livepatch logic can retry the patch
> transition at a later time.
> 
> Given the increasing need of livepatching, and relatively long time before
> sframe is fully ready (for both gcc and clang), we would like to enable
> livepatch without sframe.
> 
> Thanks!
> 
> [1] https://lore.kernel.org/live-patching/20250127213310.2496133-1-wnliu@google.com/
> [2] https://lore.kernel.org/live-patching/20250129232936.1795412-1-song@kernel.org/
> [3] https://sourceware.org/bugzilla/show_bug.cgi?id=32589
> [4] https://lore.kernel.org/linux-arm-kernel/20241017092538.1859841-1-mark.rutland@arm.com/
> 
> Changes v2 => v3:
> 1. Remove a redundant check for -ENOENT. (Josh Poimboeuf)
> 2. Add Tested-by and Acked-by on v1. (I forgot to add them in v2.)

The approach and both patches look reasonable:

Reviewed-by: Petr Mladek <pmladek@suse.com>

Is anyone, Arm people, Mark, against pushing this into linux-next,
please?

Best Regards,
Petr

