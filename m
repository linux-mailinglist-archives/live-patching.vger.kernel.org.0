Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D175E60ADC5
	for <lists+live-patching@lfdr.de>; Mon, 24 Oct 2022 16:34:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232547AbiJXOeQ (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 24 Oct 2022 10:34:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237178AbiJXOeC (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 24 Oct 2022 10:34:02 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 611029DDB8
        for <live-patching@vger.kernel.org>; Mon, 24 Oct 2022 06:09:08 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id AA2F21FD92;
        Mon, 24 Oct 2022 12:59:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1666616374; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=pN1heeaLFpPg/ZBDZe4BcH3XBZUjLc6e8rJPSmQsDEU=;
        b=PoL/fBmFXb6KN4l/Qlho0qFF9VKO+PynOA7kfR1D6YJ+4tqHXlXJDb0QgnpKaInEOragmJ
        kRpugBxwo6XODyX/JvKh7z44pSz+Qkh/4pbkVrsmnhMv99meJYuJ7Jvj+aLnDd6tW75b3+
        pOIUPALlZcb2igg1hMT1I6Xdf4nGVao=
Received: from suse.cz (unknown [10.100.201.202])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 8C7862C141;
        Mon, 24 Oct 2022 12:59:34 +0000 (UTC)
Date:   Mon, 24 Oct 2022 14:59:31 +0200
From:   Petr Mladek <pmladek@suse.com>
To:     Joe Lawrence <joe.lawrence@redhat.com>
Cc:     Marcos Paulo de Souza <mpdesouza@suse.com>,
        live-patching@vger.kernel.org, jpoimboe@redhat.com, mbenes@suse.cz,
        nstange@suse.de
Subject: Re: [PATCH 3/4] livepatch/shadow: Introduce klp_shadow_type structure
Message-ID: <Y1aMMxCPCEjP5Lc8@alley>
References: <20220701194817.24655-1-mpdesouza@suse.com>
 <20220701194817.24655-4-mpdesouza@suse.com>
 <a0daa94e-a66d-ad14-339c-ed08b3914469@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a0daa94e-a66d-ad14-339c-ed08b3914469@redhat.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Thu 2022-08-25 10:50:20, Joe Lawrence wrote:
> On 7/1/22 3:48 PM, Marcos Paulo de Souza wrote:
> > The shadow variable type will be used in klp_shadow_alloc/get/free
> > functions instead of id/ctor/dtor parameters. As a result, all callers
> > use the same callbacks consistently[*][**].
> > 
> > The structure will be used in the next patch that will manage the
> > lifetime of shadow variables and execute garbage collection automatically.
> > 
> > [*] From the user POV, it might have been easier to pass $id instead
> >     of pointer to struct klp_shadow_type.
> > 
> >     The problem is that each livepatch registers its own struct
> >     klp_shadow_type and defines its own @ctor/@dtor callbacks. It would
> >     be unclear what callback should be used. They should be compatible.
> > 
> >     This problem is gone when each livepatch explicitly uses its
> >     own struct klp_shadow_type pointing to its own callbacks.
> > 
> > [**] test_klp_shadow_vars.c uses a custom @dtor to show that it was called.
> >     The message must be disabled when called via klp_shadow_free_all()
> >     because the ordering of freed variables is not well defined there.
> >     It has to be done using another hack after switching to
> >     klp_shadow_types.
> > 
> 
> Is the ordering problem new to this patchset?  Shadow variables are
> still saved in klp_shadow_hash and I think the only change in this patch
> is that we need to compare through shadow_type and not id directly.  Or
> does patch 4/4 change behavior here?  Just curious, otherwise this patch
> is pretty straightforward.

The problem is old. klp_shadow_free_all() uses hash_for_each(). It
iterates the hashes sorted by the hash value. The tested arrays are
on stack. The address of the stack is different in every run.
As a result, the hash is always different and the pointers
are sorted in different order.

Best Regards,
Petr
