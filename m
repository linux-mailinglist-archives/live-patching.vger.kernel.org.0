Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B99954D4F51
	for <lists+live-patching@lfdr.de>; Thu, 10 Mar 2022 17:30:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239692AbiCJQbs (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 10 Mar 2022 11:31:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241402AbiCJQbk (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 10 Mar 2022 11:31:40 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F07E7190C28;
        Thu, 10 Mar 2022 08:30:38 -0800 (PST)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 993FC21106;
        Thu, 10 Mar 2022 16:30:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1646929837; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rtb1rpQqcRQCkvtCGrkuFprYkSi8v2+4VhQD8sTU1iQ=;
        b=fTC/GF69dbM0prQum/0nJ3Pn9C7bea80Rr6+qNB0x1hp7/ZlBD9X2pvwglJpCvcc/+Ykbt
        S5b2oKS292hYBN3q4ALs27OSkeVf/8ebPH4HUpnJzGeWErc3AKlXwY35yrreGb0k+9qP+k
        YmhzroE5OASmlta5LQd2va+kFWy6joY=
Received: from suse.cz (unknown [10.100.224.162])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 7C0AAA3B83;
        Thu, 10 Mar 2022 16:30:37 +0000 (UTC)
Date:   Thu, 10 Mar 2022 17:30:34 +0100
From:   Petr Mladek <pmladek@suse.com>
To:     Chengming Zhou <zhouchengming@bytedance.com>
Cc:     Miroslav Benes <mbenes@suse.cz>, jpoimboe@redhat.com,
        jikos@kernel.org, joe.lawrence@redhat.com,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [External] Re: [PATCH v2] livepatch: Don't block removal of
 patches that are safe to unload
Message-ID: <Yionqn3d9OQF4UiT@alley>
References: <20220303105446.7152-1-zhouchengming@bytedance.com>
 <YicnIIatfgLc2NN2@alley>
 <alpine.LSU.2.21.2203081842120.9394@pobox.suse.cz>
 <849e57ee-d412-30bd-3cce-47ce3362409d@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <849e57ee-d412-30bd-3cce-47ce3362409d@bytedance.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Thu 2022-03-10 20:57:54, Chengming Zhou wrote:
> Hi,
> 
> On 2022/3/9 1:49 上午, Miroslav Benes wrote:
> > On Tue, 8 Mar 2022, Petr Mladek wrote:
> > 
> >> On Thu 2022-03-03 18:54:46, Chengming Zhou wrote:
> >>> module_put() is currently never called for a patch with forced flag, to block
> >>> the removal of that patch module that might still be in use after a forced
> >>> transition.
> >>>
> >>> But klp_force_transition() will set all patches on the list to be forced, since
> >>> commit d67a53720966 ("livepatch: Remove ordering (stacking) of the livepatches")
> >>> has removed stack ordering of the livepatches, it will cause all other patches can't
> >>> be unloaded after disabled even if they have completed the KLP_UNPATCHED transition.
> >>>
> >>> In fact, we don't need to set a patch to forced if it's a KLP_PATCHED forced
> >>> transition. It can still be unloaded safely as long as it has passed through
> >>> the consistency model in KLP_UNPATCHED transition.
> >>
> >> It really looks safe. klp_check_stack_func() makes sure that @new_func
> >> is not on the stack when klp_target_state == KLP_UNPATCHED. As a
> >> result, the system should not be using code from the livepatch module
> >> when KLP_UNPATCHED transition cleanly finished.
> >>
> >>
> >>> But the exception is when force transition of an atomic replace patch, we
> >>> have to set all previous patches to forced, or they will be removed at
> >>> the end of klp_try_complete_transition().
> >>>
> >>> This patch only set the klp_transition_patch to be forced in KLP_UNPATCHED
> >>> case, and keep the old behavior when in atomic replace case.
> >>>
> >>> Signed-off-by: Chengming Zhou <zhouchengming@bytedance.com>
> >>> ---
> >>> v2: interact nicely with the atomic replace feature noted by Miroslav.
> >>> ---
> >>>  kernel/livepatch/transition.c | 8 ++++++--
> >>>  1 file changed, 6 insertions(+), 2 deletions(-)
> >>>
> >>> diff --git a/kernel/livepatch/transition.c b/kernel/livepatch/transition.c
> >>> index 5683ac0d2566..34ffb8c014ed 100644
> >>> --- a/kernel/livepatch/transition.c
> >>> +++ b/kernel/livepatch/transition.c
> >>> @@ -641,6 +641,10 @@ void klp_force_transition(void)
> >>>  	for_each_possible_cpu(cpu)
> >>>  		klp_update_patch_state(idle_task(cpu));
> >>>  
> >>> -	klp_for_each_patch(patch)
> >>> -		patch->forced = true;
> >>> +	if (klp_target_state == KLP_UNPATCHED)
> >>> +		klp_transition_patch->forced = true;
> >>> +	else if (klp_transition_patch->replace) {
> >>> +		klp_for_each_patch(patch)
> >>> +			patch->forced = true;
> >>
> >> This works only because there is should be only one patch when
> >> klp_target_state == KLP_UNPATCHED and
> >> klp_transition_patch->forced == true.
> > 
> > I probably misunderstand, but the above is not generally true, is it? I 
> > mean, if the transition patch is forced during its disablement, it does 
> > not say anything about the amount of enabled patches.
> > 
> >> But it is a bit tricky. I would do it the other way:
> >>
> >> 	if (klp_transition_patch->replace) {
> >> 		klp_for_each_patch(patch)
> >> 			patch->forced = true;
> >> 	} else if (klp_target_state == KLP_UNPATCHED) {
> >> 		klp_transition_patch->forced = true;
> >> 	}
> >>
> >> It looks more sane. And it makes it more clear
> >> that the special handling of KLP_UNPATCHED transition
> >> is done only when the atomic replace is not used.
> > 
> > But it is not the same. ->replace being true only comes into play when a 
> > patch is enabled. If it is disabled, then it behaves like any other patch.
> > 
> > So, if there is ->replace patch enabled (and it is the only patch present) 
> > and then more !->replace patches are loaded and then if ->replace patch is 
> > disabled and forced, your proposal would give a different result than what 
> > Chengming submitted, because in your case all the other patches will get 
> > ->forced set to true, while it is not the case in the original. It would 
> > be an unnecessary restriction if I am not missing something.
> 
> At first glance, I thought both way is right. But after looking at the case
> you mentioned above, they are not the same indeed. The original patch
> treat ->replace and not ->replace patches the same in KLP_UNPATCHED transition,
> and only set all patches to forced in the atomic replace transition.

I see. OK, Chengming's code makes sense. But we should make the commit
message more clear. Something like:

<draft>
module_put() is not called for a patch with "forced" flag. It should
block the removal of the livepatch module when the code might still
be in use after forced transition.

klp_force_transition() currently sets "force" flag for all patches on
the list.

In fact, any patch can be safely unloaded when it passed through
the consistency model in KLP_UNPATCHED transition.

By other words, the "forced" flag must be set only for livepatches
that are being removed. In particular, set the "forced" flag:

  + only for klp_transition_patch when the transition to KLP_UNPATCHED
    state was forced.

  + all replaced patches when the transition to KLP_PATCHED state was
    forced and the patch was replacing the existing patches.
</draft>

It means that we should could actually do:

	if (klp_target_state == KLP_UNPATCHED) {
		klp_transition_patch->forced = true;
	} else if (klp_transition_patch->replace) {
		klp_for_each_patch(patch) {
			if (patch != klp_transition_patch)
				patch->forced = true;
		}
	}

Huh, that is tricky ;-)

Best Regards,
Petr
