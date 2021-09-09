Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9B5A4047A0
	for <lists+live-patching@lfdr.de>; Thu,  9 Sep 2021 11:16:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232262AbhIIJRf (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 9 Sep 2021 05:17:35 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:44728 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230379AbhIIJRe (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 9 Sep 2021 05:17:34 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 18993wi5016433;
        Thu, 9 Sep 2021 05:16:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : mime-version : content-type; s=pp1;
 bh=Ljw6r7FaJTEWKs3bJDmpfjkeYs5QYc15bJkw4/W95ok=;
 b=Xh6RCRwBTSo3cPMTZXV4gIbgq+AJPSQG5/xxiZ7y+58rCUOkMJxUzMRf23DZUkus6R9S
 26DwxWgmiUCxd3PvT5iW0+p38pbgnPanZBtArPIB6fqbeuJvPhWoGuC3url4DdwBDljR
 5Mq2YjasCM2Oj9hExEb8lJ8guunfu3BX3tl1L8s47VHaAeLgWcF1WWNWaVkwhoFysrwy
 vbTqEmb+v2r+PkHcEMGCjxBbOfnaVntfRWJX6pHOecA3D4vyRTnhYzySF1CDKdmxU0lI
 SJUp+0yq5tLKw38owmbmOzdPtuXf+/ah8qLUlng+BMO9HBH2XfJL7g5oFXTgtlY3t6bv Qg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3axmeqx37p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Sep 2021 05:16:11 -0400
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1899DQWj052234;
        Thu, 9 Sep 2021 05:16:10 -0400
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3axmeqx36r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Sep 2021 05:16:10 -0400
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 18999OcM018708;
        Thu, 9 Sep 2021 09:16:08 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04fra.de.ibm.com with ESMTP id 3axcnqa1cr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Sep 2021 09:16:08 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1899G4F253805522
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 9 Sep 2021 09:16:04 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 35D3252050;
        Thu,  9 Sep 2021 09:16:04 +0000 (GMT)
Received: from localhost (unknown [9.171.95.89])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTPS id 71A8252051;
        Thu,  9 Sep 2021 09:16:03 +0000 (GMT)
Date:   Thu, 9 Sep 2021 11:16:01 +0200
From:   Vasily Gorbik <gor@linux.ibm.com>
To:     Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>
Cc:     Joe Lawrence <joe.lawrence@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Heiko Carstens <hca@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Sumanth Korikkar <sumanthk@linux.ibm.com>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] livepatch: Fix idle cpu's tasks transition
Message-ID: <patch.git-a4aad6b1540d.your-ad-here.call-01631177886-ext-3083@work.hours>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-Patchwork-Bot: notify
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: X2fuybb_Ji2VDbrBG_z4_UOZeLP647ld
X-Proofpoint-ORIG-GUID: KfyibsxcL-wgA5d4tqK96Az5qhuR42mx
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-09-09_03:2021-09-07,2021-09-09 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 bulkscore=0
 phishscore=0 adultscore=0 suspectscore=0 malwarescore=0 mlxlogscore=999
 priorityscore=1501 clxscore=1011 lowpriorityscore=0 mlxscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109030001
 definitions=main-2109090050
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

Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
---
Previous discussion and RFC PATCH:
lkml.kernel.org/r/patch.git-b76842ceb035.your-ad-here.call-01625661932-ext-1304@work.hours

 kernel/livepatch/transition.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/livepatch/transition.c b/kernel/livepatch/transition.c
index 3a4beb9395c4..c5832b2dd081 100644
--- a/kernel/livepatch/transition.c
+++ b/kernel/livepatch/transition.c
@@ -308,6 +308,8 @@ static bool klp_try_switch_task(struct task_struct *task)
 	rq = task_rq_lock(task, &flags);
 
 	if (task_running(rq, task) && task != current) {
+		if (is_idle_task(task))
+			resched_curr(rq);
 		snprintf(err_buf, STACK_ERR_BUF_SIZE,
 			 "%s: %s:%d is running\n", __func__, task->comm,
 			 task->pid);
-- 
2.25.4
