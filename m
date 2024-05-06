Return-Path: <live-patching+bounces-240-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 744618BCDB2
	for <lists+live-patching@lfdr.de>; Mon,  6 May 2024 14:22:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7F6BFB24B02
	for <lists+live-patching@lfdr.de>; Mon,  6 May 2024 12:22:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 87BBD145B29;
	Mon,  6 May 2024 12:20:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="CPAEHGgf"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-lj1-f182.google.com (mail-lj1-f182.google.com [209.85.208.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 377AA145B15
	for <live-patching@vger.kernel.org>; Mon,  6 May 2024 12:20:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714998007; cv=none; b=Jg5fJaC8peBo0wfptjhX2p/uHEtM2Tmvik96tEQTOqD8x73Xo3CVDNdXLOivnD2BwMw/oNfnoeW8LaeDNu7iXQ3d3H452FCCh8ncpJX+6qPRGR9fAmETXzWr1JhR+v+6SNQZMdPBjFiR1S9lkbzH37k8p5BSUfpFQtMw//JNOBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714998007; c=relaxed/simple;
	bh=mAArmLgHTbc9SDFQvrexkAIxKimEX/Y8Xw9iVm0GwGo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BwK59OQglgleaaZUiIKhYPbhJJHEeRJA4B5z/0FGFHtY12OlJ2BSNHhBIbnlBLVyGEqSEOt9+V7HwSBUg7xZIL4L/LFVCHNSgwRAJG+zuNTWjAloKJhp+oYl+HzoaVZ8Xam6gN+CEmBpiErE1uoKvIjIoFXodXiNv68Ln0l9WgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=CPAEHGgf; arc=none smtp.client-ip=209.85.208.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-lj1-f182.google.com with SMTP id 38308e7fff4ca-2e1fa824504so27126191fa.0
        for <live-patching@vger.kernel.org>; Mon, 06 May 2024 05:20:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1714998003; x=1715602803; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Q0GlYR+L5nTi5e9ZOfLlEo/HVKT0hHUI331HkA0aFhE=;
        b=CPAEHGgfbq+4Wi3rpHtmP+ReWa0wu1M5Qs9f1zrJKiykI97hiZf4/Eo2+uhIBtv7ce
         TvpZHVt7mwXeg4dDa3IbW1CynAJk9sLAldqA8B2QkFoFCrBpXsPgtzWym+GGxUb+cZzH
         rG8PN+cjrTdyxpTUfzuDkwT8iZNoSFYjcUbtp+MXb6yKyxpZ6Fq1Xmz2bVEI9T2h/J7S
         zij+PNlF2XSdj106Qdkmlrq6a6e8afRkhbBTeJkgNPFl4Bljfev9//OiPZTVL3InbrP/
         oRKjCtCjKqe28Dhz46IL1LwCCZzwOpq7FZYZHkVKNUViVO528wTTkZpgh4BlJAP88t5y
         +9Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714998003; x=1715602803;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Q0GlYR+L5nTi5e9ZOfLlEo/HVKT0hHUI331HkA0aFhE=;
        b=YaD3uTnpeb4uYQ5DC1/J+sbMopdjfU1TdtXzXzaozxDxOhfO8gLmb7Sax9dXdc/aS2
         Ly1+yR70Rm5qnsLBOVRutRb82vBAO2XdI2pjUc1sqfmE+RTFg9WcZao/EaE7/1Giz/fA
         oCEYRCGdFx0MgFxE49KIt0VYPKukMVbeEBUZYh7kgWQp+r6hH7AOVpSEod0EPENfJSai
         zc7HHqLimHvEdzV3bCoC9WmXozEI/EaVqg1DjCXYzjaGY+v5J0B4lGvWKCNzQTgJ6Uoj
         JdxD2SSwJBA5eAZJjYg3N1sG3PixtSAZQ1C1WBthMishKBV2y4t3CCqjDxqmEFcibZX5
         is+A==
X-Forwarded-Encrypted: i=1; AJvYcCWOiZdwp+bnbfQcuGK8WQ1B6z80fYK+QvBCLBMpE6xwZ+U/No298gqhSoQ1th8fsufYKthdzWeART+NNkft2pBrvDOucsWBuWoz9TdrXw==
X-Gm-Message-State: AOJu0Yy1zpzAhHlRyokR/PARhwdPfhj+I+j2T5/BUyBQbjLWZ9k3abus
	RsaQkL6ZrB5va3hrKmjtPf6yW1KFLKdpFHhokJjQpVFQ0Iqj5zP8q3g8WCHjHHw=
X-Google-Smtp-Source: AGHT+IFivHHv483bejgmkPdh1hOw8Sz/YEF2pqRzorIuf/QT9TUUEOmSK/eUX+CRZo1gYLzRzyLOcQ==
X-Received: by 2002:a2e:3510:0:b0:2dd:bd92:63a with SMTP id z16-20020a2e3510000000b002ddbd92063amr6558634ljz.34.1714998003147;
        Mon, 06 May 2024 05:20:03 -0700 (PDT)
Received: from pathway.suse.cz ([176.114.240.50])
        by smtp.gmail.com with ESMTPSA id d10-20020a05600c3aca00b00418e4cc9de7sm19562575wms.7.2024.05.06.05.20.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 May 2024 05:20:02 -0700 (PDT)
Date: Mon, 6 May 2024 14:20:01 +0200
From: Petr Mladek <pmladek@suse.com>
To: Yafang Shao <laoar.shao@gmail.com>
Cc: jpoimboe@kernel.org, jikos@kernel.org, mbenes@suse.cz,
	joe.lawrence@redhat.com, mcgrof@kernel.org,
	live-patching@vger.kernel.org, linux-modules@vger.kernel.org
Subject: Re: [PATCH v2 2/2] livepatch: Delete the associated module of
 disabled livepatch
Message-ID: <ZjjK8ecESRtnHjLh@pathway.suse.cz>
References: <20240407035730.20282-1-laoar.shao@gmail.com>
 <20240407035730.20282-3-laoar.shao@gmail.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240407035730.20282-3-laoar.shao@gmail.com>

On Sun 2024-04-07 11:57:30, Yafang Shao wrote:
> In our production environment, upon loading a new atomic replace livepatch,
> we encountered an issue where the kernel module of the old livepatch
> remained, despite being replaced by the new one. This issue can be
> reproduced using the following steps:
> 
> - Pre setup: Build two atomic replace livepatches
> 
> - First step: Load the first livepatch using the insmod command
>   $ insmod livepatch-test_0.ko
> 
>   $ ls /sys/kernel/livepatch/
>   livepatch_test_0
> 
>   $ cat /sys/kernel/livepatch/livepatch_test_0/enabled
>   1
> 
>   $ lsmod  | grep livepatch
>   livepatch_test_0       16384  1
> 
> - Second step: Load the new livepatch using the insmod command
>   $ insmod livepatch-test_1.ko
> 
>   $ ls /sys/kernel/livepatch/
>   livepatch_test_1                  <<<< livepatch_test_0 was replaced
> 
>   $ cat /sys/kernel/livepatch/livepatch_test_1/enabled
>   1
> 
>   $ lsmod  | grep livepatch
>   livepatch_test_1       16384  1
>   livepatch_test_0       16384  0    <<<< leftover
> 
> Detecting which livepatch will be replaced by the new one from userspace is
> not reliable, necessitating the need for the operation to be performed
> within the kernel itself. With this improvement, executing
> `insmod livepatch-test_1.ko` will automatically remove the
> livepatch-test_0.ko module.
> 
> Following this change, the associated kernel module will be removed when
> executing `echo 0 > /sys/kernel/livepatch/${livepath}/enabled`. Therefore,
> adjustments need to be made to the selftests accordingly.
> 
> --- a/kernel/livepatch/core.c
> +++ b/kernel/livepatch/core.c
> @@ -721,8 +723,12 @@ static void klp_free_patch_finish(struct klp_patch *patch)
>  	wait_for_completion(&patch->finish);
>  
>  	/* Put the module after the last access to struct klp_patch. */
> -	if (!patch->forced)
> -		module_put(patch->mod);
> +	if (!patch->forced) {
> +		module_put(mod);
> +		if (!delete)
> +			return;
> +		delete_module(mod);

We should check the return value and report an error.

> +	}
>  }

Otherwise, it looks good to me.

I am personally in favor of this change. It removes one step
which otherwise has to be called from userspace after a non trivial
delay. The transition might take seconds.

It should simplify the scripting around livepatch modules handling.
It might reduce the need to over-optimize transition times.

Best Regards,
Petr

