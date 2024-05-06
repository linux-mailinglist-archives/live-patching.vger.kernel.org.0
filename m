Return-Path: <live-patching+bounces-238-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A92768BCCD9
	for <lists+live-patching@lfdr.de>; Mon,  6 May 2024 13:32:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 494491F21913
	for <lists+live-patching@lfdr.de>; Mon,  6 May 2024 11:32:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3149E142E9D;
	Mon,  6 May 2024 11:32:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="SvMYI3Zi"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF399142E92
	for <live-patching@vger.kernel.org>; Mon,  6 May 2024 11:32:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714995145; cv=none; b=UKQGGXz36CV+/Kt60Vw7VGBaw5IvogbR080FSFf4j2YXmcI9bs9tYbOeMm/aHUsEVx6fdFBj2zE7WXqzcdByQl16CQ+vQMVmqz7a042Fl6WRcAqTZ2w2G8zXQG2Vk8NSba7RrXDydAcBYhooTWJq0+QVVlR4GViIbay3zzKcNMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714995145; c=relaxed/simple;
	bh=UsAT3fdEJRbzzFYK0R0HIYP1qe3OpTiz8oaTz8J3YWQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=U8HMtak/NmSd4fI1XHpCDwBGOdw0wO3eRs8lsqyzmO5X721SSpSzUVSCn29fdoH7APTao+bTqZepIenkE7mL5Z6cdPoh4P0qy3ZBUcuSIPL9OLJyyhEfF73MQ6eX8Q4rf/R/GuWoiNzOUx9jMrz5Y+rjRkQ5FUnlG+5gQkoamUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=SvMYI3Zi; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-41bab13ca4eso11612805e9.1
        for <live-patching@vger.kernel.org>; Mon, 06 May 2024 04:32:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1714995141; x=1715599941; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=kHsk2MezJWnperh/yf+/vw5OhP2I68/pUrRFYTCu/KU=;
        b=SvMYI3ZiCvV8U8esDG5HsA/dzkp3uMjrchJ9KkNZvYDc42W4ol9hGkohp++CVy3eJa
         ZhB+2wQS0arGv6ct1l/tDWZ6JQWdIj3o3CuxD5a9ZZ+gPtZV+cYQ3jA2yLo3fgTNlrnA
         qRTCi4azzFBK3FDaRWqvMH/7+va6AOFw+QZCxyTW4QBSEHppBOMW81klirni3X90alW5
         Dqujb9ZxaTGUHnOs4491QarU7G1UAcEEi8oKJJYAwq2WCN6XujWzGhGl+gLkU0HVsL5a
         epFUmJ8FiqJVNy6dJnT+puUsWvpreMXH+b0hWd3MheOOrzxm7nGZ2w3Omk0LRqlcEDNV
         FErw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714995141; x=1715599941;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kHsk2MezJWnperh/yf+/vw5OhP2I68/pUrRFYTCu/KU=;
        b=TTPcfju+PU5LvOi+aEgedUBbzcg9PXZtVnFxc+LVItkC2YTHiIO8dqbqQlla1C+SCf
         8FoxWrXd3O+Q4nQBodfmpV2/5angKg/4ofU/JtI2Kt3gCwpVzAHo1j7UcUCOrp9vSV/6
         AdvIE1uE6AEQguydIFUL8bzviDJBVnKpwCRdLCE+k324VcI2BelhjXPUgHRo8NnvYwMJ
         /5jx9M/Iu/gI6qWKKdYtrtmYXaHnP6Kn+OSY7o3Yce8000MMelL7hWAXPQvZz67txh1/
         XOSnKOrarUkUymVayidWernRtNMGpuNlX+jZNDHs/GKqKRqj9f/W/OgcbECD1JydrbaX
         tnLQ==
X-Forwarded-Encrypted: i=1; AJvYcCXmfGKratvESUQh2K/i9c+e25qWNJXWdA4dHAelsGEKusPr5zYqTrq8M5MGzwq2Qh9SrXFuZAr4li9Oor5ktDQtOEOPAj79VWIvNzy1tQ==
X-Gm-Message-State: AOJu0YxQ7XJo1QuZ7mb/gYoYt2i7MQ0VmzC+Nl1pV4YLYloWHEwI3a6w
	fvPxzXmuVq/eO9NxZEhA8pTD4o+mYnbqbiWRwxmJa1Ri9QnHDweZTk7CzqD9Twd3G9CpQEJEunS
	Y
