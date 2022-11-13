Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1493B6271D3
	for <lists+live-patching@lfdr.de>; Sun, 13 Nov 2022 19:51:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230525AbiKMSvo (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Sun, 13 Nov 2022 13:51:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235223AbiKMSvo (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Sun, 13 Nov 2022 13:51:44 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 089D226C7;
        Sun, 13 Nov 2022 10:51:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A6013B80C99;
        Sun, 13 Nov 2022 18:51:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1709FC433D6;
        Sun, 13 Nov 2022 18:51:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668365500;
        bh=U7MTYtRq7SXKMf781DEf7kOdL//W2sns95S2QvHfGK4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DB7X/kDKTWUFvqFqIFTLaxTGMLylnMhGw+D0DxGkakFobpXia06r/wJ/TwhQ1MHfb
         JEecZlXS+pIo81u1WgbwX37LvHi3tZz1wjk/4+6NaFAxbGGSCRMajRyUmooRqlancn
         oSkRZ8Pjo9U/HdrITn3gVz4x6bc/9bVHn3dNTHE14RjYOxRXs+MivGDTOEoJeiWdR0
         UjRsYuX0zudBTYkfgsizL2h3oel7a7WrUv9idrWank+AxGaAXj+fRDWKuVZmy7cRjp
         +Q2srlFNIw9MlbdtXXe3zuO7UHzSw/chfISjgdk1eYr+ksrQDOvFCBjRqAo2kJR3V8
         B1mY2QbWkerig==
Date:   Sun, 13 Nov 2022 10:51:38 -0800
From:   Josh Poimboeuf <jpoimboe@kernel.org>
To:     Petr Mladek <pmladek@suse.com>
Cc:     Nicolai Stange <nstange@suse.de>,
        Marcos Paulo de Souza <mpdesouza@suse.com>,
        linux-kernel@vger.kernel.org, live-patching@vger.kernel.org,
        jpoimboe@redhat.com, joe.lawrence@redhat.com
Subject: Re: [PATCH v2 4/4] livepatch/shadow: Add garbage collection of
 shadow variables
Message-ID: <20221113185138.oob2o3sevbgud5vs@treble>
References: <20221026194122.11761-1-mpdesouza@suse.com>
 <20221026194122.11761-5-mpdesouza@suse.com>
 <20221104010327.wa256pos75dczt4x@treble>
 <Y2TooogxxLTIkBcj@alley>
 <878rkhyhhv.fsf@linux.fritz.box>
 <Y24cGpeO8UHeiKGl@alley>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Y24cGpeO8UHeiKGl@alley>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Fri, Nov 11, 2022 at 10:55:38AM +0100, Petr Mladek wrote:
> > >From my experience, there are basically two relevant usage patterns of
> > shadow variables.
> > 1.) To hand over global state from one sublivepatch to its pendant in
> >     the to-be-applied livepatch module. Example: a new global mutex or
> >     alike.
> > 2.) The "regular" intended usage, attaching schadow variables to real
> >     (data) objects.
> > 
> > To manage lifetime for 1.), we usually implement some refcount scheme,
> > managed from the livepatches' module_init()/_exit(): the next livepatch
> > would subscribe to the shared state before the previous one got a chance
> > to release it. This works in practice, but the code related to it is
> > tedious to write and quite verbose.
> > 
> > The second usage pattern is much more difficult to implement correctly
> > in light of possible livepatch downgrades to a subset of
> > sublivepatches. Usually a sublivepatch making use of a shadow variable
> > attached to real objects would livepatch the associated object's
> > destruction code to free up the associated shadow, if any. If the next
> > livepatch to be applied happened to not contain this sublivepatch in
> > question as well, the destruction code would effectively become
> > unpatched, and any existing shadows leaked. Depending on the object type
> > in question, this memory leakage might or might not be an actual
> > problem, but it isn't nice either way.
> > 
> > Often, there's a more subtle issue with the latter usecase though: the
> > shadow continues to exist, but becomes unmaintained once the transitions
> > has started. If said sublivepatch happens to become reactivated later
> > on, it would potentially find stale shadows, and these could even get
> > wrongly associated with a completely different object which happened to
> > get allocated at the same memory address. Depending on the shadow type,
> > this might or might not be Ok. New per-object locks or a "TLB flush
> > needed" boolean would probably be Ok, but some kind of refcount would
> > certainly not. There's not much which could be done from the pre-unpatch
> > callbacks, because these aren't getting invoked for atomic-replace
> > downgrades.
> > 
> > We had quite some discussion internally on how to best approach these
> > limitations, the outcome being (IIRC), that a more versatile callbacks
> > support would perhaps quickly become too complex or error-prone to use
> > correctly. So Petr proposed this garbage collection/refcounting
> > mechanism posted here, which would solve the memory leakage issue as a
> > first step (and would make shadow variable usage less verbose IMO).
> > 
> > The consistency problem would still not be fully solved: consider a
> > refcount-like shadow, where during the transition some acquirer had been
> > unpatched already, while a releaser has not yet. But my hope is that we
> > can later build on this work here and somehow resolve this as well.

It would be great to have all this motivation for the new feature
documented in shadow-vars.rst.

> > > Nicolai, your have the practical experience. Should the reference
> > > counting be per-livepatched object or per-livepatch, please?
> > 
> > See above, I think it won't matter much from a functionality POV.
> 
> I would personally keep it tied together with the livepatched object
> just to be on the safe side.

If downgrades are going to be commonplace then I agree my automatic
detection idea wouldn't work so well.  And ref counting does make sense.

However I'm still not convinced that per-object is the way to go.
Doesn't that create more room for human error?  There's no way to
detect-and-warn if the wrong object is used, or if the variable is used
by multiple objects but only one of them is listed.

Per-patch shadow variable types would be easy to detect and warn on
misuse.  And easy to automate in patch author tooling.

Also, I'm not crazy about the new API.  It's even more confusing than
before.

-- 
Josh
