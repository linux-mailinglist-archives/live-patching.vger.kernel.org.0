Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1473A35430D
	for <lists+live-patching@lfdr.de>; Mon,  5 Apr 2021 16:56:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236171AbhDEO44 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 5 Apr 2021 10:56:56 -0400
Received: from linux.microsoft.com ([13.77.154.182]:48462 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235835AbhDEO44 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 5 Apr 2021 10:56:56 -0400
Received: from [192.168.254.32] (unknown [47.187.194.202])
        by linux.microsoft.com (Postfix) with ESMTPSA id B17FA20B5680;
        Mon,  5 Apr 2021 07:56:49 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com B17FA20B5680
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1617634610;
        bh=Pd2aEm4Jogei2ZP/WP/ICidNHaEQSmRltw/NyI+NufA=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=PN2nKehFJ9UP22EHuP6ZMv55ZjU8fNNTGhCuv/ZMmS5n9KGJT+TtiB9m88HKcX2UR
         it+JvqplG/kywOJpuij1/XIytSzKTzpZGL+/L0QiwASZyHAUUIi/OanCbrLApZIrXU
         grYoQwFXw5NXSJtTUqJHiqbvi3utlD6RbCAzrssk=
Subject: Re: [RFC PATCH v1 0/4] arm64: Implement stack trace reliability
 checks
To:     Masami Hiramatsu <mhiramat@kernel.org>
Cc:     Josh Poimboeuf <jpoimboe@redhat.com>, mark.rutland@arm.com,
        broonie@kernel.org, jthierry@redhat.com, catalin.marinas@arm.com,
        will@kernel.org, linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
References: <77bd5edeea72d44533c769b1e8c0fea7a9d7eb3a>
 <20210330190955.13707-1-madvenka@linux.microsoft.com>
 <20210403170159.gegqjrsrg7jshlne@treble>
 <bd13a433-c060-c501-8e76-5e856d77a225@linux.microsoft.com>
 <20210405222436.4fda9a930676d95e862744af@kernel.org>
From:   "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
Message-ID: <7dda9af3-1ecf-5e6f-1e46-8870a2a5e550@linux.microsoft.com>
Date:   Mon, 5 Apr 2021 09:56:48 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210405222436.4fda9a930676d95e862744af@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org



On 4/5/21 8:24 AM, Masami Hiramatsu wrote:
> Hi Madhaven,
> 
> On Sat, 3 Apr 2021 22:29:12 -0500
> "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com> wrote:
> 
> 
>>>> Check for kretprobe
>>>> ===================
>>>>
>>>> For functions with a kretprobe set up, probe code executes on entry
>>>> to the function and replaces the return address in the stack frame with a
>>>> kretprobe trampoline. Whenever the function returns, control is
>>>> transferred to the trampoline. The trampoline eventually returns to the
>>>> original return address.
>>>>
>>>> A stack trace taken while executing in the function (or in functions that
>>>> get called from the function) will not show the original return address.
>>>> Similarly, a stack trace taken while executing in the trampoline itself
>>>> (and functions that get called from the trampoline) will not show the
>>>> original return address. This means that the caller of the probed function
>>>> will not show. This makes the stack trace unreliable.
>>>>
>>>> Add the kretprobe trampoline to special_functions[].
>>>>
>>>> FYI, each task contains a task->kretprobe_instances list that can
>>>> theoretically be consulted to find the orginal return address. But I am
>>>> not entirely sure how to safely traverse that list for stack traces
>>>> not on the current process. So, I have taken the easy way out.
>>>
>>> For kretprobes, unwinding from the trampoline or kretprobe handler
>>> shouldn't be a reliability concern for live patching, for similar
>>> reasons as above.
>>>
>>
>> Please see previous answer.
>>
>>> Otherwise, when unwinding from a blocked task which has
>>> 'kretprobe_trampoline' on the stack, the unwinder needs a way to get the
>>> original return address.  Masami has been working on an interface to
>>> make that possible for x86.  I assume something similar could be done
>>> for arm64.
>>>
>>
>> OK. Until that is available, this case needs to be addressed.
> 
> Actually, I've done that on arm64 :) See below patch.
> (and I also have a similar code for arm32, what I'm considering is how
> to unify x86/arm/arm64 kretprobe_find_ret_addr(), since those are very
> similar.)
> 
> This is applicable on my x86 series v5
> 
> https://lore.kernel.org/bpf/161676170650.330141.6214727134265514123.stgit@devnote2/
> 
> Thank you,
> 
> 

I took a brief look at your changes. Looks reasonable.

However, for now, I am going to include the kretprobe_trampoline in the special_functions[]
array until your changes are merged. At that point, it is just a matter of deleting
kretprobe_trampoline from the special_functions[] array. That is all.

I hope that is fine with everyone.

Madhavan

