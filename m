Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8938F687F65
	for <lists+live-patching@lfdr.de>; Thu,  2 Feb 2023 14:58:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231302AbjBBN6k (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 2 Feb 2023 08:58:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231546AbjBBN6j (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 2 Feb 2023 08:58:39 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9C9A589A1;
        Thu,  2 Feb 2023 05:58:36 -0800 (PST)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 2989E33792;
        Thu,  2 Feb 2023 13:58:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1675346315; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=daUv1Gf7v2/7oXJz94/VUc5IZeFnSgyEsck5+GPwJOk=;
        b=E601L5Ur31wea2yM/LwMqttWUTZiWkJUJkkt+LmNncZI44RzJrCxk4W1s81bs4P9eQ17/B
        pFmFktira9yCj6uF7pN2rbQ5bPV8ZsuF5PX6+JP8ZjXMr3vTc7b/Tqb2CAoBBHK7n/1XhC
        VEZ/OsfeUB9tBNPA+Xu+LMdz8lA1yCQ=
Received: from suse.cz (pmladek.udp.ovpn2.prg.suse.de [10.100.201.202])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id C1E8A2C141;
        Thu,  2 Feb 2023 13:58:34 +0000 (UTC)
Date:   Thu, 2 Feb 2023 14:58:31 +0100
From:   Petr Mladek <pmladek@suse.com>
To:     Josh Poimboeuf <jpoimboe@kernel.org>
Cc:     Marcos Paulo de Souza <mpdesouza@suse.com>,
        linux-kernel@vger.kernel.org, live-patching@vger.kernel.org,
        jpoimboe@redhat.com, joe.lawrence@redhat.com,
        Nicolai Stange <nstange@suse.de>
Subject: Re: [PATCH v2 4/4] livepatch/shadow: Add garbage collection of
 shadow variables
Message-ID: <Y9vBh7ylNcnX8Kek@alley>
References: <20221026194122.11761-1-mpdesouza@suse.com>
 <20221026194122.11761-5-mpdesouza@suse.com>
 <20230131044008.atapgt326nsl6fdp@treble>
 <Y9kkflJxq2A9+W8Q@alley>
 <20230131211731.i7c6isqp5a7k4hrj@treble>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230131211731.i7c6isqp5a7k4hrj@treble>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue 2023-01-31 13:17:31, Josh Poimboeuf wrote:
> On Tue, Jan 31, 2023 at 03:23:58PM +0100, Petr Mladek wrote:
> > > > +
> > > >  void *klp_shadow_get(void *obj, struct klp_shadow_type *shadow_type);
> > > >  void *klp_shadow_alloc(void *obj, struct klp_shadow_type *shadow_type,
> > > >  		       size_t size, gfp_t gfp_flags, void *ctor_data);
> > > 
> > > I find the type-based interface to be unnecessarily clunky and
> > > confusing:
> > > 
> > > - It obscures the fact that uniqueness is determined by ID, not by type.
> > > 
> > > - It's weird to be passing around the type even after it has been
> > >   registered: e.g., why doesn't klp remember the ctor/dtor?
> > 
> > ctor/dtor must be implemented in each livepatch. klp_shadow_register()
> > would need to remember all registered implementations.
> > klp_shadow_alloc/get/free would need to find and choose one.
> > It would add an extra overhead and non-determines.
> 
> There's really no need to even "register" the constructor.  It can
> continue to just be passed as needed to the alloc functions.

Sure. But it looks weird to handle the constructor another way then
the destructor. I mean that if we registrer the destructor then we
should registrer the constructor as well.

I see an analogy with C++ here. klp_shadow_register_type() is similar
to defining a class. And both constructor and destructor are defined
in the class definition.

A custom constructor in C++ might allow to pass extra parameters
needed for initialization. In our case, these are obj, size,
gpf_flags, ctor_data.


> (Side note, I don't see why klp_shadow_alloc() even needs a constructor
> as it's typically used when its corresponding object gets allocated, so
> its initialization doesn't need to be atomic.  klp_shadow_get_or_alloc()
> on the other hand, does need a constructor since it's used for attaching
> to already-existing objects.)

If we agree that klp_shadow_get_or_alloc() needed a constructor then
klp_shadow_alloc() should do the same. Different behavior would add
more confusion from my POV.


> The thing really complicating this whole mess of an API is the
> destructor.  The problem is that it can change when replacing
> livepatches, so we can't just remember it in the registration.
> 
> At least at Red Hat, I don't think we've ever used a shadow destructor.
> Its real world use seems somewhere between rare and non-existent.

I checked SUSE livepatches and we use the destructor once
for mutex_destroy(). I guess that it made the livepatch more safe.
Also it might have been useful for testing.


> I guess a destructor would be needed if the constructor (or some other
> initialization) allocated additional memory associated with the shadow
> variable.  That data would need to be freed.

It seems that the constructor is primary used to initialize the
structure members, for example, locks.

The commit e91c2518a5d22a07642f35 ("livepatch: Initialize shadow
variables safely by a custom callback") mentions as an example
list_head. The constructor might want to link it into another list.
In that case, the destructor would do the opposite.

> But in that case couldn't an additional shadow variable be used for the
> additional memory?  Then we could just get rid of this idea of the
> destructor and this API could become much more straightforward.
> 
> Alternatively, each livepatch could just have an optional global
> destructor which is called for every object which needs destructing.  It
> could then use the ID to decide what needs done (or pass it off to a
> more specific destructor).

Honestly, I do not think that it would really make things easier
for people developing the livepatches.


Summary:

My understanding is that you do not like the following things:

1. Problem: Having both struct klp_shadow_type and
	 struct klp_shadow_type_reg.

   Proposal: Get rid of struct klp_shadow_type_reg. Instead, add
	a list_head into struct klp_shadow_type and use it for
	registration and reference counting.


2. Problem: Using struct klp_shadow_type * instead of ID in
	the klp_shadow API.

   Solution:
	a) Find the shadow_type by ID.
	b) Get rid of klp_shadow_type completely


3. Problem: The API is obscure in general and this makes it even worse

   Solution:
       a) Do not pass constructor in klp_shadow_alloc()
       b) Do not support destructor
       c) Have global destructor


