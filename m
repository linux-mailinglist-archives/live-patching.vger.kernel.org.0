Return-Path: <live-patching+bounces-1482-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 37048ACE790
	for <lists+live-patching@lfdr.de>; Thu,  5 Jun 2025 02:36:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A39B71895785
	for <lists+live-patching@lfdr.de>; Thu,  5 Jun 2025 00:36:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 15B933FD4;
	Thu,  5 Jun 2025 00:36:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="C3Bzi9Mp"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF04B8F58;
	Thu,  5 Jun 2025 00:36:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749083783; cv=none; b=J1Zg0qJwenflNlD64cAwBYAdt3qfwNZ6C6DQESWcj0mowBpXO0NK6QJ3yQfMxO77sWtrdklyGlxA4lTheLOzAhI8qu/9GBhCoUOrkx6IhNqEWKeOg7nZ9dJbJRTe+j2GDKyYwwP+Zg5FbXneyENdCLBsadGrUC+dSXVhz1zEyUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749083783; c=relaxed/simple;
	bh=OHW1wJwUb8eeUQj3pLMNMXmU/ef13yfus/mjf+oIA6I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RVRnfmqsMNC5ifBV24zurBfbM1PV0n+HkiRFNRW/Y83RNUaLt1Iz/1/7/XYSz4ZOB2fUwFaKr9EAGBGtAFQgIRyASpkiYuAAUl31mXg/094u7XvNyV5avXMVnpsiTRxBN1y5r7smP+WlMQRqMU9FuNcUsk77fP4M9M1mLQBYXfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=C3Bzi9Mp; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07EC0C4CEE4;
	Thu,  5 Jun 2025 00:36:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749083778;
	bh=OHW1wJwUb8eeUQj3pLMNMXmU/ef13yfus/mjf+oIA6I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=C3Bzi9MpIEs5tn1ScVIqYE3F3JiJ5d+t2ivp/pEX/mFotfw1ByKrR7p1TqfIPIhq0
	 FKe6t+IiwkiTaXyDtNvr1Zv+dGFABc7w2hmMQPWkYi3kHzD8iz1+go1LvLSLBns7ko
	 n8rufaR9KHRpoGBkzjpnx7bqRWNmRZj+ov3H3JG+Mo+SqEqL5lf+OrQ/Fz+KjCHzSA
	 qrwtxjWVeZp242HCjavhpyDEBKCddeCpO7FatFTMtlWoW7fuY0e1o/01rRRYai2QAN
	 3tdcV4DXo2vlwSNeTacjHLe4ftb0r3ZRy8BXpiFtJiBwlsYNqPSh8jf8M4hP+J3hMe
	 ljOd31OjIYXBw==
Date: Wed, 4 Jun 2025 17:36:15 -0700
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, 
	Petr Mladek <pmladek@suse.com>, Miroslav Benes <mbenes@suse.cz>, 
	Joe Lawrence <joe.lawrence@redhat.com>, live-patching@vger.kernel.org, Song Liu <song@kernel.org>, 
	laokz <laokz@foxmail.com>, Jiri Kosina <jikos@kernel.org>, 
	Marcos Paulo de Souza <mpdesouza@suse.com>, Weinan Liu <wnliu@google.com>, 
	Fazla Mehrab <a.mehrab@bytedance.com>, Chen Zhongjin <chenzhongjin@huawei.com>, 
	Puranjay Mohan <puranjay@kernel.org>
Subject: Re: [PATCH v2 52/62] objtool/klp: Introduce klp diff subcommand for
 diffing object files
Message-ID: <udmorf6ait6y2xeplz2wfid3xnyga3ahwv7gd7dl46c456auq3@54ym6kszzudy>
References: <cover.1746821544.git.jpoimboe@kernel.org>
 <f6ffe58daf771670a6732fd0f741ca83b19ee253.1746821544.git.jpoimboe@kernel.org>
 <20250526182259.GP24938@noisy.programming.kicks-ass.net>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250526182259.GP24938@noisy.programming.kicks-ass.net>

On Mon, May 26, 2025 at 08:22:59PM +0200, Peter Zijlstra wrote:
> On Fri, May 09, 2025 at 01:17:16PM -0700, Josh Poimboeuf wrote:
> 
> > Without '-ffunction-sections -fdata-sections', reliable object diffing
> > would be infeasible due to toolchain limitations:
> > 
> >   - For intra-file+intra-section references, the compiler might
> >     occasionally generated hard-coded instruction offsets instead of
> >     relocations.
> > 
> >   - Section-symbol-based references can be ambiguous:
> > 
> >     - Overlapping or zero-length symbols create ambiguity as to which
> >       symbol is being referenced.
> > 
> >     - A reference to the end of a symbol (e.g., checking array bounds)
> >       can be misinterpreted as a reference to the next symbol, or vice
> >       versa.
> > 
> > A potential future alternative to '-ffunction-sections -fdata-sections'
> > would be to introduce a toolchain option that forces symbol-based
> > (non-section) relocations.
> 
> Urgh.. So the first issue we can fix with objtool, but the ambiguous
> cases are indeed very hard to fix up in post.
> 
> Did you already talk to toolchain people about this?

For now, I want to stick with -ffunction-sections -fdata-sections, as
that's what kpatch has done for 10+ years and it works well.  That's the
only option we have for current compilers anyway.

The above mentioned possibility of diffing without -ffunction-sections
-fdata-sections is theoretical, and needs more exploration.  If it
indeed works then we can try to get toolchain support for that.

-- 
Josh

