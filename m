Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D9B753CE39
	for <lists+live-patching@lfdr.de>; Tue, 11 Jun 2019 16:15:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389807AbfFKON1 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 11 Jun 2019 10:13:27 -0400
Received: from mx2.suse.de ([195.135.220.15]:44176 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388728AbfFKON1 (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Tue, 11 Jun 2019 10:13:27 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 32FF0AF8C;
        Tue, 11 Jun 2019 14:13:26 +0000 (UTC)
From:   Miroslav Benes <mbenes@suse.cz>
To:     jpoimboe@redhat.com, jikos@kernel.org, pmladek@suse.com
Cc:     joe.lawrence@redhat.com, kamalesh@linux.vnet.ibm.com,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        Miroslav Benes <mbenes@suse.cz>
Subject: [PATCH v4 3/3] livepatch: Remove duplicate warning about missing reliable stacktrace support
Date:   Tue, 11 Jun 2019 16:13:20 +0200
Message-Id: <20190611141320.25359-4-mbenes@suse.cz>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190611141320.25359-1-mbenes@suse.cz>
References: <20190611141320.25359-1-mbenes@suse.cz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

From: Petr Mladek <pmladek@suse.com>

WARN_ON_ONCE() could not be called safely under rq lock because
of console deadlock issues. Moreover WARN_ON_ONCE() is superfluous in
klp_check_stack(), because stack_trace_save_tsk_reliable() cannot return
-ENOSYS thanks to klp_have_reliable_stack() check in
klp_try_switch_task().

Signed-off-by: Petr Mladek <pmladek@suse.com>
[ mbenes: changelog edited ]
Signed-off-by: Miroslav Benes <mbenes@suse.cz>
---
 kernel/livepatch/transition.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/kernel/livepatch/transition.c b/kernel/livepatch/transition.c
index 7e7ef04689d1..cdf318d86dd6 100644
--- a/kernel/livepatch/transition.c
+++ b/kernel/livepatch/transition.c
@@ -247,7 +247,6 @@ static int klp_check_stack(struct task_struct *task, char *err_buf)
 	int ret, nr_entries;
 
 	ret = stack_trace_save_tsk_reliable(task, entries, ARRAY_SIZE(entries));
-	WARN_ON_ONCE(ret == -ENOSYS);
 	if (ret < 0) {
 		snprintf(err_buf, STACK_ERR_BUF_SIZE,
 			 "%s: %s:%d has an unreliable stack\n",
-- 
2.21.0

