Return-Path: <live-patching+bounces-1031-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7FC36A18F9B
	for <lists+live-patching@lfdr.de>; Wed, 22 Jan 2025 11:24:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B3337166538
	for <lists+live-patching@lfdr.de>; Wed, 22 Jan 2025 10:24:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 125BA1BD014;
	Wed, 22 Jan 2025 10:24:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Z2rQPBW9"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62795145FE0
	for <live-patching@vger.kernel.org>; Wed, 22 Jan 2025 10:24:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737541447; cv=none; b=KhG3RclugJIXvaR7z8m5qEaqu2HIMcpPx6q8pQ5qeQ5NRPaqfOs4aMcU5nawigaduZg1Yf6GTsEB1tjrIDhSECmN8wnYZWUnoHTcPwGf+iHZq2KRLiEKtvcuMYVFoz4QY+bvafu4Tl09HxRosX8EPd9p9oKw9nE3dYbOUO9FGDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737541447; c=relaxed/simple;
	bh=Qiixjnaltem+rFOPhqiYv8MuEj3GFYEUIL81IS43+SE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QEcT94uP5h8neT83PpJFACk2lEGgb59JMlz5b+XwvnxxOAkHLhHAdZNSUdYrjK2yKN2RibhNovGiUdeaEZRFcIrg5dOpA2yuOIk3NE/A8vmYoZK2jQxv6Mflq6xJDUp/u52PNVb3/CjPQesCJGJG2IoYYbZcOvorwebSNxcuxfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Z2rQPBW9; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-385e1fcb0e1so3576659f8f.2
        for <live-patching@vger.kernel.org>; Wed, 22 Jan 2025 02:24:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1737541443; x=1738146243; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZVjlEtPD+9N0uCcqGe7cWVtl4Cm1sesPGp45JpYzsik=;
        b=Z2rQPBW9P594y/kak/2hdR7IOgfU5yvBujBcEnz7Z815OfPx+3NnfNZ74xRjbRhRru
         jQ6f9ChiHZzdP2ZjBt7egW7RAS0y30VUUtSoeLJe+LvWjDsizhSJeD6jeFr5874v2FCP
         tvsu2siknQ+WoCcJ9Co845i6Q2vflxKvq5oOtneT74LOWyMYcY0OY1tM+Sh1mIu5tgTC
         cBQG5jjy16aVrRi5vk2r2T6OjOhvz+NL19+vsjyFMYpxD1OkzXjLiet5zg8M8QbnVydi
         2z1AtrC7rrueMwpC4JZz/djnrIQbG9B7nEnnGXqvZW9I5uoDYoG4rfPsujS2JQz93O77
         7YgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737541443; x=1738146243;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZVjlEtPD+9N0uCcqGe7cWVtl4Cm1sesPGp45JpYzsik=;
        b=drIxQTSDb6h8Ng9qR6eBh7c7OLdHeBNFY17QLWQZgn02SzzWCW1yZu6ctbWKZNXKbL
         M2RV/IS5yh6F9+4vbIHWpNfSBrW9hsXib5PtCTCFnZi4UTZwgOQoa97Cf6K54BV32bCb
         nGRYL1SHU3zEeRhnyUpqPT5pcfCk8NlrB8kvQigmUreRuSI7isSZBbNNHhkvVmPUw1iF
         8QI9HDmFne6/Tvopt8Qv0Vb7gjTd+ZNKgS53jk6xEosgjiujtLaR+qXzlvsbnJbR/Uwc
         6vHs2oBeD4GgP+JbyzqICUATgKcqlqF/YbmXqM7sHx5JhJEPfQb2W8UfyZOSJwnJOjDT
         Qmsg==
X-Forwarded-Encrypted: i=1; AJvYcCWDiRjSEIWnLYm7q3wRJUqlTwqBkXx5BPhhoGUIwDriIBSaQiLrNNVYqb777GQOOJLjjCLbEAjeQfVg18he@vger.kernel.org
X-Gm-Message-State: AOJu0Ywux6gqDatYGBOvniJYAsLlTEK1qEb1TUFcLtcqS6nr9KponkC5
	0M0RU+TqMk1dKDLsLkVj2nB8KAo9UNoqeGqCXAvED5h4G153wX6UTZlVdRfUt+o=
