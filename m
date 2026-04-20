Return-Path: <live-patching+bounces-2397-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id EE1MFbGP5WlNlgEAu9opvQ
	(envelope-from <live-patching+bounces-2397-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Mon, 20 Apr 2026 04:30:09 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id ECBEF426487
	for <lists+live-patching@lfdr.de>; Mon, 20 Apr 2026 04:30:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id CA55D3014570
	for <lists+live-patching@lfdr.de>; Mon, 20 Apr 2026 02:27:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F7953783AE;
	Mon, 20 Apr 2026 02:27:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="q/f2q8Yr"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6235F375F67;
	Mon, 20 Apr 2026 02:27:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776652038; cv=none; b=fEQM5S4BMg80tD6ejfOMMfLx5X/zVxz0N88ICrEhc72rFGjkVhUwmcSZiNP3g4Z+R51pZLuSwRMVoR/dfiKSBJupUb8De0c78zkZdxxO5z622dd3WerzgoyIBObKLyXE/yT1Fl7WVKWy2lTL0K2nn6rX9Jv7nAxJPlbGLhtJpEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776652038; c=relaxed/simple;
	bh=ITFfxWVYZShfg8ObCYl+/A7sDctvchvGVKnsu2Q0ZLU=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=Gv2ejwE8Op1pVdr6ONsXyI0Z9V+AmHg6DPXJnZM8gJuP5vYmk3AADkiOgnmpfybVZ/adtzwLlI7gd1VBkxou9u39j6C2drD5/+4iH3P6uGY1k5XNpXR494DVhySCpfh55PwLzdYOxyVEfYPQxp0FQoJ6LQhF9SbpklQpJu1jDGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=q/f2q8Yr; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39F54C2BCAF;
	Mon, 20 Apr 2026 02:27:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776652038;
	bh=ITFfxWVYZShfg8ObCYl+/A7sDctvchvGVKnsu2Q0ZLU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=q/f2q8YrNja2t4MOJ3XZm+daEZl1FcXY4nfOVvtrtjvqt5MbZxWUYOT3wirQo6FaB
	 lOqgywkLPOjS1VIVUdoCXgyBgeqdQRzNwaylQtig4w+yS3qEz3gmO+SVZmZJKlQIS1
	 5YnVfgyEXKpTOb6PrQd5kn+uZtfBKDFQ/8OCcifN8EDAPaZwjDRm8Zr0mh3XQALHBh
	 Up6SdMQEWfpLr4yC73WCFbktXDXdQ7dXOqJfGS3V/MWdgRmzjD+Y1d8LwFkLfl9Ev0
	 jN9uHYhQzEihNOM9Uulk+1xe1nQar6NN7XIMU3fvu8QzHpDFat9SPtxyteXUC9ijgd
	 FqU1Wkd4FKflw==
Date: Mon, 20 Apr 2026 11:27:07 +0900
From: Masami Hiramatsu (Google) <mhiramat@kernel.org>
To: Petr Mladek <pmladek@suse.com>
Cc: Petr Pavlu <petr.pavlu@suse.com>, Song Chen <chensong_2000@189.cn>,
 rafael@kernel.org, lenb@kernel.org, mturquette@baylibre.com,
 sboyd@kernel.org, viresh.kumar@linaro.org, agk@redhat.com,
 snitzer@kernel.org, mpatocka@redhat.com, bmarzins@redhat.com,
 song@kernel.org, yukuai@fnnas.com, linan122@huawei.com,
 jason.wessel@windriver.com, danielt@kernel.org, dianders@chromium.org,
 horms@kernel.org, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, paulmck@kernel.org,
 frederic@kernel.org, mcgrof@kernel.org, da.gomez@kernel.org,
 samitolvanen@google.com, atomlin@atomlin.com, jpoimboe@kernel.org,
 jikos@kernel.org, mbenes@suse.cz, joe.lawrence@redhat.com,
 rostedt@goodmis.org, mhiramat@kernel.org, mark.rutland@arm.com,
 mathieu.desnoyers@efficios.com, linux-modules@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
 linux-acpi@vger.kernel.org, linux-clk@vger.kernel.org,
 linux-pm@vger.kernel.org, live-patching@vger.kernel.org,
 dm-devel@lists.linux.dev, linux-raid@vger.kernel.org,
 kgdb-bugreport@lists.sourceforge.net, netdev@vger.kernel.org
Subject: Re: [RFC PATCH 2/2] kernel/module: Decouple klp and ftrace from
 load_module
Message-Id: <20260420112707.aa3627ca9f975eeaf7d8ea0e@kernel.org>
In-Reply-To: <aeD2_FrFL6E3dbAC@pathway.suse.cz>
References: <20260413080701.180976-1-chensong_2000@189.cn>
	<1191caf5-6a61-4622-a15e-854d3701f4fc@suse.com>
	<a35f5f94-7d5a-4347-974b-b270c89ef241@189.cn>
	<1db425bf-58a9-4768-8c38-3ae25d7662a5@suse.com>
	<aeD2_FrFL6E3dbAC@pathway.suse.cz>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-2397-lists,live-patching=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[suse.com,189.cn,kernel.org,baylibre.com,linaro.org,redhat.com,fnnas.com,huawei.com,windriver.com,chromium.org,davemloft.net,google.com,atomlin.com,suse.cz,goodmis.org,arm.com,efficios.com,vger.kernel.org,lists.linux.dev,lists.sourceforge.net];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[48];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[mhiramat@kernel.org,live-patching@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel.org:+];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,189.cn:email,suse.com:email]
