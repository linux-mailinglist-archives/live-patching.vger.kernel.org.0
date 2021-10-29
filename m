Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CDF743FD96
	for <lists+live-patching@lfdr.de>; Fri, 29 Oct 2021 15:52:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230521AbhJ2NzG (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 29 Oct 2021 09:55:06 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:48224 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230252AbhJ2NzG (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 29 Oct 2021 09:55:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635515557;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7iYH28BKY2HkWtqeMm9u+LMJde+0Yure84miKLDU7nc=;
        b=JEADapTx9zoOfzWsr+RWPwajtnOPgAhWA9HT9s90sU9pye1lpuO92492FxbR6NX2v9BCPH
        F6knxXTF8Axf7CXSMPMjzwk63eclLx+UvEbO1HmRI0Ln0gIttZx3Sv8W+oPTI1+XGwPJlb
        9+XNeDWibGCV+NNSZXiKN5vTVfGzeLg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-58-j-gKQqqgM8GU8CtRnIYvHw-1; Fri, 29 Oct 2021 09:52:33 -0400
X-MC-Unique: j-gKQqqgM8GU8CtRnIYvHw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 60779100C660;
        Fri, 29 Oct 2021 13:52:32 +0000 (UTC)
Received: from redhat.com (unknown [10.22.16.72])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B5F425DA60;
        Fri, 29 Oct 2021 13:51:56 +0000 (UTC)
Date:   Fri, 29 Oct 2021 09:51:54 -0400
From:   Joe Lawrence <joe.lawrence@redhat.com>
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>, live-patching@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Chamberlain <mcgrof@kernel.org>
Subject: Re: [PATCH 0/3] livepatch: cleanup kpl_patch kobject release
Message-ID: <YXv8eoPKXk5gpsa7@redhat.com>
References: <20211028125734.3134176-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211028125734.3134176-1-ming.lei@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Thu, Oct 28, 2021 at 08:57:31PM +0800, Ming Lei wrote:
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

Hi Ming,

I gave the patchset a spin on top of linus tree @ 1fc596a56b33 and ended
up with a stuck task:

Test
----
Enable the livepatch selftests:
  $ grep CONFIG_TEST_LIVEPATCH .config
  CONFIG_TEST_LIVEPATCH=m

Run a continuous kernel build in the background:
  $ while (true); do make clean && make -j$(nproc); done

While continuously executing the selftests:
  $ while (true); do make -C tools/testing/selftests/livepatch/ run_tests; done

Results
-------
...
[  366.862278] ===== TEST: multiple target modules =====
[  366.877470] % modprobe test_klp_callbacks_busy block_transition=N
[  366.890468] test_klp_callbacks_busy: test_klp_callbacks_busy_init
[  366.897280] test_klp_callbacks_busy: busymod_work_func enter
[  366.903602] test_klp_callbacks_busy: busymod_work_func exit
[  366.920311] % modprobe test_klp_callbacks_demo
[  366.931737] livepatch: enabling patch 'test_klp_callbacks_demo'
[  366.938466] test_klp_callbacks_demo: pre_patch_callback: vmlinux
[  366.945173] test_klp_callbacks_demo: pre_patch_callback: test_klp_callbacks_busy -> [MODULE_STATE_LIVE] Normal state
[  366.959322] livepatch: 'test_klp_callbacks_demo': starting patching transition
[  369.699278] test_klp_callbacks_demo: post_patch_callback: vmlinux
[  369.706118] test_klp_callbacks_demo: post_patch_callback: test_klp_callbacks_busy -> [MODULE_STATE_LIVE] Normal state
[  369.718079] livepatch: 'test_klp_callbacks_demo': patching complete
[  369.786485] % modprobe test_klp_callbacks_mod
[  369.806918] livepatch: applying patch 'test_klp_callbacks_demo' to loading module 'test_klp_callbacks_mod'
[  369.818005] test_klp_callbacks_demo: pre_patch_callback: test_klp_callbacks_mod -> [MODULE_STATE_COMING] Full formed, running module_init
[  369.831826] test_klp_callbacks_demo: post_patch_callback: test_klp_callbacks_mod -> [MODULE_STATE_COMING] Full formed, running module_init
[  369.846259] test_klp_callbacks_mod: test_klp_callbacks_mod_init
[  369.865115] % rmmod test_klp_callbacks_mod
[  369.881713] test_klp_callbacks_mod: test_klp_callbacks_mod_exit
[  369.888790] test_klp_callbacks_demo: pre_unpatch_callback: test_klp_callbacks_mod -> [MODULE_STATE_GOING] Going away
[  369.900583] livepatch: reverting patch 'test_klp_callbacks_demo' on unloading module 'test_klp_callbacks_mod'
[  369.911696] test_klp_callbacks_demo: post_unpatch_callback: test_klp_callbacks_mod -> [MODULE_STATE_GOING] Going away
[  369.946082] % echo 0 > /sys/kernel/livepatch/test_klp_callbacks_demo/enabled
[  369.954544] test_klp_callbacks_demo: pre_unpatch_callback: vmlinux
[  369.962117] test_klp_callbacks_demo: pre_unpatch_callback: test_klp_callbacks_busy -> [MODULE_STATE_LIVE] Normal state
[  369.974099] livepatch: 'test_klp_callbacks_demo': starting unpatching transition
[  370.022730] test_klp_callbacks_demo: post_unpatch_callback: vmlinux
[  370.029763] test_klp_callbacks_demo: post_unpatch_callback: test_klp_callbacks_busy -> [MODULE_STATE_LIVE] Normal state
[  370.042065] livepatch: 'test_klp_callbacks_demo': unpatching complete
[  494.498310] INFO: task test-callbacks.:10039 blocked for more than 122 seconds.
[  494.506489]       Tainted: G              K   5.15.0-rc7+ #2
[  494.512834] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  494.521601] task:test-callbacks. state:D stack:    0 pid:10039 ppid: 10036 flags:0x00004000
[  494.530958] Call Trace:
[  494.533706]  __schedule+0x200/0x540
[  494.537628]  schedule+0x44/0xa0
[  494.541161]  __kernfs_remove.part.0+0x21e/0x2a0
[  494.546251]  ? do_wait_intr_irq+0xa0/0xa0
[  494.550761]  kernfs_remove_by_name_ns+0x50/0x90
[  494.555852]  remove_files+0x2b/0x60
[  494.559783]  sysfs_remove_group+0x38/0x80
[  494.564300]  sysfs_remove_groups+0x29/0x40
[  494.568908]  __kobject_del+0x1b/0x80
[  494.572933]  kobject_cleanup+0x9c/0x130
[  494.577251]  enabled_store+0xdc/0x1a0
[  494.581379]  kernfs_fop_write_iter+0x11c/0x1b0
[  494.586374]  new_sync_write+0x11f/0x1b0
[  494.590690]  ? msr_build_context.constprop.0+0x5d/0xbe
[  494.596462]  vfs_write+0x1ce/0x260
[  494.600291]  ksys_write+0x5f/0xe0
[  494.604024]  do_syscall_64+0x3b/0x90
[  494.608049]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[  494.613719] RIP: 0033:0x7f66cd5aea37
[  494.617733] RSP: 002b:00007ffe6a5e16c8 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
[  494.626209] RAX: ffffffffffffffda RBX: 0000000000000002 RCX: 00007f66cd5aea37
[  494.634196] RDX: 0000000000000002 RSI: 0000562e8101ba60 RDI: 0000000000000001
[  494.642177] RBP: 0000562e8101ba60 R08: 0000000000000000 R09: 00007f66cd6634e0
[  494.650166] R10: 00007f66cd6633e0 R11: 0000000000000246 R12: 0000000000000002
[  494.658156] R13: 00007f66cd6a85a0 R14: 0000000000000002 R15: 00007f66cd6a87a0
...
[ 1600.420533] INFO: task test-callbacks.:10039 blocked for more than 1228 seconds.

Let me know if you have any questions about the tests.  If you look at
the "^%" prefixed kernel messages in the above log, you can get a rough
idea of the commands that the test ran.

Regards,

-- Joe

