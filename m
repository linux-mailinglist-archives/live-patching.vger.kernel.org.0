Return-Path: <live-patching+bounces-239-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DCC698BCD39
	for <lists+live-patching@lfdr.de>; Mon,  6 May 2024 13:58:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9463B284C2B
	for <lists+live-patching@lfdr.de>; Mon,  6 May 2024 11:58:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE253143745;
	Mon,  6 May 2024 11:58:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="JLEJfpOY"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CE61142640
	for <live-patching@vger.kernel.org>; Mon,  6 May 2024 11:58:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714996730; cv=none; b=p0fmHCYZC7BamIrhzeZhNuTL9Ju3KwfxBLERxb+9Zc1pXh0P3mh8BpEtBMff9gDln9vaZSp8F9NG94BNFml0dbvQ4IqLe0AhIeISYFMs3LZ1gB22ezZTLY2zJIW63QqBKZfuEaMJ2/mn68oXfAg9DZ8JkX9jbdPk3HpxuZIWXvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714996730; c=relaxed/simple;
	bh=sWUvmDi4mlQEhWCDlmCHj/BquExohn1t9zMQgm3nd5A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ChjgKcAb8Der2hUijyxBIW2Qg2a53sU/szQA0jiG/0yv6z1gmZ1zOmQ1g/3GFyybj5UWg9KDSkBlXxsK3kJLg15T+DGFAoE+QtcVTFS87HpREbo4MFvnBUi8XdpR3rxmNhpJ37IXQF2ZywQGBkuFJdx5z1dn1HDNHtyRGtu03UY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=JLEJfpOY; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-41c7ac71996so15177055e9.3
        for <live-patching@vger.kernel.org>; Mon, 06 May 2024 04:58:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1714996727; x=1715601527; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=dm0GB/BuUD4Gbjv8PP6D/fUXtdd44/vugtWovY9sFFU=;
        b=JLEJfpOYd+SSW9+xvrpGLqjTZ4u6UNHRKjD5epOFZFVd+Wug3VEmXwrflmDB/p7Myd
         ZI/Hv/W0h6O+PvyDjQGslRShOeeD7pIXazsGYd0tML4xoGe+gBCq7PgAKtiqrKK6UjO7
         YPhL72mYkgv1eAytok4BhZy5VpfOub4LjGdLPT83grlt+Zy2JCO0HzKKvjYb6n2VdHTx
         mqHKuQBj8th+qr5mzz2o8ab8ce0rZDAwmv+Bu4adLiGadxLkWJWv9uQFALV1CDHIe/A2
         SBubgtXnu5AHWvq4VwkrWEEpc49AgRtuY6CsuS9pwiiXZwZdstuN2n/q0qPwagZfUnYT
         ct9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714996727; x=1715601527;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dm0GB/BuUD4Gbjv8PP6D/fUXtdd44/vugtWovY9sFFU=;
        b=kHL3vlg00sGFJXOGaoipgRzq45jurjpCi6VEByEJW3Cw6YtxdGE6OpMgZBd79gRxx2
         gW3vqlJXW8PNq2vfUhPUyC104RvwHB8SBxw9AffTwMzVv8koHNAHhZIy64v8orYAaZMq
         UOQXIJjnjRKwXfggzdczPMyhSuWeEylDPhMEp3xWt0nYEfM5Xx+YkD6mpRlcciwYY9ug
         IPtGdZ2PqA3B1OaJAPKY9jJyEAmugeLRTQoYAvUc4e84k9/oxDcb0ORTxEa09pcRBkZw
         PDjOrXk/ybPLQlErbymdm7RMH8u2AXz66jicgYpyW1l2DDtQ4OuUPuHYYcW9dV/7yobe
         f/Tw==
