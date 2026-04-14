Return-Path: <live-patching+bounces-2347-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id ECPuEM1R3mlIqQkAu9opvQ
	(envelope-from <live-patching+bounces-2347-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Tue, 14 Apr 2026 16:40:13 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B7D4B3FB691
	for <lists+live-patching@lfdr.de>; Tue, 14 Apr 2026 16:40:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id AD4A530A2402
	for <lists+live-patching@lfdr.de>; Tue, 14 Apr 2026 14:33:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A1863E92B0;
	Tue, 14 Apr 2026 14:33:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="csX3ImIg"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF64A3E8685
	for <live-patching@vger.kernel.org>; Tue, 14 Apr 2026 14:33:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776177217; cv=none; b=hlSm3pdjyB/kKEEbKw4zeARKffSzixbcOLxod/83x/gy+PbSwPlvmiFLKTqT6eV9G9qhFKg0biSakCGFxFahK18fNh4jA2UVnM/eGe8DyHo1GchNdx+lbpAQexjWpkhY4za3BkqzPoHrm8Jpw6f7XvCSEPZZ0QJM5cglgPzjrZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776177217; c=relaxed/simple;
	bh=Nw8cBmmH7vxfiWNqiq8CyDvGGD1xyD0qs9zhurR1ZIk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tLr0tJlMe/Mwy0XIU0YATHt+Gxa6/GmXf5tAhHROaOkEQE0skGIrvxiLkYRE1Zrbo/713yToUC01XF0Y5xJ5fFmxq9DoRgklJVxsotgVBas2ANlNdOkS3YB9Kx5ouC+x8qKjE3zcrDAltzJUv7MKEarh81BdkK6NkLFY6sIyMTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=csX3ImIg; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-43cfd832155so3916054f8f.1
        for <live-patching@vger.kernel.org>; Tue, 14 Apr 2026 07:33:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1776177213; x=1776782013; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ELLPgP8F2+Og4+n8Ds04pnwfQ38UDYTElLkIo6rrsKM=;
        b=csX3ImIgVJ3bv9XD4JOBHQE8R/HX1u4JHADlRr/UG+jMjc3TICB/1iDlmiZqdZITdt
         dFpIV0YnNDRg14GGanRAk3IKYi8KdJuWvTn11PTpb2nizuQAwP0x4FaCzx9m4io/2ah/
         4TE/O7KTVfu46WAUYFIZWtKKyJrgMvPYcPs+n3QAItEDmNkMoOYjXbKe0l968utmnWAR
         FFAU47TY3vBBDI/5yBY1XMwoY6Ib//AP804Lm53KHeiyZVal2/Br7c1llMhgmgN3v6Gx
         YmGq+X5Kbkbt5f8w95TRfQVI6gvHKN6VIo9IBWY1wMVMhZGZODRETSD6V62kAQa9csoj
         sRYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776177213; x=1776782013;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ELLPgP8F2+Og4+n8Ds04pnwfQ38UDYTElLkIo6rrsKM=;
        b=ZvhlJ6JODnj0dr+HogiWUCHRRpXLD+CuZhpRGVVI/5ZyaE7lu6nU238HH5slkF7N3b
         27PF3m/1vgH7MUCCI85wzlD8uS113qAoblnej3f80WWjXPB2K6oC6NiErnarL7vvG8Zc
         XsZhc+EZcSSKpDrDsC9pMlfWwAK2lzv1JXrfOPtPryqLsyLJEZAAWWW46KJD/jaGxfjX
         MAl9E8yg6gjpNZ+3Oz3HD+2+i+L6QktTCXf58RRp6twT4akt/Lw1VE1bJ00T3o+mWzsF
         B8ZORtIim9fVK0+C2wL8wrVyDrc5wq62+zfWKovCpWLY0iWBt60r1Hvo/xxiR4kXX/RN
         H/sw==
X-Forwarded-Encrypted: i=1; AFNElJ8eLqkJpWukzIJA+sFOSO6Ya3U5Xn53Ma+CUjOiDyRP35ZDNj6rsVdWj6n8/QG8YBAadZgsk55EiSmnNfwd@vger.kernel.org
X-Gm-Message-State: AOJu0YwkFWp63SE+pbHdIccR/A39nAjvaHaHuIJb+GyPxXtx2bGZM/At
	xNuyxnnjzSKXoxlMq9vOAijruUKQVMWSXdOJ1GZTS0vubeWWCEYr0zR5dtojsEXWDgE=
X-Gm-Gg: AeBDietaQtCrfG8iC9A/vMIUXBwovJ3SoumRxVFYvnJ0/gyXx/1kJXxAqT9rskVb/So
	z9JYs81hzuoZ/zvjwY+ut3By9ladTs1DEUxSg4yT7xxBWBg76pkDKMHxve0T4TE6x2tt5YIUNem
	euVeYzWFRmA+gvmkCA+0/uefLxc0ZO7KZfQmdgQi1BIJ7HTB6fGKPo0+2NFFWZwkdUJUsEfb33b
	EREXC6qx+Q2W0AdXQDTvvHXI90M83RWxuCajwNVqYzc7OUeQjH/qdTh4rmykZu0apxiTKcl99m/
	UTs7YZoAi0/4rY/+zmivD6NszMPUJOYB+EdBeLch1F+JDJhysvgHGaf4SxAexdrPY4MxSwwOtQq
	d1qNrTtQORurUX15Io18JaQjVdQI/MgO+jqQykCseNAvIAO+1YTnVA2fdSne3XL9H8eY9LatKR4
	6Gkpwggd5GqqJ1faxDv6pdTa8gioTXOgOZ8fe57Qn0yuRZ
X-Received: by 2002:a05:6000:2305:b0:43d:775b:c9bd with SMTP id ffacd0b85a97d-43d775bcb1bmr13224241f8f.10.1776177212871;
        Tue, 14 Apr 2026 07:33:32 -0700 (PDT)
Received: from [10.100.51.209] (nat2.prg.suse.com. [195.250.132.146])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43d7ba57e72sm14650537f8f.0.2026.04.14.07.33.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Apr 2026 07:33:32 -0700 (PDT)
Message-ID: <1191caf5-6a61-4622-a15e-854d3701f4fc@suse.com>
Date: Tue, 14 Apr 2026 16:33:31 +0200
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 2/2] kernel/module: Decouple klp and ftrace from
 load_module
