Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0751D46774
	for <lists+live-patching@lfdr.de>; Fri, 14 Jun 2019 20:21:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725868AbfFNSVf (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 14 Jun 2019 14:21:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51196 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725814AbfFNSVf (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Fri, 14 Jun 2019 14:21:35 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id B42D02F8BCC;
        Fri, 14 Jun 2019 18:21:29 +0000 (UTC)
Received: from treble (ovpn-121-232.rdu2.redhat.com [10.10.121.232])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id EEA534E6DE;
        Fri, 14 Jun 2019 18:21:22 +0000 (UTC)
Date:   Fri, 14 Jun 2019 13:21:21 -0500
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     Petr Mladek <pmladek@suse.com>
Cc:     Jessica Yu <jeyu@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        linux-kernel@vger.kernel.org, live-patching@vger.kernel.org,
        Johannes Erdfelt <johannes@erdfelt.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 2/3] module: Add text_mutex lockdep assertions for page
 attribute changes
Message-ID: <20190614182121.l4qvrfsjettoc7mi@treble>
References: <cover.1560474114.git.jpoimboe@redhat.com>
 <bb2b2c63c60e0b415ea1f78e6a0e3ed89ab82008.1560474114.git.jpoimboe@redhat.com>
 <20190614140457.urqjlosesvdtmiia@pathway.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190614140457.urqjlosesvdtmiia@pathway.suse.cz>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.38]); Fri, 14 Jun 2019 18:21:35 +0000 (UTC)
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Fri, Jun 14, 2019 at 04:04:57PM +0200, Petr Mladek wrote:
> On Thu 2019-06-13 20:07:23, Josh Poimboeuf wrote:
> > External callers of the module page attribute change functions now need
> > to have the text_mutex.  Enforce that with lockdep assertions.
> > 
> > diff --git a/kernel/module.c b/kernel/module.c
> > index 6e6712b3aaf5..e43a90ee2d23 100644
> > --- a/kernel/module.c
> > +++ b/kernel/module.c
> > @@ -3519,7 +3534,7 @@ static noinline int do_init_module(struct module *mod)
> >  	/* Switch to core kallsyms now init is done: kallsyms may be walking! */
> >  	rcu_assign_pointer(mod->kallsyms, &mod->core_kallsyms);
> >  #endif
> > -	module_enable_ro(mod, true);
> > +	__module_enable_ro(mod, true);
> 
> This one must be called under text_mutex. Otherwise it might get
> called when ftrace is in the middle of modifying the functions.
> 
> It should be enough to take text_mutex right around this call.
> It will prevent making the code ro when ftrace is doing
> the modification. It safe also the other way.
> set_all_modules_text_ro() does not call frob_ro_after_init().
> Therefore ftrace could not make the after_init section RO prematurely.
> 
> >  	mod_tree_remove_init(mod);
> >  	module_arch_freeing_init(mod);
> >  	mod->init_layout.base = NULL;
> > @@ -3626,8 +3641,8 @@ static int complete_formation(struct module *mod, struct load_info *info)
> >  	/* This relies on module_mutex for list integrity. */
> >  	module_bug_finalize(info->hdr, info->sechdrs, mod);
> >  
> > -	module_enable_ro(mod, false);
> > -	module_enable_nx(mod);
> > +	__module_enable_ro(mod, false);
> > +	__module_enable_nx(mod);
> 
> This one is OK. It is called when the module is in
> MODULE_STATE_UNFORMED. Therefore it is ignored by ftrace.
> The module state is manipulated and checked under module_mutex.

Yes, good catch.  Thanks.

-- 
Josh
