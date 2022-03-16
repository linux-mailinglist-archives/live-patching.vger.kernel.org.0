Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C885E4DB39C
	for <lists+live-patching@lfdr.de>; Wed, 16 Mar 2022 15:48:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242012AbiCPOtn (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 16 Mar 2022 10:49:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231273AbiCPOtm (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 16 Mar 2022 10:49:42 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A425B1A800;
        Wed, 16 Mar 2022 07:48:27 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 61F3C210E4;
        Wed, 16 Mar 2022 14:48:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1647442106; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=sNgiXVZBv6F6wyCvndqNofHIp7IwWtdhnCB8N/Uhyx4=;
        b=hothijYJO1hxPRBPTWSio0H1fgSSzQ8O7tk8VGs/WEuIfRvgvnwDzVWziL+njJmzW6wyFn
        VATT3K4e72LwlXcRj3rW+0WbHF7s9L+fpVx64QmLSbyMLwtHUQdxspy7+5OnijG2U+hrJS
        i9OUAEdd5u4u2QvpIpuWOodg7TL2S18=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1647442106;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=sNgiXVZBv6F6wyCvndqNofHIp7IwWtdhnCB8N/Uhyx4=;
        b=PKQl+BpgTe2MRagJZ4oRxzm6SS30ZxbcbTnqEeM2XrTInCRsMggLFOJzqWHHMc41bUhnSs
        yIjn9NvRSPch9PCA==
Received: from pobox.suse.cz (pobox.suse.cz [10.100.2.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 31C92A3B87;
        Wed, 16 Mar 2022 14:48:25 +0000 (UTC)
Date:   Wed, 16 Mar 2022 15:48:25 +0100 (CET)
From:   Miroslav Benes <mbenes@suse.cz>
To:     Chengming Zhou <zhouchengming@bytedance.com>
cc:     jpoimboe@redhat.com, jikos@kernel.org, pmladek@suse.com,
        joe.lawrence@redhat.com, live-patching@vger.kernel.org,
        linux-kernel@vger.kernel.org, songmuchun@bytedance.com,
        qirui.001@bytedance.com
Subject: Re: [PATCH v3] livepatch: Don't block removal of patches that are
 safe to unload
In-Reply-To: <20220312152220.88127-1-zhouchengming@bytedance.com>
Message-ID: <alpine.LSU.2.21.2203161536330.6444@pobox.suse.cz>
References: <20220312152220.88127-1-zhouchengming@bytedance.com>
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

On Sat, 12 Mar 2022, Chengming Zhou wrote:

> module_put() is not called for a patch with "forced" flag. It should
> block the removal of the livepatch module when the code might still
> be in use after forced transition.
> 
> klp_force_transition() currently sets "forced" flag for all patches on
> the list.
> 
> In fact, any patch can be safely unloaded when it passed through
> the consistency model in KLP_UNPATCHED transition.
> 
> By other words, the "forced" flag must be set only for livepatches

s/By/In/

> that are being removed. In particular, set the "forced" flag:
> 
>   + only for klp_transition_patch when the transition to KLP_UNPATCHED
>     state was forced.
> 
>   + all replaced patches when the transition to KLP_PATCHED state was
>     forced and the patch was replacing the existing patches.
> 
> Signed-off-by: Chengming Zhou <zhouchengming@bytedance.com>
> ---
> Changes in v3:
>  - rewrite more clear commit message by Petr.
> 
> Changes in v2:
>  - interact nicely with the atomic replace feature noted by Miroslav.
> ---
>  kernel/livepatch/transition.c | 16 ++++++++++++++--
>  1 file changed, 14 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/livepatch/transition.c b/kernel/livepatch/transition.c
> index 5683ac0d2566..7f25a5ae89f6 100644
> --- a/kernel/livepatch/transition.c
> +++ b/kernel/livepatch/transition.c
> @@ -641,6 +641,18 @@ void klp_force_transition(void)
>  	for_each_possible_cpu(cpu)
>  		klp_update_patch_state(idle_task(cpu));
>  
> -	klp_for_each_patch(patch)
> -		patch->forced = true;
> +	/*
> +	 * Only need to set forced flag for the transition patch
> +	 * when force transition to KLP_UNPATCHED state, but
> +	 * have to set forced flag for all replaced patches
> +	 * when force atomic replace transition.
> +	 */

How about something like

/*
 * Set forced flag for patches being removed, which is the transition
 * patch in KLP_UNPATCHED state or all replaced patches when forcing
 * the atomic replace transition.
 */

?

> +	if (klp_target_state == KLP_UNPATCHED)
> +		klp_transition_patch->forced = true;
> +	else if (klp_transition_patch->replace) {
> +		klp_for_each_patch(patch) {
> +			if (patch != klp_transition_patch)
> +				patch->forced = true;
> +		}
> +	}

Looks good to me.

Miroslav
