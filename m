Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63BAC68ABA7
	for <lists+live-patching@lfdr.de>; Sat,  4 Feb 2023 18:37:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229825AbjBDRhf (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Sat, 4 Feb 2023 12:37:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229796AbjBDRhe (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Sat, 4 Feb 2023 12:37:34 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E05C12F7A2;
        Sat,  4 Feb 2023 09:37:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 769086098A;
        Sat,  4 Feb 2023 17:37:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 957FBC433D2;
        Sat,  4 Feb 2023 17:37:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675532252;
        bh=1U1Z524zoCUWJlT2wNaUdOjiKMhjT4Qq+6mopWLK6/I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NFBX0tXWirKx8UdH7+/3Wgv/iLN3ClN2pCELGaPjNu+lbF/Cyv5+xnS9k0RuEXrk7
         EYhCYfapnX1Ithoz4DcejWO0DLXWjk1/YuZMFSD57yIDqq7jN3T1tinwxRRjuYCZIR
         JzSFppa+wJcosh7CQQqyOef7J2XtxXGdkxD7mF+lAq++ydCIjwVUVBG8oBkDj49Sr0
         9VmjuzHZ4UUPj/etzWvjcBmVbe/+//MdvPmU/Ab4yzPa40iHrWg9pkaCDW/ao+Cxar
         BhdYIFGM3BkJq7YiAO4g/tt2Xp1fvy1WKj7TGexFBnrv20jpFPzieAI7X7pscvfmL+
         UALm3twqEx4ZA==
Date:   Sat, 4 Feb 2023 09:37:30 -0800
From:   Josh Poimboeuf <jpoimboe@kernel.org>
To:     Petr Mladek <pmladek@suse.com>
Cc:     Marcos Paulo de Souza <mpdesouza@suse.com>,
        linux-kernel@vger.kernel.org, live-patching@vger.kernel.org,
        jpoimboe@redhat.com, joe.lawrence@redhat.com
Subject: Re: [PATCH v2 4/4] livepatch/shadow: Add garbage collection of
 shadow variables
Message-ID: <20230204173730.d2w6rwjlok33ah7h@treble>
References: <20221026194122.11761-1-mpdesouza@suse.com>
 <20221026194122.11761-5-mpdesouza@suse.com>
 <20230201001817.ej7n3ehtgaxwr3pq@treble>
 <Y9uM94UOJWcNxnkI@alley>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Y9uM94UOJWcNxnkI@alley>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Thu, Feb 02, 2023 at 11:14:15AM +0100, Petr Mladek wrote:
> On Tue 2023-01-31 16:18:17, Josh Poimboeuf wrote:
> > On Wed, Oct 26, 2022 at 04:41:22PM -0300, Marcos Paulo de Souza wrote:
> > > The shadow variable type might then be added into a new @shadow_types
> > > member of struct klp_object. They will get then automatically registered
> > > and unregistered when the object is being livepatched. The registration
> > > increments the reference count. Unregistration decreases the reference
> > > count. All shadow variables of the given type are freed when the reference
> > > count reaches zero.
> > 
> > How does the automatic unregistration work for replaced patches?
> > 
> > I see klp_unpatch_replaced_patches() is called, but I don't see where it
> > ends up calling klp_shadow_unregister() for the replaced patch(es).
> 
> Great catch! I forgot that replaced patches are handled separately.
> We should do the following (on top of this patch):
> 
> --- a/kernel/livepatch/transition.c
> +++ b/kernel/livepatch/transition.c
> @@ -123,8 +123,11 @@ static void klp_complete_transition(void)
>  			continue;
>  		if (klp_target_state == KLP_PATCHED)
>  			klp_post_patch_callback(obj);
> -		else if (klp_target_state == KLP_UNPATCHED) {
> +		else if (klp_target_state == KLP_UNPATCHED)
>  			klp_post_unpatch_callback(obj);
> +
> +		if (klp_target_state == KLP_UNPATCHED ||
> +		    klp_transition_patch->replace) {
>  			klp_unregister_shadow_types(obj);
>  		}
>  	}

That calls klp_unregister_shadow_types() on the objects for
klp_transition_patch, which is the replacement patch, not the replaced
patch(es).

-- 
Josh
