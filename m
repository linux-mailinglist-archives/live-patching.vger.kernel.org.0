Return-Path: <live-patching+bounces-1294-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 537F6A67DEB
	for <lists+live-patching@lfdr.de>; Tue, 18 Mar 2025 21:16:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 06BD91B600E3
	for <lists+live-patching@lfdr.de>; Tue, 18 Mar 2025 20:16:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E5BA2135A9;
	Tue, 18 Mar 2025 20:14:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UE6e/o48"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2267E208970;
	Tue, 18 Mar 2025 20:14:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742328893; cv=none; b=T+h4sJh/AYbi6cb5xZz7Tku6a5HNh7/61tH/W1eRP7MWrEd5jCKGY7QRj9Z3m0mgmE7EldSqDkxb7PhxoYZeGu0DO+T4w/bikspJGYoEnXUUDPVSc0+M+lSU3UEDs9CLafHymU5MvjdH1z/qelPMEoE/+oMP/VrnR/mg2Exc8/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742328893; c=relaxed/simple;
	bh=d/sSThcAJ1FNOkIt4xuEgK6TkWWhj5jMwQxg8sRwZlE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=t0GbGoXP/Fa0v8KNqunoa/s6f4Z/4pZtoO3lKOD3bylrgEzqMnIMlALz8+y74J3SW2Pd81QcYeP+2y9V2/CR71th4hOX/SeocEtTQbw6nLluQPd74cM7tXtKAj6ZUsirIlspcKHwAi5orFZKFS9sVqKNeYy42pEv5vJHHsV8YBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UE6e/o48; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 974E1C4CEF4;
	Tue, 18 Mar 2025 20:14:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742328892;
	bh=d/sSThcAJ1FNOkIt4xuEgK6TkWWhj5jMwQxg8sRwZlE=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=UE6e/o48rc+ViKpLcaVyDCfILBmJtDpz8KCbN7dmodQqOvLotLDM80ntBrgYueOgo
	 0U1Duo5oXb92E2LewBPDzIBfLATasvimDQujs05DxwkbTcjhwiqFJUoQdPE1a7rSUb
	 5Edf/XqKiJHbbh7EblcAR+U/qXynAHeWUJ1OnxjHcTUJaipiOl/u4hijVPI8ucaHU9
	 Q+rkLKmU+LVKrppoCcUqtby2bMvLLdoch3JoFm5WRk1b+0fio+RTBEGJe+TpViGf0c
	 NTuzVJk4S2kT3Y/t1EygJ/Mh6aeUKFs3907OqJ+NMPSGK5Y0cqgGbr7m1knNRtbVrH
	 bco6CQ1rpMjZg==
Received: by mail-il1-f182.google.com with SMTP id e9e14a558f8ab-3d46aaf36a2so47379935ab.3;
        Tue, 18 Mar 2025 13:14:52 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUXzRfr3CsX/7nhYbN35mgOuZ99xArEGOQw1NmVCMw5esTUlbDA0gHFm8n/CsktKiwPuyNcLdWUvlFUo14=@vger.kernel.org, AJvYcCWh/hPXj8tE12uHv3llpqVLlgRCWESW9aAm75WLQnFIaSk41+mMPw664Cqf9/7Uu1cwZNeyIYbOy3lyEv4BleBYAA==@vger.kernel.org, AJvYcCXj9GHrerXfI/DFo5GUdLKZQOTXNpKJNVWoup6t9+N583NcFs+kJfnSjyC1p+VhjOfA/sY2gqH4wF+hJjIlrA==@vger.kernel.org
X-Gm-Message-State: AOJu0YyfzFJb7ygG7DJ3JKIJGMRQYfTqYudo/8PqCbURvcmmGeSCgSdT
	XldccSuE1H2QDl/Rl0UN0zJWfRhemgF12YivW/oKzhM8/U/zxOUsOddaytolSKaRKx4R1VXnlgL
	bNU19Kr0hmJwskKnI7+kpTV6KGOs=
