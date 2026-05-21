Return-Path: <live-patching+bounces-2872-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id CNVXG94pD2paHQYAu9opvQ
	(envelope-from <live-patching+bounces-2872-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Thu, 21 May 2026 17:50:54 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E3675A8A58
	for <lists+live-patching@lfdr.de>; Thu, 21 May 2026 17:50:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id D45C13166C1E
	for <lists+live-patching@lfdr.de>; Thu, 21 May 2026 15:32:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D8F4C36BCCC;
	Thu, 21 May 2026 15:31:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SkKyGWpi"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CAE6364EA5;
	Thu, 21 May 2026 15:31:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779377467; cv=none; b=tomhQHluBQ57FE/OC7eEfQDFUCwQdAFSb6MyTv2BLPZp2lHge4AWCy8aDZZ4MPIN1D/a8kQhyEV1/pxmcfIAvknxvPFiNJrI+GwR2c1AEpEYhoV7cwudIDyyXxq3N9mm+i2OYGPZBWIIcjrQupTt/4Du6h6phUfLujntI4V/iHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779377467; c=relaxed/simple;
	bh=H6ijgxk2s1Fo45SirC0V9snxZFD/I0UxNcyKfJ3EVJY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BfXXEdniE+kFYfR/A9Fp+SzQhnjMO8kcD+SLnlRSpU4OnaCip558fONRH/upuitIzmM764Oq8n/ZAsIvgpLm/dymOzqWMeZ6ij0BNWURSGx6V+Iu8BXql/6GAQGLdsMd4EYPoTSFZe56InIMnERlYg8c2obhx7tEfckEg35VoFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SkKyGWpi; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4676B1F000E9;
	Thu, 21 May 2026 15:31:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779377466;
	bh=SzgQopk+OJbawn6MS3++ZN/v/mlrkfJHDvOTVpisjLg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=SkKyGWpiSdHqwlEW5hRU8HF957D2LfgRuejLdlkS3dkYVnNKoDiFha3xy5VruV5pQ
	 teYXwsQBQSLpCH8VREZqyFENDwEo2GGr6hi6pHEIUAmJu+7aF4BMNAJzRn80ujIEwX
	 ZDtFWCyjrTMifEUvFbND7kRHRpsHQBznZZBRf6rTRCX6couB9xqSb1FZ9IgkHwdfN3
	 OUk1MZnJH3l58EQVdpEw0MAGLpTBOaJTMf6q8mhNj+7MpDIgNxTfiFYxcwv+6QcWTh
	 TsuvaKWkGvB4YEZg98ftRP4ds4WvuqpuO+aMVWSFNgEb5mYYrwJ7AuMbu21ag/JM4c
	 idE8BbkP3uUKw==
Date: Thu, 21 May 2026 11:31:05 -0400
From: Sasha Levin <sashal@kernel.org>
To: Daniel Borkmann <daniel@iogearbox.net>
Cc: Song Liu <song@kernel.org>, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org,
	bpf@vger.kernel.org, live-patching@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Joshua Peisach <jpeisach@ubuntu.com>,
	Florian Weimer <fw@deneb.enyo.de>, Breno Leitao <leitao@debian.org>,
	Anthony Iliopoulos <ailiop@suse.com>,
	Michal Hocko <mhocko@suse.com>, Jiri Olsa <jolsa@kernel.org>,
	John Fastabend <john.fastabend@gmail.com>,
	Christian Brauner <brauner@kernel.org>,
	KP Singh <kpsingh@kernel.org>
Subject: Re: [PATCH v3] killswitch: add per-function short-circuit mitigation
 primitive
Message-ID: <ag8lOe6dAOgnWmsQ@laps>
References: <20260508195749.1885522-1-sashal@kernel.org>
 <20260517134858.146569-1-sashal@kernel.org>
 <CAPhsuW4x8shWon8Moi5VgCq2n4E2EzaaauZ2HHpy42Rp1Y-J-g@mail.gmail.com>
 <agsVDqdALBoHEHlv@laps>
 <CAPhsuW44UX663Au=WwHz8MVwnQgLkjxOqpJSCKxNiv3=RpZvqw@mail.gmail.com>
 <b342c38b-7323-4b72-a239-8a574d6bc36b@iogearbox.net>
 <agzAwjKhOhuANz_P@laps>
 <3dd6d852-18fb-4c64-a1ae-0d79ef7c061f@iogearbox.net>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <3dd6d852-18fb-4c64-a1ae-0d79ef7c061f@iogearbox.net>
X-Spamd-Result: default: False [-0.16 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20260515];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-2872-lists,live-patching=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[20];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_CC(0.00)[kernel.org,vger.kernel.org,linuxfoundation.org,linux-foundation.org,lwn.net,efficios.com,ubuntu.com,deneb.enyo.de,debian.org,suse.com,gmail.com];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[sashal@kernel.org,live-patching@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel.org:+];
	TAGGED_RCPT(0.00)[live-patching];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:rdns,sto.lore.kernel.org:helo]
