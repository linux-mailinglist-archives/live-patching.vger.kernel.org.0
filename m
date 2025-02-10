Return-Path: <live-patching+bounces-1145-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 90C94A2E260
	for <lists+live-patching@lfdr.de>; Mon, 10 Feb 2025 03:51:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6DB5E3A5AE3
	for <lists+live-patching@lfdr.de>; Mon, 10 Feb 2025 02:50:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 864B853363;
	Mon, 10 Feb 2025 02:50:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IvxoziST"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com [209.85.219.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82E7F126C02;
	Mon, 10 Feb 2025 02:50:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739155850; cv=none; b=dilDfn/DTu0sjwv+rRyDBuWWV8lJ/RYVclHBIjsWv6/p0nghdgNa8MgoVWhSUwzS2DZYF8Z9q+y4py+IGDmcPZjszWt91uE0N1sBryDk9aChyxZeITD1LxHk9n6oKeVJx23kSGm6/syB75tv9tHdhJLw9h1eaFUBAf+EKltLuyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739155850; c=relaxed/simple;
	bh=76xzes49qZQQ+ZrW1wrDOC5gBpy9mX4Jzf/HLLoa0lg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qoVIU0Mm+axFpquiSw7tEuQFMV8uDgQrwQDDSFFf32MHD4aAsxivW1kjx8Ic63RG7bqb6JPXh8m3Are4br01a+ru01x3LBQv4bvPEFhJdjdG1dpZwGiXUlk5GiYIqCM8xY3AKi+oVEWnnwj25N3BKZ0hA9UfqTRF92bWXiPxw7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IvxoziST; arc=none smtp.client-ip=209.85.219.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-6e432beabbdso29214276d6.3;
        Sun, 09 Feb 2025 18:50:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1739155847; x=1739760647; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MHC8abhOLTo+IK0k0Tlk4SdfffAfHpPY+tvgZKxOkqs=;
        b=IvxoziSTIjtBAGptYVIbpVdGDVblblKqy+nC8w78WDRhGEVzND9eoRpQprfAhxYcTk
         jjOjhwamWhdjlc2WSHAYbQeuQFIfow8RHHNnM26YEzwJUkdaaL1dLkZ2zbsH8jjfOVTv
         bGTtyiq8v8FzZVMnuR68TN2eE0UIlx3sZJ4hADYF7hiDiTqk3TJCNiaiA7TVjSH0hzg5
         mmFFzfszK3PCrXWReiU52EN8nqK/sw4n6EKdP4vEaPYjtCOrl9IyHzOG17sAPu8LItVO
         mQnQEIrI1Ee5+VNRG+0IyFXkwWaJgWZUlugou84WnoypR1RC/eo7HvSHThO/Vd82dGYt
         Gq9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739155847; x=1739760647;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MHC8abhOLTo+IK0k0Tlk4SdfffAfHpPY+tvgZKxOkqs=;
        b=rznTJPxCJyPFZal8N8aGYlBpehoTvHuE/hbwO1xgiXRy4qJcbZzcL6vzGbZ/wCDrt3
         t/tv9jVY8NxNOa+BnYxv+PG+LIwPmMhXLiBnr5TRSqIgxDZ2dUYUeImtnADIfSNIral2
         zsa4O2j+0GzZrytUsZsYhvV57E+qWnaHOXAUKlenUAkWjJcCssZowGBYOhkCQSuyidaW
         /ma5fO2WvqxXxfPc3hBBMfO1/8QeUnUxSyCgOCNcyD6m724cL7g8Hi4k577idThV/mXH
         /tbbo7DO+mWCMwfhfoZhWguDXT1VHLX78Y4guNSeas3VU6IhWC0Hxa3wk697aH+nyMbo
         eU9A==
X-Forwarded-Encrypted: i=1; AJvYcCVOhz63ldcZ2r6y4oDUKGYQ5vN61mrZe4WkpclF8Gv3qkEvOSxNMAPvfHpIyC2pyfhYbGDDaEmZY35r9Z8=@vger.kernel.org, AJvYcCXZ3MEGCLwHmlySHoJ+gFCRjKgMsezjH6qmJnBy/2XDxsSnbF5IOj62dVwfZoqRImwl/WPEveJj7mm4xWEMRw==@vger.kernel.org
X-Gm-Message-State: AOJu0YzFjE2507Yq2s2VHectN5KhHEVnfqhgQNPQLU/c4EwxHFHbpVky
	DL8C5wi3Ri9FLSA6XY8ccm/HGkOXJ39UjisXtq1le8IdTm+qUj95ZcPs/FxUAMzPqPWkKBr+bNo
	yTJZZLYZWxNPiMe4ml0No+W7p0/A=