X-Google-Smtp-Source: AGHT+IHtAfQRa5ygS0+xhQYljeYFtmhnJ0xVV7lJdlI0Pu/Z5ueR2htXv0YGBlFbTqjgA63bOgGEydLfCjMz7N9NFQw=
X-Received: by 2002:a05:6e02:3312:b0:3d4:6f37:3748 with SMTP id
 e9e14a558f8ab-3d586bbcfcamr1456735ab.16.1742328891937; Tue, 18 Mar 2025
 13:14:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250308012742.3208215-1-song@kernel.org> <20250308012742.3208215-2-song@kernel.org>
 <iajk7zuxy7fun7f7sv52ydhq7siqub3ec2lmguomdd3fhdw4s2@cwyfihj3gvpn>
In-Reply-To: <iajk7zuxy7fun7f7sv52ydhq7siqub3ec2lmguomdd3fhdw4s2@cwyfihj3gvpn>
From: Song Liu <song@kernel.org>
Date: Tue, 18 Mar 2025 13:14:40 -0700
X-Gmail-Original-Message-ID: <CAPhsuW4A73c0AjpUwSRJ4o-4E6wpA9c5L0xWaxvHkJ3m+BLGVA@mail.gmail.com>
X-Gm-Features: AQ5f1JoxrCAHtT-wypdFb1RI64YEPNsCvi5X7wvvH2VhOFtJbGsL8mOcDVjXOYg
Message-ID: <CAPhsuW4A73c0AjpUwSRJ4o-4E6wpA9c5L0xWaxvHkJ3m+BLGVA@mail.gmail.com>
Subject: Re: [PATCH 1/2] arm64: Implement arch_stack_walk_reliable
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-toolchains@vger.kernel.org, live-patching@vger.kernel.org, 
	indu.bhagat@oracle.com, puranjay@kernel.org, wnliu@google.com, 
	irogers@google.com, joe.lawrence@redhat.com, mark.rutland@arm.com, 
	peterz@infradead.org, roman.gushchin@linux.dev, rostedt@goodmis.org, 
	will@kernel.org, kernel-team@meta.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Josh,

Thanks for the review!

On Tue, Mar 18, 2025 at 11:45=E2=80=AFAM Josh Poimboeuf <jpoimboe@kernel.or=
g> wrote:
>
> On Fri, Mar 07, 2025 at 05:27:41PM -0800, Song Liu wrote:
> > With proper exception boundary detection, it is possible to implment
> > arch_stack_walk_reliable without sframe.
> >
> > Note that, arch_stack_walk_reliable does not guarantee getting reliable
> > stack in all scenarios. Instead, it can reliably detect when the stack
> > trace is not reliable, which is enough to provide reliable livepatching=
.
> >
> > This version has been inspired by Weinan Liu's patch [1].
> >
> > [1] https://lore.kernel.org/live-patching/20250127213310.2496133-7-wnli=
u@google.com/
> > Signed-off-by: Song Liu <song@kernel.org>
>
> This looks incomplete.  The reliable unwinder needs to be extra
> paranoid.  There are several already-checked-for errors in the unwinder
> that don't actually set the unreliable bit.
>
> There are likely other failure modes it should also be checking for.
> For example I don't see where it confirms that the unwind completed to
> the end of the stack (which is typically at a certain offset).

If I understand the comment correctly, this should be handled by the
meta data type FRAME_META_TYPE_FINAL.

>
> See for example all the error conditions in the x86 version of
> arch_stack_walk_reliable() and in arch/x86/kernel/unwind_frame.c.

I guess I missed this part:

diff --git i/arch/arm64/kernel/stacktrace.c w/arch/arm64/kernel/stacktrace.=
c
index 69d0567a0c38..3bb8e3ea4c4b 100644
--- i/arch/arm64/kernel/stacktrace.c
+++ w/arch/arm64/kernel/stacktrace.c
@@ -268,6 +268,8 @@ kunwind_next(struct kunwind_state *state)
        case KUNWIND_SOURCE_TASK:
        case KUNWIND_SOURCE_REGS_PC:
                err =3D kunwind_next_frame_record(state);
+               if (err && err !=3D -ENOENT)
+                       state->common.unreliable =3D true;
                break;
        default:
                err =3D -EINVAL;


With this part, we should cover all these cases? Did I miss something
else?

Thanks,
Song

