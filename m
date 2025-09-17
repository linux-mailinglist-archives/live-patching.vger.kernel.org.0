Return-Path: <live-patching+bounces-1718-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id EAA57B80E9D
	for <lists+live-patching@lfdr.de>; Wed, 17 Sep 2025 18:17:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2990F1C27AEE
	for <lists+live-patching@lfdr.de>; Wed, 17 Sep 2025 16:16:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1EC9E346642;
	Wed, 17 Sep 2025 16:05:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lXo1iX8B"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E775434663B;
	Wed, 17 Sep 2025 16:05:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758125102; cv=none; b=uJk3giyL9FvIylhwR+7+EmojX5dwETIyl0ahZFDp38WM0uzYFiQomHQ4Ool3YW7E9Nutc07b4+OnYzk+ssv8YWl7k1RZcBABoL8yTJKWEOAIIhFSjloLNDzrFqQQh1+EaCXaPAIo0wSfnY+3wLgo1awOQFcDzdDoiIt+7ntMyNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758125102; c=relaxed/simple;
	bh=JIeUeiinJpOiUwnaUcWDbdRzzfXPgSov7UVBeQCc65I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=egiqxZyWBzIx6peyLtp2H85+6xV+dUG8XSoTT1S/nlC0xBsjVmJduw2ARmyMEaCa5/pWoUT+zGTsJaekZZ48LNXxMxe7b9+LJ+ynAi+Wmm3pJXZobum0o4akvmunpvFBk3Ibxi0l7pY35qIXDZv0qeUEj/da1OtG0bU2zrXjpdM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lXo1iX8B; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 450D6C4CEFB;
	Wed, 17 Sep 2025 16:05:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758125101;
	bh=JIeUeiinJpOiUwnaUcWDbdRzzfXPgSov7UVBeQCc65I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lXo1iX8BVQx/y3BTFJ2TKFgmsm4TuZgiQ5cpCnO2JJidQ/k/4Y+YpD3dk96D59Enf
	 ImbUGDAneo9mJmHYsH0CnsecaHsElzijILYrh6IIrb1WRKgLNV5l8BfPXyiS577Nyu
	 tqn+g1gdxmCwg/waFtbuGU12tP+4yUnJFnIpheBwJ6D/RmQI3o0+pXcBWkkmUm41z5
	 wY+qHBDMx6elfotz1ez/LBZSSe3Xp9S20Apa6Xpy3a5pZOhGwlBp6IAIgW0bxf7A7+
	 5OvnViYY8WIUFABJchb9RnG4ZnfwCus3hPN6KovpE71EX2h+STnSqdk+C1b6I9Mq/E
	 BVGtJ5/OOd7Qw==
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org,
	Petr Mladek <pmladek@suse.com>,
	Miroslav Benes <mbenes@suse.cz>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	live-patching@vger.kernel.org,
	Song Liu <song@kernel.org>,
	laokz <laokz@foxmail.com>,
	Jiri Kosina <jikos@kernel.org>,
	Marcos Paulo de Souza <mpdesouza@suse.com>,
	Weinan Liu <wnliu@google.com>,
	Fazla Mehrab <a.mehrab@bytedance.com>,
	Chen Zhongjin <chenzhongjin@huawei.com>,
	Puranjay Mohan <puranjay@kernel.org>,
	Dylan Hatch <dylanbhatch@google.com>,
	Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH v4 63/63] livepatch: Introduce source code helpers for livepatch modules
Date: Wed, 17 Sep 2025 09:04:11 -0700
Message-ID: <262d11ae2557639839ede7312ba834817615e0a8.1758067943.git.jpoimboe@kernel.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <cover.1758067942.git.jpoimboe@kernel.org>
References: <cover.1758067942.git.jpoimboe@kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add some helper macros which can be used by livepatch source .patch
files to register callbacks, convert static calls to regular calls where
needed, and patch syscalls.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 include/linux/livepatch_helpers.h | 77 +++++++++++++++++++++++++++++++
 1 file changed, 77 insertions(+)
 create mode 100644 include/linux/livepatch_helpers.h

