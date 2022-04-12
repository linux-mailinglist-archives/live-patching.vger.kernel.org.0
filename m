Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 297764FE6CF
	for <lists+live-patching@lfdr.de>; Tue, 12 Apr 2022 19:27:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358103AbiDLR3Y (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 12 Apr 2022 13:29:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358093AbiDLR3W (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 12 Apr 2022 13:29:22 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id F360F532FF;
        Tue, 12 Apr 2022 10:27:03 -0700 (PDT)
Received: from [192.168.254.32] (unknown [47.189.24.195])
        by linux.microsoft.com (Postfix) with ESMTPSA id C13AC20A6939;
        Tue, 12 Apr 2022 10:27:02 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com C13AC20A6939
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1649784423;
        bh=tNQTQgW7F7YhR7TPnyCz6wHTQsZZS/7RFpIuroZcbUU=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=FQt4oPQbZs2YbA6H6finjiYQYzIj+0jes6+Wh0g0RJu3KgJC1pCjeZl0lWVVATdbb
         czIhP09ulIXheKhT1mqsswthBaukYUbnoGb/6NEIe6P7d4+FyQUMShhUQttOhUc1P+
         uiu2kxaZ/ZtMTx6tYxLEXhboIDvBimsaGwYoWrfA=
Message-ID: <b17e452a-e998-ac69-a129-5a184cd19c29@linux.microsoft.com>
Date:   Tue, 12 Apr 2022 12:27:01 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [RFC PATCH v1 0/9] arm64: livepatch: Use DWARF Call Frame
 Information for frame pointer validation
Content-Language: en-US
To:     Chen Zhongjin <chenzhongjin@huawei.com>
Cc:     mark.rutland@arm.com, broonie@kernel.org, ardb@kernel.org,
        nobuta.keiya@fujitsu.com, sjitindarsingh@gmail.com,
        catalin.marinas@arm.com, will@kernel.org, jmorris@namei.org,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        Josh Poimboeuf <jpoimboe@redhat.com>
References: <95691cae4f4504f33d0fc9075541b1e7deefe96f>
 <20220407202518.19780-1-madvenka@linux.microsoft.com>
 <20220408002147.pk7clzruj6sawj7z@treble>
 <15a22f4b-f04a-15e1-8f54-5b3147d8df7d@linux.microsoft.com>
 <844b3ede-eddb-cbe6-80e0-3529e2da2eb6@huawei.com>
From:   "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
In-Reply-To: <844b3ede-eddb-cbe6-80e0-3529e2da2eb6@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-20.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org



On 4/12/22 02:30, Chen Zhongjin wrote:
> Hi Madhaven,
> 
> On 2022/4/12 1:18, Madhavan T. Venkataraman wrote:
>>
>> This is a valid point. So far, I find that gcc generates reliable DWARF information.
>> But there are two bugs in what Clang generates. I have added workarounds in my
>> parser to compensate.
>>
>> So, I think a DWARF verifier is an option that architectures can use. At this point,
>> I don't want to mandate a verifier on every architecture. But that is a discussion
>> that we can have once I have a verifier ready.
> I'm concerning that depending on compilers to generate correct information can become
> a trouble because we linux kernel side can rarely fix what compilers make. That's also why
> the gcc plugin idea was objected in the objtool migration.
> 
> If your parser can solve this it sounds more doable.
> 

So far, I find that gcc generates reliable DWARF information. Clang did have two bugs for
which the parser compensates.

So, what is needed is a DWARF verifier which can find buggy DWARF information. I am working on
it.

Having said that,  I think the DWARF information for the stack and frame pointer is a *lot*
simpler than the other debug stuff. So, there may be a couple of existing bugs that need to be
discovered and fixed. But I think the likelihood of bugs appearing in this area in the future is
low but it can happen. I agree that there needs to be a way to discover and flag the bugs
when they do appear.

But compiler bugs can also affect objtool and cause problems in it. If I am not mistaken,
they ran into this multiple times on the X86 side and had to get fixes done. Josh knows better.
Compiler bugs and optimizations have always been problematic from this perspective and they
will potentially continue to be.

>>
>> Yes. That is my thinking as well. When the unwinder checks the actual FP with the
>> computed FP, any mismatch will be treated as unreliable code for unwind. So,
>> apart from some retries during the livepatch process, this is most probably not
>> a problem.
>>
>> Now,  I set a flag for an unwind hint so that the unwinder knows that it is
>> processing an unwind hint. I could generate a warning if an unwind hint does not
>> result in a reliable unwind of the frame. This would bring the broken hint
>> to people's attention.
>>
>>
>> Also, inline asm can sometimes do stack hacks like
>> "push;do_something;pop" which isn't visible to the toolchain.  But
>> again, hopefully the frame pointer checking would fail and mark it
>> unreliable.
>>
> I'm wondering how much functions will give a unreliable result because any unreliable
> function shows in stack trace will cause livepatch fail/retry. IIUC all unmarked assembly
> functions will considered unreliable and cause problem. It can be a burden to mark all
> of them.

It is not a burden to mark all of them. For instance, I have submitted a patch where I mark
all the SYM_CODE*() functions by overriding the SYM_CODE_START()/END() macros in arm64. So,
the changes are very small and self-contained.

A good part of the assembly functions are defined with SYM_CODE_*(). These, by definition,
are low-level functions that do not follow ABI rules. IIRC, Objtool does not perform static
analysis on these today. These need to be recognized by the unwinder in the kernel and handled.
Josh, please correct me if I am wrong. So, this is a problem even if we had static analysis
in Objtool for arm64.

As for functions defined with SYM_FUNC_*(), they are supposed to have proper frame setup and
teardown. But most of them do not appear to have a proper frame pointer prolog and epilog today
in arm64. Some of these will probably never have an FP prolog or epilog because they are high
performance functions or specialized functions and the extra overhead may be unacceptable. Some of
the SYM_FUNC*() functions are leaf functions that don't need an FP prolog or epilog.

With static analysis, Objtool will flag all such functions. Either a proper FP prolog and epilog
have to be introduced in the code or the functions need to be flagged as unreliable from an unwind
perspective. If any of these functions occurs frequently in stack traces, then, either a proper
FP prolog and epilog have to be introduced in the function code. Or, unwind hints have to be placed
at strategic points. In either case, there is a maintenance burden although developers may prefer
one over the other on a case-by-case basis.

The DWARF situation is the same. For the frequently occurring assembly functions, unwind hints
need to be defined. Currently, I have undertaken to study the SYM_FUNC*() functions in arm64
to see if I can determine which ones belong to this category. Also, I am going to be doing targeted
livepatch testing to see if any of these functions will cause many retries during the livepatch
process. If they don't, then this is not a problem.


>> - No software is bug free. So, even if static analysis is implemented for an architecture,
>>   it would be good to have another method of verifying the unwind rules generated from
>>   the static analysis. DWARF can provide that additional verification.
> To me verifying ORC with DWARF a little odd, cuz they are running with different unwind
> mechanism. For normal scenario which calling convention is obeyed, ORC can give a
> promised reliable stack trace, while when it easily involve bug in assembly codes,
> DWARF also can't work.
> 

I am not sure I follow. With both DWARF and ORC, stack pointer and frame pointer offsets are recorded
for every instruction address. These offsets have to be the same regardless of which one you use.

The only difference is that for an assembly function that has a proper FP prolog and epilog, Objtool
static analysis is able to generate those offsets. With DWARF, the compiler does not generate any
offsets for assembly functions. I have to rely on unwind hints. BTW, I only need to do this for functions
that occur frequently in stack traces.


> My support for FP with validation is that it provides a guarantee for FP unwinder. FP and ORC
> use absolute and relative for stack unwind to unwind stack respectively, however FP has been
> considered unreliable. Is there any feature depends on FP? If so it can be more persuasive.
> 

Yes. Static analysis makes sure that functions are following ABI rules. So, it provides a static
guarantee. And that is great.

However, with DWARF, even if some functions don't follow ABI rules, a reliable unwinder can still
be provided as long as the DWARF information generated by the compiler is correct. For instance,
let us say that the compiler generates code for a function with a call to another function before
the FP has been setup properly. If the DWARF information is correctly generated, the unwinder can
see that a stack trace involving the called function is unreliable.

Also, hypothetically, if a buggy kernel function corrupts the frame pointer or the stack
pointer, dynamic validation can catch it.

> 
> Also this patch is much more completed than migration for objtool. It would be
> nice if this could be put into use quickly. The objtool-arm64 is less than half done, but I'm going
> to relies as much as possible on current objtool components, so no more feasibility validation
> is required.
> 

The approach in your patch series is certainly feasible. I don't deny that at all. And, believe me,
I would like the community to take interest in it and review it. If I get a chance, I will also
participate in that review.

As I mentioned in a previous email, my attempt is to come up with a largely architecture independent
solution to the FP validation problem with a quicker time to market. That is all.

> By the way, I was thinking about a corner case, because arm64 CALL instruction won't push LR
> onto stack atomically as x86. Before push LR, FP to save frame there still can be some instructions
> such as bti, paciasp. If an irq happens here, the stack frame is not constructed
> so the FP unwinder will omit this function and provides a wrong stack trace to livepatch.
> 
> 

With DWARF, the unwinder will see that there are no DWARF rules associated with those PCs that occur
before the FP is completely setup. It will mark the stack trace as unreliable. So, these cases are
already handled as I have explained in my cover letter.

> It's just a guess and I have not built the test case. But I think it's a defect on arm64 that FP
> unwinder can't work properly on prologue and epilogue. Do you have any idea about this?
> 

There is no defect. The frame pointer prolog can have multiple instructions before the frame is set up.
Any interrupt or exception happening on those instructions will have an unreliable stack trace by
definition. A reliable unwinder must be able to recognize that case and mark the stack trace as unreliable.
That is all.

Thanks for your comments.

Madhavan
