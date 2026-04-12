Return-Path: <live-patching+bounces-2335-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id CPx8APmn22lEEwkAu9opvQ
	(envelope-from <live-patching+bounces-2335-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Sun, 12 Apr 2026 16:11:05 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 308FB3E4299
	for <lists+live-patching@lfdr.de>; Sun, 12 Apr 2026 16:11:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 4E0E93003377
	for <lists+live-patching@lfdr.de>; Sun, 12 Apr 2026 14:11:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF45F317146;
	Sun, 12 Apr 2026 14:10:59 +0000 (UTC)
X-Original-To: live-patching@vger.kernel.org
Received: from mail.189.cn (189sx01-ptr.21cn.com [125.88.204.37])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C88B1D130E;
	Sun, 12 Apr 2026 14:10:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=125.88.204.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776003059; cv=none; b=Sg2/Ed4KrEVHC98XYAwBGVFSKuAkpifI82sAdsXi8mSVZCJ+wtKCQkee4laj8UNvt0s7eyMfS1HlL8ZXJxEo6kIF442qF3iLCABYqwxI1+OgCpWtWtMT6Q+N/gHZE+LiwbxZbI70Aa43FXdlTcjPP3ugQltFimYudHEFLmzyHN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776003059; c=relaxed/simple;
	bh=tjc5iA5/ozTIRXHnu8IdHTw93PzAQJPc6iB3DoAvfkc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Cofka6B6BOcgDoiDTtjB5NhOYlD7UIWQjBpWTgSGOKJyTLhhSIacrB1R+IboRs29CIpBhm8bSp2fDACUvrjO2P1U8l6TcoDVokkRxYAfl/YYSJCrwthkBJziCYOct1rOzgau+AIfAo96hX0t7ASz7nl72ThR5e4cGYx9Hyyufog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=189.cn; spf=pass smtp.mailfrom=189.cn; arc=none smtp.client-ip=125.88.204.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=189.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=189.cn
HMM_SOURCE_IP:10.158.243.18:0.740051472
HMM_ATTACHE_NUM:0000
HMM_SOURCE_TYPE:SMTP
Received: from clientip-111.162.143.142 (unknown [10.158.243.18])
	by mail.189.cn (HERMES) with SMTP id 39A0840029F;
	Sun, 12 Apr 2026 22:10:46 +0800 (CST)
Received: from  ([111.162.143.142])
	by gateway-153622-dep-76cc7bc9cd-8dbpn with ESMTP id a7f5d2f936e74b1dbc442e4419dc0d7f for pmladek@suse.com;
	Sun, 12 Apr 2026 22:10:48 CST
X-Transaction-ID: a7f5d2f936e74b1dbc442e4419dc0d7f
X-Real-From: chensong_2000@189.cn
X-Receive-IP: 111.162.143.142
X-MEDUSA-Status: 0
Sender: chensong_2000@189.cn
Message-ID: <4037aa19-1b01-4076-b823-5cc0e43becac@189.cn>
Date: Sun, 12 Apr 2026 22:10:45 +0800
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] kernel/trace/ftrace: introduce ftrace module notifier
To: Petr Mladek <pmladek@suse.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Miroslav Benes <mbenes@suse.cz>,
 mcgrof@kernel.org, petr.pavlu@suse.com, da.gomez@kernel.org,
 samitolvanen@google.com, atomlin@atomlin.com, mhiramat@kernel.org,
 mark.rutland@arm.com, mathieu.desnoyers@efficios.com,
 linux-modules@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, live-patching@vger.kernel.org
References: <20260225054639.21637-1-chensong_2000@189.cn>
 <20260225192724.48ed165e@fedora>
 <e18ed5f4-3917-46e7-bca9-78063e6e4457@189.cn>
 <alpine.LSU.2.21.2602261147150.5739@pobox.suse.cz>
 <20260226123014.2197d9b7@gandalf.local.home>
 <321d4670-27cb-453f-a50d-426c83894074@189.cn>
 <aaqk-GrpCTqO36xj@pathway.suse.cz>