X-Gm-Gg: ASbGncui4nzEKXBbsypHSPasYTmqqwUHsdxo91Rl15ok7a/T5Pz6EQGo70M5h4Lr47x
	+CKboLQk8Ugd6pqyydNLC3b9wy8cHcrAXklt3FPiHDeWqOnCFPoegiLJhSAN2wXHOH99e97Jv50
	2KY9Tli8vK5kdrH5v61SvGa1VG8dBlDQ76OXBzv+Nqe/3zOYES2s8+Fy0xH9WzYi/UDWhr1zNlY
	K8yPH2U8ZMfGBMyQgrqlumul1OA5ZoxHDPzwcxT/eicGVvJn2CDANY/7iJLu1cuozZ4oX0=
X-Google-Smtp-Source: AGHT+IHhO2FG1Y91Mut7hZOysRVvPGkQJfHhY0wuENZSVXhpYOF/nIb9OSllRnYz2yJKbYrq1Nof7g==
X-Received: by 2002:adf:a1cd:0:b0:386:459e:655d with SMTP id ffacd0b85a97d-38bf5664814mr14436902f8f.20.1737541442581;
        Wed, 22 Jan 2025 02:24:02 -0800 (PST)
Received: from pathway.suse.cz ([176.114.240.50])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38bf322aac3sm16093436f8f.51.2025.01.22.02.24.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jan 2025 02:24:02 -0800 (PST)
Date: Wed, 22 Jan 2025 11:24:00 +0100
From: Petr Mladek <pmladek@suse.com>
To: Yafang Shao <laoar.shao@gmail.com>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>, jikos@kernel.org,
	Miroslav Benes <mbenes@suse.cz>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	live-patching@vger.kernel.org
Subject: Re: [BUG] Kernel Crash during replacement of livepatch patching
 do_exit()
Message-ID: <Z5DHQG4geRsuIflc@pathway.suse.cz>
References: <CALOAHbA9WHPjeZKUcUkwULagQjTMfqAdAg+akqPzbZ7Byc=qrw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALOAHbA9WHPjeZKUcUkwULagQjTMfqAdAg+akqPzbZ7Byc=qrw@mail.gmail.com>

