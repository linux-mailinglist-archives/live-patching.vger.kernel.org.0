Return-Path: <live-patching+bounces-1157-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 762A1A32A50
	for <lists+live-patching@lfdr.de>; Wed, 12 Feb 2025 16:42:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 104D03A60B1
	for <lists+live-patching@lfdr.de>; Wed, 12 Feb 2025 15:42:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D5A2212F89;
	Wed, 12 Feb 2025 15:42:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="OA3+kim0"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFA6B27180B
	for <live-patching@vger.kernel.org>; Wed, 12 Feb 2025 15:42:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739374966; cv=none; b=TF1MAa7RBhEKW/U38N6hTiCFGiXzEG6Crz5vGxHrjd/KbQXNzyK4e1O8h2oFbIM0odL+us5cEXq/bZnbG9Af4C9QdxV5pobLYRbX1AK3YfkAp3qiSuWcBTbuRAg9tmddGi+F1S2OfJSid94FCshZcrA9OzYolvyw4L9STvQEAv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739374966; c=relaxed/simple;
	bh=YY0ssl+CXBQNBh9eBWulItzJa3bkJYhVBr692DvN83M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZnXFSFOaDRJ2abCoFnPiTlWFk6IrxNuMywDwlPWMs4iTn7bY2dBOlKWeyHhkSrF5BbGJVddIunllVsYVFPxpR7NU2n4/DKa60y2awbOcAvWamtUnMQo6NSiOuSyvDJk14pJT3VpoJGjzHfL9VmBQXbqXkpYL5n06l2V/1sGjojs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=OA3+kim0; arc=none smtp.client-ip=209.85.208.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-5de64873d18so7773633a12.2
        for <live-patching@vger.kernel.org>; Wed, 12 Feb 2025 07:42:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1739374962; x=1739979762; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=i6ZpRGsTvZbDM3XhNofIhls2/mOZKVHm57EHg3R7sbY=;
        b=OA3+kim0WIWzgx/4FmG2wbahawepKkdQONR2B3ubhXLBJvcDb+X/G7aiCv5hcsn3NP
         Fp3og1BaF45RUy7OdGR+L+LVofpxqGetE5QlQcBROKflFJs0tliLVBBHSy/KXVKeiE8y
         T/chWHB1XPg9c/D8bLGZfDpQ+Fu/MnXTE26ok5/yY+vf03AXkKUudC5zztgl8OsuMsZP
         SSMwqEJFD4wEOtOFf5+2p48P50/Lb6amLkxWSdNu2Hg72sY3XMvftbJwwrSM2Og+1r9v
         FoZDhNjfZU+rSDssQ4Z74FZZOTwq1hB9oJOZ/sBAkl8UjvXztiQj9UTggKvEi/eWdad+
         TBaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739374962; x=1739979762;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=i6ZpRGsTvZbDM3XhNofIhls2/mOZKVHm57EHg3R7sbY=;
        b=KKjtgccpJEXMyHDvu2nxrZ/ckEUap8FWXYKEZFxn+sNFYos5RaVrbijl8IxbE5xcT0
         +qfCF4Wmm5vcz9btT09CW06smDE6WLNwuJs8/lc9UQyLtphjKuFrZzpAKJrofRljeZR3
         TbOMnDo2ZKI8xdcMWJhFvd7sisX3RYG2p9+KvY3MFhiZKl4+c44qGEvJ3+kFf6SLSv04
         omc5fm/T45rMegR7E8577nJx69u2rt/pdMPDBskh5K9xU7YexrCwBHsCj9HITykbcNWI
         qbLdgsZqnmlcvG7TGkUWH+DDRBmiKQ2u9+2KchUM28bZHcDXeKt6CtwXMTX1JnDfEXGk
         OqIA==
X-Forwarded-Encrypted: i=1; AJvYcCUNkGJq41U4Bn/1uShx5JyO2m7XcCNbG3liUTCAf83SYDJOPXdJsgj7+2QsO7H5uEF0IPYBKC2xUktVyI8+@vger.kernel.org
X-Gm-Message-State: AOJu0YxURbOjQSOydfUbwz+F6CmdF1d+hUZYcTOe37yrhqHVYj+fSuDa
	it1zGGojWg6o3GCa4QX+eHf4kl+C/Pd/6yxHvmnfD8PF+gA0fTFq5KcvKolmLmOK5Es2Ug1DjT8
	E
