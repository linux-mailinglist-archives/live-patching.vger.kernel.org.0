Return-Path: <live-patching+bounces-2520-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id WNGBHZjV62kASAAAu9opvQ
	(envelope-from <live-patching+bounces-2520-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Fri, 24 Apr 2026 22:42:00 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 887EA4633FB
	for <lists+live-patching@lfdr.de>; Fri, 24 Apr 2026 22:41:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 5A3E13009E03
	for <lists+live-patching@lfdr.de>; Fri, 24 Apr 2026 20:41:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 17EA63FB7E1;
	Fri, 24 Apr 2026 20:41:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eEOSnSNQ"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E94383E928A
	for <live-patching@vger.kernel.org>; Fri, 24 Apr 2026 20:41:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777063313; cv=none; b=AVwDLXa55/c2/FfvzHZX53ERmyU/xuWPgSPCbprYQW34JSpri7+d24FxsqIG33NI7fga+Z4RT3Zw44AcS/Pt6qCScyJcIWHADh5+2/hjifOCikVYjQ+6o/Q+NzNiibUC/vCRKulKTl6bHvRidsIFbi4sIeK3/i+dwrKrhb54U64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777063313; c=relaxed/simple;
	bh=TNQ4Axthw9Qbf5yyPfwI8p0cLoQild24n893ka2Ewng=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AqPnp3wmEazzQCl/egDnW0USw2/T9hh0zVmdVQGIaJKyRQV3wR7xv9cz0wJ0x3Rj9hpLNdF0Vs0DBNhRfETVL4DPnJ/PZqSrRcBbQVoXLnb+MaAF9vjsaRnvY8FXTo9AhpHSugt5n4v6Hx9pgyjdIuyv3jiDfCdybl0kIM8bV0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eEOSnSNQ; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A08C8C19425
	for <live-patching@vger.kernel.org>; Fri, 24 Apr 2026 20:41:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777063312;
	bh=TNQ4Axthw9Qbf5yyPfwI8p0cLoQild24n893ka2Ewng=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=eEOSnSNQG4QgSaSC0xt9oODho3hjKRNRZj++EjzaidkwO4KGObcrJYkOjoAH4hx78
	 EIipVwQEwD9ySGQtTYQX3rpdUyKpguqVxpcmbI8wVZ4N0O3rCyfxNr82pSR+zJD13I
	 1kxJefANXTu3TNvo403nU7DI4nWjJlWIHJ1CB2y20ZIn2fbqyA1trblGBxIJDg6SC7
	 d7Zt9jRHfEnltuqsWU95j55Guri3Y9YPwtthBNmCOcFRU8DbaQpYSey7SCH4tix9Fl
	 Td5YUQ+EumeORZXtj1zoSAoKxxTuFQQBcENuPWLUQONn/kI7NZvMI4/jviL9NoGRu6
	 q5uIfva3QAY0w==
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-50d876329bbso93306231cf.2
        for <live-patching@vger.kernel.org>; Fri, 24 Apr 2026 13:41:52 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ/WeGx6gqxt/0pV+OH5gE8EuF8KecUXV+ZhhGO2LCE54InFiuESbk4jfdHUDIlG8ReQK/DsaPE0HSZltGSm@vger.kernel.org
X-Gm-Message-State: AOJu0YzYIRfUcQwkW+Bzl1ys6SH1G7RvTF+bBj6mtndOExVW4xRC9UCR
	ZnZB80Z9BGZRYclYXX04KT1Mmiyze1+nvRt0xnSWoMo5RgwZGfIbHzkRGoX6LoxBOp/YS8wtiye
	yLfABqwNuACZEoegSGcsOcgQxTg3F5l0=
X-Received: by 2002:ac8:5d8b:0:b0:50d:d1ea:65dd with SMTP id
 d75a77b69052e-50e36b6af8emr502963151cf.14.1777063311795; Fri, 24 Apr 2026
 13:41:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1776916871.git.jpoimboe@kernel.org> <c32b3d8d0770c93f8c0d8e4a989f2f43c29e9a5f.1776916871.git.jpoimboe@kernel.org>
In-Reply-To: <c32b3d8d0770c93f8c0d8e4a989f2f43c29e9a5f.1776916871.git.jpoimboe@kernel.org>
From: Song Liu <song@kernel.org>
Date: Fri, 24 Apr 2026 13:41:40 -0700
X-Gmail-Original-Message-ID: <CAPhsuW7DOScR5qC3S9mkoy85r8vgfZ9LqrxOdU6JqMMhHH4F0g@mail.gmail.com>
X-Gm-Features: AQROBzDmFDVGlOEz6E3zb4JMcJGNRdJugs5CpaG2_1woKb9T0X1Jcsz6jIumGLA
Message-ID: <CAPhsuW7DOScR5qC3S9mkoy85r8vgfZ9LqrxOdU6JqMMhHH4F0g@mail.gmail.com>
Subject: Re: [PATCH 05/48] objtool: Move mark_rodata() to elf.c
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, 
	live-patching@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, 
	Joe Lawrence <joe.lawrence@redhat.com>, Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 887EA4633FB
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2520-lists,live-patching=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[song@kernel.org,live-patching@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	RCPT_COUNT_SEVEN(0.00)[8];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[live-patching];
	TO_DN_SOME(0.00)[]

On Wed, Apr 22, 2026 at 9:04=E2=80=AFPM Josh Poimboeuf <jpoimboe@kernel.org=
> wrote:
>
> Move the sec->rodata marking from check.c to elf.c so it's set during
> ELF reading rather than during the check pipeline.  This makes the
> rodata flag available to all objtool users, including klp-diff which
> reads ELF files directly without running check().
>
> Add an is_rodata_sec() helper to elf.h for consistency with
> is_text_sec() and is_string_sec().
>
> Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>

Acked-by: Song Liu <song@kernel.org>

