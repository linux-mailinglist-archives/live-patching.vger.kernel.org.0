Return-Path: <live-patching+bounces-2047-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id vaX5EOZ6lmmcgAIAu9opvQ
	(envelope-from <live-patching+bounces-2047-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Thu, 19 Feb 2026 03:52:22 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D27B15BC99
	for <lists+live-patching@lfdr.de>; Thu, 19 Feb 2026 03:52:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id C979B30209ED
	for <lists+live-patching@lfdr.de>; Thu, 19 Feb 2026 02:52:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF7652367B3;
	Thu, 19 Feb 2026 02:52:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CGp4gx4h"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A7A31C84A0
	for <live-patching@vger.kernel.org>; Thu, 19 Feb 2026 02:52:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771469538; cv=none; b=cz9DTSv0LmbRCyGAaoeuc6AXJxTyGKsvKxqgNOBIyCV4XeKB2uwSKU/LZ6CxEx5rAf3/a4gDQgXqKKxzpjPlNohA5pOJ4/3i+kTMq/6/4l8BEcdgUwrSgSCVqvrUxoW5w8FdGOlZt66E9Y1ZDPxtFCuoJch5JBWkciiEBae5k7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771469538; c=relaxed/simple;
	bh=5tECyJNXcPD8dUadmqVWAoKZnLUB6EqH1KLZtDQXwfE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KGxTWfiS3M0pYuhNvKpfGqw6GvBa4tIVt0+LbcO4WRVFq7/CiPU4qXpU9qZgCoQAfF+L0yvhoP4ZYUZl8Wg5JshomK6ThfDJsy40A7a19aytcqFFbg1w9Sm/nkHakW4TWERDaMIVyJmgKqCjoTmdiILG4skniCZ82sMp2kKH/yA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CGp4gx4h; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C6CFC2BC87
	for <live-patching@vger.kernel.org>; Thu, 19 Feb 2026 02:52:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771469538;
	bh=5tECyJNXcPD8dUadmqVWAoKZnLUB6EqH1KLZtDQXwfE=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=CGp4gx4hnSLj/ZUDteaBVJIf/cPyqW+rKJ3GukAnjua5iFVHLdNpIPKySAGYxXt30
	 Lm9uEcqpvJjLmjniyQn0tkaYn1snHbKSMNUB5QuSzFakQp2fD4YlEZfn/2ShKPY6fx
	 DoykFiOQ43fWxtGuTPMSPWL+bGZqxrOQ7aECMwLv81yrF19bTlO379osYaQvIPDvjd
	 ToWP1T9nFW0YnEl/uabiXmB+QXwael/SPjRwFTNr+1R2uGzLbe90NRDaCaieYvY4mA
	 82QNp5HpGWnbqekspkDUmGRP8I7do3f438fWUbzYhEoxmCWLSjRkSOjaIN8DaT8l8o
	 A9EEShnN5v1ZQ==
Received: by mail-qk1-f174.google.com with SMTP id af79cd13be357-8cb4acdacb2so56579785a.3
        for <live-patching@vger.kernel.org>; Wed, 18 Feb 2026 18:52:18 -0800 (PST)
X-Gm-Message-State: AOJu0YxmfXDv7cz3ARXHsCAHTA6YFOxC5o8RKpTzJEms4w3UYP8ASCBN
	TlmUzBHiyPjYQ6W7GkE2jV8r4U8RqPiy0AQcWUINSz19zERmTBzs1gzOCWVL0ZWf29VbvZ5yDZu
	gFf6foum/wa91qDPnbpCWsZUINDK8kc0=
X-Received: by 2002:a05:620a:2a0e:b0:8b2:e922:529a with SMTP id
 af79cd13be357-8cb4bf871d3mr1979471185a.19.1771469537149; Wed, 18 Feb 2026
 18:52:17 -0800 (PST)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260217160645.3434685-1-joe.lawrence@redhat.com>
 <20260217160645.3434685-10-joe.lawrence@redhat.com> <aZSUfFUfpUYIbuiA@redhat.com>
 <CAPhsuW55E-T0gg4zFitjVB81+y5wHPEQ0665MDPnznV9=9Y1+g@mail.gmail.com> <aZXVCIuSdlk6f-1K@redhat.com>
In-Reply-To: <aZXVCIuSdlk6f-1K@redhat.com>
From: Song Liu <song@kernel.org>
Date: Wed, 18 Feb 2026 18:52:05 -0800
X-Gmail-Original-Message-ID: <CAPhsuW6rcwiqXWdG8SbMrNgj4fnYYRo_qxWgtOprx0x0i6Kuyg@mail.gmail.com>
X-Gm-Features: AaiRm517xyOZBi04rQMb-c7AZqQi9cAppkfbSHXWCUfDx246QgMdJGgncozNIT8
Message-ID: <CAPhsuW6rcwiqXWdG8SbMrNgj4fnYYRo_qxWgtOprx0x0i6Kuyg@mail.gmail.com>
Subject: Re: [PATCH v3 09/13] livepatch/klp-build: fix version mismatch when short-circuiting
To: Joe Lawrence <joe.lawrence@redhat.com>
Cc: live-patching@vger.kernel.org, Josh Poimboeuf <jpoimboe@kernel.org>, 
	Jiri Kosina <jikos@kernel.org>, Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel.org:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2047-lists,live-patching=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MISSING_XM_UA(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[song@kernel.org,live-patching@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[live-patching];
	NEURAL_HAM(-0.00)[-0.999];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6]
X-Rspamd-Queue-Id: 5D27B15BC99
X-Rspamd-Action: no action

On Wed, Feb 18, 2026 at 7:04=E2=80=AFAM Joe Lawrence <joe.lawrence@redhat.c=
om> wrote:
>
> On Tue, Feb 17, 2026 at 11:25:13AM -0800, Song Liu wrote:
> > On Tue, Feb 17, 2026 at 8:17=E2=80=AFAM Joe Lawrence <joe.lawrence@redh=
at.com> wrote:
> > >
> > [...]
> > > > 2.53.0
> > > >
> > > >
> > >
> > > Maybe I'm starting to see things, but when running 'S 2' builds, I ke=
ep
> > > getting "vmlinux.o: changed function: override_release".  It could be
> > > considered benign for quick development work, or confusing.  Seems ea=
sy
> > > enough to stash and avoid.
> >
> > "-S 2" with a different set of patches is only needed in patch developm=
ent,
> > but not used for official releases. Therefore, I agree this is not a re=
al issue.
> >
>
> My use case was running a series of tests:
>
>   (test 1) - full build with -T
>   (test N) - short circuit with -S 2 -T
>   ...
>
> and where it confused me was that I had created tests which were
> designed to fail, specifically one wanted to verify no changes found
> for the recountdiff change in this set.
>
> Without this patch, that test will succeed as the version glitch gets
> picked up as:
>
>   vmlinux.o: changed function: override_release
>
> I could work around that in verification, but then I miss the *specific*
> failure report from klp-build.  I could also run each individual test as
> full, but each build was taking ~6 minutes on my machine.

Agreed that saving ~6 minutes per test is huge.

I think we can ship this.

Acked-by: Song Liu <song@kernel.org>

