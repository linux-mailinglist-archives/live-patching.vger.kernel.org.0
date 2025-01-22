Return-Path: <live-patching+bounces-1035-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 801F3A192E1
	for <lists+live-patching@lfdr.de>; Wed, 22 Jan 2025 14:47:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B701B16C567
	for <lists+live-patching@lfdr.de>; Wed, 22 Jan 2025 13:47:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 560C921322C;
	Wed, 22 Jan 2025 13:47:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iANyqcxM"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87258211A11
	for <live-patching@vger.kernel.org>; Wed, 22 Jan 2025 13:47:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737553654; cv=none; b=D8gRAQn3PIhM3ooMbMmbkp/jczOktGW836Jzlj7UINTpR60PljkS575sp2RBQl3N0oXIb3w/8hH5TSvmbI84eiW1RPF1v12gmyfTExh4SUFyaPry12Gro++lFBwvuIv6BPjna45ne4pXfAbsOUW+y+8YmpZ7vlPJrvtLrGcauuc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737553654; c=relaxed/simple;
	bh=+k4wJNIms56pEbDrwWMEyEc8JHDOupVb0aN/UE+GwQw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AaJi25pIGh7fKmRX80uEEF6VzqFX3v0W+I66wKl97UZ509ZDXdWR9dZqgJul8xNjL4TzfLP1fcWe4NLQQ5gnGbBvMY19K5FRNvaSK9BOgQwb4AcvD/gRHCtV1Oo8nzwIReidTA+xqbvWmEkfuijzmaaQfuW2xcOOTcf+XbeIKdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iANyqcxM; arc=none smtp.client-ip=209.85.219.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-6d92e457230so64227476d6.1
        for <live-patching@vger.kernel.org>; Wed, 22 Jan 2025 05:47:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1737553650; x=1738158450; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rNn5NFcRU7E5F4kPRpeK2bnxFnrmF+l6M9jC9mvnOZY=;
        b=iANyqcxMYkIav+GBmUhsPwXCwBkLMdhBsyyvjGzAc76eOzKgNRWE2OafasZkRDkicM
         W+4/ggByUAIHcWtvq2X0WXQsyqoxp0rZiEMb3TxNO1fzX0Q9mutO3ltO35sSQMevXWI6
         QqrMthqOzoG3ZLWNol+LXsniSIW395D82tbmEizDMOBK34vGIvupXAMlahMlrguy0CS9
         s1f6JF7129qXtyjyi/mkH6QZq36ZbUHpCmkdSHdJ3o8B2FiSYCFmKcLWxlR4IIeToxdr
         ArZMtz3+MaIlRnMTVwlmuYPbIdGY+25nljsCqu6IDx+jX4gJqU06SGx4n2nGsJdT2gFk
         Wwpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737553650; x=1738158450;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rNn5NFcRU7E5F4kPRpeK2bnxFnrmF+l6M9jC9mvnOZY=;
        b=C2YtrN6K8yhCeShwukt6VUYjZushNjwZDkHJNGja88HgqQFECIwE7x4WPZ7Fb06lj6
         ifnsgcOmYC6BQawlX1jn37N9suA7Fp5d/Q3DBla1kO0EQrY4SpevZ3ccTbz9At3dwNEJ
         hnonXySseK3zXJ/kWow47fxShreezULkzHnlkKZFOuGP0x7VGeyCdiB6i7tcTQMzkVQC
         9KWgy8Mlxxr2x2ens88jWwjjhXAA0hsnUEC0WTzfCzSw3BBlGr+d674cHGEoWCG4BDn3
         DG+2N4rkQeFuYuU/Fj96gHhceKmVJ+BTAPtqM1+jis7+1NYqqH8uxmTDa9uyKq3C9aOg
         M71g==
