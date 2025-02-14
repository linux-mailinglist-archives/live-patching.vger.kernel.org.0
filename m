Return-Path: <live-patching+bounces-1210-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1C849A36850
	for <lists+live-patching@lfdr.de>; Fri, 14 Feb 2025 23:33:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 723033AC7B8
	for <lists+live-patching@lfdr.de>; Fri, 14 Feb 2025 22:33:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E79941D7985;
	Fri, 14 Feb 2025 22:33:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gk9AIpKP"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B41DA1519B5;
	Fri, 14 Feb 2025 22:33:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739572408; cv=none; b=gMB0kMfJ1OMi8fPtKs4OKDUDgedUoD0i+SFrtHkB+GJ2f9p8cXfbZFbtJp5rkPItnkVHbzcP9lGZYwSCG6LXFCPwaQwYyaDJpfX8BFH0hE+uG4XTlZdlHsPkIBwiuYh9iLmC8zMUmUAR/AoksHhTMYKj+pTirdvGVWL1Jfv7CGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739572408; c=relaxed/simple;
	bh=I0We4+HPs5dEfYhay/YlzzWO3zPvIdMYOxdN43pC8To=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=j/3Kl/ocJn2DSsWC4/UdRNhyz+Ct+R7DIww5l18v/C9DYzZj+w8DuOnXN++2RdQ7VnfNfPCgznyxAKjkz1gleWyqnWRcwH8l8DxZB0nCQDCywSqRkrhRHqLLWgBYij/iFU4MX9U1AgW6tH5+HHxPrRLPB8/ksyuJG4kMeLWpCFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gk9AIpKP; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AE53C4CED1;
	Fri, 14 Feb 2025 22:33:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739572408;
	bh=I0We4+HPs5dEfYhay/YlzzWO3zPvIdMYOxdN43pC8To=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gk9AIpKPgslAd8QCZWjsZYHVLZ4yoOxeYcGjCZCbJbZ0VeLu6fCzN3pqYz+JKeYKf
	 mlRTta9VKKWflFC1qT9QN7/tt/xKEBXctO5Ue/0BRIR1Yvevuk0RXWD6xXXmnEpBDG
	 c7gzl8AjapADNS6Jsbl/yfhhJeoSc5/Ux59NuVQpOHYkQh5Q3nb8Qu82XOkdkpupQl
	 0GUdIS7VqcjYvWkgVJyCDy9EtahkWWGJQJ/duqZSBfVapW0NgW5zMTi7AhGUso6686
	 ION1V/snvb2mgVAyvEmDzJq0/9VLWcFTSa+nG0J2oD++oY/ddsVbKxa/w+fqei6l9N
	 mzk1QjM7BxEBA==
Date: Fri, 14 Feb 2025 14:33:25 -0800
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Song Liu <song@kernel.org>
Cc: Puranjay Mohan <puranjay@kernel.org>, Weinan Liu <wnliu@google.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Indu Bhagat <indu.bhagat@oracle.com>, 
	Peter Zijlstra <peterz@infradead.org>, Mark Rutland <mark.rutland@arm.com>, roman.gushchin@linux.dev, 
	Will Deacon <will@kernel.org>, Ian Rogers <irogers@google.com>, 
	linux-toolchains@vger.kernel.org, linux-kernel@vger.kernel.org, live-patching@vger.kernel.org, 
	joe.lawrence@redhat.com, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 0/8] unwind, arm64: add sframe unwinder for kernel
Message-ID: <z3msrl3u5wxdulvlecvehzbsu3rpeul7ckbjf4cy7guhcszqpm@xn4yhenfbvok>
References: <20250212234946.yuskayyu4gx3ul7m@jpoimboe>
 <CAPhsuW5TeMXi_Mn8+jR9Qoa=rAWasMo7M3Hs=im6NT6=+CrxqA@mail.gmail.com>
 <20250213024507.mvjkalvyqsxihp54@jpoimboe>
 <CAPhsuW4iDuTBfZowJRhxLFyK=g=s+-pK2Eq4+SNj9uL99eNkmw@mail.gmail.com>
 <mb61py0yaz3qq.fsf@kernel.org>
 <CAPhsuW7dV7UR3PsGVx_DLBH5-95DAmLMGTPuY0NfUwWLZMSTrQ@mail.gmail.com>
 <20250214080848.5xpi2y2omk4vxyoj@jpoimboe>
 <CAPhsuW6dxPtgqZaHrZEVhQXwm2+sETreZnGybZXVKYKfG9H6tg@mail.gmail.com>
 <20250214193400.j4hp45jlufihv5eh@jpoimboe>
 <CAPhsuW6q+yhn0pGQb0K+RhXHYDkjEgomZ2pu3P_MEeX+xNRe0g@mail.gmail.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPhsuW6q+yhn0pGQb0K+RhXHYDkjEgomZ2pu3P_MEeX+xNRe0g@mail.gmail.com>

On Fri, Feb 14, 2025 at 02:04:17PM -0800, Song Liu wrote:
> Hi Josh,
> 
> On Fri, Feb 14, 2025 at 11:34 AM Josh Poimboeuf <jpoimboe@kernel.org> wrote:
> >
> > On Fri, Feb 14, 2025 at 09:51:41AM -0800, Song Liu wrote:
> > > > Ignorant arm64 question: is the module's text further away from slab
> > > > memory than vmlinux text, thus requiring a different instruction (or
> > > > GOT/TOC) to access memory further away in the address space?
> > >
> > > It appears to me the module text is very close to vmlinux text:
> > >
> > > vmlinux: ffff8000800b4b68 T copy_process
> > > module: ffff80007b0f06d0 t copy_process [livepatch_always_inline_special_static]
> >
> > Hm... the only other thing I can think of is that the klp relas might be
> > wrong somewhere.  If you share patched.o and .ko files from the same
> > build I could take a look.
> 
> A tarball with these files is available here:
> 
> https://drive.google.com/file/d/1ONB1tC9oK-Z5ShmSXneqWLTjJgC5Xq-C/view?usp=drive_link

Thanks, I'll take a look.

> > That kallsyms issue has caused other headaches.  It really needs to be
> > fixed to use the actual ELF symbol size.
> 
> Maybe we should have a "module_text_end" symbol?

Maybe, though it would be a lot cleaner for kallsyms to just use the
actual ELF sizes.  And actually I'm thinking that would be a pretty
trivial change.

-- 
Josh

