Return-Path: <live-patching+bounces-1122-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 248D3A2AE08
	for <lists+live-patching@lfdr.de>; Thu,  6 Feb 2025 17:43:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 05581188B41E
	for <lists+live-patching@lfdr.de>; Thu,  6 Feb 2025 16:43:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 386A623535D;
	Thu,  6 Feb 2025 16:43:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="C9tx7S15"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBEF24C8E
	for <live-patching@vger.kernel.org>; Thu,  6 Feb 2025 16:43:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738860209; cv=none; b=hNfmypFSftZTGoFGziALqsAQgfvUICBkvxbtwsnZ3Cvz+X8PunTNXWu1fUJ5FZ0LZrP6qkDc93W7Rk70uixzWdtts2FjEPG8ItWhHm5ajFI4OkM6+Mu3fjnMKqhRT0lJHiekQ10pDZyaN6sffl6gXYr/f+xHWX9BRBm7DJRSeis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738860209; c=relaxed/simple;
	bh=lfSxUXtCblCdDTnVmcirMztnY0g5pqJEqKDKuItciC0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FUZofrSiX32uNjp38RCx9dzFRTBRe0vSb0c9YHCGTQ2DYvxaiGKkJNXHb/FE4CAsXTtg5tnz73yvhnRkZD8xozgZIAym2InuqLd1CTNDtJlJpkMWZXWL7SvZXwpV07j4a55t1jhuteKrHGO0gYrzho009+yFgcc4kPcZUxqCHXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=C9tx7S15; arc=none smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-5dca468c5e4so2421290a12.1
        for <live-patching@vger.kernel.org>; Thu, 06 Feb 2025 08:43:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1738860205; x=1739465005; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=r4Mam6bMuW5eBG7ASomWwZxqPxvbANjIEl2gg4qlgH8=;
        b=C9tx7S15dt8/bkorwZHqvn0+QAOLLlWVu82sk0Rms1WB0phq2e2UWOq8Y1wDn0s5xO
         B0vZ1Cain9bdpHarPsQLiMACF6WgWdhudTF6l+NypZH6fgwtglXm6HZmQuWz0O3yDqzk
         LWOg4ttzYe+uAvs7N8pJUbOtN4XLQY7B2+sMhP39x3iYfX1XfWGTlKDBXNY+kYFfcq9I
         J/Ov/gkoNjqV6sY2PdAfvasUmzvEuDnAUBp4yN+rmB1FjyThZTaTRqDZKMgcVskKpaD7
         ZoGOaTf0xIDSzhV1VVpz2ilBiiWorHzONr/SeTY/Wk77C+i67CGQHzjvI2vWp04s1Prq
         PSyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738860205; x=1739465005;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=r4Mam6bMuW5eBG7ASomWwZxqPxvbANjIEl2gg4qlgH8=;
        b=cqn4n4oDooEOsQ9DXYackzkPtjEcx86Umf8PsjHC967mBr54ICXo3x5Qcn9iORyT7u
         mzteiWd6yCBSVrYTgALTjl6N8ejXMyCtzdCXF78Jdkqy0uCWbMCOobf/OU1TxQEH/3c1
         SI/FwJh3/drGejE6q3CIcS4yKdZ7hBYiLgmVpmFAmKlI+utjXSptWgTq+cc+A/Q29InI
         3mD1RokpUfbw970ncxpyaVQicPwGAxmpzjv9lRyr1RLDFecCWVPnsS3T8CBosmtyhuU7
         bdB+IisaFpFXxbEt+qJNC9RbUcx88VsCgeilnIMPmXg4XYT3TiYgvafLKHctl9d/26YW
         R26g==
X-Forwarded-Encrypted: i=1; AJvYcCUFB3kXR5uGUTqvk4HxcjMOhE3XEN3Xet5pfWN9uHh+FnJOH0Lmmnmlk4/HAlTt40HVobpe45XIPcIBiST+@vger.kernel.org
X-Gm-Message-State: AOJu0Yz7Pfm7h3BPYyVVZQIToVAlXO/xU9M0Y0YQ+vZ2ueUagKBcROpz
	6CNsXSmq4jnfxYsFuDFCiBooh/ZYr/04bisgrUMf17wjbwpKe5SIZPhc7Ln4uog=
