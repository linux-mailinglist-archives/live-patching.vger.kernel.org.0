Return-Path: <live-patching+bounces-1124-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 834A8A2B8C2
	for <lists+live-patching@lfdr.de>; Fri,  7 Feb 2025 03:17:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ADDC93A81F3
	for <lists+live-patching@lfdr.de>; Fri,  7 Feb 2025 02:17:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 566F513B29F;
	Fri,  7 Feb 2025 02:17:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Dv6o8DO0"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E7772417D3
	for <live-patching@vger.kernel.org>; Fri,  7 Feb 2025 02:17:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738894643; cv=none; b=uYQQ4ZCTkRW1RF9RrDctHkEjsHRgp8FAXkgYI946J0k7xk8KFCyPk1X62AmVvEWf9FJtq3S+84EcNR6e1h5QfPjH8/f1Q99Fr0/kRd3w7U161bbmtZYGIGyD6Ew54kdbDK9dK3jZJ94Rtgsb0TzbSm3ISkrsCTDSAVp3qzF0Lp4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738894643; c=relaxed/simple;
	bh=OK2f1GHVnPkQXWytQzK+OuMSuXq/qaQ3cDm9tJkms5g=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FvNhW2a9teXdVHW4dv+yYvbNJkEkJq8JTiZ2WyzV6o+Dt7Qo3QyWpWYjWZtXZ1MUaV45ZzUl6Xhd0YGShu2RecsdsT6kuLbf2Yg6j/elRvOGemdvS6j1Qazyceh0K77moOgxvUkZ9jCFSRGKh1vLBfcPBRC7G5eRPnkiTzcLw3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Dv6o8DO0; arc=none smtp.client-ip=209.85.160.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-4679eacf2c5so15562081cf.0
        for <live-patching@vger.kernel.org>; Thu, 06 Feb 2025 18:17:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1738894639; x=1739499439; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mU8IVIT2unb4fCL4+F5hUPpSHuDlDzYBgB2+2Vs+ppM=;
        b=Dv6o8DO0yUv7N3wHKc2pWjUgL+Fed/THRvMuvdK4v1Vetrk0eq1ZwCuXLH3GMyPX4I
         noBPtGhTMLkjk3Ox6vVSaUSUOW0UMc0U0s8ZPU8+TDzWZnBmLHxyfFLILvSHdej8Wtsx
         oAfoKgkb+gFaPrZ6UCxavPy35Okm+aM6pH46H743gcwMd8rLL8EdKN+h5luwWLPzN3sn
         xtTzqPLqk0MDBN8suzFZd0zXVRretyvA44oAj/auzBx1yLZoyxjkvHtfq3l4Vh3nF8Av
         JCYniHCz6sa/LPDsAhBDJWw1j8IUTuSFCZybfZQLEEeSxTJTspO3orNvt+S0BmCIxeTg
         kVSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738894639; x=1739499439;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mU8IVIT2unb4fCL4+F5hUPpSHuDlDzYBgB2+2Vs+ppM=;
        b=Tf/pu0Zd+zHX4LB2btr53s4Kz+Yj25JbniqUa3/q8EXLIzkBPxfDcgsJaX6T2lYhdS
         44ZK3T2DgEfMc8Pa/j7Tej9iSSl3pregd1YXX6UM2cUZb7uaSl5WpDucgYUdor/WWJqW
         IJ+v8hDAsoUqyf7WFbu0Rw9xGPgFC+N6Z+tuGVxxGwVg+X5v/Lumzmt8xhUk6ERnS+eX
         CByTLjCvB/g7a0iNbDeCQdWLAzi1oQ5bIjZHIi5hmZEs8XbVQ7yofto05q5+TefLIb/3
         k9SBGOGcF+/xqHeG/l/58rGt8Rshn3nbkNVUh5TWCqHOkb6BnrH15sjd1sTWuagsmqbs
         e9WA==
X-Forwarded-Encrypted: i=1; AJvYcCXb+1KlHrLqI1h3PdzBLV/18PSBBcF9qL5e4cQ34n7vuZulZEYbQngeMETv9ObZHWMncSvQ6ZsdKQUC1GpA@vger.kernel.org
X-Gm-Message-State: AOJu0YzinUTw31gzYbBnQyGMrqXzhUI8NSOxv9vmWG6+9wVlqfPURb75
	Q8N7yfLFO/9tC4DHMEQJ/K1QfoI/QsCfWgdYuYJf8xzxGLBRapsdKFQNQ6Iynfij6rCqJw7vK6W
	y4KjkXZ/otU7n46u231vxIJuMxRI=
