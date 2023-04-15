Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 767846E3253
	for <lists+live-patching@lfdr.de>; Sat, 15 Apr 2023 18:15:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229546AbjDOQP0 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Sat, 15 Apr 2023 12:15:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbjDOQP0 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Sat, 15 Apr 2023 12:15:26 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9805E4EC4;
        Sat, 15 Apr 2023 09:15:24 -0700 (PDT)
Received: from [192.168.254.32] (unknown [47.189.246.67])
        by linux.microsoft.com (Postfix) with ESMTPSA id 00E48217A961;
        Sat, 15 Apr 2023 09:15:22 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 00E48217A961
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1681575323;
        bh=BQyFn9eZZffNATRXzm9M9vw6AouDE12jN76o7N/ccXk=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=Hbx11DXKAp9mBgcU6LD08Rxs+fvDR2qfam11ZmKO7fLVOPzI5imnZLSFQa6gT06Iy
         W34agblz0Iw/AsKu0P0loHKbjV8bt2kbIHwU803McAblcLHcmI91fyaRrSZ1fTp7pd
         8QC+bLDIsC4Mix3pnXaGIIdxSwAJUXdvpYl00MxE=
Message-ID: <2ca8b877-e936-da66-3320-ce87a1712428@linux.microsoft.com>
Date:   Sat, 15 Apr 2023 11:15:21 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [RFC PATCH v3 00/22] arm64: livepatch: Use ORC for dynamic frame
 pointer validation
To:     Josh Poimboeuf <jpoimboe@kernel.org>
Cc:     Mark Rutland <mark.rutland@arm.com>, jpoimboe@redhat.com,
        peterz@infradead.org, chenzhongjin@huawei.com, broonie@kernel.org,
        nobuta.keiya@fujitsu.com, sjitindarsingh@gmail.com,
        catalin.marinas@arm.com, will@kernel.org,
        jamorris@linux.microsoft.com, linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-toolchains@vger.kernel.org
References: <054ce0d6-70f0-b834-d4e5-1049c8df7492@linux.microsoft.com>
 <ZDVft9kysWMfTiZW@FVFF77S0Q05N> <20230412041752.i4raswvrnacnjjgy@treble>
 <c7e1df79-1506-4502-035b-24ddf6848311@linux.microsoft.com>
 <20230412050106.7v4s3lalg43i6ciw@treble>
 <a7e45ab5-c583-9077-5747-9a3d3b7274e7@linux.microsoft.com>
 <20230412155221.2l2mqsyothseymeq@treble>
 <cf583799-1a8d-4dd2-8bc7-c8fbb07f29ab@linux.microsoft.com>
 <20230413163035.ttar5uexrpldz3yl@treble>
 <4e5029f4-be42-ef23-1eab-a6cfff49527c@linux.microsoft.com>
 <20230415050556.isimfnqnsgwmerkf@treble>
Content-Language: en-US
From:   "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
In-Reply-To: <20230415050556.isimfnqnsgwmerkf@treble>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-22.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org



On 4/15/23 00:05, Josh Poimboeuf wrote:
> On Fri, Apr 14, 2023 at 11:27:44PM -0500, Madhavan T. Venkataraman wrote:
>>>> What I meant is - if SFrame is implemented by simply extracting unwind info from
>>>> DWARF data and placing it in a separate section (as it is probably implemented now),
>>>> then what you say is totally true. But if the compiler folks agree to make SFrame reliable,
>>>> then either they have to make DWARF reliable. Or, they have to implement SFrame as a
>>>> separate feature and make it reliable. The former is tough to do as DWARF has a lot of complexity.
>>>> The latter is a lot easier to do.
>>>
>>> [ adding linux-toolchains ]
>>>
>>> I don't think ensuring reliability is an easy task, regardless of the
>>> complexity of the unwinding format.
>>>
>>> Whether it's SFrame or DWARF/eh_frame, the question would be how to
>>> ensure it's always reliable for a compiler "power user" like the kernel
>>> which has many edge cases (including lots of inline asm which the
>>> compiler has no visibility to) and which uses unwinding for more than
>>> just debugging.
>>>
>>> It would need some kind of black-box testing on a complex code base.
>>> (hint: kind of like what objtool already does today)
>>>
>>
>> I could use the ORC data I generate by using the decoder against the SFrame data.
>> A function is reliable only if both data sources agree for the whole function.
> 
> This is somewhat similar to what I'm saying in another thread:
> 
>   https://lore.kernel.org/live-patching/20230415043949.7y4tvshe26zday3e@treble/
> 
> If objtool and DWARF/SFrame agree, all is well.
> 
>> Also, in my approach, the actual frame pointer is dynamically checked against the
>> frame pointer computed from the unwind data. Any mismatch indicates an unreliable stack trace.
>>
>> IMHO, this is sufficient to provide livepatch. Do you agree?
> 
> The dynamic reliable stacktrace checks for CONFIG_FRAME_POINTER on x86
> are much simpler, as they don't require ORC or any other metadata.  They
> just need to detect preemption and page faults on the stack, and to
> identify the end of the stack.  Those simple dynamic checks, combined
> with objtool's build-time frame pointer validation, worked very well
> until we switched to ORC.
> 
> So I'm not sure I see the benefit of the additional complexity involved
> in cross-checking frame pointers with ORC at runtime.  But I'm just a
> bystander.  What really matters is what the arm64 folks think ;-)
> 

The unwinder on arm64 is frame-pointer based. I don't want to deviate from that.
I just want to use the metadata to validate the frame pointer. This approach
also catches the rare cases of frame pointer corruption and any bugs in
SFrame that the metadata check did not catch.

Of course, this is all moot if the arm64 folks do not even want the reverse engineering.
I guess we wait until the microconference to discuss all this.

Madhavan
