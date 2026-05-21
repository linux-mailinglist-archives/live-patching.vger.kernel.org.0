Return-Path: <live-patching+bounces-2874-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id mBV5GqBND2rgIwYAu9opvQ
	(envelope-from <live-patching+bounces-2874-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Thu, 21 May 2026 20:23:28 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 060805AAFE8
	for <lists+live-patching@lfdr.de>; Thu, 21 May 2026 20:23:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 551943025C75
	for <lists+live-patching@lfdr.de>; Thu, 21 May 2026 18:17:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 47CF83911CE;
	Thu, 21 May 2026 18:17:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VuyXq1tq"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5C7A37EFF6
	for <live-patching@vger.kernel.org>; Thu, 21 May 2026 18:17:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779387422; cv=none; b=MkvP5RtgJArJNhbBMgkiN5nNUejDTy3Jp0CQ2yjwp1fLHqO+hr5Rvq0bFca/RjG7+5CmBPfeZ2DoFNZGjeolvTy0O3wgZe4155oFXEIj+57vmmkXs36XvYy5sFeIPIwTl8Jt1uxLIp5m4cjHMZTcmJXkouM4B4go/JdRVcAz6ig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779387422; c=relaxed/simple;
	bh=+VWCLDENbyTrufBDf5/wO7Oma9uH1Q8L65+rax8aTO4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=C7iMf9t2bdSDu2SA8d/+68uJB172tHNC7pg2vh33AKqeBRntYXQhI9572aqc2Hcnbqk2PttfPjQEE3O+dlL1SRKOExq0GeE84Wv+jukjJhx0bgGFExjjOYWFsNaFuezN5X8XXxp1JDkkwylm32qNrNsG6n9r8e1tQGp23Uhzh3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VuyXq1tq; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 853891F01568
	for <live-patching@vger.kernel.org>; Thu, 21 May 2026 18:17:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779387420;
	bh=+VWCLDENbyTrufBDf5/wO7Oma9uH1Q8L65+rax8aTO4=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=VuyXq1tqiHVI2YZ3Blv3BD2WCJdC9/dUivuyWddy+wydX2ooJe2bkg9Gm9++B3oEo
	 sh0UdIEN9umrNBhjufrQIqRV3lx0D0GA8Sb7poWd0s8udQW6ciJHHeZHcCK3RrRCoQ
	 bGWOb0NZbLBqj12BfjSZwfav5msDWT0Qq2t7Gmh4n2mSLQTSilf1F8j/1uecoi0PwC
	 ncOg8TwZYbC16t5C2LBE0N1MO/fsA442mc1wd4TmR96Jef0gJGQbZWXmNtulPenO/u
	 aQc0Km8pCckySifBInQIQvxQgvVAFm6CPvp2h04FbPQVgYDV+qLBCdJy5FkQDlrlXV
	 Lr+UDPJcnr6hQ==
Received: by mail-vs1-f49.google.com with SMTP id ada2fe7eead31-631a7868228so4457284137.0
        for <live-patching@vger.kernel.org>; Thu, 21 May 2026 11:17:00 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ9eINmxlR8mO1KogJC6xj0tAjLtRvTkNupZXTmr8PSzG2IvlA7GuvwNK5efAPtbBzZ/5aBXabV/hUzJ30E+@vger.kernel.org
X-Gm-Message-State: AOJu0Yxg0ExLlEv5pGJHofvfQEVWepEamjDMeGCIHeje0Zl/gWOQqDTD
	KBzWukndeO9XcVhsxPowVZLwkmUIWP/naO5Binsrsqh6xvS/JRahEsxOmzzH1oWCcxuAfk3aRh8
	/H3sVNqCvYhmuC8T5t+oF0WnNOtPEJ8s=
X-Received: by 2002:a05:6102:5a9a:b0:631:28c1:154e with SMTP id
 ada2fe7eead31-6739772de2emr3100077137.16.1779387419475; Thu, 21 May 2026
 11:16:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260508195749.1885522-1-sashal@kernel.org> <20260517134858.146569-1-sashal@kernel.org>
 <CAPhsuW4x8shWon8Moi5VgCq2n4E2EzaaauZ2HHpy42Rp1Y-J-g@mail.gmail.com>
 <agsVDqdALBoHEHlv@laps> <CAPhsuW44UX663Au=WwHz8MVwnQgLkjxOqpJSCKxNiv3=RpZvqw@mail.gmail.com>
 <b342c38b-7323-4b72-a239-8a574d6bc36b@iogearbox.net> <agzAwjKhOhuANz_P@laps>
 <3dd6d852-18fb-4c64-a1ae-0d79ef7c061f@iogearbox.net> <ag8lOe6dAOgnWmsQ@laps>
In-Reply-To: <ag8lOe6dAOgnWmsQ@laps>
From: Song Liu <song@kernel.org>
Date: Thu, 21 May 2026 11:16:46 -0700
X-Gmail-Original-Message-ID: <CAPhsuW7sbt5B+ZeGW8O2JMJ0ELPU-vhZFNvbB+0Q8XhZg6pKYw@mail.gmail.com>
X-Gm-Features: AVHnY4Ihdl75axpqRxaDxb23j1ycahjc8W-Yta5RRqXxUzFNMBCHqx-JtojbAKM
Message-ID: <CAPhsuW7sbt5B+ZeGW8O2JMJ0ELPU-vhZFNvbB+0Q8XhZg6pKYw@mail.gmail.com>
Subject: Re: [PATCH v3] killswitch: add per-function short-circuit mitigation primitive
To: Sasha Levin <sashal@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	bpf@vger.kernel.org, live-patching@vger.kernel.org, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Jonathan Corbet <corbet@lwn.net>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Joshua Peisach <jpeisach@ubuntu.com>, Florian Weimer <fw@deneb.enyo.de>, Breno Leitao <leitao@debian.org>, 
	Anthony Iliopoulos <ailiop@suse.com>, Michal Hocko <mhocko@suse.com>, Jiri Olsa <jolsa@kernel.org>, 
	John Fastabend <john.fastabend@gmail.com>, Christian Brauner <brauner@kernel.org>, 
	KP Singh <kpsingh@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20260515];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-2874-lists,live-patching=lfdr.de];
	FREEMAIL_CC(0.00)[iogearbox.net,vger.kernel.org,linuxfoundation.org,linux-foundation.org,lwn.net,efficios.com,ubuntu.com,deneb.enyo.de,debian.org,suse.com,kernel.org,gmail.com];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[20];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel.org:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[song@kernel.org,live-patching@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo,mail.gmail.com:mid]
