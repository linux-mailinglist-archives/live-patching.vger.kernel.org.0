Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA00A6E2EF5
	for <lists+live-patching@lfdr.de>; Sat, 15 Apr 2023 06:14:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229615AbjDOEOi (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Sat, 15 Apr 2023 00:14:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbjDOEOh (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Sat, 15 Apr 2023 00:14:37 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 30E3849D7;
        Fri, 14 Apr 2023 21:14:35 -0700 (PDT)
Received: from [192.168.254.32] (unknown [47.189.246.67])
        by linux.microsoft.com (Postfix) with ESMTPSA id A8D7D2179262;
        Fri, 14 Apr 2023 21:14:33 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com A8D7D2179262
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1681532074;
        bh=j521elXctw+G+7/S2A3bktLJfDJV6hvnvHUJKFioICU=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=Usb0R1vdJuBqPnBNM1i8xezubq6ZedR6e2qsxRfnQgdQ0jSONkitrmpvUgtwXiifh
         Rp5CNDg4nwhbwqvgtcPH0b9mY/ITu0rXVdfJtg9jtREfZelOqYHdylHGolzlRmcacM
         iqbFocZcmgQypkYy6qbCqTUoqHS1vYgA8xCXcjFY=
Message-ID: <5ee7e7da-9dba-b9b6-dcca-9bcbcbb879c1@linux.microsoft.com>
Date:   Fri, 14 Apr 2023 23:14:32 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [RFC PATCH v3 00/22] arm64: livepatch: Use ORC for dynamic frame
 pointer validation
To:     "Jose E. Marchesi" <jose.marchesi@oracle.com>,
        Nick Desaulniers <ndesaulniers@google.com>
Cc:     Mark Rutland <mark.rutland@arm.com>, jpoimboe@redhat.com,
        peterz@infradead.org, chenzhongjin@huawei.com, broonie@kernel.org,
        nobuta.keiya@fujitsu.com, sjitindarsingh@gmail.com,
        catalin.marinas@arm.com, will@kernel.org,
        jamorris@linux.microsoft.com, linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        llvm@lists.linux.dev, linux-toolchains@vger.kernel.org
References: <20230202074036.507249-1-madvenka@linux.microsoft.com>
 <ZByJmnc/XDcqQwoZ@FVFF77S0Q05N.cambridge.arm.com>
 <ZDg2BUL4uauG/w4T@google.com> <87wn2fhcmh.fsf@oracle.com>
Content-Language: en-US
From:   "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
In-Reply-To: <87wn2fhcmh.fsf@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-22.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org



On 4/13/23 13:15, Jose E. Marchesi wrote:
> 
>> On Thu, Mar 23, 2023 at 05:17:14PM +0000, Mark Rutland wrote:
>>> Hi Madhavan,
>>>
>>> At a high-level, I think this still falls afoul of our desire to not reverse
>>> engineer control flow from the binary, and so I do not think this is the right
>>> approach. I've expanded a bit on that below.
>>>
>>> I do think it would be nice to have *some* of the objtool changes, as I do
>>> think we will want to use objtool for some things in future (e.g. some
>>> build-time binary patching such as table sorting).
>>>
>>>> Problem
>>>> =======
>>>>
>>>> Objtool is complex and highly architecture-dependent. There are a lot of
>>>> different checks in objtool that all of the code in the kernel must pass
>>>> before livepatch can be enabled. If a check fails, it must be corrected
>>>> before we can proceed. Sometimes, the kernel code needs to be fixed.
>>>> Sometimes, it is a compiler bug that needs to be fixed. The challenge is
>>>> also to prove that all the work is complete for an architecture.
>>>>
>>>> As such, it presents a great challenge to enable livepatch for an
>>>> architecture.
>>>
>>> There's a more fundamental issue here in that objtool has to reverse-engineer
>>> control flow, and so even if the kernel code and compiled code generation is
>>> *perfect*, it's possible that objtool won't recognise the structure of the
>>> generated code, and won't be able to reverse-engineer the correct control flow.
>>>
>>> We've seen issues where objtool didn't understand jump tables, so support for
>>> that got disabled on x86. A key objection from the arm64 side is that we don't
>>> want to disable compile code generation strategies like this. Further, as
>>> compiles evolve, their code generation strategies will change, and it's likely
>>> there will be other cases that crop up. This is inherently fragile.
>>>
>>> The key objections from the arm64 side is that we don't want to
>>> reverse-engineer details from the binary, as this is complex, fragile, and
>>> unstable. This is why we've previously suggested that we should work with
>>> compiler folk to get what we need.
>>
>>> This still requires reverse-engineering the forward-edge control flow in order
>>> to compute those offets, so the same objections apply with this approach. I do
>>> not think this is the right approach.
>>>
>>> I would *strongly* prefer that we work with compiler folk to get the
>>> information that we need.
>>
>> IDK if it's relevant here, but I did see a commit go by to LLVM that
>> seemed to include such info in a custom ELF section (for the purposes of
>> improving fuzzing, IIUC). Maybe such an encoding scheme could be tested
>> to see if it's reliable or usable?
>> - https://github.com/llvm/llvm-project/commit/3e52c0926c22575d918e7ca8369522b986635cd3
>> - https://clang.llvm.org/docs/SanitizerCoverage.html#tracing-control-flow
>>
>>>
>>> [...]
>>>
>>>> 		FWIW, I have also compared the CFI I am generating with DWARF
>>>> 		information that the compiler generates. The CFIs match a
>>>> 		100% for Clang. In the case of gcc, the comparison fails
>>>> 		in 1.7% of the cases. I have analyzed those cases and found
>>>> 		the DWARF information generated by gcc is incorrect. The
>>>> 		ORC generated by my Objtool is correct.
>>>
>>>
>>> Have you reported this to the GCC folk, and can you give any examples?
>>> I'm sure they would be interested in fixing this, regardless of whether we end
>>> up using it.
>>
>> Yeah, at least a bug report is good. "See something, say something."
> 
> By all means, please.  If you guys report these issues on CFI
> divergences in the GCC bugzilla, we will look into fixing them.
> 
> https://gcc.gnu.org/bugzilla

I will try to get the data again and report the problems that I see.

Thanks.

Madhavan
