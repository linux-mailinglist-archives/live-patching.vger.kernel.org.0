Return-Path: <live-patching+bounces-2891-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 0JaPO5awFWpxYAcAu9opvQ
	(envelope-from <live-patching+bounces-2891-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Tue, 26 May 2026 16:39:19 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id AB0DE5D7BF2
	for <lists+live-patching@lfdr.de>; Tue, 26 May 2026 16:39:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 2EB8C3061DF8
	for <lists+live-patching@lfdr.de>; Tue, 26 May 2026 14:29:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 59F393FF1D6;
	Tue, 26 May 2026 14:29:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EzsWz/vl"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A05B3FF1AB;
	Tue, 26 May 2026 14:29:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779805787; cv=none; b=AUc5MNpjfYJLd9hFWghdGyk54Ry0pxtYN4CLMwfXQ56mLdFKOSrU81ME70q3qMDpc3R5RwvbJh3BTNo3iCIxb486dS3kJQtsuWKYQX24pIUocgxs0k2Kgij5ULalyfjHg1VI+P4azaIuZ9Q2FADLWEH9eduU3FU5Ih79+n1TcIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779805787; c=relaxed/simple;
	bh=01QZ3Oc+k3R391wthpsoqAJ4A4j9P7bKR8UG9T3xXXo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GKJewTHD96pW9neIFhdR92mobyLjNtcTYZSdmdGQSY4pAFXP+l6pBsQmpd+IrTIYWkFYWa7ivmjlQfpSYYArIvLuCz0VhDrYBERngxlUpUGDjDnGHMfBZSvHryFg6PXuS7RLoq0VXEfqQfrlCVtI1n3yuvcdOLkUbtfQXa4tymA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EzsWz/vl; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76D741F000E9;
	Tue, 26 May 2026 14:29:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779805785;
	bh=GSX/o3tGKH8prhZQKAGSjMb4rUlV/Z55PxckME59z4U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=EzsWz/vlNWJNW+NMA+grSpGmEAlzW1dMhzljG4DDGQOP42grQ3eEtdXE+yg/tu0nJ
	 e2v3LjX3uBcVx2JXnnVCBQNmCVQI7uLKvZgmd7Nxrd6B+jZBk85BEhu6L9hr4AWOhN
	 DmVXv8lzXWvF/wiKNTotwFW8EP7Ra+ZA35C0sV8SMVdKBC9j5ntx1+ijctMD6qQYF9
	 3qUB2mKBtFBdFI85Oqtg3YjaU1gaQYfEjc1plhfWPXZUkEMZg3O4ZfPw+YIn8ZesD3
	 5FkFfGfwX6V0F/bhrOcnpOSpiV6QT7FJQ6li+thvYCff9a1ujIZiIrS55YWerf7k2a
	 Zd7p7PpJbHEkA==
Date: Tue, 26 May 2026 10:29:44 -0400
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
Message-ID: <ahWuWBrZlFsAVZo2@laps>
References: <CAPhsuW4x8shWon8Moi5VgCq2n4E2EzaaauZ2HHpy42Rp1Y-J-g@mail.gmail.com>
 <agsVDqdALBoHEHlv@laps>
 <CAPhsuW44UX663Au=WwHz8MVwnQgLkjxOqpJSCKxNiv3=RpZvqw@mail.gmail.com>
 <b342c38b-7323-4b72-a239-8a574d6bc36b@iogearbox.net>
 <agzAwjKhOhuANz_P@laps>
 <3dd6d852-18fb-4c64-a1ae-0d79ef7c061f@iogearbox.net>
 <ag8lOe6dAOgnWmsQ@laps>
 <CAPhsuW7sbt5B+ZeGW8O2JMJ0ELPU-vhZFNvbB+0Q8XhZg6pKYw@mail.gmail.com>
 <ahGufsGqmLZZQL4M@laps>
 <e7464a71-7e97-44a9-a5eb-831306fb5019@iogearbox.net>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e7464a71-7e97-44a9-a5eb-831306fb5019@iogearbox.net>
X-Spamd-Result: default: False [-0.16 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20260515];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-2891-lists,live-patching=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[20];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_CC(0.00)[kernel.org,vger.kernel.org,linuxfoundation.org,linux-foundation.org,lwn.net,efficios.com,ubuntu.com,deneb.enyo.de,debian.org,suse.com,gmail.com];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[sashal@kernel.org,live-patching@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel.org:+];
	TAGGED_RCPT(0.00)[live-patching];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo]
