Return-Path: <live-patching+bounces-1786-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4540BBF7976
	for <lists+live-patching@lfdr.de>; Tue, 21 Oct 2025 18:09:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 17F9A3A4713
	for <lists+live-patching@lfdr.de>; Tue, 21 Oct 2025 16:08:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 44B0A3451DE;
	Tue, 21 Oct 2025 16:08:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kjWzGQxJ"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38278346772
	for <live-patching@vger.kernel.org>; Tue, 21 Oct 2025 16:08:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761062895; cv=none; b=fFP0pQzVGmJUFGfBI4emn2ELwPgUuLXRN6lFuN+cXbBJZnqlTFX10Nl0sEqUwcI3ypIaLZyzYvG2Kev4AL1KnxDGuuEHSxoF0HVMTg5ffpoytuehLdfdxethMZCIJFJsCGI5PkQ7UbZYZmkQofFWN9uilMg/cdIO58ejYtC7+IA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761062895; c=relaxed/simple;
	bh=4lFPY5gJLssSH78RJL3v73hMAsCcgUUsaXLBfIVvk1U=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QuX0woH8M4SPx4d8gmboOq3eK05iwcK7ruux/rBDf5QezDZAc67eKBt1qYguX1Ee4fJZwaEy/Up2Ea9T1lqaO/7HlLNo1HUt3UCRlmSBbd5IU2grHDf/5bl66wA+XtDF/sReqS5TwEp/Yrxaig7Ygi01phf/XPCOIeNbaYovdYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kjWzGQxJ; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05327C4CEF5
	for <live-patching@vger.kernel.org>; Tue, 21 Oct 2025 16:08:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761062895;
	bh=4lFPY5gJLssSH78RJL3v73hMAsCcgUUsaXLBfIVvk1U=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=kjWzGQxJEvXR+9YLcq5ZPGAQyNIjnyD6Lm1BxzacSONzB6NLCM6QryAR+maOlrzOf
	 Jy8nMy/UEjmRMxLVNphUmULplpZcHn0r3/DahJQ5GrB6aIughpHCa9qEKrkkCHeF5h
	 ibQ2gVpAV6uUvSY3GseQb3zHZ4GvlgGPniv/IhI+G2dT2YEwACdoQC2Oea0uP3ox0M
	 f5f0NgVSxAVjLahI7U5bsSex17cgFrYbUY0ufzJ3tPf4yDGv5eSHX31eYN+76GMIEu
	 Xc5xz0Jugm7SuyNan/O0MWVHZy7Q+dKCy0Tg0GrlHXrP4moiDg8zG9xRw/P2Eeng5z
	 0g0n8wPXzSdrg==
Received: by mail-vs1-f48.google.com with SMTP id ada2fe7eead31-5d5f8e95d5eso2506108137.1
        for <live-patching@vger.kernel.org>; Tue, 21 Oct 2025 09:08:14 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVC7Dm/BDWA/mZyuPfWMubO2QTqQ6CT94ClKzJW4Lf2TB2ENTyWrIx/v4YwrHRS0ay46uKQmzhXu1HjDmUd@vger.kernel.org
X-Gm-Message-State: AOJu0Yy8WVInWqDr11gq4C/v/FPAwsg4QVoouIcWpytAM/eCMYSyo5aB
	hHz5kWghhu8Czg01GiBF9JdEBZMQedqOuuPUoqdUeMACEX6yJ61ld2HI+aSLTvrkckZHTiSzRda
	v6xUmtd/yYXsqXu7RERyR21L5uSiBpRk=