X-Gm-Gg: ASbGncsNcLGv8ZfTOWu1OjS2zZ3q8UIsevhjfcJRo7kDFtHBqbQW1hqiTKBGF2wAcvE
	BiE1PkaSPCf+vLNVjifI+UaJvE/rxA7mvdDvvM9dG0P9FGw4L2VHqOzkvg410g/MauZkEHdlQXm
	BN77Xi2T66wv8NGX54CI3iilp1FzN/S5QJsnvaLNaHImb6VS1oalynwCF9UzpRgz+HUTYv7sMTS
	QqD36Jo2aqg5VuV/TQscHCMktqBiCNtnqsZKF2Xw7U8/s50BZjksGEChRJBeQH6FfZkkX8mYEKG
	wn8KgibTwNj7Dt+/cg==
X-Google-Smtp-Source: AGHT+IFoDEHl/MhCZatevg2AOUnkQFlW9ilUT9oD51jiSUebRg+vSr6edY3XziasIWcpmEqKQXyCpw==
X-Received: by 2002:a05:6402:26cf:b0:5de:42f5:817b with SMTP id 4fb4d7f45d1cf-5deade15403mr3094764a12.31.1739374961839;
        Wed, 12 Feb 2025 07:42:41 -0800 (PST)
Received: from pathway.suse.cz ([176.114.240.130])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5deb89289d9sm805622a12.62.2025.02.12.07.42.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Feb 2025 07:42:41 -0800 (PST)
Date: Wed, 12 Feb 2025 16:42:39 +0100
From: Petr Mladek <pmladek@suse.com>
To: Yafang Shao <laoar.shao@gmail.com>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>, jikos@kernel.org, mbenes@suse.cz,
	joe.lawrence@redhat.com, live-patching@vger.kernel.org
Subject: Re: [PATCH 2/3] livepatch: Avoid blocking tasklist_lock too long
Message-ID: <Z6zBb9GRkFC-R0RE@pathway.suse.cz>
References: <20250211062437.46811-1-laoar.shao@gmail.com>
 <20250211062437.46811-3-laoar.shao@gmail.com>
 <20250212004009.ijs4bdbn6h55p7xd@jpoimboe>
 <CALOAHbDsSsMzuOaHX2ZzgD3bJTPgMEp1E_S=vERHaTV11KrVJQ@mail.gmail.com>
 <CALOAHbDEBqZyDvSSv+KTFVR3owkjfawCQ-fT9pC1fMHNGPnG+g@mail.gmail.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALOAHbDEBqZyDvSSv+KTFVR3owkjfawCQ-fT9pC1fMHNGPnG+g@mail.gmail.com>

