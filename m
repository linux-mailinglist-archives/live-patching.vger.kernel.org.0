Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E07A8594933
	for <lists+live-patching@lfdr.de>; Tue, 16 Aug 2022 02:11:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243981AbiHOX2i (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 15 Aug 2022 19:28:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345669AbiHOX0x (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 15 Aug 2022 19:26:53 -0400
X-Greylist: delayed 509 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 15 Aug 2022 13:06:59 PDT
Received: from out.bound.email (out.bound.email [141.193.244.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCAA480F6F
        for <live-patching@vger.kernel.org>; Mon, 15 Aug 2022 13:06:59 -0700 (PDT)
Received: from mail.sventech.com (localhost [127.0.0.1])
        by out.bound.email (Postfix) with ESMTP id 179378A03AB;
        Mon, 15 Aug 2022 12:58:29 -0700 (PDT)
Received: by mail.sventech.com (Postfix, from userid 1000)
        id 020DE16006D1; Mon, 15 Aug 2022 12:58:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=erdfelt.com;
        s=default; t=1660593509;
        bh=djMSSpuUW2RtxPrkncynZ6XwTJDLeNnOAigLw6RHbx8=;
        h=Date:From:To:Subject:From;
        b=tARFWQwqLhJyWcHzQnPIyQlWLDzg3ECCBYSMj4j/cY7hCfPtJf0pvk5UccweLaDtJ
         zo0K40SAJzXY0ThG3rDGq+/R6Co/bA8FAwIOU0Y4n+fpAIPo8axZGjiRQIJQUR2qwu
         YpOJL+Qin7F1iNRFUHjfeTcQQRi2O87PEWejrcG4=
Date:   Mon, 15 Aug 2022 12:58:28 -0700
From:   Johannes Erdfelt <johannes@erdfelt.com>
To:     Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>, live-patching@vger.kernel.org
Subject: ftrace regression with CONFIG_UNWINDER_FRAME_POINTER
Message-ID: <20220815195828.GE3948@sventech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.11.4 (2019-03-13)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

I recently ran across an oops with ftrace when using the frame pointer
unwinder. It does not affect Linus' tree (tested 6.0-rc1), but it does
affect 5.15.60 and 5.10.136 (at least, have not tested other kernels).

It appears to be related to the recently merged retbleed mitigations,
in particular the unret mitigation. I originally reproduced it with
a live patch (livepatch-sample.ko can reproduce it) but can also
reproduce by setting a function filter with ftrace.

Oops from loading live patch:

[    0.672824] livepatch: 'livepatch_sample': patching complete
[    0.673809] BUG: unable to handle page fault for address: ffffffffc14dd888
[    0.674693] #PF: supervisor instruction fetch in kernel mode
[    0.675441] #PF: error_code(0x0010) - not-present page
[    0.676098] PGD 1ae10067 P4D 1ae10067 PUD 1ae12067 PMD 0
[    0.676790] Oops: 0010 [#1] SMP PTI
[    0.677239] CPU: 0 PID: 347 Comm: cat Tainted: G              K 5.15.60 #1
[    0.678127] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS ArchLinux 1.16.0-1 04/01/2014
[    0.679318] RIP: 0010:0xffffffffc14dd888
[    0.679820] Code: Unable to access opcode bytes at RIP 0xffffffffc14dd85e.
[    0.680689] RSP: 0018:ffffac644075bc68 EFLAGS: 00010282
[    0.681352] RAX: ffffffffa74d9cf0 RBX: 0000000000000000 RCX: 0000000000000001
[    0.682282] RDX: 0000000000400cc0 RSI: 0000000000000001 RDI: ffff970c8245f000
[    0.683184] RBP: ffffac644075bcc8 R08: 0000000000001000 R09: 0000000000000001
[    0.684081] R10: 0000000000000000 R11: ffff970c81868200 R12: ffffac644075bd20
[    0.684982] R13: ffffac644075bcf8 R14: 0000000000000001 R15: ffff970c8245f000
[    0.685925] FS:  0000000000713198(0000) GS:ffff970c9f400000(0000) knlGS:0000000000000000
[    0.686949] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    0.687677] CR2: ffffffffc14dd85e CR3: 000000000105c003 CR4: 0000000000370ef0
[    0.688579] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[    0.689513] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[    0.690411] Call Trace:
[    0.690730]  <TASK>
[    0.691006]  ? 0xffffffffc03c9000
[    0.691425]  ? seq_read_iter+0x10e/0x440
[    0.691955]  proc_reg_read_iter+0x52/0x90
[    0.692487]  generic_file_splice_read+0xf1/0x190
[    0.693079]  do_splice_to+0x7d/0xc0
[    0.693528]  splice_direct_to_actor+0xbd/0x220
[    0.694100]  ? generic_file_splice_read+0x190/0x190
[    0.694723]  do_splice_direct+0x8a/0xd0
[    0.695214]  do_sendfile+0x352/0x4b0
[    0.695751]  __x64_sys_sendfile64+0xa9/0xc0
[    0.696285]  ? __context_tracking_exit+0x57/0x90
[    0.696868]  do_syscall_64+0x37/0x90
[    0.697324]  entry_SYSCALL_64_after_hwframe+0x61/0xcb
[    0.697964] RIP: 0033:0x4bf81e
[    0.698361] Code: de e1 fe 50 be 69 19 12 28 b8 a9 00 00 00 0f 05 48 89 c7 e8 84 0a f4 ff 5a c3 49 89 ca 48 63 f6 48 63 ff b8 28 00 00 00 0f 05 <48> 89 c7 e9 6a 0a f4 ff 50 b8 74 00 00 00 0f 05 48 89 c7 e8 5a 0a
[    0.700729] RSP: 002b:00007ffd027102b8 EFLAGS: 00000246 ORIG_RAX: 0000000000000028
[    0.701670] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00000000004bf81e
[    0.702594] RDX: 0000000000000000 RSI: 0000000000000003 RDI: 0000000000000001
[    0.703483] RBP: 00007ffd02710310 R08: 0000000000000000 R09: 0000000001000000
[    0.704375] R10: 0000000001000000 R11: 0000000000000246 R12: 000000000000001b
[    0.705285] R13: 0000000000000001 R14: 0000000001000000 R15: 0000000000000001
[    0.706197]  </TASK>
[    0.706480] Modules linked in: livepatch_sample(K)
[    0.707085] CR2: ffffffffc14dd888
[    0.707508] ---[ end trace f6f689798d1c9538 ]---
[    0.708094] RIP: 0010:0xffffffffc14dd888
[    0.708610] Code: Unable to access opcode bytes at RIP 0xffffffffc14dd85e.
[    0.709480] RSP: 0018:ffffac644075bc68 EFLAGS: 00010282
[    0.710136] RAX: ffffffffa74d9cf0 RBX: 0000000000000000 RCX: 0000000000000001
[    0.711026] RDX: 0000000000400cc0 RSI: 0000000000000001 RDI: ffff970c8245f000
[    0.711915] RBP: ffffac644075bcc8 R08: 0000000000001000 R09: 0000000000000001
[    0.712864] R10: 0000000000000000 R11: ffff970c81868200 R12: ffffac644075bd20
[    0.713753] R13: ffffac644075bcf8 R14: 0000000000000001 R15: ffff970c8245f000
[    0.714649] FS:  0000000000713198(0000) GS:ffff970c9f400000(0000) knlGS:0000000000000000
[    0.715705] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    0.716426] CR2: ffffffffc14dd85e CR3: 000000000105c003 CR4: 0000000000370ef0
[    0.717317] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[    0.718208] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Killed
[    0.720709] Kernel panic - not syncing: Attempted to kill init!  exitcode=0x00000000
[    0.721740] Kernel Offset: 0x26000000 from 0xffffffff81000000 (relocation range: 0xffffffff80000000-0xffffffffbfffffff)
[    0.723133] ---[ end Kernel panic - not syncing: Attempted to kill init! exitcode=0x00000000 ]---

Oops from setting ftrace filter:

[    0.644436] BUG: unable to handle page fault for address: ffffffffc1172888
[    0.645244] #PF: supervisor instruction fetch in kernel mode
[    0.645902] #PF: error_code(0x0010) - not-present page
[    0.646536] PGD 18e10067 P4D 18e10067 PUD 18e12067 PMD 0
[    0.647166] Oops: 0010 [#1] SMP PTI
[    0.647577] CPU: 0 PID: 1 Comm: init Not tainted 5.15.60 #1
[    0.648227] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS ArchLinux 1.16.0-1 04/01/2014
[    0.649284] BUG: unable to handle page fault for address: ffffffffc1172888
[    0.650117] #PF: supervisor instruction fetch in kernel mode
[    0.650772] #PF: error_code(0x0010) - not-present page
[    0.651370] PGD 18e10067 P4D 18e10067 PUD 18e12067 PMD 0
[    0.651998] Oops: 0010 [#2] SMP PTI
[    0.652409] CPU: 0 PID: 1 Comm: init Not tainted 5.15.60 #1
[    0.653059] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS ArchLinux 1.16.0-1 04/01/2014

Oddly this oops is incomplete but the portion that does get emitted
repeats a total of 4 times.

Requirements I've found to reproduce the oops:
- Recent LTS kernel (reproduced with 5.15.60 and 5.10.136 at least)
  - I could not cause the oops with Linus' tree (6.0-rc1 tested)
  - Have not tested other stable trees
- CONFIG_RETHUNK enabled
- CONFIG_UNWINDER_FRAME_POINTER enabled
  - CONFIG_UNWINDER_ORC does not cause an oops
- Using the default retbleed mitigations
  - Using retbleed=ibpb does not cause an oops on an AMD host

I've put together a quick reproducer using qemu. This tarball includes
a kernel and a minimal initrd that will reproduce the oops. Also
included is the .config used. I built this test kernel using gcc 12.1.0
(12.1.0-2) on an Arch Linux host but have also reproduced the oops using
gcc 9.3.0 (9.3.0-17ubuntu1~20.04) on an Ubuntu host.

http://johannes.erdfelt.com/ftrace-frame-pointer-regression.tar.gz

JE

