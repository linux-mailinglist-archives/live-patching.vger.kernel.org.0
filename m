Return-Path: <live-patching+bounces-2350-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id qDLyFKg032lqQAAAu9opvQ
	(envelope-from <live-patching+bounces-2350-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Wed, 15 Apr 2026 08:48:08 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id C22C8401095
	for <lists+live-patching@lfdr.de>; Wed, 15 Apr 2026 08:48:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id B2B13303012A
	for <lists+live-patching@lfdr.de>; Wed, 15 Apr 2026 06:44:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1FCBC3914EA;
	Wed, 15 Apr 2026 06:44:11 +0000 (UTC)
X-Original-To: live-patching@vger.kernel.org
Received: from mail.189.cn (189sx01-ptr.21cn.com [125.88.204.37])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E6C3315D35;
	Wed, 15 Apr 2026 06:44:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=125.88.204.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776235451; cv=none; b=iaUvSpS14EluN4cSV0uTvhdDBl78yBya3VrM+JBM2XoiJoi5agl6rl4X90lC+FXhuekIbbROKRRYl7aeXGWI4p+8JYy/qv/mUebKEIy76IiNayIwDNs9eW+PSFfhTAu7+r0VfbCSExjZnDxDug/c7tnVDTELObjrojFTbgIl5Eg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776235451; c=relaxed/simple;
	bh=lwCmgqjqcbQlfJMh1X8hwGEYnxoUR0QLxjz3mrbn7NU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HBx22jvqQhbTcebiQ21DESwSM9y+mrp+Wih04Enlgxo00e6XtZbBFoV50aRf763ccOfJ+AN4dk17w0tKZQ2/71/pSYjN9VXzr23RTmgTV87lOKJz4RkkWPjRdA+mzG9ucjxcXtO8fOcR1N62NzG7Sr2/vlac2mQb0tDtwCaV6kM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=189.cn; spf=pass smtp.mailfrom=189.cn; arc=none smtp.client-ip=125.88.204.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=189.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=189.cn
HMM_SOURCE_IP:10.158.243.220:0.2014231400
HMM_ATTACHE_NUM:0000
HMM_SOURCE_TYPE:SMTP
Received: from clientip-60.27.227.144 (unknown [10.158.243.220])
	by mail.189.cn (HERMES) with SMTP id 7104C4002A0;
	Wed, 15 Apr 2026 14:43:54 +0800 (CST)
Received: from  ([60.27.227.144])
	by gateway-153622-dep-76cc7bc9cd-j7zjr with ESMTP id b5a71e7471bb4154ab14a2cc20557b33 for petr.pavlu@suse.com;
	Wed, 15 Apr 2026 14:43:57 CST
X-Transaction-ID: b5a71e7471bb4154ab14a2cc20557b33
X-Real-From: chensong_2000@189.cn
X-Receive-IP: 60.27.227.144
X-MEDUSA-Status: 0
Sender: chensong_2000@189.cn
Message-ID: <a35f5f94-7d5a-4347-974b-b270c89ef241@189.cn>
Date: Wed, 15 Apr 2026 14:43:53 +0800
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 2/2] kernel/module: Decouple klp and ftrace from
 load_module
To: Petr Pavlu <petr.pavlu@suse.com>
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
 <1191caf5-6a61-4622-a15e-854d3701f4fc@suse.com>
