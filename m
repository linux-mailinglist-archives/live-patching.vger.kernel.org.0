Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E775E345EE6
	for <lists+live-patching@lfdr.de>; Tue, 23 Mar 2021 14:05:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231371AbhCWNFS (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 23 Mar 2021 09:05:18 -0400
Received: from foss.arm.com ([217.140.110.172]:46064 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231360AbhCWNEu (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Tue, 23 Mar 2021 09:04:50 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C2128106F;
        Tue, 23 Mar 2021 06:04:49 -0700 (PDT)
Received: from C02TD0UTHF1T.local (unknown [10.57.24.204])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 47F0A3F719;
        Tue, 23 Mar 2021 06:04:48 -0700 (PDT)
Date:   Tue, 23 Mar 2021 13:04:37 +0000
From:   Mark Rutland <mark.rutland@arm.com>
To:     "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
Cc:     broonie@kernel.org, jpoimboe@redhat.com, jthierry@redhat.com,
        catalin.marinas@arm.com, will@kernel.org,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 4/8] arm64: Detect an EL1 exception frame and mark
 a stack trace unreliable
Message-ID: <20210323130425.GA98545@C02TD0UTHF1T.local>
References: <5997dfe8d261a3a543667b83c902883c1e4bd270>
 <20210315165800.5948-1-madvenka@linux.microsoft.com>
 <20210315165800.5948-5-madvenka@linux.microsoft.com>
 <20210323104251.GD95840@C02TD0UTHF1T.local>
 <c4a36a6f-c84f-1ad9-cd03-974f6a39c37b@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c4a36a6f-c84f-1ad9-cd03-974f6a39c37b@linux.microsoft.com>
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue, Mar 23, 2021 at 07:46:10AM -0500, Madhavan T. Venkataraman wrote:
> On 3/23/21 5:42 AM, Mark Rutland wrote:
> > On Mon, Mar 15, 2021 at 11:57:56AM -0500, madvenka@linux.microsoft.com wrote:
> >> From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
> >>
> >> EL1 exceptions can happen on any instruction including instructions in
> >> the frame pointer prolog or epilog. Depending on where exactly they happen,
> >> they could render the stack trace unreliable.
> >>
> >> If an EL1 exception frame is found on the stack, mark the stack trace as
> >> unreliable.
> >>
> >> Now, the EL1 exception frame is not at any well-known offset on the stack.
> >> It can be anywhere on the stack. In order to properly detect an EL1
> >> exception frame the following checks must be done:
> >>
> >> 	- The frame type must be EL1_FRAME.
> >>
> >> 	- When the register state is saved in the EL1 pt_regs, the frame
> >> 	  pointer x29 is saved in pt_regs->regs[29] and the return PC
> >> 	  is saved in pt_regs->pc. These must match with the current
> >> 	  frame.
> > 
> > Before you can do this, you need to reliably identify that you have a
> > pt_regs on the stack, but this patch uses a heuristic, which is not
> > reliable.
> > 
> > However, instead you can identify whether you're trying to unwind
> > through one of the EL1 entry functions, which tells you the same thing
> > without even having to look at the pt_regs.
> > 
> > We can do that based on the entry functions all being in .entry.text,
> > which we could further sub-divide to split the EL0 and EL1 entry
> > functions.
> 
> Yes. I will check the entry functions. But I still think that we should
> not rely on just one check. The additional checks will make it robust.
> So, I suggest that the return address be checked first. If that passes,
> then we can be reasonably sure that there are pt_regs. Then, check
> the other things in pt_regs.

What do you think this will catch?

The only way to correctly identify whether or not we have a pt_regs is
to check whether we're in specific portions of the EL1 entry assembly
where the regs exist. However, as any EL1<->EL1 transition cannot be
safely unwound, we'd mark any trace going through the EL1 entry assembly
as unreliable.

Given that, I don't think it's useful to check the regs, and I'd prefer
to avoid the subtlteties involved in attempting to do so.

[...]

> >> +static void check_if_reliable(unsigned long fp, struct stackframe *frame,
> >> +			      struct stack_info *info)
> >> +{
> >> +	struct pt_regs *regs;
> >> +	unsigned long regs_start, regs_end;
> >> +
> >> +	/*
> >> +	 * If the stack trace has already been marked unreliable, just
> >> +	 * return.
> >> +	 */
> >> +	if (!frame->reliable)
> >> +		return;
> >> +
> >> +	/*
> >> +	 * Assume that this is an intermediate marker frame inside a pt_regs
> >> +	 * structure created on the stack and get the pt_regs pointer. Other
> >> +	 * checks will be done below to make sure that this is a marker
> >> +	 * frame.
> >> +	 */
> > 
> > Sorry, but NAK to this approach specifically. This isn't reliable (since
> > it can be influenced by arbitrary data on the stack), and it's far more
> > complicated than identifying the entry functions specifically.
> 
> As I mentioned above, I agree that we should check the return address. But
> just as a precaution, I think we should double check the pt_regs.
> 
> Is that OK with you? It does not take away anything or increase the risk in
> anyway. I think it makes it more robust.

As above, I think that the work necessary to correctly access the regs
means that it's not helpful to check the regs themselves. If you have
something in mind where checking the regs is helpful I'm happy to
consider that, but my general preference would be to stay away from the
regs for now.

Thanks,
Mark.
