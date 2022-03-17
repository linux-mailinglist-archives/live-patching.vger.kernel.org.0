Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30CDD4DCDBC
	for <lists+live-patching@lfdr.de>; Thu, 17 Mar 2022 19:38:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237477AbiCQSkE (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 17 Mar 2022 14:40:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237476AbiCQSkD (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 17 Mar 2022 14:40:03 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0E011DEC2E;
        Thu, 17 Mar 2022 11:38:46 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 5653F210FC;
        Thu, 17 Mar 2022 18:38:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1647542325; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=LBacharOGiwQ08qhwNeSRWmmgP1vxvAH8sHIAd4C4U0=;
        b=MdDOtVyxovBp1evqe2Cv2pc6XovHQmgrdbc+TUVi3ahCx6pATF8S9HbLQlbgxsvPI2Qe+n
        MlDaUfo9A30RdzJXiHfF+6mbhTSbkRkN2YTQ8DZUAwdSU+YqQ7m0ZVQ7/NKG54yTpbj9eU
        y5GCKi6oKYu6JO8WMs+2MJ28SlA2BKw=
Received: from suse.cz (unknown [10.100.224.162])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 349AEA3B83;
        Thu, 17 Mar 2022 18:38:44 +0000 (UTC)
Date:   Thu, 17 Mar 2022 19:38:44 +0100
From:   Petr Mladek <pmladek@suse.com>
To:     Chengming Zhou <zhouchengming@bytedance.com>
Cc:     jpoimboe@redhat.com, jikos@kernel.org, mbenes@suse.cz,
        joe.lawrence@redhat.com, live-patching@vger.kernel.org,
        linux-kernel@vger.kernel.org, songmuchun@bytedance.com,
        qirui.001@bytedance.com
Subject: Re: [PATCH v3] livepatch: Don't block removal of patches that are
 safe to unload
Message-ID: <YjOANCt6Kfnzp+HZ@alley>
References: <20220312152220.88127-1-zhouchengming@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220312152220.88127-1-zhouchengming@bytedance.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Sat 2022-03-12 23:22:20, Chengming Zhou wrote:
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
> that are being removed. In particular, set the "forced" flag:
> 
>   + only for klp_transition_patch when the transition to KLP_UNPATCHED
>     state was forced.
> 
>   + all replaced patches when the transition to KLP_PATCHED state was
>     forced and the patch was replacing the existing patches.
> 
> Signed-off-by: Chengming Zhou <zhouchengming@bytedance.com>

The patch has been committed, with the proposed wording changes,
into livepatching/livepatching.git, branch for-5.18/fixes,
see
https://git.kernel.org/pub/scm/linux/kernel/git/livepatching/livepatching.git/commit/?h=for-5.18/fixes&id=2957308343fa7c621df9f342fab88cb970b8d5f3

Best Regards,
Petr
