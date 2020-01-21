Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 983F8143BC3
	for <lists+live-patching@lfdr.de>; Tue, 21 Jan 2020 12:11:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728748AbgAULLo (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 21 Jan 2020 06:11:44 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:27695 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726473AbgAULLo (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 21 Jan 2020 06:11:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579605103;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nCBKi9+PmsfMFoDzW4j7ikn7z/mWHYKyl43DcMVv+RE=;
        b=G4UsE3byRBNQsJxXHugSpcn80fux740HaZB6hNPj1Sdt33AO/EDypXryCY2hW5H8gp3qkp
        dY2NUmTMr3lCCLA7G940M7Op4Ta3lFdhOQAJ/dJ6wIm1h1vQZ78S0RUaxuLWFF+53gakWE
        Jn90nIjlOExIjmc1lYsR6T21c2the5U=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-101-0cPIuqYqMk-yS-sZZa9wUA-1; Tue, 21 Jan 2020 06:11:42 -0500
X-MC-Unique: 0cPIuqYqMk-yS-sZZa9wUA-1
Received: by mail-wm1-f71.google.com with SMTP id 18so480051wmp.0
        for <live-patching@vger.kernel.org>; Tue, 21 Jan 2020 03:11:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nCBKi9+PmsfMFoDzW4j7ikn7z/mWHYKyl43DcMVv+RE=;
        b=hAr7l5/ArQ4JthqOeozThiXlFQmez+VxlLeHougvBCxEHc/dduEwnt8wETU9AM01fN
         mw+OA9H63BIDSNl8BTUgqSpy1zeIY5twuRBHT+sH9QEkUO13eKQnIqy35mRGS/rEUzk5
         Fu1oR+20b6Ah1Zn3j5CW2VDAUg7lwSRS8ucgkKlywuDiB169Ff3e4tq9z6eVQrSEbiBK
         R/gSwH3cmgP84xuzAyRxI4cAYD33m5QFzUk9N73jU2YoOEhYRsfNe2mGCBnSPIGFjCk4
         jiFAqq2Rjrksm5+KI8BEUFG/SbIzTRZrhRuyWmv7fnHj7eCs3VdErnrST3lbSFnRVRJE
         ppYw==
X-Gm-Message-State: APjAAAXu4PNlIzbvoSQkk6i5AoI7k4BTP64i7xS4qwWdfxW9YasYLiKM
        xXK7y/J/dIrpujsGqR8Jlm/Q2vymX+gBwYnWwN6rf3XOonKK4rxBuETp+gZ6KnGyBKQr+A7PFju
        A/ykbBIlWKqBHYMmBIe2kfmCbOw==
X-Received: by 2002:a5d:4fd0:: with SMTP id h16mr4767403wrw.255.1579605101037;
        Tue, 21 Jan 2020 03:11:41 -0800 (PST)
X-Google-Smtp-Source: APXvYqygGE3nl4UgJqtbPQRpE2XRkD3JsXD4jzW9q3NxWhQM9wnKJ7bY/+s8odMR38pb826P6N5mNQ==
X-Received: by 2002:a5d:4fd0:: with SMTP id h16mr4767377wrw.255.1579605100718;
        Tue, 21 Jan 2020 03:11:40 -0800 (PST)
Received: from [192.168.1.81] (host81-140-166-164.range81-140.btcentralplus.com. [81.140.166.164])
        by smtp.gmail.com with ESMTPSA id w8sm4228305wmd.2.2020.01.21.03.11.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Jan 2020 03:11:40 -0800 (PST)
From:   Julien Thierry <jthierry@redhat.com>
Subject: Re: [POC 01/23] module: Allow to delete module also from inside
 kernel
To:     Petr Mladek <pmladek@suse.com>, Jiri Kosina <jikos@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Miroslav Benes <mbenes@suse.cz>
Cc:     Joe Lawrence <joe.lawrence@redhat.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Nicolai Stange <nstange@suse.de>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200117150323.21801-1-pmladek@suse.com>
 <20200117150323.21801-2-pmladek@suse.com>
Message-ID: <74863d91-9515-ce9b-2ac2-ad1e9c777163@redhat.com>
Date:   Tue, 21 Jan 2020 11:11:38 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <20200117150323.21801-2-pmladek@suse.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Hi Petr,

On 1/17/20 3:03 PM, Petr Mladek wrote:
> Livepatch subsystems will need to automatically load and delete
> livepatch module when the livepatched one is being removed
> or when the entire livepatch is being removed.
> 
> The code stopping the kernel module is moved to separate function
> so that it can be reused.
> 
> The function always have rights to do the action. Also it does not
> need to search for struct module because it is already passed as
> a parameter.
> 
> On the other hand, it has to make sure that the given struct module
> can't be released in parallel. It is achieved by combining module_put()
> and module_delete() functionality in a single function.
> 
> This patch does not change the existing behavior of delete_module
> syscall.
> 
> Signed-off-by: Petr Mladek <pmladek@suse.com>
> 
> module: Add module_put_and_delete()
> ---
>   include/linux/module.h |   5 +++
>   kernel/module.c        | 119 +++++++++++++++++++++++++++++++------------------
>   2 files changed, 80 insertions(+), 44 deletions(-)
> 
> diff --git a/include/linux/module.h b/include/linux/module.h
> index bd165ba68617..f69f3fd72dd5 100644
> --- a/include/linux/module.h
> +++ b/include/linux/module.h
> @@ -623,6 +623,7 @@ extern void __module_get(struct module *module);
>   extern bool try_module_get(struct module *module);
>   
>   extern void module_put(struct module *module);
> +extern int module_put_and_delete(struct module *mod);
>   
>   #else /*!CONFIG_MODULE_UNLOAD*/
>   static inline bool try_module_get(struct module *module)
> @@ -632,6 +633,10 @@ static inline bool try_module_get(struct module *module)
>   static inline void module_put(struct module *module)
>   {
>   }
> +static inline int module_put_and_delete(struct module *mod)
> +{
> +	return 0;
> +}
>   static inline void __module_get(struct module *module)
>   {
>   }
> diff --git a/kernel/module.c b/kernel/module.c
> index b56f3224b161..b3f11524f8f9 100644
> --- a/kernel/module.c
> +++ b/kernel/module.c
> @@ -964,62 +964,36 @@ EXPORT_SYMBOL(module_refcount);
>   /* This exists whether we can unload or not */
>   static void free_module(struct module *mod);
>   
> -SYSCALL_DEFINE2(delete_module, const char __user *, name_user,
> -		unsigned int, flags)
> +int stop_module(struct module *mod, int flags)
>   {
> -	struct module *mod;
> -	char name[MODULE_NAME_LEN];
> -	int ret, forced = 0;
> -
> -	if (!capable(CAP_SYS_MODULE) || modules_disabled)
> -		return -EPERM;
> -
> -	if (strncpy_from_user(name, name_user, MODULE_NAME_LEN-1) < 0)
> -		return -EFAULT;
> -	name[MODULE_NAME_LEN-1] = '\0';
> +	int forced = 0;
>   
> -	audit_log_kern_module(name);
> -
> -	if (mutex_lock_interruptible(&module_mutex) != 0)
> -		return -EINTR;
> -
> -	mod = find_module(name);
> -	if (!mod) {
> -		ret = -ENOENT;
> -		goto out;
> -	}
> -
> -	if (!list_empty(&mod->source_list)) {
> -		/* Other modules depend on us: get rid of them first. */
> -		ret = -EWOULDBLOCK;
> -		goto out;
> -	}
> +	/* Other modules depend on us: get rid of them first. */
> +	if (!list_empty(&mod->source_list))
> +		return -EWOULDBLOCK;
>   
>   	/* Doing init or already dying? */
>   	if (mod->state != MODULE_STATE_LIVE) {
>   		/* FIXME: if (force), slam module count damn the torpedoes */
>   		pr_debug("%s already dying\n", mod->name);
> -		ret = -EBUSY;
> -		goto out;
> +		return -EBUSY;
>   	}
>   
>   	/* If it has an init func, it must have an exit func to unload */
>   	if (mod->init && !mod->exit) {
>   		forced = try_force_unload(flags);
> -		if (!forced) {
> -			/* This module can't be removed */
> -			ret = -EBUSY;
> -			goto out;
> -		}
> +		/* This module can't be removed */
> +		if (!forced)
> +			return -EBUSY;
>   	}
>   
>   	/* Stop the machine so refcounts can't move and disable module. */
> -	ret = try_stop_module(mod, flags, &forced);
> -	if (ret != 0)
> -		goto out;
> +	return try_stop_module(mod, flags, &forced);
> +}
>   
> -	mutex_unlock(&module_mutex);
> -	/* Final destruction now no one is using it. */
> +/* Final destruction now no one is using it. */

Nit: Looks like some copy/paste mixup

> +static void destruct_module(struct module *mod)
> +{
>   	if (mod->exit != NULL)
>   		mod->exit();
>   	blocking_notifier_call_chain(&module_notify_list,
> @@ -1033,8 +1007,44 @@ SYSCALL_DEFINE2(delete_module, const char __user *, name_user,
>   	strlcpy(last_unloaded_module, mod->name, sizeof(last_unloaded_module));
>   
>   	free_module(mod);
> +
>   	/* someone could wait for the module in add_unformed_module() */
>   	wake_up_all(&module_wq);
> +}
> +
> +SYSCALL_DEFINE2(delete_module, const char __user *, name_user,
> +		unsigned int, flags)
> +{
> +	struct module *mod;
> +	char name[MODULE_NAME_LEN];
> +	int ret;
> +
> +	if (!capable(CAP_SYS_MODULE) || modules_disabled)
> +		return -EPERM;
> +
> +	if (strncpy_from_user(name, name_user, MODULE_NAME_LEN-1) < 0)
> +		return -EFAULT;
> +	name[MODULE_NAME_LEN-1] = '\0';
> +
> +	audit_log_kern_module(name);
> +
> +	if (mutex_lock_interruptible(&module_mutex) != 0)
> +		return -EINTR;
> +
> +	mod = find_module(name);
> +	if (!mod) {
> +		ret = -ENOENT;
> +		goto out;
> +	}
> +
> +	ret = stop_module(mod, flags);
> +	if (ret)
> +		goto out;
> +
> +	mutex_unlock(&module_mutex);
> +
> +/* Final destruction now no one is using it. */
> +	destruct_module(mod);
>   	return 0;
>   out:
>   	mutex_unlock(&module_mutex);
> @@ -1138,20 +1148,41 @@ bool try_module_get(struct module *module)
>   }
>   EXPORT_SYMBOL(try_module_get);
>   
> -void module_put(struct module *module)
> +/* Must be called under module_mutex or with preemtion disabled */

Might be worth adding some asserts to check for that.

> +static void __module_put(struct module* module)
>   {
>   	int ret;
>   
> +	ret = atomic_dec_if_positive(&module->refcnt);
> +	WARN_ON(ret < 0);	/* Failed to put refcount */
> +	trace_module_put(module, _RET_IP_);
> +}
> +
> +void module_put(struct module *module)
> +{
>   	if (module) {
>   		preempt_disable();
> -		ret = atomic_dec_if_positive(&module->refcnt);
> -		WARN_ON(ret < 0);	/* Failed to put refcount */
> -		trace_module_put(module, _RET_IP_);
> +		__module_put(module);
>   		preempt_enable();
>   	}
>   }
>   EXPORT_SYMBOL(module_put);
>   
> +int module_put_and_delete(struct module *mod)
> +{
> +	int ret;
> +	mutex_lock(&module_mutex);
> +	__module_put(mod);
> +	ret = stop_module(mod, 0);
> +	mutex_unlock(&module_mutex);
> +
> +	if (ret)
> +		return ret;
> +
> +	destruct_module(mod);
> +	return 0;
> +}
> +
>   #else /* !CONFIG_MODULE_UNLOAD */
>   static inline void print_unload_info(struct seq_file *m, struct module *mod)
>   {
> 

Thanks,

-- 
Julien Thierry