X-Gm-Gg: ASbGncsMN5TCiziKFOnFfNZwvjTuLMAPZehGlVxaj7un5F0y250UsqVRctcSGxsFxlW
	zIA7cYElRvas4khXiIGyvFn8bYliUrpXKHMB7pHe4ukcUBrviOwECgJEO/GjZ/5WJezdt2hhGEW
	uQ14/VnTT6lKJtu8SMwC+WrnXhk5hCXP2w787WPmfIEJO8MeG5k5oCgrs2jZ+mW+DjFUxV0N3UQ
	Yj8C6iSGgPlbx+mjWsbvo8PUMkzwafegk1fWY866ylTXIA1qkmFx59lwzL+GAi+S67p83a73Mx7
	pyHbckkToFWD0M2dVQ==
X-Google-Smtp-Source: AGHT+IEOTZRwgte3KKGtytLTRozIoI+MbUk3h3v1MNGV1WEa11thNh18Pj0nSn9DRyaS/xXRtC6kKA==
X-Received: by 2002:a17:907:7f8c:b0:ab7:d87:50f2 with SMTP id a640c23a62f3a-ab75e313670mr843480566b.44.1738860205118;
        Thu, 06 Feb 2025 08:43:25 -0800 (PST)
Received: from pathway.suse.cz ([176.114.240.130])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ab7732e7166sm124084166b.90.2025.02.06.08.43.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Feb 2025 08:43:24 -0800 (PST)
Date: Thu, 6 Feb 2025 17:43:22 +0100
From: Petr Mladek <pmladek@suse.com>
To: Yafang Shao <laoar.shao@gmail.com>
Cc: zhang warden <zhangwarden@gmail.com>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Jiri Kosina <jikos@kernel.org>, mbenes@suse.cz,
	joe.lawrence@redhat.com, live-patching@vger.kernel.org
Subject: Re: [PATCH] livepatch: Avoid hard lockup caused by
 klp_try_switch_task()
Message-ID: <Z6Tmqro6CSm0h-E3@pathway.suse.cz>
References: <20250122085146.41553-1-laoar.shao@gmail.com>
 <Z5DpqC7sm5qCJFtj@pathway.suse.cz>
 <A250B752-FFBF-4A53-B981-FE6D9A9F5C14@gmail.com>
 <Z5zSmlRIv5qhuVja@pathway.suse.cz>
 <CALOAHbCjZFKS9enXhNF60uYckKT+LJcRJGYq4xU+RxawJm+eMw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALOAHbCjZFKS9enXhNF60uYckKT+LJcRJGYq4xU+RxawJm+eMw@mail.gmail.com>

On Wed 2025-02-05 16:39:11, Yafang Shao wrote:
> On Fri, Jan 31, 2025 at 9:39 PM Petr Mladek <pmladek@suse.com> wrote:
> >
> > On Fri 2025-01-31 21:22:13, zhang warden wrote:
> > >
> > >
> > > > On Jan 22, 2025, at 20:50, Petr Mladek <pmladek@suse.com> wrote:
> > > >
> > > > With this patch, any operation which takes the tasklist_lock might
> > > > break klp_try_complete_transition(). I am afraid that this might
> > > > block the transition for a long time on huge systems with some
> > > > specific loads.
> > > >
> > > > And the problem is caused by a printk() added just for debugging.
> > > > I wonder if you even use a slow serial port.
> > > >
> > > > You might try to use printk_deferred() instead. Also you might need
> > > > to disable interrupts around the read_lock()/read_unlock() to
> > > > make sure that the console handling will be deferred after
> > > > the tasklist_lock gets released.
> > > >
> > > > Anyway, I am against this patch.
> > > >
> > > > Best Regards,
> > > > Petr
> > >
> > > Hi, Petr.
> > >
> > > I am unfamiliar with the function `rwlock_is_contended`, but it seems this function will not block and just only check the status of the rw_lock.
> > >
> > > If I understand it right, the problem would raise from the `break` which will stop the process of `for_each_process_thread`, right?
> >
> > You got it right. I am afraid that it might create a livelock
> > situation for the livepatch transition. I mean that the check
> > might almost always break on systems with thousands of processes
> > and frequently created/exited processes. It always has
> > to start from the beginning.
> 
> It doesn’t start from the beginning, as tasks that have already
> switched over will be skipped.

