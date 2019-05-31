Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2C333151B
	for <lists+live-patching@lfdr.de>; Fri, 31 May 2019 21:13:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727083AbfEaTNE (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 31 May 2019 15:13:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51434 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726807AbfEaTNE (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Fri, 31 May 2019 15:13:04 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 8016430821BF;
        Fri, 31 May 2019 19:13:03 +0000 (UTC)
Received: from treble (ovpn-124-142.rdu2.redhat.com [10.10.124.142])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 85C615DAAF;
        Fri, 31 May 2019 19:12:58 +0000 (UTC)
Date:   Fri, 31 May 2019 14:12:56 -0500
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     Petr Mladek <pmladek@suse.com>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>, Jessica Yu <jeyu@kernel.org>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        linux-kernel@vger.kernel.org, live-patching@vger.kernel.org,
        Johannes Erdfelt <johannes@erdfelt.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH] livepatch: Fix ftrace module text permissions race
Message-ID: <20190531191256.z5fm4itxewagd5xc@treble>
References: <bb69d4ac34111bbd9cb16180a6fafe471a88d80b.1559156299.git.jpoimboe@redhat.com>
 <20190530135414.taftuprranwtowry@pathway.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190530135414.taftuprranwtowry@pathway.suse.cz>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.47]); Fri, 31 May 2019 19:13:03 +0000 (UTC)
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Thu, May 30, 2019 at 03:54:14PM +0200, Petr Mladek wrote:
> On Wed 2019-05-29 14:02:24, Josh Poimboeuf wrote:
> > The above panic occurs when loading two modules at the same time with
> > ftrace enabled, where at least one of the modules is a livepatch module:
> > 
> > CPU0					CPU1
> > klp_enable_patch()
> >   klp_init_object_loaded()
> >     module_disable_ro()
> >     					ftrace_module_enable()
> > 					  ftrace_arch_code_modify_post_process()
> > 				    	    set_all_modules_text_ro()
> >       klp_write_object_relocations()
> >         apply_relocate_add()
> > 	  *patches read-only code* - BOOM
> 
> This patch looks fine and fixes the race:
> 
> Reviewed-by: Petr Mladek <pmladek@suse.com>
> 
> 
> That said, the semantic of text_mutex is a bit unclear:
> 
>    + It serializes RO/RW setting but not NX

True.  module_enable_nx() is a static function which is only called
internally.  I should probably rename it to __module_enable_nx() so the
locking semantics match the others.

>    + Nothing prevents manipulation of the access rights
>      by external code before the module is ready-enough.
>      I mean before the sections are set RO by the module
>      loader itself.
> 
>      Most sections are ready in MODULE_STATE_COMMING state.
>      Only ro_after_init sections need to stay RW longer,
>      see my question below.
> 
> 
> > diff --git a/kernel/module.c b/kernel/module.c
> > index 6e6712b3aaf5..3c056b56aefa 100644
> > --- a/kernel/module.c
> > +++ b/kernel/module.c
> > @@ -3519,7 +3534,7 @@ static noinline int do_init_module(struct module *mod)
> >  	/* Switch to core kallsyms now init is done: kallsyms may be walking! */
> >  	rcu_assign_pointer(mod->kallsyms, &mod->core_kallsyms);
> >  #endif
> > -	module_enable_ro(mod, true);
> > +	__module_enable_ro(mod, true);
> 
> The "true" parameter causes that also ro_after_init section is
> set read only. What is the purpose of this section, please?
> 
> I ask because module_enable_ro(mod, true) can be called
> earlier from klp_init_object_loaded() from do_one_initcall().
> 
> For example, it could some MODULE_STATE_LIVE notifier
> when it requires write access to ro_after_init section.

Hm, I think you're right.  klp_init_object_loaded() should change the
module_enable_ro() argument to false when it's called from a patch
module's initcall.

Maybe we can instead remove __module_enable_ro()'s after_init argument
and just make it smarter?  It should only do ro_after_init frobbing if
the module state is MODULE_STATE_LIVE.

> Anyway, the above is a separate problem. This patch looks
> fine for the original problem.

Thanks for the review.  I'll post another version, with the above
changes and with the patches split up like Miroslav suggested.

-- 
Josh
