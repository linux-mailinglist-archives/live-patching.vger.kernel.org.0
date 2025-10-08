Return-Path: <live-patching+bounces-1733-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 8618EBC48C0
	for <lists+live-patching@lfdr.de>; Wed, 08 Oct 2025 13:25:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id B86324EFE4A
	for <lists+live-patching@lfdr.de>; Wed,  8 Oct 2025 11:25:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA3342F656C;
	Wed,  8 Oct 2025 11:25:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IErWHqCA"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7D432ECD33;
	Wed,  8 Oct 2025 11:25:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759922738; cv=none; b=MfovSlCO9o8oDm1NVo/dS6z/V9vDrpTIRyoLHZo0Xe93GSm6EReq3xH0XvWTtJ959r2/jDx/LTrbI6b0H7Ln7q1hiO96U8gdAZwdLdmANtOjXCMr0L+Pv1TR2+6uE4lETOGIr9vAx4VDpM5EKDGH643g3KBqoc5FrKxHSMreUAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759922738; c=relaxed/simple;
	bh=88c3sFsoUsAiJupZku1KMo3Q2xahgwOIy0yqsCJN198=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KQRBw/r2Pn3PWB/Kq0hzHv5oe3jepb2oph4KswM3u2l7QeiRlUd5jSkEjVUgyD9Txy0KpldgrI4sja7+0DKbnQwMZlx33yewnbIfDaLirU+AIRYn4tDZyFWQyN6sz+G08LQBQ9Om+PCb+Wky4nWFTUNS+hD4pvnYrxj8VNtJR3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IErWHqCA; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9AE7C4CEF4;
	Wed,  8 Oct 2025 11:25:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759922738;
	bh=88c3sFsoUsAiJupZku1KMo3Q2xahgwOIy0yqsCJN198=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=IErWHqCA6ccIxcCPwE8YbXw6DkiJYJbafos4nPLuNA+TS6FWePh2R4YkjF+ybV27D
	 sTxAA4IxJQRbATvGd7wBycDlqgFnYXYxH3Y+bB8M7E7htDh0O1dkt1wl633ky7EQBh
	 UBfuHWrgNkdFImsYk7pqZLnGRZsem9S6LKaFaoRlp4X+fh3QvrSevIxunNOdgQGDd6
	 i/8BcSl6uhGVA8LtueRygAPAla+4klwvi1ionQ/qvM/HG9nl+FKfjyb2kiQMiZpY3w
	 i74lJDrKXDrCyt5jl6h1bSCJLjF5kxL1CKBZJFOjf74oH0gDoDdj+V4z23+YTA7M9K
	 iz+O2Hiyh3gAA==
Date: Wed, 8 Oct 2025 13:43:25 +0530
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
Message-ID: <unegysw3bihg32od7aham3npsdpm5govboo3uglorwsrjqfqfk@pbyzwwztmqtc>
References: <20251002192755.86441-1-hbathini@linux.ibm.com>
 <amwerofvasp7ssmq3zlrjakqj5aygyrgplcqzweno4ef42tiav@uex2ildqjvx2>
 <17f49a63-eccb-4075-91dd-b1f37aa762c7@linux.ibm.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <17f49a63-eccb-4075-91dd-b1f37aa762c7@linux.ibm.com>

On Mon, Oct 06, 2025 at 06:50:20PM +0530, Hari Bathini wrote:
> 
> 
> On 06/10/25 1:22 pm, Naveen N Rao wrote:
> > On Fri, Oct 03, 2025 at 12:57:54AM +0530, Hari Bathini wrote:
> > > Today, livepatch takes precedence over direct_call. Instead, save the
> > > state and make direct_call before handling livepatch.
> > 
> > If we call into the BPF trampoline first and if we have
> > BPF_TRAMP_F_CALL_ORIG set, does this result in the BPF trampoline
> > calling the new copy of the live-patched function or the old one?
> 
> Naveen, calls the new copy of the live-patched function..

Hmm... I'm probably missing something.

With ftrace OOL stubs, what I recall is that BPF trampoline derives the 
original function address from the OOL stub (which would be associated 
with the original function, not the livepatch one). This should mean 
that the trampoline continues to invoke the original function.


- Naveen


