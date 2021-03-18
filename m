Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55C11341069
	for <lists+live-patching@lfdr.de>; Thu, 18 Mar 2021 23:39:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231846AbhCRWis (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 18 Mar 2021 18:38:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230368AbhCRWib (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 18 Mar 2021 18:38:31 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CF99C06174A;
        Thu, 18 Mar 2021 15:38:31 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id q5so4506337pfh.10;
        Thu, 18 Mar 2021 15:38:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=hPV6PFlpjtaaQAGr+gXeOd26mXT5CK+0etiUFA1UmqY=;
        b=OqRfeKnan531gNoR4Nd5w07qAxyWwLt4N1mVSIGgcrjc0OUl/C+1Ot9r8Rz6AAurhL
         8yKR4OQp1/YgQCqMa9oXsNccxmz7A31fWb4dyR2/8NeJoOYpKYbNXRXtW5+/ESDng0GL
         3DB9zlWP5/JOFf2FAvMxzaGAHEyWtqz4vxR6k0qXFQVA51OwkFa6b67ATPZ4wWt1rlia
         AojEZR7Em6bSbXuCSfvOL2wnZHF4MzRjdqj/CODxCIu/0dHpFEA48tIPbH8QJq1NAVdR
         CGnFotTADS8fpQMYNYv9b5ONo64lRcNFTbt3ZC2jonERPYisi7RALzmmwVpiPdguQD1s
         Q5FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hPV6PFlpjtaaQAGr+gXeOd26mXT5CK+0etiUFA1UmqY=;
        b=lMbTWwuAti8nh5vu1m+L2o3q0faGN8DYRBuplDOXMY2zmrpUgsVhKmRNJOYdYNKC14
         p9FNEJ/HUcaYowpg/jlzwR7pJ5gjyMJRVw2c3nosP5/QmBFYBFa6XXNB04VQV/PZ4lX/
         32aQueeLbLUfSoB4kdMb/4Yveg1zaQQVI33Wi6waa+Cshmn4F7T7dd6vrORSpRZfjYo+
         /OejGDWgzeH6KEdxWBfadrjbGxW3v5tBi5XD3Y7nnUxYIBsd8Z8q2DpXDzA/w0eUGK9Y
         EOsfhkkx6r/AyNoDM/q8jjICNUbps90mj9SIu47RgssiAFKysISAh3onYPH2wsruHL9W
         iYbA==
X-Gm-Message-State: AOAM531l3NwjxegN6Q6xfJWX4FsNYpoMNIP7b6i1KzXk2jtQmSkwYKxN
        4rJEgHS/MzPP8zmywJmZX2i/7YRv5TI=
X-Google-Smtp-Source: ABdhPJwmZiMlog75NmzcgOTt8rBz68L8AA9VFQ3YUiU/r50zikM5233QpapMYME/h3cjmwNVdDaZOA==
X-Received: by 2002:a62:800c:0:b029:203:6990:78e2 with SMTP id j12-20020a62800c0000b0290203699078e2mr6178087pfd.3.1616107109985;
        Thu, 18 Mar 2021 15:38:29 -0700 (PDT)
Received: from f8ffc2228008.ant.amazon.com ([54.240.193.1])
        by smtp.gmail.com with ESMTPSA id 10sm3300782pfp.4.2021.03.18.15.38.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Mar 2021 15:38:27 -0700 (PDT)
Subject: Re: Live patching on ARM64
To:     Mark Rutland <mark.rutland@arm.com>,
        "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
Cc:     linux-arm-kernel@lists.infradead.org,
        Mark Brown <broonie@kernel.org>,
        Julien Thierry <jthierry@redhat.com>, jpoimboe@redhat.com,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
References: <f3fe6a60-9ac2-591d-1b83-9113c50dc492@linux.microsoft.com>
 <20210115123347.GB39776@C02TD0UTHF1T.local>
From:   "Singh, Balbir" <bsingharora@gmail.com>
Message-ID: <176e6c60-18dd-167b-41aa-dfd11e5810d3@gmail.com>
Date:   Fri, 19 Mar 2021 09:38:20 +1100
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210115123347.GB39776@C02TD0UTHF1T.local>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On 15/1/21 11:33 pm, Mark Rutland wrote:
> On Thu, Jan 14, 2021 at 04:07:55PM -0600, Madhavan T. Venkataraman wrote:
>> Hi all,
>>
>> My name is Madhavan Venkataraman.
> 
> Hi Madhavan,
> 
>> Microsoft is very interested in Live Patching support for ARM64.
>> On behalf of Microsoft, I would like to contribute.
>>
>> I would like to get in touch with the people who are currently working
>> in this area, find out what exactly they are working on and see if they
>> could use an extra pair of eyes/hands with what they are working on.
>>
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
>> I apologize if I have missed anyone else who is working on Live Patching
>> for ARM64. Do let me know.

I am quite interested as well, I did some of the work for ppc64le

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

Do we know how this differs across architectures? Usually kprobe and ftrace
unsafe functions are annotated as such, is there more to it?

> 
> Once we have objtool it should be possible to identify those cases
> automatically. Currently I'm aware that we'll need to do something in at
> least the following places:
> 
> * The entry code -- I'm currently chipping away at this.

Could you please explain, whats bits of the entry code? I suspect we never
patch anything in assembly

> 
> * The insn framework (which is used by some patching code), since the
>   bulk of it lives in arch/arm64/kernel/insn.c and isn't marked noinstr.
>   

noinstr is largely kcsan and kasan related, right?

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
> So on the kernel side, maybe a first step would be to try to headerize
> the insn generation code as __always_inline, and see whether that looks
> ok? With that out of the way it'd be a bit easier to rework patching
> code depending on the insn framework.
> 
> I'm not sure about the objtool side, so I'll leave that to Julien and co
> to answer.

Thanks, it would be good to see what the expectations from objtool are,
I thought only x86 needed it due to variable size instructions and -fomit-
frame-pointers

Balbir Singh.
