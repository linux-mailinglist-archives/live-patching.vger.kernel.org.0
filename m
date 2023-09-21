Return-Path: <live-patching+bounces-6-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DEFEA7AA593
	for <lists+live-patching@lfdr.de>; Fri, 22 Sep 2023 01:25:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sv.mirrors.kernel.org (Postfix) with ESMTP id 3EBB4282E1D
	for <lists+live-patching@lfdr.de>; Thu, 21 Sep 2023 23:25:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E19BD17740;
	Thu, 21 Sep 2023 23:25:05 +0000 (UTC)
X-Original-To: live-patching@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BF72168A3
	for <live-patching@vger.kernel.org>; Thu, 21 Sep 2023 23:25:02 +0000 (UTC)
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8B5F132
	for <live-patching@vger.kernel.org>; Thu, 21 Sep 2023 16:24:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ellerman.id.au;
	s=201909; t=1695338697;
	bh=VoF4uRzaSr8w0JBh2rKYRjrXNhC07lhe6aFDqvXGhlY=;
	h=From:To:Cc:Subject:Date:From;
	b=Fd1Cb/NBStWhfP2RAADceD6EGVt3g3PGwSLOM1JZN6YQdXOG1ggvjZNNoJZY9YXSN
	 CEXO6EBKlwL+A3R0hi9iOFWw2Xyrfj3f5f+gcGoEfa2V+XVYyE+RkPBLi44zRh6SYS
	 3LP9GXtByYOgYJmqzlszLNiEKteJyiXGvRQinIcw3vO1ma65EbyZYTuPMCr49Zc1UE
	 IsY1DVxvMOMzQNdpxOhOiJ3+5qN0Nqy25mxLwCqOfHLfTxuvRVBuC2Jvo/x5HLBA3W
	 kWsyBgGjXs+oA/KFlt6TAapgjRZ4+z16JL2HUxxx0PbSouGPQ60SEP3g9WbzJ6iVGv
	 In76krxXQyNlg==
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.ozlabs.org (Postfix) with ESMTPSA id 4RsBMF2KJQz4x3H;
	Fri, 22 Sep 2023 09:24:57 +1000 (AEST)
From: Michael Ellerman <mpe@ellerman.id.au>
To: <linuxppc-dev@lists.ozlabs.org>
Cc: <npiggin@gmail.com>,
	joe.lawrence@redhat.com,
	pmladek@suse.com,
	live-patching@vger.kernel.org
Subject: [PATCH] powerpc/stacktrace: Fix arch_stack_walk_reliable()
Date: Fri, 22 Sep 2023 09:24:41 +1000
Message-ID: <20230921232441.1181843-1-mpe@ellerman.id.au>
X-Mailer: git-send-email 2.41.0
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

The changes to copy_thread() made in commit eed7c420aac7 ("powerpc:
copy_thread differentiate kthreads and user mode threads") inadvertently
broke arch_stack_walk_reliable() because it has knowledge of the stack
layout.

Fix it by changing the condition to match the new logic in
copy_thread(). The changes make the comments about the stack layout
incorrect, rather than rephrasing them just refer the reader to
copy_thread().

Also the comment about the stack backchain is no longer true, since
commit edbd0387f324 ("powerpc: copy_thread add a back chain to the
switch stack frame"), so remove that as well.

Reported-by: Joe Lawrence <joe.lawrence@redhat.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Fixes: eed7c420aac7 ("powerpc: copy_thread differentiate kthreads and user mode threads")
---
 arch/powerpc/kernel/stacktrace.c | 27 +++++----------------------
 1 file changed, 5 insertions(+), 22 deletions(-)

diff --git a/arch/powerpc/kernel/stacktrace.c b/arch/powerpc/kernel/stacktrace.c
index b15f15dcacb5..e6a958a5da27 100644
--- a/arch/powerpc/kernel/stacktrace.c
+++ b/arch/powerpc/kernel/stacktrace.c
@@ -73,29 +73,12 @@ int __no_sanitize_address arch_stack_walk_reliable(stack_trace_consume_fn consum
 	bool firstframe;
 
 	stack_end = stack_page + THREAD_SIZE;
-	if (!is_idle_task(task)) {
-		/*
-		 * For user tasks, this is the SP value loaded on
-		 * kernel entry, see "PACAKSAVE(r13)" in _switch() and
-		 * system_call_common().
-		 *
-		 * Likewise for non-swapper kernel threads,
-		 * this also happens to be the top of the stack
-		 * as setup by copy_thread().
-		 *
-		 * Note that stack backlinks are not properly setup by
-		 * copy_thread() and thus, a forked task() will have
-		 * an unreliable stack trace until it's been
-		 * _switch()'ed to for the first time.
-		 */
-		stack_end -= STACK_USER_INT_FRAME_SIZE;
-	} else {
-		/*
-		 * idle tasks have a custom stack layout,
-		 * c.f. cpu_idle_thread_init().
-		 */
+
+	// See copy_thread() for details.
+	if (task->flags & PF_KTHREAD)
 		stack_end -= STACK_FRAME_MIN_SIZE;
-	}
+	else
+		stack_end -= STACK_USER_INT_FRAME_SIZE;
 
 	if (task == current)
 		sp = current_stack_frame();
-- 
2.41.0


