Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF04E2FAC6E
	for <lists+live-patching@lfdr.de>; Mon, 18 Jan 2021 22:18:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438040AbhARVRs (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 18 Jan 2021 16:17:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:34322 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438039AbhARVRn (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Mon, 18 Jan 2021 16:17:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7C12A22D6D;
        Mon, 18 Jan 2021 21:17:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611004623;
        bh=Bf5ce9CwufzdXB6Cszk/JHnQAMJKk7yu7BGgTzZuCSo=;
        h=From:To:Cc:Subject:Date:From;
        b=LSZPSc7BWIsNzEaHLKe7yEIG9KNqgbKXfKyRktjAby0y7HZvmvU7E9JqGpqKwv8Rh
         QSEva9QcRNHTxZuQ6dcW+X4uTTN4r0q44YGcHF8iqjwICLiD3nNIozaOGvtG4727Bu
         fnppCuI1Qm8TJPShRUXdGqj2iUAsxkCdMWtA2zLZAFOGKL7b0oXDNmD/O/fmTWwO2N
         JxysIMDWOQGshoSqH9ybxjBpBCXNyTOElGKJ5OzxGorwDtuWtBsJ9viFNEGkohy3Aq
         KPGW8VFAx16F7KPqfgIJWs+gU1JKxdHyZk8MdZM5GDIq9mcqtDG0w5eT83Yo12LT/c
         VeMQF3Q1JAatA==
From:   Mark Brown <broonie@kernel.org>
To:     linux-kernel@vger.kernel.org
Cc:     Mark Brown <broonie@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        Joe Lawrence <joe.lawrence@redhat.com>, x86@kernel.org,
        linux-s390@vger.kernel.org, live-patching@vger.kernel.org
Subject: [PATCH] stacktrace: Move documentation for arch_stack_walk_reliable() to header
Date:   Mon, 18 Jan 2021 21:10:21 +0000
Message-Id: <20210118211021.42308-1-broonie@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
X-Patch-Hashes: v=1; h=sha256; i=Kh6NyXsqh0zq94gMuzBCs8afziAecd1XZurszyuxEhw=; m=lBSJGIM2NPehiVUZenL6miw4iuwRv6ZZam6wKeaI2Fc=; p=nPcWpKdBDbrmbYT1hqEf1yR8qtxRXTJfKeEoIt+tgd4=; g=f1dfd626035b5ec1394ca2d18e3f85690f794e7e
X-Patch-Sig: m=pgp; i=broonie@kernel.org; s=0xC3F436CA30F5D8EB; b=iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmAF+SQACgkQJNaLcl1Uh9Cs6wf/aqA G6y6D8pTtW7LLVv2mo8pg0eS7xvIoxAytK6r1e333xaWzTG/baO+RT+iFPwQ5yX1piIWMoq8vSyNH JxKA1KV5Z+t6GdISS7IOuhOtjmWbEinFJWrE2yxtAmav3G/mf9h/mWu5EXLO5x9yrpxJc7gABI/gt c39Sqj0qy7Yi/ObkyNxvs/xvtxWkamPxiRI8rNh0s2HNribSDoBzs2DoDzMLQnxq2830LUJreef3y rDm9nBpx/r9sKn3SAM+RNr8Oj14q0ikuS1bEjyfFtccDIE9ryO4hkhaPPltzThoSxLIQfhUUZQdCe LjzErGmpayPVgqavyekkxzbMvn/6eRg==
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Currently arch_stack_wallk_reliable() is documented with an identical
comment in both x86 and S/390 implementations which is a bit redundant.
Move this to the header and convert to kerneldoc while we're at it.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Jiri Kosina <jikos@kernel.org>
Cc: Miroslav Benes <mbenes@suse.cz>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Joe Lawrence <joe.lawrence@redhat.com>
Cc: x86@kernel.org
Cc: linux-s390@vger.kernel.org
Cc: live-patching@vger.kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
---
 arch/s390/kernel/stacktrace.c |  6 ------
 arch/x86/kernel/stacktrace.c  |  6 ------
 include/linux/stacktrace.h    | 19 +++++++++++++++++++
 3 files changed, 19 insertions(+), 12 deletions(-)

diff --git a/arch/s390/kernel/stacktrace.c b/arch/s390/kernel/stacktrace.c
index 7f1266c24f6b..101477b3e263 100644
--- a/arch/s390/kernel/stacktrace.c
+++ b/arch/s390/kernel/stacktrace.c
@@ -24,12 +24,6 @@ void arch_stack_walk(stack_trace_consume_fn consume_entry, void *cookie,
 	}
 }
 
-/*
- * This function returns an error if it detects any unreliable features of the
- * stack.  Otherwise it guarantees that the stack trace is reliable.
- *
- * If the task is not 'current', the caller *must* ensure the task is inactive.
- */
 int arch_stack_walk_reliable(stack_trace_consume_fn consume_entry,
 			     void *cookie, struct task_struct *task)
 {
diff --git a/arch/x86/kernel/stacktrace.c b/arch/x86/kernel/stacktrace.c
index 8627fda8d993..15b058eefc4e 100644
--- a/arch/x86/kernel/stacktrace.c
+++ b/arch/x86/kernel/stacktrace.c
@@ -29,12 +29,6 @@ void arch_stack_walk(stack_trace_consume_fn consume_entry, void *cookie,
 	}
 }
 
-/*
- * This function returns an error if it detects any unreliable features of the
- * stack.  Otherwise it guarantees that the stack trace is reliable.
- *
- * If the task is not 'current', the caller *must* ensure the task is inactive.
- */
 int arch_stack_walk_reliable(stack_trace_consume_fn consume_entry,
 			     void *cookie, struct task_struct *task)
 {
diff --git a/include/linux/stacktrace.h b/include/linux/stacktrace.h
index 50e2df30b0aa..9edecb494e9e 100644
--- a/include/linux/stacktrace.h
+++ b/include/linux/stacktrace.h
@@ -52,8 +52,27 @@ typedef bool (*stack_trace_consume_fn)(void *cookie, unsigned long addr);
  */
 void arch_stack_walk(stack_trace_consume_fn consume_entry, void *cookie,
 		     struct task_struct *task, struct pt_regs *regs);
+
+/**
+ * arch_stack_walk_reliable - Architecture specific function to walk the
+ *			      stack reliably
+ *
+ * @consume_entry:	Callback which is invoked by the architecture code for
+ *			each entry.
+ * @cookie:		Caller supplied pointer which is handed back to
+ *			@consume_entry
+ * @task:		Pointer to a task struct, can be NULL
+ *
+ * This function returns an error if it detects any unreliable
+ * features of the stack. Otherwise it guarantees that the stack
+ * trace is reliable.
+ *
+ * If the task is not 'current', the caller *must* ensure the task is
+ * inactive and its stack is pinned.
+ */
 int arch_stack_walk_reliable(stack_trace_consume_fn consume_entry, void *cookie,
 			     struct task_struct *task);
+
 void arch_stack_walk_user(stack_trace_consume_fn consume_entry, void *cookie,
 			  const struct pt_regs *regs);
 
-- 
2.20.1

