Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3DCE2F469
	for <lists+live-patching@lfdr.de>; Tue, 30 Apr 2019 12:44:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726294AbfD3Ko5 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 30 Apr 2019 06:44:57 -0400
Received: from mx2.suse.de ([195.135.220.15]:55462 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726262AbfD3Ko5 (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Tue, 30 Apr 2019 06:44:57 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 14421AD7C;
        Tue, 30 Apr 2019 10:44:56 +0000 (UTC)
Date:   Tue, 30 Apr 2019 12:44:55 +0200 (CEST)
From:   Miroslav Benes <mbenes@suse.cz>
To:     "Tobin C. Harding" <tobin@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
cc:     Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jikos@kernel.org>, Petr Mladek <pmladek@suse.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] livepatch: Fix kobject memleak
In-Reply-To: <20190430084254.GB11737@kroah.com>
Message-ID: <alpine.LSU.2.21.1904301235450.8507@pobox.suse.cz>
References: <20190430001534.26246-1-tobin@kernel.org> <20190430001534.26246-2-tobin@kernel.org> <20190430084254.GB11737@kroah.com>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue, 30 Apr 2019, Greg Kroah-Hartman wrote:

> On Tue, Apr 30, 2019 at 10:15:33AM +1000, Tobin C. Harding wrote:
> > Currently error return from kobject_init_and_add() is not followed by a
> > call to kobject_put().  This means there is a memory leak.
> > 
> > Add call to kobject_put() in error path of kobject_init_and_add().
> > 
> > Signed-off-by: Tobin C. Harding <tobin@kernel.org>
> 
> Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Well, it does not even compile...

On Tue, 30 Apr 2019, Tobin C. Harding wrote:

> Currently error return from kobject_init_and_add() is not followed by a
> call to kobject_put().  This means there is a memory leak.
> 
> Add call to kobject_put() in error path of kobject_init_and_add().
> 
> Signed-off-by: Tobin C. Harding <tobin@kernel.org>
> ---
>  kernel/livepatch/core.c | 12 +++++++++---
>  1 file changed, 9 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
> index eb0ee10a1981..98a7bec41faa 100644
> --- a/kernel/livepatch/core.c
> +++ b/kernel/livepatch/core.c
> @@ -727,7 +727,9 @@ static int klp_init_func(struct klp_object *obj, struct klp_func *func)
>  	ret = kobject_init_and_add(&func->kobj, &klp_ktype_func,
>  				   &obj->kobj, "%s,%lu", func->old_name,
>  				   func->old_sympos ? func->old_sympos : 1);
> -	if (!ret)
> +	if (ret)
> +		kobject_put(&func->kobj);
> +	else
>  		func->kobj_added = true;
>  
>  	return ret;
> @@ -803,8 +805,10 @@ static int klp_init_object(struct klp_patch *patch, struct klp_object *obj)
>  	name = klp_is_module(obj) ? obj->name : "vmlinux";
>  	ret = kobject_init_and_add(&obj->kobj, &klp_ktype_object,
>  				   &patch->kobj, "%s", name);
> -	if (ret)
> +	if (ret) {
> +		kobject_put(&func->kobj);

kobject_put(&obj->kobj); I suppose.

>  		return ret;
> +	}
>  	obj->kobj_added = true;
>  
>  	klp_for_each_func(obj, func) {
> @@ -862,8 +866,10 @@ static int klp_init_patch(struct klp_patch *patch)
>  
>  	ret = kobject_init_and_add(&patch->kobj, &klp_ktype_patch,
>  				   klp_root_kobj, "%s", patch->mod->name);
> -	if (ret)
> +	if (ret) {
> +		kobject_put(&func->kobj);

kobject_put(&patch->kobj);

Thanks,
Miroslav

