Return-Path: <live-patching+bounces-216-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 90F5089897C
	for <lists+live-patching@lfdr.de>; Thu,  4 Apr 2024 16:04:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 04ABE1F2A7B2
	for <lists+live-patching@lfdr.de>; Thu,  4 Apr 2024 14:04:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 39C151292DD;
	Thu,  4 Apr 2024 14:04:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="UWARAJx0"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BEA91292FC
	for <live-patching@vger.kernel.org>; Thu,  4 Apr 2024 14:04:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712239456; cv=none; b=Z+NEuD3EImvgaDDrfo59I7FlVrx+DaYF71seAxpTRQAuBULDo84kPddS48nxi6vdql3lLW2sDW9C2bNePIBzQ3ko0lHtBFhWJeZLVIQl1f2qz4qm1bVfZud8IroeqxG/hxRUYUdYIOGurR5xXfc0jHnww5LpYrGJHzdcJPkLyC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712239456; c=relaxed/simple;
	bh=4YsbgZU6LmmggK+xUjomwMPE5BdtxPaPztjbjqDo6S8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=amAmRiFxbnMIKbqE1qWy5NYNFoTwbveLxRi8Aroy3tg2hL3iCzINjjE5tS5OAqhHzw32fSwydJAk/ntJ/cuMdHz+SKXOzPyOJ7HCVJJDHRwaIWRi3DaSKt3NB252+LXqnjnM1mS0S4iVHhBv/Y4sERUhfRG/hV0taotWXzSzxgY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=UWARAJx0; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-415584360c0so7471185e9.1
        for <live-patching@vger.kernel.org>; Thu, 04 Apr 2024 07:04:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1712239451; x=1712844251; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=xrZUZuJ6o8h0kswN/fPU1Rkqp3+7k0LUkx9tP62SUxo=;
        b=UWARAJx0g/bR/iPsXTkfCFzItBohORLWbZ+hWRWNjF6UaofS5i4x35YNMDAR3bV1JQ
         Va1rBXHkO4cSsOSMgnrESy889AFAkwHcvfXCWoA070RbpZk08JhnV8rZ20zom4rERhZg
         F4+i9jqxAInwhG3/V6eVTWvaEJPzOGJOD1NBrhdN/Gxw7lgPlRhyMTV8luDgsP8maQZa
         AgA74tFvbPpZ2HXExp55KwFgctuuLf/F6v/ekTZfNrgKLGmZBGB0qVkT4bf2aD+1vikA
         KikIqtV0hREu4/tOXvhsNFK5NqYHiTz5Ifaecq9q0CKnCrTzcym7cVaMnE66vY6g6j37
         oNCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712239451; x=1712844251;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xrZUZuJ6o8h0kswN/fPU1Rkqp3+7k0LUkx9tP62SUxo=;
        b=Vv2nz13IRvqoNWz55Cl5yNojNEeqLLLEAO+X6utLt8hHVdjwjWSC2E5/KOs2V+NyVt
         j0JTEVlCQvMvWsmiS38BGYJYoa2ByLPaiKJvxRrYvcLKq8W4JSxen8x/uG1+2ZseQ+rX
         PkuQ1sqrdNwL0GeQCNMEp/LsBG7NqIV0qG24GEVVS66df0UwNpgXJ+hRf7JXR7SY7uom
         P/TWwl8bHAf//0JeX/dOeY2nwWaIisq+y5k0RxVkwsloqpbXOo5cJrfSn0Yng5uSICta
         ZF2/Zd7qTpNnbHN9eBm7C5bjHAtEwUY39AlC2HWthfzd3sVFKsbCZrR8iuz2Zu5TAdR9
         H/UQ==
X-Forwarded-Encrypted: i=1; AJvYcCUYJYWjq5MQcXCe19RvfMk742NKvOST4lZ3UxLMBHlwmytOORE0Iag9xv7FohqFnukF6V8XVTj375At0bIsgVOl1QYeA0h5CtanoYHYTQ==
X-Gm-Message-State: AOJu0YwP9TU8Zadc/HpvbjtyohiUMTyaINbrROxrPLEbRvKn7zd2lCN3
	RqvnRfaYN2xVeAhwzWCLT6t5l5m0DPVR5V9dvItl/ktOcHStQN8zoZzzH7tU6KNx8tTb/sNSs+z
	c