X-Gm-Gg: ASbGncsrJlIgNELliyw3AbSakfQdYNKkfYjvm3MZz05MQkDrm0E1Xlq5rxLz7EYZkP4
	KhbwGY7oIilgUwfamvD9a1A5FmyeHHpy0y1PUsF2NT9O9p4ZbJx98pgRl04F6mAywvrP96JHsWA
	==
X-Google-Smtp-Source: AGHT+IHHNqLSErUgRY17HszaiDl7aNNFwvoePCi/Y7WHzVw0G7QzTdKkWvt2kFkSVXjqKc/yM3ud20/9a4j02ysLcaw=
X-Received: by 2002:a05:6214:5094:b0:6e4:41a0:3bdb with SMTP id
 6a1803df08f44-6e4456713c0mr135762456d6.26.1739155847278; Sun, 09 Feb 2025
 18:50:47 -0800 (PST)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250127063526.76687-1-laoar.shao@gmail.com> <Z5eOIQ4tDJr8N4UR@pathway.suse.cz>
 <CALOAHbBZc6ORGzXwBRwe+rD2=YGf1jub5TEr989_GpK54P2o1A@mail.gmail.com>
 <alpine.LSU.2.21.2501311414281.10231@pobox.suse.cz> <CALOAHbDwsZqo9inSLNV1FQV3NYx2=eztd556rCZqbRvEu+DDFQ@mail.gmail.com>
 <Z6IQi4wpph0dnSD7@pathway.suse.cz> <CALOAHbBktE_jYd5zSzvmbo_K7PkFDXrykTqV1-ZDQju64EYPyg@mail.gmail.com>
 <Z6Xn61Bjm8pMd8zX@pathway.suse.cz> <CALOAHbBs5sfAxSw4HA6KwjWbH3GmhkHJqcni0d4iB7oVZ_3vjw@mail.gmail.com>
In-Reply-To: <CALOAHbBs5sfAxSw4HA6KwjWbH3GmhkHJqcni0d4iB7oVZ_3vjw@mail.gmail.com>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Mon, 10 Feb 2025 10:50:10 +0800
X-Gm-Features: AWEUYZmJ1kcFiT-RLkVv-BDbPvNTZHtgwkALqNoDsPSQySkJ23q6DnFf7iPC43Q
Message-ID: <CALOAHbC1OVHk8oqWAYkf0pMVUeUajJQFPvtT6tm1-ipxLcYV5A@mail.gmail.com>
Subject: Re: [RFC PATCH 0/2] livepatch: Add support for hybrid mode
To: Petr Mladek <pmladek@suse.com>
Cc: Miroslav Benes <mbenes@suse.cz>, jpoimboe@kernel.org, jikos@kernel.org, 
	joe.lawrence@redhat.com, live-patching@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Feb 8, 2025 at 10:49=E2=80=AFAM Yafang Shao <laoar.shao@gmail.com> =
wrote:
>
> On Fri, Feb 7, 2025 at 7:01=E2=80=AFPM Petr Mladek <pmladek@suse.com> wro=
te:
> >
> > On Wed 2025-02-05 14:16:42, Yafang Shao wrote:
> > > On Tue, Feb 4, 2025 at 9:05=E2=80=AFPM Petr Mladek <pmladek@suse.com>=
 wrote:
