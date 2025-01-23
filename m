Return-Path: <live-patching+bounces-1040-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 17271A1A75B
	for <lists+live-patching@lfdr.de>; Thu, 23 Jan 2025 16:55:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D890918862BA
	for <lists+live-patching@lfdr.de>; Thu, 23 Jan 2025 15:55:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 95CF720E71C;
	Thu, 23 Jan 2025 15:55:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="CBf/y5ZZ"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A03C0F4F1
	for <live-patching@vger.kernel.org>; Thu, 23 Jan 2025 15:55:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737647742; cv=none; b=IO7TPeF9Pl/l/9Fyef2QBrtAz3bjxw914KdmTxvp6euATo/JPRQoiUDKWvHjTZM9YDmimIBWIp9zvN9JWZm6F6Np9TRKoavu3tFW87IZ8jiAmmKhQZwNzZ00sP/VtnV1N3MPU4f/mslRaa/HaKIiV1Exar+OTgTyd8r+xb+Og34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737647742; c=relaxed/simple;
	bh=iGqCgmvz4KrircTOtm6Pka4IWm+1H6TyfLL4FuDfhHA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=N5OncjFDAcrlcrlGDARMWVNpQ0vo8GwN13AUg6UD/gYz6KEiyQRrkoPSqbDHT1PLeFGxXs4eHFuISbI+s7fV2yrUgOF9FVqJqjpQj2Z7/Dzx+w0lbjEiniL4Ufvcph7xRnHrWLgjw2fn4p1mrORX2QXQLRWoAG3BH5pvQx6rjAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=CBf/y5ZZ; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-43622267b2eso11384715e9.0
        for <live-patching@vger.kernel.org>; Thu, 23 Jan 2025 07:55:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1737647738; x=1738252538; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=yYE2j1wZr8FDf60DZmDFpUfxfuradB+vroDn1CLPtzI=;
        b=CBf/y5ZZ3G99SAftyHZLkYWvqKJte1Zv5i9D+TQZZEGSkyb8tk7GNWe4fCe0m+3Ecr
         YiMspHrrAZkxjYCWextRF/avT9G0LWPbgyNcznJss7P2RzSRsKS3pq8EjhTmEpe7KA2F
         k4FxZtInNQFLVHbch//OUUo6Kg+Kx39nQ3jOSjcA94cV3mQlgBr+0tn2B8oo9Fmr3UmZ
         yTFKC7x/+mjycLEhz1t8tQrewt2J9JXeGtL+BuNJtUWTG9Ob1lX7IUdyOQPsfDtBnsNu
         8zDJ/dMxe2i65deppxj1tnflFyUlS0j2+qDXxAHrRRMy1MJ9qcx/88gZm//EmmHjaZpG
         YUag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737647738; x=1738252538;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yYE2j1wZr8FDf60DZmDFpUfxfuradB+vroDn1CLPtzI=;
        b=REATbzvcKbdea+LMLNYCdrArf1GY+AiIWbtGuIWmD6BkHWu+6kKRd1YK2/SjRfSKNU
         QDRiKQQ30ZuyEcw73KT3n4L5+TDWCtWN2m929vukOFd2KDHnoHeFaRZQYHhQLToO0I80
         HKPGaahmgbvp8S3m77UWkLmLYaeae31DNhhU2S2BqfzlLJko39tJX4BiVE7KnPwoe+n6
         RGP71G2nMrZKtNvUtvqnjIcl3qnRzX4m2unGDbfR7QtiX6o4E0UZ502/83nAXl3EJgWU
         16T4/y0pZnZWrcVxsoeYA8mOSpKN3SIJRiWiQLQhvBzg5AK8DugxVgUgMHzwLuGxxQiN
         lcAQ==
X-Forwarded-Encrypted: i=1; AJvYcCVpcdGhiEUZ/ZLe+eXvBhaQUncQ6kJCcV8vFW4s0UgGrnzzt0k0Os774ptgWfBmlWV0QI0sCUrmRM7U6ht/@vger.kernel.org
X-Gm-Message-State: AOJu0YzHrArsx7Vc2YbLFJYdyLWd6qmZ2JdMHu6lnq/eps8yW1ZFmiqZ
	FcT8vnC1nJO1xa2nFM/rI+8oFInGJOuuC8gCXqmAsHqXr6pSFDLBYaKgmfiva1M=
