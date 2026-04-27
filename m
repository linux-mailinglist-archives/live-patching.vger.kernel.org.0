Return-Path: <live-patching+bounces-2559-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id yAyaGKYK72l84gAAu9opvQ
	(envelope-from <live-patching+bounces-2559-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Mon, 27 Apr 2026 09:05:10 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 0F9CD46E06B
	for <lists+live-patching@lfdr.de>; Mon, 27 Apr 2026 09:05:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id F38E130074B8
	for <lists+live-patching@lfdr.de>; Mon, 27 Apr 2026 07:03:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C79FB384232;
	Mon, 27 Apr 2026 07:03:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="icGwHTo9"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-vs1-f44.google.com (mail-vs1-f44.google.com [209.85.217.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BA672857C7
	for <live-patching@vger.kernel.org>; Mon, 27 Apr 2026 07:03:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.217.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777273418; cv=pass; b=gecSWOW2g8z38oiJXNw+rRbESlUD9/VryswMWKGBLvCsK0lSVIYVNHEX3Nqc2QjZtnQqGnbORJ3WUTnLlMB+ScAc2mfR8zqEK+lycxuPR5Ysitxz6eZ7LSgGA1TjdCP3+lZsofcT8sjn6CAuiVSni1t6yNwp+gdycCKfulgfqjw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777273418; c=relaxed/simple;
	bh=2pJgS9S5LR5M0h9Bw24qeqPOUpOncldgAWGjxP7bvc4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bYkG60yG3OXwV6Tubh9/ZEzeIdq2NNVWUjm+4VMJ1DjFv8+DuEejqHVzUWJKJ8URlqsn6ZmD5r2KyVEyoQZSDLwikkOMwBMi9rE7WB1nNgWS9SIOdf/40sqHSZP+WL0/ndVCwdsc4YPKshXdnTv0bQycSFvt+8zZ2ZmMvIWMIy0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=icGwHTo9; arc=pass smtp.client-ip=209.85.217.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-vs1-f44.google.com with SMTP id ada2fe7eead31-60fbbac2938so3887503137.1
        for <live-patching@vger.kernel.org>; Mon, 27 Apr 2026 00:03:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777273415; cv=none;
        d=google.com; s=arc-20240605;
        b=D1MsMaWPdN2ita7shPgYw5kza3gDcpvU/ZXpQA7+52VO3JZvDP6SbqGD+DV3Gpssu7
         bY5HJZekIVQ3mfsRkDn70SMjqFbUs64J9VAQdE3ruslv7GKEdn56+isIobdFXaRgoKB5
         l5YrIjjfFoMjpSnXDo9l3jWCIGbq+QLqkDTRGc2gu/7nvLesqEqSN6qxdFE6Ob0tccUw
         wfRrPc/QiceXrNh0TS9TpDjDzjxg15ONps1X5nbsIl5hZfysnrZnS/wC7d/3TbV8HzLG
         DlCkR+6qgswZrTNBfuTRwHRvYEqhJsMkU2VatMr7TcRYBdsovFsFgec9y9KCPZKuf5yM
         BLGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=hffe5YxZ9enS5KCElAXITVujz3rFnAmgcCceKcxI0jU=;
        fh=Cr2kNjkdZOblxIaMQenD7iqlDeC7QVuY6v+ULCp40l0=;
        b=a1HBWbMxulgMN9tl4y9pGf1umHBSsmBNyf0+LHFjYaU4PhUdY53XB2DJXpZVRn1gUy
         fNgGcDjgJP1lsODmP4u65hEV3uNCvNoBuRuIj3CxLw8buLj8T6vsn/pT7vLI4U7hNQCe
         iGhVgj1mT4M6UXLlchjb0ogxO2nqWB9fYW7Zx92fk6waKQUIMRUxH3slNZlTxpYh+QWy
         +kZXILw9WDuF7XIeWoYkJjy75xK88CDeE0Ixd8L7/mBMUixArbrjZStB1DovEy5BWsKl
         ijlRA0t8e18c8HA7OOV0IeA4c8c15JwgelHWonDtY0R0FBgZG09Ed+j0hImNxKD4dCln
         BwLw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777273415; x=1777878215; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hffe5YxZ9enS5KCElAXITVujz3rFnAmgcCceKcxI0jU=;
        b=icGwHTo9nEpchkQYQicUfI4QgSP5fKGtXdbKjrIxQH9UsJpd/r7MZZvBcGjvi+aoLS
         Y2dSxaTH5sZH2D2ae/O0bn+SMIFKW0GgXLTL+VpPHd4j0irEBOzw9Lz5bLGPkNe+umKR
         oezlU5JVpBWtprU2mZ514QDzWWknZxb02h+g7C7eQmCjiVrj5cDcRIFO3+7WdG7NEvVO
         t47PELQghyA2VsRpg9MzhaBA14gSHfbgbIp1PozG/JU5pz+ojVnTH7/I1ak7YHjBxaP/
         +1e8kvnsEfIXGtgmpq0HEsVPlUWZSVGFEZ6ivaCH1oybMdAzZd0643lVHW9xGf+S3TMK
         7trA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777273415; x=1777878215;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=hffe5YxZ9enS5KCElAXITVujz3rFnAmgcCceKcxI0jU=;
        b=Ntn1G0V9Euw11pdw151kAtTXCGAwmMV1yuX8nxl2o77nS2ei8XqAee6daXzxOA7MC7
         5k2ZDmVc9nGfA0xQTYVLm0hQPi2e87KnPeGZFtW6TXsNcPJI+bI1E4tHoMtFQvOSskNw
         FUeHs9Mhx2+uE6sT3vnefWY98YKCrWnEro0KYoEO0kv08MqcSpxUMx7zxV8ZyUpJQM9h
         I3z6y1S3ivxcmmPM9FIuevlCZXNWYxEm0e2PhCOjmsZ48Q7nRIDuKHdcYuKyk9cOMbok
         wnytlyuCtwmwe0bf1E3jXJgMloJfH/197Vt+ETpnk92UyMSradVxnJZhcSjXu326qKsm
         hA8Q==
X-Forwarded-Encrypted: i=1; AFNElJ/FDYOp+5nPI2wng/B3iE04SCXcAIGPvBOMCmiwNIeSLvTSi5VLQgShjJ9CTjEv3s5XVgMiq1bQkz5zXzx5@vger.kernel.org
X-Gm-Message-State: AOJu0YxbmeKVCrJ/cKu8GHtLBKs2I2mmoi5M8vre7DXTzjGnFAt1yQ6j
	RH98xyJq3hfro2zGvagQ5FEz/LtJRFKR7pfEuMlV01SKzKqRXKfkdO6huOGFRe0qmfAorZ35GUd
	Dkk0kKqh46xWufnQArX+GeayT0vkVlr5+hSZ8De9K
X-Gm-Gg: AeBDiet/4cTnZFXkAQDtZ4lbNf20MXFcQV5UlIwJUtgNA4xYK3iNLPDiSABHgpaiFCE
	4l75sygYCX9zY348T7JGhSD8ACK67Iug4E0naagZbX7baZ0RafEnSyFsYKrVC3Un4W40uOl694x
	prjgphPvUNHgq+JNCzMIp9cEbrob+acPpEB3GXAA+IFukQmgNERLvmRnXbeBK4GQtTWca7GTD/v
	/iZ9T/Zb/qRbUNm5U8bfnQkkMn/n9yse5PFweYBIbf3yV8wG4a6/CeD8TkpbpTFQ+3gVRRPNkwr
	QU3qgYsAIFmcQUHmoxShV39LTBex
X-Received: by 2002:a05:6102:3f86:b0:607:7991:f02e with SMTP id
 ada2fe7eead31-616f8392189mr16279119137.26.1777273414448; Mon, 27 Apr 2026
 00:03:34 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260421225200.1198447-1-dylanbhatch@google.com>
 <20260421225200.1198447-8-dylanbhatch@google.com> <73e99161-c246-467d-96c2-46911ffc0bff@linux.ibm.com>
In-Reply-To: <73e99161-c246-467d-96c2-46911ffc0bff@linux.ibm.com>
From: Dylan Hatch <dylanbhatch@google.com>
Date: Mon, 27 Apr 2026 00:03:23 -0700
X-Gm-Features: AVHnY4KtKrvy0WTUUTyFTIFDf7aGdgUISg9FGVKdo0AdfDa0OxtNiPCZNoTiW6A
Message-ID: <CADBMgpz5Z0Vxz_cr3L0fsT6j7wqZrnLA7uLGabvYJV5EDoaPDA@mail.gmail.com>
Subject: Re: [PATCH v4 7/8] sframe: Introduce in-kernel SFRAME_VALIDATION
To: Jens Remus <jremus@linux.ibm.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>, Weinan Liu <wnliu@google.com>, 
	Will Deacon <will@kernel.org>, Josh Poimboeuf <jpoimboe@kernel.org>, 
	Indu Bhagat <ibhagatgnu@gmail.com>, Peter Zijlstra <peterz@infradead.org>, 
	Steven Rostedt <rostedt@goodmis.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Jiri Kosina <jikos@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
	Prasanna Kumar T S M <ptsm@linux.microsoft.com>, Puranjay Mohan <puranjay@kernel.org>, 
	Song Liu <song@kernel.org>, joe.lawrence@redhat.com, linux-toolchains@vger.kernel.org, 
	linux-kernel@vger.kernel.org, live-patching@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, Randy Dunlap <rdunlap@infradead.org>, 
	Heiko Carstens <hca@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 0F9CD46E06B
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-2559-lists,live-patching=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[linux.dev,google.com,kernel.org,gmail.com,infradead.org,goodmis.org,arm.com,linux.microsoft.com,redhat.com,vger.kernel.org,lists.infradead.org,linux.ibm.com];
	RCPT_COUNT_TWELVE(0.00)[21];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[dylanbhatch@google.com,live-patching@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	TAGGED_RCPT(0.00)[live-patching];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]

On Wed, Apr 22, 2026 at 7:11=E2=80=AFAM Jens Remus <jremus@linux.ibm.com> w=
rote:
>
> On 4/22/2026 12:51 AM, Dylan Hatch wrote:
> > Generalize the __safe* helpers to support a non-user-access code path.
> >
> > This requires arch-specific function address validation. This is becaus=
e
> > arm64 vmlinux has an .rodata.text section which lies outside the bounds
> > of the normal .text. It contains code that is never executed by the
> > kernel mapping, but for which the toolchain nonetheless generates sfram=
e
> > data, and needs to be considered valid for a PC lookup.
> >
> > This arch-specific address validation logic is only necessary to suppor=
t
> > SFRAME_VALIDATION for the vmlinux .sframe, since these .rodata.text
> > functions would never be encountered during normal unwinding.
> >
> > Signed-off-by: Dylan Hatch <dylanbhatch@google.com>
> > Suggested-by: Jens Remus <jremus@linux.ibm.com>
>
> With the minor nit below fixed:
>
> Reviewed-by: Jens Remus <jremus@linux.ibm.com>
>
> > ---
> >  arch/Kconfig                           |  2 +-
> >  arch/arm64/include/asm/sections.h      |  1 +
> >  arch/arm64/include/asm/unwind_sframe.h | 21 +++++++++++++++++++++
> >  arch/arm64/kernel/vmlinux.lds.S        |  2 ++
> >  include/linux/sframe.h                 |  2 ++
> >  kernel/unwind/sframe.c                 | 25 +++++++++++++++++++++++--
> >  6 files changed, 50 insertions(+), 3 deletions(-)
>
> > diff --git a/arch/Kconfig b/arch/Kconfig
> > @@ -503,7 +503,7 @@ config HAVE_UNWIND_USER_SFRAME
> >
> >  config SFRAME_VALIDATION
> >       bool "Enable .sframe section debugging"
> > -     depends on HAVE_UNWIND_USER_SFRAME
> > +     depends on SFRAME_LOOKUP
>
>         depends on UNWIND_SFRAME__LOOKUP

Ah my bad. This mistake was masking similar issues with .init.text and
.exit.text as we had with .rodata.text. I'll send a new version
accounting for those versions as well.

>
> >       depends on DYNAMIC_DEBUG
> >       help
> >         When adding an .sframe section for a task, validate the entire
>
> Regards,
> Jens
> --
> Jens Remus
> Linux on Z Development (D3303)
> jremus@de.ibm.com / jremus@linux.ibm.com
>
> IBM Deutschland Research & Development GmbH; Vorsitzender des Aufsichtsra=
ts: Wolfgang Wendt; Gesch=C3=A4ftsf=C3=BChrung: David Faller; Sitz der Gese=
llschaft: Ehningen; Registergericht: Amtsgericht Stuttgart, HRB 243294
> IBM Data Privacy Statement: https://www.ibm.com/privacy/
>

Thanks,
Dylan

