Return-Path: <live-patching+bounces-598-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id EDCA196C5F4
	for <lists+live-patching@lfdr.de>; Wed,  4 Sep 2024 20:06:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5ABDCB20BD0
	for <lists+live-patching@lfdr.de>; Wed,  4 Sep 2024 18:06:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5CF811E0B8C;
	Wed,  4 Sep 2024 18:06:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="b8JXFX58"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3208D2AE9F;
	Wed,  4 Sep 2024 18:06:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725473211; cv=none; b=jFycqlN7hNX63MTbpWHBUfDrKZ8oEzwoXNlWgcATKGV5515oNxibx1kgosd3V9ZigX8Y4N7eXq83INC4XoEbIUij2h7Je827+t+s0yyEzUBehdvoG2Pj3ZWMZHQM6vi9HwblkbT6nPgcCI4c/MYOpicXRIUK8C/A4hHU/ioICfI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725473211; c=relaxed/simple;
	bh=ummQraPGr12Rbrv+T6vWh69Bxy+GGS3bvVUkuPzUlmU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tfQzcJOU0rm9NAfEBr30kYf/uNlyPcSoSnr3ayN9nHCmAAyDlo6HsaSrLv80qqGfbJLDdRIKVEU6D/fsoOxmyyfab4kh3t6wZzwN4O8WuLmTzB2VCeyx60BilTbAhrk7uevWCE95TqpyqDroB55JDSxihVEiNDJ9T7PAvCt/XWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=b8JXFX58; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B6B9C4CEC2;
	Wed,  4 Sep 2024 18:06:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725473210;
	bh=ummQraPGr12Rbrv+T6vWh69Bxy+GGS3bvVUkuPzUlmU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=b8JXFX58npgpm/y900lVxLSXxT764ydB0CfC39PNbTAgLRhxiCDeYoxCwKhmYrnRN
	 mknI9zkgQ/5X3XJck81VMSfrBsoeYWruA49b2qFQ51jSO1iUEysiPvViz0uzmw/feV
	 +fjY4ja6/NxFhKwNE8JhUVJgNdKwwlRScN4Hax3olZ6cJjW+3BoFbe5Yf4VUF7CMOh
	 DU1h/aoTI/8yMYb4cXhgNEiF9sXNpZ76rvH+f17pFa6t+qrMNXrIsHi4T/D3JcLJzQ
	 +yWBw6KmxKlRZ/JFAkd01OKxd/gupoh7W5b+fO3TV9DHlfI6Tn+Tcs0s9tlhArdOYj
	 CGb4OBS94lM8A==
Date: Wed, 4 Sep 2024 11:06:48 -0700
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: zhang warden <zhangwarden@gmail.com>
Cc: Miroslav Benes <mbenes@suse.cz>, Jiri Kosina <jikos@kernel.org>,
	Petr Mladek <pmladek@suse.com>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	live-patching@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 2/2] livepatch: Add using attribute to klp_func for
 using function show
Message-ID: <20240904180648.fni3xeqkdrvswgcx@treble>
References: <20240828022350.71456-1-zhangwarden@gmail.com>
 <20240828022350.71456-3-zhangwarden@gmail.com>
 <20240904044807.nnfqlku5hnq5sx3m@treble>
 <AAD198C9-210E-4E31-8FD7-270C39A974A8@gmail.com>
 <20240904071424.lmonwdbq5clw7kb7@treble>
 <1517E547-55C1-4962-9B6F-D9723FEC2BE0@gmail.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1517E547-55C1-4962-9B6F-D9723FEC2BE0@gmail.com>

On Wed, Sep 04, 2024 at 03:30:22PM +0800, zhang warden wrote:
> > On Sep 4, 2024, at 15:14, Josh Poimboeuf <jpoimboe@kernel.org> wrote:
> > If there are multiple people applying patches independently from each
> > other (to the same function even!), you are playing with fire, as there
> > could easily be implicit dependencies and conflicts between the patches.
> > 
> > 
> Yep, I agree with you. This is not a good practice.
> 
> But we can work further, livepatch can tell which function is now running. This feature can do more than that.
> 
> Afterall, users alway want to know if their newly patched function successfully enabled and using to fix the bug-existed kernel function.
> 
> With this feature, user can confirm their patch is successfully running instead of using crash to look into /proc/kcore to make sure this function is running now. (I always use this method to check my function patched ... lol).
> 
> And I think further, if we use kpatch-build[1], `kpatch list` can not only tell us which patch is enabled, but also tell us the relationship between running function and patched module.
> I think this is an exciting feature...

Most of this information is already available in sysfs, with the
exception of patch stacking order.

Every new feature adds maintenance burden.  It might not seem like much
to you, but the features add up, and livepatch needs to be solid.

We want patches that fix real world, tangible problems, not theoretical
problems that it *might* solve for a hypothetical user.

What is the motiviation behind this patch?  What real world problem does
it fix for you, or an actual user?  Have you considered other solutions,
like more organized patch management in user space?

-- 
Josh

