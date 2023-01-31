Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8850268387B
	for <lists+live-patching@lfdr.de>; Tue, 31 Jan 2023 22:17:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231440AbjAaVRi (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 31 Jan 2023 16:17:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229613AbjAaVRh (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 31 Jan 2023 16:17:37 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 365FD4861D;
        Tue, 31 Jan 2023 13:17:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E82FDB81EE8;
        Tue, 31 Jan 2023 21:17:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65E93C433EF;
        Tue, 31 Jan 2023 21:17:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675199853;
        bh=E7KByHYDEVSon6Ok5f/jbVyuLo0txU715xa09Cdt6mE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pqiqQI67SOynS8JZEq3e/O+1NP8/ZbVZ+BYY6UiN5/Ou7oYgmVAUHVWqsms8l9gSy
         rY8kF1vjHoXH40SqOfuAo7zWLqKZts4/MjvrcqZ8g40SeijVoIpANh4Odci8mFnrJH
         HpWXVMm684/ZvP1wDS+Kl0Y4oAD9rbxkGBFnE/G4XkcPL1UIdG7OJXn2zh54jmlSNw
         8CmcwgZKya7fKn3IjXSv1Z81Fvw7J20w52ZCr9BLZH/pyTUD61SZdfLhLYl6CK+eQX
         XYLsVl3FAh6smWJEQfWvXZzDPePjJzORSV8UCNeUD8oZS91yhPadZoJur3Kqd4m9p9
         Hzmj6VKQcBkww==
Date:   Tue, 31 Jan 2023 13:17:31 -0800
From:   Josh Poimboeuf <jpoimboe@kernel.org>
To:     Petr Mladek <pmladek@suse.com>
Cc:     Marcos Paulo de Souza <mpdesouza@suse.com>,
        linux-kernel@vger.kernel.org, live-patching@vger.kernel.org,
        jpoimboe@redhat.com, joe.lawrence@redhat.com
Subject: Re: [PATCH v2 4/4] livepatch/shadow: Add garbage collection of
 shadow variables
Message-ID: <20230131211731.i7c6isqp5a7k4hrj@treble>
References: <20221026194122.11761-1-mpdesouza@suse.com>
 <20221026194122.11761-5-mpdesouza@suse.com>
 <20230131044008.atapgt326nsl6fdp@treble>
 <Y9kkflJxq2A9+W8Q@alley>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Y9kkflJxq2A9+W8Q@alley>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue, Jan 31, 2023 at 03:23:58PM +0100, Petr Mladek wrote:
> > > +
> > >  void *klp_shadow_get(void *obj, struct klp_shadow_type *shadow_type);
> > >  void *klp_shadow_alloc(void *obj, struct klp_shadow_type *shadow_type,
> > >  		       size_t size, gfp_t gfp_flags, void *ctor_data);
> > 
> > I find the type-based interface to be unnecessarily clunky and
> > confusing:
> > 
> > - It obscures the fact that uniqueness is determined by ID, not by type.
> > 
> > - It's weird to be passing around the type even after it has been
> >   registered: e.g., why doesn't klp remember the ctor/dtor?
> 
> ctor/dtor must be implemented in each livepatch. klp_shadow_register()
> would need to remember all registered implementations.
> klp_shadow_alloc/get/free would need to find and choose one.
> It would add an extra overhead and non-determines.

There's really no need to even "register" the constructor.  It can
continue to just be passed as needed to the alloc functions.

(Side note, I don't see why klp_shadow_alloc() even needs a constructor
as it's typically used when its corresponding object gets allocated, so
its initialization doesn't need to be atomic.  klp_shadow_get_or_alloc()
on the other hand, does need a constructor since it's used for attaching
to already-existing objects.)

The thing really complicating this whole mess of an API is the
destructor.  The problem is that it can change when replacing
livepatches, so we can't just remember it in the registration.

At least at Red Hat, I don't think we've ever used a shadow destructor.
Its real world use seems somewhere between rare and non-existent.

I guess a destructor would be needed if the constructor (or some other
initialization) allocated additional memory associated with the shadow
variable.  That data would need to be freed.

But in that case couldn't an additional shadow variable be used for the
additional memory?  Then we could just get rid of this idea of the
destructor and this API could become much more straightforward.

Alternatively, each livepatch could just have an optional global
destructor which is called for every object which needs destructing.  It
could then use the ID to decide what needs done (or pass it off to a
more specific destructor).

> > - I don't understand the exposed klp_shadow_{un}register() interfaces.
> >   What's the point of forcing their use if there's no garbage
> >   collection?
> 
> I probably do not understand it correctly.
> 
> Normal livepatch developers do not need to use klp_shadow_{un}register().
> They are called transparently in __klp_enable_patch()/klp_complete_transition()
> and klp_module_coming()/klp_cleanup_module_patches_limited().
> 
> The main reason why they are exposed via include/linux/livepatch.h
> and EXPORT_SYMBOL_GPL() is the selftest lib/livepatch/test_klp_shadow_vars.c.
> 
> Well, the selftest probably could be bundled into a livepatch to go
> around this.

In that case, at the very least they should be prefixed with underscores
and the function comment should make it clear they shouldn't be called
under normal usage.

> > - It's internally confusing in klp to have both 'type' and 'type_reg'.
> 
> I do not like it much either.
> 
> An idea. We could replace "bool registered" with "struct list_head
> register_node" in struct klp_shadow_type. Then we could use it
> for registration.
> 
> All the registered types will be in a global list (klp_type_register).
> klp_shadow_unregister() would do the garbage collection when it
> removed the last entry with the given id from the global list.

Yeah, that does sound better (assuming we decide to keep this type
thing).

> > It seems like overkill to have both klp_shadow_hash and
> > klp_shadow_types.  For example 'struct klp_shadow' could have a link to
> > its type and then klp_shadow_type_get_reg could iterate through the
> > klp_shadow_hash.
> 
> I guess that there is a misunderstanding. We need two databases:
> 
>    + One for the registered shadow_types. I does the reference
>      counting. It counts the number of livepatched objects
>      (livepatches) that might the shadow type. It says _when_ the garbage
>      collection must be done.
> 
>    + Second for existing shadow variables. It is needed for finding
>      the shadow data. It says _what_ variables have to freed when
>      the garbage collection is being proceed.

Yup, not sure what I was thinking, please ignore...

-- 
Josh
