Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 048A85AB30B
	for <lists+live-patching@lfdr.de>; Fri,  2 Sep 2022 16:09:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235795AbiIBOJm (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 2 Sep 2022 10:09:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238862AbiIBOIg (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 2 Sep 2022 10:08:36 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDB8E7F27C;
        Fri,  2 Sep 2022 06:36:43 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id ADEEF5BF1D;
        Fri,  2 Sep 2022 13:36:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1662125789; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XUtxAgroLi+3mkSlCPYSB9lB6AVEuFtS3rX+ldctwAE=;
        b=Z9JSa0ejAJmKR7I5S5jtOAyduv6UtVGbvYgt8bB1GsCdpK68fwvaljAUKZAqf0avItWPHz
        gkgRZEIQi9FhddEO6bkNixODOT3rYjpGeYC5RcQqdkEKdcKJ5bLiYBzmupGlI9iJaYbQsV
        v1WS8v2ONDQqr27G7mtU7wUjWuFsmFQ=
Received: from suse.cz (pathway.suse.cz [10.100.12.24])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 7BF292C149;
        Fri,  2 Sep 2022 13:36:29 +0000 (UTC)
Date:   Fri, 2 Sep 2022 15:36:28 +0200
From:   Petr Mladek <pmladek@suse.com>
To:     "Leizhen (ThunderTown)" <thunder.leizhen@huawei.com>
Cc:     Josh Poimboeuf <jpoimboe@kernel.org>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] livepatch: Move error print out of lock protection in
 klp_enable_patch()
Message-ID: <20220902133628.GA29761@pathway.suse.cz>
References: <20220901022706.813-1-thunder.leizhen@huawei.com>
 <YxC/L+fKInPWJPdy@alley>
 <c1f6c6ec-2681-8d7a-506a-4da72a963ce8@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c1f6c6ec-2681-8d7a-506a-4da72a963ce8@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Fri 2022-09-02 09:28:59, Leizhen (ThunderTown) wrote:
> >> diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
> >> index 42f7e716d56bf72..cb7abc821a50584 100644
> >> --- a/kernel/livepatch/core.c
> >> +++ b/kernel/livepatch/core.c
> >> @@ -1041,9 +1041,9 @@ int klp_enable_patch(struct klp_patch *patch)
> >>  	mutex_lock(&klp_mutex);
> >>  
> >>  	if (!klp_is_patch_compatible(patch)) {
> >> +		mutex_unlock(&klp_mutex);
> >>  		pr_err("Livepatch patch (%s) is not compatible with the already installed livepatches.\n",
> >>  			patch->mod->name);
> >> -		mutex_unlock(&klp_mutex);
> > 
> > I do not see how this change could reliably reduce the code size.
> > 
> > As Joe wrote, it looks like a random effect that is specific to a
> > particular compiler version, compilation options, and architecture.
> > 
> > I am against these kind of random microptimizations. It is just a call
> > for problems. If you move printk() outside of a lock, you need to make
> > sure that the information is not racy.
> 
> OK.
> 
> 	mutex_lock(&klp_mutex);
>         if (!klp_is_patch_compatible(patch)) {
>                 mutex_unlock(&klp_mutex);
> 			<--------- Do you mean the incompatible patches maybe disabled at this point?

This particular change is safe in the current design.
klp_enable_patch() is called from the module_init() callback
where patch->mod->name is defined. So it can't change.

The problem is that it is not obvious that it is safe. One has to
think about it. Also it might become dangerous when someone
tries to call klp_enable_livepatch() for another livepatch module.

>                 pr_err("Livepatch patch (%s) ...\n", patch->mod->name);
>                 return -EINVAL;
>         }
> 
> > 
> > It might be safe in this particular case. But it is a bad practice.
> > It adds an extra work. It is error-prone with questionable gain.
> > 
> > I am sorry but I NACK this patch. There must be better ways to
> 
> OK

Thanks for understanding.

Best Regards,
Petr
