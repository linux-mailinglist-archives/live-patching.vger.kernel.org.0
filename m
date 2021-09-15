Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99ED840C743
	for <lists+live-patching@lfdr.de>; Wed, 15 Sep 2021 16:18:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238013AbhIOOT7 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 15 Sep 2021 10:19:59 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:42948 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S237991AbhIOOTr (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 15 Sep 2021 10:19:47 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id 18FE5GDm004178;
        Wed, 15 Sep 2021 10:18:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : mime-version : content-type; s=pp1;
 bh=vJ04kTE5mt6HHs9cYDzrTl2A5jl6K64BO6ltCe/R7lg=;
 b=pmlCH8sKXgb8CwNo4YNFnr2S+5nZpS58Kx4VaojLj4UYIONF61yV+3KzV8VEdBtSNmEu
 cJ+XqkSJbh/70VJ8xbRbxBOYBYrpSGCCbtJgCn1IP993hHkiXgUzxJ2WW+7ZNt0K7wRF
 gwUcJ3dTAZTASgKbUO9G+ywD305Gd2Gn0tGabW+OF7W/jtQjm+krtpC/idV5fHyRAFbO
 nREwfpg9diPLCWkR9IEp5AO5q7/Vt0ZgyaRpcrYwWBc+Dd0EZWzcK4ojFZubTMRHWfux
 LNEjP4/dTpYbq4T5UGL5DE6UGvcwzqa0aMbveSGF4WKE+S7ZYblyFofsuUlwe/WVIMlC vw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3b3j9p09jm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 15 Sep 2021 10:18:10 -0400
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 18FEA060023719;
        Wed, 15 Sep 2021 10:18:10 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3b3j9p09he-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 15 Sep 2021 10:18:09 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 18FE8RM8025422;
        Wed, 15 Sep 2021 14:18:08 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma06ams.nl.ibm.com with ESMTP id 3b0kqk06y2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 15 Sep 2021 14:18:08 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 18FEI4fg24445212
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Sep 2021 14:18:04 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3CEB611C071;
        Wed, 15 Sep 2021 14:18:04 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 69A7411C04A;
        Wed, 15 Sep 2021 14:18:03 +0000 (GMT)
Received: from localhost (unknown [9.171.18.94])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Wed, 15 Sep 2021 14:18:03 +0000 (GMT)
Date:   Wed, 15 Sep 2021 16:18:01 +0200
From:   Vasily Gorbik <gor@linux.ibm.com>
To:     Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>
Cc:     Joe Lawrence <joe.lawrence@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Heiko Carstens <hca@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Sumanth Korikkar <sumanthk@linux.ibm.com>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] livepatch: Fix idle cpu's tasks transition
Message-ID: <patch.git-94c1daf66a9c.your-ad-here.call-01631714463-ext-3692@work.hours>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-Patchwork-Bot: notify
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: UFVeLRztszlvuJi6dmYN6u-Ec74i-FCM
X-Proofpoint-ORIG-GUID: L0EugqXAUXM9IRxmXHPOz7AiUivKPkoj
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.687,Hydra:6.0.235,FMLib:17.0.607.475
 definitions=2020-10-13_15,2020-10-13_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 suspectscore=0 malwarescore=0 bulkscore=0 mlxlogscore=999 spamscore=0
 adultscore=0 impostorscore=0 clxscore=1015 priorityscore=1501 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109030001 definitions=main-2109150087
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On an idle system with large amount of cpus it might happen that
klp_update_patch_state() is not reached in do_idle() for a long periods
of time. With debug messages enabled log is filled with:
[  499.442643] livepatch: klp_try_switch_task: swapper/63:0 is running

without any signs of progress. Ending up with "failed to complete
transition".

On s390 LPAR with 128 cpus not a single transition is able to complete
and livepatch kselftests fail. Tests on idling x86 kvm instance with 128
cpus demonstrate similar symptoms with and without CONFIG_NO_HZ.

To deal with that, since runqueue is already locked in
klp_try_switch_task() identify idling cpus and trigger rescheduling
potentially waking them up and making sure idle tasks break out of
do_idle() inner loop and reach klp_update_patch_state(). This helps to
speed up transition time while avoiding unnecessary extra system load.

Reviewed-by: Petr Mladek <pmladek@suse.com>
Acked-by: Miroslav Benes <mbenes@suse.cz>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
---
Ingo/Peter, as Josh mentioned, could you please ack if you are ok with
livepatch calling this private scheduler interface?

Changes since v1:
- added comments suggested by Petr
  lkml.kernel.org/r/patch.git-a4aad6b1540d.your-ad-here.call-01631177886-ext-3083@work.hours

Previous discussion and RFC PATCH:
  lkml.kernel.org/r/patch.git-b76842ceb035.your-ad-here.call-01625661932-ext-1304@work.hours

 kernel/livepatch/transition.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/kernel/livepatch/transition.c b/kernel/livepatch/transition.c
index 291b857a6e20..2846a879f2dc 100644
--- a/kernel/livepatch/transition.c
+++ b/kernel/livepatch/transition.c
@@ -278,6 +278,8 @@ static int klp_check_stack(struct task_struct *task, char *err_buf)
  * Try to safely switch a task to the target patch state.  If it's currently
  * running, or it's sleeping on a to-be-patched or to-be-unpatched function, or
  * if the stack is unreliable, return false.
+ *
+ * Idle tasks are switched in the main loop when running.
  */
 static bool klp_try_switch_task(struct task_struct *task)
 {
@@ -308,6 +310,12 @@ static bool klp_try_switch_task(struct task_struct *task)
 	rq = task_rq_lock(task, &flags);
 
 	if (task_running(rq, task) && task != current) {
+		/*
+		 * Idle task might stay running for a long time. Switch them
+		 * in the main loop.
+		 */
+		if (is_idle_task(task))
+			resched_curr(rq);
 		snprintf(err_buf, STACK_ERR_BUF_SIZE,
 			 "%s: %s:%d is running\n", __func__, task->comm,
 			 task->pid);
-- 
2.25.4
