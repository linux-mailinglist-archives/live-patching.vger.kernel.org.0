Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88488E8AF7
	for <lists+live-patching@lfdr.de>; Tue, 29 Oct 2019 15:39:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389444AbfJ2OjK (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 29 Oct 2019 10:39:10 -0400
Received: from mx2.suse.de ([195.135.220.15]:54616 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2389185AbfJ2OjJ (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Tue, 29 Oct 2019 10:39:09 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 7A914B29C;
        Tue, 29 Oct 2019 14:39:07 +0000 (UTC)
From:   Miroslav Benes <mbenes@suse.cz>
To:     heiko.carstens@de.ibm.com, gor@linux.ibm.com,
        borntraeger@de.ibm.com, jpoimboe@redhat.com,
        joe.lawrence@redhat.com
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        jikos@kernel.org, pmladek@suse.com, nstange@suse.de,
        live-patching@vger.kernel.org, Miroslav Benes <mbenes@suse.cz>
Subject: [PATCH v2 2/3] s390/unwind: prepare the unwinding interface for reliable stack traces
Date:   Tue, 29 Oct 2019 15:39:03 +0100
Message-Id: <20191029143904.24051-3-mbenes@suse.cz>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191029143904.24051-1-mbenes@suse.cz>
References: <20191029143904.24051-1-mbenes@suse.cz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

The reliable stack traces support will require to perform more actions
and some tasks differently. Add a new parameter to respective functions.

Signed-off-by: Miroslav Benes <mbenes@suse.cz>
---
 arch/s390/include/asm/stacktrace.h |  3 ++-
 arch/s390/include/asm/unwind.h     | 14 ++++++++------
 arch/s390/kernel/dumpstack.c       |  5 +++--
 arch/s390/kernel/perf_event.c      |  2 +-
 arch/s390/kernel/stacktrace.c      |  2 +-
 arch/s390/kernel/unwind_bc.c       |  7 ++++---
 arch/s390/oprofile/init.c          |  2 +-
 7 files changed, 20 insertions(+), 15 deletions(-)

diff --git a/arch/s390/include/asm/stacktrace.h b/arch/s390/include/asm/stacktrace.h
index 0ae4bbf7779c..f033bb70a8db 100644
--- a/arch/s390/include/asm/stacktrace.h
+++ b/arch/s390/include/asm/stacktrace.h
@@ -21,7 +21,8 @@ struct stack_info {
 
 const char *stack_type_name(enum stack_type type);
 int get_stack_info(unsigned long sp, struct task_struct *task,
-		   struct stack_info *info, unsigned long *visit_mask);
+		   struct stack_info *info, unsigned long *visit_mask,
+		   bool unwind_reliable);
 
 static inline bool on_stack(struct stack_info *info,
 			    unsigned long addr, size_t len)
diff --git a/arch/s390/include/asm/unwind.h b/arch/s390/include/asm/unwind.h
index d827b5b9a32c..1f4de78c3ef9 100644
--- a/arch/s390/include/asm/unwind.h
+++ b/arch/s390/include/asm/unwind.h
@@ -41,7 +41,8 @@ struct unwind_state {
 };
 
 void __unwind_start(struct unwind_state *state, struct task_struct *task,
-		    struct pt_regs *regs, unsigned long first_frame);
+		    struct pt_regs *regs, unsigned long first_frame,
+		    bool unwind_reliable);
 bool unwind_next_frame(struct unwind_state *state);
 unsigned long unwind_get_return_address(struct unwind_state *state);
 
@@ -58,10 +59,11 @@ static inline bool unwind_error(struct unwind_state *state)
 static inline void unwind_start(struct unwind_state *state,
 				struct task_struct *task,
 				struct pt_regs *regs,
-				unsigned long sp)
+				unsigned long sp,
+				bool unwind_reliable)
 {
 	sp = sp ? : get_stack_pointer(task, regs);
-	__unwind_start(state, task, regs, sp);
+	__unwind_start(state, task, regs, sp, unwind_reliable);
 }
 
 static inline struct pt_regs *unwind_get_entry_regs(struct unwind_state *state)
@@ -69,9 +71,9 @@ static inline struct pt_regs *unwind_get_entry_regs(struct unwind_state *state)
 	return unwind_done(state) ? NULL : state->regs;
 }
 
