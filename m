Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A65F635187D
	for <lists+live-patching@lfdr.de>; Thu,  1 Apr 2021 19:48:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235587AbhDARpy (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 1 Apr 2021 13:45:54 -0400
Received: from linux.microsoft.com ([13.77.154.182]:33150 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235935AbhDARn0 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 1 Apr 2021 13:43:26 -0400
Received: from [192.168.254.32] (unknown [47.187.194.202])
        by linux.microsoft.com (Postfix) with ESMTPSA id 756E020B5680;
        Thu,  1 Apr 2021 10:43:26 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 756E020B5680
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1617299007;
        bh=SXrslQ5h2CELNvXp37RVjh4DI/73D8F1okC67YGXnNE=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=Y4rHwdh5CynAQxFVFMiaX5GOsqqKumJgAktfCoA4eqp/vqaUjt76xJy2kDaEq24Qx
         b5RwCjL5zXBxgQzfCRx5U28X/gE0Q1oJCf19zlZ8ao/jCvpKsz36fTkaxC+pkuJDAl
         /CHFdpal5kN6kllSEZCrknTG5uqaVGQAEMYNXBWo=
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
From:   "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
Message-ID: <0bece48b-5fee-2bd1-752e-66d2b89cc5ad@linux.microsoft.com>
Date:   Thu, 1 Apr 2021 12:43:25 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210401142759.GJ4758@sirena.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org



On 4/1/21 9:27 AM, Mark Brown wrote:
> On Tue, Mar 30, 2021 at 02:09:54PM -0500, madvenka@linux.microsoft.com wrote:
> 
>> +	 * FTRACE trampolines.
>> +	 */
>> +#ifdef CONFIG_DYNAMIC_FTRACE_WITH_REGS
>> +	{ (unsigned long) &ftrace_graph_call, 0 },
>> +#ifdef CONFIG_FUNCTION_GRAPH_TRACER
>> +	{ (unsigned long) ftrace_graph_caller, 0 },
>> +	{ (unsigned long) return_to_handler, 0 },
>> +#endif
>> +#endif
> 
> It's weird that we take the address of ftrace_graph_call but not the
> other functions - we should be consistent or explain why.  It'd probably
> also look nicer to not nest the ifdefs, the dependencies in Kconfig will
> ensure we only get things when we should.
> 

I have explained it in the comment in the FTRACE trampoline right above
ftrace_graph_call().

        /*
         * The only call in the FTRACE trampoline code is above. The above
         * instruction is patched to call a tracer function. Its return
         * address is below (ftrace_graph_call). In a stack trace taken from
         * a tracer function, ftrace_graph_call() will show. The unwinder
         * checks this for reliable stack trace. Please see the comments
         * in stacktrace.c. If another call is added in the FTRACE
         * trampoline code, the special_functions[] array in stacktrace.c
         * must be updated.
         */

I also noticed that I have to fix something here. The label ftrace_graph_call
is defined like this:


#ifdef CONFIG_FUNCTION_GRAPH_TRACER
SYM_INNER_LABEL(ftrace_graph_call, SYM_L_GLOBAL) // ftrace_graph_caller();
        nop                             // If enabled, this will be replaced
                                        // "b ftrace_graph_caller"
#endif

So, it is only defined if CONFIG_FUNCTION_GRAPH_TRACER is defined. I can address
this as well as your comment by defining another label whose name is more meaningful
to our use:


+SYM_INNER_LABEL(ftrace_trampoline, SYM_L_GLOBAL) // checked by the unwinder
#ifdef CONFIG_FUNCTION_GRAPH_TRACER
SYM_INNER_LABEL(ftrace_graph_call, SYM_L_GLOBAL) // ftrace_graph_caller();
        nop                             // If enabled, this will be replaced
                                        // "b ftrace_graph_caller"
#endif

Is this acceptable?

Thanks.

Madhavan
