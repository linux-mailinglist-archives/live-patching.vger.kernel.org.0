Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB22429DEEC
	for <lists+live-patching@lfdr.de>; Thu, 29 Oct 2020 01:57:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727989AbgJ2A5z (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 28 Oct 2020 20:57:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:60532 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731586AbgJ1WRd (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Wed, 28 Oct 2020 18:17:33 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D02E7246E7;
        Wed, 28 Oct 2020 11:56:14 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94)
        (envelope-from <rostedt@goodmis.org>)
        id 1kXk3p-005ZJ1-Df; Wed, 28 Oct 2020 07:56:13 -0400
Message-ID: <20201028115613.291169246@goodmis.org>
User-Agent: quilt/0.66
Date:   Wed, 28 Oct 2020 07:52:50 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org
Cc:     Masami Hiramatsu <mhiramat@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        live-patching@vger.kernel.org
Subject: [PATCH 6/9] livepatch/ftrace: Add recursion protection to the ftrace callback
References: <20201028115244.995788961@goodmis.org>
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

The default for ftrace_ops is going to assume recursion protection unless
otherwise specified.

Cc: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Jiri Kosina <jikos@kernel.org>
Cc: Miroslav Benes <mbenes@suse.cz>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Joe Lawrence <joe.lawrence@redhat.com>
Cc: live-patching@vger.kernel.org
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


