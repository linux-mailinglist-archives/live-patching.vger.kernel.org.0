Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B1EA6DEAB7
	for <lists+live-patching@lfdr.de>; Wed, 12 Apr 2023 06:48:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229485AbjDLEs0 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 12 Apr 2023 00:48:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbjDLEsZ (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 12 Apr 2023 00:48:25 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 18F933C11;
        Tue, 11 Apr 2023 21:48:24 -0700 (PDT)
Received: from [192.168.254.32] (unknown [47.189.246.67])
        by linux.microsoft.com (Postfix) with ESMTPSA id 9F03221779AC;
        Tue, 11 Apr 2023 21:48:22 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 9F03221779AC
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1681274903;
        bh=VDa3yGOxZOkIKUoi4MUQFdW7uP1qiz4EHSVTUPJnmSU=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=hJrKDRJhhVmd8lGFBBdGrqXrxa8SvIYD/OVHSHI5bMuc7jafZw/2DJPo5Cb5sKBEg
         rPGYeyVguZW9lpEdgGuaytzWShZ78htL1MtePgiMspqtGo7c+cgJjxYtQjBRAE6A8b
         06bE1EIwlni+WZDyLEWjkqD8v+V/sAiTSCEG9rQI=
Message-ID: <c7e1df79-1506-4502-035b-24ddf6848311@linux.microsoft.com>
Date:   Tue, 11 Apr 2023 23:48:21 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [RFC PATCH v3 00/22] arm64: livepatch: Use ORC for dynamic frame
 pointer validation
Content-Language: en-US
To:     Josh Poimboeuf <jpoimboe@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>
Cc:     jpoimboe@redhat.com, peterz@infradead.org, chenzhongjin@huawei.com,
        broonie@kernel.org, nobuta.keiya@fujitsu.com,
        sjitindarsingh@gmail.com, catalin.marinas@arm.com, will@kernel.org,
        jamorris@linux.microsoft.com, linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
References: <0337266cf19f4c98388e3f6d09f590d9de258dc7>
 <20230202074036.507249-1-madvenka@linux.microsoft.com>
 <ZByJmnc/XDcqQwoZ@FVFF77S0Q05N.cambridge.arm.com>
 <054ce0d6-70f0-b834-d4e5-1049c8df7492@linux.microsoft.com>
 <ZDVft9kysWMfTiZW@FVFF77S0Q05N> <20230412041752.i4raswvrnacnjjgy@treble>
From:   "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
In-Reply-To: <20230412041752.i4raswvrnacnjjgy@treble>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-22.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org



On 4/11/23 23:17, Josh Poimboeuf wrote:
> On Tue, Apr 11, 2023 at 02:25:11PM +0100, Mark Rutland wrote:
>>> By your own argument, we cannot rely on the compiler as compiler implementations,
>>> optimization strategies, etc can change in ways that are incompatible with any
>>> livepatch implementation.
>>
>> That's not quite my argument.
>>
>> My argument is that if we assume some set of properties that compiler folk
>> never agreed to (and were never made aware of), then compiler folk are well
>> within their rights to change the compiler such that it doesn't provide those
>> properties, and it's very likely that such expectation will be broken. We've
>> seen that happen before (e.g. with jump tables).
>>
>> Consequently I think we should be working with compiler folk to agree upon some
>> solution, where compiler folk will actually try to maintain the properties we
>> depend upon (and e.g. they could have tests for). That sort of co-design has
>> worked well so far (e.g. with things like kCFI).
>>
>> Ideally we'd have people in the same room to have a discussion (e.g. at LPC).
> 
> That was the goal of my talk at LPC last year:
> 
>   https://lpc.events/event/16/contributions/1392/
> 
> We discussed having the compiler annotate the tricky bits of control
> flow, mainly jump tables and noreturns.  It's still on my TODO list to
> prototype that.
> 
> Another alternative which has been suggested in the past by Indu and
> others is for objtool to use DWARF/sframe as an input to help guide it
> through the tricky bits.
> 

I read through the SFrame spec file briefly. It looks like I can easily adapt my
version 1 of the livepatch patchset which was based on DWARF to SFrame. If the compiler
folks agree to properly support and maintain SFrame, then I could send the next version
of the patchset based on SFrame.

But I kinda need a clear path forward before I implement anything. I request the arm64
folks to comment on the above approach. Would it be useful to initiate an email discussion
with the compiler folks on what they plan to do to support SFrame? Or, should this all
happen face to face in some forum like LPC?

Madhavan

> That seems more fragile -- as Madhavan mentioned, GCC-generated DWARF
> has some reliability issues -- and also defeats some of the benefits of
> reverse-engineering in the first place (we've found many compiler bugs
> and other surprising kernel-compiler interactions over the years).
> 
> Objtool's understanding of the control flow graph has been really
> valuable for reasons beyond live patching (e.g., noinstr and uaccess
> validation), it's definitely worth finding a way to make that more
> sustainable.
> 
