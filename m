Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 821495A1144
	for <lists+live-patching@lfdr.de>; Thu, 25 Aug 2022 14:59:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229510AbiHYM7I (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 25 Aug 2022 08:59:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233371AbiHYM7I (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 25 Aug 2022 08:59:08 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F066297522
        for <live-patching@vger.kernel.org>; Thu, 25 Aug 2022 05:59:06 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 87E853416F;
        Thu, 25 Aug 2022 12:59:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1661432345; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Mi+tvJN1MrQ84u4XQYTySIJ+1EHshqvowufmfUvfSuo=;
        b=HR16EuKqlMCkgABUTAWOGQhXiOKEt5ngFCgCSG67d1EJefzrUECsXBntqKZgBfD3YnACng
        QkbFtvfxZbeQ7rG8NkR+Zw2/Jv/7a7tRg0X4oLfdr1UGGabdi7HiliS/W9OAehT9E4ohtU
        XcUTtZRA+Zv3gCtBURt7bL2s69qYxZ0=
Received: from suse.cz (unknown [10.100.201.202])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 55BE22C141;
        Thu, 25 Aug 2022 12:59:05 +0000 (UTC)
Date:   Thu, 25 Aug 2022 14:59:01 +0200
From:   Petr Mladek <pmladek@suse.com>
To:     Marcos Paulo de Souza <mpdesouza@suse.com>
Cc:     live-patching@vger.kernel.org, jpoimboe@redhat.com, mbenes@suse.cz,
        nstange@suse.de
Subject: Re: [PATCH 4/4] livepatch/shadow: Add garbage collection of shadow
 variables
Message-ID: <YwdyFbtOEuBgzbnl@alley>
References: <20220701194817.24655-1-mpdesouza@suse.com>
 <20220701194817.24655-5-mpdesouza@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220701194817.24655-5-mpdesouza@suse.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Fri 2022-07-01 16:48:17, Marcos Paulo de Souza wrote:
> The life of shadow variables is not completely trivial to maintain.
> They might be used by more livepatches and more livepatched objects.
> They should stay as long as there is any user.
> 
> In practice, it requires to implement reference counting in callbacks
> of all users. They should register all the user and remove the shadow

s/all the user/all users/

> variables only when there is no user left.
> 
> This patch hides the reference counting into the klp_shadow API.
> The counter is connected with the shadow variable @id. It requires
> an API to take and release the reference. The release function also
> calls the related dtor() when defined.
> 
> An easy solution would be to add some get_ref()/put_ref() API.
> But it would need to get called from pre()/post_un() callbacks.
> It might be easy to forget a callback and make it wrong.
> 
> A more safe approach is to associate the klp_shadow_type with
> klp_objects that use the shadow variables. The livepatch core
> code might then handle the reference counters on background.
> 
> The shadow variable type might then be added into a new @shadow_types
> member of struct klp_object. They will get then automatically registered
> and unregistered when the object is being livepatched. The registration
> increments the reference count. Unregistration decreases the reference
> count. All shadow variables of the given type are freed when the reference
> count reaches zero.
> 
> All klp_shadow_alloc/get/free functions also checks whether the requested
> type is registered. It will help to catch missing registration and might
> also help to catch eventual races.
> 
> --- a/include/linux/livepatch.h
> +++ b/include/linux/livepatch.h
> @@ -222,13 +226,30 @@ typedef void (*klp_shadow_dtor_t)(void *obj, void *shadow_data);
>   * @ctor:	custom constructor to initialize the shadow data (optional)
>   * @dtor:	custom callback that can be used to unregister the variable
>   *		and/or free data that the shadow variable points to (optional)
> + * @registered: flag indicating if the variable was successfully registered
> + *
> + * All shadow variables used by the livepatch for the related klp_object
> + * must be listed here so that they are registered when the livepatch
> + * and the module is loaded. Otherwise, it will not be possible to
> + * allocated them.

s/allocated/allocate/

>   */
>  struct klp_shadow_type {
>  	unsigned long id;
>  	klp_shadow_ctor_t ctor;
>  	klp_shadow_dtor_t dtor;
> +
> +	/* internal */
> +	bool registered;
>  };
>  
> +#define klp_for_each_shadow_type(obj, shadow_type, i)			\
> +	for (shadow_type = obj->shadow_types ? obj->shadow_types[0] : NULL, i = 1; \
> +	     shadow_type; \
> +	     shadow_type = obj->shadow_types[i++])
> +

> --- a/kernel/livepatch/shadow.c
> +++ b/kernel/livepatch/shadow.c
> @@ -307,3 +331,103 @@ void klp_shadow_free_all(struct klp_shadow_type *shadow_type)
>  	spin_unlock_irqrestore(&klp_shadow_lock, flags);
>  }
>  EXPORT_SYMBOL_GPL(klp_shadow_free_all);
> +
> +static struct klp_shadow_type_reg *
> +klp_shadow_type_get_reg(struct klp_shadow_type *shadow_type)
> +{
> +	struct klp_shadow_type_reg *shadow_type_reg;
> +	lockdep_assert_held(&klp_shadow_lock);
> +
> +	list_for_each_entry(shadow_type_reg, &klp_shadow_types, list) {
> +		if (shadow_type_reg->id == shadow_type->id)
> +			return shadow_type_reg;
> +	}
> +
> +	return NULL;
> +}
> +
> +/**
> + * klp_shadow_register() - register self for using a given data identifier

This is a relic from a former version. It should be something like:

 * klp_shadow_register() - register the given shadow variable type


> + * @shadow_type:	shadow type to be registered
> + *
> + * Tell the system that the related module (livepatch) is going to use a given
> + * shadow variable ID. It allows to check and maintain lifetime of shadow
> + * variables.

Same here. It should be:

 * Tell the system that the given shadow variable ID is going to be used by
 * the caller (livepatch module). It allows to check and maintain the lifetime
 * of shadow variables.

> + *
> + * Return: 0 on suceess, -ENOMEM when there is not enough memory.
> + */
> +int klp_shadow_register(struct klp_shadow_type *shadow_type)
> +{
> +	struct klp_shadow_type_reg *shadow_type_reg;
> +	struct klp_shadow_type_reg *new_shadow_type_reg;
> +

The code looks good to me. With the above changes:

Reviewed-by: Petr Mladek <pmladek@suse.com>

Best Regards,
Petr
