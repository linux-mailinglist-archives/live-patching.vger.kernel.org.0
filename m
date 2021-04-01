Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D607351EB6
	for <lists+live-patching@lfdr.de>; Thu,  1 Apr 2021 20:55:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236982AbhDASpt (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 1 Apr 2021 14:45:49 -0400
Received: from linux.microsoft.com ([13.77.154.182]:41004 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239423AbhDASkZ (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 1 Apr 2021 14:40:25 -0400
Received: from [192.168.254.32] (unknown [47.187.194.202])
        by linux.microsoft.com (Postfix) with ESMTPSA id BDFDF20ABC25;
        Thu,  1 Apr 2021 11:40:24 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com BDFDF20ABC25
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1617302425;
        bh=SOlvCGNF2qL5Q3qgj9PLqYCmEQf62InHHijTjNlIusI=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=PnrhJu9LCcT59AvJiHeY+krR88BIg5ss+Vm+tOQZcJ+rklhu2M8B38Qvj5bnMgCyT
         O66WxUU29Ta/gNMB+kWtkN6uCu+FU0EsFnFIlSy4xbDWNI6nMkQK+F3EhHOft3iAmO
         zx7iV8lXhO2Y5OLAwpQgTmfPaGhtpV7VcF9PFkeg=
Subject: Re: [RFC PATCH v1 3/4] arm64: Detect FTRACE cases that make the stack
 trace unreliable
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
From:   "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
Message-ID: <2a56fe4b-9929-0d8b-aa49-c2b1c1b82b79@linux.microsoft.com>
Date:   Thu, 1 Apr 2021 13:40:23 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210401182810.GO4758@sirena.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org



On 4/1/21 1:28 PM, Mark Brown wrote:
> On Thu, Apr 01, 2021 at 12:43:25PM -0500, Madhavan T. Venkataraman wrote:
> 
>>>> +#ifdef CONFIG_DYNAMIC_FTRACE_WITH_REGS
>>>> +	{ (unsigned long) &ftrace_graph_call, 0 },
>>>> +#ifdef CONFIG_FUNCTION_GRAPH_TRACER
>>>> +	{ (unsigned long) ftrace_graph_caller, 0 },
> 
>>> It's weird that we take the address of ftrace_graph_call but not the
>>> other functions - we should be consistent or explain why.  It'd probably
>>> also look nicer to not nest the ifdefs, the dependencies in Kconfig will
>>> ensure we only get things when we should.
> 
>> I have explained it in the comment in the FTRACE trampoline right above
>> ftrace_graph_call().
> 
> Ah, right - it's a result of it being an inner label.  I'd suggest
> putting a brief note right at that line of code explaining this (eg,
> "Inner label, not a function"), it wasn't confusing due to the use of
> that symbol but rather due to it being different from everything else
> in the list and that's kind of lost in the main comment.
> 

OK, So, I will add a note in the main comment above the list. I will add the
comment line you have suggested at the exact line.

>> So, it is only defined if CONFIG_FUNCTION_GRAPH_TRACER is defined. I can address
>> this as well as your comment by defining another label whose name is more meaningful
>> to our use:
> 
>> +SYM_INNER_LABEL(ftrace_trampoline, SYM_L_GLOBAL) // checked by the unwinder
>> #ifdef CONFIG_FUNCTION_GRAPH_TRACER
>> SYM_INNER_LABEL(ftrace_graph_call, SYM_L_GLOBAL) // ftrace_graph_caller();
>>         nop                             // If enabled, this will be replaced
>>                                         // "b ftrace_graph_caller"
>> #endif
> 
> I'm not sure we need to bother with that, you'd still need the & I think.

I think we need to bother with that. If CONFIG_FUNCTION_GRAPH_TRACER is not on but
CONFIG_DYNAMIC_FTRACE_WITH_REGS is, then ftrace_graph_call() will not occur in the stack
trace taken from a tracer function. The unwinder still needs to recognize an ftrace frame.
I don't want to assume ftrace_common_return which is the label that currently follows
the above code. So, we need a different label outside the above ifdef.

As for the &, I needed it because ftrace_graph_call is currently defined elsewhere as:

extern unsigned long ftrace_graph_call;

I did not want to change that.

Thanks,

Madhavan

