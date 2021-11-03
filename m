Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52F43443A9E
	for <lists+live-patching@lfdr.de>; Wed,  3 Nov 2021 01:52:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230382AbhKCAyf (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 2 Nov 2021 20:54:35 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:30691 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230463AbhKCAyf (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 2 Nov 2021 20:54:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635900719;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0CyJLoioNsU3qRSThvjU7ETmX7z5Bf7snCPpHaCNXW4=;
        b=NYXts6sWw/WjlUHEEKZGo+clqw9TDVnxgya42dv69rAbQ1i6T79cw+Ce2GGQqfJndRChpd
        QbMeFWJVFXnfKi5bChjjG1Dx6Skr+i6KVf8TZFasbIhtEi16Yh3PGtuqfAwUB3/oJx/hD+
        je3pUXqx4Y8NWCMtPqdXQtItu/YE0UU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-19-576RFM2aO9qVl4tb1Syndg-1; Tue, 02 Nov 2021 20:51:56 -0400
X-MC-Unique: 576RFM2aO9qVl4tb1Syndg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8D46218125C2;
        Wed,  3 Nov 2021 00:51:54 +0000 (UTC)
Received: from T590 (ovpn-8-17.pek2.redhat.com [10.72.8.17])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9943367840;
        Wed,  3 Nov 2021 00:51:37 +0000 (UTC)
Date:   Wed, 3 Nov 2021 08:51:32 +0800
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
Message-ID: <YYHdFLwGry58Q16F@T590>
References: <20211102145932.3623108-1-ming.lei@redhat.com>
 <20211102145932.3623108-2-ming.lei@redhat.com>
 <YYFfmo5/Dds7bspY@alley>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YYFfmo5/Dds7bspY@alley>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue, Nov 02, 2021 at 04:56:10PM +0100, Petr Mladek wrote:
> On Tue 2021-11-02 22:59:30, Ming Lei wrote:
> > The completion finish is just for waiting release of the klp_patch
> > object, then releases module refcnt. We can simply drop the module
> > refcnt in the kobject release handler of klp_patch.
> > 
> > This way also helps to support allocating klp_patch from heap.
> 
> IMHO, this is wrong assumption. kobject_put() might do everyting
> asynchronously, see:
> 
>    kobject_put()
>      kobject_release()
>        INIT_DELAYED_WORK(&kobj->release, kobject_delayed_cleanup);
>        schedule_delayed_work(&kobj->release, delay);
> 
>    asynchronously:
> 
>      kobject_delayed_cleanup()
>       kobject_cleanup()
> 	__kobject_del()

OK, this is one generic kobject release vs. module unloading issue to
solve, not unique for klp module, and there should be lots of drivers
suffering from it.

> 
> 
> > Signed-off-by: Ming Lei <ming.lei@redhat.com>
> > ---
> >  include/linux/livepatch.h |  1 -
> >  kernel/livepatch/core.c   | 12 +++---------
> >  2 files changed, 3 insertions(+), 10 deletions(-)
> > 
> > diff --git a/include/linux/livepatch.h b/include/linux/livepatch.h
> > index 2614247a9781..9712818997c5 100644
> > --- a/include/linux/livepatch.h
> > +++ b/include/linux/livepatch.h
> > @@ -170,7 +170,6 @@ struct klp_patch {
> >  	bool enabled;
> >  	bool forced;
> >  	struct work_struct free_work;
> > -	struct completion finish;
> >  };
> >  
> >  #define klp_for_each_object_static(patch, obj) \
> > diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
> > index 335d988bd811..b967b4b0071b 100644
> > --- a/kernel/livepatch/core.c
> > +++ b/kernel/livepatch/core.c
> > @@ -551,10 +551,10 @@ static int klp_add_nops(struct klp_patch *patch)
> >  
> >  static void klp_kobj_release_patch(struct kobject *kobj)
> >  {
> > -	struct klp_patch *patch;
> > +	struct klp_patch *patch = container_of(kobj, struct klp_patch, kobj);
> >  
> > -	patch = container_of(kobj, struct klp_patch, kobj);
> > -	complete(&patch->finish);
> > +	if (!patch->forced)
> > +		module_put(patch->mod);
> >  }
> >  
> >  static struct kobj_type klp_ktype_patch = {
> > @@ -678,11 +678,6 @@ static void klp_free_patch_finish(struct klp_patch *patch)
> >  	 * cannot get enabled again.
> >  	 */
> >  	kobject_put(&patch->kobj);
> > -	wait_for_completion(&patch->finish);
> > -
> > -	/* Put the module after the last access to struct klp_patch. */
> > -	if (!patch->forced)
> > -		module_put(patch->mod);
> 
> klp_free_patch_finish() does not longer wait until the release
> callbacks are called.
> 
> klp_free_patch_finish() is called also in klp_enable_patch() error
> path.
> 
> klp_enable_patch() is called in module_init(). For example, see
> samples/livepatch/livepatch-sample.c
> 
> The module must not get removed until the release callbacks are called.
> Does the module loader check the module reference counter when
> module_init() fails?

Good catch, that is really one corner case, in which the kobject has to
be cleaned up before returning from mod->init(), cause there can't be
module unloading in case of mod->init() failure. 

Yeah, it should be more related with async kobject_put().

Also looks it is reasonable to add check when cleaning module loading
failure.


thanks,
Ming

