Return-Path: <live-patching+bounces-1573-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 18E83AEAB5C
	for <lists+live-patching@lfdr.de>; Fri, 27 Jun 2025 02:04:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6D3927AE79F
	for <lists+live-patching@lfdr.de>; Fri, 27 Jun 2025 00:02:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E5F05287266;
	Thu, 26 Jun 2025 23:56:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gN/QoBtx"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEDD028725A;
	Thu, 26 Jun 2025 23:56:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750982201; cv=none; b=dniWNQKrIWmmzchNcNpCRfFIU9WuzrJwNjIIOwTsQR16ebOn5kDa/uxItqWWaoSKdOy6H/uxIwulaxU3Pj5FoeyOhXKk0GQ5MyZPXXztUYjhtAGxUkR20G3/5+m1YPdzZbNrqAtsU4LhtTQl8tcOSnzA5hnIGgaysx5pnJGiohk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750982201; c=relaxed/simple;
	bh=XNadUm4w3TOd182HQ2jLUMQ5nZfFXy4kWo38Kr7zPQs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nO7v73ly2D17aixDuPpzG01iNOneuW5lsZuxBTDXoGXxQyr84GRsvgcAhkgSx7cZlkrexl32yXe8k800geoAR4f/pN3L1RElYrox7VEDAe7bWRmOT4pZkJLyiYo4r8ZFot6tFXmNCN24ioCoJp6xUeacmtVttW2weZdlYM2WkvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gN/QoBtx; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 201F0C4CEEB;
	Thu, 26 Jun 2025 23:56:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750982201;
	bh=XNadUm4w3TOd182HQ2jLUMQ5nZfFXy4kWo38Kr7zPQs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gN/QoBtx3ZLPJhRZ2XanmsdXjEE8dboeEq4jH57XDCCi0u0jGDj8uypPsNPXq1xGg
	 7e1LotlGf8BV6mwiVgdHyDxYJW1tTJcrlZStenBLsDE85kFCCiV8qmROKZC0fEQzYh
	 Y8qNaosDTwaF+mgkfzUEVauNHDwung2aU8tSyV7pzRNqORfg8d2qgVl2/ZABGWPszb
	 CdJjkoOo6auyigSU+A8pfiDt6W9xi5Q42eh3ySvBCndbVrHI0psJuRuR//7kH3od3W
	 xJbIzSUiLSIhTbVdfUkzOfP4s8qn0Pgvcs4j1839xRAGzUpaqELvEfMLFiTIxVmYXP
	 0H+4rHABOvOfg==
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
Subject: [PATCH v3 43/64] x86/alternative: Define ELF section entry size for alternatives
Date: Thu, 26 Jun 2025 16:55:30 -0700
Message-ID: <e048e6afcb2022114ea908205f4e81b7a53eba48.1750980517.git.jpoimboe@kernel.org>
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
size for the .altinstructions section in its ELF header.  This will
allow tooling to extract individual entries.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 arch/um/include/shared/common-offsets.h    | 2 ++
 arch/x86/include/asm/alternative.h         | 5 +++--
 arch/x86/include/asm/asm.h                 | 4 ++++
 arch/x86/kernel/asm-offsets.c              | 2 ++
 arch/x86/um/shared/sysdep/kernel-offsets.h | 1 +
 kernel/bounds.c                            | 1 +
 scripts/mod/devicetable-offsets.c          | 1 +
 7 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/arch/um/include/shared/common-offsets.h b/arch/um/include/shared/common-offsets.h
index 8ca66a1918c3..4e19103afd71 100644
--- a/arch/um/include/shared/common-offsets.h
+++ b/arch/um/include/shared/common-offsets.h
@@ -18,3 +18,5 @@ DEFINE(UM_NSEC_PER_USEC, NSEC_PER_USEC);
 DEFINE(UM_KERN_GDT_ENTRY_TLS_ENTRIES, GDT_ENTRY_TLS_ENTRIES);
 
 DEFINE(UM_SECCOMP_ARCH_NATIVE, SECCOMP_ARCH_NATIVE);
