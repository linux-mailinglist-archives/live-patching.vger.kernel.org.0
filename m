Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D4CA7471F
	for <lists+live-patching@lfdr.de>; Thu, 25 Jul 2019 08:24:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729188AbfGYGYn (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 25 Jul 2019 02:24:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:49414 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729159AbfGYGYn (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Thu, 25 Jul 2019 02:24:43 -0400
Received: from localhost.localdomain (NE2965lan1.rev.em-net.ne.jp [210.141.244.193])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A220B206B8;
        Thu, 25 Jul 2019 06:24:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564035882;
        bh=ncW/68XK5c9cQCbKoGP5zby1jJDeNvVhZPLDGjRekFM=;
        h=From:To:Cc:Subject:Date:From;
        b=Yrg+fRs630IVn/OcuIQ5CzQG7jp5KvX8vYi7b3sPDNeRowFMphGnIETaVsXc2bK7B
         CsTRjfn4aF3nWunCw6c4Di1pzqEe6IhgXVHwfEKh2QT2p/yPznkjdWgtFxfxU5qdJ4
         yBbhRd4gWr2ZZRDrQUlav524sux9jH4WWvLfby3M=
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@kernel.org>
Cc:     Joe Lawrence <joe.lawrence@redhat.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Naveen N . Rao" <naveen.n.rao@linux.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: [PATCH] kprobes: Allow kprobes coexist with livepatch
Date:   Thu, 25 Jul 2019 15:24:37 +0900
Message-Id: <156403587671.30117.5233558741694155985.stgit@devnote2>
X-Mailer: git-send-email 2.20.1
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Allow kprobes which do not modify regs->ip, coexist with livepatch
by dropping FTRACE_OPS_FL_IPMODIFY from ftrace_ops.

User who wants to modify regs->ip (e.g. function fault injection)
must set a dummy post_handler to its kprobes when registering.
However, if such regs->ip modifying kprobes is set on a function,
that function can not be livepatched.

Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
---
 kernel/kprobes.c |   56 +++++++++++++++++++++++++++++++++++++++---------------
 1 file changed, 40 insertions(+), 16 deletions(-)

diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index 9873fc627d61..29065380dad0 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -961,9 +961,16 @@ static struct kprobe *alloc_aggr_kprobe(struct kprobe *p)
 
 #ifdef CONFIG_KPROBES_ON_FTRACE
 static struct ftrace_ops kprobe_ftrace_ops __read_mostly = {
+	.func = kprobe_ftrace_handler,
+	.flags = FTRACE_OPS_FL_SAVE_REGS,
+};
+
+static struct ftrace_ops kprobe_ipmodify_ops __read_mostly = {
 	.func = kprobe_ftrace_handler,
 	.flags = FTRACE_OPS_FL_SAVE_REGS | FTRACE_OPS_FL_IPMODIFY,
 };
+
+static int kprobe_ipmodify_enabled;
 static int kprobe_ftrace_enabled;
 
 /* Must ensure p->addr is really on ftrace */
@@ -976,58 +983,75 @@ static int prepare_kprobe(struct kprobe *p)
 }
 
 /* Caller must lock kprobe_mutex */
-static int arm_kprobe_ftrace(struct kprobe *p)
+static int __arm_kprobe_ftrace(struct kprobe *p, struct ftrace_ops *ops,
+			       int *cnt)
 {
 	int ret = 0;
 
-	ret = ftrace_set_filter_ip(&kprobe_ftrace_ops,
-				   (unsigned long)p->addr, 0, 0);
+	ret = ftrace_set_filter_ip(ops, (unsigned long)p->addr, 0, 0);
 	if (ret) {
 		pr_debug("Failed to arm kprobe-ftrace at %pS (%d)\n",
 			 p->addr, ret);
 		return ret;
 	}
 
-	if (kprobe_ftrace_enabled == 0) {
-		ret = register_ftrace_function(&kprobe_ftrace_ops);
+	if (*cnt == 0) {
+		ret = register_ftrace_function(ops);
 		if (ret) {
 			pr_debug("Failed to init kprobe-ftrace (%d)\n", ret);
 			goto err_ftrace;
 		}
 	}
 
-	kprobe_ftrace_enabled++;
+	(*cnt)++;
 	return ret;
 
 err_ftrace:
 	/*
-	 * Note: Since kprobe_ftrace_ops has IPMODIFY set, and ftrace requires a
-	 * non-empty filter_hash for IPMODIFY ops, we're safe from an accidental
-	 * empty filter_hash which would undesirably trace all functions.
+	 * At this point, sinec ops is not registered, we should be sefe from
+	 * registering empty filter.
 	 */
-	ftrace_set_filter_ip(&kprobe_ftrace_ops, (unsigned long)p->addr, 1, 0);
+	ftrace_set_filter_ip(ops, (unsigned long)p->addr, 1, 0);
 	return ret;
 }
 
+static int arm_kprobe_ftrace(struct kprobe *p)
+{
+	bool ipmodify = (p->post_handler != NULL);
+
+	return __arm_kprobe_ftrace(p,
+		ipmodify ? &kprobe_ipmodify_ops : &kprobe_ftrace_ops,
+		ipmodify ? &kprobe_ipmodify_enabled : &kprobe_ftrace_enabled);
+}
+
 /* Caller must lock kprobe_mutex */
-static int disarm_kprobe_ftrace(struct kprobe *p)
+static int __disarm_kprobe_ftrace(struct kprobe *p, struct ftrace_ops *ops,
+				  int *cnt)
 {
 	int ret = 0;
 
-	if (kprobe_ftrace_enabled == 1) {
-		ret = unregister_ftrace_function(&kprobe_ftrace_ops);
+	if (*cnt == 1) {
+		ret = unregister_ftrace_function(ops);
 		if (WARN(ret < 0, "Failed to unregister kprobe-ftrace (%d)\n", ret))
 			return ret;
 	}
 
-	kprobe_ftrace_enabled--;
+	(*cnt)--;
 
-	ret = ftrace_set_filter_ip(&kprobe_ftrace_ops,
-			   (unsigned long)p->addr, 1, 0);
+	ret = ftrace_set_filter_ip(ops, (unsigned long)p->addr, 1, 0);
 	WARN_ONCE(ret < 0, "Failed to disarm kprobe-ftrace at %pS (%d)\n",
 		  p->addr, ret);
 	return ret;
 }
+
+static int disarm_kprobe_ftrace(struct kprobe *p)
+{
+	bool ipmodify = (p->post_handler != NULL);
+
+	return __disarm_kprobe_ftrace(p,
+		ipmodify ? &kprobe_ipmodify_ops : &kprobe_ftrace_ops,
+		ipmodify ? &kprobe_ipmodify_enabled : &kprobe_ftrace_enabled);
+}
 #else	/* !CONFIG_KPROBES_ON_FTRACE */
 #define prepare_kprobe(p)	arch_prepare_kprobe(p)
 #define arm_kprobe_ftrace(p)	(-ENODEV)