> > > >
> > > > On Mon 2025-02-03 17:44:52, Yafang Shao wrote:
> > > > > On Fri, Jan 31, 2025 at 9:18=E2=80=AFPM Miroslav Benes <mbenes@su=
se.cz> wrote:
> > > > > >
> > > > > > > >
> > > > > > > >   + What exactly is meant by frequent replacements (busy lo=
op?, once a minute?)
> > > > > > >
> > > > > > > The script:
> > > > > > >
> > > > > > > #!/bin/bash
> > > > > > > while true; do
> > > > > > >         yum install -y ./kernel-livepatch-6.1.12-0.x86_64.rpm
> > > > > > >         ./apply_livepatch_61.sh # it will sleep 5s
> > > > > > >         yum erase -y kernel-livepatch-6.1.12-0.x86_64
> > > > > > >         yum install -y ./kernel-livepatch-6.1.6-0.x86_64.rpm
> > > > > > >         ./apply_livepatch_61.sh  # it will sleep 5s
> > > > > > > done
> > > > > >
> > > > > > A live patch application is a slowpath. It is expected not to r=
un
> > > > > > frequently (in a relative sense).
> > > > >
> > > > > The frequency isn=E2=80=99t the main concern here; _scalability_ =
is the key issue.
> > > > > Running livepatches once per day (a relatively low frequency) acr=
oss all of our
> > > > > production servers (hundreds of thousands) isn=E2=80=99t feasible=
. Instead, we need to
> > > > > periodically run tests on a subset of test servers.
> > > >
> > > > I am confused. The original problem was a system crash when
> > > > livepatching do_exit() function, see
> > > > https://lore.kernel.org/r/CALOAHbA9WHPjeZKUcUkwULagQjTMfqAdAg+akqPz=
bZ7Byc=3Dqrw@mail.gmail.com
> > >
> > > Why do you view this patchset as a solution to the original problem?
> >
> > You discovered the hardlockup warnings when trying to reproduce the
> > original problem. At least, you mentioned this at
> > https://lore.kernel.org/r/20250122085146.41553-1-laoar.shao@gmail.com
> >
> > And using the hybrid module would allow to livepatch do_exit() only
> > once and do not touch it any longer. It is not the right solution
> > but it would be a workaround.
> >
> >
> > > > The rcu watchdog warning was first mentioned in this patchset.
> > > > Do you see rcu watchdog warning in production or just
> > > > with this artificial test, please?
> > >
> > > So, we shouldn=E2=80=99t run any artificial tests on the livepatch, c=
orrect?
> > > What exactly is the issue with these test cases?
> >
> > Some tests might be too artificial. They might find problems which
> > do not exist in practice.
> >
> > Disclaimer: I do not say that this is the case. You actually prove
> >         later in this mail that the hardlockup warning happen
> >         even in production.
> >
> > Anyway, if an artificial test finds a potential problem and the fix is
> > complicated then we need to decide if it is worth it.
> >
> > It does not make sense to complicate the code too much when
> > the fixed problem does not happen in practice.
> >
> >   + Too complicated code might introduce regressions which are
> >     more serious than the original problem.
> >
> >   + Too complicated code increases the maintenance cost. It is
> >     more complicated to add new features or fix bugs.
> >
> >
> > > > > > If you stress it like this, it is quite
> > > > > > expected that it will have an impact. Especially on a large bus=
y system.
> > > > >
> > > > > It seems you agree that the current atomic-replace process lacks =
scalability.
> > > > > When deploying a livepatch across a large fleet of servers, it=E2=
=80=99s impossible to
> > > > > ensure that the servers are idle, as their workloads are constant=
ly varying and
> > > > > are not deterministic.
> > > >
> > > > Do you see the scalability problem in production, please?
> > >
> > > Yes, the livepatch transition was stalled.
> >
> > Good to know.
> >
> > >
> > > > And could you prove that it was caused by livepatching, please?
> > >
> > > When the livepatch transition is stalled, running `kpatch list` will
> > > display the stalled information.
> >
> > OK.
> >
> > > > > The challenges are very different when managing 1K servers versus=
 1M servers.
> > > > > Similarly, the issues differ significantly between patching a sin=
gle
> > > > > function and
> > > > > patching 100 functions, especially when some of those functions a=
re critical.
> > > > > That=E2=80=99s what scalability is all about.
> > > > >
> > > > > Since we transitioned from the old livepatch mode to the new
> > > > > atomic-replace mode,
> > > >
> > > > What do you mean with the old livepatch mode, please?
> > >
> > > $ kpatch-build -R
> >
> > I am not familiar with kpatch-build. OK, I see the following at
> > https://github.com/dynup/kpatch/blob/master/kpatch-build/kpatch-build
> >
> > echo "          -R, --non-replace       Disable replace patch (replace =
is on by default)" >&2
> >
> > > >
> > > > Did you allow to install more livepatches in parallel?
> > >
> > > No.
> >
> > I guess that there is a misunderstanding. I am sorry my wording was
> > not clear enough.
> >
> > By "installing" more livepatches in parallel I meant to "have enabled"
> > more livepatches in parallel. It is possible only when you do not
> > use the atomic replace.
> >
> > By other words, if you use "kpatch-build -R" then you could have
> > enabled more livepatches in parallel.
> >
> >
> > > > What was the motivation to switch to the atomic replace, please?
> > >
> > > This is the default behavior of kpatch [1] after upgrading to a new v=
ersion.
> > >
> > > [1].  https://github.com/dynup/kpatch/tree/master
> >
> > OK. I wonder if the atomic replace simplified some actions for you.
>
> Actually, it simplifies the livepatch deployment since it only
> involves a single livepatch.
>
> >
> > I ask because the proposed "hybrid" model is very similar to the "old"
> > model which did not use the atomic replace.
>
> It=E2=80=99s essentially a hybrid of the old model and the atomic replace=
 model.
