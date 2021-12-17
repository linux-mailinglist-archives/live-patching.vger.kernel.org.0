Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33518478CC5
	for <lists+live-patching@lfdr.de>; Fri, 17 Dec 2021 14:51:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233082AbhLQNvq (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 17 Dec 2021 08:51:46 -0500
Received: from smtp-out1.suse.de ([195.135.220.28]:54154 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233098AbhLQNvp (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 17 Dec 2021 08:51:45 -0500
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 4098C21101;
        Fri, 17 Dec 2021 13:51:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1639749104; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=JrT0B8EIbUK8BBtIWpxlQl/WlItqKPF02uqa7KAkEDg=;
        b=sU5Lc2KlfGUlbg0BzOHNfhfhhpRJc6+YyImKYeTC1j+D5gu5o94yR+MZHasGeg6tWcqBxV
        XlcrFu8oMPscCieZybfBGI8EDSPlArZ5cKT9lCJqXv+DZhx1dVW8bVJh9CkcHM0HzzR7UP
        4Albd1ONAU6AqxJHBIAoln7XCVL8yho=
Received: from suse.cz (unknown [10.100.216.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id E2AD5A3B87;
        Fri, 17 Dec 2021 13:51:43 +0000 (UTC)
Date:   Fri, 17 Dec 2021 14:51:42 +0100
From:   Petr Mladek <pmladek@suse.com>
To:     David Vernet <void@manifault.com>
Cc:     Josh Poimboeuf <jpoimboe@redhat.com>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        jikos@kernel.org, mbenes@suse.cz, joe.lawrence@redhat.com,
        corbet@lwn.net, songliubraving@fb.com, gregkh@linuxfoundation.org
Subject: Re: [PATCH v2] livepatch: Fix leak on klp_init_patch_early failure
 path
Message-ID: <YbyV7nsLXbQ6/44S@alley>
References: <20211214220124.2911264-1-void@manifault.com>
 <20211214235128.ckaozqsvcr6iqcnu@treble>
 <Ybm+FyhLnuH4JThq@alley>
 <YboHpHmu3D+0hxKp@dev0025.ash9.facebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YboHpHmu3D+0hxKp@dev0025.ash9.facebook.com>
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed 2021-12-15 07:20:04, David Vernet wrote:
> Petr Mladek <pmladek@suse.com> wrote on Wed [2021-Dec-15 11:06:15 +0100]:
> > Well, I still believe that this is just a cargo cult. And I would prefer
> > to finish the discussion about it, first, see
> > https://lore.kernel.org/all/YbmlL0ZyfSuek9OB@alley/
> 
> No problem, I won't send out v3 until we've finished the discussion and
> have consensus. I'll assume that the discussion on whether or not there is
> a leak will continue on the thread you linked to above, so I won't comment
> on it here.
> 
> > Note that klp_init_*_early() functions iterate through the arrays
> > using klp_for_each_*_static. While klp_free_*() functions iterate
> > via the lists using klp_for_each_*_safe().
> 
> Correct, as I've understood it, klp_for_each_*_safe() should only iterate
> over the objects that have been added to the patch and klp_object's lists,
> and thus for which kobject_init() has been invoked. So if we fail a check
> on 'struct klp_object' N, then we'll only iterate over the first N - 1
> objects in klp_for_each_*_safe().
> 
> > We should not need the pre-early-init check when the lists include only
> > structures with initialized kobjects.
> 
> Not sure I quite follow. We have to do NULL checks for obj->funcs at some
> point, and per Josh's suggestion it seems cleaner to do it outside the
> critical section, and before we actually invoke kobject_init(). Apologies
> if I've misunderstood your point.

The original purpose of klp_init_*_early() was to allow calling
klp_free_patch_*() when klp_init_*() fails. The idea was to
initialize all fields properly so that free functions would
do the right thing.

Josh's proposal adds pre-early-init() to allow calling
klp_free_patch_*() already when klp_init_*_early() fails.
The purpose is to make sure that klp_init_*_early()
will actually never fail.

This might make things somehow complicated. Any future change
in klp_init_*_early() might require change in pre-early-init()
to catch eventual problems earlier.

Also I am not sure what to do with the existing checks
in klp_init_patch_early(). I am uneasy with removing them
and hoping that pre-early-init() did the right job.
But if we keep the checks then klp_init_patch_early() then it
might fail and the code will not be ready for this.


My proposal is to use simple trick. klp_free_patch_*() iterate
using the dynamic list (list_for_each_entry) while klp_init_*_early()
iterate using the arrays.

Now, we just need to make sure that klp_init_*_early() will only add
fully initialized structures into the dynamic list. As a result,
klp_free_patch() will see only the fully initialized structures
and could release them. It will not see that not-yet-initialized
structures but it is fine. They are not initialized and they do not
need to be freed.

In fact, I think that klp_init_*_early() functions already do
the right thing. IMHO, if you move the module_get() then you
could safely do:

int klp_enable_patch(struct klp_patch *patch)
{
[...]
	if (!try_module_get(patch->mod)) {
		mutex_unlock(&klp_mutex);
		return -ENODEV;
	}

	ret = klp_init_patch_early(patch);
	if (ret)
		goto err;


Note that it would need to get tested.

Anyway, does it make sense now?

Best Regards,
Petr
