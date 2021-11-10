Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B19944C335
	for <lists+live-patching@lfdr.de>; Wed, 10 Nov 2021 15:42:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231551AbhKJOpQ (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 10 Nov 2021 09:45:16 -0500
Received: from smtp-out1.suse.de ([195.135.220.28]:49410 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231683AbhKJOpP (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 10 Nov 2021 09:45:15 -0500
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 6AAB1218E0;
        Wed, 10 Nov 2021 14:42:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1636555347; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=CjoXnMyzqTopq52JxvUZkIx7GlsUHp6OaZyz7Hm2soE=;
        b=F6OMTOHejWEHm1+6XVX+PiWRabbHPcZVyMKhy2ykNsL0RDAj+vxSmjKiAjCjRqRkRFdOaz
        8c9VL49I/j4ZE+GOWRTFVbHyo8jc2p9fLLaBbbczO34v0jhuvUDaFSrDUPFA/Cbi+/tLkT
        c9rIHHvfm/ZA6g39G60ddtwUWTnT62E=
Received: from suse.cz (unknown [10.100.216.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id C6C81A3B91;
        Wed, 10 Nov 2021 14:42:22 +0000 (UTC)
Date:   Wed, 10 Nov 2021 15:42:27 +0100
From:   Petr Mladek <pmladek@suse.com>
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>, live-patching@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Joe Lawrence <joe.lawrence@redhat.com>
Subject: Re: [PATCH V4 3/3] livepatch: free klp_patch object synchronously
Message-ID: <YYvaU1sRRbNAqigG@alley>
References: <20211102145932.3623108-1-ming.lei@redhat.com>
 <20211102145932.3623108-4-ming.lei@redhat.com>
 <YYKUx+yx4NdeWPBU@alley>
 <YYTkfAwdJio5qOFM@T590>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YYTkfAwdJio5qOFM@T590>
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Fri 2021-11-05 15:59:56, Ming Lei wrote:
> On Wed, Nov 03, 2021 at 02:55:19PM +0100, Petr Mladek wrote:
> > On Tue 2021-11-02 22:59:32, Ming Lei wrote:
> > > klp_mutex isn't acquired before calling kobject_put(klp_patch), so it is
> > > fine to free klp_patch object synchronously.
> > > 
> > > One issue is that enabled store() method, in which the klp_patch kobject
> > > itself is deleted & released. However, sysfs has provided APIs for dealing
> > > with this corner case, so use sysfs_break_active_protection() and
> > > sysfs_unbreak_active_protection() for releasing klp_patch kobject from
> > > enabled_store(), meantime the enabled attribute has to be removed
> > > before deleting the klp_patch kobject.
> > > 
> > > --- a/kernel/livepatch/core.c
> > > +++ b/kernel/livepatch/core.c
> > > @@ -369,10 +370,18 @@ static ssize_t enabled_store(struct kobject *kobj, struct kobj_attribute *attr,
> > >  out:
> > >  	mutex_unlock(&klp_mutex);
> > >  
> > > -	klp_free_patches_async(&to_free);
> > > -
> > >  	if (ret)
> > >  		return ret;
> > > +
> > > +	if (!list_empty(&to_free)) {
> > > +		kn = sysfs_break_active_protection(kobj, &attr->attr);
> > > +		WARN_ON_ONCE(!kn);
> > > +		sysfs_remove_file(kobj, &attr->attr);
> > > +		klp_free_patches(&to_free);
> > > +		if (kn)
> > > +			sysfs_unbreak_active_protection(kn);
> > > +	}
> > 
> > I agree that using workqueues for free_work looks like a hack.
> > But this looks even more tricky and fragile to me. It feels like
> > playing with sysfs/kernfs internals.
> > 
> > It might look less tricky when using sysfs_remove_file_self().
> 
> The protection needs to cover removing both 'enabled' attribute and
> the patch kobject, so sysfs_remove_file_self() isn't good here.

I see.

> > Anyway, there are only few users of these APIs:
> > 
> >    + sysfs_break_active_protection() is used only scsi
> >    + kernfs_break_active_protection() is used by cgroups, cpusets, and rdtgroup.
> >    + sysfs_remove_file_self() is used by some RDMA-related stuff.
> > 
> > It means that there are some users but it is not widely used API.
> 
> It is used by generic pci device and scsi device, both are the most popular
> devices in the world, either one of the two subsystem should have huge amount
> of users, so it means the interface itself has been proved/verified for long
> time by many enough real users.

Good to know. It means that if there is a regression then scsi users
should find it quickly.


> > > +		kn = sysfs_break_active_protection(kobj, &attr->attr);
> > > +		WARN_ON_ONCE(!kn);
> > > +		sysfs_remove_file(kobj, &attr->attr);
> > > +		klp_free_patches(&to_free);
> > > +		if (kn)
> > > +			sysfs_unbreak_active_protection(kn);


> > I would personally prefer to keep it as is. I do not see any
> > fundamental advantage of the new code. But I might be biased
> > because the current code was written by me ;-)
> 
> The fundamental advantage is that the API has been used/verified by
> enough real users. Also killing attribute/kobject itself isn't unique
> for livepatch, that is actually one common pattern, so it needn't
> such hacky implementation.

I am not sure what you mean by many users:

   + sysfs_break_active_protection() is used only once
     by sdev_store_delete()

   + sysfs_remove_file_self() seems to be used 7x in kernel sources.


It all goes down to kernfs_break_active_protection() that has
a bit scary description:

 * This function releases the active reference of @kn the caller is
 * holding.  Once this function is called, @kn may be removed at any point
 * and the caller is solely responsible for ensuring that the objects it
 * dereferences are accessible.


and the related kernfs_unbreak_active_protection() has even more
scarry description:

 * If kernfs_break_active_protection() was called, this function must be
 * invoked before finishing the kernfs operation.  Note that while this
 * function restores the active reference, it doesn't and can't actually
 * restore the active protection - @kn may already or be in the process of
 * being removed.  Once kernfs_break_active_protection() is invoked, that
 * protection is irreversibly gone for the kernfs operation instance.
 *
 * While this function may be called at any point after
 * kernfs_break_active_protection() is invoked, its most useful location
 * would be right before the enclosing kernfs operation returns.


It feels like this API allows you to cut the branch you are staying on.
You have to be sure that you do it in the right order and remove
the spot under your feet as the very last piece. While normally
this is guranteed by the refecence counters.

In compare, the workqueue approach looks less risky. You just ask
someone (worker) to remove your branch after you leave. It will be
naturally done only when nobody is on the branch and in the right
order thanks to the reference counters.

Best Regards,
Petr
