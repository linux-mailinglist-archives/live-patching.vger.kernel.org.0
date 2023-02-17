Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E262D69B570
	for <lists+live-patching@lfdr.de>; Fri, 17 Feb 2023 23:23:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229573AbjBQWXD (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 17 Feb 2023 17:23:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbjBQWXC (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 17 Feb 2023 17:23:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B47AE066;
        Fri, 17 Feb 2023 14:23:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D7E51B82E67;
        Fri, 17 Feb 2023 22:22:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27D6CC433D2;
        Fri, 17 Feb 2023 22:22:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676672578;
        bh=soqJwxnfjFfPwqvDVA1zHd0RVwQAJ3bvumgTs5D6PTU=;
        h=From:To:Cc:Subject:Date:From;
        b=pqbwAvx9gV476BnOxI1ZPxn/BwklItTpv0TYKujlOcv2JAdENw3chZusPHpRRJNga
         /SKD6eRPD9Re30MqTE6SPZ2ItrZDmS6R72ismMEYaK2ZufzoCkV6wHRVcd9Z5BwqVb
         4V+6fAxxmdP3j36QsIvKK0vUV4qTiehDBvpF05wuG7xMb4sa7h5vdvurxVQfypHVAe
         m1Jb9JTRqj93xtkrStBejWZnOUI83P3j0OX7C08GELxPyzVtZLTJ1s29sKzVHeLF24
         4d+aYHXx7ai1LnsoXiM++4buo+oML9vVKr9aGzqNasVJSRe3h41mjD42hyNkXmzYk3
         KU/2ZhhglgJhA==
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
Subject: [PATCH v2 0/3] livepatch,sched: Add livepatch task switching to cond_resched()
Date:   Fri, 17 Feb 2023 14:22:53 -0800
Message-Id: <cover.1676672328.git.jpoimboe@kernel.org>
X-Mailer: git-send-email 2.39.1
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

v2:
- Avoid calling klp_cond_resched_disable() in klp_cancel_transition()
- Fix race in klp_reverse_transition()

Fix patching stalls caused by busy kthreads.

Josh Poimboeuf (3):
  livepatch: Skip task_call_func() for current task
  livepatch,sched: Add livepatch task switching to cond_resched()
  vhost: Fix livepatch timeouts in vhost_worker()

 drivers/vhost/vhost.c           |  3 +-
 include/linux/livepatch.h       |  1 +
 include/linux/livepatch_sched.h | 29 ++++++++++++
 include/linux/sched.h           | 20 ++++++--
 kernel/livepatch/transition.c   | 84 ++++++++++++++++++++++++++++-----
 kernel/sched/core.c             | 64 +++++++++++++++++++++----
 6 files changed, 174 insertions(+), 27 deletions(-)
 create mode 100644 include/linux/livepatch_sched.h

-- 
2.39.1

