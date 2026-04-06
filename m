Return-Path: <live-patching+bounces-2300-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id EBdgKIAA1GnmpAcAu9opvQ
	(envelope-from <live-patching+bounces-2300-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Mon, 06 Apr 2026 20:50:40 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 3355E3A65EE
	for <lists+live-patching@lfdr.de>; Mon, 06 Apr 2026 20:50:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id ADA6C30269D9
	for <lists+live-patching@lfdr.de>; Mon,  6 Apr 2026 18:50:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF79C394790;
	Mon,  6 Apr 2026 18:50:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UGr04Mm5"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74D0C3932C9
	for <live-patching@vger.kernel.org>; Mon,  6 Apr 2026 18:50:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775501421; cv=none; b=nVOTMGXznEdsLkQywJsggjGAcw0Wu8rK+9lRKivhGZpxgDo382ITIYr2cZbI9AQMAsLGWKojZzTJ4vclxLwsBshCNnOZfOKjElTiX4PNyjlZpwrGeJj+FUJBsGsJJMzn8ZXjPDx6wnYlsecz64tcXH0EelJkhUC7KiftFCIIp24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775501421; c=relaxed/simple;
	bh=MdCpEv7pNcsqP+BjYwCxAubdsGnIP1z6aGPzjPVTk3k=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=d1bDJJCu90DN1OT2OIwQlBOEkQrmroncsu2GndUh2ThaHXnUZQrBmk5fAw4nrl5nxI2oXjIWvGvwlXHyrEsjfexJuI17Tp/g+cOo2kcsmxrzttOIT71DtLvuqp26lA/0K6UX/9ftXoYzNAJK9q/iokbXVXA8uC8A86KJyMkxXWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--dylanbhatch.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=UGr04Mm5; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--dylanbhatch.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-82d40278103so802361b3a.2
        for <live-patching@vger.kernel.org>; Mon, 06 Apr 2026 11:50:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1775501420; x=1776106220; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=VpzT+ICu0jB9Dwg0WfUKLLeGWuMQN0uNeEJrD8H4J74=;
        b=UGr04Mm5Qzi34Ps58Se7QT2hqqnRPi2BMTt6HzFKCiT0ALhDjstFoekxjvO3vlAkeY
         csdkpAXBJa8sVT3Y+G4uqRTpjcesdx1/LbaE+e2I1q1eTEGfGR0eTTA8Iu58zXx0gRYF
         Lh+NKa6keOJGoPYs7KxECqDyStevPrtPOgi9UJtHpSSYYerosjldSKuqStfD/iawcbHm
         QrhvbITv3cd5TFqmgymqfM61pAlJGZ4WxQv+rGb4trKq5+T0jTRDS2XcNxIAfz7o1cq1
         6Aj+4f7cnppEG73eTOTYE/mzHy3kYe5oYtqom8XAL2p5Mg5I0lQhb/BI7cqgE+8cqGoi
         adsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775501420; x=1776106220;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VpzT+ICu0jB9Dwg0WfUKLLeGWuMQN0uNeEJrD8H4J74=;
        b=hKEcoSMf2DVz5mrFdaYEeeSbneq9DU2d4RA32H8FdT/WCKpY2+ukQ9akjugYEyYayS
         cD7g9/wlZ2Ivihu+Rnytnb2Qg4sleQ4PMWBTw8GLYvFrN1QiJEfCU/cGsQrwK94IWN12
         6cBJindDSMhkbkgeQE2is+dZSFHEXCaPLdA4loLwqDnn5j7U2O2/pBIl5jYnAHENqiPY
         7gXwOQKY0LiljV5c0zPoCwGcqxCBwG1FSmi+Hreh5sIFNqG3YAvt1PQzB0FrNqAjOjca
         mfKFAndXTRL9IYjbHMYP0hWoEH9b9bfH4Ub6ReDsSfuDK/gFqwgyFg4lr02NK+eYxsnJ
         zkWA==
X-Forwarded-Encrypted: i=1; AJvYcCUzQyc9avEY9O2n9K41Ief393gmJYQVIQk3qRi8FzXjdihD35P/fwaco6Zjx/j7Izwzz/kbLHjjKKZGs/KW@vger.kernel.org
X-Gm-Message-State: AOJu0YwpgXhrjhvtel/+9WfQG6efwUggKVX/P6lbJifiAFRr8rd2aT9I
	qa3ylB35PtSNgmu5pABrohnpV0j+q5Y0mb8wbrwl2zhYk8+hrfK4WHYUonRbZH0jOBbKCvPTTeJ
	WV/a0kg3UEwiM8rfNWdS34VTCsg==
X-Received: from pfus21.prod.google.com ([2002:a05:6a00:8d5:b0:824:aec2:e5eb])
 (user=dylanbhatch job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:2e22:b0:7e8:4471:ae55 with SMTP id d2e1a72fcca58-82d0db72eb0mr14262131b3a.33.1775501419533;
 Mon, 06 Apr 2026 11:50:19 -0700 (PDT)
Date: Mon,  6 Apr 2026 18:49:54 +0000
In-Reply-To: <20260406185000.1378082-1-dylanbhatch@google.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260406185000.1378082-1-dylanbhatch@google.com>
X-Mailer: git-send-email 2.53.0.1213.gd9a14994de-goog
Message-ID: <20260406185000.1378082-3-dylanbhatch@google.com>
Subject: [PATCH v3 2/8] arm64, unwind: build kernel with sframe V3 info
From: Dylan Hatch <dylanbhatch@google.com>
To: Roman Gushchin <roman.gushchin@linux.dev>, Weinan Liu <wnliu@google.com>, 
	Will Deacon <will@kernel.org>, Josh Poimboeuf <jpoimboe@kernel.org>, 
	Indu Bhagat <indu.bhagat@oracle.com>, Peter Zijlstra <peterz@infradead.org>, 
	Steven Rostedt <rostedt@goodmis.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Jiri Kosina <jikos@kernel.org>
Cc: Dylan Hatch <dylanbhatch@google.com>, Mark Rutland <mark.rutland@arm.com>, 
	Prasanna Kumar T S M <ptsm@linux.microsoft.com>, Puranjay Mohan <puranjay@kernel.org>, 
	Song Liu <song@kernel.org>, joe.lawrence@redhat.com, linux-toolchains@vger.kernel.org, 
	linux-kernel@vger.kernel.org, live-patching@vger.kernel.org, 
	Jens Remus <jremus@linux.ibm.com>, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-2300-lists,live-patching=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[20];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[dylanbhatch@google.com,live-patching@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	TAGGED_RCPT(0.00)[live-patching];
	DBL_BLOCKED_OPENRESOLVER(0.00)[goodmis.org:email,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 3355E3A65EE
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Build with -Wa,--gsframe-3 flags to generate a .sframe section. This
will be used for in-kernel reliable stacktrace in cases where the frame
pointer alone is insufficient.

Currently, the sframe format only supports arm64, x86_64 and s390x
architectures.

Signed-off-by: Weinan Liu <wnliu@google.com>
Signed-off-by: Dylan Hatch <dylanbhatch@google.com>
Reviewed-by: Prasanna Kumar T S M <ptsm@linux.microsoft.com>
---
 MAINTAINERS                            |  1 +
 Makefile                               |  8 ++++++++
 arch/Kconfig                           |  7 +++++++
 arch/arm64/Kconfig                     |  1 +
 arch/arm64/Kconfig.debug               | 13 +++++++++++++
 arch/arm64/include/asm/unwind_sframe.h | 12 ++++++++++++
 arch/arm64/kernel/vdso/Makefile        |  2 +-
 include/asm-generic/vmlinux.lds.h      | 15 +++++++++++++++
 8 files changed, 58 insertions(+), 1 deletion(-)
 create mode 100644 arch/arm64/include/asm/unwind_sframe.h

diff --git a/MAINTAINERS b/MAINTAINERS
index cfc7dec88da4..a7d75f9cb5f4 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -27561,6 +27561,7 @@ STACK UNWINDING
 M:	Josh Poimboeuf <jpoimboe@kernel.org>
 M:	Steven Rostedt <rostedt@goodmis.org>
 S:	Maintained
+F:	arch/*/include/asm/unwind_sframe.h
 F:	include/linux/sframe.h
 F:	include/linux/unwind*.h
 F:	kernel/unwind/
diff --git a/Makefile b/Makefile
index 2b15f0b4a0cb..e03d09ea6a23 100644
--- a/Makefile
+++ b/Makefile
@@ -1110,6 +1110,14 @@ endif
 # Ensure compilers do not transform certain loops into calls to wcslen()
 KBUILD_CFLAGS += -fno-builtin-wcslen
 
+# build with sframe table
+ifdef CONFIG_SFRAME_UNWINDER
+CC_FLAGS_SFRAME := -Wa,--gsframe-3
+KBUILD_CFLAGS	+= $(CC_FLAGS_SFRAME)
+KBUILD_AFLAGS	+= $(CC_FLAGS_SFRAME)
+export CC_FLAGS_SFRAME
+endif
+
 # change __FILE__ to the relative path to the source directory
 ifdef building_out_of_srctree
 KBUILD_CPPFLAGS += -fmacro-prefix-map=$(srcroot)/=
diff --git a/arch/Kconfig b/arch/Kconfig
index 6695c222c728..c87e489fa978 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -520,6 +520,13 @@ config SFRAME_VALIDATION
 
 	  If unsure, say N.
 
+config ARCH_SUPPORTS_SFRAME_UNWINDER
+	bool
+	help
+	  An architecture can select this if it  enables the sframe (Simple
+	  Frame) unwinder for unwinding kernel stack traces. It uses unwind
+	  table that is directly generatedby toolchain based on DWARF CFI information.
+
 config HAVE_PERF_REGS
 	bool
 	help
diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 38dba5f7e4d2..189bc199ad2e 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -112,6 +112,7 @@ config ARM64
 	select ARCH_SUPPORTS_SCHED_SMT
 	select ARCH_SUPPORTS_SCHED_CLUSTER
 	select ARCH_SUPPORTS_SCHED_MC
+	select ARCH_SUPPORTS_SFRAME_UNWINDER
 	select ARCH_WANT_BATCHED_UNMAP_TLB_FLUSH
 	select ARCH_WANT_COMPAT_IPC_PARSE_VERSION if COMPAT
 	select ARCH_WANT_DEFAULT_BPF_JIT
diff --git a/arch/arm64/Kconfig.debug b/arch/arm64/Kconfig.debug
index 265c4461031f..df291d64812f 100644
--- a/arch/arm64/Kconfig.debug
+++ b/arch/arm64/Kconfig.debug
@@ -20,4 +20,17 @@ config ARM64_RELOC_TEST
 	depends on m
 	tristate "Relocation testing module"
 
+config SFRAME_UNWINDER
+	bool "Sframe unwinder"
+	depends on AS_SFRAME3
+	depends on 64BIT
+	depends on ARCH_SUPPORTS_SFRAME_UNWINDER
+	select SFRAME_LOOKUP
+	help
+	  This option enables the sframe (Simple Frame) unwinder for unwinding
+	  kernel stack traces. It uses unwind table that is directly generated
+	  by toolchain based on DWARF CFI information. In, practice this can
+	  provide more reliable stacktrace results than unwinding with frame
+	  pointers alone.
+
 source "drivers/hwtracing/coresight/Kconfig"
diff --git a/arch/arm64/include/asm/unwind_sframe.h b/arch/arm64/include/asm/unwind_sframe.h
new file mode 100644
index 000000000000..1682c079e387
--- /dev/null
+++ b/arch/arm64/include/asm/unwind_sframe.h
@@ -0,0 +1,12 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _ASM_ARM64_UNWIND_SFRAME_H
+#define _ASM_ARM64_UNWIND_SFRAME_H
+
+#ifdef CONFIG_ARM64
+
+#define SFRAME_REG_SP	31
+#define SFRAME_REG_FP	29
+
+#endif
+
+#endif /* _ASM_ARM64_UNWIND_SFRAME_H */
diff --git a/arch/arm64/kernel/vdso/Makefile b/arch/arm64/kernel/vdso/Makefile
index 7dec05dd33b7..c60ef921956f 100644
--- a/arch/arm64/kernel/vdso/Makefile
+++ b/arch/arm64/kernel/vdso/Makefile
@@ -38,7 +38,7 @@ ccflags-y += -DDISABLE_BRANCH_PROFILING -DBUILD_VDSO
 CC_FLAGS_REMOVE_VDSO := $(CC_FLAGS_FTRACE) -Os $(CC_FLAGS_SCS) \
 			$(RANDSTRUCT_CFLAGS) $(KSTACK_ERASE_CFLAGS) \
 			$(GCC_PLUGINS_CFLAGS) \
-			$(CC_FLAGS_LTO) $(CC_FLAGS_CFI) \
+			$(CC_FLAGS_LTO) $(CC_FLAGS_CFI) $(CC_FLAGS_SFRAME) \
 			-Wmissing-prototypes -Wmissing-declarations
 
 CC_FLAGS_ADD_VDSO := -O2 -mcmodel=tiny -fasynchronous-unwind-tables
diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index 1e1580febe4b..0a5c2f6cc4c0 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -491,6 +491,8 @@
 		*(.rodata1)						\
 	}								\
 									\
+	SFRAME								\
+									\
 	/* PCI quirks */						\
 	.pci_fixup        : AT(ADDR(.pci_fixup) - LOAD_OFFSET) {	\
 		BOUNDED_SECTION_PRE_LABEL(.pci_fixup_early,  _pci_fixups_early,  __start, __end) \
@@ -911,6 +913,19 @@
 #define TRACEDATA
 #endif
 
+#ifdef CONFIG_SFRAME_UNWINDER
+#define SFRAME							\
+	/* sframe */						\
+	.sframe : AT(ADDR(.sframe) - LOAD_OFFSET) {		\
+		__start_sframe_header = .;			\
+		KEEP(*(.sframe))				\
+		KEEP(*(.init.sframe))				\
+		__stop_sframe_header = .;			\
+	}
+#else
+#define SFRAME
+#endif
+
 #ifdef CONFIG_PRINTK_INDEX
 #define PRINTK_INDEX							\
 	.printk_index : AT(ADDR(.printk_index) - LOAD_OFFSET) {		\
-- 
2.53.0.1213.gd9a14994de-goog


