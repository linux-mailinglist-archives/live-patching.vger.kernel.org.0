Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B59DE682374
	for <lists+live-patching@lfdr.de>; Tue, 31 Jan 2023 05:41:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231158AbjAaElt (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 30 Jan 2023 23:41:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230377AbjAaElY (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 30 Jan 2023 23:41:24 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01A053FF09;
        Mon, 30 Jan 2023 20:40:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6FEEAB81914;
        Tue, 31 Jan 2023 04:40:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDBD2C4339B;
        Tue, 31 Jan 2023 04:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675140010;
        bh=VS9yVQNKn4di7w7JFOGcctiBkDEMf1n7go+rnpH0A3k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QGxYsRdhL9Do9jPlsLXZr0Ua9VbBchOYi7T5GE7dAHvsm/dVfeRAwOufAdnWHB2Mp
         8YIFscnKefQHp7LYgQxKBs7Ag2+Ha2KWzwJh9quB4jERZ0DeG6TR9OkXIgG49NfY5I
         5/rovdkoWMIolMciQCsw0pGap3Tt9/+8NwiHQZJ/DmlQxVlKJ1Nn9hD6CGEIronap6
         I8/+HtDqoSMaGFo0dP2lhGxO0wSj1yU4k5OEeS04BIH1HiIjfUwVwHNGFOk+k+qKM3
         lUJaSTAJNMiUGX6t++xrOFfghr7sai3YPbh+54NmAyn9PLHFl4wz6kFYc7XtwJttI4
         KxXHNLHD5Cx1g==
Date:   Mon, 30 Jan 2023 20:40:08 -0800
From:   Josh Poimboeuf <jpoimboe@kernel.org>
To:     Marcos Paulo de Souza <mpdesouza@suse.com>
Cc:     linux-kernel@vger.kernel.org, live-patching@vger.kernel.org,
        jpoimboe@redhat.com, joe.lawrence@redhat.com, pmladek@suse.com
Subject: Re: [PATCH v2 4/4] livepatch/shadow: Add garbage collection of
 shadow variables
Message-ID: <20230131044008.atapgt326nsl6fdp@treble>
References: <20221026194122.11761-1-mpdesouza@suse.com>
 <20221026194122.11761-5-mpdesouza@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20221026194122.11761-5-mpdesouza@suse.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed, Oct 26, 2022 at 04:41:22PM -0300, Marcos Paulo de Souza wrote:
>  /**
>   * struct klp_object - kernel object structure for live patching
>   * @name:	module name (or NULL for vmlinux)
>   * @funcs:	function entries for functions to be patched in the object
>   * @callbacks:	functions to be executed pre/post (un)patching
> + * @shadow_types: shadow variable types used by the livepatch for the klp_object

Please change the indentation of the other field descriptions so they
match (here and elsewhere in the patch).

> @@ -222,13 +226,30 @@ typedef void (*klp_shadow_dtor_t)(void *obj, void *shadow_data);
>   * @ctor:	custom constructor to initialize the shadow data (optional)
>   * @dtor:	custom callback that can be used to unregister the variable
>   *		and/or free data that the shadow variable points to (optional)
> + * @registered: flag indicating if the variable was successfully registered

"variable" -> "type"

> + *
> + * All shadow variables used by the livepatch for the related klp_object

"variables" -> "variable types" ?

> + * must be listed here so that they are registered when the livepatch
> + * and the module is loaded. Otherwise, it will not be possible to

Where is "here"?  Does it mean to say "must be listed in the
klp_object"?

Though, I don't think even that is true, since the user can manually call
klp_shadow_register().

"module" -> "object" ?

> + * allocate them.
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
> +int klp_shadow_register(struct klp_shadow_type *shadow_type);
> +void klp_shadow_unregister(struct klp_shadow_type *shadow_type);

More cases where 'shadow_type' can be shortened to 'type'.
(And the same comment elsewhere)

> +
>  void *klp_shadow_get(void *obj, struct klp_shadow_type *shadow_type);
>  void *klp_shadow_alloc(void *obj, struct klp_shadow_type *shadow_type,
>  		       size_t size, gfp_t gfp_flags, void *ctor_data);

I find the type-based interface to be unnecessarily clunky and
confusing:

- It obscures the fact that uniqueness is determined by ID, not by type.

- It's weird to be passing around the type even after it has been
  registered: e.g., why doesn't klp remember the ctor/dtor?

- It complicates the registration interface for the normal case where
  we normally don't have constructors/destructors.

- I don't understand the exposed klp_shadow_{un}register() interfaces.
  What's the point of forcing their use if there's no garbage
  collection?

- It's internally confusing in klp to have both 'type' and 'type_reg'.

I don't have any real suggestions yet, I'll need to think a little more
about it.

One question: has anybody actually used destructors in the real world?

> @@ -988,6 +1012,13 @@ static int __klp_enable_patch(struct klp_patch *patch)
>  		if (!klp_is_object_loaded(obj))
>  			continue;
>  
> +		ret = klp_register_shadow_types(obj);
> +		if (ret) {
> +			pr_warn("failed to register shadow types for object '%s'\n",
> +				klp_is_module(obj) ? obj->name : "vmlinux");
> +			goto err;
> +		}
> +

If this fails for some reason then the error path doesn't unregister.
Presumably klp_register_shadow_types() needs to be self-cleaning on
error like klp_patch_object() is.

And BTW, it might be easier to do so if klp_shadow_type has a 'reg'
pointer to its corresponding reg struct.  Then the 'registered' boolean
is no longer needed and klp_shadow_unregister() doesn't need to call
klp_shadow_type_get_reg().

> +++ b/kernel/livepatch/shadow.c
> @@ -34,6 +34,7 @@
>  #include <linux/hashtable.h>
>  #include <linux/slab.h>
>  #include <linux/livepatch.h>
> +#include "core.h"
>  
>  static DEFINE_HASHTABLE(klp_shadow_hash, 12);
>  
> @@ -59,6 +60,22 @@ struct klp_shadow {
>  	char data[];
>  };
>  
> +/**
> + * struct klp_shadow_type_reg - information about a registered shadow
> + *	variable type
> + * @id:		shadow variable type indentifier

"identifier"

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

It seems like overkill to have both klp_shadow_hash and
klp_shadow_types.  For example 'struct klp_shadow' could have a link to
its type and then klp_shadow_type_get_reg could iterate through the
klp_shadow_hash.

> +
> +/**
> + * klp_shadow_register() - register the given shadow variable type
> + * @shadow_type:	shadow type to be registered
> + *
> + * Tell the system that the given shadow type is going to used by the caller
> + * (livepatch module). It allows to check and maintain lifetime of shadow
> + * variables.

It's probably worth mentioning here that this function typically isn't
called directly by the livepatch, and is only needed if the klp_object
doesn't have the type in its 'shadow_types' array.

> + *
> + * Return: 0 on suceess, -ENOMEM when there is not enough memory.

"success"

> + */
> +int klp_shadow_register(struct klp_shadow_type *shadow_type)
> +{
> +	struct klp_shadow_type_reg *shadow_type_reg;
> +	struct klp_shadow_type_reg *new_shadow_type_reg;
> +
> +	new_shadow_type_reg =
> +		kzalloc(sizeof(struct klp_shadow_type_reg), GFP_KERNEL);
> +	if (!new_shadow_type_reg)
> +		return -ENOMEM;
> +
> +	spin_lock_irq(&klp_shadow_lock);
> +
> +	if (shadow_type->registered) {
> +		pr_err("Trying to register shadow variable type that is already registered: %lu",
> +		       shadow_type->id);
> +		kfree(new_shadow_type_reg);
> +		goto out;

Shouldn't this return -EINVAL or so?

> +	}
> +
> +	shadow_type_reg = klp_shadow_type_get_reg(shadow_type);
> +	if (!shadow_type_reg) {
> +		shadow_type_reg = new_shadow_type_reg;
> +		shadow_type_reg->id = shadow_type->id;
> +		list_add(&shadow_type_reg->list, &klp_shadow_types);
> +	} else {
> +		kfree(new_shadow_type_reg);
> +	}
> +
> +	shadow_type_reg->ref_cnt++;
> +	shadow_type->registered = true;
> +out:
> +	spin_unlock_irq(&klp_shadow_lock);
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(klp_shadow_register);
> +
> +/**
> + * klp_shadow_unregister() - unregister the give shadow variable type

"given"

> + * @shadow_type:	shadow type to be unregistered
> + *
> + * Tell the system that a given shadow variable ID is not longer be used by

"is no longer used"

> + * the caller (livepatch module). All existing shadow variables are freed
> + * when it was the last registered user.
> + */
> +void klp_shadow_unregister(struct klp_shadow_type *shadow_type)
> +{
> +	struct klp_shadow_type_reg *shadow_type_reg;
> +
> +	spin_lock_irq(&klp_shadow_lock);
> +
> +	if (!shadow_type->registered) {
> +		pr_err("Trying to unregister shadow variable type that is not registered: %lu",
> +		       shadow_type->id);
> +		goto out;
> +	}
> +
> +	shadow_type_reg = klp_shadow_type_get_reg(shadow_type);
> +	if (!shadow_type_reg) {
> +		pr_err("Can't find shadow variable type registration: %lu", shadow_type->id);
> +		goto out;
> +	}

Since it's too late to report these errors and they might indicate a
major bug, maybe they should WARN().

-- 
Josh
