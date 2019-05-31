Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8BAD30998
	for <lists+live-patching@lfdr.de>; Fri, 31 May 2019 09:43:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726933AbfEaHmO (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 31 May 2019 03:42:14 -0400
Received: from mx2.suse.de ([195.135.220.15]:41376 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726331AbfEaHmL (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Fri, 31 May 2019 03:42:11 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 2E6F0AE20;
        Fri, 31 May 2019 07:42:10 +0000 (UTC)
From:   Petr Mladek <pmladek@suse.com>
To:     Jiri Kosina <jikos@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Miroslav Benes <mbenes@suse.cz>
Cc:     Joe Lawrence <joe.lawrence@redhat.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        Petr Mladek <pmladek@suse.com>
Subject: [PATCH 3/3] livepatch: Use static buffer for debugging messages under rq lock
Date:   Fri, 31 May 2019 09:41:47 +0200
Message-Id: <20190531074147.27616-4-pmladek@suse.com>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20190531074147.27616-1-pmladek@suse.com>
References: <20190531074147.27616-1-pmladek@suse.com>
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

The err_buf array uses 128 bytes of stack space.  Move it off the stack
by making it static.  It's safe to use a shared buffer because
klp_try_switch_task() is called under klp_mutex.

Signed-off-by: Petr Mladek <pmladek@suse.com>
Acked-by: Miroslav Benes <mbenes@suse.cz>
Reviewed-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
---
 kernel/livepatch/transition.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/kernel/livepatch/transition.c b/kernel/livepatch/transition.c
index 1bf362df76e1..5c4f0c1f826e 100644
--- a/kernel/livepatch/transition.c
+++ b/kernel/livepatch/transition.c
@@ -280,11 +280,11 @@ static int klp_check_stack(struct task_struct *task, char *err_buf)
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
 
@@ -327,7 +327,6 @@ static bool klp_try_switch_task(struct task_struct *task)
 		pr_debug("%s", err_buf);
 
 	return success;
-
 }
 
 /*
-- 
2.16.4

