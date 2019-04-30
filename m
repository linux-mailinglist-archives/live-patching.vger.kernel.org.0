Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C54EFF282
	for <lists+live-patching@lfdr.de>; Tue, 30 Apr 2019 11:11:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726882AbfD3JK4 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 30 Apr 2019 05:10:56 -0400
Received: from mx2.suse.de ([195.135.220.15]:36476 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726129AbfD3JK4 (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Tue, 30 Apr 2019 05:10:56 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id D1FC6AE64;
        Tue, 30 Apr 2019 09:10:54 +0000 (UTC)
From:   Petr Mladek <pmladek@suse.com>
To:     Jiri Kosina <jikos@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Miroslav Benes <mbenes@suse.cz>
Cc:     Joe Lawrence <joe.lawrence@redhat.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        Petr Mladek <pmladek@suse.com>
Subject: [PATCH v2 2/2] livepatch: Use static buffer for debugging messages under rq lock
Date:   Tue, 30 Apr 2019 11:10:49 +0200
Message-Id: <20190430091049.30413-3-pmladek@suse.com>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20190430091049.30413-1-pmladek@suse.com>
References: <20190430091049.30413-1-pmladek@suse.com>
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

klp_try_switch_task() is called under klp_mutex. The buffer for
debugging messages might be static.

Signed-off-by: Petr Mladek <pmladek@suse.com>
---
 kernel/livepatch/transition.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/kernel/livepatch/transition.c b/kernel/livepatch/transition.c
index 8e0274075e75..d66086fd6d75 100644
--- a/kernel/livepatch/transition.c
+++ b/kernel/livepatch/transition.c
@@ -304,11 +304,11 @@ static int klp_check_stack(struct task_struct *task, char *err_buf)
  */
 static bool klp_try_switch_task(struct task_struct *task)
 {
+	static char err_buf[STACK_ERR_BUF_SIZE];
 	struct rq *rq;
 	struct rq_flags flags;
 	int ret;
 	bool success = false;
-	char err_buf[STACK_ERR_BUF_SIZE];
 
 	err_buf[0] = '\0';
 
@@ -351,7 +351,6 @@ static bool klp_try_switch_task(struct task_struct *task)
 		pr_debug("%s", err_buf);
 
 	return success;
-
 }
 
 /*
-- 
2.16.4

