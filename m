Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62F1669B0C0
	for <lists+live-patching@lfdr.de>; Fri, 17 Feb 2023 17:24:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229478AbjBQQYe (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 17 Feb 2023 11:24:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbjBQQYd (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 17 Feb 2023 11:24:33 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C74AD9C;
        Fri, 17 Feb 2023 08:24:11 -0800 (PST)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 75625203DC;
        Fri, 17 Feb 2023 16:22:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1676650970; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=iydwwX98SZO8kz+kjOOLd9qxfJYz+EgvKVL6AXUh/Vs=;
        b=RGGkWRdrRyM4wPhmeSshqEiM7eY3O0szOIeyccQJrMsvs9l/bIwVEaownQXyhU2ohKoh5S
        0ReWFJzWgDf+oc1bUZJg5MV8L2QLaAy2FwGYPhvRyYpBHumjlzrKzq0ds2H9QEwUqixJF6
        5QKE97eIDB6YR92pb7YpwcdKhNZluOc=
Received: from suse.cz (unknown [10.163.25.46])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 3F3CA2C141;
        Fri, 17 Feb 2023 16:22:50 +0000 (UTC)
Date:   Fri, 17 Feb 2023 17:22:44 +0100
From:   Petr Mladek <pmladek@suse.com>
To:     Josh Poimboeuf <jpoimboe@kernel.org>
Cc:     Nicolai Stange <nstange@suse.de>,
        Marcos Paulo de Souza <mpdesouza@suse.com>,
        linux-kernel@vger.kernel.org, live-patching@vger.kernel.org,
        jpoimboe@redhat.com, joe.lawrence@redhat.com
Subject: Re: [PATCH v2 4/4] livepatch/shadow: Add garbage collection of
 shadow variables
Message-ID: <Y++p1HVE8dLQT3Nl@alley>
References: <20221026194122.11761-1-mpdesouza@suse.com>
 <20221026194122.11761-5-mpdesouza@suse.com>
 <20221104010327.wa256pos75dczt4x@treble>
 <Y2TooogxxLTIkBcj@alley>
 <20221108013209.eqrxs3xqtat6kksm@treble>
 <Y2od6gc5oKeTHjIE@alley>
 <20221108184410.qhpxhtbfryzeh6eq@treble>
 <Y2u659H1tZQfG0uQ@alley>
 <20230204235910.4j4ame5ntqogqi7m@treble>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230204235910.4j4ame5ntqogqi7m@treble>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Sat 2023-02-04 15:59:10, Josh Poimboeuf wrote:
> On Wed, Nov 09, 2022 at 03:36:23PM +0100, Petr Mladek wrote:
> > We really want to support downgrades or upgrades that remove
> > problematic code. Or upgrades that start fixing the problem
> > a better way using another shadow variable.
> 
> So I've been thinking about this too...
> 
> I think it's good to support downgrades.  But even with this patch set,
> they still aren't properly supported because of the callback design.
> 
> Unpatch callbacks aren't called for the replaced patch.  Any cleanup it
> needs to do (e.g., for a downgrade) is skipped.  That can cause all
> kinds of problems including leaks and conflicts with future patches.
> 
> And actually, that seems directly related to shadow variable garbage
> collection.
> 
> Typically you would call 'klp_shadow_free_all(id, dtor)' in the
> post_unpatch callback, *unless* that data is going to be used by the
> replacement patch.

Exactly.

> That "unless" is the problem.  Without that problem, garbage collection
> of shadow variables would be trivial.
>
> Thing is, that "unless" exists not only for the freeing of shadow
> variables, but also for the allocation of some shadow variables in
> pre/post-patch callbacks, and many other types of initializations and
> cleanups done by patch/unpatch callbacks.

Yes.

> Correct me if I'm wrong, but it seems like downgrades (and similar
> scenarios like upgrades with partial revert) are the primary real-world
> motivation for this patch set.

Yes.

> These patches feel like a partial solution to a bigger problem.  If we
> really want to support downgrade use cases, the callbacks will need to
> be improved.

You are right. All this started when I discussed problems with writing
livepatch callbacks with Nicolai. I tried to make it easier by
introducing the klp_state API. But Nicolai realized that it was
still too hard.

The garbage collection was an idea how to easily handle the most
common case, see below.


> The main issue is that callbacks aren't called at the right times, and
> they're not granular enough to support different levels of
> upgrade/downgrade so that we can arbitrarily replace any patch with any
> other version of the patch without consequence.
> 
> If the callbacks were split up and called only when they're needed, it
> would be trivial to free the shadow variables in a post_unpatch
> callback.
> 
> To support this we could have some kind of callback versioning, where a
> klp_object can have an array of klp_callbacks, and each set of callbacks
> has a version associated with it.
> 
> For example, consider a sequence of patches P1-P4, each of which is an
> upgrade from the last.
> 
> (Note: I'm assuming only one klp_object here to keep it simple.)
> 
> - P1 has [ callbacks.version=1 ]
> - P2 has [ callbacks.version=1 ]
> - P3 has [ callbacks.version=1, callbacks.version=2 ]
> - P4 has [ callbacks.version=1, callbacks.version=3 ]
>
> Usually a patch will have the same callbacks (with same versions) as its
> predecessor.  P1 and P2 have the same callbacks (v1).
> 
> If needed, a patch can then add an additional set of callbacks (with
> bumped version) like P3.  Or it can remove its predecessor's callbacks.
> Or it can do both, like P4.
> 
> When deciding which callbacks to call for a replace operation, it's
> basically an XOR.  If a callback version exists in one patch but not the
> other, its callbacks should be called.
> 
> For example, if P3 gets upgraded to P4, call P4's v3 patch callbacks and
> P3's v2 unpatch callbacks.
> 
> If P4 gets downgraded to P1, call P4's v3 unpatch callbacks.
> 
> BTW, "version" may not be the right name, as there's no concept of newer
> or older: any patch can be arbitrarily replaced by any other patch.  The
> version is just a unique ID for a set of callbacks.

Yes, we discussed various possibilities and it was always getting pretty
complex.

The most promising direction with the callbacks was connecting
the callbacks with the klp_state. They are versioned as you
suggest above. And we could have callbacks:

    + state_prepare    (instead of pre_patch)
    + state_enable     (instead of post_patch)
    + state_disable    (instead of pre_unpatch)
    + state_cleanup    (instead of pre_unpatch)

The above callbacks would be called only when the state is new.
We might need more callbacks if the support update/downgrade to
another version of the state:

    + state_update_prepare       (instead of pre_patch)
    + state_update_enable        (instead of post_patch)
    + state_downgrade_prepare    (instead of pre_unpatch)
    + state_downgrade_cleanup    (instead of pre_unpatch)

Also we might some callbacks when an action is needed to take
over the state from the previous livepatch:

    + state_take_over_prepare       (instead of pre_patch and pre_unpatch?)
    + state_take_over_enable        (instead of post_patch and post_unpatch?)

IMHO, it is better than the current state. It better describes
the complexity of the problem. It forces/allows livepatch authors
to handle all scenarios correctly.

Anyway, it is complex. The authors have to understand when exactly
each callback will be called. Also some callbacks might be called
from the old-to-be-replaced and some from the new-to-be-used livepatch.

We discussed various use-cases and realized that shadow variables
were very common use case. I have just double checked it and
it seems that we used:

   + post_patch callback for two CVEs
   + klp_shadow_free() for 14 CVEs

This is where the idea of the garbage collection came from. It looked
like an elegant solution for the most common use case. So that
livepatch authors do not need to think about the rather complex
ordering of the many callbacks. They would just register/define
the shadow variable type and be done.

Well, the single state_cleanup() callback would usually be
enough for the shadow variables.


Conclusion:

You are right that the shadow variables and callbacks
are connected. Or more precisely, the shadow variables and
klp_states have similar life-time handling. They both
are introduced/transfered/removed.

Maybe, we could merge klp_shadow and klp_state into a single
entity that would support versioning and various callbacks.

I am just not sure how the entity would be called.
The name is important because it should be clear what it
means and how it can be used. The unification and bad name
might cause more harm then good.

Note that the meaning is a bit different. klp_shadow is
for storing data. klp_state rather describes a change
of the behavior done by a callback.

IMHO, there does not exist 1:1 relation between shadow
variables and states. Using a particular shadow variable
type might define a system state. But a callback might
change a system state even without using shadow variables.

Another small problem is that klp_state is currently in
struct klp_livepatch. And it would be more safe to register
klp_shadow_type in struct klp_object.

Best Regards,
Petr
