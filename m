Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7248E2AFCC7
	for <lists+live-patching@lfdr.de>; Thu, 12 Nov 2020 02:48:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728662AbgKLBdy (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 11 Nov 2020 20:33:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:38968 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728085AbgKLAfh (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Wed, 11 Nov 2020 19:35:37 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6696D22201;
        Thu, 12 Nov 2020 00:33:35 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94)
        (envelope-from <rostedt@goodmis.org>)
        id 1kd0YQ-00029q-9U; Wed, 11 Nov 2020 19:33:34 -0500
Message-ID: <20201112003334.171769950@goodmis.org>
User-Agent: quilt/0.66
Date:   Wed, 11 Nov 2020 19:32:51 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org
Cc:     Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jikos@kernel.org>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        live-patching@vger.kernel.org, Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>
Subject: [for-next][PATCH 07/17] livepatch: Trigger WARNING if livepatch function fails due to
 recursion
References: <20201112003244.764326960@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

If for some reason a function is called that triggers the recursion
detection of live patching, trigger a warning. By not executing the live
patch code, it is possible that the old unpatched function will be called
placing the system into an unknown state.

Link: https://lore.kernel.org/r/20201029145709.GD16774@alley
Link: https://lkml.kernel.org/r/20201106023547.312639435@goodmis.org

Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Jiri Kosina <jikos@kernel.org>
Cc: Joe Lawrence <joe.lawrence@redhat.com>
Cc: live-patching@vger.kernel.org
Suggested-by: Miroslav Benes <mbenes@suse.cz>
Reviewed-by: Petr Mladek <pmladek@suse.com>
Acked-by: Miroslav Benes <mbenes@suse.cz>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 kernel/livepatch/patch.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/livepatch/patch.c b/kernel/livepatch/patch.c
index 6c0164d24bbd..15480bf3ce88 100644
--- a/kernel/livepatch/patch.c
+++ b/kernel/livepatch/patch.c
@@ -50,7 +50,7 @@ static void notrace klp_ftrace_handler(unsigned long ip,
 	ops = container_of(fops, struct klp_ops, fops);
 
 	bit = ftrace_test_recursion_trylock();
-	if (bit < 0)
+	if (WARN_ON_ONCE(bit < 0))
 		return;
 	/*
 	 * A variant of synchronize_rcu() is used to allow patching functions
-- 
2.28.0


