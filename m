Return-Path: <live-patching+bounces-2283-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id YDw4Onelz2mZyQYAu9opvQ
	(envelope-from <live-patching+bounces-2283-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Fri, 03 Apr 2026 13:33:11 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 628A6393B77
	for <lists+live-patching@lfdr.de>; Fri, 03 Apr 2026 13:33:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 83EF3309284D
	for <lists+live-patching@lfdr.de>; Fri,  3 Apr 2026 11:30:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E1AF3B8BC4;
	Fri,  3 Apr 2026 11:30:08 +0000 (UTC)
X-Original-To: live-patching@vger.kernel.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2F4C3B4EA1;
	Fri,  3 Apr 2026 11:30:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775215807; cv=none; b=o7D0lafbnzss5a/+G0PROgWbGAIJVBcPEv/SgvqtrmpemMhhUN1m2kQ0n/fmHJC2IshVOKe6OU0xxKby1D29D9AgcVdySsoG4A8VZbwm5DvHd12tYfjra9htAnYC8lWMJbRyiIsecBXCiJkvAc0Mv2pYkZ0tiJS81XrLJkEXQD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775215807; c=relaxed/simple;
	bh=+bACGZwR3pTyJKt3f/V4xj32tZS5f4kSYyW6bb2sbjo=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Sm9D2MYN2sYZOlh31M4EAnkjpxc3EfBNp+tSz+MJ4a7zCske0CkzAu3p/mXyCEhfWYjwDxQf9bDWsBEMbL6jLHr859utfBQNcbqbwBPihAnEFm2m5w5sWdWwWelClMQZ4n49v0sMmUtGR6RHlcfhKLBT+b7ebPAQAMin6BdxfOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 549F7140571;
	Fri,  3 Apr 2026 11:29:55 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf13.hostedemail.com (Postfix) with ESMTPA id C54F22001E;
	Fri,  3 Apr 2026 11:29:50 +0000 (UTC)
Date: Fri, 3 Apr 2026 07:30:55 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Menglong Dong <menglong.dong@linux.dev>
Cc: Yafang Shao <laoar.shao@gmail.com>, jpoimboe@kernel.org,
 jikos@kernel.org, mbenes@suse.cz, pmladek@suse.com,
 joe.lawrence@redhat.com, mhiramat@kernel.org,
 mathieu.desnoyers@efficios.com, kpsingh@kernel.org,
 mattbobrowski@google.com, song@kernel.org, jolsa@kernel.org,
 ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
 martin.lau@linux.dev, eddyz87@gmail.com, memxor@gmail.com,
 yonghong.song@linux.dev, live-patching@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
 bpf@vger.kernel.org
Subject: Re: [RFC PATCH 2/4] trace: Allow kprobes to override livepatched
 functions
Message-ID: <20260403073055.031275d9@gandalf.local.home>
In-Reply-To: <3036842.e9J7NaK4W3@7940hx>
References: <20260402092607.96430-1-laoar.shao@gmail.com>
	<2261072.irdbgypaU6@7950hx>
	<CALOAHbDnNba_w_nWH3-S9GAXw0+VKuLTh1gy5hy9Yqgeo4C0iA@mail.gmail.com>
	<3036842.e9J7NaK4W3@7940hx>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: thm6edwrx6p6hdxzq1uqu3rh133riis7
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX18nlH+catIr+DB29T2c1U5tSY5AzM2ZWME=
X-HE-Tag: 1775215790-410000
X-HE-Meta: U2FsdGVkX1/r7GzplcyS95FkYi+VZUbP1yNjMgUpFmOD3nERkec9sy7V7SPkw+Ay8/FvvonlGSO9LvRWKiMUg77inJV0zMCNmwlKNuY7mO8G0ud9cxC+ldjeLYcMQQBl+sBShuKeGgiulVaYCVcqyZuA0KnNVKRPhpJiFnsxwxq3/S2xKUtUDg2+lErCRM4rYA8eSSKQK642AkWkUPKtMvTiU0yw4zWrbRg98BapoA2ev33Dy3JZSLw6r9k30z0IznoOhwbcYusObeyH5n81voZIXoyYobW+i6W+54/GBJEmDJqaJl8LAmJFKsMvzDVz
X-Spamd-Result: default: False [0.14 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	DMARC_POLICY_SOFTFAIL(0.10)[goodmis.org : SPF not aligned (relaxed), No valid DKIM,none];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCPT_COUNT_TWELVE(0.00)[24];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-2283-lists,live-patching=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com,kernel.org,suse.cz,suse.com,redhat.com,efficios.com,google.com,iogearbox.net,linux.dev,vger.kernel.org];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[rostedt@goodmis.org,live-patching@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	NEURAL_HAM(-0.00)[-0.739];
	TAGGED_RCPT(0.00)[live-patching];
	R_DKIM_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,linux.dev:email,gandalf.local.home:mid]
X-Rspamd-Queue-Id: 628A6393B77
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Fri, 03 Apr 2026 18:25:59 +0800
Menglong Dong <menglong.dong@linux.dev> wrote:

> I think the security problem is a big issue. Image that we have a KLP
> in our environment. Any users can crash the kernel by hook a BPF
> program on it with the calling of bpf_override_write().

Right, livepatching may allow for rapid experimentation but that is not its
purpose. It is for fixing production systems without having to reboot.
Using BPF to change the return of a function is a huge security issue.

> 
> What's more, this is a little weird for me. If we allow to use bpf_override_return()
> for the kernel functions in a KLP, why not we allow it in a common kernel
> module, as KLP is a kind of kernel module. Then, why not we allow to
> use it for all the kernel functions?

Right.

> 
> Can we mark the "bond_get_slave_hook" with ALLOW_ERROR_INJECTION() in
> your example? Then we can override its return directly. This is a more
> reasonable for me. With ALLOW_ERROR_INJECTION(), we are telling people that
> anyone can modify the return of this function safely.

If this were to go in, I say it would require both a kernel config, with
a big warning about this being a security hole, and a kernel command line
option to enable it, so that people don't accidentally have it enabled in
their config.

The command line should be something like:

  allow_bpf_to_rootkit_functions

-- Steve

