Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A96C94DB3D5
	for <lists+live-patching@lfdr.de>; Wed, 16 Mar 2022 16:01:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237227AbiCPPCW (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 16 Mar 2022 11:02:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231613AbiCPPCW (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 16 Mar 2022 11:02:22 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E23422BE3;
        Wed, 16 Mar 2022 08:01:04 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id ECF4E21123;
        Wed, 16 Mar 2022 15:01:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1647442862; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XaTng22aYFlv7NgcIe0v1KHMxXuvJ+qQDDO9xj7QADM=;
        b=UbQZbfx+JBsqITI8XSIZo49f/OYrzBsHhdFBiKt+N4P1igy2NUGhIofHT4pxJ0rWzB4ctP
        5Dv/rTBX+71DSJO1UNXbbLgrMu1y9ctA6fIhDKl7lsloZrGRH+T2YivKSvivFAcQvPKPPY
        wUb87PZ21wUAa95jeKIcpwWSMzncygk=
Received: from suse.cz (unknown [10.100.216.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 9683FA3B89;
        Wed, 16 Mar 2022 15:01:02 +0000 (UTC)
Date:   Wed, 16 Mar 2022 16:01:02 +0100
From:   Petr Mladek <pmladek@suse.com>
To:     Miroslav Benes <mbenes@suse.cz>
Cc:     Chengming Zhou <zhouchengming@bytedance.com>, jpoimboe@redhat.com,
        jikos@kernel.org, joe.lawrence@redhat.com,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        songmuchun@bytedance.com, qirui.001@bytedance.com
Subject: Re: [PATCH v3] livepatch: Don't block removal of patches that are
 safe to unload
Message-ID: <YjH7rniD4rBO6JIP@alley>
References: <20220312152220.88127-1-zhouchengming@bytedance.com>
 <alpine.LSU.2.21.2203161536330.6444@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.21.2203161536330.6444@pobox.suse.cz>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed 2022-03-16 15:48:25, Miroslav Benes wrote:
> On Sat, 12 Mar 2022, Chengming Zhou wrote:
> 
> > module_put() is not called for a patch with "forced" flag. It should
> > block the removal of the livepatch module when the code might still
> > be in use after forced transition.
> > 
> > klp_force_transition() currently sets "forced" flag for all patches on
> > the list.
> > 
> > In fact, any patch can be safely unloaded when it passed through
> > the consistency model in KLP_UNPATCHED transition.
> > 
> > By other words, the "forced" flag must be set only for livepatches
> 
> s/By/In/
> 
> > that are being removed. In particular, set the "forced" flag:
> > 
> >   + only for klp_transition_patch when the transition to KLP_UNPATCHED
> >     state was forced.
> > 
> >   + all replaced patches when the transition to KLP_PATCHED state was
> >     forced and the patch was replacing the existing patches.
> > 
> > index 5683ac0d2566..7f25a5ae89f6 100644
> > --- a/kernel/livepatch/transition.c
> > +++ b/kernel/livepatch/transition.c
> > @@ -641,6 +641,18 @@ void klp_force_transition(void)
> >  	for_each_possible_cpu(cpu)
> >  		klp_update_patch_state(idle_task(cpu));
> >  
> > -	klp_for_each_patch(patch)
> > -		patch->forced = true;
> > +	/*
> > +	 * Only need to set forced flag for the transition patch
> > +	 * when force transition to KLP_UNPATCHED state, but
> > +	 * have to set forced flag for all replaced patches
> > +	 * when force atomic replace transition.
> > +	 */
> 
> How about something like
> 
> /*
>  * Set forced flag for patches being removed, which is the transition
>  * patch in KLP_UNPATCHED state or all replaced patches when forcing
>  * the atomic replace transition.
>  */

Or just the first sentence:

	/* Set forced flag for patches being removed */

The rest is visible from the code.

Either version works for me. If we agree on it then I update
the text when pushing the patch.

Best Regards,
Petr
