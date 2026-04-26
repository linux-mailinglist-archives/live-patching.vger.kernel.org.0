Return-Path: <live-patching+bounces-2556-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id UJusHNAa7mm/qgAAu9opvQ
	(envelope-from <live-patching+bounces-2556-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Sun, 26 Apr 2026 16:01:52 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C54AD46A395
	for <lists+live-patching@lfdr.de>; Sun, 26 Apr 2026 16:01:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 17C25300E733
	for <lists+live-patching@lfdr.de>; Sun, 26 Apr 2026 14:01:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AEDBA363C7F;
	Sun, 26 Apr 2026 14:01:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=126.com header.i=@126.com header.b="Gfz8tGph"
X-Original-To: live-patching@vger.kernel.org
Received: from m16.mail.126.com (m16.mail.126.com [117.135.210.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F8A52BEC43;
	Sun, 26 Apr 2026 14:01:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777212101; cv=none; b=fNnxC8e632xyBtRjul6WKexVSm1iRXuWMiB0cSshCoYsBqKAQ/E/K1CUXzjHCnyCYjPyf5qOvpP+qmZZ63HLjOkzfvuphtEm8lhovqgW72NGcpAgGEeRFkMyEEEjUWgK4W7AoMkn7LtNG39pQn+8PWCXOrYOyu441ayAL42zkqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777212101; c=relaxed/simple;
	bh=1EWd3FHK/NUyYRjrPUv26hddlhWeaeFiowafrqz4J6I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PQ3YRqbiWlw5FZ7K5ZFEGH8ys41/9ZkPkKTZQUMeRfJuRZqizloPsX8zsInnqNLdizKEcCqA0ja41TNAvs4ziBMVmKPwd8zbrX1oY6aID1/szGjLjaGVtBKzmhCI9bfHY5gSFZif51/hZCDtRIhJRYMGUJmT/PB2Mpvd0J0iPQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=126.com; spf=pass smtp.mailfrom=126.com; dkim=pass (1024-bit key) header.d=126.com header.i=@126.com header.b=Gfz8tGph; arc=none smtp.client-ip=117.135.210.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=126.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=126.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
	s=s110527; h=Message-ID:Date:MIME-Version:Subject:To:From:
	Content-Type; bh=VObAGbTW+9A0YlT8RDgNBAL8kbf8Bp4GNC/bJiVMM38=;
	b=Gfz8tGph2KWgVIskV7kFH/2JPRot07G06I1K2xbCam83mOtshbvOugP3G7Jyqo
	ai37Dr1ofQD7wUpqZRBL3mxeK1hyR12P/5uwp0yunrzAchjxANOPZenxC08kKLYx
	5hJRvTmihsx0Vyjm1RkYPJzh1rEdFERh8U8wZYoIfh//U=
Received: from [IPV6:2408:8210:480a:2590:ec66:74e8:68a7:a44b] (unknown [])
	by gzsmtp4 (Coremail) with SMTP id PykvCgD3_9WEGe5pvjEhEA--.25861S2;
	Sun, 26 Apr 2026 21:56:23 +0800 (CST)
Message-ID: <30411bd3-2c92-495b-9d87-d6660b5cf3a3@126.com>
Date: Sun, 26 Apr 2026 21:56:20 +0800
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 1/2] kernel/notifier: replace single-linked list with
 double-linked list for reverse traversal
To: Petr Mladek <pmladek@suse.com>, Masami Hiramatsu <mhiramat@kernel.org>
Cc: chensong_2000@189.cn, rafael@kernel.org, lenb@kernel.org,
 mturquette@baylibre.com, sboyd@kernel.org, viresh.kumar@linaro.org,
 agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com,
 bmarzins@redhat.com, song@kernel.org, yukuai@fnnas.com, linan122@huawei.com,
 jason.wessel@windriver.com, danielt@kernel.org, dianders@chromium.org,
 horms@kernel.org, davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
 pabeni@redhat.com, paulmck@kernel.org, frederic@kernel.org,
 mcgrof@kernel.org, petr.pavlu@suse.com, da.gomez@kernel.org,
 samitolvanen@google.com, atomlin@atomlin.com, jpoimboe@kernel.org,
 jikos@kernel.org, mbenes@suse.cz, joe.lawrence@redhat.com,
 rostedt@goodmis.org, mark.rutland@arm.com, mathieu.desnoyers@efficios.com,
 linux-modules@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
 linux-clk@vger.kernel.org, linux-pm@vger.kernel.org,
 live-patching@vger.kernel.org, dm-devel@lists.linux.dev,
 linux-raid@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
 netdev@vger.kernel.org
References: <20260415070137.17860-1-chensong_2000@189.cn>
 <20260420144429.57b45f2beece690bceea96ec@kernel.org>
 <aec90caYZDHDAHgw@pathway.suse.cz>
Content-Language: en-US
From: Song Chen <chensong_2000@126.com>
In-Reply-To: <aec90caYZDHDAHgw@pathway.suse.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:PykvCgD3_9WEGe5pvjEhEA--.25861S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxGr48trW5Xw1rurW8KFy5twb_yoW5Wry5pF
	90gF4SkF4kJr92kFn2gw18WF1Y9FZ5GFWqqr18GrySkwn0grnFvrZrtw15uFykur48Ar12
	vrWUXasru34DZaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07UXyCJUUUUU=
X-CM-SenderInfo: xfkh02prqjsjqqqqqiyswou0bp/xtbBpQd9-GnuGYeunwAA3L
X-Rspamd-Queue-Id: C54AD46A395
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[126.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[126.com:s=s110527];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-2556-lists,live-patching=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[189.cn,kernel.org,baylibre.com,linaro.org,redhat.com,fnnas.com,huawei.com,windriver.com,chromium.org,davemloft.net,google.com,suse.com,atomlin.com,suse.cz,goodmis.org,arm.com,efficios.com,vger.kernel.org,lists.linux.dev,lists.sourceforge.net];
	RCPT_COUNT_TWELVE(0.00)[48];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FREEMAIL_FROM(0.00)[126.com];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[chensong_2000@126.com,live-patching@vger.kernel.org];
	DKIM_TRACE(0.00)[126.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[live-patching];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TO_DN_SOME(0.00)[]

Hi,

On 4/21/26 17:05, Petr Mladek wrote:
> On Mon 2026-04-20 14:44:29, Masami Hiramatsu wrote:
>> Hi Song,
>>
>> On Wed, 15 Apr 2026 15:01:37 +0800
>> chensong_2000@189.cn wrote:
>>
>>> From: Song Chen <chensong_2000@189.cn>
>>>
>>> The current notifier chain implementation uses a single-linked list
>>> (struct notifier_block *next), which only supports forward traversal
>>> in priority order. This makes it difficult to handle cleanup/teardown
>>> scenarios that require notifiers to be called in reverse priority order.
>>
>> What about introducing a new notification callback API that allows you
>> to describe dependencies between callback functions?
>>
>> For example, when registering a callback, you could register a string
>> as an ID and specify whether to call it before or after that ID,
>> or you could register a comparison function that is called when adding
>> to a list. (I prefer @name and @depends fields so that it can be easily
>> maintained.)
> 
> This looks too complex. It would make sense only
> when this API has more users.
> 
> Also this won't be enough for the ftrace/livepatch callbacks.
> They need to be ordered against against each other. But they
> also need to be called before/after all other callbacks.
> For example, when the module is loaded:
> 
>     + 1st frace
>     + 2nd livepatch
>     + then other notifiers
> 
> See the commit c1bf08ac26e92122 ("ftrace: Be first to run code
> modification on modules").
> 
>> This would allow for better dependency building when adding to the list.
>   
>>>
>>> A concrete example is the ordering dependency between ftrace and
>>> livepatch during module load/unload. see the detail here [1].
>>
>> If this only concerns notification callback issues with the ftrace
>> and livepatch modules, it's far more robust to simply call the
>> necessary processing directly when the modules load and unload,
>> rather than registering notification callbacks externally.
>>
>> There are fprobe, kprobe and its trace-events, all of them are using
>> ftrace as its fundation layer. In this case, I always needs to
>> consider callback order when a module is unloaded.
>>
>> If ftrace is working as a part of module callbacks, it will conflict
>> with fprobe/kprobe module callback. Of course we can reorder it with
>> modifying its priority. But this is ugly, because when we introduce
>> a new other feature which depends on another layer, we need to
>> reorder the callback's priority number on the list.
>>
>> Based on the above, I don't think this can be resolved simply by
>> changing the list of notification callbacks to a bidirectional list.
> 
> I agree. I would keep it as is (hardcoded).
> 
> Best Regards,
> Petr
> 


Thanks for the feedback, the necessity doesn't convincing enough. I will 
try the proposal from Masami Hiramatsu.

Best regards,

Song