X-Forwarded-Encrypted: i=1; AJvYcCVgRT/eiEM5nAMf6xfFJrjRMyXHZaNA+IYLXXRvWrnH43TS9uE32cQSCbDU5ciRx2os6tNuy8VlMZxmQhdv@vger.kernel.org
X-Gm-Message-State: AOJu0YwsRkucaQwtCHlaFdAIITnCJFbLhSWMBSEzWK0YDK/9wSxzmzZV
	Zyz0sHk1OgYmK2HuS5Z2byrCZ/sy5t8pjL4XBWqNevaOP1pZZiAmt5tsARisfB35ZHe2I62ZWrX
	JY5Z5GP1Bi67/B4inbw7TLx4hNcM=
X-Gm-Gg: ASbGncvGYDR7iEW5Jp8vOUztfP1+vHD0gygfzS75/fQt6LSc/T6i+oaLgEnlo90ao3x
	bfPH1aVqV27Wy9QiuB5jxqdBFo/fuKtJP2D7CcsRJ4OprXd7B/BE4WA==
X-Google-Smtp-Source: AGHT+IED4bVHDj9SgAOt7S/9t940b9JgdfNemDg8tR8SuuNUt9F5P5hAAd6gpF4LW545ymgA9xyzyHyTCEWRxPFpDRs=
X-Received: by 2002:a05:6214:246b:b0:6d8:8a8f:75b0 with SMTP id
 6a1803df08f44-6e1b214136fmr338956136d6.14.1737553649075; Wed, 22 Jan 2025
 05:47:29 -0800 (PST)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250122085146.41553-1-laoar.shao@gmail.com> <Z5DpqC7sm5qCJFtj@pathway.suse.cz>
In-Reply-To: <Z5DpqC7sm5qCJFtj@pathway.suse.cz>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Wed, 22 Jan 2025 21:46:52 +0800
X-Gm-Features: AWEUYZmEQCJcC-OmNO918DJvQIWh0xezOEr7IJA6NPjoArr_grbfLz8BWsx_7Kc
Message-ID: <CALOAHbCw5_ZxNuRkwzMqz7NFdnJWgt-n4R--oYiE+BtNGP_8aw@mail.gmail.com>
Subject: Re: [PATCH] livepatch: Avoid hard lockup caused by klp_try_switch_task()
To: Petr Mladek <pmladek@suse.com>
Cc: jpoimboe@kernel.org, jikos@kernel.org, mbenes@suse.cz, 
	joe.lawrence@redhat.com, live-patching@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 22, 2025 at 8:50=E2=80=AFPM Petr Mladek <pmladek@suse.com> wrot=
e:
>
> On Wed 2025-01-22 16:51:46, Yafang Shao wrote:
> > I encountered a hard lockup while attempting to reproduce the panic iss=
ue
> > that occurred on our production servers [0]. The hard lockup manifests =
as
> > follows:
> >
> > [15852778.150191] livepatch: klp_try_switch_task: grpc_executor:421106 =
is sleeping on function do_exit
> > [15852778.169471] livepatch: klp_try_switch_task: grpc_executor:421244 =
is sleeping on function do_exit
> > [15852778.188746] livepatch: klp_try_switch_task: grpc_executor:421457 =
is sleeping on function do_exit
> > [15852778.208021] livepatch: klp_try_switch_task: grpc_executor:422407 =
is sleeping on function do_exit
> > [15852778.227292] livepatch: klp_try_switch_task: grpc_executor:423184 =
is sleeping on function do_exit
> > [15852778.246576] livepatch: klp_try_switch_task: grpc_executor:423582 =
is sleeping on function do_exit
> > [15852778.265863] livepatch: klp_try_switch_task: grpc_executor:423738 =
is sleeping on function do_exit
> > [15852778.285149] livepatch: klp_try_switch_task: grpc_executor:423739 =
is sleeping on function do_exit
> > [15852778.304446] livepatch: klp_try_switch_task: grpc_executor:423833 =
is sleeping on function do_exit
> > [15852778.323738] livepatch: klp_try_switch_task: grpc_executor:423893 =
is sleeping on function do_exit
> > [15852778.343017] livepatch: klp_try_switch_task: grpc_executor:423894 =
is sleeping on function do_exit
> > [15852778.362292] livepatch: klp_try_switch_task: grpc_executor:423976 =
is sleeping on function do_exit
> > [15852778.381565] livepatch: klp_try_switch_task: grpc_executor:423977 =
is sleeping on function do_exit
> > [15852778.400847] livepatch: klp_try_switch_task: grpc_executor:424610 =
is sleeping on function do_exit
> > [15852778.412319] NMI watchdog: Watchdog detected hard LOCKUP on cpu 15
> > ...
> > [15852778.412374] CPU: 15 PID: 1 Comm: systemd Kdump: loaded Tainted: G=
 S      W  O  K    6.1.52-3