X-Google-Smtp-Source: AGHT+IFWkeyEYEnU9VKeUX+p9nUTn+I54XTino0LqNky9iIqJeqs78AiDz9uaJ1OrM65SiOjV30vMA==
X-Received: by 2002:adf:f789:0:b0:343:97b0:fd1c with SMTP id q9-20020adff789000000b0034397b0fd1cmr1914389wrp.13.1712239450817;
        Thu, 04 Apr 2024 07:04:10 -0700 (PDT)
Received: from alley ([176.114.240.50])
        by smtp.gmail.com with ESMTPSA id i13-20020adffc0d000000b00343c1cd5aedsm1698442wrr.52.2024.04.04.07.04.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Apr 2024 07:04:10 -0700 (PDT)
Date: Thu, 4 Apr 2024 16:04:08 +0200
From: Petr Mladek <pmladek@suse.com>
To: Yafang Shao <laoar.shao@gmail.com>
Cc: jpoimboe@kernel.org, jikos@kernel.org, mbenes@suse.cz,
	joe.lawrence@redhat.com, mcgrof@kernel.org,
	live-patching@vger.kernel.org, linux-modules@vger.kernel.org
Subject: Re: [PATCH] livepatch: Delete the associated module when replacing
 an old livepatch
Message-ID: <Zg6zWLuYHotLSSLT@alley>
References: <20240331133839.18316-1-laoar.shao@gmail.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240331133839.18316-1-laoar.shao@gmail.com>

On Sun 2024-03-31 21:38:39, Yafang Shao wrote:
> Enhance the functionality of kpatch to automatically remove the associated
> module when replacing an old livepatch with a new one. This ensures that no
> leftover modules remain in the system. For instance:

I like this feature. I would suggest to split it into two parts:

  + 1st patch would implement the delete_module() API. It must be safe
    even for other potential in-kernel callers. And it must be
    acceptable for the module loader code maintainers.

  + 2nd patch() using the API in the livepatch code.
    We will need to make sure that the new delete_module()
    API is used correctly from the livepatching code side.

The 2nd patch should also fix the selftests.


> - Load the first livepatch
>   $ kpatch load 6.9.0-rc1+/livepatch-test_0.ko
>   loading patch module: 6.9.0-rc1+/livepatch-test_0.ko
>   waiting (up to 15 seconds) for patch transition to complete...
>   transition complete (2 seconds)
> 
>   $ kpatch list
>   Loaded patch modules:
>   livepatch_test_0 [enabled]
> 
>   $ lsmod |grep livepatch
>   livepatch_test_0       16384  1
> 
> - Load a new livepatch
>   $ kpatch load 6.9.0-rc1+/livepatch-test_1.ko
>   loading patch module: 6.9.0-rc1+/livepatch-test_1.ko
>   waiting (up to 15 seconds) for patch transition to complete...
>   transition complete (2 seconds)
> 
>   $ kpatch list
>   Loaded patch modules:
>   livepatch_test_1 [enabled]
> 
>   $ lsmod |grep livepatch
>   livepatch_test_1       16384  1
>   livepatch_test_0       16384  0   <<<< leftover
> 
> With this improvement, executing
> `kpatch load 6.9.0-rc1+/livepatch-test_1.ko` will automatically remove the
> livepatch-test_0.ko module.

As already mentioned by Joe, please replace "kpatch" with
the related "modprobe" and "echo 0 >/sys/kernel/livepatch/<name>/enable"
calls.

"kpatch" is a 3rd party tool and only few people know what it does
internally. The kernel commit message is there for current and future
kernel developers. They should be able to understand the behavior
even without digging details about "random" user-space tools.