X-Rspamd-Queue-Id: 060805AAFE8
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Thu, May 21, 2026 at 8:31=E2=80=AFAM Sasha Levin <sashal@kernel.org> wro=
te:
>
> On Thu, May 21, 2026 at 11:11:16AM +0200, Daniel Borkmann wrote:
> >On 5/19/26 9:57 PM, Sasha Levin wrote:
> >>Sure, this would also work. How do you see this happening? Can we let a=
 certain
> >>user/pid/etc disable the allowlist if they choose to?
> >
> >I don't think we should, given then we're back to square one where root
> >or some other user would be able to just override/bypass an LSM.
>
> killswitch already disables itself when lockdown is active. We can easily
> disable it too when one of the LSMs that cares about this is active.
>
> >[...]
> >>How do you see this working with the allowlist?
> >
> >We should look at the underlying areas where most of the CVE-like fixes
> >took place (these days should be more easily doable given Claude and fri=
ends)
> >and based on that either extend ALLOW_ERROR_INJECTION() or (better) crea=
te
> >new hooks which BPF LSM can consume where you can then have a policy to =
reject
> >requests and tighten the attack surface. For example, the AF_ALG stuff y=
ou
>
> So we could grow the LSM tentacles deeper into the kernel, and we can see=
 where
> current CVEs are happening, which I suspect is the darker corners of the =
kernel
> (old unmaintained, rarely used code), but this definitely won't stay the =
case,
> right? Newer and better LLMs will discover issues elsewhere, and once the=
 low
> hanging fruits are picked off of the current target subsystems, researche=
rs
> will move elsewhere. We will be dooming ourselves to an endless cat and m=
ouse
> game where we go add LSM hooks after some big security issue goes public.

Do we really need to add new LSM hooks for recent CVEs?

The LSM hooks are designed to cover all the user-kernel interfaces. Then
with properly designed policies, we should have coverage for potential CVEs=
.
Existing LSM hooks may not be perfect, but we can improve the hooks,
potentially with the help of smart LLMs, so that these hooks can cover
future security issues. In some cases, we will need new policies, but I don=
't
think new hooks will be needed for most of these CVEs.

Thanks,
Song

