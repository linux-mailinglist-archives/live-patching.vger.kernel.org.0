Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF3444CA16A
	for <lists+live-patching@lfdr.de>; Wed,  2 Mar 2022 10:55:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240728AbiCBJzy (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 2 Mar 2022 04:55:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240708AbiCBJzv (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 2 Mar 2022 04:55:51 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA9B77DA99;
        Wed,  2 Mar 2022 01:55:08 -0800 (PST)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 550321F37E;
        Wed,  2 Mar 2022 09:55:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1646214907; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=UtRZPjqIyVkuTFVbEmS/q8EKiRdjfv+NaX4GERhTHdg=;
        b=Fn3DS5eY0YV0orabtu1sCEcvykpbOfOv3x3y24XDH+5qb0g7A1hig+ae49mwfOvRGXC8yk
        VECpoHF2NCIqhS+Yi1LHhfq4vH9LWHz9SMRniUguGsluNfyLVusH8lfWeaIuh9krbjo2+p
        YL0D4rmJ/fj9fgjD6Y2dcL6bwm9lahY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1646214907;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=UtRZPjqIyVkuTFVbEmS/q8EKiRdjfv+NaX4GERhTHdg=;
        b=lmELUlNgrXAZ8D+eX/tvlYd3+KAgpoqJ/VaBvY1cJlo0KQDB4lRlMdbFkciQeUeOS4plIu
        MqRXehx0wr7xkRBw==
Received: from pobox.suse.cz (pobox.suse.cz [10.100.2.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 3CFE9A3B81;
        Wed,  2 Mar 2022 09:55:06 +0000 (UTC)
Date:   Wed, 2 Mar 2022 10:55:06 +0100 (CET)
From:   Miroslav Benes <mbenes@suse.cz>
To:     Chengming Zhou <zhouchengming@bytedance.com>
cc:     jpoimboe@redhat.com, jikos@kernel.org, pmladek@suse.com,
        joe.lawrence@redhat.com, live-patching@vger.kernel.org,
        linux-kernel@vger.kernel.org, songmuchun@bytedance.com,
        qirui.001@bytedance.com
Subject: Re: [PATCH] livepatch: Only block the removal of KLP_UNPATCHED forced
 transition patch
In-Reply-To: <20220301140840.29345-1-zhouchengming@bytedance.com>
Message-ID: <alpine.LSU.2.21.2203021052470.5895@pobox.suse.cz>
References: <20220301140840.29345-1-zhouchengming@bytedance.com>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Hi,

On Tue, 1 Mar 2022, Chengming Zhou wrote:

> module_put() is currently never called for a patch with forced flag, to block
> the removal of that patch module that might still be in use after a forced
> transition.
> 
> But klp_force_transition() will flag all patches on the list to be forced, since
> commit d67a53720966 ("livepatch: Remove ordering (stacking) of the livepatches")
> has removed stack ordering of the livepatches, it will cause all other patches can't
> be unloaded after disabled even if they have completed the KLP_UNPATCHED transition.
> 
> In fact, we don't need to flag a patch to forced if it's a KLP_PATCHED forced
> transition. It can still be unloaded only if it has passed through the consistency
> model in KLP_UNPATCHED transition.
> 
> So this patch only set forced flag and block the removal of a KLP_UNPATCHED forced
> transition livepatch.
> 
> Signed-off-by: Chengming Zhou <zhouchengming@bytedance.com>
> ---
>  kernel/livepatch/transition.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/livepatch/transition.c b/kernel/livepatch/transition.c
> index 5683ac0d2566..8b296ad9e407 100644
> --- a/kernel/livepatch/transition.c
> +++ b/kernel/livepatch/transition.c
> @@ -641,6 +641,6 @@ void klp_force_transition(void)
>  	for_each_possible_cpu(cpu)
>  		klp_update_patch_state(idle_task(cpu));
>  
> -	klp_for_each_patch(patch)
> -		patch->forced = true;
> +	if (klp_target_state == KLP_UNPATCHED)
> +		klp_transition_patch->forced = true;

I do not think this would interact nicely with the atomic replace feature. 
If you force the transition of a patch with ->replace set to true, no 
existing patch would get ->forced set with this change, which means all 
patches will be removed at the end of klp_try_complete_transition(). And 
that is something we want to prevent.

Miroslav
