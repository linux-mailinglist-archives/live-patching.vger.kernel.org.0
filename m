Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE42B346189
	for <lists+live-patching@lfdr.de>; Tue, 23 Mar 2021 15:34:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232114AbhCWOdy (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 23 Mar 2021 10:33:54 -0400
Received: from foss.arm.com ([217.140.110.172]:47416 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231830AbhCWOdu (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Tue, 23 Mar 2021 10:33:50 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D6C8BD6E;
        Tue, 23 Mar 2021 07:33:49 -0700 (PDT)
Received: from C02TD0UTHF1T.local (unknown [10.57.24.204])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D98F03F719;
        Tue, 23 Mar 2021 07:33:47 -0700 (PDT)
Date:   Tue, 23 Mar 2021 14:33:45 +0000
From:   Mark Rutland <mark.rutland@arm.com>
To:     "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
Cc:     broonie@kernel.org, jpoimboe@redhat.com, jthierry@redhat.com,
        catalin.marinas@arm.com, will@kernel.org,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 4/8] arm64: Detect an EL1 exception frame and mark
 a stack trace unreliable
Message-ID: <20210323143345.GC98545@C02TD0UTHF1T.local>
References: <5997dfe8d261a3a543667b83c902883c1e4bd270>
 <20210315165800.5948-1-madvenka@linux.microsoft.com>
 <20210315165800.5948-5-madvenka@linux.microsoft.com>
 <20210323104251.GD95840@C02TD0UTHF1T.local>
 <c4a36a6f-c84f-1ad9-cd03-974f6a39c37b@linux.microsoft.com>
 <20210323130425.GA98545@C02TD0UTHF1T.local>
 <f5dd48d3-c0ea-a719-c10d-83e62db3e7c0@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f5dd48d3-c0ea-a719-c10d-83e62db3e7c0@linux.microsoft.com>
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue, Mar 23, 2021 at 08:31:50AM -0500, Madhavan T. Venkataraman wrote:
> On 3/23/21 8:04 AM, Mark Rutland wrote:
> > On Tue, Mar 23, 2021 at 07:46:10AM -0500, Madhavan T. Venkataraman wrote:
> >> On 3/23/21 5:42 AM, Mark Rutland wrote:
> >>> On Mon, Mar 15, 2021 at 11:57:56AM -0500, madvenka@linux.microsoft.com wrote:
> >>>> From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
> >>>>
> >>>> EL1 exceptions can happen on any instruction including instructions in
> >>>> the frame pointer prolog or epilog. Depending on where exactly they happen,
> >>>> they could render the stack trace unreliable.
> >>>>
> >>>> If an EL1 exception frame is found on the stack, mark the stack trace as
> >>>> unreliable.
> >>>>
> >>>> Now, the EL1 exception frame is not at any well-known offset on the stack.
> >>>> It can be anywhere on the stack. In order to properly detect an EL1
> >>>> exception frame the following checks must be done:
> >>>>
> >>>> 	- The frame type must be EL1_FRAME.
> >>>>
> >>>> 	- When the register state is saved in the EL1 pt_regs, the frame
> >>>> 	  pointer x29 is saved in pt_regs->regs[29] and the return PC
> >>>> 	  is saved in pt_regs->pc. These must match with the current
> >>>> 	  frame.
> >>>
> >>> Before you can do this, you need to reliably identify that you have a
> >>> pt_regs on the stack, but this patch uses a heuristic, which is not
> >>> reliable.
> >>>
> >>> However, instead you can identify whether you're trying to unwind
> >>> through one of the EL1 entry functions, which tells you the same thing
> >>> without even having to look at the pt_regs.
> >>>
> >>> We can do that based on the entry functions all being in .entry.text,
> >>> which we could further sub-divide to split the EL0 and EL1 entry
> >>> functions.
> >>
> >> Yes. I will check the entry functions. But I still think that we should
> >> not rely on just one check. The additional checks will make it robust.
> >> So, I suggest that the return address be checked first. If that passes,
> >> then we can be reasonably sure that there are pt_regs. Then, check
> >> the other things in pt_regs.
> > 
> > What do you think this will catch?
> 
> I am not sure that I have an exact example to mention here. But I will attempt
> one. Let us say that a task has called arch_stack_walk() in the recent past.
> The unwinder may have copied a stack frame onto some location in the stack
> with one of the return addresses we check. Let us assume that there is some
> stack corruption that makes a frame pointer point to that exact record. Now,
> we will get a match on the return address on the next unwind.

I don't see how this is material to the pt_regs case, as either:

* When the unwinder considers this frame, it appears to be in the middle
  of an EL1 entry function, and the unwinder must mark the unwinding as
  unreliable regardless of the contents of any regs (so there's no need
  to look at the regs).

* When the unwinder considers this frame, it does not appear to be in
  the middle of an EL1 entry function, so the unwinder does not think
  there are any regs to consider, and so we cannot detect this case.

... unless I've misunderstood the example?

There's a general problem that it's possible to corrupt any portion of
the chain to skip records, e.g.

  A -> B -> C -> D -> E -> F -> G -> H -> [final]

... could get corrupted to:

  A -> B -> D -> H -> [final]

... regardless of whether C/E/F/G had associated pt_regs. AFAICT there's
no good way to catch this generally unless we have additional metadata
to check the unwinding against.

The likelihood of this happening without triggering other checks is
vanishingly low, and as we don't have a reliable mechanism for detecting
this, I don't think it's worthwhile attempting to do so.

If and when we try to unwind across EL1 exception boundaries, the
potential mismatch between the frame record and regs will be more
significant, and I agree at that point thisd will need more thought.

> Pardon me if the example is somewhat crude. My point is that it is
> highly unlikely but not impossible for the return address to be on the
> stack and for the unwinder to get an unfortunate match.

I agree that this is possible in theory, but as above I don't think this
is a practical concern.

Thanks,
Mark.
