Return-Path: <live-patching+bounces-2501-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id PjNXAByQ6mkz0wIAu9opvQ
	(envelope-from <live-patching+bounces-2501-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Thu, 23 Apr 2026 23:33:16 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 5131D457E89
	for <lists+live-patching@lfdr.de>; Thu, 23 Apr 2026 23:33:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id DCA0330131ED
	for <lists+live-patching@lfdr.de>; Thu, 23 Apr 2026 21:33:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 23C5A332EA0;
	Thu, 23 Apr 2026 21:33:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AahsqLWk"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00A1326ADC
	for <live-patching@vger.kernel.org>; Thu, 23 Apr 2026 21:33:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776979993; cv=none; b=ah67dVEStHaOjqJXtj9rD63PzGPVguqDEM1xIJyWhr55iB3oNaEEqehm78SnrrErONpKUaj/hUZuyjEinewW9szIZYyrN3TbM8XYE6YV+UBEAUJd+NwMX4h1bxA6kyBoQ5AZyiyrEtM7HvA0gncwV6RVtTOJvoBem43IjqTdPu0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776979993; c=relaxed/simple;
	bh=mtKwd0qCq0YBC9CGimRIDoa5meSx99Zg1tgpnx84zX8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jT3xw6gMs8IFop5ev27DnIFWolpgCqOkB0gs8Uwe0/f+fl0y1SbhdBomPBTWv0uH5xQv7qRYSfsa1zG+3ppXHfaK8CeGdx7q7DHvEVTe8vrUT6NmDOViDDLFJGhGxfhKgTko39OO4ksY70/mnyiOs8EJnj77LGRYxz0RNR6d9qw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AahsqLWk; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C6DCC2BCB8
	for <live-patching@vger.kernel.org>; Thu, 23 Apr 2026 21:33:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776979992;
	bh=mtKwd0qCq0YBC9CGimRIDoa5meSx99Zg1tgpnx84zX8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=AahsqLWkWWhMFQVdEQ4Znae7VK8LyYINjjnHmOXcfy6Z4pZT0UoX+0gKP50CmBQjc
	 tQ3fMn7xT5Khj/3Wz8V1h9uNQiOBGw4/o7x1sYrQGgbpZ8mvg6jbQTzEO1XgWV8QsX
	 m9ZcjgznhkH7oHWd/z/1eWuWSgRJ2XaF0mSmYvaiHJS5BlY1a5DsyJtvnlcv0GZh//
	 dYdukSygfEeDQX8YVghkMLvJYfW20knuw/49OuuPpJcI+qTKb2JeRwSwE8JtcjfEYA
	 ZA/6bkatkk6DQx/HVcT9Z7banpAH5X486HCLzYVAfXeDae1wFpa0yiucgvuOPu6Tqr
	 qoXWQLekoRvBw==
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-8eea23d01f7so185450985a.0
        for <live-patching@vger.kernel.org>; Thu, 23 Apr 2026 14:33:12 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ8PLQp6Hbsj2Zezyh7QbIJfpy6SQ4uWA9e0Qlbj3nhuk3dXfI1RT5g3KpkkOwXrrp3JAlcWltB3ZG4q7o0V@vger.kernel.org
X-Gm-Message-State: AOJu0YyXaJB9OvpnqjOzAELcMfr3NdNE4nJ4VNnlXUKpL7qDV56wep1J
	84XlRBuJPsdQcRDrRbknlo2RL10tJakBMj3REnSYpNravYictTWW15miPYJ1HlKm5vH6UohG+O9
	/kh7KzBn10WoE/9XnyEVqpewNtqNO8gE=
X-Received: by 2002:a05:620a:649b:b0:8ea:b4d3:b19c with SMTP id
 af79cd13be357-8eab4d3b2d6mr2711019385a.28.1776979991792; Thu, 23 Apr 2026
 14:33:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1776916871.git.jpoimboe@kernel.org> <93c7c80130375edd22874a57cdea132b0edbb0e4.1776916871.git.jpoimboe@kernel.org>
 <CAPhsuW6_FzbAeqOduv56jZEk2E1xm+RqAxOHdekUHJwezvGOyw@mail.gmail.com> <gmjxp6lzlwjfdp4gf2nktoqfwrdx4bapf2mnnezo2gjyjj6yqf@if35zh3xa7t6>
In-Reply-To: <gmjxp6lzlwjfdp4gf2nktoqfwrdx4bapf2mnnezo2gjyjj6yqf@if35zh3xa7t6>
From: Song Liu <song@kernel.org>
Date: Thu, 23 Apr 2026 14:33:00 -0700
X-Gmail-Original-Message-ID: <CAPhsuW6VWk43z+BYCYRxo56w-4VKw8W3nmvVfCLh=ouN7a2Cqg@mail.gmail.com>
X-Gm-Features: AQROBzAhumUQqFXSWIF7qWwlD30cIAYoff5V7kLdQDLFIT7Su6cUH0sUdTf4qeU
Message-ID: <CAPhsuW6VWk43z+BYCYRxo56w-4VKw8W3nmvVfCLh=ouN7a2Cqg@mail.gmail.com>
Subject: Re: [PATCH 04/48] objtool/klp: Ignore __UNIQUE_ID_*() PCI stub functions
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, 
	live-patching@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, 
	Joe Lawrence <joe.lawrence@redhat.com>, Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel.org:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2501-lists,live-patching=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MISSING_XM_UA(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[song@kernel.org,live-patching@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[live-patching];
	RCPT_COUNT_SEVEN(0.00)[8];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 5131D457E89
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Thu, Apr 23, 2026 at 12:31=E2=80=AFPM Josh Poimboeuf <jpoimboe@kernel.or=
g> wrote:
>
> On Thu, Apr 23, 2026 at 12:05:03PM -0700, Song Liu wrote:
> > On Wed, Apr 22, 2026 at 9:04=E2=80=AFPM Josh Poimboeuf <jpoimboe@kernel=
.org> wrote:
> > >
> > > With Clang LTO enabled, DECLARE_PCI_FIXUP_SECTION() uses __UNIQUE_ID(=
)
> > > to generate uniquely named wrapper functions, which are being reporte=
d
> > > as new functions and unnecessarily included in the patch module:
> > >
> > >   vmlinux.o: new function: __UNIQUE_ID_quirk_f0_vpd_link_661
> > >
> > > These stub functions only exist to make the compiler happy.  Just ign=
ore
> > > them along with any other dont_correlate() symbols.  Note that
> > > dont_correlate() already includes prefix functions.
> > >
> > > Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
> >
> > The actual change appears to be much bigger than the subject line.
> > Maybe rephrase it a bit?
>
> Hm, in fact this is a relic from a previous iteration of the patches: it
> longer fixes what it claims to fix, as __UNIQUE_ID_ (other than
> __ADDRESSABLE()) are now correlated.  The claimed issue actually gets
> fixed later by the rewriting of the correlation algorithm.
>
> That said, I still think the below is needed, I just need to rewrite the
> commit log.

Agreed.

Thanks,
Song

