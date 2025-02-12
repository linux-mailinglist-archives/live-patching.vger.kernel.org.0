Return-Path: <live-patching+bounces-1153-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2797FA31C1B
	for <lists+live-patching@lfdr.de>; Wed, 12 Feb 2025 03:34:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B1D651648AF
	for <lists+live-patching@lfdr.de>; Wed, 12 Feb 2025 02:34:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 817441C54AA;
	Wed, 12 Feb 2025 02:34:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OXjEDy3I"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com [209.85.219.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7AF1288B1
	for <live-patching@vger.kernel.org>; Wed, 12 Feb 2025 02:34:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739327687; cv=none; b=Bz4A2xHqraWbxBp0x93nYmleylGbuHUW1MuRxoPFSX2BxYN5Y7IDYVamtwLdCSQfS3AXv8i7eNnW7iap1AU8lSQ6k1jbAsAV2bU3SVOUX8vL6p10DE21F2OCN00oF26PxFPB/OZ3zytnydOW5ncxypZ8thlq6EOXbVE3VBjbGiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739327687; c=relaxed/simple;
	bh=GkmoP7/GmLqI7aoEHdj/0iIkAbQ1lUrSl3HkDjDdwFs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=V8mNtXMxGdk0HFSPfKqtfWdgLhdG/WP6ZEbGYGfiufp3vykKZdMr/2VNUjB9Jt7Jycr6B11/Duwg/Neh9SaRw9o5yXrpXfmwnGOLddPlKvEcKjEQSh11CIpIOQm6TxQ+2zXIq0+n9U5PGcYlO5pKO+1ffo3Fxr/MfNWAI+neBFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OXjEDy3I; arc=none smtp.client-ip=209.85.219.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-6dd0d09215aso49596756d6.2
        for <live-patching@vger.kernel.org>; Tue, 11 Feb 2025 18:34:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1739327685; x=1739932485; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7HlFKvecytovV4L1zU5eIn1rLG8owOYITAVRNoqprC0=;
        b=OXjEDy3ItOVTjtYH28Qy8wsXfk4ENk/vY6cJqcaMHY01YlF3vWC1F3d/zkTF4sI49+
         eXDFTkrpd2Vh7dfguQsTHZZ3R67WTEOnLJ7Ia25xIEisJvo7qkE0AejKLWQstUIvtWL0
         dibOlu8UJsF4j9xHAOOfg7nvSXx/R+n4F+1fC1X8Vimi6OOy4u44xcLr1C1aeDOw8Xli
         fYtE8b+fjRObDHIUhf4YJT6jHXrF1r/vIIc+vhYOfrzNINFwrtAGaD488L7cGbdLecqD
         Rs2jUSuczb1etksafcM8MjsDO/DngcqVyBRfjZXAOCne8qz95wqWP1NTs28ZXehCTiDq
         acaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739327685; x=1739932485;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7HlFKvecytovV4L1zU5eIn1rLG8owOYITAVRNoqprC0=;
        b=HsEQ440HepZWd0wjwPoIaDhPk0yotcJfM6KuQLpMs9DDZiwQec/U1k/pFDirZkvTRG
         tf5h2Gq+A1KvuQmC7Af3r4NGO6AuOGSSxj7f0RqK5qCEyno7UWJc51uj0YNMv9eRDhPh
         fd1XN80mSvWZMZQEX8NsqAVFVMVxAl1u/PEm9o62SnzNmaqcF1Ax+pFgC/R7zELPq4xl
         py0Kqx8WVnPufJvb2Ct+MesrxeZeMJfGnNpgQd7hcQhShUWJLK/7yrpGIv+drLpvJVfm
         PAn+Cm7y+FY/EfNzboKZ6AdKaWsKYigdnrfONjkEIi1HFMJay5N1gjSTnErlVuYwDkW+
         zZ0g==
X-Forwarded-Encrypted: i=1; AJvYcCVmMIApueYIFthvIjH2l1NVHkp5WraVUDyQxFXi9BJZ2DQqD9URKvRz7NkbPjftUvNtXKe20VJ1eU6oDQWJ@vger.kernel.org
X-Gm-Message-State: AOJu0YypZbgrdIUMdRjvx2x1+XQc9KmFK74ouQkwbafUzWWQ2HKUvYnl
	Qm1PnPX7KxMo36loqIMN/JYAY0EihtDqkta7OmmWXtgmQqPQCF55F4ZXkKtxxmCMy4Plc8yUt98
	RmsZebqGsYyqoSezIDToCbdIORIM=
