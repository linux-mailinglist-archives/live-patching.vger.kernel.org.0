Return-Path: <live-patching+bounces-2710-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id kLovHGrK+WmFEAMAu9opvQ
	(envelope-from <live-patching+bounces-2710-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Tue, 05 May 2026 12:46:02 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F3E94CBBCC
	for <lists+live-patching@lfdr.de>; Tue, 05 May 2026 12:46:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 42E9630670EA
	for <lists+live-patching@lfdr.de>; Tue,  5 May 2026 10:30:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B10EC33D512;
	Tue,  5 May 2026 10:29:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="lqfZ4xUo"
X-Original-To: live-patching@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 72C8733ADA0;
	Tue,  5 May 2026 10:29:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777976991; cv=none; b=GxwFEe3B3wxBeGpTeWleZR8Tw4ZD/M/3ZMkikjUOerk5NjcQJDFLX+lDUpAr1AjoLXGGwW/KLabAYqqZKJRAdBEpyQR4CWspeFUcZuLHM8UdwCYjOh6bXU1OID4NGojLRIWpjDel46OZgFrdt/T14hT9slrTkpOnPfqZ0IFAMMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777976991; c=relaxed/simple;
	bh=08TGql+krOa3BosV5BsD4KJ5MPB96TCdNP+ZE4F3SPs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=alj8CYROtXfsXLCwzZyvCJ0drMYHmuBKd15Tqgt5Za1Cc7zRzG+YzD2hj+aFGum/VsAe4SAaxXm1VVXOw1jEd37okZqyq0PiZawOgnrNDoZQqjyjQh/aWgoD94Mld+nltnb+TRisOoKbN8XQgIqmM/NtJ186ZPAy/xvQaKnpx3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=lqfZ4xUo; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 74A55293B;
	Tue,  5 May 2026 03:29:43 -0700 (PDT)
Received: from J2N7QTR9R3 (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 398893F763;
	Tue,  5 May 2026 03:29:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1777976988; bh=08TGql+krOa3BosV5BsD4KJ5MPB96TCdNP+ZE4F3SPs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lqfZ4xUoCsNqC5HY3E7TR5zeUQNYf66Q8WL6GMQf2YbiCJzKAbvV+p05VPcURQ/M0
	 lS0ppoHeUpKFesFuMFPRMwS5prTlAKioeN4cmNvnqf8jbVbKPzh1AFpJv8FIxCgUFi
	 Yw2KI23W5wTSadwIyoESM38YVj4K0t5lgX0cOQZ0=
Date: Tue, 5 May 2026 11:29:26 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Jens Remus <jremus@linux.ibm.com>
Cc: Dylan Hatch <dylanbhatch@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Weinan Liu <wnliu@google.com>, Will Deacon <will@kernel.org>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Indu Bhagat <ibhagatgnu@gmail.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Jiri Kosina <jikos@kernel.org>,
	Prasanna Kumar T S M <ptsm@linux.microsoft.com>,
	Puranjay Mohan <puranjay@kernel.org>, Song Liu <song@kernel.org>,
	joe.lawrence@redhat.com, linux-toolchains@vger.kernel.org,
	linux-kernel@vger.kernel.org, live-patching@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Randy Dunlap <rdunlap@infradead.org>,
	Heiko Carstens <hca@linux.ibm.com>
Subject: Re: [PATCH v5 8/8] unwind: arm64: Use sframe to unwind interrupt
 frames
Message-ID: <afnGhsCYEUG0LXR5@J2N7QTR9R3>
References: <20260428183643.3796063-1-dylanbhatch@google.com>
 <20260428183643.3796063-9-dylanbhatch@google.com>
 <afTYzAF_x41pyilu@J2N7QTR9R3>
 <bc3fb59b-9d80-4957-af51-20db38e3487e@linux.ibm.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bc3fb59b-9d80-4957-af51-20db38e3487e@linux.ibm.com>
X-Rspamd-Queue-Id: 7F3E94CBBCC
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[arm.com,none];
	R_DKIM_ALLOW(-0.20)[arm.com:s=foss];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-2710-lists,live-patching=lfdr.de];
	FREEMAIL_CC(0.00)[google.com,linux.dev,kernel.org,gmail.com,infradead.org,goodmis.org,arm.com,linux.microsoft.com,redhat.com,vger.kernel.org,lists.infradead.org,linux.ibm.com];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[21];
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
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[arm.com:dkim,sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,sourceware.org:url]

On Mon, May 04, 2026 at 10:47:26AM +0200, Jens Remus wrote:
> Hello Mark,
> 
> I mostly have comments regarding your the SFrame related remarks.

Thanks for this; I have a few more questions and comments below.

> On 5/1/2026 6:46 PM, Mark Rutland wrote:
> > Thanks for putting this together. I think this is looking pretty good.
> > However, there are some things that aren't quite right and need some
> > work, which I've commented on below.
> 
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
> Wrapping them in .cfi_startproc ... .cfi_endproc should do.  For instance
> by extending SYM_FUNC_START() and SYM_FUNC_END() or introducing flavors
> that do.  Or where you thinking of something else?

I was expecting we'd do something like that, either with distinct
versions, or some entirely separate annotation.

We can't override SYM_FUNC_START() or SYM_FUNC_END() since those are
also used for non-leaf functions. The bulk of the work is going to be
making sure we only annotate leaf functions specifically, which will
require some human analysis.

> > On Tue, Apr 28, 2026 at 06:36:43PM +0000, Dylan Hatch wrote:
> >> diff --git a/arch/arm64/include/asm/stacktrace/common.h b/arch/arm64/include/asm/stacktrace/common.h
> 
> >> @@ -21,6 +21,8 @@ struct stack_info {
> >>   *
> >>   * @fp:          The fp value in the frame record (or the real fp)
> >>   * @pc:          The lr value in the frame record (or the real lr)
> >> + * @sp:          The sp value at the call site of the current function.
> >> + * @unreliable:  Stacktrace is unreliable.
> >>   *
> >>   * @stack:       The stack currently being unwound.
> >>   * @stacks:      An array of stacks which can be unwound.
> >> @@ -29,7 +31,11 @@ struct stack_info {
> >>  struct unwind_state {
> >>  	unsigned long fp;
> >>  	unsigned long pc;
> >> +#ifdef CONFIG_HAVE_UNWIND_KERNEL_SFRAME
> >> +	unsigned long sp;
> >> +#endif
> > 
> > As this is only used by the kernel unwinder (and not the hyp unwinder),
> > this should live in struct kunwind_state in stacktrace.c.
> > 
> > That said, for unwinding across exception boundaries we should not need
> > this, as the SP value will be in the pt_regs. If we only use SFrame for
> > the exception boundary case, we can remove this entirely. I would
> > strongly prefer that we do that.

> >> +	/* Get the Canonical Frame Address (CFA) */
> >> +	switch (frame.cfa.rule) {
> >> +	case UNWIND_CFA_RULE_SP_OFFSET:
> >> +		cfa = state->common.sp;
> 
> IIUC you suggest this to be changed as follows?
> 
> 		cfa = regs->regs[31];

I was suggesting:

		cfa = regs->sp;

Note: arm64's struct pt_regs has:

	union {
		struct user_pt_regs user_regs;
		struct {
			u64 regs[31];
			u64 sp;
			u64 pc;
			u64 pstate;
		};
	};	

... so regs->regs[31] would be an out-of-bounds array access.

[...]

> >> +	case UNWIND_CFA_RULE_REG_OFFSET:
> >> +	case UNWIND_CFA_RULE_REG_OFFSET_DEREF:
> >> +		/* regs only available in topmost/interrupt frame */
> >> +		if (!regs || frame.cfa.regnum > 30)
> >> +			return -EINVAL;
> >> +		cfa = regs->regs[frame.cfa.regnum];
> >> +		break;
> > 
> > Do we ever expect to see UNWIND_CFA_RULE_REG_OFFSET or
> > UNWIND_CFA_RULE_REG_OFFSET_DEREF in practice for kernel code?
> 
> No.  Those can only occur with SFrame V3 flexible FDE, which are
> currently not generated by GNU assembler for arm64/aarch64, and thus
> could be omitted in the arm64-specific kernel sframe unwinder:
> 
> https://sourceware.org/git/?p=binutils-gdb.git;a=blob;f=gas/config/tc-aarch64.h;hb=binutils-2_46#l342

Ok.

Do we know whether there are currently cases on aarch64 that cannot be
encoded in SFrame (without flexible FDE), or whether SFrame without
flexible FDE is sufficient for arm64 as-is? ... or do we have
counter-examples today?

Looking at:

  https://sourceware.org/binutils/docs/sframe-spec.html#Flexible-FDE-Type-Interpretation-1

For arm64 I'm not sure whether we'd encounter the DRAP or stack
realignment cases within the kernel (perhaps with SVE?), nor whether the
Register-based RA/FP Locations cases would apply if we assume that we
continue to use frame records.

[... ]

> I must admit that while reviewing I thought it would be future-proof to
> have support for rules that can only be represented with SFrame V3
> flexible FDE, even if they are currently not used on arm64.  Ideally
> kunwind_next_sframe() could be made common, if another architecture
> would implement kernel unwinding using sframe.

While I understand that principle, I think that for now it would be
better to keep this arch-specific and minimal:

* We have arch-specific concerns (e.g. the FRAME_META_TYPE_FINAL
  frames), and factoring that into generic code is going to be painful
  to adapt (which we're likely to need to do in the near future), and to
  maintain going forwards. Keeping that arch-specific for now will make
  it easier/quicker to get to a stable state.

* Code which isn't used is liable to be wrong or made wrong by accident.
  For example, with all the SP cases I mentioned in my initial reply.

We can certainly look at making that more generic in future, but for now
I'd prefer to omit the code that cannot be used (and have some sort of
build or boot/module-load time check that SFrame only has elements that
we expect), and make sure that we thoroughly test the cases that do
exist in practice.

Do we expect SFrame V3 flexible FDE to be generated by toolchains in the
near future?

[...]

> >> +	/* CFA alignment 8 bytes */
> >> +	if (cfa & 0x7)
> >> +		return -EINVAL;
> > 
> > If the CFA is the SP upon entry to the function, then per AAPCS64 rules
> > it should be aligned to 16 bytes. Otherwise, where has this 8 byte
> > alignment requirement come from? Does SFrame mandate that?
> 
> That originates from the common unwind user logic (see
> kernel/unwind/user.c, unwind_user_next_common()), which currently
> assumes 8-byte/4-byte SP alignment for all 64-bit/32-bit architectures.
> 
> So checking for 16-byte alignment here would make sense.

Just to confirm, am I correct to understand that the SFrame definition
of CFA is intended to be the same as the DWARF definition of CFA, and so
for arm64 the CFA is the SP when the function is called?

That's the case for DWARF on arm64:

  https://github.com/ARM-software/abi-aa/releases/download/2025Q4/aadwarf64.pdf
  https://github.com/ARM-software/abi-aa/blob/daa7a94ca55973736c0e434a67a6e4bbcd35d7fa/aadwarf64/aadwarf64.rst

| The CFA is the value of the stack pointer (sp) at the call site in the
| previous frame.

I couldn't find an explciit statement to that effect in:

  https://sourceware.org/binutils/docs/sframe-spec.html

... but I guess that is implied, given the other bits inherited from
DWARF.

I see that the documented behaviour for CFA on AMD64 and s390x are
consistent with their DWARF behaviour.

> >> +
> >> +	/* Get the Return Address (RA) */
> >> +	switch (frame.ra.rule) {
> >> +	case UNWIND_RULE_RETAIN:
> >> +		/* regs only available in topmost/interrupt frame */
> >> +		if (!regs)
> >> +			return -EINVAL;
> >> +		ra = regs->regs[30];
> >> +		source = KUNWIND_SOURCE_REGS_LR;
> >> +		break;
> >> +	/* UNWIND_USER_RULE_CFA_OFFSET not implemented on purpose */
> 
> Nit: s/UNWIND_USER_RULE_CFA_OFFSET/UNWIND_RULE_CFA_OFFSET/
> 
> > 
> > It would be better for the comment to say *why* that's not implemented.
> > 
> > I assume that's because UNWIND_USER_RULE_CFA_OFFSET would mean that the return
> > address is a stack address, and that's obviously not legitimate.
> 
> That and SFrame V3 currently cannot represent FP/RA as CFA + offset
> (i.e. UNWIND_RULE_CFA_OFFSET; .cfi_val_offset FP/RA).
> 
> The comment originates from the common unwind user logic (see
> kernel/unwind/user.c).  I am open to improve that.  What about:
> 
> 	/*
> 	 * UNWIND_RULE_CFA_OFFSET not implemented on purpose, as a stack
> 	 * address cannot be a legitimate return address value.  It is
> 	 * also not used (e.g. not represented in sframe).
> 	 */

I'd go with something simpler, e.g.

	/*
	 * UNWIND_RULE_CFA_OFFSET doesn't make sense for RA.
	 * The return address cannot legitimately be a stack addres.
	 */

[...]

> > 
> > I don't think we expect UNWIND_RULE_REG_OFFSET unless that's sometimes used
> > instead of UNWIND_RULE_RETAIN to express that the return address is in x30
> > (with zero offset).
> 
> No.  Unless there would be nonsense .cfi_register 30, 30, which would
> require SFrame V3 flexible FDE to be represented.

Ok.

> @Indu:  We may consider to treat .cfi_register <reg>, <reg> (for FP/RA)
> like .cfi_restore <reg> in the GNU assembler?
> 
> > Similarly, if the address is on the stack it should be in a frame
> > record. Would we ever expect UNWIND_RULE_REG_OFFSET_DEREF rather than
> > UNWIND_RULE_CFA_OFFSET_DEREF?
> 
> No.  See above (SFrame V3 flexible FDE).

Ok.

> >> +	default:
> >> +		WARN_ON_ONCE(1);
> >> +		return -EINVAL;
> >> +	}
> >> +
> >> +	/* Get the Frame Pointer (FP) */
> >> +	switch (frame.fp.rule) {
> >> +	case UNWIND_RULE_RETAIN:
> >> +		fp = state->common.fp;
> >> +		break;
> >> +	/* UNWIND_USER_RULE_CFA_OFFSET not implemented on purpose */
> > 
> > As for RA, the comment should explain why that's not implemented.
> 
> I am open to improve the comment in the the common unwind user logic.
> What about:
> 
> 	/*
> 	 * UNWIND_RULE_CFA_OFFSET not implemented on purpose, as it is
> 	 * not used (e.g. not represented in sframe).
> 	 */

For me, this wording raises more questions, e.g.

* Does 'not used' mean that toolchains don't use that, or that the spec
  doesn't permit that?

* Does 'not represented' mean that this is not represntable, or that
  toolchains currently don't generate SFrame with the appropriate
  elements.

IIUC you're saying that this *is* representable with flexible FDE, but
current toolchains don't generate that.

Mark.

