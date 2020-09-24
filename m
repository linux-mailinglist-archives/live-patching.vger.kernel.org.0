Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D1202771C6
	for <lists+live-patching@lfdr.de>; Thu, 24 Sep 2020 15:06:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727833AbgIXNGJ (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 24 Sep 2020 09:06:09 -0400
Received: from mx2.suse.de ([195.135.220.15]:33410 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727704AbgIXNGJ (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Thu, 24 Sep 2020 09:06:09 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id A1692AD5F;
        Thu, 24 Sep 2020 13:06:07 +0000 (UTC)
Date:   Thu, 24 Sep 2020 15:06:06 +0200 (CEST)
From:   Miroslav Benes <mbenes@suse.cz>
To:     Kristen Carlson Accardi <kristen@linux.intel.com>
cc:     keescook@chromium.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jikos@kernel.org>, Petr Mladek <pmladek@suse.com>,
        Joe Lawrence <joe.lawrence@redhat.com>, arjan@linux.intel.com,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        kernel-hardening@lists.openwall.com, rick.p.edgecombe@intel.com,
        live-patching@vger.kernel.org
Subject: Re: [PATCH v5 10/10] livepatch: only match unique symbols when using
 fgkaslr
In-Reply-To: <20200923173905.11219-11-kristen@linux.intel.com>
Message-ID: <alpine.LSU.2.21.2009241453400.6602@pobox.suse.cz>
References: <20200923173905.11219-1-kristen@linux.intel.com> <20200923173905.11219-11-kristen@linux.intel.com>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Hi,

On Wed, 23 Sep 2020, Kristen Carlson Accardi wrote:

> If any type of function granular randomization is enabled, the sympos
> algorithm will fail, as it will be impossible to resolve symbols when
> there are duplicates using the previous symbol position.
> 
> Override the value of sympos to always be zero if fgkaslr is enabled for
> either the core kernel or modules, forcing the algorithm
> to require that only unique symbols are allowed to be patched.
> 
> Signed-off-by: Kristen Carlson Accardi <kristen@linux.intel.com>
> ---
>  kernel/livepatch/core.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
> index f76fdb925532..da08e40f2da2 100644
> --- a/kernel/livepatch/core.c
> +++ b/kernel/livepatch/core.c
> @@ -170,6 +170,17 @@ static int klp_find_object_symbol(const char *objname, const char *name,
>  		kallsyms_on_each_symbol(klp_find_callback, &args);
>  	mutex_unlock(&module_mutex);
>  
> +	/*
> +	 * If any type of function granular randomization is enabled, it
> +	 * will be impossible to resolve symbols when there are duplicates
> +	 * using the previous symbol position (i.e. sympos != 0). Override
> +	 * the value of sympos to always be zero in this case. This will
> +	 * force the algorithm to require that only unique symbols are
> +	 * allowed to be patched.
> +	 */
> +	if (IS_ENABLED(CONFIG_FG_KASLR) || IS_ENABLED(CONFIG_MODULE_FG_KASLR))
> +		sympos = 0;

This should work, but I wonder if we should make it more explicit. With 
the change the user will get the error with "unresolvable ambiguity for 
symbol..." if they specify sympos and the symbol is not unique. It could 
confuse them.

So, how about it making it something like

if (IS_ENABLED(CONFIG_FG_KASLR) || IS_ENABLED(CONFIG_MODULE_FG_KASLR))
	if (sympos) {
		pr_err("fgkaslr is enabled, specifying sympos for symbol '%s' in object '%s' does not work.\n",
			name, objname);
		*addr = 0;
		return -EINVAL;
	}

? (there could be goto to the error out at the end of the function).

In that case, if sympos is not specified, the user will get the message 
which matches the reality. If the user specifies it, they will get the 
error in case of fgkaslr.

Thanks for dealing with it
Miroslav