Content-Language: en-US
From: Song Chen <chensong_2000@189.cn>
In-Reply-To: <1191caf5-6a61-4622-a15e-854d3701f4fc@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-1.46 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-2350-lists,live-patching=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DMARC_NA(0.00)[189.cn];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[47];
	FREEMAIL_FROM(0.00)[189.cn];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	FROM_HAS_DN(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[chensong_2000@189.cn,live-patching@vger.kernel.org];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	R_DKIM_NA(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	MID_RHS_MATCH_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,digitalocean.com:email,fhfr.pm:email,189.cn:mid,189.cn:email]
X-Rspamd-Queue-Id: C22C8401095
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Hi,

On 4/14/26 22:33, Petr Pavlu wrote:
> On 4/13/26 10:07 AM, chensong_2000@189.cn wrote:
>> From: Song Chen <chensong_2000@189.cn>
>>
>> ftrace and livepatch currently have their module load/unload callbacks
>> hard-coded in the module loader as direct function calls to
>> ftrace_module_enable(), klp_module_coming(), klp_module_going()
>> and ftrace_release_mod(). This tight coupling was originally introduced
>> to enforce strict call ordering that could not be guaranteed by the
>> module notifier chain, which only supported forward traversal. Their
>> notifiers were moved in and out back and forth. see [1] and [2].
> 
> I'm unclear about what is meant by the notifiers being moved back and
> forth. The links point to patches that converted ftrace+klp from using
> module notifiers to explicit callbacks due to ordering issues, but this
> switch occurred only once. Have there been other attempts to use
> notifiers again?
> 

Yes,only once,i will rephrase.

>>
>> Now that the notifier chain supports reverse traversal via
>> blocking_notifier_call_chain_reverse(), the ordering can be enforced
>> purely through notifier priority. As a result, the module loader is now
>> decoupled from the implementation details of ftrace and livepatch.
>> What's more, adding a new subsystem with symmetric setup/teardown ordering
>> requirements during module load/unload no longer requires modifying
>> kernel/module/main.c; it only needs to register a notifier_block with an
>> appropriate priority.
>>
>> [1]:https://lore.kernel.org/all/
>> 	alpine.LNX.2.00.1602172216491.22700@cbobk.fhfr.pm/
>> [2]:https://lore.kernel.org/all/
>> 	20160301030034.GC12120@packer-debian-8-amd64.digitalocean.com/
> 
> Nit: Avoid wrapping URLs, as it breaks autolinking and makes the links
> harder to copy.
> 
> Better links would be:
> [1] https://lore.kernel.org/all/1455661953-15838-1-git-send-email-jeyu@redhat.com/
> [2] https://lore.kernel.org/all/1458176139-17455-1-git-send-email-jeyu@redhat.com/
> 
> The first link is the final version of what landed as commit
> 7dcd182bec27 ("ftrace/module: remove ftrace module notifier"). The
> second is commit 7e545d6eca20 ("livepatch/module: remove livepatch
> module notifier").
> 

Thank you, i will update.

>>
>> Signed-off-by: Song Chen <chensong_2000@189.cn>
>> ---
>>   include/linux/module.h  |  8 ++++++++
>>   kernel/livepatch/core.c | 29 ++++++++++++++++++++++++++++-
>>   kernel/module/main.c    | 34 +++++++++++++++-------------------
>>   kernel/trace/ftrace.c   | 38 ++++++++++++++++++++++++++++++++++++++
>>   4 files changed, 89 insertions(+), 20 deletions(-)
>>
>> diff --git a/include/linux/module.h b/include/linux/module.h
>> index 14f391b186c6..0bdd56f9defd 100644
>> --- a/include/linux/module.h
>> +++ b/include/linux/module.h
>> @@ -308,6 +308,14 @@ enum module_state {
>>   	MODULE_STATE_COMING,	/* Full formed, running module_init. */
>>   	MODULE_STATE_GOING,	/* Going away. */
>>   	MODULE_STATE_UNFORMED,	/* Still setting it up. */
>> +	MODULE_STATE_FORMED,
> 
> I don't see a reason to add a new module state. Why is it necessary and
> how does it fit with the existing states?
> 
because once notifier fails in state MODULE_STATE_UNFORMED (now only 
ftrace has someting to do in this state), notifier chain will roll back 
by calling blocking_notifier_call_chain_robust, i'm afraid 
MODULE_STATE_GOING is going to jeopardise the notifers which don't 
handle it appropriately, like:

case MODULE_STATE_COMING:
      kmalloc();
case MODULE_STATE_GOING:
      kfree();


>> +};
>> +
>> +enum module_notifier_prio {
>> +	MODULE_NOTIFIER_PRIO_LOW = INT_MIN,	/* Low prioroty, coming last, going first */
>> +	MODULE_NOTIFIER_PRIO_MID = 0,	/* Normal priority. */
>> +	MODULE_NOTIFIER_PRIO_SECOND_HIGH = INT_MAX - 1,	/* Second high priorigy, coming second*/
>> +	MODULE_NOTIFIER_PRIO_HIGH = INT_MAX,	/* High priorigy, coming first, going late. */
> 
> I suggest being explicit about how the notifiers are ordered. For
> example:
> 
> enum module_notifier_prio {
> 	MODULE_NOTIFIER_PRIO_NORMAL,	/* Normal priority, coming last, going first. */
> 	MODULE_NOTIFIER_PRIO_LIVEPATCH,
> 	MODULE_NOTIFIER_PRIO_FTRACE,	/* High priority, coming first, going late. */
> };
> 

accepted.

>>   };
>>   
>>   struct mod_tree_node {
>> diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
>> index 28d15ba58a26..ce78bb23e24b 100644
>> --- a/kernel/livepatch/core.c
>> +++ b/kernel/livepatch/core.c
>> @@ -1375,13 +1375,40 @@ void *klp_find_section_by_name(const struct module *mod, const char *name,
>>   }
>>   EXPORT_SYMBOL_GPL(klp_find_section_by_name);
>>   
>> +static int klp_module_callback(struct notifier_block *nb, unsigned long op,
>> +			void *module)
>> +{
>> +	struct module *mod = module;
>> +	int err = 0;
>> +
>> +	switch (op) {
>> +	case MODULE_STATE_COMING:
>> +		err = klp_module_coming(mod);
>> +		break;
>> +	case MODULE_STATE_LIVE:
>> +		break;
>> +	case MODULE_STATE_GOING:
>> +		klp_module_going(mod);
>> +		break;
>> +	default:
>> +		break;
>> +	}
> 
> klp_module_coming() and klp_module_going() are now used only in
> kernel/livepatch/core.c where they are also defined. This means the
> functions can be static and their declarations removed from
> include/linux/livepatch.h.
> 
> Nit: The MODULE_STATE_LIVE and default cases in the switch can be
> removed.
> 

accepted.

>> +
>> +	return notifier_from_errno(err);
>> +}
>> +
>> +static struct notifier_block klp_module_nb = {
>> +	.notifier_call = klp_module_callback,
>> +	.priority = MODULE_NOTIFIER_PRIO_SECOND_HIGH
>> +};
>> +
>>   static int __init klp_init(void)
>>   {
>>   	klp_root_kobj = kobject_create_and_add("livepatch", kernel_kobj);
>>   	if (!klp_root_kobj)
>>   		return -ENOMEM;
>>   
>> -	return 0;
>> +	return register_module_notifier(&klp_module_nb);
>>   }
>>   
>>   module_init(klp_init);
>> diff --git a/kernel/module/main.c b/kernel/module/main.c
>> index c3ce106c70af..226dd5b80997 100644
>> --- a/kernel/module/main.c
>> +++ b/kernel/module/main.c
>> @@ -833,10 +833,8 @@ SYSCALL_DEFINE2(delete_module, const char __user *, name_user,
>>   	/* Final destruction now no one is using it. */
>>   	if (mod->exit != NULL)
>>   		mod->exit();
>> -	blocking_notifier_call_chain(&module_notify_list,
>> +	blocking_notifier_call_chain_reverse(&module_notify_list,
>>   				     MODULE_STATE_GOING, mod);
>> -	klp_module_going(mod);
>> -	ftrace_release_mod(mod);
>>   
>>   	async_synchronize_full();
>>   
>> @@ -3135,10 +3133,8 @@ static noinline int do_init_module(struct module *mod)
>>   	mod->state = MODULE_STATE_GOING;
>>   	synchronize_rcu();
>>   	module_put(mod);
>> -	blocking_notifier_call_chain(&module_notify_list,
>> +	blocking_notifier_call_chain_reverse(&module_notify_list,
>>   				     MODULE_STATE_GOING, mod);
>> -	klp_module_going(mod);
>> -	ftrace_release_mod(mod);
>>   	free_module(mod);
>>   	wake_up_all(&module_wq);
>>   
> 
> The patch unexpectedly leaves a call to ftrace_free_mem() in
> do_init_module().

Thanks for pointing it out, it was removed when i implemented and 
tested, but when i organized the patch, it was left. I will remove it.

> 
>> @@ -3281,20 +3277,14 @@ static int complete_formation(struct module *mod, struct load_info *info)
>>   	return err;
>>   }
>>   
>> -static int prepare_coming_module(struct module *mod)
>> +static int prepare_module_state_transaction(struct module *mod,
>> +			unsigned long val_up, unsigned long val_down)
>>   {
>>   	int err;
>>   
>> -	ftrace_module_enable(mod);
>> -	err = klp_module_coming(mod);
>> -	if (err)
>> -		return err;
>> -
>>   	err = blocking_notifier_call_chain_robust(&module_notify_list,
>> -			MODULE_STATE_COMING, MODULE_STATE_GOING, mod);
>> +			val_up, val_down, mod);
>>   	err = notifier_to_errno(err);
>> -	if (err)
>> -		klp_module_going(mod);
>>   
>>   	return err;
>>   }
>> @@ -3468,14 +3458,21 @@ static int load_module(struct load_info *info, const char __user *uargs,
>>   	init_build_id(mod, info);
>>   
>>   	/* Ftrace init must be called in the MODULE_STATE_UNFORMED state */
>> -	ftrace_module_init(mod);
>> +	err = prepare_module_state_transaction(mod,
>> +				MODULE_STATE_UNFORMED, MODULE_STATE_FORMED);
> 
> I believe val_down should be MODULE_STATE_GOING to reverse the
> operation. Why is the new state MODULE_STATE_FORMED needed here?
to avoid this:

case MODULE_STATE_COMING:
      kmalloc();
case MODULE_STATE_GOING:
      kfree();



> 
>> +	if (err)
>> +		goto ddebug_cleanup;
>>   
>>   	/* Finally it's fully formed, ready to start executing. */
>>   	err = complete_formation(mod, info);
>> -	if (err)
>> +	if (err) {
>> +		blocking_notifier_call_chain_reverse(&module_notify_list,
>> +				MODULE_STATE_FORMED, mod);
>>   		goto ddebug_cleanup;
>> +	}
>>   
>> -	err = prepare_coming_module(mod);
>> +	err = prepare_module_state_transaction(mod,
>> +				MODULE_STATE_COMING, MODULE_STATE_GOING);
>>   	if (err)
>>   		goto bug_cleanup;
>>   
>> @@ -3522,7 +3519,6 @@ static int load_module(struct load_info *info, const char __user *uargs,
>>   	destroy_params(mod->kp, mod->num_kp);
>>   	blocking_notifier_call_chain(&module_notify_list,
>>   				     MODULE_STATE_GOING, mod);
> 
> My understanding is that all notifier chains for MODULE_STATE_GOING
> should be reversed.
yes, all, from lowest priority notifier to highest.
I will resend patch 1 which was failed due to my proxy setting.

> 
>> -	klp_module_going(mod);
>>    bug_cleanup:
>>   	mod->state = MODULE_STATE_GOING;
>>   	/* module_bug_cleanup needs module_mutex protection */
> 
> The patch removes the klp_module_going() cleanup call in load_module().
> Similarly, the ftrace_release_mod() call under the ddebug_cleanup label
> should be removed and appropriately replaced with a cleanup via
> a notifier.
> 
     err = prepare_module_state_transaction(mod,
                 MODULE_STATE_UNFORMED, MODULE_STATE_FORMED);
     if (err)
         goto ddebug_cleanup;

ftrace will be cleanup in blocking_notifier_call_chain_robust rolling back.

     err = prepare_module_state_transaction(mod,
                 MODULE_STATE_COMING, MODULE_STATE_GOING);

each notifier including ftrace and klp will be cleanup in 
blocking_notifier_call_chain_robust rolling back.

if all notifiers are successful in MODULE_STATE_COMING, they all will be 
clean up in
  coming_cleanup:
     mod->state = MODULE_STATE_GOING;
     destroy_params(mod->kp, mod->num_kp);
     blocking_notifier_call_chain(&module_notify_list,
                      MODULE_STATE_GOING, mod);

if  something wrong underneath.

>> diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
>> index 8df69e702706..efedb98d3db4 100644
>> --- a/kernel/trace/ftrace.c
>> +++ b/kernel/trace/ftrace.c
>> @@ -5241,6 +5241,44 @@ static int __init ftrace_mod_cmd_init(void)
>>   }
>>   core_initcall(ftrace_mod_cmd_init);
>>   
>> +static int ftrace_module_callback(struct notifier_block *nb, unsigned long op,
>> +			void *module)
>> +{
>> +	struct module *mod = module;
>> +
>> +	switch (op) {
>> +	case MODULE_STATE_UNFORMED:
>> +		ftrace_module_init(mod);
>> +		break;
>> +	case MODULE_STATE_COMING:
>> +		ftrace_module_enable(mod);
>> +		break;
>> +	case MODULE_STATE_LIVE:
>> +		ftrace_free_mem(mod, mod->mem[MOD_INIT_TEXT].base,
>> +				mod->mem[MOD_INIT_TEXT].base + mod->mem[MOD_INIT_TEXT].size);
>> +		break;
>> +	case MODULE_STATE_GOING:
>> +	case MODULE_STATE_FORMED:
>> +		ftrace_release_mod(mod);
>> +		break;
>> +	default:
>> +		break;
>> +	}
> 
> ftrace_module_init(), ftrace_module_enable(), ftrace_free_mem() and
> ftrace_release_mod() should be newly used only in kernel/trace/ftrace.c
> where they are also defined. The functions can then be made static and
> removed from include/linux/ftrace.h.
> 
> Nit: The default case in the switch can be removed.
> 

accepted.

>> +
>> +	return notifier_from_errno(0);
> 
> Nit: This can be simply "return NOTIFY_OK;".

accepted
> 
>> +}
>> +
>> +static struct notifier_block ftrace_module_nb = {
>> +	.notifier_call = ftrace_module_callback,
>> +	.priority = MODULE_NOTIFIER_PRIO_HIGH
>> +};
>> +
>> +static int __init ftrace_register_module_notifier(void)
>> +{
>> +	return register_module_notifier(&ftrace_module_nb);
>> +}
>> +core_initcall(ftrace_register_module_notifier);
>> +
>>   static void function_trace_probe_call(unsigned long ip, unsigned long parent_ip,
>>   				      struct ftrace_ops *op, struct ftrace_regs *fregs)
>>   {
> 

Best regards

Song


