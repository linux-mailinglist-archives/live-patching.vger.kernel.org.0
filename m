Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E21F619469
	for <lists+live-patching@lfdr.de>; Fri,  4 Nov 2022 11:25:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231690AbiKDKZo (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 4 Nov 2022 06:25:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231309AbiKDKZn (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 4 Nov 2022 06:25:43 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D84C426116;
        Fri,  4 Nov 2022 03:25:40 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 71B261F8C1;
        Fri,  4 Nov 2022 10:25:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1667557539; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=umYuvfSYpaOMnHXO5/tfa93Xw+i4utk39bFTOZA4b+Y=;
        b=C1BmFJHcUygzu8U07Eaj/sxsK4vonaAfIucig1+vGHHold/zZg8FC6Z2ww+uWI9HPyHVUV
        h+bcttMF4LfMcjIgvZ76XquF9FacVQpStk+LN06iSih2nZzoL2862fSJWyIW+u/f8K4yS2
        6t0GXEY7eLJCfiodA5yy2YDcp7CmNfA=
Received: from suse.cz (unknown [10.100.208.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 53DE32C141;
        Fri,  4 Nov 2022 10:25:39 +0000 (UTC)
Date:   Fri, 4 Nov 2022 11:25:38 +0100
From:   Petr Mladek <pmladek@suse.com>
To:     Josh Poimboeuf <jpoimboe@kernel.org>,
        Nicolai Stange <nstange@suse.de>
Cc:     Marcos Paulo de Souza <mpdesouza@suse.com>,
        linux-kernel@vger.kernel.org, live-patching@vger.kernel.org,
        jpoimboe@redhat.com, joe.lawrence@redhat.com
Subject: Re: [PATCH v2 4/4] livepatch/shadow: Add garbage collection of
 shadow variables
Message-ID: <Y2TooogxxLTIkBcj@alley>
References: <20221026194122.11761-1-mpdesouza@suse.com>
 <20221026194122.11761-5-mpdesouza@suse.com>
 <20221104010327.wa256pos75dczt4x@treble>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221104010327.wa256pos75dczt4x@treble>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Thu 2022-11-03 18:03:27, Josh Poimboeuf wrote:
> On Wed, Oct 26, 2022 at 04:41:22PM -0300, Marcos Paulo de Souza wrote:
> > The life of shadow variables is not completely trivial to maintain.
> > They might be used by more livepatches and more livepatched objects.
> > They should stay as long as there is any user.
> > 
> > In practice, it requires to implement reference counting in callbacks
> > of all users. They should register all the user and remove the shadow
> > variables only when there is no user left.
> > 
> > This patch hides the reference counting into the klp_shadow API.
> > The counter is connected with the shadow variable @id. It requires
> > an API to take and release the reference. The release function also
> > calls the related dtor() when defined.
> > 
> > An easy solution would be to add some get_ref()/put_ref() API.
> > But it would need to get called from pre()/post_un() callbacks.
> > It might be easy to forget a callback and make it wrong.
> > 
> > A more safe approach is to associate the klp_shadow_type with
> > klp_objects that use the shadow variables. The livepatch core
> > code might then handle the reference counters on background.
> > 
> > The shadow variable type might then be added into a new @shadow_types
> > member of struct klp_object. They will get then automatically registered
> > and unregistered when the object is being livepatched. The registration
> > increments the reference count. Unregistration decreases the reference
> > count. All shadow variables of the given type are freed when the reference
> > count reaches zero.
> > 
> > All klp_shadow_alloc/get/free functions also checks whether the requested
> > type is registered. It will help to catch missing registration and might
> > also help to catch eventual races.
> 
> Is there a reason the shadow variable lifetime is tied to klp_object
> rather than klp_patch?

Good question!

My thinking was that shadow variables might be tight to variables
from a particular livepatched module. It would make sense to free them
when the only user (livepatched module) is removed.

The question is if it is really important. I did re-read the original
issue and the real problem was when the livepatch was reloaded.
The related variables were handled using livepatched code, then
without the livepatched code, and then with the livepatched code
again.

The variable was modified with the original code that was not aware of
the shadow variable. As a result the state of the shadow variable was
not in sync when it was later used again.

Nicolai, your have the practical experience. Should the reference
counting be per-livepatched object or per-livepatch, please?

> I get the feeling the latter would be easier to implement (no reference
> counting; also maybe can be auto-detected with THIS_MODULE?) and harder
> for the patch author to mess up (by accidentally omitting an object
> which uses it).

I am not sure how you mean it. I guess that you suggest to store
the name of the livepatch module into the shadow variable.
And use the variable only when the livepatch module is still loaded.

This would not help.

We use the reference counting because the shadow variables should
survive an atomic replace of the lifepatch. In this case, the related
variables are still handled using a livepatched code that is aware
of the shadow variables.

Also it does not solve the problem that the shadow variable might
get out of sync with the related variable when the same
livepatch gets reloaded.

Best Regards,
Petr
