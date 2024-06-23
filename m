Return-Path: <live-patching+bounces-360-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A534791376D
	for <lists+live-patching@lfdr.de>; Sun, 23 Jun 2024 04:53:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CD651282C04
	for <lists+live-patching@lfdr.de>; Sun, 23 Jun 2024 02:53:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9ACC88F44;
	Sun, 23 Jun 2024 02:53:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MU7D9/6q"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-qk1-f176.google.com (mail-qk1-f176.google.com [209.85.222.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C581864D
	for <live-patching@vger.kernel.org>; Sun, 23 Jun 2024 02:53:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719111199; cv=none; b=lr5RoF3ia5BtDJG+kCn/XY40KcaB/40/n/wwGh9C3W7pL/ASG22zCiEzy+8K5+u1kKdYLIMXkoTXKeLUuouD2URWp59R9ewSIi3E76MvwVoEMNvRoQJq+xe8vzhJUg7qn9kvtyNYBLtTqaF567ZBrJA78nHy7qCWNDaJMFWMo9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719111199; c=relaxed/simple;
	bh=4cEvYLkkUQQGIwFoOd0hJsfESM9cn29yADOgowyciA4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NJ3QAGeMDTQsr3aK4T4P82newPhMN+EIUL11M1i3wLBsZ1/7hq92hByKI7DaljqqWIquaMO3dXO5PSF4wFH4UN0Rt0PUo1RS6T/ruEbs9ofOSnlnQw5aAWWOT6JLiZ3iJ2OLqHaBaqjU5DUymEAIr4WDN6zIBvOJ4a/PCyemZsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MU7D9/6q; arc=none smtp.client-ip=209.85.222.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-795524bb6d9so206968785a.0
        for <live-patching@vger.kernel.org>; Sat, 22 Jun 2024 19:53:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1719111197; x=1719715997; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VHOQdelLiUUmve7GLV6zSOrQjLZXRVkZkI3PORAwbjs=;
        b=MU7D9/6q3q7HISfhv/5TEDyUHhwy0N1tETRAuU3kb7fj4nkc6KaAUI7jWIjjq0IvT7
         eBYv3oU6wtuXWuDSzIeb6pXaEZxAsXznth/Nxb/1ANyg0/2egaPqdCX0Mk8AzzGZCVZG
         waAzdkKDFnlI3RpYyWRnmiUrvQ/EEA2+hWKEoYIv6M+HRWduptBwJGkTwEdAL5HMgTt4
         iST1bCiU2EWpTzsynpt7sYTcmjrO6eJwJrhXXNBGpNkmQ4nhAq8Cu8CKQ24M3avBeN+q
         VrbW1f6tDEcA7de98NUyG+YSi0pNZrmfJ83PolKoUNBzVXpADiU1r0biJiklyRpcTBKF
         7+9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719111197; x=1719715997;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VHOQdelLiUUmve7GLV6zSOrQjLZXRVkZkI3PORAwbjs=;
        b=aT2VQv0D9L+o6WtH2pEH4VgTvlskclEoF17FN7EK3/EqAYJsD8iVmxIy2p95eC2ZUZ
         u/jJTj+v1FgKuyK/8kiCKj46T5SV9aie1cpWMYKDO+Q3QOEiWX4jm7E85xGCTM0AEiuC
         pBAHpphp3Tf6IvMTKxIEu+P7RK8Td6fAzluGenygW0Hc88ZjZPjP8UOy+rz8laFLjiVQ
         iu2Eom38D53nVQk++USs6QcHJCf3RBekCpRefJ03rga/kiKER+aZU1YwhCCkYPl4nR2F
         W8ldComWh3CmYpxztFIEoLRTJ3v3hq0XUEamWPXd61PuQKPCIkboGMZ54eoX6ZWpSLRY
         MlNg==
