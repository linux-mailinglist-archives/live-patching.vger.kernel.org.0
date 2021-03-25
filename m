Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94D17348CF0
	for <lists+live-patching@lfdr.de>; Thu, 25 Mar 2021 10:31:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229871AbhCYJbJ (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 25 Mar 2021 05:31:09 -0400
Received: from mx2.suse.de ([195.135.220.15]:57434 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229781AbhCYJai (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Thu, 25 Mar 2021 05:30:38 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 1A2C7AA55;
        Thu, 25 Mar 2021 09:30:37 +0000 (UTC)
Date:   Thu, 25 Mar 2021 10:30:36 +0100 (CET)
From:   Miroslav Benes <mbenes@suse.cz>
To:     Joe Lawrence <joe.lawrence@redhat.com>
cc:     Dong Kai <dongkai11@huawei.com>, jpoimboe@redhat.com,
        jikos@kernel.org, pmladek@suse.com, axboe@kernel.dk,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] livepatch: klp_send_signal should treat PF_IO_WORKER
 like PF_KTHREAD
In-Reply-To: <cd701421-f2c6-56f6-5798-106bc9de0084@redhat.com>
Message-ID: <alpine.LSU.2.21.2103251026180.30447@pobox.suse.cz>
References: <20210325014836.40649-1-dongkai11@huawei.com> <cd701421-f2c6-56f6-5798-106bc9de0084@redhat.com>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

> (PF_KTHREAD | PF_IO_WORKER) is open coded in soo many places maybe this is a
> silly question, but...
> 
> If the livepatch code could use fake_signal_wake_up(), we could consolidate
> the pattern in klp_send_signals() with the one in freeze_task().  Then there
> would only one place for wake up / fake signal logic.
> 
> I don't fully understand the differences in the freeze_task() version, so I
> only pose this as a question and not v2 request.

The plan was to remove our live patching fake signal completely and use 
the new infrastructure Jens proposed in the past.

Something like

diff --git a/kernel/livepatch/transition.c b/kernel/livepatch/transition.c
index f6310f848f34..3a4beb9395c4 100644
--- a/kernel/livepatch/transition.c
+++ b/kernel/livepatch/transition.c
@@ -9,6 +9,7 @@
 
 #include <linux/cpu.h>
 #include <linux/stacktrace.h>
+#include <linux/tracehook.h>
 #include "core.h"
 #include "patch.h"
 #include "transition.h"
@@ -369,9 +370,7 @@ static void klp_send_signals(void)
                         * Send fake signal to all non-kthread tasks which are
                         * still not migrated.
                         */
-                       spin_lock_irq(&task->sighand->siglock);
-                       signal_wake_up(task, 0);
-                       spin_unlock_irq(&task->sighand->siglock);
+                       set_notify_signal(task);
                }
        }
        read_unlock(&tasklist_lock);
diff --git a/kernel/signal.c b/kernel/signal.c
index a15c584a0455..b7cf4eda8611 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -181,8 +181,7 @@ void recalc_sigpending_and_wake(struct task_struct *t)
 
 void recalc_sigpending(void)
 {
-       if (!recalc_sigpending_tsk(current) && !freezing(current) &&
-           !klp_patch_pending(current))
+       if (!recalc_sigpending_tsk(current) && !freezing(current))
                clear_thread_flag(TIF_SIGPENDING);
 
 }


Let me verify it still works and there are all the needed pieces merged 
for all the architectures we support (x86_64, ppc64le and s390x). I'll 
send a proper patch then.

Miroslav
