Return-Path: <live-patching+bounces-1860-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id DC4F5C66825
	for <lists+live-patching@lfdr.de>; Tue, 18 Nov 2025 00:02:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 8DA6A4E27AA
	for <lists+live-patching@lfdr.de>; Mon, 17 Nov 2025 23:01:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE97A23EAA3;
	Mon, 17 Nov 2025 23:01:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dDpQvhpD"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DA55202F7E;
	Mon, 17 Nov 2025 23:01:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763420502; cv=none; b=YrzNuWpNVLx2KT8OPYjUjT31AomN5JuIqXOth/mbfaevb7kEZnSeXtZLK7gOuiNFrdnaPnL6P8OEC0XduhUrT2nsMCM0BymrrSAzag0fS8hUiLHX36r/WJN0OZIOHJK9ZVe85qy7y5UyaeHfow2KgjQTSGu4yvq8+vglUBsX0hE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763420502; c=relaxed/simple;
	bh=Dq0eTFRCeQzhn3vDfbpa3/NnxAYBpBDM1zcOLDRK2bU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ctsdYLhNBo+RY5A2V11Nmyv3ftly1NqQCFcRotJiI3bVJmZQ+OgCs2s1WiVBimcoD7uILPg8TQellmLlRKzznEADHo1yn9+hboxzDzN1e2TrI51+GQ7p+f4MDLwskHhWxXAwgRBxHekTLwBTpLNedK3X7SaZLeAQko4Ax551iBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dDpQvhpD; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB69FC2BCB3;
	Mon, 17 Nov 2025 23:01:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763420501;
	bh=Dq0eTFRCeQzhn3vDfbpa3/NnxAYBpBDM1zcOLDRK2bU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dDpQvhpDKHsnKt4nBDk8Wv42Po7aULS2hPhlsauClaEAUGegmN1h4sv5/MP1TV+0t
	 OT01gy6saaPr/TLmpMTlUf7pvbCmr9K99QlJETJbGNJSfC/zZ2DVVgCR0aYtq7pseR
	 KXDkEA+BaQpGvGfawf71F5glIU/7oLfhJNWx8iZxKkJkctr4iuWA9PzLtS3S/r2YTT
	 jFHX1ZuxuPN/PAY498rghNnM3gr4avYUzQKtQeIo4frwFKRfxLBYjy5kk4ai0uKOkO
	 BUHjHjRnUX0ob7mbewbxnQMEfKK77WM0ZAkZpIXbQm9L+vk7ee+Z4Rlo1HF7uLOdzl
	 5N/gQUyYsloLA==
Date: Mon, 17 Nov 2025 15:01:37 -0800
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Dylan Hatch <dylanbhatch@google.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, 
	Indu Bhagat <indu.bhagat@oracle.com>, Peter Zijlstra <peterz@infradead.org>, 
	Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Jiri Kosina <jikos@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Weinan Liu <wnliu@google.com>, Mark Rutland <mark.rutland@arm.com>, 
	Ian Rogers <irogers@google.com>, linux-toolchains@vger.kernel.org, linux-kernel@vger.kernel.org, 
	live-patching@vger.kernel.org, joe.lawrence@redhat.com, Puranjay Mohan <puranjay@kernel.org>, 
	Song Liu <song@kernel.org>, Prasanna Kumar T S M <ptsm@linux.microsoft.com>
Subject: Re: [PATCH v2 6/6] unwind: arm64: Add reliable stacktrace with
 sframe unwinder.
Message-ID: <eo5fod6csuininieur2lm6bxunmpbk6n3wtxajamrwqqpae3ja@o3eqwfp3u6su>
References: <20250904223850.884188-1-dylanbhatch@google.com>
 <20250904223850.884188-7-dylanbhatch@google.com>
 <xo2ro446awhsd7i55shx6tlz6s2azuown4xk6zfm7ie4zz2nqc@244onpurkvy3>
 <CADBMgpyVis+fRHLOv6BRPrT+0r8846MOutkmOgMbqytLVXh9Ag@mail.gmail.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CADBMgpyVis+fRHLOv6BRPrT+0r8846MOutkmOgMbqytLVXh9Ag@mail.gmail.com>

On Fri, Nov 14, 2025 at 10:44:20PM -0800, Dylan Hatch wrote:
> Sorry for the slow reply on this, I'm going to try and get a v3 out
> sometime after next week.
> 
> On Wed, Sep 17, 2025 at 4:41 PM Josh Poimboeuf <jpoimboe@kernel.org> wrote:
> >
> > As far I can tell, the *only* error condition being checked is if it
> > (successfully) fell back to frame pointers.
> 
> By checking/handling error conditions, do you mean just marking the
> state as unreliable in any case where the unwind isn't successful with
> SFrame?

Right, any sframe error it encounters along the way (including missing
sframe) would be a reason to mark it as unreliable.

> I'm thinking if I can make the unwind_next_frame_sframe() code
> path handle the end of the stack correctly on its own, I can more
> strictly mark the trace as unreliable if it encounters any error.
> 
> >
> > What if there was some bad or missing sframe data?  Or some unexpected
> > condition on the stack?
> >
> > Also, does the exception handling code have correct cfi/sframe metadata?
> >
> > In order for it to be "reliable", we need to know the unwind reached the
> > end of the stack (e.g., the task pt_regs frame, from entry-from-user).
> 
> It looks like the frame-pointer based method of handling the end of
> the stack involves calling kunwind_next_frame_record_meta() to extract
> and check frame_record_meta::type for FRAME_META_TYPE_FINAL. I think
> this currently assumes (based on the definition of 'struct
> frame_record') that the next FP and PC are right next to each other,
> alongside the meta type. But the sframe format stores separate entries
> for the FP and RA offsets, which makes extracting the meta type from
> this information a little bit murky to me.
> 
> Would it make sense to fall back to the frame pointer method for the
> final stack frame? Or I guess I could define a new sframe-friendly
> meta frame record format?

For sframe v3, I believe Indu is planning to add support for marking the
outermost frame.  That would be one definitive way to know that the
stack trace made it to the end.

Or, if the entry-from-user pt_regs frame is always stored at a certain
offset compared to the end of the task stack page, that might be another
way.

-- 
Josh

