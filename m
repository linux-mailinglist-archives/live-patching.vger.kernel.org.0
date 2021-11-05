Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 770DE44631F
	for <lists+live-patching@lfdr.de>; Fri,  5 Nov 2021 13:04:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232870AbhKEMHS (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 5 Nov 2021 08:07:18 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:52432 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232900AbhKEMHP (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 5 Nov 2021 08:07:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636113875;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XASuO+rECscFYeoZ2e+O7ZWZF/gxoe7C6KcT09KQuV8=;
        b=J1f6/KocCmX8Q/ckk7NRTHnS3OQteD2wZY20hQ0WCHuHl2k+CABkOZYz1fa9yRRq0R3Km8
        VvzKq/WWOTfzrevQlA5+ykCOYBbhfDB6+TrBGLaE0bzThF/Lucsa2H3ORjVzNUks76A3tn
        bjT69VqCcTt41CYU9g0gSdkbvqW1R54=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-48-DQ_V2EfZNS-WZmEUvlRrnQ-1; Fri, 05 Nov 2021 08:04:32 -0400
X-MC-Unique: DQ_V2EfZNS-WZmEUvlRrnQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CBAE980A5C2;
        Fri,  5 Nov 2021 12:04:30 +0000 (UTC)
Received: from T590 (ovpn-8-17.pek2.redhat.com [10.72.8.17])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 20BFB5D740;
        Fri,  5 Nov 2021 12:04:08 +0000 (UTC)
Date:   Fri, 5 Nov 2021 20:04:03 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Petr Mladek <pmladek@suse.com>
Cc:     Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>, live-patching@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Joe Lawrence <joe.lawrence@redhat.com>, ming.lei@redhat.com
Subject: Re: [PATCH V4 1/3] livepatch: remove 'struct completion finish' from
 klp_patch
Message-ID: <YYUds30Tkbs9HglB@T590>
References: <20211102145932.3623108-1-ming.lei@redhat.com>
 <20211102145932.3623108-2-ming.lei@redhat.com>
 <YYFfmo5/Dds7bspY@alley>
 <YYHdFLwGry58Q16F@T590>
 <YYKGDSdKwQfjs6xf@alley>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YYKGDSdKwQfjs6xf@alley>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed, Nov 03, 2021 at 01:52:29PM +0100, Petr Mladek wrote:
> On Wed 2021-11-03 08:51:32, Ming Lei wrote:
> > On Tue, Nov 02, 2021 at 04:56:10PM +0100, Petr Mladek wrote:
> > > On Tue 2021-11-02 22:59:30, Ming Lei wrote:
> > > > The completion finish is just for waiting release of the klp_patch
> > > > object, then releases module refcnt. We can simply drop the module
> > > > refcnt in the kobject release handler of klp_patch.
> > > > 
> > > > This way also helps to support allocating klp_patch from heap.
> 
> First, I am sorry for confusion. The above description is correct.
> I does not say anything about that kobject_put() is synchronous.
> 
> > > IMHO, this is wrong assumption. kobject_put() might do everyting
> > > asynchronously, see:
> 
> I see that you are aware of this behavior.
> 
> > >    kobject_put()
> > >      kobject_release()
> > >        INIT_DELAYED_WORK(&kobj->release, kobject_delayed_cleanup);
> > >        schedule_delayed_work(&kobj->release, delay);
> > > 
> > >    asynchronously:
> > > 
> > >      kobject_delayed_cleanup()
> > >       kobject_cleanup()
> > > 	__kobject_del()
> > 
> > OK, this is one generic kobject release vs. module unloading issue to
> > solve, not unique for klp module, and there should be lots of drivers
> > suffering from it.
> 
> Yup, the problem is generic. It would be nice to have a generic
> solution. For example, add kobject_release_sync() that would return
> only when the object is really released.

The generic solution has been posted out:

https://lore.kernel.org/lkml/20211105063710.4092936-1-ming.lei@redhat.com/

which needn't any generic API change, just flushes all scheduled kobject
cleanup work before freeing module, and the change is transparent for
drivers.

IMO, kobject_release_sync() is one wrong direction for fixing this
issue, since it is basically impossible to audit if one kobject_put()
need to be replaced with kobject_release_sync().

> 
> > > > --- a/kernel/livepatch/core.c
> > > > +++ b/kernel/livepatch/core.c
> > > > @@ -678,11 +678,6 @@ static void klp_free_patch_finish(struct klp_patch *patch)
> > > >  	 * cannot get enabled again.
> > > >  	 */
> > > >  	kobject_put(&patch->kobj);
> > > > -	wait_for_completion(&patch->finish);
> > > > -
> > > > -	/* Put the module after the last access to struct klp_patch. */
> > > > -	if (!patch->forced)
> > > > -		module_put(patch->mod);
> > > 
> > > klp_free_patch_finish() does not longer wait until the release
> > > callbacks are called.
> > > 
> > > klp_free_patch_finish() is called also in klp_enable_patch() error
> > > path.
> > > 
> > > klp_enable_patch() is called in module_init(). For example, see
> > > samples/livepatch/livepatch-sample.c
> > > 
> > > The module must not get removed until the release callbacks are called.
> > > Does the module loader check the module reference counter when
> > > module_init() fails?
> > 
> > Good catch, that is really one corner case, in which the kobject has to
> > be cleaned up before returning from mod->init(), cause there can't be
> > module unloading in case of mod->init() failure.
> 
> Just to be sure. We want to keep the safe behavior in this case.
> There are many situations when klp_enable() might fail. And the error
> handling must be safe.
> 
> In general, livepatch developers are very conservative.
> Livepatches are not easy to create. They are used only by people
> who really want to avoid reboot. We want to keep the livepatch kernel
> framework as safe as possible to avoid any potential damage.

The posted patch can cover this situation in which module_init() fails.



Thanks,
Ming

