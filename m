Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03DA0F12FF
	for <lists+live-patching@lfdr.de>; Wed,  6 Nov 2019 10:56:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725906AbfKFJ4G (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 6 Nov 2019 04:56:06 -0500
Received: from mx2.suse.de ([195.135.220.15]:49974 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726755AbfKFJ4G (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Wed, 6 Nov 2019 04:56:06 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id BEB04B35F;
        Wed,  6 Nov 2019 09:56:03 +0000 (UTC)
From:   Miroslav Benes <mbenes@suse.cz>
To:     heiko.carstens@de.ibm.com, gor@linux.ibm.com,
        borntraeger@de.ibm.com, jpoimboe@redhat.com,
        joe.lawrence@redhat.com
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        jikos@kernel.org, pmladek@suse.com, nstange@suse.de,
        live-patching@vger.kernel.org, Miroslav Benes <mbenes@suse.cz>
Subject: [PATCH v3 2/4] s390/unwind: split unwind_next_frame() to several functions
Date:   Wed,  6 Nov 2019 10:55:59 +0100
Message-Id: <20191106095601.29986-3-mbenes@suse.cz>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191106095601.29986-1-mbenes@suse.cz>
References: <20191106095601.29986-1-mbenes@suse.cz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Function unwind_next_frame() becomes less readable with each new
change. Split it to several functions to amend it and prepare for new
additions.

No functional change.

Suggested-by: Petr Mladek <pmladek@suse.com>
Signed-off-by: Miroslav Benes <mbenes@suse.cz>
---
 arch/s390/kernel/unwind_bc.c | 136 ++++++++++++++++++++++-------------
 1 file changed, 88 insertions(+), 48 deletions(-)

diff --git a/arch/s390/kernel/unwind_bc.c b/arch/s390/kernel/unwind_bc.c
index 5a78deacb972..96da99ec7b59 100644
--- a/arch/s390/kernel/unwind_bc.c
+++ b/arch/s390/kernel/unwind_bc.c
@@ -36,55 +36,10 @@ static bool update_stack_info(struct unwind_state *state, unsigned long sp)
 	return true;
 }
 
-bool unwind_next_frame(struct unwind_state *state)
+static bool unwind_update_state(struct unwind_state *state,
+				unsigned long sp, unsigned long ip,
+				struct pt_regs *regs, bool reliable)
 {
-	struct stack_info *info = &state->stack_info;
-	struct stack_frame *sf;
-	struct pt_regs *regs;
-	unsigned long sp, ip;
-	bool reliable;
-
-	regs = state->regs;
-	if (unlikely(regs)) {
-		if (state->reuse_sp) {
-			sp = state->sp;
-			state->reuse_sp = false;
-		} else {
-			sp = READ_ONCE_NOCHECK(regs->gprs[15]);
-			if (unlikely(outside_of_stack(state, sp))) {
-				if (!update_stack_info(state, sp))
-					goto out_err;
-			}
-		}
-		sf = (struct stack_frame *) sp;
-		ip = READ_ONCE_NOCHECK(sf->gprs[8]);
-		reliable = false;
-		regs = NULL;
-	} else {
-		sf = (struct stack_frame *) state->sp;
-		sp = READ_ONCE_NOCHECK(sf->back_chain);
-		if (likely(sp)) {
-			/* Non-zero back-chain points to the previous frame */
-			if (unlikely(outside_of_stack(state, sp))) {
-				if (!update_stack_info(state, sp))
-					goto out_err;
-			}
-			sf = (struct stack_frame *) sp;
-			ip = READ_ONCE_NOCHECK(sf->gprs[8]);
-			reliable = true;
-		} else {
-			/* No back-chain, look for a pt_regs structure */
-			sp = state->sp + STACK_FRAME_OVERHEAD;
-			if (!on_stack(info, sp, sizeof(struct pt_regs)))
-				goto out_stop;
-			regs = (struct pt_regs *) sp;
-			if (READ_ONCE_NOCHECK(regs->psw.mask) & PSW_MASK_PSTATE)
-				goto out_stop;
-			ip = READ_ONCE_NOCHECK(regs->psw.addr);
-			reliable = true;
-		}
-	}
-
 	ip = ftrace_graph_ret_addr(state->task, &state->graph_idx,
 				   ip, (void *) sp);
 
@@ -94,13 +49,98 @@ bool unwind_next_frame(struct unwind_state *state)
 	state->regs = regs;
 	state->reliable = reliable;
 	return true;
+}
+
+static bool unwind_use_regs(struct unwind_state *state)
+{
+	struct stack_frame *sf;
+	unsigned long sp, ip;
+	struct pt_regs *regs = state->regs;
+
+	if (state->reuse_sp) {
+		sp = state->sp;
+		state->reuse_sp = false;
+	} else {
+		sp = READ_ONCE_NOCHECK(regs->gprs[15]);
+		if (unlikely(outside_of_stack(state, sp))) {
+			if (!update_stack_info(state, sp))
+				goto out_err;
+		}
+	}
+
+	sf = (struct stack_frame *) sp;
+	ip = READ_ONCE_NOCHECK(sf->gprs[8]);
+
+	return unwind_update_state(state, sp, ip, NULL, false);
+
+out_err:
+	state->error = true;
+	state->stack_info.type = STACK_TYPE_UNKNOWN;
+	return false;
+}
+
+static bool unwind_use_frame(struct unwind_state *state, unsigned long sp)
+{
+	struct stack_frame *sf;
+	unsigned long ip;
+
+	if (unlikely(outside_of_stack(state, sp))) {
+		if (!update_stack_info(state, sp))
+			goto out_err;
+	}
+
+	sf = (struct stack_frame *) sp;
+	ip = READ_ONCE_NOCHECK(sf->gprs[8]);
+
+	return unwind_update_state(state, sp, ip, NULL, true);
 
 out_err:
 	state->error = true;
+	state->stack_info.type = STACK_TYPE_UNKNOWN;
+	return false;
+}
+
+static bool unwind_look_for_regs(struct unwind_state *state)
+{
+	struct stack_info *info = &state->stack_info;
+	struct pt_regs *regs;
+	unsigned long sp, ip;
+
+	sp = state->sp + STACK_FRAME_OVERHEAD;
+	if (!on_stack(info, sp, sizeof(struct pt_regs)))
+		goto out_stop;
+
+	regs = (struct pt_regs *) sp;
+	if (READ_ONCE_NOCHECK(regs->psw.mask) & PSW_MASK_PSTATE)
+		goto out_stop;
+
+	ip = READ_ONCE_NOCHECK(regs->psw.addr);
+
+	return unwind_update_state(state, sp, ip, regs, true);
+
 out_stop:
 	state->stack_info.type = STACK_TYPE_UNKNOWN;
 	return false;
 }
+
+bool unwind_next_frame(struct unwind_state *state)
+{
+	struct stack_frame *sf;
+	unsigned long sp;
+
+	if (unlikely(state->regs))
+		return unwind_use_regs(state);
+
+	sf = (struct stack_frame *) state->sp;
+	sp = READ_ONCE_NOCHECK(sf->back_chain);
+
+	/* Non-zero back-chain points to the previous frame */
+	if (likely(sp))
+		return unwind_use_frame(state, sp);
+
+	/* No back-chain, look for a pt_regs structure */
+	return unwind_look_for_regs(state);
+}
 EXPORT_SYMBOL_GPL(unwind_next_frame);
 
 void __unwind_start(struct unwind_state *state, struct task_struct *task,
-- 
2.23.0

