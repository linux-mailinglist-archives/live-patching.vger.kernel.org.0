Return-Path: <live-patching+bounces-1403-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D38ADAB1E27
	for <lists+live-patching@lfdr.de>; Fri,  9 May 2025 22:26:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 97C4C1760E2
	for <lists+live-patching@lfdr.de>; Fri,  9 May 2025 20:25:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4087B298CC3;
	Fri,  9 May 2025 20:18:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tx+VTOuN"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1843E298CBE;
	Fri,  9 May 2025 20:18:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746821896; cv=none; b=ZN1egAaihfyLsc3zioLx8wlJ/15zm9KsXAREGXX2L6U4ftK2uIhdIExcxGtoSe++ZpWlnZjDnxMyPuPIIFby2yxKVCTHjSXKiws07gHfk7CmEPDsGJ/cYMfOxmLEzlUSiCBp8FAx+duuv41eV4e2x2AHCCge+kDfhksdTV09tbU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746821896; c=relaxed/simple;
	bh=WrGEyNHSSw7Wx3DQ3criX7+p62Pve6p0318/Ksge9cQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jzKGUPZDP94oTjbzP97cYt18MyQJZiJQuHjFhFG1Fayr+N1yFj5PVLsA8koHe2hQtR6AbSgu7LPU3R7XDQWmpDgargSj3EHuOGKN1WJ8IyV8J6DOpuqHzacGElFteKbGBluRJMhhqbBHqnfhqpyO0DjKGZRdAPmu3YOQaNf7HFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tx+VTOuN; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F3EFC4CEEF;
	Fri,  9 May 2025 20:18:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746821896;
	bh=WrGEyNHSSw7Wx3DQ3criX7+p62Pve6p0318/Ksge9cQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tx+VTOuNeOAdNveLRr8D1TBDpGlVVTpewtqyC5XNZaf65xWLv9JRKOVIQrQwl2BnS
	 kZt7OsU+avOREH80V0YaZFvgP5suwYeruN5UtG9oJDRzTWEtpeBkSExPmirmza81yt
	 KQMQSpYcIGLggP0DOAOTyuMltPXcUI0Vu7jih6D3C1LFafvON+dMy5TPGoN9i+iI1q
	 4f9yS1wCDLWqv14zB/2+ZEpNgm0wZa8VUbZMNCY3AugEX2L7TK8pnOvUYWKVAjR/PK
	 01rbpGbAcJpuzJblDPaQZjNE27p7ZTIxwYOZC6APKV7hAqqS20VhYAYRXSk1oFtgjG
	 941II6UNRIcSQ==
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
Subject: [PATCH v2 44/62] x86/jump_label: Define ELF section entry size for jump table
Date: Fri,  9 May 2025 13:17:08 -0700
Message-ID: <e5a4ef67a5c65d1686e4d0ce1887e045d56ffa41.1746821544.git.jpoimboe@kernel.org>
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

In preparation for the objtool klp diff subcommand, define the entry
size for the __jump_table section in its ELF header.  This will allow
tooling to extract individual entries.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 arch/x86/include/asm/jump_label.h | 32 +++++++++++++++++--------------
 include/linux/jump_label.h        | 20 +++++++++++--------
 2 files changed, 30 insertions(+), 22 deletions(-)

diff --git a/arch/x86/include/asm/jump_label.h b/arch/x86/include/asm/jump_label.h
index cd21554b3675..6081c33e1566 100644
--- a/arch/x86/include/asm/jump_label.h
+++ b/arch/x86/include/asm/jump_label.h
@@ -12,29 +12,31 @@
 #include <linux/stringify.h>
 #include <linux/types.h>
 
-#define JUMP_TABLE_ENTRY(key, label)			\
-	".pushsection __jump_table,  \"a\"\n\t"		\
-	_ASM_ALIGN "\n\t"				\
-	".long 1b - . \n\t"				\
-	".long " label " - . \n\t"			\
-	_ASM_PTR " " key " - . \n\t"			\
+#define JUMP_TABLE_ENTRY(key, label, size)				\
+	".pushsection __jump_table, \"aM\", @progbits, " size "\n\t"	\
+	_ASM_ALIGN "\n\t"						\
+	".long 1b - . \n\t"						\
+	".long " label " - . \n\t"					\
+	_ASM_PTR " " key " - . \n\t"					\
 	".popsection \n\t"
 
 /* This macro is also expanded on the Rust side. */
 #ifdef CONFIG_HAVE_JUMP_LABEL_HACK
