Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E7FE21DD0
	for <lists+live-patching@lfdr.de>; Fri, 17 May 2019 20:51:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726869AbfEQSvk (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 17 May 2019 14:51:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43834 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726732AbfEQSvk (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Fri, 17 May 2019 14:51:40 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 26FB8C09AD16;
        Fri, 17 May 2019 18:51:40 +0000 (UTC)
Received: from jlaw-desktop.bos.redhat.com (dhcp-17-208.bos.redhat.com [10.18.17.208])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 28DBC413C;
        Fri, 17 May 2019 18:51:35 +0000 (UTC)
From:   Joe Lawrence <joe.lawrence@redhat.com>
To:     live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     jikos@kernel.org, joe.lawrence@redhat.com, jpoimboe@redhat.com,
        pmladek@suse.com, tglx@linutronix.de
Subject: [PATCH] stacktrace: fix CONFIG_ARCH_STACKWALK stack_trace_save_tsk_reliable return
Date:   Fri, 17 May 2019 14:51:17 -0400
Message-Id: <20190517185117.24642-1-joe.lawrence@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.32]); Fri, 17 May 2019 18:51:40 +0000 (UTC)
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Miroslav reported that the livepatch self-tests were failing,
specifically a case in which the consistency model ensures that we do
not patch a current executing function, "TEST: busy target module".

Recent renovations to stack_trace_save_tsk_reliable() left it returning
only an -ERRNO success indication in some configuration combinations:

  klp_check_stack()
    ret = stack_trace_save_tsk_reliable()
      #ifdef CONFIG_ARCH_STACKWALK && CONFIG_HAVE_RELIABLE_STACKTRACE
        stack_trace_save_tsk_reliable()
          ret = arch_stack_walk_reliable()
            return 0
            return -EINVAL
          ...
          return ret;
    ...
    if (ret < 0)
      /* stack_trace_save_tsk_reliable error */
    nr_entries = ret;                               << 0

Previously (and currently for !CONFIG_ARCH_STACKWALK &&
CONFIG_HAVE_RELIABLE_STACKTRACE) stack_trace_save_tsk_reliable()
returned the number of entries that it consumed in the passed storage
array.

In the case of the above config and trace, be sure to return the
stacktrace_cookie.len on stack_trace_save_tsk_reliable() success.

Fixes: 25e39e32b0a3f ("livepatch: Simplify stack trace retrieval")
Reported-by: Miroslav Benes <mbenes@suse.cz>
Signed-off-by: Joe Lawrence <joe.lawrence@redhat.com>
---
 kernel/stacktrace.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/stacktrace.c b/kernel/stacktrace.c
index 27bafc1e271e..90d3e0bf0302 100644
--- a/kernel/stacktrace.c
+++ b/kernel/stacktrace.c
@@ -206,7 +206,7 @@ int stack_trace_save_tsk_reliable(struct task_struct *tsk, unsigned long *store,
 
 	ret = arch_stack_walk_reliable(consume_entry, &c, tsk);
 	put_task_stack(tsk);
-	return ret;
+	return ret ? ret : c.len;
 }
 #endif
 
-- 
2.20.1

