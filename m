Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E659452040F
	for <lists+live-patching@lfdr.de>; Mon,  9 May 2022 20:00:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239879AbiEISEH (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 9 May 2022 14:04:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239925AbiEISEE (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 9 May 2022 14:04:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A16522A2F9;
        Mon,  9 May 2022 11:00:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 989E0615D7;
        Mon,  9 May 2022 18:00:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 970D7C385B2;
        Mon,  9 May 2022 18:00:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652119207;
        bh=+6bV93j1JQUzPiPeS8iW/xrGtw1Q0Og6QhFnv7F7R9o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Z2PsqCWAw810MTRoGUm/er10ah2EoSb8C3TIGr0VVdrDmjwgg/sscRHBpjkY3W7jM
         VhsZ9+kX73Xe+ftMhQnNipnQvsP/30DiVxzTZGYa2jfaUN9MukhesI6yzuyk/rR/kO
         L3XW8VteSAYo6nK3bPwi1L5nJAS7JzUj+p/08wT9/KUujrggG25DvydboTo417/4Xh
         wtncttQe3b6xivcbNmQouhyr3qQDCu2swo9sUlPMAxeKDUnp00/e1qgYQ3B9Yfvn1G
         07wOnSoD7D6g8j0Y14JmRtnuSEwroJDw34//38KD+1ko2mETo4AZBKh1vPtaT0dvAl
         FMSGt6tUD9gKA==
Date:   Mon, 9 May 2022 11:00:04 -0700
From:   Josh Poimboeuf <jpoimboe@kernel.org>
To:     Rik van Riel <riel@surriel.com>
Cc:     Song Liu <song@kernel.org>, linux-kernel@vger.kernel.org,
        live-patching@vger.kernel.org, mingo@redhat.com,
        peterz@infradead.org, vincent.guittot@linaro.org,
        jpoimboe@redhat.com, joe.lawrence@redhat.com, kernel-team@fb.com
Subject: Re: [RFC] sched,livepatch: call stop_one_cpu in
 klp_check_and_switch_task
Message-ID: <20220509180004.zmvhz65xlncwqrrc@treble>
References: <20220507174628.2086373-1-song@kernel.org>
 <20220509115227.6075105e@imladris.surriel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220509115227.6075105e@imladris.surriel.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Mon, May 09, 2022 at 11:52:27AM -0400, Rik van Riel wrote:
> Does this look like an approach that could work?
> 
> ---8<---
> sched,livepatch: call stop_one_cpu in klp_check_and_switch_task
> 
> If a running task fails to transition to the new kernel live patch after the
> first attempt, use the stopper thread to preempt it during subsequent attempts
> at switching to the new kernel live patch.
> 
> <INSERT EXPERIMENTAL RESULTS HERE>

It would be helpful to add more info about the original problem being
solved, and how this is supposed to fix it.

> +static int kpatch_dummy_fn(void *dummy)

s/kpatch/klp/

> +{
> +	return 0;
> +}
> +
>  /*
>   * Try to safely switch a task to the target patch state.  If it's currently
>   * running, or it's sleeping on a to-be-patched or to-be-unpatched function, or
> @@ -315,6 +321,9 @@ static bool klp_try_switch_task(struct task_struct *task)
>  	case -EBUSY:	/* klp_check_and_switch_task() */
>  		pr_debug("%s: %s:%d is running\n",
>  			 __func__, task->comm, task->pid);
> +		/* Preempt the task from the second KLP switch attempt. */
> +		if (klp_signals_cnt)
> +			stop_one_cpu(task_cpu(task), kpatch_dummy_fn, NULL);

I must be missing something, how is briefly preempting a kthread
supposed to actually transition it?  Won't it likely go back to running
on the CPU before the next periodic klp_transition_work_fn() check?

-- 
Josh
