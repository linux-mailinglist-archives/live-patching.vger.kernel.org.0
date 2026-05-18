Return-Path: <live-patching+bounces-2843-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id GFeGN8m0Cmpp6AQAu9opvQ
	(envelope-from <live-patching+bounces-2843-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Mon, 18 May 2026 08:42:17 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A4CFF566D92
	for <lists+live-patching@lfdr.de>; Mon, 18 May 2026 08:42:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 5D1E13031CB0
	for <lists+live-patching@lfdr.de>; Mon, 18 May 2026 06:37:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A31D93DA7C2;
	Mon, 18 May 2026 06:37:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tpomMW39"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF62C3CD8CA
	for <live-patching@vger.kernel.org>; Mon, 18 May 2026 06:37:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779086269; cv=none; b=DVuoI/3YQAWs0/nkx1mFwgZ5CbPlb6Ny+sVorH/xv9rKb1GcadjLw0JW3coubvpIw+1VGYMdP5W3NzVskM1oIoN97oBv85EJSePX/THTJTnecACq0Qod3VJpZHzxctf92H3XcrAqKLy05UOmHne6DvGWLEv5Tm0h585nbt62OD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779086269; c=relaxed/simple;
	bh=PrT96Y/vLV0Zld5NPvnbzDiOZRpJnR9HPYAVqBrX/a4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Tx4iBNNAGop/KJRquILbndXI6zUKQ890XWZhKgDHWRbfB0/Gxj9llEr2Qa2yUJ8Ay4r/epYBZHGzCCrHBHy4FH6eJLJj4npWOOdP39p+Zox3vykeVpnvKTLJfkf5auCmJEJO0rpaCFvm5QCrKO9LUHqxGscGCw7y40ENgXvI30c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tpomMW39; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A9A6C2BCF5
	for <live-patching@vger.kernel.org>; Mon, 18 May 2026 06:37:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779086268;
	bh=PrT96Y/vLV0Zld5NPvnbzDiOZRpJnR9HPYAVqBrX/a4=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=tpomMW39Z+QDBMxf/W2OlOg6wDPsPG25eOFCJTVwmHzccb84gLd4cO9h/QGw+/gZD
	 GAsyRzMtDEKon2j700Sa96994l4RBypdbX+Z/ROuYRHDIRkNIs7PVMgpO2psMCgcwS
	 2t/OpakfWgVJNjObHzxYCPZeUX1OMgBcyZAmFBeqZJI8ZQPbs9TA7w75y153t7kFIY
	 U4Nz8gtYhQA87sytwD1i4vdRJs+8httO/jezAxwxirFI7fVHXjf8PslP3/4Ha1H/rD
	 0ww/W+yedO4WQcrdCNfDtEKxT4hiBLWOWmBOjlqa1yZYDkX0cDbHrrybjue+LRS2o7
	 z2/3a+RWPiTBw==
Received: by mail-qv1-f42.google.com with SMTP id 6a1803df08f44-8b3d6b215cfso38654406d6.3
        for <live-patching@vger.kernel.org>; Sun, 17 May 2026 23:37:48 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ9HZS8qrPQa+ng+zYhe19BDdTlEi/nZ0VWzXjAk5OH/On6PRXJYDp8a3ai68u/s/UNA5mqyUpVw5I5x0MIY@vger.kernel.org
X-Gm-Message-State: AOJu0YxxRW2psXvKG+pio5z2NmKQhkLjQwDYblODy3lPEdRSjspIxzLP
	y3isgAulTCN2g80VL7hPyepWcaHzqcEWNjQgZ78dxcIClyDsiMbrC/6ILLs59EY9yjYBJHFTT6i
	CwBk6D+ZpdcnJ9XYY6l2Psbecrtxeps4=
X-Received: by 2002:a05:6214:3c98:b0:8ca:2410:4b05 with SMTP id
 6a1803df08f44-8ca2410535fmr151166296d6.40.1779086267702; Sun, 17 May 2026
 23:37:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260508195749.1885522-1-sashal@kernel.org> <20260517134858.146569-1-sashal@kernel.org>
In-Reply-To: <20260517134858.146569-1-sashal@kernel.org>
From: Song Liu <song@kernel.org>
Date: Sun, 17 May 2026 23:37:36 -0700
X-Gmail-Original-Message-ID: <CAPhsuW4x8shWon8Moi5VgCq2n4E2EzaaauZ2HHpy42Rp1Y-J-g@mail.gmail.com>
X-Gm-Features: AVHnY4J4mKBEhL8yoe8m_C50zE8fB-yoG9ZDQzbqPScq3MxagdnowtQVIUF5N1M
Message-ID: <CAPhsuW4x8shWon8Moi5VgCq2n4E2EzaaauZ2HHpy42Rp1Y-J-g@mail.gmail.com>
Subject: Re: [PATCH v3] killswitch: add per-function short-circuit mitigation primitive
To: Sasha Levin <sashal@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, bpf@vger.kernel.org, 
	live-patching@vger.kernel.org, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Jonathan Corbet <corbet@lwn.net>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Joshua Peisach <jpeisach@ubuntu.com>, Florian Weimer <fw@deneb.enyo.de>, Breno Leitao <leitao@debian.org>, 
	Anthony Iliopoulos <ailiop@suse.com>, Michal Hocko <mhocko@suse.com>, Jiri Olsa <jolsa@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: A4CFF566D92
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-2843-lists,live-patching=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	RCPT_COUNT_TWELVE(0.00)[16];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[song@kernel.org,live-patching@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[live-patching];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Action: no action

On Sun, May 17, 2026 at 6:49=E2=80=AFAM Sasha Levin <sashal@kernel.org> wro=
te:
>
> When a kernel (security) issue goes public, fleets stay exposed until a p=
atched
> kernel is built, distributed, and rebooted into.
>
> For many such issues the simplest mitigation is to stop calling the buggy
> function. Killswitch provides that. An admin writes:
>
>     echo "engage af_alg_sendmsg -1" \
>         > /sys/kernel/security/killswitch/control
>
> After this, af_alg_sendmsg() returns -EPERM on every call without
> running its body. The mitigation takes effect immediately, and is dropped=
 on
> the next reboot -- by which point a patched kernel is hopefully in place.
>
> A lot of recent kernel issues sit in code paths most installs only have e=
nabled
> to support a relative minority of users: AF_ALG, ksmbd, nf_tables, vsock,=
 ax25,
> and friends.
>
> For most users, the cost of "this socket family stops working for the day=
" is
> much smaller than the cost of running a known vulnerable kernel until the=
 fix
> lands.
>
> Why not an existing facility:
>
> * livepatch needs a built, signed, per-kernel-version module per CVE.
>   Under Secure Boot the operator can't sign their own, so they wait
>   for the vendor, and only a minority of vendors actually ship
>   livepatches. Killswitch covers the days before that module shows
>   up.
>
> * fail_function (CONFIG_FUNCTION_ERROR_INJECTION) is disabled in
>   most production kernels. Even where enabled, it only works on
>   functions pre-annotated with ALLOW_ERROR_INJECTION() in source -
>   no help for a freshly-disclosed CVE. The debugfs UI is blocked by
>   lockdown=3Dintegrity and the override is probabilistic.
>
> * BPF override (bpf_override_return) honors the same
>   ALLOW_ERROR_INJECTION() whitelist, and BPF itself is off in many
>   production kernels. Even where on, the operator interface is
>   "load a verified BPF program," not a one-line write.

If it is OK for killswitch to attach to any kernel functions, do we still
need ALLOW_ERROR_INJECTION() for fail_function and BPF
override? Shall we instead also allow fail_function and BPF override
to attach to any kernel functions?

Thanks,
Song