X-Forwarded-Encrypted: i=1; AJvYcCU+hGFHr3700+9dELQMA/P4ot99tkWjLMJuDQ6Mn2FoaQCmv3QFhphMZngYGuO4WajYDt0Y4Y4ekw593e0qCwXk4JRiUDoyEoUfvqJ7ZA==
X-Gm-Message-State: AOJu0YyZyYgD1M4GGRIufoJjQLIfh5QWD3eo0YqZRMZlm7K7VdxPaZSG
	AeuNsC/It4Srug2VF/eASUdZH/GALxshPCebu8dx5IJIPVnwEOxF8RKdlHqm1s6KDaXrBQOXZID
	+fPHZjV+/tRZYvhTbKloc2QQmpy8=
X-Google-Smtp-Source: AGHT+IFHRV8t26g1rdLvzm+c+FIGAJLmwDfTe7Rpo7yEmsljAuwVBtDDeJTK1YJmqqu9lPF+8xZiMHQK7OHHqKwqxNI=
X-Received: by 2002:a05:6214:18f4:b0:6b0:7ea7:4189 with SMTP id
 6a1803df08f44-6b540a95299mr8950776d6.42.1719111196682; Sat, 22 Jun 2024
 19:53:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240610013237.92646-1-laoar.shao@gmail.com> <CAPhsuW6MB8MgCtttk2QZDCF0Wu-r0c47kVk=a9o1_VUDPHOjVw@mail.gmail.com>
 <CALOAHbDPXDZQJENvN-yZM-OyrTy94kE6wMLGHt83m_y3O23bRQ@mail.gmail.com>
 <ZnUsYf1-Ue59Fjru@pathway.suse.cz> <CALOAHbByr3UMy=xzP82LA=D3rW-uw+s3XfzHQMVYxu4RomAANg@mail.gmail.com>
 <ZnVQJEoXpaONuTNE@pathway.suse.cz>
In-Reply-To: <ZnVQJEoXpaONuTNE@pathway.suse.cz>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Sun, 23 Jun 2024 10:52:40 +0800
Message-ID: <CALOAHbALyUdQqvjEiZ+2=3HaAyY94UL5ZTLT0ZzNPJH-vv=3GQ@mail.gmail.com>
Subject: Re: [PATCH v2 0/3] livepatch: Add "replace" sysfs attribute
To: Petr Mladek <pmladek@suse.com>
Cc: Song Liu <song@kernel.org>, jpoimboe@kernel.org, jikos@kernel.org, mbenes@suse.cz, 
	joe.lawrence@redhat.com, live-patching@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 21, 2024 at 6:04=E2=80=AFPM Petr Mladek <pmladek@suse.com> wrot=
