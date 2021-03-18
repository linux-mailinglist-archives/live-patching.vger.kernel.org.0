Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DCA334104F
	for <lists+live-patching@lfdr.de>; Thu, 18 Mar 2021 23:24:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231162AbhCRWXS (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 18 Mar 2021 18:23:18 -0400
Received: from linux.microsoft.com ([13.77.154.182]:60680 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230368AbhCRWWv (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 18 Mar 2021 18:22:51 -0400
Received: from [192.168.254.32] (unknown [47.187.194.202])
        by linux.microsoft.com (Postfix) with ESMTPSA id 47F42209C385;
        Thu, 18 Mar 2021 15:22:50 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 47F42209C385
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1616106170;
        bh=PxqNmQsDo2rsOIU7l0L48WnHUDlca3iv6Y4rPU2NjOg=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=dy+rDJewmHv0Jftz1A38quDC6GtDy/K2yVeTNmyD0ljxXwj4Eaq2HAlrt9QgTKmZz
         gfqxe863tIcam/QexESaStvgkdaax6Icj9dL2vHCrSXu20R3OVrQsFA2sFBsdVfkdU
         wVJiPYPLx6b0V8sPFLRrUM/fWdQKz6OZsh4YYJXw=
Subject: Re: [RFC PATCH v2 2/8] arm64: Implement frame types
To:     Mark Brown <broonie@kernel.org>
Cc:     mark.rutland@arm.com, jpoimboe@redhat.com, jthierry@redhat.com,
        catalin.marinas@arm.com, will@kernel.org,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
References: <5997dfe8d261a3a543667b83c902883c1e4bd270>
 <20210315165800.5948-1-madvenka@linux.microsoft.com>
 <20210315165800.5948-3-madvenka@linux.microsoft.com>
 <20210318174029.GM5469@sirena.org.uk>
From:   "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
Message-ID: <6474b609-b624-f439-7bf7-61ce78ff7b83@linux.microsoft.com>
Date:   Thu, 18 Mar 2021 17:22:49 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210318174029.GM5469@sirena.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org



On 3/18/21 12:40 PM, Mark Brown wrote:
> On Mon, Mar 15, 2021 at 11:57:54AM -0500, madvenka@linux.microsoft.com wrote:
> 
>> To summarize, pt_regs->stackframe is used (or will be used) as a marker
>> frame in stack traces. To enable the unwinder to detect these frames, tag
>> each pt_regs->stackframe with a type. To record the type, use the unused2
>> field in struct pt_regs and rename it to frame_type. The types are:
> 
> Unless I'm misreading what's going on here this is more trying to set a
> type for the stack as a whole than for a specific stack frame.  I'm also
> finding this a bit confusing as the unwinder already tracks things it
> calls frame types and it handles types that aren't covered here like
> SDEI.  At the very least there's a naming issue here.
> 

When the unwinder gets to EL1 pt_regs->stackframe, it needs to be sure that
it is indeed a frame inside an EL1 pt_regs structure. It performs the
following checks:

	FP == pt_regs->regs[29]
	PC == pt_regs->pc
	type == EL1_FRAME

to confirm that the frame is EL1 pt_regs->stackframe.

Similarly, for EL0, the type is EL0_FRAME.

Both these frames are on the task stack. So, it is not a stack type.

> Taking a step back though do we want to be tracking this via pt_regs?
> It's reliant on us robustly finding the correct pt_regs and on having
> the things that make the stack unreliable explicitly go in and set the
> appropriate type.  That seems like it will be error prone, I'd been
> expecting to do something more like using sections to filter code for
> unreliable features based on the addresses of the functions we find on
> the stack or similar.  This could still go wrong of course but there's
> fewer moving pieces, and especially fewer moving pieces specific to
> reliable stack trace.
> 

In that case, I suggest doing both. That is, check the type as well
as specific functions. For instance, in the EL1 pt_regs, in addition
to the above checks, check the PC against el1_sync(), el1_irq() and
el1_error(). I have suggested this in the cover letter.

If this is OK with you, we could do that. We want to make really sure that
nothing goes wrong with detecting the exception frame.

> I'm wary of tracking data that only ever gets used for the reliable
> stack trace path given that it's going to be fairly infrequently used
> and hence tested, especially things that only crop up in cases that are
> hard to provoke reliably.  If there's a way to detect things that
> doesn't use special data that seems safer.
> 

If you dislike the frame type, I could remove it and just do the
following checks:

	FP == pt_regs->regs[29]
	PC == pt_regs->pc
	and the address check against el1_*() functions

and similar changes for EL0 as well.

I still think that the frame type check makes it more robust.

>> EL1_FRAME
>> 	EL1 exception frame.
> 
> We do trap into EL2 as well, the patch will track EL2 frames as EL1
> frames.  Even if we can treat them the same the naming ought to be
> clear.
> 

Are you referring to ARMv8.1 VHE extension where the kernel can run
at EL2? Could you elaborate? I thought that EL2 was basically for
Hypervisors.

Thanks.

>> FTRACE_FRAME
>>         FTRACE frame.
> 
> This is implemented later in the series.  If using this approach I'd
> suggest pulling the change in entry-ftrace.S that sets this into this
> patch, it's easier than adding a note about this being added later and
> should help with any bisect issues.
> 

OK. Good point.

Madhavan
