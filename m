Return-Path: <live-patching+bounces-647-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F3E0F974B99
	for <lists+live-patching@lfdr.de>; Wed, 11 Sep 2024 09:39:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B149B28D499
	for <lists+live-patching@lfdr.de>; Wed, 11 Sep 2024 07:39:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 12B3613D250;
	Wed, 11 Sep 2024 07:39:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mZkGR35m"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE3841DA5E;
	Wed, 11 Sep 2024 07:39:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726040385; cv=none; b=g+wQmzTLHsVPj9sMM8P9jrPZl3aC5uAAkH0ogUKdLssZpXqQGM+GM/9mqBoC4PCuWBHh98V0bnn+EpbdvMztozQNVnrLuTvx9skoGvQG8oZSbOjuu6itEummsZATh2E9WlFDaT86ESRLpDHkwfRt0Scwlyfdi2H/mZpF+/RoiLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726040385; c=relaxed/simple;
	bh=It9dg/hdhewayTTFm0G/gJ3qKPHCFC/RvttasGppbvQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TM1bzHS7H0uAVd7bdurXEvyEK7x2EEQvuNVORtfclVHpHjLvxKyuEag64X0gI2NaEQHpauE+tXJvrnUs0jixztzQ0hZRk/NJ26xe4qA+mBqfSegPZhdSBKNeXf0tP2OWUdrH8R+UowN/ipFPU2LVI8Dji1hf2tWYhe7C3tsj078=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mZkGR35m; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 097A9C4CEC5;
	Wed, 11 Sep 2024 07:39:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1726040384;
	bh=It9dg/hdhewayTTFm0G/gJ3qKPHCFC/RvttasGppbvQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mZkGR35mTA8+S8mFvLdHwlr6bD51K4cXT8XWhtt7tSaJz9bqzvHeA5yQx0OIv05Pf
	 5wnPigiaZNMKn9wEirZrgP9IdLBYxbikKSWARxo17srwl60DTW7CCsWnko1saeyFUs
	 m7bgKuwRf99WpJwHUCSGID8sjG4B1K/9UPX0DlaVGtY1eKVla57j5cko7bSIMm56/2
	 kpbr0yec+wN7cdSaQ3ak3p2740+OqHdNYJW0kVqEgz7ZkbrraxQrsIgGrv/9rrqOLG
	 aqOyW7WTLnDdTs3u6aV/aloJvMIb/V0f2oe7yPWunTFlPtiWIxSvrJb7YRKHg8Dq6r
	 hXb+Ll04U1vWw==
Date: Wed, 11 Sep 2024 00:39:42 -0700
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: live-patching@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
	Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	Jiri Kosina <jikos@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Marcos Paulo de Souza <mpdesouza@suse.com>,
	Song Liu <song@kernel.org>
Subject: Re: [RFC 00/31] objtool, livepatch: Livepatch module generation
Message-ID: <20240911073942.fem2kekg3f23hzf2@treble>
References: <cover.1725334260.git.jpoimboe@kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <cover.1725334260.git.jpoimboe@kernel.org>

On Mon, Sep 02, 2024 at 08:59:43PM -0700, Josh Poimboeuf wrote:
> Hi,
> 
> Here's a new way to build livepatch modules called klp-build.
> 
> I started working on it when I realized that objtool already does 99% of
> the work needed for detecting function changes.
> 
> This is similar in concept to kpatch-build, but the implementation is
> much cleaner.
> 
> Personally I still have reservations about the "source-based" approach
> (klp-convert and friends), including the fragility and performance
> concerns of -flive-patching.  I would submit that klp-build might be
> considered the "official" way to make livepatch modules.
> 
> Please try it out and let me know what you think.  Based on v6.10.
> 
> Also avaiable at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/jpoimboe/linux.git klp-build-rfc

Here's an updated branch with a bunch of fixes.  It's still incompatible
with BTF at the moment, otherwise it should (hopefully) fix the rest of
the issues reported so far.

While the known bugs are fixed, I haven't finished processing all the
review comments yet.  Once that happens I'll post a proper v2.

  git://git.kernel.org/pub/scm/linux/kernel/git/jpoimboe/linux.git klp-build-v1.5

-- 
Josh

