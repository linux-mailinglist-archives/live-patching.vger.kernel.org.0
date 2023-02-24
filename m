Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62E786A2000
	for <lists+live-patching@lfdr.de>; Fri, 24 Feb 2023 17:50:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230024AbjBXQuQ (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 24 Feb 2023 11:50:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230022AbjBXQuP (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 24 Feb 2023 11:50:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 126F352DFD;
        Fri, 24 Feb 2023 08:50:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A21576193E;
        Fri, 24 Feb 2023 16:50:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 839F4C433D2;
        Fri, 24 Feb 2023 16:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677257413;
        bh=/eJtNjckHnQFplB3Qoe3dNHpdJc/ipL91nL41jMQZiw=;
        h=From:To:Cc:Subject:Date:From;
        b=TkEdBD95c8810I1jH9ym2fsI8woI1k7zAGhetcRLfUiUz5/urjNGtQY7+mcs17gVJ
         v175HRfzKCk3/ybFcUewEoYHR5UN3ZwmRBnm2mBkdgIsQyGv1rX5lNYkX8v1Y/PNrd
         j7+4E0mgjVIheduAok9GVwP8IeoXOU2M0HHoixW/ipITKsKBKysuI27E7ZcgEOa0Gv
         Z1TizjRxg/tSTMSG3GeunMXcEPSNYPLDNzz7M0IU5TVSRpy+N47B8n1m7vRKYm+SS7
         oISnGG6yFXpZc+Gs9+EOGBnUTSdCkNHiWGHuTv3jozWhG4zin04O+xhqL/gDPPwrU6
         W6KdxeFz8oKpQ==
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
Subject: [PATCH v3 0/3] livepatch,sched: Add livepatch task switching to cond_resched()
Date:   Fri, 24 Feb 2023 08:49:58 -0800
Message-Id: <cover.1677257135.git.jpoimboe@kernel.org>
X-Mailer: git-send-email 2.39.1
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

v3:
- Add barriers (pmladek)
- Update comments

v2:
- Avoid calling klp_cond_resched_disable() in klp_cancel_transition()
- Fix race in klp_reverse_transition()

Fix patching stalls caused by busy kthreads.

Josh Poimboeuf (3):
  livepatch: Skip task_call_func() for current task
  livepatch,sched: Add livepatch task switching to cond_resched()
  vhost: Fix livepatch timeouts in vhost_worker()

 drivers/vhost/vhost.c           |   3 +-
 include/linux/livepatch.h       |   1 +
 include/linux/livepatch_sched.h |  29 ++++++++
 include/linux/sched.h           |  20 ++++--
 kernel/livepatch/core.c         |   1 +
 kernel/livepatch/transition.c   | 113 +++++++++++++++++++++++++++-----
 kernel/sched/core.c             |  64 +++++++++++++++---
 7 files changed, 200 insertions(+), 31 deletions(-)
 create mode 100644 include/linux/livepatch_sched.h

-- 
2.39.1