e:
>
> On Fri 2024-06-21 16:39:40, Yafang Shao wrote:
> > On Fri, Jun 21, 2024 at 3:31=E2=80=AFPM Petr Mladek <pmladek@suse.com> =
wrote:
> > >
> > > On Tue 2024-06-11 10:46:47, Yafang Shao wrote:
> > > > On Tue, Jun 11, 2024 at 1:19=E2=80=AFAM Song Liu <song@kernel.org> =
wrote:
> > > > >
> > > > > Hi Yafang,
> > > > >
> > > > > On Sun, Jun 9, 2024 at 6:33=E2=80=AFPM Yafang Shao <laoar.shao@gm=
ail.com> wrote:
> > > > > >
> > > > > > Add "replace" sysfs attribute to show whether a livepatch suppo=
rts
> > > > > > atomic replace or not.
> > > > >
> > > > > I am curious about the use case here.
> > > >
> > > > We will use this flag to check if there're both atomic replace
> > > > livepatch and non atomic replace livepatch running on a single serv=
er
> > > > at the same time. That can happen if we install a new non atomic
> > > > replace livepatch to a server which has already applied an atomic
> > > > replace livepatch.
> > > >
> > > > > AFAICT, the "replace" flag
> > > > > matters _before_ the livepatch is loaded. Once the livepatch is
> > > > > loaded, the "replace" part is already finished. Therefore, I thin=
k
> > > > > we really need a way to check the replace flag before loading the
> > > > > .ko file? Maybe in modinfo?
> > > >
> > > > It will be better if we can check it before loading it. However it
> > > > depends on how we build the livepatch ko, right? Take the
> > > > kpatch-build[0] for example, we have to modify the kpatch-build to =
add
> > > > support for it but we can't ensure all users will use it to build t=
he
> > > > livepatch.
> > >
> > > > [0]. https://github.com/dynup/kpatch
> > >
> > > I still do not understand how the sysfs attribute would help here.
> > > It will show the type of the currently used livepatches. But
> > > it won't say what the to-be-installed livepatch would do.
> > >
> > > Could you please describe how exactly you would use the information?
> > > What would be the process/algorithm/logic which would prevent a mista=
ke?
> > >
> > > Honestly, it sounds like your processes are broken and you try
> > > to fix them on the wrong end.
> > >
> > > Allowing to load random livepatches which are built a random way
> > > sounds like a hazard.
> >
> > They are not random live patches. Some system administrators maintain
> > their own livepatches tailored for specific workloads or develop
> > livepatches for A/B testing. Our company=E2=80=99s kernel team maintain=
s the
> > general livepatches. This worked well in the past when all livepatches
> > were independent. However, the situation changed when we switched from
> > non atomic replace livepatches to atomic replace livepatches, causing
> > issues due to the uncertain behavior of mixed atomic replace and non
> > atomic replace livepatches.
>
> I think that the uncertain behavior has been even before you started
> using the atomic replace.
>
> How did the system administrators detect whether the livepatches were
> independent?
>
> It looks to me that it worked only by luck. Well, I could imagine
> that it has worked for a long time.

We have a limited number of livepatches in our system, primarily
intended to address critical issues that could potentially cause
system instability. Therefore, the likelihood of conflicts between two
livepatches is relatively low. While I acknowledge that there is
indeed a potential risk involved, it is the atomic replace livepatch
that poses this risk.

>
>
> > To address this change, we need a robust solution. One approach we
> > have identified is developing a CI build system for livepatches. All
> > livepatches must be built through this CI system, where they will
> > undergo CI tests to verify if they are atomic replace or not.
>
> The important part is that the livepatch authors have to see
> all already existing changes. They need to check that
> the new change would not break other livepatched code and
> vice versa.

Exactly. Through this CI system, all developers have visibility into
all the livepatches currently running on our system.

>
>
> > Additionally, in our production environment, we need to ensure that
> > there are no non atomic replace livepatches in use. For instance, some
> > system administrators might still build livepatches outside of our CI
> > system. Detecting whether a single livepatch is atomic replace or not
> > is not easy. To simplify this, we propose adding a new sysfs attribute
> > to facilitate this check.
> >
> > BTW, perhaps we could introduce a new sysctl setting to forcefully
> > forbid all non atomic replace livepatches?
>
> I like it. This looks like the most reliable solution. Would it
> solve your problem.
>
> Alternative solution would be to forbid installing non-replace
> livepatches when there is already installed a livepatch with
> the atomic replace. I could imagine that we enforce this for
> everyone (without sysctl knob). Would this work for you?

Perhaps we can add this sysctl knob as follows?

kernel.livepatch.forbid_non_atomic_replace:
    0 - Allow non atomic replace livepatch. (Default behavior)
    1 - Completely forbid non atomic replace livepatch.
    2 - Forbid non atomic replace livepatch only if there is already
an atomic replace livepatch running.

>
> That said, I am not completely against adding the sysfs attribute
> "replace". I could imagine that it might be useful when a more
> flexible solution is needed. But I think that it would be
> hard to make a more flexible solution safe, especially
> in your environment.

This sysfs attribute remains valuable as it aids in monitoring
livepatches, specifically allowing us to track which type of livepatch
is currently operating on a server.

--
Regards
Yafang

