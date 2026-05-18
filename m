Return-Path: <live-patching+bounces-2849-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id cEAYKNynC2p2KgUAu9opvQ
	(envelope-from <live-patching+bounces-2849-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Tue, 19 May 2026 01:59:24 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 1B1BF5754D8
	for <lists+live-patching@lfdr.de>; Tue, 19 May 2026 01:59:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id DD83D301AA87
	for <lists+live-patching@lfdr.de>; Mon, 18 May 2026 23:59:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2889D33ADA4;
	Mon, 18 May 2026 23:59:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LMS9J5R7"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05FFD330D28
	for <live-patching@vger.kernel.org>; Mon, 18 May 2026 23:59:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779148762; cv=none; b=EzWPBxhspHsrLalbxVpnp1kq/3RPh3FwlAsoSdNGor6NpDaa4rhX8PEsxQGtNcNFr9Dlp7Q8CAlE5H1y6hZylWD4OQnRWJemZKpNkE+OfozK4PLZ11PB3GRCFgX0pCRY38Ta9yX/YH7iusJ5zrRHIRRsn8gaEcCF93ETxSY/gN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779148762; c=relaxed/simple;
	bh=M1jZL+G9PjCkkkoJkmzieqzjSlVxT3vxti9JYkSFRKo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Jl6rMTexpdLXcISWhRt0HT+WMmLhttBIVzc7Hm/g+PsGu02Lr0wYL3TonpWyAN1j8xbkajgGW4gdOgIWOyahwe/Yy0G1ht+Ni4141IXhT/zgZ5gzxM25qGDQrDJB0f//+rL3HISGAqGQubIUjttMp6xoGfGIhtPYYjb09dE8BSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LMS9J5R7; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D58FBC2BCFF
	for <live-patching@vger.kernel.org>; Mon, 18 May 2026 23:59:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779148761;
	bh=M1jZL+G9PjCkkkoJkmzieqzjSlVxT3vxti9JYkSFRKo=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=LMS9J5R74Y+KhosKU43X6aNBZ15H/2hwPBLBcuOSaC0Yt1D4AxYg0lzUmNlf9NYjl
	 oK0uUY9/Q15o0SOU6iuoVhsgfed4Ice2Fj8c4C+0lfov46eh9GXZ3KviodJ9q22/+e
	 xVWCNUUZ9ywlpgZpdnW7sBFY9J9BFtTNmNgIHhV650cm4b+pqa02N6RNKn1rrJM0MB
	 16Z/9dnDm8xU6xGE1qTBCYR9QPEnrvztXcYBl/yGlk4zRkg9tg2hp2LpQV1CIuJiVb
	 z6LxtWKz2u5sKE0m4X7W7/AqAmWxthO8M4Q6Gs0zoEaxNC4qEhjAA3uWkrvG14OEsg
	 RybdGhfHRNd2A==
Received: by mail-qv1-f54.google.com with SMTP id 6a1803df08f44-8b59772d441so38920546d6.0
        for <live-patching@vger.kernel.org>; Mon, 18 May 2026 16:59:21 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ/rYVMH3Wq+shvWgZbBmzUVkSYhF3/qztYPhB7e754BMMCKvTJwRamOLeUsuQ/LeX6ICaz/546TNXoQn5tK@vger.kernel.org
X-Gm-Message-State: AOJu0Yw/nsijDNZgVZF7zPLCHOEDYFzISc1nfhCXARUyuI8qpja3vRAw
	17qdSiAPJiMEb0V17Jno8jNBqlS1YLE9M38lw5wEnTPsPSwbq2xzyo7xWvcsZULtN1lcnDvXk+D
	td3lS4lHj+rw/5ZXrFpTbLJOyw1cJsyw=
X-Received: by 2002:a05:6214:5889:b0:89e:bae9:9d56 with SMTP id
 6a1803df08f44-8ca0f70f638mr325646126d6.45.1779148761045; Mon, 18 May 2026
 16:59:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260508195749.1885522-1-sashal@kernel.org> <20260517134858.146569-1-sashal@kernel.org>
 <CAPhsuW4x8shWon8Moi5VgCq2n4E2EzaaauZ2HHpy42Rp1Y-J-g@mail.gmail.com> <agsVDqdALBoHEHlv@laps>
In-Reply-To: <agsVDqdALBoHEHlv@laps>
From: Song Liu <song@kernel.org>
Date: Mon, 18 May 2026 16:59:08 -0700
X-Gmail-Original-Message-ID: <CAPhsuW44UX663Au=WwHz8MVwnQgLkjxOqpJSCKxNiv3=RpZvqw@mail.gmail.com>
X-Gm-Features: AVHnY4KB_KmZYOh3b7B12VOg51Un_1RpdfIMTYdv8DCrrVz0v7mS0Jk_sQ1HKxI
Message-ID: <CAPhsuW44UX663Au=WwHz8MVwnQgLkjxOqpJSCKxNiv3=RpZvqw@mail.gmail.com>
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
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2849-lists,live-patching=lfdr.de];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[16];
	DKIM_TRACE(0.00)[kernel.org:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[song@kernel.org,live-patching@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo,mail.gmail.com:mid]
X-Rspamd-Queue-Id: 1B1BF5754D8
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Mon, May 18, 2026 at 6:33=E2=80=AFAM Sasha Levin <sashal@kernel.org> wro=
te:
>
> On Sun, May 17, 2026 at 11:37:36PM -0700, Song Liu wrote:
> >On Sun, May 17, 2026 at 6:49=E2=80=AFAM Sasha Levin <sashal@kernel.org> =
wrote:
> >> * fail_function (CONFIG_FUNCTION_ERROR_INJECTION) is disabled in
> >>   most production kernels. Even where enabled, it only works on
> >>   functions pre-annotated with ALLOW_ERROR_INJECTION() in source -
> >>   no help for a freshly-disclosed CVE. The debugfs UI is blocked by
> >>   lockdown=3Dintegrity and the override is probabilistic.
> >>
> >> * BPF override (bpf_override_return) honors the same
> >>   ALLOW_ERROR_INJECTION() whitelist, and BPF itself is off in many
> >>   production kernels. Even where on, the operator interface is
> >>   "load a verified BPF program," not a one-line write.
> >
> >If it is OK for killswitch to attach to any kernel functions, do we stil=
l
> >need ALLOW_ERROR_INJECTION() for fail_function and BPF
> >override? Shall we instead also allow fail_function and BPF override
> >to attach to any kernel functions?
>
> I don't think so. ALLOW_ERROR_INJECTION is not a security mechanism, it's=
 an
> integrity/safety mechanism for both bpf and fault injection.
>
> It protects against a "developer or CI script doing legitimate fault inje=
ction
> accidentally panics the box" scenario, not an "attacker gets in" one.

There really isn't a clear boundary between "security mechanism" and
"non-security mechanism". As we are making killswitch available
everywhere under root, users will soon learn to use it to do fault injectio=
n,
and potentially much more scary things. (Think about agents with sudo
access).

Thanks,
Song

