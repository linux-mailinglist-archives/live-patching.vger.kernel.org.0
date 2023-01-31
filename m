Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED199682F31
	for <lists+live-patching@lfdr.de>; Tue, 31 Jan 2023 15:25:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232033AbjAaOZr (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 31 Jan 2023 09:25:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231453AbjAaOZ3 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 31 Jan 2023 09:25:29 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E28551C4F;
        Tue, 31 Jan 2023 06:24:34 -0800 (PST)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 7352022B20;
        Tue, 31 Jan 2023 14:24:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1675175042; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=2pnGyHfGTSNbv47Fo4KFIPFGOEJ57bu4NsyejObITEY=;
        b=L32KJ3WRu6pXWQ9gsEwNv7HGM4cgXvkkMAA3bFqLJAbYLyubHZHditddKlffhMBZ1miwkf
        Br+SPOYWskc5qR1gIgr+3dMbVD+Zkhyl0j8ayyA12gIpgpNBnOVUCJvS8fj3I7wCHGOoz8
        L1+gPn4k2c8iq3kYQ17muQQ7nvGFVhM=
Received: from suse.cz (unknown [10.100.201.202])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 4690A2C141;
        Tue, 31 Jan 2023 14:24:02 +0000 (UTC)
Date:   Tue, 31 Jan 2023 15:23:58 +0100
From:   Petr Mladek <pmladek@suse.com>
To:     Josh Poimboeuf <jpoimboe@kernel.org>
Cc:     Marcos Paulo de Souza <mpdesouza@suse.com>,
        linux-kernel@vger.kernel.org, live-patching@vger.kernel.org,
        jpoimboe@redhat.com, joe.lawrence@redhat.com
Subject: Re: [PATCH v2 4/4] livepatch/shadow: Add garbage collection of
 shadow variables
Message-ID: <Y9kkflJxq2A9+W8Q@alley>
References: <20221026194122.11761-1-mpdesouza@suse.com>
 <20221026194122.11761-5-mpdesouza@suse.com>
 <20230131044008.atapgt326nsl6fdp@treble>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230131044008.atapgt326nsl6fdp@treble>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Mon 2023-01-30 20:40:08, Josh Poimboeuf wrote:
> On Wed, Oct 26, 2022 at 04:41:22PM -0300, Marcos Paulo de Souza wrote:
> > +#define klp_for_each_shadow_type(obj, shadow_type, i)			\
> > +	for (shadow_type = obj->shadow_types ? obj->shadow_types[0] : NULL, i = 1; \
> > +	     shadow_type; \
> > +	     shadow_type = obj->shadow_types[i++])
> > +
> > +int klp_shadow_register(struct klp_shadow_type *shadow_type);
> > +void klp_shadow_unregister(struct klp_shadow_type *shadow_type);
> 
> More cases where 'shadow_type' can be shortened to 'type'.
> (And the same comment elsewhere)

Works for me.

> > +
> >  void *klp_shadow_get(void *obj, struct klp_shadow_type *shadow_type);
> >  void *klp_shadow_alloc(void *obj, struct klp_shadow_type *shadow_type,
> >  		       size_t size, gfp_t gfp_flags, void *ctor_data);
> 
> I find the type-based interface to be unnecessarily clunky and
> confusing:
> 
> - It obscures the fact that uniqueness is determined by ID, not by type.
> 
> - It's weird to be passing around the type even after it has been
>   registered: e.g., why doesn't klp remember the ctor/dtor?

ctor/dtor must be implemented in each livepatch. klp_shadow_register()
would need to remember all registered implementations.
klp_shadow_alloc/get/free would need to find and choose one.
It would add an extra overhead and non-determines.

The overhead might be negligible. The callbacks should be compatible.
But still, is it worth the potential troubles?

IMHO, it is just about POV. Does it really matter if we pass id or type?

Switching to type might be a slight complication for existing API users
that are used to ID. But we are changing the API anyway.


> - It complicates the registration interface for the normal case where
>   we normally don't have constructors/destructors.

I am sorry but I do not understand this concern. The new API hides
ctor/dtor into struct klp_shadow_type. It removes one NULL parameter
from klp_alloc/get/free API. It looks like a simplification to me.


> - I don't understand the exposed klp_shadow_{un}register() interfaces.
>   What's the point of forcing their use if there's no garbage
>   collection?

I probably do not understand it correctly.

Normal livepatch developers do not need to use klp_shadow_{un}register().
They are called transparently in __klp_enable_patch()/klp_complete_transition()
and klp_module_coming()/klp_cleanup_module_patches_limited().

The main reason why they are exposed via include/linux/livepatch.h
and EXPORT_SYMBOL_GPL() is the selftest lib/livepatch/test_klp_shadow_vars.c.

Well, the selftest probably could be bundled into a livepatch to go
around this.


> - It's internally confusing in klp to have both 'type' and 'type_reg'.

I do not like it much either.

An idea. We could replace "bool registered" with "struct list_head
register_node" in struct klp_shadow_type. Then we could use it
for registration.

All the registered types will be in a global list (klp_type_register).
klp_shadow_unregister() would do the garbage collection when it
removed the last entry with the given id from the global list.


> One question: has anybody actually used destructors in the real world?
> 
> > @@ -988,6 +1012,13 @@ static int __klp_enable_patch(struct klp_patch *patch)
> >  		if (!klp_is_object_loaded(obj))
> >  			continue;
> >  
> > +		ret = klp_register_shadow_types(obj);
> > +		if (ret) {
> > +			pr_warn("failed to register shadow types for object '%s'\n",
> > +				klp_is_module(obj) ? obj->name : "vmlinux");
> > +			goto err;
> > +		}
> > +
> 
> If this fails for some reason then the error path doesn't unregister.
> Presumably klp_register_shadow_types() needs to be self-cleaning on
> error like klp_patch_object() is.

Good point!

They actually are unregisterd via:

  + __klp_enable_patch()
    + klp_cancel_transition()    # err: in __klp_enabled_patch()
      + klp_complete_transition()
	+ klp_unregister_shadow_types()

But there is a problem. It tries to unregister all types.
We have to make sure that it does not complain when a type has
not been registered yet.

> And BTW, it might be easier to do so if klp_shadow_type has a 'reg'
> pointer to its corresponding reg struct.  Then the 'registered' boolean
> is no longer needed and klp_shadow_unregister() doesn't need to call
> klp_shadow_type_get_reg().

Yup. It would be easier also if the use list_head pointing to the
global register.

> > +++ b/kernel/livepatch/shadow.c
> 
> > +static struct klp_shadow_type_reg *
> > +klp_shadow_type_get_reg(struct klp_shadow_type *shadow_type)
> > +{
> > +	struct klp_shadow_type_reg *shadow_type_reg;
> > +	lockdep_assert_held(&klp_shadow_lock);
> > +
> > +	list_for_each_entry(shadow_type_reg, &klp_shadow_types, list) {
> > +		if (shadow_type_reg->id == shadow_type->id)
> > +			return shadow_type_reg;
> > +	}
> > +
> > +	return NULL;
> > +}
> 
> It seems like overkill to have both klp_shadow_hash and
> klp_shadow_types.  For example 'struct klp_shadow' could have a link to
> its type and then klp_shadow_type_get_reg could iterate through the
> klp_shadow_hash.

I guess that there is a misunderstanding. We need two databases:

   + One for the registered shadow_types. I does the reference
     counting. It counts the number of livepatched objects
     (livepatches) that might the shadow type. It says _when_ the garbage
     collection must be done.

   + Second for existing shadow variables. It is needed for finding
     the shadow data. It says _what_ variables have to freed when
     the garbage collection is being proceed.


> > +
> > +/**
> > + * klp_shadow_register() - register the given shadow variable type
> > + * @shadow_type:	shadow type to be registered
> > + *
> > + * Tell the system that the given shadow type is going to used by the caller
> > + * (livepatch module). It allows to check and maintain lifetime of shadow
> > + * variables.
> 
> It's probably worth mentioning here that this function typically isn't
> called directly by the livepatch, and is only needed if the klp_object
> doesn't have the type in its 'shadow_types' array.

Yup.

> > + *
> > + * Return: 0 on suceess, -ENOMEM when there is not enough memory.
> 
> "success"
> 
> > + */
> > +int klp_shadow_register(struct klp_shadow_type *shadow_type)
> > +{
> > +	struct klp_shadow_type_reg *shadow_type_reg;
> > +	struct klp_shadow_type_reg *new_shadow_type_reg;
> > +
> > +	new_shadow_type_reg =
> > +		kzalloc(sizeof(struct klp_shadow_type_reg), GFP_KERNEL);
> > +	if (!new_shadow_type_reg)
> > +		return -ENOMEM;
> > +
> > +	spin_lock_irq(&klp_shadow_lock);
> > +
> > +	if (shadow_type->registered) {
> > +		pr_err("Trying to register shadow variable type that is already registered: %lu",
> > +		       shadow_type->id);
> > +		kfree(new_shadow_type_reg);
> > +		goto out;
> 
> Shouldn't this return -EINVAL or so?

Yes, it would make more sense.

> > +	}
> > +
> > +	shadow_type_reg = klp_shadow_type_get_reg(shadow_type);
> > +	if (!shadow_type_reg) {
> > +		shadow_type_reg = new_shadow_type_reg;
> > +		shadow_type_reg->id = shadow_type->id;
> > +		list_add(&shadow_type_reg->list, &klp_shadow_types);
> > +	} else {
> > +		kfree(new_shadow_type_reg);
> > +	}
> > +
> > +	shadow_type_reg->ref_cnt++;
> > +	shadow_type->registered = true;
> > +out:
> > +	spin_unlock_irq(&klp_shadow_lock);
> > +
> > +	return 0;
> > +}
> > +EXPORT_SYMBOL_GPL(klp_shadow_register);
> > +
> > +void klp_shadow_unregister(struct klp_shadow_type *shadow_type)
> > +{
> > +	struct klp_shadow_type_reg *shadow_type_reg;
> > +
> > +	spin_lock_irq(&klp_shadow_lock);
> > +
> > +	if (!shadow_type->registered) {
> > +		pr_err("Trying to unregister shadow variable type that is not registered: %lu",
> > +		       shadow_type->id);
> > +		goto out;
> > +	}
> > +
> > +	shadow_type_reg = klp_shadow_type_get_reg(shadow_type);
> > +	if (!shadow_type_reg) {
> > +		pr_err("Can't find shadow variable type registration: %lu", shadow_type->id);
> > +		goto out;
> > +	}
> 
> Since it's too late to report these errors and they might indicate a
> major bug, maybe they should WARN().

This probably won't be needed after we get rid of shadow_type_reg.

Also this is actually a valid scenario. klp_complete_transition()
might try to unregister a not-yet-registered type. It might happen
when called from __klp_enabled_patch() error path.

Thanks a lot for the review.

Best Regards,
Petr