X-Google-Smtp-Source: AGHT+IG2xzAfpZ5JdFkPSCfAzFUDUqwhRGZzz+nMA9qWeY+NoVoLenws/eR+YOLF2HRtSCJCp/l2aQCIYV6Qx13t8C4=
X-Received: by 2002:a05:6102:3a0a:b0:5d6:254f:cc5f with SMTP id
 ada2fe7eead31-5d7dd6384ddmr5059661137.20.1761062894112; Tue, 21 Oct 2025
 09:08:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <c5058315a39d4615b333e485893345be@crowdstrike.com>
 <aPDPYIA4_mpo-OZS@pathway.suse.cz> <CAHzjS_v2HfpH1Oof3BWawN51WVM_1V1uXro4MSC=0YmMiqVWcg@mail.gmail.com>
 <82eaaada-f3fc-44f7-826d-8de47ce9fd39@crowdstrike.com> <CAHzjS_s2RhM3_H9CCedud3zkGUWW2xkmvxvPLR1qujLZRhgL1A@mail.gmail.com>
 <CAHzjS_sQQaTZpxC2drGx8=7zCMAKQN_CNjYFcNzxZEGhd+yXPA@mail.gmail.com>
 <69339fb8-04a6-4c28-bb71-d9522ebd7282@crowdstrike.com> <CAHzjS_tf0KeBnzA6psjHSCuiXn--hK=owDPhCPUB0=jnLDBk=A@mail.gmail.com>
 <4cc825e6-fdf8-4fc1-8ccd-9bad456c2131@crowdstrike.com> <CAHzjS_soRQwKKP24DObNKBnOtiNsVZHOM-NnY_34w5GwGhC9rw@mail.gmail.com>
 <5477a73a-1dce-4b9e-b389-e757ef5536c4@crowdstrike.com> <CAHzjS_tuotYQQ0HmncVp=oFOfcyxmYqCds0MDBMOr5FC5KzhSA@mail.gmail.com>
 <7e6886ab-b168-422e-9adf-8297b88643d1@crowdstrike.com> <f3f3e753-1014-4fb2-9d6e-328b33c7356f@crowdstrike.com>
 <07ab2111-0f41-40cb-aeb1-d9d3463b1a6a@crowdstrike.com> <CAHzjS_vD1TJkVxN+bf+2srKhH9ajn=BHyvEn7oeu664R481R+g@mail.gmail.com>
 <c3ad390e-4320-46bb-bc72-b57ab628bff6@crowdstrike.com>
In-Reply-To: <c3ad390e-4320-46bb-bc72-b57ab628bff6@crowdstrike.com>
From: Song Liu <song@kernel.org>
Date: Tue, 21 Oct 2025 09:08:03 -0700
X-Gmail-Original-Message-ID: <CAHzjS_vv5Yr3NrL9Uih6n9PEnLZug+Uo=oZgmuHm4R=dHxqCPw@mail.gmail.com>
X-Gm-Features: AS18NWAKfH3Lz9uH2axMZzWFILmPvVE_ruxcUomqkh0irgGMOZhS0Yn7IzOXsbM
Message-ID: <CAHzjS_vv5Yr3NrL9Uih6n9PEnLZug+Uo=oZgmuHm4R=dHxqCPw@mail.gmail.com>
Subject: Re: [External] Re: Question - Livepatch/Kprobe Coexistence on
 Ftrace-enabled Functions (Ubuntu kernel based on Linux stable 5.15.30)
To: Andrey Grodzovsky <andrey.grodzovsky@crowdstrike.com>
Cc: Song Liu <song@kernel.org>, Petr Mladek <pmladek@suse.com>, 
	"kernel-team@lists.ubuntu.com" <kernel-team@lists.ubuntu.com>, 
	"live-patching@vger.kernel.org" <live-patching@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 21, 2025 at 7:15=E2=80=AFAM Andrey Grodzovsky
<andrey.grodzovsky@crowdstrike.com> wrote:
[...]
> > commit a8b9cf62ade1bf17261a979fc97e40c2d7842353
> > Author: Masami Hiramatsu (Google) <mhiramat@kernel.org>
> > Date: 1 year, 9 months ago
> > ftrace: Fix DIRECT_CALLS to use SAVE_REGS by default
> >
> > commit bdbddb109c75365d22ec4826f480c5e75869e1cb
> > Author: Petr Pavlu <petr.pavlu@suse.com>
> > Date:   1 year, 8 months ago
> >
> >      tracing: Fix HAVE_DYNAMIC_FTRACE_WITH_REGS ifdef
> >
> > I tried to cherry-pick 60c8971899f3b34ad24857913c0784dab08962f0
> > and a8b9cf62ade1bf17261a979fc97e40c2d7842353, on top of 6.5.13
> > kernel. Then, fentry and fexit both work with livepatch.
>
>
> I see, thanks for testing! Is the reason it breaks so often is because
> this combination of having BPF
> and llivepatch together on a system with intersection on same functions
> as relatively   rate event and
> so regressions go easily unnoticed ? Isn't there any relevant automated
> testing in upstream that checks for
> those types of breaks ?

This case is not being covered because it is the intersection of tracing
and livepatch. I am thinking about adding a BPF selftest to cover this
case.

Thanks,
Song

