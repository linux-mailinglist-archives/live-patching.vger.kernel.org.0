Return-Path: <live-patching+bounces-485-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3907D9509CD
	for <lists+live-patching@lfdr.de>; Tue, 13 Aug 2024 18:07:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AE44C1F27887
	for <lists+live-patching@lfdr.de>; Tue, 13 Aug 2024 16:07:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 39B301A2552;
	Tue, 13 Aug 2024 16:05:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="PApheRYX"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5F211A2542
	for <live-patching@vger.kernel.org>; Tue, 13 Aug 2024 16:05:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723565125; cv=none; b=KLd4EQsOPANR3IZyzd0DzRWCRHRyL022rTJ7YOBL/FG+eaCgF+u7jHqmmcx5l1WTUNXsM/XordoceK2NCnVwrtNdG+Q4ANdQXGjk1qnUZsT/YGqf4GM2+TYW7q9/f6r4RpYt5B3YTUiUGI12Vi7Qslf/p9xqsNP8cQjOlayCvW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723565125; c=relaxed/simple;
	bh=pE/JJsJwAZs7NmM5OlRmLlnWFQnfpSXYpFpeXH1hGrE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=boTeyoEvQGMvBV5aF1xXyqG6UJdPCH4CPPfXefGEGZZ98XXUvYFhNLwmJC90v4wAHhC5xnIsKXrBiF3DdnIElJlbr6LMVQO7HnglJ3jA3cDK1TzLb1iRs5Wn80QfjKPBEJxMNhUtZiTt7G1aF7ZjYgZkbdQAVZ3pMLGrdxRXUxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=PApheRYX; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-5b8c2a6135eso23745a12.0
        for <live-patching@vger.kernel.org>; Tue, 13 Aug 2024 09:05:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1723565120; x=1724169920; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=r6TUXGQw9LVl4ztxK/BZhTX+2pcevqPkKUrlJiDLRWU=;
        b=PApheRYXYAHHQ6m3SBE/210nSXYiyffMdL6ybjtHi7KTMO1kcKOViEmvv26hSq7XGD
         0HbA7V4KdapGOOXtjjWkV+BbAEUe1kDGB3SATLOTDxzzqdpw0gJYmLszd3JhK6Z0LAob
         Tni2JkTqKhaRnp+ava8vMYeV0SzV3kkpVe43G1vK3z99lVc3xy4llPEngccdKSMwvBiN
         ypZd+gk5xC7wTGhxVHms8DO6ZscwiP8E3P6p1Wb0gMfgcA6C7yn4L1EfRFtVBmSfUqD1
         W5cIrf5nNZxYaZ8tcxA/8KK1tI93Ehxsoe2tw0n9i1rHKm1L1/vMB9hDIvEMwcH/Y/Mq
         zxww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723565120; x=1724169920;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=r6TUXGQw9LVl4ztxK/BZhTX+2pcevqPkKUrlJiDLRWU=;
        b=tPH7PM7JTAFInyEs4ccccMV+l8ZT2uWBkOtfD0e3Po9YXUwjaWvziv0Rn0JWl38UUF
         g/Ngs2g2yvihoNuCgCseo+HHS7IW12Lax7SFLKWivC+RQ8NaU0NMTbsEGx/C/JPw5YzD
         /tN7Y00dkf19U79Af7U5LCaksYqSoWq48m+69wEdnvz657DiQ01jXiSNqyhpyClO4eve
         +t4cq2BtWrgPxuyI7ryw2WW/0YMWi7baTbTKTJI96owwx8PhurRlMLvcgjJXXPURUvFX
         Xtq2hZgcm1s7X6HY2557bdBMrbjgYljtVeSEPl1NYiq9qP5tq+22yLIdtOpOdnGG3DLE
         8fqw==
