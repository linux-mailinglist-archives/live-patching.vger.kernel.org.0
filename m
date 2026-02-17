Return-Path: <live-patching+bounces-2032-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id IFX1EmCplGlSGQIAu9opvQ
	(envelope-from <live-patching+bounces-2032-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Tue, 17 Feb 2026 18:46:08 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id E8A2F14EB7A
	for <lists+live-patching@lfdr.de>; Tue, 17 Feb 2026 18:46:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 9B7FE3001328
	for <lists+live-patching@lfdr.de>; Tue, 17 Feb 2026 17:46:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C9EA254B1F;
	Tue, 17 Feb 2026 17:46:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="u0vzoI1j"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A3AE1465B4
	for <live-patching@vger.kernel.org>; Tue, 17 Feb 2026 17:46:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771350364; cv=none; b=Zy3kSYA4qtWhaUAm0rXSRFScPsWuMX0/snYHxiqmkQr0F1P5INZQLL2Jev9uv2JVvzdyE/Kqs1ZQJJ5rS4Zkn3Mvm852/ms/R9E/5BODKqGqIPQLdMVFY/M4n4jedSj7Nb9MzzexXVUhMxW3TIi1skfS9OWx/Dp9vyDYeZKXq6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771350364; c=relaxed/simple;
	bh=ERVsghGBtwOhB3huWNbWGDau7P0zo8hA2NtpHY+P0+o=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BtEgR6kw8GmszEW5bvrV0WbNn7og4Ja/Pzr1j4wu1X8EM8YzhkeGknNNC8ZcBqOaMFGMNJzDL6/LsSIJRjFgYFGZrq8FHcLKoalpqKxtRngjZuYa1fj/MkF/Nq5s/gaFjMRx7Yq92Oejx2u6Bb+xcH3xBZG5G2409ze1TzwoRoU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=u0vzoI1j; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A93CC4CEF7
	for <live-patching@vger.kernel.org>; Tue, 17 Feb 2026 17:46:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771350363;
	bh=ERVsghGBtwOhB3huWNbWGDau7P0zo8hA2NtpHY+P0+o=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=u0vzoI1jOaD3RQaknwQo8o/Fyhc2/DfQ9tSNbQ2+cOosC0JNvTBo0AAaLDuPKuNN9
	 7Ecgcid1/IQmdNvmeU0U3e2b15IOg40TwDLjxI5/DbuP118YlS3/ucv26QSk7j6DFl
	 +nTEZg8iNPYY7iV1XRxY8mV22QTi0WLv+NGXlyluu+IM3nXrM9ieTt3WOaa4T6sPdI
	 kkhqoBu/1FigNQOQ8I/5/+J3zwG+TcmDek7VizcVAAOf90ZqGDZxCKGKah04gifeE8
	 WthZlHwmLomRKQvP72bxvC60ERGesfHtRzQKpOAfqZkXh84YGuZY+/UGY4kly23QpI
	 J2eoDTVh7MKhw==
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-896f4627dffso54932016d6.0
        for <live-patching@vger.kernel.org>; Tue, 17 Feb 2026 09:46:03 -0800 (PST)
X-Gm-Message-State: AOJu0YwCWIpsTrrPNUbSBb0Ns0x3crviyOo6XqvKL1R9e3BqxFuF1qxc
	4vVnxrWa31ueD8EiXrHSimNXaWBC1XKiqHL7mqyIUUBs/YkVVsQpN/wW4OhKZoR9fSkqqJXQoAa
	3xHupAvAROmF0Zo/q9VI1m/pGhz1b1jk=
X-Received: by 2002:a05:6214:f2e:b0:889:b6f1:1f30 with SMTP id
 6a1803df08f44-897360a4c93mr211096496d6.18.1771350362777; Tue, 17 Feb 2026
 09:46:02 -0800 (PST)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260217160645.3434685-1-joe.lawrence@redhat.com> <20260217160645.3434685-3-joe.lawrence@redhat.com>
In-Reply-To: <20260217160645.3434685-3-joe.lawrence@redhat.com>
From: Song Liu <song@kernel.org>
Date: Tue, 17 Feb 2026 09:45:51 -0800
X-Gmail-Original-Message-ID: <CAPhsuW4fd0K2=zcwNfeRK0p6UOJ1fiO1_vtFiYMMOiVeyLLH4g@mail.gmail.com>
X-Gm-Features: AaiRm50eEQhJHVszgDzlod88WqOm87gVzL2xZ7mR2baCW0BswfOIEGYa8x_n-wM
Message-ID: <CAPhsuW4fd0K2=zcwNfeRK0p6UOJ1fiO1_vtFiYMMOiVeyLLH4g@mail.gmail.com>
Subject: Re: [PATCH v3 02/13] objtool/klp: fix mkstemp() failure with long paths
To: Joe Lawrence <joe.lawrence@redhat.com>
Cc: live-patching@vger.kernel.org, Josh Poimboeuf <jpoimboe@kernel.org>, 
	Jiri Kosina <jikos@kernel.org>, Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2032-lists,live-patching=lfdr.de];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[song@kernel.org,live-patching@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	RCPT_COUNT_FIVE(0.00)[6];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid]
X-Rspamd-Queue-Id: E8A2F14EB7A
X-Rspamd-Action: no action

On Tue, Feb 17, 2026 at 8:06=E2=80=AFAM Joe Lawrence <joe.lawrence@redhat.c=
om> wrote:
>
> The elf_create_file() function fails with EINVAL when the build directory
> path is long enough to truncate the "XXXXXX" suffix in the 256-byte
> tmp_name buffer.
>
> Simplify the code to remove the unnecessary dirname()/basename() split
> and concatenation.  Instead, allocate the exact number of bytes needed fo=
r
> the path.
>
> Signed-off-by: Joe Lawrence <joe.lawrence@redhat.com>

Acked-by: Song Liu <song@kernel.org>

