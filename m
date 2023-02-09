Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE98569111D
	for <lists+live-patching@lfdr.de>; Thu,  9 Feb 2023 20:18:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229512AbjBITS1 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 9 Feb 2023 14:18:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230016AbjBITS0 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 9 Feb 2023 14:18:26 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F898458A1;
        Thu,  9 Feb 2023 11:18:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C8574B8202F;
        Thu,  9 Feb 2023 19:18:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07908C433EF;
        Thu,  9 Feb 2023 19:18:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675970303;
        bh=2N2cNIU1XW5YmMOreRcBKEoSVcSbJ0JNBK/ngcNtt9Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EJ+0bCl0DYiLH3J2h2I74scxWV26SXxTDm1arHtllsr8w1Bq1EuE6aoePIvqs6ryi
         CfWcMTuzcZQCO3ceinvRXyadBcBNfkzYhtrdAnqVWVpAenvUbPrt7o97lP71TOgneU
         A8qBJefAmcCCMWG8D9fOfo2n8Fqis275rcLismrol8xdsrD11GJ0qmzqc74v06XFeV
         1ngvEc6mfBrKZeKCAl2ZvA2LV+l8vfFAkFMA93hyPUFH9JkybLkldcyVeSP0MmqHM+
         JBWKklr8/bso6Ry+CjEaHttL2xa7Geu5OzAgO6W8W/PCzHGE8tINlDYZyeqII2Og47
         atGwj4GGGuLSQ==
From:   Josh Poimboeuf <jpoimboe@kernel.org>
To:     live-patching@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Seth Forshee <sforshee@digitalocean.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Song Liu <song@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Petr Mladek <pmladek@suse.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Miroslav Benes <mbenes@suse.cz>,
        Jiri Kosina <jikos@kernel.org>, Ingo Molnar <mingo@redhat.com>
Subject: [PATCH 1/3] livepatch: Skip task_call_func() for current task
Date:   Thu,  9 Feb 2023 11:17:47 -0800
Message-Id: <fe4deb491717279f6db8c58bfaf923d964b4a2ed.1675969869.git.jpoimboe@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <cover.1675969869.git.jpoimboe@kernel.org>
References: <cover.1675969869.git.jpoimboe@kernel.org>
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
2.39.0

