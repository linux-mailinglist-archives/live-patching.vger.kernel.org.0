Return-Path: <live-patching+bounces-1521-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 77489ADDAC4
	for <lists+live-patching@lfdr.de>; Tue, 17 Jun 2025 19:37:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 545B47AD064
	for <lists+live-patching@lfdr.de>; Tue, 17 Jun 2025 17:36:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F6742DFF1B;
	Tue, 17 Jun 2025 17:37:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WVwN0gYT"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 441A3238D49;
	Tue, 17 Jun 2025 17:37:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750181867; cv=none; b=TJeaGNRZPJkBItw0uU0xPdOVKLs8B3h8SG+HC+1+ZZXGAS42s7XQIUJYOSY72vdQ5S2LunrtYGYCFgU1L1VY1Rke0uHhAjTFTJrv6m2O5ET7SBztWQ9i8UFedmwcs87/FWHOuWb9OkjtI0z6n2/qCEDsZtvEd9fwb2Ilsk1HP1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750181867; c=relaxed/simple;
	bh=tPM1ERGTQDQ05aYoKr5NmEZeCXbd0I3kyp9i8yKwlzY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Mi9gRLXWetiWN4O1ghWwZ3wI+w2AlKnHOBnJTY0WDJqGCISLewSPo6TqH6W9lOENxrs3U5nU5vwuzXAb/LbX+HncGtuijCEKV+NQDqepPJmh0qvpdfzVF+GBFxW4qAJCsZzwtlI190HsbIGKolZhN6CIXxx9R/oAH3fDJvgETik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WVwN0gYT; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB8AEC4CEE3;
	Tue, 17 Jun 2025 17:37:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750181867;
	bh=tPM1ERGTQDQ05aYoKr5NmEZeCXbd0I3kyp9i8yKwlzY=;
	h=From:To:Cc:Subject:Date:From;
	b=WVwN0gYToBvYkX/rmMNJD8xgfFvc/Q30jaum38YjCkSNZRKxetIDFgIqKTmBOG+C1
	 jskFy8ZebIdxD2NV2xsOat17ZcOgDG9UIoih9NvtcDUfG191p2Z/7RZSU4Hmdq24zi
	 VVHCXMshVxgrEbntAZEobvgMJsTpv0rL2IDqLUxj5qh5wz9L4a/oN8WtQ1sRAc4QfP
	 coc3BjIR8OKZ7SCc2hV6xGwu5tYjbOhxom7SfNMezYKPiv0nJMW5LSzXZera4ERl5R
	 CKhaZ3+iZM4YRnge4MfV8gU3RHA580xhOz6/twIkbzLRJ3g01KDy0NymvJuZ62RHxB
	 ic+SbtgXfWy5A==
From: Song Liu <song@kernel.org>
To: live-patching@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: jpoimboe@kernel.org,
	jikos@kernel.org,
	mbenes@suse.cz,
	pmladek@suse.com,
	joe.lawrence@redhat.com,
	catalin.marinas@arm.com,
	will@kernel.org,
	dylanbhatch@google.com,
	fj6611ie@aa.jp.fujitsu.com,
	mark.rutland@arm.com,
	kernel-team@meta.com,
	Song Liu <song@kernel.org>,
	Suraj Jitindar Singh <surajjs@amazon.com>,
	Torsten Duwe <duwe@suse.de>,
	Breno Leitao <leitao@debian.org>,
	Andrea della Porta <andrea.porta@suse.com>
Subject: [PATCH v4] arm64: Implement HAVE_LIVEPATCH
Date: Tue, 17 Jun 2025 10:37:34 -0700
Message-ID: <20250617173734.651611-1-song@kernel.org>
X-Mailer: git-send-email 2.47.1
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
Acked-by: Miroslav Benes <mbenes@suse.cz>
Tested-by: Breno Leitao <leitao@debian.org>
Tested-by: Andrea della Porta <andrea.porta@suse.com>
Signed-off-by: Song Liu <song@kernel.org>

---

Note: This patch depends on [3] and [4].

[3] https://lore.kernel.org/linux-arm-kernel/20250521111000.2237470-2-mark.rutland@arm.com/
[4] https://lore.kernel.org/linux-arm-kernel/20250603223417.3700218-1-dylanbhatch@google.com/

