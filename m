Return-Path: <live-patching+bounces-1013-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3A853A17A5C
	for <lists+live-patching@lfdr.de>; Tue, 21 Jan 2025 10:39:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 385393A241E
	for <lists+live-patching@lfdr.de>; Tue, 21 Jan 2025 09:39:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 754891C1AD4;
	Tue, 21 Jan 2025 09:39:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AmdMh6ta"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 768571C1F2F
	for <live-patching@vger.kernel.org>; Tue, 21 Jan 2025 09:39:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737452364; cv=none; b=ka0fsjtnvGAu2ZX4mS+9oklvr2h9gUiCZzap26hXgjTCzKI5F6zGL6iZK5XuzBVxlm2wrlxa3hUjnwZJS1wS8yV1ZZR6MTDBwkfFcljxH6dCl06aPvx8G+flxEgkuf2P8xxdgMVZfJE3BY8iM5ZaGqPII3Tu2ntHLZW6+0NnoLg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737452364; c=relaxed/simple;
	bh=Fp1XVFqUKgXaxr2Ko7uZSaOWQcwQ/ynpP+UpWDFpKt0=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=MnSVm+tz0vWXh/uQ45cNTEl95C8hkRRsX12chh4CT4s/1BI+sJoVYVPuQpftZScWOzjWJXCqEGwecEpzhvTA1j2efdF3L+qzE/Ydujsbt4L5+w2JpjSsIPoEmVKEvtkBcMc4GbdXCCjgHOoSBXL7dKJQ4Ab+OVYTrdw9dnZ8jao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AmdMh6ta; arc=none smtp.client-ip=209.85.160.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-468f6b3a439so53353961cf.1
        for <live-patching@vger.kernel.org>; Tue, 21 Jan 2025 01:39:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1737452361; x=1738057161; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=CrfiZvgCTOL2ebg6otRJp6bcMYzxQOGHKN3yaMsSmW4=;
        b=AmdMh6tax+e5LPLo2bMUlZrm2rI1XftFLzdz0CA47yUHG1eNLIWrKYqxa68Mhev4w/
         Z82pYgpPkG592hsHEhCGSDXGeIYE+/3+cZ2SdfPXly1pFj4b8TN9js6JUgLjrLXjhRVG
         PUQN0xsNks1tnwmCRQbWv/mlrfnspH6FR1tExEcfNvp9JOIcrsQZmTsWcz/ukMYl/Ck4
         oVe09auvl1eO+iJn6MuV9F/KoLKM9OqboTieQg/CA0Gbdh98/sGF1cg/5/7hg6pURrN8
         ZBQAb4qserG37AXEQoSTQuvgDlyFrtJMAjc/mcxPo/qURf3M5Y22wp4fBmDEO/CtSlfE
         Ne6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737452361; x=1738057161;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=CrfiZvgCTOL2ebg6otRJp6bcMYzxQOGHKN3yaMsSmW4=;
        b=oXP53rMz9NibcIco8D919IuqeXS9DJ+1+ojb95pNsS6xsdALqVa1dkwRuqbmy8wiPK
         jf7dpI1W4VZn3ADK7Avsn1JtV4GqYowof+QprRBJaxlCo26uoU1pdRAwpQB0F1hRrq3w
         RdboG2VlJB8vqvx1IHxGkrBjhrAWgXt8upOWc7Yl5080iWMTvP2oQkpKIhMZcRC+dNsA
         odxkfLrbDKjiR9aI4MPLkh/D7ZG12YSo8OWFJtrPF9ZaQ5EhAnsfd3qv1oQiHZvkYHM8
         0p7e9DQmBUew1jIbFTrrJyhNSaMrq07NoOn9RizPS3+ZY9oqO8bPvfZrTONUj30gckLk
         DhWg==
X-Forwarded-Encrypted: i=1; AJvYcCUK7kGDWPkDTZHrMYp/MOEifJ8/+iN6zNV2t8loKWdRzSzty23IUsdufgii+hueru2KnbMccFGe70OYfy0P@vger.kernel.org
X-Gm-Message-State: AOJu0Yz7f3zXrBhyjJqtY6adtyzGnhv+BpbFDyKtgBxyIT0DbJJbozfY
	VAVmcP8sPiC24Z+u7k/TxEOZgW8904zil9n0sVsbHfV6Hb54cWrejaRfKvUifc6LIFLPMfqU/Pu
	duhlvj4YEVgXd3norRQGBjQwReGw=