diff --git a/include/linux/livepatch_helpers.h b/include/linux/livepatch_helpers.h
new file mode 100644
index 0000000000000..99d68d0773fa8
--- /dev/null
+++ b/include/linux/livepatch_helpers.h
@@ -0,0 +1,77 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _LINUX_LIVEPATCH_HELPERS_H
+#define _LINUX_LIVEPATCH_HELPERS_H
+
+/*
+ * Interfaces for use by livepatch patches
+ */
+
+#include <linux/syscalls.h>
+#include <linux/livepatch.h>
+
+#ifdef MODULE
+#define KLP_OBJNAME __KBUILD_MODNAME
+#else
+#define KLP_OBJNAME vmlinux
+#endif
+
+/* Livepatch callback registration */
+
+#define KLP_CALLBACK_PTRS ".discard.klp_callback_ptrs"
+
+#define KLP_PRE_PATCH_CALLBACK(func)						\
+	klp_pre_patch_t __used __section(KLP_CALLBACK_PTRS)			\
+		__PASTE(__KLP_PRE_PATCH_PREFIX, KLP_OBJNAME) = func
+
+#define KLP_POST_PATCH_CALLBACK(func)						\
+	klp_post_patch_t __used __section(KLP_CALLBACK_PTRS)			\
+		__PASTE(__KLP_POST_PATCH_PREFIX, KLP_OBJNAME) = func
+
+#define KLP_PRE_UNPATCH_CALLBACK(func)						\
+	klp_pre_unpatch_t __used __section(KLP_CALLBACK_PTRS)			\
+		__PASTE(__KLP_PRE_UNPATCH_PREFIX, KLP_OBJNAME) = func
+
+#define KLP_POST_UNPATCH_CALLBACK(func)						\
+	klp_post_unpatch_t __used __section(KLP_CALLBACK_PTRS)			\
+		__PASTE(__KLP_POST_UNPATCH_PREFIX, KLP_OBJNAME) = func
+
+/*
+ * Replace static_call() usage with this macro when create-diff-object
+ * recommends it due to the original static call key living in a module.
+ *
+ * This converts the static call to a regular indirect call.
+ */
+#define KLP_STATIC_CALL(name) \
+	((typeof(STATIC_CALL_TRAMP(name))*)(STATIC_CALL_KEY(name).func))
+
+/* Syscall patching */
+
+#define KLP_SYSCALL_DEFINE1(name, ...) KLP_SYSCALL_DEFINEx(1, _##name, __VA_ARGS__)
+#define KLP_SYSCALL_DEFINE2(name, ...) KLP_SYSCALL_DEFINEx(2, _##name, __VA_ARGS__)
+#define KLP_SYSCALL_DEFINE3(name, ...) KLP_SYSCALL_DEFINEx(3, _##name, __VA_ARGS__)
+#define KLP_SYSCALL_DEFINE4(name, ...) KLP_SYSCALL_DEFINEx(4, _##name, __VA_ARGS__)
+#define KLP_SYSCALL_DEFINE5(name, ...) KLP_SYSCALL_DEFINEx(5, _##name, __VA_ARGS__)
+#define KLP_SYSCALL_DEFINE6(name, ...) KLP_SYSCALL_DEFINEx(6, _##name, __VA_ARGS__)
+
+#define KLP_SYSCALL_DEFINEx(x, sname, ...)				\
+	__KLP_SYSCALL_DEFINEx(x, sname, __VA_ARGS__)
+
+#ifdef CONFIG_X86_64
+// TODO move this to arch/x86/include/asm/syscall_wrapper.h and share code
+#define __KLP_SYSCALL_DEFINEx(x, name, ...)			\
+	static long __se_sys##name(__MAP(x,__SC_LONG,__VA_ARGS__));	\
+	static inline long __klp_do_sys##name(__MAP(x,__SC_DECL,__VA_ARGS__));\
+	__X64_SYS_STUBx(x, name, __VA_ARGS__)				\
+	__IA32_SYS_STUBx(x, name, __VA_ARGS__)				\
+	static long __se_sys##name(__MAP(x,__SC_LONG,__VA_ARGS__))	\
+	{								\
+		long ret = __klp_do_sys##name(__MAP(x,__SC_CAST,__VA_ARGS__));\
+		__MAP(x,__SC_TEST,__VA_ARGS__);				\
+		__PROTECT(x, ret,__MAP(x,__SC_ARGS,__VA_ARGS__));	\
+		return ret;						\
+	}								\
+	static inline long __klp_do_sys##name(__MAP(x,__SC_DECL,__VA_ARGS__))
+
+#endif
+
+#endif /* _LINUX_LIVEPATCH_HELPERS_H */
-- 
2.50.0


