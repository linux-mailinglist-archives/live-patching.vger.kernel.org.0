Return-Path: <live-patching+bounces-2558-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id uJGQB9Ah7mnHqwAAu9opvQ
	(envelope-from <live-patching+bounces-2558-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Sun, 26 Apr 2026 16:31:44 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 956D346A55C
	for <lists+live-patching@lfdr.de>; Sun, 26 Apr 2026 16:31:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id E2B17301A395
	for <lists+live-patching@lfdr.de>; Sun, 26 Apr 2026 14:31:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 707C1365A1B;
	Sun, 26 Apr 2026 14:31:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=126.com header.i=@126.com header.b="GJr6WW1F"
X-Original-To: live-patching@vger.kernel.org
Received: from m16.mail.126.com (m16.mail.126.com [117.135.210.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E35A33EAF9;
	Sun, 26 Apr 2026 14:31:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777213882; cv=none; b=B4oCBBO6iYDhQ8giyyXVRSDYh7nFHxxmC5tHnCaseh2r23yaOGze81USIKuocMa53Q7oXXR+rkl2ejKCqlgdvSAXI5oemgKUwTmSKoqFCSgucPgl2Op4F+HM6R9c+w1r9dV+AysgYZR/jqr8rMPJtTV1pnQHWiF8AjYogHW77aY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777213882; c=relaxed/simple;
	bh=+bORunN9DihtZKlWmsbyAGvFX7FDw4aL3SCDlhq8TbQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Iq9JWsNU47zulAjTpwkWEIwLER16AYo9OwggxexnsmZK24z0Yql8/OeoVS6CER/gIXBb6dC6A3qQ/+NKhsAKiNVFK1heGf81ZC4Zv+OLUOuvyDJzbyjCyCYTunE0oZN64Bmuk3cpLSDORbjXDbR0JqMZ/wHKebfn45k23jGSpNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=126.com; spf=pass smtp.mailfrom=126.com; dkim=pass (1024-bit key) header.d=126.com header.i=@126.com header.b=GJr6WW1F; arc=none smtp.client-ip=117.135.210.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=126.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=126.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
	s=s110527; h=Message-ID:Date:MIME-Version:Subject:To:From:
	Content-Type; bh=E9QmRybu2HwGPax/8gg8zi6sH9jkn1UXfiltYEM9caY=;
	b=GJr6WW1FFj6/yFQO/D5b9Z35SC7l1yTBhxhkj4vkJEDWXnmtfwNBf1YT1GYzae
	P0Gt/eizsqh6vY6sMw6Mw1boLItuuLSQUjjE1+H0HF3nkXamKKPRxDHvIBIeT+aq
	TIDE6L1lz40dD6JtPB2Ok5ChCODfw8DCkX8wZ/USbRfTA=
Received: from [IPV6:2408:8210:480a:2590:ec66:74e8:68a7:a44b] (unknown [])
	by gzga-smtp-mtada-g0-1 (Coremail) with SMTP id _____wD3lxKMIO5pdslVAQ--.7227S2;
	Sun, 26 Apr 2026 22:26:22 +0800 (CST)
Message-ID: <c646232a-f2bf-439a-88c9-737dde9b1725@126.com>
Date: Sun, 26 Apr 2026 22:26:20 +0800
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 2/2] kernel/module: Decouple klp and ftrace from
 load_module
To: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
 Petr Mladek <pmladek@suse.com>
Cc: Petr Pavlu <petr.pavlu@suse.com>, rafael@kernel.org, lenb@kernel.org,
 mturquette@baylibre.com, sboyd@kernel.org, viresh.kumar@linaro.org,
 agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com,
 bmarzins@redhat.com, song@kernel.org, yukuai@fnnas.com, linan122@huawei.com,
 jason.wessel@windriver.com, danielt@kernel.org, dianders@chromium.org,
 horms@kernel.org, davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
 pabeni@redhat.com, paulmck@kernel.org, frederic@kernel.org,
 mcgrof@kernel.org, da.gomez@kernel.org, samitolvanen@google.com,
 atomlin@atomlin.com, jpoimboe@kernel.org, jikos@kernel.org, mbenes@suse.cz,
 joe.lawrence@redhat.com, rostedt@goodmis.org, mark.rutland@arm.com,
 mathieu.desnoyers@efficios.com, linux-modules@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
 linux-acpi@vger.kernel.org, linux-clk@vger.kernel.org,
 linux-pm@vger.kernel.org, live-patching@vger.kernel.org,
 dm-devel@lists.linux.dev, linux-raid@vger.kernel.org,
 kgdb-bugreport@lists.sourceforge.net, netdev@vger.kernel.org
References: <20260413080701.180976-1-chensong_2000@189.cn>
 <1191caf5-6a61-4622-a15e-854d3701f4fc@suse.com>
 <a35f5f94-7d5a-4347-974b-b270c89ef241@189.cn>
 <1db425bf-58a9-4768-8c38-3ae25d7662a5@suse.com>
 <aeD2_FrFL6E3dbAC@pathway.suse.cz>
 <20260420112707.aa3627ca9f975eeaf7d8ea0e@kernel.org>
Content-Language: en-US
From: Song Chen <chensong_2000@126.com>
In-Reply-To: <20260420112707.aa3627ca9f975eeaf7d8ea0e@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:_____wD3lxKMIO5pdslVAQ--.7227S2
X-Coremail-Antispam: 1Uf129KBjvJXoW3JrW8Wry8Gr4xKw15uFy3Jwb_yoW3GFWDpF
	9xWF17Gr4DXr9rCa1Ivw1UZr17K34UGr4jqr15GFyxGryqyFn7JFy8Gr109FykJrWkZry2
	qr4UAry7A345JrJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07UG-eOUUUUU=
X-CM-SenderInfo: xfkh02prqjsjqqqqqiyswou0bp/xtbBsw5BwGnuII7qoQAA3e
X-Rspamd-Queue-Id: 956D346A55C
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[126.com,none];
	R_DKIM_ALLOW(-0.20)[126.com:s=s110527];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-2558-lists,live-patching=lfdr.de];
	FREEMAIL_FROM(0.00)[126.com];
	RCPT_COUNT_TWELVE(0.00)[47];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[chensong_2000@126.com,live-patching@vger.kernel.org];
	DKIM_TRACE(0.00)[126.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[live-patching];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,suse.com:email,189.cn:email]

Hi,


On 4/20/26 10:27, Masami Hiramatsu (Google) wrote:
> On Thu, 16 Apr 2026 16:49:32 +0200
> Petr Mladek <pmladek@suse.com> wrote:
> 
>> On Thu 2026-04-16 13:18:30, Petr Pavlu wrote:
>>> On 4/15/26 8:43 AM, Song Chen wrote:
>>>> On 4/14/26 22:33, Petr Pavlu wrote:
>>>>> On 4/13/26 10:07 AM, chensong_2000@189.cn wrote:
>>>>>> diff --git a/include/linux/module.h b/include/linux/module.h
>>>>>> index 14f391b186c6..0bdd56f9defd 100644
>>>>>> --- a/include/linux/module.h
>>>>>> +++ b/include/linux/module.h
>>>>>> @@ -308,6 +308,14 @@ enum module_state {
>>>>>>        MODULE_STATE_COMING,    /* Full formed, running module_init. */
>>>>>>        MODULE_STATE_GOING,    /* Going away. */
>>>>>>        MODULE_STATE_UNFORMED,    /* Still setting it up. */
>>>>>> +    MODULE_STATE_FORMED,
>>>>>
>>>>> I don't see a reason to add a new module state. Why is it necessary and
>>>>> how does it fit with the existing states?
>>>>>
>>>> because once notifier fails in state MODULE_STATE_UNFORMED (now only ftrace has someting to do in this state), notifier chain will roll back by calling blocking_notifier_call_chain_robust, i'm afraid MODULE_STATE_GOING is going to jeopardise the notifers which don't handle it appropriately, like:
>>>>
>>>> case MODULE_STATE_COMING:
>>>>       kmalloc();
>>>> case MODULE_STATE_GOING:
>>>>       kfree();
>>>
>>> My understanding is that the current module "state machine" operates as
>>> follows. Transitions marked with an asterisk (*) are announced via the
>>> module notifier.
>>>
>>> ---> UNFORMED --*> COMING --*> LIVE --*> GOING -.
>>>          ^            |                     ^    |
>>>          |            '---------------------*    |
>>>          '---------------------------------------'
>>>
>>> The new code aims to replace the current ftrace_module_init() call in
>>> load_module(). To achieve this, it adds a notification for the UNFORMED
>>> state (only when loading a module) and introduces a new FORMED state for
>>> rollback. FORMED is purely a fake state because it never appears in
>>> module::state. The new structure is as follows:
>>>
>>>          ,--*> (FORMED)
>>>          |
>>> --*> UNFORMED --*> COMING --*> LIVE --*> GOING -.
>>>          ^            |                     ^    |
>>>          |            '---------------------*    |
>>>          '---------------------------------------'
>>>
>>> I'm afraid this is quite complex and inconsistent. Unless it can be kept
>>> simple, we would be just replacing one special handling with a different
>>> complexity, which is not worth it.
>>
>>>>>
>>>>>> +    if (err)
>>>>>> +        goto ddebug_cleanup;
>>>>>>          /* Finally it's fully formed, ready to start executing. */
>>>>>>        err = complete_formation(mod, info);
>>>>>> -    if (err)
>>>>>> +    if (err) {
>>>>>> +        blocking_notifier_call_chain_reverse(&module_notify_list,
>>>>>> +                MODULE_STATE_FORMED, mod);
>>>>>>            goto ddebug_cleanup;
>>>>>> +    }
>>>>>>    -    err = prepare_coming_module(mod);
>>>>>> +    err = prepare_module_state_transaction(mod,
>>>>>> +                MODULE_STATE_COMING, MODULE_STATE_GOING);
>>>>>>        if (err)
>>>>>>            goto bug_cleanup;
>>>>>>    @@ -3522,7 +3519,6 @@ static int load_module(struct load_info *info, const char __user *uargs,
>>>>>>        destroy_params(mod->kp, mod->num_kp);
>>>>>>        blocking_notifier_call_chain(&module_notify_list,
>>>>>>                         MODULE_STATE_GOING, mod);
>>>>>
>>>>> My understanding is that all notifier chains for MODULE_STATE_GOING
>>>>> should be reversed.
>>>> yes, all, from lowest priority notifier to highest.
>>>> I will resend patch 1 which was failed due to my proxy setting.
>>>
>>> What I meant here is that the call:
>>>
>>> blocking_notifier_call_chain(&module_notify_list, MODULE_STATE_GOING, mod);
>>>
>>> should be replaced with:
>>>
>>> blocking_notifier_call_chain_reverse(&module_notify_list, MODULE_STATE_GOING, mod);
>>>
>>>>
>>>>>
>>>>>> -    klp_module_going(mod);
>>>>>>     bug_cleanup:
>>>>>>        mod->state = MODULE_STATE_GOING;
>>>>>>        /* module_bug_cleanup needs module_mutex protection */
>>>>>
>>>>> The patch removes the klp_module_going() cleanup call in load_module().
>>>>> Similarly, the ftrace_release_mod() call under the ddebug_cleanup label
>>>>> should be removed and appropriately replaced with a cleanup via
>>>>> a notifier.
>>>>>
>>>>      err = prepare_module_state_transaction(mod,
>>>>                  MODULE_STATE_UNFORMED, MODULE_STATE_FORMED);
>>>>      if (err)
>>>>          goto ddebug_cleanup;
>>>>
>>>> ftrace will be cleanup in blocking_notifier_call_chain_robust rolling back.
>>>>
>>>>      err = prepare_module_state_transaction(mod,
>>>>                  MODULE_STATE_COMING, MODULE_STATE_GOING);
>>>>
>>>> each notifier including ftrace and klp will be cleanup in blocking_notifier_call_chain_robust rolling back.
>>>>
>>>> if all notifiers are successful in MODULE_STATE_COMING, they all will be clean up in
>>>>   coming_cleanup:
>>>>      mod->state = MODULE_STATE_GOING;
>>>>      destroy_params(mod->kp, mod->num_kp);
>>>>      blocking_notifier_call_chain(&module_notify_list,
>>>>                       MODULE_STATE_GOING, mod);
>>>>
>>>> if  something wrong underneath.
>>>
>>> My point is that the patch leaves a call to ftrace_release_mod() in
>>> load_module(), which I expected to be handled via a notifier.
>>
>> I think that I have got it. The ftrace code needs two notifiers when
>> the module is being loaded and two when it is going.
>>
>> This is why Sond added the new state. But I think that we would
>> need two new states to call:
>>
>>      + ftrace_module_init() in MODULE_STATE_UNFORMED
>>      + ftrace_module_enable() in MODULE_STATE_FORMED
>>
>> and
>>
>>      + ftrace_free_mem() in MODULE_STATE_PRE_GOING
>>      + ftrace_free_mem() in MODULE_STATE_GOING
>>
>>
>> By using the ascii art:
>>
>>   -*> UNFORMED -*> FORMED -> COMING -*> LIVE -*> PRE_GOING -*> GOING -.
>>                |          |         |                ^           ^    ^
>>                |          |         '----------------'           |    |
>>                |          '--------------------------------------'    |
>>                '------------------------------------------------------'
>>
>>
>> But I think that this is not worth it.
> 
> Agree.
> 
> If this needs to be ordered so strictly, why we will use a "single"
> module notifier chain for this complex situation?
> 
> I think the notifier call chain is just for notice a single signal,
> instead of sending several different signals, especially if there is
> any dependency among the callbacks.
> 
> If notification callbacks need to be ordered, they are currently
> sorted by representing priority numerically, but this is quite
> fragile for updating. It has to look up other registered priorities
> and adjust the order among dependencies each time. For this reason,
> this mechanism is not suitable for global ordering. (It's like line
> numbers in BASIC.)
> It is probably only useful for representing dependencies between
> two components maintained by the same maintainer.
> 
> I'm against a general-purpose system that makes everything modular.
> It unnecessarily complicates things. If there are processes that
> require strict ordering, especially processes that must be performed
> before each stage as part of the framework, they should be called
> directly from the framework, not via notification callbacks.
> 
> This makes it simpler and more robust to maintain.
> 
> Only the framework's end users should utilize notification callbacks.
> 
> Thank you,
> 
> 

my motivation is to decouple ftrace and klp from module loader and make 
blocking_notifier_chain more generic, but it doesn't become generic 
completely. I understand your and Petr's comments and agree.

Thanks

Best regards

Song

>>
>> Best Regards,
>> Petr
>>
> 
> 


