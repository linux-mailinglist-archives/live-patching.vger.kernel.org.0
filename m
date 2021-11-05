Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8310446064
	for <lists+live-patching@lfdr.de>; Fri,  5 Nov 2021 09:01:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232356AbhKEIED (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 5 Nov 2021 04:04:03 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:53887 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232476AbhKEIEC (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 5 Nov 2021 04:04:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636099283;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0MqXgdVfhBySSGVsmZdlv09NxUwfcfOPShoRaoY0Oy8=;
        b=G3T+Q3kulc2Z0F+Q9vTcfq4VabtKSop1mH+/0Snsl78vSsBJK5a0L1ay/8pq5k1s/Ixrtb
        t9/nPK/pSuvxQ269qWmwXLA6eyr85YiYzyGgkCFKz45UHDeOCF1/6xyz891qfYRYDGnEoF
        woKEvZrvf5X7lQdMMHwNTiuoO8Me/Wc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-37-LrDIzKHvMBq5Fy_EvqV5AQ-1; Fri, 05 Nov 2021 04:01:20 -0400
X-MC-Unique: LrDIzKHvMBq5Fy_EvqV5AQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F24CF9126F;
        Fri,  5 Nov 2021 08:01:18 +0000 (UTC)
Received: from T590 (ovpn-8-17.pek2.redhat.com [10.72.8.17])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2D4035D9DE;
        Fri,  5 Nov 2021 08:00:01 +0000 (UTC)
Date:   Fri, 5 Nov 2021 15:59:56 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Petr Mladek <pmladek@suse.com>
Cc:     Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>, live-patching@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Joe Lawrence <joe.lawrence@redhat.com>, ming.lei@redhat.com
Subject: Re: [PATCH V4 3/3] livepatch: free klp_patch object synchronously
Message-ID: <YYTkfAwdJio5qOFM@T590>
References: <20211102145932.3623108-1-ming.lei@redhat.com>
 <20211102145932.3623108-4-ming.lei@redhat.com>
 <YYKUx+yx4NdeWPBU@alley>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YYKUx+yx4NdeWPBU@alley>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed, Nov 03, 2021 at 02:55:19PM +0100, Petr Mladek wrote:
> On Tue 2021-11-02 22:59:32, Ming Lei wrote:
> > klp_mutex isn't acquired before calling kobject_put(klp_patch), so it is
> > fine to free klp_patch object synchronously.
> > 
> > One issue is that enabled store() method, in which the klp_patch kobject
> > itself is deleted & released. However, sysfs has provided APIs for dealing
> > with this corner case, so use sysfs_break_active_protection() and
> > sysfs_unbreak_active_protection() for releasing klp_patch kobject from
> > enabled_store(), meantime the enabled attribute has to be removed
> > before deleting the klp_patch kobject.
> > 
> > --- a/kernel/livepatch/core.c
> > +++ b/kernel/livepatch/core.c
> > @@ -369,10 +370,18 @@ static ssize_t enabled_store(struct kobject *kobj, struct kobj_attribute *attr,
> >  out:
> >  	mutex_unlock(&klp_mutex);
> >  
> > -	klp_free_patches_async(&to_free);
> > -
> >  	if (ret)
> >  		return ret;
> > +
> > +	if (!list_empty(&to_free)) {
> > +		kn = sysfs_break_active_protection(kobj, &attr->attr);
> > +		WARN_ON_ONCE(!kn);
> > +		sysfs_remove_file(kobj, &attr->attr);
> > +		klp_free_patches(&to_free);
> > +		if (kn)
> > +			sysfs_unbreak_active_protection(kn);
> > +	}
> 
> I agree that using workqueues for free_work looks like a hack.
> But this looks even more tricky and fragile to me. It feels like
> playing with sysfs/kernfs internals.
> 
> It might look less tricky when using sysfs_remove_file_self().

The protection needs to cover removing both 'enabled' attribute and
the patch kobject, so sysfs_remove_file_self() isn't good here.

> 
> Anyway, there are only few users of these APIs:
> 
>    + sysfs_break_active_protection() is used only scsi
>    + kernfs_break_active_protection() is used by cgroups, cpusets, and rdtgroup.
>    + sysfs_remove_file_self() is used by some RDMA-related stuff.
> 
> It means that there are some users but it is not widely used API.

It is used by generic pci device and scsi device, both are the most popular
devices in the world, either one of the two subsystem should have huge amount
of users, so it means the interface itself has been proved/verified for long
time by many enough real users.

> 
> I would personally prefer to keep it as is. I do not see any
> fundamental advantage of the new code. But I might be biased
> because the current code was written by me ;-)

The fundamental advantage is that the API has been used/verified by
enough real users. Also killing attribute/kobject itself isn't unique
for livepatch, that is actually one common pattern, so it needn't
such hacky implementation.


Thanks,
Ming

