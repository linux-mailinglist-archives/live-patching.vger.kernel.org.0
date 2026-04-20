Return-Path: <live-patching+bounces-2400-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id fq4MGB3A5WkVnwEAu9opvQ
	(envelope-from <live-patching+bounces-2400-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Mon, 20 Apr 2026 07:56:45 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id ADDB2426F93
	for <lists+live-patching@lfdr.de>; Mon, 20 Apr 2026 07:56:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 355A53007AE3
	for <lists+live-patching@lfdr.de>; Mon, 20 Apr 2026 05:56:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 821C537CD20;
	Mon, 20 Apr 2026 05:56:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="gqAZrBep"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-ua1-f42.google.com (mail-ua1-f42.google.com [209.85.222.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE9D535C190
	for <live-patching@vger.kernel.org>; Mon, 20 Apr 2026 05:56:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.222.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776664600; cv=pass; b=kOZBUvK1DklDcZcy9MBt8bktHcimlKUfK4O86HnhhOBKQtK7QsXgY93HlpR76KhPdRNRiJOwkjSjeWs7oEpomGmPLge86Rz8hQLUSPuZyTICSAGcNE8qfg5eAUPhvUzXQPN9OBsexHXcTdIAz3lVbW6uqlUQVYciQy4JGMbG/no=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776664600; c=relaxed/simple;
	bh=sFzFVHg9OKFKV0qs6atP5BlM6IR+mC7cyoL1tUNXn/k=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=o4RsK0xDBx2kJaO/ZcwDq9AZXDQK4VSrcDIKBdlXAiedovV6ShqxgaGlkpkuKubJFfTLKe0lr2n8Zbz/rc0TmELponFsqpbTmdVCK4lt1MS11u6sVKBt99qbrDgAd7Z9gRO7/H+NQ9KD9W+0dNgQP7PU7kVj2T9M8Nc63lB26us=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=gqAZrBep; arc=pass smtp.client-ip=209.85.222.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ua1-f42.google.com with SMTP id a1e0cc1a2514c-953ac1602f8so2285385241.1
        for <live-patching@vger.kernel.org>; Sun, 19 Apr 2026 22:56:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776664598; cv=none;
        d=google.com; s=arc-20240605;
        b=EBhii7i8Ds+SusmzMDw9PGGsBoH1eFN+GCTxh+Jb8X8X0Hx7VA2E5XqrLCMqvJ92tP
         I131QO8+FkEm95FVMpuzPXLOMX9MKovEEGD2OV7nRx3xYPGv14qAZA0T4wTuXp9ZtGAs
         YrVOHa761Z0Qm5PCKVkxA5LyFPZe/viBidX+ze8JhHUJn0D8m40IEWwh6LJKOshtnBmb
         9IcedVOWlw7/N7TGIvO5c6xbwMe76k9Tox+cO2LaGW+GZOInARIfJMaxdlUxB0vKFtZi
         v4vrJM2AvOP07Is8xoUQCx61afgcelDU4pT6YBKT92Go3hctBfipNL3pB+5EHRt/juiT
         /5/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=BPEVhn8QEcx6wbVw5CO4dCCDD+tkmOF6Duo+IIAkxXk=;
        fh=WXYXSx8GjGiWNOUYg6KWak808/sQntrZ6ChzuiZAc9k=;
        b=GrtddbTRF8Os9wKlVeEJkayntXQybdBockNH2sLNSAQuyqLSA+ES1FJw9imWnCsqYS
         9wb/n7KOAWy2dm853EWb0qrU1FDZf7W1koRUwbkPn6x0/OrJ7HMdB95BgVchOSqvoL3R
         birSEYz4MkP4QVxW2EVASMk8w82BxV1ar1Y3f1W3gdyOwtBjpw6axh+/wIpByPm0SRkv
         dRwmGnKlNleNFfwW1w2OyL/UmD4cSbtXNMuWQS6kUWzK2UYHQUC2Xhh0szJdnE3mvgpx
         nPqazQSb3RxFNpZybp87xCDw246Hj3ORPnA7exKNME0qzm/6PhxDDNTTEnbLDxRl7YXv
         7Ahw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1776664598; x=1777269398; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BPEVhn8QEcx6wbVw5CO4dCCDD+tkmOF6Duo+IIAkxXk=;
        b=gqAZrBepy1vDIN7ULJGyBgmblNY6QSwt4lThbolKfdEPy/P3T6c1PkpI01LbeJOYeM
         FzzGmexlRLcm45WwQ4po9Hli/OFaEOTKSnk3geY3EuC02+UuaGSSSOIRmXAz41d8ADSi
         Hiph8RxWWo6ESPhGk21JZxO0sV03r66IEa6LS/zg7QJzmMaxXOVj26457y+swgp6l98P
         Az/cmqlrSdyQh49pqlIqAgfzirVCSZOBlfxi+S5t091EZxmMOg8MPBCa3d3Lco23v7LL
         lQ7LYv4RgT9fyVAOFHFhr+pgQPF1m53eFR4gx7xhUS30MM8hfebM/kXtUe90tOTP3qRZ
         z8rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776664598; x=1777269398;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=BPEVhn8QEcx6wbVw5CO4dCCDD+tkmOF6Duo+IIAkxXk=;
        b=eg6R8RvY5SlglHIshHa0DII3GSJgHs2wrQsAT4JJCV47cKTlZUhxCMXaZ/vRDX7YsD
         8WXR6wNYVsyMN80qEm5FDcudb2qFg0OdX5LZEDR3NIjFO/J3XmyIMf4TOkRJms9Jrxh/
         CpIgx8xCeyR6y30hNmrCZhXqSkJG2Ls0GLxumZIPQDdLouqkE038936EHJfxjRTKlJYD
         xIEz7z4W++QiokChijiPcJeyEOUHjyG1G6mYfPdFWwHgMn8F/I1F7zk1SaqNY4F8lJEF
         ohHR8BgIbUj7DsIoYGLA3SdoXD+Ophd2fb49ljpD3Ou+fh4XYRtv7wkUSU1wWYm2Ss42
         YGag==
X-Forwarded-Encrypted: i=1; AFNElJ+aN24TtVpup584ZFkEUxiYYNkSYoVHOlndTDSuuVrgWOSL503xBCjEr145MEBC9ZxtlTYuZ/3c6l0ZuRm7@vger.kernel.org
X-Gm-Message-State: AOJu0YyuxtNs5fs+b1PmcBUAKtdLG04FzBBXeB7/BlgH0kJb3OELRT63
	oq/HE8TOG0LNlENvES1Q8i3qkct8lA6mIjMbhdkuzSsNUGJSZ/TP/GOGyryC/qScawpKRS7SUV/
	YjKOdb6JFDlVJtvc6kshwGQFqM0hpzYB7fBQi5zyO
X-Gm-Gg: AeBDiesNmTnk3rVOCzsEZNNkOfNED9Wn0b/KNJJRrUt7VomhZHafUTQZVpajOOSAACN
	+NngRCPF6E1f0XrFGLDUk0kMFEgfuQSKBAUVDmEt8uIEUFQw3ve77a+SgvuExQKvtlOkE0NfBIX
	KCRXxitPUrAhSEl5Dn+qwajVRnxjzumRZD4IDdAF/6JBeknxso60jrKWXWHBFvK1q2pCjxI2mNd
	8L+6bKXWOav+ESbUKO0N3gqw9uyNaG1NZJXFTVls3MdqyI1/X4/+gokDfCebrZp1XMxO3Dl/RdX
	qKqmMiVZ30h8nUU0FEjkspgMPStQ
X-Received: by 2002:a05:6102:38cf:b0:5ff:e10e:b9fb with SMTP id
 ada2fe7eead31-616fbea2311mr3560618137.4.1776664597392; Sun, 19 Apr 2026
 22:56:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260406185000.1378082-1-dylanbhatch@google.com>
 <20260406185000.1378082-9-dylanbhatch@google.com> <95f9d11a-dd92-433e-a8db-cbebe94e1611@linux.ibm.com>
In-Reply-To: <95f9d11a-dd92-433e-a8db-cbebe94e1611@linux.ibm.com>
From: Dylan Hatch <dylanbhatch@google.com>
Date: Sun, 19 Apr 2026 22:56:25 -0700
X-Gm-Features: AQROBzAWlVd0Pik6ECU4Kd-qXgzCf38HreKoJT7my4kpOuBpU6_tq6UEX8EHlO0
Message-ID: <CADBMgpwjDf44p0ApR1=XVStCyN-0Q6tuywJ4ixLcbaLZOSjjBg@mail.gmail.com>
Subject: Re: [PATCH v3 8/8] unwind: arm64: Use sframe to unwind interrupt frames.
To: Jens Remus <jremus@linux.ibm.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>, Weinan Liu <wnliu@google.com>, 
	Will Deacon <will@kernel.org>, Josh Poimboeuf <jpoimboe@kernel.org>, 
	Indu Bhagat <indu.bhagat@oracle.com>, Peter Zijlstra <peterz@infradead.org>, 
	Steven Rostedt <rostedt@goodmis.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Jiri Kosina <jikos@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
	Prasanna Kumar T S M <ptsm@linux.microsoft.com>, Puranjay Mohan <puranjay@kernel.org>, 
	Song Liu <song@kernel.org>, joe.lawrence@redhat.com, linux-toolchains@vger.kernel.org, 
	linux-kernel@vger.kernel.org, live-patching@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, Heiko Carstens <hca@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2400-lists,live-patching=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[20];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[dylanbhatch@google.com,live-patching@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TAGGED_RCPT(0.00)[live-patching];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,mail.gmail.com:mid]
X-Rspamd-Queue-Id: ADDB2426F93
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Fri, Apr 17, 2026 at 8:45=E2=80=AFAM Jens Remus <jremus@linux.ibm.com> w=
rote:
>
> > +     case UNWIND_CFA_RULE_FP_OFFSET:
> > +             if (state->common.fp < state->common.sp)
> > +                     return -EINVAL;
>
> I wonder whether that check is valid in kernel?  Looking at
> call_on_irq_stack() saving SP in FP and then loading SP with the IRQ SP.
> Is that condition always true then?

Good catch. I will double-check this.

>
> > +             cfa =3D state->common.fp;
> > +             break;
> > +     case UNWIND_CFA_RULE_REG_OFFSET:
> > +     case UNWIND_CFA_RULE_REG_OFFSET_DEREF:
> > +             if (!regs)
>
>                 if (!regs || frame.cfa.regnum > 30)
>
> > +                     return -EINVAL;
> > +             cfa =3D regs->regs[frame.cfa.regnum];
>
> In unwind user this is guarded by a topmost frame check, as arbitrary
> registers are otherwise not available.  Isn't this necessary in the
> kernel case?

It is necessary, though as you point out the way I wrote the check is
not as obvious as it probably should be.

The saved state->regs is set when the current frame is recovered from
the saved PC of a struct pt_regs, and then immediately set back to
NULL after the next frame has been recovered. In other words, the
state->regs is only ever set when it is relevant to the current frame,
which occurs when state->source =3D=3D KUNWIND_SOURCE_REGS_PC. This only
happens when the topmost frame is recovered from a pt_regs, or when a
pt_regs is recovered from the stack due to an interrupt.

I can make this more readable by adding an explicit check for
KUNWIND_SOURCE_REGS_PC in addition to state->regs !=3D NULL.

>
> > +             break;
> > +     default:
> > +             WARN_ON_ONCE(1);
> > +             return -EINVAL;
> > +     }
> > +     cfa +=3D frame.cfa.offset;
> > +
> > +     /*
> > +      * CFA typically points to a higher address than RA or FP, so don=
't
> > +      * consume from the stack when we read it.
> > +      */
> > +     if (frame.cfa.rule & UNWIND_RULE_DEREF &&
> > +         !get_word(&state->common, &cfa))
> > +             return -EINVAL;
> > +
> > +     /* CFA alignment 8 bytes */
> > +     if (cfa & 0x7)
> > +             return -EINVAL;
> > +
> > +     /* Get the Return Address (RA) */
> > +     switch (frame.ra.rule) {
> > +     case UNWIND_RULE_RETAIN:
> > +             if (!regs)
> > +                     return -EINVAL;
> > +             ra =3D regs->regs[30];
>
> Likewise: Topmost frame check not required to access arbitrary registers
> (including RA/LR)?  Furthermore, provided don't have a thinko, LR may
> only be in LR in the topmost frame.  In any other frame it must have
> been saved.  Otherwise there would be an endless return loop.
>
> > +             source =3D KUNWIND_SOURCE_REGS_LR;
> > +             break;
> > +     /* UNWIND_USER_RULE_CFA_OFFSET not implemented on purpose */
> > +     case UNWIND_RULE_CFA_OFFSET_DEREF:
> > +             ra =3D cfa + frame.ra.offset;
> > +             break;
> > +     case UNWIND_RULE_REG_OFFSET:
> > +     case UNWIND_RULE_REG_OFFSET_DEREF:
> > +             if (!regs)
>
>                 if (!regs || frame.cfa.regnum > 30)
>
> > +                     return -EINVAL;
> > +             ra =3D regs->regs[frame.cfa.regnum];
>
> Likewise: Topmost frame check not required to access arbitrary registers?
>
> > +             ra +=3D frame.ra.offset;
> > +             break;
> > +     default:
> > +             WARN_ON_ONCE(1);
> > +             return -EINVAL;
> > +     }
> > +
> > +     /* Get the Frame Pointer (FP) */
> > +     switch (frame.fp.rule) {
> > +     case UNWIND_RULE_RETAIN:
> > +             fp =3D state->common.fp;
> > +             break;
> > +     /* UNWIND_USER_RULE_CFA_OFFSET not implemented on purpose */
> > +     case UNWIND_RULE_CFA_OFFSET_DEREF:
> > +             fp =3D cfa + frame.fp.offset;
> > +             break;
> > +     case UNWIND_RULE_REG_OFFSET:
> > +     case UNWIND_RULE_REG_OFFSET_DEREF:
> > +             if (!regs)
>
>                 if (!regs || frame.cfa.regnum > 30)
>
> > +                     return -EINVAL;
> > +             fp =3D regs->regs[frame.fp.regnum];
>
> Likewise: Topmost frame check not required to access arbitrary registers?
>
> > +             fp +=3D frame.fp.offset;
> > +             break;
> > +     default:
> > +             WARN_ON_ONCE(1);
> > +             return -EINVAL;
> > +     }
> > +
> > +     /*
> > +      * Consume RA and FP from the stack. The frame record puts FP at =
a lower
> > +      * address than RA, so we always read FP first.
> > +      */
> > +     if (frame.fp.rule & UNWIND_RULE_DEREF &&
> > +         !get_word(&state->common, &fp))
> > +             return -EINVAL;
> > +
> > +     if (frame.ra.rule & UNWIND_RULE_DEREF &&
> > +         get_consume_word(&state->common, &ra))
> > +             return -EINVAL;
> > +
> > +     state->common.pc =3D ra;
> > +     state->common.sp =3D cfa;
> > +     state->common.fp =3D fp;
> > +
> > +     state->source =3D source;
> > +
> > +     return 0;
> > +}
> Thanks and regards,
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

