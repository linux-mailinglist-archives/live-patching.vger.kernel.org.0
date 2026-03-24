Return-Path: <live-patching+bounces-2253-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id aONdLrCfwmm3fQQAu9opvQ
	(envelope-from <live-patching+bounces-2253-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Tue, 24 Mar 2026 15:29:04 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id BC65230A260
	for <lists+live-patching@lfdr.de>; Tue, 24 Mar 2026 15:29:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 88FB1300BE85
	for <lists+live-patching@lfdr.de>; Tue, 24 Mar 2026 14:22:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A8BF53FEB36;
	Tue, 24 Mar 2026 14:22:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="dTlti1ss";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="L1ROqEz8";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="DG6ktTNK";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="kQ68gNe1"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF0293FEB27
	for <live-patching@vger.kernel.org>; Tue, 24 Mar 2026 14:22:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774362155; cv=none; b=BeT9qQjYv6ULXYQN2foYlFClnjwbz4dk5k27gEIE++As6SX+2dvYgpGIHiTl3oxGmFyBhpgTXEATuYgcZBeqWEbbVohQcu+vg4ukfjs7zcpYxxl5zRshmb2cYUWSQpw8FMuvTLUUD9tZVEFQ52cLvK7hlXddH7kn5RkHpTffcuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774362155; c=relaxed/simple;
	bh=l1y+dHz07c8oKvOlkZE/zzGXtSlNqW836W5eAjuV7wU=;
	h=MIME-Version:Content-Type:Subject:From:To:Cc:In-Reply-To:
	 References:Date:Message-Id; b=eahvU6qExi2orpPVvKRftTCxCFZ5nxj3Y1c2E2gBT1A2sO/wFUxuNoENkEgvWTCsmWll4ckALjuKaJVBzO6FObLUurDyqO26mGV+UvQU5a8cuynyQeZ59N9rWbU22KPdEsSCWnb5GtsoulgUx5aQ6MO8ZkxGDwqNVnOkPR30WPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=dTlti1ss; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=L1ROqEz8; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=DG6ktTNK; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=kQ68gNe1; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from localhost.localdomain (unknown [IPv6:2a07:de40:b2bf:1b::12ef])
	by smtp-out1.suse.de (Postfix) with ESMTP id B796D4D1D5;
	Tue, 24 Mar 2026 14:22:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774362150; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0d+miF3FPQ4mJOMemR09EeUmoR4iHBN8H3OEhaM5WMg=;
	b=dTlti1ssZEhc6Q6sHO8lTD+naIXPFRTukwvZlEBC/3d83wIaUbYxohBgvMej67ZAtByPBE
	ifoGJRRfmw1TaFADNzvd22+QaN3wbxy8PhGkEUMU8DRO8omIedpD5R/AQNfKOiyrHu22ha
	/ETwSCL0cN5HDn9XP7iwB/j8am3nFV8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774362150;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0d+miF3FPQ4mJOMemR09EeUmoR4iHBN8H3OEhaM5WMg=;
	b=L1ROqEz81Pz6cC9EJbgpyENkSwWP9QvbreDHdn0i1FDLBkX8fcZukVM5AZDNF5XvfyJpX2
	A3BL7yLKf5pVTzDw==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=DG6ktTNK;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=kQ68gNe1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774362148; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0d+miF3FPQ4mJOMemR09EeUmoR4iHBN8H3OEhaM5WMg=;
	b=DG6ktTNKKcJeLTGylHqjdRXPQtLtkUUxm48/ZlY0OIc2uesL+9cya6bGUWPmoEGzlEGibW
	A+y9PUfI0zzNKfanHLmi/VqVq6/PhLzpRaL3g4HFNgXw/iFwMwv3QzOGQ0R9RIVlUrqDkP
	u7OHqNu52t4twUB2CjKgd8D/DOAezwI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774362148;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0d+miF3FPQ4mJOMemR09EeUmoR4iHBN8H3OEhaM5WMg=;
	b=kQ68gNe1P2i/AT87VeCTrhrwzbBzGSpoR8pSj9Yi6oowad19trQaw4ymKG48emb5pGpO7Y
	V7ZDYthsmR341yDQ==
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] selftests/livepatch: add test for module function
 patching
From: Miroslav Benes <mbenes@suse.cz>
To: Pablo Hugen <phugen@redhat.com>
Cc: live-patching@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 linux-kernel@vger.kernel.org, jpoimboe@kernel.org, jikos@kernel.org, 
 mbenes@suse.cz, pmladek@suse.com, joe.lawrence@redhat.com, shuah@kernel.org
In-Reply-To: <20260320201135.1203992-1-phugen@redhat.com>
References: <20260320201135.1203992-1-phugen@redhat.com>
Date: Tue, 24 Mar 2026 15:22:27 +0100
Message-Id: <177436214729.62466.7977538958560300344.b4-review@b4>
X-Mailer: b4 0.15.0
X-Spamd-Bar: +++++++++++++++++
X-Spam-Flag: YES
X-Spam-Score: 17.39
X-Spam-Level: *****************
X-Spamd-Result: default: False [3.84 / 15.00];
	SPAM_FLAG(5.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FROM_HAS_DN(0.00)[];
	DMARC_NA(0.00)[suse.cz];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2253-lists,live-patching=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[mbenes@suse.cz,live-patching@vger.kernel.org];
	DKIM_TRACE(0.00)[suse.cz:+];
	NEURAL_HAM(-0.00)[-0.981];
	TAGGED_RCPT(0.00)[live-patching];
	RCPT_COUNT_SEVEN(0.00)[10];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:dkim,sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,test-callbacks.sh:url]
X-Rspamd-Queue-Id: BC65230A260
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Fri, 20 Mar 2026 17:11:17 -0300, Pablo Hugen <phugen@redhat.com> wrote:
> Add a target module and livepatch pair that verify module function
> patching via a proc entry. Two test cases cover both the
> klp_enable_patch path (target loaded before livepatch) and the
> klp_module_coming path (livepatch loaded before target).

We sort of test the same in test-callbacks.sh. Just using different
means. I think I would not mind having this as well.

Petr, Joe, what do you think?

>
>
> diff --git a/tools/testing/selftests/livepatch/test_modules/test_klp_mod_target.c b/tools/testing/selftests/livepatch/test_modules/test_klp_mod_target.c
> new file mode 100644
> index 000000000000..9643984d2402
> --- /dev/null
> +++ b/tools/testing/selftests/livepatch/test_modules/test_klp_mod_target.c
> @@ -0,0 +1,39 @@
> [ ... skip 11 lines ... ]
> +
> +static noinline int test_klp_mod_target_show(struct seq_file *m, void *v)
> +{
> +	seq_printf(m, "%s: %s\n", THIS_MODULE->name, "original output");
> +	return 0;
> +}

A nit but is 'noinline' keyword needed here? proc_create_single() below
takes a function pointer so hopefully test_klp_mod_target_show() stays
even without it?

> +
> +static int test_klp_mod_target_init(void)
> +{
> +	pr_info("%s\n", __func__);
> +	pde = proc_create_single("test_klp_mod_target", 0, NULL,
> +				 test_klp_mod_target_show);

...here.

Otherwise it looks good to me.

-- 
Miroslav


