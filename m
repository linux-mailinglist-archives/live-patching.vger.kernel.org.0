Return-Path: <live-patching+bounces-946-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1972D9FE114
	for <lists+live-patching@lfdr.de>; Mon, 30 Dec 2024 01:09:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BDF1F16116E
	for <lists+live-patching@lfdr.de>; Mon, 30 Dec 2024 00:09:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B0E81817;
	Mon, 30 Dec 2024 00:09:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wRD9CAUS"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0694A645
	for <live-patching@vger.kernel.org>; Mon, 30 Dec 2024 00:09:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735517382; cv=none; b=LUcWVLT7g+SbPYeFna6fpRe2NTwGAqFb4ETPZNgZaz2I1Fm4ydSceivQEjtaw/GRHKvJoKKoA9+zo1mTBZkN1OVGjn8Y23HGKMo3xod6Exlcrq+5cCULHtVGCuW6Z8OPD33Th13/gxrvwfm5d3hEmPdeGHgYOJmobtPeiUHXIog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735517382; c=relaxed/simple;
	bh=BUtQMCSg1Oj0Chy5Kbp17AuO/+h+n58htkK175/Z7iA=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=Br7/9n+cl4JDg7IxouDrbbpsJk7ofJg12eDUQ8VwPIH9HbeyaU7/AEQfjdtigzSHj6q7UDIV5s62bHEQxcQIOXJKoVYCK2aKoWyMzYxUSJFtUDaViTExgv8eD7xMvL+W2H3aPDLVN5BNg1Z7SQSeGWD56HRLS5P0b7mbIDIY9/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=wRD9CAUS; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-215740b7fb8so1061235ad.0
        for <live-patching@vger.kernel.org>; Sun, 29 Dec 2024 16:09:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1735517380; x=1736122180; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=s5aXoDdVCtXt3iybNZCPNId+3b30Me5/dyFiUes8QNc=;
        b=wRD9CAUS8cNEXfeSkXAgCwkt/Gso66KbUMzL7YvKKeFWh4tTDAsi1zpiYYL39itNE4
         kRS70ZFV4d1xgACgwgmqBleUm9dunNETudfVq258l6DWlECGMWB0AhMfhtVdyzuf7EYu
         mXzq+I9XFQPr6TsVdFaxiCEUr2CxHDe2N3xnS5UWncX0gm5Fvq2wFGiuMZmYlay6mfhh
         sAJpFPCus7QrZL0XnMuTPE3j3oO5+x+QeyJrPzRf0nqXPd42Fzg2zIVXr0UnWoxTwU3F
         Pph1Z3HLh1aKla49Lzsg23xNOevAJ5NMRAuDft5R9Zdc6R2Z9TnCnKZ75lQhQFr7ZM14
         r4Tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735517380; x=1736122180;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=s5aXoDdVCtXt3iybNZCPNId+3b30Me5/dyFiUes8QNc=;
        b=vHpasmavTTGJ3pSseoScs7FN0+Iygr83aLTZbjHhPA7+sZFANaAZHLBb0C2qGjtSDO
         quwCQB0pRDY6cN2Jx68NdDNaL5+HqET3s5iop+kEvyuh3iXIL08mtybMMkPH2+4UgPtu
         IzjeusiFXL6BqQ7dMABACGmaAd1S78imJcfAY4xBwkOArBBY1H372r40hC8P75alhYeh
         4YDHTNkh+xBkAH77cTsAyfJhj2EaK92qLIhnmvQXZcWfjIYgj/WMLSRvWgtlZl1W5Cxn
         fD9NLuhjiPOkIB91U3mkGYgPpxyM8rsGnupYfb2J+Tt79fT0qdRjPHe77T5AV2hWOQl8
         MUUg==
X-Forwarded-Encrypted: i=1; AJvYcCWSRn/RzHeoQJGR75rtTuBwnFo43Z0eJGtGebT+hvBL3MHP1SgZ/oGwTHMfENSEzAeM0mOIJKDJ79F0CuDG@vger.kernel.org
X-Gm-Message-State: AOJu0Yw2uyEkOJHEdSfZAtLvpc4alZ5WWgMBJWNph+k4hXrNPyhVuHD6
	tykfFTuzYo5FPWK3sZT/1SzWjFjDy7maQL0X67sKzTWjPu9WSMTxoHMc01yBgskW++pvEXOQad3
	Zu3VBozT+5OcQvZXIan9f6U2lBmfo04yOFHSy