X-Gm-Gg: ASbGncudelsYgIK8ta5HhaiFx2g8FDler+OGAVCG3kPaGXp81z++yODidYJicf/kdv3
	8rFBnbCXNjvDnWIjOQ1CT4HGpG41N+R4K7pJVXuhspwpg1XWS01ZE/Q==
X-Google-Smtp-Source: AGHT+IHKB5rlIUsN+GbbTUOhDzM8m/i1tpGOa2hpvKwrzFuVl60F+4jusvumDQ07MrKJzmPxs30qCS+xHV5ISgjs7q0=
X-Received: by 2002:a05:6214:226a:b0:6d8:a148:9ac9 with SMTP id
 6a1803df08f44-6e1b220e57dmr237717056d6.30.1737452361275; Tue, 21 Jan 2025
 01:39:21 -0800 (PST)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Yafang Shao <laoar.shao@gmail.com>
Date: Tue, 21 Jan 2025 17:38:45 +0800
X-Gm-Features: AbW1kvY1eOfJ66O_FdzrpFW_RKxjXNVPxnb4D0yp-JjtPbdxEN5DxRVlDr1TdKs
Message-ID: <CALOAHbA9WHPjeZKUcUkwULagQjTMfqAdAg+akqPzbZ7Byc=qrw@mail.gmail.com>
Subject: [BUG] Kernel Crash during replacement of livepatch patching do_exit()
To: Josh Poimboeuf <jpoimboe@kernel.org>, jikos@kernel.org, Miroslav Benes <mbenes@suse.cz>, 
	Petr Mladek <pmladek@suse.com>, Joe Lawrence <joe.lawrence@redhat.com>, 
	live-patching@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hello,

We encountered a panic while upgrading our livepatch, specifically
replacing an old livepatch with a new version on our production
servers.

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

Although the issue was observed on an older 6.1 kernel, I suspect it
persists in the upstream kernel as well. Due to the significant effort
required to deploy the upstream kernel in our production environment,
I have not yet attempted to reproduce the issue with the latest
upstream version.

Crash Analysis:
=============

crash> bt
PID: 783972  TASK: ffff94cd316f0000  CPU: 70  COMMAND: "java"
 #0 [ffffba6f273db9a8] machine_kexec at ffffffff990632ad
 #1 [ffffba6f273dba08] __crash_kexec at ffffffff9915c8af
 #2 [ffffba6f273dbad0] crash_kexec at ffffffff9915db0c
 #3 [ffffba6f273dbae0] oops_end at ffffffff99024bc9
 #4 [ffffba6f273dbaf0] _MODULE_START_livepatch_61_release6 at
ffffffffc0ded7fa [livepatch_61_release6]
 #5 [ffffba6f273dbb80] _MODULE_START_livepatch_61_release6 at
ffffffffc0ded7fa [livepatch_61_release6]
 #6 [ffffba6f273dbbf8] _MODULE_START_livepatch_61_release6 at
ffffffffc0ded7fa [livepatch_61_release6]
 #7 [ffffba6f273dbc80] asm_exc_page_fault at ffffffff99c00bb7
    [exception RIP: _MODULE_START_livepatch_61_release6+14330]
    RIP: ffffffffc0ded7fa  RSP: ffffba6f273dbd30  RFLAGS: 00010282
    RAX: 0000000000000000  RBX: ffff94cd316f0000  RCX: 000000008020000d
    RDX: 000000008020000e  RSI: 000000008020000d  RDI: ffff94cd316f0000
    RBP: ffffba6f273dbd88   R8: ffff94cd316f13f8   R9: 0000000000000001
    R10: 0000000000000000  R11: 0000000000000000  R12: ffffba6f273dbd48
    R13: ffffba6f273dbd48  R14: ffffba6f273db340  R15: ffffba6f273db340
    ORIG_RAX: ffffffffffffffff  CS: 0010  SS: 0018
 #8 [ffffba6f273dbd90] do_group_exit at ffffffff99092395
 #9 [ffffba6f273dbdc0] get_signal at ffffffff990a1c69
