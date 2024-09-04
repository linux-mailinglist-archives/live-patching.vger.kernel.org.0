Return-Path: <live-patching+bounces-597-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 94B3D96C44E
	for <lists+live-patching@lfdr.de>; Wed,  4 Sep 2024 18:44:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 48B161F219C9
	for <lists+live-patching@lfdr.de>; Wed,  4 Sep 2024 16:44:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC50B1E0B60;
	Wed,  4 Sep 2024 16:44:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QvqhJEBn"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C21F51E00BD;
	Wed,  4 Sep 2024 16:44:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725468271; cv=none; b=YbtHS2H2+lT2hCvdLip8nMA4aJMX6bWvsGMp0+AetWtgzYACmg6SBlV46gOCdycJvnPcjifHxUkbA1DGx+/mn/hnk4I7fzcskY0y2D/vev+0PRLS6z2Oe7h5N6/QyYlzdpu8A1mSPS9y91JVhJFFGFKRlLov9dB7QhkCErE3Mtw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725468271; c=relaxed/simple;
	bh=b0/jVE3eF7SiKmjozMXjpT6kBCbEEbOS7Y/RJoB0Su4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VtEVcLiApV4WclI0s1o8dn+m/kpLhg7MOv61Bw57UY8TdardISkrg7sB6Kv6zYlPC8vCUAlzWfR2SrU4SQDnruWLaYW5hb8lXRoybu3Kc+bCzQDqutNlOkCtOyIwf34jOU2ou1QUP25MQYM0ZIPeaSTV5Cd60YKCo/TV0RuZ64A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QvqhJEBn; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D340AC4CEC2;
	Wed,  4 Sep 2024 16:44:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725468271;
	bh=b0/jVE3eF7SiKmjozMXjpT6kBCbEEbOS7Y/RJoB0Su4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QvqhJEBnwQx3Xgm1qtXAowO8bX3g0DWICYCEGf3+k16QUlisAz5dMKhmHg6r31T42
	 VFjc2khDY6cmOYCovmK4g3+V+HcadgoSB6OyX3xVDyxJEvuE57tMH7A8+vhhBpkc2+
	 cgWmzvGuPAeatem8Szu7TIVhjDKQtM9OTL2xUP4g+o7gkrHN/VVB1yfGpX0Rj8s+bk
	 fOpy7Wv0Y4S7mflW/OXXt7B7402KIs8JGwbOVpDeanrCi96uVcQiQjM2YBPjjP23Fz
	 bdbPU9+FS//yAXi340FuVxSGkcwmCqmrI4jGioHuOjobBMJqhge8qLqpLgadJp1yWh
	 9pexCC4PxADVQ==
Date: Wed, 4 Sep 2024 09:44:29 -0700
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Peter Zijlstra <peterz@infradead.org>, live-patching@vger.kernel.org,
	linux-kernel@vger.kernel.org, x86@kernel.org,
	Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	Jiri Kosina <jikos@kernel.org>,
	Marcos Paulo de Souza <mpdesouza@suse.com>,
	Song Liu <song@kernel.org>
Subject: Re: [RFC 28/31] x86/alternative: Create symbols for special section
 entries
Message-ID: <20240904164429.hstbg5beejt32mlu@treble>
References: <cover.1725334260.git.jpoimboe@kernel.org>
 <7bc1bcb1cd875350948f43c77c9895173bd22012.1725334260.git.jpoimboe@kernel.org>
 <20240903082909.GP4723@noisy.programming.kicks-ass.net>
 <20240904042829.tkcpql65cxgzvhpx@treble>
 <20240904123918.GCZthU9rOJLWUKBbsv@fat_crate.local>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240904123918.GCZthU9rOJLWUKBbsv@fat_crate.local>

On Wed, Sep 04, 2024 at 02:39:18PM +0200, Borislav Petkov wrote:
> On Tue, Sep 03, 2024 at 09:28:29PM -0700, Josh Poimboeuf wrote:
> > Take a more generic approach: for the "array of structs" style sections,
> > annotate each struct entry with a symbol containing the entry.  This
> > makes it easy for tooling to parse the data and avoids the fragility of
> > hardcoding section details.
> 
> This is more a question for my own understanding: so you want a generic
> approach where objtool doesn't need to know each special section and what it
> needs to copy there from but simply copy those new, special symbols over?
> 
> Which you use as markers of sorts: "this is a relevant symbol, pls copy it"...
> 
> I think you mean that but lemme confirm anyway.

Yes, that's exactly it.  I should clarify a bit more.

> Also, have you checked whether this can be done with some compiler switch
> already?

Not that I know of, since the compiler usually doesn't have visibility
to these sections.

It might be possible to specify "entsize" in the .pushsection flags,
which is an ELF section header attribute which objtool could read.

But that wouldn't work for .altinstr_replacement and other sections with
variable-size entries.  Also, "objtool klp diff" works by copying
symbols, so the current solution is definitely simpler as it fits in
nicely with the rest of the implementation.

-- 
Josh