X-Gm-Gg: ASbGncsNmRUp/dBEYg90xh/OnTonXKB+1xXJ8WM6+utHjtIBmZnqPntFrMFwAjzL/19
	RYToBOZADpfM/f4N6P9US3x6hbh+nAU3DseJ207O3H9MlyWp1Fc5zLjlqDDXHSvw+Cbajjzt1Ac
	g=
X-Google-Smtp-Source: AGHT+IE/xC4VVyQ5GTn8LsEOlPPmZphula7DHEZV2iUOahPBezZv9bwLuVTYaaEH7Y4OqhYRESRmxeOiGuhfYTghCmg=
X-Received: by 2002:ad4:5be2:0:b0:6e4:41a0:3bdb with SMTP id
 6a1803df08f44-6e46ed88629mr27811306d6.26.1739327684780; Tue, 11 Feb 2025
 18:34:44 -0800 (PST)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250211062437.46811-1-laoar.shao@gmail.com> <20250211062437.46811-3-laoar.shao@gmail.com>
 <20250212004009.ijs4bdbn6h55p7xd@jpoimboe>
In-Reply-To: <20250212004009.ijs4bdbn6h55p7xd@jpoimboe>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Wed, 12 Feb 2025 10:34:08 +0800
X-Gm-Features: AWEUYZkg3Tw9wDl8Mzs7emdEYvaf4lol-YN4M4_C2KEFsCIW92LaMafVlwXVyT0
Message-ID: <CALOAHbDsSsMzuOaHX2ZzgD3bJTPgMEp1E_S=vERHaTV11KrVJQ@mail.gmail.com>
Subject: Re: [PATCH 2/3] livepatch: Avoid blocking tasklist_lock too long
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: jikos@kernel.org, mbenes@suse.cz, pmladek@suse.com, 
	joe.lawrence@redhat.com, live-patching@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 12, 2025 at 8:40=E2=80=AFAM Josh Poimboeuf <jpoimboe@kernel.org=
> wrote:
>
> On Tue, Feb 11, 2025 at 02:24:36PM +0800, Yafang Shao wrote:
> >  void klp_try_complete_transition(void)
> >  {
> > +     unsigned long timeout, proceed_pending_processes;
> >       unsigned int cpu;
> >       struct task_struct *g, *task;
> >       struct klp_patch *patch;
> > @@ -467,9 +468,30 @@ void klp_try_complete_transition(void)
> >        * unless the patch includes changes to a very common function.
> >        */
> >       read_lock(&tasklist_lock);
> > -     for_each_process_thread(g, task)
> > +     timeout =3D jiffies + HZ;
> > +     proceed_pending_processes =3D 0;
> > +     for_each_process_thread(g, task) {
> > +             /* check if this task has already switched over */
> > +             if (task->patch_state =3D=3D klp_target_state)
> > +                     continue;
> > +
> > +             proceed_pending_processes++;
> > +
> >               if (!klp_try_switch_task(task))
> >                       complete =3D false;
> > +
> > +             /*
> > +              * Prevent hardlockup by not blocking tasklist_lock for t=
oo long.
> > +              * But guarantee the forward progress by making sure at l=
east
> > +              * some pending processes were checked.
> > +              */
> > +             if (rwlock_is_contended(&tasklist_lock) &&
> > +                 time_after(jiffies, timeout) &&
> > +                 proceed_pending_processes > 100) {
> > +                     complete =3D false;
> > +                     break;
> > +             }
> > +     }
> >       read_unlock(&tasklist_lock);
>
> Instead of all this can we not just use rcu_read_lock() instead of
> tasklist_lock?

I=E2=80=99m concerned that there=E2=80=99s a potential race condition in fo=
rk() if we
use RCU, as illustrated below:

  CPU0                                                     CPU1

write_lock_irq(&tasklist_lock);
klp_copy_process(p);

                                         parent->patch_state=3Dklp_target_s=
tate

list_add_tail_rcu(&p->tasks, &init_task.tasks);
write_unlock_irq(&tasklist_lock);

In this scenario, after the parent executes klp_copy_process(p) to
copy its patch_state to the child, but before adding the child to the
task list, the parent=E2=80=99s patch_state might be updated by the KLP
transition. This could result in the child being left with an outdated
state.

We need to ensure that klp_copy_process() and list_add_tail_rcu() are
treated as a single atomic operation.

--
Regards



Yafang

