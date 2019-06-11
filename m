Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3C333CE3D
	for <lists+live-patching@lfdr.de>; Tue, 11 Jun 2019 16:15:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387593AbfFKONg (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 11 Jun 2019 10:13:36 -0400
Received: from mx2.suse.de ([195.135.220.15]:44152 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728309AbfFKON1 (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Tue, 11 Jun 2019 10:13:27 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 62D89AEEE;
        Tue, 11 Jun 2019 14:13:25 +0000 (UTC)
From:   Miroslav Benes <mbenes@suse.cz>
To:     jpoimboe@redhat.com, jikos@kernel.org, pmladek@suse.com
Cc:     joe.lawrence@redhat.com, kamalesh@linux.vnet.ibm.com,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        Miroslav Benes <mbenes@suse.cz>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH v4 1/3] stacktrace: Remove weak version of save_stack_trace_tsk_reliable()
Date:   Tue, 11 Jun 2019 16:13:18 +0200
Message-Id: <20190611141320.25359-2-mbenes@suse.cz>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190611141320.25359-1-mbenes@suse.cz>
References: <20190611141320.25359-1-mbenes@suse.cz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Recent rework of stack trace infrastructure introduced a new set of
helpers for common stack trace operations (commit e9b98e162aa5
("stacktrace: Provide helpers for common stack trace operations") and
related). As a result, save_stack_trace_tsk_reliable() is not directly
called anywhere. Livepatch, currently the only user of the reliable
stack trace feature, now calls stack_trace_save_tsk_reliable().

When CONFIG_HAVE_RELIABLE_STACKTRACE is set and depending on
CONFIG_ARCH_STACKWALK, stack_trace_save_tsk_reliable() calls either
arch_stack_walk_reliable() or mentioned save_stack_trace_tsk_reliable().
x86_64 defines the former, ppc64le the latter. All other architectures
do not have HAVE_RELIABLE_STACKTRACE and include/linux/stacktrace.h
defines -ENOSYS returning version for them.

In short, stack_trace_save_tsk_reliable() returning -ENOSYS defined in
include/linux/stacktrace.h serves the same purpose as the old weak
version of save_stack_trace_tsk_reliable() which is therefore no longer
needed.

Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Miroslav Benes <mbenes@suse.cz>
---
 kernel/stacktrace.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/kernel/stacktrace.c b/kernel/stacktrace.c
index 36139de0a3c4..0c3f00db9069 100644
--- a/kernel/stacktrace.c
+++ b/kernel/stacktrace.c
@@ -255,14 +255,6 @@ save_stack_trace_regs(struct pt_regs *regs, struct stack_trace *trace)
 	WARN_ONCE(1, KERN_INFO "save_stack_trace_regs() not implemented yet.\n");
 }
 
-__weak int
-save_stack_trace_tsk_reliable(struct task_struct *tsk,
-			      struct stack_trace *trace)
-{
-	WARN_ONCE(1, KERN_INFO "save_stack_tsk_reliable() not implemented yet.\n");
-	return -ENOSYS;
-}
-
 /**
  * stack_trace_save - Save a stack trace into a storage array
  * @store:	Pointer to storage array
-- 
2.21.0

