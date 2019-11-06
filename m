Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8AC71F12FC
	for <lists+live-patching@lfdr.de>; Wed,  6 Nov 2019 10:56:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727543AbfKFJ4F (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 6 Nov 2019 04:56:05 -0500
Received: from mx2.suse.de ([195.135.220.15]:49956 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725906AbfKFJ4E (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Wed, 6 Nov 2019 04:56:04 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 3B03EAFE3;
        Wed,  6 Nov 2019 09:56:03 +0000 (UTC)
From:   Miroslav Benes <mbenes@suse.cz>
To:     heiko.carstens@de.ibm.com, gor@linux.ibm.com,
        borntraeger@de.ibm.com, jpoimboe@redhat.com,
        joe.lawrence@redhat.com
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        jikos@kernel.org, pmladek@suse.com, nstange@suse.de,
        live-patching@vger.kernel.org, Miroslav Benes <mbenes@suse.cz>
Subject: [PATCH v3 1/4] s390/unwind: drop unnecessary code around calling ftrace_graph_ret_addr()
Date:   Wed,  6 Nov 2019 10:55:58 +0100
Message-Id: <20191106095601.29986-2-mbenes@suse.cz>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191106095601.29986-1-mbenes@suse.cz>
References: <20191106095601.29986-1-mbenes@suse.cz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

The current code around calling ftrace_graph_ret_addr() is ifdeffed and
also tests if ftrace redirection is present on stack.
ftrace_graph_ret_addr() however performs the test internally and there
is a version for !CONFIG_FUNCTION_GRAPH_TRACER as well. The unnecessary
code can thus be dropped.

Signed-off-by: Miroslav Benes <mbenes@suse.cz>
---
 arch/s390/kernel/unwind_bc.c | 16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

diff --git a/arch/s390/kernel/unwind_bc.c b/arch/s390/kernel/unwind_bc.c
index a8204f952315..5a78deacb972 100644
--- a/arch/s390/kernel/unwind_bc.c
+++ b/arch/s390/kernel/unwind_bc.c
@@ -85,12 +85,8 @@ bool unwind_next_frame(struct unwind_state *state)
 		}
 	}
 
-#ifdef CONFIG_FUNCTION_GRAPH_TRACER
-	/* Decode any ftrace redirection */
-	if (ip == (unsigned long) return_to_handler)
-		ip = ftrace_graph_ret_addr(state->task, &state->graph_idx,
-					   ip, (void *) sp);
-#endif
+	ip = ftrace_graph_ret_addr(state->task, &state->graph_idx,
+				   ip, (void *) sp);
 
 	/* Update unwind state */
 	state->sp = sp;
@@ -147,12 +143,8 @@ void __unwind_start(struct unwind_state *state, struct task_struct *task,
 		reuse_sp = false;
 	}
 
-#ifdef CONFIG_FUNCTION_GRAPH_TRACER
-	/* Decode any ftrace redirection */
-	if (ip == (unsigned long) return_to_handler)
-		ip = ftrace_graph_ret_addr(state->task, &state->graph_idx,
-					   ip, NULL);
-#endif
+	ip = ftrace_graph_ret_addr(state->task, &state->graph_idx,
+				   ip, NULL);
 
 	/* Update unwind state */
 	state->sp = sp;
-- 
2.23.0

