Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 369E6614820
	for <lists+live-patching@lfdr.de>; Tue,  1 Nov 2022 12:03:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229475AbiKALDR (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 1 Nov 2022 07:03:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbiKALDQ (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 1 Nov 2022 07:03:16 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 877D71705D
        for <live-patching@vger.kernel.org>; Tue,  1 Nov 2022 04:03:15 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id E44CD338A1;
        Tue,  1 Nov 2022 11:02:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1667300575; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=FLjYalIogy8Un073gAhCFss8D7/W/LvbvGKS5jUz0fQ=;
        b=rloeW1xOmOPvwPAKemCgC9FwwTOi0YPVtNqFLKo+ZlMxPLZiwfa93EOqm+8QNtpOh4V0us
        VmVm4HOxqouaHloqBinsTqTmYTQ07aWyHxZCtwzFRHj2NS6aBYFRi0rtsnVAElisvjoVt2
        tlInenQnqsEE0EMVewl3u+6ddr9ejuI=
Received: from suse.cz (unknown [10.100.208.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id C68A82C141;
        Tue,  1 Nov 2022 11:02:55 +0000 (UTC)
Date:   Tue, 1 Nov 2022 12:02:55 +0100
From:   Petr Mladek <pmladek@suse.com>
To:     Joe Lawrence <joe.lawrence@redhat.com>
Cc:     Marcos Paulo de Souza <mpdesouza@suse.com>,
        live-patching@vger.kernel.org, jpoimboe@redhat.com, mbenes@suse.cz,
        nstange@suse.de
Subject: Re: [PATCH 4/4] livepatch/shadow: Add garbage collection of shadow
 variables
Message-ID: <Y2D83wFbIcBoknQL@alley>
References: <20220701194817.24655-1-mpdesouza@suse.com>
 <20220701194817.24655-5-mpdesouza@suse.com>
 <b5fc2891-2fb0-4aa7-01dd-861da22bb7ea@redhat.com>
 <Y1aqkxKWnzVo7pfP@alley>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y1aqkxKWnzVo7pfP@alley>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Mon 2022-10-24 17:09:08, Petr Mladek wrote:
> On Thu 2022-08-25 12:26:25, Joe Lawrence wrote:
> > On 7/1/22 3:48 PM, Marcos Paulo de Souza wrote:
> > > The life of shadow variables is not completely trivial to maintain.
> > > They might be used by more livepatches and more livepatched objects.
> > > They should stay as long as there is any user.
> > > 
> > > In practice, it requires to implement reference counting in callbacks
> > > of all users. They should register all the user and remove the shadow
> > > variables only when there is no user left.
> > > 
> > > This patch hides the reference counting into the klp_shadow API.
> > > The counter is connected with the shadow variable @id. It requires
> > > an API to take and release the reference. The release function also
> > > calls the related dtor() when defined.
> > > 
> > > An easy solution would be to add some get_ref()/put_ref() API.
> > > But it would need to get called from pre()/post_un() callbacks.
> > > It might be easy to forget a callback and make it wrong.
> > > 
> > > A more safe approach is to associate the klp_shadow_type with
> > > klp_objects that use the shadow variables. The livepatch core
> > > code might then handle the reference counters on background.
> > > 
> > > The shadow variable type might then be added into a new @shadow_types
> > > member of struct klp_object. They will get then automatically registered
> > > and unregistered when the object is being livepatched. The registration
> > > increments the reference count. Unregistration decreases the reference
> > > count. All shadow variables of the given type are freed when the reference
> > > count reaches zero.
> > > 
> > > All klp_shadow_alloc/get/free functions also checks whether the requested
> > > type is registered. It will help to catch missing registration and might
> > > also help to catch eventual races.
> > > 
> > > --- a/include/linux/livepatch.h
> > > +++ b/include/linux/livepatch.h
> > > @@ -100,11 +100,14 @@ struct klp_callbacks {
> > >  	bool post_unpatch_enabled;
> > >  };
> > >  
> > > +struct klp_shadow_type;
> > > +
> > >  /**
> > >   * struct klp_object - kernel object structure for live patching
> > >   * @name:	module name (or NULL for vmlinux)
> > >   * @funcs:	function entries for functions to be patched in the object
> > >   * @callbacks:	functions to be executed pre/post (un)patching
> > > + * @shadow_types: shadow variable types used by the livepatch for the klp_object
> > >   * @kobj:	kobject for sysfs resources
> > >   * @func_list:	dynamic list of the function entries
> > >   * @node:	list node for klp_patch obj_list
> > > @@ -118,6 +121,7 @@ struct klp_object {
> > >  	const char *name;
> > >  	struct klp_func *funcs;
> > >  	struct klp_callbacks callbacks;
> > > +	struct klp_shadow_type **shadow_types;
> > >  
> > 
> > Hmm.  The implementation of shadow_types inside klp_object might be
> > difficult to integrate into kpatch-build.  For kpatches, we do utilize
> > the kernel's shadow variable API directly, but at kpatch author time we
> > don't have any of klp_patch objects in hand -- those are generated by
> > template after the binary before/after comparison is completed.
> 
> I am sorry but I am not much familiar with kPatch. But I am surprised.
> It should be similar to klp_callbacks. If it was possible to define
> struct klp_callbacks for a particular struct klp_object then it
> should be possible to define struct klp_shadow_types ** similar way.

Note that adding the used klp_shadow_types into struct klp_object
is not strictly required.

Alternative solution is to register/unregister the used types using
klp_callbacks or module init()/exit() callbacks. This approach
is used in lib/livepatch/test_klp_shadow_vars.c.

I believe that this would be usable for kpatch-build.
You needed to remove not-longer used shadow variables
using these callbacks even before this patchset. I would
consider it a bug if you did not remove them. The new API
just allows to do this a safe way.

Best Regards,
Petr
