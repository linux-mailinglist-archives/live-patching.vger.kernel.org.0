Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3ECFE4DB3C1
	for <lists+live-patching@lfdr.de>; Wed, 16 Mar 2022 15:55:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350666AbiCPO4k (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 16 Mar 2022 10:56:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239686AbiCPO4j (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 16 Mar 2022 10:56:39 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93EFA66211;
        Wed, 16 Mar 2022 07:55:25 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 4EC9521108;
        Wed, 16 Mar 2022 14:55:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1647442524; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=NXMA/Pj4MkM0jtnceee8WzxTN05heTV2kaXZm6L30uw=;
        b=QuXrVF7cnCVfdd6o/hNe5x297tISgC7dDlxMmyd/phdT0zsbxaGvQm29fFTL6D6Wob5/O7
        Ae0nbqSkzBdqZ8rMAasDxbfi2/9LpEnlvmAz1Ig8nfylZhQQhBcT1jtMdWCUtIq1SHip93
        lBw14Zc/oc7h82hykxw6Z1sDSVSqHj4=
Received: from suse.cz (unknown [10.100.216.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 31590A3B8A;
        Wed, 16 Mar 2022 14:55:24 +0000 (UTC)
Date:   Wed, 16 Mar 2022 15:55:23 +0100
From:   Petr Mladek <pmladek@suse.com>
To:     Chengming Zhou <zhouchengming@bytedance.com>
Cc:     jpoimboe@redhat.com, jikos@kernel.org, mbenes@suse.cz,
        joe.lawrence@redhat.com, live-patching@vger.kernel.org,
        linux-kernel@vger.kernel.org, songmuchun@bytedance.com,
        qirui.001@bytedance.com
Subject: Re: [PATCH v3] livepatch: Don't block removal of patches that are
 safe to unload
Message-ID: <YjH6W6eL1XQAGcxD@alley>
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

Looks reasonable, passes livepatch tests:

Reviewed-by: Petr Mladek <pmladek@suse.com>
Tested-by: Petr Mladek <pmladek@suse.com>

Just let me repeat. The "force" flags must be used carefully because
it breaks the consistency model.

Best Regards,
Petr
