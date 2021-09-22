Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1B8D41479C
	for <lists+live-patching@lfdr.de>; Wed, 22 Sep 2021 13:16:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235647AbhIVLR7 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 22 Sep 2021 07:17:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235795AbhIVLRp (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 22 Sep 2021 07:17:45 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 340EBC061766;
        Wed, 22 Sep 2021 04:14:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Type:MIME-Version:References:
        Subject:Cc:To:From:Date:Message-ID:Sender:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:In-Reply-To;
        bh=w4yjs1qO3xsnfIJqTqBPsoNNOmUosIvX58CvlthR2e8=; b=A27MTIQFIyu5o+A16naspB7PLN
        DuuzFJv5cNEHib7wkMEJtOLeusHTVL5JYmx0SqKAg7oYsE/nfej+G966FWlnGSytZMw6YQykd0iDm
        UPzHxijo5LzXucj1Qa73eS0rtFuQm/MVYhaJnkrw/OnXitvfHVrjD4hW0KnI9LeWO4ZLSwfRxMNoQ
        ynrqwLKpvRriFhWct47p0RwEJzeGVfX8auiTtZzN4jjV6QhdXD1I+PGGifTYCfEHxynwgn/ysIjGc
        6JOc7WfYRsighqpaz7u/gHJi14tiyYLwlDzhqYoW5ExvySUMvzkf8OX6MFQYk4nd8VZN6oiCjOd6F
        eb/1AUlQ==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mT09o-004isE-Ue; Wed, 22 Sep 2021 11:11:37 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 3EDC2300EC3;
        Wed, 22 Sep 2021 13:11:19 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 0)
        id 9098A206A3E34; Wed, 22 Sep 2021 13:11:18 +0200 (CEST)
Message-ID: <20210922110836.244770922@infradead.org>
User-Agent: quilt/0.66
Date:   Wed, 22 Sep 2021 13:05:12 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     gor@linux.ibm.com, jpoimboe@redhat.com, jikos@kernel.org,
        mbenes@suse.cz, pmladek@suse.com, mingo@kernel.org
Cc:     linux-kernel@vger.kernel.org, peterz@infradead.org,
        joe.lawrence@redhat.com, fweisbec@gmail.com, tglx@linutronix.de,
        hca@linux.ibm.com, svens@linux.ibm.com, sumanthk@linux.ibm.com,
        live-patching@vger.kernel.org, paulmck@kernel.org
Subject: [RFC][PATCH 6/7] context_tracking: Provide SMP ordering using RCU
References: <20210922110506.703075504@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Use rcu_user_{enter,exit}() calls to provide SMP ordering on context
tracking state stores:

__context_tracking_exit()
  __this_cpu_write(context_tracking.state, CONTEXT_KERNEL)
  rcu_user_exit()
    rcu_eqs_exit()
      rcu_dynticks_eqs_eit()
        rcu_dynticks_inc()
          atomic_add_return() /* smp_mb */

__context_tracking_enter()
  rcu_user_enter()
    rcu_eqs_enter()
      rcu_dynticks_eqs_enter()
        rcu_dynticks_inc()
	  atomic_add_return() /* smp_mb */
  __this_cpu_write(context_tracking.state, state)

This separates USER/KERNEL state with an smp_mb() on each side,
therefore, a user of context_tracking_state_cpu() can say the CPU must
pass through an smp_mb() before changing.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
---
 include/linux/context_tracking_state.h |   12 ++++++++++++
 kernel/context_tracking.c              |    7 ++++---
 2 files changed, 16 insertions(+), 3 deletions(-)

--- a/include/linux/context_tracking_state.h
+++ b/include/linux/context_tracking_state.h
@@ -45,11 +45,23 @@ static __always_inline bool context_trac
 {
 	return __this_cpu_read(context_tracking.state) == CONTEXT_USER;
 }
+
+static __always_inline bool context_tracking_state_cpu(int cpu)
+{
+	struct context_tracking *ct = per_cpu_ptr(&context_tracking);
+
+	if (!context_tracking_enabled() || !ct->active)
+		return CONTEXT_DISABLED;
+
+	return ct->state;
+}
+
 #else
 static inline bool context_tracking_in_user(void) { return false; }
 static inline bool context_tracking_enabled(void) { return false; }
 static inline bool context_tracking_enabled_cpu(int cpu) { return false; }
 static inline bool context_tracking_enabled_this_cpu(void) { return false; }
+static inline bool context_tracking_state_cpu(int cpu) { return CONTEXT_DISABLED; }
 #endif /* CONFIG_CONTEXT_TRACKING */
 
 #endif
--- a/kernel/context_tracking.c
+++ b/kernel/context_tracking.c
@@ -82,7 +82,7 @@ void noinstr __context_tracking_enter(en
 				vtime_user_enter(current);
 				instrumentation_end();
 			}
-			rcu_user_enter();
+			rcu_user_enter(); /* smp_mb */
 		}
 		/*
 		 * Even if context tracking is disabled on this CPU, because it's outside
@@ -149,12 +149,14 @@ void noinstr __context_tracking_exit(enu
 		return;
 
 	if (__this_cpu_read(context_tracking.state) == state) {
+		__this_cpu_write(context_tracking.state, CONTEXT_KERNEL);
+
 		if (__this_cpu_read(context_tracking.active)) {
 			/*
 			 * We are going to run code that may use RCU. Inform
 			 * RCU core about that (ie: we may need the tick again).
 			 */
-			rcu_user_exit();
+			rcu_user_exit(); /* smp_mb */
 			if (state == CONTEXT_USER) {
 				instrumentation_begin();
 				vtime_user_exit(current);
@@ -162,7 +164,6 @@ void noinstr __context_tracking_exit(enu
 				instrumentation_end();
 			}
 		}
-		__this_cpu_write(context_tracking.state, CONTEXT_KERNEL);
 	}
 	context_tracking_recursion_exit();
 }