To make it clear. The next klp_try_complete_transition() will start
from the beginning but it should be faster because it will quickly
skip already migrated processes. Right?

It makes some sense. I agree that checking the stack is relatively
slow operation.

That said, beware that the full stack is checked only when the process
is in the kernel code: kthread or userspace process calling a syscall.
Other processes should be handled much faster. The ratio of these
processes depends on the type of the load. And I could imagine that
even checking the TIF_PATCH_PENDING might take a long time when
there are thousands of processes.


OK, let's make a step from a theory back to the practice:

You say that this patch helped and worked fine with your
workload.

It might be the best approach after all. It looks easier then
the hybrid model. And it might be needed even with the hybrid
model.

If I get it correctly, the email
https://lore.kernel.org/all/CALOAHbBZc6ORGzXwBRwe+rD2=YGf1jub5TEr989_GpK54P2o1A@mail.gmail.com/
says that you saw the hardlockup even with a relatively simple
livepatch. It modified "only" about 15 functions.

My main concern is how to guarantee a forward progress. I would like
to make sure that klp_try_complete_transition() will eventually
check all processes.

I would modify the check to something like:

	read_lock(&tasklist_lock);

	timeout = jiffies + HZ;
	proceed_pending_processes = 0;

	for_each_process_thread(g, task) {
		/* check if this task has already switched over */
		if (task->patch_state == klp_target_state)
			continue;

		proceed_pending_processes++;

		if (!klp_try_switch_task(task))
			complete = false;

		/*
		 * Prevent hardlockup by not blocking tasklist_lock for too long.
		 * But guarantee the forward progress by making sure at least
		 * some pending processes were checked.
		 */
		 if (rwlock_is_contended(&tasklist_lock) &&
		    time_after(jiffies, timeout) &&
		    proceed_pending_processes > 100) {
				complete = false;
				break;
		}
	}

	read_unlock(&tasklist_lock);



> Since the task->patch_state is set before the task is added to the
> task list and the child’s patch_state is inherited from the parent, I
> believe we can remove the tasklist_lock and use RCU instead, as
> follows:
> 
> diff --git a/kernel/livepatch/transition.c b/kernel/livepatch/transition.c
> index 30187b1d8275..1d022f983bbc 100644
> --- a/kernel/livepatch/transition.c
> +++ b/kernel/livepatch/transition.c
> @@ -399,11 +399,11 @@ void klp_try_complete_transition(void)
>          * Usually this will transition most (or all) of the tasks on a system
>          * unless the patch includes changes to a very common function.
>          */
> -       read_lock(&tasklist_lock);
> +       read_rcu_lock();
>         for_each_process_thread(g, task)
>                 if (!klp_try_switch_task(task))
>                         complete = false;
> -       read_unlock(&tasklist_lock);
> +       read_rcu_unlock();

IMHO, this does not guarantee that we checked all processes in the
cycle.

I mean:

We already have a problem that tasklist_lock is not enough to
serialize livepatches modifying do_exit(). It creates a race window
when the process still might be scheduled but it is not longer visible
in the for_each_process_thread() cycle.

And using read_rcu_lock() will make the race window even bigger.
I mean:

  + with read_lock(&tasklist_lock) the race window is limited by

       + read_lock(&tasklist_lock) in klp_try_complete_transition()
       + write_lock_irq(&tasklist_lock) in the middle of do_exit()

  + with read_rcu_lock() the race window is unlimited

I mean that more processes might get removed from the list
when klp_try_complete_transition() is running when they
are not serialized via the tasklist_lock. As a result, more
processes might be scheduled without being seen
by for_each_process_thread() cycle.

Does it make sense?

Best Regards,
Petr

