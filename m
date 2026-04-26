Return-Path: <live-patching+bounces-2557-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id qAwiFZEe7mlwqwAAu9opvQ
	(envelope-from <live-patching+bounces-2557-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Sun, 26 Apr 2026 16:17:53 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C303946A492
	for <lists+live-patching@lfdr.de>; Sun, 26 Apr 2026 16:17:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 8DFE2300B855
	for <lists+live-patching@lfdr.de>; Sun, 26 Apr 2026 14:17:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 19615364021;
	Sun, 26 Apr 2026 14:17:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=126.com header.i=@126.com header.b="MiHDuQ3a"
X-Original-To: live-patching@vger.kernel.org
Received: from m16.mail.126.com (m16.mail.126.com [117.135.210.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99FBC2236EB;
	Sun, 26 Apr 2026 14:17:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777213064; cv=none; b=SLy6lOZBOWRlcm8xhnOgCmUm3ueuMH6Pzbi4rqqES/u1EkRVKyzScr3MloWphH9nTzBQRFOJNScK8GpS42G0IpXTW8/MvUA/GuTkIkzxaqoai38bxc2YhaQI+BQMVLZ4DDYCl7DFmMfoJC2Om/H0V/uyHeyZ1BXoLCO3fCgmNSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777213064; c=relaxed/simple;
	bh=PpgkP1YKmlbuFUrJNXhMVv1K4LUZT2tLz09Jj+Nnro0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gfQC2aqZalEToTQeUvXFbomjsBRuldvj1Nk1Y6i/6aGZSfkSgvLcS4N+7pwMxjL+TJAHJbDgQDylzgTg0D/s5IgvIse9H7ho7lxJSPtA+9Cm39MvJPhQIH4LATHrP/09tJAtBBETDVt38r/oEkOr04YgVbX9irudt9ODhJTub/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=126.com; spf=pass smtp.mailfrom=126.com; dkim=pass (1024-bit key) header.d=126.com header.i=@126.com header.b=MiHDuQ3a; arc=none smtp.client-ip=117.135.210.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=126.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=126.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
	s=s110527; h=Message-ID:Date:MIME-Version:Subject:To:From:
	Content-Type; bh=buJnxB7ZO086rGZFo2LRvhB0nYMnOVMe4qEqFrdkycM=;
	b=MiHDuQ3aM0w40MkZuRTZDrM885olgYuK7xbsTOXHp4lT/cD7bkwpwZZ5XVkNrZ
	r81nQvRWVagRR3hk6K4kEm4G+n6t/UKXjfxhvevhUatCqlPXKtOEpl8/Yc8ooebv
	GLgKMdGai9+gq1Q85IKLbNypuUgpj9yVPZRD36EWDEneo=
Received: from [IPV6:2408:8210:480a:2590:ec66:74e8:68a7:a44b] (unknown [])
	by gzsmtp4 (Coremail) with SMTP id PykvCgD3X9rhHe5pse0hEA--.31129S2;
	Sun, 26 Apr 2026 22:15:00 +0800 (CST)
Message-ID: <7b73e122-8bca-410d-a14f-a8f55a79305c@126.com>
Date: Sun, 26 Apr 2026 22:14:57 +0800
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 1/2] kernel/notifier: replace single-linked list with
 double-linked list for reverse traversal
To: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: rafael@kernel.org, lenb@kernel.org, mturquette@baylibre.com,
 sboyd@kernel.org, viresh.kumar@linaro.org, agk@redhat.com,
 snitzer@kernel.org, mpatocka@redhat.com, bmarzins@redhat.com,
 song@kernel.org, yukuai@fnnas.com, linan122@huawei.com,
 jason.wessel@windriver.com, danielt@kernel.org, dianders@chromium.org,
 horms@kernel.org, davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
 pabeni@redhat.com, paulmck@kernel.org, frederic@kernel.org,
 mcgrof@kernel.org, petr.pavlu@suse.com, da.gomez@kernel.org,
 samitolvanen@google.com, atomlin@atomlin.com, jpoimboe@kernel.org,
 jikos@kernel.org, mbenes@suse.cz, pmladek@suse.com, joe.lawrence@redhat.com,
 rostedt@goodmis.org, mark.rutland@arm.com, mathieu.desnoyers@efficios.com,
 linux-modules@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
 linux-clk@vger.kernel.org, linux-pm@vger.kernel.org,
 live-patching@vger.kernel.org, dm-devel@lists.linux.dev,
 linux-raid@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
 netdev@vger.kernel.org
References: <20260415070137.17860-1-chensong_2000@189.cn>
 <20260420144429.57b45f2beece690bceea96ec@kernel.org>
Content-Language: en-US
From: Song Chen <chensong_2000@126.com>
In-Reply-To: <20260420144429.57b45f2beece690bceea96ec@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:PykvCgD3X9rhHe5pse0hEA--.31129S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7AF4DuFWxKw45Ww15ZF1DWrg_yoW8KF13pa
	4qgr4fCF4kJr92yFs2qw1xWFyYga95JFWUJF18C34Sywn0gF9FvrWxtw45uFWkCws3Zry2
	9w4UXwnrua4DZaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07UXBMNUUUUU=
X-CM-SenderInfo: xfkh02prqjsjqqqqqiyswou0bp/xtbBpASWFmnuHeTUYwAA3p
X-Rspamd-Queue-Id: C303946A492
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[126.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[126.com:s=s110527];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2557-lists,live-patching=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[47];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[chensong_2000@126.com,live-patching@vger.kernel.org];
	DKIM_TRACE(0.00)[126.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[live-patching];
	MID_RHS_MATCH_FROM(0.00)[];
	FREEMAIL_FROM(0.00)[126.com];
	TO_DN_SOME(0.00)[]

Hi Hiramatsu san,


On 4/20/26 13:44, Masami Hiramatsu (Google) wrote:
> Hi Song,
> 
> On Wed, 15 Apr 2026 15:01:37 +0800
> chensong_2000@189.cn wrote:
> 
>> From: Song Chen <chensong_2000@189.cn>
>>
>> The current notifier chain implementation uses a single-linked list
>> (struct notifier_block *next), which only supports forward traversal
>> in priority order. This makes it difficult to handle cleanup/teardown
>> scenarios that require notifiers to be called in reverse priority order.
> 
> What about introducing a new notification callback API that allows you
> to describe dependencies between callback functions?
> 
> For example, when registering a callback, you could register a string
> as an ID and specify whether to call it before or after that ID,
> or you could register a comparison function that is called when adding
> to a list. (I prefer @name and @depends fields so that it can be easily
> maintained.)
> 
> This would allow for better dependency building when adding to the list.
> 

Is the new notification callback API going to replace 
blocking_notifier_chain in module loader? or an expansion inside 
blocking_notifier_chain but introducing less complexity?
>>
>> A concrete example is the ordering dependency between ftrace and
>> livepatch during module load/unload. see the detail here [1].
> 
> If this only concerns notification callback issues with the ftrace
> and livepatch modules, it's far more robust to simply call the
> necessary processing directly when the modules load and unload,
> rather than registering notification callbacks externally.
> 
> There are fprobe, kprobe and its trace-events, all of them are using
> ftrace as its fundation layer. In this case, I always needs to
> consider callback order when a module is unloaded.
> 
> If ftrace is working as a part of module callbacks, it will conflict
> with fprobe/kprobe module callback. Of course we can reorder it with
> modifying its priority. But this is ugly, because when we introduce
> a new other feature which depends on another layer, we need to
> reorder the callback's priority number on the list.
> 
> Based on the above, I don't think this can be resolved simply by
> changing the list of notification callbacks to a bidirectional list.
> 
> Thank you,
> 

understood, many thanks for your proposal, i will think  about it.

best regards,

Song


