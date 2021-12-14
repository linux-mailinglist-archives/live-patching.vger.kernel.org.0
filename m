Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06BB64746DC
	for <lists+live-patching@lfdr.de>; Tue, 14 Dec 2021 16:52:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234740AbhLNPws (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 14 Dec 2021 10:52:48 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:57948 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234383AbhLNPwr (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 14 Dec 2021 10:52:47 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id E29F8CE1997;
        Tue, 14 Dec 2021 15:52:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91897C34604;
        Tue, 14 Dec 2021 15:52:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639497164;
        bh=Tp0Z4PeXVqvqfrM0bGNPhLHKolo4FS5DT8mc4cPM5UM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NGH3uGC1SQyyQ+pPgl7XiaJ+0BkmIJsnP5kAXo/iD31v/69WiY2l4e+zcj8MXdO5Q
         QQFKsni/8yXyWsH8moTQtYaB29UU9PgKRzEisTvAz7Ca13wojujxMYpW2LCp0n+c9L
         rEGaE/IYzhmxOreDvdh2PlRgh8ANHCsG3f13toec=
Date:   Tue, 14 Dec 2021 16:52:41 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Petr Mladek <pmladek@suse.com>
Cc:     David Vernet <void@manifault.com>, linux-doc@vger.kernel.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        jpoimboe@redhat.com, jikos@kernel.org, mbenes@suse.cz,
        joe.lawrence@redhat.com, corbet@lwn.net, yhs@fb.com,
        songliubraving@fb.com
Subject: Re: [PATCH] livepatch: Fix leak on klp_init_patch_early failure path
Message-ID: <Ybi9yeEnKqq7HtS5@kroah.com>
References: <20211213191734.3238783-1-void@manifault.com>
 <YbhZwVocHDX9ZBAc@alley>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YbhZwVocHDX9ZBAc@alley>
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Ah, found the thread...

On Tue, Dec 14, 2021 at 09:45:53AM +0100, Petr Mladek wrote:
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
> 
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

These say the same thing as "good practice" == "MUST" here.  You can NOT
call kfree after calling kobject_init().  Bad things will happen if you
try to do so.

> I believe that this comment is misleading. IMHO, kobject_init() allows
> to call kobject_put().

You are FORCED TO call kobject_put() after kobject_init() is called.
Anything else is a bug.

> And it might be used to free memory that has
> already been allocated when initializing the structure where this
> kobject is bundled. But simple free() is perfectly fine when nothing
> else was allocated.

Nope, sorry, you have to call kobject_put().

thanks,

greg k-h
