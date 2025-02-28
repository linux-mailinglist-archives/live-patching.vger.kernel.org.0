Return-Path: <live-patching+bounces-1247-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 08403A48EB5
	for <lists+live-patching@lfdr.de>; Fri, 28 Feb 2025 03:39:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C65D03B6CAE
	for <lists+live-patching@lfdr.de>; Fri, 28 Feb 2025 02:38:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C1D8F7081F;
	Fri, 28 Feb 2025 02:38:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YpzNKWLw"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-qv1-f45.google.com (mail-qv1-f45.google.com [209.85.219.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D51913F9C5
	for <live-patching@vger.kernel.org>; Fri, 28 Feb 2025 02:38:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740710337; cv=none; b=cE+s825IiCImB/oVbFgpOwretS02TNQfgGh5dTsSyTx6+hDBTDKkM+uE/+ux6PIklr9KxY6NZ91DpFhWQrncE4V2zwUxWLeHcHtfMNp2Os06ormw86mxMkfbLyQLccoZmSNRm77puFoyyB5p+FJ3pezGSoW1I4wmPSLR7wnLLdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740710337; c=relaxed/simple;
	bh=hRp1RjPDsex0DO7NoR6G1VnZOVaaIfJ7/+dukEGX//w=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gTWbQxAdNGp60+Gmzq4MeYhTUOy8yqoucg2YbyQDv1+XKKRusMgVKaglNawLBAOEdqWaQb1QJKsY9RN2Tw3l3GXqbTA2IdZuwX/JoE4pOPnWaQFmDrF5xNUlI660wlGGhGfCEVAByqv5wIDV0uoUO0/ic0sX2NykVM1b4rGoU90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YpzNKWLw; arc=none smtp.client-ip=209.85.219.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qv1-f45.google.com with SMTP id 6a1803df08f44-6e894b81678so8789256d6.0
        for <live-patching@vger.kernel.org>; Thu, 27 Feb 2025 18:38:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740710334; x=1741315134; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JXMeWHtmabEt/OT/JNZFVkUXj/ELmG3ouMCpz75VB+w=;
        b=YpzNKWLwIQOZf2CCGT+4sVYZR2lLVQKiUfXTqfOe7rGBvZprbiHMLyJRrfz9ijWdji
         7ck/6ZfSq3gA5pg4kTO69Hv6jYEz5LbsHzHJ7yV6eCE0RXWJRuEg21/phmgmeTKoMR1R
         mUdYuZZaD3IuLywotE6Rdj8cRx5TXTsDgGiKSaBprw99cuIc1ZoFD6X0CkUsZTW5BOjf
         TR9prhipMY2+WBL0/nvbhcpSTWK9+KNAPeh0yAv9HZPIcE/Ejeys7bhhpAwCc1lf0u1Y
         g00mpo5yy3RMuA9t3aUIsdLpXYEv2G1h11cm07rwjvromwOLgv3MF++mqZS9+rtExQY3
         N3Iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740710334; x=1741315134;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JXMeWHtmabEt/OT/JNZFVkUXj/ELmG3ouMCpz75VB+w=;
        b=BVi5p7e091jynjdO7l9ltoMCzwLhWVnr1X/ZN1U97y9+G25DrzT/rCvHMCDtOrMeeI
         gk2mdK0pyM2WtEl2tM+Oth806O1Bx1qLwA9iDE7WJgO4XwdzE6MBUhf1oMMrY1Bezeoh
         yQX/tDBvopezctmQhjjMp7GQcQ0hKcLj8jxE8WdzIICqC0ITu2KuKk0eDWzLSfgF5TST
         ytt4t3yt5AWaGx1O2EB7LYQR6dfMBIMHhPE+0s70/R6pTLg1RSZxDxYZHdodVMPJEShy
         LMWVftmA/UWpOYwMJzng06i9VEH4BBFxCVALhyqV1+GQCn3LiwfNjUas1AJsIl31DQVJ
         Y7Uw==
