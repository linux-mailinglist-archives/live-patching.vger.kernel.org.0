Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F826501696
	for <lists+live-patching@lfdr.de>; Thu, 14 Apr 2022 17:50:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234985AbiDNPIC (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 14 Apr 2022 11:08:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349524AbiDNOUj (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 14 Apr 2022 10:20:39 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id EB4155F8F0;
        Thu, 14 Apr 2022 07:11:17 -0700 (PDT)
Received: from [192.168.254.32] (unknown [47.189.24.195])
        by linux.microsoft.com (Postfix) with ESMTPSA id 8676120C34F6;
        Thu, 14 Apr 2022 07:11:16 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 8676120C34F6
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1649945477;
        bh=CCivcobdjTSIqO/n6SrPCQb7F6TrngftOXYOVomxLcA=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=pC3wgC3+4kgZsZLu/RdVdTFtTyKFejRU6j7YbpASO52I1iedmlBrjkEVG9aa7uy/2
         mZP5pReBbAVE0VfmJIsMzg227QaQOcpR8LCYOG4WEdY5AnZxb3HklnKvA5rMUuH/ZY
         ZQjRBi5wjusZlpu6CkGMq0NCRVgvuEbgzds5bLAg=
Message-ID: <fb1667fd-58a3-d4b9-3943-ef7143d85756@linux.microsoft.com>
Date:   Thu, 14 Apr 2022 09:11:15 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [RFC PATCH v1 0/9] arm64: livepatch: Use DWARF Call Frame
 Information for frame pointer validation
Content-Language: en-US
To:     Josh Poimboeuf <jpoimboe@redhat.com>
Cc:     mark.rutland@arm.com, broonie@kernel.org, ardb@kernel.org,
        nobuta.keiya@fujitsu.com, sjitindarsingh@gmail.com,
        catalin.marinas@arm.com, will@kernel.org, jmorris@namei.org,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
References: <95691cae4f4504f33d0fc9075541b1e7deefe96f>
 <20220407202518.19780-1-madvenka@linux.microsoft.com>
 <20220408002147.pk7clzruj6sawj7z@treble>
From:   "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
In-Reply-To: <20220408002147.pk7clzruj6sawj7z@treble>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-22.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Hi Josh, Peter,

I have decided to accept your comment that using the compiler generated DWARF info
is probably not reliable. I can write a DWARF verifier. But I decided that if I can
write a DWARF verifier, I can use that same code to generate the same information as
DWARF CFI.

So, I am going to implement this in the traditional way as you wanted. Fortunately,
I only need to decode a small subset of the instruction formats (just the ones that
affect the SP and FP) and branch and return instructions to be able to compute the
SP and FP offsets at every instruction address. I only need a small part of the
static analysis code.

In other words, I am removing the crazy from my patch series. I am still retaining the
idea of dynamic FP validation rather than static validation. IMO, that will be able to
handle even non-ABI compliant functions and FP corruptions from buggy kernel functions.

Huawei has resubmitted the objtool patch set. When the full blown static analysis
is implemented by them and accepted by the community, my changes can be easily merged
with theirs. So, my solution is not a competing solution. In fact, it will provide an
additional level of robustness.

I will make these changes, test and send out version 2.

Thanks for your comments.

Madhavan

On 4/7/22 19:21, Josh Poimboeuf wrote:
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
> 
> Hi Madhaven,
> 
> This is quite interesting.  And it's exactly the kind of crazy idea I
> can appreciate ;-)
> 
> Some initial thoughts:
> 
> 
> 1)
> 
> I have some concerns about DWARF's reliability, especially considering
> a) inline asm, b) regular asm, and c) the kernel's tendency to push
> compilers to their limits.
> 
> BUT, supplementing the frame pointer unwinding with DWARF, rather than
> just relying on DWARF alone, does help a LOT.
> 
> I guess the hope is that cross-checking two "mostly reliable" things
> against each other (frame pointers and DWARF) will give a reliable
> result ;-)
> 
> In a general sense, I've never looked at DWARF's reliability, even for
> just normal C code.  It would be good to have some way of knowing that
> DWARF looks mostly sane for both GCC and Clang.  For example, maybe
> somehow cross-checking it with objtool's knowledge.  And then of course
> we'd have to hope that it stays bug-free in future compilers.
> 
> I'd also be somewhat concerned about assembly.  Since there's nothing
> ensuring the unwind hints are valid, and will stay valid over time, I
> wonder how likely it would be for that to break, and what the
> implications would be.  Most likely I guess it would break silently, but
> then get caught by the frame pointer cross-checking.  So a broken hint
> might not get noticed for a long time, but at least it (hopefully)
> wouldn't break reliable unwinding.
> 
> Also, inline asm can sometimes do stack hacks like
> "push;do_something;pop" which isn't visible to the toolchain.  But
> again, hopefully the frame pointer checking would fail and mark it
> unreliable.
> 
> So I do have some worries about DWARF, but the fact that it's getting
> "fact checked" by frame pointers might be sufficient.
> 
> 
> 2)
> 
> If I understand correctly, objtool is converting parts of DWARF to a new
> format which can then be read by the kernel.  In that case, please don't
> call it DWARF as that will cause a lot of confusion.
> 
> There are actually several similarities between your new format and ORC,
> which is also an objtool-created DWARF alternative.  It would be
> interesting to see if they could be combined somehow.
> 
> 
> 3)
> 
> Objtool has become an integral part of x86-64, due to security and
> performance features and toolchain workarounds.
> 
> Not *all* of its features require the full "branch validation" which
> follows all code paths -- and was the hardest part to get right -- but
> several features *do* need that: stack validation, ORC, uaccess
> validation, noinstr validation.
> 
> Objtool has been picking up a lot of steam (and features) lately, with
> more features currently in active development.  And lately there have
> been renewed patches for porting it to powerpc and arm64 (and rumors of
> s390).
> 
> If arm64 ever wants one of those features -- particularly a "branch
> validation" based feature -- I think it would make more sense to just do
> the stack validation in objtool, rather than the DWARF supplementation
> approach.
> 
> Just to give an idea of what objtool already supports and how useful it
> has become for x86, here's an excerpt from some documentation I've been
> working on, since I'm in the middle of rewriting the interface to make
> it more modular.  This is a list of all its current features:
> 
> 
> Features
> --------
> 
> Objtool has the following features:
> 
> 
> - Stack unwinding metadata validation -- useful for helping to ensure
>   stack traces are reliable for live patching
> 
> - ORC unwinder metadata generation -- a faster and more precise
>   alternative to frame pointer based unwinding
> 
> - Retpoline validation -- ensures that all indirect calls go through
>   retpoline thunks, for Spectre v2 mitigations
> 
> - Retpoline call site annotation -- annotates all retpoline thunk call
>   sites, enabling the kernel to patch them inline, to prevent "thunk
>   funneling" for both security and performance reasons
> 
> - Non-instrumentation validation -- validates non-instrumentable
>   ("noinstr") code rules, preventing unexpected instrumentation in
>   low-level C entry code
> 
> - Static call annotation -- annotates static call sites, enabling the
>   kernel to implement inline static calls, a faster alternative to some
>   indirect branches
> 
> - Uaccess validation -- validates uaccess rules for a proper safe
>   implementation of Supervisor Mode Access Protection (SMAP)
> 
> - Straight Line Speculation validation -- validates certain SLS
>   mitigations
> 
> - Indirect Branch Tracking validation -- validates Intel CET IBT rules
>   to ensure that all functions referenced by function pointers have
>   corresponding ENDBR instructions
> 
> - Indirect Branch Tracking annotation -- annotates unused ENDBR
>   instruction sites, enabling the kernel to "seal" them (replace them
>   with NOPs) to further harden IBT
> 
> - Function entry annotation -- annotates function entries, enabling
>   kernel function tracing
> 
> - Other toolchain hacks which will go unmentioned at this time...
> 
