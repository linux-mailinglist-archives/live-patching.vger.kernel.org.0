Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87B50585210
	for <lists+live-patching@lfdr.de>; Fri, 29 Jul 2022 17:07:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230516AbiG2PG7 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 29 Jul 2022 11:06:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236887AbiG2PG6 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 29 Jul 2022 11:06:58 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69ABA814AD
        for <live-patching@vger.kernel.org>; Fri, 29 Jul 2022 08:06:56 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id E9B1834A35;
        Fri, 29 Jul 2022 15:06:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1659107214; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=f/fRZY4Jt5OXhmRhIl+IzPvy4SrMb6oGsTnjblinDMM=;
        b=BIlValmsKtCioWkGG2TpaHWbGzW0zG6GKUqeiiYv2Rm4nLCGJbnW2sQRfd5bty3sNOsZ/q
        x7BcrD/iNOOOAe6g9PbGlqM4CTaHFKAX/T+FkTrfkLrEbIXHktxiXbyDowhG03kEGAE59l
        UWbPcq0WJuFUAfnabg1+QHnfAA84Dc4=
Received: from suse.cz (unknown [10.100.208.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id C9C722C141;
        Fri, 29 Jul 2022 15:06:54 +0000 (UTC)
Date:   Fri, 29 Jul 2022 17:06:52 +0200
From:   Petr Mladek <pmladek@suse.com>
To:     Marcos Paulo de Souza <mpdesouza@suse.com>
Cc:     live-patching@vger.kernel.org, jpoimboe@redhat.com, mbenes@suse.cz,
        nstange@suse.de
Subject: Re: [PATCH 1/4] livepatch/shadow: Separate code to get or use
 pre-allocated shadow variable
Message-ID: <YuP3jBVZIdxBm/E/@alley>
References: <20220701194817.24655-1-mpdesouza@suse.com>
 <20220701194817.24655-2-mpdesouza@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220701194817.24655-2-mpdesouza@suse.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Fri 2022-07-01 16:48:14, Marcos Paulo de Souza wrote:
> From: Petr Mladek <pmladek@suse.com>
> 
> Separate code that is used in klp_shadow_get_or_alloc() under klp_mutex.
> It splits a long spaghetti function into two. Also it unifies the error
> handling. The old used a mix of duplicated code, direct returns,
> and goto. The new code has only one unlock, free, and return calls.
> 
> Background: The change was needed by an earlier variant of the code adding
> 	garbage collection of shadow variables. It is not needed in
> 	the end. But the change still looks like an useful clean up.

Maybe the above paragraph is superfluous. I would remove it after all.

> It is code refactoring without any functional changes.
> 
> Signed-off-by: Petr Mladek <pmladek@suse.com>

(It is fun to review my own RFC patch).

> ---
>  kernel/livepatch/shadow.c | 77 ++++++++++++++++++++++-----------------
>  1 file changed, 43 insertions(+), 34 deletions(-)
> 
> diff --git a/kernel/livepatch/shadow.c b/kernel/livepatch/shadow.c
> index c2e724d97ddf..67c1313f6831 100644
> --- a/kernel/livepatch/shadow.c
> +++ b/kernel/livepatch/shadow.c
> @@ -101,41 +101,19 @@ void *klp_shadow_get(void *obj, unsigned long id)
>  }
>  EXPORT_SYMBOL_GPL(klp_shadow_get);
>  
> -static void *__klp_shadow_get_or_alloc(void *obj, unsigned long id,
> -				       size_t size, gfp_t gfp_flags,
> -				       klp_shadow_ctor_t ctor, void *ctor_data,
> -				       bool warn_on_exist)
> +static void *__klp_shadow_get_or_use(void *obj, unsigned long id,
> +				     struct klp_shadow *new_shadow,
> +				     klp_shadow_ctor_t ctor, void *ctor_data,
> +				     bool *exist)

I have to admit that the name is a bit misleading. The real meaning
is "get existing" or "use newly allocated one".

I think that the following might better describe the real meaning
in the context where it is used:

     __klp_shadow_get_or_alloc_locked()
     __klp_shadow_get_or_add()

Anyway, it would deserve some comment above the function definition.
For example:

/*
 * Check if the variable already exists. Otherwise, add
 * the pre-allocated one.
 */

>  {
> -	struct klp_shadow *new_shadow;
>  	void *shadow_data;
> -	unsigned long flags;

It would deserve:

	lockdep_assert_held(&klp_shadow_lock);

> -
> -	/* Check if the shadow variable already exists */
> -	shadow_data = klp_shadow_get(obj, id);
> -	if (shadow_data)
> -		goto exists;
> -

Best Regards,
Petr