X-Gm-Gg: ASbGncu80e3W8olMWIxozocNCxn8hArEd8NFWrsB4bN3Kjx2WFf964+8ZDkiJZDxGk9
	VrtZMLdFSQI9Mwxo8DnP0AveOLVSfJGLspT8l
X-Google-Smtp-Source: AGHT+IED0OOOeYrHXZaLoyVsabfnYVRzwby1oeJPfnt9kAFzELRgCktOS5laqmNdNl1xrBm57Qduh7AC85xJGT7lOaU=
X-Received: by 2002:a17:902:e5c1:b0:216:4d90:47af with SMTP id
 d9443c01a7336-219e7769cdcmr13926205ad.29.1735517379928; Sun, 29 Dec 2024
 16:09:39 -0800 (PST)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: =?UTF-8?Q?Marek_Ma=C5=9Blanka?= <mmaslanka@google.com>
Date: Mon, 30 Dec 2024 01:09:13 +0100
Message-ID: <CAGcaFA2hdThQV6mjD_1_U+GNHThv84+MQvMWLgEuX+LVbAyDxg@mail.gmail.com>
Subject: ROX allocations broke livepatch for modules since 6.13-rc1
To: rppt@kernel.org, akpm@linux-foundation.org, mcgrof@kernel.org
Cc: regressions@lists.linux.dev, linux-modules@vger.kernel.org, 
	linux-mm@kvack.org, live-patching@vger.kernel.org, joe.lawrence@redhat.com, 
	jpoimboe@kernel.org, pmladek@suse.com
Content-Type: text/plain; charset="UTF-8"

Hi Mike and others,

I discovered that the patch "[v7,4/8] module: prepare to handle ROX allocations
for text" has disrupted livepatch functionality. Specifically, this occurs when
livepatch is prepared to patch a kernel module and when the livepatch module
contains a "special" relocation section named
".klp.rela.<MODULE_NAME>.<SECTION_NAME>" to access local symbols.
The problem is caused by this changes:

@@ -2454,7 +2497,24 @@  static int post_relocation(struct module *mod,
const struct load_info *info)
  add_kallsyms(mod, info);

  /* Arch-specific module finalizing. */
- return module_finalize(info->hdr, info->sechdrs, mod);
+ ret = module_finalize(info->hdr, info->sechdrs, mod);
+ if (ret)
+ return ret;
+
+ for_each_mod_mem_type(type) {
+ struct module_memory *mem = &mod->mem[type];
+
+ if (mem->is_rox) {
+ if (!execmem_update_copy(mem->base, mem->rw_copy,
+ mem->size))
+ return -ENOMEM;
+
+ vfree(mem->rw_copy);
+ mem->rw_copy = NULL;
+ }
+ }
+
+ return module_post_finalize(info->hdr, info->sechdrs, mod);
 }

Specifically these lines:
+ vfree(mem->rw_copy);
+ mem->rw_copy = NULL;
which frees the "mem->rw_copy" too early. It's called from:
load_module (kernel/module/main.c:3312)
  post_relocation

The "mem->rw_copy" is needed later:
load_module (kernel/module/main.c:3339)
  prepare_coming_module
    klp_module_coming
      klp_init_object_loaded
        klp_apply_object_relocs
          klp_write_object_relocs
            klp_write_section_relocs
              apply_relocate_add
                write_relocate_add
                  __write_relocate_add
                    module_writable_address
                      __module_writable_address
                        return loc + (mem->rw_copy - mem->base);
                                                       ^

