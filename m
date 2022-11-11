Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA37A62575E
	for <lists+live-patching@lfdr.de>; Fri, 11 Nov 2022 10:55:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232943AbiKKJzr (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 11 Nov 2022 04:55:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233338AbiKKJzq (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 11 Nov 2022 04:55:46 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25BFC6B238;
        Fri, 11 Nov 2022 01:55:43 -0800 (PST)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id A1F8020195;
        Fri, 11 Nov 2022 09:55:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1668160542; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=b1XE/Se5I0+DLupPxmBeBy4R6iBzoI28YYS3C1nC3ts=;
        b=ddAAIQqxm4+1CZLcBBAmTihoJJ4XBpPXHlqcZ7mR6G6llKYGc+KCI7bxV+OhI0pTVjhYN2
        NLFIzIJkJt6twldDIqZn6S1c/i16m0gjNqOUdNbqS4GFD7V1z59yNZJIk5tJS8XZIGvk1z
        +wDC9Qk8IvTcZTsSEKdg3qD4aQTjG5w=
Received: from suse.cz (unknown [10.100.208.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 7749C2C14E;
        Fri, 11 Nov 2022 09:55:42 +0000 (UTC)
Date:   Fri, 11 Nov 2022 10:55:38 +0100
From:   Petr Mladek <pmladek@suse.com>
To:     Nicolai Stange <nstange@suse.de>
Cc:     Josh Poimboeuf <jpoimboe@kernel.org>,
        Marcos Paulo de Souza <mpdesouza@suse.com>,
        linux-kernel@vger.kernel.org, live-patching@vger.kernel.org,
        jpoimboe@redhat.com, joe.lawrence@redhat.com
Subject: Re: [PATCH v2 4/4] livepatch/shadow: Add garbage collection of
 shadow variables
Message-ID: <Y24cGpeO8UHeiKGl@alley>
References: <20221026194122.11761-1-mpdesouza@suse.com>
 <20221026194122.11761-5-mpdesouza@suse.com>
 <20221104010327.wa256pos75dczt4x@treble>
 <Y2TooogxxLTIkBcj@alley>
 <878rkhyhhv.fsf@linux.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <878rkhyhhv.fsf@linux.fritz.box>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Fri 2022-11-11 10:20:44, Nicolai Stange wrote:
> Hi all,
> 
> Petr Mladek <pmladek@suse.com> writes:
> 
> > On Thu 2022-11-03 18:03:27, Josh Poimboeuf wrote:
> >> On Wed, Oct 26, 2022 at 04:41:22PM -0300, Marcos Paulo de Souza wrote:
> >> > The life of shadow variables is not completely trivial to maintain.
> >> > They might be used by more livepatches and more livepatched objects.
> >> > They should stay as long as there is any user.
> >> > 
> >> > In practice, it requires to implement reference counting in callbacks
> >> > of all users. They should register all the user and remove the shadow
> >> > variables only when there is no user left.
> >> > 
> >> > This patch hides the reference counting into the klp_shadow API.
> >> > The counter is connected with the shadow variable @id. It requires
> >> > an API to take and release the reference. The release function also
> >> > calls the related dtor() when defined.
> >> > 
> >> > An easy solution would be to add some get_ref()/put_ref() API.
> >> > But it would need to get called from pre()/post_un() callbacks.
> >> > It might be easy to forget a callback and make it wrong.
> >> > 
> >> > A more safe approach is to associate the klp_shadow_type with
> >> > klp_objects that use the shadow variables. The livepatch core
> >> > code might then handle the reference counters on background.
> >> > 
> >> > The shadow variable type might then be added into a new @shadow_types
> >> > member of struct klp_object. They will get then automatically registered
> >> > and unregistered when the object is being livepatched. The registration
> >> > increments the reference count. Unregistration decreases the reference
> >> > count. All shadow variables of the given type are freed when the reference
> >> > count reaches zero.
> >> > 
> >> > All klp_shadow_alloc/get/free functions also checks whether the requested
> >> > type is registered. It will help to catch missing registration and might
> >> > also help to catch eventual races.
> >> 
> >> Is there a reason the shadow variable lifetime is tied to klp_object
> >> rather than klp_patch?
> >
> > Good question!
> >
> > My thinking was that shadow variables might be tight to variables
> > from a particular livepatched module. It would make sense to free them
> > when the only user (livepatched module) is removed.
> >
> > The question is if it is really important.
> 
> I don't think so. For shadow variables attached to "real" data objects,
> I would expect those objects to be gone by the time the patched ko gets
> removed. For dummy shadows attached to NULL (see below), used for
> handing over shared state between atomic-replace livepatch modules, the
> memory footprint is negligible, I'd say.
> 
> OTOH, callbacks are per klp_object already, so for API consistency, it
> might make sense to stick to this pattern for the shadows as well. But I
> don't have a real opinion on this.

Good point!

> >From my experience, there are basically two relevant usage patterns of
> shadow variables.
> 1.) To hand over global state from one sublivepatch to its pendant in
>     the to-be-applied livepatch module. Example: a new global mutex or
>     alike.
> 2.) The "regular" intended usage, attaching schadow variables to real
>     (data) objects.
> 
> To manage lifetime for 1.), we usually implement some refcount scheme,
> managed from the livepatches' module_init()/_exit(): the next livepatch
> would subscribe to the shared state before the previous one got a chance
> to release it. This works in practice, but the code related to it is
> tedious to write and quite verbose.
> 
> The second usage pattern is much more difficult to implement correctly
> in light of possible livepatch downgrades to a subset of
> sublivepatches. Usually a sublivepatch making use of a shadow variable
> attached to real objects would livepatch the associated object's
> destruction code to free up the associated shadow, if any. If the next
> livepatch to be applied happened to not contain this sublivepatch in
> question as well, the destruction code would effectively become
> unpatched, and any existing shadows leaked. Depending on the object type
> in question, this memory leakage might or might not be an actual
> problem, but it isn't nice either way.
> 
> Often, there's a more subtle issue with the latter usecase though: the
> shadow continues to exist, but becomes unmaintained once the transitions
> has started. If said sublivepatch happens to become reactivated later
> on, it would potentially find stale shadows, and these could even get
> wrongly associated with a completely different object which happened to
> get allocated at the same memory address. Depending on the shadow type,
> this might or might not be Ok. New per-object locks or a "TLB flush
> needed" boolean would probably be Ok, but some kind of refcount would
> certainly not. There's not much which could be done from the pre-unpatch
> callbacks, because these aren't getting invoked for atomic-replace
> downgrades.
> 
> We had quite some discussion internally on how to best approach these
> limitations, the outcome being (IIRC), that a more versatile callbacks
> support would perhaps quickly become too complex or error-prone to use
> correctly. So Petr proposed this garbage collection/refcounting
> mechanism posted here, which would solve the memory leakage issue as a
> first step (and would make shadow variable usage less verbose IMO).
> 
> The consistency problem would still not be fully solved: consider a
> refcount-like shadow, where during the transition some acquirer had been
> unpatched already, while a releaser has not yet. But my hope is that we
> can later build on this work here and somehow resolve this as well.
> 
> > Nicolai, your have the practical experience. Should the reference
> > counting be per-livepatched object or per-livepatch, please?
> 
> See above, I think it won't matter much from a functionality POV.

I would personally keep it tied together with the livepatched object
just to be on the safe side.

Is this acceptable for kPatch users in the end?

Best Regards,
Petr
