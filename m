Return-Path: <live-patching+bounces-1361-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3ECA5AB1DCC
	for <lists+live-patching@lfdr.de>; Fri,  9 May 2025 22:17:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B7BFB4C6B49
	for <lists+live-patching@lfdr.de>; Fri,  9 May 2025 20:17:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 009AC25F79B;
	Fri,  9 May 2025 20:17:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eqEfFw+o"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCE6E25F793;
	Fri,  9 May 2025 20:17:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746821865; cv=none; b=jzhVn9rcqSY1z9wSSewyhzayxD2DG4Rkl0SF5YNDhBdxDspooc2DgR3DiPcjo/oj04LR6YbI6DiZRnL9MN5iFowZfwrB3R6Xb6LJ1Tvk2wnMngcR0/bzll+5agt76orrRvBN27FvhYUYzkIuA1+kotoZxDVtsGdgQ2C5wxXsZwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746821865; c=relaxed/simple;
	bh=4TA+WNxTrns2N3CKVtMj7arg+1eFOn6rCtTLzKHGzU4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SKH+0KIWHcsdCh4ivybMBi1g6GbVjn2ZXOQQVrHFZMA0jWakCfev9Ly3JLc5/i43u3W2zMP//ZL2awWspsYgTE7IySH+wBkWm4JZBJvAOSA1F1HVzP1tB/7XNUh4APPeGw+GHQxfl48O33smw7uAkArFkc/dqzw14YM9jHzeYGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eqEfFw+o; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 989CBC4CEE4;
	Fri,  9 May 2025 20:17:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746821865;
	bh=4TA+WNxTrns2N3CKVtMj7arg+1eFOn6rCtTLzKHGzU4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eqEfFw+olaGYPSpB3Ec/rsQfz8WWspeqonPWN/YLgGrhRdVX9jdfzXdJ7Jxx0QCXn
	 YaOqPJkIo3WoZmaiPyjrz0rsq19lJzPJ9C1jjhHv7L+DFNIg2jvuWOJG9jfV2I8sZQ
	 10Eysk/zAASwGxAwWslfoH3/M0KDItA1dDG3XTe/lntr6mT0YoaFSlW45gCxn0KR+M
	 GQnrNxMC2hTlNpitl/eLfsvppF2CiD6Kab/uK290NAPACrp8ZsOPjx2pJAIzhy/XQs
	 fHLvjFos76WRmVN8EfRshE/FIkCuUZTiAyWOqh+Jd47FzdM0RmlgoS0vLhWo8EGD0r
	 yGb5eTmPuwiig==
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
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>
Subject: [PATCH v2 02/62] vmlinux.lds: Unify TEXT_MAIN, DATA_MAIN, and related macros
Date: Fri,  9 May 2025 13:16:26 -0700
Message-ID: <47f63106a68a38d5a2003ca2989b3512e1338ddc.1746821544.git.jpoimboe@kernel.org>
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
 scripts/module.lds.S              | 16 ++++---------
 2 files changed, 17 insertions(+), 39 deletions(-)

diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index 66409bc3a4e0..9417c7501018 100644
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
+ * .text.unlikely or .text.hot, must be matched explicitly before invoking
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
index 450f1088d5fd..0b5ea63d1c67 100644
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
@@ -59,11 +57,7 @@ SECTIONS {
 		*(.rodata .rodata.[0-9a-zA-Z_]*)
 		*(.rodata..L*)
 	}
-#else
-	.data : {
-		MOD_CODETAG_SECTIONS()
-	}
-#endif
+
 	MOD_SEPARATE_CODETAG_SECTIONS()
 }
 
-- 
2.49.0


