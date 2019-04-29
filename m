Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3185E58F
	for <lists+live-patching@lfdr.de>; Mon, 29 Apr 2019 16:56:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728358AbfD2O4a (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 29 Apr 2019 10:56:30 -0400
Received: from mx2.suse.de ([195.135.220.15]:59478 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728339AbfD2O4a (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Mon, 29 Apr 2019 10:56:30 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 63F54AB6D;
        Mon, 29 Apr 2019 14:56:29 +0000 (UTC)
From:   Petr Mladek <pmladek@suse.com>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     Ingo Molnar <mingo@kernel.org>, Jiri Kosina <jikos@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Miroslav Benes <mbenes@suse.cz>,
        Jason Baron <jbaron@akamai.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Evgenii Shatokhin <eshatokhin@virtuozzo.com>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        Petr Mladek <pmladek@suse.com>
Subject: [PATCH] stacktrace: Remove superfluous WARN_ONCE() from save_stack_trace_tsk_reliable()
Date:   Mon, 29 Apr 2019 16:56:24 +0200
Message-Id: <20190429145624.27746-1-pmladek@suse.com>
X-Mailer: git-send-email 2.16.4
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

WARN_ONCE() in the generic save_stack_trace_tsk_reliable() is superfluous.
The only current user klp_check_stack() writes its own warning when
-ENOSYS is returned.

Signed-off-by: Petr Mladek <pmladek@suse.com>
Acked-by: Josh Poimboeuf <jpoimboe@redhat.com>
Acked-by: Miroslav Benes <mbenes@suse.cz>
Reviewed-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
---
 kernel/stacktrace.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/kernel/stacktrace.c b/kernel/stacktrace.c
index f8edee9c792d..83ac0ac5ffd9 100644
--- a/kernel/stacktrace.c
+++ b/kernel/stacktrace.c
@@ -74,6 +74,5 @@ __weak int
 save_stack_trace_tsk_reliable(struct task_struct *tsk,
 			      struct stack_trace *trace)
 {
-	WARN_ONCE(1, KERN_INFO "save_stack_tsk_reliable() not implemented yet.\n");
 	return -ENOSYS;
 }
-- 
2.16.4

