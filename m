Return-Path: <live-patching+bounces-1659-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 744F9B80D2B
	for <lists+live-patching@lfdr.de>; Wed, 17 Sep 2025 18:04:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id ECB831C03013
	for <lists+live-patching@lfdr.de>; Wed, 17 Sep 2025 16:05:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D35E62F8BF5;
	Wed, 17 Sep 2025 16:04:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lTR/nntv"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAB192F8BD5;
	Wed, 17 Sep 2025 16:04:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758125059; cv=none; b=sZW6lBZeNITRvhFaZnR7AI1i/kLbXmLYy5o6/lfTZFeC4JFy4qfGNx1yycusmz6Rzn8LxM9O9r1nOf5oZDnOYj4vvo6ieLVV8uu9d9sxTAuJ3j5M6cRtYvQ/Qdt8uCICCgtBicV3cwH+mrHuDcsiqJc2DoIBQlMRGKhgtVLqOkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758125059; c=relaxed/simple;
	bh=I3QLLmOY/E7ZwGHM5EzQWEH4P7l7uhjOnzCBo67r6ow=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qeSW8AKMcPB0x//6S4k2icC3guensDDwTdu4NstVKJlhYwcQ39yLS3rUFwb4TenWdpV+y87cXNsjb3ms3oD/5AFNJr+mbLouHWfo1L2xgZUP9+lhN+ijCz162Y8NubqZhLingn0OBacpRQDxAwIozVxyFUivMTm5TUguw0r/YPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lTR/nntv; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E511BC4CEFA;
	Wed, 17 Sep 2025 16:04:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758125057;
	bh=I3QLLmOY/E7ZwGHM5EzQWEH4P7l7uhjOnzCBo67r6ow=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lTR/nntv9RmNGRbGXrMbzpvY9+jfTEiau9vqyltJA7yEdTEWUm5Vj0cZcQOvvVqNE
	 QjhD+5iv0aP15AeQWYOy/hp+VMD6m9/H0JOS0w1r5PhlVMTOW5SqE63z8yLwGmIhMX
	 /BLFrKFiIVkpa6TTl9/0YZXFQlMWX4EAGu/LhMBQNqRjnijFi5jJKnwxLQwFPWZwTB
	 lr8OezQcx9iC5pz4hAPabwtcEI4c+AexIibO76PA7VJxUHYuOhpvfyONl9E0o95P+P
	 ZNoV66q4v0T14r1aW+VsrExCsK8/uX4VjFVsrTlF81Tk/znq8gIf0FOhbupLPMZi3G
	 AWCsTsDFEzp2Q==
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
	Peter Zijlstra <peterz@infradead.org>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>
Subject: [PATCH v4 02/63] vmlinux.lds: Unify TEXT_MAIN, DATA_MAIN, and related macros
Date: Wed, 17 Sep 2025 09:03:10 -0700
Message-ID: <97d8b7710a8f5389e323d0933dec68888fec5f1f.1758067942.git.jpoimboe@kernel.org>
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

TEXT_MAIN, DATA_MAIN and friends are defined differently depending on
whether certain config options enable -ffunction-sections and/or
-fdata-sections.

There's no technical reason for that beyond voodoo coding.  Keeping the
separate implementations adds unnecessary complexity, fragments the
logic, and increases the risk of subtle bugs.

Unify the macros by using the same input section patterns across all
configs.

This is a prerequisite for the upcoming livepatch klp-build tooling
which will manually enable -ffunction-sections and -fdata-sections via
KCFLAGS.

Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 include/asm-generic/vmlinux.lds.h | 40 ++++++++++---------------------
 scripts/module.lds.S              | 12 ++++------
 2 files changed, 17 insertions(+), 35 deletions(-)

diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index ae2d2359b79e9..6b2311fa41393 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -87,39 +87,24 @@
 #define ALIGN_FUNCTION()  . = ALIGN(CONFIG_FUNCTION_ALIGNMENT)
 
 /*
- * LD_DEAD_CODE_DATA_ELIMINATION option enables -fdata-sections, which
- * generates .data.identifier sections, which need to be pulled in with
- * .data. We don't want to pull in .data..other sections, which Linux
- * has defined. Same for text and bss.
+ * Support -ffunction-sections by matching .text and .text.*,
+ * but exclude '.text..*'.
  *
- * With LTO_CLANG, the linker also splits sections by default, so we need
- * these macros to combine the sections during the final link.
- *
- * With AUTOFDO_CLANG and PROPELLER_CLANG, by default, the linker splits
- * text sections and regroups functions into subsections.
- *
- * RODATA_MAIN is not used because existing code already defines .rodata.x
- * sections to be brought in with rodata.
+ * Special .text.* sections that are typically grouped separately, such as
+ * .text.unlikely or .text.hot, must be matched explicitly before using
+ * TEXT_MAIN.
  */
-#if defined(CONFIG_LD_DEAD_CODE_DATA_ELIMINATION) || defined(CONFIG_LTO_CLANG) || \
-defined(CONFIG_AUTOFDO_CLANG) || defined(CONFIG_PROPELLER_CLANG)
 #define TEXT_MAIN .text .text.[0-9a-zA-Z_]*
-#else
-#define TEXT_MAIN .text
-#endif
-#if defined(CONFIG_LD_DEAD_CODE_DATA_ELIMINATION) || defined(CONFIG_LTO_CLANG)
+
+/*
+ * Support -fdata-sections by matching .data, .data.*, and others,
+ * but exclude '.data..*'.
+ */
 #define DATA_MAIN .data .data.[0-9a-zA-Z_]* .data.rel.* .data..L* .data..compoundliteral* .data.$__unnamed_* .data.$L*
 #define SDATA_MAIN .sdata .sdata.[0-9a-zA-Z_]*
 #define RODATA_MAIN .rodata .rodata.[0-9a-zA-Z_]* .rodata..L*
 #define BSS_MAIN .bss .bss.[0-9a-zA-Z_]* .bss..L* .bss..compoundliteral*
 #define SBSS_MAIN .sbss .sbss.[0-9a-zA-Z_]*
-#else
-#define DATA_MAIN .data .data.rel .data.rel.local
-#define SDATA_MAIN .sdata
-#define RODATA_MAIN .rodata
-#define BSS_MAIN .bss
-#define SBSS_MAIN .sbss
-#endif
 
 /*
  * GCC 4.5 and later have a 32 bytes section alignment for structures.
@@ -580,9 +565,8 @@ defined(CONFIG_AUTOFDO_CLANG) || defined(CONFIG_PROPELLER_CLANG)
  * during second ld run in second ld pass when generating System.map
  *
  * TEXT_MAIN here will match symbols with a fixed pattern (for example,
- * .text.hot or .text.unlikely) if dead code elimination or
- * function-section is enabled. Match these symbols first before
- * TEXT_MAIN to ensure they are grouped together.
+ * .text.hot or .text.unlikely).  Match those before TEXT_MAIN to ensure
+ * they get grouped together.
  *
  * Also placing .text.hot section at the beginning of a page, this
  * would help the TLB performance.
diff --git a/scripts/module.lds.S b/scripts/module.lds.S
index ee79c41059f3d..2632c6cb8ebe7 100644
--- a/scripts/module.lds.S
+++ b/scripts/module.lds.S
@@ -38,12 +38,10 @@ SECTIONS {
 	__kcfi_traps 		: { KEEP(*(.kcfi_traps)) }
 #endif
 
-#ifdef CONFIG_LTO_CLANG
-	/*
-	 * With CONFIG_LTO_CLANG, LLD always enables -fdata-sections and
-	 * -ffunction-sections, which increases the size of the final module.
-	 * Merge the split sections in the final binary.
-	 */
+	.text : {
+		*(.text .text.[0-9a-zA-Z_]*)
+	}
+
 	.bss : {
 		*(.bss .bss.[0-9a-zA-Z_]*)
 		*(.bss..L*)
@@ -58,7 +56,7 @@ SECTIONS {
 		*(.rodata .rodata.[0-9a-zA-Z_]*)
 		*(.rodata..L*)
 	}
-#endif
+
 	MOD_SEPARATE_CODETAG_SECTIONS()
 }
 
-- 
2.50.0


