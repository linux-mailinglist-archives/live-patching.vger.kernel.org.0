Return-Path: <live-patching+bounces-1751-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3226EBDCAF4
	for <lists+live-patching@lfdr.de>; Wed, 15 Oct 2025 08:19:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 74DED19A6523
	for <lists+live-patching@lfdr.de>; Wed, 15 Oct 2025 06:20:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7512E30F945;
	Wed, 15 Oct 2025 06:19:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hsNNLVEz"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95E1230DECC;
	Wed, 15 Oct 2025 06:19:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760509178; cv=none; b=YNHUel6m4wsLiHYPeqXy6jcUQAyxF5uK2XQXzLHtZZDFT2BZoJ9znRF7Fp0Wb4wPEUvGLmM6kdHupilFVzNm1SU5srOo+ci2QTfGML/0f8FU/4qOZ7coTch3aTRj90xV50NLFUsM8UaXfERxftXwVYLhFixzMVRYinw8ftVOlok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760509178; c=relaxed/simple;
	bh=575+wvXoKm0wSCqMEWqtmPWHwk3ClafWmET/hcBbNmY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Nod2dpBlr2Whw5dkXwygSU2pitwpXaMUfA0FuUKZZ6vjfSfp8sHSQ8FWSQTUZGW/AjL2jb2JuYmu1NwCajwcv7OkDb+MF7jveGP17yJum8rK67cVaGpjFQdCg+5EaRh2ql1Kv/vpPk52HTmYZFPwMe0OLIT9jcAtdw+Jq0/ql14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hsNNLVEz; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85D25C4CEF8;
	Wed, 15 Oct 2025 06:19:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760509177;
	bh=575+wvXoKm0wSCqMEWqtmPWHwk3ClafWmET/hcBbNmY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hsNNLVEzfzWz7dR7//VOQ7HBra/IIKK2TJb+uHsLg9lLGv1xXVYod7dbxtejsTMHb
	 vvXynatD9q9yBFtQkzQE2SqRJhFB+9NpMD2/LMeADWReV63RNC/ugzjMMtiKOpR9ZI
	 Z234DnezMu4QVa5hzU7wwUYj1wpxXr9mHrL362hgck6uc8/8PNjzpLMlkVD7Zd5rle
	 xngjHIYJeT9N//BZB6XWLTT4RYKf71SPeektAn/4kpxT1lUh5GB/oOe1XGfLi2+8+W
	 astWLyu9y7M06lsXx0eRd/9UU7edQVgQd0fdIaahhK4O3UrrylNkifDDiUgwX2NiEN
	 bFaD8HCYYaFOw==
Date: Wed, 15 Oct 2025 11:48:45 +0530
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
Message-ID: <nuinyo7o7uniemqqmoboctwrkkwkuv77nt7yk6td6eb3x43hv2@2lukfuvcmcko>
References: <20251002192755.86441-1-hbathini@linux.ibm.com>
 <amwerofvasp7ssmq3zlrjakqj5aygyrgplcqzweno4ef42tiav@uex2ildqjvx2>
 <17f49a63-eccb-4075-91dd-b1f37aa762c7@linux.ibm.com>
 <unegysw3bihg32od7aham3npsdpm5govboo3uglorwsrjqfqfk@pbyzwwztmqtc>
 <42d72061-3d23-43db-bb02-d5f75333c924@linux.ibm.com>
 <dvvv5cytyak2iquer7d6g57ttum3qcckupyahsqsmvpzfjbyni@wbsr77swnrcl>
 <79946463-4742-4919-9d56-927a0a6f1c7c@linux.ibm.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <79946463-4742-4919-9d56-927a0a6f1c7c@linux.ibm.com>

On Fri, Oct 10, 2025 at 12:47:21PM +0530, Hari Bathini wrote:
> 
> 
> On 09/10/25 4:57 pm, Naveen N Rao wrote:
> > On Thu, Oct 09, 2025 at 11:19:45AM +0530, Hari Bathini wrote:
> > > 
> > > 
> > > On 08/10/25 1:43 pm, Naveen N Rao wrote:
> > > > On Mon, Oct 06, 2025 at 06:50:20PM +0530, Hari Bathini wrote:
> > > > > 
> > > > > 
> > > > > On 06/10/25 1:22 pm, Naveen N Rao wrote:
> > > > > > On Fri, Oct 03, 2025 at 12:57:54AM +0530, Hari Bathini wrote:
> > > > > > > Today, livepatch takes precedence over direct_call. Instead, save the
> > > > > > > state and make direct_call before handling livepatch.
> > > > > > 
> > > > > > If we call into the BPF trampoline first and if we have
> > > > > > BPF_TRAMP_F_CALL_ORIG set, does this result in the BPF trampoline
> > > > > > calling the new copy of the live-patched function or the old one?
> > > > > 
> > > > > Naveen, calls the new copy of the live-patched function..
> > > > 
> > > > Hmm... I'm probably missing something.
> > > > 
> > > > With ftrace OOL stubs, what I recall is that BPF trampoline derives the
> > > > original function address from the OOL stub (which would be associated
> > > > with the original function, not the livepatch one).
> > > 
> > > Trampoline derives the address from LR.
> > 
> > Does it? I'm referring to BPF_TRAMP_F_CALL_ORIG handling in
> > __arch_prepare_bpf_trampoline().
> 
> 
> > LR at BPF trampoline entry points at
> > the ftrace OOL stub. We recover the "real LR" pointing to the function
> > being traced from there so that we can call into it from within the BPF
> > trampoline.
> 
> Naveen, from the snippet in livepatch_handler code shared below,
> the LR at BPF trmapoline entry points at the 'nop' after the call
> to trampoline with 'bnectrl cr1' in the updated livepatch_handler.
> 
> Mimic'ing ftrace OOL branch instruction in livepatch_handler
> with 'b	1f' (the instruction after nop) to ensure the trmapoline
> derives the real LR to '1f' and jumps back into the livepatch_handler..
> 
> +       /* Jump to the direct_call */
> +       bnectrl cr1
> +
> +       /*
> +        * The address to jump after direct call is deduced based on ftrace
> OOL stub sequence.
> +        * The seemingly insignificant couple of instructions below is to
> mimic that here to
> +        * jump back to the livepatch handler code below.
> +        */
> +       nop
> +       b       1f
> +
> +       /*
> +        * Restore the state for livepatching from the livepatch stack.
> +        * Before that, check if livepatch stack is intact. Use r0 for it.
> +        */
> +1:     mtctr   r0

Ah, so you are faking a ftrace OOL stub here. But, won't this mean that 
bpf_get_func_ip() won't return the function address anymore?

One of the other thoughts I had was if we could stuff the function 
address into the ftrace OOL stub. I had considered this back when I 
implemented the OOL stubs, but didn't do it due to the extra memory 
requirement. However, given the dance we're having to do, I'm now 
thinking that may make sense and can simplify the code. If we can also 
hook into livepatch, then we should be able to update the function 
address in the stub to point to the new address and the trampoline 
should then "just work" since it already saves/restores the TOC [We may 
additionally have to update the function IP in _R12, but that would be a 
minor change overall]

We will still need a way to restore livepatch TOC if the BPF trampoline 
doesn't itself call into the function, but we may be able to handle that 
if we change the return address to jump to a stub that restores the TOC 
from the livepatch stack.

> 
> 
> I should probably improve my comments for better readability..

Yes, please. I would also split the changes converting some of the hard 
coded offsets into macros into a separate patch.

- Naveen


