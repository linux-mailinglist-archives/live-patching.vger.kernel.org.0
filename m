Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E02C4801A1
	for <lists+live-patching@lfdr.de>; Mon, 27 Dec 2021 17:31:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229643AbhL0Qbs (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 27 Dec 2021 11:31:48 -0500
Received: from mail-qt1-f172.google.com ([209.85.160.172]:34748 "EHLO
        mail-qt1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229639AbhL0Qbs (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 27 Dec 2021 11:31:48 -0500
Received: by mail-qt1-f172.google.com with SMTP id o17so13933217qtk.1;
        Mon, 27 Dec 2021 08:31:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=adZ/MWFrQb7lzVY4zAg4F6UnmPFEmR78gsLYD6lzktI=;
        b=YLWYe20+sF/FYmeihB3aCB4pliNprTxtaaBQ8STHkzoRuqkpQ7dRrKZAthJnVfee8k
         6iUtuhY1LALdJyv5IQZIZ1NLlL4uQXoyK16QaOT8sKenpnjnQ4rex5HqyACHbXs5EcoF
         9muhpbbmK+yseeyHtKGg4Oeca3G3XXbD0aLPsAbTOxNunXAwHJOxVG4sw57Dy/tGTvAI
         JAiECkauQhzYv+WesE7nnIuUln1qS+T+Emn1xzJK315wn5ktJxDd0YJvgIKuawPCxsey
         D1GE5J8o70psiP4UG95x1WnDgIpgCRPx1sUlC3N39H4Z61zGrXxWuk2j/8FL3ZphsFw+
         0J9Q==
X-Gm-Message-State: AOAM533njLnBfoRX4KRh69RqXJfz3Y/ZQDquVy9cEpg9xjwnwLWoePqB
        I4IZkhFP889HI+RrNhe5hoA=
X-Google-Smtp-Source: ABdhPJyp7Z89PNVR7Xsxb3/MeV/nmZk6OMc1ir6+jNZh/wHoh3eX7OkOf1xqgNP+cfZsruV+P3wYIw==
X-Received: by 2002:ac8:5796:: with SMTP id v22mr13255937qta.299.1640622707367;
        Mon, 27 Dec 2021 08:31:47 -0800 (PST)
Received: from dev0025.ash9.facebook.com (fwdproxy-ash-022.fbsv.net. [2a03:2880:20ff:16::face:b00c])
        by smtp.gmail.com with ESMTPSA id u6sm14006311qki.129.2021.12.27.08.31.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Dec 2021 08:31:47 -0800 (PST)
Date:   Mon, 27 Dec 2021 08:31:45 -0800
From:   David Vernet <void@manifault.com>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     linux-kernel@vger.kernel.org, live-patching@vger.kernel.org,
        jpoimboe@redhat.com, jikos@kernel.org, mbenes@suse.cz,
        pmladek@suse.com
Subject: Re: [PATCH -next] livepatch: Fix missing unlock on error in
 klp_enable_patch()
Message-ID: <YcnqcXMQ7hxBe68a@dev0025.ash9.facebook.com>
References: <20211225025115.475348-1-yangyingliang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211225025115.475348-1-yangyingliang@huawei.com>
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Yang Yingliang <yangyingliang@huawei.com> wrote on Sat [2021-Dec-25 10:51:15 +0800]:
> Add missing unlock when try_module_get() fails in klp_enable_patch().
> 
> Fixes: bf01c2975925 ("livepatch: Fix kobject refcount bug on klp_init_patch_early failure path")
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> ---
>  kernel/livepatch/core.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
> index 23cf444091a8..01bfab7fe7c0 100644
> --- a/kernel/livepatch/core.c
> +++ b/kernel/livepatch/core.c
> @@ -1047,8 +1047,10 @@ int klp_enable_patch(struct klp_patch *patch)
>  		return -EINVAL;
>  	}
>  
> -	if (!try_module_get(patch->mod))
> +	if (!try_module_get(patch->mod)) {
> +		mutex_unlock(&klp_mutex);
>  		return -ENODEV;
> +	}
>  
>  	klp_init_patch_early(patch);
>  
> -- 
> 2.25.1
> 

Apologies for the silly oversight. Thank you for the fix.

Acked-by: David Vernet <void@manifault.com>
