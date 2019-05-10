Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB1CD1A4C1
	for <lists+live-patching@lfdr.de>; Fri, 10 May 2019 23:47:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728204AbfEJVr4 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 10 May 2019 17:47:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:40256 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728161AbfEJVr4 (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Fri, 10 May 2019 17:47:56 -0400
Received: from pobox.suse.cz (prg-ext-pat.suse.com [213.151.95.130])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D6ACB217D6;
        Fri, 10 May 2019 21:47:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557524875;
        bh=uGuKdpcnbNynUPSfIfEiu8Vxvnoyu9UL4a8JrFHkYEM=;
        h=Date:From:To:cc:Subject:In-Reply-To:References:From;
        b=GpgJp1orFXFeY1NOPGbmDYEx+fj8jr4cO/hTGGLOl7+UW4DVFMFnESbIcIHvbgT+h
         eBcGlLABvRYRhCArHwl9CLl1Q8ZqTKyie2e6ZQANfkfJlWeJlgniqg2TVGOcb8PdNt
         mj3Z91Cw/fjoBxBIFEaIlzbrnvYLoD639L4gsc5s=
Date:   Fri, 10 May 2019 23:47:50 +0200 (CEST)
From:   Jiri Kosina <jikos@kernel.org>
To:     Steven Rostedt <rostedt@goodmis.org>
cc:     linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        live-patching@vger.kernel.org, x86@kernel.org,
        Borislav Petkov <bp@alien8.de>
Subject: [RFC][PATCH 3/2] livepatch: remove klp_check_compiler_support()
In-Reply-To: <20190510163519.794235443@goodmis.org>
Message-ID: <nycvar.YFH.7.76.1905102346100.17054@cbobk.fhfr.pm>
References: <20190510163519.794235443@goodmis.org>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

From: Jiri Kosina <jkosina@suse.cz>

The only purpose of klp_check_compiler_support() is to make sure that we 
are not using ftrace on x86 via mcount (because that's executed only after 
prologue has already happened, and that's too late for livepatching 
purposes).

Now that mcount is not supported by ftrace any more, there is no need for 
klp_check_compiler_support() either.

Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
---

I guess it makes most sense to merge this together with mcount removal in 
one go.

 arch/powerpc/include/asm/livepatch.h | 5 -----
 arch/s390/include/asm/livepatch.h    | 5 -----
 arch/x86/include/asm/livepatch.h     | 5 -----
 kernel/livepatch/core.c              | 8 --------
 4 files changed, 23 deletions(-)

diff --git a/arch/powerpc/include/asm/livepatch.h b/arch/powerpc/include/asm/livepatch.h
index 5070df19d463..c005aee5ea43 100644
--- a/arch/powerpc/include/asm/livepatch.h
+++ b/arch/powerpc/include/asm/livepatch.h
@@ -24,11 +24,6 @@
 #include <linux/sched/task_stack.h>
 
 #ifdef CONFIG_LIVEPATCH
-static inline int klp_check_compiler_support(void)
-{
-	return 0;
-}
-
 static inline void klp_arch_set_pc(struct pt_regs *regs, unsigned long ip)
 {
 	regs->nip = ip;
diff --git a/arch/s390/include/asm/livepatch.h b/arch/s390/include/asm/livepatch.h
index 672f95b12d40..818612b784cd 100644
--- a/arch/s390/include/asm/livepatch.h
+++ b/arch/s390/include/asm/livepatch.h
@@ -13,11 +13,6 @@
 
 #include <asm/ptrace.h>
 
-static inline int klp_check_compiler_support(void)
-{
-	return 0;
-}
-
 static inline void klp_arch_set_pc(struct pt_regs *regs, unsigned long ip)
 {
 	regs->psw.addr = ip;
diff --git a/arch/x86/include/asm/livepatch.h b/arch/x86/include/asm/livepatch.h
index 2f2bdf0662f8..a66f6706c2de 100644
--- a/arch/x86/include/asm/livepatch.h
+++ b/arch/x86/include/asm/livepatch.h
@@ -24,11 +24,6 @@
 #include <asm/setup.h>
 #include <linux/ftrace.h>
 
-static inline int klp_check_compiler_support(void)
-{
-	return 0;
-}
-
 static inline void klp_arch_set_pc(struct pt_regs *regs, unsigned long ip)
 {
 	regs->ip = ip;
diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
index f12c0eabd843..7e5cdeeca3bd 100644
--- a/kernel/livepatch/core.c
+++ b/kernel/livepatch/core.c
@@ -1207,14 +1207,6 @@ void klp_module_going(struct module *mod)
 
 static int __init klp_init(void)
 {
-	int ret;
-
-	ret = klp_check_compiler_support();
-	if (ret) {
-		pr_info("Your compiler is too old; turning off.\n");
-		return -EINVAL;
-	}
-
 	klp_root_kobj = kobject_create_and_add("livepatch", kernel_kobj);
 	if (!klp_root_kobj)
 		return -ENOMEM;
-- 
Jiri Kosina
SUSE Labs

