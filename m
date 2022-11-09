Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C9EF622E0E
	for <lists+live-patching@lfdr.de>; Wed,  9 Nov 2022 15:36:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231590AbiKIOga (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 9 Nov 2022 09:36:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231213AbiKIOga (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 9 Nov 2022 09:36:30 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3F4C3A2;
        Wed,  9 Nov 2022 06:36:28 -0800 (PST)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 43E541FAB3;
        Wed,  9 Nov 2022 14:36:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1668004587; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=RK4f1H5YPdP8JjJ/U+5vet//t/WB+7YrMTLnpKKnQlI=;
        b=pSfZscTy0iQa1K0Zgsw1nk2XxmOkbvROXvTvi3iv/jPP0IzG1Yfs9IqrLaoldLwOwcITXp
        30t9wzNHXZIis/QBD1tdV4KB2Bult6sThZXCHj5urxUSPJuWCATVV3gtPWTCsvX8+0+KQg
        qH3tcuTSlbs4B8TKdk3hSNCHF6gyKrc=
Received: from suse.cz (unknown [10.100.201.202])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 264E82C141;
        Wed,  9 Nov 2022 14:36:27 +0000 (UTC)
Date:   Wed, 9 Nov 2022 15:36:23 +0100
From:   Petr Mladek <pmladek@suse.com>
To:     Josh Poimboeuf <jpoimboe@kernel.org>
Cc:     Nicolai Stange <nstange@suse.de>,
        Marcos Paulo de Souza <mpdesouza@suse.com>,
        linux-kernel@vger.kernel.org, live-patching@vger.kernel.org,
        jpoimboe@redhat.com, joe.lawrence@redhat.com
Subject: Re: [PATCH v2 4/4] livepatch/shadow: Add garbage collection of
 shadow variables
Message-ID: <Y2u659H1tZQfG0uQ@alley>
References: <20221026194122.11761-1-mpdesouza@suse.com>
 <20221026194122.11761-5-mpdesouza@suse.com>
 <20221104010327.wa256pos75dczt4x@treble>
 <Y2TooogxxLTIkBcj@alley>
 <20221108013209.eqrxs3xqtat6kksm@treble>
 <Y2od6gc5oKeTHjIE@alley>
 <20221108184410.qhpxhtbfryzeh6eq@treble>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221108184410.qhpxhtbfryzeh6eq@treble>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue 2022-11-08 10:44:10, Josh Poimboeuf wrote:
> On Tue, Nov 08, 2022 at 10:14:18AM +0100, Petr Mladek wrote:
> > On Mon 2022-11-07 17:32:09, Josh Poimboeuf wrote:
> > > On Fri, Nov 04, 2022 at 11:25:38AM +0100, Petr Mladek wrote:
> > > > > I get the feeling the latter would be easier to implement (no reference
> > > > > counting; also maybe can be auto-detected with THIS_MODULE?) and harder
> > > > > for the patch author to mess up (by accidentally omitting an object
> > > > > which uses it).
> > > > 
> > > > I am not sure how you mean it. I guess that you suggest to store
> > > > the name of the livepatch module into the shadow variable.
> > > > And use the variable only when the livepatch module is still loaded.
> > > 
> > > Actually I was thinking the klp_patch could have references to all the
> > > shadow variables (or shadow variable types?) it owns.
> > 
> > In short, you suggest to move the array of used klp_shadow_types from
> > struct klp_object to struct klp_patch. Do I get it correctly?
> 
> Right.  Though, thinking about it more, this isn't even needed.  Each
> klp_shadow would have a pointer to its owning module.  We already have a
> global hash of klp_shadows which can be iterated when the module gets
> unloaded or replaced.
>
> Assuming atomic replace, the new patch is almost always a superset of
> the old patch.  We can optimize for that case.

I see. But I do not agree with this assumption. The new livepatch
might also remove code that caused problems.

Also we allow downgrades. I mean that there is no versioning
of livepatches. Older livepatches might replace new ones.

We really want to support downgrades or upgrades that remove
problematic code. Or upgrades that start fixing the problem
a better way using another shadow variable.

I personally think that registering the supported klp_shadow_types
is worth the effort. It allows to do various changes a safe way.

Also it should be easy to make sure that all klp_shadow_types
are registered:

1. Grep might be used to find declarations in the source code.
   IMHO, it should work even with kPatch.

2. The klp_shadow_*() API will warn when a non-registered shadow
   variable is used. IMHO, this might be useful and catch some bugs
   on its own.

Best Regards,
Petr
