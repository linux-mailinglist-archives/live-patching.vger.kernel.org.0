Return-Path: <live-patching+bounces-1066-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9A2D5A1D9A6
	for <lists+live-patching@lfdr.de>; Mon, 27 Jan 2025 16:35:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ED1EE3A1C14
	for <lists+live-patching@lfdr.de>; Mon, 27 Jan 2025 15:35:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8EBD7757F3;
	Mon, 27 Jan 2025 15:35:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ae7nyfpT"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com [209.85.219.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFF701AAC9;
	Mon, 27 Jan 2025 15:35:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737992130; cv=none; b=iTE9htF1yJXfDEl0uhEjdqBgLxProGnEy/41XzwSzUOugc0y6ex2uEIDX/VzBsklVZRYIDZhtyG/3MlFOCNeknHmFeeVtb6fMnWJL8VaZkSRtguudKp1PWW7O73Xk8gy8X4L/htmtratudgSKoWWWfU1XLNs0MIFW6AJgo3QgCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737992130; c=relaxed/simple;
	bh=RbgUsxUTLd0zkGrI8qPoMJr6AnDF+2o4vC+Na4nHWyk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=sELCq8JWaLpUqpC5kXEUGsacMesS/cmUyEdVIHIMIraj7n0/XUJRl8QsqzZPY+Ybg9TM0AjpCT4LxTDQZnY98X+E1TFrRh3CLN40cIfk150eo7AyVrh0fZNAGLnq28iIXYQ2P/ZPmU845skY5zkoQ+dz1Xh6MQk502xwWkedxOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ae7nyfpT; arc=none smtp.client-ip=209.85.219.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-6d88cb85987so42071346d6.1;
        Mon, 27 Jan 2025 07:35:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1737992127; x=1738596927; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=09SBPi/73I013klYaXQMD6D3zd6n5M+dOTgnQypfV1s=;
        b=Ae7nyfpTp/YT6mxLeO14yMVKbDytCaIIwSNLDlcXUiiMRPgRAIZ+f8oL37KtxMAwJm
         NPD/OwJ2+OkOZUQ/IOCuGO5AilLSnHU01ehToIBBQyZgP62nSJiPGdwiqRRIxTZ2xgDB
         vtOWsEYGEIQgIIPjop7vEhFfFgrI5NlkfNVENTUg9MkY6ESRe9RSFensstqaesXnnaRP
         v3kWbEXE+P3OgQBAdUO432Z0yCqo/AFEw2myA/1NAgoEDZtIefNS3QsaKM3ONMRtVCR4
         Jjk1qOYkAf4ETVnrFG6Qa+3wB+lDzaoEraHZ+HBFAQASYdurf6xYLDmIE9eEfVI7Asxv
         mlGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737992127; x=1738596927;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=09SBPi/73I013klYaXQMD6D3zd6n5M+dOTgnQypfV1s=;
        b=aGfWJNh8/Thjt+Yd6WogFfZP9QsPqwPgGxucJUfzTQZB2gih4+RZqzHvwPUYOq4TFY
         pPNQW0hH+QNwTddvrEAt5D6JcyjiRTpYPAM7Q0OcFHFpnuxt4tEZVlUa4vSpqqtcwhe/
         O/N0iyW8vmVO7ARSrz4CMEK+pYAxdOhmBObx1+sGWSrR24khLxTu48p0uG/XczirmNwV
         eIbn9rrZ+h/ahSlURg7ZbqaOes1R1C25ssqGYWe1C7VPa5mLEsh+IKDjESHeT2sQDej/
         P1ZGz6hO8Tk+Oryev7SPCBUZ+9KxAA8SRGYUJ2IC5MGTPK3zUmj7x3a6KNGzr0K1Mtb7
         pDRw==
X-Forwarded-Encrypted: i=1; AJvYcCWNrE+9GhuUi1DXd0yZ/hzi9Ktf3QcNuJkllb7wRWexPcW+0Xr227cD/8Y7+FdszhtvUkyc0S3z0ewoIUc=@vger.kernel.org, AJvYcCXx66UNqiyAKEQp8MnyC1RqiAEp3DMnbR016Q8kXwtuMGXojrIcEo1+KSIDqWOlt5/HfkaDideo8pctietsdQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YzjBjCcPvsbKRhXzE+PS9bZI++gAIR1UiWGdCrP2lgCQs0AGeEr
	MWB94P+uWdAXUa/JG03pDtKiCUxl0+0ru4HJs12uq8kAk2M2x9oySzZJqOCejiyhDxQpI3GQPCm
	XnEjgimRSipMePLn6+wxxKXe7BQw=
X-Gm-Gg: ASbGncsjqp4eJUINvAg8QMBEfnrMoIkkOOMq0TGG0513sCF4B/4GXwLvP7u0XO8LCWh
	BhWa3PdyC0aiSQoHZYoh+bP/2Q93fMeUfhI1A1Hbd39igZgj6wA9HRwaP1b4s7GWry1HSFgbAGw
	w=
X-Google-Smtp-Source: AGHT+IHs9F9z+4ZfCjpqf6xD8karIpKg03O3KPBj6f2iQXSgUua3zYSEW2cfvekMzB039ccoPo8S+9KQEi63pYZZXt8=
X-Received: by 2002:ad4:5cc7:0:b0:6d8:99cf:d2d0 with SMTP id
 6a1803df08f44-6e1f9fd7877mr315143846d6.19.1737992127587; Mon, 27 Jan 2025
 07:35:27 -0800 (PST)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250127063526.76687-1-laoar.shao@gmail.com> <20250127063526.76687-3-laoar.shao@gmail.com>
 <Z5eYzcF5JLR4o5Yl@pathway.suse.cz>