> --- a/kernel/livepatch/core.c
> +++ b/kernel/livepatch/core.c
> @@ -721,8 +723,13 @@ static void klp_free_patch_finish(struct klp_patch *patch)
>  	wait_for_completion(&patch->finish);
>  
>  	/* Put the module after the last access to struct klp_patch. */
> -	if (!patch->forced)
> -		module_put(patch->mod);
> +	if (!patch->forced)  {
> +		module_put(mod);
> +		if (module_refcount(mod))
> +			return;
> +		mod->state = MODULE_STATE_GOING;

mod->state should be modified only by the code in kernel/module/.
It helps to keep the operation safe (under control of module
loader code maintainers).

The fact that this patch does the above without module_mutex is
a nice example of possible mistakes.

And there are more problems, see below.

> +		delete_module(mod);

klp_free_patch_finish() is called also from the error path
in klp_enable_patch(). We must not remove the module
in this case. do_init_module() will do the clean up
the right way.

> +	}
>  }
>  
>  /*
> diff --git a/kernel/module/main.c b/kernel/module/main.c
> index e1e8a7a9d6c1..e863e1f87dfd 100644
> --- a/kernel/module/main.c
> +++ b/kernel/module/main.c
> @@ -695,12 +695,35 @@ EXPORT_SYMBOL(module_refcount);
>  /* This exists whether we can unload or not */
>  static void free_module(struct module *mod);
>  
> +void delete_module(struct module *mod)
> +{
> +	char buf[MODULE_FLAGS_BUF_SIZE];
> +

If we export this API via include/linux/module.h then
it could be used anywhere in the kernel. Therefore we need
to make it safe.

This function should do the same actions as the syscall
starting from:

	mutex_lock(&module_mutex); 

	if (!list_empty(&mod->source_list)) {
		/* Other modules depend on us: get rid of them first. */
		ret = -EWOULDBLOCK;
		goto out;
	}
...

Best Regards,
Petr

> +	/* Final destruction now no one is using it. */
> +	if (mod->exit != NULL)
> +		mod->exit();
> +	blocking_notifier_call_chain(&module_notify_list,
> +				     MODULE_STATE_GOING, mod);
> +	klp_module_going(mod);
> +	ftrace_release_mod(mod);
> +
> +	async_synchronize_full();
> +
> +	/* Store the name and taints of the last unloaded module for diagnostic purposes */
> +	strscpy(last_unloaded_module.name, mod->name, sizeof(last_unloaded_module.name));
> +	strscpy(last_unloaded_module.taints, module_flags(mod, buf, false),
> +		sizeof(last_unloaded_module.taints));
> +
> +	free_module(mod);
> +	/* someone could wait for the module in add_unformed_module() */
> +	wake_up_all(&module_wq);
> +}
> +
>  SYSCALL_DEFINE2(delete_module, const char __user *, name_user,
>  		unsigned int, flags)
>  {
>  	struct module *mod;
>  	char name[MODULE_NAME_LEN];
> -	char buf[MODULE_FLAGS_BUF_SIZE];
>  	int ret, forced = 0;
>  
>  	if (!capable(CAP_SYS_MODULE) || modules_disabled)
> @@ -750,23 +773,7 @@ SYSCALL_DEFINE2(delete_module, const char __user *, name_user,
>  		goto out;
>  
>  	mutex_unlock(&module_mutex);
> -	/* Final destruction now no one is using it. */
> -	if (mod->exit != NULL)
> -		mod->exit();
> -	blocking_notifier_call_chain(&module_notify_list,
> -				     MODULE_STATE_GOING, mod);
> -	klp_module_going(mod);
> -	ftrace_release_mod(mod);
> -
> -	async_synchronize_full();
> -
> -	/* Store the name and taints of the last unloaded module for diagnostic purposes */
> -	strscpy(last_unloaded_module.name, mod->name, sizeof(last_unloaded_module.name));
> -	strscpy(last_unloaded_module.taints, module_flags(mod, buf, false), sizeof(last_unloaded_module.taints));
> -
> -	free_module(mod);
> -	/* someone could wait for the module in add_unformed_module() */
> -	wake_up_all(&module_wq);
> +	delete_module(mod);
>  	return 0;
>  out:
>  	mutex_unlock(&module_mutex);

