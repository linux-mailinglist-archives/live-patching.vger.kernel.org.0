Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A8C9541193
	for <lists+live-patching@lfdr.de>; Tue,  7 Jun 2022 21:39:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356437AbiFGTi7 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 7 Jun 2022 15:38:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356420AbiFGTiY (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 7 Jun 2022 15:38:24 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4BC2942ED8;
        Tue,  7 Jun 2022 11:13:56 -0700 (PDT)
Received: from [192.168.254.32] (unknown [47.189.24.195])
        by linux.microsoft.com (Postfix) with ESMTPSA id 1243420BE631;
        Tue,  7 Jun 2022 11:13:55 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 1243420BE631
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1654625635;
        bh=Vs6hUjZ0i9nSyYyUH4wO91dnSp1jpNStrtYIBeo1B3o=;
        h=Date:Subject:From:To:Cc:References:In-Reply-To:From;
        b=bGMUoKHuRZMan7PbBtthghVWnCnaTqSkWrHZeOOBfjKbNQeWypm7pdbs6Gp7bCA7f
         +wTfoF66kdmy+w2WR9iy618cIhz8UxVPHpjtUTCuYFP4Biiddm5JmdklTxPQaQlW2D
         5On5KGuSOH+sTSSoTqX7M9iGbVje4is7p+cGo/Ls=
Message-ID: <dbee3bcd-266c-9ba3-d405-58010deb244b@linux.microsoft.com>
Date:   Tue, 7 Jun 2022 13:13:54 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [RFC PATCH v2 09/20] objtool: arm64: Implement command to invoke
 the decoder
Content-Language: en-US
From:   "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Mark Brown <broonie@kernel.org>, jpoimboe@redhat.com,
        chenzhongjin@huawei.com, mark.rutland@arm.com,
        nobuta.keiya@fujitsu.com, sjitindarsingh@gmail.com,
        catalin.marinas@arm.com, will@kernel.org,
        jamorris@linux.microsoft.com, linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
References: <e81e773678f88f7c2ff7480e2eb096973ec198db>
 <20220524001637.1707472-1-madvenka@linux.microsoft.com>
 <20220524001637.1707472-10-madvenka@linux.microsoft.com>
 <YoznLR30T+03Ea08@sirena.org.uk>
 <ff58b576-efee-276a-bfb3-11f5d258d580@linux.microsoft.com>
 <YpR3naaNCNG9ZJGC@worktop.programming.kicks-ass.net>
 <38546223-7585-bfad-b553-9739d31d7fbf@linux.microsoft.com>
In-Reply-To: <38546223-7585-bfad-b553-9739d31d7fbf@linux.microsoft.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-21.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org



On 6/1/22 17:45, Madhavan T. Venkataraman wrote:
> 
> 
> On 5/30/22 02:51, Peter Zijlstra wrote:
>> On Sun, May 29, 2022 at 09:49:44AM -0500, Madhavan T. Venkataraman wrote:
>>>
>>>
>>> On 5/24/22 09:09, Mark Brown wrote:
>>>> On Mon, May 23, 2022 at 07:16:26PM -0500, madvenka@linux.microsoft.com wrote:
>>>>> From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
>>>>>
>>>>> Implement a built-in command called cmd_fpv() that can be invoked as
>>>>> follows:
>>>>>
>>>>> 	objtool fpv generate file.o
>>>>>
>>>>> The built-in command invokes decode_instructions() to walk each function
>>>>> and decode the instructions of the function.
>>>>
>>>> In commit b51277eb9775ce91 ("objtool: Ditch subcommands") Josh removed
>>>> subcommands so this interface is going to need a rethink.
>>>
>>> Thanks for mentioning this. I will sync my patchset to the latest and send out version 3.
>>
>> Before you do; why are you duplicating lots of validate_branch() ? Why
>> can't you use the regular code to generate ORC data?
>>
>> I'm really not happy about all this.
> 
> Hi Peter,
> 
> I am preparing a detailed response to this explaining why I have not used validate_branch().
> The short answer is that no validation is required for my approach. But I will send my detailed
> response shortly.
> 
> Thanks.
> 
> Madhavan

Sorry for the delay in responding to your comment. I had to make changes
to address it and complete testing.

I will address your comment in version 3. There are two parts to your comment:

- Why is validate_branch() not being used in Dynamic FP Validation?

	I will use it in version 3. See below.

- Why is the current code not being used to compute ORC?

	There are some differences in the CFI code between X86 and ARM64.
	So, I have defined handle_insn_ops() separately for the two in v3.

What I am doing in v3
=====================

I have discarded my own function (walk_code()) to walk instructions. Instead,
I have used validate_branch() per your comment.

However, my approach requires no validation. More on this below.

So, what I have done is to move all of the validation checks and actions into
their own functions. I define the functions separately for Static Stack
Validation (in check.c) and Dynamic Frame Pointer Validation (in fpv.c). The
two files are mutually exclusive.

The functions in fpv.c contain their own checks and actions.

	validate_insn_initial()		Initial checks.
	validate_insn_cfi()		CFI-related checks.
	validate_insn_alt()		Alternate instructions checks.
	validate_insn_return()		Return instruction checks.
	validate_insn_call()		Call/Call dynamic instruction checks.
	validate_insn_jump()		Jump instruction checks.
	validate_insn_jump_dynamic()	Jump Dynamic instruction checks.
	validate_insn_rest()		Checks for miscellaneous instructions.
	validate_ibt_insn()		IBT instruction checks.
	handle_insn_ops()		Update CFI from stack ops generated by
					the decoder.

validate_branch() looks like this now:

int validate_branch(struct objtool_file *file, struct symbol *func,
		    struct instruction *insn, struct insn_state state)
{
	struct instruction *next_insn, *prev_insn = NULL;
	struct section *sec;
	u8 visited;
	int ret;

	sec = insn->sec;

	while (1) {
		next_insn = next_insn_to_validate(file, insn);

		if (validate_insn_initial(file, func, insn, &ret))
			return ret;

		if (validate_insn_cfi(prev_insn, insn, &state, &visited, &ret))
			return ret;

		if (state.noinstr)
			state.instr += insn->instr;

		if (validate_insn_alt(file, func, insn, &state, &ret))
			return ret;

		if (handle_insn_ops(insn, next_insn, &state))
			return 1;

		switch (insn->type) {

		case INSN_RETURN:
			validate_insn_return(func, insn,
					     next_insn, &state, &ret);
			return ret;

		case INSN_CALL:
		case INSN_CALL_DYNAMIC:
			if (validate_insn_call(file, func, insn, &state, &ret))
				return ret;
			break;

		case INSN_JUMP_CONDITIONAL:
		case INSN_JUMP_UNCONDITIONAL:
			if (validate_insn_jump(file, func, insn, &state, &ret))
				return ret;
			break;

		case INSN_JUMP_DYNAMIC:
		case INSN_JUMP_DYNAMIC_CONDITIONAL:
			if (validate_insn_jump_dynamic(file, insn, next_insn,
						       &state, &ret)) {
				return ret;
			}
			break;

		default:
			if (validate_insn_rest(func, insn, next_insn,
					       &state, &ret)) {
				return ret;
			}
			break;
		}

		if (ibt)
			validate_ibt_insn(file, insn);

		if (insn->dead_end)
			return 0;

		if (!next_insn) {
			if (state.cfi.cfa.base == CFI_UNDEFINED)
				return 0;
			WARN("%s: unexpected end of section", sec->name);
			return 1;
		}

		prev_insn = insn;
		insn = next_insn;
	}

	return 0;
}

Why no validation?
==================

There are two approaches for reliable stacktrace.

1. Static Stack Validation (the current approach).

   Analyze the code statically and perform checks for ABI compliance and valid
   stack operations. If any warnings or errors are encountered, "fix" the
   kernel and/or the toolchain so the generated code conforms to Objtool's
   expectations.

2. Dynamic Frame Pointer Validation.

   Don't perform any validation of kernel code. Simply compute the SP and FP
   offsets at each instruction address based on the actual code. During unwind,
   compute a frame pointer from the offsets at each frame and validate the
   actual frame pointer with it. If an FP cannot be computed or the computed
   FP does not match the actual FP, consider the frame unreliable for unwind.

   Since the unwinder can clearly tell whether a frame is reliable or not,
   reliable stacktrace can be provided.

I am doing (2) in my patch series.

Different cases
===============

C Functions
-----------

I find that the compiler generates proper FP prolog and epilog for C functions.
The only exceptions I found are functions that have multiple code paths sharing
some instructions with differing CFIs. See CFI mismatch below. This mismatch
happens only for a very small percentage of the functions.

	Buggy code generated by compiler
	--------------------------------

	Even assuming that the compiler can sometimes generate code that does
	not follow ABI rules, it is still not a problem as the unwinder can
	do an FP match and tell whether some code is reliable for unwind or not.

Assembly Functions
------------------

There are two cases:

	SYM_CODE functions
	------------------

	Functions defined using the SYM_CODE_*() macros. 

	AFAICT, Objtool does not process these. These are low-level functions
	that don't follow any ABI rules. The ORC entries for these would be
	undefined. So, the unwinder will rightly consider them unreliable
	for unwind.

	SYM_FUNC functions
	------------------

	Functions defined using the SYM_FUNC_*() macros.

	These are supposed to have proper FP prologs and epilogs.

	At the moment, they don't for ARM64. The unwinder will consider these
	unreliable for unwind at the moment.

	That said, I am working on a separate patch series to add the prologs
	and epilogs to these functions (except in cases where functionality
	or performance would be affected). This is not required to support
	reliable stack trace. This is only to reduce potential retries during
	the livepatch process.

Functions without a proper FP prolog/epilog
-------------------------------------------

For leaf functions, the compiler may not generate FP prologs/epilogs for
performance reasons. In Dynamic FP Validation, the unwinder will recognize
these to be unreliable for unwind.

Assembly functions that don't have a proper FP prolog/epilog are treated like
leaf functions.

CFI mismatch
------------

This is based on actual code on ARM64.

Let us say there are two code paths in a function. The two code paths share
some instructions. If the SP and FP offsets are different in the two code paths,
the shared instructions will have a CFI mismatch. But this is not invalid or
buggy code. It is just a case that Objtool cannot handle because only one CFI
is associated with an instruction in Objtool.

In my approach, one CFI will be recorded. The other will be ignored. The
computed FP will match the actual FP in one code path. It will not match
in the other one. The unwinder will consider the former reliable and the
latter unreliable.

This happens only for a very small number of functions in the entire kernel.

That said, I am investigating the possibility of storing both in ORC entries
in a manner similar to alternate instructions. If this is feasible, then the
unwinder can do an FP match using any of these entries.

Thanks!

Madhavan