In-Reply-To: <Z5eYzcF5JLR4o5Yl@pathway.suse.cz>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Mon, 27 Jan 2025 23:34:50 +0800
X-Gm-Features: AWEUYZm_26bKVZQwumRmaA9TM5XLmcboQ_C8G_aKYqxmLnkbrsEgmsJhGKYLz4U
Message-ID: <CALOAHbANtpY+ee9Wd+HV6-uPOw+Kq1JcU5UdOXjz8m_UJ_-XRA@mail.gmail.com>
Subject: Re: [RFC PATCH 2/2] livepatch: Implement livepatch hybrid mode
To: Petr Mladek <pmladek@suse.com>
Cc: jpoimboe@kernel.org, jikos@kernel.org, mbenes@suse.cz, 
	joe.lawrence@redhat.com, live-patching@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 27, 2025 at 10:31=E2=80=AFPM Petr Mladek <pmladek@suse.com> wro=
te:
>
> On Mon 2025-01-27 14:35:26, Yafang Shao wrote:
> > The atomic replace livepatch mechanism was introduced to handle scenari=
os
> > where we want to unload a specific livepatch without unloading others.
> > However, its current implementation has significant shortcomings, makin=
g
> > it less than ideal in practice. Below are the key downsides:
>
> [...]
>
> > In the hybrid mode:
> >
> > - Specific livepatches can be marked as "non-replaceable" to ensure the=
y
> >   remain active and unaffected during replacements.
> >
> > - Other livepatches can be marked as "replaceable," allowing targeted
> >   replacements of only those patches.
> >
> > This selective approach would reduce unnecessary transitions, lower the
> > risk of temporary patch loss, and mitigate performance issues during
> > livepatch replacement.
> >
> > --- a/kernel/livepatch/core.c
> > +++ b/kernel/livepatch/core.c
> > @@ -658,6 +658,8 @@ static int klp_add_nops(struct klp_patch *patch)
> >               klp_for_each_object(old_patch, old_obj) {
> >                       int err;
> >
> > +                     if (!old_patch->replaceable)
> > +                             continue;
>
> This is one example where things might get very complicated.

Why does this example even exist in the first place?
If hybrid mode is enabled, this scenario could have been avoided entirely.

>
> The same function might be livepatched by more livepatches, see
> ops->func_stack. For example, let's have funcA and three livepatches:
> a
>   + lp1:
>         .replace =3D false,
>         .non-replace =3D true,
>         .func =3D {
>                         .old_name =3D "funcA",
>                         .new_func =3D lp1_funcA,
>                 }, { }
>
>   + lp2:
>         .replace =3D false,
>         .non-replace =3D false,
>         .func =3D {
>                         .old_name =3D "funcA",
>                         .new_func =3D lp2_funcA,
>                 },{
>                         .old_name =3D "funcB",
>                         .new_func =3D lp2_funcB,
>                 }, { }
>
>
>   + lp3:
>         .replace =3D true,
>         .non-replace =3D false,
>         .func =3D {
>                         .old_name =3D "funcB",
>                         .new_func =3D lp3_funcB,
>                 }, { }
>
>
> Now, apply lp1:
>
>       + funcA() gets redirected to lp1_funcA()
>
> Then, apply lp2
>
>       + funcA() gets redirected to lp2_funcA()
>
> Finally, apply lp3:
>
>       + The proposed code would add "nop()" for
>         funcA() because it exists in lp2 and does not exist in lp3.
>
>       + funcA() will get redirected to the original code
>         because of the nop() during transition
>
>       + nop() will get removed in klp_complete_transition() and
>         funcA() will get suddenly redirected to lp1_funcA()
>         because it will still be on ops->func_stack even
>         after the "nop" and lp2_funcA() gets removed.
>
>            =3D> The entire system will start using another funcA
>               implementation at some random time
>
>            =3D> this would violate the consistency model
>
>
> The proper solution might be tricky:
>
> 1. We would need to detect this situation and do _not_ add
>    the "nop" for lp3 and funcA().
>
> 2. We would need a more complicate code for handling the task states.
>
>    klp_update_patch_state() sets task->patch_state using
>    the global "klp_target_state". But in the above example,
>    when enabling lp3:
>
>     + funcA would need to get transitioned _backward_:
>          KLP_TRANSITION_PATCHED -> KLP_TRANSITION_UNPATCHED
>       , so that it goes on ops->func_stack:
>          lp2_funcA -> lp1->funcA
>
>    while:
>
>     + funcA would need to get transitioned forward:
>          KLP_TRANSITION_UNPATCHED -> KLP_TRANSITION_PATCHED
>       , so that it goes on ops->func_stack:
>          lp2_funcB -> lp3->funcB
>
>
> =3D> the hybrid mode would complicate the life for both livepatch
>    creators/maintainers and kernel code developers/maintainers.
>

I don=E2=80=99t believe they should be held responsible for poor
configurations. These settings could have been avoided from the start.
There are countless tunable knobs in the system=E2=80=94should we try to
accommodate every possible combination? No, that=E2=80=99s not how systems =
are
designed to operate. Instead, we should identify and follow best
practices to ensure optimal functionality.

>    I am afraid that this complexity is not acceptable if there are
>    better solutions for the original problem.
>
> >                       err =3D klp_add_object_nops(patch, old_obj);
> >                       if (err)
> >                               return err;
>
> I am sorry but I am quite strongly against this approach!
>
> Best Regards,
> Petr



--
Regards
Yafang

