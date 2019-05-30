Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 392952FCAE
	for <lists+live-patching@lfdr.de>; Thu, 30 May 2019 15:54:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726653AbfE3NyR (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 30 May 2019 09:54:17 -0400
Received: from mx2.suse.de ([195.135.220.15]:40772 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725870AbfE3NyR (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Thu, 30 May 2019 09:54:17 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id F04F9ADD9;
        Thu, 30 May 2019 13:54:15 +0000 (UTC)
Date:   Thu, 30 May 2019 15:54:14 +0200
From:   Petr Mladek <pmladek@suse.com>
To:     Josh Poimboeuf <jpoimboe@redhat.com>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>, Jessica Yu <jeyu@kernel.org>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        linux-kernel@vger.kernel.org, live-patching@vger.kernel.org,
        Johannes Erdfelt <johannes@erdfelt.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH] livepatch: Fix ftrace module text permissions race
Message-ID: <20190530135414.taftuprranwtowry@pathway.suse.cz>
References: <bb69d4ac34111bbd9cb16180a6fafe471a88d80b.1559156299.git.jpoimboe@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bb69d4ac34111bbd9cb16180a6fafe471a88d80b.1559156299.git.jpoimboe@redhat.com>
User-Agent: NeoMutt/20170912 (1.9.0)
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed 2019-05-29 14:02:24, Josh Poimboeuf wrote:
> The above panic occurs when loading two modules at the same time with
> ftrace enabled, where at least one of the modules is a livepatch module:
> 
> CPU0					CPU1
> klp_enable_patch()
>   klp_init_object_loaded()
>     module_disable_ro()
>     					ftrace_module_enable()
> 					  ftrace_arch_code_modify_post_process()
> 				    	    set_all_modules_text_ro()
>       klp_write_object_relocations()
>         apply_relocate_add()
> 	  *patches read-only code* - BOOM

This patch looks fine and fixes the race:

Reviewed-by: Petr Mladek <pmladek@suse.com>


That said, the semantic of text_mutex is a bit unclear:

   + It serializes RO/RW setting but not NX

   + Nothing prevents manipulation of the access rights
     by external code before the module is ready-enough.
     I mean before the sections are set RO by the module
     loader itself.

     Most sections are ready in MODULE_STATE_COMMING state.
     Only ro_after_init sections need to stay RW longer,
     see my question below.


> diff --git a/kernel/module.c b/kernel/module.c
> index 6e6712b3aaf5..3c056b56aefa 100644
> --- a/kernel/module.c
> +++ b/kernel/module.c
> @@ -3519,7 +3534,7 @@ static noinline int do_init_module(struct module *mod)
>  	/* Switch to core kallsyms now init is done: kallsyms may be walking! */
>  	rcu_assign_pointer(mod->kallsyms, &mod->core_kallsyms);
>  #endif
> -	module_enable_ro(mod, true);
> +	__module_enable_ro(mod, true);

The "true" parameter causes that also ro_after_init section is
set read only. What is the purpose of this section, please?

I ask because module_enable_ro(mod, true) can be called
earlier from klp_init_object_loaded() from do_one_initcall().

For example, it could some MODULE_STATE_LIVE notifier
when it requires write access to ro_after_init section.

Anyway, the above is a separate problem. This patch looks
fine for the original problem.

Best Regards,
Petr