-#define ARCH_STATIC_BRANCH_ASM(key, label)		\
+#define ARCH_STATIC_BRANCH_ASM(key, label, size)	\
 	"1: jmp " label " # objtool NOPs this \n\t"	\
-	JUMP_TABLE_ENTRY(key " + 2", label)
+	JUMP_TABLE_ENTRY(key " + 2", label, size)
 #else /* !CONFIG_HAVE_JUMP_LABEL_HACK */
-#define ARCH_STATIC_BRANCH_ASM(key, label)		\
+#define ARCH_STATIC_BRANCH_ASM(key, label, size)	\
 	"1: .byte " __stringify(BYTES_NOP5) "\n\t"	\
-	JUMP_TABLE_ENTRY(key, label)
+	JUMP_TABLE_ENTRY(key, label, size)
 #endif /* CONFIG_HAVE_JUMP_LABEL_HACK */
 
 static __always_inline bool arch_static_branch(struct static_key * const key, const bool branch)
 {
-	asm goto(ARCH_STATIC_BRANCH_ASM("%c0 + %c1", "%l[l_yes]")
-		: :  "i" (key), "i" (branch) : : l_yes);
+	asm goto(ARCH_STATIC_BRANCH_ASM("%c[key] + %c[branch]", "%l[l_yes]", "%c[size]")
+		 : : [key] "i" (key), [branch] "i" (branch),
+		     [size] "i" (sizeof(struct jump_entry))
+		 : : l_yes);
 
 	return false;
 l_yes:
@@ -45,8 +47,10 @@ static __always_inline bool arch_static_branch_jump(struct static_key * const ke
 {
 	asm goto("1:"
 		"jmp %l[l_yes]\n\t"
-		JUMP_TABLE_ENTRY("%c0 + %c1", "%l[l_yes]")
-		: :  "i" (key), "i" (branch) : : l_yes);
+		JUMP_TABLE_ENTRY("%c[key] + %c[branch]", "%l[l_yes]", "%c[size]")
+		: : [key] "i" (key), [branch] "i" (branch),
+		    [size] "i" (sizeof(struct jump_entry))
+		: : l_yes);
 
 	return false;
 l_yes:
diff --git a/include/linux/jump_label.h b/include/linux/jump_label.h
index fdb79dd1ebd8..9ff1ecc8e7a8 100644
--- a/include/linux/jump_label.h
+++ b/include/linux/jump_label.h
@@ -110,16 +110,20 @@ struct static_key {
 #endif /* __ASSEMBLY__ */
 
 #ifdef CONFIG_JUMP_LABEL
-#include <asm/jump_label.h>
-
-#ifndef __ASSEMBLY__
-#ifdef CONFIG_HAVE_ARCH_JUMP_LABEL_RELATIVE
 
+#if defined(CONFIG_HAVE_ARCH_JUMP_LABEL_RELATIVE) && !defined(__ASSEMBLY__)
+/* Must be defined before including <asm/jump_label.h> */
 struct jump_entry {
 	s32 code;
 	s32 target;
 	long key;	// key may be far away from the core kernel under KASLR
 };
+#endif
+
+#include <asm/jump_label.h>
+
+#ifndef __ASSEMBLY__
+#ifdef CONFIG_HAVE_ARCH_JUMP_LABEL_RELATIVE
 
 static inline unsigned long jump_entry_code(const struct jump_entry *entry)
 {
@@ -138,7 +142,7 @@ static inline struct static_key *jump_entry_key(const struct jump_entry *entry)
 	return (struct static_key *)((unsigned long)&entry->key + offset);
 }
 
-#else
+#else /* !CONFIG_HAVE_ARCH_JUMP_LABEL_RELATIVE */
 
 static inline unsigned long jump_entry_code(const struct jump_entry *entry)
 {
@@ -155,7 +159,7 @@ static inline struct static_key *jump_entry_key(const struct jump_entry *entry)
 	return (struct static_key *)((unsigned long)entry->key & ~3UL);
 }
 
-#endif
+#endif /* !CONFIG_HAVE_ARCH_JUMP_LABEL_RELATIVE */
 
 static inline bool jump_entry_is_branch(const struct jump_entry *entry)
 {
@@ -184,8 +188,8 @@ static inline int jump_entry_size(struct jump_entry *entry)
 #endif
 }
 
-#endif
-#endif
+#endif /* !__ASSEMBLY__ */
+#endif /* CONFIG_JUMP_LABEL */
 
 #ifndef __ASSEMBLY__
 
-- 
2.49.0


