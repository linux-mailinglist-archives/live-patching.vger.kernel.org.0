Return-Path: <live-patching+bounces-1155-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8D2D6A32574
	for <lists+live-patching@lfdr.de>; Wed, 12 Feb 2025 12:55:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EB6A11889EC1
	for <lists+live-patching@lfdr.de>; Wed, 12 Feb 2025 11:55:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A2E0D20AF94;
	Wed, 12 Feb 2025 11:55:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GvCAVcZK"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-qv1-f49.google.com (mail-qv1-f49.google.com [209.85.219.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEA9120A5E8
	for <live-patching@vger.kernel.org>; Wed, 12 Feb 2025 11:54:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739361301; cv=none; b=LdnMq8A0RxuMFJ5kYI+6CxGMLqPGr2//7el6Zs48f2LrcSNqVGjuJXgwZEnaK/z/B6IuDFGK2xNJDpzv+Fj0rG1ZGxkWdmHwisjLnxI9qRBpamaWSlOFiRfThih2sHCJLFyJivu5C6io5G2P6xuAmaPz6aYUaOxcwJb9audhxfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739361301; c=relaxed/simple;
	bh=KJL6a/sg72PLx7JeASUSvvGZ9EKYNC7LFcRqH4lROD4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=k2G5A2YSTI4Xar5XiZFehdBAx8ezp9W3xnzmwpsGtogHgbqQpfdaWtgQoK9MkMusMCytkQQppKw8mpx9UXK8EpTT79nxegCw13khGCzEvTpdzaX7YDRd5vQO+oco4P6ehTcW8TMgbdqy0A8ACl0H+m+spnWQ4eXS6ENYedtZD4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GvCAVcZK; arc=none smtp.client-ip=209.85.219.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qv1-f49.google.com with SMTP id 6a1803df08f44-6e46f491275so11760126d6.3
        for <live-patching@vger.kernel.org>; Wed, 12 Feb 2025 03:54:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1739361299; x=1739966099; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XukvST9dGWz8zzI5HunOnBcy9khPdi7QyVxOpU0g3mw=;
        b=GvCAVcZKbipkjUIgLT2vVMuFf4UMiAOHCaWNOsjAaPqdFj1lm+Gs5ipE5RpruDKfQ3
         X26OOBcUf+tdQq8tx8YKo3LlFvlNKZNJnqZY68Phkk0zdnLl+YP0hwIxotQJN4GYrGcY
         urLYpr1moREjf29bLHCUYm/xPbHoJg0nW9zKYU6F4JbQzSH8Gta6doRbKhlPQNb6J8c3
         hSod8OoehtrHKqgSwAe2Rxbl9nprrrnSKaGZOfIxmBa5VlaNykBCohZxiKyePXaES1rp
         57aH+EauBJPWoQigIG+deiXk2Ik2GWxh0z1BrHVYqbM89fVe4vf8v4JLNtTd/57FiCkU
         ieIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739361299; x=1739966099;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XukvST9dGWz8zzI5HunOnBcy9khPdi7QyVxOpU0g3mw=;
        b=i2NrWuEo77oX0tg38X1jFoz0rhl9M8KeFiNtaBMIKL6ejknXiK6n9u2xk6L5biEglY
         pzI/fUHuUcAbVd0ukeAozUUTpuygk7zb+dIyHKS98uCb/KRqJT4yMH5xgZN+jshwjZ+V
         h4q2TtQlnbZBj+W/UI8FUjVOKA5J7jKjx1g7odylofT4fT17qh64AHIZQXyeBGq5tqF1
         JJ+JZdzLJyh+c48mARR0vkcutLv2E+4BzI9gPbl6YmAP1D4PLGkCPDehW4dZ+Svv9mcO
         wSV1QdW7euqSY6WSz6AhSu6mh0K2TDUQoclKMcP/fWZCAJH1sf5WHx8PLM+UnLMYDgZR
         F8Yg==
X-Forwarded-Encrypted: i=1; AJvYcCWHG+Y/eHzUh/xe0PwRDEOuyiHOpB0lYHIaO8HywaT+1orS3vdqbZ45QpTClwrquUidKfi8Hg6rzoG+BXJR@vger.kernel.org
X-Gm-Message-State: AOJu0Yz336fqNOL9KKO2um2V05CpTaUKNEQcQ7h77IwBbs+ZMH1io6Mm
	SNicEDUrFSaDDvfFe7pePsmE8x8DKchTxgRsxl7N8v066ciFBUIcSS3eBQ5owPu9qiUKdkEz56c
	Tu0gV7XND5W+7DIkpVi7yFv/HbWs=
X-Gm-Gg: ASbGncuTZh+sskFcCLHiP+/cCFrvD9EcvUgLE42EKHbYb0kIGfmWRhZrfVErofsb4tw
	Q3C+foKFh6xRWFTXxQYStoOvzLfa24RVk6dOxJwlGOSeIQ4vJNHSIPDYDxfYgmne3jlQx4hMJRX
	k=
