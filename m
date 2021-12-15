Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F199475C0B
	for <lists+live-patching@lfdr.de>; Wed, 15 Dec 2021 16:44:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244040AbhLOPnr (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 15 Dec 2021 10:43:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244033AbhLOPnr (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 15 Dec 2021 10:43:47 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4497DC061574;
        Wed, 15 Dec 2021 07:43:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 24646B82004;
        Wed, 15 Dec 2021 15:43:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B1A7C350AD;
        Wed, 15 Dec 2021 15:43:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639583022;
        bh=daFra/it80tNYf8ZnzenMAxIx4uQffBkpSjTHdvk+I0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Jl4QoNRg8yJdGzcTSinWBI+SW3RpvwIl/WCjH9oBvIX+F/9thacwx2tGfvL8+dlhS
         9XnuSwvbZ8/ewbP/rtNJdk3WkMdX4tbLTSC0r7Rd+BG2O7svapMvgy5xF7Xm/gbBjQ
         O4Xp5RXigJb49fv7GXccnA8qki89EgMXSMaB4/D8=
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
