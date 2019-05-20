Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B99024197
	for <lists+live-patching@lfdr.de>; Mon, 20 May 2019 21:56:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726004AbfETT40 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 20 May 2019 15:56:26 -0400
Received: from out.bound.email ([141.193.244.10]:40810 "EHLO out.bound.email"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725951AbfETT40 (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Mon, 20 May 2019 15:56:26 -0400
X-Greylist: delayed 429 seconds by postgrey-1.27 at vger.kernel.org; Mon, 20 May 2019 15:56:25 EDT
Received: from mail.sventech.com (localhost [127.0.0.1])
        by out.bound.email (Postfix) with ESMTP id CE4718A0E7F;
        Mon, 20 May 2019 12:49:15 -0700 (PDT)
Received: by mail.sventech.com (Postfix, from userid 1000)
        id AFFD41600410; Mon, 20 May 2019 12:49:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=erdfelt.com;
        s=default; t=1558381755;
        bh=oZso2p1ld/yWyzQANIKklBxHpoVt65FCEMCZ1z7xtQk=;
        h=Date:From:To:Subject:From;
        b=tQk3X2I4GZp9iWe9qCA8R6a2+xeow6B7LEofril0pQcBmeMDVWbZUf3EWA85YCCmb
         rrtWhw2JcZLK5WgiUZ3ykNh+hGJEhPuF1NKOmUYqdqKZIf6/pYI6hRn5/510e1r+WM
         t5l0w8tWM2yRz9ZGWUllj7tKTBaKkUmmmCHFeV/0=
Date:   Mon, 20 May 2019 12:49:15 -0700
From:   Johannes Erdfelt <johannes@erdfelt.com>
To:     Josh Poimboeuf <jpoimboe@redhat.com>, Jessica Yu <jeyu@redhat.com>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>, live-patching@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Oops caused by race between livepatch and ftrace
Message-ID: <20190520194915.GB1646@sventech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

There exists a race condition between livepatch and ftrace that can
cause an oops similar to this one:

  BUG: unable to handle page fault for address: ffffffffc005b1d9
  #PF: supervisor write access in kernel mode
  #PF: error_code(0x0003) - permissions violation
  PGD 3ea0c067 P4D 3ea0c067 PUD 3ea0e067 PMD 3cc13067 PTE 3b8a1061
  Oops: 0003 [#1] PREEMPT SMP PTI
  CPU: 1 PID: 453 Comm: insmod Tainted: G           O  K   5.2.0-rc1-a188339ca5 #1
  Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.12.0-20181126_142135-anatol 04/01/2014
  RIP: 0010:apply_relocate_add+0xbe/0x14c
  Code: fa 0b 74 21 48 83 fa 18 74 38 48 83 fa 0a 75 40 eb 08 48 83 38 00 74 33 eb 53 83 38 00 75 4e 89 08 89 c8 eb 0a 83 38 00 75 43 <89> 08 48 63 c1 48 39 c8 74 2e eb 48 83 38 00 75 32 48 29 c1 89 08
  RSP: 0018:ffffb223c00dbb10 EFLAGS: 00010246
  RAX: ffffffffc005b1d9 RBX: 0000000000000000 RCX: ffffffff8b200060
  RDX: 000000000000000b RSI: 0000004b0000000b RDI: ffff96bdfcd33000
  RBP: ffffb223c00dbb38 R08: ffffffffc005d040 R09: ffffffffc005c1f0
  R10: ffff96bdfcd33c40 R11: ffff96bdfcd33b80 R12: 0000000000000018
  R13: ffffffffc005c1f0 R14: ffffffffc005e708 R15: ffffffff8b2fbc74
  FS:  00007f5f447beba8(0000) GS:ffff96bdff900000(0000) knlGS:0000000000000000
  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: ffffffffc005b1d9 CR3: 000000003cedc002 CR4: 0000000000360ea0
  DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
  DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
  Call Trace:
   klp_init_object_loaded+0x10f/0x219
   ? preempt_latency_start+0x21/0x57
   klp_enable_patch+0x662/0x809
   ? virt_to_head_page+0x3a/0x3c
   ? kfree+0x8c/0x126
   patch_init+0x2ed/0x1000 [livepatch_test02]
   ? 0xffffffffc0060000
   do_one_initcall+0x9f/0x1c5
   ? kmem_cache_alloc_trace+0xc4/0xd4
   ? do_init_module+0x27/0x210
   do_init_module+0x5f/0x210
   load_module+0x1c41/0x2290
   ? fsnotify_path+0x3b/0x42
   ? strstarts+0x2b/0x2b
   ? kernel_read+0x58/0x65
   __do_sys_finit_module+0x9f/0xc3
   ? __do_sys_finit_module+0x9f/0xc3
   __x64_sys_finit_module+0x1a/0x1c
   do_syscall_64+0x52/0x61
   entry_SYSCALL_64_after_hwframe+0x44/0xa9
  RIP: 0033:0x7f5f44764881
  Code: 0e 4c 8b 44 24 10 4d 8d 48 08 4c 89 4c 24 10 44 8b 4c 24 08 4d 8b 00 4c 01 c9 41 83 f9 2f 76 05 48 8b 4c 24 10 4c 8b 09 0f 05 <48> 89 c7 e8 f7 e9 fd ff 48 83 c4 58 c3 56 31 d2 be 02 00 08 00 bf
  RSP: 002b:00007ffcf1e64b80 EFLAGS: 00000212 ORIG_RAX: 0000000000000139
  RAX: ffffffffffffffda RBX: 00000000006229a0 RCX: 00007f5f44764881
  RDX: 0000000000000000 RSI: 000000000041a506 RDI: 0000000000000003
  RBP: 000000000041a506 R08: 0000000000000000 R09: 00007ffcf1e64c48
  R10: 0000000000000003 R11: 0000000000000212 R12: 0000000000000000
  R13: 00000000006228c0 R14: 0000000000000000 R15: 0000000000000000
  Modules linked in: livepatch_test03(OK+) livepatch_test01(OK+) livepatch_test11(OK+) livepatch_test06(OK+) livepatch_test04(OK+) livepatch_test02(OK+) livepatch_test10(OK+) livepatch_test16(OK+) livepatch_test18(OK-) livepatch_test12(OK)
  CR2: ffffffffc005b1d9
  ---[ end trace 52fee0aa635dd5a1 ]---

The oops occurs because both livepatch and ftrace remap the module text
section at the same. After ftrace is done, it can leave the module text
text section mapped RO when the livepatch code is expecting it to be RW.

CPU A			CPU B
--------		--------
			set_all_modules_text_rw		(module is now RW)
module_disable_ro					(module is still RW)
			set_all_modules_text_ro		(module is now RO)
apply_relocate_add					(oops)

I've reproduced it from the latest code in git (a188339ca5a3), 5.0.17,
4.19.44, 4.14.120, 4.9.177 and some kernels in between. I haven't tried
reproducing on any kernel older than 4.9. From looking at the older
versions in git, it will likely be harder to reproduce since the kernel
switched in 4.5 to remapping RW once from remapping on every write.

The oops will only occur if CONFIG_STRICT_MODULE_RWX is enabled
(previously called CONFIG_DEBUG_SET_MODULE_RONX).

I've found two ways the race condition can be reproduced:
1) loading multiple livepatches at the same time
2) loading a livepatch at the same time ftrace is patching code

They are both ultimately the same root cause since livepatch uses ftrace
to perform the patching.

I have put together a test case that can reproduce the crash using
KVM. The tarball includes a minimal kernel and initramfs, along with
a script to run qemu and the .config used to build the kernel. By
default it will attempt to reproduce by loading multiple livepatches
at the same time. Passing 'test=ftrace' to the script will attempt to
reproduce by racing with ftrace.

My test setup reproduces the race and oops more reliably by loading
multiple livepatches at the same time than with the ftrace method. It's
not 100% reproducible, so the test case may need to be run multiple
times.

It can be found here (not attached because of its size):
http://johannes.erdfelt.com/5.2.0-rc1-a188339ca5-livepatch-race.tar.gz

The simple patch of extending the module_mutex lock over the entirety
of klp_init_object_loaded fixes it from the livepatch side. This
mostly works because set_all_modules_text_{rw,ro} acquires module_mutex
as well, but it still leaves a hole in the ftrace code. A lock should
probably be held over the entirety of remapping the text sections RW.

This is complicated by the fact that remapping the text section in
ftrace is handled by arch specific code. I'm not sure what a good
solution to this is yet.

JE

