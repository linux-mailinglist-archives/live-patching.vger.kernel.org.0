Return-Path: <live-patching+bounces-573-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 03FAD96AE2C
	for <lists+live-patching@lfdr.de>; Wed,  4 Sep 2024 04:01:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A2B541F21F4C
	for <lists+live-patching@lfdr.de>; Wed,  4 Sep 2024 02:01:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F39D06FD3;
	Wed,  4 Sep 2024 02:01:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sCyl8B5T"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA73EDDCD;
	Wed,  4 Sep 2024 02:01:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725415301; cv=none; b=sXYIJtMCc/aMqBPUMfX+q5yxjfld3dM+rhWxEwEGzjsWu7pA9D8dCMV6QcgP3WaC3cPVlWy6QYYrAKqIex899pjT0VrA8dk+/m1bUwXnJ4LQSMyINNCTPTfX6Xx5vJsp0NlvHeipJJ0dXjlIJjTASIKl3ILe08lEi9F2+qXlN/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725415301; c=relaxed/simple;
	bh=Z4dK3Vk59UJ5Zt1Cz8V2awKOwiTunNVatvtgtG1/jUU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LvblIWb1Ll6IbrOY9hXNyfjn/nXRc7KgVO9Gj32Nw0J7xhjT1+baI+umGcn6xbsRM6VXeG/ZfEkgKmCpskLTouvoKFkuO5/6LaV/zozZfVt3Nx6TgPtEuJShTzzkfKRenojrWRnfNVMzb/djOD7YaLs3Cjxntt7mWXxsXynT4ik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sCyl8B5T; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05E14C4CEC4;
	Wed,  4 Sep 2024 02:01:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725415301;
	bh=Z4dK3Vk59UJ5Zt1Cz8V2awKOwiTunNVatvtgtG1/jUU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=sCyl8B5Tsh6szo8OZeNIiqH8ootrBwZS765hFWpbIuSNacg6diVIUcdArGIc8TDrO
	 jmi0Vgj8/hzQjVecZLKaWzTIxMDzsVHNqvGSvN+azOHoSbRCV86ZBFuc4o6OyUVyg9
	 q75Jsgume6mZV8hHaihOZuPH78zc3P19X1ToBxhufjTGpaNSHBZ30G5xpy1p5li+3Y
	 CV6zyzb0srrton23N8JmAqyCI9ioGrzJHlIn5fKWkpES6CildDVg25nt3GuFc93abK
	 ECO845MFqyr4Z2ZmWt3RS5ia74BEA4U0BS16dE05raiUo+SbxR9s+2oj8vev0aaVu5
	 tWsg1/bhcK09g==
Date: Tue, 3 Sep 2024 19:01:39 -0700
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
	x86@kernel.org, Miroslav Benes <mbenes@suse.cz>,
	Petr Mladek <pmladek@suse.com>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	Jiri Kosina <jikos@kernel.org>,
	Marcos Paulo de Souza <mpdesouza@suse.com>,
	Song Liu <song@kernel.org>
Subject: Re: [RFC 05/31] x86/compiler: Tweak __UNIQUE_ID naming
Message-ID: <20240904020139.xyguxzshms7xuqcg@treble>
References: <cover.1725334260.git.jpoimboe@kernel.org>
 <d8d876dcd1d76c667a4449f4673104669480c08d.1725334260.git.jpoimboe@kernel.org>
 <20240903075634.GL4723@noisy.programming.kicks-ass.net>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240903075634.GL4723@noisy.programming.kicks-ass.net>

On Tue, Sep 03, 2024 at 09:56:34AM +0200, Peter Zijlstra wrote:
> > -#define __UNIQUE_ID(prefix) __PASTE(__PASTE(__UNIQUE_ID_, prefix), __COUNTER__)
> > +/* Format: __UNIQUE_ID_<name>_<__COUNTER__> */
> > +#define __UNIQUE_ID(name)					\
> > +	__PASTE(__UNIQUE_ID_,					\
> > +	__PASTE(name,						\
> > +	__PASTE(_, __COUNTER__)))
> 
> OK, that's just painful to read; how about so?
> 
> 	__PASTE(__UNIQUE_ID_,					\
> 	        __PASTE(name,					\
> 		        __PASTE(_, __COUNTER)))

Sure.

> >  /**
> >   * data_race - mark an expression as containing intentional data races
> > @@ -218,7 +222,7 @@ void ftrace_likely_update(struct ftrace_likely_data *f, int val,
> >   */
> >  #define ___ADDRESSABLE(sym, __attrs) \
> >  	static void * __used __attrs \
> > -	__UNIQUE_ID(__PASTE(__addressable_,sym)) = (void *)(uintptr_t)&sym;
> > +	__UNIQUE_ID(__PASTE(addressable_, sym)) = (void *)(uintptr_t)&sym;
> 
> This change doesn't get mention ?

Hm, I have no idea why I did that...  I'll drop it.

-- 
Josh

