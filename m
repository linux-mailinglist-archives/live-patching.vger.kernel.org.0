Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DCFFCFBF1
	for <lists+live-patching@lfdr.de>; Tue, 30 Apr 2019 16:56:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726066AbfD3O4P (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 30 Apr 2019 10:56:15 -0400
Received: from mx2.suse.de ([195.135.220.15]:56398 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726053AbfD3O4O (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Tue, 30 Apr 2019 10:56:14 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 9FA9AABE1;
        Tue, 30 Apr 2019 14:56:13 +0000 (UTC)
Date:   Tue, 30 Apr 2019 16:56:13 +0200
From:   Petr Mladek <pmladek@suse.com>
To:     "Tobin C. Harding" <tobin@kernel.org>
Cc:     Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] livepatch: Fix kobject memleak
Message-ID: <20190430145613.7tokgyqjsuxlyh2g@pathway.suse.cz>
References: <20190430001534.26246-1-tobin@kernel.org>
 <20190430001534.26246-2-tobin@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190430001534.26246-2-tobin@kernel.org>
User-Agent: NeoMutt/20170912 (1.9.0)
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue 2019-04-30 10:15:33, Tobin C. Harding wrote:
> Currently error return from kobject_init_and_add() is not followed by a
> call to kobject_put().  This means there is a memory leak.

I see, the ref count is always initialized to 1 via:

  + kobject_init_and_add()
    + kobject_init()
      + kobject_init_internal()
	+ kref_init()


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

We could actually get rid of the custom kobj_added. Intead, we could
check for kobj->state_initialized in the various klp_free* functions.

Best Regards,
Petr
