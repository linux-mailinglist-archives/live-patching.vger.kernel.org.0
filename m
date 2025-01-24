Return-Path: <live-patching+bounces-1043-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 36803A1B0AF
	for <lists+live-patching@lfdr.de>; Fri, 24 Jan 2025 08:08:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8FA827A475E
	for <lists+live-patching@lfdr.de>; Fri, 24 Jan 2025 07:07:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 991951DA2FD;
	Fri, 24 Jan 2025 07:07:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bDYT/gcw"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-qv1-f44.google.com (mail-qv1-f44.google.com [209.85.219.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F83E33998
	for <live-patching@vger.kernel.org>; Fri, 24 Jan 2025 07:07:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737702477; cv=none; b=VHm6+5Myth/ZVZGDQel2q+w4KwCDOiN5XI8POyMSgPUknjpBGHozO5guIRJxrnNVVcJGspd+rBTt+r0A2/RRqvtFaL5rXMSGYN9QwHWZhcb/W9BNt9GlkNcQUVjeLj05XZgc4ywp0oKIpUWhaHqXhseT4OD4gVH4CHmUCCTqMsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737702477; c=relaxed/simple;
	bh=3KmDjol4H0ZfhYBT1matPFj9oxjov/i+2KMBmJhmA/s=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=u59jnKw7yeWARtvDffIn1jxeRA2yRlFBmMY5ChPlSyrhzwDbFgS7u2s7r9VcOlUQrnl3EvakRvfWv41a325oIkwwUZotv+z7/4NYlh2aqDrSy2By+qE099XO2l79V03XFS4nZ6LP/r8Ug/M3iJ/9qqJM2FGCfAVfIuuqRYT9VOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bDYT/gcw; arc=none smtp.client-ip=209.85.219.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qv1-f44.google.com with SMTP id 6a1803df08f44-6dd049b5428so15120646d6.2
        for <live-patching@vger.kernel.org>; Thu, 23 Jan 2025 23:07:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1737702474; x=1738307274; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RU+/pxkUgIWWtDLkUo0WrjleioNh6PoKJw4OsEQLSGc=;
        b=bDYT/gcwzUZTHg1LFe9a9oClYa87sA67hlSeNGICJ+0YM5JU4GZ2pyNVTFY7cw+bZ8
         Jojw9IbFGEha/lQJVGwNd5Tb8zo9Cfz0Juxbfd73/zt0Fh75Lczg2Jkl9rIbQZH0oPFM
         pynwmwy+xDaYpFGuhwtIJyPunysxq+O698tcmf0KvFOPQBWzPH3o7xKPkJw//7W7C2EC
         tQAQtcsP4pon93mr7D5dy2Ri54PS4aK654RBBhw7owqSuogBAGJxs0MAcFNWz30tuKTn
         cDnN8VIF085+0W98K/e6Ndn3FJpYL49YprLAaJp2/APLVN+M8p+coZK/yet92qv4Rdlv
         QiJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737702474; x=1738307274;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RU+/pxkUgIWWtDLkUo0WrjleioNh6PoKJw4OsEQLSGc=;
        b=uMqpiOe+czAbPOWJ00whtnnanjT1STvCtZ11aLpoBDVz/DpeRcy/wim8sg/l6i6fzb
         sijgAeslmGl9/r9kgbN4J/Zw7IFbETKZgM299GORSz1HGx2PRGPYhirJ0+5Id3BXKu/s
         zzF936nVnxMcOXzUfRasIf4mhLPNwHIZ8AIRjb7BFe0JHO8v+Dp3SVKu2tjHGE0dvIRa
         AwLEVHWnPF0dWpwL4AdYKPt48jN92o4UdhP9hKXOL9Q/bX5yf/WIb0wTg8Q/Inl4N7PP
         Hy/yrmAY9q8fqJpHQuY05/WUCNFK13K5wkaN/IYD17SHrPRN1gGldAXXewn83GH8SUfY
         PpHw==
