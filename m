Return-Path: <live-patching+bounces-2361-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id GAvyNby74GmIlAAAu9opvQ
	(envelope-from <live-patching+bounces-2361-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Thu, 16 Apr 2026 12:36:44 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 627E940CF98
	for <lists+live-patching@lfdr.de>; Thu, 16 Apr 2026 12:36:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 70B61306C877
	for <lists+live-patching@lfdr.de>; Thu, 16 Apr 2026 10:34:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 23CDF3A6406;
	Thu, 16 Apr 2026 10:33:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Yw99Yy5m"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58B7E395D9D
	for <live-patching@vger.kernel.org>; Thu, 16 Apr 2026 10:33:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776335634; cv=none; b=kq/e1IWPpEFqMKvgBUJTdsCmVQs1/W9XGpjEJy2lAWoEc9Qw9y6KuS4CPDShpq2eBHM9ocF4WUDa2+MDYzPXemzRMMqiKcD+q8ZJ6Yb/l4udjE/mdE2NssgnMl0gSwNpW1ISFlNsbb3hR8+06UmJKtbxLOzGRhHhdcpyiJ96xIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776335634; c=relaxed/simple;
	bh=PnkhtnPlWqR69u9/G7kOgPwF0gnYlgcUF1nrMIPg0fc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=e8YiN9s99PKVsrLBcGO3a6sg8BpF9sPBfQZagp4bUh8xv6/GewHa48gj4WIr2iclZO3zlRlaorwWfGbD1yMk1FxXW+UFdQeFY5yTHwOSZhtB5O2P0t4irYk8Z9/tuVMDat/FVlmMJvo+d8ZsqmdiJuyoSt6KBaJVBiUHzP0GNFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Yw99Yy5m; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-483487335c2so85992015e9.2
        for <live-patching@vger.kernel.org>; Thu, 16 Apr 2026 03:33:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1776335627; x=1776940427; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=PFX0kfy1JVc6bVB6CE0bGMq+YH6jFLY5/9CO0YM6hrU=;
        b=Yw99Yy5m7kvN1KSa9pxCJ+rj4LVOuiacf7mjAZ1+hedrfUk5JyPIN6zYHYbyElzPIe
         x9JebNsVvvlrV/hoQwDjPkr/KB/PctEr7qKlO6OLJoafdSkZB9jeLeiL/a4vvE1M0t3/
         om3eA/uaTfwen6E5V1J4ngTZ+wAbgwElWypa4jFVmTWBptmpaTJTIPBbe6XRWVKrTzwu
         tebPL2lxwUgYQLNII1kDn9OyLAGJsxMAwVBH4Hvo76H6AxeHISu9mKkqAdAa5je+hRlh
         rg54EVzzcMHE6qqQpg2GAWy6DRWd74af5HXg0FkOYrlGVCqvUn9fRdyfGdcpNr1UxK7W
         J7gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776335627; x=1776940427;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PFX0kfy1JVc6bVB6CE0bGMq+YH6jFLY5/9CO0YM6hrU=;
        b=oFomV8Btm4omkih7rrisaA+H9hnv+SUh3FhznR0uDp5G26SzdEYW4tDhd7YEb3mmve
         25yoIrWxKQwvJVNcvGMw4P7mqY3mc8p+LQC1bou5v40XQDOdUsZZmyIXuxDCDSO2dw/g
         8xBUpoZ50P/BKDPfEyP0mSpUx8WSQDas/x85/LRY+aIIqMacLnCUtLr7kQ/TIjMRiEFK
         9AGtfzO3zuMcovh1PF+vDdjMI1RdS8HkQjJB5uwRklld3bnFz4Ygo84ANMxTCDhhlQzn
         8E3DslEtWUd+j/rnZ2gYizSCv0CP6Fqcet8zsrSwdV0T6xbKVg0vWlkTj/B++78tu1gg
         wl7w==
X-Forwarded-Encrypted: i=1; AFNElJ9xcx5GbdrEGqCR4L9iRtPOYolxScma0BejcZ7VkvghKNm1GRVSqk+laGbdI/QH6xQlU8ywKK9bg9gOqa40@vger.kernel.org
X-Gm-Message-State: AOJu0Yx+6VV0dUuqYPxVTHOT8SHIqMMa7tIuKsbZhTKI4E/mCxJbp/vh
	x4t0pbhUpJ8Pq+1wVMHLLaoE1ANyh8jSd1bRqj411QOygYulbHYlj2rQEhe9wx0XPuA=
X-Gm-Gg: AeBDietDovVQDwnX2m9H6J2xKR3a2j2Iouxkm2m+LFn9EOZxAZEqqTpcBE6iKxhHhCS
	OsY/6hutsE/22U7zgEmXpuFu8mqrS4kSB1zNuxaJpGkc3eOkh3DcyaWjFdeTway3HbJrUWMODu7
	27gTtkFRP4Rx91/UT3Q9a58z65J3mOT4jZIvPx8rM92BWoJgHU7t1zVrMxrr1+3yPBnZq2pA0AG
	WFRWEgZzsElSNi/hdFTe+PITIgvTCVJaLWbdo6WvLbpnjLhe8Ao6cBjcbtgvtwECgDHAboeH04O
	Q3Tj2SGXyz2MjlYOAskq7IzKdciNV5DNFePt6eHvZpGWWkslM5sRcbC3WE/8XWXASg5hLlGabF/
	ml0QULQ0wkQo2So2wh5/1OJIwRhwWS7JMn9varhYM0DjxzX0Ny5HnoZ59k+cN6hVHrv+Wo2pOzy
	cDcltu2AssNDQn/IVheKm9Zy59Ug==
X-Received: by 2002:a05:600c:3b96:b0:488:b098:b653 with SMTP id 5b1f17b1804b1-488d67f0a8amr350880245e9.13.1776335626808;
        Thu, 16 Apr 2026 03:33:46 -0700 (PDT)
Received: from pathway.suse.cz ([176.114.240.130])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43ead402ee8sm12369872f8f.37.2026.04.16.03.33.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Apr 2026 03:33:46 -0700 (PDT)
Date: Thu, 16 Apr 2026 12:33:43 +0200
From: Petr Mladek <pmladek@suse.com>
To: chensong_2000@189.cn
Cc: rafael@kernel.org, lenb@kernel.org, mturquette@baylibre.com,
	sboyd@kernel.org, viresh.kumar@linaro.org, agk@redhat.com,
	snitzer@kernel.org, mpatocka@redhat.com, bmarzins@redhat.com,
	song@kernel.org, yukuai@fnnas.com, linan122@huawei.com,
	jason.wessel@windriver.com, danielt@kernel.org,
	dianders@chromium.org, horms@kernel.org, davem@davemloft.net,
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
	paulmck@kernel.org, frederic@kernel.org, mcgrof@kernel.org,
	petr.pavlu@suse.com, da.gomez@kernel.org, samitolvanen@google.com,
	atomlin@atomlin.com, jpoimboe@kernel.org, jikos@kernel.org,
	mbenes@suse.cz, joe.lawrence@redhat.com, rostedt@goodmis.org,
	mhiramat@kernel.org, mark.rutland@arm.com,
	mathieu.desnoyers@efficios.com, linux-modules@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
	linux-acpi@vger.kernel.org, linux-clk@vger.kernel.org,
	linux-pm@vger.kernel.org, live-patching@vger.kernel.org,
	dm-devel@lists.linux.dev, linux-raid@vger.kernel.org,
	kgdb-bugreport@lists.sourceforge.net, netdev@vger.kernel.org
Subject: Re: [RFC PATCH 1/2] kernel/notifier: replace single-linked list with
 double-linked list for reverse traversal
Message-ID: <aeC7ByGA5MHBcGQR@pathway.suse.cz>
References: <20260415070137.17860-1-chensong_2000@189.cn>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260415070137.17860-1-chensong_2000@189.cn>
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[suse.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[suse.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[suse.com:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2361-lists,live-patching=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_TO(0.00)[189.cn];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MISSING_XM_UA(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[47];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[pmladek@suse.com,live-patching@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TO_DN_NONE(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,fhfr.pm:email,189.cn:email,suse.com:dkim]
X-Rspamd-Queue-Id: 627E940CF98
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Wed 2026-04-15 15:01:37, chensong_2000@189.cn wrote:
> From: Song Chen <chensong_2000@189.cn>
> 
> The current notifier chain implementation uses a single-linked list
> (struct notifier_block *next), which only supports forward traversal
> in priority order. This makes it difficult to handle cleanup/teardown
> scenarios that require notifiers to be called in reverse priority order.
> 
> A concrete example is the ordering dependency between ftrace and
> livepatch during module load/unload. see the detail here [1].
> 
> This patch replaces the single-linked list in struct notifier_block
> with a struct list_head, converting the notifier chain into a
> doubly-linked list sorted in descending priority order. Based on
> this, a new function notifier_call_chain_reverse() is introduced,
> which traverses the chain in reverse (ascending priority order).
> The corresponding blocking_notifier_call_chain_reverse() is also
> added as the locking wrapper for blocking notifier chains.
> 
> The internal notifier_call_chain_robust() is updated to use
> notifier_call_chain_reverse() for rollback: on error, it records
> the failing notifier (last_nb) and the count of successfully called
> notifiers (nr), then rolls back exactly those nr-1 notifiers in
> reverse order starting from last_nb's predecessor, without needing
> to know the total length of the chain.
> 
> With this change, subsystems with symmetric setup/teardown ordering
> requirements can register a single notifier_block with one priority
> value, and rely on blocking_notifier_call_chain() for forward
> traversal and blocking_notifier_call_chain_reverse() for reverse
> traversal, without needing hard-coded call sequences or separate
> notifier registrations for each direction.
> 
> [1]:https://lore.kernel.org/all
> 	/alpine.LNX.2.00.1602172216491.22700@cbobk.fhfr.pm/
> 
> --- a/include/linux/notifier.h
> +++ b/include/linux/notifier.h
> @@ -53,41 +53,41 @@ typedef	int (*notifier_fn_t)(struct notifier_block *nb,
[...]
>  struct notifier_block {
>  	notifier_fn_t notifier_call;
> -	struct notifier_block __rcu *next;
> +	struct list_head __rcu entry;
>  	int priority;
>  };
[...]
>  #define ATOMIC_INIT_NOTIFIER_HEAD(name) do {	\
>  		spin_lock_init(&(name)->lock);	\
> -		(name)->head = NULL;		\
> +		INIT_LIST_HEAD(&(name)->head);		\

I would expect the RCU variant here, aka INIT_LIST_HEAD_RCU().

> --- a/kernel/notifier.c
> +++ b/kernel/notifier.c
> @@ -14,39 +14,47 @@
>   *	are layered on top of these, with appropriate locking added.
>   */
>  
> -static int notifier_chain_register(struct notifier_block **nl,
> +static int notifier_chain_register(struct list_head *nl,
>  				   struct notifier_block *n,
>  				   bool unique_priority)
>  {
> -	while ((*nl) != NULL) {
> -		if (unlikely((*nl) == n)) {
> +	struct notifier_block *cur;
> +
> +	list_for_each_entry(cur, nl, entry) {
> +		if (unlikely(cur == n)) {
>  			WARN(1, "notifier callback %ps already registered",
>  			     n->notifier_call);
>  			return -EEXIST;
>  		}
> -		if (n->priority > (*nl)->priority)
> -			break;
> -		if (n->priority == (*nl)->priority && unique_priority)
> +
> +		if (n->priority == cur->priority && unique_priority)
>  			return -EBUSY;
> -		nl = &((*nl)->next);
> +
> +		if (n->priority > cur->priority) {
> +			list_add_tail(&n->entry, &cur->entry);
> +			goto out;
> +		}
>  	}
> -	n->next = *nl;
> -	rcu_assign_pointer(*nl, n);
> +
> +	list_add_tail(&n->entry, nl);

I would expect list_add_tail_rcu() here.

> @@ -59,25 +67,25 @@ static int notifier_chain_unregister(struct notifier_block **nl,
>   *			value of this parameter is -1.
>   *	@nr_calls:	Records the number of notifications sent. Don't care
>   *			value of this field is NULL.
> + *	@last_nb:  Records the last called notifier block for rolling back
>   *	Return:		notifier_call_chain returns the value returned by the
>   *			last notifier function called.
>   */
> -static int notifier_call_chain(struct notifier_block **nl,
> +static int notifier_call_chain(struct list_head *nl,
>  			       unsigned long val, void *v,
> -			       int nr_to_call, int *nr_calls)
> +			       int nr_to_call, int *nr_calls,
> +				   struct notifier_block **last_nb)
>  {
>  	int ret = NOTIFY_DONE;
> -	struct notifier_block *nb, *next_nb;
> -
> -	nb = rcu_dereference_raw(*nl);
> +	struct notifier_block *nb;
>  
> -	while (nb && nr_to_call) {
> -		next_nb = rcu_dereference_raw(nb->next);
> +	if (!nr_to_call)
> +		return ret;
>  
> +	list_for_each_entry(nb, nl, entry) {

I would expect the RCU variant here, aka list_for_each_rcu()

These are just two random examples which I found by a quick look.

I guess that the notifier API is very old and it does not use all
the RCU API features which allow to track safety when
CONFIG_PROVE_RCU and CONFIG_PROVE_RCU_LIST are enabled.

It actually might be worth to audit the code and make it right.

>  #ifdef CONFIG_DEBUG_NOTIFIERS
>  		if (unlikely(!func_ptr_is_kernel_text(nb->notifier_call))) {
>  			WARN(1, "Invalid notifier called!");
> -			nb = next_nb;
>  			continue;
>  		}
>  #endif

That said, I am not sure if the ftrace/livepatching handlers are
the right motivation for this. Especially when I see the
complexity of the 2nd patch [*]

After thinking more about it. I am not even sure that the ftrace and
livepatching callbacks are good candidates for generic notifiers.
They are too special. It is not only about ordering them against
each other. But it is also about ordering them against other
notifiers. The ftrace/livepatching callbacks must be the first/last
during module load/release.

[*] The 2nd patch is not archived by lore for some reason.
    I have found only a review but it gives a good picture, see
    https://lore.kernel.org/all/1191caf5-6a61-4622-a15e-854d3701f4fc@suse.com/

Best Regards,
Petr

