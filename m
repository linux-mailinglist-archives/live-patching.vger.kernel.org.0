Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DF9844C29C
	for <lists+live-patching@lfdr.de>; Wed, 10 Nov 2021 14:57:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232090AbhKJOAC (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 10 Nov 2021 09:00:02 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:50062 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232057AbhKJOAC (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 10 Nov 2021 09:00:02 -0500
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 149C61FD33;
        Wed, 10 Nov 2021 13:57:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1636552634; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0hr7WLfcXhupe7bquZN3x2cx82w6SeSF9FCLwM2WXts=;
        b=YD929wzvXp5LhIY1ztnYGPg2cV0T38fEWq8xWWDagOq+ZL1cD2w1P3rks5m/95peGKRhhg
        YcoOkvL5TqjcRfs1cdqZpv/z7TQ2MJKsEdo2hnboe4qRKeEr43OqUeRwopu8JLxao0xpc6
        OcN1JckOTN57W9W0BY3fyrxQ4tPyX7s=
Received: from suse.cz (unknown [10.100.216.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 6E4D9A3B8A;
        Wed, 10 Nov 2021 13:57:09 +0000 (UTC)
Date:   Wed, 10 Nov 2021 14:57:11 +0100
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
Message-ID: <YYvPt1DHmpyEPGXG@alley>
References: <20211102145932.3623108-1-ming.lei@redhat.com>
 <20211102145932.3623108-2-ming.lei@redhat.com>
 <YYFfmo5/Dds7bspY@alley>
 <YYHdFLwGry58Q16F@T590>
 <YYKGDSdKwQfjs6xf@alley>
 <YYUds30Tkbs9HglB@T590>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YYUds30Tkbs9HglB@T590>
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Fri 2021-11-05 20:04:03, Ming Lei wrote:
> On Wed, Nov 03, 2021 at 01:52:29PM +0100, Petr Mladek wrote:
> > On Wed 2021-11-03 08:51:32, Ming Lei wrote:
> > > On Tue, Nov 02, 2021 at 04:56:10PM +0100, Petr Mladek wrote:
> > I see that you are aware of this behavior.
> > 
> > > >    kobject_put()
> > > >      kobject_release()
> > > >        INIT_DELAYED_WORK(&kobj->release, kobject_delayed_cleanup);
> > > >        schedule_delayed_work(&kobj->release, delay);
> > > > 
> > > >    asynchronously:
> > > > 
> > > >      kobject_delayed_cleanup()
> > > >       kobject_cleanup()
> > > > 	__kobject_del()
> > > 
> > > OK, this is one generic kobject release vs. module unloading issue to
> > > solve, not unique for klp module, and there should be lots of drivers
> > > suffering from it.
> > 
> > Yup, the problem is generic. It would be nice to have a generic
> > solution. For example, add kobject_release_sync() that would return
> > only when the object is really released.
> 
> The generic solution has been posted out:
> 
> https://lore.kernel.org/lkml/20211105063710.4092936-1-ming.lei@redhat.com/
> 
> which needn't any generic API change, just flushes all scheduled kobject
> cleanup work before freeing module, and the change is transparent for
> drivers.

No, it is not enough. The proposed "generic solution" solves only
the problem introduced by CONFIG_DEBUG_KOBJECT_RELEASE. It does not
prevent unloading the module from another reasons. I mean that it
does not help when the last reference is not released in time
or never from some reasons.


> IMO, kobject_release_sync() is one wrong direction for fixing this
> issue, since it is basically impossible to audit if one kobject_put()
> need to be replaced with kobject_release_sync().
> 
> > 
> > > > > --- a/kernel/livepatch/core.c
> > > > > +++ b/kernel/livepatch/core.c
> > > > > @@ -678,11 +678,6 @@ static void klp_free_patch_finish(struct klp_patch *patch)
> > > > >  	 * cannot get enabled again.
> > > > >  	 */
> > > > >  	kobject_put(&patch->kobj);
> > > > > -	wait_for_completion(&patch->finish);
> > > > > -
> > > > > -	/* Put the module after the last access to struct klp_patch. */
> > > > > -	if (!patch->forced)
> > > > > -		module_put(patch->mod);
> > > > 
> > > > klp_free_patch_finish() does not longer wait until the release
> > > > callbacks are called.
> > > > 
> > > > klp_free_patch_finish() is called also in klp_enable_patch() error
> > > > path.
> > > > 
> > > > klp_enable_patch() is called in module_init(). For example, see
> > > > samples/livepatch/livepatch-sample.c
> > > > 
> > > > The module must not get removed until the release callbacks are called.
> > > > Does the module loader check the module reference counter when
> > > > module_init() fails?
> > > 
> > > Good catch, that is really one corner case, in which the kobject has to
> > > be cleaned up before returning from mod->init(), cause there can't be
> > > module unloading in case of mod->init() failure.
> > 
> > Just to be sure. We want to keep the safe behavior in this case.
> > There are many situations when klp_enable() might fail. And the error
> > handling must be safe.
> > 
> > In general, livepatch developers are very conservative.
> > Livepatches are not easy to create. They are used only by people
> > who really want to avoid reboot. We want to keep the livepatch kernel
> > framework as safe as possible to avoid any potential damage.
> 
> The posted patch can cover this situation in which module_init() fails.

No, it works only when the last reference was dropped, the delayed
release queued, and the kobject added into kobj_cleanup_list.

The current livepatch code is much more safe. klp_free_patch_finish()
waits for the completion. It will allows to remove the module only
when the kobject was really released. It will block the module
removal as long as needed, even forever, if there is a bug somewhere.

If we use wait_for_completion_timeout() in a while cycle, we could
even report when it takes suspiciously long and something likely
went wrong. This is one way to "always" catch and report the problem.

I am not sure if similar approach is usable for device drivers. But I
had this in mind when I proposed the kobject_release_sync() API.

Best Regards,
Petr
