Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB12C1E7A20
	for <lists+live-patching@lfdr.de>; Fri, 29 May 2020 12:11:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725775AbgE2KLa (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 29 May 2020 06:11:30 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:58174 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725601AbgE2KL3 (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Fri, 29 May 2020 06:11:29 -0400
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id C003B6E80F94C9C22371;
        Fri, 29 May 2020 18:11:26 +0800 (CST)
Received: from huawei.com (10.175.124.27) by DGGEMS412-HUB.china.huawei.com
 (10.3.19.212) with Microsoft SMTP Server id 14.3.487.0; Fri, 29 May 2020
 18:11:15 +0800
From:   Wang ShaoBo <bobo.shaobowang@huawei.com>
CC:     <huawei.libin@huawei.com>, <xiexiuqi@huawei.com>,
        <cj.chengjian@huawei.com>, <bobo.shaobowang@huawei.com>,
        <mingo@redhat.com>, <x86@kernel.org>,
        <linux-kernel@vger.kernel.org>, <live-patching@vger.kernel.org>,
        <mbenes@suse.cz>, <jpoimboe@redhat.com>, <devel@etsukata.com>,
        <viro@zeniv.linux.org.uk>, <esyr@redhat.com>
Subject: Question: livepatch failed for new fork() task stack unreliable
Date:   Fri, 29 May 2020 18:10:59 +0800
Message-ID: <20200529101059.39885-1-bobo.shaobowang@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.124.27]
X-CFilter-Loop: Reflected
To:     unlisted-recipients:; (no To-header on input)
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Stack unreliable error is reported by stack_trace_save_tsk_reliable() when trying
to insmod a hot patch for module modification, this results in frequent failures
sometimes. We found this 'unreliable' stack is from task just fork.

The task just fork need to go through these steps will the problem not appear:

_do_fork
    -=> copy_process
    ...
    -=> ret_from_fork
            -=> UNWIND_HINT_REGS

Call trace as follow when stack_trace_save_tsk_reliable() return failure:
    [ 896.214710] livepatch: klp_check_stack: monitor-process:41642 has an unreliable stack
    [ 896.214735] livepatch: Call Trace:    # print trace entries by myself
    [ 896.214760] Call Trace:               # call show_stack()
    [ 896.214763] ? __switch_to_asm+0x70/0x70

Only for user mode task, there are two cases related for one task just created:

1) The task was not actually scheduled to excute, at this time UNWIND_HINT_EMPTY in
ret_from_fork() has not reset unwind_hint, it's sp_reg and end field remain default value
and end up throwing an error in unwind_next_frame() when called by arch_stack_walk_reliable();

2) The task has been scheduled but UNWIND_HINT_REGS not finished, at this time
arch_stack_walk_reliable() terminates it's backtracing loop for pt_regs unknown
and return -EINVAL because it's a user task.

As shown below, for user task, There exists a gap where ORC unwinder cannot
capture the stack state of task immediately, at this time the task has already been
created but ret_from_fork() has not complete it's mission.

We attempt to append a bit field orc_info_prepared in task_struct to probe when
related actions finished in ret_from_fork, we found scenario 1) 2) can be capatured.
It's a informal solution, just for testing our conjecture.

I am eager to purse an effective answer, welcome any ideas.
Another similar question: https://lkml.org/lkml/2020/3/12/590

Following is the draft modification:

1. Add a bit field orc_info_prepared int task_struct.

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 4418f5cb8324..3ff1368b8877 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -791,6 +791,9 @@ struct task_struct {
	/* Stalled due to lack of memory */
	unsigned			in_memstall:1;
 #endif
+#ifdef CONFIG_UNWINDER_ORC
+	unsigned			orc_info_prepared:1;
+#endif
 
	unsigned long			atomic_flags; /* Flags requiring atomic access. */


2. if UNWIND_HINT_REGS complete, pt_regs can be known by orc unwinder,
   set orc_info_prepared = 1 in orc_info_prepared_fini().

diff --git a/arch/x86/entry/entry_64.S b/arch/x86/entry/entry_64.S
index 3063aa9090f9..637bdb091090 100644
--- a/arch/x86/entry/entry_64.S
+++ b/arch/x86/entry/entry_64.S
@@ -339,6 +339,7 @@ SYM_CODE_START(ret_from_fork)
 
 2:
 	UNWIND_HINT_REGS
+	call	orc_info_prepared_fini
 	movq	%rsp, %rdi
 	call	syscall_return_slowpath	/* returns with IRQs disabled */
 	TRACE_IRQS_ON			/* user mode is traced as IRQS on */
 
3. Simply judge orc_info_prepared if task is user mode process.

diff --git a/arch/x86/kernel/stacktrace.c b/arch/x86/kernel/stacktrace.c
index 6ad43fc44556..bf1d2887f00b 100644
--- a/arch/x86/kernel/stacktrace.c
+++ b/arch/x86/kernel/stacktrace.c
@@ -77,6 +77,10 @@ int arch_stack_walk_reliable(stack_trace_consume_fn consume_entry,
 			return -EINVAL;
 	}


+	if (!(task->flags & (PF_KTHREAD | PF_IDLE)) &&
+		!task_orc_info_prepared(task))
+		return 0;
+
 	/* Check for stack corruption */
 	if (unwind_error(&state))
 		return -EINVAL;

