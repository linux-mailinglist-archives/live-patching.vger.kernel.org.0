Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CADA55B044
	for <lists+live-patching@lfdr.de>; Sun, 26 Jun 2022 10:32:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234148AbiFZIc1 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Sun, 26 Jun 2022 04:32:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234140AbiFZIc1 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Sun, 26 Jun 2022 04:32:27 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 40D0AFD07;
        Sun, 26 Jun 2022 01:32:25 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2E4F9D6E;
        Sun, 26 Jun 2022 01:32:25 -0700 (PDT)
Received: from FVFF77S0Q05N (unknown [10.57.71.61])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 249333F792;
        Sun, 26 Jun 2022 01:32:23 -0700 (PDT)
Date:   Sun, 26 Jun 2022 09:32:19 +0100
From:   Mark Rutland <mark.rutland@arm.com>
To:     madvenka@linux.microsoft.com
Cc:     broonie@kernel.org, jpoimboe@redhat.com, ardb@kernel.org,
        nobuta.keiya@fujitsu.com, sjitindarsingh@gmail.com,
        catalin.marinas@arm.com, will@kernel.org,
        jamorris@linux.microsoft.com, linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v15 4/6] arm64: Introduce stack trace reliability checks
 in the unwinder
Message-ID: <YrgZkz7BA1U09gUC@FVFF77S0Q05N>
References: <ff68fb850d42e1adaa6a0a6c9c258acabb898b24>
 <20220617210717.27126-1-madvenka@linux.microsoft.com>
 <20220617210717.27126-5-madvenka@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220617210717.27126-5-madvenka@linux.microsoft.com>
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_FILL_THIS_FORM_SHORT,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Fri, Jun 17, 2022 at 04:07:15PM -0500, madvenka@linux.microsoft.com wrote:
> From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
> 
> There are some kernel features and conditions that make a stack trace
> unreliable. Callers may require the unwinder to detect these cases.
> E.g., livepatch.
> 
> Introduce a new function called unwind_check_reliability() that will
> detect these cases and set a flag in the stack frame. Call
> unwind_check_reliability() for every frame in unwind().
> 
> Introduce the first reliability check in unwind_check_reliability() - If
> a return PC is not a valid kernel text address, consider the stack
> trace unreliable. It could be some generated code. Other reliability checks
> will be added in the future.
> 
> Let unwind() return a boolean to indicate if the stack trace is
> reliable.
> 
> Signed-off-by: Madhavan T. Venkataraman <madvenka@linux.microsoft.com>
> Reviewed-by: Mark Brown <broonie@kernel.org>
> ---
>  arch/arm64/kernel/stacktrace.c | 31 +++++++++++++++++++++++++++++--
>  1 file changed, 29 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/kernel/stacktrace.c b/arch/arm64/kernel/stacktrace.c
> index c749129aba5a..5ef2ce217324 100644
> --- a/arch/arm64/kernel/stacktrace.c
> +++ b/arch/arm64/kernel/stacktrace.c
> @@ -44,6 +44,8 @@
>   * @final_fp:	 Pointer to the final frame.
>   *
>   * @failed:      Unwind failed.
> + *
> + * @reliable:    Stack trace is reliable.
>   */

I would strongly prefer if we could have something like an
unwind_state_is_reliable() helper, and just use that directly, rather than
storing that into the state.

That way, we can opt-into any expensive checks in the reliable unwinder (e.g.
__kernel_text_address), and can use them elsewhere for informative purposes
(e.g. when dumping a stacktrace out to the console).

>  struct unwind_state {
>  	unsigned long fp;
> @@ -57,6 +59,7 @@ struct unwind_state {
>  	struct task_struct *task;
>  	unsigned long final_fp;
>  	bool failed;
> +	bool reliable;
>  };
>  
>  static void unwind_init_common(struct unwind_state *state,
> @@ -80,6 +83,7 @@ static void unwind_init_common(struct unwind_state *state,
>  	state->prev_fp = 0;
>  	state->prev_type = STACK_TYPE_UNKNOWN;
>  	state->failed = false;
> +	state->reliable = true;
>  
>  	/* Stack trace terminates here. */
>  	state->final_fp = (unsigned long)task_pt_regs(task)->stackframe;
> @@ -242,11 +246,34 @@ static void notrace unwind_next(struct unwind_state *state)
>  }
>  NOKPROBE_SYMBOL(unwind_next);
>  
> -static void notrace unwind(struct unwind_state *state,
> +/*
> + * Check the stack frame for conditions that make further unwinding unreliable.
> + */
> +static void unwind_check_reliability(struct unwind_state *state)
> +{
> +	if (state->fp == state->final_fp) {
> +		/* Final frame; no more unwind, no need to check reliability */
> +		return;
> +	}
> +
> +	/*
> +	 * If the PC is not a known kernel text address, then we cannot
> +	 * be sure that a subsequent unwind will be reliable, as we
> +	 * don't know that the code follows our unwind requirements.
> +	 */
> +	if (!__kernel_text_address(state->pc))
> +		state->reliable = false;
> +}

I'd strongly prefer that we split this into two helpers, e.g.

static inline bool unwind_state_is_final(struct unwind_state *state)
{
	return state->fp == state->final_fp;
}

static inline bool unwind_state_is_reliable(struct unwind_state *state)
{
	return __kernel_text_address(state->pc);
}

> +
> +static bool notrace unwind(struct unwind_state *state,
>  			   stack_trace_consume_fn consume_entry, void *cookie)
>  {
> -	while (unwind_continue(state, consume_entry, cookie))
> +	unwind_check_reliability(state);
> +	while (unwind_continue(state, consume_entry, cookie)) {
>  		unwind_next(state);
> +		unwind_check_reliability(state);

This is going to slow down regular unwinds even when the reliablity value is
not consumed (e.g. for KASAN traces on alloc and free), so I don't think this
should live here, and should be intreoduced with arch_stack_walk_reliable().

Thanks,
Mark.

> +	}
> +	return !state->failed && state->reliable;
>  }
>  NOKPROBE_SYMBOL(unwind);
>  
> -- 
> 2.25.1
> 
