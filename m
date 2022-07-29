Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3ECA58532C
	for <lists+live-patching@lfdr.de>; Fri, 29 Jul 2022 18:07:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232085AbiG2QHM (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 29 Jul 2022 12:07:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229818AbiG2QHM (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 29 Jul 2022 12:07:12 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8C5A88761
        for <live-patching@vger.kernel.org>; Fri, 29 Jul 2022 09:07:10 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 7240B5BCFE;
        Fri, 29 Jul 2022 16:07:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1659110829; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ayqqkaqZSLYqDptgn6ofRPQz0p7nE6UWBrkcYt6oJGk=;
        b=RH4D5pg/no4y9tT8OMxfpKhG3tZSUgwGGbAJrZItP+jRTay5KAoTNHpxkcbI3PMZNwksWE
        baV1VwAgJt0MueS6BWp809aF60QBavMMLas3gRfqruyuWvvMgr0gK3vBQsVTTp9wF2Krmu
        /IQZTUIubp1VygSS8WnFSJSvC4QajCk=
Received: from suse.cz (unknown [10.100.201.202])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 5050E2C141;
        Fri, 29 Jul 2022 16:07:09 +0000 (UTC)
Date:   Fri, 29 Jul 2022 18:07:09 +0200
From:   Petr Mladek <pmladek@suse.com>
To:     Marcos Paulo de Souza <mpdesouza@suse.com>
Cc:     live-patching@vger.kernel.org, jpoimboe@redhat.com, mbenes@suse.cz,
        nstange@suse.de
Subject: Re: [PATCH 3/4] livepatch/shadow: Introduce klp_shadow_type structure
Message-ID: <YuQFragh3zd+2LGz@alley>
References: <20220701194817.24655-1-mpdesouza@suse.com>
 <20220701194817.24655-4-mpdesouza@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220701194817.24655-4-mpdesouza@suse.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Fri 2022-07-01 16:48:16, Marcos Paulo de Souza wrote:
> The shadow variable type will be used in klp_shadow_alloc/get/free
> functions instead of id/ctor/dtor parameters. As a result, all callers
> use the same callbacks consistently[*][**].
> 
> The structure will be used in the next patch that will manage the
> lifetime of shadow variables and execute garbage collection automatically.
> 
> [*] From the user POV, it might have been easier to pass $id instead
>     of pointer to struct klp_shadow_type.
>
>     The problem is that each livepatch registers its own struct
>     klp_shadow_type and defines its own @ctor/@dtor callbacks. It would
>     be unclear what callback should be used. They should be compatible.

This probably is not clear enough. The following might be better:

[*] From the user POV, it might have been easier to pass $id instead
    of pointer to struct klp_shadow_type.

    It would require registering the klp_shadow_type so that
    the klp_shadow API could find ctor/dtor for the given id.
    It actually will be needed for the garbage collection anyway
    because it will define the lifetime of the variables.

    The bigger problem is that the same klp_shadow_type might be
    used by more livepatch modules. Each livepatch module need
    to duplicate the definition of klp_shadow_type and ctor/dtor
    callbacks. The klp_shadow API would need to choose one registered
    copy.

    They definitions should be compatible and they should stay as long
    as the type is registered. But it still feels more safe when
    klp_shadow API callers use struct klp_shadow_type and ctor/dtor
    callbacks defined in the same livepatch module.

>     This problem is gone when each livepatch explicitly uses its
>     own struct klp_shadow_type pointing to its own callbacks.
> 
> [**] test_klp_shadow_vars.c uses a custom @dtor to show that it was called.
>     The message must be disabled when called via klp_shadow_free_all()
>     because the ordering of freed variables is not well defined there.
>     It has to be done using another hack after switching to
>     klp_shadow_types.
> 
> Signed-off-by: Marcos Paulo de Souza <mpdesouza@suse.com>
> Signed-off-by: Petr Mladek <pmladek@suse.com>

This should be:

Co-developed-by: Petr Mladek <pmladek@suse.com>
Signed-off-by: Petr Mladek <pmladek@suse.com>
Signed-off-by: Marcos Paulo de Souza <mpdesouza@suse.com>

> --- a/kernel/livepatch/shadow.c
> +++ b/kernel/livepatch/shadow.c
> @@ -156,22 +154,25 @@ static void *__klp_shadow_get_or_alloc(void *obj, unsigned long id,
>  	 * More complex setting can be done by @ctor function.  But it is
>  	 * called only when the buffer is really used (under klp_shadow_lock).
>  	 */
> -	new_shadow = kzalloc(size + sizeof(*new_shadow), gfp_flags);
> +	new_shadow = kzalloc(size + sizeof(struct klp_shadow), gfp_flags);
>  	if (!new_shadow)
>  		return NULL;
>  
>  	/* Look for <obj, id> again under the lock */
>  	spin_lock_irqsave(&klp_shadow_lock, flags);
> -	shadow_data = __klp_shadow_get_or_use(obj, id, new_shadow,
> -					      ctor, ctor_data, &exist);
> +	shadow_data = __klp_shadow_get_or_use(obj, shadow_type,
> +					      new_shadow, ctor_data, &exist);
>  	spin_unlock_irqrestore(&klp_shadow_lock, flags);
>  
> -	/* Throw away unused speculative allocation. */
> +	/*
> +	 * Throw away unused speculative allocation if the shadow variable
> +	 * exists or if the ctor function failed.
> +	 */

The ordering is confusing because it does not match the code. Please,
either use:

	 * Throw away the unused speculative allocation if ctor() failed
	 * or the variable already existed.

or just keep the original comment.

>  	if (!shadow_data || exist)
>  		kfree(new_shadow);
>  
>  	if (exist && warn_on_exist) {
> -		WARN(1, "Duplicate shadow variable <%p, %lx>\n", obj, id);
> +		WARN(1, "Duplicate shadow variable <%p, %lx>\n", obj, shadow_type->id);
>  		return NULL;
>  	}

Best Regards,
Petr
