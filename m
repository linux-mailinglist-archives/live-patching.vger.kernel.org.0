Return-Path: <live-patching+bounces-2364-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id qGGaECfg4Gk+nAAAu9opvQ
	(envelope-from <live-patching+bounces-2364-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Thu, 16 Apr 2026 15:12:07 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C31D40E8CD
	for <lists+live-patching@lfdr.de>; Thu, 16 Apr 2026 15:12:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 467BB310EE47
	for <lists+live-patching@lfdr.de>; Thu, 16 Apr 2026 13:09:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D0E3638944C;
	Thu, 16 Apr 2026 13:09:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="gWVkabXn"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 893BF3BA225
	for <live-patching@vger.kernel.org>; Thu, 16 Apr 2026 13:09:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776344978; cv=none; b=GziyHOKZG4mcTM3HcAZRfzHeH1JQEUd2K3Mu8LzZX5ogT/gZ/y5E+Jp0M/lCsez9bTKtmF4wKuhcWYfgLs2tgblnzk8t5tneXZzPK2VuBpYJSEmunFTy7OYM0OfbhYxnuM2Nb1DZ1TWlK5Tkv/PrCxfYpvyjFz36aLZIQ5Vm5nM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776344978; c=relaxed/simple;
	bh=eVmjde+k93xycVxx5TzpLj5SCL1rx1KrvC1l3ql6brE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BTaIiZkusQHeGXHnaXIE33SKEVP3eYPSc0CKK1mTENnLecbixPXn2kCeF2nfG6la8GuAiaZyBhybkNTo9GZeEPa0N7hQHjqZv5dCFGVy8JwXVPUHNamOUIDS6HvFyqmescwaQNVngvFEoi+wQIlt+TazmpvgSpxACqoe2XQd50o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=gWVkabXn; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-488ba840146so79001755e9.1
        for <live-patching@vger.kernel.org>; Thu, 16 Apr 2026 06:09:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1776344975; x=1776949775; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=m3piWCtfpN3U6w8bKY3YeNvzMYnQTdnw3h4KjP2i/sk=;
        b=gWVkabXnsOnvoM3GUthhg8haRYPkHddoedkvckM6BiaWRjb06CqxgY1ZFpHCK6p2WQ
         FeqGPchIhpZXb0+i22atTHjtQiVxh/L3GaX0sweeDZNZh0F0BqZNyig0cvTJIlkZOWrU
         iafVJOHGilIbYuSWy9/9iW9WyzDmm/DAkiMmIoAp3Kr55fvy4h49B0CstsHsF0gAOsMP
         k2vDVLT3F5J56OpiQi1aRT8PZh7o1ZnusmrX9FtcSuPjXgt4jpR7uV6jXUFW+6bTdZK+
         bfmF+CPLNC4k007+B1ngA7VPideyNIXpDY5g7gjNDJuM/JGoIeOAqBG39/Z81HGf0hxO
         cXOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776344975; x=1776949775;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=m3piWCtfpN3U6w8bKY3YeNvzMYnQTdnw3h4KjP2i/sk=;
        b=b/9EgncpiLekxvsMmEl2ZIxG7H+W2B/4a9mAfjSHlDaoFm2/ukCg5TBx7ir84UyvqA
         139KprXN7895S2KoRhsDJz20fkm1Iq9NcV3ZUPUd6hBmhZBhe/kkcDd2rYOd1vH2t/Ge
         gvhCITL4jv15JO4cUSGOK1jYlNiAqFFvmeVSyefgg59gApMjStEsnZdzZrZrUvZHmD5l
         8cYMmr+ItpkOqPytovmqhPj6nmqTecMEBt4PFL/O7cVyVzwnyIUA0m37FwMYnMMVZ1ro
         +I2r7KKZSGrjQWadG1CqG9KFzKcyeP8JhxW21Hyt2+se36msOgqSiZuyl2E8oJYk91Hy
         btbg==
X-Forwarded-Encrypted: i=1; AFNElJ/HU9CEyZQTIe6nCNO9ZxeWc9pTqFO9Fze9Xz8hS+YJHqh7jqc13C6eK1ZSTvgh/9rOQ0xm0KjZBuO+2+O3@vger.kernel.org
X-Gm-Message-State: AOJu0YwmcRBTsiFzsXhXj+MknRJ/PKCpu1GSqugpxhNVmfuiLWnWltp9
	l8+TwZatCAMEjWnxugW58JuNhhXUo/+43JXIKyXHnh26RsH6pYd3uRGxQSs91+ZHzOk=
X-Gm-Gg: AeBDietrWM3QWkZn1zn06+ga2kwNYpV4/DohsmAsv+Zg9Morm/kVpC6p3QFmDemie/u
	5JlKUIirQtYzCDaA6zhfVXgh5htA65fLBEMlg8hfxECVzmAOWCXgEsFOaB08HsDXSy8DWYsiiTP
	SI2Xdm0j4Xt2/yLLJXXuBuwessvAtEX0zeYIyUiXiEmnFMJE+L4/de5his3V59SCvQRhQVrjiGd
	NSEQXi/TXVJZqsl5oNGHTJn7JzsBP0amfJ2JZNnjX7PIGb3XYygYTGs3eGOkEyOC726nt+C7RJv
	baPLOjSvFZqDB621wNzGlCJI6BFoi9VRwFyX6Wzwa/qAuR048Q/eGj+DhnQBVtYK84+I3o3bH/6
	5tnuJkgRVHFOkPRhbSfT4FMZPIVLW8VN1U//ULmGqoTuMvlXzjIqpT9f1OIVtvP6tujoOL6+jYH
	2aj3Pw2tBirDL0ifCVBoPlqZL/sA==
X-Received: by 2002:a05:600d:8449:b0:487:55c:e0c1 with SMTP id 5b1f17b1804b1-488d68364fdmr279402625e9.14.1776344974877;
        Thu, 16 Apr 2026 06:09:34 -0700 (PDT)
Received: from pathway.suse.cz ([176.114.240.130])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-488f585cefdsm53796665e9.14.2026.04.16.06.09.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Apr 2026 06:09:34 -0700 (PDT)
Date: Thu, 16 Apr 2026 15:09:31 +0200
From: Petr Mladek <pmladek@suse.com>
To: Song Chen <chensong_2000@189.cn>
Cc: Petr Pavlu <petr.pavlu@suse.com>, rafael@kernel.org, lenb@kernel.org,
	mturquette@baylibre.com, sboyd@kernel.org, viresh.kumar@linaro.org,
	agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com,
	bmarzins@redhat.com, song@kernel.org, yukuai@fnnas.com,
	linan122@huawei.com, jason.wessel@windriver.com, danielt@kernel.org,
	dianders@chromium.org, horms@kernel.org, davem@davemloft.net,
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
	paulmck@kernel.org, frederic@kernel.org, mcgrof@kernel.org,
	da.gomez@kernel.org, samitolvanen@google.com, atomlin@atomlin.com,
	jpoimboe@kernel.org, jikos@kernel.org, mbenes@suse.cz,
	joe.lawrence@redhat.com, rostedt@goodmis.org, mhiramat@kernel.org,
	mark.rutland@arm.com, mathieu.desnoyers@efficios.com,
	linux-modules@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
	linux-clk@vger.kernel.org, linux-pm@vger.kernel.org,
	live-patching@vger.kernel.org, dm-devel@lists.linux.dev,
	linux-raid@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
	netdev@vger.kernel.org
Subject: Re: [RFC PATCH 2/2] kernel/module: Decouple klp and ftrace from
 load_module
Message-ID: <aeDfi98xpnKcAJx5@pathway.suse.cz>
References: <20260413080701.180976-1-chensong_2000@189.cn>
 <1191caf5-6a61-4622-a15e-854d3701f4fc@suse.com>
 <a35f5f94-7d5a-4347-974b-b270c89ef241@189.cn>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a35f5f94-7d5a-4347-974b-b270c89ef241@189.cn>
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[suse.com,quarantine];
	R_DKIM_ALLOW(-0.20)[suse.com:s=google];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-2364-lists,live-patching=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_TO(0.00)[189.cn];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[47];
	DKIM_TRACE(0.00)[suse.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	MISSING_XM_UA(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[pmladek@suse.com,live-patching@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:dkim,pathway.suse.cz:mid,189.cn:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 8C31D40E8CD
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Wed 2026-04-15 14:43:53, Song Chen wrote:
> Hi,
> 
> On 4/14/26 22:33, Petr Pavlu wrote:
> > On 4/13/26 10:07 AM, chensong_2000@189.cn wrote:
> > > From: Song Chen <chensong_2000@189.cn>
> > > 
> > > ftrace and livepatch currently have their module load/unload callbacks
> > > hard-coded in the module loader as direct function calls to
> > > ftrace_module_enable(), klp_module_coming(), klp_module_going()
> > > and ftrace_release_mod(). This tight coupling was originally introduced
> > > to enforce strict call ordering that could not be guaranteed by the
> > > module notifier chain, which only supported forward traversal. Their
> > > notifiers were moved in and out back and forth. see [1] and [2].
> > 
> > I'm unclear about what is meant by the notifiers being moved back and
> > forth. The links point to patches that converted ftrace+klp from using
> > module notifiers to explicit callbacks due to ordering issues, but this
> > switch occurred only once. Have there been other attempts to use
> > notifiers again?
> > 
> > > diff --git a/include/linux/module.h b/include/linux/module.h
> > > index 14f391b186c6..0bdd56f9defd 100644
> > > --- a/include/linux/module.h
> > > +++ b/include/linux/module.h
> > > @@ -308,6 +308,14 @@ enum module_state {
> > >   	MODULE_STATE_COMING,	/* Full formed, running module_init. */
> > >   	MODULE_STATE_GOING,	/* Going away. */
> > >   	MODULE_STATE_UNFORMED,	/* Still setting it up. */
> > > +	MODULE_STATE_FORMED,
> > 
> > I don't see a reason to add a new module state. Why is it necessary and
> > how does it fit with the existing states?
> > 
> because once notifier fails in state MODULE_STATE_UNFORMED (now only ftrace
> has someting to do in this state), notifier chain will roll back by calling
> blocking_notifier_call_chain_robust, i'm afraid MODULE_STATE_GOING is going
> to jeopardise the notifers which don't handle it appropriately, like:
> 
> case MODULE_STATE_COMING:
>      kmalloc();
> case MODULE_STATE_GOING:
>      kfree();
> 
> 
> > > +};
> > > +
> > > +enum module_notifier_prio {
> > > +	MODULE_NOTIFIER_PRIO_LOW = INT_MIN,	/* Low prioroty, coming last, going first */
> > > +	MODULE_NOTIFIER_PRIO_MID = 0,	/* Normal priority. */
> > > +	MODULE_NOTIFIER_PRIO_SECOND_HIGH = INT_MAX - 1,	/* Second high priorigy, coming second*/
> > > +	MODULE_NOTIFIER_PRIO_HIGH = INT_MAX,	/* High priorigy, coming first, going late. */
> > 
> > I suggest being explicit about how the notifiers are ordered. For
> > example:
> > 
> > enum module_notifier_prio {
> > 	MODULE_NOTIFIER_PRIO_NORMAL,	/* Normal priority, coming last, going first. */
> > 	MODULE_NOTIFIER_PRIO_LIVEPATCH,
> > 	MODULE_NOTIFIER_PRIO_FTRACE,	/* High priority, coming first, going late. */
> > };
> > 

I like the explicit PRIO_LIVEPATCH/FTRACE names.

But I would keep the INT_MAX - 1 and INT_MAX priorities. I believe
that ftrace/livepatching will always be the first/last to call.
And INT_MAX would help to preserve kABI when PRIO_NORMAL is not
enough for the rest of notifiers.

That said, I am not sure whether this is worth the effort.
This patch tries to move the explicit callbacks in a generic
notifiers API. But it will still need to use some explictly
defined (reserved) priorities. And it will
not guarantee a misuse. Also it requires the double linked
list which complicates the notifiers code.


> > >   };
> > >   struct mod_tree_node {
> > > --- a/kernel/module/main.c
> > > +++ b/kernel/module/main.c
> > > @@ -3281,20 +3277,14 @@ static int complete_formation(struct module *mod, struct load_info *info)
> > >   	return err;
> > >   }
> > > -static int prepare_coming_module(struct module *mod)
> > > +static int prepare_module_state_transaction(struct module *mod,
> > > +			unsigned long val_up, unsigned long val_down)
> > >   {
> > >   	int err;
> > > -	ftrace_module_enable(mod);
> > > -	err = klp_module_coming(mod);
> > > -	if (err)
> > > -		return err;
> > > -
> > >   	err = blocking_notifier_call_chain_robust(&module_notify_list,
> > > -			MODULE_STATE_COMING, MODULE_STATE_GOING, mod);
> > > +			val_up, val_down, mod);
> > >   	err = notifier_to_errno(err);
> > > -	if (err)
> > > -		klp_module_going(mod);
> > >   	return err;
> > >   }

I personally find the name "prepare_module_state_transaction"
misleading. What is the "transaction" here? If this was a "preparation"
step then where is the transaction done/finished?

It might be better to just opencode the
blocking_notifier_call_chain_robust() instead.

> > > @@ -3468,14 +3458,21 @@ static int load_module(struct load_info *info, const char __user *uargs,
> > >   	init_build_id(mod, info);
> > >   	/* Ftrace init must be called in the MODULE_STATE_UNFORMED state */
> > > -	ftrace_module_init(mod);
> > > +	err = prepare_module_state_transaction(mod,
> > > +				MODULE_STATE_UNFORMED, MODULE_STATE_FORMED);
> > 
> > I believe val_down should be MODULE_STATE_GOING to reverse the
> > operation. Why is the new state MODULE_STATE_FORMED needed here?
> to avoid this:
> 
> case MODULE_STATE_COMING:
>      kmalloc();
> case MODULE_STATE_GOING:
>      kfree();

Hmm, the module is in "FORMED" state here.

> > > +	if (err)
> > > +		goto ddebug_cleanup;
> > >   	/* Finally it's fully formed, ready to start executing. */
> > >   	err = complete_formation(mod, info);

And we call "complete_formation()" function. This sounds like
it was not really "FORMED" before. => It is confusing and nono.

Please, try to avoid the new state if possible. My experience
with reading the module loader code is that any new state
brings a lot of complexity. You need to take it into account
when checking correctness of other changes, features, ...

Something tells me that if the state was not needed before
then we could avoid it.

> > > -	if (err)
> > > +	if (err) {
> > > +		blocking_notifier_call_chain_reverse(&module_notify_list,
> > > +				MODULE_STATE_FORMED, mod);
> > >   		goto ddebug_cleanup;
> > > +	}
> > > -	err = prepare_coming_module(mod);
> > > +	err = prepare_module_state_transaction(mod,
> > > +				MODULE_STATE_COMING, MODULE_STATE_GOING);
> > >   	if (err)
> > >   		goto bug_cleanup;
> > > --- a/kernel/trace/ftrace.c
> > > +++ b/kernel/trace/ftrace.c
> > > @@ -5241,6 +5241,44 @@ static int __init ftrace_mod_cmd_init(void)
> > >   }
> > >   core_initcall(ftrace_mod_cmd_init);
> > > +static int ftrace_module_callback(struct notifier_block *nb, unsigned long op,
> > > +			void *module)
> > > +{
> > > +	struct module *mod = module;
> > > +
> > > +	switch (op) {
> > > +	case MODULE_STATE_UNFORMED:
> > > +		ftrace_module_init(mod);
> > > +		break;
> > > +	case MODULE_STATE_COMING:
> > > +		ftrace_module_enable(mod);
> > > +		break;
> > > +	case MODULE_STATE_LIVE:
> > > +		ftrace_free_mem(mod, mod->mem[MOD_INIT_TEXT].base,
> > > +				mod->mem[MOD_INIT_TEXT].base + mod->mem[MOD_INIT_TEXT].size);
> > > +		break;
> > > +	case MODULE_STATE_GOING:
> > > +	case MODULE_STATE_FORMED:
> > > +		ftrace_release_mod(mod);

This calls "release" in a "FORMED" state. It does not make any
sense. Something looks fishy, either the code or the naming.

> > > +		break;
> > > +	default:
> > > +		break;
> > > +	}
> > 

I am sorry for being so picky about names. I believe that good names
help to prevent bugs and reduce headaches.

Best Regards,
Petr

