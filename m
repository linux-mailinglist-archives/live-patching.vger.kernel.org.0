Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E684A3BE84D
	for <lists+live-patching@lfdr.de>; Wed,  7 Jul 2021 14:50:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231483AbhGGMwc (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 7 Jul 2021 08:52:32 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:1596 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231383AbhGGMwc (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 7 Jul 2021 08:52:32 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 167CXKro084140;
        Wed, 7 Jul 2021 08:49:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : mime-version : content-type; s=pp1;
 bh=tVWoMSw7Z3rinGR6jRf8OexhqSTeaz+VwKHwlKOzR5U=;
 b=Dmed/uRGrl+MyQKnSDr2fDKFWYwatvySzrwXj6UvPORp5gQO+uZHSHGy15NOZCLt6ywY
 9TRugI4XP5H2J/wMGZC194SFjJ6YjL/+6BNEE35vbKQcB+fTcq5OZ/e8hFOr604lcnLC
 ls87bI6K6ca5u0TA/szGkJgWSPCpF7B0Vk22wOZAMypW95R45gqP74BzkS5dovT1lMOU
 zoyly+XfBjJywDI6tu6+zfZSNjbqMeOxztatc6Uh9zy6t44cyoaUMDcd/tNYlpluDf9P
 zrcDL7fLgQdgxbr+9h1S+YuD6/hChNh7evlczU8o47BlxeKGi7iCJOzYCV518I3173r9 7Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39m8bn6q8v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 07 Jul 2021 08:49:46 -0400
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 167CYNdH087053;
        Wed, 7 Jul 2021 08:49:46 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39m8bn6q7a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 07 Jul 2021 08:49:45 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 167Cl7Go029407;
        Wed, 7 Jul 2021 12:49:43 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma04ams.nl.ibm.com with ESMTP id 39jfh8srpp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 07 Jul 2021 12:49:43 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 167ClkIU35979612
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 7 Jul 2021 12:47:46 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 68B6911C05E;
        Wed,  7 Jul 2021 12:49:40 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D3EDF11C04C;
        Wed,  7 Jul 2021 12:49:39 +0000 (GMT)
Received: from localhost (unknown [9.171.25.238])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Wed,  7 Jul 2021 12:49:39 +0000 (GMT)
Date:   Wed, 7 Jul 2021 14:49:38 +0200
From:   Vasily Gorbik <gor@linux.ibm.com>
To:     Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>
Cc:     Joe Lawrence <joe.lawrence@redhat.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Sumanth Korikkar <sumanthk@linux.ibm.com>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RFC PATCH] livepatch: Kick idle cpu's tasks to perform transition
Message-ID: <patch.git-b76842ceb035.your-ad-here.call-01625661932-ext-1304@work.hours>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-Patchwork-Bot: notify
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: BkZPJO9lRca1XsVBvO4WsAwnB84hjX0e
X-Proofpoint-ORIG-GUID: C7L4CMZg83D7QkaK-DJTK9w0tA0Nza_n
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-07_06:2021-07-06,2021-07-07 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 phishscore=0 impostorscore=0 clxscore=1011 spamscore=0 mlxscore=0
 bulkscore=0 malwarescore=0 suspectscore=0 mlxlogscore=999 adultscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107070075
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
and livepatch kselftests fail.

To deal with that, make sure we break out of do_idle() inner loop to
reach klp_update_patch_state() by marking idle tasks as NEED_RESCHED
as well as kick cpus out of idle state.

Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
---
 kernel/livepatch/transition.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/kernel/livepatch/transition.c b/kernel/livepatch/transition.c
index 3a4beb9395c4..793eba46e970 100644
--- a/kernel/livepatch/transition.c
+++ b/kernel/livepatch/transition.c
@@ -415,8 +415,11 @@ void klp_try_complete_transition(void)
 	for_each_possible_cpu(cpu) {
 		task = idle_task(cpu);
 		if (cpu_online(cpu)) {
-			if (!klp_try_switch_task(task))
+			if (!klp_try_switch_task(task)) {
 				complete = false;
+				set_tsk_need_resched(task);
+				kick_process(task);
+			}
 		} else if (task->patch_state != klp_target_state) {
 			/* offline idle tasks can be switched immediately */
 			clear_tsk_thread_flag(task, TIF_PATCH_PENDING);
-- 
2.25.4
