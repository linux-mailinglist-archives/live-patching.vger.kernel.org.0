Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF732F46E
	for <lists+live-patching@lfdr.de>; Tue, 30 Apr 2019 12:46:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726793AbfD3Kqm (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 30 Apr 2019 06:46:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:50496 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726736AbfD3Kql (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Tue, 30 Apr 2019 06:46:41 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C048E20675;
        Tue, 30 Apr 2019 10:46:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556621201;
        bh=D3sfDG7uxYtxPW02ApZZJFjnsJg3kMpIBjXi36/qpno=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ChJUZQJwe1XcML0+wkCvqsopVCkLe5hjyK/1ECif/g6SLfTtVah03jseseraLfs+I
         16ipOq+lLYd/SruQpfU1YH04tKiAz1KJsCIySGy8dfEPU+YkIuR7OZoi/D2V1obGMD
         yHBwa6YyFXLg4bVfE+x1nfz9vectIJs3tW0CwtS4=
Date:   Tue, 30 Apr 2019 12:46:38 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Miroslav Benes <mbenes@suse.cz>
Cc:     "Tobin C. Harding" <tobin@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jikos@kernel.org>, Petr Mladek <pmladek@suse.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] livepatch: Fix kobject memleak
Message-ID: <20190430104638.GA8137@kroah.com>
References: <20190430001534.26246-1-tobin@kernel.org>
 <20190430001534.26246-2-tobin@kernel.org>
 <20190430084254.GB11737@kroah.com>
 <alpine.LSU.2.21.1904301235450.8507@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.21.1904301235450.8507@pobox.suse.cz>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue, Apr 30, 2019 at 12:44:55PM +0200, Miroslav Benes wrote:
> On Tue, 30 Apr 2019, Greg Kroah-Hartman wrote:
> 
> > On Tue, Apr 30, 2019 at 10:15:33AM +1000, Tobin C. Harding wrote:
> > > Currently error return from kobject_init_and_add() is not followed by a
> > > call to kobject_put().  This means there is a memory leak.
> > > 
> > > Add call to kobject_put() in error path of kobject_init_and_add().
> > > 
> > > Signed-off-by: Tobin C. Harding <tobin@kernel.org>
> > 
> > Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> Well, it does not even compile...

The idea is correct :)

> On Tue, 30 Apr 2019, Tobin C. Harding wrote:
> 
> > Currently error return from kobject_init_and_add() is not followed by a
> > call to kobject_put().  This means there is a memory leak.
> > 
> > Add call to kobject_put() in error path of kobject_init_and_add().
> > 
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
> >  
> >  	return ret;
> > @@ -803,8 +805,10 @@ static int klp_init_object(struct klp_patch *patch, struct klp_object *obj)
> >  	name = klp_is_module(obj) ? obj->name : "vmlinux";
> >  	ret = kobject_init_and_add(&obj->kobj, &klp_ktype_object,
> >  				   &patch->kobj, "%s", name);
> > -	if (ret)
> > +	if (ret) {
> > +		kobject_put(&func->kobj);
> 
> kobject_put(&obj->kobj); I suppose.

Yeah, that makes it better, sorry for not catching that in the review :(

greg k-h
