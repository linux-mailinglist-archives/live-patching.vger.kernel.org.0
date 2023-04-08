Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8A626DB89F
	for <lists+live-patching@lfdr.de>; Sat,  8 Apr 2023 05:40:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230013AbjDHDkN (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 7 Apr 2023 23:40:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230027AbjDHDkM (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 7 Apr 2023 23:40:12 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5BEC193C1;
        Fri,  7 Apr 2023 20:40:10 -0700 (PDT)
Received: from [192.168.254.32] (unknown [47.189.246.67])
        by linux.microsoft.com (Postfix) with ESMTPSA id AEE80213B635;
        Fri,  7 Apr 2023 20:40:08 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com AEE80213B635
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1680925209;
        bh=yu4L/pgWX5pNzUR0FHcUhBCU2kj8zE6++8P99CHGKEY=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=aEFJhjE9CShP4mJEQMoazLtG0imOXB9kWveQoMXnUD0NSAhBwXNpcGeomZjc+iF9n
         tyiIpCWB0gIRxiIYq6YdfHvvVyDSgJEx2aU+HoId+7FqtbM9cYUQcUkLlE7udR6OMV
         7mqYxOOe+221I0eNe9XjAw2GFjpuP/OjJbONdUNM=
Message-ID: <054ce0d6-70f0-b834-d4e5-1049c8df7492@linux.microsoft.com>
Date:   Fri, 7 Apr 2023 22:40:07 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [RFC PATCH v3 00/22] arm64: livepatch: Use ORC for dynamic frame
 pointer validation
To:     Mark Rutland <mark.rutland@arm.com>
Cc:     jpoimboe@redhat.com, peterz@infradead.org, chenzhongjin@huawei.com,
        broonie@kernel.org, nobuta.keiya@fujitsu.com,
        sjitindarsingh@gmail.com, catalin.marinas@arm.com, will@kernel.org,
        jamorris@linux.microsoft.com, linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
References: <0337266cf19f4c98388e3f6d09f590d9de258dc7>
 <20230202074036.507249-1-madvenka@linux.microsoft.com>
 <ZByJmnc/XDcqQwoZ@FVFF77S0Q05N.cambridge.arm.com>
Content-Language: en-US
From:   "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
In-Reply-To: <ZByJmnc/XDcqQwoZ@FVFF77S0Q05N.cambridge.arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-19.9 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Hi Mark,

Sorry for the long delay in responding. Was caught up in many things.
My responses inline..

On 3/23/23 12:17, Mark Rutland wrote:
> Hi Madhavan,
> 
> At a high-level, I think this still falls afoul of our desire to not reverse
> engineer control flow from the binary, and so I do not think this is the right
> approach. I've expanded a bit on that below.
> 
> I do think it would be nice to have *some* of the objtool changes, as I do
> think we will want to use objtool for some things in future (e.g. some
> build-time binary patching such as table sorting).
> 

OK. I have been under the impression that the arm64 folks are basically OK with
Objtool's approach of reverse engineering from the binary. I did not see
any specific objections to previously submitted patches based on this approach
including mine.

So, if the community is not in agreement with this approach, I will go back to the
drawing board for this one.

Are there any other opinions on this subject from others?

> On Thu, Feb 02, 2023 at 01:40:14AM -0600, madvenka@linux.microsoft.com wrote:
>> From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
>>
>> Introduction
>> ============
>>
>> The livepatch feature requires an unwinder that can provide a reliable stack
>> trace. General requirements for a reliable unwinder are described in this
>> document from Mark Rutland:
>>
>> 	Documentation/livepatch/reliable-stacktrace.rst
>>
>> The requirements have two parts:
>>
>> 1. The unwinder must be enhanced with certain features. E.g.,
>>
>> 	- Identifying successful termination of stack trace
>> 	- Identifying unwindable and non-unwindable code
>> 	- Identifying interrupts and exceptions occurring in the frame pointer
>> 	  prolog and epilog
>> 	- Identifying features such as kretprobe and ftrace graph tracing
>> 	  that can modify the return address stored on the stack
>> 	- Identifying corrupted/unreliable stack contents
>> 	- Architecture-specific items that can render a stack trace unreliable
>> 	  at certain points in code
>>
>> 2. Validation of the frame pointer
>>
>> 	This assumes that the unwinder is based on the frame pointer (FP).
>> 	The actual frame pointer that the unwinder uses cannot just be
>> 	assumed to be correct. It needs to be validated somehow.
>>
>> This patch series is to address the following:
>>
>> 	- Identifying unwindable and non-unwindable code
>> 	- Identifying interrupts and exceptions occurring in the frame pointer
>> 	  prolog and epilog
>> 	- Validation of the frame pointer
>>
>> The rest are already in place AFAICT.
> 
> Just as a note: there are a few issues remaining (e.g. the kretprobe and fgraph
> PC recovery both have windows where they lose the original return address), and
> there are a few compiler-generated trampoline functions with non-AAPCS calling
> conventions that will need special care.
> 

OK.

>> Validation of the FP (aka FRAME_POINTER_VALIDATION)
>> ====================
>>
>> The current approach in Linux is to use objtool, a build time tool, for this
>> purpose. When configured, objtool is invoked on every relocatable object file
>> during kernel build. It performs static analysis of the code in each file. It
>> walks the instructions in every function and notes the changes to the stack
>> pointer (SP) and the frame pointer (FP). It makes sure that the changes are in
>> accordance with the ABI rules. There are also a lot of other checks that
>> Objtool performs. Once objtool completes successfully, the kernel can then be
>> used for livepatch purposes.
>>
>> Objtool can have uses other than just FP validation. For instance, it can check
>> control flow integrity during its analysis.
>>
>> Problem
>> =======
>>
>> Objtool is complex and highly architecture-dependent. There are a lot of
>> different checks in objtool that all of the code in the kernel must pass
>> before livepatch can be enabled. If a check fails, it must be corrected
>> before we can proceed. Sometimes, the kernel code needs to be fixed.
>> Sometimes, it is a compiler bug that needs to be fixed. The challenge is
>> also to prove that all the work is complete for an architecture.
>>
>> As such, it presents a great challenge to enable livepatch for an
>> architecture.
> 
> There's a more fundamental issue here in that objtool has to reverse-engineer
> control flow, and so even if the kernel code and compiled code generation is
> *perfect*, it's possible that objtool won't recognise the structure of the
> generated code, and won't be able to reverse-engineer the correct control flow.
> 
> We've seen issues where objtool didn't understand jump tables, so support for
> that got disabled on x86. A key objection from the arm64 side is that we don't
> want to disable compile code generation strategies like this. Further, as
> compiles evolve, their code generation strategies will change, and it's likely
> there will be other cases that crop up. This is inherently fragile.
> 
> The key objections from the arm64 side is that we don't want to
> reverse-engineer details from the binary, as this is complex, fragile, and
> unstable. This is why we've previously suggested that we should work with
> compiler folk to get what we need.
> 

So, what exactly do you have in mind? What help can the compiler folk provide?
By your own argument, we cannot rely on the compiler as compiler implementations,
optimization strategies, etc can change in ways that are incompatible with any
livepatch implementation. Also, there can always be bugs in the compiler
implementations.

Can you please elaborate? Are we looking for a way for the compiler folks to
provide us with something that we can use to implement reliable stack trace?

> I'll note that at the last Linux Plumbers Conference, there was a discussion
> about what is now called SFrame, which *might* give us sufficient information,
> but I have not had the time to dig into that as I have been chasing other
> problems and trying to get other infrastructure in place.
> 

I will try to locate the link. If you can provide me a link, that would be greatly
appreciated. I will study their SFrame proposal.

>> A different approach
>> ====================
>>
>> I would like to propose a different approach for FP validation. I would
>> like to be able to enable livepatch for an architecture as is. That is,
>> without "fixing" the kernel or the compiler for it:
>>
>> There are three steps in this:
>>
>> 1. Objtool walks all the functions as usual. It computes the stack and
>>    frame pointer offsets at each instruction as usual. It generates ORC
>>    records and stores them in special sections as usual. This is simple
>>    enough to do.
> 
> This still requires reverse-engineering the forward-edge control flow in order
> to compute those offets, so the same objections apply with this approach. I do
> not think this is the right approach.
> 
> I would *strongly* prefer that we work with compiler folk to get the
> information that we need.
> 

I am willing to do this. But I am not clear on the kind of features we want
from the compiler. Are you suggesting something for getting a reliable
stack trace? Is there any kind of proposal out there that I need to study?

> [...]
> 
>> 		FWIW, I have also compared the CFI I am generating with DWARF
>> 		information that the compiler generates. The CFIs match a
>> 		100% for Clang. In the case of gcc, the comparison fails
>> 		in 1.7% of the cases. I have analyzed those cases and found
>> 		the DWARF information generated by gcc is incorrect. The
>> 		ORC generated by my Objtool is correct.
> 
> 
> Have you reported this to the GCC folk, and can you give any examples?
> I'm sure they would be interested in fixing this, regardless of whether we end
> up using it.
> 

I will try to get the data again and put something together and send it to the
gcc folks.

Thanks for the suggestions.

Madhavan
