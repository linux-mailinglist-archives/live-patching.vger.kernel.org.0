Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08A5747359F
	for <lists+live-patching@lfdr.de>; Mon, 13 Dec 2021 21:10:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231971AbhLMUKi (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 13 Dec 2021 15:10:38 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:38085 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240824AbhLMUKh (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 13 Dec 2021 15:10:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639426234;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=98410SCY73aKt24LcVMxqvWF7akIYNbHy7o+glUPBM4=;
        b=OzwV7bFo4v4wATHPGsIlTxR5B5IRfUn+LOCMciFkwRDMFmGIV9/JM8bh8cX8jPjhNXT/XC
        0P9ArqMnUP7wY79T/pTBScGw47YCdqiZELP9OTM0tAv7SsSecaQIL1K49UqoR5PkOQTiPa
        qxkPBGZyS/xpgMbAR6xTrWWJkipApeE=
Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com
 [209.85.167.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-420-iq7iBg53PciWJcK38lzmZA-1; Mon, 13 Dec 2021 15:10:33 -0500
X-MC-Unique: iq7iBg53PciWJcK38lzmZA-1
Received: by mail-oi1-f198.google.com with SMTP id s37-20020a05680820a500b002bcbae866f9so11549009oiw.6
        for <live-patching@vger.kernel.org>; Mon, 13 Dec 2021 12:10:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=98410SCY73aKt24LcVMxqvWF7akIYNbHy7o+glUPBM4=;
        b=Tqy6wqDlRk+d9iestT6VxUkPP7ZlYfoQUZs+isR9tj1vK9oZGRg2fgjhxf1Ks4QSwd
         w1riGxG7dmU+v8Sv+i4CCQbaqIaUtRLQbI5j8dthfg3VTbVUIJCNsLtRKcoUn6Eo07Zc
         GvFfUf3D7aitEwBVeoJgPC0/oySLGf/Kp9OETqHT478b72yK2ybrMSrbOZwpy32gSXdf
         a+Kxb5L9HRZ9Ke5/gEiUg1Qh5b756aIC3r+iqVC8HStPqdHlqr6UvEvsn7L7BKJ2/+D6
         XN52uDLLj7+gQCRCvqtscfkkFbbcx6Pcbc/HXvgzdDd2ADoZG5axTE0iPOv3tPIZOSW1
         zb0A==
X-Gm-Message-State: AOAM530sOKo92d/f1b0kttmrOyG/AcCnZbIrav2juhLjJhmtl9GfI6pv
        sM4OZ+9TIz0O3gZ5T6m3ChnaQVNcx27voF7+VUCbStlixq+ONUHj1kRpvMFuIgwRVu1A0UJY9LK
        IgqX440+AKSkby1ak8IVlwN4yFA==
X-Received: by 2002:a4a:d184:: with SMTP id j4mr448483oor.72.1639426226196;
        Mon, 13 Dec 2021 12:10:26 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzdF5hmqnDtiL8k0ufA6KXBZMr+XhxgtNNHlmdJ9hKuUpIpa3M2DrnM0v+LSkj9mIo3zup2qw==
X-Received: by 2002:a4a:d184:: with SMTP id j4mr448461oor.72.1639426225935;
        Mon, 13 Dec 2021 12:10:25 -0800 (PST)
Received: from treble ([2600:1700:6e32:6c00::49])
        by smtp.gmail.com with ESMTPSA id h14sm2392996ots.22.2021.12.13.12.10.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Dec 2021 12:10:25 -0800 (PST)
Date:   Mon, 13 Dec 2021 12:10:22 -0800
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     David Vernet <void@manifault.com>
Cc:     pmladek@suse.com, linux-doc@vger.kernel.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        jikos@kernel.org, mbenes@suse.cz, joe.lawrence@redhat.com,
        corbet@lwn.net, yhs@fb.com, songliubraving@fb.com
Subject: Re: [PATCH] livepatch: Fix leak on klp_init_patch_early failure path
Message-ID: <20211213201022.dhalhtc2bpey55gh@treble>
References: <20211213191734.3238783-1-void@manifault.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20211213191734.3238783-1-void@manifault.com>
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Mon, Dec 13, 2021 at 11:17:35AM -0800, David Vernet wrote:
> When enabling a KLP patch with `klp_enable_patch`, we invoke
> `klp_init_patch_early` to initialize the kobjects for the patch itself, as
> well as the `struct klp_object*`'s and `struct klp_func*`'s that comprise
> it. However, there are some paths where we may fail to do an
> early-initialization of an object or its functions if certain conditions
> are not met, such as an object having a `NULL` funcs pointer. In these
> paths, we may currently leak the `struct klp_patch*`'s kobject, as well as
> any of its objects or functions, as we don't free the patch in
> `klp_enable_patch` if `klp_init_patch_early` returns an error code. For
> example, if we added the following object entry to the sample livepatch
> code, it would cause us to leak the vmlinux `klp_object`, and its `struct
> klp_func` which updates `cmdline_proc_show`:
> 
> ```
> static struct klp_object objs[] = {
>         {
>                 .name = "kvm",
>         }, { }
> };
> ```
> 
> Without this change, if we enable `CONFIG_DEBUG_KOBJECT` and try to `kpatch
> load livepatch-sample.ko`, we don't observe the kobjects being released
> (though of course we do observe `insmod` failing to insert the module).
> With the change, we do observe that the `kobject` for the patch and its
> `vmlinux` object are released.
> 
> Signed-off-by: David Vernet <void@manifault.com>

Thanks for reporting the issue and submitting the patch!

The patch description needs a few tweaks.  In the kernel we don't use
Markdown for patch descriptions.

A function can be postfixed with a trailing pair of parentheses, like
klp_enable_patch().

Other symbols can be enclosed with single quotes, like 'struct
klp_object'.

I'd also recommend avoiding the excessive use of "we", in favor of more
imperative-type language.

See Documentation/process/submitting-patches.rst for more details.  It's
also a good idea to look at some kernel commit logs to get a general
idea of the kernel patch description style.

> @@ -1052,10 +1052,7 @@ int klp_enable_patch(struct klp_patch *patch)
>  	}
>  
>  	ret = klp_init_patch_early(patch);
> -	if (ret) {
> -		mutex_unlock(&klp_mutex);
> -		return ret;
> -	}
> +		goto err;
>  
>  	ret = klp_init_patch(patch);
>  	if (ret)

I don't think the fix will be quite that simple.  For example, if
klp_init_patch_early() fails, that means try_module_get() hasn't been
done, so klp_free_patch_finish() will wrongly do a module_put().

-- 
Josh

