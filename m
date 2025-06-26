Return-Path: <live-patching+bounces-1575-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1D248AEAB61
	for <lists+live-patching@lfdr.de>; Fri, 27 Jun 2025 02:04:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 43B506A1BD5
	for <lists+live-patching@lfdr.de>; Fri, 27 Jun 2025 00:04:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5651228B51E;
	Thu, 26 Jun 2025 23:56:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lKQ2sGuG"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C0A328A70A;
	Thu, 26 Jun 2025 23:56:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750982203; cv=none; b=XYZzESdr62e2OvPqLeWtu9JCez/t1t0VFM0fVNbXjeuZQ9fXiOrTTmQ3bJCvw2RWCNnEGwTri7/rF1I2ONoQRlvawHCx6nUQF0hxaEhLG/DIN5cUmjVqDCKFg74gpvoAUFwqqpgCp/HvqgIuW7LuB07NBN1NHpo9CczIIfmaM6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750982203; c=relaxed/simple;
	bh=lKP9pcf5JLNshoXCNIFr0bPP37w/NqZ72Fam2hwYVs4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jpQ4KNK7vh19RvwFgBfTLzPVyu2ZaJ0aZ5VT3qQm8xmT/PfLRkYKxTJLGC4RrZAGcBhJDias15LBzUUKuPSL/zPJdFY5SLTJ4v9bJkG6LE5juY/YrU0f2BdIzSra9EeDm/rQRMVejtvl/QaoULAeKYqVY6VA2/zJ0pCVQCwGbv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lKQ2sGuG; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 826F2C4CEF0;
	Thu, 26 Jun 2025 23:56:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750982203;
	bh=lKP9pcf5JLNshoXCNIFr0bPP37w/NqZ72Fam2hwYVs4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lKQ2sGuGrghTKHtsfpLr/vxsDlmjDoFMB9DkfpsWrhJxyGqXC7JJEuQmBsrdyLJTX
	 oYM02TQngxOm19Ri4AbZP1oB4qa967m5CuHEheAeedKYaywUJneQh/ViaakHoTBuTI
	 8zyOZBqXIk3VPclEDzsyWpCSxjXo1lxbL3fMznrUB4ZrW6p4bXvwNw0ltXfbBVG9Eh
	 tM9lKYksWSE9DOjMRKsYcchaAxKHRw3Nk6zOA6/QDGMtj53N2Qbb5FhYQpJ2b67Ajv
	 9+wNb3R7W568Z4BR/hZ0cDGLRekEdrw9vaxH9a4GA/cLQoGgbA/hJ8KjJDbhN9bwch
	 8lfQFEfdIHVpA==
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
	Dylan Hatch <dylanbhatch@google.com>
Subject: [PATCH v3 45/64] x86/static_call: Define ELF section entry size of static calls
Date: Thu, 26 Jun 2025 16:55:32 -0700
Message-ID: <6c3466449d8c721af903ccc5e16251e36f678236.1750980517.git.jpoimboe@kernel.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1750980516.git.jpoimboe@kernel.org>
References: <cover.1750980516.git.jpoimboe@kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In preparation for the objtool klp diff subcommand, define the entry
size for the .static_call_sites section in its ELF header.  This will
allow tooling to extract individual entries.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 arch/x86/include/asm/static_call.h      |  3 ++-
 include/linux/static_call.h             |  6 ------
 include/linux/static_call_types.h       |  6 ++++++
 kernel/bounds.c                         |  4 ++++
 tools/include/linux/static_call_types.h |  6 ++++++
 tools/objtool/check.c                   | 11 +++++++++--
 6 files changed, 27 insertions(+), 9 deletions(-)

diff --git a/arch/x86/include/asm/static_call.h b/arch/x86/include/asm/static_call.h
index 41502bd2afd6..e03ad9bbbf59 100644
--- a/arch/x86/include/asm/static_call.h
+++ b/arch/x86/include/asm/static_call.h
@@ -58,7 +58,8 @@
 	ARCH_DEFINE_STATIC_CALL_TRAMP(name, __static_call_return0)
 
 #define ARCH_ADD_TRAMP_KEY(name)					\