X-Rspamd-Queue-Id: ECBEF426487
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Thu, 16 Apr 2026 16:49:32 +0200
Petr Mladek <pmladek@suse.com> wrote:

> On Thu 2026-04-16 13:18:30, Petr Pavlu wrote:
> > On 4/15/26 8:43 AM, Song Chen wrote:
> > > On 4/14/26 22:33, Petr Pavlu wrote:
> > >> On 4/13/26 10:07 AM, chensong_2000@189.cn wrote:
> > >>> diff --git a/include/linux/module.h b/include/linux/module.h
> > >>> index 14f391b186c6..0bdd56f9defd 100644
> > >>> --- a/include/linux/module.h
> > >>> +++ b/include/linux/module.h
> > >>> @@ -308,6 +308,14 @@ enum module_state {
> > >>>       MODULE_STATE_COMING,    /* Full formed, running module_init. */
> > >>>       MODULE_STATE_GOING,    /* Going away. */
> > >>>       MODULE_STATE_UNFORMED,    /* Still setting it up. */
> > >>> +    MODULE_STATE_FORMED,
> > >>
> > >> I don't see a reason to add a new module state. Why is it necessary and
> > >> how does it fit with the existing states?
> > >>
> > > because once notifier fails in state MODULE_STATE_UNFORMED (now only ftrace has someting to do in this state), notifier chain will roll back by calling blocking_notifier_call_chain_robust, i'm afraid MODULE_STATE_GOING is going to jeopardise the notifers which don't handle it appropriately, like:
> > > 
> > > case MODULE_STATE_COMING:
> > >      kmalloc();
> > > case MODULE_STATE_GOING:
> > >      kfree();
> > 
> > My understanding is that the current module "state machine" operates as
> > follows. Transitions marked with an asterisk (*) are announced via the
> > module notifier.
> > 
> > ---> UNFORMED --*> COMING --*> LIVE --*> GOING -.
> >         ^            |                     ^    |
> >         |            '---------------------*    |
> >         '---------------------------------------'
> > 
> > The new code aims to replace the current ftrace_module_init() call in
> > load_module(). To achieve this, it adds a notification for the UNFORMED
> > state (only when loading a module) and introduces a new FORMED state for
> > rollback. FORMED is purely a fake state because it never appears in
> > module::state. The new structure is as follows:
> > 
> >         ,--*> (FORMED)
> >         |
> > --*> UNFORMED --*> COMING --*> LIVE --*> GOING -.
> >         ^            |                     ^    |
> >         |            '---------------------*    |
> >         '---------------------------------------'
> > 
> > I'm afraid this is quite complex and inconsistent. Unless it can be kept
> > simple, we would be just replacing one special handling with a different
> > complexity, which is not worth it.
> 
> > >>
> > >>> +    if (err)
> > >>> +        goto ddebug_cleanup;
> > >>>         /* Finally it's fully formed, ready to start executing. */
> > >>>       err = complete_formation(mod, info);
> > >>> -    if (err)
> > >>> +    if (err) {
> > >>> +        blocking_notifier_call_chain_reverse(&module_notify_list,
> > >>> +                MODULE_STATE_FORMED, mod);
> > >>>           goto ddebug_cleanup;
> > >>> +    }
> > >>>   -    err = prepare_coming_module(mod);
> > >>> +    err = prepare_module_state_transaction(mod,
> > >>> +                MODULE_STATE_COMING, MODULE_STATE_GOING);
> > >>>       if (err)
> > >>>           goto bug_cleanup;
> > >>>   @@ -3522,7 +3519,6 @@ static int load_module(struct load_info *info, const char __user *uargs,
> > >>>       destroy_params(mod->kp, mod->num_kp);
> > >>>       blocking_notifier_call_chain(&module_notify_list,
> > >>>                        MODULE_STATE_GOING, mod);
> > >>
> > >> My understanding is that all notifier chains for MODULE_STATE_GOING
> > >> should be reversed.
> > > yes, all, from lowest priority notifier to highest.
> > > I will resend patch 1 which was failed due to my proxy setting.
> > 
> > What I meant here is that the call:
> > 
> > blocking_notifier_call_chain(&module_notify_list, MODULE_STATE_GOING, mod);
> > 
> > should be replaced with:
> > 
> > blocking_notifier_call_chain_reverse(&module_notify_list, MODULE_STATE_GOING, mod);
> > 
> > > 
> > >>
> > >>> -    klp_module_going(mod);
> > >>>    bug_cleanup:
> > >>>       mod->state = MODULE_STATE_GOING;
> > >>>       /* module_bug_cleanup needs module_mutex protection */
> > >>
> > >> The patch removes the klp_module_going() cleanup call in load_module().
> > >> Similarly, the ftrace_release_mod() call under the ddebug_cleanup label
> > >> should be removed and appropriately replaced with a cleanup via
> > >> a notifier.
> > >>
> > >     err = prepare_module_state_transaction(mod,
> > >                 MODULE_STATE_UNFORMED, MODULE_STATE_FORMED);
> > >     if (err)
> > >         goto ddebug_cleanup;
> > > 
> > > ftrace will be cleanup in blocking_notifier_call_chain_robust rolling back.
> > > 
> > >     err = prepare_module_state_transaction(mod,
> > >                 MODULE_STATE_COMING, MODULE_STATE_GOING);
> > > 
> > > each notifier including ftrace and klp will be cleanup in blocking_notifier_call_chain_robust rolling back.
> > > 
> > > if all notifiers are successful in MODULE_STATE_COMING, they all will be clean up in
> > >  coming_cleanup:
> > >     mod->state = MODULE_STATE_GOING;
> > >     destroy_params(mod->kp, mod->num_kp);
> > >     blocking_notifier_call_chain(&module_notify_list,
> > >                      MODULE_STATE_GOING, mod);
> > > 
> > > if  something wrong underneath.
> > 
> > My point is that the patch leaves a call to ftrace_release_mod() in
> > load_module(), which I expected to be handled via a notifier.
> 
> I think that I have got it. The ftrace code needs two notifiers when
> the module is being loaded and two when it is going.
> 
> This is why Sond added the new state. But I think that we would
> need two new states to call:
> 
>     + ftrace_module_init() in MODULE_STATE_UNFORMED
>     + ftrace_module_enable() in MODULE_STATE_FORMED
> 
> and
> 
>     + ftrace_free_mem() in MODULE_STATE_PRE_GOING
>     + ftrace_free_mem() in MODULE_STATE_GOING
> 
> 
> By using the ascii art:
> 
>  -*> UNFORMED -*> FORMED -> COMING -*> LIVE -*> PRE_GOING -*> GOING -.
>               |          |         |                ^           ^    ^
>               |          |         '----------------'           |    |
>               |          '--------------------------------------'    |
>               '------------------------------------------------------'
> 
> 
> But I think that this is not worth it.

Agree.

If this needs to be ordered so strictly, why we will use a "single"
module notifier chain for this complex situation?

I think the notifier call chain is just for notice a single signal,
instead of sending several different signals, especially if there is
any dependency among the callbacks.

If notification callbacks need to be ordered, they are currently
sorted by representing priority numerically, but this is quite
fragile for updating. It has to look up other registered priorities
and adjust the order among dependencies each time. For this reason,
this mechanism is not suitable for global ordering. (It's like line
numbers in BASIC.)
It is probably only useful for representing dependencies between
two components maintained by the same maintainer.

I'm against a general-purpose system that makes everything modular.
It unnecessarily complicates things. If there are processes that
require strict ordering, especially processes that must be performed
before each stage as part of the framework, they should be called
directly from the framework, not via notification callbacks.

This makes it simpler and more robust to maintain.

Only the framework's end users should utilize notification callbacks.

Thank you,


> 
> Best Regards,
> Petr
> 


-- 
Masami Hiramatsu (Google) <mhiramat@kernel.org>