X-Rspamd-Queue-Id: AB0DE5D7BF2
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Tue, May 26, 2026 at 03:10:45PM +0200, Daniel Borkmann wrote:
>On 5/23/26 3:41 PM, Sasha Levin wrote:
>>On Thu, May 21, 2026 at 11:16:46AM -0700, Song Liu wrote:
>>>On Thu, May 21, 2026 at 8:31 AM Sasha Levin <sashal@kernel.org> wrote:
>>>>On Thu, May 21, 2026 at 11:11:16AM +0200, Daniel Borkmann wrote:
>>>>>On 5/19/26 9:57 PM, Sasha Levin wrote:
>>>>>>Sure, this would also work. How do you see this happening? Can we let a certain
>>>>>>user/pid/etc disable the allowlist if they choose to?
>>>>>
>>>>>I don't think we should, given then we're back to square one where root
>>>>>or some other user would be able to just override/bypass an LSM.
>>>>
>>>>killswitch already disables itself when lockdown is active. We can easily
>>>>disable it too when one of the LSMs that cares about this is active.
>>>>
>>>>>[...]
>>>>>>How do you see this working with the allowlist?
>>>>>
>>>>>We should look at the underlying areas where most of the CVE-like fixes
>>>>>took place (these days should be more easily doable given Claude and friends)
>>>>>and based on that either extend ALLOW_ERROR_INJECTION() or (better) create
>>>>>new hooks which BPF LSM can consume where you can then have a policy to reject
>>>>>requests and tighten the attack surface. For example, the AF_ALG stuff you
>>>>
>>>>So we could grow the LSM tentacles deeper into the kernel, and we can see where
>>>>current CVEs are happening, which I suspect is the darker corners of the kernel
>>>>(old unmaintained, rarely used code), but this definitely won't stay the case,
>>>>right? Newer and better LLMs will discover issues elsewhere, and once the low
>>>>hanging fruits are picked off of the current target subsystems, researchers
>>>>will move elsewhere. We will be dooming ourselves to an endless cat and mouse
>>>>game where we go add LSM hooks after some big security issue goes public.
>>>
>>>Do we really need to add new LSM hooks for recent CVEs?
>>>
>>>The LSM hooks are designed to cover all the user-kernel interfaces. Then
>>>with properly designed policies, we should have coverage for potential CVEs.
>>>Existing LSM hooks may not be perfect, but we can improve the hooks,
>>>potentially with the help of smart LLMs, so that these hooks can cover
>>>future security issues. In some cases, we will need new policies, but I don't
>>>think new hooks will be needed for most of these CVEs.
>>
>>Running a quick LLM evaluation on the last ~70 severe CVEs, it seems that about
>>40% is doable with the current hooks.
>
>
>Interesting, do you have some more details in which areas your eval sees new
>lsm hooks missing?

The recent ones I saw fall into about 5 buckets:

1. Kernel-thread / workqueue context: LSM hooks fire but current is a worker,
not the actual attacker. Lots of ksmbd, ceph-msgr, and async cleanup races land
here.

2. Driver: pci_driver.probe, notifier_call_chain, ib_* RDMA callbacks, ndo_*,
bus dispatch tables all sit below any LSM hook. Big chunk of mlx5, RDMA, USB,
i3c, DRM bugs.

3. Per-packet softirq RX: security_sock_rcv_skb only fires inside
sk_filter_trim_cap, which UDP encap_rcv bypasses and L2/bridge protocols never
reach. Covers Bluetooth softirq, bond, IPv6 softirq, TCP-MD5/AO timing leaks,
etc.

4. Netfilter: config path is well-gated via security_netlink_send, but
per-match callbacks, set GC, and flowtable cleanup have nothing. That's where
most of the recent netfilter CVEs actually fire.

5. Crypto subsystem + io_uring per-opcode: crypto/ has zero LSM hooks.

-- 
Thanks,
Sasha

