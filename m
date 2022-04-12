Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C4674FDB53
	for <lists+live-patching@lfdr.de>; Tue, 12 Apr 2022 12:56:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243499AbiDLKBa (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 12 Apr 2022 06:01:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1389342AbiDLJXl (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 12 Apr 2022 05:23:41 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4D1B541B4;
        Tue, 12 Apr 2022 01:32:29 -0700 (PDT)
Received: from dggpemm500023.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4KczRw0cnqzFpX4;
        Tue, 12 Apr 2022 16:30:04 +0800 (CST)
Received: from dggpemm500013.china.huawei.com (7.185.36.172) by
 dggpemm500023.china.huawei.com (7.185.36.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 12 Apr 2022 16:32:28 +0800
Received: from [127.0.0.1] (10.67.108.67) by dggpemm500013.china.huawei.com
 (7.185.36.172) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Tue, 12 Apr
 2022 16:32:27 +0800
Message-ID: <35c99466-9024-a7fd-9632-5d21b3e558f7@huawei.com>
Date:   Tue, 12 Apr 2022 16:32:22 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [RFC PATCH v1 0/9] arm64: livepatch: Use DWARF Call Frame
 Information for frame pointer validation
Content-Language: en-US
To:     "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
CC:     <mark.rutland@arm.com>, <broonie@kernel.org>, <ardb@kernel.org>,
        <nobuta.keiya@fujitsu.com>, <sjitindarsingh@gmail.com>,
        <catalin.marinas@arm.com>, <will@kernel.org>, <jmorris@namei.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <live-patching@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>
References: <95691cae4f4504f33d0fc9075541b1e7deefe96f>
 <20220407202518.19780-1-madvenka@linux.microsoft.com>
 <20220408002147.pk7clzruj6sawj7z@treble>
 <15a22f4b-f04a-15e1-8f54-5b3147d8df7d@linux.microsoft.com>
From:   Chen Zhongjin <chenzhongjin@huawei.com>
In-Reply-To: <15a22f4b-f04a-15e1-8f54-5b3147d8df7d@linux.microsoft.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.108.67]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpemm500013.china.huawei.com (7.185.36.172)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-5.3 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Hi Madhaven,

Sorry I sent the last email as HTML. This is a plain text resend.

On 2022/4/12 1:18, Madhavan T. Venkataraman wrote:

>> In a general sense, I've never looked at DWARF's reliability, even for
>> just normal C code.  It would be good to have some way of knowing that
>> DWARF looks mostly sane for both GCC and Clang.  For example, maybe
>> somehow cross-checking it with objtool's knowledge.  And then of course
>> we'd have to hope that it stays bug-free in future compilers.
>>
> 
> This is a valid point. So far, I find that gcc generates reliable DWARF information.
> But there are two bugs in what Clang generates. I have added workarounds in my
> parser to compensate.
> 
> So, I think a DWARF verifier is an option that architectures can use. At this point,
> I don't want to mandate a verifier on every architecture. But that is a discussion
> that we can have once I have a verifier ready.
>
I'm concerning that depending on compilers to generate correct 
information can become a trouble because we linux kernel side can rarely 
fix what compilers make. That's also why the gcc plugin idea was 
objected in the objtool migration.

If your parser can solve this it sounds more doable.

>> I'd also be somewhat concerned about assembly.  Since there's nothing
>> ensuring the unwind hints are valid, and will stay valid over time, I
>> wonder how likely it would be for that to break, and what the
>> implications would be.  Most likely I guess it would break silently, but
>> then get caught by the frame pointer cross-checking.  So a broken hint
>> might not get noticed for a long time, but at least it (hopefully)
>> wouldn't break reliable unwinding.
>>
> 
> Yes. That is my thinking as well. When the unwinder checks the actual FP with the
> computed FP, any mismatch will be treated as unreliable code for unwind. So,
> apart from some retries during the livepatch process, this is most probably not
> a problem.
> 
> Now,  I set a flag for an unwind hint so that the unwinder knows that it is
> processing an unwind hint. I could generate a warning if an unwind hint does not
> result in a reliable unwind of the frame. This would bring the broken hint
> to people's attention.
> 
> 
>> Also, inline asm can sometimes do stack hacks like
>> "push;do_something;pop" which isn't visible to the toolchain.  But
>> again, hopefully the frame pointer checking would fail and mark it
>> unreliable.
>>
>> So I do have some worries about DWARF, but the fact that it's getting
>> "fact checked" by frame pointers might be sufficient.
>>
> 
> Exactly.
> 
I'm wondering how much functions will give a unreliable result because 
any unreliable function shows in stack trace will cause livepatch 
fail/retry. IIUC all unmarked assembly functions will considered 
unreliable and cause problem. It can be a burden to mark all of them.

> - No software is bug free. So, even if static analysis is implemented for an architecture,
>    it would be good to have another method of verifying the unwind rules generated from
>    the static analysis. DWARF can provide that additional verification.
> 
I'm wondering how much functions will give a unreliable result because 
any unreliable function shows in stack trace will cause livepatch 
fail/retry. IIUC all unmarked assembly functions will considered 
unreliable and cause problem. It can be a burden to mark all of them.

> 
> So, it is just frame pointer validation for livepatch I am trying to look at.
> 
My support reason for FP with validation is that it provides a guarantee 
for FP unwinder. FP and ORC use absolute and relative for stack unwind 
to unwind stack respectively, however FP has been considered unreliable. 
Is there any feature depends on FP? If so it can be more persuasive.


Also this patch is much more completed than migration for objtool. It 
would be nice if this could be put into use quickly. The objtool-arm64 
is less than half done, but I'm going to relies as much as possible on 
current objtool components, so no more feasibility validation is required.

By the way, I was thinking about a corner case, because arm64 CALL 
instruction won't push LR onto stack atomically as x86. Before push LR, 
FP to save frame there still can be some instructions such as bti, 
paciasp. If an irq happens here, the stack frame is not constructed so 
the FP unwinder will omit this function and provides a wrong stack trace 
to livepatch.

It's just a guess and I have not built the test case. But I think it's a 
defect on arm64 that FP unwinder can't work properly on prologue and 
epilogue. Do you have any idea about this?

Thanks for your time,
Chen