X-Gm-Gg: ASbGncubuJxXtWJV8E96wYVDGgkjvNju4GM+XJR1v6QC8NLwFmCOw+GTj3AMf52Y4YL
	NmPyZKrz9zRuuqiK60QNvf44lftutGqXZtWF1lI0NVQkNQVC9kVGvAHMW5M3klAEIIFNqk66zJy
	c=
X-Google-Smtp-Source: AGHT+IE1t5rPLSPv2Nx6aRf+aoUfSS5e84rmIbrwETl+zYA/ODQjxQmVpG6NbK3uDyeglt8XNsFTcOVZQCBHGYhNpTY=
X-Received: by 2002:a05:6214:2621:b0:6d9:353b:a8e9 with SMTP id
 6a1803df08f44-6e44561996dmr21827866d6.15.1738894639189; Thu, 06 Feb 2025
 18:17:19 -0800 (PST)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250122085146.41553-1-laoar.shao@gmail.com> <Z5DpqC7sm5qCJFtj@pathway.suse.cz>
 <A250B752-FFBF-4A53-B981-FE6D9A9F5C14@gmail.com> <Z5zSmlRIv5qhuVja@pathway.suse.cz>
 <CALOAHbCjZFKS9enXhNF60uYckKT+LJcRJGYq4xU+RxawJm+eMw@mail.gmail.com> <Z6Tmqro6CSm0h-E3@pathway.suse.cz>
In-Reply-To: <Z6Tmqro6CSm0h-E3@pathway.suse.cz>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Fri, 7 Feb 2025 10:16:43 +0800
X-Gm-Features: AWEUYZkHt6_07G49WlouR51W5hH1sqSOvp7a-zigfJYgQoMlz6EVQjOdjZ2vpJQ
Message-ID: <CALOAHbB=XF2+F3oGZqrGvP84DGaxWXREHbT_LNymgXR2OyNWzw@mail.gmail.com>
Subject: Re: [PATCH] livepatch: Avoid hard lockup caused by klp_try_switch_task()
To: Petr Mladek <pmladek@suse.com>
Cc: zhang warden <zhangwarden@gmail.com>, Josh Poimboeuf <jpoimboe@kernel.org>, 
	Jiri Kosina <jikos@kernel.org>, mbenes@suse.cz, joe.lawrence@redhat.com, 
	live-patching@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 7, 2025 at 12:43=E2=80=AFAM Petr Mladek <pmladek@suse.com> wrot=
e:
>
> On Wed 2025-02-05 16:39:11, Yafang Shao wrote:
> > On Fri, Jan 31, 2025 at 9:39=E2=80=AFPM Petr Mladek <pmladek@suse.com> =
wrote:
> > >
> > > On Fri 2025-01-31 21:22:13, zhang warden wrote:
> > > >
> > > >
> > > > > On Jan 22, 2025, at 20:50, Petr Mladek <pmladek@suse.com> wrote:
> > > > >
> > > > > With this patch, any operation which takes the tasklist_lock migh=
t
> > > > > break klp_try_complete_transition(). I am afraid that this might
> > > > > block the transition for a long time on huge systems with some
> > > > > specific loads.
> > > > >
> > > > > And the problem is caused by a printk() added just for debugging.
> > > > > I wonder if you even use a slow serial port.
> > > > >
> > > > > You might try to use printk_deferred() instead. Also you might ne=
ed
> > > > > to disable interrupts around the read_lock()/read_unlock() to
> > > > > make sure that the console handling will be deferred after
> > > > > the tasklist_lock gets released.
> > > > >
> > > > > Anyway, I am against this patch.
> > > > >
> > > > > Best Regards,
> > > > > Petr
> > > >
> > > > Hi, Petr.
> > > >
> > > > I am unfamiliar with the function `rwlock_is_contended`, but it see=
ms this function will not block and just only check the status of the rw_lo=
ck.
> > > >
> > > > If I understand it right, the problem would raise from the `break` =
which will stop the process of `for_each_process_thread`, right?
> > >
> > > You got it right. I am afraid that it might create a livelock
> > > situation for the livepatch transition. I mean that the check
> > > might almost always break on systems with thousands of processes
> > > and frequently created/exited processes. It always has
> > > to start from the beginning.
> >
> > It doesn=E2=80=99t start from the beginning, as tasks that have already
> > switched over will be skipped.
>
> To make it clear. The next klp_try_complete_transition() will start
> from the beginning but it should be faster because it will quickly
> skip already migrated processes. Right?

