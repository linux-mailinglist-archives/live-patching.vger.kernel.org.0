Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 428424CB820
	for <lists+live-patching@lfdr.de>; Thu,  3 Mar 2022 08:51:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229620AbiCCHwj (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 3 Mar 2022 02:52:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbiCCHwi (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 3 Mar 2022 02:52:38 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E791DDD94B;
        Wed,  2 Mar 2022 23:51:53 -0800 (PST)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 9D90A218D9;
        Thu,  3 Mar 2022 07:51:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1646293912; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=lq4MwJ9oEF5X/5RUIbbzy1pe2UILNj8/E+/osWaO6ao=;
        b=3JrUpGllgdtpsJBkxQF/TtYQhaJ8cqLGfIYu+stU87AJx/HrNlP0bdImsEPw7izWgemF3n
        llz7W2EMq0LP6gEpJK8epmfYUUvFPaOU9Pks1IUOns4h06b/5OjRCh1IuVH2gznqAt9ZOY
        MBbUgjsOCFIWS8bCS9dPvWeLQElZqzc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1646293912;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=lq4MwJ9oEF5X/5RUIbbzy1pe2UILNj8/E+/osWaO6ao=;
        b=WqExyDwNOzc+GxUWSMaQb2qRorfAohmYA4gt00Yr34rMp2lgajCbBMIxxXMWww1DMChLUA
        W4f32MZkKOcm5FCw==
Received: from pobox.suse.cz (pobox.suse.cz [10.100.2.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id ED871A3B83;
        Thu,  3 Mar 2022 07:51:47 +0000 (UTC)
Date:   Thu, 3 Mar 2022 08:51:52 +0100 (CET)
From:   Miroslav Benes <mbenes@suse.cz>
To:     Chengming Zhou <zhouchengming@bytedance.com>
cc:     jpoimboe@redhat.com, jikos@kernel.org, pmladek@suse.com,
        joe.lawrence@redhat.com, live-patching@vger.kernel.org,
        linux-kernel@vger.kernel.org, songmuchun@bytedance.com,
        qirui.001@bytedance.com
Subject: Re: [External] Re: [PATCH] livepatch: Only block the removal of
 KLP_UNPATCHED forced transition patch
In-Reply-To: <fe2b9225-44c3-2041-f8a3-6f17f9d1be40@bytedance.com>
Message-ID: <alpine.LSU.2.21.2203030847430.704@pobox.suse.cz>
References: <20220301140840.29345-1-zhouchengming@bytedance.com> <alpine.LSU.2.21.2203021052470.5895@pobox.suse.cz> <fe2b9225-44c3-2041-f8a3-6f17f9d1be40@bytedance.com>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="1678380546-1492415682-1646293912=:704"
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--1678380546-1492415682-1646293912=:704
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Thu, 3 Mar 2022, Chengming Zhou wrote:

> Hi,
> 
> On 2022/3/2 5:55 下午, Miroslav Benes wrote:
> > Hi,
> > 
> > On Tue, 1 Mar 2022, Chengming Zhou wrote:
> > 
> >> module_put() is currently never called for a patch with forced flag, to block
> >> the removal of that patch module that might still be in use after a forced
> >> transition.
> >>
> >> But klp_force_transition() will flag all patches on the list to be forced, since
> >> commit d67a53720966 ("livepatch: Remove ordering (stacking) of the livepatches")
> >> has removed stack ordering of the livepatches, it will cause all other patches can't
> >> be unloaded after disabled even if they have completed the KLP_UNPATCHED transition.
> >>
> >> In fact, we don't need to flag a patch to forced if it's a KLP_PATCHED forced
> >> transition. It can still be unloaded only if it has passed through the consistency
> >> model in KLP_UNPATCHED transition.
> >>
> >> So this patch only set forced flag and block the removal of a KLP_UNPATCHED forced
> >> transition livepatch.
> >>
> >> Signed-off-by: Chengming Zhou <zhouchengming@bytedance.com>
> >> ---
> >>  kernel/livepatch/transition.c | 4 ++--
> >>  1 file changed, 2 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/kernel/livepatch/transition.c b/kernel/livepatch/transition.c
> >> index 5683ac0d2566..8b296ad9e407 100644
> >> --- a/kernel/livepatch/transition.c
> >> +++ b/kernel/livepatch/transition.c
> >> @@ -641,6 +641,6 @@ void klp_force_transition(void)
> >>  	for_each_possible_cpu(cpu)
> >>  		klp_update_patch_state(idle_task(cpu));
> >>  
> >> -	klp_for_each_patch(patch)
> >> -		patch->forced = true;
> >> +	if (klp_target_state == KLP_UNPATCHED)
> >> +		klp_transition_patch->forced = true;
> > 
> > I do not think this would interact nicely with the atomic replace feature. 
> > If you force the transition of a patch with ->replace set to true, no 
> > existing patch would get ->forced set with this change, which means all 
> > patches will be removed at the end of klp_try_complete_transition(). And 
> > that is something we want to prevent.
> 
> Good point, I should check if it's an atomic replace livepatch in the else
> branch, in which case we have to set all existing patches to forced.

Yes, but that leads to a question if it then brings any value. Forcing a 
transition should be exceptional. If it is needed, there may be other 
issues involved which should probably be fixed. Have you come across a 
practical situation where the patch helped?

Thanks

Miroslav
--1678380546-1492415682-1646293912=:704--
