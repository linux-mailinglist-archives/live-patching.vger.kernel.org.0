Return-Path: <live-patching+bounces-564-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 42C9C9692A5
	for <lists+live-patching@lfdr.de>; Tue,  3 Sep 2024 06:06:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 75FB11C2293D
	for <lists+live-patching@lfdr.de>; Tue,  3 Sep 2024 04:06:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E9DC3201244;
	Tue,  3 Sep 2024 04:00:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TvtovvBK"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF7F620012F;
	Tue,  3 Sep 2024 04:00:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725336044; cv=none; b=oWLBiQ7O/PEsMZ6b/FY/yrHCz17hByVTAyWdIsPzGi/+5FNvlVk4uGJCRLbctz3NtW6vDG3m1fo6wPAjTOrfFRDLYok/8HUHmgxWr6A4F8XkTaqFpSdksqDblbixzDp8FzwQS4Z+hTChvHDDNDVnn6v8CmKzIOWej3MzBHvqWwY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725336044; c=relaxed/simple;
	bh=XZH6GbpQqqfXTAWtcBScwAB8pujkxzWJvje19GUL4Cs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qcq0v7dNbOlbITO8gg0onepgy99BQON5uz0qseE7acUq/6At64X01oscp3wljDGt6PpvhMmPTJFaX22QoyvMDitpJCrUSERCRRaiOQf0szPjqJ5DEpn30vpKIoqaJu8Kt5TBZa2kYLbVQ34CRhELFR9+EJPGLgsEPrEePKK20gs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TvtovvBK; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49633C4CEC7;
	Tue,  3 Sep 2024 04:00:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725336044;
	bh=XZH6GbpQqqfXTAWtcBScwAB8pujkxzWJvje19GUL4Cs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TvtovvBKo9816mllYRKTLwt9zhZEKS3F8BbVy3qKPRSVuQ0ZwEb4P7A9Djb02tBcJ
	 6npZqjPZMns7hoO0I5+NhzldFT7JoKYN59QiuAI2GpdOkc3F0eckiadc6vdZYbte3Y
	 PXn6Z+WcSaO9iBGEJJhQH9KvMSR9hhi77uLrhE7CzWPPPi1S0qMjD/Oi/elsGTsbnH
	 pwj49zUsa8jrRulCJgP2NYOHOmCxrOxdt9KO3dtRzXZ5amn2anf1Ua14o1BVhRMOc7
	 I61Yydb6Bui4kV9/5bJ6hd7OVE9sXfrBrweys2jQ5MMNt3ZXHD97m0FDA4K2wLuqID
	 ZIYBm62hPMNIw==
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: live-patching@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	x86@kernel.org,
	Miroslav Benes <mbenes@suse.cz>,
	Petr Mladek <pmladek@suse.com>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	Jiri Kosina <jikos@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Marcos Paulo de Souza <mpdesouza@suse.com>,
	Song Liu <song@kernel.org>
Subject: [RFC 30/31] livepatch: Enable -ffunction-sections -fdata-sections
Date: Mon,  2 Sep 2024 21:00:13 -0700
Message-ID: <38c14842a3045e236bb5c446a86ca5536682a7b8.1725334260.git.jpoimboe@kernel.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <cover.1725334260.git.jpoimboe@kernel.org>
References: <cover.1725334260.git.jpoimboe@kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Doing a binary diff of two objects can be problematic:

  - For intra-section references, the compiler might use hard-coded
    offsets rather than relocations.

  - Data references can be ambiguous if the compiler uses section symbol
    references:

    - Symbol overlap and zero-length symbols create ambiguity as to
      which symbol is being referenced.

    - An access to the end of a symbol (e.g., array bounds) could be
      incorrectly interpreted as an access to the beginning of the next
      symbol.

Remove those ambiguities by turning on -ffunction-sections and
-fdata-sections for CONFIG_LIVEPATCH.

They could alternatively be turned on only during the comparison builds,
rather than also in the production kernel, but that might theoretically
leave the possibility open for unexpected differences between the
kernels.  The compared kernels should be identical to the original
kernel as much as possible.

The performance impact should be small.  Intra-TU references are quite
rare in practice.  And the resulting final code layout is similar.

Distros are likely going to start using these options soon anyway for
things like LTO and fgKASLR.