> > [15852778.412377] Hardware name: New H3C Technologies Co., Ltd. H3C Uni=
Server R4950 G5/RS45M2C9S, BIOS 5.12 10/15/2021
> > [15852778.412378] RIP: 0010:queued_write_lock_slowpath+0x75/0x135
> > ...
> > [15852778.412397] Call Trace:
> > [15852778.412398]  <NMI>
> > [15852778.412400]  ? show_regs.cold+0x1a/0x1f
> > [15852778.412403]  ? watchdog_overflow_callback.cold+0x1e/0x70
> > [15852778.412406]  ? __perf_event_overflow+0x102/0x1e0
> > [15852778.412409]  ? perf_event_overflow+0x19/0x20
> > [15852778.412411]  ? x86_pmu_handle_irq+0xf7/0x160
> > [15852778.412415]  ? flush_tlb_one_kernel+0xe/0x30
> > [15852778.412418]  ? __set_pte_vaddr+0x2d/0x40
> > [15852778.412421]  ? set_pte_vaddr_p4d+0x3d/0x50
> > [15852778.412423]  ? set_pte_vaddr+0x6d/0xa0
> > [15852778.412424]  ? __native_set_fixmap+0x28/0x40
> > [15852778.412426]  ? native_set_fixmap+0x54/0x60
> > [15852778.412428]  ? ghes_copy_tofrom_phys+0x75/0x120
> > [15852778.412431]  ? __ghes_peek_estatus.isra.0+0x4e/0xb0
> > [15852778.412434]  ? ghes_in_nmi_queue_one_entry.constprop.0+0x3d/0x240
> > [15852778.412437]  ? amd_pmu_handle_irq+0x48/0xc0
> > [15852778.412438]  ? perf_event_nmi_handler+0x2d/0x50
> > [15852778.412440]  ? nmi_handle+0x60/0x120
> > [15852778.412443]  ? default_do_nmi+0x45/0x120
> > [15852778.412446]  ? exc_nmi+0x118/0x150
> > [15852778.412447]  ? end_repeat_nmi+0x16/0x67
> > [15852778.412450]  ? copy_process+0xf01/0x19f0
> > [15852778.412452]  ? queued_write_lock_slowpath+0x75/0x135
> > [15852778.412455]  ? queued_write_lock_slowpath+0x75/0x135
> > [15852778.412457]  ? queued_write_lock_slowpath+0x75/0x135
> > [15852778.412459]  </NMI>
> > [15852778.412460]  <TASK>
> > [15852778.412461]  _raw_write_lock_irq+0x43/0x50
> > [15852778.412463]  copy_process+0xf01/0x19f0
> > [15852778.412466]  kernel_clone+0x9d/0x3e0
> > [15852778.412468]  ? autofs_dev_ioctl_requester+0x100/0x100
> > [15852778.412471]  __do_sys_clone+0x66/0x90
> > [15852778.412475]  __x64_sys_clone+0x25/0x30
> > [15852778.412477]  do_syscall_64+0x38/0x90
> > [15852778.412478]  entry_SYSCALL_64_after_hwframe+0x64/0xce
> > [15852778.412481] RIP: 0033:0x7f426bb3b9c1
> > ...
> >
> > Notably, dynamic_debug is enabled to collect debug information when
> > applying a livepatch, resulting in a large amount of debug output.
> >
> > The issue arises because klp_try_switch_task() holds the tasklist_lock,=
 and
