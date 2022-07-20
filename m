Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D73D357BB49
	for <lists+live-patching@lfdr.de>; Wed, 20 Jul 2022 18:21:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240966AbiGTQUm (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 20 Jul 2022 12:20:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232828AbiGTQUd (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 20 Jul 2022 12:20:33 -0400
X-Greylist: delayed 599 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 20 Jul 2022 09:20:31 PDT
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEBCF4504C;
        Wed, 20 Jul 2022 09:20:31 -0700 (PDT)
Received: from [2603:3005:d05:2b00:6e0b:84ff:fee2:98bb] (helo=imladris.surriel.com)
        by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <riel@shelob.surriel.com>)
        id 1oECHI-0005l4-So;
        Wed, 20 Jul 2022 12:10:24 -0400
Date:   Wed, 20 Jul 2022 12:10:23 -0400
From:   Rik van Riel <riel@surriel.com>
To:     linux-kernel@vger.kernel.org
Cc:     live-patching@vger.kernel.org, kernel-team@fb.com,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Breno Leitao <leitao@debian.org>
Subject: [PATCH,RFC] livepatch: fix race between fork and
 klp_reverse_transition
Message-ID: <20220720121023.043738bb@imladris.surriel.com>
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

When a KLP fails to apply, klp_reverse_transition will clear the
TIF_PATCH_PENDING flag on all tasks, except for newly created tasks
which are not on the task list yet.

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

This patch will set, or clear, the TIF_PATCH_PENDING flag in the child
process depending on whether or not it is needed at the time
klp_copy_process is called, at a point in copy_process where the
tasklist_lock is held exclusively, preventing races with the KLP
code.

This should prevent this warning from triggering again in the
future.

I have not yet figured out whether this would also help with races in
the other direction, where the child process fails to have TIF_PATCH_PENDING
set and somehow misses a transition, or whether the retries in
klp_try_complete_transition would catch that task and help it transition
later.

Signed-off-by: Rik van Riel <riel@surriel.com>
Reported-by: Breno Leitao <leitao@debian.org>
---
 kernel/livepatch/transition.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/kernel/livepatch/transition.c b/kernel/livepatch/transition.c
index 5d03a2ad1066..7a90ad5e9224 100644
--- a/kernel/livepatch/transition.c
+++ b/kernel/livepatch/transition.c
@@ -612,7 +612,15 @@ void klp_copy_process(struct task_struct *child)
 {
 	child->patch_state = current->patch_state;
 
-	/* TIF_PATCH_PENDING gets copied in setup_thread_stack() */
+	/*
+	 * The parent process may have gone through a KLP transition since
+	 * the thread flag was copied in setup_thread_stack earlier. Set
+	 * the flag according to whether this task needs a KLP transition.
+	 */
+	if (child->patch_state != klp_target_state)
+		set_tsk_thread_flag(child, TIF_PATCH_PENDING);
+	else
+		clear_tsk_thread_flag(child, TIF_PATCH_PENDING);
 }
 
 /*
-- 
2.35.1