X-Forwarded-Encrypted: i=1; AJvYcCXBJIHk+gyLM1Llw/idxZth6vAVKLun8dwZoi6VHeTQUweC35AEYQ3oMefEQnjUUNcn4MsZ6J6n4uLB0qIM@vger.kernel.org
X-Gm-Message-State: AOJu0YypvfJ1bajxpQURS7vOPWXLHIb2A2Jss/w8fmoblPwS20KPzM70
	pun6/Dqegk7wXjIkJ57wxIJGHMeEmUmLcfADf/vUdCcCPWg9AvGzmeNUoELdzapMDuHbehYUAWG
	09akaIEiBXrI8tptqm7CIip8CXSFHpR+PelcEuw==
X-Gm-Gg: ASbGnctH2WcC6IkCGT+uzafH53t671RjS5UN8LJqBMq6U00nx9RTAHZoMd7UKtftpFk
	ySHsbVUWEJbauDT8DnosF0/mnwvUg8G7g6X6kisRTyK+75QaQ1lolNrrG+JP2NFF8UHA0jWwvOf
	+jSAcieYVy
X-Google-Smtp-Source: AGHT+IEVt+dHZdSv5/iWUeBpjkJOxo4PmJH4JKb6T9mlZBj8xsndQ1IsSxh6T2F0Cby30w6jPxO7fBbqG+OeI+9BuS8=
X-Received: by 2002:a05:6214:21e7:b0:6d8:9d81:2107 with SMTP id
 6a1803df08f44-6e8a0d33e98mr26003826d6.20.1740710334547; Thu, 27 Feb 2025
 18:38:54 -0800 (PST)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250227024733.16989-1-laoar.shao@gmail.com> <20250227024733.16989-3-laoar.shao@gmail.com>
 <Z8CRXxfI24E9_IHC@pathway.suse.cz>
In-Reply-To: <Z8CRXxfI24E9_IHC@pathway.suse.cz>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Fri, 28 Feb 2025 10:38:17 +0800
X-Gm-Features: AQ5f1Jr6JMXp1rLiWEnI9D-jhhmqNMGnDZarhOpfDZ_fZ68e8u-_-NStW7kKicw
Message-ID: <CALOAHbBE5m4ZMdCKCpZVuh5w50wfnRR3kyfu58ND=gKCNQz0ew@mail.gmail.com>
Subject: Re: [PATCH v3 2/2] livepatch: Replace tasklist_lock with RCU
To: Petr Mladek <pmladek@suse.com>
Cc: jpoimboe@kernel.org, jikos@kernel.org, mbenes@suse.cz, 
	joe.lawrence@redhat.com, live-patching@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 28, 2025 at 12:22=E2=80=AFAM Petr Mladek <pmladek@suse.com> wro=
