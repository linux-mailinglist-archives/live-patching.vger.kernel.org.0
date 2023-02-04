Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98D2968AC1C
	for <lists+live-patching@lfdr.de>; Sat,  4 Feb 2023 20:34:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230358AbjBDTeJ (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Sat, 4 Feb 2023 14:34:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232127AbjBDTeI (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Sat, 4 Feb 2023 14:34:08 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A4A72D14E;
        Sat,  4 Feb 2023 11:34:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9851DB80B67;
        Sat,  4 Feb 2023 19:34:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2C72C433EF;
        Sat,  4 Feb 2023 19:34:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675539244;
        bh=AdY6TYSZFKpSo66Jq2l8vunuavfLcbgyFlV81LOhabE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=eOkUCQ6L8YYU3obvMeeYyGAUmMG12eWvnO7f7CHgMPqzSRJDgYdVRITc4TlAqTRoK
         lceCd/fqN/fceBmxa1BWyDRPO8a+yyeq2+br1sw79ujdlM0oLv8XMTo1oorZuhv07t
         fJcXerGYEnwNwNnEs+Sfr9/tCHF3GcEEuu8/hRoncS2mIy8yfEudst3b5YXxrC9JQF
         4i80X/f8IQeptHt1BEg0dlwuR9r8FDlkCtSaRVP9T6OWOqQ62ycFhYNHqpM4/9gXlF
         nl+XQtgXexpUh9W7IcJIlXrHcE29ho3AKrgdOjPZM6xi3SrkiO07d3g8Ciwj7ZiuWT
         d6vtUZZLtyGRQ==
Date:   Sat, 4 Feb 2023 11:34:02 -0800
From:   Josh Poimboeuf <jpoimboe@kernel.org>
To:     Petr Mladek <pmladek@suse.com>
Cc:     Nicolai Stange <nstange@suse.de>,
        Marcos Paulo de Souza <mpdesouza@suse.com>,
        linux-kernel@vger.kernel.org, live-patching@vger.kernel.org,
        jpoimboe@redhat.com, joe.lawrence@redhat.com
Subject: Re: [PATCH v2 4/4] livepatch/shadow: Add garbage collection of
 shadow variables
Message-ID: <20230204193402.rrbzeotpgdpieuaj@treble>
References: <20221026194122.11761-1-mpdesouza@suse.com>
 <20221026194122.11761-5-mpdesouza@suse.com>
 <20221104010327.wa256pos75dczt4x@treble>
 <Y2TooogxxLTIkBcj@alley>
 <878rkhyhhv.fsf@linux.fritz.box>
 <Y24cGpeO8UHeiKGl@alley>
 <20221113185138.oob2o3sevbgud5vs@treble>
 <Y8a4ZQ0sm5AOnY7R@alley>
 <20230125232248.inewq5tlpwfk3rny@treble>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230125232248.inewq5tlpwfk3rny@treble>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed, Jan 25, 2023 at 03:22:48PM -0800, Josh Poimboeuf wrote:
> On Tue, Jan 17, 2023 at 04:01:57PM +0100, Petr Mladek wrote:
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
> > 
> > IMHO, this is the reason why we should make it per-object.
> > 
> > If the shadow variable was used by a livepatched module and we remove
> > this module then the shadow variables would get unmaintained. It would
> > results in the problem described in this paragraph.
> 
> Yes, that makes sense.  Ok, I'm convinced.

I've been thinking about this some more, and this justification for
making it per-object no longer makes sense to me.

A shadow variable should follow the lifetime of its associated data
object, so the only way it would leak from an unloaded patched module
would be if there's a bug either in the patched module or in the
livepatch itself, right?

Or did I misunderstand your point?

-- 
Josh
