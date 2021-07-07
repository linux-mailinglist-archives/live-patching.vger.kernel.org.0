Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 877D63BE84F
	for <lists+live-patching@lfdr.de>; Wed,  7 Jul 2021 14:50:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231765AbhGGMwf (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 7 Jul 2021 08:52:35 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:65064 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231383AbhGGMwe (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 7 Jul 2021 08:52:34 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 167CY4LQ080304;
        Wed, 7 Jul 2021 08:49:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : mime-version : content-type; s=pp1;
 bh=gKtpeRMJEm+77yyfTj9L2Usx71ZqL3rAulVDbToGx+o=;
 b=DOzDIQ4pjIe2m63swdIPIGE5YAYyGtrMcX+plq/s+B+QQh+U4b8PE+WkuoJ4Q76YyPfN
 0kgM8AjZAYBB2ojwJjau09/qFOOfLf5UJeaAjfPyM9xrAZxfCY31n661h6fwbTIwwJ91
 3YWR/R3V789ipPU7EkrQaKmJY3RfaqWyausqfpZ2LaUSzhi0pH6v6OLVDJu6v5QMfH+I
 DPU+yHnG1dnMw4jbrZfKvhiwGW7O/X2UrvXtM/y8SxKwIW7wIk9IcYgspvu3k3C/y+Cd
 LhMaOUhjzG5G6lTJ4iJaDFRjiiN5d8oelwayveGMHEAnRJIH4dxG+nx6PvurgwDyXGRa Rg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39mc161eya-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 07 Jul 2021 08:49:48 -0400
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 167CaI72090035;
        Wed, 7 Jul 2021 08:49:48 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39mc161exr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 07 Jul 2021 08:49:48 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 167ClJds029650;
        Wed, 7 Jul 2021 12:49:46 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma04ams.nl.ibm.com with ESMTP id 39jfh8srpr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 07 Jul 2021 12:49:46 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 167ClndO29098484
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 7 Jul 2021 12:47:49 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 65EF24204B;
        Wed,  7 Jul 2021 12:49:43 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CE42542041;
        Wed,  7 Jul 2021 12:49:42 +0000 (GMT)
Received: from localhost (unknown [9.171.25.238])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Wed,  7 Jul 2021 12:49:42 +0000 (GMT)
Date:   Wed, 7 Jul 2021 14:49:41 +0200
From:   Vasily Gorbik <gor@linux.ibm.com>
To:     Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>
Cc:     Joe Lawrence <joe.lawrence@redhat.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Sumanth Korikkar <sumanthk@linux.ibm.com>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RFC PATCH] livepatch: Speed up transition retries
Message-ID: <patch.git-3127eb42c636.your-ad-here.call-01625661963-ext-4010@work.hours>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-Patchwork-Bot: notify
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: -1YjJE9Qg-Cux2EQbapppd3tBbEmvGIv
X-Proofpoint-GUID: PCLPGIHlsc-88_vMkNw7pZiJo_4nUjtI
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-07_06:2021-07-06,2021-07-07 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 bulkscore=0 lowpriorityscore=0 adultscore=0 malwarescore=0 mlxlogscore=999
 phishscore=0 impostorscore=0 mlxscore=0 spamscore=0 clxscore=1015
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107070075
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

That's just a racy hack for now for demonstration purposes.

On a s390 system with large amount of cpus
klp_try_complete_transition() often cannot be "complete" from the first
attempt. klp_try_complete_transition() schedules itself as delayed work
after a second delay. This accumulates to significant amount of time when
there are large number of livepatching transitions.

This patch tries to minimize this delay to counting processes which still
need to be transitioned and then scheduling
klp_try_complete_transition() right away.

For s390 LPAR with 128 cpu this reduces livepatch kselftest run time
from
real    1m11.837s
user    0m0.603s
sys     0m10.940s

to
real    0m14.550s
user    0m0.420s
sys     0m5.779s

And qa_test_klp run time from
real    5m15.950s
user    0m34.447s
sys     15m11.345s

to
real    3m51.987s
user    0m27.074s
sys     9m37.301s

Would smth like that be useful for production use cases?
Any ideas how to approach that more gracefully?

Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
---
 kernel/livepatch/transition.c | 41 +++++++++++++++++++++++++----------
 1 file changed, 30 insertions(+), 11 deletions(-)

diff --git a/kernel/livepatch/transition.c b/kernel/livepatch/transition.c
index 793eba46e970..fc4bb7a4a116 100644
--- a/kernel/livepatch/transition.c
+++ b/kernel/livepatch/transition.c
@@ -26,6 +26,8 @@ static int klp_target_state = KLP_UNDEFINED;
 
 static unsigned int klp_signals_cnt;
 
+static atomic_t klp_procs;
+
 /*
  * This work can be performed periodically to finish patching or unpatching any
  * "straggler" tasks which failed to transition in the first attempt.
@@ -181,8 +183,15 @@ void klp_update_patch_state(struct task_struct *task)
 	 *    of func->transition, if klp_ftrace_handler() is called later on
 	 *    the same CPU.  See __klp_disable_patch().
 	 */
-	if (test_and_clear_tsk_thread_flag(task, TIF_PATCH_PENDING))
+	if (test_and_clear_tsk_thread_flag(task, TIF_PATCH_PENDING)) {
 		task->patch_state = READ_ONCE(klp_target_state);
+		if (atomic_read(&klp_procs) == 0)
+			pr_err("klp_procs misaccounting\n");
+		else if (atomic_sub_return(1, &klp_procs) == 0) {
+			if (delayed_work_pending(&klp_transition_work))
+				mod_delayed_work(system_wq, &klp_transition_work, 0);
+		}
+	}
 
 	preempt_enable_notrace();
 }
