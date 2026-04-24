Return-Path: <live-patching+bounces-2523-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id MP1HIQ7a62nfSAAAu9opvQ
	(envelope-from <live-patching+bounces-2523-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Fri, 24 Apr 2026 23:01:02 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id DA5E7463628
	for <lists+live-patching@lfdr.de>; Fri, 24 Apr 2026 23:01:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 893E630136BF
	for <lists+live-patching@lfdr.de>; Fri, 24 Apr 2026 21:00:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 606F630FF36;
	Fri, 24 Apr 2026 21:00:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YG1xktcr"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DB7D2EB856
	for <live-patching@vger.kernel.org>; Fri, 24 Apr 2026 21:00:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777064440; cv=none; b=V3TO5jO/YiO8FDmX3Sth5LygO5u7CRlECV9NL1B5VOcR/B5B1IBoOlETfMywOyDJc/0j2c4FNCsDpX8XpLrlNagyZv/ViT5JIMnhrUd0Df7yv/w/1LreXzPEboNqQLX1J8gH8ROQuvnedwh8+Nn91/EHjzXfTEL5LEbjGe1ao/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777064440; c=relaxed/simple;
	bh=ABxeM8DDzY+K3SY5Oq8YR6dcphh8vocHS7cK50hqXwk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uz1y7gbXqUO+JP8FB553XZjF5mvQzrtDKf2SEwNGzq1chM3Dj2CRzYhNX/AdlfQCl9yRWTNbGGGhJtGEJTJCk/6aJhmpMYD2BGjX7679R3eXA6tCEaGdekVe/ySx+1TFrzuXm0bPVi8jz5m6eCLT4pPR9gU/kX8Z59OEYWJIgdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YG1xktcr; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DBECC2BCB6
	for <live-patching@vger.kernel.org>; Fri, 24 Apr 2026 21:00:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777064440;
	bh=ABxeM8DDzY+K3SY5Oq8YR6dcphh8vocHS7cK50hqXwk=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=YG1xktcr5vLj50LqJnqIYsOF3WdarfsH31nHjnBm2FIXZFcwqGl+yhEr7d+4ft1Qe
	 jDicM5paIGXdYfLp55qi3a4J+rwfUbCGITLmmvpgW5tin1+pPfD7Ng0APWG/ixg2cw
	 MFM/++oGCMtB0wWSW7A7RewhUN8rP2I4aKcuG/RnGQq1S8Keo2VoPx3NnUrqB/hXUn
	 IU4hSt9G5bLmdiqJsT7BZk3ue1fF92BZna9tCksEnvp4PxNVA90SG80PQ4yrgZSB7l
	 hHzf/EZPQJugkcb9z1dEbn8Q8pL2u24zQJNhqPSAAPogsGV5jsTWWVA17r0DfxWMf2
	 K+HMwg8WWW2og==
Received: by mail-qk1-f179.google.com with SMTP id af79cd13be357-8ee7ffd738dso473431885a.1
        for <live-patching@vger.kernel.org>; Fri, 24 Apr 2026 14:00:40 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ922jqb2FkXH09Wsiv2KiHNkCBapdabJjOFn9mVPT/6dAoyb1F5jnEB/eOGKnJxhYrpDm2R99tfzaSarcgG@vger.kernel.org
X-Gm-Message-State: AOJu0Yyt1toNuz6f+zGLsVidiUW6lfLcLOT/qsq+RJlzLLMku8Lduz5M
	hJqsCmRMEF9eiH1KyUe3SrAcUyaqpUjmXXI+n5Thbbr6oTnI2rC0B/FlLoon6U3i14r4opKB9dx
	KrjFYUcafYf7Mewc8VFquI8QflX1MVOw=
X-Received: by 2002:ad4:4ee9:0:b0:89c:8a3c:e34f with SMTP id
 6a1803df08f44-8b0286f9e44mr424882516d6.12.1777064439188; Fri, 24 Apr 2026
 14:00:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1776916871.git.jpoimboe@kernel.org> <e10231fce5d8f3f17e4cc7a396a4a8e8d791f994.1776916871.git.jpoimboe@kernel.org>
In-Reply-To: <e10231fce5d8f3f17e4cc7a396a4a8e8d791f994.1776916871.git.jpoimboe@kernel.org>
From: Song Liu <song@kernel.org>
Date: Fri, 24 Apr 2026 14:00:27 -0700
X-Gmail-Original-Message-ID: <CAPhsuW4RudruUWV9piq88C5hMf-BEYJVMQxV_wQG682i6JMJ+g@mail.gmail.com>
X-Gm-Features: AQROBzCYOIf9ENbF0dRGxWHOgK9k75ObNtrek1plnPlkc4g7QuvSi91pru2tlxg
Message-ID: <CAPhsuW4RudruUWV9piq88C5hMf-BEYJVMQxV_wQG682i6JMJ+g@mail.gmail.com>
Subject: Re: [PATCH 09/48] objtool/klp: Fix create_fake_symbols() skipping
 entsize-based sections
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, 
	live-patching@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, 
	Joe Lawrence <joe.lawrence@redhat.com>, Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: DA5E7463628
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2523-lists,live-patching=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[song@kernel.org,live-patching@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	RCPT_COUNT_SEVEN(0.00)[8];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[live-patching];
	TO_DN_SOME(0.00)[]

On Wed, Apr 22, 2026 at 9:04=E2=80=AFPM Josh Poimboeuf <jpoimboe@kernel.org=
> wrote:
>
> From: Joe Lawrence <joe.lawrence@redhat.com>
>
> create_fake_symbols() has two phases: creating symbols from
> ANNOTATE_DATA_SPECIAL entries, and a fallback that uses sh_entsize for
> special sections like .static_call_sites.
>
> When .discard.annotate_data is absent, the function returns early,
> skipping the entsize fallback and silently allowing unsupported
> module-local static call keys through.
>
> Fix it by jumping to the entsize phase instead of returning early.
>
> Fixes: dd590d4d57eb ("objtool/klp: Introduce klp diff subcommand for diff=
ing object files")
> Assisted-by: Claude:claude-4-opus
> Signed-off-by: Joe Lawrence <joe.lawrence@redhat.com>
> Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>

Acked-by: Song Liu <song@kernel.org>

