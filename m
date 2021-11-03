Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 366BD4441EF
	for <lists+live-patching@lfdr.de>; Wed,  3 Nov 2021 13:52:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231343AbhKCMzK (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 3 Nov 2021 08:55:10 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:45604 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230472AbhKCMzJ (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 3 Nov 2021 08:55:09 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 20DFE1FD2F;
        Wed,  3 Nov 2021 12:52:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1635943952; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7LyPIXzXI53HNpm3jQLfD9DoICZ48gFa7860SvpDD4E=;
        b=CDXTN+toc6M1hD1pAlIBAFY0SOrgILL/f1ecQgNwsPGpiBbE2W7QGr6N/0U+1XYtlYOd3s
        d4Ojc8xa0Xf9HwEfrL6GsMoEeKfzXFBHnb2FNqwghz+BalZHIOOPzofu9iPiix54jh35+D
        9t3bPaD6KiLyzoDiJTRliqsJR5ber68=
Received: from suse.cz (unknown [10.100.224.162])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 308012C144;
        Wed,  3 Nov 2021 12:52:28 +0000 (UTC)
Date:   Wed, 3 Nov 2021 13:52:29 +0100
From:   Petr Mladek <pmladek@suse.com>
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>, live-patching@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Joe Lawrence <joe.lawrence@redhat.com>
Subject: Re: [PATCH V4 1/3] livepatch: remove 'struct completion finish' from
 klp_patch
Message-ID: <YYKGDSdKwQfjs6xf@alley>
References: <20211102145932.3623108-1-ming.lei@redhat.com>
 <20211102145932.3623108-2-ming.lei@redhat.com>
 <YYFfmo5/Dds7bspY@alley>
 <YYHdFLwGry58Q16F@T590>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YYHdFLwGry58Q16F@T590>
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed 2021-11-03 08:51:32, Ming Lei wrote:
> On Tue, Nov 02, 2021 at 04:56:10PM +0100, Petr Mladek wrote:
> > On Tue 2021-11-02 22:59:30, Ming Lei wrote:
> > > The completion finish is just for waiting release of the klp_patch
> > > object, then releases module refcnt. We can simply drop the module
> > > refcnt in the kobject release handler of klp_patch.
> > > 
> > > This way also helps to support allocating klp_patch from heap.

First, I am sorry for confusion. The above description is correct.
I does not say anything about that kobject_put() is synchronous.

> > IMHO, this is wrong assumption. kobject_put() might do everyting
> > asynchronously, see:

I see that you are aware of this behavior.

> >    kobject_put()
> >      kobject_release()
> >        INIT_DELAYED_WORK(&kobj->release, kobject_delayed_cleanup);
> >        schedule_delayed_work(&kobj->release, delay);
> > 
> >    asynchronously:
> > 
> >      kobject_delayed_cleanup()
> >       kobject_cleanup()
> > 	__kobject_del()
> 
> OK, this is one generic kobject release vs. module unloading issue to
> solve, not unique for klp module, and there should be lots of drivers
> suffering from it.

Yup, the problem is generic. It would be nice to have a generic
solution. For example, add kobject_release_sync() that would return
only when the object is really released.

> > > --- a/kernel/livepatch/core.c
> > > +++ b/kernel/livepatch/core.c
> > > @@ -678,11 +678,6 @@ static void klp_free_patch_finish(struct klp_patch *patch)
> > >  	 * cannot get enabled again.
> > >  	 */
> > >  	kobject_put(&patch->kobj);
> > > -	wait_for_completion(&patch->finish);
> > > -
> > > -	/* Put the module after the last access to struct klp_patch. */
> > > -	if (!patch->forced)
> > > -		module_put(patch->mod);
> > 
> > klp_free_patch_finish() does not longer wait until the release
> > callbacks are called.
> > 
> > klp_free_patch_finish() is called also in klp_enable_patch() error
> > path.
> > 
> > klp_enable_patch() is called in module_init(). For example, see
> > samples/livepatch/livepatch-sample.c
> > 
> > The module must not get removed until the release callbacks are called.
> > Does the module loader check the module reference counter when
> > module_init() fails?
> 
> Good catch, that is really one corner case, in which the kobject has to
> be cleaned up before returning from mod->init(), cause there can't be
> module unloading in case of mod->init() failure.

Just to be sure. We want to keep the safe behavior in this case.
There are many situations when klp_enable() might fail. And the error
handling must be safe.

In general, livepatch developers are very conservative.
Livepatches are not easy to create. They are used only by people
who really want to avoid reboot. We want to keep the livepatch kernel
framework as safe as possible to avoid any potential damage.

> Yeah, it should be more related with async kobject_put().

Yup, it would be nice to have some sychronous variant provided
by kobject API.

> Also looks it is reasonable to add check when cleaning module loading
> failure.

Which means that the completion has to stay until there is any generic
solution. And this patch should be dropped for now.

Best Regards,
Petr
