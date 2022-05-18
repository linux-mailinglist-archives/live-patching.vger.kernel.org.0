Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB78152C186
	for <lists+live-patching@lfdr.de>; Wed, 18 May 2022 19:50:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240921AbiERRej (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 18 May 2022 13:34:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240955AbiERRei (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 18 May 2022 13:34:38 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 529BDBCE9C
        for <live-patching@vger.kernel.org>; Wed, 18 May 2022 10:34:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652895270;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=k7oz4e4aJMs7N3/jTHMdgyAk86Qj1FfimALtt+HOfaM=;
        b=e9kpU+wKETcynWaCM5MAy2shjZICMMTm9LqlierTJQKvDbn6WTQ/oghBDV5d2hLXXwjkX0
        mTu1okNzjDlZSlawW260+BhcUyXcMwOsw4bO89hSnPOLVyzpalXufT/N6MJy4uuoLbTlOy
        JPIfGuA17egewKzhC4CDg5Pspvm2ilk=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-25-G-dRTGqiNbucaO0_1zwP5g-1; Wed, 18 May 2022 13:34:27 -0400
X-MC-Unique: G-dRTGqiNbucaO0_1zwP5g-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 80BA83C60520;
        Wed, 18 May 2022 17:34:26 +0000 (UTC)
Received: from jlaw-desktop.redhat.com (unknown [10.22.16.62])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 25C5240C1421;
        Wed, 18 May 2022 17:34:26 +0000 (UTC)
From:   Joe Lawrence <joe.lawrence@redhat.com>
To:     live-patching@vger.kernel.org
Cc:     Joe Lawrence <joe.lawrence@redhat.com>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>, Yannick Cote <ycote@suse.com>
Subject: [PATCH] selftests/livepatch: better synchronize test_klp_callbacks_busy
Date:   Wed, 18 May 2022 13:34:24 -0400
Message-Id: <20220518173424.911649-1-joe.lawrence@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

The test_klp_callbacks_busy module conditionally blocks a future
livepatch transition by busy waiting inside its workqueue function,
busymod_work_func().  After scheduling this work, a test livepatch is
loaded, introducing the transition under test.

Both events are marked in the kernel log for later verification, but
there is no synchronization to ensure that busymod_work_func() logs its
function entry message before subsequent selftest commands log their own
messages.  This can lead to a rare test failure due to unexpected
ordering like:

  --- expected
  +++ result
  @@ -1,7 +1,7 @@
   % modprobe test_klp_callbacks_busy block_transition=Y
   test_klp_callbacks_busy: test_klp_callbacks_busy_init
  -test_klp_callbacks_busy: busymod_work_func enter
   % modprobe test_klp_callbacks_demo
  +test_klp_callbacks_busy: busymod_work_func enter
   livepatch: enabling patch 'test_klp_callbacks_demo'
   livepatch: 'test_klp_callbacks_demo': initializing patching transition
   test_klp_callbacks_demo: pre_patch_callback: vmlinux

Force the module init function to wait until busymod_work_func() has
started (and logged its message), before exiting to the next selftest
steps.

Fixes: 547840bd5ae5 ("selftests/livepatch: simplify test-klp-callbacks busy target tests")
Signed-off-by: Joe Lawrence <joe.lawrence@redhat.com>
---

Hi Petr, I remember you discouraged against a completion variable the
first time around [1], but is there any better way with the workqueue
API to ensure our "enter" message gets logged first?  Or should we just
drop the msg altogether to avoid the situation?  I don't think it's
absolutely necessary for the tests.

[1] https://lore.kernel.org/live-patching/20200602081654.GI27273@linux-b0ei/

 lib/livepatch/test_klp_callbacks_busy.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/lib/livepatch/test_klp_callbacks_busy.c b/lib/livepatch/test_klp_callbacks_busy.c
index 7ac845f65be5..eb502b2bb3ef 100644
--- a/lib/livepatch/test_klp_callbacks_busy.c
+++ b/lib/livepatch/test_klp_callbacks_busy.c
@@ -16,10 +16,16 @@ MODULE_PARM_DESC(block_transition, "block_transition (default=false)");
 
 static void busymod_work_func(struct work_struct *work);
 static DECLARE_WORK(work, busymod_work_func);
+static DECLARE_COMPLETION(busymod_work_started);
 
 static void busymod_work_func(struct work_struct *work)
 {
+	/*
+	 * Hold the init function from exiting until we've started and
+	 * announced our appearence in the kernel log.
+	 */
 	pr_info("%s enter\n", __func__);
+	complete(&busymod_work_started);
 
 	while (READ_ONCE(block_transition)) {
 		/*
@@ -36,6 +42,7 @@ static int test_klp_callbacks_busy_init(void)
 {
 	pr_info("%s\n", __func__);
 	schedule_work(&work);
+	wait_for_completion(&busymod_work_started);
 
 	if (!block_transition) {
 		/*
-- 
2.26.3

