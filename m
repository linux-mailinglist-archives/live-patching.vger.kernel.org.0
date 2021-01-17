Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3A692F9423
	for <lists+live-patching@lfdr.de>; Sun, 17 Jan 2021 18:26:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729880AbhAQR00 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Sun, 17 Jan 2021 12:26:26 -0500
Received: from linux.microsoft.com ([13.77.154.182]:39950 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729877AbhAQR0Y (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Sun, 17 Jan 2021 12:26:24 -0500
Received: from [192.168.254.32] (unknown [47.187.219.45])
        by linux.microsoft.com (Postfix) with ESMTPSA id A8F0120B7192;
        Sun, 17 Jan 2021 09:25:42 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com A8F0120B7192
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1610904343;
        bh=dSxgyZILd6ePeQFGFSfItK/jBXk7vqxGoh5JR1/STnU=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=NaeBDi7O+56Gh0KonoBTBOjzfe3hfWYRl6mCpb1uojoZiibtZgwkuczXfumqIW1Xm
         qLblMkxvZUO1VO/QuGbp2KyGbuFyRon9vp3BruaNST8Hd5OpKIg1DLmuMYc+LN2Pre
         JQ1/PqvGORj1UhGIMXUax1j8+WP3nJY/6SRq7ObU=
Subject: Re: Live patching on ARM64
To:     Mark Rutland <mark.rutland@arm.com>
Cc:     linux-arm-kernel@lists.infradead.org,
        Mark Brown <broonie@kernel.org>,
        Julien Thierry <jthierry@redhat.com>, jpoimboe@redhat.com,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
References: <f3fe6a60-9ac2-591d-1b83-9113c50dc492@linux.microsoft.com>
 <20210115123347.GB39776@C02TD0UTHF1T.local>
From:   "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
Message-ID: <a5f22237-a18d-3905-0521-f0d0f9c253ea@linux.microsoft.com>
Date:   Sun, 17 Jan 2021 11:25:41 -0600
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



On 1/15/21 6:33 AM, Mark Rutland wrote:

>> It looks like the most recent work in this area has been from the
>> following folks:
>>
>> Mark Brown and Mark Rutland:
>> 	Kernel changes to providing reliable stack traces.
>>
>> Julien Thierry:
>> 	Providing ARM64 support in objtool.
>>
>> Torsten Duwe:
>> 	Ftrace with regs.
> 
> IIRC that's about right. I'm also trying to make arm64 patch-safe (more
> on that below), and there's a long tail of work there for anyone
> interested.
> 

OK.

>> I apologize if I have missed anyone else who is working on Live Patching
>> for ARM64. Do let me know.
>>
>> Is there any work I can help with? Any areas that need investigation, any code
>> that needs to be written, any work that needs to be reviewed, any testing that
>> needs to done? You folks are probably super busy and would not mind an extra
>> hand.
> 
> One general thing that I believe we'll need to do is to rework code to
> be patch-safe (which implies being noinstr-safe too). For example, we'll
> need to rework the instruction patching code such that this cannot end
> up patching itself (or anything that has instrumented it) in an unsafe
> way.
> 

OK.

> Once we have objtool it should be possible to identify those cases
> automatically. Currently I'm aware that we'll need to do something in at
> least the following places:
> 
> * The entry code -- I'm currently chipping away at this.
> 

OK.

> * The insn framework (which is used by some patching code), since the
>   bulk of it lives in arch/arm64/kernel/insn.c and isn't marked noinstr.
>   
>   We can probably shift the bulk of the aarch64_insn_gen_*() and
>   aarch64_get_*() helpers into a header as __always_inline functions,
>   which would allow them to be used in noinstr code. As those are
>   typically invoked with a number of constant arguments that the
>   compiler can fold, this /might/ work out as an optimization if the
>   compiler can elide the error paths.
> 
> * The alternatives code, since we call instrumentable and patchable
>   functions between updating instructions and performing all the
>   necessary maintenance. There are a number of cases within
>   __apply_alternatives(), e.g.
> 
>   - test_bit()
>   - cpus_have_cap()
>   - pr_info_once()
>   - lm_alias()
>   - alt_cb, if the callback is not marked as noinstr, or if it calls
>     instrumentable code (e.g. from the insn framework).
>   - clean_dcache_range_nopatch(), as read_sanitised_ftr_reg() and
>     related code can be instrumented.
> 
>   This might need some underlying rework elsewhere (e.g. in the
>   cpufeature code, or atomics framework).
> 

OK.

> So on the kernel side, maybe a first step would be to try to headerize
> the insn generation code as __always_inline, and see whether that looks
> ok? With that out of the way it'd be a bit easier to rework patching
> code depending on the insn framework.
> 

OK.

I have an understanding of some of the above already. I will come up to
speed on the others. I will email you any questions I might have.

> I'm not sure about the objtool side, so I'll leave that to Julien and co
> to answer.
> 

Thanks for the information.

Madhavan