X-Forwarded-Encrypted: i=1; AJvYcCV6Fwl1y/en46JZcWmln38LGI21iffKOKhle2KROfM/9Z6HKwNMBKXER40H3liaiJPnPIXJfkt/a142SgWYcrFZ61P1cN9GjzlW26poiA==
X-Gm-Message-State: AOJu0Yy1ese/mWvBxPlPqnKY69tQeMI3SHoeBWe4b5V4TaJMIxxn3szU
	55ufmr+vWf1EGmh3a2SfiPX26mJyFyNAFgyRIGnpWuRA6xNHcG99nJHb8pSTtNw=
X-Google-Smtp-Source: AGHT+IE8bZvoNWekXnFDmPVltvx21KeribfH7wtwpDxLU1aDbLB72Ho09fmJhaygrlpzYUl+4P+d6A==
X-Received: by 2002:a05:6402:354c:b0:57d:4409:4f48 with SMTP id 4fb4d7f45d1cf-5bd462178a9mr3176525a12.15.1723565120152;
        Tue, 13 Aug 2024 09:05:20 -0700 (PDT)
Received: from pathway.suse.cz ([176.114.240.50])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5bd187f4fe2sm3025709a12.9.2024.08.13.09.05.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Aug 2024 09:05:19 -0700 (PDT)
Date: Tue, 13 Aug 2024 18:05:18 +0200
From: Petr Mladek <pmladek@suse.com>
To: "zhangyongde.zyd" <zhangwarden@gmail.com>
Cc: jpoimboe@kernel.org, mbenes@suse.cz, jikos@kernel.org,
	joe.lawrence@redhat.com, live-patching@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/1] livepatch: Add using attribute to klp_func for
 using function show
Message-ID: <ZruEPvstxgBQwN1K@pathway.suse.cz>
References: <20240805064656.40017-1-zhangyongde.zyd@alibaba-inc.com>
 <20240805064656.40017-2-zhangyongde.zyd@alibaba-inc.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240805064656.40017-2-zhangyongde.zyd@alibaba-inc.com>

On Mon 2024-08-05 14:46:56, zhangyongde.zyd wrote:
> From: Wardenjohn <zhangwarden@gmail.com>
> 
> One system may contains more than one livepatch module. We can see
> which patch is enabled. If some patches applied to one system
> modifing the same function, livepatch will use the function enabled
> on top of the function stack. However, we can not excatly know
> which function of which patch is now enabling.
> 
> This patch introduce one sysfs attribute of "using" to klp_func.
> For example, if there are serval patches  make changes to function
> "meminfo_proc_show", the attribute "enabled" of all the patch is 1.
> With this attribute, we can easily know the version enabling belongs
> to which patch.
> 
> The "using" is set as three state. 0 is disabled, it means that this
> version of function is not used. 1 is running, it means that this
> version of function is now running. -1 is unknown, it means that
> this version of function is under transition, some task is still
> chaning their running version of this function.
> 
> --- a/kernel/livepatch/core.c
> +++ b/kernel/livepatch/core.c
> @@ -773,6 +791,7 @@ static int klp_init_func(struct klp_object *obj, struct klp_func *func)
>  	INIT_LIST_HEAD(&func->stack_node);
>  	func->patched = false;
>  	func->transition = false;
> +	func->using = 0;
>  
>  	/* The format for the sysfs directory is <function,sympos> where sympos
>  	 * is the nth occurrence of this symbol in kallsyms for the patched
> @@ -903,6 +922,7 @@ static int klp_init_object(struct klp_patch *patch, struct klp_object *obj)
>  static void klp_init_func_early(struct klp_object *obj,
>  				struct klp_func *func)
>  {
> +	func->using = false;

It should be enough to initialize the value only one.
klp_init_func() is the right place.
klp_init_func_early() does only the bare minimum to allow freeing.

>  	kobject_init(&func->kobj, &klp_ktype_func);
>  	list_add_tail(&func->node, &obj->func_list);
>  }
> diff --git a/kernel/livepatch/patch.c b/kernel/livepatch/patch.c
> index 90408500e5a3..bf4a8edbd888 100644
> --- a/kernel/livepatch/patch.c
> +++ b/kernel/livepatch/patch.c
> @@ -104,7 +104,7 @@ static void notrace klp_ftrace_handler(unsigned long ip,
>  			 * original function.
>  			 */
>  			func = list_entry_rcu(func->stack_node.next,
> -					      struct klp_func, stack_node);
> +						struct klp_func, stack_node);

