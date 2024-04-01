Return-Path: <live-patching+bounces-205-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D37F3893C84
	for <lists+live-patching@lfdr.de>; Mon,  1 Apr 2024 17:03:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C015E1C21824
	for <lists+live-patching@lfdr.de>; Mon,  1 Apr 2024 15:03:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4839C4596D;
	Mon,  1 Apr 2024 15:02:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="A06nfUVt"
X-Original-To: live-patching@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8078645BFF
	for <live-patching@vger.kernel.org>; Mon,  1 Apr 2024 15:02:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711983767; cv=none; b=Q7mk09KcqvSytdZdBhHoHzkoldLQ11anqbvHojdQ3LuWMIdsQGKvRVYvFMIxjqYduihNfxhatwd0t96pH3nYrS2vlpS6PBkmennyfwU0pur5Rzdq+AuX91s6frr3Y/UwXLWRboc4iL6t+JusHC0sENuHzbm1mEsIirJbTUBjMfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711983767; c=relaxed/simple;
	bh=i5pY7PNSPoQEEazRBrDrLYADHt6R4k940I8TJSkkYws=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DMay8QVJwTM/YjhtuxWBjz7uAEVX8RDOcduFbLK77dUk9KVEspANamiN21iiU9cifjW2zpFXoX8DYa+Ej9iKJ0+c27Ll++bEYgNp1Fjgir3H86v81DltbsrK/2WfqmBIJrkGLJs4wtQ/fUurC94FmtF2af818X/P3KlnhJbm/FM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=A06nfUVt; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1711983764;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=y6RAfEb+VJo4/i7U+FuG1IA4NawzdlKoHcYezVyDJio=;
	b=A06nfUVtZDxEIUdnc3RGYVO45eJ6TNm4wN3z+vu+5WvvZCxReLMTFLO6oHY56ZKiOT8UrE
	2QnS+jHxPN4sE+s2Dnev3GmCRhXGoK/GeOfjuoAne9ZtqEuSPSXsBtoSjG61PB7SxkBsew
	1fTEYMddGb/U3pXQNvTc0wflNYhfF0c=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-453-nK0HKxk5Mq2mGfRNYxBCeg-1; Mon,
 01 Apr 2024 11:02:39 -0400
X-MC-Unique: nK0HKxk5Mq2mGfRNYxBCeg-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 40521383E12A;
	Mon,  1 Apr 2024 15:02:23 +0000 (UTC)
Received: from redhat.com (unknown [10.22.8.63])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D7E15492BC4;
	Mon,  1 Apr 2024 15:02:22 +0000 (UTC)
Date: Mon, 1 Apr 2024 11:02:21 -0400
From: Joe Lawrence <joe.lawrence@redhat.com>
To: Yafang Shao <laoar.shao@gmail.com>
Cc: jpoimboe@kernel.org, jikos@kernel.org, mbenes@suse.cz, pmladek@suse.com,
	mcgrof@kernel.org, live-patching@vger.kernel.org,
	linux-modules@vger.kernel.org
Subject: Re: [PATCH] livepatch: Delete the associated module when replacing
 an old livepatch
Message-ID: <ZgrMfYBo8TynjSKX@redhat.com>
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
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.10

On Sun, Mar 31, 2024 at 09:38:39PM +0800, Yafang Shao wrote:
> Enhance the functionality of kpatch to automatically remove the associated
> module when replacing an old livepatch with a new one. This ensures that no
> leftover modules remain in the system. For instance:
> 
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
> 

Hi Yafang,

I think it would be better if the commit message reasoning used
insmod/modprobe directly rather than the kpatch user utility wrapper.
That would be more generic and remove any potential kpatch utility
variants from the picture.  (For example, it is possible to add `rmmod`
in the wrapper and then this patch would be redundant.)

> Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
> ---
>  include/linux/module.h  |  1 +
>  kernel/livepatch/core.c | 11 +++++++++--
>  kernel/module/main.c    | 43 ++++++++++++++++++++++++-----------------
>  3 files changed, 35 insertions(+), 20 deletions(-)
> 
> diff --git a/include/linux/module.h b/include/linux/module.h
> index 1153b0d99a80..9a95174a919b 100644
> --- a/include/linux/module.h
> +++ b/include/linux/module.h
> @@ -75,6 +75,7 @@ extern struct module_attribute module_uevent;
>  /* These are either module local, or the kernel's dummy ones. */
>  extern int init_module(void);
>  extern void cleanup_module(void);
> +extern void delete_module(struct module *mod);
>  
>  #ifndef MODULE
>  /**
> diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
> index ecbc9b6aba3a..f1edc999f3ef 100644
> --- a/kernel/livepatch/core.c
> +++ b/kernel/livepatch/core.c
> @@ -711,6 +711,8 @@ static void klp_free_patch_start(struct klp_patch *patch)
>   */
>  static void klp_free_patch_finish(struct klp_patch *patch)
>  {
> +	struct module *mod = patch->mod;
> +
>  	/*
>  	 * Avoid deadlock with enabled_store() sysfs callback by
>  	 * calling this outside klp_mutex. It is safe because
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
> +		delete_module(mod);
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
> -- 
> 2.39.1
> 

It's been a while since atomic replace was added and so I forget why the
implementation doesn't try this -- is it possible for the livepatch
module to have additional references that this patch would force its way
through?

Also, this patch will break the "atomic replace livepatch" kselftest in
test-livepatch.sh [1].  I think it would need to drop the `unload_lp
$MOD_LIVEPATCH` command, the following 'live patched' greps and their
corresponding dmesg output in the test's final check_result() call.

--
Joe


