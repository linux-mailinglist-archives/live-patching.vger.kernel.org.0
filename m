Return-Path: <live-patching+bounces-1114-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E9131A2842E
	for <lists+live-patching@lfdr.de>; Wed,  5 Feb 2025 07:17:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 528013A2989
	for <lists+live-patching@lfdr.de>; Wed,  5 Feb 2025 06:17:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 426332165E0;
	Wed,  5 Feb 2025 06:17:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="J1OE/RFg"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-qk1-f172.google.com (mail-qk1-f172.google.com [209.85.222.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5887120C02A;
	Wed,  5 Feb 2025 06:17:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738736241; cv=none; b=IpOdzV7Cwiscir466O1PprdEdglLn813Pw62zapnmzfSyaBF1F69Xdle67xvLDGFgTLx6vj66fMTrQgaqdHGeFm9Vd4EnSr0UNrdPsHdLcYmJWNWIGmnzAlkAhXZ3Fk225PrbKr4NDhXv1ZMbrNSpbDF8Vfk3FFYmqNeMiT1/o4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738736241; c=relaxed/simple;
	bh=pZVAyrBiEeTA4e6lbI11nddgrixvFpxatCAbBKmYYPA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kopMEIQBHFFBNpREu+2g6xkuoZFlbYNVlMw3ubVFWgu0t10dHq0CemnfpOONuLawaCaypt8oZgPPjJxt9Ez8XESfKBNijhKYoqscazojke3TBtzfRV80N3f5YdbQUJOdwPH6O+Cf7tz98MghanduaeanjiURmqLcw8e4NOI/uOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=J1OE/RFg; arc=none smtp.client-ip=209.85.222.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-7b6fc3e9e4aso580949785a.2;
        Tue, 04 Feb 2025 22:17:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1738736238; x=1739341038; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cCRgINirE+iODNY3WTd2udcTDH1gjU7AElssx8SU6Gg=;
        b=J1OE/RFgdUfYLtaixuMx9rZo6PrwIcC0BPCRdMm5Wv3e1qoTs8bkrNEjkkURZDWbT2
         PseBmYo1D0YOfuW2r9KFwsRLCtD6Kw7qqpMATYkcDLyuqgDnrgqvwVFGTs0uqdpYXl2s
         968x2pgs9sHqnQP1gr1jzsvceOb99HpuEL7dAZIEu5USQCGybFLdLo7aaRhBeU8Vr+sr
         XaZO0CtPUsVyL/638nYCiNUzrBEKL98ztG5UJqon3pnIZzzT+cor+HAR78Z1ZidzwQpw
         OeOmyO7MOmnwMsOkNRNx2dQ8RUfURmWgeEmHkun51c/0gvDIonVbihxZhZ6bGUUlPrdq
         gwvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738736238; x=1739341038;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cCRgINirE+iODNY3WTd2udcTDH1gjU7AElssx8SU6Gg=;
        b=okdsoZJ8i3zfAtXQCzDZypX5uGPOsxFu9QGCbmtx8RfZsaIycgMlBJ3/1gJwj4MiRl
         I+w5rRPFwAy36Nt2Ph4MO/OosGrv1SdOas7LRC/soBpOH/2/gCPsUpY55LGCJuQkViSX
         Q+Y+JUPmG3xe7jxUEr79+4iX/M3KSVOhYWAANczqsPFrh4n9U/4J5iYiKohhzZldQyA2
         DWIK8dNBxLhbj+QeSV9fVpxQSyQ+M+1sKF2KLkNRTnEpntg3LYsbNCNzdtI9beAaPLcn
         rqojMDfj8RQRCjGXDc9D1gajB8sa6RWmdNTePeJZpGrN1Vt5riytIacvjPkegZndOWWK
         YUbg==
X-Forwarded-Encrypted: i=1; AJvYcCU1jmkmb2GRAdJZ2+Lz9NVbKsNRUEA/aoeXU0sW1GtQCvrEaWKeA6Q5Xhmmk3US2xztdv+wOE+EcSmI0gJIFg==@vger.kernel.org, AJvYcCUYPzi0h45tXusbujXBE0wQ6CaLpGtbK4x/ZUNDjXAS4FkQwyPBjwOUyDsdxsWIuxHjPf7M7v5NA5KP9kY=@vger.kernel.org
X-Gm-Message-State: AOJu0YwUkRftWZaOTHZnc86Tj8zkKXvGzIn1Bqe0uy++W6SvTBETpW12
	f6meOZ57g505V2yr2rRYgnQJejyvoTqjXUzgzClf4SrLdtETqfC8AVgNtVHuxTWoQJfhgYSr+We
	i2GSZ15AQ9c+O6KlaerPTDhNTTT8=
X-Gm-Gg: ASbGncsbxc34RIzSqEEnPFZjT6F8qA7YNFSdbp9ZtPoOsI6iIlzp9bmPmFH+T8KbRDP
	R/PW7P4zKYKZ1xElNZul7WDBBRND2pJyMzaasY2VFVzdCi0vfkl/rCG2abbVedXIOxcd7qK15Up
	4=
X-Google-Smtp-Source: AGHT+IH/y2iclPbXaJW7mxStcSEO5pl9GdFXvnP9pmwhLakoL/fmL3EI5CUZY9HYaHfsWB2jMgn2Gc5QYj9XWZeXLNI=
X-Received: by 2002:a05:620a:2401:b0:7b6:eed4:695c with SMTP id
 af79cd13be357-7c039ff75c4mr293691385a.32.1738736238060; Tue, 04 Feb 2025
 22:17:18 -0800 (PST)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250127063526.76687-1-laoar.shao@gmail.com> <Z5eOIQ4tDJr8N4UR@pathway.suse.cz>
 <CALOAHbBZc6ORGzXwBRwe+rD2=YGf1jub5TEr989_GpK54P2o1A@mail.gmail.com>
 <alpine.LSU.2.21.2501311414281.10231@pobox.suse.cz> <CALOAHbDwsZqo9inSLNV1FQV3NYx2=eztd556rCZqbRvEu+DDFQ@mail.gmail.com>
 <Z6IQi4wpph0dnSD7@pathway.suse.cz>
In-Reply-To: <Z6IQi4wpph0dnSD7@pathway.suse.cz>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Wed, 5 Feb 2025 14:16:42 +0800
X-Gm-Features: AWEUYZlwxu766zS1EinatyqzFyllFw-NFGqizj8p3k56iZn2k_ASA6a0nvsxSzc
Message-ID: <CALOAHbBktE_jYd5zSzvmbo_K7PkFDXrykTqV1-ZDQju64EYPyg@mail.gmail.com>
Subject: Re: [RFC PATCH 0/2] livepatch: Add support for hybrid mode
To: Petr Mladek <pmladek@suse.com>
Cc: Miroslav Benes <mbenes@suse.cz>, jpoimboe@kernel.org, jikos@kernel.org, 
	joe.lawrence@redhat.com, live-patching@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 4, 2025 at 9:05=E2=80=AFPM Petr Mladek <pmladek@suse.com> wrote=
:
>
> On Mon 2025-02-03 17:44:52, Yafang Shao wrote:
> > On Fri, Jan 31, 2025 at 9:18=E2=80=AFPM Miroslav Benes <mbenes@suse.cz>=
 wrote:
> > >
> > > > >
> > > > >   + What exactly is meant by frequent replacements (busy loop?, o=
nce a minute?)
> > > >
> > > > The script:
> > > >
> > > > #!/bin/bash
> > > > while true; do
> > > >         yum install -y ./kernel-livepatch-6.1.12-0.x86_64.rpm
> > > >         ./apply_livepatch_61.sh # it will sleep 5s
> > > >         yum erase -y kernel-livepatch-6.1.12-0.x86_64
> > > >         yum install -y ./kernel-livepatch-6.1.6-0.x86_64.rpm
> > > >         ./apply_livepatch_61.sh  # it will sleep 5s
> > > > done
> > >
> > > A live patch application is a slowpath. It is expected not to run
> > > frequently (in a relative sense).
> >
> > The frequency isn=E2=80=99t the main concern here; _scalability_ is the=
 key issue.
> > Running livepatches once per day (a relatively low frequency) across al=
l of our
> > production servers (hundreds of thousands) isn=E2=80=99t feasible. Inst=
ead, we need to
> > periodically run tests on a subset of test servers.
>
> I am confused. The original problem was a system crash when
> livepatching do_exit() function, see
> https://lore.kernel.org/r/CALOAHbA9WHPjeZKUcUkwULagQjTMfqAdAg+akqPzbZ7Byc=
=3Dqrw@mail.gmail.com

Why do you view this patchset as a solution to the original problem?

>
> The rcu watchdog warning was first mentioned in this patchset.
> Do you see rcu watchdog warning in production or just
> with this artificial test, please?

So, we shouldn=E2=80=99t run any artificial tests on the livepatch, correct=
?
What exactly is the issue with these test cases?

>
>
> > > If you stress it like this, it is quite
> > > expected that it will have an impact. Especially on a large busy syst=
em.
> >
> > It seems you agree that the current atomic-replace process lacks scalab=
ility.
> > When deploying a livepatch across a large fleet of servers, it=E2=80=99=
s impossible to
> > ensure that the servers are idle, as their workloads are constantly var=
ying and
> > are not deterministic.
>
> Do you see the scalability problem in production, please?

Yes, the livepatch transition was stalled.


> And could you prove that it was caused by livepatching, please?

When the livepatch transition is stalled, running `kpatch list` will
display the stalled information.

>
>
> > The challenges are very different when managing 1K servers versus 1M se=
rvers.
> > Similarly, the issues differ significantly between patching a single
> > function and
> > patching 100 functions, especially when some of those functions are cri=
tical.
> > That=E2=80=99s what scalability is all about.
> >
> > Since we transitioned from the old livepatch mode to the new
> > atomic-replace mode,
>
> What do you mean with the old livepatch mode, please?

$ kpatch-build -R

>
> Did you allow to install more livepatches in parallel?

No.

> What was the motivation to switch to the atomic replace, please?

This is the default behavior of kpatch [1] after upgrading to a new version=
.

[1].  https://github.com/dynup/kpatch/tree/master

>
> > our SREs have consistently reported that one or more servers become
> > stalled during
> > the upgrade (replacement).
>
> What is SRE, please?

From the wikipedia : https://en.wikipedia.org/wiki/Site_reliability_enginee=
ring

> Could you please show some log from a production system?

When the SREs initially reported that the livepatch transition was
stalled, I simply advised them to try again. However, after
experiencing these crashes, I dug deeper into the livepatch code and
realized that scalability is a concern. As a result, periodically
replacing an old livepatch triggers RCU warnings on our production
servers.

[Wed Feb  5 10:56:10 2025] livepatch: enabling patch 'livepatch_61_release6=
'
[Wed Feb  5 10:56:10 2025] livepatch: 'livepatch_61_release6':
starting patching transition
[Wed Feb  5 10:56:24 2025] rcu_tasks_wait_gp: rcu_tasks grace period
1126113 is 10078 jiffies old.
[Wed Feb  5 10:56:38 2025] rcu_tasks_wait_gp: rcu_tasks grace period
1126117 is 10199 jiffies old.
[Wed Feb  5 10:56:52 2025] rcu_tasks_wait_gp: rcu_tasks grace period
1126121 is 10047 jiffies old.
[Wed Feb  5 10:56:57 2025] livepatch: 'livepatch_61_release6': patching com=
plete

PS: You might argue again about the frequency. If you believe this is
just a frequency issue, please suggest a suitable frequency.

>
>
> > > > > > Other potential risks may also arise
> > > > > >   due to inconsistencies or race conditions during transitions.
> > > > >
> > > > > What inconsistencies and race conditions you have in mind, please=
?
> > > >
> > > > I have explained it at
> > > > https://lore.kernel.org/live-patching/Z5DHQG4geRsuIflc@pathway.suse=
.cz/T/#m5058583fa64d95ef7ac9525a6a8af8ca865bf354
> > > >
> > > >  klp_ftrace_handler
> > > >       if (unlikely(func->transition)) {
> > > >           WARN_ON_ONCE(patch_state =3D=3D KLP_UNDEFINED);
> > > >   }
> > > >
> > > > Why is WARN_ON_ONCE() placed here? What issues have we encountered =
in the past
> > > > that led to the decision to add this warning?
> > >
> > > A safety measure for something which really should not happen.
> >
> > Unfortunately, this issue occurs during my stress tests.
>
> I am confused. Do you see the above WARN_ON_ONCE() during your
> stress test? Could you please provide a log?

Could you pls read my replyment seriously ?
https://lore.kernel.org/live-patching/Z5DHQG4geRsuIflc@pathway.suse.cz/T/#m=
5058583fa64d95ef7ac9525a6a8af8ca865bf354

>
> > > > > The main advantage of the atomic replace is simplify the maintena=
nce
> > > > > and debugging.
> > > >
> > > > Is it worth the high overhead on production servers?
> > >
> > > Yes, because the overhead once a live patch is applied is negligible.
> >
> > If you=E2=80=99re managing a large fleet of servers, this issue is far =
from negligible.
> >
> > >
> > > > Can you provide examples of companies that use atomic replacement a=
t
> > > > scale in their production environments?
> > >
> > > At least SUSE uses it as a solution for its customers. No many proble=
ms
> > > have been reported since we started ~10 years ago.
> >
> > Perhaps we=E2=80=99re running different workloads.
> > Going back to the original purpose of livepatching: is it designed to a=
ddress
> > security vulnerabilities, or to deploy new features?
>
> We (SUSE) use livepatches only for fixing CVEs and serious bugs.
>
>
> > If it=E2=80=99s the latter, then there=E2=80=99s definitely a lot of ro=
om for improvement.
>
> You might be right. I am just not sure whether the hybrid mode would
> be the right solution.
>
> If you have problems with the atomic replace then you might stop using
> it completely and just install more livepatches in parallel.

Why do we need to install livepatches in parallel if atomic replace is disa=
bled?
We only need to install the additional new livepatch. Parallel
installation is only necessary at boot time.

>
>
> My view:
>
> More livepatches installed in parallel are more prone to

I=E2=80=99m confused as to why you consider this a parallel installation is=
sue.

> inconsistencies. A good example is the thread about introducing
> stack order sysfs interface, see
> https://lore.kernel.org/all/AAD198C9-210E-4E31-8FD7-270C39A974A8@gmail.co=
m/
>
> The atomic replace helps to keep the livepatched functions consistent.
>
> The hybrid model would allow to install more livepatches in parallel exce=
pt
> that one livepatch could be replaced atomically. It would create even
> more scenarios than allowing all livepatches in parallel.
>
> What would be the rules, please?
>
> Which functionality will be livepatched by the atomic replace, please?
>
> Which functionality will be handled by the extra non-replaceable
> livepatches, please?
>
> How would you keep the livepatches consistent, please?
>
> How would you manage dependencies between livepatches, please?
>
> What is the advantage of the hybrid model over allowing
> all livepatches in parallel, please?

I can=E2=80=99t answer your questions if you insist on framing this as a
parallel installation issue.

--
Regards

Yafang

