Return-Path: <live-patching+bounces-1206-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A23ADA36633
	for <lists+live-patching@lfdr.de>; Fri, 14 Feb 2025 20:34:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E34DF3ACFFC
	for <lists+live-patching@lfdr.de>; Fri, 14 Feb 2025 19:33:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 398F0194A44;
	Fri, 14 Feb 2025 19:34:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Fuj7Bn2k"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D3973A8D2;
	Fri, 14 Feb 2025 19:34:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739561643; cv=none; b=ou+cqaGH7fA6UXFZ0ycoSVNFYbnsQPiARL4N+HmUgylZ0mfJcoRh5A7P7+8AXuG3NMvOoTiixY8zli0iYrQEn8DeLOyzy7SWg19J+RnJ0U3fZce52zVZNNdrsuVf6XR0aFwdpA66xvh+Vv+AYNpYk+AaZo//Sbn330tcUodWrAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739561643; c=relaxed/simple;
	bh=CKl2EjbG0ELi5S1ZKbHAQc1rq0HGkpxGF4N4RdLKqvU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Bt8ACp0Mp6gPRVBlisekeEZL64EKzlB/+ml6YpvvG8av+Z80MPx9pM6em7J0Fei/26/fTirwlyCA1lvi1CJIVF64fPHOzR4JUZAFPVjUFF+GuvlUYQnolS2pKaLOx2Np3qaqHHyTi0SYgI/9Eqt1N5F1Soapuf2UaXkhfNjzuCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Fuj7Bn2k; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 373B0C4CED1;
	Fri, 14 Feb 2025 19:34:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739561642;
	bh=CKl2EjbG0ELi5S1ZKbHAQc1rq0HGkpxGF4N4RdLKqvU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Fuj7Bn2kcQmMxqPwhTbYHuB1Ns/qrQ64TiXnLfUhCbSLRweoEB7M+TcBmIQX0d+Iv
	 81TlVLC4l4Wbz1szemM9E19vqnOqY2Sj2MoNkoDWtm4bJBuVR3aXNi+YIcb5NCniYN
	 /WKkGAA8OhIL7eIMotQ2QIWAh5cxMoKDKJg0STu1xOqkO/HWgKZLOJJRm+/hxF1UeY
	 ee5pnJst8fkjdBLBmUqIv+g6F1A0CE373Xc5g10n5ZkbYLIVD3ldtFF5QwyxsIsP6s
	 t6YSDtoW9QIW93Zq08gVfBSsAPD4+x9TQMPUcTTYiGPIMYnI67A72KDC105HHLcJla
	 QgtNABJFzhtYg==
Date: Fri, 14 Feb 2025 11:34:00 -0800
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Song Liu <song@kernel.org>
Cc: Puranjay Mohan <puranjay@kernel.org>, Weinan Liu <wnliu@google.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Indu Bhagat <indu.bhagat@oracle.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Mark Rutland <mark.rutland@arm.com>, roman.gushchin@linux.dev,
	Will Deacon <will@kernel.org>, Ian Rogers <irogers@google.com>,
	linux-toolchains@vger.kernel.org, linux-kernel@vger.kernel.org,
	live-patching@vger.kernel.org, joe.lawrence@redhat.com,
	linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 0/8] unwind, arm64: add sframe unwinder for kernel
Message-ID: <20250214193400.j4hp45jlufihv5eh@jpoimboe>
References: <20250127213310.2496133-1-wnliu@google.com>
 <CAPhsuW6S1JPn0Dp+bhJiSVs9iUv7v7HThBSE85iaDAvw=_2TUw@mail.gmail.com>
 <20250212234946.yuskayyu4gx3ul7m@jpoimboe>
 <CAPhsuW5TeMXi_Mn8+jR9Qoa=rAWasMo7M3Hs=im6NT6=+CrxqA@mail.gmail.com>
 <20250213024507.mvjkalvyqsxihp54@jpoimboe>
 <CAPhsuW4iDuTBfZowJRhxLFyK=g=s+-pK2Eq4+SNj9uL99eNkmw@mail.gmail.com>
 <mb61py0yaz3qq.fsf@kernel.org>
 <CAPhsuW7dV7UR3PsGVx_DLBH5-95DAmLMGTPuY0NfUwWLZMSTrQ@mail.gmail.com>
 <20250214080848.5xpi2y2omk4vxyoj@jpoimboe>
 <CAPhsuW6dxPtgqZaHrZEVhQXwm2+sETreZnGybZXVKYKfG9H6tg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAPhsuW6dxPtgqZaHrZEVhQXwm2+sETreZnGybZXVKYKfG9H6tg@mail.gmail.com>

On Fri, Feb 14, 2025 at 09:51:41AM -0800, Song Liu wrote:
> > Ignorant arm64 question: is the module's text further away from slab
> > memory than vmlinux text, thus requiring a different instruction (or
> > GOT/TOC) to access memory further away in the address space?
> 
> It appears to me the module text is very close to vmlinux text:
> 
> vmlinux: ffff8000800b4b68 T copy_process
> module: ffff80007b0f06d0 t copy_process [livepatch_always_inline_special_static]

Hm... the only other thing I can think of is that the klp relas might be
wrong somewhere.  If you share patched.o and .ko files from the same
build I could take a look.

BTW, I realized the wrong function size shown in the WARNING stack trace
is probably just due to a kallsyms quirk.  It calculates a symbol's size
by subtracting its start address from the next symbol's start address.
It doesn't actually use the ELF symbol size.  So the next symbol after
copy_process() in the loaded module's address space might just be far
away.

That kallsyms issue has caused other headaches.  It really needs to be
fixed to use the actual ELF symbol size.

-- 
Josh