-	asm(".pushsection .static_call_tramp_key, \"a\"		\n"	\
+	asm(".pushsection .static_call_tramp_key, \"aM\", @progbits, "	\
+	    __stringify(STATIC_CALL_TRAMP_KEY_SIZE) "\n"		\
 	    ".long " STATIC_CALL_TRAMP_STR(name) " - .		\n"	\
 	    ".long " STATIC_CALL_KEY_STR(name) " - .		\n"	\
 	    ".popsection					\n")
diff --git a/include/linux/static_call.h b/include/linux/static_call.h
index 78a77a4ae0ea..5210612817f2 100644
--- a/include/linux/static_call.h
+++ b/include/linux/static_call.h
@@ -172,12 +172,6 @@ struct static_call_mod {
 	struct static_call_site *sites;
 };
 
-/* For finding the key associated with a trampoline */
-struct static_call_tramp_key {
-	s32 tramp;
-	s32 key;
-};
-
 extern void __static_call_update(struct static_call_key *key, void *tramp, void *func);
 extern int static_call_mod_init(struct module *mod);
 extern int static_call_text_reserved(void *start, void *end);
diff --git a/include/linux/static_call_types.h b/include/linux/static_call_types.h
index 5a00b8b2cf9f..eb772df625d4 100644
--- a/include/linux/static_call_types.h
+++ b/include/linux/static_call_types.h
@@ -34,6 +34,12 @@ struct static_call_site {
 	s32 key;
 };
 
+/* For finding the key associated with a trampoline */
+struct static_call_tramp_key {
+	s32 tramp;
+	s32 key;
+};
+
 #define DECLARE_STATIC_CALL(name, func)					\
 	extern struct static_call_key STATIC_CALL_KEY(name);		\
 	extern typeof(func) STATIC_CALL_TRAMP(name);
diff --git a/kernel/bounds.c b/kernel/bounds.c
index e4c7ded3dc48..21c37e3ea629 100644
--- a/kernel/bounds.c
+++ b/kernel/bounds.c
@@ -14,6 +14,7 @@
 #include <linux/log2.h>
 #include <linux/spinlock_types.h>
 #include <linux/jump_label.h>
+#include <linux/static_call_types.h>
 
 int main(void)
 {
@@ -33,6 +34,9 @@ int main(void)
 #endif
 #if defined(CONFIG_HAVE_ARCH_JUMP_LABEL_RELATIVE) && defined(CONFIG_JUMP_LABEL)
 	DEFINE(JUMP_ENTRY_SIZE, sizeof(struct jump_entry));
+#endif
+#ifdef CONFIG_HAVE_STATIC_CALL_INLINE
+	DEFINE(STATIC_CALL_TRAMP_KEY_SIZE, sizeof(struct static_call_tramp_key));
 #endif
 	/* End of constants */
 
diff --git a/tools/include/linux/static_call_types.h b/tools/include/linux/static_call_types.h
index 5a00b8b2cf9f..eb772df625d4 100644
--- a/tools/include/linux/static_call_types.h
+++ b/tools/include/linux/static_call_types.h
@@ -34,6 +34,12 @@ struct static_call_site {
 	s32 key;
 };
 
+/* For finding the key associated with a trampoline */
+struct static_call_tramp_key {
+	s32 tramp;
+	s32 key;
+};
+
 #define DECLARE_STATIC_CALL(name, func)					\
 	extern struct static_call_key STATIC_CALL_KEY(name);		\
 	extern typeof(func) STATIC_CALL_TRAMP(name);
diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index 3afc748ba516..c3e1ca3dba06 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -650,8 +650,15 @@ static int create_static_call_sections(struct objtool_file *file)
 	if (!sec)
 		return -1;
 
-	/* Allow modules to modify the low bits of static_call_site::key */
-	sec->sh.sh_flags |= SHF_WRITE;
+	/*
+	 * Set SHF_MERGE to prevent tooling from stripping entsize.
+	 *
+	 * SHF_WRITE would also get set here to allow modules to modify the low
+	 * bits of static_call_site::key, but the LLVM linker doesn't allow
+	 * SHF_MERGE+SHF_WRITE for whatever reason.  That gets fixed up by the
+	 * makefiles with CONFIG_NEED_MODULE_PERMISSIONS_FIX.
+	 */
+	sec->sh.sh_flags |= SHF_MERGE;
 
 	idx = 0;
 	list_for_each_entry(insn, &file->static_call_list, call_node) {
-- 
2.49.0


