Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68916429D44
	for <lists+live-patching@lfdr.de>; Tue, 12 Oct 2021 07:40:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232254AbhJLFmt (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 12 Oct 2021 01:42:49 -0400
Received: from out4436.biz.mail.alibaba.com ([47.88.44.36]:40982 "EHLO
        out4436.biz.mail.alibaba.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229688AbhJLFms (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 12 Oct 2021 01:42:48 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R211e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04357;MF=yun.wang@linux.alibaba.com;NM=1;PH=DS;RN=31;SR=0;TI=SMTPD_---0UrY3qZU_1634017231;
Received: from testdeMacBook-Pro.local(mailfrom:yun.wang@linux.alibaba.com fp:SMTPD_---0UrY3qZU_1634017231)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 12 Oct 2021 13:40:32 +0800
Subject: [PATCH 2/2] ftrace: prevent preemption in perf_ftrace_function_call()
From:   =?UTF-8?B?546L6LSH?= <yun.wang@linux.alibaba.com>
To:     Guo Ren <guoren@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Helge Deller <deller@gmx.de>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Colin Ian King <colin.king@canonical.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Nicholas Piggin <npiggin@gmail.com>,
        Jisheng Zhang <jszhang@kernel.org>, linux-csky@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-parisc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-riscv@lists.infradead.org,
        live-patching@vger.kernel.org
References: <8c7de46d-9869-aa5e-2bb9-5dbc2eda395e@linux.alibaba.com>
Message-ID: <7ec34e08-a357-58d6-2ce4-c7472d8b0381@linux.alibaba.com>
Date:   Tue, 12 Oct 2021 13:40:31 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.13; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <8c7de46d-9869-aa5e-2bb9-5dbc2eda395e@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

With CONFIG_DEBUG_PREEMPT we observed reports like:

  BUG: using smp_processor_id() in preemptible
  caller is perf_ftrace_function_call+0x6f/0x2e0
  CPU: 1 PID: 680 Comm: a.out Not tainted
  Call Trace:
   <TASK>
   dump_stack_lvl+0x8d/0xcf
   check_preemption_disabled+0x104/0x110
   ? optimize_nops.isra.7+0x230/0x230
   ? text_poke_bp_batch+0x9f/0x310
   perf_ftrace_function_call+0x6f/0x2e0
   ...
   __text_poke+0x5/0x620
   text_poke_bp_batch+0x9f/0x310

This telling us the CPU could be changed after task is preempted, and
the checking on CPU before preemption will be invalid.

This patch just turn off preemption in perf_ftrace_function_call()
to prevent CPU changing.

CC: Steven Rostedt <rostedt@goodmis.org>
Reported-by: Abaci <abaci@linux.alibaba.com>
Signed-off-by: Michael Wang <yun.wang@linux.alibaba.com>
---
 kernel/trace/trace_event_perf.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/kernel/trace/trace_event_perf.c b/kernel/trace/trace_event_perf.c
index 6aed10e..33c2f76 100644
--- a/kernel/trace/trace_event_perf.c
+++ b/kernel/trace/trace_event_perf.c
@@ -441,12 +441,19 @@ void perf_trace_buf_update(void *record, u16 type)
 	if (!rcu_is_watching())
 		return;

+	/*
+	 * Prevent CPU changing from now on. rcu must
+	 * be in watching if the task was migrated and
+	 * scheduled.
+	 */
+	preempt_disable_notrace();
+
 	if ((unsigned long)ops->private != smp_processor_id())
-		return;
+		goto out;

 	bit = ftrace_test_recursion_trylock(ip, parent_ip);
 	if (bit < 0)
-		return;
+		goto out;

 	event = container_of(ops, struct perf_event, ftrace_ops);

@@ -468,16 +475,18 @@ void perf_trace_buf_update(void *record, u16 type)

 	entry = perf_trace_buf_alloc(ENTRY_SIZE, NULL, &rctx);
 	if (!entry)
-		goto out;
+		goto unlock;

 	entry->ip = ip;
 	entry->parent_ip = parent_ip;
 	perf_trace_buf_submit(entry, ENTRY_SIZE, rctx, TRACE_FN,
 			      1, &regs, &head, NULL);

-out:
+unlock:
 	ftrace_test_recursion_unlock(bit);
 #undef ENTRY_SIZE
+out:
+	preempt_enable_notrace();
 }

 static int perf_ftrace_function_register(struct perf_event *event)
-- 
1.8.3.1