-#define unwind_for_each_frame(state, task, regs, first_frame)	\
-	for (unwind_start(state, task, regs, first_frame);	\
-	     !unwind_done(state);				\
+#define unwind_for_each_frame(state, task, regs, first_frame, unwind_reliable)	\
+	for (unwind_start(state, task, regs, first_frame, unwind_reliable);	\
+	     !unwind_done(state);						\
 	     unwind_next_frame(state))
 
 static inline void unwind_init(void) {}
diff --git a/arch/s390/kernel/dumpstack.c b/arch/s390/kernel/dumpstack.c
index 34bdc60c0b11..1ee19e6336cd 100644
--- a/arch/s390/kernel/dumpstack.c
+++ b/arch/s390/kernel/dumpstack.c
@@ -88,7 +88,8 @@ static bool in_restart_stack(unsigned long sp, struct stack_info *info)
 }
 
 int get_stack_info(unsigned long sp, struct task_struct *task,
-		   struct stack_info *info, unsigned long *visit_mask)
+		   struct stack_info *info, unsigned long *visit_mask,
+		   bool unwind_reliable)
 {
 	if (!sp)
 		goto unknown;
@@ -130,7 +131,7 @@ void show_stack(struct task_struct *task, unsigned long *stack)
 	printk("Call Trace:\n");
 	if (!task)
 		task = current;
-	unwind_for_each_frame(&state, task, NULL, (unsigned long) stack)
+	unwind_for_each_frame(&state, task, NULL, (unsigned long) stack, false)
 		printk(state.reliable ? " [<%016lx>] %pSR \n" :
 					"([<%016lx>] %pSR)\n",
 		       state.ip, (void *) state.ip);
diff --git a/arch/s390/kernel/perf_event.c b/arch/s390/kernel/perf_event.c
index fcb6c2e92b07..7e81db0883e1 100644
--- a/arch/s390/kernel/perf_event.c
+++ b/arch/s390/kernel/perf_event.c
@@ -225,7 +225,7 @@ void perf_callchain_kernel(struct perf_callchain_entry_ctx *entry,
 {
 	struct unwind_state state;
 
-	unwind_for_each_frame(&state, current, regs, 0)
+	unwind_for_each_frame(&state, current, regs, 0, false)
 		perf_callchain_store(entry, state.ip);
 }
 
diff --git a/arch/s390/kernel/stacktrace.c b/arch/s390/kernel/stacktrace.c
index f8fc4f8aef9b..751c136172f7 100644
--- a/arch/s390/kernel/stacktrace.c
+++ b/arch/s390/kernel/stacktrace.c
@@ -16,7 +16,7 @@ void arch_stack_walk(stack_trace_consume_fn consume_entry, void *cookie,
 	struct unwind_state state;
 	unsigned long addr;
 
-	unwind_for_each_frame(&state, task, regs, 0) {
+	unwind_for_each_frame(&state, task, regs, 0, false) {
 		addr = unwind_get_return_address(&state);
 		if (!addr || !consume_entry(cookie, addr, false))
 			break;
diff --git a/arch/s390/kernel/unwind_bc.c b/arch/s390/kernel/unwind_bc.c
index b407b5531f11..564eef63668b 100644
--- a/arch/s390/kernel/unwind_bc.c
+++ b/arch/s390/kernel/unwind_bc.c
@@ -29,7 +29,7 @@ static bool update_stack_info(struct unwind_state *state, unsigned long sp)
 	unsigned long *mask = &state->stack_mask;
 
 	/* New stack pointer leaves the current stack */
-	if (get_stack_info(sp, state->task, info, mask) != 0 ||
+	if (get_stack_info(sp, state->task, info, mask, false) != 0 ||
 	    !on_stack(info, sp, sizeof(struct stack_frame)))
 		/* 'sp' does not point to a valid stack */
 		return false;
@@ -99,7 +99,8 @@ bool unwind_next_frame(struct unwind_state *state)
 EXPORT_SYMBOL_GPL(unwind_next_frame);
 
 void __unwind_start(struct unwind_state *state, struct task_struct *task,
-		    struct pt_regs *regs, unsigned long sp)
+		    struct pt_regs *regs, unsigned long sp,
+		    bool unwind_reliable)
 {
 	struct stack_info *info = &state->stack_info;
 	unsigned long *mask = &state->stack_mask;
@@ -118,7 +119,7 @@ void __unwind_start(struct unwind_state *state, struct task_struct *task,
 	}
 
 	/* Get current stack pointer and initialize stack info */
-	if (get_stack_info(sp, task, info, mask) != 0 ||
+	if (get_stack_info(sp, task, info, mask, unwind_reliable) != 0 ||
 	    !on_stack(info, sp, sizeof(struct stack_frame))) {
 		/* Something is wrong with the stack pointer */
 		info->type = STACK_TYPE_UNKNOWN;
diff --git a/arch/s390/oprofile/init.c b/arch/s390/oprofile/init.c
index 7441857df51b..59d736f46cbc 100644
--- a/arch/s390/oprofile/init.c
+++ b/arch/s390/oprofile/init.c
@@ -19,7 +19,7 @@ static void s390_backtrace(struct pt_regs *regs, unsigned int depth)
 {
 	struct unwind_state state;
 
-	unwind_for_each_frame(&state, current, regs, 0) {
+	unwind_for_each_frame(&state, current, regs, 0, false) {
 		if (depth-- == 0)
 			break;
 		oprofile_add_trace(state.ip);
-- 
2.23.0

