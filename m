Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F299734D119
	for <lists+live-patching@lfdr.de>; Mon, 29 Mar 2021 15:28:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229674AbhC2N2Y (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 29 Mar 2021 09:28:24 -0400
Received: from mx2.suse.de ([195.135.220.15]:46022 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231319AbhC2N2S (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Mon, 29 Mar 2021 09:28:18 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 1353CB32B;
        Mon, 29 Mar 2021 13:28:17 +0000 (UTC)
From:   Miroslav Benes <mbenes@suse.cz>
To:     jpoimboe@redhat.com, jikos@kernel.org, pmladek@suse.com,
        joe.lawrence@redhat.com
Cc:     live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        axboe@kernel.dk, Miroslav Benes <mbenes@suse.cz>
Subject: [PATCH v2] livepatch: Replace the fake signal sending with TIF_NOTIFY_SIGNAL infrastructure
Date:   Mon, 29 Mar 2021 15:28:15 +0200
Message-Id: <20210329132815.10035-1-mbenes@suse.cz>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Livepatch sends a fake signal to all remaining blocking tasks of a
running transition after a set period of time. It uses TIF_SIGPENDING
flag for the purpose. Commit 12db8b690010 ("entry: Add support for
TIF_NOTIFY_SIGNAL") added a generic infrastructure to achieve the same.
Replace our bespoke solution with the generic one.

Reviewed-by: Jens Axboe <axboe@kernel.dk>
Reviewed-by: Petr Mladek <pmladek@suse.com>
Signed-off-by: Miroslav Benes <mbenes@suse.cz>
---
v2:
- #include from kernel/signal.c removed [Petr]

 kernel/livepatch/transition.c | 5 ++---
 kernel/signal.c               | 4 +---
 2 files changed, 3 insertions(+), 6 deletions(-)

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
-			spin_lock_irq(&task->sighand->siglock);
-			signal_wake_up(task, 0);
-			spin_unlock_irq(&task->sighand->siglock);
+			set_notify_signal(task);
 		}
 	}
 	read_unlock(&tasklist_lock);
diff --git a/kernel/signal.c b/kernel/signal.c
index f2a1b898da29..604290a8ca89 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -43,7 +43,6 @@
 #include <linux/cn_proc.h>
 #include <linux/compiler.h>
 #include <linux/posix-timers.h>
-#include <linux/livepatch.h>
 #include <linux/cgroup.h>
 #include <linux/audit.h>
 
@@ -181,8 +180,7 @@ void recalc_sigpending_and_wake(struct task_struct *t)
 
 void recalc_sigpending(void)
 {
-	if (!recalc_sigpending_tsk(current) && !freezing(current) &&
-	    !klp_patch_pending(current))
+	if (!recalc_sigpending_tsk(current) && !freezing(current))
 		clear_thread_flag(TIF_SIGPENDING);
 
 }
-- 
2.30.2

