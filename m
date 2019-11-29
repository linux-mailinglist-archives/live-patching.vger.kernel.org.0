Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11CE510D1EF
	for <lists+live-patching@lfdr.de>; Fri, 29 Nov 2019 08:42:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726915AbfK2HmB (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 29 Nov 2019 02:42:01 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:7522 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726908AbfK2HmB (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 29 Nov 2019 02:42:01 -0500
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xAT7fugc135211
        for <live-patching@vger.kernel.org>; Fri, 29 Nov 2019 02:42:00 -0500
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2whcxsg1wu-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <live-patching@vger.kernel.org>; Fri, 29 Nov 2019 02:42:00 -0500
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <live-patching@vger.kernel.org> from <gor@linux.ibm.com>;
        Fri, 29 Nov 2019 07:41:58 -0000
Received: from b06avi18626390.portsmouth.uk.ibm.com (9.149.26.192)
        by e06smtp04.uk.ibm.com (192.168.101.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 29 Nov 2019 07:41:54 -0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xAT7fDGv35586426
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Nov 2019 07:41:13 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3B7A0AE055;
        Fri, 29 Nov 2019 07:41:53 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 99B19AE051;
        Fri, 29 Nov 2019 07:41:52 +0000 (GMT)
Received: from localhost (unknown [9.145.76.153])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Fri, 29 Nov 2019 07:41:52 +0000 (GMT)
Date:   Fri, 29 Nov 2019 08:41:51 +0100
From:   Vasily Gorbik <gor@linux.ibm.com>
To:     Miroslav Benes <mbenes@suse.cz>
Cc:     heiko.carstens@de.ibm.com, borntraeger@de.ibm.com,
        jpoimboe@redhat.com, joe.lawrence@redhat.com,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        jikos@kernel.org, pmladek@suse.com, nstange@suse.de,
        live-patching@vger.kernel.org
Subject: [PATCH v4 2/2] s390/livepatch: Implement reliable stack tracing for
 the consistency model
References: <20191106095601.29986-5-mbenes@suse.cz>
 <cover.thread-a0061f.your-ad-here.call-01575012971-ext-9115@work.hours>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <cover.thread-a0061f.your-ad-here.call-01575012971-ext-9115@work.hours>
X-TM-AS-GCONF: 00
x-cbid: 19112907-0016-0000-0000-000002CDC775
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19112907-0017-0000-0000-0000332FB08D
Message-Id: <patch-2.thread-a0061f.git-a0061fcad34d.your-ad-here.call-01575012971-ext-9115@work.hours>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-29_01:2019-11-29,2019-11-29 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 malwarescore=0 impostorscore=0 clxscore=1015 adultscore=0 suspectscore=7
 phishscore=0 spamscore=0 lowpriorityscore=0 bulkscore=0 priorityscore=1501
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911290066
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

From: Miroslav Benes <mbenes@suse.cz>

The livepatch consistency model requires reliable stack tracing
architecture support in order to work properly. In order to achieve
this, two main issues have to be solved. First, reliable and consistent
call chain backtracing has to be ensured. Second, the unwinder needs to
be able to detect stack corruptions and return errors.

The "zSeries ELF Application Binary Interface Supplement" says:

  "The stack pointer points to the first word of the lowest allocated
  stack frame. If the "back chain" is implemented this word will point to
  the previously allocated stack frame (towards higher addresses), except
  for the first stack frame, which shall have a back chain of zero (NULL).
  The stack shall grow downwards, in other words towards lower addresses."

"back chain" is optional. GCC option -mbackchain enables it. Quoting
Martin Schwidefsky [1]:

  "The compiler is called with the -mbackchain option, all normal C
  function will store the backchain in the function prologue. All
  functions written in assembler code should do the same, if you find one
  that does not we should fix that. The end result is that a task that
  *voluntarily* called schedule() should have a proper backchain at all
  times.

  Dependent on the use case this may or may not be enough. Asynchronous
  interrupts may stop the CPU at the beginning of a function, if kernel
  preemption is enabled we can end up with a broken backchain.  The
  production kernels for IBM Z are all compiled *without* kernel
  preemption. So yes, we might get away without the objtool support.

  On a side-note, we do have a line item to implement the ORC unwinder for
  the kernel, that includes the objtool support. Once we have that we can
  drop the -mbackchain option for the kernel build. That gives us a nice
  little performance benefit. I hope that the change from backchain to the
  ORC unwinder will not be too hard to implement in the livepatch tools."

Since -mbackchain is enabled by default when the kernel is compiled, the
call chain backtracing should be currently ensured and objtool should
not be necessary for livepatch purposes.

Regarding the second issue, stack corruptions and non-reliable states
have to be recognized by the unwinder. Mainly it means to detect
preemption or page faults, the end of the task stack must be reached,
return addresses must be valid text addresses and hacks like function
graph tracing and kretprobes must be properly detected.

Unwinding a running task's stack is not a problem, because there is a
livepatch requirement that every checked task is blocked, except for the
current task. Due to that, we can consider a task's kernel/thread stack
only and skip the other stacks.

[1] 20180912121106.31ffa97c@mschwideX1 [not archived on lore.kernel.org]

Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
---
 arch/s390/Kconfig             |  1 +
 arch/s390/kernel/stacktrace.c | 43 +++++++++++++++++++++++++++++++++++
 2 files changed, 44 insertions(+)

diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index 2528eb9d01fb..367a87c5d7b8 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -170,6 +170,7 @@ config S390
 	select HAVE_PERF_EVENTS
 	select HAVE_RCU_TABLE_FREE
 	select HAVE_REGS_AND_STACK_ACCESS_API
+	select HAVE_RELIABLE_STACKTRACE
 	select HAVE_RSEQ
 	select HAVE_SYSCALL_TRACEPOINTS
 	select HAVE_VIRT_CPU_ACCOUNTING
diff --git a/arch/s390/kernel/stacktrace.c b/arch/s390/kernel/stacktrace.c
index f8fc4f8aef9b..fc5419ac64c8 100644
--- a/arch/s390/kernel/stacktrace.c
+++ b/arch/s390/kernel/stacktrace.c
@@ -9,6 +9,7 @@
 #include <linux/stacktrace.h>
 #include <asm/stacktrace.h>
 #include <asm/unwind.h>
+#include <asm/kprobes.h>
 
 void arch_stack_walk(stack_trace_consume_fn consume_entry, void *cookie,
 		     struct task_struct *task, struct pt_regs *regs)
@@ -22,3 +23,45 @@ void arch_stack_walk(stack_trace_consume_fn consume_entry, void *cookie,
 			break;
 	}
 }
+
+/*
+ * This function returns an error if it detects any unreliable features of the
+ * stack.  Otherwise it guarantees that the stack trace is reliable.
+ *
+ * If the task is not 'current', the caller *must* ensure the task is inactive.
+ */
+int arch_stack_walk_reliable(stack_trace_consume_fn consume_entry,
+			     void *cookie, struct task_struct *task)
+{
+	struct unwind_state state;
+	unsigned long addr;
+
+	unwind_for_each_frame(&state, task, NULL, 0) {
+		if (state.stack_info.type != STACK_TYPE_TASK)
+			return -EINVAL;
+
+		if (state.regs)
+			return -EINVAL;
+
+		addr = unwind_get_return_address(&state);
+		if (!addr)
+			return -EINVAL;
+
+#ifdef CONFIG_KPROBES
+		/*
+		 * Mark stacktraces with kretprobed functions on them
+		 * as unreliable.
+		 */
+		if (state.ip == (unsigned long)kretprobe_trampoline)
+			return -EINVAL;
+#endif
+
+		if (!consume_entry(cookie, addr, false))
+			return -EINVAL;
+	}
+
+	/* Check for stack corruption */
+	if (unwind_error(&state))
+		return -EINVAL;
+	return 0;
+}
-- 
2.21.0