+
+DEFINE(ALT_INSTR_SIZE, sizeof(struct alt_instr));
diff --git a/arch/x86/include/asm/alternative.h b/arch/x86/include/asm/alternative.h
index 15bc07a5ebb3..eb24d9ba30d7 100644
--- a/arch/x86/include/asm/alternative.h
+++ b/arch/x86/include/asm/alternative.h
@@ -197,7 +197,8 @@ static inline int alternatives_text_reserved(void *start, void *end)
 	"773:\n"
 
 #define ALTINSTR_ENTRY(ft_flags)					      \
-	".pushsection .altinstructions,\"a\"\n"				      \
+	".pushsection .altinstructions, \"aM\", @progbits, "		      \
+		      __stringify(ALT_INSTR_SIZE) "\n"			      \
 	" .long 771b - .\n"				/* label           */ \
 	" .long 774f - .\n"				/* new instruction */ \
 	" .4byte " __stringify(ft_flags) "\n"		/* feature + flags */ \
@@ -360,7 +361,7 @@ void nop_func(void);
 741:									\
 	.skip -(((744f-743f)-(741b-740b)) > 0) * ((744f-743f)-(741b-740b)),0x90	;\
 742:									\
-	.pushsection .altinstructions,"a" ;				\
+	.pushsection .altinstructions, "aM", @progbits, ALT_INSTR_SIZE ;\
 	altinstr_entry 740b,743f,flag,742b-740b,744f-743f ;		\
 	.popsection ;							\
 	.pushsection .altinstr_replacement,"ax"	;			\
diff --git a/arch/x86/include/asm/asm.h b/arch/x86/include/asm/asm.h
index f963848024a5..1f26f90a57ce 100644
--- a/arch/x86/include/asm/asm.h
+++ b/arch/x86/include/asm/asm.h
@@ -136,6 +136,10 @@ static __always_inline __pure void *rip_rel_ptr(void *p)
 
 #ifdef __KERNEL__
 
+#ifndef COMPILE_OFFSETS
+#include <asm/asm-offsets.h>
+#endif
+
 # include <asm/extable_fixup_types.h>
 
 /* Exception table entry */
diff --git a/arch/x86/kernel/asm-offsets.c b/arch/x86/kernel/asm-offsets.c
index 6259b474073b..b51625c3f64c 100644
--- a/arch/x86/kernel/asm-offsets.c
+++ b/arch/x86/kernel/asm-offsets.c
@@ -123,4 +123,6 @@ static void __used common(void)
 	OFFSET(ARIA_CTX_rounds, aria_ctx, rounds);
 #endif
 
+	BLANK();
+	DEFINE(ALT_INSTR_SIZE,	 sizeof(struct alt_instr));
 }
diff --git a/arch/x86/um/shared/sysdep/kernel-offsets.h b/arch/x86/um/shared/sysdep/kernel-offsets.h
index 6fd1ed400399..9f6d3d1a248c 100644
--- a/arch/x86/um/shared/sysdep/kernel-offsets.h
+++ b/arch/x86/um/shared/sysdep/kernel-offsets.h
@@ -1,4 +1,5 @@
 /* SPDX-License-Identifier: GPL-2.0 */
+#define COMPILE_OFFSETS
 #include <linux/stddef.h>
 #include <linux/sched.h>
 #include <linux/elf.h>
diff --git a/kernel/bounds.c b/kernel/bounds.c
index 29b2cd00df2c..02b619eb6106 100644
--- a/kernel/bounds.c
+++ b/kernel/bounds.c
@@ -6,6 +6,7 @@
  */
 
 #define __GENERATING_BOUNDS_H
+#define COMPILE_OFFSETS
 /* Include headers that define the enum constants of interest */
 #include <linux/page-flags.h>
 #include <linux/mmzone.h>
diff --git a/scripts/mod/devicetable-offsets.c b/scripts/mod/devicetable-offsets.c
index d3d00e85edf7..ef2ffb68f69d 100644
--- a/scripts/mod/devicetable-offsets.c
+++ b/scripts/mod/devicetable-offsets.c
@@ -1,4 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0
+#define COMPILE_OFFSETS
 #include <linux/kbuild.h>
 #include <linux/mod_devicetable.h>
 
-- 
2.49.0


