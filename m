Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97A9B443221
	for <lists+live-patching@lfdr.de>; Tue,  2 Nov 2021 16:56:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231928AbhKBP6u (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 2 Nov 2021 11:58:50 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:58184 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231314AbhKBP6t (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 2 Nov 2021 11:58:49 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 0DC23212C5;
        Tue,  2 Nov 2021 15:56:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1635868574; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=BmonHUnAnYnD8EpEMAbj9Xb4Tj4hqZW3n8QfuohThc4=;
        b=q77Vi0EksI1bvwukk8f+UhQtvSydthVGfiehL1dkY8ypR3VtkJ1e5zRb6e1Q8fUNqbKHax
        4uhSCMXUjYGYHj2b7fekF6D/3G9NVygd8rGY/YmfjpKxlOQPprQr1gOyaGxOH389rZJ3z4
        GZIHKLBI9vw/jSphQjTc6h9J9Z7xTq0=
Received: from suse.cz (unknown [10.100.216.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id E63E4A3B83;
        Tue,  2 Nov 2021 15:56:13 +0000 (UTC)
Date:   Tue, 2 Nov 2021 16:56:10 +0100
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
Message-ID: <YYFfmo5/Dds7bspY@alley>
References: <20211102145932.3623108-1-ming.lei@redhat.com>
 <20211102145932.3623108-2-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211102145932.3623108-2-ming.lei@redhat.com>
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue 2021-11-02 22:59:30, Ming Lei wrote:
> The completion finish is just for waiting release of the klp_patch
> object, then releases module refcnt. We can simply drop the module
> refcnt in the kobject release handler of klp_patch.
> 
> This way also helps to support allocating klp_patch from heap.

IMHO, this is wrong assumption. kobject_put() might do everyting
asynchronously, see:

   kobject_put()
     kobject_release()
       INIT_DELAYED_WORK(&kobj->release, kobject_delayed_cleanup);
       schedule_delayed_work(&kobj->release, delay);

   asynchronously:

     kobject_delayed_cleanup()
      kobject_cleanup()
	__kobject_del()


> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> ---
>  include/linux/livepatch.h |  1 -
>  kernel/livepatch/core.c   | 12 +++---------
>  2 files changed, 3 insertions(+), 10 deletions(-)
> 
> diff --git a/include/linux/livepatch.h b/include/linux/livepatch.h
> index 2614247a9781..9712818997c5 100644
> --- a/include/linux/livepatch.h
> +++ b/include/linux/livepatch.h
> @@ -170,7 +170,6 @@ struct klp_patch {
>  	bool enabled;
>  	bool forced;
>  	struct work_struct free_work;
> -	struct completion finish;
>  };
>  
>  #define klp_for_each_object_static(patch, obj) \
> diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
> index 335d988bd811..b967b4b0071b 100644
> --- a/kernel/livepatch/core.c
> +++ b/kernel/livepatch/core.c
> @@ -551,10 +551,10 @@ static int klp_add_nops(struct klp_patch *patch)
>  
>  static void klp_kobj_release_patch(struct kobject *kobj)
>  {
> -	struct klp_patch *patch;
> +	struct klp_patch *patch = container_of(kobj, struct klp_patch, kobj);
>  
> -	patch = container_of(kobj, struct klp_patch, kobj);
> -	complete(&patch->finish);
> +	if (!patch->forced)
> +		module_put(patch->mod);
>  }
>  
>  static struct kobj_type klp_ktype_patch = {
> @@ -678,11 +678,6 @@ static void klp_free_patch_finish(struct klp_patch *patch)
>  	 * cannot get enabled again.
>  	 */
>  	kobject_put(&patch->kobj);
> -	wait_for_completion(&patch->finish);
> -
> -	/* Put the module after the last access to struct klp_patch. */
> -	if (!patch->forced)
> -		module_put(patch->mod);

klp_free_patch_finish() does not longer wait until the release
callbacks are called.

klp_free_patch_finish() is called also in klp_enable_patch() error
path.

klp_enable_patch() is called in module_init(). For example, see
samples/livepatch/livepatch-sample.c

The module must not get removed until the release callbacks are called.
Does the module loader check the module reference counter when
module_init() fails?

Best Regards,
Petr
