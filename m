Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA54E14B410
	for <lists+live-patching@lfdr.de>; Tue, 28 Jan 2020 13:16:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726002AbgA1MQ4 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 28 Jan 2020 07:16:56 -0500
Received: from mx2.suse.de ([195.135.220.15]:57378 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725959AbgA1MQ4 (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Tue, 28 Jan 2020 07:16:56 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 95B15AEFF;
        Tue, 28 Jan 2020 12:16:53 +0000 (UTC)
Date:   Tue, 28 Jan 2020 13:16:53 +0100
From:   Petr Mladek <pmladek@suse.com>
To:     Julien Thierry <jthierry@redhat.com>
Cc:     Jiri Kosina <jikos@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Miroslav Benes <mbenes@suse.cz>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Nicolai Stange <nstange@suse.de>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [POC 02/23] livepatch: Split livepatch modules per livepatched
 object
Message-ID: <20200128121653.72mhdqnfwtw7kifr@pathway.suse.cz>
References: <20200117150323.21801-1-pmladek@suse.com>
 <20200117150323.21801-3-pmladek@suse.com>
 <af90531e-219c-3515-1dc8-d86191902ea4@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <af90531e-219c-3515-1dc8-d86191902ea4@redhat.com>
User-Agent: NeoMutt/20170912 (1.9.0)
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue 2020-01-21 11:11:45, Julien Thierry wrote:
> Hi Petr,
> 
> On 1/17/20 3:03 PM, Petr Mladek wrote:
> > One livepatch module allows to fix vmlinux and any number of modules
> > while providing some guarantees defined by the consistency model.
> > 
> > The solution is to split the livepatch module per livepatched
> > object (vmlinux or module). Then both livepatch module and
> > the livepatched modules could get loaded and removed at the
> > same time.
> > 
> > The livepatches for modules are put into separate source files
> > that define only struct klp_object() and call the new klp_add_object()
> > in the init() callback. The name of the module follows the pattern:
> > 
> >    <patch_name>__<object_name>
> > 
> 
> Is that a requirement? Or is it just the convention followed for the current
> tests?

This naming pattern is enforced by the code. The reason is to
distinguish the purpose of each livepatch module.

   + Livepatch module for "vmlinux" and the related livepatch modules
     for other objects.

   + Different livepatches (versions) that might be installed at the
     same time. This happens even with cumulative livepatches.


It is important for the functionality:

   + Consistency checks that all and right livepatch modules are
     loaded.

   + Automatic loading of livepatch modules for modules when the patched
     module is being loaded.

But it should be "clear" even for humans because the livepatch modules are
listed by lsmod, ...

Of course, we could talk about other naming scheme, another approach.


> > @@ -844,21 +822,7 @@ static int klp_init_patch_early(struct klp_patch *patch)
> >   	INIT_WORK(&patch->free_work, klp_free_patch_work_fn);
> >   	init_completion(&patch->finish);
> > -	klp_for_each_object_static(patch, obj) {
> 
> I think we can get rid of klp_for_each_object_static(), no? Now the
> klp_patch is only associated to a single klp_object, so everything will be
> dynamic. Is this correct?

Yes, the macro klp_for_each_object_static() is not longer needed.

Just to be sure. It would be better to say that all klp_object
structures will be in the linked lists only.

Most structures are still defined statically. The name "dynamic" is
used for the dynamically allocated structures. They are used for
"nop" functions that might be needed when doing atomic replace
of cumulative patches and functions that are not longer patched.
See obj->dynamic and func->nop.


> > @@ -991,12 +958,12 @@ int klp_enable_patch(struct klp_patch *patch)
> >   {
> >   	int ret;
> > -	if (!patch || !patch->mod)
> > +	if (!patch || !patch->obj || !patch->obj->mod)
> >   		return -EINVAL;
> > -	if (!is_livepatch_module(patch->mod)) {
> > +	if (!is_livepatch_module(patch->obj->mod)) {
> >   		pr_err("module %s is not marked as a livepatch module\n",
> > -		       patch->mod->name);
> > +		       patch->obj->patch_name);
> 
> Shouldn't that be "patch->obj->mod->name" ?

They are actually the same. Note that it is redundant only in
struct klp_object that is in the livepatch module for vmlinux.

Hmm, it might be possible to get rid of it after I added the array
patch->obj_names. But I would prefer to keep it as a consistency
check.

One big drawback of the split modules approach is that there are
suddenly many more livepatch modules. The kernel code has to make
sure always the right ones are loaded. It is great to have some
cross-checks.


> >   		return -EINVAL;
> >   	}

> > diff --git a/kernel/livepatch/transition.c b/kernel/livepatch/transition.c
> > index f6310f848f34..78e3280560cd 100644
> > --- a/kernel/livepatch/transition.c
> > +++ b/kernel/livepatch/transition.c
> > @@ -147,7 +145,7 @@ void klp_cancel_transition(void)
> >   		return;
> >   	pr_debug("'%s': canceling patching transition, going to unpatch\n",
> > -		 klp_transition_patch->mod->name);
> > +		 klp_transition_patch->obj->patch_name);
> >   	klp_target_state = KLP_UNPATCHED;
> >   	klp_complete_transition();
> > @@ -468,7 +466,7 @@ void klp_start_transition(void)
> >   	WARN_ON_ONCE(klp_target_state == KLP_UNDEFINED);
> >   	pr_notice("'%s': starting %s transition\n",
> > -		  klp_transition_patch->mod->name,
> > +		  klp_transition_patch->obj->patch_name,
> 
> Isn't the transition per livepatched module rather than per-patch now?
> If so, would it make more sense to display also the name of the module being
> patched/unpatched?

The transition still happens for the entire livepatch defined by
struct klp_patch. All needed livepatch modules for the other objects
are loaded before the transition starts, see the patch 17/24
("livepatch: Load livepatches for modules when loading the main
livepatch").

> >   		  klp_target_state == KLP_PATCHED ? "patching" : "unpatching");
> >   	/*

Best Regards,
Petr

PS: Julien,

first, thanks a lot for looking at the patchset.

I am going to answer questions and comments that are related to
the overall design. The most important question is if the split
livepatch modules are the way to go. I hope that this patchset
shows possible wins and catches so that we could decide if it
is worth the effort.

Anyway, feel free to comment even details when you notice
a mistake. There might be some catches that I missed, ...

Best Regards,
Petr
