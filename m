Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 664EB54DCC
	for <lists+live-patching@lfdr.de>; Tue, 25 Jun 2019 13:36:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730750AbfFYLgk (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 25 Jun 2019 07:36:40 -0400
Received: from mx2.suse.de ([195.135.220.15]:56144 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728703AbfFYLgk (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Tue, 25 Jun 2019 07:36:40 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id BEA4FAE78;
        Tue, 25 Jun 2019 11:36:38 +0000 (UTC)
Date:   Tue, 25 Jun 2019 13:36:37 +0200 (CEST)
From:   Miroslav Benes <mbenes@suse.cz>
To:     Petr Mladek <pmladek@suse.com>
cc:     Joe Lawrence <joe.lawrence@redhat.com>,
        linux-kernel@vger.kernel.org, live-patching@vger.kernel.org,
        linux-kbuild@vger.kernel.org
Subject: Re: [PATCH v4 00/10] klp-convert livepatch build tooling
In-Reply-To: <20190614083435.uq3mk6mprbatysol@pathway.suse.cz>
Message-ID: <alpine.LSU.2.21.1906251324450.12085@pobox.suse.cz>
References: <20190509143859.9050-1-joe.lawrence@redhat.com> <alpine.LSU.2.21.1906131451560.22698@pobox.suse.cz> <b1a627a4-3702-9689-6c03-0c2123c06a2d@redhat.com> <c9021573-11c6-b576-0aa6-97754c98a06e@redhat.com>
 <20190614083435.uq3mk6mprbatysol@pathway.suse.cz>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Fri, 14 Jun 2019, Petr Mladek wrote:

> On Thu 2019-06-13 16:48:02, Joe Lawrence wrote:
> > On 6/13/19 9:15 AM, Joe Lawrence wrote:
> > > On 6/13/19 9:00 AM, Miroslav Benes wrote:
> > >> Hi Joe,
> > >>
> > >> first, I'm sorry for the lack of response so far.
> > >>
> > >> Maybe you've already noticed but the selftests fail. Well, at least in
> > >> my VM. When test_klp_convert1.ko is loaded, the process is killed with
> > >>
> > >> [  518.041826] BUG: kernel NULL pointer dereference, address: 0000000000000000
> > >> [  518.042816] #PF: supervisor read access in kernel mode
> > >> [  518.043393] #PF: error_code(0x0000) - not-present page
> > >> [  518.043981] PGD 0 P4D 0
> > >> [  518.044185] Oops: 0000 [#1] SMP PTI
> > >> [  518.044518] CPU: 2 PID: 2255 Comm: insmod Tainted: G           O  K   5.1.0-klp_convert_v4-193435-g67748576637e #2
> > >> [  518.045784] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.12.1-0-ga5cab58-prebuilt.qemu.org 04/01/2014
> > >> [  518.046940] RIP: 0010:test_klp_convert_init+0x1c/0x40 [test_klp_convert1]
> > >> [  518.047611] Code: 1b a0 48 89 c6 e9 a8 c0 f4 e0 0f 1f 40 00 0f 1f 44 00 00 53 48 c7 c7 00 30 1b a0 e8 5e 33 f6 e0 85 c0 89 c3 74 04 89 d8 5b c3 <48> 8b 35 5d ef e4 5f 48 c7 c7 28 20 1b a0 e8 75 c0 f4 e0 e8 6c ff
> > >> [  518.049779] RSP: 0018:ffffc90000f37cc8 EFLAGS: 00010246
> > >> [  518.050243] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000027de0
> > >> [  518.050922] RDX: 0000000000000000 RSI: 0000000000000006 RDI: ffff88807ab54f40
> > >> [  518.051619] RBP: ffffffffa01b1080 R08: 0000000096efde7a R09: 0000000000000001
> > >> [  518.052332] R10: 0000000000000000 R11: 0000000000000000 R12: 00000000ffffffff
> > >> [  518.053012] R13: 0000000000000000 R14: ffff888078b55000 R15: ffffc90000f37ea0
> > >> [  518.053714] FS:  00007febece1fb80(0000) GS:ffff88807d400000(0000) knlGS:0000000000000000
> > >> [  518.054514] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > >> [  518.055078] CR2: 0000000000000000 CR3: 000000007a56a000 CR4: 00000000000006e0
> > >> [  518.055818] Call Trace:
> > >> [  518.056007]  do_one_initcall+0x6a/0x2da
> > >> [  518.056340]  ? do_init_module+0x22/0x230
> > >> [  518.056702]  ? rcu_read_lock_sched_held+0x96/0xa0
> > >> [  518.057125]  ? kmem_cache_alloc_trace+0x284/0x2e0
> > >> [  518.057493]  do_init_module+0x5a/0x230
> > >> [  518.057900]  load_module+0x17bc/0x1f50
> > >> [  518.058214]  ? __symbol_put+0x40/0x40
> > >> [  518.058499]  ? vfs_read+0x12d/0x160
> > >> [  518.058766]  __do_sys_finit_module+0x83/0xc0
> > >> [  518.059122]  do_syscall_64+0x57/0x190
> > >> [  518.059407]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
> > >> ...
> > >>
> > >> It crashes right in test_klp_convert_init() when print_*() using
> > >> supposed-to-be-converted symbols are called. I'll debug it next week. Can
> > >> you reproduce it too?
> > > 
> > > Hey, thanks for the report..
> > > 
> > > I don't recall the tests crashing, but I had put this patchset on the
> > > side for a few weeks now.  I'll try to fire up a VM and see what happens
> > > today.
> > > 
> > 
> > Hmm, I haven't been able to reproduce using my original base (Linux 5.1-rc6)
> > or when rebased ontop of livepatching.git/master + 997a55f3fb6d("stacktrace: Unbreak stack_trace_save_tsk_reliable()")
> 
> I stared into the code a bit but I did not find any bug. Let's hope
> that it was just some pre-vacation last minute mistake (system
> inconsistency or so ;-)

It was not and I do not understand it much, so there is a brain dump here.

I'll take test_klp_convert1.c as an example. When you compile it, 
test_klp_convert1.klp.o (not-yet-converted kernel module) has these 
relevant relocations.

Relocation section '.rela.text' at offset 0x1328 contains 27 entries:
    Offset             Info             Type               Symbol's Value  Symbol's Name + Addend
0000000000000008  0000002800000002 R_X86_64_PC32          0000000000000000 saved_command_line - 4
000000000000009f  0000002800000002 R_X86_64_PC32          0000000000000000 saved_command_line - 4

When converted, test_klp_convert1.ko has

Relocation section '.rela.text' at offset 0x138 contains 22 entries:
    Offset             Info             Type               Symbol's Value  Symbol's Name + Addend
000000000000009f  0000002600000002 R_X86_64_PC32          0000000000000000 .klp.sym.vmlinux.saved_command_line,0 - 4

and

Relocation section '.klp.rela.vmlinux..text' at offset 0x1968 contains 1 
entry:
    Offset             Info             Type               Symbol's Value  Symbol's Name + Addend
0000000000000008  0000002600000002 R_X86_64_PC32          0000000000000000 .klp.sym.vmlinux.saved_command_line,0 - 4

See? One of the relocations was not moved to the correct .klp.rela 
section. The final module should have

Relocation section '.klp.rela.vmlinux..text' at offset 0x1928 contains 2 
entries:
    Offset             Info             Type               Symbol's Value  Symbol's Name + Addend
000000000000009f  0000002600000002 R_X86_64_PC32          0000000000000000 .klp.sym.vmlinux.saved_command_line,0 - 4
0000000000000008  0000002600000002 R_X86_64_PC32          0000000000000000 .klp.sym.vmlinux.saved_command_line,0 - 4

and no saved_command_line relocation in .rela.text.

It thus makes sense that there is a NULL pointer dereference. The code 
accesses non-relocated symbol and boom.

So I made a couple of experiments and found that GCC is somehow involved. 
If klp-convert (from scripts/livepatch/) is compiled with our GCC 4.8.5 
from SLE12, the output is incorrect. If I compile it with GCC 7.4.0 from 
openSUSE Leap 15.1, the output is correct.

If I revert commit d59cadc0a8f8 ("[squash] klp-convert: make 
convert_rela() list-safe") (from Joe's expanded github tree), the problem 
disappears.

I haven't spotted any problem in the code and I cannot explain a 
dependency on GCC version. Any ideas?

Miroslav
