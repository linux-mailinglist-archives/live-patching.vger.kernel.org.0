Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 912884F8913
	for <lists+live-patching@lfdr.de>; Fri,  8 Apr 2022 00:14:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230123AbiDGUj7 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 7 Apr 2022 16:39:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229900AbiDGUjo (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 7 Apr 2022 16:39:44 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 716EE345D4E;
        Thu,  7 Apr 2022 13:26:03 -0700 (PDT)
Received: from x64host.home (unknown [47.189.24.195])
        by linux.microsoft.com (Postfix) with ESMTPSA id 798F420B9CF0;
        Thu,  7 Apr 2022 13:26:02 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 798F420B9CF0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1649363163;
        bh=wbp3KQRzbL8wBuPZAF+JGlo4GHESFi/Po72T2KLLghc=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=R25TWtc3BkaKmcHdSg95pqX7kI1wwu5ptGUfUsniDru1WvlWHXVlclaqU2JEnbfzf
         w61K70ILGt2p/F+/E9xjBa8ZTbPtw8HapvDAXXqegLfOuyVTrYDlcDTboQqXn4DvF9
         W6BBgdS0l6JCAooirPH5dmPDvzUsF1HitaGFsgd0=
From:   madvenka@linux.microsoft.com
To:     mark.rutland@arm.com, broonie@kernel.org, jpoimboe@redhat.com,
        ardb@kernel.org, nobuta.keiya@fujitsu.com,
        sjitindarsingh@gmail.com, catalin.marinas@arm.com, will@kernel.org,
        jmorris@namei.org, linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        madvenka@linux.microsoft.com
Subject: [RFC PATCH v1 3/9] dwarf: Build the kernel with DWARF information
Date:   Thu,  7 Apr 2022 15:25:12 -0500
Message-Id: <20220407202518.19780-4-madvenka@linux.microsoft.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220407202518.19780-1-madvenka@linux.microsoft.com>
References: <95691cae4f4504f33d0fc9075541b1e7deefe96f>
 <20220407202518.19780-1-madvenka@linux.microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-19.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>

Define CONFIG_DWARF_FP - to include DWARF based FP validation code.
Define CONFIG_STACK_VALIDATION - to enable DWARF based FP validation.

When these configs are enabled, invoke objtool on relocatable files during
the kernel build with the following command:

	objtool dwarf generate <object-file>

Objtool creates the following sections in each object file:

.dwarf_rules	Array of DWARF rules
.dwarf_pcs	Array of PCs, one-to-one with rules

In the future, the kernel can use these sections to find the rules for a
given instruction address. The unwinder can then compute the FP at an
instruction address and validate the actual FP with that.

NOTE: CONFIG_STACK_VALIDATION needs to be turned on here. Otherwise, objtool
will not be invoked during the kernel build process. The actual stack
validation code will be added separately. This is harmless.

Signed-off-by: Madhavan T. Venkataraman <madvenka@linux.microsoft.com>
---
 arch/Kconfig                    |  4 +++-
 arch/arm64/Kconfig              |  2 ++
 arch/arm64/Kconfig.debug        |  5 +++++
 arch/arm64/configs/defconfig    |  1 +
 arch/arm64/kernel/vmlinux.lds.S | 22 ++++++++++++++++++++++
 scripts/Makefile.build          |  4 ++++
 scripts/link-vmlinux.sh         |  6 ++++++
 7 files changed, 43 insertions(+), 1 deletion(-)

diff --git a/arch/Kconfig b/arch/Kconfig
index d3c4ab249e9c..3b0d0db322b9 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -1016,7 +1016,9 @@ config HAVE_STACK_VALIDATION
 	bool
 	help
 	  Architecture supports the 'objtool check' host tool command, which
-	  performs compile-time stack metadata validation.
+	  performs compile-time stack metadata validation. Or, on architectures
+	  that use DWARF validated frame pointers, it supports the
+	  'objtool dwarf generate' host tool command.
 
 config HAVE_RELIABLE_STACKTRACE
 	bool
diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index c4207cf9bb17..c82a3a93297f 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -220,6 +220,8 @@ config ARM64
 	select SWIOTLB
 	select SYSCTL_EXCEPTION_TRACE
 	select THREAD_INFO_IN_TASK
+	select HAVE_STACK_VALIDATION	if DWARF_FP
+	select STACK_VALIDATION		if HAVE_STACK_VALIDATION
 	select HAVE_ARCH_USERFAULTFD_MINOR if USERFAULTFD
 	select TRACE_IRQFLAGS_SUPPORT
 	help
diff --git a/arch/arm64/Kconfig.debug b/arch/arm64/Kconfig.debug
index 265c4461031f..585967062a1c 100644
--- a/arch/arm64/Kconfig.debug
+++ b/arch/arm64/Kconfig.debug
@@ -20,4 +20,9 @@ config ARM64_RELOC_TEST
 	depends on m
 	tristate "Relocation testing module"
 
+config DWARF_FP
+	def_bool y
+	depends on FRAME_POINTER
+	depends on DEBUG_INFO_DWARF4
+
 source "drivers/hwtracing/coresight/Kconfig"
diff --git a/arch/arm64/configs/defconfig b/arch/arm64/configs/defconfig
index f2e2b9bdd702..a59c448f442a 100644
--- a/arch/arm64/configs/defconfig
+++ b/arch/arm64/configs/defconfig
@@ -1233,3 +1233,4 @@ CONFIG_DEBUG_KERNEL=y
 # CONFIG_DEBUG_PREEMPT is not set
 # CONFIG_FTRACE is not set
 CONFIG_MEMTEST=y
+CONFIG_DEBUG_INFO_DWARF4=y
diff --git a/arch/arm64/kernel/vmlinux.lds.S b/arch/arm64/kernel/vmlinux.lds.S
index 50bab186c49b..fb3b9970453b 100644
--- a/arch/arm64/kernel/vmlinux.lds.S
+++ b/arch/arm64/kernel/vmlinux.lds.S
@@ -122,6 +122,25 @@ jiffies = jiffies_64;
 #define TRAMP_TEXT
 #endif
 
+#ifdef CONFIG_DWARF_FP
+#define DWARF_RULES					\
+	. = ALIGN(8);					\
+	.dwarf_rules : {				\
+		__dwarf_rules_start = .;		\
+		KEEP(*(.dwarf_rules))			\
+		__dwarf_rules_end = .;			\
+	}
+
+#define DWARF_PCS					\
+	. = ALIGN(8);					\
+	__dwarf_pcs_start = .;				\
+	KEEP(*(.dwarf_pcs))				\
+	__dwarf_pcs_end = .;
+#else
+#define DWARF_RULES
+#define DWARF_PCS
+#endif
+
 /*
  * The size of the PE/COFF section that covers the kernel image, which
  * runs from _stext to _edata, must be a round multiple of the PE/COFF
@@ -239,6 +258,7 @@ SECTIONS
 		CON_INITCALL
 		INIT_RAM_FS
 		*(.init.altinstructions .init.bss)	/* from the EFI stub */
+		DWARF_PCS
 	}
 	.exit.data : {
 		EXIT_DATA
@@ -291,6 +311,8 @@ SECTIONS
 		__mmuoff_data_end = .;
 	}
 
