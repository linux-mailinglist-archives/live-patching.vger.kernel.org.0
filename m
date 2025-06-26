Return-Path: <live-patching+bounces-1576-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E0099AEAB5D
	for <lists+live-patching@lfdr.de>; Fri, 27 Jun 2025 02:04:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 080CD16ECCE
	for <lists+live-patching@lfdr.de>; Fri, 27 Jun 2025 00:04:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 11A6228C2C9;
	Thu, 26 Jun 2025 23:56:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="W+RA9wEu"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D03C628C01A;
	Thu, 26 Jun 2025 23:56:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750982203; cv=none; b=L7BFVsjIIfFbxwp7h1eBumCTOmwF8jAXiJ/NlPGhE1pJRqCsSmzP2rjxrAqXTUK6PqxlOt0kX0dHBUeFHxbqFTHl9ZX0kFBbXxVb3VhkEgIcpkmdX8NIEjGutntHFm3cZbXC9viQIPdIuD5u+l7EQfv/y8HbnC3nXMvL7VNlEWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750982203; c=relaxed/simple;
	bh=PBM/iTiwWZaioDN0pY0/oaH5NWCKZ6CmHlpih2f76eA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ggtzzs/FWA6JnUyxDGj65Dq/teZK96vzdCp1OzGlRExdDU0gHWZ0Sr9QNP13pQ99wx/PaaS8Dr/2bFMTBQvgLg+jRo9A1r+HSoc0788Qvd4wWa7ZXf+RyNIPz0EA8YddRPg59Fz3+u8ZX/z0g3ZsRfpsZeruTVEPgqpzLIoqNfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=W+RA9wEu; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34430C4CEF1;
	Thu, 26 Jun 2025 23:56:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750982203;
	bh=PBM/iTiwWZaioDN0pY0/oaH5NWCKZ6CmHlpih2f76eA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W+RA9wEuKsa4XOvMIGZhtd5xeGH37+B6bsrcfH9A4LjbYvd98Ect8C168u3xvl6R5
	 tZyQvhDseTxUly3T8gH2T1Vv8T2dhmYr9M9mSqUj/kqzIWh0GLpJOzCr7+vTPAwbcN
	 hIUGtITxHhULqk8bHrPxUEPcBGIcO97m85ZkbxHkT4L5OoKyRSYAa5z5wIvg0aQXA2
	 nz0uTz3/S8DbEAD5V+HJSkG1wsT6zYGXuCjc9FLzCGCejQhV+naCjH+476Fc2/vzwS
	 Nkt7ni+wJCHmmlch3hyFu73azjxheeLaLLUB0nxpEN/Sn+aZ9m/2T45cOZqlrQKiZS
	 n3Ai6TTk+W/wA==
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
Subject: [PATCH v3 46/64] x86/extable: Define ELF section entry size for exception table
Date: Thu, 26 Jun 2025 16:55:33 -0700
Message-ID: <1a53b6dcf236ce1fe0f0cd0d4441fc2bd9022cb3.1750980517.git.jpoimboe@kernel.org>
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
size for the __ex_table section in its ELF header.  This will allow
tooling to extract individual entries.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 arch/um/include/asm/Kbuild                 |  1 -
 arch/um/include/shared/common-offsets.h    |  1 +
 arch/x86/include/asm/asm.h                 | 18 ++++++++++--------
 arch/x86/kernel/asm-offsets.c              |  1 +
 arch/x86/um/shared/sysdep/kernel-offsets.h |  1 +
 5 files changed, 13 insertions(+), 9 deletions(-)

diff --git a/arch/um/include/asm/Kbuild b/arch/um/include/asm/Kbuild
index 04ab3b653a48..1934fa0df888 100644
--- a/arch/um/include/asm/Kbuild
+++ b/arch/um/include/asm/Kbuild
@@ -5,7 +5,6 @@ generic-y += device.h
 generic-y += dma-mapping.h
 generic-y += emergency-restart.h
 generic-y += exec.h
-generic-y += extable.h
 generic-y += ftrace.h
 generic-y += hw_irq.h
 generic-y += irq_regs.h
