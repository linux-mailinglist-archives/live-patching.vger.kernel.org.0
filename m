Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1EFDD58F9B
	for <lists+live-patching@lfdr.de>; Fri, 28 Jun 2019 03:18:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726633AbfF1BSX (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 27 Jun 2019 21:18:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:51456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726606AbfF1BSX (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Thu, 27 Jun 2019 21:18:23 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 048B0208CB;
        Fri, 28 Jun 2019 01:18:20 +0000 (UTC)
Date:   Thu, 27 Jun 2019 21:18:19 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     Josh Poimboeuf <jpoimboe@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Petr Mladek <pmladek@suse.com>,
        Miroslav Benes <mbenes@suse.cz>, Jessica Yu <jeyu@kernel.org>,
        Jiri Kosina <jikos@kernel.org>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        live-patching@vger.kernel.org,
        Johannes Erdfelt <johannes@erdfelt.com>,
        Ingo Molnar <mingo@kernel.org>, mhiramat@kernel.org,
        torvalds@linux-foundation.org
Subject: [PATCH] ftrace/x86: Add a comment to why we take text_mutex in
 ftrace_arch_code_modify_prepare()
Message-ID: <20190627211819.5a591f52@gandalf.local.home>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org


From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

Taking the text_mutex in ftrace_arch_code_modify_prepare() is to fix a
race against module loading and live kernel patching that might try to
change the text permissions while ftrace has it as read/write. This
really needs to be documented in the code. Add a comment that does such.

Suggested-by: Josh Poimboeuf <jpoimboe@redhat.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 arch/x86/kernel/ftrace.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index 33786044d5ac..d7e93b2783fd 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -36,6 +36,11 @@
 
 int ftrace_arch_code_modify_prepare(void)
 {
+	/*
+	 * Need to grab text_mutex to prevent a race from module loading
+	 * and live kernel patching from changing the text permissions while
+	 * ftrace has it set to "read/write".
+	 */
 	mutex_lock(&text_mutex);
 	set_kernel_text_rw();
 	set_all_modules_text_rw();
-- 
2.20.1