X-Google-Smtp-Source: AGHT+IHbr6BRplyZBD6g6bchObjyaqmV/7Q2OVvgmD0JZcLmoFBrSwlDFLU6DpoqWr8KIGZLMLRNVg==
X-Received: by 2002:a05:600c:45cd:b0:418:f826:58c3 with SMTP id s13-20020a05600c45cd00b00418f82658c3mr8029030wmo.15.1714995141168;
        Mon, 06 May 2024 04:32:21 -0700 (PDT)
Received: from pathway.suse.cz ([176.114.240.50])
        by smtp.gmail.com with ESMTPSA id fc20-20020a05600c525400b00418accde252sm15684675wmb.30.2024.05.06.04.32.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 May 2024 04:32:20 -0700 (PDT)
Date: Mon, 6 May 2024 13:32:19 +0200
From: Petr Mladek <pmladek@suse.com>
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: Yafang Shao <laoar.shao@gmail.com>, jikos@kernel.org, mbenes@suse.cz,
	joe.lawrence@redhat.com, mcgrof@kernel.org,
	live-patching@vger.kernel.org, linux-modules@vger.kernel.org
Subject: Re: [PATCH v2 2/2] livepatch: Delete the associated module of
 disabled livepatch
Message-ID: <Zji_w3dLEKMghMxr@pathway.suse.cz>
References: <20240407035730.20282-1-laoar.shao@gmail.com>
 <20240407035730.20282-3-laoar.shao@gmail.com>
 <20240503211434.wce2g4gtpwr73tya@treble>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240503211434.wce2g4gtpwr73tya@treble>

On Fri 2024-05-03 14:14:34, Josh Poimboeuf wrote:
> On Sun, Apr 07, 2024 at 11:57:30AM +0800, Yafang Shao wrote:
> >   $ ls /sys/kernel/livepatch/
> >   livepatch_test_1                  <<<< livepatch_test_0 was replaced
> > 
> >   $ cat /sys/kernel/livepatch/livepatch_test_1/enabled
> >   1
> > 
> >   $ lsmod  | grep livepatch
> >   livepatch_test_1       16384  1
> >   livepatch_test_0       16384  0    <<<< leftover
> > 
> > Detecting which livepatch will be replaced by the new one from userspace is
> > not reliable

BTW: we handle this in rpm post install script. It removes all not longer
used livepatch modules before installing the newly installed one.


> > , necessitating the need for the operation to be performed
> > within the kernel itself. With this improvement, executing
> > `insmod livepatch-test_1.ko` will automatically remove the
> > livepatch-test_0.ko module.
> >
> > Following this change, the associated kernel module will be removed when
> > executing `echo 0 > /sys/kernel/livepatch/${livepath}/enabled`. Therefore,
> > adjustments need to be made to the selftests accordingly.
> 
> If the problem is that the user can't see which livepatch has been
> disabled, we should just fix that problem directly by leaving the
> disabled module in /sys/kernel/livepatch with an 'enabled' value of 0.
> 'enabled' could then be made read-only for replaced files.

I agree that it might remove the race. We must make sure that the
value is false only when the module can be removed. Also it would
require adding an API to remove the sysfs files from the module_exit
callback.

> That seems less disruptive to the user (and more consistent with the
> previous interface), and continues to leave the policy up to the user to
> decide if/when they want to remove the module.

I do not see any reasonable reason to keep the replaced livepatch
module loaded. It is an unusable piece of code. IMHO, it would be
really convenient if the kernel removed it.

It would be a new behavior even for the module loader. But we could
see it as a version upgrade of a kernel module.

> It would also allow easily downgrading the replaced module in the future
> (once we have proper support for that).

Sigh, I still havn't found time to prepare v2 of the patchset
reworking the callbacks.

Best Regards,
Petr

