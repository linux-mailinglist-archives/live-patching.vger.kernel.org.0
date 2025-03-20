Return-Path: <live-patching+bounces-1312-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 50AB3A6ABD1
	for <lists+live-patching@lfdr.de>; Thu, 20 Mar 2025 18:17:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 02EA098281A
	for <lists+live-patching@lfdr.de>; Thu, 20 Mar 2025 17:16:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 59622224B1B;
	Thu, 20 Mar 2025 17:16:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aZhkcZjh"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25FF41E5B6D;
	Thu, 20 Mar 2025 17:16:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742490983; cv=none; b=QyRVCP6J4QQa4ZOiZ9g8MLHi8DnndQS9qmqlQUd/fHxT3JrG5OHN0MwNxViKfc2i6Vtqc9r2rUh1414qvuyRbCuyiGl/0LP9w71VDpxzmqSl1Ro6Uxi1ATvfR3pCK3aLT9bzQ5Zk79SBi71igNRomeYHMuzmAfPCt8Dq0fbbHaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742490983; c=relaxed/simple;
	bh=+evCBeNGTvUjxQbku1JezmpWd8bBB4yvmqkVwISqS1w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ewgzl0zYoouq1bDl+rVOQ9/gu6NowPsSRzScr1qCwOiNEAU+fDUtQtYX4wCV1rfYzlVIz/Lqu72We4Ic6QKSn+C2IU+d6Xem5G8WEV4EQ82PEErRxzWxB0IxtHD8z21Mmd4qBFjmFiBHCZC/WSoX1V87yppr4pSXJ+1GrcG8npw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aZhkcZjh; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4622C4CEDD;
	Thu, 20 Mar 2025 17:16:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742490983;
	bh=+evCBeNGTvUjxQbku1JezmpWd8bBB4yvmqkVwISqS1w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aZhkcZjhgwTBQhn5xLxRnF3a4qsa3u+33DaXQvkxOCmztDrjEduWoh9z6n8kqeTFf
	 qAdmXarac8CfVE7puGIIgCCYAY0GtNUjG8G8gfUcZPpPJ07fx5PSBQUC9g488Gx/d5
	 c6TKxha++wh71G+QcFcyJa6NVvszcn/4y8Va3WfQLtoRrFPSdzrs9S2wsuPqjptnsH
	 uld7Tp2ri8VeaM446rm7kl0yuZ/TOjgptCBqKroNZi5627Urk8CscO0RsHovIuGnTM
	 DVWtGQPt8hXyrV7j4TIsGz1B7FAOv5N2GVjRGmmxPIiLP532gpL2Hl4m5wANOgyt0w
	 RP8bMohr+O8GA==
From: Song Liu <song@kernel.org>
To: linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-toolchains@vger.kernel.org,
	live-patching@vger.kernel.org
Cc: indu.bhagat@oracle.com,
	puranjay@kernel.org,
	wnliu@google.com,
	irogers@google.com,
	joe.lawrence@redhat.com,
	jpoimboe@kernel.org,
	mark.rutland@arm.com,
	peterz@infradead.org,
	roman.gushchin@linux.dev,
	rostedt@goodmis.org,
	will@kernel.org,
	kernel-team@meta.com,
	song@kernel.org,
	Suraj Jitindar Singh <surajjs@amazon.com>,
	Torsten Duwe <duwe@suse.de>,
	Miroslav Benes <mbenes@suse.cz>,
	Breno Leitao <leitao@debian.org>
Subject: [PATCH v3 2/2] arm64: Implement HAVE_LIVEPATCH
Date: Thu, 20 Mar 2025 10:15:59 -0700
Message-ID: <20250320171559.3423224-3-song@kernel.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250320171559.3423224-1-song@kernel.org>
References: <20250320171559.3423224-1-song@kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is largely based on [1] by Suraj Jitindar Singh.

Test coverage:

- Passed manual tests with samples/livepatch.
- Passed all but test-kprobe.sh in selftests/livepatch.
  test-kprobe.sh is expected to fail, because arm64 doesn't have
  KPROBES_ON_FTRACE.
- Passed tests with kpatch-build [2]. (This version includes commits that
  are not merged to upstream kpatch yet).

