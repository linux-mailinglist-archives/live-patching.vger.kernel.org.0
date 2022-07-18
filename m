Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88AAB5782BA
	for <lists+live-patching@lfdr.de>; Mon, 18 Jul 2022 14:50:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233249AbiGRMum (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 18 Jul 2022 08:50:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233493AbiGRMum (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 18 Jul 2022 08:50:42 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 719DD6397;
        Mon, 18 Jul 2022 05:50:40 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 1F56033BE8;
        Mon, 18 Jul 2022 12:50:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1658148639; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9QeNU7i1Z8jOANG2Muly2d9TTzEZo5jKEBQhnd4Wbho=;
        b=aXCE0L5kmo7kN4TNty5IXSebf6+/gMTsHbMU8UHhLiD5s6Q/GymEAj8WT2fCYooe+u+H3E
        8nzTlsJbn7jQhxaPDdbi1pWLoddkmSVa0BJt6HMf381Wq3CsFTB4fA5yx7Pe5rFABuYmRx
        s4bd2JA1tX19hRCZ+8nHXLxtMpYt9yQ=
Received: from suse.cz (unknown [10.100.201.202])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id BD6AD2C141;
        Mon, 18 Jul 2022 12:50:38 +0000 (UTC)
Date:   Mon, 18 Jul 2022 14:50:36 +0200
From:   Petr Mladek <pmladek@suse.com>
To:     Song Liu <song@kernel.org>
Cc:     bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        live-patching@vger.kernel.org, daniel@iogearbox.net,
        kernel-team@fb.com, jolsa@kernel.org, rostedt@goodmis.org
Subject: Re: [PATCH v3 bpf-next 1/4] ftrace: add
 modify_ftrace_direct_multi_nolock
Message-ID: <YtVXHDfV8HDwAm6G@alley>
References: <20220718001405.2236811-1-song@kernel.org>
 <20220718001405.2236811-2-song@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220718001405.2236811-2-song@kernel.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Sun 2022-07-17 17:14:02, Song Liu wrote:
> This is similar to modify_ftrace_direct_multi, but does not acquire
> direct_mutex. This is useful when direct_mutex is already locked by the
> user.
> 
> --- a/kernel/trace/ftrace.c
> +++ b/kernel/trace/ftrace.c
> @@ -5691,22 +5691,8 @@ int unregister_ftrace_direct_multi(struct ftrace_ops *ops, unsigned long addr)
> @@ -5717,12 +5703,8 @@ int modify_ftrace_direct_multi(struct ftrace_ops *ops, unsigned long addr)
>  	int i, size;
>  	int err;
>  
> -	if (check_direct_multi(ops))
> +	if (WARN_ON_ONCE(!mutex_is_locked(&direct_mutex)))
>  		return -EINVAL;

IMHO, it is better to use:

	lockdep_assert_held_once(&direct_mutex);

It will always catch the problem when called without the lock and
lockdep is enabled.

> -	if (!(ops->flags & FTRACE_OPS_FL_ENABLED))
> -		return -EINVAL;
> -
> -	mutex_lock(&direct_mutex);
>  
>  	/* Enable the tmp_ops to have the same functions as the direct ops */
>  	ftrace_ops_init(&tmp_ops);
> @@ -5730,7 +5712,7 @@ int modify_ftrace_direct_multi(struct ftrace_ops *ops, unsigned long addr)
>  
>  	err = register_ftrace_function(&tmp_ops);
>  	if (err)
> -		goto out_direct;
> +		return err;
>  
>  	/*
>  	 * Now the ftrace_ops_list_func() is called to do the direct callers.
> @@ -5754,7 +5736,64 @@ int modify_ftrace_direct_multi(struct ftrace_ops *ops, unsigned long addr)
>  	/* Removing the tmp_ops will add the updated direct callers to the functions */
>  	unregister_ftrace_function(&tmp_ops);
>  
> - out_direct:
> +	return err;
> +}
> +
> +/**
> + * modify_ftrace_direct_multi_nolock - Modify an existing direct 'multi' call
> + * to call something else
> + * @ops: The address of the struct ftrace_ops object
> + * @addr: The address of the new trampoline to call at @ops functions
> + *
> + * This is used to unregister currently registered direct caller and
> + * register new one @addr on functions registered in @ops object.
> + *
> + * Note there's window between ftrace_shutdown and ftrace_startup calls
> + * where there will be no callbacks called.
> + *
> + * Caller should already have direct_mutex locked, so we don't lock
> + * direct_mutex here.
> + *
> + * Returns: zero on success. Non zero on error, which includes:
> + *  -EINVAL - The @ops object was not properly registered.
> + */
> +int modify_ftrace_direct_multi_nolock(struct ftrace_ops *ops, unsigned long addr)
> +{
> +	if (check_direct_multi(ops))
> +		return -EINVAL;
> +	if (!(ops->flags & FTRACE_OPS_FL_ENABLED))
> +		return -EINVAL;
> +
> +	return __modify_ftrace_direct_multi(ops, addr);
> +}
> +EXPORT_SYMBOL_GPL(modify_ftrace_direct_multi_nolock);
> +
> +/**
> + * modify_ftrace_direct_multi - Modify an existing direct 'multi' call
> + * to call something else
> + * @ops: The address of the struct ftrace_ops object
> + * @addr: The address of the new trampoline to call at @ops functions
> + *
> + * This is used to unregister currently registered direct caller and
> + * register new one @addr on functions registered in @ops object.
> + *
> + * Note there's window between ftrace_shutdown and ftrace_startup calls
> + * where there will be no callbacks called.
> + *
> + * Returns: zero on success. Non zero on error, which includes:
> + *  -EINVAL - The @ops object was not properly registered.
> + */
> +int modify_ftrace_direct_multi(struct ftrace_ops *ops, unsigned long addr)
> +{
> +	int err;
> +
> +	if (check_direct_multi(ops))
> +		return -EINVAL;
> +	if (!(ops->flags & FTRACE_OPS_FL_ENABLED))
> +		return -EINVAL;
> +
> +	mutex_lock(&direct_mutex);
> +	err = __modify_ftrace_direct_multi(ops, addr);
>  	mutex_unlock(&direct_mutex);
>  	return err;
>  }

I would personally do:

int __modify_ftrace_direct_multi(struct ftrace_ops *ops,
			unsigned long addr, bool lock)
{
	int err;

	if (check_direct_multi(ops))
		return -EINVAL;
	if (!(ops->flags & FTRACE_OPS_FL_ENABLED))
		return -EINVAL;

	if (lock)
		mutex_lock(&direct_mutex);

	err = __modify_ftrace_direct_multi(ops, addr);

	if (lock)
		mutex_unlock(&direct_mutex);

	return err;
}

int modify_ftrace_direct_multi(struct ftrace_ops *ops, unsigned long addr)
{
	__modify_ftrace_direct_multi(ops, addr, true);
}

int modify_ftrace_direct_multi_nolock(struct ftrace_ops *ops, unsigned long addr)
{
	__modify_ftrace_direct_multi(ops, addr, false);
}

To avoid duplication of the checks. But it is a matter of taste.

Best Regards,
Petr