Requirements:

We agree that a constructor is needed at least for
klp_shadow_get_or_alloc().

The garbage collection solves a real problem. It provides a real
solution instead of custom hacks.


My opinion:

The shadow API is used rarely so that livepatch developer do not
have much experience with it.

The shadow API is usually used for some tricky things. And it is
used for custom livepatch-specific modifications that do not
get much review.

An ideal API should be simple. But we agree that the constructor is
needed in klp_shadow_get_or_alloc(). It defines the basic
complexity of the API.

The API should be predictable. IMHO, klp_shadow_alloc() should handle
the constructor the same way as klp_shadow_get_or_alloc().

Also it would help when the API is symmetric. I would keep the
destructor. And if register destructor then we should register
constructor as well.

I do not see big difference between passing ID or struct
klp_shadow_type * in the API. IMHO, it is better than a common
destructor.

Summary: I would get rid of struct klp_shadow_type_reg and
	keep the rest as is.


Proposal:

If we can't find an agreenment. Then the decision should be made
by people actually using the API. On the SUSE side, it is Nicolai
and Marcos.

IMHO, the main question is whether we need custom destructors.
We could avoid struct klp_shadow_type if the destructors are
not needed...


> > > - I don't understand the exposed klp_shadow_{un}register() interfaces.
> > >   What's the point of forcing their use if there's no garbage
> > >   collection?
> > 
> > I probably do not understand it correctly.
> > 
> > Normal livepatch developers do not need to use klp_shadow_{un}register().
> > They are called transparently in __klp_enable_patch()/klp_complete_transition()
> > and klp_module_coming()/klp_cleanup_module_patches_limited().
> > 
> > The main reason why they are exposed via include/linux/livepatch.h
> > and EXPORT_SYMBOL_GPL() is the selftest lib/livepatch/test_klp_shadow_vars.c.
> > 
> > Well, the selftest probably could be bundled into a livepatch to go
> > around this.
> 
> In that case, at the very least they should be prefixed with underscores
> and the function comment should make it clear they shouldn't be called
> under normal usage.

Good point. Well, I think that we should start testing the klp_shadow API using
livepatches. So that it won't be necessary to export the registration API.

Best Regards,
Petr
