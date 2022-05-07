Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 661F251E903
	for <lists+live-patching@lfdr.de>; Sat,  7 May 2022 19:46:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1446733AbiEGRu3 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+live-patching@lfdr.de>); Sat, 7 May 2022 13:50:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1446729AbiEGRu2 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Sat, 7 May 2022 13:50:28 -0400
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A865FC8
        for <live-patching@vger.kernel.org>; Sat,  7 May 2022 10:46:41 -0700 (PDT)
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.17.1.5/8.17.1.5) with ESMTP id 247GLWrO022328
        for <live-patching@vger.kernel.org>; Sat, 7 May 2022 10:46:40 -0700
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0001303.ppops.net (PPS) with ESMTPS id 3fwn141dbf-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <live-patching@vger.kernel.org>; Sat, 07 May 2022 10:46:40 -0700
Received: from twshared11660.23.frc3.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:11d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Sat, 7 May 2022 10:46:39 -0700
Received: by devbig932.frc1.facebook.com (Postfix, from userid 4523)
        id B3D8F758C0BC; Sat,  7 May 2022 10:46:33 -0700 (PDT)
From:   Song Liu <song@kernel.org>
To:     <linux-kernel@vger.kernel.org>, <live-patching@vger.kernel.org>
CC:     <mingo@redhat.com>, <peterz@infradead.org>,
        <vincent.guittot@linaro.org>, <jpoimboe@redhat.com>,
        <joe.lawrence@redhat.com>, <kernel-team@fb.com>,
        Song Liu <song@kernel.org>
Subject: [RFC] sched,livepatch: call klp_try_switch_task in __cond_resched
Date:   Sat, 7 May 2022 10:46:28 -0700
Message-ID: <20220507174628.2086373-1-song@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: z5nZwT9zFUcbe7W1bntzGnEiJG-NnR0O
X-Proofpoint-ORIG-GUID: z5nZwT9zFUcbe7W1bntzGnEiJG-NnR0O
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-07_06,2022-05-06_01,2022-02-23_01
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Busy kernel threads may block the transition of livepatch. Call
klp_try_switch_task from __cond_resched to make the transition easier.

Signed-off-by: Song Liu <song@kernel.org>
---
 include/linux/livepatch.h     | 2 ++
 kernel/livepatch/transition.c | 2 +-
 kernel/sched/core.c           | 3 +++
 3 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/include/linux/livepatch.h b/include/linux/livepatch.h
index 2614247a9781..a9209f62550a 100644
--- a/include/linux/livepatch.h
+++ b/include/linux/livepatch.h
@@ -236,6 +236,7 @@ int klp_apply_section_relocs(struct module *pmod, Elf_Shdr *sechdrs,
 			     unsigned int symindex, unsigned int secindex,
 			     const char *objname);
 
+bool klp_try_switch_task(struct task_struct *task);
 #else /* !CONFIG_LIVEPATCH */
 
 static inline int klp_module_coming(struct module *mod) { return 0; }
@@ -253,6 +254,7 @@ int klp_apply_section_relocs(struct module *pmod, Elf_Shdr *sechdrs,
 	return 0;
 }
 
+bool klp_try_switch_task(struct task_struct *task) { return true; }
 #endif /* CONFIG_LIVEPATCH */
 
 #endif /* _LINUX_LIVEPATCH_H_ */
diff --git a/kernel/livepatch/transition.c b/kernel/livepatch/transition.c
index f6310f848f34..4257a8eec64b 100644
--- a/kernel/livepatch/transition.c
+++ b/kernel/livepatch/transition.c
@@ -278,7 +278,7 @@ static int klp_check_stack(struct task_struct *task, char *err_buf)
  * running, or it's sleeping on a to-be-patched or to-be-unpatched function, or
  * if the stack is unreliable, return false.
  */
-static bool klp_try_switch_task(struct task_struct *task)
+bool klp_try_switch_task(struct task_struct *task)
 {
 	static char err_buf[STACK_ERR_BUF_SIZE];
 	struct rq *rq;
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index a7302b7b65f2..41d1c7a86912 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -6990,6 +6990,9 @@ SYSCALL_DEFINE0(sched_yield)
 #if !defined(CONFIG_PREEMPTION) || defined(CONFIG_PREEMPT_DYNAMIC)
 int __sched __cond_resched(void)
 {
+	if (unlikely(klp_patch_pending(current)))
+		klp_try_switch_task(current);
+
 	if (should_resched(0)) {
 		preempt_schedule_common();
 		return 1;
-- 
2.30.2

