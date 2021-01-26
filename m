Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3DE13057E0
	for <lists+live-patching@lfdr.de>; Wed, 27 Jan 2021 11:09:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S313868AbhAZXHT (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 26 Jan 2021 18:07:19 -0500
Received: from linux.microsoft.com ([13.77.154.182]:45182 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390578AbhAZSEb (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 26 Jan 2021 13:04:31 -0500
Received: from [192.168.254.32] (unknown [47.187.219.45])
        by linux.microsoft.com (Postfix) with ESMTPSA id 40D9120B7192;
        Tue, 26 Jan 2021 10:03:32 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 40D9120B7192
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1611684212;
        bh=VkWouM927sS4tAA7jtXNPFYjeYSo0tacxiplhxttVOs=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=q60zSDdvN+Rup5Vcwic4qbLREsKILOQ/wVvLBox2wYRIjVRrbvyno2Oid33hAh0NW
         o1gw3Z0fLDgLG0YC/0FgxJNA63izCpq1/7ynmb+E+VWquERtyrP7a/RBQRXg/u8zK6
         D7gaINkh0KFPqnQN5CkX8Ys/UMniFZpNYdi04Gq8=
Subject: Re: Live patching on ARM64
To:     Mark Rutland <mark.rutland@arm.com>
Cc:     linux-arm-kernel@lists.infradead.org,
        Mark Brown <broonie@kernel.org>,
        Julien Thierry <jthierry@redhat.com>, jpoimboe@redhat.com,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
References: <f3fe6a60-9ac2-591d-1b83-9113c50dc492@linux.microsoft.com>
 <20210115123347.GB39776@C02TD0UTHF1T.local>
From:   "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
Message-ID: <a3393eb3-03a5-e4dd-f40c-b801cc60778e@linux.microsoft.com>
Date:   Tue, 26 Jan 2021 12:03:31 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210115123347.GB39776@C02TD0UTHF1T.local>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Hi all,

Mark Rutland had sent me some ideas on what work is pending for ARM64 live patching.
I sent some questions to Mark Rutland. I forgot to include everyone in the email.
Sorry about that. I have reproduced my questions and his responses below. Please
chime in with any comments:

Thanks!




On Mon, Jan 25, 2021 at 11:58:47AM -0600, Madhavan T. Venkataraman wrote:
> Some questions below:

I've answered thos below.

If possible, I'd prefer to handle future queries on a public list (so
that others can chime in, and so that it gets archived), so if you could
direct further questions to a thread on LAKML, that would be much
appreciated.

> On 1/15/21 6:33 AM, Mark Rutland wrote:
> [...]
>>
>> One general thing that I believe we'll need to do is to rework code to
>> be patch-safe (which implies being noinstr-safe too). For example, we'll
>> need to rework the instruction patching code such that this cannot end
>> up patching itself (or anything that has instrumented it) in an unsafe
>> way.
>>
>
> OK. I understand that. Are there are other scenarios that make patching
> unsafe?

I suspect so; these are simply the cases I'm immediately aware of. I
suspect there are other cases that we will need to consider that don't
immediately spring to mind.

> I expect the kernel already handles scenarios such as two CPUs patching
> the same location at the same time or a thread executing at a location that is
> currently being patched.

IIRC that is supposed to be catered for by ftrace (and so I assume for
livepatching too); I'm not certain about kprobes. In addition to
synchronization in the core ftrace code, arm64's ftrace_modify_code()
has a sanity-check with a non-atomic RMW sequence. We might be able to
make that more robust wiuth a faultable cmpxchg, and some changes around
ftrace_update_ftrace_func() and ftrace_make_nop()  to get rid of the
unvalidated cases.

> Any other scenarios to be considered?

I'm not immediately aware of others, but suspect more cases will become
apparent as work progresses on the bits we already know about.

>> Once we have objtool it should be possible to identify those cases
>> automatically. Currently I'm aware that we'll need to do something in at
>> least the following places:
>>
>
> OK. AFAIK, objtool checks for the following:
>
>         - returning from noinstr function with instrumentation enabled
>
>         - calling instrumentable functions from noinstr code without:
>
>                 instrumentation_begin();
>                 instrumentation_end();
>
> Is that what you mean?

That's what I was thinking of, yes -- this should highlight some places
that will need attention.

> Does objtool check other things as well that is relevant to (un)safe
> patching?

I'm not entirely familiar with objtool, so I'm not exactly sure what it
can do; I expect Josh and Julien can give more detail here.

>> * The insn framework (which is used by some patching code), since the
>>   bulk of it lives in arch/arm64/kernel/insn.c and isn't marked noinstr.
>>   
>>   We can probably shift the bulk of the aarch64_insn_gen_*() and
>>   aarch64_get_*() helpers into a header as __always_inline functions,
>>   which would allow them to be used in noinstr code. As those are
>>   typically invoked with a number of constant arguments that the
>>   compiler can fold, this /might/ work out as an optimization if the
>>   compiler can elide the error paths.
>
> OK. I will take a look at the insn code.

IIRC Julien's objtool series had some patches had some patches moving
the insn code about, so it'd be worth checking whether that's a help or
a hindrance. If it's possible to split out a set of preparatory patches
that make that ready both for objtool and the kernel, that would make it
easier to review that and queue it early.

>> * The alternatives code, since we call instrumentable and patchable
>>   functions between updating instructions and performing all the
>>   necessary maintenance. There are a number of cases within
>>   __apply_alternatives(), e.g.
>>
>>   - test_bit()
>>   - cpus_have_cap()
>>   - pr_info_once()
>>   - lm_alias()
>>   - alt_cb, if the callback is not marked as noinstr, or if it calls
>>     instrumentable code (e.g. from the insn framework).
>>   - clean_dcache_range_nopatch(), as read_sanitised_ftr_reg() and
>>     related code can be instrumented.
>>
>>   This might need some underlying rework elsewhere (e.g. in the
>>   cpufeature code, or atomics framework).
>>
>> So on the kernel side, maybe a first step would be to try to headerize
>> the insn generation code as __always_inline, and see whether that looks
>> ok? With that out of the way it'd be a bit easier to rework patching
>> code depending on the insn framework.
>
> OK. I will study this.

Great, thanks!

Mark.


