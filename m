Return-Path: <live-patching+bounces-1612-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3B67DAEE612
	for <lists+live-patching@lfdr.de>; Mon, 30 Jun 2025 19:45:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C846816513D
	for <lists+live-patching@lfdr.de>; Mon, 30 Jun 2025 17:45:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 502452D130C;
	Mon, 30 Jun 2025 17:45:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oDrzdZyp"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26FE228DF40;
	Mon, 30 Jun 2025 17:45:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751305509; cv=none; b=DpzmcdtKkgxYbcSyA/KqlXt0UbAmq6x8ptVb63RT+k9FewGQIGoeEkfxOrgCAyjaua8x19MjY0iwAsfEX4wmRXvOafgevpt7xrLe4h/XaKD1N19QWM8qg11Ir1NywCTx3x4wCmxSBB4bx6AG9aKOnLrd/RjhqfFHM+Qck1X/M9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751305509; c=relaxed/simple;
	bh=i5RJ/sC/svK83YrMoFZztx4G0sX30XvRei6equEd/Hs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=THtJMMkgr70NbQ+QUh4Sql4h9u9qzfHVGwiBT+vUwK/QBjKd3uizM/rD8ZDk3lRiAsmPVvTLVYpMh5WkGz0DBbQCo4kaZ5zG4AULuKQ52VRweVNK4cYlJkdJwISQ8qtNfq3j9W2UChCJMLpbJ5Ch1KLEfr0WMBi/pnNe1AE/MjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oDrzdZyp; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0A0CC4CEE3;
	Mon, 30 Jun 2025 17:45:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751305508;
	bh=i5RJ/sC/svK83YrMoFZztx4G0sX30XvRei6equEd/Hs=;
	h=From:To:Cc:Subject:Date:From;
	b=oDrzdZypIrEsLQIZLa6c6QXtwB2jVjICOOVnRIfOHf86uSSrscF/DAl4rMU7Iu/Ls
	 kprDTfME4Vm7NX98RUvXe+9xhVjM7USYFIJXWFXh1BunC6xyU8LFWPZDWyRKL3J0WS
	 y6lRBPVlJXs4Tqabod4v179KaBriS7nWXPRtWdz1e359Vwb7tq497uc64wkFNeXLqj
	 w5QJOosQu7ly8d//zo593m9/PqG6wcx+NlVbc/3vt8F8+DArH9MB5cUonsCp8SNm8C
	 0JDQbqWZXASDlbh2/4/YRQTQYBsyZUscUfvbx0QMIhLjb9su6oOfilIAAd+AIu8EsK
	 P+Imc9iQrWh/Q==
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
Subject: [PATCH v5] arm64: Implement HAVE_LIVEPATCH
Date: Mon, 30 Jun 2025 10:45:02 -0700
Message-ID: <20250630174502.842486-1-song@kernel.org>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Allocate a task flag used to represent the patch pending state for the
task. When a livepatch is being loaded or unloaded, the livepatch code
uses this flag to select the proper version of a being patched kernel
functions to use for current task.

In arch/arm64/Kconfig, select HAVE_LIVEPATCH and include proper Kconfig.

This is largely based on [1] by Suraj Jitindar Singh.

[1] https://lore.kernel.org/all/20210604235930.603-1-surajjs@amazon.com/

Cc: Suraj Jitindar Singh <surajjs@amazon.com>
Cc: Torsten Duwe <duwe@suse.de>
Acked-by: Miroslav Benes <mbenes@suse.cz>
Tested-by: Breno Leitao <leitao@debian.org>
Tested-by: Andrea della Porta <andrea.porta@suse.com>
Signed-off-by: Song Liu <song@kernel.org>
Acked-by: Will Deacon <will@kernel.org>

---

Changes v4 => v5:
1. Update commit log.

v4: https://lore.kernel.org/live-patching/20250617173734.651611-1-song@kernel.org/

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