diff --git a/arch/um/include/shared/common-offsets.h b/arch/um/include/shared/common-offsets.h
index 4e19103afd71..a6f77cb6aa7e 100644
--- a/arch/um/include/shared/common-offsets.h
+++ b/arch/um/include/shared/common-offsets.h
@@ -20,3 +20,4 @@ DEFINE(UM_KERN_GDT_ENTRY_TLS_ENTRIES, GDT_ENTRY_TLS_ENTRIES);
 DEFINE(UM_SECCOMP_ARCH_NATIVE, SECCOMP_ARCH_NATIVE);
 
 DEFINE(ALT_INSTR_SIZE, sizeof(struct alt_instr));
+DEFINE(EXTABLE_SIZE,   sizeof(struct exception_table_entry));
diff --git a/arch/x86/include/asm/asm.h b/arch/x86/include/asm/asm.h
index 1f26f90a57ce..e9b6d2d006c6 100644
--- a/arch/x86/include/asm/asm.h
+++ b/arch/x86/include/asm/asm.h
@@ -145,12 +145,12 @@ static __always_inline __pure void *rip_rel_ptr(void *p)
 /* Exception table entry */
 #ifdef __ASSEMBLER__
 
-# define _ASM_EXTABLE_TYPE(from, to, type)			\
-	.pushsection "__ex_table","a" ;				\
-	.balign 4 ;						\
-	.long (from) - . ;					\
-	.long (to) - . ;					\
-	.long type ;						\
+# define _ASM_EXTABLE_TYPE(from, to, type)				\
+	.pushsection "__ex_table", "aM", @progbits, EXTABLE_SIZE;	\
+	.balign 4 ;							\
+	.long (from) - . ;						\
+	.long (to) - . ;						\
+	.long type ;							\
 	.popsection
 
 # ifdef CONFIG_KPROBES
@@ -193,7 +193,8 @@ static __always_inline __pure void *rip_rel_ptr(void *p)
 	".purgem extable_type_reg\n"
 
 # define _ASM_EXTABLE_TYPE(from, to, type)			\
-	" .pushsection \"__ex_table\",\"a\"\n"			\
+	" .pushsection __ex_table, \"aM\", @progbits, "		\
+		       __stringify(EXTABLE_SIZE) "\n"		\
 	" .balign 4\n"						\
 	" .long (" #from ") - .\n"				\
 	" .long (" #to ") - .\n"				\
@@ -201,7 +202,8 @@ static __always_inline __pure void *rip_rel_ptr(void *p)
 	" .popsection\n"
 
 # define _ASM_EXTABLE_TYPE_REG(from, to, type, reg)				\
-	" .pushsection \"__ex_table\",\"a\"\n"					\
+	" .pushsection __ex_table, \"aM\", @progbits, "				\
+		       __stringify(EXTABLE_SIZE) "\n"				\
 	" .balign 4\n"								\
 	" .long (" #from ") - .\n"						\
 	" .long (" #to ") - .\n"						\
diff --git a/arch/x86/kernel/asm-offsets.c b/arch/x86/kernel/asm-offsets.c
index b51625c3f64c..3d3eef7fae32 100644
--- a/arch/x86/kernel/asm-offsets.c
+++ b/arch/x86/kernel/asm-offsets.c
@@ -125,4 +125,5 @@ static void __used common(void)
 
 	BLANK();
 	DEFINE(ALT_INSTR_SIZE,	 sizeof(struct alt_instr));
+	DEFINE(EXTABLE_SIZE,	 sizeof(struct exception_table_entry));
 }
diff --git a/arch/x86/um/shared/sysdep/kernel-offsets.h b/arch/x86/um/shared/sysdep/kernel-offsets.h
index 9f6d3d1a248c..8215a0200ddd 100644
--- a/arch/x86/um/shared/sysdep/kernel-offsets.h
+++ b/arch/x86/um/shared/sysdep/kernel-offsets.h
@@ -8,6 +8,7 @@
 #include <linux/audit.h>
 #include <asm/mman.h>
 #include <asm/seccomp.h>
+#include <asm/extable.h>
 
 /* workaround for a warning with -Wmissing-prototypes */
 void foo(void);
-- 
2.49.0