X-Rspamd-Queue-Id: 3E3675A8A58
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Thu, May 21, 2026 at 11:11:16AM +0200, Daniel Borkmann wrote:
>On 5/19/26 9:57 PM, Sasha Levin wrote:
>>Sure, this would also work. How do you see this happening? Can we let a certain
>>user/pid/etc disable the allowlist if they choose to?
>
>I don't think we should, given then we're back to square one where root
>or some other user would be able to just override/bypass an LSM.

killswitch already disables itself when lockdown is active. We can easily
disable it too when one of the LSMs that cares about this is active.

>[...]
>>How do you see this working with the allowlist?
>
>We should look at the underlying areas where most of the CVE-like fixes
>took place (these days should be more easily doable given Claude and friends)
>and based on that either extend ALLOW_ERROR_INJECTION() or (better) create
>new hooks which BPF LSM can consume where you can then have a policy to reject
>requests and tighten the attack surface. For example, the AF_ALG stuff you

So we could grow the LSM tentacles deeper into the kernel, and we can see where
current CVEs are happening, which I suspect is the darker corners of the kernel
(old unmaintained, rarely used code), but this definitely won't stay the case,
right? Newer and better LLMs will discover issues elsewhere, and once the low
hanging fruits are picked off of the current target subsystems, researchers
will move elsewhere. We will be dooming ourselves to an endless cat and mouse
game where we go add LSM hooks after some big security issue goes public.

One question I had here: how would we tackle security issues with BPF itself?

>can already easily cover today ...
>
>#include "vmlinux.h"
>#include <bpf/bpf_helpers.h>
>#include <bpf/bpf_tracing.h>
>
>#define AF_ALG	38
>#define EPERM	1
>
>char _license[] SEC("license") = "Dual BSD/GPL";
>
>SEC("lsm/socket_create")
>int BPF_PROG(block_af_alg, int family, int type, int protocol, int kern)
>{
>	if (family == AF_ALG)
>		return -EPERM;
>	return 0;
>}
>
>... the problem is that distros enable and pull in all sort of crap which
>then non-root could pull in via request_module() as an example; similarly
>for netlink we want to have a BPF LSM policy to parse into netlink requests
>and then reject based on certain attribute matching (both on our todo list)
>which would have helped in case of exotic tc cls/act/qdisc modules to prevent
>them to be pulled from userns. I bet there are a ton more examples once we
>look further into the data.

I definitely agree that BPF is a much nicer hammer than the simple killswitch
implementation. I've actually been (privately) playing with an out of tree
killswitch that also supports BPF. I've pushed the (hacky) code I have to
https://github.com/sashalevin/killswitch , and you can see an example of a BPF
mitigation similar to the one you have above:

https://github.com/sashalevin/killswitch/blob/master/mitigations/cve-2025-21703.sh

My concern is mostly with the whitelist approach.

-- 
Thanks,
Sasha

