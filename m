Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 041FD30994
	for <lists+live-patching@lfdr.de>; Fri, 31 May 2019 09:42:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726916AbfEaHmI (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 31 May 2019 03:42:08 -0400
Received: from mx2.suse.de ([195.135.220.15]:41322 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726403AbfEaHmI (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Fri, 31 May 2019 03:42:08 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 822B4AE15;
        Fri, 31 May 2019 07:42:07 +0000 (UTC)
From:   Petr Mladek <pmladek@suse.com>
To:     Jiri Kosina <jikos@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Miroslav Benes <mbenes@suse.cz>
Cc:     Joe Lawrence <joe.lawrence@redhat.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        Petr Mladek <pmladek@suse.com>
Subject: [PATCH 1/3] stacktrace: Remove superfluous WARN_ONCE() from save_stack_trace_tsk_reliable()
Date:   Fri, 31 May 2019 09:41:45 +0200
Message-Id: <20190531074147.27616-2-pmladek@suse.com>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20190531074147.27616-1-pmladek@suse.com>
References: <20190531074147.27616-1-pmladek@suse.com>
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

WARN_ONCE() in the generic save_stack_trace_tsk_reliable() is superfluous.

The information is passed also via the return value. The only current
user klp_check_stack() writes its own warning when the reliable stack
traces are not supported. Other eventual users might want its own error
handling as well.

Signed-off-by: Petr Mladek <pmladek@suse.com>
Acked-by: Miroslav Benes <mbenes@suse.cz>
Reviewed-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
---
 kernel/stacktrace.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/kernel/stacktrace.c b/kernel/stacktrace.c
index 5667f1da3ede..8d088408928d 100644
--- a/kernel/stacktrace.c
+++ b/kernel/stacktrace.c
@@ -259,7 +259,6 @@ __weak int
 save_stack_trace_tsk_reliable(struct task_struct *tsk,
 			      struct stack_trace *trace)
 {
-	WARN_ONCE(1, KERN_INFO "save_stack_tsk_reliable() not implemented yet.\n");
 	return -ENOSYS;
 }
 
-- 
2.16.4

