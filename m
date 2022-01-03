Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4122483008
	for <lists+live-patching@lfdr.de>; Mon,  3 Jan 2022 11:49:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232718AbiACKtT (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 3 Jan 2022 05:49:19 -0500
Received: from smtp-out1.suse.de ([195.135.220.28]:44542 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229545AbiACKtT (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 3 Jan 2022 05:49:19 -0500
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id C4B3D2110B;
        Mon,  3 Jan 2022 10:49:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1641206957; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=kXWXkoeqCuuk6VXlljVuLN5eBry1ocUqknDqjO5oeek=;
        b=WlxjNI4cZHAoGZ0p4MYppKOslPLul653Z5x/knyWA7LxKGIL9YaMiMLnYld2KjGXwSHlnV
        MZhhiDsY7zTjLkySqqhbbV5H6rRGJ/2b237ooGf1ztTo6/15OiVlugUG6kdgOUipgBTJrb
        8Ae3GgDqYw/Kj/5kB5LAHjtP6N/Jp3Q=
Received: from suse.cz (unknown [10.100.224.162])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 46F11A3B83;
        Mon,  3 Jan 2022 10:49:17 +0000 (UTC)
Date:   Mon, 3 Jan 2022 11:49:14 +0100
From:   Petr Mladek <pmladek@suse.com>
To:     David Vernet <void@manifault.com>
Cc:     Yang Yingliang <yangyingliang@huawei.com>,
        linux-kernel@vger.kernel.org, live-patching@vger.kernel.org,
        jpoimboe@redhat.com, jikos@kernel.org, mbenes@suse.cz
Subject: Re: [PATCH -next] livepatch: Fix missing unlock on error in
 klp_enable_patch()
Message-ID: <YdLUqsYeXg91GjZ7@alley>
References: <20211225025115.475348-1-yangyingliang@huawei.com>
 <YcnqcXMQ7hxBe68a@dev0025.ash9.facebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YcnqcXMQ7hxBe68a@dev0025.ash9.facebook.com>
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Mon 2021-12-27 08:31:45, David Vernet wrote:
> Yang Yingliang <yangyingliang@huawei.com> wrote on Sat [2021-Dec-25 10:51:15 +0800]:
> > Add missing unlock when try_module_get() fails in klp_enable_patch().
> > 
> > Fixes: bf01c2975925 ("livepatch: Fix kobject refcount bug on klp_init_patch_early failure path")
> > Reported-by: Hulk Robot <hulkci@huawei.com>
> > Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> > ---
> >  kernel/livepatch/core.c | 4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> > 
> > diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
> > index 23cf444091a8..01bfab7fe7c0 100644
> > --- a/kernel/livepatch/core.c
> > +++ b/kernel/livepatch/core.c
> > @@ -1047,8 +1047,10 @@ int klp_enable_patch(struct klp_patch *patch)
> >  		return -EINVAL;
> >  	}
> >  
> > -	if (!try_module_get(patch->mod))
> > +	if (!try_module_get(patch->mod)) {
> > +		mutex_unlock(&klp_mutex);
> >  		return -ENODEV;
> > +	}
> >  
> >  	klp_init_patch_early(patch);
> >  
> > -- 
> > 2.25.1
> > 
> 
> Apologies for the silly oversight. Thank you for the fix.

And nobody caught it. I think that it was partly caused by
a pre-holiday loss of concentration :-/

> Acked-by: David Vernet <void@manifault.com>

Reviewed-by: Petr Mladek <pmladek@suse.com>

Best Regards,
Petr
