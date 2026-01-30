Return-Path: <live-patching+bounces-1937-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id eACpBjAEfWmRPwIAu9opvQ
	(envelope-from <live-patching+bounces-1937-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Fri, 30 Jan 2026 20:19:12 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 85DA8BE0F2
	for <lists+live-patching@lfdr.de>; Fri, 30 Jan 2026 20:19:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 9E570304323C
	for <lists+live-patching@lfdr.de>; Fri, 30 Jan 2026 19:19:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D0C31388841;
	Fri, 30 Jan 2026 19:18:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NfWqeBcR"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD0613876DC
	for <live-patching@vger.kernel.org>; Fri, 30 Jan 2026 19:18:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769800738; cv=none; b=MLm5mnXJ8kw0O2vTMVpxqz/Isj4wIV/pMQ7lk1dmoBMbnC71twUmFXUSHPSouVlTRRf8Qfx0PL1DthDg62/0ELoJahW48InY/VmiK1JbZF3cu3zpSht7JYBX93BFkjISJvwOn22XxKmEEBk42Rj4FtdAokUALCYGZ+Aoj6y3slc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769800738; c=relaxed/simple;
	bh=jBDHNLhPSDPNI4AbE5ag4bUDeI7gjHm+uG+HB1MsGQE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JUe4pHF3EOx/vqVP6wQlvwUB7EjGkEmPmsaQUxAUSIt3MsPWlzcUj5rC9bowSPme9sD59BSUAW3gn7k0IFn23g0puovwkAuSFE+urgdu+3km/7dQY4o2xXciy5WIBSZtWwhRMnpWt5EJZCY8IDRdFuzeATDhwS07ZC4HZoYH27Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NfWqeBcR; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C53CC19421
	for <live-patching@vger.kernel.org>; Fri, 30 Jan 2026 19:18:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769800738;
	bh=jBDHNLhPSDPNI4AbE5ag4bUDeI7gjHm+uG+HB1MsGQE=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=NfWqeBcRUtz4qKA+e9pNAHCCM52ISCDhDQjpR4K/mxaiIlVbiHZ4jIOCmIgo8Mq/c
	 2iEcZkYOgYteqSSjhR10YLKB3E/L+VvdZbbGNn1GrhBj079UANGPL0UdeW9DouBzD9
	 13mssTu2+1QPX1z8KEOdBQhEigC6y0OGM05BjwePGLz8dV+9qB+ZX+QY74GCWVUxY6
	 L5rebnd0z98xu7K9mR7GNkNHTFI7xbvL/QjC9vd28aBIiVNZOqWlH7AtDumxD868Mk
	 /llriU+5YU5CqMEUfcSaNJXknE2oknEIHJibDU+CWVGQ1dEthUnYKlk/Y+rekutn+8
	 EYVv6AibJfTjw==
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-8c5349ba802so247852185a.1
        for <live-patching@vger.kernel.org>; Fri, 30 Jan 2026 11:18:58 -0800 (PST)
X-Gm-Message-State: AOJu0YymV2oLoYt8jGpfLYIRv8fKkeJdWh7M9XIMyVGbSXyin/YGUebW
	uAhWIvpwyJT/OlV56nUk/Cfx6b/gBLElCkjSYIZVRJnTYUfFuXX3dqdAVsbq+JG7dU2a7G+9Tsv
	/5/DI4rGZHPG8wGuq1CnWAy20AKUCdTw=
X-Received: by 2002:a05:620a:4706:b0:828:aff4:3c03 with SMTP id
 af79cd13be357-8c9eb30f3e7mr493652485a.61.1769800737441; Fri, 30 Jan 2026
 11:18:57 -0800 (PST)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260130175950.1056961-1-joe.lawrence@redhat.com>
In-Reply-To: <20260130175950.1056961-1-joe.lawrence@redhat.com>
From: Song Liu <song@kernel.org>
Date: Fri, 30 Jan 2026 11:18:46 -0800
X-Gmail-Original-Message-ID: <CAPhsuW5qrueccM123YbTo2ZvP-Rf+0UT-goG6c5A8gXw7BsF3w@mail.gmail.com>
X-Gm-Features: AZwV_QgRcbW3j62_Tv1Rl-XhxL_QNxqxedxwrdY17bYn-MdLOabsSBXD16BW4FA
Message-ID: <CAPhsuW5qrueccM123YbTo2ZvP-Rf+0UT-goG6c5A8gXw7BsF3w@mail.gmail.com>
Subject: Re: [PATCH 0/5] objtool/klp-build: small fixups and enhancements
To: Joe Lawrence <joe.lawrence@redhat.com>
Cc: live-patching@vger.kernel.org, Josh Poimboeuf <jpoimboe@kernel.org>, 
	Jiri Kosina <jikos@kernel.org>, Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-1937-lists,live-patching=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	RCPT_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[song@kernel.org,live-patching@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[live-patching];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,mail.gmail.com:mid]
X-Rspamd-Queue-Id: 85DA8BE0F2
X-Rspamd-Action: no action

On Fri, Jan 30, 2026 at 10:00=E2=80=AFAM Joe Lawrence <joe.lawrence@redhat.=
com> wrote:
>
> Hi Josh,
>
> While porting over some internal tests to use klp-build, I tripped over
> a few small usability bugs and nits.  These are aren't show-stoppers,
> but a few were pretty esoteric to debug and might lead some users down
> similar rabbit holes.
>
> Look for per-patch failure messages and reproducers in the individual
> patch diffstat areas.  LMK if any of those details should make it into
> the commit messages as I assumed they were only interesting for
> reviewing context.

The commit messages look good to me. We can add some of those
extra contexts in selftests.

For the set
Acked-by: Song Liu <song@kernel.org>