Content-Language: en-US
From: Song Chen <chensong_2000@189.cn>
In-Reply-To: <aaqk-GrpCTqO36xj@pathway.suse.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-1.46 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-2335-lists,live-patching=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DMARC_NA(0.00)[189.cn];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[15];
	FREEMAIL_FROM(0.00)[189.cn];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	FROM_HAS_DN(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[chensong_2000@189.cn,live-patching@vger.kernel.org];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	R_DKIM_NA(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	MID_RHS_MATCH_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,189.cn:mid]
X-Rspamd-Queue-Id: 308FB3E4299
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Hi,


在 2026/3/6 17:57, Petr Mladek 写道:
> On Fri 2026-02-27 09:34:59, Song Chen wrote:
>> Hi,
>>
>> 在 2026/2/27 01:30, Steven Rostedt 写道:
>>> On Thu, 26 Feb 2026 11:51:53 +0100 (CET)
>>> Miroslav Benes <mbenes@suse.cz> wrote:
>>>
>>>>> Let me see if there is any way to use notifier and remain below calling
>>>>> sequence:
>>>>>
>>>>> ftrace_module_enable
>>>>> klp_module_coming
>>>>> blocking_notifier_call_chain_robust(MODULE_STATE_COMING)
>>>>>
>>>>> blocking_notifier_call_chain(MODULE_STATE_GOING)
>>>>> klp_module_going
>>>>> ftrace_release_mod
>>>>
>>>> Both klp and ftrace used module notifiers in the past. We abandoned that
>>>> and opted for direct calls due to issues with ordering at the time. I do
>>>> not have the list of problems at hand but I remember it was very fragile.
>>>>
>>>> See commits 7dcd182bec27 ("ftrace/module: remove ftrace module
>>>> notifier"), 7e545d6eca20 ("livepatch/module: remove livepatch module
>>>> notifier") and their surroundings.
>>>>
>>>> So unless there is a reason for the change (which should be then carefully
>>>> reviewed and properly tested), I would prefer to keep it as is. What is
>>>> the motivation? I am failing to find it in the commit log.
>>
>> There is no special motivation, i just read btf initialization in module
>> loading and found direct calls of ftrace and klp, i thought they were just
>> forgotten to use notifier and i even didn't search git log to verify, sorry
>> about that.
>>
>>>
>>> Honestly, I do think just decoupling ftrace and live kernel patching from
>>> modules is rationale enough, as it makes the code a bit cleaner. But to do
>>> so, we really need to make sure there is absolutely no regressions.
>>>
>>> Thus, to allow such a change, I would ask those that are proposing it, show
>>> a full work flow of how ftrace, live kernel patching, and modules work with
>>> each other and why those functions are currently injected in the module code.
>>>
>>> As Miroslav stated, we tried to do it via notifiers in the past and it
>>> failed. I don't want to find out why they failed by just adding them back
>>> to notifiers again. Instead, the reasons must be fully understood and
>>> updates made to make sure they will not fail in the future.
>>
>> Yes, you are right, i read commit msg of 7dcd182bec27, this patch just
>> reverses it simply and will introduce order issue back. I will try to find
>> out the problem in the past at first.
> 
> AFAIK, the root of the problem is that livepatch uses the ftrace
> framework. It means that:
> 
>     + ftrace must be initialized before livepatch gets enabled
>     + livepatch must be disabled before ftrace support gets removed
> 
> My understanding is that this can't be achieved by notifiers easily
> because they are always proceed in the same order.
> 
> An elegant solution would be to introduce  notifier_reverse_call_chain()
> which would process the callbacks in the reverse order. But it might
> be non-trivial:
> 
>    + We would need to make sure that it does not break some
>      existing "hidden" dependencies.
> 
Thanks so much, this is the solution i'm working on. I replaced next 
with a list_head in notifier_block and implemented 
anotifier_call_chain_reverse to address the order issues, like your 
suggestion. And a new robust revision for rolling back.

+static int notifier_call_chain_reverse(struct list_head *nl,
+                    struct notifier_block *start,
+                    unsigned long val, void *v,
+                    int nr_to_call, int *nr_calls)
+{
+    int ret = NOTIFY_DONE;
+    struct notifier_block *nb;
+    bool do_call = (start == NULL);
+
+    if (!nr_to_call)
+        return ret;
+
+    list_for_each_entry_reverse(nb, nl, entry) {
+        if (!do_call) {
+            if (nb == start)
+                do_call = true;
+            continue;
+        }
+#ifdef CONFIG_DEBUG_NOTIFIERS
+        if (unlikely(!func_ptr_is_kernel_text(nb->notifier_call))) {
+            WARN(1, "Invalid notifier called!");
+            continue;
+        }
+#endif
+        trace_notifier_run((void *)nb->notifier_call);
+        ret = nb->notifier_call(nb, val, v);
+
+        if (nr_calls)
+            (*nr_calls)++;
+
+        if (ret & NOTIFY_STOP_MASK)
+            break;
+
+        if (nr_to_call-- == 0)
+            break;
+    }
+    return ret;
+}
+NOKPROBE_SYMBOL(notifier_call_chain_reverse);

I'll send the patches for review soon.

Best regards

Song
>    + notifier_call_chain() uses RCU to process the list of registered
>      callbacks. I am not sure how complicated would be to make it safe
>      in both directions.
> 
> Best Regards,
> Petr
> 
> 

