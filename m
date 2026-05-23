Return-Path: <live-patching+bounces-2875-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id SKBMNKeuEWqHowYAu9opvQ
	(envelope-from <live-patching+bounces-2875-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Sat, 23 May 2026 15:41:59 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 74D3E5BF155
	for <lists+live-patching@lfdr.de>; Sat, 23 May 2026 15:41:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id EDA833014C2B
	for <lists+live-patching@lfdr.de>; Sat, 23 May 2026 13:41:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F57639A077;
	Sat, 23 May 2026 13:41:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IRcsv9km"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1793023815B;
	Sat, 23 May 2026 13:41:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779543681; cv=none; b=V9kg3UF9ofeTsLrLw3vya4dgv8TmPIiOmUtgpDqCJi/F6RsZPUK/EIm5oNENXYQs8Hc6IzaPI48y9+R2VJBmGB2EEVNxhwlQjDT7ySRzQfaeC7Qbtn+CpCW4rOpJzRKEmPZPnM3KX64YJTcLoHGOcWCEmVxmd52XJRBElZhCCDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779543681; c=relaxed/simple;
	bh=sk2rS2Lv1PF2RRNe9kOwphlVomY+tXK7570KQSHZK3M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dGiUsbd+neXg9CDh28+Fyl/gVdP+Nh4uMM33v1kWYfspOodr2N4a6Ivrna4bMILIvjpSQMy++VWb2lNRchty4+HN4mrayMnxOofn/w2yWViZyA2juCskGGDeMtt05smMjEaPiLqOtcQu5BxY21OtHs9WQzTZ9Xk/QbBLPu0lVQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IRcsv9km; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF1F31F000E9;
	Sat, 23 May 2026 13:41:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779543679;
	bh=70OTpdEyi7pV8VNKRGAyBkGpAuAMNqdiEhHF5NzVZa8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=IRcsv9kmml5qrOea+8Afo+4d6ynsz1beiGJDPW5RaXoiThn80vI34Ex1hcfIUXtJj
	 56Z/wD1+LEr1iXtbpSnli5TTxn2A7wThX1ogitv1szuNvZugJtsLUn9c5WQIXQ4uu8
	 oxVyTnaruy9idnikXYMjuY3hLqvax02WUelT6ngXljQsF0+j2kQXKe3yN7PoqEhLLd
	 JZlGGccINLyEV9hEyKFa2sweWhfOiEQsxvgp/TfMnQqmZplcxJdo+/OhxW4Rb5SnfO
	 xVAtExQLn6vMqcFbd+P0tel78f6WY6SDSvLPup8rCOnjUbw3XcniCJ1/l+l25FtBE+
	 yjIO3Tn6ku8Gw==
Date: Sat, 23 May 2026 09:41:18 -0400
From: Sasha Levin <sashal@kernel.org>
To: Song Liu <song@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>, linux-kernel@vger.kernel.org,
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
Message-ID: <ahGufsGqmLZZQL4M@laps>
References: <20260508195749.1885522-1-sashal@kernel.org>
 <20260517134858.146569-1-sashal@kernel.org>
 <CAPhsuW4x8shWon8Moi5VgCq2n4E2EzaaauZ2HHpy42Rp1Y-J-g@mail.gmail.com>
 <agsVDqdALBoHEHlv@laps>
 <CAPhsuW44UX663Au=WwHz8MVwnQgLkjxOqpJSCKxNiv3=RpZvqw@mail.gmail.com>
 <b342c38b-7323-4b72-a239-8a574d6bc36b@iogearbox.net>
 <agzAwjKhOhuANz_P@laps>
 <3dd6d852-18fb-4c64-a1ae-0d79ef7c061f@iogearbox.net>
 <ag8lOe6dAOgnWmsQ@laps>
 <CAPhsuW7sbt5B+ZeGW8O2JMJ0ELPU-vhZFNvbB+0Q8XhZg6pKYw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPhsuW7sbt5B+ZeGW8O2JMJ0ELPU-vhZFNvbB+0Q8XhZg6pKYw@mail.gmail.com>
X-Spamd-Result: default: False [-0.16 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20260515];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-2875-lists,live-patching=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[iogearbox.net,vger.kernel.org,linuxfoundation.org,linux-foundation.org,lwn.net,efficios.com,ubuntu.com,deneb.enyo.de,debian.org,suse.com,kernel.org,gmail.com];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[20];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[sashal@kernel.org,live-patching@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel.org:+];
	TAGGED_RCPT(0.00)[live-patching];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[]
X-Rspamd-Queue-Id: 74D3E5BF155
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Thu, May 21, 2026 at 11:16:46AM -0700, Song Liu wrote:
>On Thu, May 21, 2026 at 8:31 AM Sasha Levin <sashal@kernel.org> wrote:
>>
>> On Thu, May 21, 2026 at 11:11:16AM +0200, Daniel Borkmann wrote:
>> >On 5/19/26 9:57 PM, Sasha Levin wrote:
>> >>Sure, this would also work. How do you see this happening? Can we let a certain
>> >>user/pid/etc disable the allowlist if they choose to?
>> >
>> >I don't think we should, given then we're back to square one where root
>> >or some other user would be able to just override/bypass an LSM.
>>
>> killswitch already disables itself when lockdown is active. We can easily
>> disable it too when one of the LSMs that cares about this is active.
>>
>> >[...]
>> >>How do you see this working with the allowlist?
>> >
>> >We should look at the underlying areas where most of the CVE-like fixes
>> >took place (these days should be more easily doable given Claude and friends)
>> >and based on that either extend ALLOW_ERROR_INJECTION() or (better) create
>> >new hooks which BPF LSM can consume where you can then have a policy to reject
>> >requests and tighten the attack surface. For example, the AF_ALG stuff you
>>
>> So we could grow the LSM tentacles deeper into the kernel, and we can see where
>> current CVEs are happening, which I suspect is the darker corners of the kernel
>> (old unmaintained, rarely used code), but this definitely won't stay the case,
>> right? Newer and better LLMs will discover issues elsewhere, and once the low
>> hanging fruits are picked off of the current target subsystems, researchers
>> will move elsewhere. We will be dooming ourselves to an endless cat and mouse
>> game where we go add LSM hooks after some big security issue goes public.
>
>Do we really need to add new LSM hooks for recent CVEs?
>
>The LSM hooks are designed to cover all the user-kernel interfaces. Then
>with properly designed policies, we should have coverage for potential CVEs.
>Existing LSM hooks may not be perfect, but we can improve the hooks,
>potentially with the help of smart LLMs, so that these hooks can cover
>future security issues. In some cases, we will need new policies, but I don't
>think new hooks will be needed for most of these CVEs.

Running a quick LLM evaluation on the last ~70 severe CVEs, it seems that about
40% is doable with the current hooks.

-- 
Thanks,
Sasha

