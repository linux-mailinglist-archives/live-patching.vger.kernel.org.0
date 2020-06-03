Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 359531ED49F
	for <lists+live-patching@lfdr.de>; Wed,  3 Jun 2020 19:00:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726090AbgFCRAN (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 3 Jun 2020 13:00:13 -0400
Received: from mx2.suse.de ([195.135.220.15]:39860 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725961AbgFCRAM (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Wed, 3 Jun 2020 13:00:12 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 00A6AABCE;
        Wed,  3 Jun 2020 17:00:13 +0000 (UTC)
Date:   Wed, 3 Jun 2020 19:00:10 +0200 (CEST)
From:   Miroslav Benes <mbenes@suse.cz>
To:     Cheng Jian <cj.chengjian@huawei.com>
cc:     linux-kernel@vger.kernel.org, live-patching@vger.kernel.org,
        chenwandun@huawei.com, xiexiuqi@huawei.com,
        bobo.shaobowang@huawei.com, huawei.libin@huawei.com,
        jeyu@kernel.org, jikos@kernel.org
Subject: Re: [PATCH] module: make module symbols visible after init
In-Reply-To: <20200603141200.17745-1-cj.chengjian@huawei.com>
Message-ID: <alpine.LSU.2.21.2006031848020.26737@pobox.suse.cz>
References: <20200603141200.17745-1-cj.chengjian@huawei.com>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Hi,

I'm confused...

On Wed, 3 Jun 2020, Cheng Jian wrote:

> When lookup the symbols of module by module_kallsyms_lookup_name(),
> the symbols address is visible only if the module's status isn't
> MODULE_STATE_UNFORMED, This is problematic.
> 
> When complete_formation is done, the state of the module is modified
> to MODULE_STATE_COMING, and the symbol of module is visible to the
> outside.
> 
> At this time, the init function of the module has not been called,
> so if the address of the function symbol has been found and called,
> it may cause some exceptions.
> 
> For livepatch module, the relocation information of the livepatch
> module is completed in init by klp_write_object_relocations(), and
> the symbol name of the old and new functions are the same. Therefore,
> when we lookup the symbol, we may get the function address of the
> livepatch module. a crash can occurs when we call this function.
> 
> 	CPU 0				CPU 1
> 	==================================================
> 	load_module
> 	add_unformed_module # MODULE_STATE_UNFORMED;
> 	post_relocation
> 	complete_formation  # MODULE_STATE_COMING;
> 					------------------
> 					module_kallsymc_lookup_name("A")
> 					call A()	# CRASH
> 					------------------
> 	do_init_module
> 	klp_write_object_relocations
> 	mod->state = MODULE_STATE_LIVE;

We don't call module_kallsymc_lookup_name() anywhere in livepatch if I am 
not missing something. So is this your code? Then I could see the problem. 
You get the address of a function from a livepatch module and call it, 
which is not correct.

I see two options...

1. don't use the same name for the new function. Use some kind of prefix. 
It is more bulletproof anyway.

2. module_kallsyms_lookup_name() accepts a module name as a prefix of a 
symbol. So you can use module_kallsyms_lookup_name("module:A") and it 
should return A from that particular module only (if it exists).
 
> In commit 0bd476e6c671 ("kallsyms: unexport kallsyms_lookup_name() and
> kallsyms_on_each_symbol()") restricts the invocation for kernel unexported
> symbols, but it is still incorrect to make the symbols of non-LIVE modules
> visible to the outside.

Why? It could easily break something somewhere. I didn't check properly, 
but module states are not safe to play with, so I'd be conservative here.

> Signed-off-by: Cheng Jian <cj.chengjian@huawei.com>
> ---
>  kernel/module.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel/module.c b/kernel/module.c
> index 64a2b4daaaa5..96c9cb64de57 100644
> --- a/kernel/module.c
> +++ b/kernel/module.c
> @@ -4220,7 +4220,7 @@ unsigned long module_kallsyms_lookup_name(const char *name)
>  			ret = find_kallsyms_symbol_value(mod, colon+1);
>  	} else {
>  		list_for_each_entry_rcu(mod, &modules, list) {
> -			if (mod->state == MODULE_STATE_UNFORMED)
> +			if (mod->state != MODULE_STATE_LIVE)
>  				continue;
>  			if ((ret = find_kallsyms_symbol_value(mod, name)) != 0)
>  				break;

Thanks,
Miroslav
