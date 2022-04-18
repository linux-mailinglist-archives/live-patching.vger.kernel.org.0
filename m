Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21A78505DFA
	for <lists+live-patching@lfdr.de>; Mon, 18 Apr 2022 20:38:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347400AbiDRSlf (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 18 Apr 2022 14:41:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347396AbiDRSlc (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 18 Apr 2022 14:41:32 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 10E552BB17;
        Mon, 18 Apr 2022 11:38:53 -0700 (PDT)
Received: from [192.168.254.32] (unknown [47.189.24.195])
        by linux.microsoft.com (Postfix) with ESMTPSA id D817320C3609;
        Mon, 18 Apr 2022 11:38:51 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com D817320C3609
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1650307132;
        bh=H8MyfPervZyuNt3r3vstdEuHzcoj4KqWTgx18POqIdA=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=VCRFtQ/Oere8emSN1kRUq5qJ/USQF9Y3CrlpBuBMAXTs9hWhhhcL4s2wFZtCIi4Cu
         1KssUGysj8cYkXnJARC05+b8ief9dY6f3mCjxYs+8AAG1baC+E0OaTrdtzlehbCxfZ
         VA3jd3RotO1haVys02m+8VSWn33q4rM+ThZc1y24=
Message-ID: <e787031d-81fd-b1bc-4619-e8236a938d5c@linux.microsoft.com>
Date:   Mon, 18 Apr 2022 13:38:51 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [RFC PATCH v1 0/9] arm64: livepatch: Use DWARF Call Frame
 Information for frame pointer validation
Content-Language: en-US
To:     Josh Poimboeuf <jpoimboe@redhat.com>,
        Chen Zhongjin <chenzhongjin@huawei.com>
Cc:     mark.rutland@arm.com, broonie@kernel.org, ardb@kernel.org,
        nobuta.keiya@fujitsu.com, sjitindarsingh@gmail.com,
        catalin.marinas@arm.com, will@kernel.org, jmorris@namei.org,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
References: <95691cae4f4504f33d0fc9075541b1e7deefe96f>
 <20220407202518.19780-1-madvenka@linux.microsoft.com>
 <20220408002147.pk7clzruj6sawj7z@treble>
 <15a22f4b-f04a-15e1-8f54-5b3147d8df7d@linux.microsoft.com>
 <35c99466-9024-a7fd-9632-5d21b3e558f7@huawei.com>
 <20220416005609.3znhltjlhpg475ff@treble>
 <0abfa1af-81ec-9048-6f95-cf5dda295139@huawei.com>
 <20220418161145.hj3ahxqjdgqd3qn2@treble>
From:   "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
In-Reply-To: <20220418161145.hj3ahxqjdgqd3qn2@treble>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-23.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org



On 4/18/22 11:11, Josh Poimboeuf wrote:
> On Mon, Apr 18, 2022 at 08:28:33PM +0800, Chen Zhongjin wrote:
>> Hi Josh,
>>
>> IIUC, ORC on x86 can make reliable stack unwind for this scenario
>> because objtool validates BP state.
>>
>> I'm thinking that on arm64 there's no guarantee that LR will be pushed
>> onto stack. When we meet similar scenario on arm64, we should recover
>> (LR, FP) on pt_regs and continue to unwind the stack. And this is
>> reliable only after we validate (LR, FP).
>>
>> So should we track LR on arm64 additionally as track BP on x86? Or can
>> we just treat (LR, FP) as a pair? because as I know they are always set
>> up together.
> 
> Does the arm64 unwinder have a way to detect kernel pt_regs on the
> stack?  If so, the simplest solution is to mark all stacks with kernel
> regs as unreliable.  That's what the x86 FP unwinder does.
> 

AFAICT, only the task pt_regs can be detected. For detecting the other pt_regs,
we would have to set a bit in the FP. IIRC, I had a proposal where I set the LSB in
the FP stored on the stack. The arm64 folks did not like that approach as it
would be indistinguishable from a corrupted FP, however unlikely the corruption
may be.

Unwind hints can be used for these cases to unwind reliably through them. That is
probably the current thinking. Mark Rutland can confirm.

Madhavan
