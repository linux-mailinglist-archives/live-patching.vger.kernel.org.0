Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 906F947A768
	for <lists+live-patching@lfdr.de>; Mon, 20 Dec 2021 10:48:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230156AbhLTJsq (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 20 Dec 2021 04:48:46 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:47512 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230139AbhLTJsq (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 20 Dec 2021 04:48:46 -0500
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 5D8CD1F381;
        Mon, 20 Dec 2021 09:48:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1639993725; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ChQn6vubC/nAMrCMhDXt+5Se68ms5hI5Evn2K9UY5Ow=;
        b=two1fDIrP61IMB7FIZl8TihOmr4buKC/sISLddQWr2TVwFrwebDlzU9vX7nf1i6VoutWKU
        W+dRyeyM6S/6mO9z1ixWqzQInOf/0FhBla8ISoBqfnROV7eaLjNjkl/fL+xKiIH6j5Kb/1
        vKm/cnUNSlmbFPRYZ/9i8CDVAuUKfVo=
Received: from suse.cz (unknown [10.100.224.162])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 14E85A3B81;
        Mon, 20 Dec 2021 09:48:45 +0000 (UTC)
Date:   Mon, 20 Dec 2021 10:48:41 +0100
From:   Petr Mladek <pmladek@suse.com>
To:     Josh Poimboeuf <jpoimboe@redhat.com>
Cc:     David Vernet <void@manifault.com>, live-patching@vger.kernel.org,
        linux-kernel@vger.kernel.org, jikos@kernel.org, mbenes@suse.cz,
        joe.lawrence@redhat.com, corbet@lwn.net, songliubraving@fb.com,
        gregkh@linuxfoundation.org
Subject: Re: [PATCH v2] livepatch: Fix leak on klp_init_patch_early failure
 path
Message-ID: <YcBReVgF2hFLpyjf@alley>
References: <20211214220124.2911264-1-void@manifault.com>
 <20211214235128.ckaozqsvcr6iqcnu@treble>
 <Ybm+FyhLnuH4JThq@alley>
 <YboHpHmu3D+0hxKp@dev0025.ash9.facebook.com>
 <YbyV7nsLXbQ6/44S@alley>
 <20211217215042.76m5qn5e63ptgrjq@treble>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211217215042.76m5qn5e63ptgrjq@treble>
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Fri 2021-12-17 13:50:42, Josh Poimboeuf wrote:
> On Fri, Dec 17, 2021 at 02:51:42PM +0100, Petr Mladek wrote:
> > On Wed 2021-12-15 07:20:04, David Vernet wrote:
> > Josh's proposal adds pre-early-init() to allow calling
> > klp_free_patch_*() already when klp_init_*_early() fails.
> > The purpose is to make sure that klp_init_*_early()
> > will actually never fail.
> > 
> > This might make things somehow complicated. Any future change
> > in klp_init_*_early() might require change in pre-early-init()
> > to catch eventual problems earlier.
> 
> I'm not sure why that would be a problem.  If we can separate out the
> things which fail from the things which don't, it simplifies things.

I think that there is no right answer. It depends on personal
preferences.


> > My proposal is to use simple trick. klp_free_patch_*() iterate
> > using the dynamic list (list_for_each_entry) while klp_init_*_early()
> > iterate using the arrays.
> > 
> > Now, we just need to make sure that klp_init_*_early() will only add
> > fully initialized structures into the dynamic list. As a result,
> > klp_free_patch() will see only the fully initialized structures
> > and could release them. It will not see that not-yet-initialized
> > structures but it is fine. They are not initialized and they do not
> > need to be freed.
> > 
> > In fact, I think that klp_init_*_early() functions already do
> > the right thing. IMHO, if you move the module_get() then you
> > could safely do:
> > 
> > int klp_enable_patch(struct klp_patch *patch)
> > {
> > [...]
> > 	if (!try_module_get(patch->mod)) {
> > 		mutex_unlock(&klp_mutex);
> > 		return -ENODEV;
> > 	}
> > 
> > 	ret = klp_init_patch_early(patch);
> > 	if (ret)
> > 		goto err;
> > 
> > 
> > Note that it would need to get tested.
> > 
> > Anyway, does it make sense now?
> 
> It would work, but it's too clever/non-obvious.  If we rely on tricks
> then we may eventually forget about them and accidentally break
> assumptions later.

It is not that super magic from my POV. But again, it is a personal
taste.

I do not want to bikeshed about it. Feel free to use the pre-early
thing.

Best Regards,
Petr
