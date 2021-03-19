Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 053D4341FD0
	for <lists+live-patching@lfdr.de>; Fri, 19 Mar 2021 15:41:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230090AbhCSOlS (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 19 Mar 2021 10:41:18 -0400
Received: from linux.microsoft.com ([13.77.154.182]:43212 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229926AbhCSOks (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 19 Mar 2021 10:40:48 -0400
Received: from [192.168.254.32] (unknown [47.187.194.202])
        by linux.microsoft.com (Postfix) with ESMTPSA id 590E9209C398;
        Fri, 19 Mar 2021 07:40:47 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 590E9209C398
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1616164847;
        bh=1zQaqS/XbK07XWlK6cwo3q5bC7o/WeaNHXa0xXx1Uh4=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=ZX8aqmUc05ndJQXno8dUB7gDV7LXoR7hrDnVhjLGeuSRcxQvspUMtnr7Bnpl1CqHZ
         RDn3Pp4u79tMqZYjFJhqTR6L0nUh8o61Xq5rM2z29rcmae23mNpTCh4Q8kLcGGNNJS
         B9/owhj8huMaPL8OhCK0tZTv9AHW/IWtOsRUSpCE=
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
 <6474b609-b624-f439-7bf7-61ce78ff7b83@linux.microsoft.com>
 <20210319132208.GD5619@sirena.org.uk>
From:   "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
Message-ID: <e8d596c3-b1ec-77a6-f387-92ecd2ebfceb@linux.microsoft.com>
Date:   Fri, 19 Mar 2021 09:40:46 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210319132208.GD5619@sirena.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org



On 3/19/21 8:22 AM, Mark Brown wrote:
> On Thu, Mar 18, 2021 at 05:22:49PM -0500, Madhavan T. Venkataraman wrote:
>> On 3/18/21 12:40 PM, Mark Brown wrote:
> 
>>> Unless I'm misreading what's going on here this is more trying to set a
>>> type for the stack as a whole than for a specific stack frame.  I'm also
>>> finding this a bit confusing as the unwinder already tracks things it
>>> calls frame types and it handles types that aren't covered here like
>>> SDEI.  At the very least there's a naming issue here.
> 
>> Both these frames are on the task stack. So, it is not a stack type.
> 
> OTOH it's also not something that applies to every frame but only to the
> base frame from each stack which I think was more where I was coming
> from there.  In any case, the issue is also that there's already another
> thing that the unwinder calls a frame type so there's at least that
> collision which needs to be resolved if nothing else.
> 

The base frame from each stack as well as intermediate marker frames such
as the EL1 frame and the Ftrace frame.

As for the frame type, I will try to come up with a better name.

>>> Taking a step back though do we want to be tracking this via pt_regs?
>>> It's reliant on us robustly finding the correct pt_regs and on having
>>> the things that make the stack unreliable explicitly go in and set the
>>> appropriate type.  That seems like it will be error prone, I'd been
>>> expecting to do something more like using sections to filter code for
>>> unreliable features based on the addresses of the functions we find on
>>> the stack or similar.  This could still go wrong of course but there's
>>> fewer moving pieces, and especially fewer moving pieces specific to
>>> reliable stack trace.
> 
>> In that case, I suggest doing both. That is, check the type as well
>> as specific functions. For instance, in the EL1 pt_regs, in addition
>> to the above checks, check the PC against el1_sync(), el1_irq() and
>> el1_error(). I have suggested this in the cover letter.
> 
>> If this is OK with you, we could do that. We want to make really sure that
>> nothing goes wrong with detecting the exception frame.
> 
> ...
> 
>> If you dislike the frame type, I could remove it and just do the
>> following checks:
> 
>> 	FP == pt_regs->regs[29]
>> 	PC == pt_regs->pc
>> 	and the address check against el1_*() functions
> 
>> and similar changes for EL0 as well.
> 
>> I still think that the frame type check makes it more robust.
> 
> Yeah, we know the entry points so they can serve the same role as
> checking an explicitly written value.  It does mean one less operation
> on exception entry, though I'm not sure that's that a big enough
> overhead to actually worry about.  I don't have *super* strong opinons
> against adding the explicitly written value other than it being one more
> thing we don't otherwise use which we have to get right for reliable
> stack trace, there's a greater risk of bitrot if it's not something that
> we ever look at outside of the reliable stack trace code.
> 

So, I will add the address checks for robustness. I will think some more
about the frame type.

>>>> EL1_FRAME
>>>> 	EL1 exception frame.
> 
>>> We do trap into EL2 as well, the patch will track EL2 frames as EL1
>>> frames.  Even if we can treat them the same the naming ought to be
>>> clear.
> 
>> Are you referring to ARMv8.1 VHE extension where the kernel can run
>> at EL2? Could you elaborate? I thought that EL2 was basically for
>> Hypervisors.
> 
> KVM is the main case, yes - IIRC otherwise it's mainly error handlers
> but I might be missing something.  We do recommend that the kernel is
> started at EL2 where possible.
> 
> Actually now I look again it's just not adding anything on EL2 entries
> at all, they use a separate set of macros which aren't updated - this
> will only update things for EL0 and EL1 entries so my comment above
> about this tracking EL2 as EL1 isn't accurate.
> 

OK.

Madhavan