+	DWARF_RULES
+
 	PECOFF_EDATA_PADDING
 	__pecoff_data_rawsize = ABSOLUTE(. - __initdata_begin);
 	_edata = .;
diff --git a/scripts/Makefile.build b/scripts/Makefile.build
index 78656b527fe5..5e8d89c64572 100644
--- a/scripts/Makefile.build
+++ b/scripts/Makefile.build
@@ -227,6 +227,9 @@ ifdef CONFIG_STACK_VALIDATION
 
 objtool := $(objtree)/tools/objtool/objtool
 
+ifdef CONFIG_DWARF_FP
+objtool_args = dwarf generate
+else
 objtool_args =								\
 	$(if $(CONFIG_UNWINDER_ORC),orc generate,check)			\
 	$(if $(part-of-module), --module)				\
@@ -235,6 +238,7 @@ objtool_args =								\
 	$(if $(CONFIG_RETPOLINE), --retpoline)				\
 	$(if $(CONFIG_X86_SMAP), --uaccess)				\
 	$(if $(CONFIG_FTRACE_MCOUNT_USE_OBJTOOL), --mcount)
+endif
 
 cmd_objtool = $(if $(objtool-enabled), ; $(objtool) $(objtool_args) $@)
 cmd_gen_objtooldep = $(if $(objtool-enabled), { echo ; echo '$@: $$(wildcard $(objtool))' ; } >> $(dot-target).cmd)
diff --git a/scripts/link-vmlinux.sh b/scripts/link-vmlinux.sh
index 5cdd9bc5c385..433e395f977b 100755
--- a/scripts/link-vmlinux.sh
+++ b/scripts/link-vmlinux.sh
@@ -104,6 +104,12 @@ objtool_link()
 	local objtoolcmd;
 	local objtoolopt;
 
+	if [ "${CONFIG_LTO_CLANG} ${CONFIG_DWARF_FP}" = "y y" ]
+	then
+		tools/objtool/objtool dwarf generate ${1}
+		return
+	fi
+
 	if [ "${CONFIG_LTO_CLANG} ${CONFIG_STACK_VALIDATION}" = "y y" ]; then
 		# Don't perform vmlinux validation unless explicitly requested,
 		# but run objtool on vmlinux.o now that we have an object file.
-- 
2.25.1

