Return-Path: <live-patching+bounces-2537-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id YFbRBF3n62nNSgAAu9opvQ
	(envelope-from <live-patching+bounces-2537-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Fri, 24 Apr 2026 23:57:49 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 7DF50463A19
	for <lists+live-patching@lfdr.de>; Fri, 24 Apr 2026 23:57:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id E8EBF302307E
	for <lists+live-patching@lfdr.de>; Fri, 24 Apr 2026 21:57:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6776135F197;
	Fri, 24 Apr 2026 21:57:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sZNHky0n"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 448553469E7
	for <live-patching@vger.kernel.org>; Fri, 24 Apr 2026 21:57:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777067865; cv=none; b=CkA/8rOxhnW/Mq8MHdCFmHTOrJDcMG+gOfP+RJGGal0YpIdOrB0HtTJ/W96ng+OflFWhdnHL7Mfs0xzKc7ZjMGbiSxZ2SXAQ9vh2NR0wTK8ZbV4RYRrWik+nLHxla16T4BK1U7jSvnKNCeJ9qDPJ73Q8mCq63YCIVqBb7kGeMTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777067865; c=relaxed/simple;
	bh=GnDzj5cF6ucTN07JN2/+n/kkhEI9S/gFWq3qYA4NhII=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ujZOHvZ54Owfs1gUKyFkrzqvYyEfDaUB9t7d2QOcXlJu3IAPl6GwwUKSgfOc0z3YGGYbBKH47w81EYhBvAk5z8k/jMQ4HMvo+JZqMZRQLEk/f1vD1yWPaaa/z2jU1iWwZlXZYtF57EjhrwsGrkhkgIDhi6bEfn8GiyKeXeoXxss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sZNHky0n; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E74CFC2BCB0
	for <live-patching@vger.kernel.org>; Fri, 24 Apr 2026 21:57:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777067864;
	bh=GnDzj5cF6ucTN07JN2/+n/kkhEI9S/gFWq3qYA4NhII=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=sZNHky0n1jjWP58k4G9l3PeC+ryWYXBfzUDQi01cBF3vlMdXY4wmt+k8CCeoEk3d+
	 HVldElhcclC7BWo4w/XWpm7FX1HnUNB/HBj1/GVr7aYDcr0ooYEO0CGdOODRoIa1EI
	 qWi7EZT5V8zYeN9XFPy8xOn4O3HD49WG0ddsUCwbRRAHrzKUJGfgUKzGsdMFf1qISu
	 SpYu7epkKRYwPa3pFkgcXCG8DPGuMlrnaQehyK2L7A8wyMqWYqml5hjfFtUiKgU0ds
	 G5nYz1WolDWiIkl5DFcSvUeWf639g12Ve/BYeE1QEGErSzmfrRxh34DqMHKBgxRHLr
	 DHBq0QibCt8iQ==
Received: by mail-qv1-f50.google.com with SMTP id 6a1803df08f44-8a1e1817db6so65985306d6.2
        for <live-patching@vger.kernel.org>; Fri, 24 Apr 2026 14:57:44 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ967l+SOU+1OJHAqKd7yWXm1m5SWQ9e9Euy9fPX05VsiqK346WtoAjBlTbypi5EP+rQVaUHHWGrSmx0DPlz@vger.kernel.org
X-Gm-Message-State: AOJu0YwQ3Vx7Q50eCqFF4k539yIpPAKkROZiwGjKsDRtOoMlu6Y53uHs
	6sOn99A088XolaxWGI/FLlaPXDoxacyap0zwplv6XJ5OR0zkVVWoM8QuMx+QbKVjW62+66uALvG
	XtPNBo7NM8LmE4bKz4d/3RU2ZSamueKE=
X-Received: by 2002:a05:6214:419a:b0:89c:4985:83e3 with SMTP id
 6a1803df08f44-8b028168addmr500462886d6.49.1777067864126; Fri, 24 Apr 2026
 14:57:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1776916871.git.jpoimboe@kernel.org> <f5ad8c1b51ba95187f0ed48f2f82056c8320337e.1776916871.git.jpoimboe@kernel.org>
In-Reply-To: <f5ad8c1b51ba95187f0ed48f2f82056c8320337e.1776916871.git.jpoimboe@kernel.org>
From: Song Liu <song@kernel.org>
Date: Fri, 24 Apr 2026 14:57:32 -0700
X-Gmail-Original-Message-ID: <CAPhsuW5PMLskD4Q=VfLwRcB75zN8TtzyegnpK17zOR3vs8YaxA@mail.gmail.com>
X-Gm-Features: AQROBzB2LrbSAsjZInyDPORQe_Gh3mK02xdWFAnf-wPaueWXCYZsykYvTg2ophA
Message-ID: <CAPhsuW5PMLskD4Q=VfLwRcB75zN8TtzyegnpK17zOR3vs8YaxA@mail.gmail.com>
Subject: Re: [PATCH 25/48] klp-build: Reject patches to realmode
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, 
	live-patching@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, 
	Joe Lawrence <joe.lawrence@redhat.com>, Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 7DF50463A19
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2537-lists,live-patching=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[song@kernel.org,live-patching@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	RCPT_COUNT_SEVEN(0.00)[8];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[live-patching];
	TO_DN_SOME(0.00)[]

On Wed, Apr 22, 2026 at 9:04=E2=80=AFPM Josh Poimboeuf <jpoimboe@kernel.org=
> wrote:
>
> Realmode code is compiled as a separate 16-bit binary and embedded into
> the kernel image via rmpiggy.S.  It can't be livepatched.
>
> Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>

Acked-by: Song Liu <song@kernel.org>

