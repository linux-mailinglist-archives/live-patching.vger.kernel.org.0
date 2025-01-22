Return-Path: <live-patching+bounces-1036-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 06B56A1933C
	for <lists+live-patching@lfdr.de>; Wed, 22 Jan 2025 15:02:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 10FC9166775
	for <lists+live-patching@lfdr.de>; Wed, 22 Jan 2025 14:02:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 93A2F2116E4;
	Wed, 22 Jan 2025 14:02:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="c6+n3i81"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-qv1-f49.google.com (mail-qv1-f49.google.com [209.85.219.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 584D6187553
	for <live-patching@vger.kernel.org>; Wed, 22 Jan 2025 14:02:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737554533; cv=none; b=pMZtowYAZctstKt5nyqFk9wLqaR5RXDMP8Jlo7ijqYv66VSF9koiqqwJihZBCE3sjZEQXdkn8iWfAt48raoB1+6/F8ThZ8MgKVbXJg5Q0fpfstmocfM2Xnzzil3Annq7zjIhGZ0f8QmZiNGIC4SVfonJExMuUCFCRYdqWRaD/F8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737554533; c=relaxed/simple;
	bh=JCLPhkyVinS22KHfaDMDzTFXd+xvooc1qhcFceDNTJs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FKnJsJy+RZGZQuTspndZxqlBH9jCqRPEDzvSmZlHOzSfEsMbMZFpBJOxumxD2Zs4JRzMOi+P50YOtYdK/1rwEd+8JSI/NhPeMQZGH/nM68FxutSPu/ptfHZSrXNGuyPM2lcTR9mTpZPx1eKoeOoHxi1X+Tv4+oUy/82KgOa611M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=c6+n3i81; arc=none smtp.client-ip=209.85.219.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qv1-f49.google.com with SMTP id 6a1803df08f44-6dd01781b56so83579266d6.0
        for <live-patching@vger.kernel.org>; Wed, 22 Jan 2025 06:02:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1737554529; x=1738159329; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dgm+Yul8jWnKuUy8vRC6Wh+2Yu31v1/9LEaHbhwYbi4=;
        b=c6+n3i81lvZKwAaCf3/8yB3qGLe07bvZ94un/wBb8IWp0HY1PKkXl8FtMegow9wyyV
         apWIxgaB2z2KrE+OENkToKuGrGgBZfAM+yioOq452fGZnc9MpbaZwN+D2ZBI06oUB65T
         TESw7HdnMpsW8BCWe913XFlVGfp1Tw8uJkoUtmUh79/Mnf7yb/hGewmQMftoVJ/Gor3l
         T6jnYpOUC15QBOcGr31g/OyihifEiyYbujxseFhtOxhY95CCARLw8fjlW+3zmfHGL+1C
         VIc+WHEmmEa7ERWb2S67lNQNYBzW8LL33un+aRaRKqbNdzWxELy13OWOWqdfw9aMo6kQ
         sjHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737554529; x=1738159329;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dgm+Yul8jWnKuUy8vRC6Wh+2Yu31v1/9LEaHbhwYbi4=;
        b=LfSGvYnufEGT34Rxj9LKaoJgJ3v4I7cecvesvqZADkWQs9JnzexJG+vHw9zzKALRnX
         1XrhFuIsE+UCYAA+hwN79FiSc40vIBBo82pwLMeA7qUVi+yPXJoiy8GoVoi44cJP1Ytl
         767e+W3/3sy6gKz7HBF9rFPWZsdQSRt3AQJgnrYG0xHPSd+ghSR46qLmycMB55kkoRFR
         i/hI/Z7SOkSKgrUZcHzoeHPZx5TbYXlxVImCQkpzmryRC+DzDJn+g3AUpQIBc4Y8JEP9
         XA0cx6sHb1t1zRpN+Z6+UXFj1kApyUwQsWFOn4bC/2lH1Z69rg4roy590oVWhebZyxwZ
         frkQ==
X-Forwarded-Encrypted: i=1; AJvYcCUWgWSb8GC5W7gNUG1TuHVvpjHLT2KXg6xbEb+/GZpH17jfPbE23QO5y3qkYcOfjCy2NmmtU8d2F3C1uz9X@vger.kernel.org
X-Gm-Message-State: AOJu0YwwOcXAQ1SarZlUgiqQAdaq9P+ZEucE/roL8H6ABZGaPH0C/2Gk
	5DmPgdvBQRyDSogPtd7znQCBqddfhQppVubUd+7/wltdjldj7kA7Pzuy8WvRrhViiqFmGU5addx
	GdJcIPlWlEZuCuLD2R04DipyJivY=
X-Gm-Gg: ASbGnctQZpFV3+CXU8EfLm/hbxCofRa4xUGATv127IpHyqywyj3+QRGc20QGdpvM6S0
	yUk+sQ7CwfvbCKBsLehwMxzctG8uejAM94TxMRz2E+SFh/TbkooUK9w==
X-Google-Smtp-Source: AGHT+IH7tspC3AYjW/LvarIfpaDwu7qW/gDZ5wqBGsEQlCuxs7iIAjgOa2Y139naYxTP+SBw5BsHDbzziusG4Leur6o=
X-Received: by 2002:a05:6214:e47:b0:6d8:d79c:1cbd with SMTP id
 6a1803df08f44-6e1b21761e3mr330636886d6.15.1737554528370; Wed, 22 Jan 2025
 06:02:08 -0800 (PST)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CALOAHbA9WHPjeZKUcUkwULagQjTMfqAdAg+akqPzbZ7Byc=qrw@mail.gmail.com>
 <CALOAHbAi61nrAqL9OLaAsRa_WoDYUrC96rYTGWZh1b6-Lotupg@mail.gmail.com>
 <Z5DaUvNAMUP0Euoy@pathway.suse.cz> <CALOAHbBC2TSoy4fGcCe88pR7Nc1yyN+HYbXJA3O8UwHoRsLtSg@mail.gmail.com>
In-Reply-To: <CALOAHbBC2TSoy4fGcCe88pR7Nc1yyN+HYbXJA3O8UwHoRsLtSg@mail.gmail.com>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Wed, 22 Jan 2025 22:01:31 +0800
X-Gm-Features: AWEUYZl5K2nvm5CVq0tA3CKkeHlXJnQ0Es_6HU71PhilG0IfM6XgZy40VeNKn2c
Message-ID: <CALOAHbAr8jPgeseW7zPB9mk7tfxN3HDUqFSA__oOvEtobX4-5A@mail.gmail.com>
Subject: Re: [BUG] Kernel Crash during replacement of livepatch patching do_exit()
To: Petr Mladek <pmladek@suse.com>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>, jikos@kernel.org, Miroslav Benes <mbenes@suse.cz>, 
	Joe Lawrence <joe.lawrence@redhat.com>, live-patching@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 22, 2025 at 9:30=E2=80=AFPM Yafang Shao <laoar.shao@gmail.com> =
wrote:
>
> On Wed, Jan 22, 2025 at 7:45=E2=80=AFPM Petr Mladek <pmladek@suse.com> wr=
ote:
> >
> > On Wed 2025-01-22 14:36:55, Yafang Shao wrote:
> > > On Tue, Jan 21, 2025 at 5:38=E2=80=AFPM Yafang Shao <laoar.shao@gmail=
.com> wrote:
> > > >
> > > > Hello,
> > > >
> > > > We encountered a panic while upgrading our livepatch, specifically
> > > > replacing an old livepatch with a new version on our production
> > > > servers.
> > > >
> > > > [156821.048318] livepatch: enabling patch 'livepatch_61_release12'
> > > > [156821.061580] livepatch: 'livepatch_61_release12': starting patch=
ing
> > > > transition
> > > > [156821.122212] livepatch: 'livepatch_61_release12': patching compl=
ete
> > > > [156821.175871] kernel tried to execute NX-protected page - exploit
> > > > attempt? (uid: 10524)
> > > > [156821.176011] BUG: unable to handle page fault for address: fffff=
fffc0ded7fa
> > > > [156821.176121] #PF: supervisor instruction fetch in kernel mode
> > > > [156821.176211] #PF: error_code(0x0011) - permissions violation
> > > > [156821.176302] PGD 986c15067 P4D 986c15067 PUD 986c17067 PMD
> > > > 184f53b067 PTE 800000194c08e163
> > > > [156821.176435] Oops: 0011 [#1] PREEMPT SMP NOPTI
> > > > [156821.176506] CPU: 70 PID: 783972 Comm: java Kdump: loaded Tainte=
d:
> > > > G S      W  O  K    6.1.52-3 #3.pdd
> > > > [156821.176654] Hardware name: Inspur SA5212M5/SA5212M5, BIOS 4.1.2=
0 05/05/2021
> > > > [156821.176766] RIP: 0010:0xffffffffc0ded7fa
> > > > [156821.176841] Code: 0a 00 00 48 89 42 08 48 89 10 4d 89 a6 08 0a =
00
> > > > 00 4c 89 f7 4d 89 a6 10 0a 00 00 4d 8d a7 08 0a 00 00 4d 89 fe e8 0=
0
> > > > 00 00 00 <49> 8b 87 08 0a 00 00 48 2d 08 0a 00 00 4d 39 ec 75 aa 48=
 89
> > > > df e8
> > > > [156821.177138] RSP: 0018:ffffba6f273dbd30 EFLAGS: 00010282
> > > > [156821.177222] RAX: 0000000000000000 RBX: ffff94cd316f0000 RCX:
> > > > 000000008020000d
> > > > [156821.177338] RDX: 000000008020000e RSI: 000000008020000d RDI:
> > > > ffff94cd316f0000
> > > > [156821.177452] RBP: ffffba6f273dbd88 R08: ffff94cd316f13f8 R09:
> > > > 0000000000000001
> > > > [156821.177567] R10: 0000000000000000 R11: 0000000000000000 R12:
> > > > ffffba6f273dbd48
> > > > [156821.177682] R13: ffffba6f273dbd48 R14: ffffba6f273db340 R15:
> > > > ffffba6f273db340
> > > > [156821.177797] FS:  0000000000000000(0000) GS:ffff94e321180000(000=
0)
> > > > knlGS:0000000000000000
> > > > [156821.177926] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > > > [156821.178019] CR2: ffffffffc0ded7fa CR3: 000000015909c006 CR4:
> > > > 00000000007706e0
> > > > [156821.178133] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
> > > > 0000000000000000
> > > > [156821.178248] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:
> > > > 0000000000000400
> > > > [156821.178363] PKRU: 55555554
> > > > [156821.178407] Call Trace:
> > > > [156821.178449]  <TASK>
> > > > [156821.178492]  ? show_regs.cold+0x1a/0x1f
> > > > [156821.178559]  ? __die_body+0x20/0x70
> > > > [156821.178617]  ? __die+0x2b/0x37
> > > > [156821.178669]  ? page_fault_oops+0x136/0x2b0
> > > > [156821.178734]  ? search_bpf_extables+0x63/0x90
> > > > [156821.178805]  ? search_exception_tables+0x5f/0x70
> > > > [156821.178881]  ? kernelmode_fixup_or_oops+0xa2/0x120
> > > > [156821.178957]  ? __bad_area_nosemaphore+0x176/0x1b0
> > > > [156821.179034]  ? bad_area_nosemaphore+0x16/0x20
> > > > [156821.179105]  ? do_kern_addr_fault+0x77/0x90
> > > > [156821.179175]  ? exc_page_fault+0xc6/0x160
> > > > [156821.179239]  ? asm_exc_page_fault+0x27/0x30
> > > > [156821.179310]  do_group_exit+0x35/0x90
> > > > [156821.179371]  get_signal+0x909/0x950
> > > > [156821.179429]  ? wake_up_q+0x50/0x90
> > > > [156821.179486]  arch_do_signal_or_restart+0x34/0x2a0
> > > > [156821.183207]  exit_to_user_mode_prepare+0x149/0x1b0
> > > > [156821.186963]  syscall_exit_to_user_mode+0x1e/0x50
> > > > [156821.190723]  do_syscall_64+0x48/0x90
> > > > [156821.194500]  entry_SYSCALL_64_after_hwframe+0x64/0xce
> > > > [156821.198195] RIP: 0033:0x7f967feb5a35
> > > > [156821.201769] Code: Unable to access opcode bytes at 0x7f967feb5a=
0b.
> > > > [156821.205283] RSP: 002b:00007f96664ee670 EFLAGS: 00000246 ORIG_RA=
X:
> > > > 00000000000000ca
> > > > [156821.208790] RAX: fffffffffffffe00 RBX: 00007f967808a650 RCX:
> > > > 00007f967feb5a35
> > > > [156821.212305] RDX: 000000000000000f RSI: 0000000000000080 RDI:
> > > > 00007f967808a654
> > > > [156821.215785] RBP: 00007f96664ee6c0 R08: 00007f967808a600 R09:
> > > > 0000000000000007
> > > > [156821.219273] R10: 0000000000000000 R11: 0000000000000246 R12:
> > > > 00007f967808a600
> > > > [156821.222727] R13: 00007f967808a628 R14: 00007f967f691220 R15:
> > > > 00007f96664ee750
> > > > [156821.226155]  </TASK>
> > > > [156821.229470] Modules linked in: livepatch_61_release12(OK)
> > > > ebtable_filter ebtables af_packet_diag netlink_diag xt_DSCP xt_owne=
r
> > > > iptable_mangle iptable_raw xt_CT cls_bpf sch_ingress bpf_preload
> > > > binfmt_misc raw_diag unix_diag tcp_diag udp_diag inet_diag
> > > > iptable_filter bpfilter xt_conntrack nf_nat nf_conntrack_netlink
> > > > nfnetlink nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 overlay af_pac=
ket
> > > > bonding tls intel_rapl_msr intel_rapl_common intel_uncore_frequency
> > > > intel_uncore_frequency_common isst_if_common skx_edac nfit
> > > > x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel kvm irqbyp=
ass
> > > > rapl vfat fat intel_cstate iTCO_wdt xfs intel_uncore pcspkr ses
> > > > enclosure mei_me i2c_i801 input_leds lpc_ich acpi_ipmi ioatdma
> > > > i2c_smbus mei mfd_core dca wmi ipmi_si intel_pch_thermal ipmi_devin=
tf
> > > > ipmi_msghandler acpi_cpufreq acpi_pad acpi_power_meter ip_tables ex=
t4
> > > > mbcache jbd2 sd_mod sg mpt3sas raid_class scsi_transport_sas
> > > > megaraid_sas crct10dif_pclmul crc32_pclmul crc32c_intel
> > > > polyval_clmulni polyval_generic
> > > > [156821.229555]  ghash_clmulni_intel sha512_ssse3 aesni_intel
> > > > crypto_simd cryptd nvme nvme_core t10_pi i40e ptp pps_core ahci
> > > > libahci libata deflate zlib_deflate
> > > > [156821.259012] Unloaded tainted modules:
> > > > livepatch_61_release6(OK):14089 livepatch_61_release12(OK):14088 [l=
ast
> > > > unloaded: livepatch_61_release6(OK)]
> > > > [156821.275421] CR2: ffffffffc0ded7fa
> > > >
> > > > Although the issue was observed on an older 6.1 kernel, I suspect i=
t
> > > > persists in the upstream kernel as well. Due to the significant eff=
ort
> > > > required to deploy the upstream kernel in our production environmen=
t,
> > > > I have not yet attempted to reproduce the issue with the latest
> > > > upstream version.
> > > >
> > > > Crash Analysis:
> > > > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > > >
> > > > crash> bt
> > > > PID: 783972  TASK: ffff94cd316f0000  CPU: 70  COMMAND: "java"
> > > >  #0 [ffffba6f273db9a8] machine_kexec at ffffffff990632ad
> > > >  #1 [ffffba6f273dba08] __crash_kexec at ffffffff9915c8af
> > > >  #2 [ffffba6f273dbad0] crash_kexec at ffffffff9915db0c
> > > >  #3 [ffffba6f273dbae0] oops_end at ffffffff99024bc9
> > > >  #4 [ffffba6f273dbaf0] _MODULE_START_livepatch_61_release6 at
> > > > ffffffffc0ded7fa [livepatch_61_release6]
> > > >  #5 [ffffba6f273dbb80] _MODULE_START_livepatch_61_release6 at
> > > > ffffffffc0ded7fa [livepatch_61_release6]
> > > >  #6 [ffffba6f273dbbf8] _MODULE_START_livepatch_61_release6 at
> > > > ffffffffc0ded7fa [livepatch_61_release6]
> > > >  #7 [ffffba6f273dbc80] asm_exc_page_fault at ffffffff99c00bb7
> > > >     [exception RIP: _MODULE_START_livepatch_61_release6+14330]
> > > >     RIP: ffffffffc0ded7fa  RSP: ffffba6f273dbd30  RFLAGS: 00010282
> > > >     RAX: 0000000000000000  RBX: ffff94cd316f0000  RCX: 000000008020=
000d
> > > >     RDX: 000000008020000e  RSI: 000000008020000d  RDI: ffff94cd316f=
0000
> > > >     RBP: ffffba6f273dbd88   R8: ffff94cd316f13f8   R9: 000000000000=
0001
> > > >     R10: 0000000000000000  R11: 0000000000000000  R12: ffffba6f273d=
bd48
> > > >     R13: ffffba6f273dbd48  R14: ffffba6f273db340  R15: ffffba6f273d=
b340
> > > >     ORIG_RAX: ffffffffffffffff  CS: 0010  SS: 0018
> > > >  #8 [ffffba6f273dbd90] do_group_exit at ffffffff99092395
> > > >  #9 [ffffba6f273dbdc0] get_signal at ffffffff990a1c69
> > > > #10 [ffffba6f273dbdd0] wake_up_q at ffffffff990ce060
> > > > #11 [ffffba6f273dbe48] arch_do_signal_or_restart at ffffffff990209b=
4
> > > > #12 [ffffba6f273dbee0] exit_to_user_mode_prepare at ffffffff9912fdf=
9
> > > > #13 [ffffba6f273dbf20] syscall_exit_to_user_mode at ffffffff99aeb87=
e
> > > > #14 [ffffba6f273dbf38] do_syscall_64 at ffffffff99ae70b8
> > > > #15 [ffffba6f273dbf50] entry_SYSCALL_64_after_hwframe at ffffffff99=
c000dc
> > > >     RIP: 00007f967feb5a35  RSP: 00007f96664ee670  RFLAGS: 00000246
> > > >     RAX: fffffffffffffe00  RBX: 00007f967808a650  RCX: 00007f967feb=
5a35
> > > >     RDX: 000000000000000f  RSI: 0000000000000080  RDI: 00007f967808=
a654
> > > >     RBP: 00007f96664ee6c0   R8: 00007f967808a600   R9: 000000000000=
0007
> > > >     R10: 0000000000000000  R11: 0000000000000246  R12: 00007f967808=
a600
> > > >     R13: 00007f967808a628  R14: 00007f967f691220  R15: 00007f96664e=
e750
> > > >     ORIG_RAX: 00000000000000ca  CS: 0033  SS: 002b
> > > >
> > > > The crash occurred at the address 0xffffffffc0ded7fa, which is with=
in
> > > > the livepatch_61_release6. However, from the kernel log, it's clear
> > > > that this module was replaced by livepatch_61_release12. We can ver=
ify
> > > > this with the crash utility:
> > > >
> > > > crash> dis do_exit
> > > > dis: do_exit: duplicate text symbols found:
> > > > ffffffff99091700 (T) do_exit
> > > > /root/rpmbuild/BUILD/kernel-6.1.52/kernel/exit.c: 806
> > > > ffffffffc0e038d0 (t) do_exit [livepatch_61_release12]
> > > >
> > > > crash> dis ffffffff99091700
> > > > 0xffffffff99091700 <do_exit>:   call   0xffffffffc08b9000
> > > > 0xffffffff99091705 <do_exit+5>: push   %rbp
> > > >
> > > > Here, do_exit was patched in livepatch_61_release12, with the
> > > > trampoline address of the new implementation being 0xffffffffc08b90=
00.
> > > >
> > > > Next, we checked the klp_ops struct to verify the livepatch operati=
ons:
> > > >
> > > > crash> list klp_ops.node -H klp_ops  -s klp_ops -x
> > > > ...
> > > > ffff94f3ab8ec900
> > > > struct klp_ops {
> > > >   node =3D {
> > > >     next =3D 0xffff94f3ab8ecc00,
> > > >     prev =3D 0xffff94f3ab8ed500
> > > >   },
> > > >   func_stack =3D {
> > > >     next =3D 0xffff94cd4a856238,
> > > >     prev =3D 0xffff94cd4a856238
> > > >   },
> > > > ...
> > > >
> > > > crash> struct -o klp_func.stack_node
> > > > struct klp_func {
> > > >   [112] struct list_head stack_node;
> > > > }
> > > >
> > > > crash> klp_func ffff94cd4a8561c8
> > > > struct klp_func {
> > > >   old_name =3D 0xffffffffc0e086c8 "do_exit",
> > > >   new_func =3D 0xffffffffc0e038d0,
> > > >   old_sympos =3D 0,
> > > >   old_func =3D 0xffffffff99091700 <do_exit>,
> > > >   kobj =3D {
> > > >     name =3D 0xffff94f379c519c0 "do_exit,1",
> > > >     entry =3D {
> > > >       next =3D 0xffff94cd4a8561f0,
> > > >       prev =3D 0xffff94cd4a8561f0
> > > >     },
> > > >     parent =3D 0xffff94e487064ad8,
> > > >
> > > > The do_exit function from livepatch_61_release6 was successfully
> > > > replaced by the updated version in livepatch_61_release12, but the
> > > > task causing the crash was still executing the older do_exit() from
> > > > livepatch_61_release6.
> > > >
> > > > This was confirmed when we checked the symbol mapping for livepatch=
_61_release6:
> > > >
> > > > crash> sym -m livepatch_61_release6
> > > > ffffffffc0dea000 MODULE START: livepatch_61_release6
> > > > ffffffffc0dff000 MODULE END: livepatch_61_release6
> > > >
> > > > We identified that the crash occurred at offset 0x37fa within the o=
ld
> > > > livepatch module, specifically right after the release_task()
> > > > function. This crash took place within the do_exit() function. (Not=
e
> > > > that the instruction shown below is decoded from the newly loaded
> > > > livepatch_61_release6, so while the address differs, the offset
> > > > remains the same.)
> > > >
> > > > 0xffffffffc0db07eb <do_exit+1803>:      lea    0xa08(%r15),%r12
> > > > 0xffffffffc0db07f2 <do_exit+1810>:      mov    %r15,%r14
> > > > 0xffffffffc0db07f5 <do_exit+1813>:      call   0xffffffff9a08fc00 <=
release_task>
> > > > 0xffffffffc0db07fa <do_exit+1818>:      mov    0xa08(%r15),%rax
> > > >          <<<<<<<
> > > > 0xffffffffc0db0801 <do_exit+1825>:      sub    $0xa08,%rax
> > > >
> > > > Interestingly, the crash occurred immediately after returning from =
the
> > > > release_task() function. Four servers crashed out of around 50K, al=
l
> > > > after returning from release_task().
> > > >
> > > > This suggests a potential synchronization issue between release_tas=
k()
> > > > and klp_try_complete_transition(). It is possible that
> > > > klp_try_switch_task() failed to detect the task executing
> > > > release_task(), or that klp_synchronize_transition() failed to wait
> > > > for release_task() to finish.
> > > >
> > > > I suspect we need do something change as follows,
> > > >
> > > > --- a/kernel/exit.c
> > > > +++ b/kernel/exit.c
> > > > @@ -220,6 +220,7 @@ static void delayed_put_task_struct(struct rcu_=
head *rhp)
> > > >
> > > >         kprobe_flush_task(tsk);
> > > >         rethook_flush_task(tsk);
> > > > +       klp_flush_task(tsk);
> > > >         perf_event_delayed_put(tsk);
> > > >         trace_sched_process_free(tsk);
> > > >         put_task_struct(tsk);
> > > >
> > > > Any suggestions ?
> > >
> > > Hello,
> > >
> > > After further analysis, my best guess is that the task stack is being
> > > freed in release_task() while klp_try_switch_task() is still
> > > attempting to access it. It seems we should consider calling
> > > try_get_task_stack() in klp_check_stack() to address this.
> >
> > I do not agree here.
> >
> > My understanding is that the system crashed when it was running
> > the obsolete livepatch_61_release6 code. Why do you think that
> > it was in klp_try_switch_task()?
>
> I suspect that klp_try_switch_task() is misinterpreting the task's
> stack when the task is in release_task() or immediately after it. All
> crashes occurred right after executing release_task(), which doesn't
> seem like a coincidence.
>
> >
> > The ordering of messages is:
> >
> >  [156821.122212] livepatch: 'livepatch_61_release12': patching complete
> >  [156821.175871] kernel tried to execute NX-protected page - exploit
> >  attempt? (uid: 10524)
> >  [156821.176011] BUG: unable to handle page fault for address: ffffffff=
c0ded7fa
> >
> > So that the livepatch transition has completed before the crash.
> > I can't see which process or CPU would be running
> > klp_try_switch_task() at this point.
>
> I agree with you that klp_try_switch_task() is not currently running.
> As I mentioned earlier, it appears that klp_try_switch_task() simply
> missed this task.
>
> >
> > My theory is that the transition has finished and some other process
> > started removing the older livepatch module. I guess that the memory
> > with the livepatch_61_release6 code has been freed on another CPU.
> >
> > It would cause a crash of a process still running the freed do_exit()
> > function. The process would not block the transition after it was
> > removed from the task list in the middle of do_exit().
> >
> > Maybe, you could confirm this in the existing crash dump.
>
> That's correct, I can confirm this. Below are the details:
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
>
> crash> task_struct.tgid ffff94cd316f0000
>   tgid =3D 783848,
>
> crash> task_struct.tasks -o init_task
> struct task_struct {
>   [ffffffff9ac1b310] struct list_head tasks;
> }
>
> crash> list task_struct.tasks -H ffffffff9ac1b310 -s task_struct.tgid
> | grep 783848
>   tgid =3D 783848,
>
> The thread group leader remains on the task list, but the thread has
> already been removed from the thread_head list.
>
> crash> task 783848
> PID: 783848  TASK: ffff94cd603eb000  CPU: 18  COMMAND: "java"
> struct task_struct {
>   thread_info =3D {
>     flags =3D 16388,
>
> crash> task_struct.signal ffff94cd603eb000
>   signal =3D 0xffff94cc89d11b00,
>
> crash> signal_struct.thread_head -o 0xffff94cc89d11b00
> struct signal_struct {
>   [ffff94cc89d11b10] struct list_head thread_head;
> }
>
> crash> list task_struct.thread_node -H ffff94cc89d11b10 -s task_struct.pi=
d
> ffff94cd603eb000
>   pid =3D 783848,
> ffff94ccd8343000
>   pid =3D 783879,
>
> crash> signal_struct.nr_threads,thread_head 0xffff94cc89d11b00
>   nr_threads =3D 2,
>   thread_head =3D {
>     next =3D 0xffff94cd603eba70,
>     prev =3D 0xffff94ccd8343a70
>   },
>
> crash> ps -g 783848
> PID: 783848  TASK: ffff94cd603eb000  CPU: 18  COMMAND: "java"
>   PID: 783879  TASK: ffff94ccd8343000  CPU: 81  COMMAND: "java"
>   PID: 783972  TASK: ffff94cd316f0000  CPU: 70  COMMAND: "java"
>   PID: 784023  TASK: ffff94d644b48000  CPU: 24  COMMAND: "java"
>   PID: 784025  TASK: ffff94dd30250000  CPU: 65  COMMAND: "java"
>   PID: 785242  TASK: ffff94ccb5963000  CPU: 48  COMMAND: "java"
>   PID: 785412  TASK: ffff94cd3eaf8000  CPU: 92  COMMAND: "java"
>   PID: 785415  TASK: ffff94cd6606b000  CPU: 23  COMMAND: "java"
>   PID: 785957  TASK: ffff94dfea4e3000  CPU: 16  COMMAND: "java"
>   PID: 787125  TASK: ffff94e70547b000  CPU: 27  COMMAND: "java"
>   PID: 787445  TASK: ffff94e49a2bb000  CPU: 28  COMMAND: "java"
>   PID: 787502  TASK: ffff94e41e0f3000  CPU: 36  COMMAND: "java"
>
> It seems like fixing this will be a challenging task.
>

Hello Petr,

I believe this case highlights the need for a hybrid livepatch
mode=E2=80=94where we allow the coexistence of atomic-replace and
non-atomic-replace patches. If a livepatch is set to non-replaceable,
it should neither be replaced by other livepatches nor replace any
other patches itself.

We=E2=80=99ve deployed this livepatch, including the change to do_exit(), t=
o
nearly all of our servers=E2=80=94hundreds of thousands in total. It=E2=80=
=99s a real
tragedy that we can't unload it. Moving forward, we=E2=80=99ll have no choi=
ce
but to create non-atomic-replace livepatches to avoid this issue...

--
Regards
Yafang

