Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC5812A1069
	for <lists+live-patching@lfdr.de>; Fri, 30 Oct 2020 22:41:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727376AbgJ3Vkk (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 30 Oct 2020 17:40:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:46978 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727820AbgJ3VkQ (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Fri, 30 Oct 2020 17:40:16 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B1A2D2224D;
        Fri, 30 Oct 2020 21:40:15 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94)
        (envelope-from <rostedt@goodmis.org>)
        id 1kYc86-006491-4c; Fri, 30 Oct 2020 17:40:14 -0400
Message-ID: <20201030214014.018742947@goodmis.org>
User-Agent: quilt/0.66
Date:   Fri, 30 Oct 2020 17:31:48 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org
Cc:     Masami Hiramatsu <mhiramat@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        live-patching@vger.kernel.org
Subject: [PATCH 06/11 v2] livepatch/ftrace: Add recursion protection to the ftrace callback
References: <20201030213142.096102821@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

If a ftrace callback does not supply its own recursion protection and
does not set the RECURSION_SAFE flag in its ftrace_ops, then ftrace will
make a helper trampoline to do so before calling the callback instead of
just calling the callback directly.

The default for ftrace_ops is going to change. It will expect that handlers
provide their own recursion protection, unless its ftrace_ops states
otherwise.

Link: https://lkml.kernel.org/r/20201028115613.291169246@goodmis.org

Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Jiri Kosina <jikos@kernel.org>
Cc: Miroslav Benes <mbenes@suse.cz>
Cc: Joe Lawrence <joe.lawrence@redhat.com>
Cc: live-patching@vger.kernel.org
Reviewed-by: Petr Mladek <pmladek@suse.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 kernel/livepatch/patch.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/kernel/livepatch/patch.c b/kernel/livepatch/patch.c
index b552cf2d85f8..6c0164d24bbd 100644
--- a/kernel/livepatch/patch.c
+++ b/kernel/livepatch/patch.c
@@ -45,9 +45,13 @@ static void notrace klp_ftrace_handler(unsigned long ip,
 	struct klp_ops *ops;
 	struct klp_func *func;
 	int patch_state;
+	int bit;
 
 	ops = container_of(fops, struct klp_ops, fops);
 
+	bit = ftrace_test_recursion_trylock();
+	if (bit < 0)
+		return;
 	/*
 	 * A variant of synchronize_rcu() is used to allow patching functions
 	 * where RCU is not watching, see klp_synchronize_transition().
@@ -117,6 +121,7 @@ static void notrace klp_ftrace_handler(unsigned long ip,
 
 unlock:
 	preempt_enable_notrace();
+	ftrace_test_recursion_unlock(bit);
 }
 
 /*
-- 
2.28.0