#10 [ffffba6f273dbdd0] wake_up_q at ffffffff990ce060
#11 [ffffba6f273dbe48] arch_do_signal_or_restart at ffffffff990209b4
#12 [ffffba6f273dbee0] exit_to_user_mode_prepare at ffffffff9912fdf9
#13 [ffffba6f273dbf20] syscall_exit_to_user_mode at ffffffff99aeb87e
#14 [ffffba6f273dbf38] do_syscall_64 at ffffffff99ae70b8
#15 [ffffba6f273dbf50] entry_SYSCALL_64_after_hwframe at ffffffff99c000dc
    RIP: 00007f967feb5a35  RSP: 00007f96664ee670  RFLAGS: 00000246
    RAX: fffffffffffffe00  RBX: 00007f967808a650  RCX: 00007f967feb5a35
    RDX: 000000000000000f  RSI: 0000000000000080  RDI: 00007f967808a654
    RBP: 00007f96664ee6c0   R8: 00007f967808a600   R9: 0000000000000007
    R10: 0000000000000000  R11: 0000000000000246  R12: 00007f967808a600
    R13: 00007f967808a628  R14: 00007f967f691220  R15: 00007f96664ee750
    ORIG_RAX: 00000000000000ca  CS: 0033  SS: 002b

The crash occurred at the address 0xffffffffc0ded7fa, which is within
the livepatch_61_release6. However, from the kernel log, it's clear
that this module was replaced by livepatch_61_release12. We can verify
this with the crash utility:

crash> dis do_exit
dis: do_exit: duplicate text symbols found:
ffffffff99091700 (T) do_exit
/root/rpmbuild/BUILD/kernel-6.1.52/kernel/exit.c: 806
ffffffffc0e038d0 (t) do_exit [livepatch_61_release12]

crash> dis ffffffff99091700
0xffffffff99091700 <do_exit>:   call   0xffffffffc08b9000
0xffffffff99091705 <do_exit+5>: push   %rbp

Here, do_exit was patched in livepatch_61_release12, with the
trampoline address of the new implementation being 0xffffffffc08b9000.

Next, we checked the klp_ops struct to verify the livepatch operations:

crash> list klp_ops.node -H klp_ops  -s klp_ops -x
...
ffff94f3ab8ec900
struct klp_ops {
  node = {
    next = 0xffff94f3ab8ecc00,
    prev = 0xffff94f3ab8ed500
  },
  func_stack = {
    next = 0xffff94cd4a856238,
    prev = 0xffff94cd4a856238
  },
...

crash> struct -o klp_func.stack_node
struct klp_func {
  [112] struct list_head stack_node;
}

crash> klp_func ffff94cd4a8561c8
struct klp_func {
  old_name = 0xffffffffc0e086c8 "do_exit",
  new_func = 0xffffffffc0e038d0,
  old_sympos = 0,
  old_func = 0xffffffff99091700 <do_exit>,
  kobj = {
    name = 0xffff94f379c519c0 "do_exit,1",
    entry = {
      next = 0xffff94cd4a8561f0,
      prev = 0xffff94cd4a8561f0
    },
    parent = 0xffff94e487064ad8,

The do_exit function from livepatch_61_release6 was successfully
replaced by the updated version in livepatch_61_release12, but the
task causing the crash was still executing the older do_exit() from
livepatch_61_release6.

This was confirmed when we checked the symbol mapping for livepatch_61_release6:

crash> sym -m livepatch_61_release6
ffffffffc0dea000 MODULE START: livepatch_61_release6
ffffffffc0dff000 MODULE END: livepatch_61_release6

We identified that the crash occurred at offset 0x37fa within the old
livepatch module, specifically right after the release_task()
function. This crash took place within the do_exit() function. (Note
that the instruction shown below is decoded from the newly loaded
livepatch_61_release6, so while the address differs, the offset
remains the same.)

0xffffffffc0db07eb <do_exit+1803>:      lea    0xa08(%r15),%r12
0xffffffffc0db07f2 <do_exit+1810>:      mov    %r15,%r14
0xffffffffc0db07f5 <do_exit+1813>:      call   0xffffffff9a08fc00 <release_task>
0xffffffffc0db07fa <do_exit+1818>:      mov    0xa08(%r15),%rax
         <<<<<<<
0xffffffffc0db0801 <do_exit+1825>:      sub    $0xa08,%rax

Interestingly, the crash occurred immediately after returning from the
release_task() function. Four servers crashed out of around 50K, all
after returning from release_task().

This suggests a potential synchronization issue between release_task()
and klp_try_complete_transition(). It is possible that
klp_try_switch_task() failed to detect the task executing
release_task(), or that klp_synchronize_transition() failed to wait
for release_task() to finish.

I suspect we need do something change as follows,

--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -220,6 +220,7 @@ static void delayed_put_task_struct(struct rcu_head *rhp)

        kprobe_flush_task(tsk);
        rethook_flush_task(tsk);
+       klp_flush_task(tsk);
        perf_event_delayed_put(tsk);
        trace_sched_process_free(tsk);
        put_task_struct(tsk);

Any suggestions ?

--
Regards
Yafang

