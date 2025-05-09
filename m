Return-Path: <live-patching+bounces-1421-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6E923AB1E43
	for <lists+live-patching@lfdr.de>; Fri,  9 May 2025 22:29:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 50C68A25C89
	for <lists+live-patching@lfdr.de>; Fri,  9 May 2025 20:28:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6432629B23B;
	Fri,  9 May 2025 20:18:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tHL3nFw7"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3896029B232;
	Fri,  9 May 2025 20:18:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746821909; cv=none; b=AZ50MP66KBjrMs3f2tesLiVxqNwS2hda/LwksUyaZP2BJoRJjkKBeEvHKE+0XlhDcGhme935UgBLDMHEcJ/bgGtIyfLhugjkkWLokpRMf2n/6FTiMbtFi3TqBd9a/cCwXDLM/ebfrPp+55RQ27czrKcS67Rq1y6ES7y+7Ntyx9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746821909; c=relaxed/simple;
	bh=vEnwKBFgMDnerydIawqZPcGrp8qCIphckzzU5Fp2jB8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i5QcB42fzTfw9tvs5ar9ZFDLAnRJo4JkKFEhxI4EGzKav4JXjKAfT9sjhdvI4iZ11GIJfLWeIQLhWI/SYzMKc6GKnWistXB6P6XnE2XeYi8oEYDSEsLrmGX2oIWvkpmd0GLC2rwJTmA7y6Y1xj0H87IMpU+MGQcWXBvcLBswHIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tHL3nFw7; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24293C4CEEF;
	Fri,  9 May 2025 20:18:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746821908;
	bh=vEnwKBFgMDnerydIawqZPcGrp8qCIphckzzU5Fp2jB8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tHL3nFw75Wj0azM2AY2o9njmQ758w+MeqxVob1iJeyM5JC6VEhdrO/wilGUoaP5To
	 QtQnfGR7KiMEo7U4Sq0VEWZnY1J+tPyVEEI9jkHatKDtuNpDJaePxBDBecHqEi67Xg
	 1JzDD9twy+yZwEjI5+1irDxrWZ52WZ+7mkPqvNQDW8KBmacO8QZ/MNJQovAXwGJEum
	 kLt9EMKCH5tRlzNlquUYs8hxHcvuXrHBH65b7C2JNSc0jMjy/122z1SJAIo6HcRrp5
	 cC0gIec9nP81w3hKS079UcpnmgqlOtbGzDP6KFWcmJ5RNnook9d29Ipz6DVTNHRrnE
	 FVVbV/i0/4GLg==
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
	Puranjay Mohan <puranjay@kernel.org>
Subject: [PATCH v2 62/62] livepatch: Introduce source code helpers for livepatch modules
Date: Fri,  9 May 2025 13:17:26 -0700
Message-ID: <da3b8c56c40edeaf40804f6503cbb640f191dad4.1746821544.git.jpoimboe@kernel.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1746821544.git.jpoimboe@kernel.org>
References: <cover.1746821544.git.jpoimboe@kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add some helper macros which can be used by livepatch source .patch
files to register callbacks or patch syscalls.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 include/linux/livepatch_helpers.h | 68 +++++++++++++++++++++++++++++++
 1 file changed, 68 insertions(+)
 create mode 100644 include/linux/livepatch_helpers.h

diff --git a/include/linux/livepatch_helpers.h b/include/linux/livepatch_helpers.h
new file mode 100644
index 000000000000..09f4a2d53fd7
--- /dev/null
+++ b/include/linux/livepatch_helpers.h
@@ -0,0 +1,68 @@
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
2.49.0


