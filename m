Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98233475BF9
	for <lists+live-patching@lfdr.de>; Wed, 15 Dec 2021 16:41:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243796AbhLOPkl (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 15 Dec 2021 10:40:41 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:52700 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232480AbhLOPkl (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 15 Dec 2021 10:40:41 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B71D8B81FE6;
        Wed, 15 Dec 2021 15:40:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C590C350A1;
        Wed, 15 Dec 2021 15:40:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639582831;
        bh=daFra/it80tNYf8ZnzenMAxIx4uQffBkpSjTHdvk+I0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CMKmCvAYXr4WexuO2xqr1xCQI80kTdjB4OtyVYp/wwMiESpv1eiXDRruCJxm6RAb/
         cwDYin8dT/ic1KIgRihshy+DXKn7v4s92W6S3W6CetMQBS6O4E/FKzQ3K3mATZefBz
         l8SCE4lqVboUt+rqtcZODNCqmStPcIRJb6lC7b80=
Date:   Wed, 15 Dec 2021 16:35:24 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Petr Mladek <pmladek@suse.com>
Cc:     David Vernet <void@manifault.com>, Miroslav Benes <mbenes@suse.cz>,
        linux-doc@vger.kernel.org, live-patching@vger.kernel.org,
        linux-kernel@vger.kernel.org, jpoimboe@redhat.com,
        jikos@kernel.org, joe.lawrence@redhat.com, corbet@lwn.net,
        yhs@fb.com, songliubraving@fb.com
Subject: Re: [PATCH] livepatch: Fix leak on klp_init_patch_early failure path
Message-ID: <YboLPAmOc8/6khu2@kroah.com>
References: <20211213191734.3238783-1-void@manifault.com>
 <YbhZwVocHDX9ZBAc@alley>
 <alpine.LSU.2.21.2112141012090.20187@pobox.suse.cz>
 <Ybi3qcA5ySDYpyib@dev0025.ash9.facebook.com>
 <Ybi9NzbvWU7ka8m1@kroah.com>
 <YbmlL0ZyfSuek9OB@alley>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YbmlL0ZyfSuek9OB@alley>
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed, Dec 15, 2021 at 09:19:59AM +0100, Petr Mladek wrote:
> On Tue 2021-12-14 16:50:15, Greg Kroah-Hartman wrote:
> > 
> > kobject_init() does allocate things internally, where does it say it
> > does not?  What is trying to be "fixed" here?
> 
> Could you please show where things are allocated in kobject_init()?
> I do not see it in the code!
> 
> It looks to me like a cargo cult claim to me.

Hm, I thought I saw it yesterday when I reviewed the code.  Let me look
again...

> Documentation/core-api/kobject.rst says:
> 
>    Once you registered your kobject via kobject_add(), you must never use
>    kfree() to free it directly. The only safe way is to use kobject_put().
> 
> kobject_add() makes perfect sense because it copies the name, takes
> reference to the parent, etc.
> 
> kobject_init() just initializes the structure members and nothing else.

Now it does.  In the past, I think we did create some memory.  I know
when we hook debugobjects up to kobjects (there's an external patch for
that floating around somewhere), that is one reason to keep the
kobject_put() rule, and there might have been other reasons in the past
20+ years as well.

So yes, while you are correct today, the "normal" reference counted
object model patern is "after the object is initialized, it MUST only be
freed by handling its reference count."  So let's stick to that rule for
now.

If you want, I can put some code in the kobject_init() logic to force
this to be the case if it bothers you :)

thanks,

greg k-h
