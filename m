Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE42DE4FF
	for <lists+live-patching@lfdr.de>; Mon, 29 Apr 2019 16:44:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728300AbfD2OoX (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 29 Apr 2019 10:44:23 -0400
Received: from mx2.suse.de ([195.135.220.15]:56478 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725838AbfD2OoX (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Mon, 29 Apr 2019 10:44:23 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id B1858AD49;
        Mon, 29 Apr 2019 14:44:21 +0000 (UTC)
Date:   Mon, 29 Apr 2019 16:44:21 +0200
From:   Petr Mladek <pmladek@suse.com>
To:     Jiri Kosina <jikos@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Miroslav Benes <mbenes@suse.cz>
Cc:     Joe Lawrence <joe.lawrence@redhat.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] livepatch: Convert error about unsupported reliable
 stacktrace into a warning
Message-ID: <20190429144421.3ymte7reee22nf2c@pathway.suse.cz>
References: <20190424085550.29612-1-pmladek@suse.com>
 <20190424085550.29612-2-pmladek@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190424085550.29612-2-pmladek@suse.com>
User-Agent: NeoMutt/20170912 (1.9.0)
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed 2019-04-24 10:55:48, Petr Mladek wrote:
> The commit d0807da78e11d46f ("livepatch: Remove immediate feature") caused
> that any livepatch was refused when reliable stacktraces were not supported
> on the given architecture.
> 
> The limitation is too strong. User space processes are safely migrated
> even when entering or leaving the kernel. Kthreads transition would
> need to get forced. But it is safe when:
> 
>    + The livepatch does not change the semantic of the code.
>    + Callbacks do not depend on a safely finished transition.
> 
> Suggested-by: Josh Poimboeuf <jpoimboe@redhat.com>
> Signed-off-by: Petr Mladek <pmladek@suse.com>
> ---
>  kernel/livepatch/core.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
> index eb0ee10a1981..14f33ab6c583 100644
> --- a/kernel/livepatch/core.c
> +++ b/kernel/livepatch/core.c
> @@ -1003,11 +1003,10 @@ int klp_enable_patch(struct klp_patch *patch)
>  		return -ENODEV;
>  
>  	if (!klp_have_reliable_stack()) {
> -		pr_err("This architecture doesn't have support for the livepatch consistency model.\n");
> -		return -EOPNOTSUPP;
> +		pr_warn("This architecture doesn't have support for the livepatch consistency model.\n");
> +		pr_warn("The livepatch transition may never complete.\n");
>  	}
>  
> -
>  	mutex_lock(&klp_mutex);
>  
>  	ret = klp_init_patch_early(patch);
> -- 
> 2.16.4

I have committed this patch into for-5.2/core branch.

Best Regards,
Petr

PS: I am going to resend 2nd patch separately with more people
    interested into kernel/stacktrace.c.

    Also I am going to send two separate patches instead of
    the 3rd one (complete warning removal, static err_buf).
