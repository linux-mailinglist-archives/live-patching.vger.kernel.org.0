Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBCD54FC383
	for <lists+live-patching@lfdr.de>; Mon, 11 Apr 2022 19:35:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348900AbiDKRiD (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 11 Apr 2022 13:38:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348986AbiDKRhv (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 11 Apr 2022 13:37:51 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CB43D2E080;
        Mon, 11 Apr 2022 10:35:35 -0700 (PDT)
Received: from [192.168.254.32] (unknown [47.189.24.195])
        by linux.microsoft.com (Postfix) with ESMTPSA id A44D7209DD7D;
        Mon, 11 Apr 2022 10:35:34 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com A44D7209DD7D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1649698535;
        bh=rG2uaZyAEiyhXkFt52SkyeQGStuNJXxJtH9hUO9i+kA=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=AIn04MYTzNVllTU+rmjF8YLvOR/CmtHaTesOXIlZb8pTSC2pHpvygd4qqpul/h4un
         6VpXElMCG61TaXBBaCzPbpQ8ub9/ZtiD6752Jsxv7FbhDSedBYjnRUcerv9H8XlgAx
         PmS3DDEZrUSBgqG9dRIppJ9wRLZ7k0ijvQ1lYguU=
Message-ID: <209888b9-fa98-2012-9f4c-1e37fd3283cd@linux.microsoft.com>
Date:   Mon, 11 Apr 2022 12:35:33 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [RFC PATCH v1 0/9] arm64: livepatch: Use DWARF Call Frame
 Information for frame pointer validation
Content-Language: en-US
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     mark.rutland@arm.com, broonie@kernel.org, jpoimboe@redhat.com,
        ardb@kernel.org, nobuta.keiya@fujitsu.com,
        sjitindarsingh@gmail.com, catalin.marinas@arm.com, will@kernel.org,
        jmorris@namei.org, linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
References: <95691cae4f4504f33d0fc9075541b1e7deefe96f>
 <20220407202518.19780-1-madvenka@linux.microsoft.com>
 <YlAlK+94gBlVlv2J@hirez.programming.kicks-ass.net>
From:   "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
In-Reply-To: <YlAlK+94gBlVlv2J@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-21.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org



On 4/8/22 07:06, Peter Zijlstra wrote:
> On Thu, Apr 07, 2022 at 03:25:09PM -0500, madvenka@linux.microsoft.com wrote:
>> The solution
>> ============
>>
>> The goal here is to use the absolute minimum CFI needed to compute the FP at
>> every instruction address. The unwinder can compute the FP in each frame,
>> compare the actual FP with the computed one and validate the actual FP.
>>
>> Objtool is enhanced to parse the CFI, extract just the rules required,
>> encode them in compact data structures and create special sections for
>> the rules. The unwinder uses the special sections to find the rules for
>> a given instruction address and compute the FP.
>>
>> Objtool can be invoked as follows:
>>
>> 	objtool dwarf generate <object-file>
>>
>> The version of the DWARF standard supported in this work is version 4. The
>> official documentation for this version is here:
>>
>> 	https://dwarfstd.org/doc/DWARF4.pdf
>>
>> Section 6.4 contains the description of the CFI.
> 
> The problem is of course that DWARF is only available for compiler
> generated code and doesn't cover assembly code, of which is there is
> always lots.
> 

Yes. But assembly functions are of two types:

SYM_CODE_*() functions
SYM_FUNC_*() functions

SYM_CODE functions are, by definition, special functions that don't follow any ABI rules.
They don't set up a frame. Based on the opinion of ARM64 experts, these need to be
recognized by the unwinder and, if they are present in a stack trace, the stack trace
must be considered unreliable. I have, in fact, submitted a patch to implement that.

So, only SYM_FUNC*() functions are relevant for this part. I will look into these for arm64
and check if any of them can occur frequently in stack traces. If any of them is likely
to occur frequently in stack traces, I must address them. If there are only a few such
functions, unwind hints may be sufficient. I will get back to you on this.

> I suppose you can go add DWARF annotations to all the assembly, but IIRC
> those are pretty terrible. We were *REALLY* happy to delete all that
> nasty from the x86 code.
> 

DWARF annotations are a PITA to maintain. I will never recommend that!

> On top of that, AFAIK compilers don't generally consider DWARF
> generation to be a correctness issue. For them it's debug info and
> having it be correct is nice but not required. So using it as input for
> something that's required to be correct, seems unfortunate.

It is only debug info. But if that info can be verified, then it is usable for livepatch
purposes. I am thinking of implementing a verifier since DWARF reliability is a valid
concern. I will keep you posted.

Thanks!

Madhavan
