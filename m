Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F23EB4A7CF6
	for <lists+live-patching@lfdr.de>; Thu,  3 Feb 2022 01:39:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345985AbiBCAjc (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 2 Feb 2022 19:39:32 -0500
Received: from linux.microsoft.com ([13.77.154.182]:45668 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234317AbiBCAjb (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 2 Feb 2022 19:39:31 -0500
Received: from [192.168.254.32] (unknown [47.187.212.181])
        by linux.microsoft.com (Postfix) with ESMTPSA id 72E2420B6C61;
        Wed,  2 Feb 2022 16:39:30 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 72E2420B6C61
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1643848771;
        bh=GftQnaZmoXOg3pi7YQk/y5waoxN7UBdPSQ4aS5QGUIY=;
        h=Date:Subject:From:To:Cc:References:In-Reply-To:From;
        b=dslc/QwSqbJotie/8onj+pRmzc627WbKjEXF1vhEHTuyQzxZZq/mW3bIMohHf/MCs
         h3XEMWCjg9d3p+n4cSIKnm3LZvYoUPp+G/pdxNd7gYVgi6jp/mf+Pfab67b+Ndi0DZ
         +A/WV4pqkCXvUcMngjaUlIjBZZBJEx5GBZ0Oys/Q=
Message-ID: <e44dd796-8675-2dee-7ad1-65d01058d5aa@linux.microsoft.com>
Date:   Wed, 2 Feb 2022 18:39:29 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v13 04/11] arm64: Split unwind_init()
Content-Language: en-US
From:   "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
To:     Mark Brown <broonie@kernel.org>
Cc:     mark.rutland@arm.com, jpoimboe@redhat.com, ardb@kernel.org,
        nobuta.keiya@fujitsu.com, sjitindarsingh@gmail.com,
        catalin.marinas@arm.com, will@kernel.org, jmorris@namei.org,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
References: <95691cae4f4504f33d0fc9075541b1e7deefe96f>
 <20220117145608.6781-1-madvenka@linux.microsoft.com>
 <20220117145608.6781-5-madvenka@linux.microsoft.com>
 <YfrQ80PE8Nhg8lx3@sirena.org.uk>
 <bb9c0f6f-7f80-9d76-8bfe-7a2a82fa3544@linux.microsoft.com>
In-Reply-To: <bb9c0f6f-7f80-9d76-8bfe-7a2a82fa3544@linux.microsoft.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org



On 2/2/22 18:26, Madhavan T. Venkataraman wrote:
> 
> 
> On 2/2/22 12:44, Mark Brown wrote:
>> On Mon, Jan 17, 2022 at 08:56:01AM -0600, madvenka@linux.microsoft.com wrote:
>>
>>> +/*
>>> + * TODO: document requirements here.
>>> + */
>>> +static inline void unwind_init_from_regs(struct unwind_state *state,
>>> +					 struct pt_regs *regs)
>>
>>> +/*
>>> + * TODO: document requirements here.
>>> + *
>>> + * Note: this is always inlined, and we expect our caller to be a noinline
>>> + * function, such that this starts from our caller's caller.
>>> + */
>>> +static __always_inline void unwind_init_from_current(struct unwind_state *state)
>>
>>> +/*
>>> + * TODO: document requirements here.
>>> + *
>>> + * The caller guarantees that the task is not running.
>>> + */
>>> +static inline void unwind_init_from_task(struct unwind_state *state,
>>> +					 struct task_struct *task)
>>
>> Other than the obvious gap this looks good to me.  For _current() I
>> don't think we've got any particular requirements other than what's
>> documented.  For the others I think the main thing is that trying to
>> walk the stack of a task that is actively executing is going to be a bad
>> idea so we should say that the task shouldn't be running, but in general
>> given that one of the main use cases is printing diagnostics on error
>> we shouldn't have too many *requirements* for calling these.
> 
> OK. For now, I will remove the TODO comment from individual functions.
> I will add only a common general comment above all 3 helpers that
> additional requirements may be documented as seen fit. And, I will
> add that the task must not be running in other-directed cases.
> 

If what I have suggested above for comments is good enough, can I get a
Reviewed-by for this? I will fix the comments on the next send.

> Madhavan
