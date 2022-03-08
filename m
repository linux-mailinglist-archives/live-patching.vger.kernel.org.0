Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C91FF4D13D1
	for <lists+live-patching@lfdr.de>; Tue,  8 Mar 2022 10:51:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345456AbiCHJw0 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 8 Mar 2022 04:52:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345407AbiCHJwZ (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 8 Mar 2022 04:52:25 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE38941F9A;
        Tue,  8 Mar 2022 01:51:29 -0800 (PST)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 972741F397;
        Tue,  8 Mar 2022 09:51:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1646733088; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=rfVbrz8lg45qGvZsPo5VEWHFttjSpHtZNvUX7LzR6Kc=;
        b=Q/14xt4hxFEC3EFzitSjjIrDHD20ZIPHE9sAhGZv9bDKNlVYDwQxQ0keoh7JHnFGf4p52u
        kUvVaHNzmJV/h77ISdtMNYNhu2SU04s8RNFKDq8cQyYjYn6xDRXCQzbtG1T37aJ16joRHJ
        6MIEYsWQmkffQPzrMPkG85hpN6Iic+A=
Received: from suse.cz (unknown [10.100.224.162])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 78E8DA3B87;
        Tue,  8 Mar 2022 09:51:28 +0000 (UTC)
Date:   Tue, 8 Mar 2022 10:51:28 +0100
From:   Petr Mladek <pmladek@suse.com>
To:     Chengming Zhou <zhouchengming@bytedance.com>
Cc:     jpoimboe@redhat.com, jikos@kernel.org, mbenes@suse.cz,
        joe.lawrence@redhat.com, live-patching@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] livepatch: Don't block removal of patches that are
 safe to unload
Message-ID: <YicnIIatfgLc2NN2@alley>
References: <20220303105446.7152-1-zhouchengming@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220303105446.7152-1-zhouchengming@bytedance.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Thu 2022-03-03 18:54:46, Chengming Zhou wrote:
> module_put() is currently never called for a patch with forced flag, to block
> the removal of that patch module that might still be in use after a forced
> transition.
> 
> But klp_force_transition() will set all patches on the list to be forced, since
> commit d67a53720966 ("livepatch: Remove ordering (stacking) of the livepatches")
> has removed stack ordering of the livepatches, it will cause all other patches can't
> be unloaded after disabled even if they have completed the KLP_UNPATCHED transition.
> 
> In fact, we don't need to set a patch to forced if it's a KLP_PATCHED forced
> transition. It can still be unloaded safely as long as it has passed through
> the consistency model in KLP_UNPATCHED transition.

It really looks safe. klp_check_stack_func() makes sure that @new_func
is not on the stack when klp_target_state == KLP_UNPATCHED. As a
result, the system should not be using code from the livepatch module
when KLP_UNPATCHED transition cleanly finished.


> But the exception is when force transition of an atomic replace patch, we
> have to set all previous patches to forced, or they will be removed at
> the end of klp_try_complete_transition().
> 
> This patch only set the klp_transition_patch to be forced in KLP_UNPATCHED
> case, and keep the old behavior when in atomic replace case.
> 
> Signed-off-by: Chengming Zhou <zhouchengming@bytedance.com>
> ---
> v2: interact nicely with the atomic replace feature noted by Miroslav.
> ---
>  kernel/livepatch/transition.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/livepatch/transition.c b/kernel/livepatch/transition.c
> index 5683ac0d2566..34ffb8c014ed 100644
> --- a/kernel/livepatch/transition.c
> +++ b/kernel/livepatch/transition.c
> @@ -641,6 +641,10 @@ void klp_force_transition(void)
>  	for_each_possible_cpu(cpu)
>  		klp_update_patch_state(idle_task(cpu));
>  
> -	klp_for_each_patch(patch)
> -		patch->forced = true;
> +	if (klp_target_state == KLP_UNPATCHED)
> +		klp_transition_patch->forced = true;
> +	else if (klp_transition_patch->replace) {
> +		klp_for_each_patch(patch)
> +			patch->forced = true;

This works only because there is should be only one patch when
klp_target_state == KLP_UNPATCHED and
klp_transition_patch->forced == true.
But it is a bit tricky. I would do it the other way:

	if (klp_transition_patch->replace) {
		klp_for_each_patch(patch)
			patch->forced = true;
	} else if (klp_target_state == KLP_UNPATCHED) {
		klp_transition_patch->forced = true;
	}

It looks more sane. And it makes it more clear
that the special handling of KLP_UNPATCHED transition
is done only when the atomic replace is not used.

Otherwise, I do not see any real problem with the patch.

Best Regards,
Petr
