Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B66E69111B
	for <lists+live-patching@lfdr.de>; Thu,  9 Feb 2023 20:18:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229537AbjBITSZ (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 9 Feb 2023 14:18:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbjBITSY (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 9 Feb 2023 14:18:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA4DC458A1;
        Thu,  9 Feb 2023 11:18:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7C14A61BA0;
        Thu,  9 Feb 2023 19:18:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 559B5C433D2;
        Thu,  9 Feb 2023 19:18:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675970302;
        bh=2hZ074pprsWhW5GxtNrfkrbBnieK8ztCBAdaCGo+uXE=;
        h=From:To:Cc:Subject:Date:From;
        b=tiXrQce6Iv8Y+NP6DJjZMlPWSBV58IibCmYibYUBtV8JdkGFBCbdEejheiVdkZiOA
         +6XmISbHDCSqbsj4vL3yuIftCQWYhRNhuXsH4ciiy3M8f5X2pB1hXxFDqgIbsy8KrR
         veEJlvhc1thPUE57e8QvItX5u9M8sJ6ZBoFuEX1kYhZqxN11qUcPVQmp34pk1Oc9Xu
         /6MI1uhvB23d620xl1no+d1rgpVvI4pG8xbjp0Hp2ixZjAzFwmXUx1fndmdXBn/feH
         7+XlJw/m+P/YQOfEQbwqmU/t6YabDERZS2Cp3yxLOn/8EFu3OL8h4bzO1DrGrtMXux
         HUD0TqN3KrzPg==
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
Subject: [PATCH 0/3] livepatch,sched: Add livepatch task switching to cond_resched()
Date:   Thu,  9 Feb 2023 11:17:46 -0800
Message-Id: <cover.1675969869.git.jpoimboe@kernel.org>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Fix patching stalls caused by busy kthreads.

Josh Poimboeuf (3):
  livepatch: Skip task_call_func() for current task
  livepatch,sched: Add livepatch task switching to cond_resched()
  vhost: Fix livepatch timeouts in vhost_worker()

 drivers/vhost/vhost.c           |  3 +-
 include/linux/livepatch.h       |  1 +
 include/linux/livepatch_sched.h | 29 +++++++++++++++
 include/linux/sched.h           | 20 ++++++++---
 kernel/livepatch/transition.c   | 60 ++++++++++++++++++++++++++++++-
 kernel/sched/core.c             | 64 ++++++++++++++++++++++++++++-----
 6 files changed, 161 insertions(+), 16 deletions(-)
 create mode 100644 include/linux/livepatch_sched.h

-- 
2.39.0

