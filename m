Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C0B5620BD9
	for <lists+live-patching@lfdr.de>; Tue,  8 Nov 2022 10:14:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233339AbiKHJOY (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 8 Nov 2022 04:14:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233313AbiKHJOY (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 8 Nov 2022 04:14:24 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B850DE96;
        Tue,  8 Nov 2022 01:14:23 -0800 (PST)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id C9E4E224A1;
        Tue,  8 Nov 2022 09:14:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1667898861; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=tQyf2Bea/AOHWwaWJvP1WJFWRYE/NVS0I5KxRCHvLIw=;
        b=AvRc1BlJoq1AQg4nXnlTTu/2k/iHDP0910RlLu7mz1U1/zzHeoXg2/n8zpaL9FYJgTne1B
        7GJ0I+Cx4DhT5/RBbo11jTBv9iM2Y1Gus6JaKinqOhEixD1YKz73yxHArdA32/Z+8Ehjkc
        3KPBH4koK1+gIAfCSGlD3wW7Giy8kzg=
Received: from suse.cz (unknown [10.100.208.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id AC5A72C142;
        Tue,  8 Nov 2022 09:14:21 +0000 (UTC)
Date:   Tue, 8 Nov 2022 10:14:18 +0100
From:   Petr Mladek <pmladek@suse.com>
To:     Josh Poimboeuf <jpoimboe@kernel.org>
Cc:     Nicolai Stange <nstange@suse.de>,
        Marcos Paulo de Souza <mpdesouza@suse.com>,
        linux-kernel@vger.kernel.org, live-patching@vger.kernel.org,
        jpoimboe@redhat.com, joe.lawrence@redhat.com
Subject: Re: [PATCH v2 4/4] livepatch/shadow: Add garbage collection of
 shadow variables
Message-ID: <Y2od6gc5oKeTHjIE@alley>
References: <20221026194122.11761-1-mpdesouza@suse.com>
 <20221026194122.11761-5-mpdesouza@suse.com>
 <20221104010327.wa256pos75dczt4x@treble>
 <Y2TooogxxLTIkBcj@alley>
 <20221108013209.eqrxs3xqtat6kksm@treble>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221108013209.eqrxs3xqtat6kksm@treble>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Mon 2022-11-07 17:32:09, Josh Poimboeuf wrote:
> On Fri, Nov 04, 2022 at 11:25:38AM +0100, Petr Mladek wrote:
> > > I get the feeling the latter would be easier to implement (no reference
> > > counting; also maybe can be auto-detected with THIS_MODULE?) and harder
> > > for the patch author to mess up (by accidentally omitting an object
> > > which uses it).
> > 
> > I am not sure how you mean it. I guess that you suggest to store
> > the name of the livepatch module into the shadow variable.
> > And use the variable only when the livepatch module is still loaded.
> 
> Actually I was thinking the klp_patch could have references to all the
> shadow variables (or shadow variable types?) it owns.

In short, you suggest to move the array of used klp_shadow_types from
struct klp_object to struct klp_patch. Do I get it correctly?


> Instead of reference counting, the livepatch atomic replace code could
> just migrate any previously owned shadow variables to the new klp_patch.

I see. We would not need to explicitly register the shadow type using
klp_shadow_register() and allocate struct klp_shadow_type_reg
for the reference counter.


> This of course adds the restriction that such garbage-collected shadow
> variables couldn't be shared across non-replace livepatches.  But I
> wouldn't expect that to be much of a problem.

From my POV, this is similar to "func_stack" in struct "klp_ops".
The list was originally designed for non-replace livepatches because
the same function might be livepatched many times.

It might theoretically get "simplified" when only the atomic replace is
supported. Then there would be the maximum of two livepatches
and the (infinite) list would be an overhead.

I say theoretically because the list is actually quite elegant
solution.


> Additionally, I was wondering if "which klp_patch owns which shadow
> variables" could be auto-detected somehow.
> 
> For example:
> 
> 1) add 'struct module *owner' or 'struct klp_patch *owner' to klp_shadow
> 
> 2) add klp_shadow_alloc_gc() and klp_shadow_get_or_alloc_gc(), which are
>    similar to their non-gc counterparts, with a few additional
>    arguments: the klp module owner (THIS_MODULE for the caller); and a
>    destructor to be used later for the garbage collection
> 
> 3) When atomic replacing a patch, iterate through the klp_shadow_hash
>    and, for each klp_shadow which previously had an owner, change it to
>    be owned by the new patch

This is not clear to me. The new livepatch might also use less shadow
variables. It must not blindly take over all shadow variables which
were owned by the previous livepatch.

> 4) When unloading/freeing a patch, free all its associated klp_shadows
>    (also calling destructors where applicable)
> 
> 
> I'm thinking this would be easier for the patch author, and also simpler
> overall.  I could work up a patch.

From the patch author POV:

If the autodetection did not work then the patch author would still
need to provide the array of used shadow types. I agree that only
one array in struct klp_patch might be enough.


From the implementation POV:

I agree that the code might be easier if we support only atomic
replace. We would not need the reference counter in this case.

But I am not sure if this is acceptable for users that do not use
the atomic replace. They suffer from the same problem. Do we really
want to make this mode a 2nd citizen? IMHO, all applicable features
have been implemented for both modes so far.

Best Regards,
Petr