A potential alternative approach would be to add a toolchain option to
always use (symbol) relocations.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 Makefile                          |  9 +++++++++
 include/asm-generic/vmlinux.lds.h |  2 +-
 scripts/Makefile.lib              |  2 +-
 scripts/module.lds.S              | 13 +++++++++----
 4 files changed, 20 insertions(+), 6 deletions(-)

diff --git a/Makefile b/Makefile
index 3d10e3aadeda..2a15b560ecc0 100644
--- a/Makefile
+++ b/Makefile
@@ -931,10 +931,19 @@ ifdef CONFIG_DEBUG_SECTION_MISMATCH
 KBUILD_CFLAGS += -fno-inline-functions-called-once
 endif
 
+ifdef CONFIG_LIVEPATCH
+KBUILD_CFLAGS += -ffunction-sections -fdata-sections
 # `rustc`'s `-Zfunction-sections` applies to data too (as of 1.59.0).
+KBUILD_RUSTFLAGS += -Zfunction-sections=y
+else
 ifdef CONFIG_LD_DEAD_CODE_DATA_ELIMINATION
 KBUILD_CFLAGS_KERNEL += -ffunction-sections -fdata-sections
+# `rustc`'s `-Zfunction-sections` applies to data too (as of 1.59.0).
 KBUILD_RUSTFLAGS_KERNEL += -Zfunction-sections=y
+endif
+endif
+
+ifdef CONFIG_LD_DEAD_CODE_DATA_ELIMINATION
 LDFLAGS_vmlinux += --gc-sections
 endif
 
diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index 5703526d6ebf..a7ac3ca596ad 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -98,7 +98,7 @@
  * RODATA_MAIN is not used because existing code already defines .rodata.x
  * sections to be brought in with rodata.
  */
-#if defined(CONFIG_LD_DEAD_CODE_DATA_ELIMINATION) || defined(CONFIG_LTO_CLANG)
+#if defined(CONFIG_LD_DEAD_CODE_DATA_ELIMINATION) || defined(CONFIG_LTO_CLANG) || defined(CONFIG_LIVEPATCH)
 #define TEXT_MAIN .text .text.[0-9a-zA-Z_]*
 #define DATA_MAIN .data .data.[0-9a-zA-Z_]* .data..L* .data..compoundliteral* .data.$__unnamed_* .data.$L*
 #define SDATA_MAIN .sdata .sdata.[0-9a-zA-Z_]*
diff --git a/scripts/Makefile.lib b/scripts/Makefile.lib
index 9f4708702ef7..ca7497f74247 100644
--- a/scripts/Makefile.lib
+++ b/scripts/Makefile.lib
@@ -289,7 +289,7 @@ objtool-args = $(objtool-args-y)					\
 	$(if $(delay-objtool), --link)					\
 	$(if $(part-of-module), --module)
 
-delay-objtool := $(or $(CONFIG_LTO_CLANG),$(CONFIG_X86_KERNEL_IBT))
+delay-objtool := $(or $(CONFIG_LTO_CLANG),$(CONFIG_X86_KERNEL_IBT),$(CONFIG_LIVEPATCH))
 
 cmd_objtool = $(if $(objtool-enabled), ; $(objtool) $(objtool-args) $@)
 cmd_gen_objtooldep = $(if $(objtool-enabled), { echo ; echo '$@: $$(wildcard $(objtool))' ; } >> $(dot-target).cmd)
diff --git a/scripts/module.lds.S b/scripts/module.lds.S
index 3f43edef813c..5cbae820bca0 100644
--- a/scripts/module.lds.S
+++ b/scripts/module.lds.S
@@ -36,12 +36,17 @@ SECTIONS {
 	__kcfi_traps 		: { KEEP(*(.kcfi_traps)) }
 #endif
 
-#ifdef CONFIG_LTO_CLANG
+#if defined(CONFIG_LTO_CLANG) || defined(CONFIG_LIVEPATCH)
+
 	/*
-	 * With CONFIG_LTO_CLANG, LLD always enables -fdata-sections and
-	 * -ffunction-sections, which increases the size of the final module.
-	 * Merge the split sections in the final binary.
+	 * Merge -ffunction-sections and -fdata-sections sections to decrease
+	 * module size.
 	 */
+
+	.text : {
+		*(.text .text.[0-9a-zA-Z_]*)
+	}
+
 	.bss : {
 		*(.bss .bss.[0-9a-zA-Z_]*)
 		*(.bss..L*)
-- 
2.45.2


