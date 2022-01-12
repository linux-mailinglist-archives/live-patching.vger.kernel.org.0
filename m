Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB1A548C8DA
	for <lists+live-patching@lfdr.de>; Wed, 12 Jan 2022 17:54:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355378AbiALQyD (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 12 Jan 2022 11:54:03 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:42288 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244049AbiALQyC (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 12 Jan 2022 11:54:02 -0500
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 041391F3A3;
        Wed, 12 Jan 2022 16:54:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1642006440; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=UlUXwhz5IgifMhCXTxIB0eJXkNvd51PGEd132obgUBM=;
        b=Tj12U0yEKazKvlgKPCg4i2/GRE9ioMuLOlUekHY2+lygso0kKTeGZHQJ81hlJdavgJyN7v
        LBWtJFHnvvbYoUfi+VKpAi8GdY3lJbV1Q6YfPzun1caBg7QjACzmPP/B+9WLMRSyMy5bCR
        8wgX92bPc1ryW7ohVEZWY48psnWhwlI=
Received: from suse.cz (unknown [10.100.216.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 9D218A3B84;
        Wed, 12 Jan 2022 16:53:59 +0000 (UTC)
Date:   Wed, 12 Jan 2022 17:53:56 +0100
From:   Petr Mladek <pmladek@suse.com>
To:     Aaron Tomlin <atomlin@redhat.com>
Cc:     mcgrof@kernel.org, cl@linux.com, mbenes@suse.cz,
        akpm@linux-foundation.org, jeyu@kernel.org,
        linux-kernel@vger.kernel.org, linux-modules@vger.kernel.org,
        atomlin@atomlin.com, ghalat@redhat.com, allen.lkml@gmail.com,
        live-patching@vger.kernel.org
Subject: Re: [RFC PATCH v2 03/13] module: Move livepatch support to a
 separate file
Message-ID: <Yd8HpK44aWhhNI/Q@alley>
References: <20220106234319.2067842-1-atomlin@redhat.com>
 <20220106234319.2067842-4-atomlin@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220106234319.2067842-4-atomlin@redhat.com>
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Thu 2022-01-06 23:43:09, Aaron Tomlin wrote:
> No functional change.
> 
> This patch migrates livepatch support (i.e. used during module
> add/or load and remove/or deletion) from core module code into
> kernel/module/livepatch.c. At the moment it contains code to
> persist Elf information about a given livepatch module, only.
> 
> Signed-off-by: Aaron Tomlin <atomlin@redhat.com>
> ---
>  kernel/module/Makefile    |  1 +
>  kernel/module/internal.h  | 12 ++++++
>  kernel/module/livepatch.c | 75 +++++++++++++++++++++++++++++++++
>  kernel/module/main.c      | 89 +--------------------------------------
>  4 files changed, 89 insertions(+), 88 deletions(-)
>  create mode 100644 kernel/module/livepatch.c
> 
> diff --git a/kernel/module/Makefile b/kernel/module/Makefile
> index a9cf6e822075..47d70bb18da3 100644
> --- a/kernel/module/Makefile
> +++ b/kernel/module/Makefile
> @@ -6,3 +6,4 @@
>  obj-$(CONFIG_MODULES) += main.o
>  obj-$(CONFIG_MODULE_SIG) += signing.o
>  obj-$(CONFIG_MODULE_SIG_FORMAT) += signature.o
> +obj-$(CONFIG_LIVEPATCH) += livepatch.o
> diff --git a/kernel/module/internal.h b/kernel/module/internal.h
> index ffc50df010a7..91ef152aeffb 100644
> --- a/kernel/module/internal.h
> +++ b/kernel/module/internal.h
> @@ -51,3 +51,15 @@ struct load_info {
>  };
>  
>  extern int mod_verify_sig(const void *mod, struct load_info *info);
> +
> +#ifdef CONFIG_LIVEPATCH
> +extern int copy_module_elf(struct module *mod, struct load_info *info);
> +extern void free_module_elf(struct module *mod);
> +extern int check_modinfo_livepatch(struct module *mod, struct load_info *info);
> +#else /* !CONFIG_LIVEPATCH */
> +static inline int copy_module_elf(struct module *mod, struct load_info *info)
> +{
> +	return 0;
> +}
> +static inline void free_module_elf(struct module *mod) { }

It looks like there is no check_modinfo_livepatch() variant when
CONFIG_LIPATCH is disabled.

> +#endif /* CONFIG_LIVEPATCH */
> diff --git a/kernel/module/main.c b/kernel/module/main.c
> index 2a6b859716c0..9bcaf251e109 100644
> --- a/kernel/module/main.c
> +++ b/kernel/module/main.c
> @@ -3052,19 +2977,7 @@ static int copy_chunked_from_user(void *dst, const void __user *usrc, unsigned l
>  	return 0;
>  }
>  
> -#ifdef CONFIG_LIVEPATCH
> -static int check_modinfo_livepatch(struct module *mod, struct load_info *info)
> -{
> -	if (get_modinfo(info, "livepatch")) {
> -		mod->klp = true;
> -		add_taint_module(mod, TAINT_LIVEPATCH, LOCKDEP_STILL_OK);
> -		pr_notice_once("%s: tainting kernel with TAINT_LIVEPATCH\n",
> -			       mod->name);
 > -	}
> -
> -	return 0;
> -}
> -#else /* !CONFIG_LIVEPATCH */
> +#ifndef CONFIG_LIVEPATCH
>  static int check_modinfo_livepatch(struct module *mod, struct load_info *info)
>  {
>  	if (get_modinfo(info, "livepatch")) {

But it exist here.

It would be better to have the two variants close each other. I mean
to have it somewhere like:

#ifdef CONFIG_LIVEPATCH

   variant A

#else

   variant B

#endif


A solution would be to do it a similar way like in
check_modinfo_retpoline(). Have a generic:

static int check_modinfo_livepatch(struct module *mod, struct load_info *info)
{
	if (!get_modinfo(info, "livepatch"))
		return 0;

	if (set_livepatch_module(mod)) {
		add_taint_module(mod, TAINT_LIVEPATCH, LOCKDEP_STILL_OK);
		pr_notice_once("%s: tainting kernel with TAINT_LIVEPATCH\n",
			       mod->name);
		return 0;
       }

       pr_err("%s: module is marked as livepatch module, but livepatch support is disabled",
	       mod->name);
       return -ENOEXEC;
}

, where set_livepatch_module(mod) might be defined inline
similar way like is_livepatch_module():

#ifdef CONFIG_LIVEPATCH
static inline bool set_livepatch_module(struct module *mod)
{
	mod->klp = true;
	return true;
}
#else /* !CONFIG_LIVEPATCH */
static inline bool set_livepatch_module(struct module *mod)
{
	return false;
}
#endif /* CONFIG_LIVEPATCH */


Well, it might be matter of taste. Others might prefer another solution.
Adding live-patching mailing list into Cc.

Anyway, if we do any code refactoring, we should do it in a separate
preparatory patch.

Best Regards,
Petr