X-Google-Smtp-Source: AGHT+IFMLvW8WU+488J3P359k4JUFcTccOBGJOZno4iKTSRuAnt4KwpzswVUmnS1c/EQJdqmaLqsJ6u7UcvAkm7xFw0=
X-Received: by 2002:a05:6214:f0e:b0:6d8:9960:b063 with SMTP id
 6a1803df08f44-6e46ed7f89fmr51793466d6.14.1739361298778; Wed, 12 Feb 2025
 03:54:58 -0800 (PST)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250211062437.46811-1-laoar.shao@gmail.com> <20250211062437.46811-3-laoar.shao@gmail.com>
 <20250212004009.ijs4bdbn6h55p7xd@jpoimboe> <CALOAHbDsSsMzuOaHX2ZzgD3bJTPgMEp1E_S=vERHaTV11KrVJQ@mail.gmail.com>
In-Reply-To: <CALOAHbDsSsMzuOaHX2ZzgD3bJTPgMEp1E_S=vERHaTV11KrVJQ@mail.gmail.com>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Wed, 12 Feb 2025 19:54:21 +0800
X-Gm-Features: AWEUYZmOfs0q3lmfIT42mzb1FnJovvDT2Y3i-XiKAQu_XMdZjxC-zYHW9vNDesY
Message-ID: <CALOAHbDEBqZyDvSSv+KTFVR3owkjfawCQ-fT9pC1fMHNGPnG+g@mail.gmail.com>
Subject: Re: [PATCH 2/3] livepatch: Avoid blocking tasklist_lock too long
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: jikos@kernel.org, mbenes@suse.cz, pmladek@suse.com, 
	joe.lawrence@redhat.com, live-patching@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 12, 2025 at 10:34=E2=80=AFAM Yafang Shao <laoar.shao@gmail.com>=
 wrote:
>
> On Wed, Feb 12, 2025 at 8:40=E2=80=AFAM Josh Poimboeuf <jpoimboe@kernel.o=
rg> wrote:
> >
> > On Tue, Feb 11, 2025 at 02:24:36PM +0800, Yafang Shao wrote:
> > >  void klp_try_complete_transition(void)
> > >  {
> > > +     unsigned long timeout, proceed_pending_processes;
> > >       unsigned int cpu;
> > >       struct task_struct *g, *task;
> > >       struct klp_patch *patch;
> > > @@ -467,9 +468,30 @@ void klp_try_complete_transition(void)
> > >        * unless the patch includes changes to a very common function.
> > >        */
> > >       read_lock(&tasklist_lock);
> > > -     for_each_process_thread(g, task)
> > > +     timeout =3D jiffies + HZ;
> > > +     proceed_pending_processes =3D 0;
> > > +     for_each_process_thread(g, task) {
> > > +             /* check if this task has already switched over */
> > > +             if (task->patch_state =3D=3D klp_target_state)
> > > +                     continue;
> > > +
> > > +             proceed_pending_processes++;
> > > +
> > >               if (!klp_try_switch_task(task))
> > >                       complete =3D false;
> > > +
> > > +             /*
> > > +              * Prevent hardlockup by not blocking tasklist_lock for=
 too long.
> > > +              * But guarantee the forward progress by making sure at=
 least
> > > +              * some pending processes were checked.
> > > +              */
> > > +             if (rwlock_is_contended(&tasklist_lock) &&
> > > +                 time_after(jiffies, timeout) &&
> > > +                 proceed_pending_processes > 100) {
> > > +                     complete =3D false;
> > > +                     break;
> > > +             }
> > > +     }
> > >       read_unlock(&tasklist_lock);
> >
> > Instead of all this can we not just use rcu_read_lock() instead of
> > tasklist_lock?
>
> I=E2=80=99m concerned that there=E2=80=99s a potential race condition in =
fork() if we
> use RCU, as illustrated below:
>
>   CPU0                                                     CPU1
>
> write_lock_irq(&tasklist_lock);
> klp_copy_process(p);
>
>                                          parent->patch_state=3Dklp_target=
_state
>
> list_add_tail_rcu(&p->tasks, &init_task.tasks);
> write_unlock_irq(&tasklist_lock);
>
> In this scenario, after the parent executes klp_copy_process(p) to
> copy its patch_state to the child, but before adding the child to the
> task list, the parent=E2=80=99s patch_state might be updated by the KLP
> transition. This could result in the child being left with an outdated
> state.
>
> We need to ensure that klp_copy_process() and list_add_tail_rcu() are
> treated as a single atomic operation.

Before the newly forked task is added to the task list, it doesn=E2=80=99t
execute any code and can always be considered safe during the KLP
transition. Therefore, we could replace klp_copy_process() with
klp_init_process(), where we simply set patch_state to
KLP_TRANSITION_IDLE, as shown below:

--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -2544,7 +2544,9 @@ __latent_entropy struct task_struct *copy_process(
                p->exit_signal =3D args->exit_signal;
        }

-       klp_copy_process(p);
+       // klp_init_process(p);
+       clear_tsk_thread_flag(child, TIF_PATCH_PENDING);
+       child->patch_state =3D KLP_TRANSITION_IDLE;

        sched_core_fork(p);

Some additional changes may be needed, such as removing
WARN_ON_ONCE(patch_state =3D=3D KLP_TRANSITION_IDLE) in
klp_ftrace_handler().

This would allow us to safely convert tasklist_lock to rcu_read_lock()
during the KLP transition.
Of course, we also need to address the race condition in do_exit().


--
Regards
Yafang

