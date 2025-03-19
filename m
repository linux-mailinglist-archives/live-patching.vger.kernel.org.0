Return-Path: <live-patching+bounces-1307-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id C9978A69B05
	for <lists+live-patching@lfdr.de>; Wed, 19 Mar 2025 22:39:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0D3217AA089
	for <lists+live-patching@lfdr.de>; Wed, 19 Mar 2025 21:37:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E7D821577D;
	Wed, 19 Mar 2025 21:38:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XTzRGgYg"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3B07214A71;
	Wed, 19 Mar 2025 21:38:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742420309; cv=none; b=AJvsagZr68dp4Znv302g6iV1mNFVgXDETeRVy8s1Nf2b/60hgKlEW+1uAh2vR7OOLbdbqlyPaEuGjqnDrUxS5tnTk93soSQDlb+8jTWUzbQ1KqrMa12E83MPPXezUhlcet9vELkHLOIlCIqu0XNyIERCPUktdwg0a87D1FGxtIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742420309; c=relaxed/simple;
	bh=FwNROOBiRQdLC4LMY0dNrjEMqI1FlzLJowVkMOHTQnk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yr7RfQG7Vv2+5g9TAx+9Qq+DywLSECLMUfncZLh5sAVEn51cVLDp8N7gdBOmSOcLL6SStLZufr0UpbAb2Uq6CSKGXvkfT1dk/cJCcA20y7BbMYLFYhf3QUYTmVm1v30KdwtguoJ1JfwkdBXvGI7WhgrfUN6j1ld2g+DMTm23G7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XTzRGgYg; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB78CC4CEE4;
	Wed, 19 Mar 2025 21:38:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742420309;
	bh=FwNROOBiRQdLC4LMY0dNrjEMqI1FlzLJowVkMOHTQnk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XTzRGgYgUiM7dDAuU0PP/o/gxpWPk5nrU+ZcqlHgsz+v+XhA8Ul8QPhPN6JhlnZ9j
	 am/lMjA0Ckj/odltOGkGav5L28oqNWF0DEVA8CmnGuUrUEA8G68GAvFHL1pep11xgB
	 g1CDS6xvYGBN+KivygRYRr5+YgBsuWDX57mevLtXFQXA6R5+42vo+shrhO0HvJly3G
	 /Oukcx+7KhM2haG6oCR1xPfrrSmSLc7kjC2MpvyYwgQczDnOFFBIosYJqsOGmT9yOu
	 OZS8nub6nbGdm5HuoX8E4Vpt1mZ4u74hTdQUs+7rCDeXGOtC1DGZ9k/H7A63Aje/nT
	 ZDTyVfVUQE50A==
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
	Torsten Duwe <duwe@suse.de>
Subject: [PATCH v2 2/2] arm64: Implement HAVE_LIVEPATCH
Date: Wed, 19 Mar 2025 14:37:07 -0700
Message-ID: <20250319213707.1784775-3-song@kernel.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250319213707.1784775-1-song@kernel.org>
References: <20250319213707.1784775-1-song@kernel.org>
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
---
 arch/arm64/Kconfig                   | 3 +++
 arch/arm64/include/asm/thread_info.h | 4 +++-
 arch/arm64/kernel/entry-common.c     | 4 ++++
 3 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index ed4f7bf4a879..bc9edba6171a 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -276,6 +276,7 @@ config ARM64
 	select USER_STACKTRACE_SUPPORT
 	select VDSO_GETRANDOM
 	select HAVE_RELIABLE_STACKTRACE
+	select HAVE_LIVEPATCH
 	help
 	  ARM 64-bit (AArch64) Linux support.
 
@@ -2500,3 +2501,5 @@ endmenu # "CPU Power Management"
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


