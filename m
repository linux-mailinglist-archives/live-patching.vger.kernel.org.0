Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 166BA143C64
	for <lists+live-patching@lfdr.de>; Tue, 21 Jan 2020 12:58:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728797AbgAUL66 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 21 Jan 2020 06:58:58 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:55471 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726052AbgAUL66 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 21 Jan 2020 06:58:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579607937;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mIJRmUS3RoI/eRku0oSveKGJeOaZOoTBV3XTY86CXrI=;
        b=ALh8zseSdE6nbbELjiOUcxEq40PzpOoXm5TQtOW2EgJuUIZ+/m6N5eJmL6vXbMxCrYD9Ww
        nsMMpdGUkVEJz86CmpFioq32NCK2U0086d4zU6WXVh+BYfL1OYd4IUezJBqm1gVvw7cgqm
        79FT0wB8Bqu+j9+JIMIrWK01jA2ppKY=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-213-ZEEjfg0JNr2LCfgaGN6WdA-1; Tue, 21 Jan 2020 06:58:56 -0500
X-MC-Unique: ZEEjfg0JNr2LCfgaGN6WdA-1
Received: by mail-wm1-f72.google.com with SMTP id b9so525339wmj.6
        for <live-patching@vger.kernel.org>; Tue, 21 Jan 2020 03:58:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=mIJRmUS3RoI/eRku0oSveKGJeOaZOoTBV3XTY86CXrI=;
        b=WlB2+QSW6lwWgHDGlDMXseVYQLjg8gbQCwpD49dMdsUXGfvm9j5Yq9bveH41cAVJ1Z
         P1maNrk60qO2I/vaqqA7JNhz02srqY6vHL87E9X7X//Y5bUfOKzTalhWWcOTq307LUNl
         y2H9Bbt0k1JzlVHM7O0pwAup4+ckKfi3ji5lXlrChVN3IQam5B64zVe1o0RzItQEIfAc
         FoW6BhK+ZEYRqAD6kST81v9+fM/WEK4FOEaBQmG8b4EwtC31u/9kQr+atrqI3UEx7e+b
         YrIocE7vhQluAJ6u/AZ8LYPdtQjcuA9KeeYzFuy3msrEnydiEti1qFY2NcO5zR4WXHPl
         dEqA==
X-Gm-Message-State: APjAAAUIBz9NqK9nPz/hCzmUM1SM1nkW36Nr83aEvmuCmSeHMHNbng0F
        XkYM0LmVOYEttFVYBSMTFBq2iG2vZKPbkRUYf0V/raDadu4iZPV8VRSVluphHaCuGH8rElBENHL
        +ClqnYiYMq+E4ZkIRFjz18dOD5A==
X-Received: by 2002:a1c:a9c6:: with SMTP id s189mr4079717wme.151.1579607935021;
        Tue, 21 Jan 2020 03:58:55 -0800 (PST)
X-Google-Smtp-Source: APXvYqy1OprcTDbiQO/QR6z0+OgYBrUc82Dc0O0g2xxJa107E1VFaHvFSIoh4166ZrRF0PqTnsAc4Q==
X-Received: by 2002:a1c:a9c6:: with SMTP id s189mr4079700wme.151.1579607934843;
        Tue, 21 Jan 2020 03:58:54 -0800 (PST)
Received: from [192.168.1.81] (host81-140-166-164.range81-140.btcentralplus.com. [81.140.166.164])
        by smtp.gmail.com with ESMTPSA id x11sm53508323wre.68.2020.01.21.03.58.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Jan 2020 03:58:54 -0800 (PST)
Subject: Re: [POC 05/23] livepatch: Initialize and free livepatch submodule
To:     Petr Mladek <pmladek@suse.com>, Jiri Kosina <jikos@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Miroslav Benes <mbenes@suse.cz>
Cc:     Joe Lawrence <joe.lawrence@redhat.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Nicolai Stange <nstange@suse.de>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200117150323.21801-1-pmladek@suse.com>
 <20200117150323.21801-6-pmladek@suse.com>
From:   Julien Thierry <jthierry@redhat.com>
Message-ID: <0cc056a0-99c7-68d6-9f22-28c043254ab2@redhat.com>
Date:   Tue, 21 Jan 2020 11:58:53 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <20200117150323.21801-6-pmladek@suse.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Hi Petr,

On 1/17/20 3:03 PM, Petr Mladek wrote:
> Another step when loading livepatches to livepatch modules is
> to initialize the structure, create sysfs entries, do livepatch
> specific relocations.
> 
> These operation can fail and the objects must be freed that case.
> The error message is taken from klp_module_coming() to match
> selftests.
> 
> Signed-off-by: Petr Mladek <pmladek@suse.com>
> ---
>   kernel/livepatch/core.c | 34 +++++++++++++++++++++++++++-------
>   1 file changed, 27 insertions(+), 7 deletions(-)
> 
> diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
> index e2c7dc6c2d5f..6c27b635e5a7 100644
> --- a/kernel/livepatch/core.c
> +++ b/kernel/livepatch/core.c
> @@ -583,18 +583,23 @@ static void klp_free_object_loaded(struct klp_object *obj)
>   	}
>   }
>   
> +static void klp_free_object(struct klp_object *obj, bool nops_only)
> +{
> +	__klp_free_funcs(obj, nops_only);
> +
> +	if (nops_only && !obj->dynamic)
> +		return;
> +
> +	list_del(&obj->node);
> +	kobject_put(&obj->kobj);
> +}
> +
>   static void __klp_free_objects(struct klp_patch *patch, bool nops_only)
>   {
>   	struct klp_object *obj, *tmp_obj;
>   
>   	klp_for_each_object_safe(patch, obj, tmp_obj) {
> -		__klp_free_funcs(obj, nops_only);
> -
> -		if (nops_only && !obj->dynamic)
> -			continue;
> -
> -		list_del(&obj->node);
> -		kobject_put(&obj->kobj);
> +		klp_free_object(obj, nops_only);
>   	}
>   }
>   
> @@ -812,6 +817,8 @@ static int klp_init_object_early(struct klp_patch *patch,
>   	if (obj->dynamic || try_module_get(obj->mod))
>   		return 0;
>   
> +	/* patch stays when this function fails in klp_add_object() */
> +	list_del(&obj->node);
>   	return -ENODEV;
>   }
>   
> @@ -993,9 +1000,22 @@ int klp_add_object(struct klp_object *obj)
>   		goto err;
>   	}
>   
> +	ret = klp_init_object_early(patch, obj);

klp_init_object_early() can fail after adding obj to patch->obj_list. 
This wouldn't get cleaned up by the "err" path.

It probably would keep things simple to only add obj to patch->obj_list 
if early initialization is successful in patch 2 (ofc I'm talking about 
the actual patch of this patch series ;) ).

> +	if (ret)
> +		goto err;
> +
> +	ret = klp_init_object(patch, obj);
> +	if (ret) {
> +		pr_warn("failed to initialize patch '%s' for module '%s' (%d)\n",
> +			patch->obj->patch_name, obj->name, ret);
> +		goto err_free;
> +	}
> +
>   	mutex_unlock(&klp_mutex);
>   	return 0;
>   
> +err_free:
> +	klp_free_object(obj, false);
>   err:
>   	/*
>   	 * If a patch is unsuccessfully applied, return
> 

Cheers,

-- 
Julien Thierry

