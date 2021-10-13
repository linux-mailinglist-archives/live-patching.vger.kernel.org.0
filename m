Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F4AB42B341
	for <lists+live-patching@lfdr.de>; Wed, 13 Oct 2021 05:17:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236946AbhJMDTk (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 12 Oct 2021 23:19:40 -0400
Received: from out30-43.freemail.mail.aliyun.com ([115.124.30.43]:39104 "EHLO
        out30-43.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229526AbhJMDTk (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 12 Oct 2021 23:19:40 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R661e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=yun.wang@linux.alibaba.com;NM=1;PH=DS;RN=31;SR=0;TI=SMTPD_---0UrdkllL_1634095050;
Received: from testdeMacBook-Pro.local(mailfrom:yun.wang@linux.alibaba.com fp:SMTPD_---0UrdkllL_1634095050)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 13 Oct 2021 11:17:31 +0800
Subject: [PATCH v2 1/2] ftrace: disable preemption between
 ftrace_test_recursion_trylock/unlock()
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
 <1a8e8d73-b508-f90b-0d82-eb2da45a720e@linux.alibaba.com>
Message-ID: <1e7c5a26-0e98-8304-d62e-95810916016e@linux.alibaba.com>
Date:   Wed, 13 Oct 2021 11:17:30 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.13; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <1a8e8d73-b508-f90b-0d82-eb2da45a720e@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

As the documentation explained, ftrace_test_recursion_trylock()
and ftrace_test_recursion_unlock() were supposed to disable and
enable preemption properly, however currently this work is done
outside of the function, which could be missing by mistake.

This path will make sure the preemption was disabled when trylock()
succeed, and the unlock() will enable the preemption if previously
enabled.

CC: Steven Rostedt <rostedt@goodmis.org>
CC: Miroslav Benes <mbenes@suse.cz>
Reported-by: Abaci <abaci@linux.alibaba.com>
Suggested-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Michael Wang <yun.wang@linux.alibaba.com>
---
 arch/csky/kernel/probes/ftrace.c     |  2 --
 arch/parisc/kernel/ftrace.c          |  2 --
 arch/powerpc/kernel/kprobes-ftrace.c |  2 --
 arch/riscv/kernel/probes/ftrace.c    |  2 --
 arch/x86/kernel/kprobes/ftrace.c     |  2 --
 include/linux/trace_recursion.h      | 22 +++++++++++++++++++++-
 kernel/livepatch/patch.c             |  6 ------
 kernel/trace/trace_functions.c       |  5 -----
 8 files changed, 21 insertions(+), 22 deletions(-)

diff --git a/arch/csky/kernel/probes/ftrace.c b/arch/csky/kernel/probes/ftrace.c
index b388228..834cffc 100644
--- a/arch/csky/kernel/probes/ftrace.c
+++ b/arch/csky/kernel/probes/ftrace.c
@@ -17,7 +17,6 @@ void kprobe_ftrace_handler(unsigned long ip, unsigned long parent_ip,
 		return;

 	regs = ftrace_get_regs(fregs);
-	preempt_disable_notrace();
 	p = get_kprobe((kprobe_opcode_t *)ip);
 	if (!p) {
 		p = get_kprobe((kprobe_opcode_t *)(ip - MCOUNT_INSN_SIZE));
@@ -57,7 +56,6 @@ void kprobe_ftrace_handler(unsigned long ip, unsigned long parent_ip,
 		__this_cpu_write(current_kprobe, NULL);
 	}
 out:
-	preempt_enable_notrace();
 	ftrace_test_recursion_unlock(bit);
 }
 NOKPROBE_SYMBOL(kprobe_ftrace_handler);
diff --git a/arch/parisc/kernel/ftrace.c b/arch/parisc/kernel/ftrace.c
index 0a1e75a..3543496 100644
--- a/arch/parisc/kernel/ftrace.c
+++ b/arch/parisc/kernel/ftrace.c
@@ -216,7 +216,6 @@ void kprobe_ftrace_handler(unsigned long ip, unsigned long parent_ip,
 		return;

 	regs = ftrace_get_regs(fregs);
-	preempt_disable_notrace();
 	p = get_kprobe((kprobe_opcode_t *)ip);
 	if (unlikely(!p) || kprobe_disabled(p))
 		goto out;
@@ -245,7 +244,6 @@ void kprobe_ftrace_handler(unsigned long ip, unsigned long parent_ip,
 	}
 	__this_cpu_write(current_kprobe, NULL);
 out:
-	preempt_enable_notrace();
 	ftrace_test_recursion_unlock(bit);
 }
 NOKPROBE_SYMBOL(kprobe_ftrace_handler);
diff --git a/arch/powerpc/kernel/kprobes-ftrace.c b/arch/powerpc/kernel/kprobes-ftrace.c
index 7154d58..072ebe7 100644
--- a/arch/powerpc/kernel/kprobes-ftrace.c
+++ b/arch/powerpc/kernel/kprobes-ftrace.c
@@ -26,7 +26,6 @@ void kprobe_ftrace_handler(unsigned long nip, unsigned long parent_nip,
 		return;

 	regs = ftrace_get_regs(fregs);
-	preempt_disable_notrace();
 	p = get_kprobe((kprobe_opcode_t *)nip);
 	if (unlikely(!p) || kprobe_disabled(p))
 		goto out;
@@ -61,7 +60,6 @@ void kprobe_ftrace_handler(unsigned long nip, unsigned long parent_nip,
 		__this_cpu_write(current_kprobe, NULL);
 	}
 out:
-	preempt_enable_notrace();
 	ftrace_test_recursion_unlock(bit);
 }
 NOKPROBE_SYMBOL(kprobe_ftrace_handler);
diff --git a/arch/riscv/kernel/probes/ftrace.c b/arch/riscv/kernel/probes/ftrace.c
index aab85a8..7142ec4 100644
--- a/arch/riscv/kernel/probes/ftrace.c
+++ b/arch/riscv/kernel/probes/ftrace.c
@@ -15,7 +15,6 @@ void kprobe_ftrace_handler(unsigned long ip, unsigned long parent_ip,
 	if (bit < 0)
 		return;

-	preempt_disable_notrace();
 	p = get_kprobe((kprobe_opcode_t *)ip);
 	if (unlikely(!p) || kprobe_disabled(p))
 		goto out;
@@ -52,7 +51,6 @@ void kprobe_ftrace_handler(unsigned long ip, unsigned long parent_ip,
 		__this_cpu_write(current_kprobe, NULL);
 	}
 out:
-	preempt_enable_notrace();
 	ftrace_test_recursion_unlock(bit);
 }
 NOKPROBE_SYMBOL(kprobe_ftrace_handler);
diff --git a/arch/x86/kernel/kprobes/ftrace.c b/arch/x86/kernel/kprobes/ftrace.c
index 596de2f..dd2ec14 100644
--- a/arch/x86/kernel/kprobes/ftrace.c
+++ b/arch/x86/kernel/kprobes/ftrace.c
@@ -25,7 +25,6 @@ void kprobe_ftrace_handler(unsigned long ip, unsigned long parent_ip,
 	if (bit < 0)
 		return;

-	preempt_disable_notrace();
 	p = get_kprobe((kprobe_opcode_t *)ip);
 	if (unlikely(!p) || kprobe_disabled(p))
 		goto out;
@@ -59,7 +58,6 @@ void kprobe_ftrace_handler(unsigned long ip, unsigned long parent_ip,
 		__this_cpu_write(current_kprobe, NULL);
 	}
 out:
-	preempt_enable_notrace();
 	ftrace_test_recursion_unlock(bit);
 }
 NOKPROBE_SYMBOL(kprobe_ftrace_handler);
diff --git a/include/linux/trace_recursion.h b/include/linux/trace_recursion.h
index a9f9c57..101e1fb 100644
--- a/include/linux/trace_recursion.h
+++ b/include/linux/trace_recursion.h
@@ -208,13 +208,29 @@ static __always_inline void trace_clear_recursion(int bit)
  * Use this for ftrace callbacks. This will detect if the function
  * tracing recursed in the same context (normal vs interrupt),
  *
+ * The ftrace_test_recursion_trylock() will disable preemption,
+ * which is required for the variant of synchronize_rcu() that is
+ * used to allow patching functions where RCU is not watching.
+ * See klp_synchronize_transition() for more details.
+ *
  * Returns: -1 if a recursion happened.
  *           >= 0 if no recursion
  */
 static __always_inline int ftrace_test_recursion_trylock(unsigned long ip,
 							 unsigned long parent_ip)
 {
-	return trace_test_and_set_recursion(ip, parent_ip, TRACE_FTRACE_START, TRACE_FTRACE_MAX);
+	int bit;
+
+	bit = trace_test_and_set_recursion(ip, parent_ip, TRACE_FTRACE_START, TRACE_FTRACE_MAX);
+	/*
+	 * The zero bit indicate we are nested
+	 * in another trylock(), which means the
+	 * preemption already disabled.
+	 */
+	if (bit > 0)
+		preempt_disable_notrace();
+
+	return bit;
 }

 /**
@@ -222,9 +238,13 @@ static __always_inline int ftrace_test_recursion_trylock(unsigned long ip,
  * @bit: The return of a successful ftrace_test_recursion_trylock()
  *
  * This is used at the end of a ftrace callback.
+ *
+ * Preemption will be enabled (if it was previously enabled).
  */
 static __always_inline void ftrace_test_recursion_unlock(int bit)
 {
+	if (bit)
+		preempt_enable_notrace();
 	trace_clear_recursion(bit);
 }

diff --git a/kernel/livepatch/patch.c b/kernel/livepatch/patch.c
index e8029ae..6e66ccd 100644
--- a/kernel/livepatch/patch.c
+++ b/kernel/livepatch/patch.c
@@ -52,11 +52,6 @@ static void notrace klp_ftrace_handler(unsigned long ip,
 	bit = ftrace_test_recursion_trylock(ip, parent_ip);
 	if (WARN_ON_ONCE(bit < 0))
 		return;
-	/*
-	 * A variant of synchronize_rcu() is used to allow patching functions
-	 * where RCU is not watching, see klp_synchronize_transition().
-	 */
-	preempt_disable_notrace();

 	func = list_first_or_null_rcu(&ops->func_stack, struct klp_func,
 				      stack_node);
@@ -120,7 +115,6 @@ static void notrace klp_ftrace_handler(unsigned long ip,
 	klp_arch_set_pc(fregs, (unsigned long)func->new_func);

 unlock:
-	preempt_enable_notrace();
 	ftrace_test_recursion_unlock(bit);
 }

diff --git a/kernel/trace/trace_functions.c b/kernel/trace/trace_functions.c
index 1f0e63f..9f1bfbe 100644
--- a/kernel/trace/trace_functions.c
+++ b/kernel/trace/trace_functions.c
@@ -186,7 +186,6 @@ static void function_trace_start(struct trace_array *tr)
 		return;

 	trace_ctx = tracing_gen_ctx();
-	preempt_disable_notrace();

 	cpu = smp_processor_id();
 	data = per_cpu_ptr(tr->array_buffer.data, cpu);
@@ -194,7 +193,6 @@ static void function_trace_start(struct trace_array *tr)
 		trace_function(tr, ip, parent_ip, trace_ctx);

 	ftrace_test_recursion_unlock(bit);
-	preempt_enable_notrace();
 }

 #ifdef CONFIG_UNWINDER_ORC
@@ -298,8 +296,6 @@ static inline void process_repeats(struct trace_array *tr,
 	if (bit < 0)
 		return;

-	preempt_disable_notrace();
-
 	cpu = smp_processor_id();
 	data = per_cpu_ptr(tr->array_buffer.data, cpu);
 	if (atomic_read(&data->disabled))
@@ -324,7 +320,6 @@ static inline void process_repeats(struct trace_array *tr,

 out:
 	ftrace_test_recursion_unlock(bit);
-	preempt_enable_notrace();
 }

 static void
-- 
1.8.3.1

