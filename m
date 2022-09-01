Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C6555A99EE
	for <lists+live-patching@lfdr.de>; Thu,  1 Sep 2022 16:18:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232374AbiIAOSa (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 1 Sep 2022 10:18:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230370AbiIAOS3 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 1 Sep 2022 10:18:29 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B7D83A4A8;
        Thu,  1 Sep 2022 07:18:26 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id EC3812296C;
        Thu,  1 Sep 2022 14:18:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1662041904; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8LWgg6owsnlx0e20bDfAb/b6qis3DAUj9Q3YQHgTX6E=;
        b=Xcxr5QcM1xoSU1ictcXSIbk3WTLKQHPd8zVEBQ4K11OXezUwhIHgZTSEAP3K6kfbdRKzxi
        8a/KKKcAKOV+SV8+qAAE3PbkctgHdUTDE4LtTcCBt42i5Ns/qUJJ8yeJzwtDCorehY4TNQ
        7xHHPrEtrluRHFmydzIH/7P/Jl42eDY=
Received: from suse.cz (unknown [10.100.208.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id BB3F92C141;
        Thu,  1 Sep 2022 14:18:24 +0000 (UTC)
Date:   Thu, 1 Sep 2022 16:18:23 +0200
From:   Petr Mladek <pmladek@suse.com>
To:     Zhen Lei <thunder.leizhen@huawei.com>
Cc:     Josh Poimboeuf <jpoimboe@kernel.org>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] livepatch: Move error print out of lock protection in
 klp_enable_patch()
Message-ID: <YxC/L+fKInPWJPdy@alley>
References: <20220901022706.813-1-thunder.leizhen@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220901022706.813-1-thunder.leizhen@huawei.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Thu 2022-09-01 10:27:06, Zhen Lei wrote:
> The patch->mod is not a protected object of mutex_lock(&klp_mutex). Since
> it's in the error handling branch, it might not be helpful to reduce lock
> conflicts, but it can reduce some code size.
> 
> Before:
>    text    data     bss     dec     hex filename
>   10330     464       8   10802    2a32 kernel/livepatch/core.o
> 
> After:
>    text    data     bss     dec     hex filename
>   10307     464       8   10779    2a1b kernel/livepatch/core.o

Please, is this part of some longterm effort to reduce the size of
the kernel? Or is this just some random observation?


> Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
> ---
>  kernel/livepatch/core.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
> index 42f7e716d56bf72..cb7abc821a50584 100644
> --- a/kernel/livepatch/core.c
> +++ b/kernel/livepatch/core.c
> @@ -1041,9 +1041,9 @@ int klp_enable_patch(struct klp_patch *patch)
>  	mutex_lock(&klp_mutex);
>  
>  	if (!klp_is_patch_compatible(patch)) {
> +		mutex_unlock(&klp_mutex);
>  		pr_err("Livepatch patch (%s) is not compatible with the already installed livepatches.\n",
>  			patch->mod->name);
> -		mutex_unlock(&klp_mutex);

I do not see how this change could reliably reduce the code size.

As Joe wrote, it looks like a random effect that is specific to a
particular compiler version, compilation options, and architecture.

I am against these kind of random microptimizations. It is just a call
for problems. If you move printk() outside of a lock, you need to make
sure that the information is not racy.

It might be safe in this particular case. But it is a bad practice.
It adds an extra work. It is error-prone with questionable gain.

I am sorry but I NACK this patch. There must be better ways to
reduce the kernel binary size.

Best Regards,
Petr
