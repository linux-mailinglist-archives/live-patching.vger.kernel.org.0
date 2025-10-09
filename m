Return-Path: <live-patching+bounces-1738-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 16EDFBC8CEC
	for <lists+live-patching@lfdr.de>; Thu, 09 Oct 2025 13:29:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 18FE71A605D7
	for <lists+live-patching@lfdr.de>; Thu,  9 Oct 2025 11:29:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7FF472E03F0;
	Thu,  9 Oct 2025 11:28:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uAIHBeP7"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DDFD2E03E0;
	Thu,  9 Oct 2025 11:28:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760009294; cv=none; b=cQ7KclWyyx9CVL3vqdYTSnli2nPAwXPtA9u/XaoMVqFxpdYCS+IhAB52w7gyN98y3MU6a/jo7heaZyYBMZ18z/7SlwbYJH5Z/TNJSvzuBzZ++qxmX1g0dSioA9TtOS37rKOevyzhIiGin0XFTOkii+3bH85eLJHdiMZWUc/oPVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760009294; c=relaxed/simple;
	bh=vus6lroH0Ik++53bkVvlr40gcH/48xLsVh0shYo/QCQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TqSzQBVhAmiK4NhNl8BsuuLJj7Rr+jTPl1X/qVnXQZfKDWNiF6VADjhbi8K4HpyLovVyhC43g/evbbQ3CVmqY2ZXW/TRjDV2ja+3CxcDodMqLBfTjwvD0p+5VghzLhNPDZpLBnPYSBurGlqW81sYcZXfWoUPFNICs8Tw+ECh4Bc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uAIHBeP7; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B017EC4CEE7;
	Thu,  9 Oct 2025 11:28:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760009293;
	bh=vus6lroH0Ik++53bkVvlr40gcH/48xLsVh0shYo/QCQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=uAIHBeP7h41eTgv80PY/K5DQ/2vTQZRBDMJg7zsHUdg3MtD+6LlFzY8psyqvni3Y2
	 M7vhW5I45ox0YH7BZEvdx7s4RexbCWVLN0dTDu1pQ5cZaVWhYUqGKQFkI6f0QfVwKf
	 IhMmpz/VNJpRImN0Q02baaXeiJE/c2SVmYuc5/m+0P/W6f+TvubRdadUyjkgd8Dkjo
	 M25h4fbel54wxC6ZKHAXhE38u0JJKDMgIj1UdmBXwuIbAzCQs9D4H5yjU1e3+plWmy
	 BqFwn0Fk6QwQuvCTnebsM+slRTC/szw7yypnHSI/8htSwreoJddTNYbgv1cSefhrpb
	 xtA44kz+fuQrQ==
Date: Thu, 9 Oct 2025 16:57:53 +0530
From: Naveen N Rao <naveen@kernel.org>
To: Hari Bathini <hbathini@linux.ibm.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>, 
	linuxppc-dev <linuxppc-dev@lists.ozlabs.org>, Christophe Leroy <christophe.leroy@csgroup.eu>, 
	Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, bpf@vger.kernel.org, 
	Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
	Andrii Nakryiko <andrii@kernel.org>, Song Liu <songliubraving@fb.com>, Jiri Olsa <jolsa@kernel.org>, 
	Viktor Malik <vmalik@redhat.com>, live-patching@vger.kernel.org, 
	Josh Poimboeuf <jpoimboe@kernel.org>, Joe Lawrence <joe.lawrence@redhat.com>, 
	Jiri Kosina <jikos@kernel.org>, linux-trace-kernel@vger.kernel.org, 
	Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Shung-Hsi Yu <shung-hsi.yu@suse.com>
Subject: Re: [PATCH] powerpc64/bpf: support direct_call on livepatch function
Message-ID: <dvvv5cytyak2iquer7d6g57ttum3qcckupyahsqsmvpzfjbyni@wbsr77swnrcl>
References: <20251002192755.86441-1-hbathini@linux.ibm.com>
 <amwerofvasp7ssmq3zlrjakqj5aygyrgplcqzweno4ef42tiav@uex2ildqjvx2>
 <17f49a63-eccb-4075-91dd-b1f37aa762c7@linux.ibm.com>
 <unegysw3bihg32od7aham3npsdpm5govboo3uglorwsrjqfqfk@pbyzwwztmqtc>
 <42d72061-3d23-43db-bb02-d5f75333c924@linux.ibm.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <42d72061-3d23-43db-bb02-d5f75333c924@linux.ibm.com>

On Thu, Oct 09, 2025 at 11:19:45AM +0530, Hari Bathini wrote:
> 
> 
> On 08/10/25 1:43 pm, Naveen N Rao wrote:
> > On Mon, Oct 06, 2025 at 06:50:20PM +0530, Hari Bathini wrote:
> > > 
> > > 
> > > On 06/10/25 1:22 pm, Naveen N Rao wrote:
> > > > On Fri, Oct 03, 2025 at 12:57:54AM +0530, Hari Bathini wrote:
> > > > > Today, livepatch takes precedence over direct_call. Instead, save the
> > > > > state and make direct_call before handling livepatch.
> > > > 
> > > > If we call into the BPF trampoline first and if we have
> > > > BPF_TRAMP_F_CALL_ORIG set, does this result in the BPF trampoline
> > > > calling the new copy of the live-patched function or the old one?
> > > 
> > > Naveen, calls the new copy of the live-patched function..
> > 
> > Hmm... I'm probably missing something.
> > 
> > With ftrace OOL stubs, what I recall is that BPF trampoline derives the
> > original function address from the OOL stub (which would be associated
> > with the original function, not the livepatch one).
> 
> Trampoline derives the address from LR.

Does it? I'm referring to BPF_TRAMP_F_CALL_ORIG handling in 
__arch_prepare_bpf_trampoline(). LR at BPF trampoline entry points at 
the ftrace OOL stub. We recover the "real LR" pointing to the function 
being traced from there so that we can call into it from within the BPF 
trampoline.

- Naveen


