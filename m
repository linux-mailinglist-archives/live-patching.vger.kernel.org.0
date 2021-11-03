Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7511E4442D9
	for <lists+live-patching@lfdr.de>; Wed,  3 Nov 2021 14:55:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230282AbhKCN57 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 3 Nov 2021 09:57:59 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:49356 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231986AbhKCN55 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 3 Nov 2021 09:57:57 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 0BA8E1FD39;
        Wed,  3 Nov 2021 13:55:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1635947720; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=BzdeH19q1WG7WtFYpjka6gTYSLgRMwNCKIuuhcecbBk=;
        b=lvGtWuhA4+dA0+8AQcInExTJfPv2m/FXPVAvzkegHoPl1sGIYeGw2qOHhFB+Dak+SgGpYs
        /D0XxpU6FOfq/jhqJVdcyoUYB2jiQJIOznhyg8Jfrmy+rm/OZd73urFciQywypm5gb2jhb
        sOZPXizN61f+UHQHzwFtdBEiIJKBZPs=
Received: from suse.cz (unknown [10.100.224.162])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 1D491A3B83;
        Wed,  3 Nov 2021 13:55:16 +0000 (UTC)
Date:   Wed, 3 Nov 2021 14:55:19 +0100
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
Message-ID: <YYKUx+yx4NdeWPBU@alley>
References: <20211102145932.3623108-1-ming.lei@redhat.com>
 <20211102145932.3623108-4-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211102145932.3623108-4-ming.lei@redhat.com>
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue 2021-11-02 22:59:32, Ming Lei wrote:
> klp_mutex isn't acquired before calling kobject_put(klp_patch), so it is
> fine to free klp_patch object synchronously.
> 
> One issue is that enabled store() method, in which the klp_patch kobject
> itself is deleted & released. However, sysfs has provided APIs for dealing
> with this corner case, so use sysfs_break_active_protection() and
> sysfs_unbreak_active_protection() for releasing klp_patch kobject from
> enabled_store(), meantime the enabled attribute has to be removed
> before deleting the klp_patch kobject.
> 
> --- a/kernel/livepatch/core.c
> +++ b/kernel/livepatch/core.c
> @@ -369,10 +370,18 @@ static ssize_t enabled_store(struct kobject *kobj, struct kobj_attribute *attr,
>  out:
>  	mutex_unlock(&klp_mutex);
>  
> -	klp_free_patches_async(&to_free);
> -
>  	if (ret)
>  		return ret;
> +
> +	if (!list_empty(&to_free)) {
> +		kn = sysfs_break_active_protection(kobj, &attr->attr);
> +		WARN_ON_ONCE(!kn);
> +		sysfs_remove_file(kobj, &attr->attr);
> +		klp_free_patches(&to_free);
> +		if (kn)
> +			sysfs_unbreak_active_protection(kn);
> +	}

I agree that using workqueues for free_work looks like a hack.
But this looks even more tricky and fragile to me. It feels like
playing with sysfs/kernfs internals.

It might look less tricky when using sysfs_remove_file_self().

Anyway, there are only few users of these APIs:

   + sysfs_break_active_protection() is used only scsi
   + kernfs_break_active_protection() is used by cgroups, cpusets, and rdtgroup.
   + sysfs_remove_file_self() is used by some RDMA-related stuff.

It means that there are some users but it is not widely used API.

I would personally prefer to keep it as is. I do not see any
fundamental advantage of the new code. But I might be biased
because the current code was written by me ;-)

Best Regards,
Petr
