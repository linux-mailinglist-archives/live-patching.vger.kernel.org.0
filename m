Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E1646876A5
	for <lists+live-patching@lfdr.de>; Thu,  2 Feb 2023 08:43:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232113AbjBBHni (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 2 Feb 2023 02:43:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232111AbjBBHnR (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 2 Feb 2023 02:43:17 -0500
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A1E0E84B59;
        Wed,  1 Feb 2023 23:42:43 -0800 (PST)
Received: from x64host.home (unknown [47.187.213.40])
        by linux.microsoft.com (Postfix) with ESMTPSA id 99EFB20B2EE4;
        Wed,  1 Feb 2023 23:42:42 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 99EFB20B2EE4
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1675323763;
        bh=CDc7R+oUQPek3aA1dFgOorPmCowQj3RJsL4UXFb2DgY=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=goYLJgwf1YQT2czqCuodcUPHAsKPIdaqYhBPR9ytjVVj8gaYPMeDhCVeBL8t2owJr
         JV228E1OZrBX/eS1A9h4wSLkcoKdieF6ov+xakMKTyBr36GEj/40Xj6Zl62UTYi5DJ
         UYLoQukcEM4pHnPt2pQSqW8ZdBOWuMxcl7Plm5AU=
From:   madvenka@linux.microsoft.com
To:     jpoimboe@redhat.com, peterz@infradead.org, chenzhongjin@huawei.com,
        mark.rutland@arm.com, broonie@kernel.org, nobuta.keiya@fujitsu.com,
        sjitindarsingh@gmail.com, catalin.marinas@arm.com, will@kernel.org,
        jamorris@linux.microsoft.com, linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        madvenka@linux.microsoft.com
Subject: [RFC PATCH v3 18/22] arm64: Build the kernel with ORC information
Date:   Thu,  2 Feb 2023 01:40:32 -0600
Message-Id: <20230202074036.507249-19-madvenka@linux.microsoft.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230202074036.507249-1-madvenka@linux.microsoft.com>
References: <0337266cf19f4c98388e3f6d09f590d9de258dc7>
 <20230202074036.507249-1-madvenka@linux.microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-19.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>

Add code to scripts/Makefile.lib to define objtool options to generate
ORC data for frame pointer validation.

Define kernel configs:
	- to enable dynamic FRAME_POINTER_VALIDATION
	- to enable the generation of ORC data using objtool

When these configs are enabled, objtool is invoked on relocatable files
during kernel build with the following command:

	objtool --stackval --orc <object-file>

Objtool creates special sections in the object files:

.orc_unwind_ip	PC array.
.orc_unwind	ORC structure table.
.orc_lookup	ORC lookup table.

Change arch/arm64/kernel/vmlinux.lds.S to include ORC_UNWIND_TABLE in
the data section so that the special sections get included there. For
modules, these sections will be added to the kernel during module load.

In the future, the kernel can use these sections to find the ORC for a
given instruction address. The unwinder can then compute the FP at an
instruction address and validate the actual FP with that.

Signed-off-by: Madhavan T. Venkataraman <madvenka@linux.microsoft.com>
---
 arch/arm64/Kconfig              |  2 ++
 arch/arm64/Kconfig.debug        | 32 ++++++++++++++++++++++++++++++++
 arch/arm64/include/asm/module.h | 12 +++++++++++-
 arch/arm64/kernel/vmlinux.lds.S |  3 +++
 include/linux/objtool.h         |  2 ++
 scripts/Makefile                |  4 +++-
 scripts/Makefile.lib            |  9 +++++++++
 tools/include/linux/objtool.h   |  2 ++
 8 files changed, 64 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 505c8a1ccbe0..73c3f30a37c7 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -230,6 +230,8 @@ config ARM64
 	select TRACE_IRQFLAGS_SUPPORT
 	select TRACE_IRQFLAGS_NMI_SUPPORT
 	select HAVE_SOFTIRQ_ON_OWN_STACK
+	select HAVE_STACK_VALIDATION	if FRAME_POINTER_VALIDATION
+	select STACK_VALIDATION		if HAVE_STACK_VALIDATION
 	help
 	  ARM 64-bit (AArch64) Linux support.
 
diff --git a/arch/arm64/Kconfig.debug b/arch/arm64/Kconfig.debug
index 265c4461031f..a50caabdb18e 100644
--- a/arch/arm64/Kconfig.debug
+++ b/arch/arm64/Kconfig.debug
@@ -20,4 +20,36 @@ config ARM64_RELOC_TEST
 	depends on m
 	tristate "Relocation testing module"
 
+config UNWINDER_ORC
+	bool "ORC unwinder"
+	depends on FRAME_POINTER_VALIDATION
+	select HAVE_MOD_ARCH_SPECIFIC
+	select OBJTOOL
+	help
+	  This option enables ORC (Oops Rewind Capability) for ARM64. This
+	  allows the unwinder to look up ORC data for an instruction address
+	  and compute the frame pointer at that address. The computed frame
+	  pointer is used to validate the actual frame pointer.
+
+config UNWINDER_FRAME_POINTER
+	bool "Frame pointer unwinder"
+	depends on FRAME_POINTER_VALIDATION
+	select FRAME_POINTER
+	help
+	  ARM64 already uses the frame pointer for unwinding kernel stack
+	  traces. We need to enable this config to enable STACK_VALIDATION.
+	  STACK_VALIDATION is needed to get objtool to do static analysis
+	  of kernel code.
+
+config FRAME_POINTER_VALIDATION
+	bool "Dynamic Frame pointer validation"
+	select UNWINDER_FRAME_POINTER
+	select UNWINDER_ORC
+	help
+		This invokes objtool on every object file causing it to
+		generate ORC data for the object file. ORC data is in a custom
+		data format which is a simplified version of the DWARF
+		Call Frame Information standard. See UNWINDER_ORC for more
+		details.
+
 source "drivers/hwtracing/coresight/Kconfig"
diff --git a/arch/arm64/include/asm/module.h b/arch/arm64/include/asm/module.h
index 18734fed3bdd..4362f44aae61 100644
--- a/arch/arm64/include/asm/module.h
+++ b/arch/arm64/include/asm/module.h
@@ -6,6 +6,7 @@
 #define __ASM_MODULE_H
 
 #include <asm-generic/module.h>
+#include <asm/orc_types.h>
 
 #ifdef CONFIG_ARM64_MODULE_PLTS
 struct mod_plt_sec {
@@ -13,15 +14,24 @@ struct mod_plt_sec {
 	int			plt_num_entries;
 	int			plt_max_entries;
 };
+#endif
 
+#ifdef CONFIG_HAVE_MOD_ARCH_SPECIFIC
 struct mod_arch_specific {
+#ifdef CONFIG_ARM64_MODULE_PLTS
 	struct mod_plt_sec	core;
 	struct mod_plt_sec	init;
 
 	/* for CONFIG_DYNAMIC_FTRACE */
 	struct plt_entry	*ftrace_trampolines;
-};
 #endif
+#ifdef CONFIG_UNWINDER_ORC
+	unsigned int num_orcs;
+	int *orc_unwind_ip;
+	struct orc_entry *orc_unwind;
+#endif
+};
+#endif /* CONFIG_HAVE_MOD_ARCH_SPECIFIC */
 
 u64 module_emit_plt_entry(struct module *mod, Elf64_Shdr *sechdrs,
 			  void *loc, const Elf64_Rela *rela,
diff --git a/arch/arm64/kernel/vmlinux.lds.S b/arch/arm64/kernel/vmlinux.lds.S
index 45131e354e27..bf7b55ae10ee 100644
--- a/arch/arm64/kernel/vmlinux.lds.S
+++ b/arch/arm64/kernel/vmlinux.lds.S
@@ -61,6 +61,7 @@
 #define RUNTIME_DISCARD_EXIT
 
 #include <asm-generic/vmlinux.lds.h>
+#include <asm-generic/orc_lookup.h>
 #include <asm/cache.h>
 #include <asm/kernel-pgtable.h>
 #include <asm/kexec.h>
@@ -294,6 +295,8 @@ SECTIONS
 		__mmuoff_data_end = .;
 	}
 
+	ORC_UNWIND_TABLE
+
 	PECOFF_EDATA_PADDING
 	__pecoff_data_rawsize = ABSOLUTE(. - __initdata_begin);
 	_edata = .;
diff --git a/include/linux/objtool.h b/include/linux/objtool.h
index dcbd365944f6..c980522190f7 100644
--- a/include/linux/objtool.h
+++ b/include/linux/objtool.h
@@ -31,7 +31,9 @@
 
 #ifdef CONFIG_OBJTOOL
 
+#ifndef CONFIG_ARM64
 #include <asm/asm.h>
+#endif
 
 #ifndef __ASSEMBLY__
 
diff --git a/scripts/Makefile b/scripts/Makefile
index 1575af84d557..df3e4d90f195 100644
--- a/scripts/Makefile
+++ b/scripts/Makefile
@@ -23,8 +23,10 @@ HOSTLDLIBS_sign-file = $(shell $(HOSTPKG_CONFIG) --libs libcrypto 2> /dev/null |
 ifdef CONFIG_UNWINDER_ORC
 ifeq ($(ARCH),x86_64)
 ARCH := x86
-endif
 HOSTCFLAGS_sorttable.o += -I$(srctree)/tools/arch/x86/include
+else
+HOSTCFLAGS_sorttable.o += -I$(srctree)/tools/arch/$(ARCH)/include
+endif
 HOSTCFLAGS_sorttable.o += -DUNWINDER_ORC_ENABLED
 endif
 
diff --git a/scripts/Makefile.lib b/scripts/Makefile.lib
index 3aa384cec76b..d364871a1046 100644
--- a/scripts/Makefile.lib
+++ b/scripts/Makefile.lib
@@ -252,6 +252,13 @@ ifdef CONFIG_OBJTOOL
 
 objtool := $(objtree)/tools/objtool/objtool
 
+ifdef CONFIG_FRAME_POINTER_VALIDATION
+
+objtool-args-$(CONFIG_STACK_VALIDATION)			+= --stackval
+objtool-args-$(CONFIG_UNWINDER_ORC)			+= --orc
+
+else
+
 objtool-args-$(CONFIG_HAVE_JUMP_LABEL_HACK)		+= --hacks=jump_label
 objtool-args-$(CONFIG_HAVE_NOINSTR_HACK)		+= --hacks=noinstr
 objtool-args-$(CONFIG_X86_KERNEL_IBT)			+= --ibt
@@ -265,6 +272,8 @@ objtool-args-$(CONFIG_HAVE_STATIC_CALL_INLINE)		+= --static-call
 objtool-args-$(CONFIG_HAVE_UACCESS_VALIDATION)		+= --uaccess
 objtool-args-$(CONFIG_GCOV_KERNEL)			+= --no-unreachable
 
+endif
+
 objtool-args = $(objtool-args-y)					\
 	$(if $(delay-objtool), --link)					\
 	$(if $(part-of-module), --module)
diff --git a/tools/include/linux/objtool.h b/tools/include/linux/objtool.h
index dcbd365944f6..c980522190f7 100644
--- a/tools/include/linux/objtool.h
+++ b/tools/include/linux/objtool.h
@@ -31,7 +31,9 @@
 
 #ifdef CONFIG_OBJTOOL
 
+#ifndef CONFIG_ARM64
 #include <asm/asm.h>
+#endif
 
 #ifndef __ASSEMBLY__
 
-- 
2.25.1