>
> >
> > What are the advantages of the "hybrid" model over the "old" model, ple=
ase?
>
> - Advantages compared to the old model
>   In the old model, it=E2=80=99s not possible to replace a specific livep=
atch
> with a new one. In the hybrid model, however, you can replace specific
> livepatches as needed.
>
> - Advantages and disadvantages compared to the atomic replace model
>    - Advantage
>      In the atomic replace model, you must replace all old
> livepatches, regardless of whether they are relevant to the new
> livepatch. In the hybrid model, you only need to replace the relevant
> livepatches.
>
>    - Disadvantage
>      In the atomic replace model, you only need to maintain a single
> livepatch. However, in the hybrid model, you need to manage multiple
> livepatches.
>
> >
> >
> > > > > our SREs have consistently reported that one or more servers beco=
me
> > > > > stalled during
> > > > > the upgrade (replacement).
> > > >
> > > > What is SRE, please?
> > >
> > > >From the wikipedia : https://en.wikipedia.org/wiki/Site_reliability_=
engineering
> >
> > Good to know.
> >
> > > > Could you please show some log from a production system?
> > >
> > > When the SREs initially reported that the livepatch transition was
> > > stalled, I simply advised them to try again. However, after
> > > experiencing these crashes, I dug deeper into the livepatch code and
> > > realized that scalability is a concern. As a result, periodically
> > > replacing an old livepatch triggers RCU warnings on our production
> > > servers.
> > >
> > > [Wed Feb  5 10:56:10 2025] livepatch: enabling patch 'livepatch_61_re=
lease6'
> > > [Wed Feb  5 10:56:10 2025] livepatch: 'livepatch_61_release6':
> > > starting patching transition
> > > [Wed Feb  5 10:56:24 2025] rcu_tasks_wait_gp: rcu_tasks grace period
> > > 1126113 is 10078 jiffies old.
> > > [Wed Feb  5 10:56:38 2025] rcu_tasks_wait_gp: rcu_tasks grace period
> > > 1126117 is 10199 jiffies old.
> > > [Wed Feb  5 10:56:52 2025] rcu_tasks_wait_gp: rcu_tasks grace period
> > > 1126121 is 10047 jiffies old.
> > > [Wed Feb  5 10:56:57 2025] livepatch: 'livepatch_61_release6': patchi=
ng complete
> >
> > I guess that this happens primary because there are many processes
> > running in kernel code:
> >
> >        + many processes =3D> long task list
> >        + in kernel code =3D> need to check stack
> >
> > I wondered how much it is caused by livepatching do_exit() which
> > takes tasklist_lock. The idea was:
>
> I=E2=80=99ll drop the changes in do_exit() and run the test again.

The RCU warning is still triggered even when the do_exit() is not
livepatched, but the frequency of occurrence decreases slightly.

However, with the following change, the RCU warning ceases to appear,
even when do_exit() is present and the test is run at a high frequency
(once every 5 seconds).

diff --git a/kernel/livepatch/transition.c b/kernel/livepatch/transition.c
index 30187b1..c436aa6 100644
--- a/kernel/livepatch/transition.c
+++ b/kernel/livepatch/transition.c
@@ -400,11 +400,22 @@ void klp_try_complete_transition(void)
         * unless the patch includes changes to a very common function.
         */
        read_lock(&tasklist_lock);
-       for_each_process_thread(g, task)
+       for_each_process_thread(g, task) {
+               if (task->patch_state =3D=3D klp_target_state)
+                       continue;
                if (!klp_try_switch_task(task))
                        complete =3D false;
+
+               if (need_resched()) {
+                       complete =3D false;
+                       break;
+               }
+       }
        read_unlock(&tasklist_lock);

+       /* The above operation might be expensive. */
+       cond_resched();
+
        /*
         * Ditto for the idle "swapper" tasks.
         */

--=20
Regards
Yafang

