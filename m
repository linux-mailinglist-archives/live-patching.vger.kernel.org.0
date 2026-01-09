Return-Path: <live-patching+bounces-1906-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 3DAD7D0A82E
	for <lists+live-patching@lfdr.de>; Fri, 09 Jan 2026 14:55:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id BBC513037509
	for <lists+live-patching@lfdr.de>; Fri,  9 Jan 2026 13:51:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E49E35B149;
	Fri,  9 Jan 2026 13:51:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fBroDu6I"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED5A0336ED1;
	Fri,  9 Jan 2026 13:51:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767966715; cv=none; b=WPxHPLqYUeGro4+255w7FvA0mgIJNUe7z/dA+IdMKo+IA2Qe1xGT8nTWoU1ykAPk11Sw4v3fR+ZIYimnntuXoUnDdaGIEGiHaLLsRK+cI8zB92RWe5OFHu2B4q3HFh/uMM4nf6nRwxew2MlyAw8/HnjONgAvy+TBrNHkn9r9gfw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767966715; c=relaxed/simple;
	bh=CLZvYIsZyfLJIsGhoiYPM3t/q9SwiCeDSBIF6jrDkOE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tyqjzlz/HCmVqhDmgZvjSydvki6eQHog/vW5NFmG4qw6YhQW68uDHBs1t62iCBK6/iIAo1hidqbLXToXD9x+Ibkh7TGCPCAmj09kuABX/ju5/d6DSqOm9WZWfaBWdZFcEnRnNdHrHX/5MHX38KATvTxHS7ugyXy4ohA0y1TSGRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fBroDu6I; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9487C4CEF1;
	Fri,  9 Jan 2026 13:51:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767966714;
	bh=CLZvYIsZyfLJIsGhoiYPM3t/q9SwiCeDSBIF6jrDkOE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fBroDu6IN+2tkXyeN5U5QMYb0DBexlKu0/2Zg/2VFDJQ43930saje+YN+kzqeQeX+
	 u209JM5Zc1YixNnK1OfMUFPqPon20e82wpwxDGFsYfSt5O8uoFHH24jhcLQ4tPGRGO
	 DMXvkwfXGDK6i7eSqaHWbaY9ask2AohBoxnUfqNLh/o4ZIaVnNrDMF9NicfCgpDpaK
	 6D5mmeg+QLuPthnOJh0H19g9/AihyIF5/N6+jdsICFCPKGjNOWAB5sudlV+OqWck0l
	 mhyICObKpOj1w9pYFrvQFSSpnSlyqsyFy/cH8OgmW/gwFh2Zw/27nVEbt1EPx0KMtf
	 JuCJk3+AY+Dxg==
Date: Fri, 9 Jan 2026 19:18:22 +0530
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
Message-ID: <aWEFaNhwUaRSqISq@blrnaveerao1>
References: <20251002192755.86441-1-hbathini@linux.ibm.com>
 <amwerofvasp7ssmq3zlrjakqj5aygyrgplcqzweno4ef42tiav@uex2ildqjvx2>
 <17f49a63-eccb-4075-91dd-b1f37aa762c7@linux.ibm.com>
 <unegysw3bihg32od7aham3npsdpm5govboo3uglorwsrjqfqfk@pbyzwwztmqtc>
 <42d72061-3d23-43db-bb02-d5f75333c924@linux.ibm.com>
 <dvvv5cytyak2iquer7d6g57ttum3qcckupyahsqsmvpzfjbyni@wbsr77swnrcl>
 <79946463-4742-4919-9d56-927a0a6f1c7c@linux.ibm.com>
 <nuinyo7o7uniemqqmoboctwrkkwkuv77nt7yk6td6eb3x43hv2@2lukfuvcmcko>
 <e34ddd05-d926-4eb4-b861-4bf8fd5635bb@linux.ibm.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e34ddd05-d926-4eb4-b861-4bf8fd5635bb@linux.ibm.com>

On Mon, Dec 08, 2025 at 10:05:44PM +0530, Hari Bathini wrote:
> > 
> > One of the other thoughts I had was if we could stuff the function
> > address into the ftrace OOL stub. I had considered this back when I
> > implemented the OOL stubs, but didn't do it due to the extra memory
> > requirement. However, given the dance we're having to do, I'm now
> > thinking that may make sense and can simplify the code. If we can also
> > hook into livepatch, then we should be able to update the function
> > address in the stub to point to the new address and the trampoline
> > should then "just work" since it already saves/restores the TOC [We may
> > additionally have to update the function IP in _R12, but that would be a
> > minor change overall]
> > 
> > We will still need a way to restore livepatch TOC if the BPF trampoline
> > doesn't itself call into the function, but we may be able to handle that
> > if we change the return address to jump to a stub that restores the TOC
> > from the livepatch stack.
> 
> Sounds doable. Looking into a couple of other things at the moment
> though. Will try out this suggestion and get back post that.
> Having said that, your thoughts on whether the current approach
> is a viable option if bpf_get_func_ip() can be fixed somehow?

Oh, that's fine -- feel free to go with whatever approach you think 
works best.


- Naveen


