Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C26D8473F23
	for <lists+live-patching@lfdr.de>; Tue, 14 Dec 2021 10:17:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230281AbhLNJRK (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 14 Dec 2021 04:17:10 -0500
Received: from smtp-out1.suse.de ([195.135.220.28]:45774 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230237AbhLNJRJ (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 14 Dec 2021 04:17:09 -0500
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 856EE210F4;
        Tue, 14 Dec 2021 09:17:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1639473428; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Ivw9qYVEpxgMLOl5vZw4EUJzZKYIGofZTWq+pmcd9LE=;
        b=NMGbtb15X5PXra/VG5vX9DEqP1P2JCgFbrqPw/vjTSA1HBbLzVkwgyA7g+XJAMkQXgvQGs
        2DNw5RkGoffFH6j8Z5sYt+/5eMvGLmkVvjQLBmLKZVpTTtmPeMbgPctA8lYDxKtSM1tzs8
        gs6XG8LTVgAw2QQ42PZiIEQ0Na9apVw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1639473428;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Ivw9qYVEpxgMLOl5vZw4EUJzZKYIGofZTWq+pmcd9LE=;
        b=1p8nYBsOaMl9dZUQjiaKOSNl4jIVs8VQv6Y3ywMrBQP5kwyRxtXguwlYYp8DG3kQinXMp9
        JrV7YBrgeprjTEBg==
Received: from pobox.suse.cz (pobox.suse.cz [10.100.2.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 3B944A3B85;
        Tue, 14 Dec 2021 09:17:08 +0000 (UTC)
Date:   Tue, 14 Dec 2021 10:17:08 +0100 (CET)
From:   Miroslav Benes <mbenes@suse.cz>
To:     Petr Mladek <pmladek@suse.com>
cc:     David Vernet <void@manifault.com>, linux-doc@vger.kernel.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        jpoimboe@redhat.com, jikos@kernel.org, joe.lawrence@redhat.com,
        corbet@lwn.net, yhs@fb.com, songliubraving@fb.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] livepatch: Fix leak on klp_init_patch_early failure
 path
In-Reply-To: <YbhZwVocHDX9ZBAc@alley>
Message-ID: <alpine.LSU.2.21.2112141012090.20187@pobox.suse.cz>
References: <20211213191734.3238783-1-void@manifault.com> <YbhZwVocHDX9ZBAc@alley>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue, 14 Dec 2021, Petr Mladek wrote:

> On Mon 2021-12-13 11:17:35, David Vernet wrote:
> > When enabling a KLP patch with `klp_enable_patch`, we invoke
> > `klp_init_patch_early` to initialize the kobjects for the patch itself, as
> > well as the `struct klp_object*`'s and `struct klp_func*`'s that comprise
> > it. However, there are some paths where we may fail to do an
> > early-initialization of an object or its functions if certain conditions
> > are not met, such as an object having a `NULL` funcs pointer. In these
> > paths, we may currently leak the `struct klp_patch*`'s kobject, as well as
> > any of its objects or functions, as we don't free the patch in
> > `klp_enable_patch` if `klp_init_patch_early` returns an error code.
> 
> Could you please explain what exactly are we leaking?

It would help to share warning outputs (or whatever) from DEBUG_KOBJECTS.
 
> I do not see anything allocated in klp_init_*_early() functions.
> Also I do not see anything allocated in kobject_init().
> 
> Documentation/core-api/kobject.rst says that kobject_put() must be
> used after calling kobject_add():
> 
>    "Once you registered your kobject via kobject_add(), you must never use
>     kfree() to free it directly. The only safe way is to use kobject_put(). It
>     is good practice to always use kobject_put() after kobject_init() to avoid
>     errors creeping in."
> 
> 
> Hmm, the comment in lib/kobject.c says something else:
> 
> /**
>  * kobject_init() - Initialize a kobject structure.
>  * @kobj: pointer to the kobject to initialize
>  * @ktype: pointer to the ktype for this kobject.
>  *
>  * This function will properly initialize a kobject such that it can then
>  * be passed to the kobject_add() call.
>  *
>  * After this function is called, the kobject MUST be cleaned up by a call
>  * to kobject_put(), not by a call to kfree directly to ensure that all of
>  * the memory is cleaned up properly.
>  */
> 
> I believe that this comment is misleading. IMHO, kobject_init() allows
> to call kobject_put(). And it might be used to free memory that has
> already been allocated when initializing the structure where this
> kobject is bundled. But simple free() is perfectly fine when nothing
> else was allocated.

I think that this might be, once again, a false positive. We use kobjects 
differently than what the kobject implementation and its documentation 
assume. So not doing anything after kobject_init() and kobject_add() in 
_init_early stages could be perfectly fine. DEBUG_KOBJECTS output would be 
really welcome.

And if it is not a false positive, we should implement some rollback for 
processed klp_funcs and klp_objects if an error happens. It is not only 
klp_patch kobject affected.

Regards
Miroslav
