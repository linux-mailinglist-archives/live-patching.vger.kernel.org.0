Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D73C373307
	for <lists+live-patching@lfdr.de>; Wed,  5 May 2021 02:21:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231134AbhEEAWe (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 4 May 2021 20:22:34 -0400
Received: from linux.microsoft.com ([13.77.154.182]:40700 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230505AbhEEAWe (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 4 May 2021 20:22:34 -0400
Received: from [192.168.254.32] (unknown [47.187.223.33])
        by linux.microsoft.com (Postfix) with ESMTPSA id 0759C20B7178;
        Tue,  4 May 2021 17:21:37 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 0759C20B7178
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1620174098;
        bh=67pUuO9NPGqjJ/qDqrzzpbBgFlanoF6KUFDz7lH6P00=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=Cj/GF5no1DMzZUaaja0KNhnaQ6g3J95YGLHwQk/gdXf2RUxB/JCXv9g2OPWrRXuCl
         qM0WHBHB7DMIG/wVEbyC7+bwFsEZLYSxsIUgYznkroXl4AlWjKTZR3y4rv5wsai5+v
         vYXrukyB/VmQEH7FF4WOakI6azOsc9SeGD8nx0xA=
Subject: Re: [RFC PATCH v3 1/4] arm64: Introduce stack trace reliability
 checks in the unwinder
To:     Josh Poimboeuf <jpoimboe@redhat.com>
Cc:     broonie@kernel.org, mark.rutland@arm.com, jthierry@redhat.com,
        catalin.marinas@arm.com, will@kernel.org, jmorris@namei.org,
        pasha.tatashin@soleen.com, linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
References: <65cf4dfbc439b010b50a0c46ec500432acde86d6>
 <20210503173615.21576-1-madvenka@linux.microsoft.com>
 <20210503173615.21576-2-madvenka@linux.microsoft.com>
 <20210504215248.oi3zay3memgqri33@treble>
 <b000767b-26ca-01a9-a109-c9fc3357f832@linux.microsoft.com>
 <20210505000728.yxg3xbwa3emcu2wi@treble>
From:   "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
Message-ID: <2fc9a77a-ddf5-812a-0681-ece94b433d71@linux.microsoft.com>
Date:   Tue, 4 May 2021 19:21:37 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210505000728.yxg3xbwa3emcu2wi@treble>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org



On 5/4/21 7:07 PM, Josh Poimboeuf wrote:
> On Tue, May 04, 2021 at 06:13:39PM -0500, Madhavan T. Venkataraman wrote:
>>
>>
>> On 5/4/21 4:52 PM, Josh Poimboeuf wrote:
>>> On Mon, May 03, 2021 at 12:36:12PM -0500, madvenka@linux.microsoft.com wrote:
>>>> @@ -44,6 +44,8 @@ int notrace unwind_frame(struct task_struct *tsk, struct stackframe *frame)
>>>>  	unsigned long fp = frame->fp;
>>>>  	struct stack_info info;
>>>>  
>>>> +	frame->reliable = true;
>>>> +
>>>
>>> Why set 'reliable' to true on every invocation of unwind_frame()?
>>> Shouldn't it be remembered across frames?
>>>
>>
>> This is mainly for debug purposes in case a caller wants to print the whole stack and also
>> print which functions are unreliable. For livepatch, it does not make any difference. It will
>> quit as soon as it encounters an unreliable frame.
> 
> Hm, ok.  So 'frame->reliable' refers to the current frame, not the
> entire stack.
> 

Yes.

>>> Also, it looks like there are several error scenarios where it returns
>>> -EINVAL but doesn't set 'reliable' to false.
>>>
>>
>> I wanted to make a distinction between an error situation (like stack corruption where unwinding
>> has to stop) and an unreliable situation (where unwinding can still proceed). E.g., when a
>> stack trace is taken for informational purposes or debug purposes, the unwinding will try to
>> proceed until either the stack trace ends or an error happens.
> 
> Ok, but I don't understand how that relates to my comment.
> 
> Why wouldn't a stack corruption like !on_accessible_stack() set
> 'frame->reliable' to false?
> 

I do see your point. If an error has been hit, then the stack trace is essentially unreliable
regardless of anything else. So, I accept your comment. I will mark the stack trace as unreliable
if any kind of error is encountered.

Thanks!

Madhavan
