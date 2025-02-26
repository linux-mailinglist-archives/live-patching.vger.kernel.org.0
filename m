Return-Path: <live-patching+bounces-1232-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B6A3A45422
	for <lists+live-patching@lfdr.de>; Wed, 26 Feb 2025 04:47:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 59CD816F8BF
	for <lists+live-patching@lfdr.de>; Wed, 26 Feb 2025 03:47:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 07844266B6A;
	Wed, 26 Feb 2025 03:47:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HPX77T/5"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-qv1-f49.google.com (mail-qv1-f49.google.com [209.85.219.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A2CE42AB4;
	Wed, 26 Feb 2025 03:47:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740541648; cv=none; b=NzRAyX/SL0KozDVX0yDrj823+Jk07mjz2tKxYhmNi7I+FyurskxuYcGyjJ93Msxy82UCDWL3aA/c+2Wq8uv2vT68xebY/B2qyhdazcJ4JCpUH8vyjTuUcFOmCebKrd6d69ubuS0QnAGx1miBZ3InVrOyQsyox3Lb/1rTJkEKEXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740541648; c=relaxed/simple;
	bh=kbzTfEFTc42i/4CW4iSA0pKghpwg4lWEx58lDd/Nxyc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZBUF0Td01MGO7TYElKKs7JAtQX/ugH6ouqwlEo5hMIlNH/B1eJcUdXAHPJ6pDMXKz6JxXRSfELL+mn4KseaQrlCSQkE7uUb4RgpZmMdgwgugf0TXgwRVHdKmWLnaRf/orutMxH3e41uVUlcTTsWSOHqHPDdTGOeswdDESUG3PYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HPX77T/5; arc=none smtp.client-ip=209.85.219.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qv1-f49.google.com with SMTP id 6a1803df08f44-6e65d6e1f12so79430966d6.0;
        Tue, 25 Feb 2025 19:47:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740541646; x=1741146446; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZSJhmAbNuFPvPvbPYk7L0OT8cajN6anynVXiM0Y3tPc=;
        b=HPX77T/5PFMmp6BDYRFrHjbhqIY6lq7IedWsC9CYSjt30mLkKTeKgpOhMdIE6O6xLg
         Db6Owobw/JyMkMg6NYCojWIlsK0kReXhEcc1Q/78X14gBan4T8duFM6nzLCOIs1b+2Nt
         LWT7ffNzrWkBi4KdiMy0qsmgkmOQWqb+JLEVPxVkXX/BVjp75br/6HUJjNkmePBtDKGe
         lKkytRT82tT+gAoZPVPta+GFjKPmkn4WS9njPbW/6L40m01iG6f7nfCVR4v0YPyoho+Y
         +nVA8Jgy7CTVX0Xc+oTN0xyrW/IODk45hx9vLGdowAjlDDlwU9csGFoS6QSgNE1C93sv
         HDgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740541646; x=1741146446;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZSJhmAbNuFPvPvbPYk7L0OT8cajN6anynVXiM0Y3tPc=;
        b=ZNuApjboZFVyoDDyFxieUR7HjL4d5Ov04pj9Img90JvT3veMJOiaa5XmUfJqDkZApc
         b+kLIenDFtNO8PR8I0Jhbnyb+9DD99LsxWo23gZoDkVzlpOSrDRZaXpi5s23VpJSVFw7
         GMu1n6zSJLjtGT8EnohKcCkOhWAEk0sthxqHYOxbdB0PQFaOgLKhCEJENkiy+jdK5Clo
         A5eKW/SHXByq8G7Lzpwe3jW/b4cuxX2BPUC10AKrwh3yjgl2ml9KJk0ejXQpc8qyCkWb
         VpzKVqXESQfe4cgu1zU2JRy5CHDM3DAo2Nrlu01ep6XWtlkylqixq14PAaT8Jq9Z34LU
         uPaQ==
X-Forwarded-Encrypted: i=1; AJvYcCUW6bK88F6+cMQTse9aokqrvwSruXxtLZX6WA4zbBV9Wo9VOPwXVELtFFS/jjDiuWf8CpiWXRUiGPVUMhel1A==@vger.kernel.org, AJvYcCVfORxPGjQvFyGsaDVXocBlE1CJfIFZdmCgyruVhxvxPjbyxkDX7b5xT9b43szAXMBFDlEPe1wckvU58tc=@vger.kernel.org
X-Gm-Message-State: AOJu0YzURsZOchNfWrBBxvWLbrqTVcU5w7Vb122yJxWJcYfCSHpBHgos
	9EVxXk1/bnmmvdEzIDsNDlO0Ag/AHN0FJq9wDa2RzSo18nkIPFmayI0fLz+71hx2kcQwAxi/QTE
	joG4eIsP2gu8Qmw6WUPPtkzPNaHk=
