Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 144D9473E86
	for <lists+live-patching@lfdr.de>; Tue, 14 Dec 2021 09:45:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229927AbhLNIpz (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 14 Dec 2021 03:45:55 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:52580 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229900AbhLNIpy (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 14 Dec 2021 03:45:54 -0500
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 926331F3C4;
        Tue, 14 Dec 2021 08:45:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1639471553; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=KC3U22DzbacwmZdmAA1sCGT4OyJVZTtDTJeYsTlHINU=;
        b=MurGcDF42ChRf4C2B+i1/vZna/QaL8U3bG22DY2G/ydSLfRo2I5tBcEmNu1/qcpAv4qus8
        9NRAardkj0C9dNsu6kCmGlabZD8nOh3CYyCswwD7CJpJCMZp6ZFvQx2387syW7XND9u0h1
        kIs9h5Mz4WfRVTWmY7QcbFok0qdWIRc=
Received: from suse.cz (unknown [10.100.224.162])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 55650A3B84;
        Tue, 14 Dec 2021 08:45:53 +0000 (UTC)
Date:   Tue, 14 Dec 2021 09:45:53 +0100
From:   Petr Mladek <pmladek@suse.com>
To:     David Vernet <void@manifault.com>
Cc:     linux-doc@vger.kernel.org, live-patching@vger.kernel.org,
        linux-kernel@vger.kernel.org, jpoimboe@redhat.com,
        jikos@kernel.org, mbenes@suse.cz, joe.lawrence@redhat.com,
        corbet@lwn.net, yhs@fb.com, songliubraving@fb.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] livepatch: Fix leak on klp_init_patch_early failure path
Message-ID: <YbhZwVocHDX9ZBAc@alley>
References: <20211213191734.3238783-1-void@manifault.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211213191734.3238783-1-void@manifault.com>
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Mon 2021-12-13 11:17:35, David Vernet wrote:
> When enabling a KLP patch with `klp_enable_patch`, we invoke
> `klp_init_patch_early` to initialize the kobjects for the patch itself, as
> well as the `struct klp_object*`'s and `struct klp_func*`'s that comprise
> it. However, there are some paths where we may fail to do an
> early-initialization of an object or its functions if certain conditions
> are not met, such as an object having a `NULL` funcs pointer. In these
> paths, we may currently leak the `struct klp_patch*`'s kobject, as well as
> any of its objects or functions, as we don't free the patch in
> `klp_enable_patch` if `klp_init_patch_early` returns an error code.

Could you please explain what exactly are we leaking?

I do not see anything allocated in klp_init_*_early() functions.
Also I do not see anything allocated in kobject_init().

Documentation/core-api/kobject.rst says that kobject_put() must be
used after calling kobject_add():

   "Once you registered your kobject via kobject_add(), you must never use
    kfree() to free it directly. The only safe way is to use kobject_put(). It
    is good practice to always use kobject_put() after kobject_init() to avoid
    errors creeping in."


Hmm, the comment in lib/kobject.c says something else:

/**
 * kobject_init() - Initialize a kobject structure.
 * @kobj: pointer to the kobject to initialize
 * @ktype: pointer to the ktype for this kobject.
 *
 * This function will properly initialize a kobject such that it can then
 * be passed to the kobject_add() call.
 *
 * After this function is called, the kobject MUST be cleaned up by a call
 * to kobject_put(), not by a call to kfree directly to ensure that all of
 * the memory is cleaned up properly.
 */

I believe that this comment is misleading. IMHO, kobject_init() allows
to call kobject_put(). And it might be used to free memory that has
already been allocated when initializing the structure where this
kobject is bundled. But simple free() is perfectly fine when nothing
else was allocated.

Adding Greg into Cc.

Best Regards,
Petr

> For example, if we added the following object entry to the sample livepatch
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
> ---
>  kernel/livepatch/core.c | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
> 
> diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
> index 335d988bd811..16e96836a825 100644
> --- a/kernel/livepatch/core.c
> +++ b/kernel/livepatch/core.c
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
> -- 
> 2.30.2
