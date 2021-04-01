Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2664E352014
	for <lists+live-patching@lfdr.de>; Thu,  1 Apr 2021 21:47:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234377AbhDATrN (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 1 Apr 2021 15:47:13 -0400
Received: from linux.microsoft.com ([13.77.154.182]:49978 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233786AbhDATrN (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 1 Apr 2021 15:47:13 -0400
Received: from [192.168.254.32] (unknown [47.187.194.202])
        by linux.microsoft.com (Postfix) with ESMTPSA id C7C6720B5680;
        Thu,  1 Apr 2021 12:47:12 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com C7C6720B5680
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1617306433;
        bh=OWDpaHvm2D0YNKQeRL1yB30M3kQ2iFEviD+jXzZJLw4=;
        h=Subject:From:To:Cc:References:Date:In-Reply-To:From;
        b=hFTJ7U55fKBJa5C9uc9lhXSXZj88jm9BczziZFIOsSkr6xWahJtH1OljSGIRXrChG
         Ns4Ytm0hEXP3U7E58XtVbcl8b4t1Qo/tI3W2sg1NJrjKFgu4cheH6J2xiG00hWGHE9
         rvFn/sM5MJA7+E48QTLt2jeiogErJPoyvFe1r7hc=
Subject: Re: [RFC PATCH v1 3/4] arm64: Detect FTRACE cases that make the stack
 trace unreliable
From:   "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
To:     Mark Brown <broonie@kernel.org>
Cc:     mark.rutland@arm.com, jpoimboe@redhat.com, jthierry@redhat.com,
        catalin.marinas@arm.com, will@kernel.org,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
References: <77bd5edeea72d44533c769b1e8c0fea7a9d7eb3a>
 <20210330190955.13707-1-madvenka@linux.microsoft.com>
 <20210330190955.13707-4-madvenka@linux.microsoft.com>
 <20210401142759.GJ4758@sirena.org.uk>
 <0bece48b-5fee-2bd1-752e-66d2b89cc5ad@linux.microsoft.com>
 <20210401182810.GO4758@sirena.org.uk>
 <2a56fe4b-9929-0d8b-aa49-c2b1c1b82b79@linux.microsoft.com>
 <fe2f3b1e-8cb6-05ce-7968-216fed079fe4@linux.microsoft.com>
Message-ID: <9ebc341b-ba5a-db9a-c5e6-17b30d4b1fd4@linux.microsoft.com>
Date:   Thu, 1 Apr 2021 14:47:11 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <fe2f3b1e-8cb6-05ce-7968-216fed079fe4@linux.microsoft.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org



On 4/1/21 1:53 PM, Madhavan T. Venkataraman wrote:
> 
> 
> On 4/1/21 1:40 PM, Madhavan T. Venkataraman wrote:
>>>> So, it is only defined if CONFIG_FUNCTION_GRAPH_TRACER is defined. I can address
>>>> this as well as your comment by defining another label whose name is more meaningful
>>>> to our use:
>>>> +SYM_INNER_LABEL(ftrace_trampoline, SYM_L_GLOBAL) // checked by the unwinder
>>>> #ifdef CONFIG_FUNCTION_GRAPH_TRACER
>>>> SYM_INNER_LABEL(ftrace_graph_call, SYM_L_GLOBAL) // ftrace_graph_caller();
>>>>         nop                             // If enabled, this will be replaced
>>>>                                         // "b ftrace_graph_caller"
>>>> #endif
>>> I'm not sure we need to bother with that, you'd still need the & I think.
>> I think we need to bother with that. If CONFIG_FUNCTION_GRAPH_TRACER is not on but
>> CONFIG_DYNAMIC_FTRACE_WITH_REGS is, then ftrace_graph_call() will not occur in the stack
>> trace taken from a tracer function. The unwinder still needs to recognize an ftrace frame.
>> I don't want to assume ftrace_common_return which is the label that currently follows
>> the above code. So, we need a different label outside the above ifdef.
> 
> Alternatively, I could just move the SYM_INNER_LABEL(ftrace_graph_call..) to outside the ifdef.
> 
> Madhavan
> 

Or, even better, I could just use ftrace_call+4 because that would be the return
address for the tracer function at ftrace_call:

SYM_CODE_START(ftrace_common)
        sub     x0, x30, #AARCH64_INSN_SIZE     // ip (callsite's BL insn)
        mov     x1, x9                          // parent_ip (callsite's LR)
        ldr_l   x2, function_trace_op           // op
        mov     x3, sp                          // regs

SYM_INNER_LABEL(ftrace_call, SYM_L_GLOBAL)
        bl      ftrace_stub

I think that would be cleaner. And, I don't need the complicated comments for ftrace_graph_call.

Is this acceptable?

Madhavan
