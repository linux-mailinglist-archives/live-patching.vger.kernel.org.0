Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E11E531FBA
	for <lists+live-patching@lfdr.de>; Tue, 24 May 2022 02:18:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231915AbiEXARw (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 23 May 2022 20:17:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232034AbiEXARM (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 23 May 2022 20:17:12 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 75BF87CB76;
        Mon, 23 May 2022 17:17:04 -0700 (PDT)
Received: from x64host.home (unknown [47.189.24.195])
        by linux.microsoft.com (Postfix) with ESMTPSA id 8601F20B87F6;
        Mon, 23 May 2022 17:17:03 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 8601F20B87F6
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1653351424;
        bh=TQ/XlAh2pJ/fVzbjSjvKssRRUWTo6FGCftijB4Zl7Mo=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=jJGo7xvKQqkBA7IhJFiWZkUNsWh4P/aCvBW0LfJ1s5E++6pqNlCQIinQQufRHbJ/R
         JFKvvdos2IVRf5OiQTK3IWfUkwGAPd5kdrLoRUXUyQ7+38ETsMFFE5YASUA7Lj66H4
         z9tF0wuxsuTgupj5+HIRtvglb3vUj4imzq612COw=
From:   madvenka@linux.microsoft.com
To:     jpoimboe@redhat.com, peterz@infradead.org, chenzhongjin@huawei.com,
        mark.rutland@arm.com, broonie@kernel.org, nobuta.keiya@fujitsu.com,
        sjitindarsingh@gmail.com, catalin.marinas@arm.com, will@kernel.org,
        jamorris@linux.microsoft.com, linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        madvenka@linux.microsoft.com
Subject: [RFC PATCH v2 17/20] arm64: Build the kernel with ORC information
Date:   Mon, 23 May 2022 19:16:34 -0500
Message-Id: <20220524001637.1707472-18-madvenka@linux.microsoft.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220524001637.1707472-1-madvenka@linux.microsoft.com>
References: <e81e773678f88f7c2ff7480e2eb096973ec198db>
 <20220524001637.1707472-1-madvenka@linux.microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-19.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>

Define CONFIG_UNWINDER_ORC - to include ORC lookup code in the kernel.
Define CONFIG_FRAME_POINTER_VALIDATION - to enable ORC based FP validation.
Select CONFIG_HAVE_STACK_VALIDATION if CONFIG_FRAME_POINTER_VALIDATION is
       present.

Add code to scripts/Makefile.build to define objtool options to generate
ORC data for frame pointer validation.

When these configs are enabled, CONFIG_STACK_VALIDATION can be enabled.
When that is done, invoke objtool on relocatable files during the kernel
build with the following command:

	objtool fpv generate <object-file>

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

NOTE: CONFIG_STACK_VALIDATION needs to be turned on here. Otherwise, objtool
will not be invoked during the kernel build process. The actual stack
validation code will be added separately. This is harmless.

Signed-off-by: Madhavan T. Venkataraman <madvenka@linux.microsoft.com>
---
 arch/Kconfig                    |  4 +++-
 arch/arm64/Kconfig              |  2 ++
 arch/arm64/Kconfig.debug        | 21 +++++++++++++++++++++
 arch/arm64/include/asm/module.h | 10 +++++++++-
 arch/arm64/kernel/vmlinux.lds.S |  3 +++
 scripts/Makefile                |  4 +++-
 scripts/Makefile.build          |  4 ++++
 scripts/link-vmlinux.sh         |  7 +++++++
 8 files changed, 52 insertions(+), 3 deletions(-)

diff --git a/arch/Kconfig b/arch/Kconfig
index 29b0167c088b..16eb5ad1f83e 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -1032,7 +1032,9 @@ config HAVE_STACK_VALIDATION
 	bool
 	help
 	  Architecture supports the 'objtool check' host tool command, which
-	  performs compile-time stack metadata validation.
+	  performs compile-time stack metadata validation. Or, on architectures
+	  that use dynamic frame pointer validation, it supports the
+	  'objtool fpv generate' host tool command.
 
 config HAVE_RELIABLE_STACKTRACE
 	bool
diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 57c4c995965f..e6a7bfc85ff9 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -223,6 +223,8 @@ config ARM64
 	select SWIOTLB
 	select SYSCTL_EXCEPTION_TRACE
 	select THREAD_INFO_IN_TASK
+	select HAVE_STACK_VALIDATION	if FRAME_POINTER_VALIDATION
+	select STACK_VALIDATION		if HAVE_STACK_VALIDATION
 	select HAVE_ARCH_USERFAULTFD_MINOR if USERFAULTFD
 	select TRACE_IRQFLAGS_SUPPORT
 	help
diff --git a/arch/arm64/Kconfig.debug b/arch/arm64/Kconfig.debug
index 265c4461031f..37a7a90331d0 100644
--- a/arch/arm64/Kconfig.debug
+++ b/arch/arm64/Kconfig.debug
@@ -20,4 +20,25 @@ config ARM64_RELOC_TEST
 	depends on m
 	tristate "Relocation testing module"
 
+config UNWINDER_ORC
+	bool "ORC unwinder"
+	depends on FRAME_POINTER_VALIDATION
+	select HAVE_MOD_ARCH_SPECIFIC
+	help
+	  This option enables ORC (Oops Rewind Capability) for ARM64. This
+	  allows the unwinder to look up ORC data for an instruction address
+	  and compute the frame pointer at that address. The computed frame
+	  pointer is used to validate the actual frame pointer.
+
+config FRAME_POINTER_VALIDATION
+	bool "Dynamic Frame pointer validation"
+	depends on FRAME_POINTER
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
index 4e7fa2623896..a15cddf11224 100644
--- a/arch/arm64/include/asm/module.h
+++ b/arch/arm64/include/asm/module.h
@@ -6,6 +6,7 @@
 #define __ASM_MODULE_H
 
 #include <asm-generic/module.h>
+#include <asm/orc_types.h>
 
 #ifdef CONFIG_ARM64_MODULE_PLTS
 struct mod_plt_sec {
@@ -13,15 +14,22 @@ struct mod_plt_sec {
 	int			plt_num_entries;
 	int			plt_max_entries;
 };
+#endif
 
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
 
 u64 module_emit_plt_entry(struct module *mod, Elf64_Shdr *sechdrs,
 			  void *loc, const Elf64_Rela *rela,
diff --git a/arch/arm64/kernel/vmlinux.lds.S b/arch/arm64/kernel/vmlinux.lds.S
index edaf0faf766f..7a4fa5404541 100644
--- a/arch/arm64/kernel/vmlinux.lds.S
+++ b/arch/arm64/kernel/vmlinux.lds.S
@@ -61,6 +61,7 @@
 #define RUNTIME_DISCARD_EXIT
 
 #include <asm-generic/vmlinux.lds.h>
+#include <asm-generic/orc_lookup.h>
 #include <asm/cache.h>
 #include <asm/kernel-pgtable.h>
 #include <asm/kexec.h>
@@ -291,6 +292,8 @@ SECTIONS
 		__mmuoff_data_end = .;
 	}
 
+	ORC_UNWIND_TABLE
+
 	PECOFF_EDATA_PADDING
 	__pecoff_data_rawsize = ABSOLUTE(. - __initdata_begin);
 	_edata = .;
diff --git a/scripts/Makefile b/scripts/Makefile
index ce5aa9030b74..abcda21c1bb9 100644
--- a/scripts/Makefile
+++ b/scripts/Makefile
@@ -20,8 +20,10 @@ HOSTLDLIBS_sign-file = $(shell pkg-config --libs libcrypto 2> /dev/null || echo
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
 
diff --git a/scripts/Makefile.build b/scripts/Makefile.build
index 9717e6f6fb31..7d370b498a6b 100644
--- a/scripts/Makefile.build
+++ b/scripts/Makefile.build
@@ -226,6 +226,9 @@ ifdef CONFIG_STACK_VALIDATION
 
 objtool := $(objtree)/tools/objtool/objtool
 
+ifdef CONFIG_FRAME_POINTER_VALIDATION
+objtool_args = fpv generate
+else
 objtool_args =								\
 	$(if $(CONFIG_UNWINDER_ORC),orc generate,check)			\
 	$(if $(part-of-module), --module)				\
@@ -236,6 +239,7 @@ objtool_args =								\
 	$(if $(CONFIG_X86_SMAP), --uaccess)				\
 	$(if $(CONFIG_FTRACE_MCOUNT_USE_OBJTOOL), --mcount)		\
 	$(if $(CONFIG_SLS), --sls)
+endif
 
 cmd_objtool = $(if $(objtool-enabled), ; $(objtool) $(objtool_args) $@)
 cmd_gen_objtooldep = $(if $(objtool-enabled), { echo ; echo '$@: $$(wildcard $(objtool))' ; } >> $(dot-target).cmd)
diff --git a/scripts/link-vmlinux.sh b/scripts/link-vmlinux.sh
index 20f44504a644..ea0a85370e0f 100755
--- a/scripts/link-vmlinux.sh
+++ b/scripts/link-vmlinux.sh
@@ -108,6 +108,13 @@ objtool_link()
 	local objtoolcmd;
 	local objtoolopt;
 
+	if is_enabled CONFIG_STACK_VALIDATION && \
+	   is_enabled CONFIG_FRAME_POINTER_VALIDATION && \
+	   is_enabled CONFIG_LTO_CLANG; then
+		tools/objtool/objtool fpv generate ${1}
+		return
+	fi
+
 	if is_enabled CONFIG_STACK_VALIDATION && \
 	   ( is_enabled CONFIG_LTO_CLANG || is_enabled CONFIG_X86_KERNEL_IBT ); then
 
-- 
2.25.1

