Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04EDE6A01B2
	for <lists+live-patching@lfdr.de>; Thu, 23 Feb 2023 05:07:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232814AbjBWEHb (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 22 Feb 2023 23:07:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230281AbjBWEHa (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 22 Feb 2023 23:07:30 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A0043E600;
        Wed, 22 Feb 2023 20:07:28 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id nw10-20020a17090b254a00b00233d7314c1cso11357997pjb.5;
        Wed, 22 Feb 2023 20:07:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to:date
         :cc:to:from:subject:message-id:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oWSEd1NxYC11TmhqLYnTRyNanS7IntnXRdA2JcgjIq4=;
        b=A6xKQmhsb0+t3BEJkyFlkIOkRBQwx77Yv4++QoGR7PUIzHXLjhkzOpopYLPVx2BbWb
         NrSAfaSlzVUD4fy7wK2vqi2cqNG1hkR4qFHoPL2IyNJx6yXu1Cy5anJhi901uCzcICRQ
         QAYsMD9+qVsQfbz9+xGLl665DurwWY9iITEFqxZRwSptRfZZtrMTNvWYE0RmFmMNASgY
         cj9QBxrskW20mNqSplSd5GCQTNEMRXSO/n7Rv0O2s1WhlAnV42j/mRUf/sO0ulhQpZwQ
         3SIaY/osDqNjJfx9llwn3UoRBGclW7PwsZW0ejABRIu7YQh0xtbrlAF9dOnure6b6LoA
         hxPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to:date
         :cc:to:from:subject:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=oWSEd1NxYC11TmhqLYnTRyNanS7IntnXRdA2JcgjIq4=;
        b=gzsLz2ugzgy4hgyvOyMMTN68WeNYpAZEkLBopKcKb+S91NNeX8FiaCe/edsFnixsJB
         tpC7As/YGdQ5vHx7Mb6at08+V8wOu5HPTMdcYNIiOk5XqZe9GEsnjgCl7JtNy10bngVv
         yu96bReIRPEXim/LFQwu7IcTrYrxWeTj1O0efeO5bJUZFehAYyRmaQGHOqTEWIYH+Qpy
         o3uyoowRmG+NkfODyRs6k2Uzuf8cYnGzsKy4+VdYR8FEDmo/AgwWpzUxH5FdKN0GDtzN
         7BX0SRSA7Z0rRX2ZZtbd214Ko2NRNNK4RIsXhf0utGL3s/Og5WMABpI5VVssX3PzvGV2
         2WiQ==
X-Gm-Message-State: AO0yUKVzRO8TQXoGSCd2svecqUFAa9jfK5kRmnQ8I+p3ptNvu6MJKIoD
        cHbhFycd9Vzm/LZpeRyDNeM=
X-Google-Smtp-Source: AK7set+JvYa165vssA3FxAgXlIB6DbNGxRw2hl3MGkRtnutUbOSThX5fn9dhRPgrTQR7/O7qY8zBIQ==
X-Received: by 2002:a17:90b:4a4d:b0:234:148:4b27 with SMTP id lb13-20020a17090b4a4d00b0023401484b27mr13371708pjb.17.1677125247646;
        Wed, 22 Feb 2023 20:07:27 -0800 (PST)
Received: from cdg1-dhcp-7-226.amazon.fr ([54.240.193.0])
        by smtp.googlemail.com with ESMTPSA id gi4-20020a17090b110400b00230ab56a1f3sm5802814pjb.51.2023.02.22.20.07.21
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 22 Feb 2023 20:07:26 -0800 (PST)
Message-ID: <88ab8c8348373e5c7c90c985dd92b5e06f32b16b.camel@gmail.com>
Subject: Re: [RFC PATCH v3 19/22] arm64: unwinder: Add a reliability check
 in the unwinder based on ORC
From:   Suraj Jitindar Singh <sjitindarsingh@gmail.com>
To:     madvenka@linux.microsoft.com
Cc:     poimboe@redhat.com, peterz@infradead.org, chenzhongjin@huawei.com,
        mark.rutland@arm.com, broonie@kernel.org, nobuta.keiya@fujitsu.com,
        catalin.marinas@arm.com, will@kernel.org,
        jamorris@linux.microsoft.com, linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Thu, 23 Feb 2023 14:07:19 +1000
In-Reply-To: <20230202074036.507249-20-madvenka@linux.microsoft.com>
References: <0337266cf19f4c98388e3f6d09f590d9de258dc7>
         <20230202074036.507249-1-madvenka@linux.microsoft.com>
         <20230202074036.507249-20-madvenka@linux.microsoft.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Thu, 2023-02-02 at 01:40 -0600, madvenka@linux.microsoft.com wrote:
> From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
> 
> Introduce a reliability flag in struct unwind_state. This will be set
> to
> false if the PC does not have a valid ORC or if the frame pointer
> computed
> from the ORC does not match the actual frame pointer.
> 
> Now that the unwinder can validate the frame pointer, introduce
> arch_stack_walk_reliable().
> 
> Signed-off-by: Madhavan T. Venkataraman <madvenka@linux.microsoft.com
> >
> ---
>  arch/arm64/include/asm/stacktrace/common.h |  15 ++
>  arch/arm64/kernel/stacktrace.c             | 167
> ++++++++++++++++++++-
>  2 files changed, 175 insertions(+), 7 deletions(-)
> 

[snip]
 
> -static void notrace unwind(struct unwind_state *state,
> +static int notrace unwind(struct unwind_state *state, bool
> need_reliable,
>  			   stack_trace_consume_fn consume_entry, void
> *cookie)
>  {
> -	while (1) {
> -		int ret;
> +	int ret = 0;
>  
> +	while (1) {
> +		if (need_reliable && !state->reliable)
> +			return -EINVAL;
>  		if (!consume_entry(cookie, state->pc))
>  			break;
>  		ret = unwind_next(state);
> +		if (need_reliable && !ret)
> +			unwind_check_reliable(state);
>  		if (ret < 0)
>  			break;
>  	}
> +	return ret;

nit:

I think you're looking more for comments on the approach and the
correctness of these patches, but from an initial read I'm still
putting it all together in my head. So this comment is on the coding
style.

The above loop seems to check the current reliability state, then
unwind a frame then check the reliability, and then break based of
something which couldn't have been updated by the line immediately
above. I propose something like:

unwind(...) {
	ret = 0;

	while (!ret) {
		if (need_reliable) {
			unwind_check_reliable(state);
			if (!state->reliable)
				return -EINVAL;
		}
		if (!consume_entry(cookie, state->pc))
			return -EINVAL;
		ret = unwind_next(state);
	}

	return ret;
}

This also removes the need for the call to unwind_check_reliable()
before the first unwind() below in arch_stack_walk_reliable().

- Suraj

>  }
>  NOKPROBE_SYMBOL(unwind);
>  
> @@ -216,5 +337,37 @@ noinline notrace void
> arch_stack_walk(stack_trace_consume_fn consume_entry,
>  		unwind_init_from_task(&state, task);
>  	}
>  
> -	unwind(&state, consume_entry, cookie);
> +	unwind(&state, false, consume_entry, cookie);
> +}
> +
> +noinline notrace int arch_stack_walk_reliable(
> +				stack_trace_consume_fn consume_entry,
> +				void *cookie, struct task_struct *task)
> +{
> +	struct stack_info stacks[] = {
> +		stackinfo_get_task(task),
> +		STACKINFO_CPU(irq),
> +#if defined(CONFIG_VMAP_STACK)
> +		STACKINFO_CPU(overflow),
> +#endif
> +#if defined(CONFIG_VMAP_STACK) && defined(CONFIG_ARM_SDE_INTERFACE)
> +		STACKINFO_SDEI(normal),
> +		STACKINFO_SDEI(critical),
> +#endif
> +	};
> +	struct unwind_state state = {
> +		.stacks = stacks,
> +		.nr_stacks = ARRAY_SIZE(stacks),
> +	};
> +	int ret;
> +
> +	if (task == current)
> +		unwind_init_from_caller(&state);
> +	else
> +		unwind_init_from_task(&state, task);
> +	unwind_check_reliable(&state);
> +
> +	ret = unwind(&state, true, consume_entry, cookie);
> +
> +	return ret == -ENOENT ? 0 : -EINVAL;
>  }