Looks like an unwanted change.

>  
>  			if (&func->stack_node == &ops->func_stack)
>  				goto unlock;
> diff --git a/kernel/livepatch/transition.c b/kernel/livepatch/transition.c
> index ba069459c101..12241dabce6f 100644
> --- a/kernel/livepatch/transition.c
> +++ b/kernel/livepatch/transition.c
> @@ -119,9 +120,35 @@ static void klp_complete_transition(void)
>  		klp_synchronize_transition();
>  	}
>  
> -	klp_for_each_object(klp_transition_patch, obj)
> -		klp_for_each_func(obj, func)
> -			func->transition = false;
> +	/*
> +	* The transition patch is finished. The stack top function is now truly
> +	* running. The previous function should be set as 0 as none task is 
> +	* using this function anymore.
> +	* 
> +	* If this is a patching patch, all function is using.
> +	* if this patch is unpatching, all function of the func stack top is using
> +	*/
> +	if (klp_target_state == KLP_TRANSITION_PATCHED)
> +		klp_for_each_object(klp_transition_patch, obj)
> +			klp_for_each_func(obj, func){

Missing space between "){'"

You should check your patch with ./scripts/checkpatch.pl before sending.

> +				func->using = 1;
> +				func->transition = false;
> +				next_func = list_entry_rcu(func->stack_node.next,
> +								struct klp_func, stack_node);

What if there is only one function on the stack?
You could take inspiration in klp_ftrace_handler.

> +				next_func->using = 0;
> +			}

Wrong indentation, see Documentation/process/coding-style.rst
./scripts/checkpatch.pl would likely caught this.

> +	else

Please, always put multi-line code in { }. It helps to avoid mistakes
and read the code.

> +		// for the unpatch func, if ops exist, the top of this func is using
> +		klp_for_each_object(klp_transition_patch, obj)
> +			klp_for_each_func(obj, func){
> +				func->transition = false;
> +				ops = klp_find_ops(func->old_func);
> +				if (ops){
> +					stack_top_func = list_first_entry(&ops->func_stack, struct klp_func,
> +							stack_node);
> +					stack_top_func->using = 1;
> +				}
> +			}
>  
>  	/* Prevent klp_ftrace_handler() from seeing KLP_TRANSITION_IDLE state */
>  	if (klp_target_state == KLP_TRANSITION_PATCHED)
> @@ -538,6 +565,7 @@ void klp_start_transition(void)
>  		  klp_transition_patch->mod->name,
>  		  klp_target_state == KLP_TRANSITION_PATCHED ? "patching" : "unpatching");
>  
> +

Extra line?

>  	/*
>  	 * Mark all normal tasks as needing a patch state update.  They'll
>  	 * switch either in klp_try_complete_transition() or as they exit the
> @@ -633,6 +661,9 @@ void klp_init_transition(struct klp_patch *patch, int state)
>  	 *
>  	 * When unpatching, the funcs are already in the func_stack and so are
>  	 * already visible to the ftrace handler.
> +	 * 
> +	 * When this patch is in transition, all functions of this patch will
> +	 * set to be unknown

The sentence is not complete. It does not say what exactly is set to unknown.

>  	 */
>  	klp_for_each_object(patch, obj)
>  		klp_for_each_func(obj, func)


Alternative solution:

The patch adds a lot of extra complexity to maintain the information.

Alternative solution would be to store the pointer of struct klp_ops
*ops into struct klp_func. Then using_show() could just check if
the related struct klp_func in on top of the stack.

It would allow to remove the global list klp_ops and all the related
code. klp_find_ops() would instead do:

   for_each_patch
     for_each_object
       for_each_func

The search would need more code. But it would be simple and
straightforward. We do this many times all over the code.

IMHO, it would actually remove some complexity and be a win-win solution.

Best Regards,
Petr

