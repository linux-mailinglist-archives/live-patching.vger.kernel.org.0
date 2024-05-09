Return-Path: <live-patching+bounces-260-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 365FC8C0E8B
	for <lists+live-patching@lfdr.de>; Thu,  9 May 2024 12:51:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 618F51C21FEE
	for <lists+live-patching@lfdr.de>; Thu,  9 May 2024 10:51:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E578130487;
	Thu,  9 May 2024 10:51:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="S4cL7h2J"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AF7812FB3F
	for <live-patching@vger.kernel.org>; Thu,  9 May 2024 10:51:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715251882; cv=none; b=izoEDI2f16OFkmWXJOb9R7OMvzzAIrtQhQqHlfsa/cpnavh0mPjITwnUCCHeha0XPgJpW3mcOgCJPoiBwC66P38NcH9s9t4wYqsOYVOw03kYknsb3tt7AQtAPMBO4FebuKRj85oJ37J+izoYJqkcbQV8h6WrkZHdKQp1a62oTAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715251882; c=relaxed/simple;
	bh=90Hq0FSuA9ZwYovzuyW3D43JnFMBkUN7xgexPFOARJk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=r4faFnaE4qxSXwDt5vFucFJBcqj3W/bIYoMh1ojk4km9Uqre/h1J3/oTSpS0skdH4hT4+7AevS3tZoa3Fwc3YRng6G1NCbJdyWc0x5xFru8U1oNnJApicb+APaohKaVyVpV8STziKGkOAb4TgJ2lBUlCFEes7jmZmdBEVX4RZeQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=S4cL7h2J; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-41fd5dc0508so2509685e9.0
        for <live-patching@vger.kernel.org>; Thu, 09 May 2024 03:51:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1715251879; x=1715856679; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=7PE/w319+RnELVg/gttqAl5h4DHnf11FqXh6NU9c/KU=;
        b=S4cL7h2JTk0xb5xa1UspiAejzejoNfWseBcmUewD1U1CXgUcA6fMQf/2teJgR1ljQq
         qw2lEyhBFIcm4CfxN7hovItFNmfD3tB178AAZe0N6ZkBI8yqSniFFZxR2IqoVdVM/pkO
         H1DIBRB1ieb52pUkC/rGMg4lK9gD7ELValZc7eVkdnAS8UkViLc1d+BmoHZsE4wTKwr9
         uZDEFDmWmL1z8UJdtkNLfYgE16yNnp92G+2W5AGXIJuGjW4lbOFDLB+8Hm04DEJrrSOw
         pV75MXEZrCjVEEW1ztNghmzD/zmeEo+xV6vkKRw8aa5xwWbZyjk1aexUPTp34esdCKAk
         Ffjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715251879; x=1715856679;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7PE/w319+RnELVg/gttqAl5h4DHnf11FqXh6NU9c/KU=;
        b=iAs25FCD1pNX88gauju9VV+3MuS/89GTTusLPD4uXOAPYRU7s/pnlICr6eF5NQHpsi
         Xt6MYUeR1xsv0UwBlbAR1qi7m21fSoa3rJkLdXS1Og8PeVF+odacV3XxEG7Ra4cQDUkl
         tb5w1MaQDKF6qsYiKyAsNJplFyWjX2IY48CQzmR6A+h3cHXakdIMY8SZlG2F7JfzJNyj
         hB21mWFWIebU+jyPrGFbsEUEN0TsJzMAIoCWwLNji8JJbQ42/vsg3dq1twhvO+zV+WiC
         K2mYEWgbvODaxFel3Ds6a2a+WNwUX0oXukZr3MsZj9BW3+Z/ngizqUL+FunEYlfirNOc
         jZRw==
X-Forwarded-Encrypted: i=1; AJvYcCWg+vcIxhyqIpuRDZmdhX3VH3egnL9rZXTKMZVnMHLvD3OH2f1K7ROOipF/9dL98S0g5SWnkVnk5VvbGswnCk+mVsk5lV3Ex2oJzDF6IA==
X-Gm-Message-State: AOJu0YwOtSjr0c27pBR5/msNwSgEDE2tw0j21zz+j8hSqEwiifN624UN
	46CrG47Mq8g+0f08Rkfd1GGyMLUv8m5OfI4EUh2m6ey83E8WqcGKtmUWZMkYwS8=
X-Google-Smtp-Source: AGHT+IEyXDNBNsqAW1Z0YapSRbxhJ9/MFwmOUaz8zNaFt9G3InR6MOt+Opgve1XuXDXYfNwOYiy41A==
X-Received: by 2002:a05:600c:3c83:b0:419:ec38:f34b with SMTP id 5b1f17b1804b1-41f714f6ea8mr39308995e9.20.1715251878877;
        Thu, 09 May 2024 03:51:18 -0700 (PDT)
Received: from pathway ([176.114.240.50])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3502b79bd09sm1378238f8f.14.2024.05.09.03.51.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 May 2024 03:51:18 -0700 (PDT)
Date: Thu, 9 May 2024 12:51:17 +0200
From: Petr Mladek <pmladek@suse.com>
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: Yafang Shao <laoar.shao@gmail.com>, jikos@kernel.org, mbenes@suse.cz,
	joe.lawrence@redhat.com, mcgrof@kernel.org,
	live-patching@vger.kernel.org, linux-modules@vger.kernel.org
Subject: Re: [PATCH v2 2/2] livepatch: Delete the associated module of
 disabled livepatch
Message-ID: <ZjyqpXES5cHOl1Mg@pathway>
References: <20240407035730.20282-1-laoar.shao@gmail.com>
 <20240407035730.20282-3-laoar.shao@gmail.com>
 <20240503211434.wce2g4gtpwr73tya@treble>
 <Zji_w3dLEKMghMxr@pathway.suse.cz>
 <20240507023522.zk5xygvpac6gnxkh@treble>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240507023522.zk5xygvpac6gnxkh@treble>

On Mon 2024-05-06 19:35:22, Josh Poimboeuf wrote:
> On Mon, May 06, 2024 at 01:32:19PM +0200, Petr Mladek wrote:
> > Also it would require adding an API to remove the sysfs files from the
> > module_exit callback.
> 
> Could the sysfs removal be triggered from klp_module_going() or a module
> notifier?

Great idea!

> > I do not see any reasonable reason to keep the replaced livepatch
> > module loaded. It is an unusable piece of code. IMHO, it would be
> > really convenient if the kernel removed it.
> 
> User space needs to be polling for the transition to complete so it can
> reverse the patch if it stalls.  Otherwise the patch could stall forever
> and go unnoticed.

Triggering the revert and removing the module are two asynchronous
operations. User space might just trigger the revert when it detect
the stall and assume that the module will get removed.

Stalled revert is end of the game anyway.

> Can't user space just unload the replaced module after it detects the
> completed transition?
> 
> I'm not sure I see the benefit in complicating the kernel and possibly
> introducing bugs, when unloading the module from user space seems to be
> a perfectly valid option.
>
> Also, an error returned by delete_module() to the kernel would be
> ignored and the module might remain in memory forever without being
> noticed.

The same error would happen even when it was called via the syscall.
It is the same code.

Well, user space might want to know when the module was removed.
For example, it could not load the same livepatch module until
it was removed. Explicit rmmod would be useful in this case.

I agree that adding the auto deleting might create new problems
and probably is not worth it.

Best Regards,
Petr

