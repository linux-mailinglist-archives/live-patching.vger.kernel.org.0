Return-Path: <live-patching+bounces-1211-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8BD9FA36911
	for <lists+live-patching@lfdr.de>; Sat, 15 Feb 2025 00:23:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DCC903A1F35
	for <lists+live-patching@lfdr.de>; Fri, 14 Feb 2025 23:23:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9912D1FCF41;
	Fri, 14 Feb 2025 23:23:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Etk1v6vO"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A6311FC7CD;
	Fri, 14 Feb 2025 23:23:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739575425; cv=none; b=orV5Plcaoj2jTYnx20ae1YrGrmGJJnO4Ko7e/n5x64O/9+qrNeeA2CaRyDtHlPWOmhLtcxYV2chtrtV92H+Xu25LqrnlbQye18T/0Koru92wKkPoT28Sfq2Gy9zsgDbusFI49BprzhYHpDzFefVTLekX8uwlPbvj+QDXfqmr9Cc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739575425; c=relaxed/simple;
	bh=Yhq/C5gSgJ6cl34cEwCBrIztG271Bks4WJzIFA5Zmhc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lvwSgXLE0C6Z9mdEBkvLzJR+YH4F8saGAJd+CxOCDmhut9Ea7jehma98wylke9l6+VgGNov3HgS8gWYzMJ7JRns81UG0gCEOH8Iy35mLtM/O5CnjbqzMdUDPEIhLS5DD9bgs6j1uy+m4GOrAJmnQRzX14ciXXR2ExC1x5oC5AWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Etk1v6vO; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59BDDC4CED1;
	Fri, 14 Feb 2025 23:23:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739575424;
	bh=Yhq/C5gSgJ6cl34cEwCBrIztG271Bks4WJzIFA5Zmhc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Etk1v6vOaAAIg0XO1g/wK0jfLEDXElXxYj3ZBqwfuPAz+9rwu0xxKsmGQ9K8mAoy5
	 PLyLEnl/GMAPJrcLzop5aBOWv0OHv5OCVh0Vyv/pxVCJI3gANGzSBV6MsQL5b8XLVP
	 A4sYC4V/LEa30v66Qv3lG0Kr3eLRPqpGrjo4GZVY/sezZJYD17cE5nzRUZP/nHMgWC
	 Zc/q2h7f55E9XsASOacUgTBF4zQE/p66H4WwvckNTrL1WUNb8/Cepgg3i5eKEzKtJ1
	 C5m1lbBEzNhDBmIv97u9MNL+oc7fQ26OMxAfPo3rf9YXPwGuyX6IhrpS90JkLIiOLE
	 wYDr5RBTBH0aQ==
Date: Fri, 14 Feb 2025 15:23:42 -0800
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
Message-ID: <20250214232342.5m3hveygqb2qafpp@jpoimboe>
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

Poking around the arm64 module code, arch/arm64/kernel/module-plts.c
is looking at all the relocations in order to set up the PLT.  That also
needs to be done for klp relas, or are your patches already doing that?

-- 
Josh

