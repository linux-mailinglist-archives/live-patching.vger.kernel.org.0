Return-Path: <live-patching+bounces-2743-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id YGTNJxv9AmpOzQEAu9opvQ
	(envelope-from <live-patching+bounces-2743-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Tue, 12 May 2026 12:12:43 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 3D8B451E53A
	for <lists+live-patching@lfdr.de>; Tue, 12 May 2026 12:12:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 571CA30A1276
	for <lists+live-patching@lfdr.de>; Tue, 12 May 2026 10:08:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EAE794C6F00;
	Tue, 12 May 2026 10:08:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="PBsdS/E1"
X-Original-To: live-patching@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8DC3824DD17;
	Tue, 12 May 2026 10:08:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778580491; cv=none; b=eyM4Z77nxwSpbtnn02cTPMDtemP1XoY09cm52Y7gj7mOdWO4p4v7+1I209Qh4LrvOY2DGxmoRpPVPIuH0hsircPAx/OeYt+sv44Vvm61aAJagJXupsNSi71YWpwa7tY53n//gxK8+fapxD/nCF2ALxM9SMBJgEjhpiXcGfQfVbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778580491; c=relaxed/simple;
	bh=eGr3fp5GkMU3CLAyOvVshZEVqHTmK+5CoHNUA1ui2AM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YJVreqxQkI0+GDNykN0Z4M52FOc3s/vMwFJf46S3aywSBAfGd4q2A5OqPwvz7mqG9ZWd41q6DeMA25opmwAQoxOycrqBkqFkuBSS0vn6qhvZDk97i27XAEkRAp1Kxp1H7jHmE9rOW76f+zQGkAatd7QchgjLpxyn/uTMrwgA6a8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=PBsdS/E1; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8B4011691;
	Tue, 12 May 2026 03:08:03 -0700 (PDT)
Received: from J2N7QTR9R3 (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 30BAA3F7B4;
	Tue, 12 May 2026 03:08:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1778580488; bh=eGr3fp5GkMU3CLAyOvVshZEVqHTmK+5CoHNUA1ui2AM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=PBsdS/E1/7LU87K3e2zSG7GwqBKdw0z6IXR13j6V0WLW1hx0Z9RWZWJfjQEKvPf6W
	 TWn6Wk5ixhN9UqwAej3RYb/DoVXTDG8hPjMAswwW3ZJvHoSJSo6VtS91oyF8tZIdXr
	 5627kLrYOzsVr/rx/r0ITxVGeEG/eDj5a6I7yCCQ=
Date: Tue, 12 May 2026 11:07:59 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Dylan Hatch <dylanbhatch@google.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>,
	Weinan Liu <wnliu@google.com>, Will Deacon <will@kernel.org>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Indu Bhagat <ibhagatgnu@gmail.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Jiri Kosina <jikos@kernel.org>, Jens Remus <jremus@linux.ibm.com>,
	Prasanna Kumar T S M <ptsm@linux.microsoft.com>,
	Puranjay Mohan <puranjay@kernel.org>, Song Liu <song@kernel.org>,
	joe.lawrence@redhat.com, linux-toolchains@vger.kernel.org,
	linux-kernel@vger.kernel.org, live-patching@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [PATCH v5 8/8] unwind: arm64: Use sframe to unwind interrupt
 frames
Message-ID: <agL7_3RD8RrfiucX@J2N7QTR9R3>
References: <20260428183643.3796063-1-dylanbhatch@google.com>
 <20260428183643.3796063-9-dylanbhatch@google.com>
 <afTYzAF_x41pyilu@J2N7QTR9R3>
 <CADBMgpx9YxNUO6wLP7mYKxWW8L78Hk9gPwHrMjXUwPyUmGEu9w@mail.gmail.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CADBMgpx9YxNUO6wLP7mYKxWW8L78Hk9gPwHrMjXUwPyUmGEu9w@mail.gmail.com>
X-Rspamd-Queue-Id: 3D8B451E53A
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[arm.com,none];
	R_DKIM_ALLOW(-0.20)[arm.com:s=foss];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-2743-lists,live-patching=lfdr.de];
	FREEMAIL_CC(0.00)[linux.dev,google.com,kernel.org,gmail.com,infradead.org,goodmis.org,arm.com,linux.ibm.com,linux.microsoft.com,redhat.com,vger.kernel.org,lists.infradead.org];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[20];
	DKIM_TRACE(0.00)[arm.com:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[mark.rutland@arm.com,live-patching@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[arm.com:email,arm.com:dkim,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Action: no action

On Mon, May 11, 2026 at 08:00:21PM -0700, Dylan Hatch wrote:
> Hi Mark,
> 
> Thanks for all the feedback and help on this. I'm planning on getting
> your comments addressed in the coming days, but I have some initial
> clarifying questions.
> 
> On Fri, May 1, 2026 at 9:46 AM Mark Rutland <mark.rutland@arm.com> wrote:
> >
> > Hi Dylan,
> >
> > Thanks for putting this together. I think this is looking pretty good.
> > However, there are some things that aren't quite right and need some
> > work, which I've commented on below.
> >
> > More generally, there are a few things that aren't addressed by this
> > series that we will also need to address. Importantly:
> >
> > (1) For correctness, we'll need to address a latent issue with unwinding
> >     across an fgraph return trampoline, where the return address is
> >     transiently unrecoverable.
> >
> >     Before this series, that doesn't matter for livepatching because the
> >     livepatching code isn't called synchronously within the fgraph
> >     handler, and unwinds which cross an exception boundary are marked as
> >     unreliable.
> >
> >     After this series, that does matter as we can unwind across an
> >     exception boundary, and might happen to interrupt that transient
> >     window.
> >
> >     I think we can solve that with some restructuring of that code,
> >     restoring the original address *before* removing that from the
> >     fgraph return stack, and ensuring that the unwinder can find it.
> 
> If my understanding is correct, the issue arrises in return_to_handler
> as the return address is recovered:
> 
> mov x0, sp
> bl ftrace_return_to_handler // addr = ftrace_return_to_hander(fregs);
> mov x30, x0 // restore the original return address
> 
> Because ftrace_return_to_handler pops the return address from the
> return stack before it can be restored into the LR, it cannot be
> recovered.

Yes.

To be clear, please don't worry about solving that for the next version
of this series; let's get the SFrame bits into shape first. I just
wanted to highlight that there's some more general work that we'll need
to do.

I think we can *detect* this case (and mark the unwind as unreliable)
with some tiny changes to the arm64 code. I'm happy to put that
together.

> Based on this, I believe you are suggesting to restructure this code
> path such that the return address is removed from the return stack
> only after it has been restored to LR. But since kernel/trace/fgraph.c
> is core kernel code, will this end up requiring either (1) a similar
> restructuring of other arches supporting ftrace, or (2) an
> arm64-specific implementation of this recovery logic?

Yes, I am say that to *recover* the address we'd need to make changes to
core code.

In the mean time we can *detect* this case with some minimal changes to
arm64 code, and abort. As above, I'm happy to go put that together.

> It looks to me like there is essentially the same recovery pattern on
> other arches; is there a reason this transient unrecoverability isn't
> an issue for reliable unwind on other platforms?

Yep; on all architectures there's a transient period where the address
cannot be recovered. It's not a correctness issue so long as the
architecture detects this case and marks the unwind as unreliable.

IIUC x86 will mark the unwind as unreliable in this case.

I don't know whether other architectures detect this reliably. That's a
question for loonarch, parisc, powerpc, and s390 folk.

> >     I'm not immediately sure whether kretprobes has a similar issue.
> >
> > (2) To make unwinding generally possible, we'll need to annotate some
> >     assembly functions as unwindable. We'll need to do that for string
> >     routines under lib/, and probably some crypto code, but we don't
> >     need to do that for most code in head.S, entry.S, etc.
> >
> >     The vast majority of relevant assembly functions are leaf functions
> >     (where the return address is never moved out of the LR), so we can
> >     probably get away with a simple annotation for those that avoids the
> >     need for open-coded CFI directives everywhere.
> 
> Are you suggesting something like a SYM_LEAF_FUNC_(START|END), that
> wraps CFI directives for leaf functions?

Yep; that's exactly the sort of thing I was thinking of.

That or have a seaprate annotation we can add, e.g.

SYM_FUNC_START(foo)
SYM_FUN_END(foo)
SYM_FUNC_IS_LEAF_AND_DOES_NOT_TOUCH_LR(foo)

> > I've pushed some reliable stacktrace tests to:
> >
> >   git://git.kernel.org/pub/scm/linux/kernel/git/mark/linux.git stacktrace/tests
> >
> > That finds the fgraph issue (regardless of this series). When merged
> > with this series triggers a warning in kunwind_next_frame_record_meta(),
> > where unwind_next_frame_sframe() calls that erroneously as a fallback.
> 
> Thanks for the pointer on these tests, they're super useful! I've been
> able to reproduce the fgraph failure you mentioned.

Great!

Mark.

