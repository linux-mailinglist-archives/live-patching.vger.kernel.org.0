Return-Path: <live-patching+bounces-2832-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 2AlxIIXlBmoHowIAu9opvQ
	(envelope-from <live-patching+bounces-2832-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Fri, 15 May 2026 11:21:09 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D783A54C4BF
	for <lists+live-patching@lfdr.de>; Fri, 15 May 2026 11:21:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id C5C2D31B5423
	for <lists+live-patching@lfdr.de>; Fri, 15 May 2026 08:59:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8911F4266A8;
	Fri, 15 May 2026 08:58:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="M+U8Z9rj"
X-Original-To: live-patching@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0052F42B754;
	Fri, 15 May 2026 08:58:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778835520; cv=none; b=sUwqY3fAetkJK7j1gsO4Fk9HxlXLnyCoMaQ1ZKYs8c33vwj9/xCDya5tl+kG1Abqlr2f1yR0aKOzJi3VjGPg99JdeeOq+LYyvkSc2q9I5NhipvvTXZ9RBYj7AncqaOOJX2YwWAhJ6GxMgQ+l63vPKkb56z7AmPYzODNrP3NNmek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778835520; c=relaxed/simple;
	bh=jV5bXdtpOjz07c8aVu/DQNoLK0X8K5E5q+WDYtjkBWE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=L57tLa6SXaAZdZbjjvMxF08JHOzAqgM1mf6UslXt44GVAGcGlzt2aLLfS1UkT3qz2ziIsEZpMPVF2SEl8aqVqZ/imUk4UltFHdgjss/nuK2a4zE4z/lh3QHEZZaGjkE+gBdc7jmoAb3yZUPE4SLXhMSA9M4KS0oWB/TnBMVmXjs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=M+U8Z9rj; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1877225E3;
	Fri, 15 May 2026 01:58:30 -0700 (PDT)
Received: from J2N7QTR9R3 (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8BCE23F7B4;
	Fri, 15 May 2026 01:58:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1778835515; bh=jV5bXdtpOjz07c8aVu/DQNoLK0X8K5E5q+WDYtjkBWE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=M+U8Z9rjEYBpu+LUUutT3hOsrHX0KM2xYEHMH5VcdHnMhIctVv91O/zvchkF/fd76
	 dSLPNQjmmCaFSbmwxX1n9fU4ly0gSlHynPkRXeze63jNZwCAlYvjCnNSzR2aQtZNuH
	 36Q9/1vMty1KtMjaIj+ByOXRL+xEWOdHGoJB19hA=
Date: Fri, 15 May 2026 09:58:25 +0100
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
Subject: Re: [PATCH v5 3/8] arm64: entry: add unwind info for various kernel
 entries
Message-ID: <agbgMb6jrgiFFHRX@J2N7QTR9R3>
References: <20260428183643.3796063-1-dylanbhatch@google.com>
 <20260428183643.3796063-4-dylanbhatch@google.com>
 <afIjFLbUrdxWA6eR@J2N7QTR9R3.cambridge.arm.com>
 <CADBMgpxBeYUdA5X8BPgkgz=KQyN=NQ760bXygwXfvVRScNzgbA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CADBMgpxBeYUdA5X8BPgkgz=KQyN=NQ760bXygwXfvVRScNzgbA@mail.gmail.com>
X-Rspamd-Queue-Id: D783A54C4BF
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[arm.com,none];
	R_DKIM_ALLOW(-0.20)[arm.com:s=foss];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-2832-lists,live-patching=lfdr.de];
	FREEMAIL_CC(0.00)[linux.dev,google.com,kernel.org,gmail.com,infradead.org,goodmis.org,arm.com,linux.ibm.com,linux.microsoft.com,redhat.com,vger.kernel.org,lists.infradead.org];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[arm.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[mark.rutland@arm.com,live-patching@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	RCPT_COUNT_TWELVE(0.00)[20];
	TO_DN_SOME(0.00)[]
X-Rspamd-Action: no action

On Thu, May 14, 2026 at 08:30:43PM -0700, Dylan Hatch wrote:
> On Wed, Apr 29, 2026 at 8:26 AM Mark Rutland <mark.rutland@arm.com> wrote:
> > On Tue, Apr 28, 2026 at 06:36:38PM +0000, Dylan Hatch wrote:
> > > From: Weinan Liu <wnliu@google.com>
> > >
> > > DWARF CFI (Call Frame Information) specifies how to recover the return
> > > address and callee-saved registers at each PC in a given function.
> > > Compilers are able to generate the CFI annotations when they compile
> > > the code to assembly language. For handcrafted assembly, we need to
> > > annotate them by hand.
> > >
> > > Annotate minimal CFI to enable stacktracing using SFrame for kernel
> > > exception entries through el1*_64_*() paths
> >
> > I thought we were only consuming SFrame when unwinding an exeption
> > boundary?
> >
> > We shouldn't be taking exceptions _from_ the entry assembly functions
> > unless something has gone horribly wrong, and so I don't see why we'd
> > need CFI entries for the entry assembly functions.
> >
> > Am I missing some reason we need CFI entries for the entry assembly
> > functions? I strongly suspect it is not necessary to add these, and I'd
> > prefer to omit them.
> 
> I believe the el1 entry functions are called in an exception, and are
> called before call_on_irq_stack. 

Yes, but I don't think that matters. See below for more details.

> Example stacktrace segment:
> 
> [  262.119564]  handle_percpu_devid_irq+0xb4/0x348
> [  262.119913]  handle_irq_desc+0x3c/0x68
> [  262.120196]  generic_handle_domain_irq+0x20/0x40
> [  262.120678]  gic_handle_irq+0x48/0xe0
> [  262.121005]  call_on_irq_stack+0x30/0x48
> [  262.121412]  do_interrupt_handler+0x88/0xa0
> [  262.121779]  el1_interrupt+0x38/0x58
> [  262.122089]  el1h_64_irq_handler+0x18/0x30
> [  262.122617]  el1h_64_irq+0x6c/0x70

The segment immediately above can be unwound using FP, as frame records
were created consistently, and there are no exception boundaries. No CFI
needed.

It's legitimate to take an exception from parts of call_on_irq_stack(),
so it makes sense for that to have CFI, but for the specific unwind
segment above, CFI isn't necessary.

Everything in the stacktrace segment above was executed *after* HW took
the exception.

<< EXCEPTION BOUNDARY HERE >>

Everything in the stacktrace segment(s) below was executed *before* HW
took the exception.

The unwinder knows that it has crossed this exception boundary by virtue
of finding a FRAME_META_TYPE_PT_REGS frame record.

> [  262.123159]  _raw_spin_unlock_irq+0x10/0x60 (P)

The unwinder knows that the value of pt_regs::pc was *definitely* the PC
at the time the exception was taken, so that entry is reliable. No CFI
needed.

> [  262.123720]  __filemap_add_folio+0x200/0x580 (L)

The unwinder doesn't know whether the LR should be used, and needs CFI
to determine that.

After this point, an FP unwind can be used until we encounter the next
exception boundary.

> [  262.124145]  filemap_add_folio+0xec/0x300
> [  262.124674]  page_cache_ra_unbounded+0x128/0x368
> [  262.125338]  do_page_cache_ra+0x70/0x98
> [  262.125875]  page_cache_ra_order+0x460/0x4e0

The segment immediately above can be unwound using FP. No CFI needed.

> Here, el1h_64_irq is the last function that appears in the exception
> stack before _raw_spin_unlock_irq and __filemap_add_folio are
> recovered from the saved PC and LR, respectively. So we therefore need
> the CFI annotations in order to unwind through the full exception
> boundary.
> 
> Is my interpretation here correct?

Given you say "full exception boundary" here, I think we might be using
the term "exception boundary" to mean different things.

As per the example above, I'm using "exception boundary" to mean the a
point between two entries in the stacktrace where HW took an exception.

Did my comments on the example help?

> > > and irq entries through call_on_irq_stack()
> >
> > Needing some sort of unwind annotations for call_on_irq_stack() makes
> > sense to me, but don't we need something for other assembly functions
> > too?
> >
> > We can interrupt things like memset(); I assume we'll treat those as
> > unreliable until annotated?
> 
> While looking into adding these annotations, I noticed a pattern where
> a sibling call is made to a local function:
> 
> SYM_FUNC_START(__pi_memset)
> alternative_if_not ARM64_HAS_MOPS
>         b       __pi_memset_generic
> alternative_else_nop_endif
> 
>         mov     dst, dstin
>         setp    [dst]!, count!, val_x
>         setm    [dst]!, count!, val_x
>         sete    [dst]!, count!, val_x
>         ret
> SYM_FUNC_END(__pi_memset)
> 
> In this case, do we consider the stacktrace unreliable since
> __pi_memset may not appear in the trace?

This is a tail-call, and __pi_memset_generic() will not return to
__pi_memset(). Once the branch to __pi_memset_generic() has been
executed, it's fine for __pi_memset() to not show up in the trace.

The key thing is that no more instructions from __pi_memset() itself
will be executed unless it was called again (from its entry point).

> Or is this not important because assembly functions cannot be directly
> livepatched anyway?

To the best of my knowledge, reliable stacktrace is only used to
determine whether any thread is still within an old version of a
patchable function (including where it's within a callee thereof).

I am not aware of a case where we'd need to detect whether a thread is
still within a non-patchable function, but I can't rule out that as a
possibility.

That's more of a question for the livepatching maintainers.

Thanks,
Mark.