On Wed 2025-02-12 19:54:21, Yafang Shao wrote:
> On Wed, Feb 12, 2025 at 10:34 AM Yafang Shao <laoar.shao@gmail.com> wrote:
> >
> > On Wed, Feb 12, 2025 at 8:40 AM Josh Poimboeuf <jpoimboe@kernel.org> wrote:
> > >
> > > On Tue, Feb 11, 2025 at 02:24:36PM +0800, Yafang Shao wrote:
> > > >  void klp_try_complete_transition(void)
> > > >  {
> > > > +     unsigned long timeout, proceed_pending_processes;
> > > >       unsigned int cpu;
> > > >       struct task_struct *g, *task;
> > > >       struct klp_patch *patch;
> > > > @@ -467,9 +468,30 @@ void klp_try_complete_transition(void)
> > > >        * unless the patch includes changes to a very common function.
> > > >        */
> > > >       read_lock(&tasklist_lock);
> > > > -     for_each_process_thread(g, task)
> > > > +     timeout = jiffies + HZ;
> > > > +     proceed_pending_processes = 0;
> > > > +     for_each_process_thread(g, task) {
> > > > +             /* check if this task has already switched over */
> > > > +             if (task->patch_state == klp_target_state)
> > > > +                     continue;
> > > > +
> > > > +             proceed_pending_processes++;
> > > > +
> > > >               if (!klp_try_switch_task(task))
> > > >                       complete = false;
> > > > +
> > > > +             /*
> > > > +              * Prevent hardlockup by not blocking tasklist_lock for too long.
> > > > +              * But guarantee the forward progress by making sure at least
> > > > +              * some pending processes were checked.
> > > > +              */
> > > > +             if (rwlock_is_contended(&tasklist_lock) &&
> > > > +                 time_after(jiffies, timeout) &&
> > > > +                 proceed_pending_processes > 100) {
> > > > +                     complete = false;
> > > > +                     break;
> > > > +             }
> > > > +     }
> > > >       read_unlock(&tasklist_lock);
> > >
> > > Instead of all this can we not just use rcu_read_lock() instead of
> > > tasklist_lock?
> >
> > I’m concerned that there’s a potential race condition in fork() if we
> > use RCU, as illustrated below:
> >
> >   CPU0                                                     CPU1
> >
> > write_lock_irq(&tasklist_lock);
> > klp_copy_process(p);
> >
> >                                          parent->patch_state=klp_target_state
> >
> > list_add_tail_rcu(&p->tasks, &init_task.tasks);
> > write_unlock_irq(&tasklist_lock);
> >
> > In this scenario, after the parent executes klp_copy_process(p) to
> > copy its patch_state to the child, but before adding the child to the
> > task list, the parent’s patch_state might be updated by the KLP
> > transition. This could result in the child being left with an outdated
> > state.

Similar race actually existed even before. 

> > We need to ensure that klp_copy_process() and list_add_tail_rcu() are
> > treated as a single atomic operation.
> 
> Before the newly forked task is added to the task list, it doesn’t
> execute any code and can always be considered safe during the KLP
> transition. Therefore, we could replace klp_copy_process() with
> klp_init_process(), where we simply set patch_state to
> KLP_TRANSITION_IDLE, as shown below:

This might work when a new process is created, for example, using
execve(). But it would fail when the process is just forked (man 2 fork)
and both parent and child continue running the same code.


> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -2544,7 +2544,9 @@ __latent_entropy struct task_struct *copy_process(
>                 p->exit_signal = args->exit_signal;
>         }
> 
> -       klp_copy_process(p);
> +       // klp_init_process(p);
> +       clear_tsk_thread_flag(child, TIF_PATCH_PENDING);
> +       child->patch_state = KLP_TRANSITION_IDLE;

This is exactly the loction where we depend on the sychronization
with the tasklist_lock. It allows us to synchronize both
TIF_PATCH_PENDING flag and p->patch_state between the parent
and child, see the comment in klp_copy_process():

/* Called from copy_process() during fork */
void klp_copy_process(struct task_struct *child)
{
	/*
	 * The parent process may have gone through a KLP transition since
	 * the thread flag was copied in setup_thread_stack earlier. Bring
	 * the task flag up to date with the parent here.
	 *
	 * The operation is serialized against all klp_*_transition()
	 * operations by the tasklist_lock. The only exceptions are
	 * klp_update_patch_state(current) and __klp_sched_try_switch(), but we
	 * cannot race with them because we are current.
	 */
	if (test_tsk_thread_flag(current, TIF_PATCH_PENDING))
		set_tsk_thread_flag(child, TIF_PATCH_PENDING);
	else
		clear_tsk_thread_flag(child, TIF_PATCH_PENDING);

	child->patch_state = current->patch_state;
}

When using rcu_read_lock() in klp_try_complete_transition,
child->patch_state might get an outdated information. The following
race commes to my mind:

CPU1				CPU1

				klp_try_complete_transition()


taskA:	
 + fork()
   + klp_copy_process()
      child->patch_state = KLP_PATCH_UNPATCHED

				  klp_try_switch_task(taskA)
				    // safe

				child->patch_state = KLP_PATCH_PATCHED

				all processes patched

				klp_finish_transition()


	list_add_tail_rcu(&p->thread_node,
			  &p->signal->thread_head);


BANG: The forked task has KLP_PATCH_UNPATCHED so that
      klp_ftrace_handler() will redirect it to the old code.

      But CPU1 thinks that all tasks are migrated and is going
      to finish the transition



My opinion:

I am afraid that using rcu_read_lock() in klp_try_complete_transition()
might cause more harm than good. The code already is complicated
and this might make it even more tricky.

I would first like to understand how exactly the stall happens.
It is possible that even rcu_read_lock() won't help here!

If the it takes too long time to check backtraces of all pending
processes then even rcu_read_lock() might trigger the RCU stall
warning as well.

Best Regards,
Petr

