Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AE15441226
	for <lists+live-patching@lfdr.de>; Mon,  1 Nov 2021 03:26:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230281AbhKAC3G (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Sun, 31 Oct 2021 22:29:06 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:21727 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230234AbhKAC3F (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Sun, 31 Oct 2021 22:29:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635733592;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=2CFcDAAKtdRHfDHUO+AtkQWLMsZM3R+b56iEA9NeVjE=;
        b=i2GvQLWwGNM49xdejioYwjfPQeI9VrOB784wut/u+SBWBhW10ciKqqj49sEMjshkAV5k7K
        f4zjcpSJM3FSGG9yjkIgcKRh27Af/hPsw3B+KDC9Rsvxx+cw5mFAuts29Ci8FboASJTmAA
        wB0JiPta/qEypA4KCy2TdlWywFJzEPU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-234-UM0ma7m2MEieqWFDyeih2g-1; Sun, 31 Oct 2021 22:26:29 -0400
X-MC-Unique: UM0ma7m2MEieqWFDyeih2g-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DD93C80668C;
        Mon,  1 Nov 2021 02:26:27 +0000 (UTC)
Received: from redhat.com (unknown [10.22.16.72])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4048C60D30;
        Mon,  1 Nov 2021 02:26:20 +0000 (UTC)
Date:   Sun, 31 Oct 2021 22:26:18 -0400
From:   Joe Lawrence <joe.lawrence@redhat.com>
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>, live-patching@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Chamberlain <mcgrof@kernel.org>
Subject: Re: [PATCH 0/3] livepatch: cleanup kpl_patch kobject release
Message-ID: <YX9QSqk8yg2ZbZz/@redhat.com>
References: <20211028125734.3134176-1-ming.lei@redhat.com>
 <YXv8eoPKXk5gpsa7@redhat.com>
 <YXwjDJx+ZZNmy7CN@T590>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YXwjDJx+ZZNmy7CN@T590>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Sat, Oct 30, 2021 at 12:36:28AM +0800, Ming Lei wrote:
> On Fri, Oct 29, 2021 at 09:51:54AM -0400, Joe Lawrence wrote:
> > On Thu, Oct 28, 2021 at 08:57:31PM +0800, Ming Lei wrote:
> > > Hello,
> > >
> > > The 1st patch moves module_put() to release handler of klp_patch
> > > kobject.
> > >
> > > The 2nd patch changes to free klp_patch and other kobjects without
> > > klp_mutex.
> > >
> > > The 3rd patch switches to synchronous kobject release for klp_patch.
> > >
> > 
> > Hi Ming,
> > 
> > I gave the patchset a spin on top of linus tree @ 1fc596a56b33 and ended
> > up with a stuck task:
> > 
> > Test
> > ----
> > Enable the livepatch selftests:
> >   $ grep CONFIG_TEST_LIVEPATCH .config
> >   CONFIG_TEST_LIVEPATCH=m
> > 
> > Run a continuous kernel build in the background:
> >   $ while (true); do make clean && make -j$(nproc); done
> > 
> > While continuously executing the selftests:
> >   $ while (true); do make -C tools/testing/selftests/livepatch/ run_tests; done
> > 
> > Results
> > -------
> 
> Hello Joe,
> 
> Thanks for the test!
> 
> Can you replace the 3rd patch with the following one then running the test again?
> 
> From 599e96f79aebc388ef3854134312c6039a7884bf Mon Sep 17 00:00:00 2001
> From: Ming Lei <ming.lei@redhat.com>
> Date: Thu, 28 Oct 2021 20:11:23 +0800
> Subject: [PATCH 3/3] livepatch: free klp_patch object synchronously
> 
> klp_mutex isn't acquired before calling kobject_put(klp_patch), so it is
> fine to free klp_patch object synchronously.
> 
> One issue is that enabled store() method, in which the klp_patch kobject
> itself is deleted & released. However, sysfs has provided APIs for dealing
> with this corner case, so use sysfs_break_active_protection() and
> sysfs_unbreak_active_protection() for releasing klp_patch kobject from
> enabled_store().
> 
> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> ---
>  include/linux/livepatch.h     |  1 -
>  kernel/livepatch/core.c       | 32 +++++++++++++-------------------
>  kernel/livepatch/core.h       |  2 +-
>  kernel/livepatch/transition.c |  2 +-
>  4 files changed, 15 insertions(+), 22 deletions(-)
> 
> diff --git a/include/linux/livepatch.h b/include/linux/livepatch.h
> index 9712818997c5..4dcebf52fac5 100644
> --- a/include/linux/livepatch.h
> +++ b/include/linux/livepatch.h
> @@ -169,7 +169,6 @@ struct klp_patch {
>  	struct list_head obj_list;
>  	bool enabled;
>  	bool forced;
> -	struct work_struct free_work;
>  };
>  
>  #define klp_for_each_object_static(patch, obj) \
> diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
> index 9ede093d699a..6cfc54f6bdcc 100644
> --- a/kernel/livepatch/core.c
> +++ b/kernel/livepatch/core.c
> @@ -337,6 +337,7 @@ static ssize_t enabled_store(struct kobject *kobj, struct kobj_attribute *attr,
>  	int ret;
>  	bool enabled;
>  	LIST_HEAD(to_free);
> +	struct kernfs_node *kn = NULL;
>  
>  	ret = kstrtobool(buf, &enabled);
>  	if (ret)
> @@ -369,7 +370,14 @@ static ssize_t enabled_store(struct kobject *kobj, struct kobj_attribute *attr,
>  out:
>  	mutex_unlock(&klp_mutex);
>  
> -	klp_free_patches_async(&to_free);
> +	if (list_empty(&to_free)) {
> +		kn = sysfs_break_active_protection(kobj, &attr->attr);
> +		WARN_ON_ONCE(!kn);
> +		sysfs_remove_file(kobj, &attr->attr);
> +		klp_free_patches(&to_free);
> +		if (kn)
> +			sysfs_unbreak_active_protection(kn);
> +	}
>  
>  	if (ret)
>  		return ret;
> @@ -684,32 +692,19 @@ static void klp_free_patch_finish(struct klp_patch *patch)
>  	kobject_put(&patch->kobj);
>  }
>  
> -/*
> - * The livepatch might be freed from sysfs interface created by the patch.
> - * This work allows to wait until the interface is destroyed in a separate
> - * context.
> - */
> -static void klp_free_patch_work_fn(struct work_struct *work)
> -{
> -	struct klp_patch *patch =
> -		container_of(work, struct klp_patch, free_work);
> -
> -	klp_free_patch_finish(patch);
> -}
> -
> -static void klp_free_patch_async(struct klp_patch *patch)
> +static void klp_free_patch(struct klp_patch *patch)
>  {
>  	klp_free_patch_start(patch);
> -	schedule_work(&patch->free_work);
> +	klp_free_patch_finish(patch);
>  }
>  
> -void klp_free_patches_async(struct list_head *to_free)
> +void klp_free_patches(struct list_head *to_free)
>  {
>  	struct klp_patch *patch, *tmp_patch;
>  
>  	list_for_each_entry_safe(patch, tmp_patch, to_free, list) {
>  		list_del_init(&patch->list);
> -		klp_free_patch_async(patch);
> +		klp_free_patch(patch);
>  	}
>  }
>  
> @@ -873,7 +868,6 @@ static int klp_init_patch_early(struct klp_patch *patch)
>  	kobject_init(&patch->kobj, &klp_ktype_patch);
>  	patch->enabled = false;
>  	patch->forced = false;
> -	INIT_WORK(&patch->free_work, klp_free_patch_work_fn);
>  
>  	klp_for_each_object_static(patch, obj) {
>  		if (!obj->funcs)
> diff --git a/kernel/livepatch/core.h b/kernel/livepatch/core.h
> index 8ff97745ba40..ea593f370049 100644
> --- a/kernel/livepatch/core.h
> +++ b/kernel/livepatch/core.h
> @@ -13,7 +13,7 @@ extern struct list_head klp_patches;
>  #define klp_for_each_patch(patch)	\
>  	list_for_each_entry(patch, &klp_patches, list)
>  
> -void klp_free_patches_async(struct list_head *to_free);
> +void klp_free_patches(struct list_head *to_free);
>  void klp_unpatch_replaced_patches(struct klp_patch *new_patch);
>  void klp_discard_nops(struct klp_patch *new_patch);
>  
> diff --git a/kernel/livepatch/transition.c b/kernel/livepatch/transition.c
> index a9ebc9c5db02..3eff5fc0deee 100644
> --- a/kernel/livepatch/transition.c
> +++ b/kernel/livepatch/transition.c
> @@ -41,7 +41,7 @@ static void klp_transition_work_fn(struct work_struct *work)
>  
>  	mutex_unlock(&klp_mutex);
>  
> -	klp_free_patches_async(&to_free);
> +	klp_free_patches(&to_free);
>  }
>  static DECLARE_DELAYED_WORK(klp_transition_work, klp_transition_work_fn);
>  
> -- 
> 2.31.1
> 
> 

Hi Ming,

The previous test runs without hung tasks, but I noticed that is
probably because the selftests quickly wedge.  A simple reproducer for
that:

# (background load)
% while(true); do make clean && make -j$(nproc); done
vs.
# (selftests)
% while(true); do ./tools/testing/selftests/livepatch/test-livepatch.sh || break; done
TEST: basic function patching ... ok
TEST: multiple livepatches ... ok
TEST: atomic replace livepatch ... ok
TEST: basic function patching ... ok
TEST: multiple livepatches ... ok
TEST: atomic replace livepatch ... ok
TEST: basic function patching ... ok
TEST: multiple livepatches ... ERROR: failed to disable livepatch test_klp_livepatch

% lsmod | grep test_klp
test_klp_livepatch     16384  1

% cat /sys/kernel/livepatch/test_klp_livepatch/enabled 
0

% rmmod test_klp_livepatch
rmmod: ERROR: Module test_klp_livepatch is in use

[  249.870587] ===== TEST: multiple livepatches =====
[  249.885520] % modprobe test_klp_livepatch
[  249.916987] livepatch: enabling patch 'test_klp_livepatch'
[  249.923131] livepatch: 'test_klp_livepatch': initializing patching transition
[  249.925575] livepatch: 'test_klp_livepatch': starting patching transition
[  249.934215] livepatch: 'test_klp_livepatch': completing patching transition
[  249.934337] livepatch: 'test_klp_livepatch': patching complete
[  249.946294] test_klp_livepatch: this has been live patched
[  249.963337] % modprobe test_klp_atomic_replace replace=0
[  249.996371] livepatch: enabling patch 'test_klp_atomic_replace'
[  250.002998] livepatch: 'test_klp_atomic_replace': initializing patching transition
[  250.005333] livepatch: 'test_klp_atomic_replace': starting patching transition
[  250.014364] livepatch: 'test_klp_atomic_replace': completing patching transition
[  250.014471] livepatch: 'test_klp_atomic_replace': patching complete
[  250.027259] test_klp_livepatch: this has been live patched
[  250.036050] test_klp_atomic_replace: this has been live patched
[  250.046347] % echo 0 > /sys/kernel/livepatch/test_klp_atomic_replace/enabled
[  250.054403] livepatch: 'test_klp_atomic_replace': initializing unpatching transition
[  250.054574] livepatch: 'test_klp_atomic_replace': starting unpatching transition
[  251.764849] livepatch: 'test_klp_atomic_replace': completing unpatching transition
[  251.799266] livepatch: 'test_klp_atomic_replace': unpatching complete
[  251.911706] % rmmod test_klp_atomic_replace
[  251.970438] test_klp_livepatch: this has been live patched
[  251.980347] % echo 0 > /sys/kernel/livepatch/test_klp_livepatch/enabled
[  251.987936] livepatch: 'test_klp_livepatch': initializing unpatching transition
[  251.988115] livepatch: 'test_klp_livepatch': starting unpatching transition
[  251.997033] livepatch: 'test_klp_livepatch': completing unpatching transition
[  252.027090] livepatch: 'test_klp_livepatch': unpatching complete
[  313.289932] ERROR: failed to disable livepatch test_klp_livepatch

In this case, the "failed to disable" msg occurs because the sysfs
interface / module remain present.

-- Joe

