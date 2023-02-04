Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DC3268AD89
	for <lists+live-patching@lfdr.de>; Sun,  5 Feb 2023 00:59:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229877AbjBDX7R (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Sat, 4 Feb 2023 18:59:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229713AbjBDX7Q (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Sat, 4 Feb 2023 18:59:16 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F4F925E0C;
        Sat,  4 Feb 2023 15:59:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D10F7B80B1F;
        Sat,  4 Feb 2023 23:59:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45B14C433D2;
        Sat,  4 Feb 2023 23:59:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675555152;
        bh=/9drqnIrirUoHxmY5BI9opQ3MN5M4i+Myc29SuPPUQs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XQ7ML1W/4uapPxR7t2iOARyq5c0tWWbliiox3vTYLzeG/YWLq+6Rl5krtPqF8hJX6
         uscdn25dRloVFFKoFRwrj2bDR70C7hENbogyKLo9bADhPo+CDrtlcLEcyW/4Runa+J
         44tCV3XZ0zqFm8l8pacXP37uzRYAZ5EhMFxSSobSUopqIgEYfbQo0S6m0jPwIQuJhe
         b/4ekv/cpABATLjaqGe+zGOL+Ow/wBa7WNhiUG0ZrmKS1bpXGAWBbVcdmM4NjkVgPc
         fQjCsxSM6IDIl6wBTwnBSW18ivY5r2ykd9BP5oJC8kYL09hI5ddzBuia3FO3f+sK7/
         JX5/57uLIjiGA==
Date:   Sat, 4 Feb 2023 15:59:10 -0800
From:   Josh Poimboeuf <jpoimboe@kernel.org>
To:     Petr Mladek <pmladek@suse.com>
Cc:     Nicolai Stange <nstange@suse.de>,
        Marcos Paulo de Souza <mpdesouza@suse.com>,
        linux-kernel@vger.kernel.org, live-patching@vger.kernel.org,
        jpoimboe@redhat.com, joe.lawrence@redhat.com
Subject: Re: [PATCH v2 4/4] livepatch/shadow: Add garbage collection of
 shadow variables
Message-ID: <20230204235910.4j4ame5ntqogqi7m@treble>
References: <20221026194122.11761-1-mpdesouza@suse.com>
 <20221026194122.11761-5-mpdesouza@suse.com>
 <20221104010327.wa256pos75dczt4x@treble>
 <Y2TooogxxLTIkBcj@alley>
 <20221108013209.eqrxs3xqtat6kksm@treble>
 <Y2od6gc5oKeTHjIE@alley>
 <20221108184410.qhpxhtbfryzeh6eq@treble>
 <Y2u659H1tZQfG0uQ@alley>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Y2u659H1tZQfG0uQ@alley>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed, Nov 09, 2022 at 03:36:23PM +0100, Petr Mladek wrote:
> > Right.  Though, thinking about it more, this isn't even needed.  Each
> > klp_shadow would have a pointer to its owning module.  We already have a
> > global hash of klp_shadows which can be iterated when the module gets
> > unloaded or replaced.
> >
> > Assuming atomic replace, the new patch is almost always a superset of
> > the old patch.  We can optimize for that case.
> 
> I see. But I do not agree with this assumption. The new livepatch
> might also remove code that caused problems.
> 
> Also we allow downgrades. I mean that there is no versioning
> of livepatches. Older livepatches might replace new ones.
> 
> We really want to support downgrades or upgrades that remove
> problematic code. Or upgrades that start fixing the problem
> a better way using another shadow variable.

So I've been thinking about this too...

I think it's good to support downgrades.  But even with this patch set,
they still aren't properly supported because of the callback design.

Unpatch callbacks aren't called for the replaced patch.  Any cleanup it
needs to do (e.g., for a downgrade) is skipped.  That can cause all
kinds of problems including leaks and conflicts with future patches.

And actually, that seems directly related to shadow variable garbage
collection.

Typically you would call 'klp_shadow_free_all(id, dtor)' in the
post_unpatch callback, *unless* that data is going to be used by the
replacement patch.

That "unless" is the problem.  Without that problem, garbage collection
of shadow variables would be trivial.

Thing is, that "unless" exists not only for the freeing of shadow
variables, but also for the allocation of some shadow variables in
pre/post-patch callbacks, and many other types of initializations and
cleanups done by patch/unpatch callbacks.

Correct me if I'm wrong, but it seems like downgrades (and similar
scenarios like upgrades with partial revert) are the primary real-world
motivation for this patch set.

These patches feel like a partial solution to a bigger problem.  If we
really want to support downgrade use cases, the callbacks will need to
be improved.

The main issue is that callbacks aren't called at the right times, and
they're not granular enough to support different levels of
upgrade/downgrade so that we can arbitrarily replace any patch with any
other version of the patch without consequence.

If the callbacks were split up and called only when they're needed, it
would be trivial to free the shadow variables in a post_unpatch
callback.


To support this we could have some kind of callback versioning, where a
klp_object can have an array of klp_callbacks, and each set of callbacks
has a version associated with it.

For example, consider a sequence of patches P1-P4, each of which is an
upgrade from the last.

(Note: I'm assuming only one klp_object here to keep it simple.)

- P1 has [ callbacks.version=1 ]
- P2 has [ callbacks.version=1 ]
- P3 has [ callbacks.version=1, callbacks.version=2 ]
- P4 has [ callbacks.version=1, callbacks.version=3 ]

Usually a patch will have the same callbacks (with same versions) as its
predecessor.  P1 and P2 have the same callbacks (v1).

If needed, a patch can then add an additional set of callbacks (with
bumped version) like P3.  Or it can remove its predecessor's callbacks.
Or it can do both, like P4.

When deciding which callbacks to call for a replace operation, it's
basically an XOR.  If a callback version exists in one patch but not the
other, its callbacks should be called.

For example, if P3 gets upgraded to P4, call P4's v3 patch callbacks and
P3's v2 unpatch callbacks.

If P4 gets downgraded to P1, call P4's v3 unpatch callbacks.

BTW, "version" may not be the right name, as there's no concept of newer
or older: any patch can be arbitrarily replaced by any other patch.  The
version is just a unique ID for a set of callbacks.

-- 
Josh