X-Gm-Gg: ASbGnctpZIFRXGcmgGy4r1JQl8EUc9iGEeKPviEsj/9EBeQiXfBdngAZEebK7ZLywef
	B6Zu9RAakrZx6rE4Ve7p+uG44W/Wgvy4qQrCzbZAEszWLxIzyskO9RU2/+uqVwgoShgy2cCR6rD
	Y+7jyxNcztywdDz6e8XSTd16DPOKOyFv1ZYajaKNHvX9/BiWyP4LXDVFtlLE4WpU+JwiDeX0AxD
	OMziKSul5Ou2DDUxpr1op4kMyf6bLoS+AsXLJqlZl2+f+TlcKSoOKUZXrMgkg0aRSaa5ITHBt/B
	zBWq+vQBMjqxxfzVSG9U6gyKP5LDYI7774FIzA==
X-Google-Smtp-Source: AGHT+IH6cJ8VDYSHDJZSynjwwlRt8Y1h6s++sG5SNWOau3xExSKaaFkeLd2KdoYDIDiRoETiEbAVZg==
X-Received: by 2002:a05:600c:3b27:b0:434:fd15:3ac9 with SMTP id 5b1f17b1804b1-43891438051mr233875845e9.22.1737647737671;
        Thu, 23 Jan 2025 07:55:37 -0800 (PST)
Received: from pathway.suse.cz (176-114-240-130.rychlydrat.cz. [176.114.240.130])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-438b31d9a51sm66150565e9.28.2025.01.23.07.55.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jan 2025 07:55:37 -0800 (PST)
Date: Thu, 23 Jan 2025 16:55:35 +0100
From: Petr Mladek <pmladek@suse.com>
To: Yafang Shao <laoar.shao@gmail.com>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>, jikos@kernel.org,
	Miroslav Benes <mbenes@suse.cz>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	live-patching@vger.kernel.org
Subject: Re: [BUG] Kernel Crash during replacement of livepatch patching
 do_exit()
Message-ID: <Z5Jmd_Xb7Ug9GxGG@pathway.suse.cz>
References: <CALOAHbA9WHPjeZKUcUkwULagQjTMfqAdAg+akqPzbZ7Byc=qrw@mail.gmail.com>
 <CALOAHbAi61nrAqL9OLaAsRa_WoDYUrC96rYTGWZh1b6-Lotupg@mail.gmail.com>
 <Z5DaUvNAMUP0Euoy@pathway.suse.cz>
 <CALOAHbBC2TSoy4fGcCe88pR7Nc1yyN+HYbXJA3O8UwHoRsLtSg@mail.gmail.com>
 <CALOAHbAr8jPgeseW7zPB9mk7tfxN3HDUqFSA__oOvEtobX4-5A@mail.gmail.com>
 <Z5EVL19hj3bnrKjA@pathway.suse.cz>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z5EVL19hj3bnrKjA@pathway.suse.cz>

On Wed 2025-01-22 16:56:31, Petr Mladek wrote:
> Anyway, I am working on a POC which would allow to track
> to-be-released processes. It would finish the transition only
> when all the to-be-released processes already use the new code.
> It won't allow to remove the disabled livepatch prematurely.

Here is the POC. I am not sure if it is the right path, see
the warning and open questions in the commit message.

I am going to wait for some feedback before investing more time
into this.

The patch is against current Linus' master, aka, v6.13-rc7.

From ac7287d99aaeca7a4536e8ade61b9bd0c8ec7fdc Mon Sep 17 00:00:00 2001
From: Petr Mladek <pmladek@suse.com>
Date: Thu, 23 Jan 2025 09:04:09 +0100
Subject: [PATCH] livepatching: Block transition until
 delayed_put_task_struct()

WARNING: This patch is just a POC. It will blow up the system because
	RCU callbacks are handled by softirq context which are handled
	by default on exit from IRQ handlers. And it is not allowed
	to take sleeping locks here, see the backtrace at the end
	of the commit message.

	We would need to synchronize the counting of the exiting
	processes with the livepatch transition another way.

	Hmm, I guess that spin_lock is legal in softirq context.
	It might be the easiest approach.

	In the worst case, we would need to use a lock less
	algorithm which might make things even more complicated.

