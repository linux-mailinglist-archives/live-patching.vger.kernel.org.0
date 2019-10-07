Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9CBBCCDD05
	for <lists+live-patching@lfdr.de>; Mon,  7 Oct 2019 10:17:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727504AbfJGIRT (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 7 Oct 2019 04:17:19 -0400
Received: from mx2.suse.de ([195.135.220.15]:56256 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727477AbfJGIRT (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Mon, 7 Oct 2019 04:17:19 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 69ADFAE4D;
        Mon,  7 Oct 2019 08:17:17 +0000 (UTC)
From:   Miroslav Benes <mbenes@suse.cz>
To:     rostedt@goodmis.org, mingo@redhat.com, jpoimboe@redhat.com,
        jikos@kernel.org, pmladek@suse.com, joe.lawrence@redhat.com
Cc:     linux-kernel@vger.kernel.org, live-patching@vger.kernel.org,
        Miroslav Benes <mbenes@suse.cz>
Subject: [PATCH 1/3] ftrace: Make test_rec_ops_needs_regs() generic
Date:   Mon,  7 Oct 2019 10:17:12 +0200
Message-Id: <20191007081714.20259-2-mbenes@suse.cz>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191007081714.20259-1-mbenes@suse.cz>
References: <20191007081714.20259-1-mbenes@suse.cz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Function test_rec_ops_needs_regs() tests whether ftrace_ops registered
on a record needs saved regs. That is, it tests for
FTRACE_OPS_FL_SAVE_REGS being set.

The same logic will be reused for newly introduced
FTRACE_OPS_FL_PERMANENT flag, so make the function generic.

Signed-off-by: Miroslav Benes <mbenes@suse.cz>
---
 kernel/trace/ftrace.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 62a50bf399d6..a37c1127599c 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -1602,24 +1602,24 @@ int ftrace_text_reserved(const void *start, const void *end)
 	return (int)!!ret;
 }
 
-/* Test if ops registered to this rec needs regs */
-static bool test_rec_ops_needs_regs(struct dyn_ftrace *rec)
+/* Test if ops registered to this rec needs to have a specified flag set */
+static bool test_rec_ops_needs_flag(struct dyn_ftrace *rec, int flag)
 {
 	struct ftrace_ops *ops;
-	bool keep_regs = false;
+	bool keep_flag = false;
 
 	for (ops = ftrace_ops_list;
 	     ops != &ftrace_list_end; ops = ops->next) {
 		/* pass rec in as regs to have non-NULL val */
 		if (ftrace_ops_test(ops, rec->ip, rec)) {
-			if (ops->flags & FTRACE_OPS_FL_SAVE_REGS) {
-				keep_regs = true;
+			if (ops->flags & flag) {
+				keep_flag = true;
 				break;
 			}
 		}
 	}
 
-	return  keep_regs;
+	return keep_flag;
 }
 
 static struct ftrace_ops *
@@ -1750,7 +1750,8 @@ static bool __ftrace_hash_rec_update(struct ftrace_ops *ops,
 			if (ftrace_rec_count(rec) > 0 &&
 			    rec->flags & FTRACE_FL_REGS &&
 			    ops->flags & FTRACE_OPS_FL_SAVE_REGS) {
-				if (!test_rec_ops_needs_regs(rec))
+				if (!test_rec_ops_needs_flag(rec,
+						FTRACE_OPS_FL_SAVE_REGS))
 					rec->flags &= ~FTRACE_FL_REGS;
 			}
 
-- 
2.23.0