> > if another task attempts to acquire it, it must spin until it's availab=
le.
> > This becomes problematic in the copy_process() path, where IRQs are
> > disabled, leading to the hard lockup. To prevent this, we should implem=
ent
> > a check for spinlock contention before proceeding.
> >
> > Link: https://lore.kernel.org/live-patching/CALOAHbA9WHPjeZKUcUkwULagQj=
TMfqAdAg+akqPzbZ7Byc=3Dqrw@mail.gmail.com/ [0]
> > Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
> > ---
> >  kernel/livepatch/transition.c | 7 ++++++-
> >  1 file changed, 6 insertions(+), 1 deletion(-)
> >
> > diff --git a/kernel/livepatch/transition.c b/kernel/livepatch/transitio=
n.c
> > index ba069459c101..774017825bb4 100644
> > --- a/kernel/livepatch/transition.c
> > +++ b/kernel/livepatch/transition.c
> > @@ -467,9 +467,14 @@ void klp_try_complete_transition(void)
> >        * unless the patch includes changes to a very common function.
> >        */
> >       read_lock(&tasklist_lock);
> > -     for_each_process_thread(g, task)
> > +     for_each_process_thread(g, task) {
> >               if (!klp_try_switch_task(task))
> >                       complete =3D false;
> > +             if (rwlock_is_contended(&tasklist_lock) || need_resched()=
) {
>
> Are you able to finish the livepatch transition with this patch?

Yes, I've deployed this change to a few test servers, and the
livepatch transition is still functioning correctly on them. These
servers are running the same workload which triggered the panic.

>
> > +                     complete =3D false;
> > +                     break;
> > +             }
> > +     }
> >       read_unlock(&tasklist_lock);
> >
> >       /*
>
> With this patch, any operation which takes the tasklist_lock might
> break klp_try_complete_transition(). I am afraid that this might
> block the transition for a long time on huge systems with some
> specific loads.
>
> And the problem is caused by a printk() added just for debugging.
> I wonder if you even use a slow serial port.

No, we don't use a slow console.

The console is :

$ cat /proc/cmdline
... console=3Dtty0 ...

The log start from :
[15852771.495313] livepatch: 'livepatch_61_release6': starting
patching transition
[15852771.500341] livepatch: klp_try_switch_task: kcompactd0:664 is running
[15852771.516951] livepatch: klp_try_switch_task: java:2236329 is running
[15852771.522891] livepatch: klp_try_switch_task: python:338825 is
sleeping on function do_exit
[15852771.526292] livepatch: klp_try_switch_task:
jemalloc_bg_thd:338826 is sleeping on function do_exit
....

And end with:

[15852778.343017] livepatch: klp_try_switch_task: grpc_executor:423894
is sleeping on function do_exit
[15852778.362292] livepatch: klp_try_switch_task: grpc_executor:423976
is sleeping on function do_exit
[15852778.381565] livepatch: klp_try_switch_task: grpc_executor:423977
is sleeping on function do_exit
[15852778.400847] livepatch: klp_try_switch_task: grpc_executor:424610
is sleeping on function do_exit
[15852778.412319] NMI watchdog: Watchdog detected hard LOCKUP on cpu 15

$ cat log | grep do_exit | wc -l
1061

It seems that there are simply too many threads executing do_exit() at
the moment.

>
> You might try to use printk_deferred() instead. Also you might need
> to disable interrupts around the read_lock()/read_unlock() to
> make sure that the console handling will be deferred after
> the tasklist_lock gets released.
>
> Anyway, I am against this patch.

However, there is still a risk of triggering a hard lockup if a large
number of tasks are involved.


--
Regards
Yafang

