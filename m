Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4657EF281
	for <lists+live-patching@lfdr.de>; Tue, 30 Apr 2019 11:11:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726262AbfD3JKz (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 30 Apr 2019 05:10:55 -0400
Received: from mx2.suse.de ([195.135.220.15]:36470 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726865AbfD3JKy (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Tue, 30 Apr 2019 05:10:54 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id A31BEAE5A;
        Tue, 30 Apr 2019 09:10:53 +0000 (UTC)
From:   Petr Mladek <pmladek@suse.com>
To:     Jiri Kosina <jikos@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Miroslav Benes <mbenes@suse.cz>
Cc:     Joe Lawrence <joe.lawrence@redhat.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        Petr Mladek <pmladek@suse.com>
Subject: [PATCH v2 1/2] livepatch: Remove duplicate warning about missing reliable stacktrace support
Date:   Tue, 30 Apr 2019 11:10:48 +0200
Message-Id: <20190430091049.30413-2-pmladek@suse.com>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20190430091049.30413-1-pmladek@suse.com>
References: <20190430091049.30413-1-pmladek@suse.com>
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

WARN_ON_ONCE() could not be called safely under rq lock because
of console deadlock issues. Fortunately, there is another check
for the reliable stacktrace support in klp_enable_patch().

Signed-off-by: Petr Mladek <pmladek@suse.com>
---
 kernel/livepatch/transition.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/kernel/livepatch/transition.c b/kernel/livepatch/transition.c
index 9c89ae8b337a..8e0274075e75 100644
--- a/kernel/livepatch/transition.c
+++ b/kernel/livepatch/transition.c
@@ -263,8 +263,15 @@ static int klp_check_stack(struct task_struct *task, char *err_buf)
 	trace.nr_entries = 0;
 	trace.max_entries = MAX_STACK_ENTRIES;
 	trace.entries = entries;
+
 	ret = save_stack_trace_tsk_reliable(task, &trace);
-	WARN_ON_ONCE(ret == -ENOSYS);
+	/*
+	 * pr_warn() under task rq lock might cause a deadlock.
+	 * Fortunately, missing reliable stacktrace support has
+	 * already been handled when the livepatch was enabled.
+	 */
+	if (ret == -ENOSYS)
+		return ret;
 	if (ret) {
 		snprintf(err_buf, STACK_ERR_BUF_SIZE,
 			 "%s: %s:%d has an unreliable stack\n",
-- 
2.16.4

