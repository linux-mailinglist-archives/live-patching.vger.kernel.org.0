Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2346637473F
	for <lists+live-patching@lfdr.de>; Wed,  5 May 2021 19:53:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234780AbhEERxI (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 5 May 2021 13:53:08 -0400
Received: from linux.microsoft.com ([13.77.154.182]:41146 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234090AbhEERwl (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 5 May 2021 13:52:41 -0400
Received: from [192.168.254.32] (unknown [47.187.223.33])
        by linux.microsoft.com (Postfix) with ESMTPSA id 24BC220B7178;
        Wed,  5 May 2021 10:51:43 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 24BC220B7178
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1620237103;
        bh=sdd8ZMJAgH8gVKupmR0QjAVLyv9Ta+9CM3nIhnT4w4E=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=C52y7+v8ilF8BexdEy/Wkqfza8Rzms0fSCvyQ9ulzKSjekGM8BRm9cRpZqNzS5W9h
         EIcCsR2tBclzDi/ycQ5EEVUUYIt84oU3VROjxUcutquknWLFcHsZ5NCbFIkhPnVtuD
         Bvn1ceilFKmtswxjkUzyiFqKarfVpHCBGPQ7kCwM=
Subject: Re: [RFC PATCH v3 2/4] arm64: Check the return PC against unreliable
 code sections
To:     Mark Brown <broonie@kernel.org>
Cc:     jpoimboe@redhat.com, mark.rutland@arm.com, jthierry@redhat.com,
        catalin.marinas@arm.com, will@kernel.org, jmorris@namei.org,
        pasha.tatashin@soleen.com, linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
References: <65cf4dfbc439b010b50a0c46ec500432acde86d6>
 <20210503173615.21576-1-madvenka@linux.microsoft.com>
 <20210503173615.21576-3-madvenka@linux.microsoft.com>
 <20210504160508.GC7094@sirena.org.uk>
 <1bd2b177-509a-21d9-e349-9b2388db45eb@linux.microsoft.com>
 <20210505163406.GB4541@sirena.org.uk>
From:   "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
Message-ID: <64373047-1029-df65-e7aa-b8058850fbde@linux.microsoft.com>
Date:   Wed, 5 May 2021 12:51:42 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210505163406.GB4541@sirena.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org



On 5/5/21 11:34 AM, Mark Brown wrote:
> On Tue, May 04, 2021 at 02:03:14PM -0500, Madhavan T. Venkataraman wrote:
>> On 5/4/21 11:05 AM, Mark Brown wrote:
> 
>>>> @@ -118,9 +160,21 @@ int notrace unwind_frame(struct task_struct *tsk, struct stackframe *frame)
>>>>  			return -EINVAL;
>>>>  		frame->pc = ret_stack->ret;
>>>>  		frame->pc = ptrauth_strip_insn_pac(frame->pc);
>>>> +		return 0;
>>>>  	}
> 
>>> Do we not need to look up the range of the restored pc and validate
>>> what's being pointed to here?  It's not immediately obvious why we do
>>> the lookup before handling the function graph tracer, especially given
>>> that we never look at the result and there's now a return added skipping
>>> further reliability checks.  At the very least I think this needs some
>>> additional comments so the code is more obvious.
> 
>> I want sym_code_ranges[] to contain both unwindable and non-unwindable ranges.
>> Unwindable ranges will be special ranges such as the return_to_handler() and
>> kretprobe_trampoline() functions for which the unwinder has (or will have)
>> special code to unwind. So, the lookup_range() has to happen before the
>> function graph code. Please look at the last patch in the series for
>> the fix for the above function graph code.
> 
> That sounds reasonable but like I say should probably be called out in
> the code so it's clear to people working with it.
> 

OK. To make this better, I will do the lookup_range() after the function
graph code to begin with. Then, in the last patch for the function graph
code, I will move it up. This way, the code is clear and your comment
is addressed.

>> On the question of "should the original return address be checked against
>> sym_code_ranges[]?" - I assumed that if there is a function graph trace on a
>> function, it had to be an ftraceable function. It would not be a part
>> of sym_code_ranges[]. Is that a wrong assumption on my part?
> 
> I can't think of any cases where it wouldn't be right now, but it seems
> easier to just do a redundant check than to have the assumption in the
> code and have to think about if it's missing.
> 

Agreed. Will do the check.

Madhavan