X-Gm-Gg: ASbGncunVbtZk+Fej6OPb35S0RCDgGu1s5Ax01yW4HD5HfKsPcqSLvMgnZjEL93HwqH
	4dHFjbiH8eefFXiV1y6lgg4if0ju4tCqButEFlJoEwi8FLY0ZtQ9VnTafHjrMsijP6qvt6pYD3N
	gIjlScO8hG
X-Google-Smtp-Source: AGHT+IE4Gdw9CcFvSKMLJIzqS9mSmsmlvzZNg5/hmMPKSTuQrBW8M3Kd3gCQToYlIyQXlgD3CMI4THe4eN13hJd4ta4=
X-Received: by 2002:a05:6214:402:b0:6d8:8466:d205 with SMTP id
 6a1803df08f44-6e87ab14369mr82912316d6.6.1740541646358; Tue, 25 Feb 2025
 19:47:26 -0800 (PST)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250223062046.2943-1-laoar.shao@gmail.com> <20250223062046.2943-3-laoar.shao@gmail.com>
 <20250225183308.yjtgdl3esisvlhab@jpoimboe>
In-Reply-To: <20250225183308.yjtgdl3esisvlhab@jpoimboe>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Wed, 26 Feb 2025 11:46:50 +0800
X-Gm-Features: AQ5f1JqAkTcNbfvs-xt53XUJirI6BZqpqPgGmZ6moHy2ERZ2y4U6dOAqL9rwrLc
Message-ID: <CALOAHbDcKoO4Wicva_qtNy4fNyS+ey7_PybbmXSk_xhKM=ZG=A@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] livepatch: Replace tasklist_lock with RCU
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: jikos@kernel.org, mbenes@suse.cz, pmladek@suse.com, 
	joe.lawrence@redhat.com, live-patching@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 26, 2025 at 2:33=E2=80=AFAM Josh Poimboeuf <jpoimboe@kernel.org=
> wrote:
>
> On Sun, Feb 23, 2025 at 02:20:46PM +0800, Yafang Shao wrote:
> > +++ b/kernel/livepatch/patch.c
> > @@ -95,7 +95,12 @@ static void notrace klp_ftrace_handler(unsigned long=
 ip,
> >
> >               patch_state =3D current->patch_state;
> >
> > -             WARN_ON_ONCE(patch_state =3D=3D KLP_TRANSITION_IDLE);
> > +             /* If the patch_state is KLP_TRANSITION_IDLE, it indicate=
s the
> > +              * task was forked after klp_init_transition(). For this =
newly
> > +              * forked task, it is safe to switch it to klp_target_sta=
te.
> > +              */
> > +             if (patch_state =3D=3D KLP_TRANSITION_IDLE)
> > +                     current->patch_state =3D klp_target_state;
>
> Hm, but then the following line is:
>
> >               if (patch_state =3D=3D KLP_TRANSITION_UNPATCHED) {
>
> Shouldn't the local 'patch_state' variable be updated?

Ah, I missed it.

>
> It also seems unnecessary to update 'current->patch_state' here.

Got it.

>
> > @@ -294,6 +294,13 @@ static int klp_check_and_switch_task(struct task_s=
truct *task, void *arg)
> >  {
> >       int ret;
> >
> > +     /* If the patch_state remains KLP_TRANSITION_IDLE at this point, =
it
> > +      * indicates that the task was forked after klp_init_transition()=
. For
> > +      * this newly forked task, it is now safe to perform the switch.
> > +      */
> > +     if (task->patch_state =3D=3D KLP_TRANSITION_IDLE)
> > +             goto out;
> > +
>
> This also seems unnecessary.  No need to transition the patch if the
> ftrace handler is already doing the right thing.  klp_try_switch_task()
> can just return early on !TIF_PATCH_PENDING.

Good suggestion.

>
> > @@ -466,11 +474,11 @@ void klp_try_complete_transition(void)
> >        * Usually this will transition most (or all) of the tasks on a s=
ystem
> >        * unless the patch includes changes to a very common function.
> >        */
> > -     read_lock(&tasklist_lock);
> > +     rcu_read_lock();
> >       for_each_process_thread(g, task)
> >               if (!klp_try_switch_task(task))
> >                       complete =3D false;
> > -     read_unlock(&tasklist_lock);
> > +     rcu_read_unlock();
>
> Can this also be done for the idle tasks?

The cpus_read_lock() around the idle tasks is in place to protect
against CPU hotplug operations. If we aim to eliminate this lock
during the KLP transition, the CPU hotplug logic would need to be
adjusted accordingly. For instance, we would need to address how to
handle wake_up_if_idle() when a CPU is in the process of hotplugging.

Given that the number of CPUs is unlikely to be large enough to create
a bottleneck in the current implementation, optimizing this mechanism
may not be a priority at the moment. It might be more practical to
address this issue at a later stage.


--
Regards
Yafang

