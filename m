Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BE45223D9C
	for <lists+live-patching@lfdr.de>; Fri, 17 Jul 2020 16:04:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727055AbgGQOEg (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 17 Jul 2020 10:04:36 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:21965 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726210AbgGQOEf (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 17 Jul 2020 10:04:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594994674;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IMwwAUUq0OOq0OaEDBeXqYJMF/5C2zNXBqYrD8iYPjE=;
        b=PpfRA7x5Mr+55RN56cfkgHZIohtxP8Y5cif+p6GOl8Y2RBiqYp5LoEod3Ko+eov5jehny+
        T7M3dWOGUUgIl1zna3qWxDjnaXytckMpFi0YNKjUVKPyBeEdY4Ph4wsp7fMGdZGey/WIca
        jyMrKwt0iT2guDvktkIRTtsJwtvI0DQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-216-tmrvOvS_O_y94gYCONtZug-1; Fri, 17 Jul 2020 10:04:32 -0400
X-MC-Unique: tmrvOvS_O_y94gYCONtZug-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4CC901080;
        Fri, 17 Jul 2020 14:04:31 +0000 (UTC)
Received: from treble.redhat.com (ovpn-118-144.rdu2.redhat.com [10.10.118.144])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9F55F1EA;
        Fri, 17 Jul 2020 14:04:30 +0000 (UTC)
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     x86@kernel.org
Cc:     linux-kernel@vger.kernel.org, live-patching@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Wang ShaoBo <bobo.shaobowang@huawei.com>
Subject: [PATCH 1/2] x86/unwind/orc: Fix ORC for newly forked tasks
Date:   Fri, 17 Jul 2020 09:04:25 -0500
Message-Id: <f91a8778dde8aae7f71884b5df2b16d552040441.1594994374.git.jpoimboe@redhat.com>
In-Reply-To: <cover.1594994374.git.jpoimboe@redhat.com>
References: <cover.1594994374.git.jpoimboe@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

The ORC unwinder fails to unwind newly forked tasks which haven't yet
run on the CPU.  It correctly reads the 'ret_from_fork' instruction
pointer from the stack, but it incorrectly interprets that value as a
call stack address rather than a "signal" one, so the address gets
incorrectly decremented in the call to orc_find(), resulting in bad ORC
data.

Fix it by forcing 'ret_from_fork' frames to be signal frames.

Reported-by: Wang ShaoBo <bobo.shaobowang@huawei.com>
Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
---
 arch/x86/kernel/unwind_orc.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/unwind_orc.c b/arch/x86/kernel/unwind_orc.c
index 7f969b2d240f..ec88bbe08a32 100644
--- a/arch/x86/kernel/unwind_orc.c
+++ b/arch/x86/kernel/unwind_orc.c
@@ -440,8 +440,11 @@ bool unwind_next_frame(struct unwind_state *state)
 	/*
 	 * Find the orc_entry associated with the text address.
 	 *
-	 * Decrement call return addresses by one so they work for sibling
-	 * calls and calls to noreturn functions.
+	 * For a call frame (as opposed to a signal frame), state->ip points to
+	 * the instruction after the call.  That instruction's stack layout
+	 * could be different from the call instruction's layout, for example
+	 * if the call was to a noreturn function.  So get the ORC data for the
+	 * call instruction itself.
 	 */
 	orc = orc_find(state->signal ? state->ip : state->ip - 1);
 	if (!orc) {
@@ -662,6 +665,7 @@ void __unwind_start(struct unwind_state *state, struct task_struct *task,
 		state->sp = task->thread.sp;
 		state->bp = READ_ONCE_NOCHECK(frame->bp);
 		state->ip = READ_ONCE_NOCHECK(frame->ret_addr);
+		state->signal = (void *)state->ip == ret_from_fork;
 	}
 
 	if (get_stack_info((unsigned long *)state->sp, state->task,
-- 
2.25.4