To: chensong_2000@189.cn
Cc: rafael@kernel.org, lenb@kernel.org, mturquette@baylibre.com,
 sboyd@kernel.org, viresh.kumar@linaro.org, agk@redhat.com,
 snitzer@kernel.org, mpatocka@redhat.com, bmarzins@redhat.com,
 song@kernel.org, yukuai@fnnas.com, linan122@huawei.com,
 jason.wessel@windriver.com, danielt@kernel.org, dianders@chromium.org,
 horms@kernel.org, davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
 pabeni@redhat.com, paulmck@kernel.org, frederic@kernel.org,
 mcgrof@kernel.org, da.gomez@kernel.org, samitolvanen@google.com,
 atomlin@atomlin.com, jpoimboe@kernel.org, jikos@kernel.org, mbenes@suse.cz,
 pmladek@suse.com, joe.lawrence@redhat.com, rostedt@goodmis.org,
 mhiramat@kernel.org, mark.rutland@arm.com, mathieu.desnoyers@efficios.com,
 linux-modules@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
 linux-clk@vger.kernel.org, linux-pm@vger.kernel.org,
 live-patching@vger.kernel.org, dm-devel@lists.linux.dev,
 linux-raid@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
 netdev@vger.kernel.org
References: <20260413080701.180976-1-chensong_2000@189.cn>
Content-Language: en-US
From: Petr Pavlu <petr.pavlu@suse.com>
In-Reply-To: <20260413080701.180976-1-chensong_2000@189.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[suse.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[suse.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DKIM_TRACE(0.00)[suse.com:+];
	TAGGED_FROM(0.00)[bounces-2347-lists,live-patching=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_TO(0.00)[189.cn];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[47];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[petr.pavlu@suse.com,live-patching@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	TO_DN_NONE(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[live-patching];
	DBL_BLOCKED_OPENRESOLVER(0.00)[fhfr.pm:email,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,digitalocean.com:email,189.cn:email,suse.com:dkim,suse.com:mid]
X-Rspamd-Queue-Id: B7D4B3FB691
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On 4/13/26 10:07 AM, chensong_2000@189.cn wrote:
> From: Song Chen <chensong_2000@189.cn>
> 
> ftrace and livepatch currently have their module load/unload callbacks
> hard-coded in the module loader as direct function calls to
> ftrace_module_enable(), klp_module_coming(), klp_module_going()
> and ftrace_release_mod(). This tight coupling was originally introduced
> to enforce strict call ordering that could not be guaranteed by the
> module notifier chain, which only supported forward traversal. Their
> notifiers were moved in and out back and forth. see [1] and [2].

I'm unclear about what is meant by the notifiers being moved back and
forth. The links point to patches that converted ftrace+klp from using
module notifiers to explicit callbacks due to ordering issues, but this
switch occurred only once. Have there been other attempts to use
notifiers again?

> 
> Now that the notifier chain supports reverse traversal via
> blocking_notifier_call_chain_reverse(), the ordering can be enforced
> purely through notifier priority. As a result, the module loader is now
> decoupled from the implementation details of ftrace and livepatch.
> What's more, adding a new subsystem with symmetric setup/teardown ordering
> requirements during module load/unload no longer requires modifying
> kernel/module/main.c; it only needs to register a notifier_block with an
> appropriate priority.
> 
> [1]:https://lore.kernel.org/all/
> 	alpine.LNX.2.00.1602172216491.22700@cbobk.fhfr.pm/
> [2]:https://lore.kernel.org/all/
> 	20160301030034.GC12120@packer-debian-8-amd64.digitalocean.com/

Nit: Avoid wrapping URLs, as it breaks autolinking and makes the links
harder to copy.

Better links would be:
[1] https://lore.kernel.org/all/1455661953-15838-1-git-send-email-jeyu@redhat.com/
[2] https://lore.kernel.org/all/1458176139-17455-1-git-send-email-jeyu@redhat.com/

The first link is the final version of what landed as commit
7dcd182bec27 ("ftrace/module: remove ftrace module notifier"). The
second is commit 7e545d6eca20 ("livepatch/module: remove livepatch
module notifier").

> 
> Signed-off-by: Song Chen <chensong_2000@189.cn>
> ---
>  include/linux/module.h  |  8 ++++++++
>  kernel/livepatch/core.c | 29 ++++++++++++++++++++++++++++-
>  kernel/module/main.c    | 34 +++++++++++++++-------------------
>  kernel/trace/ftrace.c   | 38 ++++++++++++++++++++++++++++++++++++++
>  4 files changed, 89 insertions(+), 20 deletions(-)
> 
> diff --git a/include/linux/module.h b/include/linux/module.h
> index 14f391b186c6..0bdd56f9defd 100644
> --- a/include/linux/module.h
> +++ b/include/linux/module.h
> @@ -308,6 +308,14 @@ enum module_state {
>  	MODULE_STATE_COMING,	/* Full formed, running module_init. */
>  	MODULE_STATE_GOING,	/* Going away. */
>  	MODULE_STATE_UNFORMED,	/* Still setting it up. */
> +	MODULE_STATE_FORMED,

I don't see a reason to add a new module state. Why is it necessary and
how does it fit with the existing states?

> +};
> +
> +enum module_notifier_prio {
> +	MODULE_NOTIFIER_PRIO_LOW = INT_MIN,	/* Low prioroty, coming last, going first */
> +	MODULE_NOTIFIER_PRIO_MID = 0,	/* Normal priority. */
> +	MODULE_NOTIFIER_PRIO_SECOND_HIGH = INT_MAX - 1,	/* Second high priorigy, coming second*/
> +	MODULE_NOTIFIER_PRIO_HIGH = INT_MAX,	/* High priorigy, coming first, going late. */

I suggest being explicit about how the notifiers are ordered. For
example:

enum module_notifier_prio {
	MODULE_NOTIFIER_PRIO_NORMAL,	/* Normal priority, coming last, going first. */
	MODULE_NOTIFIER_PRIO_LIVEPATCH,
	MODULE_NOTIFIER_PRIO_FTRACE,	/* High priority, coming first, going late. */
};

>  };
>  
>  struct mod_tree_node {
> diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
> index 28d15ba58a26..ce78bb23e24b 100644
> --- a/kernel/livepatch/core.c
> +++ b/kernel/livepatch/core.c
> @@ -1375,13 +1375,40 @@ void *klp_find_section_by_name(const struct module *mod, const char *name,
>  }
>  EXPORT_SYMBOL_GPL(klp_find_section_by_name);
>  
> +static int klp_module_callback(struct notifier_block *nb, unsigned long op,
> +			void *module)
> +{
> +	struct module *mod = module;
> +	int err = 0;
> +
> +	switch (op) {
> +	case MODULE_STATE_COMING:
> +		err = klp_module_coming(mod);
> +		break;
> +	case MODULE_STATE_LIVE:
> +		break;
> +	case MODULE_STATE_GOING:
> +		klp_module_going(mod);
> +		break;
> +	default:
> +		break;
> +	}

klp_module_coming() and klp_module_going() are now used only in
kernel/livepatch/core.c where they are also defined. This means the
functions can be static and their declarations removed from
include/linux/livepatch.h.

Nit: The MODULE_STATE_LIVE and default cases in the switch can be
removed.

> +
> +	return notifier_from_errno(err);
> +}
> +
> +static struct notifier_block klp_module_nb = {
> +	.notifier_call = klp_module_callback,
> +	.priority = MODULE_NOTIFIER_PRIO_SECOND_HIGH
> +};
> +
>  static int __init klp_init(void)
>  {
>  	klp_root_kobj = kobject_create_and_add("livepatch", kernel_kobj);
>  	if (!klp_root_kobj)
>  		return -ENOMEM;
>  
> -	return 0;
> +	return register_module_notifier(&klp_module_nb);
>  }
>  
>  module_init(klp_init);
> diff --git a/kernel/module/main.c b/kernel/module/main.c
> index c3ce106c70af..226dd5b80997 100644
> --- a/kernel/module/main.c
> +++ b/kernel/module/main.c
> @@ -833,10 +833,8 @@ SYSCALL_DEFINE2(delete_module, const char __user *, name_user,
>  	/* Final destruction now no one is using it. */
>  	if (mod->exit != NULL)
>  		mod->exit();
> -	blocking_notifier_call_chain(&module_notify_list,
> +	blocking_notifier_call_chain_reverse(&module_notify_list,
>  				     MODULE_STATE_GOING, mod);
> -	klp_module_going(mod);
> -	ftrace_release_mod(mod);
>  
>  	async_synchronize_full();
>  
> @@ -3135,10 +3133,8 @@ static noinline int do_init_module(struct module *mod)
>  	mod->state = MODULE_STATE_GOING;
>  	synchronize_rcu();
>  	module_put(mod);
> -	blocking_notifier_call_chain(&module_notify_list,
> +	blocking_notifier_call_chain_reverse(&module_notify_list,
>  				     MODULE_STATE_GOING, mod);
> -	klp_module_going(mod);
> -	ftrace_release_mod(mod);
>  	free_module(mod);
>  	wake_up_all(&module_wq);
>  

The patch unexpectedly leaves a call to ftrace_free_mem() in
do_init_module().

> @@ -3281,20 +3277,14 @@ static int complete_formation(struct module *mod, struct load_info *info)
>  	return err;
>  }
>  
> -static int prepare_coming_module(struct module *mod)
> +static int prepare_module_state_transaction(struct module *mod,
> +			unsigned long val_up, unsigned long val_down)
>  {
>  	int err;
>  
> -	ftrace_module_enable(mod);
> -	err = klp_module_coming(mod);
> -	if (err)
> -		return err;
> -
>  	err = blocking_notifier_call_chain_robust(&module_notify_list,
> -			MODULE_STATE_COMING, MODULE_STATE_GOING, mod);
> +			val_up, val_down, mod);
>  	err = notifier_to_errno(err);
> -	if (err)
> -		klp_module_going(mod);
>  
>  	return err;
>  }
> @@ -3468,14 +3458,21 @@ static int load_module(struct load_info *info, const char __user *uargs,
>  	init_build_id(mod, info);
>  
>  	/* Ftrace init must be called in the MODULE_STATE_UNFORMED state */
> -	ftrace_module_init(mod);
> +	err = prepare_module_state_transaction(mod,
> +				MODULE_STATE_UNFORMED, MODULE_STATE_FORMED);

I believe val_down should be MODULE_STATE_GOING to reverse the
operation. Why is the new state MODULE_STATE_FORMED needed here?

> +	if (err)
> +		goto ddebug_cleanup;
>  
>  	/* Finally it's fully formed, ready to start executing. */
>  	err = complete_formation(mod, info);
> -	if (err)
> +	if (err) {
> +		blocking_notifier_call_chain_reverse(&module_notify_list,
> +				MODULE_STATE_FORMED, mod);
>  		goto ddebug_cleanup;
> +	}
>  
> -	err = prepare_coming_module(mod);
> +	err = prepare_module_state_transaction(mod,
> +				MODULE_STATE_COMING, MODULE_STATE_GOING);
>  	if (err)
>  		goto bug_cleanup;
>  
> @@ -3522,7 +3519,6 @@ static int load_module(struct load_info *info, const char __user *uargs,
>  	destroy_params(mod->kp, mod->num_kp);
>  	blocking_notifier_call_chain(&module_notify_list,
>  				     MODULE_STATE_GOING, mod);

My understanding is that all notifier chains for MODULE_STATE_GOING
should be reversed.

> -	klp_module_going(mod);
>   bug_cleanup:
>  	mod->state = MODULE_STATE_GOING;
>  	/* module_bug_cleanup needs module_mutex protection */

The patch removes the klp_module_going() cleanup call in load_module().
Similarly, the ftrace_release_mod() call under the ddebug_cleanup label
should be removed and appropriately replaced with a cleanup via
a notifier.

> diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
> index 8df69e702706..efedb98d3db4 100644
> --- a/kernel/trace/ftrace.c
> +++ b/kernel/trace/ftrace.c
> @@ -5241,6 +5241,44 @@ static int __init ftrace_mod_cmd_init(void)
>  }
>  core_initcall(ftrace_mod_cmd_init);
>  
> +static int ftrace_module_callback(struct notifier_block *nb, unsigned long op,
> +			void *module)
> +{
> +	struct module *mod = module;
> +
> +	switch (op) {
> +	case MODULE_STATE_UNFORMED:
> +		ftrace_module_init(mod);
> +		break;
> +	case MODULE_STATE_COMING:
> +		ftrace_module_enable(mod);
> +		break;
> +	case MODULE_STATE_LIVE:
> +		ftrace_free_mem(mod, mod->mem[MOD_INIT_TEXT].base,
> +				mod->mem[MOD_INIT_TEXT].base + mod->mem[MOD_INIT_TEXT].size);
> +		break;
> +	case MODULE_STATE_GOING:
> +	case MODULE_STATE_FORMED:
> +		ftrace_release_mod(mod);
> +		break;
> +	default:
> +		break;
> +	}

ftrace_module_init(), ftrace_module_enable(), ftrace_free_mem() and
ftrace_release_mod() should be newly used only in kernel/trace/ftrace.c
where they are also defined. The functions can then be made static and
removed from include/linux/ftrace.h.

Nit: The default case in the switch can be removed.

> +
> +	return notifier_from_errno(0);

Nit: This can be simply "return NOTIFY_OK;".

> +}
> +
> +static struct notifier_block ftrace_module_nb = {
> +	.notifier_call = ftrace_module_callback,
> +	.priority = MODULE_NOTIFIER_PRIO_HIGH
> +};
> +
> +static int __init ftrace_register_module_notifier(void)
> +{
> +	return register_module_notifier(&ftrace_module_nb);
> +}
> +core_initcall(ftrace_register_module_notifier);
> +
>  static void function_trace_probe_call(unsigned long ip, unsigned long parent_ip,
>  				      struct ftrace_ops *op, struct ftrace_regs *fregs)
>  {

-- 
Thanks,
Petr

