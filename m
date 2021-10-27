Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1739043D213
	for <lists+live-patching@lfdr.de>; Wed, 27 Oct 2021 22:07:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243779AbhJ0UJk (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 27 Oct 2021 16:09:40 -0400
Received: from linux.microsoft.com ([13.77.154.182]:49046 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243780AbhJ0UJh (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 27 Oct 2021 16:09:37 -0400
Received: from [192.168.254.32] (unknown [47.187.212.181])
        by linux.microsoft.com (Postfix) with ESMTPSA id 7D73120A5C64;
        Wed, 27 Oct 2021 13:07:10 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 7D73120A5C64
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1635365231;
        bh=BGo/Dtg7YwC8q+RFxuQcteIV/YmgEHdRFKrKDWOW+zM=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=GFFcGMtfPsb7c/cwQ8Bs8gXv83qw86n+XfEOD5DCkazvHXeY3soocMGmFANA8g44+
         GKuU9BHNGKPokRjr1ZWDQI8ZXb+tccj/Q3E6aO1dYD01iKpzkfh11+o59n00bMzpbI
         TQh3WVZMWYu5tcXheJo/g0DQlrYdvUTmtiB9mxYI=
Subject: Re: [PATCH v10 08/11] arm64: Rename unwinder functions, prevent them
 from being traced and kprobed
To:     Mark Rutland <mark.rutland@arm.com>
Cc:     broonie@kernel.org, jpoimboe@redhat.com, ardb@kernel.org,
        nobuta.keiya@fujitsu.com, sjitindarsingh@gmail.com,
        catalin.marinas@arm.com, will@kernel.org, jmorris@namei.org,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
References: <c05ce30dcc9be1bd6b5e24a2ca8fe1d66246980b>
 <20211015025847.17694-1-madvenka@linux.microsoft.com>
 <20211015025847.17694-9-madvenka@linux.microsoft.com>
 <20211027175325.GC58503@C02TD0UTHF1T.local>
From:   "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
Message-ID: <88b9f9fb-155f-da97-b8ef-755eaf2a4af9@linux.microsoft.com>
Date:   Wed, 27 Oct 2021 15:07:09 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211027175325.GC58503@C02TD0UTHF1T.local>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org



On 10/27/21 12:53 PM, Mark Rutland wrote:
> On Thu, Oct 14, 2021 at 09:58:44PM -0500, madvenka@linux.microsoft.com wrote:
>> From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
>>
>> Rename unwinder functions for consistency and better naming.
>>
>> 	- Rename start_backtrace() to unwind_start().
>> 	- Rename unwind_frame() to unwind_next().
>> 	- Rename walk_stackframe() to unwind().
> 
> This looks good to me.
> 

Thanks.

> Could we split this from the krpbes/tracing changes? I think this stands
> on it's own, and (as below) the kprobes/tracing changes need some more
> explanation, and would make sense as a separate patch.
> 

OK. I will split the patches.

>> Prevent the following unwinder functions from being traced:
>>
>> 	- unwind_start()
>> 	- unwind_next()
>>
>> 	unwind() is already prevented from being traced.
> 
> This could do with an explanation in the commis message as to why we
> need to do this. If this is fixing a latent issue, it should be in a
> preparatory patch that we can backport.
> 
> I dug into this a bit, and from taking a look, we prohibited ftrace in commit:
> 
>   0c32706dac1b0a72 ("arm64: stacktrace: avoid tracing arch_stack_walk()")
> 
> ... which is just one special case of graph return stack unbalancing,
> and should be addressed by using HAVE_FUNCTION_GRAPH_RET_ADDR_PTR, so
> with the patch making us use HAVE_FUNCTION_GRAPH_RET_ADDR_PTR, that's
> no longer necessary.
> 
> So we no longer seem to have a specific reason to prohibit ftrace
> here.
> 

OK, I will think about this and add a comment.

>> Prevent the following unwinder functions from being kprobed:
>>
>> 	- unwind_start()
>>
>> 	unwind_next() and unwind() are already prevented from being kprobed.
> 
> Likewise, I think this needs some explanation. From diggin, we
> prohibited kprobes in commit:
> 
>   ee07b93e7721ccd5 ("arm64: unwind: Prohibit probing on return_address()")
> 
> ... and the commit message says we need to do this because this is
> (transitively) called by trace_hardirqs_off(), which is kprobes
> blacklisted, but doesn't explain the actual problem this results in.
> 

OK. I will think about this and add a comment.

> AFAICT x86 directly uses __builtin_return_address() here, but that won't
> recover rewritten addresses, which seems like a bug (or at least a
> limitation) on x86, assuming I've read that correctly.
> 

OK.

Thanks,

Madhavan