X-Forwarded-Encrypted: i=1; AJvYcCUVeiUcveO9wyXrGksFZKtVIt57kuIJ/Yg2NyLGq4dS2B18CI6F4tSMMJw4zFyoNFRDKviMI0gafJND9KQgEyWyQIkrwR7VnpgOzySi6g==
X-Gm-Message-State: AOJu0YwdkfP4+vKDdsE6I7CKxZcKPaXB+tOOR6nf7x1Tebq7ICK5n0/n
	uc5dZFsIerMXnepQeRULy5/m8KUmwNSUVXywDVHx3ORi3geagGWes3fJnjWnLXE=
X-Google-Smtp-Source: AGHT+IHq2W1bMd8BCEB/4Fo71NJZZSz16EVbLhHtUL018DOrphhQ1gnBkliG/W3yy03Mp5O0YL7HfA==
X-Received: by 2002:a05:600c:3ac9:b0:418:df23:ae0e with SMTP id d9-20020a05600c3ac900b00418df23ae0emr6836772wms.40.1714996726905;
        Mon, 06 May 2024 04:58:46 -0700 (PDT)
Received: from pathway.suse.cz ([176.114.240.50])
        by smtp.gmail.com with ESMTPSA id s7-20020a05600c384700b0041b6f63f42esm15690084wmr.48.2024.05.06.04.58.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 May 2024 04:58:46 -0700 (PDT)
Date: Mon, 6 May 2024 13:58:45 +0200
From: Petr Mladek <pmladek@suse.com>
To: Yafang Shao <laoar.shao@gmail.com>
Cc: jpoimboe@kernel.org, jikos@kernel.org, mbenes@suse.cz,
	joe.lawrence@redhat.com, mcgrof@kernel.org,
	live-patching@vger.kernel.org, linux-modules@vger.kernel.org
Subject: Re: [PATCH v2 1/2] module: Add a new helper delete_module()
Message-ID: <ZjjF9cf0nU3ORFha@pathway.suse.cz>
References: <20240407035730.20282-1-laoar.shao@gmail.com>
 <20240407035730.20282-2-laoar.shao@gmail.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240407035730.20282-2-laoar.shao@gmail.com>

On Sun 2024-04-07 11:57:29, Yafang Shao wrote:
> Introduce a new helper function, delete_module(), designed to delete kernel
> modules from locations outside of the `kernel/module` directory.
> 
> No functional change.
> 
> --- a/kernel/module/main.c
> +++ b/kernel/module/main.c
> @@ -695,12 +695,74 @@ EXPORT_SYMBOL(module_refcount);
>  /* This exists whether we can unload or not */
>  static void free_module(struct module *mod);
>  
> +static void __delete_module(struct module *mod)
> +{
> +	char buf[MODULE_FLAGS_BUF_SIZE];
> +
> +	WARN_ON_ONCE(mod->state != MODULE_STATE_GOING);
> +
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
> +int delete_module(struct module *mod)
> +{
> +	int ret;
> +
> +	mutex_lock(&module_mutex);
> +	if (!list_empty(&mod->source_list)) {
> +		/* Other modules depend on us: get rid of them first. */
> +		ret = -EWOULDBLOCK;
> +		goto out;
> +	}

This is cut&paste from SYSCALL_DEFINE2(delete_module...

> +
> +	/* Doing init or already dying? */
> +	if (mod->state != MODULE_STATE_LIVE) {
> +		ret = -EBUSY;
> +		goto out;
> +	}

Same here. You only removed the debug message. Why?

> +
> +	/* If it has an init func, it must have an exit func to unload */
> +	if (mod->init && !mod->exit) {
> +		ret = -EBUSY;
> +		goto out;
> +	}

Same code, just without the "forced" handling.

> +
> +	if (try_release_module_ref(mod) != 0) {
> +		ret = -EWOULDBLOCK;
> +		goto out;
> +	}

This is the same as try_stop_module() without the "forced" handling.

> +	mod->state = MODULE_STATE_GOING;
> +	mutex_unlock(&module_mutex);
> +	__delete_module(mod);
> +	return 0;

I am sure that we could better refactor the code to remove
the code duplication.

> +
> +out:
> +	mutex_unlock(&module_mutex);
> +	return ret;
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

Otherwise, it looks good to me.

Best Regards,
Petr