te:
>
> On Thu 2025-02-27 10:47:33, Yafang Shao wrote:
> > The tasklist_lock in the KLP transition might result high latency under
> > specific workload. We can replace it with RCU.
> >
> > After a new task is forked, its kernel stack is always set to empty[0].
> > Therefore, we can init these new tasks to KLP_TRANSITION_IDLE state
> > after they are forked. If these tasks are forked during the KLP
> > transition but before klp_check_and_switch_task(), they can be safely
> > skipped during klp_check_and_switch_task(). Additionally, if
> > klp_ftrace_handler() is triggered right after forking, the task can
> > determine which function to use based on the klp_target_state.
> >
> > With the above change, we can safely convert the tasklist_lock to RCU.
> >
> > Link: https://lore.kernel.org/all/20250213173253.ovivhuq2c5rmvkhj@jpoim=
boe/ [0]
> > Link: https://lore.kernel.org/all/20250214181206.xkvxohoc4ft26uhf@jpoim=
boe/ [1]
> > Suggested-by: Josh Poimboeuf <jpoimboe@kernel.org>
> > Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
> > ---
> > --- a/kernel/livepatch/patch.c
> > +++ b/kernel/livepatch/patch.c
> > @@ -95,7 +95,13 @@ static void notrace klp_ftrace_handler(unsigned long=
 ip,
> >
> >               patch_state =3D current->patch_state;
> >
> > -             WARN_ON_ONCE(patch_state =3D=3D KLP_TRANSITION_IDLE);
> > +             /* If the patch_state is KLP_TRANSITION_IDLE, it means th=
e task
> > +              * was forked after klp_init_transition(). In this case, =
the
> > +              * newly forked task can determine which function to use =
based
> > +              * on the klp_target_state.
> > +              */
> > +             if (patch_state =3D=3D KLP_TRANSITION_IDLE)
> > +                     patch_state =3D klp_target_state;
> >
>

I'm a bit confused by your example. Let me break it down to ensure I
understand correctly:

> CPU0                            CPU1
>
> task_0 (forked process):
>
> funcA
>   klp_ftrace_handler()
>     if (patch_state =3D=3D KLP_TRANSITION_IDLE)
>        patch_state =3D klp_target_state
>         # set to KLP_TRANSITION_PATCHED
>
>   # redirected to klp_funcA()

It seems that the KLP  is still in the process of transitioning, right?

>
>
>                                 echo 0 >/sys/kernel/livepatch/patch1/enab=
led
>
>                                 klp_reverse_transition()
>
>                                   klp_target_state =3D !klp_target_state;
>                                     # set to KLP_TRANSITION_UNPATCHED

If you attempt to initiate a new transition while the current one is
still ongoing, the __klp_disable_patch function will return -EBUSY,
correct?

__klp_disable_patch
    if (klp_transition_patch)
        return -EBUSY;

On the other hand, if klp_transition_patch is NULL, it indicates that
the first KLP transition has completed successfully.

>
>
>    funcB
>      if (patch_state =3D=3D KLP_TRANSITION_IDLE)
>        patch_state =3D klp_target_state
>          # set to KLP_TRANSITION_UNPATCHED
>
>    # staying in origianl funcB
>
>
> BANG: livepatched and original function called at the same time
>
>       =3D> broken consistency model.
>
> BTW: This is what I tried to warn you about at
>      https://lore.kernel.org/r/Z69Wuhve2vnsrtp_@pathway.suse.cz
>
> See below for more:
>
> >               if (patch_state =3D=3D KLP_TRANSITION_UNPATCHED) {
> >                       /*
> > diff --git a/kernel/livepatch/transition.c b/kernel/livepatch/transitio=
n.c
> > index ba069459c101..af76defca67a 100644
> > --- a/kernel/livepatch/transition.c
> > +++ b/kernel/livepatch/transition.c
> > @@ -23,7 +23,7 @@ static DEFINE_PER_CPU(unsigned long[MAX_STACK_ENTRIES=
], klp_stack_entries);
> >
> >  struct klp_patch *klp_transition_patch;
> >
> > -static int klp_target_state =3D KLP_TRANSITION_IDLE;
> > +int klp_target_state =3D KLP_TRANSITION_IDLE;
> >
> >  static unsigned int klp_signals_cnt;
> >
> > @@ -294,6 +294,14 @@ static int klp_check_and_switch_task(struct task_s=
truct *task, void *arg)
> >  {
> >       int ret;
> >
> > +     /*
> > +      * If the patch_state remains KLP_TRANSITION_IDLE at this point, =
it
> > +      * indicates that the task was forked after klp_init_transition()=
.
> > +      * In this case, it is safe to skip the task.
> > +      */
> > +     if (!test_tsk_thread_flag(task, TIF_PATCH_PENDING))
> > +             return 0;
> > +
> >       if (task_curr(task) && task !=3D current)
> >               return -EBUSY;
> >
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
> >
> >       /*
> >        * Ditto for the idle "swapper" tasks.
> > @@ -694,25 +702,10 @@ void klp_reverse_transition(void)
> >  }
> >
> >  /* Called from copy_process() during fork */
> > -void klp_copy_process(struct task_struct *child)
> > +void klp_init_process(struct task_struct *child)
> >  {
> > -
> > -     /*
> > -      * The parent process may have gone through a KLP transition sinc=
e
> > -      * the thread flag was copied in setup_thread_stack earlier. Brin=
g
> > -      * the task flag up to date with the parent here.
> > -      *
> > -      * The operation is serialized against all klp_*_transition()
> > -      * operations by the tasklist_lock. The only exceptions are
> > -      * klp_update_patch_state(current) and __klp_sched_try_switch(), =
but we
> > -      * cannot race with them because we are current.
> > -      */
> > -     if (test_tsk_thread_flag(current, TIF_PATCH_PENDING))
> > -             set_tsk_thread_flag(child, TIF_PATCH_PENDING);
> > -     else
> > -             clear_tsk_thread_flag(child, TIF_PATCH_PENDING);
> > -
> > -     child->patch_state =3D current->patch_state;
> > +     clear_tsk_thread_flag(child, TIF_PATCH_PENDING);
> > +     child->patch_state =3D KLP_TRANSITION_IDLE;
>
> I thought that we might do:
>
>         child->patch_state =3D klp_target_state;
>
> to avoid the race in the klp_ftrace_handler() described above.
>
> But the following might happen:
>
> CPU0                            CPU1
>
> klp_init_process(child)
>
>   child->patch_state =3D KLP_TRANSITION_IDLE
>
>                                 klp_enable_patch()
>                                   # setup ftrace handlers
>                                   # initialize all processes
>                                   # in the task list
>
>   # add "child" into the task list
>
>   schedule()
>
> [running child now]
>
> funcA()
>
>   klp_ftrace_handler()
>
>     child->patch_state =3D KLP_TRANSITION_IDLE
>
> BANG: Same problem as with the original patch.
>
>
> Hmm, the 2nd version of this patchset tried to do:
>
> diff --git a/kernel/livepatch/patch.c b/kernel/livepatch/patch.c
> index 90408500e5a3..5e523a3fbb3c 100644
> --- a/kernel/livepatch/patch.c
> +++ b/kernel/livepatch/patch.c
> @@ -95,7 +95,12 @@ static void notrace klp_ftrace_handler(unsigned long i=
p,
>
>                 patch_state =3D current->patch_state;
>
> -               WARN_ON_ONCE(patch_state =3D=3D KLP_TRANSITION_IDLE);
> +               /* If the patch_state is KLP_TRANSITION_IDLE, it indicate=
s the
> +                * task was forked after klp_init_transition(). For this =
newly
> +                * forked task, it is safe to switch it to klp_target_sta=
te.
> +                */
> +               if (patch_state =3D=3D KLP_TRANSITION_IDLE)
> +                       current->patch_state =3D klp_target_state;
>
>                 if (patch_state =3D=3D KLP_TRANSITION_UNPATCHED) {
>                         /*
>
> Note: It is broken. It sets current->patch_state but it later
>       checks the local variable "patch_state" which is still
>       KLP_TRANSITION_IDLE.

You're right=E2=80=94Josh has already highlighted this. I overlooked the lo=
cal variable.

>
> But is is safe when we fix it?
>
> It might be as long as we run klp_synchronize_transition() between
> updating the global @klp_target_state and the other operations.
>
> Especially, we need to make sure that @klp_target_state always have
> either KLP_TRANSITION_PATCHED or KLP_TRANSITION_UNPATCHED when
> func->transition is set.
>
> For this, we would need to add klp_synchronize_transition() into
>
>   + klp_init_transition() between setting @klp_target_state
>     and func->transition =3D true.
>
>   + klp_complete_transition() also for KLP_TRANSITION_UNPATCHED way.
>     It is currently called only for the PATCHED target state.
>
> Will this be enough?
>
> FACT: It is more complicated than it looked.
> QUESTION: Is this worth the effort?
>
> NOTE: The rcu_read_lock() does not solve the reported stall.
>       We are spending time on it only because it looked nice and
>       simple to you.

It can help avoid contention on the tasklist_lock. We often encounter
latency spikes caused by lock contention, but identifying the root
cause isn't always straightforward. If we can eliminate this global
lock, I believe it=E2=80=99s a worthwhile improvement.

>
> My opinion: I would personally prefer to focus on solving
>         the stall and the use-after-free access in do_exit().

These are distinct issues, and I believe it would be more effective to
discuss them separately.

--=20
Regards
Yafang

