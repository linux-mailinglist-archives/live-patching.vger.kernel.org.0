Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B10244FC30D
	for <lists+live-patching@lfdr.de>; Mon, 11 Apr 2022 19:18:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240748AbiDKRUb (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 11 Apr 2022 13:20:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236896AbiDKRUa (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 11 Apr 2022 13:20:30 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 36CDA140CC;
        Mon, 11 Apr 2022 10:18:15 -0700 (PDT)
Received: from [192.168.254.32] (unknown [47.189.24.195])
        by linux.microsoft.com (Postfix) with ESMTPSA id 2D60C2058429;
        Mon, 11 Apr 2022 10:18:14 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 2D60C2058429
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1649697494;
        bh=SRABqxxMrPUtYUfC//emiCJG95l/1g2I/XdMEDuiPFA=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=gI37Vw71esQb4U4C9cq+pdD9SzSoINM+NvqWqGhNJtwvR7qVzB9mKV1RWcfpCMipd
         YZ+yIYUlUYKZc+ImazpQo8fNBBB3dzrcX8jLT0OO1DB4qciJkQHu8Y3k+TRB3/pjLL
         vzjdtj5ZrCNYNVuSp3k0Pl32RnS1q3u0x82YPEno=
Message-ID: <15a22f4b-f04a-15e1-8f54-5b3147d8df7d@linux.microsoft.com>
Date:   Mon, 11 Apr 2022 12:18:13 -0500
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

Hi Josh,

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

A little crazy is a good thing sometimes.

> Some initial thoughts:
> 
> 
> 1)
> 
> I have some concerns about DWARF's reliability, especially considering
> a) inline asm, b) regular asm, and c) the kernel's tendency to push
> compilers to their limits.
> 

I am thinking of implementing a DWARF verifier to make sure that the DWARF information
in .debug_frame is correct. I am still in the process of designing this. I will keep
you posted on that. This should address (a) and (c).

As for (b), the compiler does not generate any DWARF rules for ASM code. DWARF
annotations are a PITA to maintain. So, in my current design regular ASM functions are 
considered unreliable from an unwind perspective except the places that have unwind
hints. Unwind hints are only needed for places that tend to occur frequently in stack
traces. So, it would be just a handful of unwind hints which can be maintained.

As you know, ASM functions come in two flavors - SYM_CODE() functions and SYM_FUNC()
functions. SYM_CODE functions are, by definition, unreliable from an unwind perspective
because they don't follow ABI rules and they don't set up any frame pointer. In my
reliable stack trace patch series, I have a patch based on the opinion of the reviewers
to mark these functions so the unwinder can recognize them and declare the stack trace
unreliable. So, the only ASM functions that matter in (b) are the SYM_FUNC functions.
For now, I have considered them to be unreliable. But I will analyze those functions to
see if any of them can occur frequently in stack traces. If some of these functions
can occur frequently in stack traces, I need to address them. I will see if unwind hints
are a good fit. I will get back to you on this.

> BUT, supplementing the frame pointer unwinding with DWARF, rather than
> just relying on DWARF alone, does help a LOT.
> 

Yes.

> I guess the hope is that cross-checking two "mostly reliable" things
> against each other (frame pointers and DWARF) will give a reliable
> result ;-)
> 

Yes!

> In a general sense, I've never looked at DWARF's reliability, even for
> just normal C code.  It would be good to have some way of knowing that
> DWARF looks mostly sane for both GCC and Clang.  For example, maybe
> somehow cross-checking it with objtool's knowledge.  And then of course
> we'd have to hope that it stays bug-free in future compilers.
> 

This is a valid point. So far, I find that gcc generates reliable DWARF information.
But there are two bugs in what Clang generates. I have added workarounds in my
parser to compensate.

So, I think a DWARF verifier is an option that architectures can use. At this point,
I don't want to mandate a verifier on every architecture. But that is a discussion
that we can have once I have a verifier ready.

> I'd also be somewhat concerned about assembly.  Since there's nothing
> ensuring the unwind hints are valid, and will stay valid over time, I
> wonder how likely it would be for that to break, and what the
> implications would be.  Most likely I guess it would break silently, but
> then get caught by the frame pointer cross-checking.  So a broken hint
> might not get noticed for a long time, but at least it (hopefully)
> wouldn't break reliable unwinding.
> 

Yes. That is my thinking as well. When the unwinder checks the actual FP with the
computed FP, any mismatch will be treated as unreliable code for unwind. So,
apart from some retries during the livepatch process, this is most probably not
a problem.

Now,  I set a flag for an unwind hint so that the unwinder knows that it is
processing an unwind hint. I could generate a warning if an unwind hint does not
result in a reliable unwind of the frame. This would bring the broken hint
to people's attention.


> Also, inline asm can sometimes do stack hacks like
> "push;do_something;pop" which isn't visible to the toolchain.  But
> again, hopefully the frame pointer checking would fail and mark it
> unreliable.
> 
> So I do have some worries about DWARF, but the fact that it's getting
> "fact checked" by frame pointers might be sufficient.
> 

Exactly.

> 
> 2)
> 
> If I understand correctly, objtool is converting parts of DWARF to a new
> format which can then be read by the kernel.  In that case, please don't
> call it DWARF as that will cause a lot of confusion.
> 

OK. I will rename it.

> There are actually several similarities between your new format and ORC,
> which is also an objtool-created DWARF alternative.  It would be
> interesting to see if they could be combined somehow.
> 

I will certainly look into it. So, if I decide to merge the two, I might want
to make a minor change to the ORC structure. Would that be OK with you?

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

First off, I think that objtool does a great job for X64. I only want to implement
frame pointer validation in a different way. All the other features of objtool
(listed below) are great. I have admired the amount of work you guys have put into
the X64 part.

These are the reasons why I tried the DWARF based method:

- My implementation is largely architecture independent. There are a couple of
  minor pieces that are architecture-specific, but they are minor in nature.
  So, if an architecture wanted to support the livepatch feature but did not
  want to do a heavy weight objtool implementation, then it has an option.
  There has been some debate about whether static analysis should be mandated
  for livepatch. My patch series is an attempt to provide an option.

- To get an objtool static analysis implementation working for an architecture
  as reliably as X64 and getting it reviewed and upstreamed can take years. It took
  years for X64, am I right? I mean, it has been quite a while since the original
  patch series for arm64 was posted. There have been only one or two minor comments
  so far. I am sure arm64 linux users would very much want to have livepatch available
  ASAP to be able to install security fixes without downtime. This is an immediate need.

- No software is bug free. So, even if static analysis is implemented for an architecture,
  it would be good to have another method of verifying the unwind rules generated from
  the static analysis. DWARF can provide that additional verification.

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

I completely agree.

So, it is just frame pointer validation for livepatch I am trying to look at.

Thanks!

Madhavan
