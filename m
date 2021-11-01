Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E778441EC2
	for <lists+live-patching@lfdr.de>; Mon,  1 Nov 2021 17:44:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232663AbhKAQql (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 1 Nov 2021 12:46:41 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:59130 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231303AbhKAQql (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 1 Nov 2021 12:46:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635785047;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=lLoWElTXOh81t0IzH0KVaO46+KcNaw/LEiHi/DUGW6c=;
        b=SM3fLgtfuawVhWIDFKIlXXssmifEUuanILYeNjyz19OlO79zZcVnnj/yedTKqT41lMLGcW
        GmnUs0GBoe06zQ5X/JEbHL9bIDa4/3a2YANyqUZpDchf9ADZ9wQrEh0q2VRPLa8dV1k4yA
        PHFHvlN4l3xytp/TrLdVfjrOLxb64Vo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-256-RhD7tEF8NY2uLvAsc4sknw-1; Mon, 01 Nov 2021 12:44:04 -0400
X-MC-Unique: RhD7tEF8NY2uLvAsc4sknw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3952B873099;
        Mon,  1 Nov 2021 16:44:03 +0000 (UTC)
Received: from redhat.com (unknown [10.22.16.72])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1117C57CAB;
        Mon,  1 Nov 2021 16:44:01 +0000 (UTC)
Date:   Mon, 1 Nov 2021 12:44:00 -0400
From:   Joe Lawrence <joe.lawrence@redhat.com>
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>, live-patching@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Chamberlain <mcgrof@kernel.org>
Subject: Re: [PATCH V3 0/3] livepatch: cleanup kpl_patch kobject release
Message-ID: <YYAZUDfIj/UpJWoi@redhat.com>
References: <20211101112548.3364086-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211101112548.3364086-1-ming.lei@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Mon, Nov 01, 2021 at 07:25:45PM +0800, Ming Lei wrote:
> Hello,
> 
> The 1st patch moves module_put() to release handler of klp_patch
> kobject.
> 
> The 2nd patch changes to free klp_patch and other kobjects without
> klp_mutex.
> 
> The 3rd patch switches to synchronous kobject release for klp_patch.
> 
> 
> V3:
> 	- one line fix on check of list_empty() in enabled_store(), 3/3
> 
> V2:
> 	- remove enabled attribute before deleting this klp_patch kobject,
> 	for avoiding deadlock in deleting me

Hi Ming,

Another interesting wedge (doesn't seem to happen w/o system load):

# different kernel tree build
$ while(true); do make clean && make -j$(nproc); done

vs.

# loop the basic tests
$ while(true); do ./tools/testing/selftests/livepatch/test-livepatch.sh || break; done
TEST: basic function patching ... ok
TEST: multiple livepatches ... ok
TEST: atomic replace livepatch ... ERROR: failed to unload module test_klp_livepatch (refcnt)

$ lsmod | grep test_klp
test_klp_atomic_replace    16384  1
test_klp_livepatch     16384  1

$ head /sys/kernel/livepatch/*/enabled
==> /sys/kernel/livepatch/test_klp_atomic_replace/enabled <==
1

==> /sys/kernel/livepatch/test_klp_livepatch/enabled <==
0

[  307.818060] livepatch: kernel.ftrace_enabled = 1
[  307.849759] ===== TEST: basic function patching =====
[  307.876520] % modprobe test_klp_livepatch
[  307.889014] test_klp_livepatch: tainting kernel with TAINT_LIVEPATCH
[  307.915450] livepatch: enabling patch 'test_klp_livepatch'
[  307.923991] livepatch: 'test_klp_livepatch': starting patching transition
[  308.768730] livepatch: 'test_klp_livepatch': patching complete
[  308.779476] % echo 0 > /sys/kernel/livepatch/test_klp_livepatch/enabled
[  308.787378] livepatch: 'test_klp_livepatch': starting unpatching transition
[  308.828968] livepatch: 'test_klp_livepatch': unpatching complete
[  308.838284] % rmmod test_klp_livepatch
[  308.921367] ===== TEST: multiple livepatches =====
[  308.936056] % modprobe test_klp_livepatch
[  308.968419] livepatch: enabling patch 'test_klp_livepatch'
[  308.976976] livepatch: 'test_klp_livepatch': starting patching transition
[  309.779754] livepatch: 'test_klp_livepatch': patching complete
[  309.827765] test_klp_livepatch: this has been live patched
[  309.853678] % modprobe test_klp_atomic_replace replace=0
[  309.887697] livepatch: enabling patch 'test_klp_atomic_replace'
[  309.897090] livepatch: 'test_klp_atomic_replace': starting patching transition
[  309.906310] livepatch: 'test_klp_atomic_replace': patching complete
[  309.919386] test_klp_livepatch: this has been live patched
[  309.928124] test_klp_atomic_replace: this has been live patched
[  309.935306] % echo 0 > /sys/kernel/livepatch/test_klp_atomic_replace/enabled
[  309.943882] livepatch: 'test_klp_atomic_replace': starting unpatching transition
[  310.842939] livepatch: 'test_klp_atomic_replace': unpatching complete
[  310.875590] % rmmod test_klp_atomic_replace
[  310.910489] test_klp_livepatch: this has been live patched
[  310.919444] % echo 0 > /sys/kernel/livepatch/test_klp_livepatch/enabled
[  310.927157] livepatch: 'test_klp_livepatch': starting unpatching transition
[  311.795931] livepatch: 'test_klp_livepatch': unpatching complete
[  311.858463] % rmmod test_klp_livepatch
[  311.941334] ===== TEST: atomic replace livepatch =====
[  311.959647] % modprobe test_klp_livepatch
[  311.992469] livepatch: enabling patch 'test_klp_livepatch'
[  312.001464] livepatch: 'test_klp_livepatch': starting patching transition
[  312.787758] livepatch: 'test_klp_livepatch': patching complete
[  312.854237] test_klp_livepatch: this has been live patched
[  312.872939] % modprobe test_klp_atomic_replace replace=1
[  312.926957] livepatch: enabling patch 'test_klp_atomic_replace'
[  312.936289] livepatch: 'test_klp_atomic_replace': starting patching transition
[  312.968876] livepatch: 'test_klp_atomic_replace': patching complete
[  312.975898] ------------[ cut here ]------------
[  312.981073] WARNING: CPU: 16 PID: 35260 at kernel/livepatch/core.c:996 __klp_enable_patch.cold+0xbd/0x132
[  312.991781] Modules linked in: test_klp_atomic_replace(K+) test_klp_livepatch(K) rfkill intel_rapl_msr intel_rapl_common sb_edac x86_pkg_]
[  313.060963] CPU: 16 PID: 35260 Comm: modprobe Kdump: loaded Tainted: G              K   5.15.0-rc7+ #1
[  313.071375] Hardware name: Dell Inc. PowerEdge T620/0MX4YF, BIOS 1.0.4 02/21/2012
[  313.079756] RIP: 0010:__klp_enable_patch.cold+0xbd/0x132
[  313.085718] Code: dc ff ff e8 2a d4 78 ff e9 a2 b1 78 ff e8 b0 d8 78 ff c6 85 80 00 00 00 01 48 89 df e8 91 d4 78 ff 48 8b 04 24 48 39 d8f
[  313.106703] RSP: 0018:ffffa99ac8e0fd68 EFLAGS: 00010216
[  313.112564] RAX: ffffffffc098d020 RBX: ffffa99ac8e0fd68 RCX: 0000000000000000
[  313.120554] RDX: ffffa99ac8e0fd68 RSI: ffffa99ac8e0fd68 RDI: ffffffffc098d020
[  313.128552] RBP: ffffffffc0a9d000 R08: ffffa99ac8e0fd68 R09: ffffa99ac8e0fd68
[  313.136545] R10: ffffa99ac8e0fb50 R11: ffffffffb45e5648 R12: 0000000000000000
[  313.144528] R13: ffffffffc0a9d070 R14: ffffffffc0a9cfe8 R15: ffffffffc0a9d2f8
[  313.152517] FS:  00007fa4a968e740(0000) GS:ffff8b469fc00000(0000) knlGS:0000000000000000
[  313.161576] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  313.168017] CR2: 00000000013fb008 CR3: 000000012b7da005 CR4: 00000000000606e0
[  313.176008] Call Trace:
[  313.178765]  klp_enable_patch+0x2d7/0x340
[  313.183272]  ? livepatch_meminfo_proc_show+0x30/0x30 [test_klp_atomic_replace]
[  313.191367]  do_one_initcall+0x44/0x1d0
[  313.195685]  ? load_module+0xab3/0xb60
[  313.199899]  ? __cond_resched+0x16/0x40
[  313.204207]  ? kmem_cache_alloc_trace+0x44/0x3d0
[  313.209391]  do_init_module+0x5c/0x270
[  313.213600]  __do_sys_finit_module+0xae/0x110
[  313.218490]  do_syscall_64+0x3b/0x90
[  313.222505]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[  313.228167] RIP: 0033:0x7fa4a979e0cd
[  313.232180] Code: 5b 41 5c c3 66 0f 1f 84 00 00 00 00 00 f3 0f 1e fa 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 088
[  313.253166] RSP: 002b:00007fff515d0488 EFLAGS: 00000246 ORIG_RAX: 0000000000000139
[  313.261658] RAX: ffffffffffffffda RBX: 0000562e0d532900 RCX: 00007fa4a979e0cd
[  313.269654] RDX: 0000000000000000 RSI: 0000562e0d532d90 RDI: 0000000000000003
[  313.277648] RBP: 0000000000040000 R08: 0000000000000000 R09: 00007fff00000002
[  313.285628] R10: 0000000000000003 R11: 0000000000000246 R12: 0000562e0d532d90
[  313.293617] R13: 0000562e0d532b40 R14: 0000562e0d532900 R15: 0000562e0d532db0
[  313.301612] ---[ end trace d4ec8b943e8d24cc ]---
[  313.315675] test_klp_atomic_replace: this has been live patched
[  375.850221] ERROR: failed to unload module test_klp_livepatch (refcnt)

 949 static int __klp_enable_patch(struct klp_patch *patch)
 ...
 993         klp_start_transition();
 994         patch->enabled = true;
 995         klp_try_complete_transition(&unused);
 996         WARN_ON_ONCE(!list_empty(&unused));
 
-- Joe

