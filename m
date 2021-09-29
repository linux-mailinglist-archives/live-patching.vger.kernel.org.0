Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07A3A41C9B4
	for <lists+live-patching@lfdr.de>; Wed, 29 Sep 2021 18:08:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345663AbhI2QKB (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 29 Sep 2021 12:10:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344649AbhI2QJ5 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 29 Sep 2021 12:09:57 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F141C0613E4;
        Wed, 29 Sep 2021 09:02:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Type:MIME-Version:References:
        Subject:Cc:To:From:Date:Message-ID:Sender:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:In-Reply-To;
        bh=H1cuga11mvZk+h9olL/e15hBNLlFvhKrZGWUXQh2rrU=; b=KONycvIffex9Rz1f5r3Qt2sSnb
        EXXpXIrEWJ4gKJg5V2l2DRW3JFsU39NE7hBsh6bouQngBLOyVm6Te70bO43G4Etzpy34Jj95MiiKf
        ryPagaL/fsTqRfunYsbZj/1d+0W22xK+lyf69YAlOGZ4dOqw/jgv0x6o8Gz4wSc47C1NGa4XjMGmR
        Gmpfau51PaCJ/HvjwmQF8QRFenytx1qKh+K5VVuLlOgoASn58upU+IQ+0kjlQ6sYiYY4zBtiGTTmw
        d8aMbU3ETZvP0Eq+4+Q8W9OjSyfZgUWUUGQYUWHRFSiUkWTFxqXJCWh2E06xttFSWazCm30ZsADAT
        HYzOGp+g==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mVbxj-00Bz4Q-BG; Wed, 29 Sep 2021 15:57:53 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id CF627302A13;
        Wed, 29 Sep 2021 17:57:37 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 0)
        id 2F4FD2C78F4FE; Wed, 29 Sep 2021 17:57:37 +0200 (CEST)
Message-ID: <20210929152428.828064133@infradead.org>
User-Agent: quilt/0.66
Date:   Wed, 29 Sep 2021 17:17:28 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     gor@linux.ibm.com, jpoimboe@redhat.com, jikos@kernel.org,
        mbenes@suse.cz, pmladek@suse.com, mingo@kernel.org
Cc:     linux-kernel@vger.kernel.org, peterz@infradead.org,
        joe.lawrence@redhat.com, fweisbec@gmail.com, tglx@linutronix.de,
        hca@linux.ibm.com, svens@linux.ibm.com, sumanthk@linux.ibm.com,
        live-patching@vger.kernel.org, paulmck@kernel.org,
        rostedt@goodmis.org, x86@kernel.org
Subject: [PATCH v2 05/11] sched,livepatch: Use wake_up_if_idle()
References: <20210929151723.162004989@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Make sure to prod idle CPUs so they call klp_update_patch_state().

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
---
 kernel/livepatch/transition.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/kernel/livepatch/transition.c
+++ b/kernel/livepatch/transition.c
@@ -413,8 +413,11 @@ void klp_try_complete_transition(void)
 	for_each_possible_cpu(cpu) {
 		task = idle_task(cpu);
 		if (cpu_online(cpu)) {
-			if (!klp_try_switch_task(task))
+			if (!klp_try_switch_task(task)) {
 				complete = false;
+				/* Make idle task go through the main loop. */
+				wake_up_if_idle(cpu);
+			}
 		} else if (task->patch_state != klp_target_state) {
 			/* offline idle tasks can be switched immediately */
 			clear_tsk_thread_flag(task, TIF_PATCH_PENDING);


