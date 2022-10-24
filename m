Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 916B860B175
	for <lists+live-patching@lfdr.de>; Mon, 24 Oct 2022 18:25:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231126AbiJXQZQ (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 24 Oct 2022 12:25:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234895AbiJXQYg (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 24 Oct 2022 12:24:36 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1D4115B311
        for <live-patching@vger.kernel.org>; Mon, 24 Oct 2022 08:11:12 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 24D4322062;
        Mon, 24 Oct 2022 15:09:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1666624148; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=gO1sktYJByX9L/swgAsEkHeORfMvJs6RAo/GoxFfkaw=;
        b=YYRSFKlEMAHmGMghbEWovONqkfcvf9c277NnB9Bpt1SAZB2Q6hu25vc3PxRklprDO7boEk
        XnHTt1MAqOTrkmBvyJSqmWE7Ele9IAiZ3gGZaJCUvrk4Of/pqd7o47XMHwMXNizbRVc4T6
        /xc5qT6zPCdiG4xhAP+dXuSA5hHSjx0=
Received: from suse.cz (unknown [10.100.201.202])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 07E342C141;
        Mon, 24 Oct 2022 15:09:08 +0000 (UTC)
Date:   Mon, 24 Oct 2022 17:09:07 +0200
From:   Petr Mladek <pmladek@suse.com>
To:     Joe Lawrence <joe.lawrence@redhat.com>
Cc:     Marcos Paulo de Souza <mpdesouza@suse.com>,
        live-patching@vger.kernel.org, jpoimboe@redhat.com, mbenes@suse.cz,
        nstange@suse.de
Subject: Re: [PATCH 4/4] livepatch/shadow: Add garbage collection of shadow
 variables
Message-ID: <Y1aqkxKWnzVo7pfP@alley>
References: <20220701194817.24655-1-mpdesouza@suse.com>
 <20220701194817.24655-5-mpdesouza@suse.com>
 <b5fc2891-2fb0-4aa7-01dd-861da22bb7ea@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b5fc2891-2fb0-4aa7-01dd-861da22bb7ea@redhat.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Thu 2022-08-25 12:26:25, Joe Lawrence wrote:
> On 7/1/22 3:48 PM, Marcos Paulo de Souza wrote:
> > The life of shadow variables is not completely trivial to maintain.
> > They might be used by more livepatches and more livepatched objects.
> > They should stay as long as there is any user.
> > 
> > In practice, it requires to implement reference counting in callbacks
> > of all users. They should register all the user and remove the shadow
> > variables only when there is no user left.
> > 
> > This patch hides the reference counting into the klp_shadow API.
> > The counter is connected with the shadow variable @id. It requires
> > an API to take and release the reference. The release function also
> > calls the related dtor() when defined.
> > 
> > An easy solution would be to add some get_ref()/put_ref() API.
> > But it would need to get called from pre()/post_un() callbacks.
> > It might be easy to forget a callback and make it wrong.
> > 
> > A more safe approach is to associate the klp_shadow_type with
> > klp_objects that use the shadow variables. The livepatch core
> > code might then handle the reference counters on background.
> > 
> > The shadow variable type might then be added into a new @shadow_types
> > member of struct klp_object. They will get then automatically registered
> > and unregistered when the object is being livepatched. The registration
> > increments the reference count. Unregistration decreases the reference
> > count. All shadow variables of the given type are freed when the reference
> > count reaches zero.
> > 
> > All klp_shadow_alloc/get/free functions also checks whether the requested
> > type is registered. It will help to catch missing registration and might
> > also help to catch eventual races.
> > 
> 
> If I understand the patchset correctly, the last patch consolidated
> id/ctor/dtor into klp_shadow_type structure, then this one formally
> associates the new structure with a klp_object so that it bumps up /
> down a simple reference count automatically.  That count is now checked
> before calling the dtor/removal of any matching shadow variable.  So far
> so good.
> 
> How does this play out for the following scenario:
> 
> - atomic replace livepatches, accumulative versions
> - livepatch v1 : registers a klp_shadow_type (id=1), creates a few
> shadow vars
> - livepatch v2 : also uses klp_shadow_type (id=1) and creates a few
> shadow vars
> 
> Since the first livepatch registered the klp_shadow_type, its ctor/dtor
> pair will be used for all id=1 shadow variables, including those created
> by the subsequent livepatches, right?

The klp_shadow_*alloc() and klp_shdow_free*() APIs pass
struct *klp_shadow_type instead of the ID. The structure is
defined in each livepatch that is using this shadow variable.
As a result, each livepatch code is using @ctor/@dtor defined
in its own livepatch module. It actually behaves the same as before.

I though about storing pointers to @ctors/@dtors of all
registered klp_shadow_types from all livepatches. But it
would hard to choose which one should be used.

Note that some implementation might disappear when the livepatch
is replaced and the module removed.

So, it is easier when each caller passes its own structure
with its own implementation. They should be compatible anyway.

> 
> > Signed-off-by: Marcos Paulo de Souza <mpdesouza@suse.com>
> > Signed-off-by: Petr Mladek <pmladek@suse.com>
> > ---
> >  include/linux/livepatch.h                 |  21 ++++
> >  kernel/livepatch/core.c                   |  39 +++++++
> >  kernel/livepatch/core.h                   |   1 +
> >  kernel/livepatch/shadow.c                 | 124 ++++++++++++++++++++++
> >  kernel/livepatch/transition.c             |   4 +-
> >  lib/livepatch/test_klp_shadow_vars.c      |  18 +++-
> >  samples/livepatch/livepatch-shadow-fix1.c |   8 +-
> >  samples/livepatch/livepatch-shadow-fix2.c |   9 +-
> >  8 files changed, 214 insertions(+), 10 deletions(-)
> > 
> > diff --git a/include/linux/livepatch.h b/include/linux/livepatch.h
> > index 79e7bf3b35f6..cb65de831684 100644
> > --- a/include/linux/livepatch.h
> > +++ b/include/linux/livepatch.h
> > @@ -100,11 +100,14 @@ struct klp_callbacks {
> >  	bool post_unpatch_enabled;
> >  };
> >  
> > +struct klp_shadow_type;
> > +
> >  /**
> >   * struct klp_object - kernel object structure for live patching
> >   * @name:	module name (or NULL for vmlinux)
> >   * @funcs:	function entries for functions to be patched in the object
> >   * @callbacks:	functions to be executed pre/post (un)patching
> > + * @shadow_types: shadow variable types used by the livepatch for the klp_object
> >   * @kobj:	kobject for sysfs resources
> >   * @func_list:	dynamic list of the function entries
> >   * @node:	list node for klp_patch obj_list
> > @@ -118,6 +121,7 @@ struct klp_object {
> >  	const char *name;
> >  	struct klp_func *funcs;
> >  	struct klp_callbacks callbacks;
> > +	struct klp_shadow_type **shadow_types;
> >  
> 
> Hmm.  The implementation of shadow_types inside klp_object might be
> difficult to integrate into kpatch-build.  For kpatches, we do utilize
> the kernel's shadow variable API directly, but at kpatch author time we
> don't have any of klp_patch objects in hand -- those are generated by
> template after the binary before/after comparison is completed.

I am sorry but I am not much familiar with kPatch. But I am surprised.
It should be similar to klp_callbacks. If it was possible to define
struct klp_callbacks for a particular struct klp_object then it
should be possible to define struct klp_shadow_types ** similar way.

> My first thought is that kpatch-build might associate any shadow
> variables in foo.c with its parent object (vmlinux, foo.ko, etc.),
> however that may not always be 100% accurate.

I think that I would need to get more familiar with kPatch...

> In fact, we have occasionally used shadow variables with <id, 0> to
> create one off variables not associated with specific code or data
> structures, but rather the presence of livepatch.  This is (too) briefly
> mentioned in "Other use-cases" section of the shadow variable Documentation.

I think that we do this as well. AFAIK, we are going to associate them
with the klp_object for "vmlinux".

Best Regards,
Petr
