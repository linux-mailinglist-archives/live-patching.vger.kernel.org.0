Return-Path: <live-patching+bounces-1193-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7CC96A35886
	for <lists+live-patching@lfdr.de>; Fri, 14 Feb 2025 09:09:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 839691883CC9
	for <lists+live-patching@lfdr.de>; Fri, 14 Feb 2025 08:09:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 26D08221D8B;
	Fri, 14 Feb 2025 08:08:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WAmbBAwG"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBD4022155B;
	Fri, 14 Feb 2025 08:08:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739520531; cv=none; b=o2NHoF6Rnyta8vGquYVr9ZO1X8NrD+5j2ojpb/KLB75SHljlk465M+F3/BwREr4d2jz+6XVlHs6omd7ndeNlR0Jsj+qOAD5+5LQgHFbrQrhydy7ZXpwIQMFq2ZVArLGpzIQ3X3ihsZjIAiKvlK8+zG3Ew/Sx53c2f3HuZvV2k2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739520531; c=relaxed/simple;
	bh=8fIq6lw3P3TyFk9U6Dky3t367XWONU83XLGY7Ec0/4Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NFJ6/BpN/6QnABtKGkGYc0Rfuk7e4KnvPKvuS2+wbCTWxi2bmfjVTQH4rNPtv6nlM9KV7eW4BHKpLObzudvQ0Qeyc1mNw9/jD9vmEmu3qh93tJGNqIp0urCfHT66mlANWmmb3n/eNeOEF8Ij7x8THAwOq/aQy+Eglmg75/5eOpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WAmbBAwG; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6F8EC4CED1;
	Fri, 14 Feb 2025 08:08:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739520530;
	bh=8fIq6lw3P3TyFk9U6Dky3t367XWONU83XLGY7Ec0/4Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=WAmbBAwGJaDrisyAiRs7d6rtf1gEdYFkfp2NxA37drWHXg0ZJycOZbKFzG+K+n58c
	 kVqbfGYP0N+qw0mdFfdJwtB2kZKOGnnz4rIkWlZNfcMu49sOrMGYOoJdgD6A/sSUgL
	 rCDxUH+P6CQe4T14lFvFL9CftGviplC7hsZjU876WerR43VCpYG5BgVajipmnA8NPC
	 xzmjps1vFBEYM85bXiu5BWXDc+2zE3Kaw8HScv+5yFn3kf2Ol+3++YVIwEbsVWqAT2
	 T1SIWlNxLGr9S05gk77oaRACklsGRKwz6P8K5jP07GF7ocZ+CWKfDBruAz6MsGhlVE
	 P98kVABruTf+A==
Date: Fri, 14 Feb 2025 00:08:48 -0800
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
Message-ID: <20250214080848.5xpi2y2omk4vxyoj@jpoimboe>
References: <20250127213310.2496133-1-wnliu@google.com>
 <CAPhsuW6S1JPn0Dp+bhJiSVs9iUv7v7HThBSE85iaDAvw=_2TUw@mail.gmail.com>
 <20250212234946.yuskayyu4gx3ul7m@jpoimboe>
 <CAPhsuW5TeMXi_Mn8+jR9Qoa=rAWasMo7M3Hs=im6NT6=+CrxqA@mail.gmail.com>
 <20250213024507.mvjkalvyqsxihp54@jpoimboe>
 <CAPhsuW4iDuTBfZowJRhxLFyK=g=s+-pK2Eq4+SNj9uL99eNkmw@mail.gmail.com>
 <mb61py0yaz3qq.fsf@kernel.org>
 <CAPhsuW7dV7UR3PsGVx_DLBH5-95DAmLMGTPuY0NfUwWLZMSTrQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAPhsuW7dV7UR3PsGVx_DLBH5-95DAmLMGTPuY0NfUwWLZMSTrQ@mail.gmail.com>

On Thu, Feb 13, 2025 at 11:40:43AM -0800, Song Liu wrote:
> Yeah, objdump does show the same disassembly. However, if
> I open the file with gdb, and do "disassemble copy_process",
> the one in livepatch-special-static.o looks very weird.

The symbol table looks ok.  I'm not sure why gdb is getting confused,
but that could possibly be a red herring.  Maybe it doesn't like the
-ffunction-sections for some reason.

It's really weird the function length reported by kallsyms is so wrong.
Can you share the .ko?

The refcount warning might indicate it's passing some bogus memory to
tty_kref_get().  Any chance you have struct randomization enabled?

Are you sure there's no code or .config mismatch between the built
kernel and the running kernel?

Ignorant arm64 question: is the module's text further away from slab
memory than vmlinux text, thus requiring a different instruction (or
GOT/TOC) to access memory further away in the address space?

-- 
Josh

