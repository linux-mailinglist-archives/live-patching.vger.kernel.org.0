Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E13766A2001
	for <lists+live-patching@lfdr.de>; Fri, 24 Feb 2023 17:50:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229492AbjBXQuQ (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 24 Feb 2023 11:50:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230023AbjBXQuQ (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 24 Feb 2023 11:50:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA6B54617A;
        Fri, 24 Feb 2023 08:50:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 415F16194B;
        Fri, 24 Feb 2023 16:50:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30298C433EF;
        Fri, 24 Feb 2023 16:50:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677257413;
        bh=nDYIubJTBPWH5ktJId6VhvPlAhhjbmackYfSKNUBnA8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CjuG2KvIvxcQ+B/eSRKm+PTo7G6vaKPGQgIU4hFyQs5wXnomIMM8b84GLT0O4Dnxe
         QWNkVDuQ1LSFLD75KKIO2nbosAgOXkj7ZRn7zUfbJs9Us+nqb3WkGIsp0fwlnwVmb4
         dziFmuO5RmZlg2XCPkckA6GTPkq/+V6lRfEVFGwnWxWXY2EGWu/RqRsfd2LVcnEUwJ
         OvR8GULbhHEn7F9zn7ez5vg60FBy9A+cPDiw+ei2E+b1+FZcxvG/b/nQydeoRE3TWG
         chzdnusNMa6FPIev2fEZjRfPq+laArTHe4isK2ASKzh1Je7tudeigh2zidFin6awuM
         2Y9+HwyejfjbQ==
From:   Josh Poimboeuf <jpoimboe@kernel.org>
To:     live-patching@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Seth Forshee <sforshee@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Song Liu <song@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Petr Mladek <pmladek@suse.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Miroslav Benes <mbenes@suse.cz>,
        Jiri Kosina <jikos@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Rik van Riel <riel@surriel.com>
Subject: [PATCH v3 1/3] livepatch: Skip task_call_func() for current task
Date:   Fri, 24 Feb 2023 08:49:59 -0800
Message-Id: <4b92e793462d532a05f03767151fa29db3e68e13.1677257135.git.jpoimboe@kernel.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <cover.1677257135.git.jpoimboe@kernel.org>
References: <cover.1677257135.git.jpoimboe@kernel.org>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

The current task doesn't need the scheduler's protection to unwind its
own stack.

Tested-by: Seth Forshee (DigitalOcean) <sforshee@kernel.org>
Reviewed-by: Petr Mladek <pmladek@suse.com>
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 kernel/livepatch/transition.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/kernel/livepatch/transition.c b/kernel/livepatch/transition.c
index f1b25ec581e0..4d1f443778f7 100644
--- a/kernel/livepatch/transition.c
+++ b/kernel/livepatch/transition.c
@@ -307,7 +307,11 @@ static bool klp_try_switch_task(struct task_struct *task)
 	 * functions.  If all goes well, switch the task to the target patch
 	 * state.
 	 */
-	ret = task_call_func(task, klp_check_and_switch_task, &old_name);
+	if (task == current)
+		ret = klp_check_and_switch_task(current, &old_name);
+	else
+		ret = task_call_func(task, klp_check_and_switch_task, &old_name);
+
 	switch (ret) {
 	case 0:		/* success */
 		break;
-- 
2.39.1

