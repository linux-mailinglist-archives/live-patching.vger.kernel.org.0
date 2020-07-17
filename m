Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C1AD223D9A
	for <lists+live-patching@lfdr.de>; Fri, 17 Jul 2020 16:04:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726988AbgGQOEh (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 17 Jul 2020 10:04:37 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:24963 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727021AbgGQOEg (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 17 Jul 2020 10:04:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594994675;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RPasInMPBQhfNqDDCSClEwKnR8yJcnj0gbkGKH+IRS8=;
        b=OP7mVcVAUlVoII1FJ6HUXdYwoo23W6YcLuVgYz3SGPN/OVa6q53Q+Wh0HHlBfga0vubNUk
        nm6YfEEYqwYp1k93bkD/Vq+IUxWfjwIw9eA3b6oNdZGaH0fvrZJjK7d2aKYuX97tEJjnHH
        Se538EfGfDhZH3YUxSVnG90Iv0IuYqs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-144-RcK2A-9mM22zz-CDwjqxRg-1; Fri, 17 Jul 2020 10:04:33 -0400
X-MC-Unique: RcK2A-9mM22zz-CDwjqxRg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 24D3A18A1DE5;
        Fri, 17 Jul 2020 14:04:32 +0000 (UTC)
Received: from treble.redhat.com (ovpn-118-144.rdu2.redhat.com [10.10.118.144])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 74C2A1EA;
        Fri, 17 Jul 2020 14:04:31 +0000 (UTC)
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     x86@kernel.org
Cc:     linux-kernel@vger.kernel.org, live-patching@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Wang ShaoBo <bobo.shaobowang@huawei.com>
Subject: [PATCH 2/2] x86/stacktrace: Fix reliable check for empty user task stacks
Date:   Fri, 17 Jul 2020 09:04:26 -0500
Message-Id: <f136a4e5f019219cbc4f4da33b30c2f44fa65b84.1594994374.git.jpoimboe@redhat.com>
In-Reply-To: <cover.1594994374.git.jpoimboe@redhat.com>
References: <cover.1594994374.git.jpoimboe@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

If a user task's stack is empty, or if it only has user regs, ORC
reports it as a reliable empty stack.  But arch_stack_walk_reliable()
incorrectly treats it as unreliable.

That happens because the only success path for user tasks is inside the
loop, which only iterates on non-empty stacks.  Generally, a user task
must end in a user regs frame, but an empty stack is an exception to
that rule.

Thanks to commit 71c95825289f ("x86/unwind/orc: Fix error handling in
__unwind_start()"), unwind_start() now sets state->error appropriately.
So now for both ORC and FP unwinders, unwind_done() and !unwind_error()
always means the end of the stack was successfully reached.  So the
success path for kthreads is no longer needed -- it can also be used for
empty user tasks.

Reported-by: Wang ShaoBo <bobo.shaobowang@huawei.com>
Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
---
 arch/x86/kernel/stacktrace.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/arch/x86/kernel/stacktrace.c b/arch/x86/kernel/stacktrace.c
index 6ad43fc44556..2fd698e28e4d 100644
--- a/arch/x86/kernel/stacktrace.c
+++ b/arch/x86/kernel/stacktrace.c
@@ -58,7 +58,6 @@ int arch_stack_walk_reliable(stack_trace_consume_fn consume_entry,
 			 * or a page fault), which can make frame pointers
 			 * unreliable.
 			 */
-
 			if (IS_ENABLED(CONFIG_FRAME_POINTER))
 				return -EINVAL;
 		}
@@ -81,10 +80,6 @@ int arch_stack_walk_reliable(stack_trace_consume_fn consume_entry,
 	if (unwind_error(&state))
 		return -EINVAL;
 
-	/* Success path for non-user tasks, i.e. kthreads and idle tasks */
-	if (!(task->flags & (PF_KTHREAD | PF_IDLE)))
-		return -EINVAL;
-
 	return 0;
 }
 
-- 
2.25.4

