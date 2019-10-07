Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E42FCDD01
	for <lists+live-patching@lfdr.de>; Mon,  7 Oct 2019 10:17:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727522AbfJGIRV (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 7 Oct 2019 04:17:21 -0400
Received: from mx2.suse.de ([195.135.220.15]:56276 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727103AbfJGIRU (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Mon, 7 Oct 2019 04:17:20 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id ECC0CAE86;
        Mon,  7 Oct 2019 08:17:17 +0000 (UTC)
From:   Miroslav Benes <mbenes@suse.cz>
To:     rostedt@goodmis.org, mingo@redhat.com, jpoimboe@redhat.com,
        jikos@kernel.org, pmladek@suse.com, joe.lawrence@redhat.com
Cc:     linux-kernel@vger.kernel.org, live-patching@vger.kernel.org,
        Miroslav Benes <mbenes@suse.cz>
Subject: [PATCH 2/3] ftrace: Introduce PERMANENT ftrace_ops flag
Date:   Mon,  7 Oct 2019 10:17:13 +0200
Message-Id: <20191007081714.20259-3-mbenes@suse.cz>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191007081714.20259-1-mbenes@suse.cz>
References: <20191007081714.20259-1-mbenes@suse.cz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Livepatch uses ftrace for redirection to new patched functions. It means
that if ftrace is disabled, all live patched functions are disabled as
well. Toggling global 'ftrace_enabled' sysctl thus affect it directly.
It is not a problem per se, because only administrator can set sysctl
values, but it still may be surprising.

Introduce PERMANENT ftrace_ops flag to amend this. If the
FTRACE_OPS_FL_PERMANENT is set, the tracing of the function is not
disabled. Such ftrace_ops can still be unregistered in a standard way.

Signed-off-by: Miroslav Benes <mbenes@suse.cz>
---
 Documentation/trace/ftrace-uses.rst |  6 ++++++
 Documentation/trace/ftrace.rst      |  2 ++
 include/linux/ftrace.h              |  8 ++++++--
 kernel/trace/ftrace.c               | 32 ++++++++++++++++++++++++++++-
 4 files changed, 45 insertions(+), 3 deletions(-)

diff --git a/Documentation/trace/ftrace-uses.rst b/Documentation/trace/ftrace-uses.rst
index 1fbc69894eed..e97b52de403f 100644
--- a/Documentation/trace/ftrace-uses.rst
+++ b/Documentation/trace/ftrace-uses.rst
@@ -170,6 +170,12 @@ FTRACE_OPS_FL_RCU
 	a callback may be executed and RCU synchronization will not protect
 	it.
 
+FTRACE_OPS_FL_PERMANENT
+        If this is set, then the tracing of the function is not disabled when
+        the proc sysctl ftrace_enabled is switched off. Livepatch uses it not
+        to lose the function redirection, so the system stays protected. The
+        callbacks with the flag set can still be unregistered.
+
 
 Filtering which functions to trace
 ==================================
diff --git a/Documentation/trace/ftrace.rst b/Documentation/trace/ftrace.rst
index e3060eedb22d..e93987a79477 100644
--- a/Documentation/trace/ftrace.rst
+++ b/Documentation/trace/ftrace.rst
@@ -2977,6 +2977,8 @@ function tracer. By default it is enabled (when function tracing is
 enabled in the kernel). If it is disabled, all function tracing is
 disabled. This includes not only the function tracers for ftrace, but
 also for any other uses (perf, kprobes, stack tracing, profiling, etc).
+Functions, whose ftrace_ops are registered with FTRACE_OPS_FL_PERMANENT set,
+are the only exceptions. Tracing stays enabled there.
 
 Please disable this with care.
 
diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index 8a8cb3c401b2..55f074f248b2 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -142,6 +142,7 @@ ftrace_func_t ftrace_ops_get_func(struct ftrace_ops *ops);
  * PID     - Is affected by set_ftrace_pid (allows filtering on those pids)
  * RCU     - Set when the ops can only be called when RCU is watching.
  * TRACE_ARRAY - The ops->private points to a trace_array descriptor.
+ * PERMAMENT - Set when the ops is permanent and should not be removed.
  */
 enum {
 	FTRACE_OPS_FL_ENABLED			= 1 << 0,
@@ -160,6 +161,7 @@ enum {
 	FTRACE_OPS_FL_PID			= 1 << 13,
 	FTRACE_OPS_FL_RCU			= 1 << 14,
 	FTRACE_OPS_FL_TRACE_ARRAY		= 1 << 15,
+	FTRACE_OPS_FL_PERMANENT			= 1 << 16,
 };
 
 #ifdef CONFIG_DYNAMIC_FTRACE
@@ -330,6 +332,7 @@ bool is_ftrace_trampoline(unsigned long addr);
  *  REGS_EN - the function is set up to save regs.
  *  IPMODIFY - the record allows for the IP address to be changed.
  *  DISABLED - the record is not ready to be touched yet
+ *  PERMANENT - the record is permanent, do not remove it.
  *
  * When a new ftrace_ops is registered and wants a function to save
  * pt_regs, the rec->flag REGS is set. When the function has been
@@ -345,10 +348,11 @@ enum {
 	FTRACE_FL_TRAMP_EN	= (1UL << 27),
 	FTRACE_FL_IPMODIFY	= (1UL << 26),
 	FTRACE_FL_DISABLED	= (1UL << 25),
+	FTRACE_FL_PERMANENT	= (1UL << 24),
 };
 
-#define FTRACE_REF_MAX_SHIFT	25
-#define FTRACE_FL_BITS		7
+#define FTRACE_REF_MAX_SHIFT	24
+#define FTRACE_FL_BITS		8
 #define FTRACE_FL_MASKED_BITS	((1UL << FTRACE_FL_BITS) - 1)
 #define FTRACE_FL_MASK		(FTRACE_FL_MASKED_BITS << FTRACE_REF_MAX_SHIFT)
 #define FTRACE_REF_MAX		((1UL << FTRACE_REF_MAX_SHIFT) - 1)
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index a37c1127599c..790a7c2dd0b4 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -1736,6 +1736,13 @@ static bool __ftrace_hash_rec_update(struct ftrace_ops *ops,
 			 */
 			if (ops->flags & FTRACE_OPS_FL_SAVE_REGS)
 				rec->flags |= FTRACE_FL_REGS;
+
+			/*
+			 * If any ops is permanent for this function, set it
+			 * for the record.
+			 */
+			if (ops->flags & FTRACE_OPS_FL_PERMANENT)
+				rec->flags |= FTRACE_FL_PERMANENT;
 		} else {
 			if (FTRACE_WARN_ON(ftrace_rec_count(rec) == 0))
 				return false;
@@ -1755,6 +1762,20 @@ static bool __ftrace_hash_rec_update(struct ftrace_ops *ops,
 					rec->flags &= ~FTRACE_FL_REGS;
 			}
 
+			/*
+			 * If the rec had PERMANENT enabled and the ops that is
+			 * being removed had PERMANENT set, then see if there
+			 * is still any ops for this record that wants to be
+			 * permanent.  If not, we can stop recording them.
+			 */
+			if (ftrace_rec_count(rec) > 0 &&
+			    rec->flags & FTRACE_FL_PERMANENT &&
+			    ops->flags & FTRACE_OPS_FL_PERMANENT) {
+				if (!test_rec_ops_needs_flag(rec,
+						FTRACE_OPS_FL_PERMANENT))
+					rec->flags &= ~FTRACE_FL_PERMANENT;
+			}
+
 			/*
 			 * The TRAMP needs to be set only if rec count
 			 * is decremented to one, and the ops that is
@@ -2032,6 +2053,8 @@ void ftrace_bug(int failed, struct dyn_ftrace *rec)
 		pr_info("ftrace record flags: %lx\n", rec->flags);
 		pr_cont(" (%ld)%s", ftrace_rec_count(rec),
 			rec->flags & FTRACE_FL_REGS ? " R" : "  ");
+		pr_cont(" (%ld)%s", ftrace_rec_count(rec),
+			rec->flags & FTRACE_FL_PERMANENT ? " P" : "  ");
 		if (rec->flags & FTRACE_FL_TRAMP_EN) {
 			ops = ftrace_find_tramp_ops_any(rec);
 			if (ops) {
@@ -2129,6 +2152,12 @@ static int ftrace_check_record(struct dyn_ftrace *rec, bool enable, bool update)
 		return FTRACE_UPDATE_MODIFY_CALL;
 	}
 
+	/* Do not disable the permanent record */
+	if (ftrace_rec_count(rec) &&
+	   (rec->flags & FTRACE_FL_PERMANENT)) {
+		return FTRACE_UPDATE_IGNORE;
+	}
+
 	if (update) {
 		/* If there's no more users, clear all flags */
 		if (!ftrace_rec_count(rec))
@@ -3450,9 +3479,10 @@ static int t_show(struct seq_file *m, void *v)
 	if (iter->flags & FTRACE_ITER_ENABLED) {
 		struct ftrace_ops *ops;
 
-		seq_printf(m, " (%ld)%s%s",
+		seq_printf(m, " (%ld)%s%s%s",
 			   ftrace_rec_count(rec),
 			   rec->flags & FTRACE_FL_REGS ? " R" : "  ",
+			   rec->flags & FTRACE_FL_PERMANENT ? " P" : "  ",
 			   rec->flags & FTRACE_FL_IPMODIFY ? " I" : "  ");
 		if (rec->flags & FTRACE_FL_TRAMP_EN) {
 			ops = ftrace_find_tramp_ops_any(rec);
-- 
2.23.0

