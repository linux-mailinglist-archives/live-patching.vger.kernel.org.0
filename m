Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD1EE46060
	for <lists+live-patching@lfdr.de>; Fri, 14 Jun 2019 16:16:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728913AbfFNOO4 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 14 Jun 2019 10:14:56 -0400
Received: from mx2.suse.de ([195.135.220.15]:34754 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728555AbfFNOO4 (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Fri, 14 Jun 2019 10:14:56 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 08FA2AEB3;
        Fri, 14 Jun 2019 14:14:54 +0000 (UTC)
Date:   Fri, 14 Jun 2019 16:14:53 +0200
From:   Petr Mladek <pmladek@suse.com>
To:     Josh Poimboeuf <jpoimboe@redhat.com>
Cc:     Jessica Yu <jeyu@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        linux-kernel@vger.kernel.org, live-patching@vger.kernel.org,
        Johannes Erdfelt <johannes@erdfelt.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 3/3] module: Improve module __ro_after_init handling
Message-ID: <20190614141453.fjtvk7uvux6vcmlp@pathway.suse.cz>
References: <cover.1560474114.git.jpoimboe@redhat.com>
 <1b72f40d863a1444f687b3e1b958bdc6925882ed.1560474114.git.jpoimboe@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1b72f40d863a1444f687b3e1b958bdc6925882ed.1560474114.git.jpoimboe@redhat.com>
User-Agent: NeoMutt/20170912 (1.9.0)
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Thu 2019-06-13 20:07:24, Josh Poimboeuf wrote:
> module_enable_ro() can be called in the following scenario:
> 
>   [load livepatch module]
>     initcall
>       klp_enable_patch()
>         klp_init_patch()
>           klp_init_object()
>             klp_init_object_loaded()
>               module_enable_ro(pmod, true)
> 
> In this case, module_enable_ro()'s 'after_init' argument is true, which
> prematurely changes the module's __ro_after_init area to read-only.
> 
> If, theoretically, a registrant of the MODULE_STATE_LIVE module notifier
> tried to write to the livepatch module's __ro_after_init section, an
> oops would occur.
> 
> Remove the 'after_init' argument and instead make __module_enable_ro()
> smart enough to only frob the __ro_after_init section after the module
> has gone live.
> 
> Reported-by: Petr Mladek <pmladek@suse.com>
> Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
> ---
>  arch/arm64/kernel/ftrace.c |  2 +-
>  include/linux/module.h     |  4 ++--
>  kernel/livepatch/core.c    |  4 ++--
>  kernel/module.c            | 14 +++++++-------
>  4 files changed, 12 insertions(+), 12 deletions(-)
> 
> diff --git a/arch/arm64/kernel/ftrace.c b/arch/arm64/kernel/ftrace.c
> index 65a51331088e..c17d98aafc93 100644
> --- a/arch/arm64/kernel/ftrace.c
> +++ b/arch/arm64/kernel/ftrace.c
> @@ -120,7 +120,7 @@ int ftrace_make_call(struct dyn_ftrace *rec, unsigned long addr)
>  			/* point the trampoline to our ftrace entry point */
>  			module_disable_ro(mod);
>  			*mod->arch.ftrace_trampoline = trampoline;
> -			module_enable_ro(mod, true);
> +			module_enable_ro(mod);
>  
>  			/* update trampoline before patching in the branch */
>  			smp_wmb();
> diff --git a/include/linux/module.h b/include/linux/module.h
> index 188998d3dca9..4d6922f3760e 100644
> --- a/include/linux/module.h
> +++ b/include/linux/module.h
> @@ -844,12 +844,12 @@ extern int module_sysfs_initialized;
>  #ifdef CONFIG_STRICT_MODULE_RWX
>  extern void set_all_modules_text_rw(void);
>  extern void set_all_modules_text_ro(void);
> -extern void module_enable_ro(const struct module *mod, bool after_init);
> +extern void module_enable_ro(const struct module *mod);
>  extern void module_disable_ro(const struct module *mod);
>  #else
>  static inline void set_all_modules_text_rw(void) { }
>  static inline void set_all_modules_text_ro(void) { }
> -static inline void module_enable_ro(const struct module *mod, bool after_init) { }
> +static inline void module_enable_ro(const struct module *mod) { }
>  static inline void module_disable_ro(const struct module *mod) { }
>  #endif
>  
> diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
> index c4ce08f43bd6..f9882ffa2f44 100644
> --- a/kernel/livepatch/core.c
> +++ b/kernel/livepatch/core.c
> @@ -724,13 +724,13 @@ static int klp_init_object_loaded(struct klp_patch *patch,
>  	module_disable_ro(patch->mod);
>  	ret = klp_write_object_relocations(patch->mod, obj);
>  	if (ret) {
> -		module_enable_ro(patch->mod, true);
> +		module_enable_ro(patch->mod);
>  		mutex_unlock(&text_mutex);
>  		return ret;
>  	}
>  
>  	arch_klp_init_object_loaded(patch, obj);
> -	module_enable_ro(patch->mod, true);
> +	module_enable_ro(patch->mod);
>  
>  	mutex_unlock(&text_mutex);
>  
> diff --git a/kernel/module.c b/kernel/module.c
> index e43a90ee2d23..fb3561e0c5b0 100644
> --- a/kernel/module.c
> +++ b/kernel/module.c
> @@ -1956,7 +1956,7 @@ void module_disable_ro(const struct module *mod)
>  	frob_rodata(&mod->init_layout, set_memory_rw);
>  }
>  
> -void __module_enable_ro(const struct module *mod, bool after_init)
> +static void __module_enable_ro(const struct module *mod)
>  {
>  	if (!rodata_enabled)
>  		return;
> @@ -1973,15 +1973,15 @@ void __module_enable_ro(const struct module *mod, bool after_init)
>  
>  	frob_rodata(&mod->init_layout, set_memory_ro);
>  
> -	if (after_init)
> +	if (mod->state == MODULE_STATE_LIVE)
>  		frob_ro_after_init(&mod->core_layout, set_memory_ro);

This works only now because __module_enable_ro() is called only from
three locations (klp_init_object_loaded(),  complete_formation(),
and do_init_module(). And they all are called in a well defined order
from load_module().

Only the final call in do_init_module() should touch the after_init
section.

IMHO, the most clean solutiuon would be to call frob_ro_after_init()
from extra __module_after_init_enable_ro() or so. This should be
called only from the single place.

Best Regards,
Petr