Here is the description of the problem and the solution:

The livepatching core code uses for_each_process_thread() cycle for setting
and checking the state of processes on the system. It works well as long
as the livepatch touches only code which is used only by processes in
the task list.

The problem starts when the livepatch replaces code which might be
used by a process which is not longer in the task list. It is
mostly about the processes which are being removed. They
disapper from the list here:

	+ release_task()
	  + __exit_signal()
	    + __unhash_process()

There are basically two groups of problems:

1. The livepatching core does not longer updates TIF_PATCH_PENDING
   and p->patch_state. In this case, the ftrace handler
   klp_check_stack_func() might do wrong decision and
   use an incompatible variant of the code.

   This might become a real problem only when the code modifies
   the semantic.

2. The livepatching core does not longer check the stack and
   could finish the livepatch transition even when these
   to-be-removed processes have not been transitioned yet.

   This might even cause Oops when the to-be-removed processes
   are running a code from a disabled livepatch which might
   be removed in the meantime.

This patch tries to address the 2nd problem which most likely caused
the following crash:

[156821.048318] livepatch: enabling patch 'livepatch_61_release12'
[156821.061580] livepatch: 'livepatch_61_release12': starting patching
transition
[156821.122212] livepatch: 'livepatch_61_release12': patching complete
[156821.175871] kernel tried to execute NX-protected page - exploit
attempt? (uid: 10524)
[156821.176011] BUG: unable to handle page fault for address: ffffffffc0ded7fa
[156821.176121] #PF: supervisor instruction fetch in kernel mode
[156821.176211] #PF: error_code(0x0011) - permissions violation
[156821.176302] PGD 986c15067 P4D 986c15067 PUD 986c17067 PMD
184f53b067 PTE 800000194c08e163
[156821.176435] Oops: 0011 [#1] PREEMPT SMP NOPTI
[156821.176506] CPU: 70 PID: 783972 Comm: java Kdump: loaded Tainted:
G S      W  O  K    6.1.52-3 #3.pdd
[156821.176654] Hardware name: Inspur SA5212M5/SA5212M5, BIOS 4.1.20 05/05/2021
[156821.176766] RIP: 0010:0xffffffffc0ded7fa
[156821.176841] Code: 0a 00 00 48 89 42 08 48 89 10 4d 89 a6 08 0a 00
00 4c 89 f7 4d 89 a6 10 0a 00 00 4d 8d a7 08 0a 00 00 4d 89 fe e8 00
00 00 00 <49> 8b 87 08 0a 00 00 48 2d 08 0a 00 00 4d 39 ec 75 aa 48 89
df e8
[156821.177138] RSP: 0018:ffffba6f273dbd30 EFLAGS: 00010282
[156821.177222] RAX: 0000000000000000 RBX: ffff94cd316f0000 RCX:
000000008020000d
[156821.177338] RDX: 000000008020000e RSI: 000000008020000d RDI:
ffff94cd316f0000
[156821.177452] RBP: ffffba6f273dbd88 R08: ffff94cd316f13f8 R09:
0000000000000001
[156821.177567] R10: 0000000000000000 R11: 0000000000000000 R12:
ffffba6f273dbd48
[156821.177682] R13: ffffba6f273dbd48 R14: ffffba6f273db340 R15:
ffffba6f273db340
[156821.177797] FS:  0000000000000000(0000) GS:ffff94e321180000(0000)
knlGS:0000000000000000
[156821.177926] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[156821.178019] CR2: ffffffffc0ded7fa CR3: 000000015909c006 CR4:
00000000007706e0
[156821.178133] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[156821.178248] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:
0000000000000400
[156821.178363] PKRU: 55555554
[156821.178407] Call Trace:
[156821.178449]  <TASK>
[156821.178492]  ? show_regs.cold+0x1a/0x1f
[156821.178559]  ? __die_body+0x20/0x70
[156821.178617]  ? __die+0x2b/0x37
[156821.178669]  ? page_fault_oops+0x136/0x2b0
[156821.178734]  ? search_bpf_extables+0x63/0x90
[156821.178805]  ? search_exception_tables+0x5f/0x70
[156821.178881]  ? kernelmode_fixup_or_oops+0xa2/0x120
[156821.178957]  ? __bad_area_nosemaphore+0x176/0x1b0
[156821.179034]  ? bad_area_nosemaphore+0x16/0x20
[156821.179105]  ? do_kern_addr_fault+0x77/0x90
[156821.179175]  ? exc_page_fault+0xc6/0x160
[156821.179239]  ? asm_exc_page_fault+0x27/0x30
[156821.179310]  do_group_exit+0x35/0x90
[156821.179371]  get_signal+0x909/0x950
[156821.179429]  ? wake_up_q+0x50/0x90
[156821.179486]  arch_do_signal_or_restart+0x34/0x2a0
[156821.183207]  exit_to_user_mode_prepare+0x149/0x1b0
[156821.186963]  syscall_exit_to_user_mode+0x1e/0x50
[156821.190723]  do_syscall_64+0x48/0x90
[156821.194500]  entry_SYSCALL_64_after_hwframe+0x64/0xce
[156821.198195] RIP: 0033:0x7f967feb5a35
[156821.201769] Code: Unable to access opcode bytes at 0x7f967feb5a0b.
[156821.205283] RSP: 002b:00007f96664ee670 EFLAGS: 00000246 ORIG_RAX:
00000000000000ca
[156821.208790] RAX: fffffffffffffe00 RBX: 00007f967808a650 RCX:
00007f967feb5a35
[156821.212305] RDX: 000000000000000f RSI: 0000000000000080 RDI:
00007f967808a654
[156821.215785] RBP: 00007f96664ee6c0 R08: 00007f967808a600 R09:
0000000000000007
[156821.219273] R10: 0000000000000000 R11: 0000000000000246 R12:
00007f967808a600
[156821.222727] R13: 00007f967808a628 R14: 00007f967f691220 R15:
00007f96664ee750
[156821.226155]  </TASK>
[156821.229470] Modules linked in: livepatch_61_release12(OK)
ebtable_filter ebtables af_packet_diag netlink_diag xt_DSCP xt_owner
iptable_mangle iptable_raw xt_CT cls_bpf sch_ingress bpf_preload
binfmt_misc raw_diag unix_diag tcp_diag udp_diag inet_diag
iptable_filter bpfilter xt_conntrack nf_nat nf_conntrack_netlink
nfnetlink nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 overlay af_packet
bonding tls intel_rapl_msr intel_rapl_common intel_uncore_frequency
intel_uncore_frequency_common isst_if_common skx_edac nfit
x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel kvm irqbypass
rapl vfat fat intel_cstate iTCO_wdt xfs intel_uncore pcspkr ses
enclosure mei_me i2c_i801 input_leds lpc_ich acpi_ipmi ioatdma
i2c_smbus mei mfd_core dca wmi ipmi_si intel_pch_thermal ipmi_devintf
ipmi_msghandler acpi_cpufreq acpi_pad acpi_power_meter ip_tables ext4
mbcache jbd2 sd_mod sg mpt3sas raid_class scsi_transport_sas
megaraid_sas crct10dif_pclmul crc32_pclmul crc32c_intel
polyval_clmulni polyval_generic
[156821.229555]  ghash_clmulni_intel sha512_ssse3 aesni_intel
crypto_simd cryptd nvme nvme_core t10_pi i40e ptp pps_core ahci
libahci libata deflate zlib_deflate
[156821.259012] Unloaded tainted modules:
livepatch_61_release6(OK):14089 livepatch_61_release12(OK):14088 [last
unloaded: livepatch_61_release6(OK)]
[156821.275421] CR2: ffffffffc0ded7fa

This patch tries to avoid the crash by tracking the number of
to-be-released processes. They block the current transition
until delayed_put_task_struct() is called.

It is just a POC. There are many open questions:

1. Does it help at all?

   It looks to me that release_task() is always called from another
   task. For example, exit_notify() seems to call it for a dead
   childern. It is not clear to me whether the released task
   is still running do_exit() at this point.

   Well, for example, wait_task_zombie() calls release_task()
   in some special cases.

2. Is it enough to block the transition until delayed_put_task_struct()?

   I do not fully understand the maze of code. It might still be too
   early.

   It seems that put_task_struct() can delay the release even more.
   Mabye, we should drop the klp reference count when it is final
   put_task_struct().

3. Is this worth the effort?

   It is probably a bad idea to livepatch do_exit() in the first place.

   But it is not obvious why it is a problem. It would be nice to at
   least detect the problem and warn about it.

Finally, here is the backtrace showing the problem with taking klp_mutex in
the RCU handler.

[    0.986614][    C3] =============================
[    0.987234][    C3] [ BUG: Invalid wait context ]
[    0.987882][    C3] 6.13.0-rc7-default+ #234 Tainted: G        W
[    0.988733][    C3] -----------------------------
[    0.989219][    C3] swapper/3/0 is trying to lock:
[    0.989698][    C3] ffffffff86447030 (klp_mutex){+.+.}-{4:4}, at: klp_put_releasing_task+0x1b/0x90
[    0.990283][    C3] other info that might help us debug this:
[    0.990283][    C3] context-{3:3}
[    0.990283][    C3] 1 lock held by swapper/3/0:
[    0.990283][    C3]  #0: ffffffff86377fc0 (rcu_callback){....}-{0:0}, at: rcu_do_batch+0x1a8/0xa40
[    0.990283][    C3] stack backtrace:
[    0.990283][    C3] CPU: 3 UID: 0 PID: 0 Comm: swapper/3 Tainted: G        W          6.13.0-rc7-default+ #234 bfeca4b35f98fc672d5ef9f6b720fe908580ae2c
[    0.990283][    C3] Tainted: [W]=WARN
[    0.990283][    C3] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.16.3-2-gc13ff2cd-prebuilt.qemu.org 04/01/2014
[    0.990283][    C3] Call Trace:
[    0.990283][    C3]  <IRQ>
[    0.990283][    C3]  dump_stack_lvl+0x6c/0xa0
[    0.990283][    C3]  __lock_acquire+0x919/0xb70
[    0.990283][    C3]  lock_acquire.part.0+0xad/0x220
[    0.990283][    C3]  ? klp_put_releasing_task+0x1b/0x90
[    0.990283][    C3]  ? rcu_is_watching+0x11/0x50
[    0.990283][    C3]  ? lock_acquire+0x107/0x140
[    0.990283][    C3]  ? klp_put_releasing_task+0x1b/0x90
[    0.990283][    C3]  __mutex_lock+0xb5/0xe00
[    0.990283][    C3]  ? klp_put_releasing_task+0x1b/0x90
[    0.990283][    C3]  ? __lock_acquire+0x551/0xb70
[    0.990283][    C3]  ? klp_put_releasing_task+0x1b/0x90
[    0.990283][    C3]  ? lock_acquire.part.0+0xbd/0x220
[    0.990283][    C3]  ? klp_put_releasing_task+0x1b/0x90
[    0.990283][    C3]  klp_put_releasing_task+0x1b/0x90
[    0.990283][    C3]  delayed_put_task_struct+0x4b/0x150
[    0.990283][    C3]  ? rcu_do_batch+0x1d2/0xa40
[    0.990283][    C3]  rcu_do_batch+0x1d4/0xa40
[    0.990283][    C3]  ? rcu_do_batch+0x1a8/0xa40
[    0.990283][    C3]  ? lock_is_held_type+0xd9/0x130
[    0.990283][    C3]  rcu_core+0x3bb/0x4f0
[    0.990283][    C3]  handle_softirqs+0xe2/0x400
[    0.990283][    C3]  __irq_exit_rcu+0xd9/0x150
[    0.990283][    C3]  irq_exit_rcu+0xe/0x30
[    0.990283][    C3]  sysvec_apic_timer_interrupt+0x8d/0xb0
[    0.990283][    C3]  </IRQ>
[    0.990283][    C3]  <TASK>
[    0.990283][    C3]  asm_sysvec_apic_timer_interrupt+0x1a/0x20
[    0.990283][    C3] RIP: 0010:pv_native_safe_halt+0xf/0x20
[    0.990283][    C3] Code: 22 d7 c3 cc cc cc cc 0f 1f 40 00 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 f3 0f 1e fa 66 90 0f 00 2d 03 92 2f 00 fb f4 <c3> cc cc cc cc 66 66 2e 0f 1f 84 00 00 00 00 00 90 90 90 90 90 90
[    0.990283][    C3] RSP: 0000:ffffb95bc00c3eb8 EFLAGS: 00000246
[    0.990283][    C3] RAX: 0000000000000111 RBX: 00000000001fd2cc RCX: 0000000000000000
[    0.990283][    C3] RDX: 0000000000000000 RSI: ffffffff85f06d6a RDI: ffffffff85ed7907
[    0.990283][    C3] RBP: ffff9cd980883740 R08: 0000000000000001 R09: 0000000000000000
[    0.990283][    C3] R10: 0000000000000001 R11: 0000000000000001 R12: 0000000000000000
[    0.990283][    C3] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[    0.990283][    C3]  default_idle+0x9/0x20
[    0.990283][    C3]  default_idle_call+0x84/0x1e0
[    0.990283][    C3]  cpuidle_idle_call+0x134/0x170
[    0.990283][    C3]  ? tsc_verify_tsc_adjust+0x45/0xd0
[    0.990283][    C3]  do_idle+0x93/0xf0
[    0.990283][    C3]  cpu_startup_entry+0x29/0x30
[    0.990283][    C3]  start_secondary+0x121/0x140
[    0.990283][    C3]  common_startup_64+0x13e/0x141
[    0.990283][    C3]  </TASK>

Signed-off-by: Petr Mladek <pmladek@suse.com>
---
 include/linux/livepatch.h     |  3 ++
 include/linux/sched.h         |  1 +
 kernel/exit.c                 |  5 ++
 kernel/livepatch/transition.c | 89 +++++++++++++++++++++++++++++------
 4 files changed, 83 insertions(+), 15 deletions(-)

diff --git a/include/linux/livepatch.h b/include/linux/livepatch.h
index 51a258c24ff5..63e9e56ca6fe 100644
--- a/include/linux/livepatch.h
+++ b/include/linux/livepatch.h
@@ -201,6 +201,9 @@ void klp_module_going(struct module *mod);
 void klp_copy_process(struct task_struct *child);
 void klp_update_patch_state(struct task_struct *task);
 
+void klp_get_releasing_task(struct task_struct *task);
+void klp_put_releasing_task(struct task_struct *task);
+
 static inline bool klp_patch_pending(struct task_struct *task)
 {
 	return test_tsk_thread_flag(task, TIF_PATCH_PENDING);
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 64934e0830af..d8a587208212 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1542,6 +1542,7 @@ struct task_struct {
 #endif
 #ifdef CONFIG_LIVEPATCH
 	int patch_state;
+	bool klp_exit_counted;
 #endif
 #ifdef CONFIG_SECURITY
 	/* Used by LSM modules for access restriction: */
diff --git a/kernel/exit.c b/kernel/exit.c
index 1dcddfe537ee..a2a9672077d5 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -224,6 +224,7 @@ static void delayed_put_task_struct(struct rcu_head *rhp)
 	rethook_flush_task(tsk);
 	perf_event_delayed_put(tsk);
 	trace_sched_process_free(tsk);
+	klp_put_releasing_task(tsk);
 	put_task_struct(tsk);
 }
 
@@ -242,6 +243,10 @@ void release_task(struct task_struct *p)
 	struct task_struct *leader;
 	struct pid *thread_pid;
 	int zap_leader;
+
+	/* Block the transition until the very end. */
+	klp_get_releasing_task(p);
+
 repeat:
 	/* don't need to get the RCU readlock here - the process is dead and
 	 * can't be modifying its own credentials. But shut RCU-lockdep up */
diff --git a/kernel/livepatch/transition.c b/kernel/livepatch/transition.c
index ba069459c101..6403af34f231 100644
--- a/kernel/livepatch/transition.c
+++ b/kernel/livepatch/transition.c
@@ -25,6 +25,14 @@ struct klp_patch *klp_transition_patch;
 
 static int klp_target_state = KLP_TRANSITION_IDLE;
 
+/*
+ * Allow to livepatch do_exit() function by counting processes which
+ * are being removed from the task list. They will block the transition
+ * almost until the task struct is released.
+ */
+unsigned int klp_releasing_tasks_cnt;
+bool klp_track_releasing_tasks;
+
 static unsigned int klp_signals_cnt;
 
 /*
@@ -87,7 +95,7 @@ static void klp_synchronize_transition(void)
  * The transition to the target patch state is complete.  Clean up the data
  * structures.
  */
-static void klp_complete_transition(void)
+static void __klp_complete_transition(void)
 {
 	struct klp_object *obj;
 	struct klp_func *func;
@@ -156,6 +164,25 @@ static void klp_complete_transition(void)
 	klp_transition_patch = NULL;
 }
 
+static void klp_complete_transition(void)
+{
+	struct klp_patch *patch;
+
+	klp_cond_resched_disable();
+	patch = klp_transition_patch;
+	__klp_complete_transition();
+
+	/*
+	 * It would make more sense to free the unused patches in
+	 * klp_complete_transition() but it is called also
+	 * from klp_cancel_transition().
+	 */
+	if (!patch->enabled)
+		klp_free_patch_async(patch);
+	else if (patch->replace)
+		klp_free_replaced_patches_async(patch);
+}
+
 /*
  * This is called in the error path, to cancel a transition before it has
  * started, i.e. klp_init_transition() has been called but
@@ -171,7 +198,7 @@ void klp_cancel_transition(void)
 		 klp_transition_patch->mod->name);
 
 	klp_target_state = KLP_TRANSITION_UNPATCHED;
-	klp_complete_transition();
+	__klp_complete_transition();
 }
 
 /*
@@ -452,7 +479,6 @@ void klp_try_complete_transition(void)
 {
 	unsigned int cpu;
 	struct task_struct *g, *task;
-	struct klp_patch *patch;
 	bool complete = true;
 
 	WARN_ON_ONCE(klp_target_state == KLP_TRANSITION_IDLE);
@@ -507,20 +533,14 @@ void klp_try_complete_transition(void)
 		return;
 	}
 
-	/* Done!  Now cleanup the data structures. */
-	klp_cond_resched_disable();
-	patch = klp_transition_patch;
-	klp_complete_transition();
-
 	/*
-	 * It would make more sense to free the unused patches in
-	 * klp_complete_transition() but it is called also
-	 * from klp_cancel_transition().
+	 * All tasks in the task list are migrated. Stop counting releasing
+	 * processes. The last one would finish the transition when any.
 	 */
-	if (!patch->enabled)
-		klp_free_patch_async(patch);
-	else if (patch->replace)
-		klp_free_replaced_patches_async(patch);
+	klp_track_releasing_tasks = false;
+
+	/* Done!  Now cleanup the data structures. */
+	klp_complete_transition();
 }
 
 /*
@@ -582,6 +602,8 @@ void klp_init_transition(struct klp_patch *patch, int state)
 
 	klp_transition_patch = patch;
 
+	klp_track_releasing_tasks = true;
+
 	/*
 	 * Set the global target patch state which tasks will switch to.  This
 	 * has no effect until the TIF_PATCH_PENDING flags get set later.
@@ -715,6 +737,43 @@ void klp_copy_process(struct task_struct *child)
 	child->patch_state = current->patch_state;
 }
 
+void klp_get_releasing_task(struct task_struct* p)
+{
+	mutex_lock(&klp_mutex);
+
+	if (klp_track_releasing_tasks) {
+		klp_releasing_tasks_cnt++;
+		p->klp_exit_counted = true;
+	}
+
+	mutex_unlock(&klp_mutex);
+}
+
+void klp_put_releasing_task(struct task_struct *p)
+{
+	mutex_lock(&klp_mutex);
+
+	if (!p->klp_exit_counted)
+		goto out;
+
+	if (WARN_ON_ONCE(!klp_releasing_tasks_cnt))
+		goto out;
+
+	if (--klp_releasing_tasks_cnt)
+		goto out;
+
+	/*
+	 * Do not finish the transition when there are still non-migrated
+	 * processes in the task list.
+	 */
+	if (klp_track_releasing_tasks)
+		goto out;
+
+	klp_complete_transition();
+out:
+	mutex_unlock(&klp_mutex);
+}
+
 /*
  * Drop TIF_PATCH_PENDING of all tasks on admin's request. This forces an
  * existing transition to finish.
-- 
2.48.1