On Tue 2025-01-21 17:38:45, Yafang Shao wrote:
> Hello,
> 
> We encountered a panic while upgrading our livepatch, specifically
> replacing an old livepatch with a new version on our production
> servers.
> 
> [156821.048318] livepatch: enabling patch 'livepatch_61_release12'
> [156821.061580] livepatch: 'livepatch_61_release12': starting patching
> transition
> [156821.122212] livepatch: 'livepatch_61_release12': patching complete
> [156821.175871] kernel tried to execute NX-protected page - exploit
> attempt? (uid: 10524)
> [156821.176011] BUG: unable to handle page fault for address: ffffffffc0ded7fa
> [156821.176121] #PF: supervisor instruction fetch in kernel mode
> [156821.176211] #PF: error_code(0x0011) - permissions violation
> [156821.176302] PGD 986c15067 P4D 986c15067 PUD 986c17067 PMD
> 184f53b067 PTE 800000194c08e163
> [156821.176435] Oops: 0011 [#1] PREEMPT SMP NOPTI
> [156821.176506] CPU: 70 PID: 783972 Comm: java Kdump: loaded Tainted:
> G S      W  O  K    6.1.52-3 #3.pdd
> [156821.176654] Hardware name: Inspur SA5212M5/SA5212M5, BIOS 4.1.20 05/05/2021
> [156821.176766] RIP: 0010:0xffffffffc0ded7fa
> [156821.176841] Code: 0a 00 00 48 89 42 08 48 89 10 4d 89 a6 08 0a 00
> 00 4c 89 f7 4d 89 a6 10 0a 00 00 4d 8d a7 08 0a 00 00 4d 89 fe e8 00
> 00 00 00 <49> 8b 87 08 0a 00 00 48 2d 08 0a 00 00 4d 39 ec 75 aa 48 89
> df e8
> [156821.177138] RSP: 0018:ffffba6f273dbd30 EFLAGS: 00010282
> [156821.177222] RAX: 0000000000000000 RBX: ffff94cd316f0000 RCX:
> 000000008020000d
> [156821.177338] RDX: 000000008020000e RSI: 000000008020000d RDI:
> ffff94cd316f0000
> [156821.177452] RBP: ffffba6f273dbd88 R08: ffff94cd316f13f8 R09:
> 0000000000000001
> [156821.177567] R10: 0000000000000000 R11: 0000000000000000 R12:
> ffffba6f273dbd48
> [156821.177682] R13: ffffba6f273dbd48 R14: ffffba6f273db340 R15:
> ffffba6f273db340
> [156821.177797] FS:  0000000000000000(0000) GS:ffff94e321180000(0000)
> knlGS:0000000000000000
> [156821.177926] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [156821.178019] CR2: ffffffffc0ded7fa CR3: 000000015909c006 CR4:
> 00000000007706e0
> [156821.178133] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
> 0000000000000000
> [156821.178248] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:
> 0000000000000400
> [156821.178363] PKRU: 55555554
> [156821.178407] Call Trace:
> [156821.178449]  <TASK>
> [156821.178492]  ? show_regs.cold+0x1a/0x1f
> [156821.178559]  ? __die_body+0x20/0x70
> [156821.178617]  ? __die+0x2b/0x37
> [156821.178669]  ? page_fault_oops+0x136/0x2b0
> [156821.178734]  ? search_bpf_extables+0x63/0x90
> [156821.178805]  ? search_exception_tables+0x5f/0x70
> [156821.178881]  ? kernelmode_fixup_or_oops+0xa2/0x120
> [156821.178957]  ? __bad_area_nosemaphore+0x176/0x1b0
> [156821.179034]  ? bad_area_nosemaphore+0x16/0x20
> [156821.179105]  ? do_kern_addr_fault+0x77/0x90
> [156821.179175]  ? exc_page_fault+0xc6/0x160
> [156821.179239]  ? asm_exc_page_fault+0x27/0x30
> [156821.179310]  do_group_exit+0x35/0x90
> [156821.179371]  get_signal+0x909/0x950
> [156821.179429]  ? wake_up_q+0x50/0x90
> [156821.179486]  arch_do_signal_or_restart+0x34/0x2a0
> [156821.183207]  exit_to_user_mode_prepare+0x149/0x1b0
> [156821.186963]  syscall_exit_to_user_mode+0x1e/0x50
> [156821.190723]  do_syscall_64+0x48/0x90
> [156821.194500]  entry_SYSCALL_64_after_hwframe+0x64/0xce
> [156821.198195] RIP: 0033:0x7f967feb5a35
> [156821.201769] Code: Unable to access opcode bytes at 0x7f967feb5a0b.
> [156821.205283] RSP: 002b:00007f96664ee670 EFLAGS: 00000246 ORIG_RAX:
> 00000000000000ca
> [156821.208790] RAX: fffffffffffffe00 RBX: 00007f967808a650 RCX:
> 00007f967feb5a35
> [156821.212305] RDX: 000000000000000f RSI: 0000000000000080 RDI:
> 00007f967808a654
> [156821.215785] RBP: 00007f96664ee6c0 R08: 00007f967808a600 R09:
> 0000000000000007
> [156821.219273] R10: 0000000000000000 R11: 0000000000000246 R12:
> 00007f967808a600
> [156821.222727] R13: 00007f967808a628 R14: 00007f967f691220 R15:
> 00007f96664ee750
> [156821.226155]  </TASK>
> [156821.229470] Modules linked in: livepatch_61_release12(OK)
> ebtable_filter ebtables af_packet_diag netlink_diag xt_DSCP xt_owner
> iptable_mangle iptable_raw xt_CT cls_bpf sch_ingress bpf_preload
> binfmt_misc raw_diag unix_diag tcp_diag udp_diag inet_diag
> iptable_filter bpfilter xt_conntrack nf_nat nf_conntrack_netlink
> nfnetlink nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 overlay af_packet
> bonding tls intel_rapl_msr intel_rapl_common intel_uncore_frequency
> intel_uncore_frequency_common isst_if_common skx_edac nfit
> x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel kvm irqbypass
> rapl vfat fat intel_cstate iTCO_wdt xfs intel_uncore pcspkr ses
> enclosure mei_me i2c_i801 input_leds lpc_ich acpi_ipmi ioatdma
> i2c_smbus mei mfd_core dca wmi ipmi_si intel_pch_thermal ipmi_devintf
> ipmi_msghandler acpi_cpufreq acpi_pad acpi_power_meter ip_tables ext4
> mbcache jbd2 sd_mod sg mpt3sas raid_class scsi_transport_sas
> megaraid_sas crct10dif_pclmul crc32_pclmul crc32c_intel
> polyval_clmulni polyval_generic
> [156821.229555]  ghash_clmulni_intel sha512_ssse3 aesni_intel
> crypto_simd cryptd nvme nvme_core t10_pi i40e ptp pps_core ahci
> libahci libata deflate zlib_deflate
> [156821.259012] Unloaded tainted modules:
> livepatch_61_release6(OK):14089 livepatch_61_release12(OK):14088 [last
> unloaded: livepatch_61_release6(OK)]
> [156821.275421] CR2: ffffffffc0ded7fa
> 
> Although the issue was observed on an older 6.1 kernel, I suspect it
> persists in the upstream kernel as well. Due to the significant effort
> required to deploy the upstream kernel in our production environment,
> I have not yet attempted to reproduce the issue with the latest
> upstream version.
> 
> Crash Analysis:
> =============
> 
> crash> bt
> PID: 783972  TASK: ffff94cd316f0000  CPU: 70  COMMAND: "java"
>  #0 [ffffba6f273db9a8] machine_kexec at ffffffff990632ad
>  #1 [ffffba6f273dba08] __crash_kexec at ffffffff9915c8af
>  #2 [ffffba6f273dbad0] crash_kexec at ffffffff9915db0c
>  #3 [ffffba6f273dbae0] oops_end at ffffffff99024bc9
>  #4 [ffffba6f273dbaf0] _MODULE_START_livepatch_61_release6 at
> ffffffffc0ded7fa [livepatch_61_release6]
>  #5 [ffffba6f273dbb80] _MODULE_START_livepatch_61_release6 at
> ffffffffc0ded7fa [livepatch_61_release6]
>  #6 [ffffba6f273dbbf8] _MODULE_START_livepatch_61_release6 at
> ffffffffc0ded7fa [livepatch_61_release6]
>  #7 [ffffba6f273dbc80] asm_exc_page_fault at ffffffff99c00bb7
>     [exception RIP: _MODULE_START_livepatch_61_release6+14330]
>     RIP: ffffffffc0ded7fa  RSP: ffffba6f273dbd30  RFLAGS: 00010282
>     RAX: 0000000000000000  RBX: ffff94cd316f0000  RCX: 000000008020000d
>     RDX: 000000008020000e  RSI: 000000008020000d  RDI: ffff94cd316f0000
>     RBP: ffffba6f273dbd88   R8: ffff94cd316f13f8   R9: 0000000000000001
>     R10: 0000000000000000  R11: 0000000000000000  R12: ffffba6f273dbd48
>     R13: ffffba6f273dbd48  R14: ffffba6f273db340  R15: ffffba6f273db340
>     ORIG_RAX: ffffffffffffffff  CS: 0010  SS: 0018
>  #8 [ffffba6f273dbd90] do_group_exit at ffffffff99092395
>  #9 [ffffba6f273dbdc0] get_signal at ffffffff990a1c69
> #10 [ffffba6f273dbdd0] wake_up_q at ffffffff990ce060
> #11 [ffffba6f273dbe48] arch_do_signal_or_restart at ffffffff990209b4
> #12 [ffffba6f273dbee0] exit_to_user_mode_prepare at ffffffff9912fdf9
> #13 [ffffba6f273dbf20] syscall_exit_to_user_mode at ffffffff99aeb87e
> #14 [ffffba6f273dbf38] do_syscall_64 at ffffffff99ae70b8
> #15 [ffffba6f273dbf50] entry_SYSCALL_64_after_hwframe at ffffffff99c000dc
>     RIP: 00007f967feb5a35  RSP: 00007f96664ee670  RFLAGS: 00000246
>     RAX: fffffffffffffe00  RBX: 00007f967808a650  RCX: 00007f967feb5a35
>     RDX: 000000000000000f  RSI: 0000000000000080  RDI: 00007f967808a654
>     RBP: 00007f96664ee6c0   R8: 00007f967808a600   R9: 0000000000000007
>     R10: 0000000000000000  R11: 0000000000000246  R12: 00007f967808a600
>     R13: 00007f967808a628  R14: 00007f967f691220  R15: 00007f96664ee750
>     ORIG_RAX: 00000000000000ca  CS: 0033  SS: 002b
> 
> The crash occurred at the address 0xffffffffc0ded7fa, which is within
> the livepatch_61_release6. However, from the kernel log, it's clear
> that this module was replaced by livepatch_61_release12. We can verify
> this with the crash utility:
> 
> crash> dis do_exit
> dis: do_exit: duplicate text symbols found:
> ffffffff99091700 (T) do_exit
> /root/rpmbuild/BUILD/kernel-6.1.52/kernel/exit.c: 806
> ffffffffc0e038d0 (t) do_exit [livepatch_61_release12]
> 
> crash> dis ffffffff99091700
> 0xffffffff99091700 <do_exit>:   call   0xffffffffc08b9000
> 0xffffffff99091705 <do_exit+5>: push   %rbp
> 
> Here, do_exit was patched in livepatch_61_release12, with the
> trampoline address of the new implementation being 0xffffffffc08b9000.
> 
> Next, we checked the klp_ops struct to verify the livepatch operations:
> 
> crash> list klp_ops.node -H klp_ops  -s klp_ops -x
> ...
> ffff94f3ab8ec900
> struct klp_ops {
>   node = {
>     next = 0xffff94f3ab8ecc00,
>     prev = 0xffff94f3ab8ed500
>   },
>   func_stack = {
>     next = 0xffff94cd4a856238,
>     prev = 0xffff94cd4a856238
>   },
> ...
> 
> crash> struct -o klp_func.stack_node
> struct klp_func {
>   [112] struct list_head stack_node;
> }
> 
> crash> klp_func ffff94cd4a8561c8
> struct klp_func {
>   old_name = 0xffffffffc0e086c8 "do_exit",
>   new_func = 0xffffffffc0e038d0,
>   old_sympos = 0,
>   old_func = 0xffffffff99091700 <do_exit>,
>   kobj = {
>     name = 0xffff94f379c519c0 "do_exit,1",
>     entry = {
>       next = 0xffff94cd4a8561f0,
>       prev = 0xffff94cd4a8561f0
>     },
>     parent = 0xffff94e487064ad8,
> 
> The do_exit function from livepatch_61_release6 was successfully
> replaced by the updated version in livepatch_61_release12, but the
> task causing the crash was still executing the older do_exit() from
> livepatch_61_release6.
> 
> This was confirmed when we checked the symbol mapping for livepatch_61_release6:
> 
> crash> sym -m livepatch_61_release6
> ffffffffc0dea000 MODULE START: livepatch_61_release6
> ffffffffc0dff000 MODULE END: livepatch_61_release6
> 
> We identified that the crash occurred at offset 0x37fa within the old
> livepatch module, specifically right after the release_task()
> function. This crash took place within the do_exit() function. (Note
> that the instruction shown below is decoded from the newly loaded
> livepatch_61_release6, so while the address differs, the offset
> remains the same.)
> 
> 0xffffffffc0db07eb <do_exit+1803>:      lea    0xa08(%r15),%r12
> 0xffffffffc0db07f2 <do_exit+1810>:      mov    %r15,%r14
> 0xffffffffc0db07f5 <do_exit+1813>:      call   0xffffffff9a08fc00 <release_task>
> 0xffffffffc0db07fa <do_exit+1818>:      mov    0xa08(%r15),%rax
>          <<<<<<<
> 0xffffffffc0db0801 <do_exit+1825>:      sub    $0xa08,%rax
> 
> Interestingly, the crash occurred immediately after returning from the
> release_task() function. Four servers crashed out of around 50K, all
> after returning from release_task().

The release_task() removes the process from the task list. It happens in:

  + release_task()
    + __exit_signal()
      + __unhash_process()

As a result, the task is no longer listed by for_each_process_thread()
loop in klp_complete_transition(). It becomes invisible for
the livepatching core and can't block the transition.

> This suggests a potential synchronization issue between release_task()
> and klp_try_complete_transition(). It is possible that
> klp_try_switch_task() failed to detect the task executing
> release_task(), or that klp_synchronize_transition() failed to wait
> for release_task() to finish.
>
> I suspect we need do something change as follows,
> 
> --- a/kernel/exit.c
> +++ b/kernel/exit.c
> @@ -220,6 +220,7 @@ static void delayed_put_task_struct(struct rcu_head *rhp)
> 
>         kprobe_flush_task(tsk);
>         rethook_flush_task(tsk);
> +       klp_flush_task(tsk);

What exactly should klp_flush_task() do, please?

>         perf_event_delayed_put(tsk);
>         trace_sched_process_free(tsk);
>         put_task_struct(tsk);
> 
> Any suggestions ?

I am playing with some ideas how to block the transition until
delayed_put_task_struct() is called for all pending processes.
But it is not trivial.

Anyway, livepatching of do_exit() is not safe at the moment.
I think that the same problem is with fork.

In principle, it might be dangerous to livepatch functions which
might add/remove tasks to/from the task list used by
for_each_process_thread().

I am not sure at the moment how complicated and safe would be
to make this safe.

Best Regards,
Petr

PS: It was great analyze. The information from the crash dump
    were really helpful.
    

