Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A94237308C
	for <lists+live-patching@lfdr.de>; Tue,  4 May 2021 21:14:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232055AbhEDTPQ (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 4 May 2021 15:15:16 -0400
Received: from linux.microsoft.com ([13.77.154.182]:58312 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231604AbhEDTPP (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 4 May 2021 15:15:15 -0400
Received: from [192.168.254.32] (unknown [47.187.223.33])
        by linux.microsoft.com (Postfix) with ESMTPSA id F1D5E20B7178;
        Tue,  4 May 2021 12:14:19 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com F1D5E20B7178
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1620155660;
        bh=NT93qR5y4vJEyN4TlNFBZ7epv4aqQ9wRwRPw+CZEeh0=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=c4Tu84/wv4NIzOPdh8fTtWgwZHEwqPxQdHhJSjz1xd7HvjwI9ScVDcvHvbJF16QuD
         xacGTdmjxVwMCyloctrINa9KX9kO/eV0zszLDjgO71fR6lOUexVEiKp5niDkeBTGhY
         CIS7a8e2TaWWqVKaxS4Yv6x8082R2iAnK/a9pez8=
Subject: Re: [RFC PATCH v3 1/4] arm64: Introduce stack trace reliability
 checks in the unwinder
To:     Mark Brown <broonie@kernel.org>
Cc:     jpoimboe@redhat.com, mark.rutland@arm.com, jthierry@redhat.com,
        catalin.marinas@arm.com, will@kernel.org, jmorris@namei.org,
        pasha.tatashin@soleen.com, linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
References: <65cf4dfbc439b010b50a0c46ec500432acde86d6>
 <20210503173615.21576-1-madvenka@linux.microsoft.com>
 <20210503173615.21576-2-madvenka@linux.microsoft.com>
 <20210504155056.GB7094@sirena.org.uk>
From:   "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
Message-ID: <66680284-8c80-1434-6c49-d86a47767168@linux.microsoft.com>
Date:   Tue, 4 May 2021 14:14:19 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210504155056.GB7094@sirena.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org



On 5/4/21 10:50 AM, Mark Brown wrote:
> On Mon, May 03, 2021 at 12:36:12PM -0500, madvenka@linux.microsoft.com wrote:
> 
>> +	/*
>> +	 * First, make sure that the return address is a proper kernel text
>> +	 * address. A NULL or invalid return address probably means there's
>> +	 * some generated code which __kernel_text_address() doesn't know
>> +	 * about. Mark the stack trace as not reliable.
>> +	 */
>> +	if (!__kernel_text_address(frame->pc)) {
>> +		frame->reliable = false;
>> +		return 0;
>> +	}
> 
> Do we want the return here?  It means that...
> 
>> +
>>  #ifdef CONFIG_FUNCTION_GRAPH_TRACER
>>  	if (tsk->ret_stack &&
>> -		(ptrauth_strip_insn_pac(frame->pc) == (unsigned long)return_to_handler)) {
>> +		frame->pc == (unsigned long)return_to_handler) {
>>  		struct ftrace_ret_stack *ret_stack;
>>  		/*
>>  		 * This is a case where function graph tracer has
>> @@ -103,11 +117,10 @@ int notrace unwind_frame(struct task_struct *tsk, struct stackframe *frame)
>>  		if (WARN_ON_ONCE(!ret_stack))
>>  			return -EINVAL;
>>  		frame->pc = ret_stack->ret;
>> +		frame->pc = ptrauth_strip_insn_pac(frame->pc);
>>  	}
> 
> ...we skip this handling in the case where we're not in kernel code.  I
> don't know off hand if that's a case that can happen right now but it
> seems more robust to run through this and anything else we add later,
> even if it's not relevant now changes either in the unwinder itself or
> resulting from some future work elsewhere may mean it later becomes
> important.  Skipping futher reliability checks is obviously fine if
> we've already decided things aren't reliable but this is more than just
> a reliability check.
> 

AFAICT, currently, all the functions that the unwinder checks do have
valid kernel text addresses. However, I don't think there is any harm
in letting it fall through and make all the checks. So, I will remove the
return statement.

Thanks!

Madhavan

