Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 248BBFC7E
	for <lists+live-patching@lfdr.de>; Tue, 30 Apr 2019 17:10:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726359AbfD3PKJ (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 30 Apr 2019 11:10:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:37136 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726028AbfD3PKI (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Tue, 30 Apr 2019 11:10:08 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8EB4B20835;
        Tue, 30 Apr 2019 15:10:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556637008;
        bh=zBYVD89Ga502t2W3oixEvvE+fgpD1hl8GQQvPTyVRkk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=zUDdEa0JtLy8WrOxbx7BBxtDmXrNIiFICLg7H2xTTiXms64PfZ/Fh2KB2DlmrgE15
         PoBF/xyJoecS5srDBmHfzTeR3mF1gUPR1qAZopw9g30sRcF7VkpokPRdXvjhnkOHwl
         lFO5RSMStrU0KCVjf8jTztwFQ6lS5ridnVz7vHYk=
Date:   Tue, 30 Apr 2019 17:10:05 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Petr Mladek <pmladek@suse.com>
Cc:     "Tobin C. Harding" <tobin@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] livepatch: Fix kobject memleak
Message-ID: <20190430151005.GA20916@kroah.com>
References: <20190430001534.26246-1-tobin@kernel.org>
 <20190430001534.26246-2-tobin@kernel.org>
 <20190430145613.7tokgyqjsuxlyh2g@pathway.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190430145613.7tokgyqjsuxlyh2g@pathway.suse.cz>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue, Apr 30, 2019 at 04:56:13PM +0200, Petr Mladek wrote:
> On Tue 2019-04-30 10:15:33, Tobin C. Harding wrote:
> > Currently error return from kobject_init_and_add() is not followed by a
> > call to kobject_put().  This means there is a memory leak.
> 
> I see, the ref count is always initialized to 1 via:
> 
>   + kobject_init_and_add()
>     + kobject_init()
>       + kobject_init_internal()
> 	+ kref_init()
> 
> 
> > Signed-off-by: Tobin C. Harding <tobin@kernel.org>
> > ---
> >  kernel/livepatch/core.c | 12 +++++++++---
> >  1 file changed, 9 insertions(+), 3 deletions(-)
> > 
> > diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
> > index eb0ee10a1981..98a7bec41faa 100644
> > --- a/kernel/livepatch/core.c
> > +++ b/kernel/livepatch/core.c
> > @@ -727,7 +727,9 @@ static int klp_init_func(struct klp_object *obj, struct klp_func *func)
> >  	ret = kobject_init_and_add(&func->kobj, &klp_ktype_func,
> >  				   &obj->kobj, "%s,%lu", func->old_name,
> >  				   func->old_sympos ? func->old_sympos : 1);
> > -	if (!ret)
> > +	if (ret)
> > +		kobject_put(&func->kobj);
> > +	else
> >  		func->kobj_added = true;
> 
> We could actually get rid of the custom kobj_added. Intead, we could
> check for kobj->state_initialized in the various klp_free* functions.

Why do you need to care about this at all anyway?  The kobject can
handle it's own lifetime just fine (that's what it is there for), why do
you need to also track it?

thanks,

greg k-h
