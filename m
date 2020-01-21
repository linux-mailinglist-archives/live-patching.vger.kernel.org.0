Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC876143BFF
	for <lists+live-patching@lfdr.de>; Tue, 21 Jan 2020 12:27:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728741AbgAUL1Y (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 21 Jan 2020 06:27:24 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:21092 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726052AbgAUL1Y (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 21 Jan 2020 06:27:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579606042;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4wLiGpMD42LOuU4kjzIpcVPiYqHbfTqMgURbNbtZMwA=;
        b=iHKF+M55zZdIE3IK9lByl1uM2VYEsEQWETRieAU6Ga2etWtYqVN+FYFYubO34B7PSGgivb
        EA/vOV+W1tnXUt0BenQRikZo2XFAfEA3vOSOSy7cHojXgKEx4MsvaFc0DoIGARsAZjsaEM
        6gSxcOUJ8BWx98tw4O4I3zLkWc2dkW4=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-374-sVUMTJIrOPKPTljhBGl7rQ-1; Tue, 21 Jan 2020 06:27:21 -0500
X-MC-Unique: sVUMTJIrOPKPTljhBGl7rQ-1
Received: by mail-wr1-f72.google.com with SMTP id c6so1164141wrm.18
        for <live-patching@vger.kernel.org>; Tue, 21 Jan 2020 03:27:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4wLiGpMD42LOuU4kjzIpcVPiYqHbfTqMgURbNbtZMwA=;
        b=CdRV4s5RyJFxnYC1oOwadsj++EX+qusuCEI3y7Ljg7yM6bbxkx8VXo+1NuY46rROEt
         jDNt5ei7gOVxPKd8coLRYcvh+hOSxyXQwmr7KRWeB6g6tvwZELGAWdd1b18z+CADFPDM
         nHW0kD8WRZm840eWu9E8jrUEFzRFvM4+Gd0RWBP/T6f4bw/XGGjYBn/ftRQ1yGQHORB/
         tAj+wWYW0L6jcXTI8MwUKQuoMtxrTPNsoUVgfD9KYCXn0lrGrivdaYVU9wv/e3cR/4qN
         K2I9ZdSXyFH1cdBffwSZzEAxPDVxP1ZEEzJIV6tw3h9TsMNjKw3sOB9632ZrTiQAt74Q
         my8A==
X-Gm-Message-State: APjAAAXi7glohQQDqMqF+bwodIk9nvHw1/0r9t0YyrLM1YJ7s0ZnPjEz
        7MVbJb7CCk5xiBfGRnCBfsqNMAz5QsPjUyidywzML3FN0Ws3W/3V1jSZnYSsMt9gJAnDKhhQswA
        CYVPJXFHhp70/zXhGo0rpUyey4w==
X-Received: by 2002:a5d:620b:: with SMTP id y11mr4699933wru.230.1579606039807;
        Tue, 21 Jan 2020 03:27:19 -0800 (PST)
X-Google-Smtp-Source: APXvYqwzYu8JVEWTNn9Ir2TT0p2JoqpSNxpMZYoGI1bRoT37e/sljDk8LeKuy40yzk+swjn3q2vw3A==
X-Received: by 2002:a5d:620b:: with SMTP id y11mr4699903wru.230.1579606039565;
        Tue, 21 Jan 2020 03:27:19 -0800 (PST)
Received: from [192.168.1.81] (host81-140-166-164.range81-140.btcentralplus.com. [81.140.166.164])
        by smtp.gmail.com with ESMTPSA id p15sm3329320wma.40.2020.01.21.03.27.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Jan 2020 03:27:19 -0800 (PST)
Subject: Re: [POC 03/23] livepatch: Better checks of struct klp_object
 definition
To:     Petr Mladek <pmladek@suse.com>, Jiri Kosina <jikos@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Miroslav Benes <mbenes@suse.cz>
Cc:     Joe Lawrence <joe.lawrence@redhat.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Nicolai Stange <nstange@suse.de>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200117150323.21801-1-pmladek@suse.com>
 <20200117150323.21801-4-pmladek@suse.com>
From:   Julien Thierry <jthierry@redhat.com>
Message-ID: <a5327513-a208-a3c1-cbff-5e978a21b230@redhat.com>
Date:   Tue, 21 Jan 2020 11:27:17 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <20200117150323.21801-4-pmladek@suse.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Hi Petr,

On 1/17/20 3:03 PM, Petr Mladek wrote:
> The number of user defined fields increased in struct klp_object after
> spliting per-object livepatches. It was sometimes unclear why exactly
> the module could not get loded when returned -EINVAL.
> 
> Add more checks for the split modules and write useful error
> messages on particular errors.
> 
> Signed-off-by: Petr Mladek <pmladek@suse.com>
> ---
>   kernel/livepatch/core.c | 91 ++++++++++++++++++++++++++++++++++++++++++++-----
>   1 file changed, 82 insertions(+), 9 deletions(-)
> 
> diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
> index bb62c5407b75..ec7ffc7db3a7 100644
> --- a/kernel/livepatch/core.c
> +++ b/kernel/livepatch/core.c
> @@ -756,9 +756,6 @@ static int klp_init_object(struct klp_patch *patch, struct klp_object *obj)
>   	int ret;
>   	const char *name;
>   
> -	if (klp_is_module(obj) && strlen(obj->name) >= MODULE_NAME_LEN)
> -		return -EINVAL;
> -
>   	obj->patched = false;
>   
>   	name = obj->name ? obj->name : "vmlinux";
> @@ -851,8 +848,86 @@ static int klp_init_patch(struct klp_patch *patch)
>   	return 0;
>   }
>   
> +static int klp_check_module_name(struct klp_object *obj, bool is_module)
> +{
> +	char mod_name[MODULE_NAME_LEN];
> +	const char *expected_name;
> +
> +	if (is_module) {
> +		snprintf(mod_name, sizeof(mod_name), "%s__%s",
> +			 obj->patch_name, obj->name);
> +		expected_name = mod_name;
> +	} else {
> +		expected_name = obj->patch_name;
> +	}
> +
> +	if (strcmp(expected_name, obj->mod->name)) {

I'm not sure I understand the point of enforcing this.

> +		pr_err("The module name %s does not match with obj->patch_name and obj->name. The expected name is: %s\n",
> +		       obj->mod->name, expected_name);
> +		return -EINVAL;
> +	}
> +
> +	return 0;
> +}
> +
> +static int klp_check_object(struct klp_object *obj, bool is_module)
> +{
> +
> +	if (!obj->mod)
> +		return -EINVAL;
> +
> +	if (!is_livepatch_module(obj->mod)) {
> +		pr_err("module %s is not marked as a livepatch module\n",
> +		       obj->mod->name);
> +		return -EINVAL;
> +	}
> +
> +	if (!obj->patch_name) {
> +		pr_err("module %s does not have set obj->patch_name\n",
> +		       obj->mod->name);
> +		return -EINVAL;
> +	}
> +
> +	if (strlen(obj->patch_name) >= MODULE_NAME_LEN) {
> +		pr_err("module %s has too long obj->patch_name\n",
> +		       obj->mod->name);
> +		return -EINVAL;
> +	}
> +
> +	if (is_module) {
> +		if (!obj->name) {
> +			pr_err("module %s does not have set obj->name\n",
> +			       obj->mod->name);
> +			return -EINVAL;
> +		}
> +		if (strlen(obj->name) >= MODULE_NAME_LEN) {
> +			pr_err("module %s has too long obj->name\n",
> +			       obj->mod->name);
> +			return -EINVAL;
> +		}
> +	} else if (obj->name) {
> +		pr_err("module %s for vmlinux must not have set obj->name\n",
> +		       obj->mod->name);
> +		return -EINVAL;
> +	}
> +
> +	if (!obj->funcs) {
> +		pr_err("module %s does not have set obj->funcs\n",
> +		       obj->mod->name);
> +		return -EINVAL;
> +	}
> +
> +	return klp_check_module_name(obj, is_module);
> +}
> +
>   int klp_add_object(struct klp_object *obj)
>   {
> +	int ret;
> +
> +	ret = klp_check_object(obj, true);
> +	if (ret)
> +		return ret;
> +
>   	return 0;
>   }
>   EXPORT_SYMBOL_GPL(klp_add_object);
> @@ -958,14 +1033,12 @@ int klp_enable_patch(struct klp_patch *patch)
>   {
>   	int ret;
>   
> -	if (!patch || !patch->obj || !patch->obj->mod)
> +	if (!patch || !patch->obj)
>   		return -EINVAL;
>   
> -	if (!is_livepatch_module(patch->obj->mod)) {
> -		pr_err("module %s is not marked as a livepatch module\n",
> -		       patch->obj->patch_name);
> -		return -EINVAL;
> -	}
> +	ret = klp_check_object(patch->obj, false);
> +	if (ret)
> +		return ret;
>   
>   	if (!klp_initialized())
>   		return -ENODEV;
> 

Otherwise this looks good to me.

Cheers,

-- 
Julien Thierry

