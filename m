Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E28B26E2EFE
	for <lists+live-patching@lfdr.de>; Sat, 15 Apr 2023 06:27:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229543AbjDOE1t (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Sat, 15 Apr 2023 00:27:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbjDOE1s (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Sat, 15 Apr 2023 00:27:48 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1F6C249F5;
        Fri, 14 Apr 2023 21:27:47 -0700 (PDT)
Received: from [192.168.254.32] (unknown [47.189.246.67])
        by linux.microsoft.com (Postfix) with ESMTPSA id B33BB217A94A;
        Fri, 14 Apr 2023 21:27:45 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com B33BB217A94A
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1681532866;
        bh=OX5xVhjidekkFVQIYzgkoxkH+GLLDJ1xTOt43sVJ2OM=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=rcqOCAaOyPmeZX4WCMxx0UEeK5ysE/La3n7WSecBaxuv4JwwLzWgozwl3EM0qGWoW
         E05kjjxvTxooa/OtOYgWCznQyo9ceT5RBenHcP8L69VqnyneQebxiy/FK4dHS42tJB
         ahAWUw2UZJZC4iR//tLO0q0k8wOStGMw3sZz/xf8=
Message-ID: <4e5029f4-be42-ef23-1eab-a6cfff49527c@linux.microsoft.com>
Date:   Fri, 14 Apr 2023 23:27:44 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [RFC PATCH v3 00/22] arm64: livepatch: Use ORC for dynamic frame
 pointer validation
Content-Language: en-US
To:     Josh Poimboeuf <jpoimboe@kernel.org>
Cc:     Mark Rutland <mark.rutland@arm.com>, jpoimboe@redhat.com,
        peterz@infradead.org, chenzhongjin@huawei.com, broonie@kernel.org,
        nobuta.keiya@fujitsu.com, sjitindarsingh@gmail.com,
        catalin.marinas@arm.com, will@kernel.org,
        jamorris@linux.microsoft.com, linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-toolchains@vger.kernel.org
References: <20230202074036.507249-1-madvenka@linux.microsoft.com>
 <ZByJmnc/XDcqQwoZ@FVFF77S0Q05N.cambridge.arm.com>
 <054ce0d6-70f0-b834-d4e5-1049c8df7492@linux.microsoft.com>
 <ZDVft9kysWMfTiZW@FVFF77S0Q05N> <20230412041752.i4raswvrnacnjjgy@treble>
 <c7e1df79-1506-4502-035b-24ddf6848311@linux.microsoft.com>
 <20230412050106.7v4s3lalg43i6ciw@treble>
 <a7e45ab5-c583-9077-5747-9a3d3b7274e7@linux.microsoft.com>
 <20230412155221.2l2mqsyothseymeq@treble>
 <cf583799-1a8d-4dd2-8bc7-c8fbb07f29ab@linux.microsoft.com>
 <20230413163035.ttar5uexrpldz3yl@treble>
From:   "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
In-Reply-To: <20230413163035.ttar5uexrpldz3yl@treble>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-22.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org



On 4/13/23 11:30, Josh Poimboeuf wrote:
> On Thu, Apr 13, 2023 at 09:59:31AM -0500, Madhavan T. Venkataraman wrote:
>> On 4/12/23 10:52, Josh Poimboeuf wrote:
>>> On Wed, Apr 12, 2023 at 09:50:23AM -0500, Madhavan T. Venkataraman wrote:
>>>>>> I read through the SFrame spec file briefly. It looks like I can easily adapt my
>>>>>> version 1 of the livepatch patchset which was based on DWARF to SFrame. If the compiler
>>>>>> folks agree to properly support and maintain SFrame, then I could send the next version
>>>>>> of the patchset based on SFrame.
>>>>>>
>>>>>> But I kinda need a clear path forward before I implement anything. I request the arm64
>>>>>> folks to comment on the above approach. Would it be useful to initiate an email discussion
>>>>>> with the compiler folks on what they plan to do to support SFrame? Or, should this all
>>>>>> happen face to face in some forum like LPC?
>>>>>
>>>>> SFrame is basically a simplified version of DWARF unwind, using it as an
>>>>> input to objtool is going to have the same issues I mentioned below (and
>>>>> as was discussed with your v1).
>>>>>
>>>>
>>>> Yes. It is a much simplified version of DWARF. So, I am hoping that the compiler folks
>>>> can provide the feature with a reliability guarantee. DWARF is too complex.
>>>
>>> I don't see what the complexity (or lack thereof) of the unwinding data
>>> format has to do with it.  The unreliability comes from the underlying
>>> data source, not the formatting of the data.
>>>
>>
>> What I meant is - if SFrame is implemented by simply extracting unwind info from
>> DWARF data and placing it in a separate section (as it is probably implemented now),
>> then what you say is totally true. But if the compiler folks agree to make SFrame reliable,
>> then either they have to make DWARF reliable. Or, they have to implement SFrame as a
>> separate feature and make it reliable. The former is tough to do as DWARF has a lot of complexity.
>> The latter is a lot easier to do.
> 
> [ adding linux-toolchains ]
> 
> I don't think ensuring reliability is an easy task, regardless of the
> complexity of the unwinding format.
> 
> Whether it's SFrame or DWARF/eh_frame, the question would be how to
> ensure it's always reliable for a compiler "power user" like the kernel
> which has many edge cases (including lots of inline asm which the
> compiler has no visibility to) and which uses unwinding for more than
> just debugging.
> 
> It would need some kind of black-box testing on a complex code base.
> (hint: kind of like what objtool already does today)
> 

I could use the ORC data I generate by using the decoder against the SFrame data.
A function is reliable only if both data sources agree for the whole function.

Also, in my approach, the actual frame pointer is dynamically checked against the
frame pointer computed from the unwind data. Any mismatch indicates an unreliable stack trace.

IMHO, this is sufficient to provide livepatch. Do you agree?

Madhavan