Changes v3 => v4:
1. Only keep 2/2 from v3, as 1/2 is now included in [3].
2. Change TIF_PATCH_PENDING from 7 to 13.

v3: https://lore.kernel.org/linux-arm-kernel/20250320171559.3423224-1-song@kernel.org/

Changes v2 => v3:
1. Remove a redundant check for -ENOENT. (Josh Poimboeuf)
2. Add Tested-by and Acked-by on v1. (I forgot to add them in v2.)

v2: https://lore.kernel.org/live-patching/20250319213707.1784775-1-song@kernel.org/

Changes v1 => v2:

1. Rework arch_stack_walk_reliable().

v1: https://lore.kernel.org/live-patching/20250308012742.3208215-1-song@kernel.org/
---
 arch/arm64/Kconfig                   | 3 +++
 arch/arm64/include/asm/thread_info.h | 5 ++++-
 arch/arm64/kernel/entry-common.c     | 4 ++++
 3 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index b7462424aa59..110218542920 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -280,6 +280,7 @@ config ARM64
 	select USER_STACKTRACE_SUPPORT
 	select VDSO_GETRANDOM
 	select HAVE_RELIABLE_STACKTRACE
+	select HAVE_LIVEPATCH
 	help
 	  ARM 64-bit (AArch64) Linux support.
 
@@ -2499,3 +2500,5 @@ endmenu # "CPU Power Management"
 source "drivers/acpi/Kconfig"
 
 source "arch/arm64/kvm/Kconfig"
+
+source "kernel/livepatch/Kconfig"
diff --git a/arch/arm64/include/asm/thread_info.h b/arch/arm64/include/asm/thread_info.h
index 1269c2487574..f241b8601ebd 100644
--- a/arch/arm64/include/asm/thread_info.h
+++ b/arch/arm64/include/asm/thread_info.h
@@ -70,6 +70,7 @@ void arch_setup_new_exec(void);
 #define TIF_SYSCALL_TRACEPOINT	10	/* syscall tracepoint for ftrace */
 #define TIF_SECCOMP		11	/* syscall secure computing */
 #define TIF_SYSCALL_EMU		12	/* syscall emulation active */
+#define TIF_PATCH_PENDING	13	/* pending live patching update */
 #define TIF_MEMDIE		18	/* is terminating due to OOM killer */
 #define TIF_FREEZE		19
 #define TIF_RESTORE_SIGMASK	20
@@ -96,6 +97,7 @@ void arch_setup_new_exec(void);
 #define _TIF_SYSCALL_TRACEPOINT	(1 << TIF_SYSCALL_TRACEPOINT)
 #define _TIF_SECCOMP		(1 << TIF_SECCOMP)
 #define _TIF_SYSCALL_EMU	(1 << TIF_SYSCALL_EMU)
+#define _TIF_PATCH_PENDING	(1 << TIF_PATCH_PENDING)
 #define _TIF_UPROBE		(1 << TIF_UPROBE)
 #define _TIF_SINGLESTEP		(1 << TIF_SINGLESTEP)
 #define _TIF_32BIT		(1 << TIF_32BIT)
@@ -107,7 +109,8 @@ void arch_setup_new_exec(void);
 #define _TIF_WORK_MASK		(_TIF_NEED_RESCHED | _TIF_NEED_RESCHED_LAZY | \
 				 _TIF_NOTIFY_RESUME | _TIF_FOREIGN_FPSTATE | \
 				 _TIF_UPROBE | _TIF_MTE_ASYNC_FAULT | \
-				 _TIF_NOTIFY_SIGNAL | _TIF_SIGPENDING)
+				 _TIF_NOTIFY_SIGNAL | _TIF_SIGPENDING | \
+				 _TIF_PATCH_PENDING)
 
 #define _TIF_SYSCALL_WORK	(_TIF_SYSCALL_TRACE | _TIF_SYSCALL_AUDIT | \
 				 _TIF_SYSCALL_TRACEPOINT | _TIF_SECCOMP | \
diff --git a/arch/arm64/kernel/entry-common.c b/arch/arm64/kernel/entry-common.c
index 7c1970b341b8..a56878d7c733 100644
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