[1] https://lore.kernel.org/all/20210604235930.603-1-surajjs@amazon.com/
[2] https://github.com/liu-song-6/kpatch/tree/fb-6.13
Cc: Suraj Jitindar Singh <surajjs@amazon.com>
Cc: Torsten Duwe <duwe@suse.de>
Signed-off-by: Song Liu <song@kernel.org>
Acked-by: Miroslav Benes <mbenes@suse.cz>
Tested-by: Breno Leitao <leitao@debian.org>
---
 arch/arm64/Kconfig                   | 3 +++
 arch/arm64/include/asm/thread_info.h | 4 +++-
 arch/arm64/kernel/entry-common.c     | 4 ++++
 3 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 31d5e1ee6089..dbd237b13b21 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -277,6 +277,7 @@ config ARM64
 	select USER_STACKTRACE_SUPPORT
 	select VDSO_GETRANDOM
 	select HAVE_RELIABLE_STACKTRACE
+	select HAVE_LIVEPATCH
 	help
 	  ARM 64-bit (AArch64) Linux support.
 
@@ -2501,3 +2502,5 @@ endmenu # "CPU Power Management"
 source "drivers/acpi/Kconfig"
 
 source "arch/arm64/kvm/Kconfig"
+
+source "kernel/livepatch/Kconfig"
diff --git a/arch/arm64/include/asm/thread_info.h b/arch/arm64/include/asm/thread_info.h
index 1114c1c3300a..4ac42e13032b 100644
--- a/arch/arm64/include/asm/thread_info.h
+++ b/arch/arm64/include/asm/thread_info.h
@@ -64,6 +64,7 @@ void arch_setup_new_exec(void);
 #define TIF_UPROBE		4	/* uprobe breakpoint or singlestep */
 #define TIF_MTE_ASYNC_FAULT	5	/* MTE Asynchronous Tag Check Fault */
 #define TIF_NOTIFY_SIGNAL	6	/* signal notifications exist */
+#define TIF_PATCH_PENDING	7	/* pending live patching update */
 #define TIF_SYSCALL_TRACE	8	/* syscall trace active */
 #define TIF_SYSCALL_AUDIT	9	/* syscall auditing */
 #define TIF_SYSCALL_TRACEPOINT	10	/* syscall tracepoint for ftrace */
@@ -92,6 +93,7 @@ void arch_setup_new_exec(void);
 #define _TIF_SYSCALL_TRACEPOINT	(1 << TIF_SYSCALL_TRACEPOINT)
 #define _TIF_SECCOMP		(1 << TIF_SECCOMP)
 #define _TIF_SYSCALL_EMU	(1 << TIF_SYSCALL_EMU)
+#define _TIF_PATCH_PENDING	(1 << TIF_PATCH_PENDING)
 #define _TIF_UPROBE		(1 << TIF_UPROBE)
 #define _TIF_SINGLESTEP		(1 << TIF_SINGLESTEP)
 #define _TIF_32BIT		(1 << TIF_32BIT)
@@ -103,7 +105,7 @@ void arch_setup_new_exec(void);
 #define _TIF_WORK_MASK		(_TIF_NEED_RESCHED | _TIF_SIGPENDING | \
 				 _TIF_NOTIFY_RESUME | _TIF_FOREIGN_FPSTATE | \
 				 _TIF_UPROBE | _TIF_MTE_ASYNC_FAULT | \
-				 _TIF_NOTIFY_SIGNAL)
+				 _TIF_NOTIFY_SIGNAL | _TIF_PATCH_PENDING)
 
 #define _TIF_SYSCALL_WORK	(_TIF_SYSCALL_TRACE | _TIF_SYSCALL_AUDIT | \
 				 _TIF_SYSCALL_TRACEPOINT | _TIF_SECCOMP | \
diff --git a/arch/arm64/kernel/entry-common.c b/arch/arm64/kernel/entry-common.c
index b260ddc4d3e9..b537af333b42 100644
--- a/arch/arm64/kernel/entry-common.c
+++ b/arch/arm64/kernel/entry-common.c
@@ -8,6 +8,7 @@
 #include <linux/context_tracking.h>
 #include <linux/kasan.h>
 #include <linux/linkage.h>
+#include <linux/livepatch.h>
 #include <linux/lockdep.h>
 #include <linux/ptrace.h>
 #include <linux/resume_user_mode.h>
@@ -144,6 +145,9 @@ static void do_notify_resume(struct pt_regs *regs, unsigned long thread_flags)
 				       (void __user *)NULL, current);
 		}
 
+		if (thread_flags & _TIF_PATCH_PENDING)
+			klp_update_patch_state(current);
+
 		if (thread_flags & (_TIF_SIGPENDING | _TIF_NOTIFY_SIGNAL))
 			do_signal(regs);
 
-- 
2.47.1


