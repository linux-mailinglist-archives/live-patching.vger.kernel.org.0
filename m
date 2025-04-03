Return-Path: <live-patching+bounces-1351-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 2AA12A7A6BB
	for <lists+live-patching@lfdr.de>; Thu,  3 Apr 2025 17:30:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id CFC677A5974
	for <lists+live-patching@lfdr.de>; Thu,  3 Apr 2025 15:29:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A2C63250C14;
	Thu,  3 Apr 2025 15:30:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jMzK8cwz"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A7F924EF7E;
	Thu,  3 Apr 2025 15:30:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743694211; cv=none; b=A5xCbm72Uo2dxPEaz4QtNaymJnPlT1lFAe874EbxHqb9QrIwqHal0ZBXJAC0Rk9Rg2O87tELsJQSRCzRuzEo7Nkxl6ujHsCfMGY8sqZMnAaec2qrlTgh056aHPMj1HLlElS/WXwwQZHeRNNd5f7H1tI5aC6gCICTYcSgnRjWBpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743694211; c=relaxed/simple;
	bh=q4ROEx0k0EcOszxzPv3EkCrjgDjbH5aqcKwGDoSp5+c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VcvA2MPHgOOOvDp94B/oTLujMsBBZSaJVcAUKe6d9TDanArycdEuBEUm/5sQtP9QbNW+IAePOQggwZs35XziMObZHHvlISAhRvMaezvtMoRr4rfXAItLM1D594wJ8D2sqQoqo6vNJ75EIjTx8IcWgec3EOhkfbL/tBdP/NDWi74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jMzK8cwz; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 569F4C4CEEB;
	Thu,  3 Apr 2025 15:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1743694211;
	bh=q4ROEx0k0EcOszxzPv3EkCrjgDjbH5aqcKwGDoSp5+c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jMzK8cwzjq9uC/pC8ANF+KmdYBqLQvnFUUxyINaU6JRruJdCSamzVMRYZb6BgrQ7F
	 IHDVXZ+J6YlKCt3FetCFAXdkukDoPcYIzQ2xPJJLh2xfnX9m/ZlSxf4X6/QLuirjaN
	 U5rqIG8nevtMexftmBXD6igwydxqy3wSJNUEPZGbwcyrRwQV+vh5/MvN1IRtUW4FD2
	 oWCIWbB1j49kpVlk03Vh/e4KFemlGPSRvPm8+ouN/GlPYDFkPKgssFIlTrrMR50Dr2
	 SJCnEHW6nh8DrCxXCBRuvHku/Onj9sQhkpTagraOEjDI6WaVbXSwGLZ8PLqmuza3F/
	 Y6tsDUe4oz/Dg==
Date: Thu, 3 Apr 2025 20:56:26 +0530
From: Naveen N Rao <naveen@kernel.org>
To: Jiri Olsa <olsajiri@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, 
	Shung-Hsi Yu <shung-hsi.yu@suse.com>, Hari Bathini <hbathini@linux.ibm.com>, bpf@vger.kernel.org, 
	Michael Ellerman <mpe@ellerman.id.au>, Mark Rutland <mark.rutland@arm.com>, 
	Daniel Borkmann <daniel@iogearbox.net>, Masahiro Yamada <masahiroy@kernel.org>, 
	Nicholas Piggin <npiggin@gmail.com>, Alexei Starovoitov <ast@kernel.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Andrii Nakryiko <andrii@kernel.org>, 
	Christophe Leroy <christophe.leroy@csgroup.eu>, Vishal Chourasia <vishalc@linux.ibm.com>, 
	Mahesh J Salgaonkar <mahesh@linux.ibm.com>, Miroslav Benes <mbenes@suse.cz>, 
	Michal =?utf-8?B?U3VjaMOhbmVr?= <msuchanek@suse.de>, linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
	linux-trace-kernel@vger.kernel.org, live-patching@vger.kernel.org, Song Liu <song@kernel.org>
