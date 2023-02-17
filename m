Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A81369B571
	for <lists+live-patching@lfdr.de>; Fri, 17 Feb 2023 23:23:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229644AbjBQWXD (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 17 Feb 2023 17:23:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229509AbjBQWXC (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 17 Feb 2023 17:23:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B80345D3EB;
        Fri, 17 Feb 2023 14:23:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6EF30B82DD0;
        Fri, 17 Feb 2023 22:23:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC44DC433EF;
        Fri, 17 Feb 2023 22:22:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676672579;
        bh=nDYIubJTBPWH5ktJId6VhvPlAhhjbmackYfSKNUBnA8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HvaqSr5PbTHNs8mAMaAmaYbTfmj4JGX1vO3kz55UvEw93l5BToEp5+PskKaCtMUeS
         OUMKsxV+tVXyKFXE+8+csdac7DIDBeylDt7DWhvsWVljlU4UlctSUoRrOmFMPlYBpv
         zgOZhnks24H2u7Ie0dgDdmYZftBRMVkj0epeKHM4sLSs17K8xg3btcsVxQ2K3C5h7u
         sva5ly/+lj6K1pMbn2gwTWJBSx0JCIp/u7aSiSH3zae9c7968ZiY97Coz7SedTHhNz
         q31EckXsm5CLqqo9HEQ7WAcVB4TnJPv7Wpy4g6/QRkUk09ZQ7s5cUGDjCVS1gHXIfJ
         Lmn9k+xGyVk3Q==
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
Subject: [PATCH v2 1/3] livepatch: Skip task_call_func() for current task
Date:   Fri, 17 Feb 2023 14:22:54 -0800
Message-Id: <4b92e793462d532a05f03767151fa29db3e68e13.1676672328.git.jpoimboe@kernel.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <cover.1676672328.git.jpoimboe@kernel.org>
References: <cover.1676672328.git.jpoimboe@kernel.org>
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

