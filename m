Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 331C941C8DC
	for <lists+live-patching@lfdr.de>; Wed, 29 Sep 2021 17:58:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229712AbhI2P7o (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 29 Sep 2021 11:59:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344077AbhI2P7m (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 29 Sep 2021 11:59:42 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C084DC061765;
        Wed, 29 Sep 2021 08:58:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Content-Type:MIME-Version:References:
        Subject:Cc:To:From:Date:Message-ID:Sender:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:In-Reply-To;
        bh=vDJJW23T5FKoZLJc2aYvdwTUBF3cwv1FnD/IF8+PH5c=; b=E82XpR3QsLp4AIONvwejNljYbf
        dFnFW37bl7GPxYbwroZBN1Q0tiL637Fy5z5IoPdg0C8aJTIgwSsoKEudMLiXTCA5LLKApHgVFKlbH
        FWvPaYAtxBNMdEgGijrFoBv5Sds/iqEXctxSa5jrhRUnvoz+06lNvaBuOBcB9ZtyOnaXskVb7FqMH
        DbDH0vXewN+yJasg8wezGB/j85Lviw03ymt6gqetzxjzt/0uwPhbB9EavmYIfbwqw4xsXcDWtCyRE
        FbQvLZhSaLkSZRf4Y29icoNm9Xx6RCDMa/gWwaCtokufneP7DfMObODDHSysoapbpluiK48i2umrN
        18LMc5Dg==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mVbxi-006jon-Mx; Wed, 29 Sep 2021 15:57:38 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 3DE09300953;
        Wed, 29 Sep 2021 17:57:37 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 0)
        id 233FD2C78F4FA; Wed, 29 Sep 2021 17:57:37 +0200 (CEST)
Message-ID: <20210929152428.709906138@infradead.org>
User-Agent: quilt/0.66
Date:   Wed, 29 Sep 2021 17:17:26 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     gor@linux.ibm.com, jpoimboe@redhat.com, jikos@kernel.org,
        mbenes@suse.cz, pmladek@suse.com, mingo@kernel.org
Cc:     linux-kernel@vger.kernel.org, peterz@infradead.org,
        joe.lawrence@redhat.com, fweisbec@gmail.com, tglx@linutronix.de,
        hca@linux.ibm.com, svens@linux.ibm.com, sumanthk@linux.ibm.com,
        live-patching@vger.kernel.org, paulmck@kernel.org,
        rostedt@goodmis.org, x86@kernel.org
Subject: [PATCH v2 03/11] sched,livepatch: Use task_call_func()
References: <20210929151723.162004989@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Instead of frobbing around with scheduler internals, use the shiny new
task_call_func() interface.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
---
 kernel/livepatch/transition.c |   90 ++++++++++++++++++++----------------------
 1 file changed, 44 insertions(+), 46 deletions(-)

--- a/kernel/livepatch/transition.c
+++ b/kernel/livepatch/transition.c
@@ -13,7 +13,6 @@
 #include "core.h"
 #include "patch.h"
 #include "transition.h"
-#include "../sched/sched.h"
 
 #define MAX_STACK_ENTRIES  100
 #define STACK_ERR_BUF_SIZE 128
@@ -240,7 +239,7 @@ static int klp_check_stack_func(struct k
  * Determine whether it's safe to transition the task to the target patch state
  * by looking for any to-be-patched or to-be-unpatched functions on its stack.
  */
-static int klp_check_stack(struct task_struct *task, char *err_buf)
+static int klp_check_stack(struct task_struct *task, const char **oldname)
 {
 	static unsigned long entries[MAX_STACK_ENTRIES];
 	struct klp_object *obj;
@@ -248,12 +247,8 @@ static int klp_check_stack(struct task_s
 	int ret, nr_entries;
 
 	ret = stack_trace_save_tsk_reliable(task, entries, ARRAY_SIZE(entries));
-	if (ret < 0) {
-		snprintf(err_buf, STACK_ERR_BUF_SIZE,
-			 "%s: %s:%d has an unreliable stack\n",
-			 __func__, task->comm, task->pid);
-		return ret;
-	}
+	if (ret < 0)
+		return -EINVAL;
 	nr_entries = ret;
 
 	klp_for_each_object(klp_transition_patch, obj) {
@@ -262,11 +257,8 @@ static int klp_check_stack(struct task_s
 		klp_for_each_func(obj, func) {
 			ret = klp_check_stack_func(func, entries, nr_entries);
 			if (ret) {
-				snprintf(err_buf, STACK_ERR_BUF_SIZE,
-					 "%s: %s:%d is sleeping on function %s\n",
-					 __func__, task->comm, task->pid,
-					 func->old_name);
-				return ret;
+				*oldname = func->old_name;
+				return -EADDRINUSE;
 			}
 		}
 	}
@@ -274,6 +266,22 @@ static int klp_check_stack(struct task_s
 	return 0;
 }
 
+static int klp_check_and_switch_task(struct task_struct *task, void *arg)
+{
+	int ret;
+
+	if (task_curr(task))
+		return -EBUSY;
+
+	ret = klp_check_stack(task, arg);
+	if (ret)
+		return ret;
+
+	clear_tsk_thread_flag(task, TIF_PATCH_PENDING);
+	task->patch_state = klp_target_state;
+	return 0;
+}
+
 /*
  * Try to safely switch a task to the target patch state.  If it's currently
  * running, or it's sleeping on a to-be-patched or to-be-unpatched function, or
@@ -281,13 +289,8 @@ static int klp_check_stack(struct task_s
  */
 static bool klp_try_switch_task(struct task_struct *task)
 {
-	static char err_buf[STACK_ERR_BUF_SIZE];
-	struct rq *rq;
-	struct rq_flags flags;
+	const char *old_name;
 	int ret;
-	bool success = false;
-
-	err_buf[0] = '\0';
 
 	/* check if this task has already switched over */
 	if (task->patch_state == klp_target_state)
@@ -305,36 +308,31 @@ static bool klp_try_switch_task(struct t
 	 * functions.  If all goes well, switch the task to the target patch
 	 * state.
 	 */
-	rq = task_rq_lock(task, &flags);
+	ret = task_call_func(task, klp_check_and_switch_task, &old_name);
+	switch (ret) {
+	case 0:		/* success */
+		break;
 
-	if (task_running(rq, task) && task != current) {
-		snprintf(err_buf, STACK_ERR_BUF_SIZE,
-			 "%s: %s:%d is running\n", __func__, task->comm,
-			 task->pid);
-		goto done;
+	case -EBUSY:	/* klp_check_and_switch_task() */
+		pr_debug("%s: %s:%d is running\n",
+			 __func__, task->comm, task->pid);
+		break;
+	case -EINVAL:	/* klp_check_and_switch_task() */
+		pr_debug("%s: %s:%d has an unreliable stack\n",
+			 __func__, task->comm, task->pid);
+		break;
+	case -EADDRINUSE: /* klp_check_and_switch_task() */
+		pr_debug("%s: %s:%d is sleeping on function %s\n",
+			 __func__, task->comm, task->pid, old_name);
+		break;
+
+	default:
+		pr_debug("%s: Unknown error code (%d) when trying to switch %s:%d\n",
+			 __func__, ret, task->comm, task->pid);
+		break;
 	}
 
-	ret = klp_check_stack(task, err_buf);
-	if (ret)
-		goto done;
-
-	success = true;
-
-	clear_tsk_thread_flag(task, TIF_PATCH_PENDING);
-	task->patch_state = klp_target_state;
-
-done:
-	task_rq_unlock(rq, task, &flags);
-
-	/*
-	 * Due to console deadlock issues, pr_debug() can't be used while
-	 * holding the task rq lock.  Instead we have to use a temporary buffer
-	 * and print the debug message after releasing the lock.
-	 */
-	if (err_buf[0] != '\0')
-		pr_debug("%s", err_buf);
-
-	return success;
+	return !ret;
 }
 
 /*


