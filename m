Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3CDC44579A
	for <lists+live-patching@lfdr.de>; Fri, 14 Jun 2019 10:34:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726598AbfFNIei (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 14 Jun 2019 04:34:38 -0400
Received: from mx2.suse.de ([195.135.220.15]:43676 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726259AbfFNIeh (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Fri, 14 Jun 2019 04:34:37 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 96AE4ADFA;
        Fri, 14 Jun 2019 08:34:35 +0000 (UTC)
Date:   Fri, 14 Jun 2019 10:34:35 +0200
From:   Petr Mladek <pmladek@suse.com>
To:     Joe Lawrence <joe.lawrence@redhat.com>
Cc:     Miroslav Benes <mbenes@suse.cz>, linux-kernel@vger.kernel.org,
        live-patching@vger.kernel.org, linux-kbuild@vger.kernel.org
Subject: Re: [PATCH v4 00/10] klp-convert livepatch build tooling
Message-ID: <20190614083435.uq3mk6mprbatysol@pathway.suse.cz>
References: <20190509143859.9050-1-joe.lawrence@redhat.com>
 <alpine.LSU.2.21.1906131451560.22698@pobox.suse.cz>
 <b1a627a4-3702-9689-6c03-0c2123c06a2d@redhat.com>
 <c9021573-11c6-b576-0aa6-97754c98a06e@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c9021573-11c6-b576-0aa6-97754c98a06e@redhat.com>
User-Agent: NeoMutt/20170912 (1.9.0)
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Thu 2019-06-13 16:48:02, Joe Lawrence wrote:
> On 6/13/19 9:15 AM, Joe Lawrence wrote:
> > On 6/13/19 9:00 AM, Miroslav Benes wrote:
> >> Hi Joe,
> >>
> >> first, I'm sorry for the lack of response so far.
> >>
> >> Maybe you've already noticed but the selftests fail. Well, at least in
> >> my VM. When test_klp_convert1.ko is loaded, the process is killed with
> >>
> >> [  518.041826] BUG: kernel NULL pointer dereference, address: 0000000000000000
> >> [  518.042816] #PF: supervisor read access in kernel mode
> >> [  518.043393] #PF: error_code(0x0000) - not-present page
> >> [  518.043981] PGD 0 P4D 0
> >> [  518.044185] Oops: 0000 [#1] SMP PTI
> >> [  518.044518] CPU: 2 PID: 2255 Comm: insmod Tainted: G           O  K   5.1.0-klp_convert_v4-193435-g67748576637e #2
> >> [  518.045784] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.12.1-0-ga5cab58-prebuilt.qemu.org 04/01/2014
> >> [  518.046940] RIP: 0010:test_klp_convert_init+0x1c/0x40 [test_klp_convert1]
> >> [  518.047611] Code: 1b a0 48 89 c6 e9 a8 c0 f4 e0 0f 1f 40 00 0f 1f 44 00 00 53 48 c7 c7 00 30 1b a0 e8 5e 33 f6 e0 85 c0 89 c3 74 04 89 d8 5b c3 <48> 8b 35 5d ef e4 5f 48 c7 c7 28 20 1b a0 e8 75 c0 f4 e0 e8 6c ff
> >> [  518.049779] RSP: 0018:ffffc90000f37cc8 EFLAGS: 00010246
> >> [  518.050243] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000027de0
> >> [  518.050922] RDX: 0000000000000000 RSI: 0000000000000006 RDI: ffff88807ab54f40
> >> [  518.051619] RBP: ffffffffa01b1080 R08: 0000000096efde7a R09: 0000000000000001
> >> [  518.052332] R10: 0000000000000000 R11: 0000000000000000 R12: 00000000ffffffff
> >> [  518.053012] R13: 0000000000000000 R14: ffff888078b55000 R15: ffffc90000f37ea0
> >> [  518.053714] FS:  00007febece1fb80(0000) GS:ffff88807d400000(0000) knlGS:0000000000000000
> >> [  518.054514] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> >> [  518.055078] CR2: 0000000000000000 CR3: 000000007a56a000 CR4: 00000000000006e0
> >> [  518.055818] Call Trace:
> >> [  518.056007]  do_one_initcall+0x6a/0x2da
> >> [  518.056340]  ? do_init_module+0x22/0x230
> >> [  518.056702]  ? rcu_read_lock_sched_held+0x96/0xa0
> >> [  518.057125]  ? kmem_cache_alloc_trace+0x284/0x2e0
> >> [  518.057493]  do_init_module+0x5a/0x230
> >> [  518.057900]  load_module+0x17bc/0x1f50
> >> [  518.058214]  ? __symbol_put+0x40/0x40
> >> [  518.058499]  ? vfs_read+0x12d/0x160
> >> [  518.058766]  __do_sys_finit_module+0x83/0xc0
> >> [  518.059122]  do_syscall_64+0x57/0x190
> >> [  518.059407]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
> >> ...
> >>
> >> It crashes right in test_klp_convert_init() when print_*() using
> >> supposed-to-be-converted symbols are called. I'll debug it next week. Can
> >> you reproduce it too?
> > 
> > Hey, thanks for the report..
> > 
> > I don't recall the tests crashing, but I had put this patchset on the
> > side for a few weeks now.  I'll try to fire up a VM and see what happens
> > today.
> > 
> 
> Hmm, I haven't been able to reproduce using my original base (Linux 5.1-rc6)
> or when rebased ontop of livepatching.git/master + 997a55f3fb6d("stacktrace: Unbreak stack_trace_save_tsk_reliable()")

I stared into the code a bit but I did not find any bug. Let's hope
that it was just some pre-vacation last minute mistake (system
inconsistency or so ;-)

Anyway, I am curious about one thing. I saw:

function __load_mod() {
	local mod="$1"; shift

	local msg="% modprobe $mod $*"
	log "${msg%% }"
	ret=$(modprobe "$mod" "$@" 2>&1)
	if [[ "$ret" != "" ]]; then
		die "$ret"
	fi

	# Wait for module in sysfs ...
	loop_until '[[ -e "/sys/module/$mod" ]]' ||
		die "failed to load module $mod"
}

Is the waiting for sysfs really necessary here?

Note that it is /sys/module and not /sys/kernel/livepatch/.

My understanding is that modprobe waits until the module succesfully
loaded. mod_sysfs_setup() is called before the module init callback.
Therefore the sysfs interface should be read before modprobe returns.
Do I miss something?

If it works different way then there might be some races because
mod_sysfs_setup() is called before the module is alive.

Best Regards,
Petr