Subject: Re: [BUG?] ppc64le: fentry BPF not triggered after live patch (v6.14)
Message-ID: <xcym3f3rnakaokcf55266czlm5iuh6gv32yl2hplr2hh4uknz3@jusk2mxbrcvw>
References: <rwmwrvvtg3pd7qrnt3of6dideioohwhsplancoc2gdrjran7bg@j5tqng6loymr>
 <20250331100940.3dc5e23a@gandalf.local.home>
 <Z-vgigjuor5awkh-@krava>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z-vgigjuor5awkh-@krava>

On Tue, Apr 01, 2025 at 02:48:10PM +0200, Jiri Olsa wrote:
> On Mon, Mar 31, 2025 at 10:09:40AM -0400, Steven Rostedt wrote:
> > On Mon, 31 Mar 2025 21:19:36 +0800
> > Shung-Hsi Yu <shung-hsi.yu@suse.com> wrote:
> > 
> > > Hi all,
> > > 
> > > On ppc64le (v6.14, kernel config attached), I've observed that fentry
> > > BPF programs stop being invoked after the target kernel function is live
> > > patched. This occurs regardless of whether the BPF program was attached
> > > before or after the live patch. I believe fentry/fprobe on ppc64le is
> > > added with [1].
> > > 
> > > Steps to reproduce on ppc64le:
> > > - Use bpftrace (v0.10.0+) to attach a BPF program to cmdline_proc_show
> > >   with fentry (kfunc is the older name bpftrace used for fentry, used
> > >   here for max compatability)
> > > 
> > >     bpftrace -e 'kfunc:cmdline_proc_show { printf("%lld: cmdline_proc_show() called by %s\n", nsecs(), comm) }'
> > > 
> > > - Run `cat /proc/cmdline` and observe bpftrace output
> > > 
> > > - Load samples/livepatch/livepatch-sample.ko
> > > 
> > > - Run `cat /proc/cmdline` again. Observe "this has been live patched" in
> > >   output, but no new bpftrace output.
> > > 
> > > Note: once the live patching module is disabled through the sysfs interface
> > > the BPF program invocation is restored.
> > > 
> > > Is this the expected interaction between fentry BPF and live patching?
> > > On x86_64 it does _not_ happen, so I'd guess the behavior on ppc64le is
> > > unintended. Any insights appreciated.

We haven't addressed this particular interaction in the powerpc support 
for ftrace direct and BPF trampolines. Right now, live patching takes 
priority so we call the livepatch'ed function and skip further ftrace 
direct calls.

I'm curious if this works on arm64 with which we share support for 
DYNAMIC_FTRACE_WITH_CALL_OPS.

> > 
> > Hmm, I'm not sure how well BPF function attachment and live patching
> > interact. Can you see if on x86 the live patch is actually updated when a
> > BPF program is attached?
> 
> above works for me on x86, there's both 'this has been live patched'
> and bpftrace output
> 
> > 
> > Would be even more interesting to see how BPF reading the return code works
> > with live patching, as it calls the function directly from the BPF
> > trampoline. I wonder, does it call the live patched function, or does it
> > call the original one?
> 
> yes, that should work, Song fixed some time ago with:
>   00963a2e75a8 bpf: Support bpf_trampoline on functions with IPMODIFY (e.g. livepatch)

We don't support BPF_TRAMP_F_ORIG_STACK today, and I am not sure that 
will be easy to support with the out-of-line stubs we are using for 
ftrace.

Today, we support one of livepatch or a direct caller from 
ftrace_caller. Livepatch takes priority. We could call the direct caller 
first, but that will only work if it is guaranteed to call the 
livepatched function (i.e., if the direct call is to a bpf trampoline 
with BPF_TRAMP_F_CALL_ORIG). Otherwise, we will need to call the 
livepatched function after that, but we don't return to ftrace_caller 
from the livepatch handler.

Not sure which of those interactions are valid between a livepatch and a 
direct caller (with and without BPF_TRAMP_F_CALL_ORIG), and if all 
combinations of those need to be supported.


- Naveen


