Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A58160AEB4
	for <lists+live-patching@lfdr.de>; Mon, 24 Oct 2022 17:13:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229792AbiJXPNY (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 24 Oct 2022 11:13:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232118AbiJXPNC (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 24 Oct 2022 11:13:02 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86DE78A7DB
        for <live-patching@vger.kernel.org>; Mon, 24 Oct 2022 06:50:30 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 3EDDB2214F;
        Mon, 24 Oct 2022 13:24:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1666617871; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=VxyipOmoC3jQJ6MwF3AWwXixJOGtCymjNqk5udJyRvo=;
        b=Y5Occ/BQ526ljKMi/GBnKkF/rdB+w6sHlqeUFcs0q7iqluVsPMCs1h27F5YVx5XW04bhQS
        xsYW+uJXKPscJzOBKUgnByDYebTasW5+XJ9fwIS7af5Cu4NWRN+/hnxDp6QOTB5vzeOkbL
        zO0jXAtu5twLBCN5fZQtzUEq6AhAVLw=
Received: from suse.cz (unknown [10.100.201.202])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 20EA52C141;
        Mon, 24 Oct 2022 13:24:31 +0000 (UTC)
Date:   Mon, 24 Oct 2022 15:24:28 +0200
From:   Petr Mladek <pmladek@suse.com>
To:     Joe Lawrence <joe.lawrence@redhat.com>
Cc:     Marcos Paulo de Souza <mpdesouza@suse.com>,
        live-patching@vger.kernel.org, jpoimboe@redhat.com, mbenes@suse.cz,
        nstange@suse.de
Subject: Re: [PATCH 3/4] livepatch/shadow: Introduce klp_shadow_type structure
Message-ID: <Y1aSDMi6ty8E+VGm@alley>
References: <20220701194817.24655-1-mpdesouza@suse.com>
 <20220701194817.24655-4-mpdesouza@suse.com>
 <a0daa94e-a66d-ad14-339c-ed08b3914469@redhat.com>
 <2d00d226-9db2-7efd-903e-622e5698aaca@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2d00d226-9db2-7efd-903e-622e5698aaca@redhat.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Thu 2022-08-25 10:54:18, Joe Lawrence wrote:
> On 8/25/22 10:50 AM, Joe Lawrence wrote:
> > On 7/1/22 3:48 PM, Marcos Paulo de Souza wrote:
> >> The shadow variable type will be used in klp_shadow_alloc/get/free
> >> functions instead of id/ctor/dtor parameters. As a result, all callers
> >> use the same callbacks consistently[*][**].
> >>
> >> The structure will be used in the next patch that will manage the
> >> lifetime of shadow variables and execute garbage collection automatically.
> >>
> >> [*] From the user POV, it might have been easier to pass $id instead
> >>     of pointer to struct klp_shadow_type.
> >>
> >>     The problem is that each livepatch registers its own struct
> >>     klp_shadow_type and defines its own @ctor/@dtor callbacks. It would
> >>     be unclear what callback should be used. They should be compatible.
> >>
> >>     This problem is gone when each livepatch explicitly uses its
> >>     own struct klp_shadow_type pointing to its own callbacks.
> >>
> >> [**] test_klp_shadow_vars.c uses a custom @dtor to show that it was called.
> >>     The message must be disabled when called via klp_shadow_free_all()
> >>     because the ordering of freed variables is not well defined there.
> >>     It has to be done using another hack after switching to
> >>     klp_shadow_types.
> >>
> > 
> > Is the ordering problem new to this patchset?  Shadow variables are
> > still saved in klp_shadow_hash and I think the only change in this patch
> > is that we need to compare through shadow_type and not id directly.  Or
> > does patch 4/4 change behavior here?  Just curious, otherwise this patch
> > is pretty straightforward.
> > 
> >> --- a/include/linux/livepatch.h
> >> +++ b/include/linux/livepatch.h
> >> @@ -216,15 +216,26 @@ typedef int (*klp_shadow_ctor_t)(void *obj,
> >>  				 void *ctor_data);
> >>  typedef void (*klp_shadow_dtor_t)(void *obj, void *shadow_data);
> >>  
> >> -void *klp_shadow_get(void *obj, unsigned long id);
> >> -void *klp_shadow_alloc(void *obj, unsigned long id,
> >> -		       size_t size, gfp_t gfp_flags,
> >> -		       klp_shadow_ctor_t ctor, void *ctor_data);
> >> -void *klp_shadow_get_or_alloc(void *obj, unsigned long id,
> >> -			      size_t size, gfp_t gfp_flags,
> >> -			      klp_shadow_ctor_t ctor, void *ctor_data);
> >> -void klp_shadow_free(void *obj, unsigned long id, klp_shadow_dtor_t dtor);
> >> -void klp_shadow_free_all(unsigned long id, klp_shadow_dtor_t dtor);
> >> +/**
> >> + * struct klp_shadow_type - shadow variable type used by the klp_object
> >> + * @id:		shadow variable type indentifier
> >> + * @ctor:	custom constructor to initialize the shadow data (optional)
> >> + * @dtor:	custom callback that can be used to unregister the variable
> >> + *		and/or free data that the shadow variable points to (optional)
> >> + */
> >> +struct klp_shadow_type {
> >> +	unsigned long id;
> >> +	klp_shadow_ctor_t ctor;
> >> +	klp_shadow_dtor_t dtor;
> >> +};
> >> +
> >> +void *klp_shadow_get(void *obj, struct klp_shadow_type *shadow_type);
> >> +void *klp_shadow_alloc(void *obj, struct klp_shadow_type *shadow_type,
> >> +		       size_t size, gfp_t gfp_flags, void *ctor_data);
> >> +void *klp_shadow_get_or_alloc(void *obj, struct klp_shadow_type *shadow_type,
> >> +			      size_t size, gfp_t gfp_flags, void *ctor_data);
> >> +void klp_shadow_free(void *obj, struct klp_shadow_type *shadow_type);
> >> +void klp_shadow_free_all(struct klp_shadow_type *shadow_type);
> >>  
> >>  struct klp_state *klp_get_state(struct klp_patch *patch, unsigned long id);
> >>  struct klp_state *klp_get_prev_state(unsigned long id);
> >> diff --git a/kernel/livepatch/shadow.c b/kernel/livepatch/shadow.c
> >> index 79b8646b1d4c..9dcbb626046e 100644
> >> --- a/kernel/livepatch/shadow.c
> >> +++ b/kernel/livepatch/shadow.c
> >> @@ -63,24 +63,24 @@ struct klp_shadow {
> >>   * klp_shadow_match() - verify a shadow variable matches given <obj, id>
> >>   * @shadow:	shadow variable to match
> >>   * @obj:	pointer to parent object
> >> - * @id:		data identifier
> >> + * @shadow_type: type of the wanted shadow variable
> >>   *
> >>   * Return: true if the shadow variable matches.
> >>   */
> >>  static inline bool klp_shadow_match(struct klp_shadow *shadow, void *obj,
> >> -				unsigned long id)
> >> +				struct klp_shadow_type *shadow_type)
> >>  {
> >> -	return shadow->obj == obj && shadow->id == id;
> >> +	return shadow->obj == obj && shadow->id == shadow_type->id;
> > 
> > Not sure if I'm being paranoid, but is there any problem if the user
> > registers two klp_shadow_types with the same id?  I can't find any
> > obvious logic problems with that, but I don't think the API prevents
> > this confusing possibility.

Great question!

> Ah n/m, I think I see now that I'm reading patch 4/4, it's
> klp_shadow_type_get_reg() is going to look for an existing
> shadow_type_reg->id first.

The purpose of klp_shadow_type_get_reg() is a bit different.
It decides whether the given klp_shadow_type is registered
for the first time or we just need to increase the refcount.

It means that it is actually possible to register two
different klp_shadow_types using the same ID.

Well, I am not sure if we could do better. We could not compare
pointers of @ctor and @dtor callbacks. The very same klp_shadow_type
can be registered from more livepatches and each livepatch need
to have its own implementation of @ctor and @dtor. It is the purpose
of the refcounting.

In each case, it does not make things worse. The previous API
allowed to combine any ID with any @ctor or @dtor.

One idea. We could define the type by "name" and "id". The @name
might be created by stringification of the structure that defines
the klp_shadow_type. It might be checked during registration
and unregistration. But I am not sure if it is worth the effort.

Best Regards,
Petr
