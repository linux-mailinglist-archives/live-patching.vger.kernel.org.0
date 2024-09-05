Return-Path: <live-patching+bounces-611-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F58C96DFA7
	for <lists+live-patching@lfdr.de>; Thu,  5 Sep 2024 18:30:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EDC791F21DC9
	for <lists+live-patching@lfdr.de>; Thu,  5 Sep 2024 16:30:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B67F61A01C9;
	Thu,  5 Sep 2024 16:30:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DcHbhQaR"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FC1A1A01C4;
	Thu,  5 Sep 2024 16:30:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725553810; cv=none; b=gPSnk6wkWfmZpwPykdc3d8R9tePJVkbwsFCHPn0Dh37tIqc3/U2OfVvqQOfUTdGdn5NvZ8PN9gd16lZEgp319/E2Kz3y/1olfl8axGW5YsyVuhOPm6pkyOHQHPPYqPLVsYT73SmVVkuQBO46Zdj326Z9Rx9Nh/NZa2xJMcDvt6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725553810; c=relaxed/simple;
	bh=GqVOC0GMXs7NGw5ABXco7veHYyALr0nKN7/CFsvIxNE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CO71ykuIrbE4FbP30NljsyL1yj7ISzRX5DygcEydd4vZTD8dl0yo04caufq4wfizdT1mTJiEP4ciDnDA5D9GgHjQTHYHiT0PZZeVzpP0H3TTjmDdKfGemw6VW/7eg2e7p29G7Xk1xii7gqzsS+kSVC/tnCAVBWvrVEuYGCujunk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DcHbhQaR; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2449C4CEC5;
	Thu,  5 Sep 2024 16:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725553810;
	bh=GqVOC0GMXs7NGw5ABXco7veHYyALr0nKN7/CFsvIxNE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DcHbhQaR/KKsNa2OfBBKl64QAFtSHVVIQ6ueqIlm3bUmcBPofPbuRC9bVUqyufV+/
	 88dxsgtZ6pGpGFm9hrhPld6SZeGjTbbMkRFHVzSxg03Kcyn7iA96YGmql91BtgL1fi
	 KPyctGHD/a3W7R2Fas7b3JmLEEYQC9Iz+RkLt7tYIbfCUwRqYf4p89gqS7Edak1swS
	 bQ1GMVZubdhv6cJn9J4kkzq+jzZIlCGtrHiOSQHQXd8vnY0SKOm4CVV9MUtDdksy59
	 FASr/edXmjkKgtWgkb3QUEv/By0MooYHIOM8oYPeAHeZuL6kRp9UDmgni+MGJegLDw
	 UVTBIUBeLny8g==
Date: Thu, 5 Sep 2024 09:30:08 -0700
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: zhang warden <zhangwarden@gmail.com>
Cc: Miroslav Benes <mbenes@suse.cz>, Jiri Kosina <jikos@kernel.org>,
	Petr Mladek <pmladek@suse.com>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	live-patching@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 2/2] livepatch: Add using attribute to klp_func for
 using function show
Message-ID: <20240905163008.kjlavrw6k6eb6aqu@treble>
References: <20240828022350.71456-1-zhangwarden@gmail.com>
 <20240828022350.71456-3-zhangwarden@gmail.com>
 <20240904044807.nnfqlku5hnq5sx3m@treble>
 <AAD198C9-210E-4E31-8FD7-270C39A974A8@gmail.com>
 <20240904071424.lmonwdbq5clw7kb7@treble>
 <1517E547-55C1-4962-9B6F-D9723FEC2BE0@gmail.com>
 <20240904180648.fni3xeqkdrvswgcx@treble>
 <5B13628F-755E-4081-9E12-EB2F2441BBDF@gmail.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <5B13628F-755E-4081-9E12-EB2F2441BBDF@gmail.com>

On Thu, Sep 05, 2024 at 10:03:52PM +0800, zhang warden wrote:
> >>Here I can give you an example.
> We are going to fix a problem of io_uring.
> Our team made a livepatch of io_sq_offload_create.
> This livepatch module is deployed to some running servers.
> 
> Then, another team make some change to the same function and deployed it to the same cluster.
> 
> Finally, they found that there are some livepatch module modifying the same function io_sq_offload_create. But none of them can tell which version of io_sq_offload_create is now exactly running in the system.
> 
> We can only use crash to debug /proc/kcore to see if we can get more information from the kcore.
> 
> If livepatch can tell which version of the function is now running or going to run, it will be very useful.
> 
> >>>>>>
> What's more, the scenario we easily face is that for the confidential environment, the system maintenance mainly depends on SREs. Different team may do bug fix or performance optimization to kernel function. 
> 
> Here usually some SREs comes to me and ask me how to make sure which version is now actually active because tow teams make tow livepatch modules, both of them make changes to one function. 
> 
> He wants to know if his system is under risk, he want the system run the right version of the function because one module is a bug fix and the other is just a performance optimization module, at this time, the bug fix version is much more important. dmesg is too long, he find it hard to find out the patch order from dmesg.
> 
> With this patch, he can just cat /sys/kernel/livepatch/<module>/<object>/<function>/using and get his answer.

Thanks for the details, and sorry if I missed it before.  This would
have been helpful to have in the cover letter.

But again I want to stress that livepatching should be done with care.
Having different teams applying patches without coordination is not
recommended.  The teams' processes and/or tooling really need to be
improved.

> > Have you considered other solutions,
> > like more organized patch management in user space?
> 
> User space solutions seems unreliable. What we need is just the enabling version of target function. The order of livepatch module enable mainly from dmesg, which is easily flush away or being cleaned.

journalctl -b ?

> If we use an user space program to maintain the information of patch order, once the program is killed, the information is loss either.

Store the state in a file in /var/run?

-- 
Josh

