Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06712477426
	for <lists+live-patching@lfdr.de>; Thu, 16 Dec 2021 15:14:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229576AbhLPOOn (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 16 Dec 2021 09:14:43 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:42854 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229525AbhLPOOn (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 16 Dec 2021 09:14:43 -0500
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id CF34F1F465;
        Thu, 16 Dec 2021 14:14:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1639664081; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1ue6/TYI0i0J8w8ZHXna6f2slYijkGXx+ie8ci2x8po=;
        b=iG3tZzfJ5SCS+SfJADwn/EPifM89UCPJzH8u6lWyVnQgjHeg04JRxwOrDZypH1wu79x7j3
        tPIkYtw9Zdr/UofWIVhlE9NYxGgK0ODkYeu5WAgN4W1aZ0T9hD3k7w4nx36EMfEYt7wS26
        1NXLjXTzPZy7tUpR6rEwdDS1iOq5v7E=
Received: from suse.cz (unknown [10.100.224.162])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 8377DA3B81;
        Thu, 16 Dec 2021 14:14:41 +0000 (UTC)
Date:   Thu, 16 Dec 2021 15:14:38 +0100
From:   Petr Mladek <pmladek@suse.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     David Vernet <void@manifault.com>, Miroslav Benes <mbenes@suse.cz>,
        linux-doc@vger.kernel.org, live-patching@vger.kernel.org,
        linux-kernel@vger.kernel.org, jpoimboe@redhat.com,
        jikos@kernel.org, joe.lawrence@redhat.com, corbet@lwn.net,
        yhs@fb.com, songliubraving@fb.com
Subject: Re: [PATCH] livepatch: Fix leak on klp_init_patch_early failure path
Message-ID: <YbtJzonSJjcUaUwh@alley>
References: <20211213191734.3238783-1-void@manifault.com>
 <YbhZwVocHDX9ZBAc@alley>
 <alpine.LSU.2.21.2112141012090.20187@pobox.suse.cz>
 <Ybi3qcA5ySDYpyib@dev0025.ash9.facebook.com>
 <Ybi9NzbvWU7ka8m1@kroah.com>
 <YbmlL0ZyfSuek9OB@alley>
 <YboLPAmOc8/6khu2@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YboLPAmOc8/6khu2@kroah.com>
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed 2021-12-15 16:35:24, Greg Kroah-Hartman wrote:
> On Wed, Dec 15, 2021 at 09:19:59AM +0100, Petr Mladek wrote:
> > On Tue 2021-12-14 16:50:15, Greg Kroah-Hartman wrote:
> > > 
> > > kobject_init() does allocate things internally, where does it say it
> > > does not?  What is trying to be "fixed" here?
> > 
> > Could you please show where things are allocated in kobject_init()?
> > I do not see it in the code!
> > 
> > It looks to me like a cargo cult claim to me.
> 
> Hm, I thought I saw it yesterday when I reviewed the code.  Let me look
> again...
> 
> > Documentation/core-api/kobject.rst says:
> > 
> >    Once you registered your kobject via kobject_add(), you must never use
> >    kfree() to free it directly. The only safe way is to use kobject_put().
> > 
> > kobject_add() makes perfect sense because it copies the name, takes
> > reference to the parent, etc.
> > 
> > kobject_init() just initializes the structure members and nothing else.
> 
> Now it does.  In the past, I think we did create some memory.  I know
> when we hook debugobjects up to kobjects (there's an external patch for
> that floating around somewhere), that is one reason to keep the
> kobject_put() rule, and there might have been other reasons in the past
> 20+ years as well.
> 
> So yes, while you are correct today, the "normal" reference counted
> object model patern is "after the object is initialized, it MUST only be
> freed by handling its reference count."  So let's stick to that rule for
> now.

Good point.


> If you want, I can put some code in the kobject_init() logic to force
> this to be the case if it bothers you :)

I actually know about one case where this might be very useful.

There is the problem with kobject lifetime and module removal.
module is removed after mod->exit() callback finishes. But some
kobject release() callbacks might be delayed, especillay when
CONFIG_DEBUG_KOBJECT_RELEASE is enabled.

I have proposed there a solution where kobject_add_internal() takes reference
on the module. It would make sure that the module will stay in the
memory until the release callbacks is called, see
https://lore.kernel.org/all/Ya84O2%2FnYCyNb%2Ffp@alley/

But kobject_add_internal() is not the right place. The reference on
the module should be taken already in kobject_init() because the
release callbacks might be used after this point.

Best Regards,
Petr