Here's example OOPS:
[   25.823395] deku: loading out-of-tree module taints kernel.
[   25.823521] deku: tainting kernel with TAINT_LIVEPATCH
[   25.827238] BUG: unable to handle page fault for address: 00000000000012ba
[   25.827819] #PF: supervisor read access in kernel mode
[   25.828153] #PF: error_code(0x0000) - not-present page
[   25.828588] PGD 0 P4D 0
[   25.829063] Oops: Oops: 0000 [#1] PREEMPT SMP NOPTI
[   25.829742] CPU: 2 UID: 0 PID: 452 Comm: insmod Tainted: G
 O  K    6.13.0-rc4-00078-g059dd502b263 #7820
[   25.830417] Tainted: [O]=OOT_MODULE, [K]=LIVEPATCH
[   25.830768] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
BIOS 1.16.0-20220807_005459-localhost 04/01/2014
[   25.831651] RIP: 0010:memcmp+0x24/0x60
[   25.832190] Code: 90 90 90 90 90 90 f3 0f 1e fa 49 89 f0 48 89 d6
48 83 fa 07 77 3a 31 d2 48 85 f6 74 1a 31 c0 eb 09 48 83 c0 01 48 39
c6 74 0d <0f> b6 14 07 41 0f b6 0c 00 29 ca 74 ea 89 d0 c3 cc cc cc cc
48 83
[   25.833378] RSP: 0018:ffffa40b403a3ae8 EFLAGS: 00000246
[   25.833637] RAX: 0000000000000000 RBX: ffff93bc81d8e700 RCX: ffffffffc0202000
[   25.834072] RDX: 0000000000000000 RSI: 0000000000000004 RDI: 00000000000012ba
[   25.834548] RBP: ffffa40b403a3b68 R08: ffffa40b403a3b30 R09: 0000004a00000002
[   25.835088] R10: ffffffffffffd222 R11: f000000000000000 R12: 0000000000000000
[   25.835666] R13: ffffffffc02032ba R14: ffffffffc007d1e0 R15: 0000000000000004
[   25.836139] FS:  00007fecef8c3080(0000) GS:ffff93bc8f900000(0000)
knlGS:0000000000000000
[   25.836519] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   25.836977] CR2: 00000000000012ba CR3: 0000000002f24000 CR4: 00000000000006f0
[   25.837442] Call Trace:
[   25.838297]  <TASK>
[   25.838803]  ? __die+0x29/0x70
[   25.839067]  ? page_fault_oops+0x15f/0x450
[   25.839299]  ? exc_page_fault+0x6e/0x160
[   25.839506]  ? asm_exc_page_fault+0x26/0x30
[   25.839978]  ? uinput_ioctl_handler_isra_0+0x120/0xe66 [deku]
[   25.840519]  ? uinput_misc_exit+0x3e0/0x3e0 [uinput]
[   25.840892]  ? memcmp+0x24/0x60
[   25.841083]  __write_relocate_add.constprop.0+0xc7/0x2b0
[   25.841460]  ? __pfx_text_poke+0x10/0x10
[   25.841701]  apply_relocate_add+0x75/0xa0
[   25.841973]  klp_write_section_relocs+0x10e/0x140
[   25.842304]  klp_write_object_relocs+0x70/0xa0
[   25.842682]  klp_init_object_loaded+0x21/0xf0
[   25.842972]  klp_enable_patch+0x43d/0x900
[   25.843227]  ? deku_exit+0x30/0x30 [deku]
[   25.843572]  do_one_initcall+0x4c/0x220
[   25.843936]  ? do_init_module+0x28/0x260
[   25.844186]  do_init_module+0x6a/0x260
[   25.844423]  init_module_from_file+0x9c/0xe0
[   25.844702]  idempotent_init_module+0x172/0x270
[   25.845008]  __x64_sys_finit_module+0x69/0xc0
[   25.845253]  do_syscall_64+0x9e/0x1a0
[   25.845498]  entry_SYSCALL_64_after_hwframe+0x77/0x7f
[   25.846056] RIP: 0033:0x7fecef9eb25d
[   25.846444] Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e
fa 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24
08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 8b bb 0d 00 f7 d8 64 89
01 48
[   25.847563] RSP: 002b:00007ffd0c5d6de8 EFLAGS: 00000246 ORIG_RAX:
0000000000000139
[   25.848082] RAX: ffffffffffffffda RBX: 000055b03f05e470 RCX: 00007fecef9eb25d
[   25.848456] RDX: 0000000000000000 RSI: 000055b001e74e52 RDI: 0000000000000003
[   25.848969] RBP: 00007ffd0c5d6ea0 R08: 0000000000000040 R09: 0000000000004100
[   25.849411] R10: 00007fecefac7b20 R11: 0000000000000246 R12: 000055b001e74e52
[   25.849905] R13: 0000000000000000 R14: 000055b03f05e440 R15: 0000000000000000
[   25.850336]  </TASK>
[   25.850553] Modules linked in: deku(OK+) uinput
[   25.851408] CR2: 00000000000012ba
[   25.852085] ---[ end trace 0000000000000000 ]---

Please let me know if you need help to test or reproduce this issue.

Best regards,
Marek