X-Forwarded-Encrypted: i=1; AJvYcCVgtSNsftkS1K5buB1VDH1XA+/i5/uP1MpNxLrktd/4tJXrT4c/FniB8UMNrVoZuTjrkEtFe7NYEsoRiBJz@vger.kernel.org
X-Gm-Message-State: AOJu0Ywvfwy/55lopCfaItGOV4x6EzxKoMS8NvYG9zJWEocNvkrUpxfA
	uaAJvnq/EBt3Vg7pcNcU1Jwrph9bwolyVvMT9eVwMR1/PyP6mNGui+wFrPh7eJGfdOAgov48J6r
	VarAlKM4h0FdvMEPtgU+VePzVGW8=
X-Gm-Gg: ASbGnctKCPgcc96MVDhjny7GaE1mVAbDSXhykn2HGfiinn3dYAuy/X/X8MSQ2DVezh2
	7R7xsmEHd3I5OIxpjCZFfR4WmRDsGCroRvgabqFTQHQHw/aNB6un7aypmhB2USd9u
X-Google-Smtp-Source: AGHT+IG4UwEcP7TnF9nDTFrAjSjcmywYqAq+K58Z4AcpG6PPlpR1d9uWMTz3AlsnyAeWltW14wJVGBLXu8pArKDMzU0=
X-Received: by 2002:a05:6214:21e4:b0:6e1:6bdf:ed1c with SMTP id
 6a1803df08f44-6e1b217a2a8mr421136726d6.14.1737702474365; Thu, 23 Jan 2025
 23:07:54 -0800 (PST)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CALOAHbA9WHPjeZKUcUkwULagQjTMfqAdAg+akqPzbZ7Byc=qrw@mail.gmail.com>
 <CALOAHbAi61nrAqL9OLaAsRa_WoDYUrC96rYTGWZh1b6-Lotupg@mail.gmail.com>
 <Z5DaUvNAMUP0Euoy@pathway.suse.cz> <CALOAHbBC2TSoy4fGcCe88pR7Nc1yyN+HYbXJA3O8UwHoRsLtSg@mail.gmail.com>
 <CALOAHbAr8jPgeseW7zPB9mk7tfxN3HDUqFSA__oOvEtobX4-5A@mail.gmail.com>
 <Z5EVL19hj3bnrKjA@pathway.suse.cz> <Z5Jmd_Xb7Ug9GxGG@pathway.suse.cz> <CALOAHbA+ro6r_p3cGdzNn4FjDyYa-=CuHuvUHntMxCX0MbTEJg@mail.gmail.com>
In-Reply-To: <CALOAHbA+ro6r_p3cGdzNn4FjDyYa-=CuHuvUHntMxCX0MbTEJg@mail.gmail.com>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Fri, 24 Jan 2025 15:07:18 +0800
X-Gm-Features: AWEUYZnk0vdqqr58KnLNPY1RCILzOaIhZEzCyCq65mFz_qlX6nO7kpzMld2qjws
Message-ID: <CALOAHbAWdq1eYYHy6iK27FiPUwvErybNdt1uuJzh-5wQCDjFcg@mail.gmail.com>
Subject: Re: [BUG] Kernel Crash during replacement of livepatch patching do_exit()
To: Petr Mladek <pmladek@suse.com>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>, jikos@kernel.org, Miroslav Benes <mbenes@suse.cz>, 
	Joe Lawrence <joe.lawrence@redhat.com>, live-patching@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 24, 2025 at 11:11=E2=80=AFAM Yafang Shao <laoar.shao@gmail.com>=
 wrote:
