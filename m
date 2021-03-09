Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CFB2332F34
	for <lists+live-patching@lfdr.de>; Tue,  9 Mar 2021 20:43:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231326AbhCITnL (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 9 Mar 2021 14:43:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:37266 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231243AbhCITmn (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Tue, 9 Mar 2021 14:42:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AE34265228;
        Tue,  9 Mar 2021 19:42:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615318963;
        bh=ZhUp65qT2Edv35cPfVcgVPA1Vr3DqEzB5OQkhdx4Dz0=;
        h=From:To:Cc:Subject:Date:From;
        b=ArJFusyN7UERXhJENyeMvV7NnlyWuWh8BovqPV29pBUzaU0ioiO103V0S7dVRRO6X
         4mcpPaZabsPcORzLRWpfQK2dw7Pda562qM5Mx7DBbXPH4xI69Bnmzg0Uq7wm/R4EKL
         nT0sPxNqrzh2ZwfwMQONp6Xo28t8ezPf+N7ifGWq62S5gGV/WIJtMNc7vRdvGmmtov
         mqFXp0247nSaQnaLBzjzO4LiwIHykdpcN2+ur7yS2Ezy9rPqgIxluRdZK41a7Otibs
         Fh5cNfGZ/nJdSPnV8qVZlfQpFTNfVHlk62TIes7fQ/fTS1GTBOs+mF/CxH164s9f02
         B7ST17bZQTRWQ==
From:   Mark Brown <broonie@kernel.org>
To:     linux-kernel@vger.kernel.org
Cc:     Mark Brown <broonie@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jikos@kernel.org>, Petr Mladek <pmladek@suse.com>,
        Joe Lawrence <joe.lawrence@redhat.com>, x86@kernel.org,
        linux-s390@vger.kernel.org, live-patching@vger.kernel.org,
        Vasily Gorbik <gor@linux.ibm.com>,
        Miroslav Benes <mbenes@suse.cz>
Subject: [PATCH] stacktrace: Move documentation for arch_stack_walk_reliable() to header
Date:   Tue,  9 Mar 2021 19:41:25 +0000
Message-Id: <20210309194125.652-1-broonie@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
X-Patch-Hashes: v=1; h=sha256; i=Kh6NyXsqh0zq94gMuzBCs8afziAecd1XZurszyuxEhw=; m=/jKBVe0RfPWMav8OjafUnXErqEkBoTiYB/rI2TxCriw=; p=nPcWpKdBDbrmbYT1hqEf1yR8qtxRXTJfKeEoIt+tgd4=; g=f1dfd626035b5ec1394ca2d18e3f85690f794e7e
X-Patch-Sig: m=pgp; i=broonie@kernel.org; s=0xC3F436CA30F5D8EB; b=iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmBHz1sACgkQJNaLcl1Uh9Au4AgAghj XD7vbxyItKIAkn2Tx0Ks3t5LR/K2p5yRT3CgHpvU4Jshp/08F7etkVHNAZSRbuzatlr6xDMecPhB8 bHfClUAz9GqGQh6IYvJhflL+fSwscO2OJTeColxwFL25VVaRANnro+vqi++RiVCIBHP3zTtT94xRp XruEbwfVqOqfXbr1ZMn4kx3nM3IL2Ht//KrBEzG2c9oBRP5uK+e+GYZ7se4FYNtPTXpWnkFpXi4Pb Fv7qHPimm9tFXsRc0yo8YLKwtsT4afjkxr6E/HmbVXLct6VHTIRQo4CW8eA2/DeZACFQvh13449MS CKc38Y/DaR0fVU6imKby4FsdYt3Y+fQ==
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
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Jiri Kosina <jikos@kernel.org>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Joe Lawrence <joe.lawrence@redhat.com>
Cc: x86@kernel.org
Cc: linux-s390@vger.kernel.org
Cc: live-patching@vger.kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Acked-by: Vasily Gorbik <gor@linux.ibm.com>
Reviewed-by: Miroslav Benes <mbenes@suse.cz>
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

