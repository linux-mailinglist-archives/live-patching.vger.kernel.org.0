Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE66641C8E0
	for <lists+live-patching@lfdr.de>; Wed, 29 Sep 2021 17:58:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345416AbhI2P7q (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 29 Sep 2021 11:59:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344245AbhI2P7n (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 29 Sep 2021 11:59:43 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1ED8C061768;
        Wed, 29 Sep 2021 08:58:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Content-Type:MIME-Version:References:
        Subject:Cc:To:From:Date:Message-ID:Sender:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:In-Reply-To;
        bh=yH0ZIl3D+WnPvufmIHy/BePePeS6TTn7IaJYYr7glWg=; b=lPOfxrqxQN89DUvxvt8UWhflu3
        tkeWFEG80WT05t44aEQYdeBQhnCNbAmvRlZqLZotLwHx6pDxlZnaoWf5hF8dmxBUT1AMXJ23bkSYV
        s//l1W/3ubVZ9BJHSTWX3R184iFk/aAMBsYBKSnqGF3FbMV3TRNj0ZWhIb2aKqJ5hbdkPcqS1Ruhw
        drNgNy9hKIeq29bqRn5+YEeE+QkF1NMk4ocN1fG4b9bTrvwksTXtkiMedC6tyy/ZYEy7Z/uFC4Xs9
        1xyl45yWzoW7wDhp/KyJzH7aZSo2T+gyFDLyw/QwfbPohRQ5FvILk4nLisaYOKEvElNujTGeqzGY9
        CsaKcH/A==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mVbxk-006jow-AR; Wed, 29 Sep 2021 15:57:40 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id D95A9302A2C;
        Wed, 29 Sep 2021 17:57:37 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 0)
        id 564112C905DAC; Wed, 29 Sep 2021 17:57:37 +0200 (CEST)
Message-ID: <20210929152429.186930629@infradead.org>
User-Agent: quilt/0.66
Date:   Wed, 29 Sep 2021 17:17:34 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     gor@linux.ibm.com, jpoimboe@redhat.com, jikos@kernel.org,
        mbenes@suse.cz, pmladek@suse.com, mingo@kernel.org
Cc:     linux-kernel@vger.kernel.org, peterz@infradead.org,
        joe.lawrence@redhat.com, fweisbec@gmail.com, tglx@linutronix.de,
        hca@linux.ibm.com, svens@linux.ibm.com, sumanthk@linux.ibm.com,
        live-patching@vger.kernel.org, paulmck@kernel.org,
        rostedt@goodmis.org, x86@kernel.org
Subject: [RFC][PATCH v2 11/11] context_tracking,x86: Fix text_poke_sync() vs NOHZ_FULL
References: <20210929151723.162004989@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Use the new context_tracking infrastructure to avoid disturbing
userspace tasks when we rewrite kernel code.

XXX re-audit the entry code to make sure only the context_tracking
static_branch is before hitting this code.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
---
 arch/x86/include/asm/sync_core.h |    2 ++
 arch/x86/kernel/alternative.c    |    8 +++++++-
 include/linux/context_tracking.h |    1 +
 kernel/context_tracking.c        |   12 ++++++++++++
 4 files changed, 22 insertions(+), 1 deletion(-)

--- a/arch/x86/include/asm/sync_core.h
+++ b/arch/x86/include/asm/sync_core.h
@@ -87,6 +87,8 @@ static inline void sync_core(void)
 	 */
 	iret_to_self();
 }
+#define sync_core sync_core
+
 
 /*
  * Ensure that a core serializing instruction is issued before returning
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -18,6 +18,7 @@
 #include <linux/mmu_context.h>
 #include <linux/bsearch.h>
 #include <linux/sync_core.h>
+#include <linux/context_tracking.h>
 #include <asm/text-patching.h>
 #include <asm/alternative.h>
 #include <asm/sections.h>
@@ -924,9 +925,14 @@ static void do_sync_core(void *info)
 	sync_core();
 }
 
+static bool do_sync_core_cond(int cpu, void *info)
+{
+	return !context_tracking_set_cpu_work(cpu, CT_WORK_SYNC);
+}
+
 void text_poke_sync(void)
 {
-	on_each_cpu(do_sync_core, NULL, 1);
+	on_each_cpu_cond(do_sync_core_cond, do_sync_core, NULL, 1);
 }
 
 struct text_poke_loc {
--- a/include/linux/context_tracking.h
+++ b/include/linux/context_tracking.h
@@ -11,6 +11,7 @@
 
 enum ct_work {
 	CT_WORK_KLP = 1,
+	CT_WORK_SYNC = 2,
 };
 
 /*
--- a/kernel/context_tracking.c
+++ b/kernel/context_tracking.c
@@ -51,6 +51,10 @@ static __always_inline void context_trac
 	__this_cpu_dec(context_tracking.recursion);
 }
 
+#ifndef sync_core
+static inline void sync_core(void) { }
+#endif
+
 /* CT_WORK_n, must be noinstr, non-blocking, NMI safe and deal with spurious calls */
 static noinstr void ct_exit_user_work(struct context_tracking *ct)
 {
@@ -64,6 +68,14 @@ static noinstr void ct_exit_user_work(struct
 		arch_atomic_andnot(CT_WORK_KLP, &ct->work);
 	}
 
+	if (work & CT_WORK_SYNC) {
+		/* NMI happens here and must still do/finish CT_WORK_n */
+		sync_core();
+
+		smp_mb__before_atomic();
+		arch_atomic_andnot(CT_WORK_SYNC, &ct->work);
+	}
+
 	smp_mb__before_atomic();
 	arch_atomic_andnot(CT_SEQ_WORK, &ct->seq);
 }


