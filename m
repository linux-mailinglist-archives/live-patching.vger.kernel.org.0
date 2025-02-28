Return-Path: <live-patching+bounces-1248-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 40872A49188
	for <lists+live-patching@lfdr.de>; Fri, 28 Feb 2025 07:24:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 048013B7BB5
	for <lists+live-patching@lfdr.de>; Fri, 28 Feb 2025 06:24:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 99EBE1C07C1;
	Fri, 28 Feb 2025 06:24:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="N+PF7P9/"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-qv1-f49.google.com (mail-qv1-f49.google.com [209.85.219.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AC7C23DE
	for <live-patching@vger.kernel.org>; Fri, 28 Feb 2025 06:24:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740723850; cv=none; b=uYhdO/lJT1EUHdvZicuX4TNGx2+FplOje3qQVO6g6ua49X8KTP/0j9G1GqVMtE8yMCKmbNpO42qo6pIeo3Sh2BCHWVChvclM769N5vb0EP2wzbt9qWW/HNW3NnfZTXQdjscsnvSXZNK3uMJ/b27mQaoRl3vjUs5BPWtROYe1+Po=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740723850; c=relaxed/simple;
	bh=1VVis7Dmck2cyPVM8aZJsyGb8g2qApEQoN0kQ6ynHmE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=CgCalQJ0b1fwcmhNBeLUrbqeOECXfQ8mhr2bZ8P+Rxgq0xM/AtPkt9PQCB8yV5vuY4ADL4OkesfSj3PIsUkUxqUvOlfZDDWbBhbD0B++SBbVBfCTpkHfibGOMKvw4ddz+3ka021ZSS+QxwRti5Rquc4STPKEHjX5so0QtLkp2Ig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=N+PF7P9/; arc=none smtp.client-ip=209.85.219.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qv1-f49.google.com with SMTP id 6a1803df08f44-6e1b11859a7so7308026d6.1
        for <live-patching@vger.kernel.org>; Thu, 27 Feb 2025 22:24:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740723844; x=1741328644; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=f9FZ/Ye3zkVmZcD0dhE8YWqpgLNGCNWjyzmgFrXwWzg=;
        b=N+PF7P9/HPVz0TC0SuaJHmSDP6vURBAVNgPLIEahUXSUOk318WleAMngBMzrrzC6qt
         bs17/VejcDvhw6rj0liVaoDBC5j/3/WqpzB8AHA/lThzYcFrVbUPQBXgkniE57d5Ietq
         7Gb1Rt/yBW1hSKJ91yAv/dJDsEjdSWgT3x2YOS0gMM8gLoE108oVKMxLt4jXOJSd8T27
         QFd5kpHb+iz453j/N0ENBUSPRy4PLbRAOEzSC4/XUME7sVOe/BQ1Tg7VoIDnPym1Qyzj
         B1APX08Cx3y6iwafkOWylhqDpi2pbAQOqyc529DkfcXp2vmzWOTbm7lwMIQOF9luHg2K
         Mb+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740723844; x=1741328644;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=f9FZ/Ye3zkVmZcD0dhE8YWqpgLNGCNWjyzmgFrXwWzg=;
        b=fcRt33wGesjJqZXVFBnn4GPz2UZ+BjRuHJoAY1y3Xz3YpfPmmqDzXJi+Gve6eynvIv
         HXG6S1wEHyw1HsOK6tymf+NICWjhebiBa3x+ovKBhHeG3wu6NNl8/XsIe1ZsUc6yRRIU
         Bh2sxHYZD5J4iAN8tTqhoQEQ8fwKYHZzaibCIuyXJxbNqoAZr/zq8qNknZhfn5CdS3RG
         UHotzKu4NHptu5VgQPzUF9MlQ1aSB+g+SNjEgKsOPeN+QCtgg8zrpg/sfePxYCDeERMt
         gNYtPZUXmZqf/EwJVSCTdXowTr9kuRe+xksHGX15n+icVixOXxT7enL/2U2jZZJVbZbP
         2mZg==
X-Forwarded-Encrypted: i=1; AJvYcCXOrMOk/fU+uxcqgJULEgdBvfp7lzucKnKYb5Pkh7DdxAPlqRMYdZgnBv47mHBxPpEACvZQiSTCD/LliTsP@vger.kernel.org
X-Gm-Message-State: AOJu0YyKBABHvz8wkTJcQ7PI//wzWo7ZUCpEbb4gUqtSQoB3x4Du5+LR
	DMF5EsSjJ++3fJ51WMK2UV7kPLxB7Qp7AEg8Vb7Pm4tLlctaLQSkQwIxMHGJ8fxsGCmp2HNFFAi
	/WAhhISX5OJf7hBEc/wowElqjNb4=
X-Gm-Gg: ASbGncullG7PVzgQABVEJZoA78/UKp3meOXr++7JuKedu9EOs88Kkq9ARuSJU07itJ1
	Kf1Yd/sH71GcEnCTS6HPCizkEaVC8t3V8GUUJoRaP4k+SOnkUsB9/5pYi0SJiMjLSg28WDxrcT+
	QR/wkfgRZm
X-Google-Smtp-Source: AGHT+IGLd9oqnbNkN8ihc+QfCrbyzKhSdE/eLLcgEFEpES/TCO3DQluX22gDiMsAf+dg0YR51geBujqJ43nfmoVrQZA=
X-Received: by 2002:a05:6214:2b0b:b0:6e6:a60f:24cf with SMTP id
 6a1803df08f44-6e8a0d27100mr39623166d6.19.1740723843605; Thu, 27 Feb 2025
 22:24:03 -0800 (PST)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250227024733.16989-1-laoar.shao@gmail.com> <20250227024733.16989-3-laoar.shao@gmail.com>
 <Z8CRXxfI24E9_IHC@pathway.suse.cz> <CALOAHbBE5m4ZMdCKCpZVuh5w50wfnRR3kyfu58ND=gKCNQz0ew@mail.gmail.com>
In-Reply-To: <CALOAHbBE5m4ZMdCKCpZVuh5w50wfnRR3kyfu58ND=gKCNQz0ew@mail.gmail.com>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Fri, 28 Feb 2025 14:23:26 +0800
X-Gm-Features: AQ5f1JrXiU99dcwtDONZQ8E53tScSy3VOVlytandPWDLJsuafRGq8F2QQAuSv-0
Message-ID: <CALOAHbD5CDTzde=jyvqDLz1WgdF6sZ4Lm5F=m396kdMH9nr+RQ@mail.gmail.com>
Subject: Re: [PATCH v3 2/2] livepatch: Replace tasklist_lock with RCU
To: Petr Mladek <pmladek@suse.com>
Cc: jpoimboe@kernel.org, jikos@kernel.org, mbenes@suse.cz, 
	joe.lawrence@redhat.com, live-patching@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 28, 2025 at 10:38=E2=80=AFAM Yafang Shao <laoar.shao@gmail.com>=
 wrote:
>
> On Fri, Feb 28, 2025 at 12:22=E2=80=AFAM Petr Mladek <pmladek@suse.com> w=
rote:
> >
> > On Thu 2025-02-27 10:47:33, Yafang Shao wrote:
> > > The tasklist_lock in the KLP transition might result high latency und=
er
> > > specific workload. We can replace it with RCU.
> > >
> > > After a new task is forked, its kernel stack is always set to empty[0=
].
> > > Therefore, we can init these new tasks to KLP_TRANSITION_IDLE state
> > > after they are forked. If these tasks are forked during the KLP
> > > transition but before klp_check_and_switch_task(), they can be safely
> > > skipped during klp_check_and_switch_task(). Additionally, if
> > > klp_ftrace_handler() is triggered right after forking, the task can
> > > determine which function to use based on the klp_target_state.
> > >
> > > With the above change, we can safely convert the tasklist_lock to RCU=
.
> > >
> > > Link: https://lore.kernel.org/all/20250213173253.ovivhuq2c5rmvkhj@jpo=
imboe/ [0]
> > > Link: https://lore.kernel.org/all/20250214181206.xkvxohoc4ft26uhf@jpo=
imboe/ [1]
> > > Suggested-by: Josh Poimboeuf <jpoimboe@kernel.org>
> > > Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
> > > ---
> > > --- a/kernel/livepatch/patch.c
> > > +++ b/kernel/livepatch/patch.c
> > > @@ -95,7 +95,13 @@ static void notrace klp_ftrace_handler(unsigned lo=
ng ip,
> > >
> > >               patch_state =3D current->patch_state;
> > >
> > > -             WARN_ON_ONCE(patch_state =3D=3D KLP_TRANSITION_IDLE);
> > > +             /* If the patch_state is KLP_TRANSITION_IDLE, it means =
the task
> > > +              * was forked after klp_init_transition(). In this case=
, the
> > > +              * newly forked task can determine which function to us=
e based
> > > +              * on the klp_target_state.
> > > +              */
> > > +             if (patch_state =3D=3D KLP_TRANSITION_IDLE)
> > > +                     patch_state =3D klp_target_state;
> > >
> >
>
> I'm a bit confused by your example. Let me break it down to ensure I
> understand correctly:
>
> > CPU0                            CPU1
> >
> > task_0 (forked process):
> >
> > funcA
> >   klp_ftrace_handler()
> >     if (patch_state =3D=3D KLP_TRANSITION_IDLE)
> >        patch_state =3D klp_target_state
> >         # set to KLP_TRANSITION_PATCHED
> >
> >   # redirected to klp_funcA()
>
> It seems that the KLP  is still in the process of transitioning, right?
>
> >
> >
> >                                 echo 0 >/sys/kernel/livepatch/patch1/en=
abled
> >
> >                                 klp_reverse_transition()
> >
> >                                   klp_target_state =3D !klp_target_stat=
e;
> >                                     # set to KLP_TRANSITION_UNPATCHED
>
> If you attempt to initiate a new transition while the current one is
> still ongoing, the __klp_disable_patch function will return -EBUSY,
> correct?
>
> __klp_disable_patch
>     if (klp_transition_patch)
>         return -EBUSY;
>
> On the other hand, if klp_transition_patch is NULL, it indicates that
> the first KLP transition has completed successfully.

Please disregard my previous comment.
I missed the fact that it is called from klp_reverse_transition().
I will review your example again and give it more thought.

--=20
Regards
Yafang