>
> On Thu, Jan 23, 2025 at 11:55=E2=80=AFPM Petr Mladek <pmladek@suse.com> w=
rote:
> >
> > On Wed 2025-01-22 16:56:31, Petr Mladek wrote:
> > > Anyway, I am working on a POC which would allow to track
> > > to-be-released processes. It would finish the transition only
> > > when all the to-be-released processes already use the new code.
> > > It won't allow to remove the disabled livepatch prematurely.
> >
> > Here is the POC. I am not sure if it is the right path, see
> > the warning and open questions in the commit message.
> >
> > I am going to wait for some feedback before investing more time
> > into this.
> >
> > The patch is against current Linus' master, aka, v6.13-rc7.
> >
> > From ac7287d99aaeca7a4536e8ade61b9bd0c8ec7fdc Mon Sep 17 00:00:00 2001
> > From: Petr Mladek <pmladek@suse.com>
> > Date: Thu, 23 Jan 2025 09:04:09 +0100
> > Subject: [PATCH] livepatching: Block transition until
> >  delayed_put_task_struct()
> >
> > WARNING: This patch is just a POC. It will blow up the system because
> >         RCU callbacks are handled by softirq context which are handled
> >         by default on exit from IRQ handlers. And it is not allowed
> >         to take sleeping locks here, see the backtrace at the end
> >         of the commit message.
> >
> >         We would need to synchronize the counting of the exiting
> >         processes with the livepatch transition another way.
> >
> >         Hmm, I guess that spin_lock is legal in softirq context.
> >         It might be the easiest approach.
> >
> >         In the worst case, we would need to use a lock less
> >         algorithm which might make things even more complicated.
> >
> > Here is the description of the problem and the solution:
> >
> > The livepatching core code uses for_each_process_thread() cycle for set=
ting
> > and checking the state of processes on the system. It works well as lon=
g
> > as the livepatch touches only code which is used only by processes in
> > the task list.
> >
> > The problem starts when the livepatch replaces code which might be
> > used by a process which is not longer in the task list. It is
> > mostly about the processes which are being removed. They
> > disapper from the list here:
> >
> >         + release_task()
> >           + __exit_signal()
> >             + __unhash_process()
> >
> > There are basically two groups of problems:
> >
> > 1. The livepatching core does not longer updates TIF_PATCH_PENDING
> >    and p->patch_state. In this case, the ftrace handler
> >    klp_check_stack_func() might do wrong decision and
> >    use an incompatible variant of the code.
>
> I believe I was able to reproduce the issue while attempting to
> trigger the panic. The warning message is as follows:
>
> The warning occurred at the following location:
>
>  klp_ftrace_handler
>       if (unlikely(func->transition)) {
>           WARN_ON_ONCE(patch_state =3D=3D KLP_UNDEFINED);
>   }
>
> [58063.291589] livepatch: enabling patch 'livepatch_61_release12'
> [58063.297580] livepatch: 'livepatch_61_release12': starting patching tra=
nsition
> [58063.323340] ------------[ cut here ]------------
> [58063.323343] WARNING: CPU: 58 PID: 3851051 at
> kernel/livepatch/patch.c:98 klp_ftrace_handler+0x136/0x150
> [58063.323349] Modules linked in: livepatch_61_release12(OK)
> livepatch_61_release6(OK) ebtable_filter ebtables af_packet_diag
> netlink_diag xt_DSCP xt_owner iptable_mangle raw_diag unix_diag
> udp_diag iptable_raw xt_CT tcp_diag inet_diag cls_bpf sch_ingress
> bpf_preload binfmt_misc iptable_filter bpfilter xt_conntrack nf_nat
> nf_conntrack_netlink nfnetlink nf_conntrack nf_defrag_ipv6
> nf_defrag_ipv4 overlay af_packet bonding tls intel_rapl_msr
> intel_rapl_common intel_uncore_frequency intel_uncore_frequency_common
> isst_if_common skx_edac nfit x86_pkg_temp_thermal intel_powerclamp
> coretemp kvm_intel kvm irqbypass rapl vfat intel_cstate fat iTCO_wdt
> xfs intel_uncore pcspkr ses enclosure input_leds i2c_i801 i2c_smbus
> mei_me lpc_ich ioatdma mei mfd_core intel_pch_thermal dca acpi_ipmi
> wmi ipmi_si ipmi_devintf ipmi_msghandler acpi_cpufreq acpi_pad
> acpi_power_meter ip_tables ext4 mbcache jbd2 sd_mod sg mpt3sas
> raid_class scsi_transport_sas megaraid_sas crct10dif_pclmul
> crc32_pclmul crc32c_intel
> [58063.323402]  polyval_clmulni polyval_generic ghash_clmulni_intel
> sha512_ssse3 aesni_intel nvme crypto_simd cryptd nvme_core t10_pi i40e
> ptp pps_core ahci libahci libata deflate zlib_deflate
> [58063.323413] Unloaded tainted modules:
> livepatch_61_release6(OK):3369 livepatch_61_release12(OK):3370 [last
> unloaded: livepatch_61_release12(OK)]
> [58063.323418] CPU: 58 PID: 3851051 Comm: docker Kdump: loaded
> Tainted: G S         O  K    6.1.52-3
> [58063.323421] Hardware name: Inspur SA5212M5/SA5212M5, BIOS 4.1.20 05/05=
/2021
> [58063.323423] RIP: 0010:klp_ftrace_handler+0x136/0x150
> [58063.323425] Code: eb b3 0f 1f 44 00 00 eb b5 8b 89 f4 23 00 00 83
> f9 ff 74 16 85 c9 75 89 48 8b 00 48 8d 50 90 48 39 c6 0f 85 79 ff ff
> ff eb 8b <0f> 0b e9 70 ff ff ff e8 ae 24 9c 00 66 66 2e 0f 1f 84 00 00
> 00 00
> [58063.323428] RSP: 0018:ffffa87b2367fbb8 EFLAGS: 00010046
> [58063.323429] RAX: ffff8b0ee59229a0 RBX: ffff8b26fa47b000 RCX: 00000000f=
fffffff
> [58063.323432] RDX: ffff8b0ee5922930 RSI: ffff8b2d41e53f10 RDI: ffffa87b2=
367fbd8
> [58063.323433] RBP: ffffa87b2367fbc8 R08: 0000000000000000 R09: fffffffff=
ffffff7
> [58063.323434] R10: 0000000000000000 R11: 0000000000000000 R12: ffff8b252=
0eaf240
> [58063.323435] R13: ffff8b26fa47b000 R14: 000000000002f240 R15: 000000000=
0000000
> [58063.323436] FS:  0000000000000000(0000) GS:ffff8b2520e80000(0000)
> knlGS:0000000000000000
> [58063.323438] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [58063.323440] CR2: 00007f19d7eaf000 CR3: 000000187a676004 CR4: 000000000=
07706e0
> [58063.323441] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 000000000=
0000000
> [58063.323442] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 000000000=
0000400
> [58063.323444] PKRU: 55555554
> [58063.323445] Call Trace:
> [58063.323445]  <TASK>
> [58063.323449]  ? show_regs.cold+0x1a/0x1f
> [58063.323454]  ? klp_ftrace_handler+0x136/0x150
> [58063.323455]  ? __warn+0x84/0xd0
> [58063.323457]  ? klp_ftrace_handler+0x136/0x150
> [58063.323459]  ? report_bug+0x105/0x180
> [58063.323463]  ? handle_bug+0x40/0x70
> [58063.323467]  ? exc_invalid_op+0x19/0x70
> [58063.323469]  ? asm_exc_invalid_op+0x1b/0x20
> [58063.323474]  ? klp_ftrace_handler+0x136/0x150
> [58063.323476]  ? kmem_cache_free+0x155/0x470
> [58063.323479]  0xffffffffc0876099
> [58063.323495]  ? update_rq_clock+0x5/0x250
> [58063.323498]  update_rq_clock+0x5/0x250
> [58063.323500]  __schedule+0xed/0x8f0
> [58063.323504]  ? update_rq_clock+0x5/0x250
> [58063.323506]  ? __schedule+0xed/0x8f0
> [58063.323508]  ? trace_hardirqs_off+0x36/0xf0
> [58063.323512]  do_task_dead+0x44/0x50
> [58063.323515]  do_exit+0x7cd/0xb90 [livepatch_61_release6]
> [58063.323525]  ? xfs_inode_mark_reclaimable+0x320/0x320 [livepatch_61_re=
lease6]
> [58063.323533]  do_group_exit+0x35/0x90
> [58063.323536]  get_signal+0x909/0x950
> [58063.323539]  ? get_futex_key+0xa4/0x4f0
> [58063.323543]  arch_do_signal_or_restart+0x34/0x2a0
> [58063.323547]  exit_to_user_mode_prepare+0x149/0x1b0
> [58063.323551]  syscall_exit_to_user_mode+0x1e/0x50
> [58063.323555]  do_syscall_64+0x48/0x90
> [58063.323557]  entry_SYSCALL_64_after_hwframe+0x64/0xce
> [58063.323560] RIP: 0033:0x5601df8122f3
> [58063.323563] Code: Unable to access opcode bytes at 0x5601df8122c9.
> [58063.323564] RSP: 002b:00007f9ce6ffccc0 EFLAGS: 00000286 ORIG_RAX:
> 00000000000000ca
> [58063.323566] RAX: fffffffffffffe00 RBX: 000000c42053e000 RCX: 00005601d=
f8122f3
> [58063.323567] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 000000c42=
053e148
> [58063.323568] RBP: 00007f9ce6ffcd08 R08: 0000000000000000 R09: 000000000=
0000000
> [58063.323569] R10: 0000000000000000 R11: 0000000000000286 R12: 000000000=
0000000
> [58063.323570] R13: 0000000000801000 R14: 0000000000000000 R15: 00007f9ce=
6ffd700
> [58063.323573]  </TASK>
> [58063.323574] ---[ end trace 0000000000000000 ]---
>
> >
> >    This might become a real problem only when the code modifies
> >    the semantic.
> >
> > 2. The livepatching core does not longer check the stack and
> >    could finish the livepatch transition even when these
> >    to-be-removed processes have not been transitioned yet.
> >
> >    This might even cause Oops when the to-be-removed processes
> >    are running a code from a disabled livepatch which might
> >    be removed in the meantime.
> >
> > This patch tries to address the 2nd problem which most likely caused
> > the following crash:
> > [...]
> >
> > This patch tries to avoid the crash by tracking the number of
> > to-be-released processes. They block the current transition
> > until delayed_put_task_struct() is called.
> >
> > It is just a POC. There are many open questions:
> >
> > 1. Does it help at all?
> >
> >    It looks to me that release_task() is always called from another
> >    task. For example, exit_notify() seems to call it for a dead
> >    childern. It is not clear to me whether the released task
> >    is still running do_exit() at this point.
>
> If the task is a thread (but not the thread group leader), it should
> call release_task(), correct? Below is the trace from our production
> server:
>
> $ bpftrace -e 'k:release_task {$tsk=3D(struct task_struct *)arg0; if
> ($tsk->pid =3D=3D tid){@stack[kstack()]=3Dcount()}}'
> @stack[
>     release_task+1
>     kthread_exit+41
>     kthread+200
>     ret_from_fork+31
> ]: 1
> @stack[
>     release_task+1
>     do_group_exit+53
>     __x64_sys_exit_group+24
>     do_syscall_64+56
>     entry_SYSCALL_64_after_hwframe+100
> ]: 2
> @stack[
>     release_task+1
>     do_group_exit+53
>     get_signal+2313
>     arch_do_signal_or_restart+52
>     exit_to_user_mode_prepare+329
>     syscall_exit_to_user_mode+30
>     do_syscall_64+72
>     entry_SYSCALL_64_after_hwframe+100
> ]: 20
> @stack[
>     release_task+1
>     __x64_sys_exit+27
>     do_syscall_64+56
>     entry_SYSCALL_64_after_hwframe+100
> ]: 26
>
> >
> >    Well, for example, wait_task_zombie() calls release_task()
> >    in some special cases.
> >
> > 2. Is it enough to block the transition until delayed_put_task_struct()=
?
> >
> >    I do not fully understand the maze of code. It might still be too
> >    early.
> >
> >    It seems that put_task_struct() can delay the release even more.
>
> After delayed_put_task_struct(), there is still some code that needs
> to be executed. It appears that this just reduces the likelihood of
> the issue occurring, but does not completely prevent it.

The last function to be executed is do_task_dead(), and this function
will not return to do_exit() again. What if we define this function as
"__noinline __nopatchable" and perform the final check within it?

The "__noinline" attribute ensures it won=E2=80=99t be inlined into do_exit=
(),
while "__nopatchable" guarantees that it can't be livepatched.

Something as follows?

--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -6569,6 +6569,7 @@ void __noreturn do_task_dead(void)
        /* Tell freezer to ignore us: */
        current->flags |=3D PF_NOFREEZE;

+       klp_put_releasing_task();
        __schedule(SM_NONE);
        BUG();


--
Regards
Yafang

