Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00EDA66E190
	for <lists+live-patching@lfdr.de>; Tue, 17 Jan 2023 16:02:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229667AbjAQPC3 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 17 Jan 2023 10:02:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229708AbjAQPCC (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 17 Jan 2023 10:02:02 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2970A3E614;
        Tue, 17 Jan 2023 07:02:01 -0800 (PST)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id D50DC688FB;
        Tue, 17 Jan 2023 15:01:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1673967719; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=iWARP7rvIHyyCT02ol36led6jkTMP2g4Wa0/k9rI7T8=;
        b=a2w6YUszuwOKN1dOX8zmUYXuUu8ZGmAOnB5yahkSUIlhKLIteAUDs6GN6ZAukpaWRt4x73
        7ws0bcjK7qCX4tIiemTq48pJFyKH+aj02pkuDR/0+cOBAodr0AHa0ihCJTFmd7v4G4YhPK
        9jc1CjQ0wVBBEX53Jbd6TBPNxowCwmg=
Received: from suse.cz (unknown [10.100.208.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id B68A12C141;
        Tue, 17 Jan 2023 15:01:59 +0000 (UTC)
Date:   Tue, 17 Jan 2023 16:01:57 +0100
From:   Petr Mladek <pmladek@suse.com>
To:     Josh Poimboeuf <jpoimboe@kernel.org>
Cc:     Nicolai Stange <nstange@suse.de>,
        Marcos Paulo de Souza <mpdesouza@suse.com>,
        linux-kernel@vger.kernel.org, live-patching@vger.kernel.org,
        jpoimboe@redhat.com, joe.lawrence@redhat.com
Subject: Re: [PATCH v2 4/4] livepatch/shadow: Add garbage collection of
 shadow variables
Message-ID: <Y8a4ZQ0sm5AOnY7R@alley>
References: <20221026194122.11761-1-mpdesouza@suse.com>
 <20221026194122.11761-5-mpdesouza@suse.com>
 <20221104010327.wa256pos75dczt4x@treble>
 <Y2TooogxxLTIkBcj@alley>
 <878rkhyhhv.fsf@linux.fritz.box>
 <Y24cGpeO8UHeiKGl@alley>
 <20221113185138.oob2o3sevbgud5vs@treble>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221113185138.oob2o3sevbgud5vs@treble>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Hi,

I am sorry for answering this so late. It somehow fallen under cracks.

On Sun 2022-11-13 10:51:38, Josh Poimboeuf wrote:
> On Fri, Nov 11, 2022 at 10:55:38AM +0100, Petr Mladek wrote:
> > > >From my experience, there are basically two relevant usage patterns of
> > > shadow variables.
> > > 1.) To hand over global state from one sublivepatch to its pendant in
> > >     the to-be-applied livepatch module. Example: a new global mutex or
> > >     alike.
> > > 2.) The "regular" intended usage, attaching shadow variables to real
> > >     (data) objects.
> > > 
> > > To manage lifetime for 1.), we usually implement some refcount scheme,
> > > managed from the livepatches' module_init()/_exit(): the next livepatch
> > > would subscribe to the shared state before the previous one got a chance
> > > to release it. This works in practice, but the code related to it is
> > > tedious to write and quite verbose.
> > > 
> > > The second usage pattern is much more difficult to implement correctly
> > > in light of possible livepatch downgrades to a subset of
> > > sublivepatches. Usually a sublivepatch making use of a shadow variable
> > > attached to real objects would livepatch the associated object's
> > > destruction code to free up the associated shadow, if any. If the next
> > > livepatch to be applied happened to not contain this sublivepatch in
> > > question as well, the destruction code would effectively become
> > > unpatched, and any existing shadows leaked. Depending on the object type
> > > in question, this memory leakage might or might not be an actual
> > > problem, but it isn't nice either way.
> > > 
> > > Often, there's a more subtle issue with the latter usecase though: the
> > > shadow continues to exist, but becomes unmaintained once the transitions
> > > has started. If said sublivepatch happens to become reactivated later
> > > on, it would potentially find stale shadows, and these could even get
> > > wrongly associated with a completely different object which happened to
> > > get allocated at the same memory address. Depending on the shadow type,
> > > this might or might not be Ok. New per-object locks or a "TLB flush
> > > needed" boolean would probably be Ok, but some kind of refcount would
> > > certainly not. There's not much which could be done from the pre-unpatch
> > > callbacks, because these aren't getting invoked for atomic-replace
> > > downgrades.

IMHO, this is the reason why we should make it per-object.

If the shadow variable was used by a livepatched module and we remove
this module then the shadow variables would get unmaintained. It would
results in the problem described in this paragraph.

> > > We had quite some discussion internally on how to best approach these
> > > limitations, the outcome being (IIRC), that a more versatile callbacks
> > > support would perhaps quickly become too complex or error-prone to use
> > > correctly. So Petr proposed this garbage collection/refcounting
> > > mechanism posted here, which would solve the memory leakage issue as a
> > > first step (and would make shadow variable usage less verbose IMO).
> > > 
> > > The consistency problem would still not be fully solved: consider a
> > > refcount-like shadow, where during the transition some acquirer had been
> > > unpatched already, while a releaser has not yet. But my hope is that we
> > > can later build on this work here and somehow resolve this as well.
> 
> It would be great to have all this motivation for the new feature
> documented in shadow-vars.rst.
> 
> > > > Nicolai, your have the practical experience. Should the reference
> > > > counting be per-livepatched object or per-livepatch, please?
> > > 
> > > See above, I think it won't matter much from a functionality POV.
> > 
> > I would personally keep it tied together with the livepatched object
> > just to be on the safe side.
> 
> If downgrades are going to be commonplace then I agree my automatic
> detection idea wouldn't work so well.  And ref counting does make sense.
> 
> However I'm still not convinced that per-object is the way to go.
> Doesn't that create more room for human error?  There's no way to
> detect-and-warn if the wrong object is used, or if the variable is used
> by multiple objects but only one of them is listed.

I agree that these mistakes might happen. And I really do not see
any reasonable way how to auto-detect which livepatched object uses
which shadow variables.

Well, the per-object registration allows to register all shadow
types for the "vmlinux" object that is always loaded. It would
work as you suggested. I mean that it would keep the shadow variables
registered as long as the livepatch is loaded.

But I would still like to keep the registration per-object.
It would allow to handle re-load of livepatched modules
the right way when needed.

And I agree that we should document these pitfalls in the documentation.


> Per-patch shadow variable types would be easy to detect and warn on
> misuse.  And easy to automate in patch author tooling.
> 
> Also, I'm not crazy about the new API.  It's even more confusing than
> before.

I do not think that it made the API much worse. It actually made some
things more safe and easier.

The ctor/dtor callbacks are defined by the shadow type. It removes
the risk to passing a wrong one.

Also there is not need to free the unused shadow variables in
post_un() callbacks. It was actually pretty tricky because
it required the reference counting.

Best Regards,
Petr
