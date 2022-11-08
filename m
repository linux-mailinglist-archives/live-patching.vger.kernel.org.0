Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A986621C20
	for <lists+live-patching@lfdr.de>; Tue,  8 Nov 2022 19:44:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230439AbiKHSoP (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 8 Nov 2022 13:44:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231403AbiKHSoP (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 8 Nov 2022 13:44:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 804BD1CB1E;
        Tue,  8 Nov 2022 10:44:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1E65A61738;
        Tue,  8 Nov 2022 18:44:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 409AFC433C1;
        Tue,  8 Nov 2022 18:44:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667933052;
        bh=YZJW9PuyAoD6FKJ/UVaOFmB4zzAmny7XDzRZ8U866ls=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uKMuOj7ZgE4rQVG/Id7yJnYLS+l5cFyEmQbemahxUICgTUwfSfXTzMAotn4pwUOCh
         QKSx/yyQpouolMAQdsFmB2fudp5uTKgCcZh1H+e/T63icv9/2+5cjeWALvFsKHSw6V
         BhMjQaUy4s5fYBKhpeBdDJ1394JGMLRZ8Iv1J2GNsnC69HBdd9Oa82TuMfh4Eq064D
         2b3QN8+RGXVJkUbUZeNU8NvtVBpnuueqOJwFS7VTDRRuzLez083/T8hBWK56NG8uMb
         bGVfc+Y7tEOZxz4V82euuYR922zBKzPYUO6CCUgL/KKiWSz70wv2Pfg+QN50WJCFux
         1k0+PJigOR7PQ==
Date:   Tue, 8 Nov 2022 10:44:10 -0800
From:   Josh Poimboeuf <jpoimboe@kernel.org>
To:     Petr Mladek <pmladek@suse.com>
Cc:     Nicolai Stange <nstange@suse.de>,
        Marcos Paulo de Souza <mpdesouza@suse.com>,
        linux-kernel@vger.kernel.org, live-patching@vger.kernel.org,
        jpoimboe@redhat.com, joe.lawrence@redhat.com
Subject: Re: [PATCH v2 4/4] livepatch/shadow: Add garbage collection of
 shadow variables
Message-ID: <20221108184410.qhpxhtbfryzeh6eq@treble>
References: <20221026194122.11761-1-mpdesouza@suse.com>
 <20221026194122.11761-5-mpdesouza@suse.com>
 <20221104010327.wa256pos75dczt4x@treble>
 <Y2TooogxxLTIkBcj@alley>
 <20221108013209.eqrxs3xqtat6kksm@treble>
 <Y2od6gc5oKeTHjIE@alley>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Y2od6gc5oKeTHjIE@alley>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue, Nov 08, 2022 at 10:14:18AM +0100, Petr Mladek wrote:
> On Mon 2022-11-07 17:32:09, Josh Poimboeuf wrote:
> > On Fri, Nov 04, 2022 at 11:25:38AM +0100, Petr Mladek wrote:
> > > > I get the feeling the latter would be easier to implement (no reference
> > > > counting; also maybe can be auto-detected with THIS_MODULE?) and harder
> > > > for the patch author to mess up (by accidentally omitting an object
> > > > which uses it).
> > > 
> > > I am not sure how you mean it. I guess that you suggest to store
> > > the name of the livepatch module into the shadow variable.
> > > And use the variable only when the livepatch module is still loaded.
> > 
> > Actually I was thinking the klp_patch could have references to all the
> > shadow variables (or shadow variable types?) it owns.
> 
> In short, you suggest to move the array of used klp_shadow_types from
> struct klp_object to struct klp_patch. Do I get it correctly?

Right.  Though, thinking about it more, this isn't even needed.  Each
klp_shadow would have a pointer to its owning module.  We already have a
global hash of klp_shadows which can be iterated when the module gets
unloaded or replaced.

> > 1) add 'struct module *owner' or 'struct klp_patch *owner' to klp_shadow
> > 
> > 2) add klp_shadow_alloc_gc() and klp_shadow_get_or_alloc_gc(), which are
> >    similar to their non-gc counterparts, with a few additional
> >    arguments: the klp module owner (THIS_MODULE for the caller); and a
> >    destructor to be used later for the garbage collection
> > 
> > 3) When atomic replacing a patch, iterate through the klp_shadow_hash
> >    and, for each klp_shadow which previously had an owner, change it to
> >    be owned by the new patch
> 
> This is not clear to me. The new livepatch might also use less shadow
> variables. It must not blindly take over all shadow variables which
> were owned by the previous livepatch.

Assuming atomic replace, the new patch is almost always a superset of
the old patch.  We can optimize for that case.

If the new patch needs to remove any old shadow variables, it can do so
in its post-patch callback.

> > 4) When unloading/freeing a patch, free all its associated klp_shadows
> >    (also calling destructors where applicable)
> > 
> > 
> > I'm thinking this would be easier for the patch author, and also simpler
> > overall.  I could work up a patch.
> 
> From the patch author POV:
> 
> If the autodetection did not work then the patch author would still
> need to provide the array of used shadow types. I agree that only
> one array in struct klp_patch might be enough.
> 
> 
> From the implementation POV:
> 
> I agree that the code might be easier if we support only atomic
> replace. We would not need the reference counter in this case.
> 
> But I am not sure if this is acceptable for users that do not use
> the atomic replace. They suffer from the same problem. Do we really
> want to make this mode a 2nd citizen? IMHO, all applicable features
> have been implemented for both modes so far.

Non-replace patches would still be supported.  Just with the restriction
that garbage-collected shadow variables are by definition owned by a
single patch module and thus can't be shared across patch modules.

-- 
Josh
