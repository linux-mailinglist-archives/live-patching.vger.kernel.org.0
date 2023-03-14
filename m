Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05A216B909F
	for <lists+live-patching@lfdr.de>; Tue, 14 Mar 2023 11:51:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230123AbjCNKvK (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 14 Mar 2023 06:51:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230111AbjCNKuw (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 14 Mar 2023 06:50:52 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF34C9CFDA;
        Tue, 14 Mar 2023 03:50:25 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id C03AC219F2;
        Tue, 14 Mar 2023 10:50:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1678791023; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ysvDwr8pUVPSJCbQxmn2Y/eGntnEow5CqCBPPXw87k8=;
        b=bOa+kJVnO+f5QQqUEqYKKSTN6vVhJsd8fz6xndA6ythfVXLe5t45cxFsyAAeywRl6Huejk
        rc9yyMmar5/7dpU6P+0XerNPT9k3G3FwYlRh0gh3twsD6XSybtg8T3/0xL8x2kb0NA6iNc
        yPRk7Kk0lVbaLc6V5vhh6uGpl6bS92M=
Received: from suse.cz (unknown [10.100.201.202])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 667B62C141;
        Tue, 14 Mar 2023 10:50:21 +0000 (UTC)
Date:   Tue, 14 Mar 2023 11:50:21 +0100
From:   Petr Mladek <pmladek@suse.com>
To:     Josh Poimboeuf <jpoimboe@kernel.org>
Cc:     live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        Seth Forshee <sforshee@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Song Liu <song@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Miroslav Benes <mbenes@suse.cz>,
        Jiri Kosina <jikos@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Rik van Riel <riel@surriel.com>
Subject: Re: [PATCH 0.5/3] livepatch: Convert stack entries array to percpu
Message-ID: <ZBBRbfAL5+ZI77XN@alley>
References: <cover.1677257135.git.jpoimboe@kernel.org>
 <4ae981466b7814ec221014fc2554b2f86f3fb70b.1677257135.git.jpoimboe@kernel.org>
 <Y/zSgw5LOpbp7e/A@alley>
 <20230228165608.kumgxziaietsjaz3@treble>
 <ZAH9baGIOVL4/OHM@alley>
 <20230313233346.kayh4t2lpicjkpsv@treble>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230313233346.kayh4t2lpicjkpsv@treble>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Mon 2023-03-13 16:33:46, Josh Poimboeuf wrote:
> On Fri, Mar 03, 2023 at 03:00:13PM +0100, Petr Mladek wrote:
> > > MAX_STACK_ENTRIES is 100, which seems excessive.  If we halved that, the
> > > array would be "only" 400 bytes, which is *almost* reasonable to
> > > allocate on the stack?
> > 
> > It is just for the stack in the process context. Right?
> > 
> > I think that I have never seen a stack with over 50 entries. And in
> > the worst case, a bigger amount of entries would "just" result in
> > a non-reliable stack which might be acceptable.
> > 
> > It looks acceptable to me.
> > 
> > > Alternatively we could have a percpu entries array... :-/
> > 
> > That said, percpu entries would be fine as well. It sounds like
> > a good price for the livepatching feature. I think that livepatching
> > is used on big systems anyway.
> > 
> > I slightly prefer the per-cpu solution.
> 
> Booting a kernel with PREEMPT+LOCKDEP gave me a high-water mark of 60+
> stack entries, seen when probing a device.  I decided not to mess with
> MAX_STACK_ENTRIES, and instead just convert the entries to percpu.  This
> patch could be inserted at the beginning of the set.

Good to know.

> 
> ---8<---
> 
> Subject: [PATCH 0.5/3] livepatch: Convert stack entries array to percpu
> 
> --- a/kernel/livepatch/transition.c
> +++ b/kernel/livepatch/transition.c
> @@ -240,12 +242,15 @@ static int klp_check_stack_func(struct klp_func *func, unsigned long *entries,
>   */
>  static int klp_check_stack(struct task_struct *task, const char **oldname)
>  {
> -	static unsigned long entries[MAX_STACK_ENTRIES];
> +	unsigned long *entries = this_cpu_ptr(klp_stack_entries);
>  	struct klp_object *obj;
>  	struct klp_func *func;
>  	int ret, nr_entries;
>  
> -	ret = stack_trace_save_tsk_reliable(task, entries, ARRAY_SIZE(entries));
> +	/* Protect 'klp_stack_entries' */
> +	lockdep_assert_preemption_disabled();

I think about adding:

	/*
	 * Stay on the safe side even when cond_resched() is called from
	 * an IRQ context by mistake.
	 */
	if (!in_task())
		return -EINVAL;

Or is this prevented another way, please?

> +
> +	ret = stack_trace_save_tsk_reliable(task, entries, MAX_STACK_ENTRIES);
>  	if (ret < 0)
>  		return -EINVAL;
>  	nr_entries = ret;

Otherwise, it looks good to me.

Best Regards,
Petr
