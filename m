Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99497582884
	for <lists+live-patching@lfdr.de>; Wed, 27 Jul 2022 16:24:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233678AbiG0OYr (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 27 Jul 2022 10:24:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233565AbiG0OYq (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 27 Jul 2022 10:24:46 -0400
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F24E624BC8;
        Wed, 27 Jul 2022 07:24:45 -0700 (PDT)
Received: from [2603:3005:d05:2b00:6e0b:84ff:fee2:98bb] (helo=imladris.surriel.com)
        by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <riel@shelob.surriel.com>)
        id 1oGhxl-0008Bo-Ua;
        Wed, 27 Jul 2022 10:24:37 -0400
Date:   Wed, 27 Jul 2022 10:24:37 -0400
From:   Rik van Riel <riel@surriel.com>
To:     Josh Poimboeuf <jpoimboe@kernel.org>
Cc:     Petr Mladek <pmladek@suse.com>, linux-kernel@vger.kernel.org,
        live-patching@vger.kernel.org, kernel-team@fb.com,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Breno Leitao <leitao@debian.org>
Subject: [PATCH v4] livepatch: fix race between fork and KLP transition
Message-ID: <20220727102437.34530586@imladris.surriel.com>
In-Reply-To: <20220727001040.vlqnnb4a3um46746@treble>
References: <20220720121023.043738bb@imladris.surriel.com>
        <YtrCqMLUqJlcoqIo@alley>
        <20220722150106.683f3704@imladris.surriel.com>
        <Yt6bZo5ztnVSjLLC@alley>
        <20220725094919.52bcde19@imladris.surriel.com>
        <20220727001040.vlqnnb4a3um46746@treble>
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.31; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: riel@shelob.surriel.com
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

v4: address changelog comments by Josh (thank you)

---8<---
When a KLP fails to apply, klp_reverse_transition will clear the
TIF_PATCH_PENDING flag on all tasks, except for newly created tasks
which are not on the task list yet. A similar race is possible
for normal (forward) transitions, where TIF_PATCH_PENDING gets
copied to the child, then later cleared in the parent.

Meanwhile, fork will copy over the TIF_PATCH_PENDING flag from the
parent to the child early on, in dup_task_struct -> setup_thread_stack.

Much later, klp_copy_process will set child->patch_state to match
that of the parent.

However, the parent's patch_state may have been changed by KLP loading
or unloading since it was initially copied over into the child.

This results in the KLP code occasionally hitting this warning in
klp_complete_transition:

        for_each_process_thread(g, task) {
                WARN_ON_ONCE(test_tsk_thread_flag(task, TIF_PATCH_PENDING));
                task->patch_state = KLP_UNDEFINED;
        }

Set, or clear, the TIF_PATCH_PENDING flag in the child task
depending on whether or not it is needed at the time
klp_copy_process is called, at a point in copy_process where the
tasklist_lock is held exclusively, preventing races with the KLP
code.

The KLP code does have a few places where the state is changed
without the tasklist_lock held, but those should not cause
problems because klp_update_patch_state(current) cannot be
called while the current task is in the middle of fork,
klp_check_and_switch_task() which is called under the pi_lock,
which prevents rescheduling, and manipulation of the patch
state of idle tasks, which do not fork.

This should prevent this warning from triggering again in the
future, and close the race for both normal and reverse transitions.

Signed-off-by: Rik van Riel <riel@surriel.com>
Reported-by: Breno Leitao <leitao@debian.org>
Reviewed-by: Petr Mladek <pmladek@suse.com>
Acked-by: Josh Poimboeuf <jpoimboe@kernel.org>
Fixes: d83a7cb375ee ("livepatch: change to a per-task consistency model")
Cc: stable@kernel.org
---
 kernel/livepatch/transition.c | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/kernel/livepatch/transition.c b/kernel/livepatch/transition.c
index 5d03a2ad1066..30187b1d8275 100644
--- a/kernel/livepatch/transition.c
+++ b/kernel/livepatch/transition.c
@@ -610,9 +610,23 @@ void klp_reverse_transition(void)
 /* Called from copy_process() during fork */
 void klp_copy_process(struct task_struct *child)
 {
-	child->patch_state = current->patch_state;
 
-	/* TIF_PATCH_PENDING gets copied in setup_thread_stack() */
+	/*
+	 * The parent process may have gone through a KLP transition since
+	 * the thread flag was copied in setup_thread_stack earlier. Bring
+	 * the task flag up to date with the parent here.
+	 *
+	 * The operation is serialized against all klp_*_transition()
+	 * operations by the tasklist_lock. The only exception is
+	 * klp_update_patch_state(current), but we cannot race with
+	 * that because we are current.
+	 */
+	if (test_tsk_thread_flag(current, TIF_PATCH_PENDING))
+		set_tsk_thread_flag(child, TIF_PATCH_PENDING);
+	else
+		clear_tsk_thread_flag(child, TIF_PATCH_PENDING);
+
+	child->patch_state = current->patch_state;
 }
 
 /*
-- 
2.35.1

