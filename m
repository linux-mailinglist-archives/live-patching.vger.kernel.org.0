Return-Path: <live-patching+bounces-1165-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A073A33591
	for <lists+live-patching@lfdr.de>; Thu, 13 Feb 2025 03:45:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 06915188AFB0
	for <lists+live-patching@lfdr.de>; Thu, 13 Feb 2025 02:45:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 226992045B8;
	Thu, 13 Feb 2025 02:45:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BOQ0ZOY+"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAC541A5AA;
	Thu, 13 Feb 2025 02:45:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739414710; cv=none; b=i1eCoClD11biNpSWlEy1TkAThSqRSclaLxlRpQgAJJ35jXYJ+Y8WGC+vdqICtIbfi3CGNNxnw/pXgoFU0zc3gFEsKqZAkhjLrfbOVvDhdNxrSwokiKREbOF7WZ/UIXCbNeTeXy4EgSFRxzZDfSZMFg67pUd2qb+IY7ZTX2Z+PhM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739414710; c=relaxed/simple;
	bh=rFCOY1gFGh4xAz2GXJr9L5uIUyO+fu9QPIO7RB4RRZU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bFJbdUPSXJqpXaDeO70DN27mb71hCTyDTj1VgUtNv3bomURDhq7v/CDbQmcJdG37h7xFNJoGZhYbMWO9g87lnfZyAAdL60du4xx45NP1iypFunGR/295vVlkSvHWNvfI58WKab3pbvLMvega0A4CBdJtoksMsmH+rkDuS4d1MKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BOQ0ZOY+; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3773C4CEDF;
	Thu, 13 Feb 2025 02:45:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739414709;
	bh=rFCOY1gFGh4xAz2GXJr9L5uIUyO+fu9QPIO7RB4RRZU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BOQ0ZOY+ohAab/jMFSuCRCoi1bj/2eMme4j6Rf24dK8+5WkbkIA4y7FdCUOCRf5rE
	 1qEuJ1TRWTTOhIOUMb9mYlrTwOcfIDYJ22tgAKwSf/suKWUoLCgo7xpmBa/WOiiCVH
	 Pej3lFI73HOZ7azBj0bA2OxrwEaVJrGOXW4tk2XYe7a+OJXBWDiYCQNSil5j0XOBY5
	 dclODV5/KmDoabmbjCGPQqhKyY/pnJ2rLQI6Ro2nly1H+lKA+6a72bsVVZqI7RhOA1
	 WridrQ1jdH3nBsWML15ZrneuFFhHfn34eYckz4nwv1+LgtKbrUooUUfXV9+x4RzsA0
	 9Vi4ogMe33kRQ==
Date: Wed, 12 Feb 2025 18:45:07 -0800
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Song Liu <song@kernel.org>
Cc: Weinan Liu <wnliu@google.com>, Steven Rostedt <rostedt@goodmis.org>,
	Indu Bhagat <indu.bhagat@oracle.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Mark Rutland <mark.rutland@arm.com>, roman.gushchin@linux.dev,
	Will Deacon <will@kernel.org>, Ian Rogers <irogers@google.com>,
	linux-toolchains@vger.kernel.org, linux-kernel@vger.kernel.org,
	live-patching@vger.kernel.org, joe.lawrence@redhat.com,
	linux-arm-kernel@lists.infradead.org,
	Puranjay Mohan <puranjay@kernel.org>
Subject: Re: [PATCH 0/8] unwind, arm64: add sframe unwinder for kernel
Message-ID: <20250213024507.mvjkalvyqsxihp54@jpoimboe>
References: <20250127213310.2496133-1-wnliu@google.com>
 <CAPhsuW6S1JPn0Dp+bhJiSVs9iUv7v7HThBSE85iaDAvw=_2TUw@mail.gmail.com>
 <20250212234946.yuskayyu4gx3ul7m@jpoimboe>
 <CAPhsuW5TeMXi_Mn8+jR9Qoa=rAWasMo7M3Hs=im6NT6=+CrxqA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAPhsuW5TeMXi_Mn8+jR9Qoa=rAWasMo7M3Hs=im6NT6=+CrxqA@mail.gmail.com>

On Wed, Feb 12, 2025 at 06:36:04PM -0800, Song Liu wrote:
> > > [   81.261748]  copy_process+0xfdc/0xfd58 [livepatch_special_static]
> >
> > Does that copy_process+0xfdc/0xfd58 resolve to this line in
> > copy_process()?
> >
> >                         refcount_inc(&current->signal->sigcnt);
> >
> > Maybe the klp rela reference to 'current' is bogus, or resolving to the
> > wrong address somehow?
> 
> It resolves the following line.
> 
> p->signal->tty = tty_kref_get(current->signal->tty);
> 
> I am not quite sure how 'current' should be resolved.

Hm, on arm64 it looks like the value of 'current' is stored in the
SP_EL0 register.  So I guess that shouldn't need any relocations.

> The size of copy_process (0xfd58) is wrong. It is only about
> 5.5kB in size. Also, the copy_process function in the .ko file
> looks very broken. I will try a few more things.

Ah ok, sounds like it's pretty borked.

-- 
Josh