@@ -320,7 +329,8 @@ static bool klp_try_switch_task(struct task_struct *task)
 
 	success = true;
 
-	clear_tsk_thread_flag(task, TIF_PATCH_PENDING);
+	if (test_and_clear_tsk_thread_flag(task, TIF_PATCH_PENDING))
+		atomic_sub(1, &klp_procs);
 	task->patch_state = klp_target_state;
 
 done:
@@ -402,11 +412,6 @@ void klp_try_complete_transition(void)
 	 * Usually this will transition most (or all) of the tasks on a system
 	 * unless the patch includes changes to a very common function.
 	 */
-	read_lock(&tasklist_lock);
-	for_each_process_thread(g, task)
-		if (!klp_try_switch_task(task))
-			complete = false;
-	read_unlock(&tasklist_lock);
 
 	/*
 	 * Ditto for the idle "swapper" tasks.
@@ -424,10 +429,17 @@ void klp_try_complete_transition(void)
 			/* offline idle tasks can be switched immediately */
 			clear_tsk_thread_flag(task, TIF_PATCH_PENDING);
 			task->patch_state = klp_target_state;
+			atomic_sub(1, &klp_procs);
 		}
 	}
 	put_online_cpus();
 
+	read_lock(&tasklist_lock);
+	for_each_process_thread(g, task)
+		if (!klp_try_switch_task(task))
+			complete = false;
+	read_unlock(&tasklist_lock);
+
 	if (!complete) {
 		if (klp_signals_cnt && !(klp_signals_cnt % SIGNALS_TIMEOUT))
 			klp_send_signals();
@@ -438,8 +450,8 @@ void klp_try_complete_transition(void)
 		 * later and/or wait for other methods like kernel exit
 		 * switching.
 		 */
-		schedule_delayed_work(&klp_transition_work,
-				      round_jiffies_relative(HZ));
+		schedule_delayed_work(&klp_transition_work, atomic_read(&klp_procs) ?
+				      round_jiffies_relative(HZ) : 0);
 		return;
 	}
 
@@ -473,6 +485,7 @@ void klp_start_transition(void)
 		  klp_transition_patch->mod->name,
 		  klp_target_state == KLP_PATCHED ? "patching" : "unpatching");
 
+	atomic_set(&klp_procs, 0);
 	/*
 	 * Mark all normal tasks as needing a patch state update.  They'll
 	 * switch either in klp_try_complete_transition() or as they exit the
@@ -480,8 +493,10 @@ void klp_start_transition(void)
 	 */
 	read_lock(&tasklist_lock);
 	for_each_process_thread(g, task)
-		if (task->patch_state != klp_target_state)
+		if (task->patch_state != klp_target_state) {
 			set_tsk_thread_flag(task, TIF_PATCH_PENDING);
+			atomic_inc(&klp_procs);
+		}
 	read_unlock(&tasklist_lock);
 
 	/*
@@ -491,8 +506,10 @@ void klp_start_transition(void)
 	 */
 	for_each_possible_cpu(cpu) {
 		task = idle_task(cpu);
-		if (task->patch_state != klp_target_state)
+		if (task->patch_state != klp_target_state) {
 			set_tsk_thread_flag(task, TIF_PATCH_PENDING);
+			atomic_inc(&klp_procs);
+		}
 	}
 
 	klp_signals_cnt = 0;
@@ -614,6 +631,8 @@ void klp_reverse_transition(void)
 void klp_copy_process(struct task_struct *child)
 {
 	child->patch_state = current->patch_state;
+	if (child->patch_state != klp_target_state)
+		atomic_add(1, &klp_procs);
 
 	/* TIF_PATCH_PENDING gets copied in setup_thread_stack() */
 }
-- 
2.25.4