Exactly, that=E2=80=99s precisely what I meant.

>
> It makes some sense. I agree that checking the stack is relatively
> slow operation.
>
> That said, beware that the full stack is checked only when the process
> is in the kernel code: kthread or userspace process calling a syscall.
> Other processes should be handled much faster. The ratio of these
> processes depends on the type of the load. And I could imagine that
> even checking the TIF_PATCH_PENDING might take a long time when
> there are thousands of processes.
>
>
> OK, let's make a step from a theory back to the practice:
>
> You say that this patch helped and worked fine with your
> workload.
>
> It might be the best approach after all. It looks easier then
> the hybrid model. And it might be needed even with the hybrid
> model.
>
> If I get it correctly, the email
> https://lore.kernel.org/all/CALOAHbBZc6ORGzXwBRwe+rD2=3DYGf1jub5TEr989_Gp=
K54P2o1A@mail.gmail.com/
> says that you saw the hardlockup even with a relatively simple
> livepatch. It modified "only" about 15 functions.

That's correct. We=E2=80=99ve only modified 15 functions so far.

>
> My main concern is how to guarantee a forward progress. I would like
> to make sure that klp_try_complete_transition() will eventually
> check all processes.
>
> I would modify the check to something like:
>
>         read_lock(&tasklist_lock);
>
>         timeout =3D jiffies + HZ;
>         proceed_pending_processes =3D 0;
>
>         for_each_process_thread(g, task) {
>                 /* check if this task has already switched over */
>                 if (task->patch_state =3D=3D klp_target_state)
>                         continue;
>
>                 proceed_pending_processes++;
>
>                 if (!klp_try_switch_task(task))
>                         complete =3D false;
>
>                 /*
>                  * Prevent hardlockup by not blocking tasklist_lock for t=
oo long.
>                  * But guarantee the forward progress by making sure at l=
east
>                  * some pending processes were checked.
>                  */
>                  if (rwlock_is_contended(&tasklist_lock) &&
>                     time_after(jiffies, timeout) &&
>                     proceed_pending_processes > 100) {
>                                 complete =3D false;
>                                 break;
>                 }
>         }
>
>         read_unlock(&tasklist_lock);
>

Thanks for your suggestion. I'll deploy this change to our production
servers and verify its effectiveness.

>
>
> > Since the task->patch_state is set before the task is added to the
> > task list and the child=E2=80=99s patch_state is inherited from the par=
ent, I
> > believe we can remove the tasklist_lock and use RCU instead, as
> > follows:
> >
> > diff --git a/kernel/livepatch/transition.c b/kernel/livepatch/transitio=
n.c
> > index 30187b1d8275..1d022f983bbc 100644
> > --- a/kernel/livepatch/transition.c
> > +++ b/kernel/livepatch/transition.c
> > @@ -399,11 +399,11 @@ void klp_try_complete_transition(void)
> >          * Usually this will transition most (or all) of the tasks on a=
 system
> >          * unless the patch includes changes to a very common function.
> >          */
> > -       read_lock(&tasklist_lock);
> > +       read_rcu_lock();
> >         for_each_process_thread(g, task)
> >                 if (!klp_try_switch_task(task))
> >                         complete =3D false;
> > -       read_unlock(&tasklist_lock);
> > +       read_rcu_unlock();
>
> IMHO, this does not guarantee that we checked all processes in the
> cycle.
>
> I mean:
>
> We already have a problem that tasklist_lock is not enough to
> serialize livepatches modifying do_exit(). It creates a race window
> when the process still might be scheduled but it is not longer visible
> in the for_each_process_thread() cycle.
>
> And using read_rcu_lock() will make the race window even bigger.
> I mean:
>
>   + with read_lock(&tasklist_lock) the race window is limited by
>
>        + read_lock(&tasklist_lock) in klp_try_complete_transition()
>        + write_lock_irq(&tasklist_lock) in the middle of do_exit()
>
>   + with read_rcu_lock() the race window is unlimited
>
> I mean that more processes might get removed from the list
> when klp_try_complete_transition() is running when they
> are not serialized via the tasklist_lock. As a result, more
> processes might be scheduled without being seen
> by for_each_process_thread() cycle.
>
> Does it make sense?

That makes sense. Thanks for the detailed explanation.

--
Regards
Yafang

