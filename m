Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 352F45BE539
	for <lists+live-patching@lfdr.de>; Tue, 20 Sep 2022 14:08:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229963AbiITMIO (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 20 Sep 2022 08:08:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229490AbiITMIN (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 20 Sep 2022 08:08:13 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F9A566110;
        Tue, 20 Sep 2022 05:08:11 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 412321F37C;
        Tue, 20 Sep 2022 12:08:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1663675690; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Mw8XZsMOVdktnEvvNgooVCEZGsB574IvHs9xXgcOl2M=;
        b=q2+WgSOp6FLlcKgpuRbcQUx/O1TXmhAK8X49lVoe9h6nwx8DcZhXl1yS27QLdlsJ6ClJgn
        79PA/tbXFjAoc3UD18A+ebB4jtuj9yTQzjH7bTnH12uDyrPX2YLP7QsfnGDfOQOiXLjb38
        FUwyJIT4etm9FxN32uO6hluCRgdmBbs=
Received: from suse.cz (unknown [10.100.201.202])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 1A7532C141;
        Tue, 20 Sep 2022 12:08:09 +0000 (UTC)
Date:   Tue, 20 Sep 2022 14:08:07 +0200
From:   Petr Mladek <pmladek@suse.com>
To:     Zhen Lei <thunder.leizhen@huawei.com>
Cc:     Josh Poimboeuf <jpoimboe@kernel.org>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        Masahiro Yamada <masahiroy@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Jiri Olsa <jolsa@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Luis Chamberlain <mcgrof@kernel.org>,
        linux-modules@vger.kernel.org
Subject: Re: [PATCH v2 7/8] livepatch: Improve the search performance of
 module_kallsyms_on_each_symbol()
Message-ID: <YymtJwYB7Q9mTPgS@alley>
References: <20220909130016.727-1-thunder.leizhen@huawei.com>
 <20220909130016.727-8-thunder.leizhen@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220909130016.727-8-thunder.leizhen@huawei.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Fri 2022-09-09 21:00:15, Zhen Lei wrote:
> Currently we traverse all symbols of all modules to find the specified
> function for the specified module. But in reality, we just need to find
> the given module and then traverse all the symbols in it.

I agree that it might be noticeable speedup.

> In order to achieve this purpose, split the call to hook 'fn' into two
> phases:
> 1. Finds the given module. Pass pointer 'mod'. Hook 'fn' directly returns
>    the comparison result of the module name without comparing the function
>    name.
> 2. Finds the given function in that module. Pass pointer 'mod = NULL'.
>    Hook 'fn' skip the comparison of module name and directly compare
>    function names.
> 
> Phase1: mod1-->mod2..(subsequent modules do not need to be compared)
>                 |
> Phase2:          -->f1-->f2-->f3
> 
> Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
> ---
>  kernel/livepatch/core.c  |  7 ++-----
>  kernel/module/kallsyms.c | 13 ++++++++++++-
>  2 files changed, 14 insertions(+), 6 deletions(-)
> 
> diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
> index 31b57ccf908017e..98e23137e4133bc 100644
> --- a/kernel/livepatch/core.c
> +++ b/kernel/livepatch/core.c
> @@ -130,15 +130,12 @@ static int klp_find_callback(void *data, const char *name,
>  {
>  	struct klp_find_arg *args = data;
>  
> -	if ((mod && !args->objname) || (!mod && args->objname))
> -		return 0;
> +	if (mod)
> +		return strcmp(args->objname, mod->name);
>  
>  	if (strcmp(args->name, name))
>  		return 0;
>  
> -	if (args->objname && strcmp(args->objname, mod->name))
> -		return 0;
> -
>  	args->addr = addr;
>  	args->count++;
>  
> diff --git a/kernel/module/kallsyms.c b/kernel/module/kallsyms.c
> index f5c5c9175333df7..b033613e6c7e3bb 100644
> --- a/kernel/module/kallsyms.c
> +++ b/kernel/module/kallsyms.c
> @@ -510,6 +510,11 @@ int module_kallsyms_on_each_symbol(int (*fn)(void *, const char *,
>  		if (mod->state == MODULE_STATE_UNFORMED)
>  			continue;
>  
> +		/* check mod->name first */
> +		ret = fn(data, NULL, mod, 0);
> +		if (ret)
> +			continue;

Hmm, it somehow gets too complicated. The same fn() callback has to
behave correctly in 3 different situations. I would suggest to
simplify everything:


1. Pass the requested modname as a parameter to module_kallsyms_on_each_symbol()

/*
 * Iterate over all symbols in the given @modname. For symbols from
 * vmlinux use kallsyms_on_each_symbol() instead.
 */
int module_kallsyms_on_each_symbol(const char *modname,
				   int (*fn)(void *, const char *,
					     struct module *, unsigned long),
				   void *data)

and do here:

		if (strcmp(modname, mod->name))
			continue;


2. We do not even need to pass .objname in struct klp_find_arg
   could simplify the callback:

static int klp_find_callback(void *data, const char *name,
			     struct module *mod, unsigned long addr)
{
	struct klp_find_arg *args = data;

	if (strcmp(args->name, name))
		return 0;

	args->addr = addr;
	args->count++;

	/*
	 * Finish the search when the symbol is found for the desired position
	 * or the position is not defined for a non-unique symbol.
	 */
	if ((args->pos && (args->count == args->pos)) ||
	    (!args->pos && (args->count > 1)))
		return 1;

	return 0;
}

3. As a result the *mod parameter won't be used by any existing
   fn() callback and could be removed. This should be done as
   a separate patch. It touches also ftrace_lookup_symbols().

Best Regards,
Petr
