Return-Path: <live-patching+bounces-1572-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B0CB5AEAB53
	for <lists+live-patching@lfdr.de>; Fri, 27 Jun 2025 02:03:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D57824A2DFC
	for <lists+live-patching@lfdr.de>; Fri, 27 Jun 2025 00:03:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C2B8285078;
	Thu, 26 Jun 2025 23:56:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="I8JkOOXO"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14B3528504E;
	Thu, 26 Jun 2025 23:56:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750982201; cv=none; b=qFOv4T9mApOzon3G81DFTAzUMigIQGyWQ0RgD/UsjVnPN4BXztBdIpj+HPp0Z7b6lzpohzl+bw/xc5guTtr3CjgeW2HUza10LMlmzQV38KZrkjqMCNMN6jTWdSwEMFrVVhQT5o6jRng5STOALuXfVQYdAhlNyUQ7llvrSkiZCNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750982201; c=relaxed/simple;
	bh=cDSDfPuFviJZI1Tb44QI/RSgrjC4wn64JVLGOdgLNnQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t7q8WynlwaeUrhE6D0aSJnmbqHkrO6c3qVmzrDdjQ4fSIh9ocjBpQaNLItuS6ceieODqB3RD0dF/9t8a9a53mDcspX771QV5lMY73sgiJM+rovp+VZTfrkgD/BQJ5O2JgY+fvXMH6HeGUyXVG5qIAGfcnfNiaIax28mA1G7GkI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=I8JkOOXO; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 614ACC4CEF1;
	Thu, 26 Jun 2025 23:56:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750982201;
	bh=cDSDfPuFviJZI1Tb44QI/RSgrjC4wn64JVLGOdgLNnQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I8JkOOXOEsBVgbhrpHwfSzQxNn6mtCytNelvI2G8RNCxWEEEPkK739NslK7NbYE6/
	 2dud3RmW9U0M+GTkzerMx4paG2zbFrFsdHEGLDUxBIVclkPt/YQQqloDnTfPJTMj8T
	 ugRabkl+S4Y8eCVCQgB/qnqwIzKBbtXDf1tA0IrW0l+fslwEAXhjvLAeYep79+qEkX
	 zaP+Yz7DtdMIMB8yKxrqohlMDwtRWOkiRZ5jHDBcPDyUT0I1mDNBk0Qlt0i/qVK9tK
	 GpuNWAfU1hu4yF/MMiqapE+YnRnmOF7kTMz0hd66M1lxa+RUAmkrfSx13L5M0VR8wt
	 PbdsA0UPS83vA==
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
	Masahiro Yamada <masahiroy@kernel.org>
Subject: [PATCH v3 42/64] kbuild,x86: Fix special section module permissions
Date: Thu, 26 Jun 2025 16:55:29 -0700
Message-ID: <cf1cfb9042005be7bf0a1c3f2bdbeebc769e3ee4.1750980517.git.jpoimboe@kernel.org>
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

An upcoming patch will add the SHF_MERGE flag to x86 __jump_table and
__bug_table so their entry sizes can be defined in inline asm.

However, those sections have SHF_WRITE, which the Clang linker (lld)
explicitly forbids combining with SHF_MERGE.

Those sections are modified at runtime and must remain writable.  While
SHF_WRITE is ignored by vmlinux, it's still needed for modules.

To work around the linker interference, remove SHF_WRITE during
compilation and restore it after linking the module.

Cc: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 arch/Kconfig                      |  3 +++
 arch/x86/Kconfig                  |  1 +
 arch/x86/include/asm/bug.h        |  4 ++--
 arch/x86/include/asm/jump_label.h |  2 +-
 scripts/Makefile.modfinal         | 19 ++++++++++++++-----
 5 files changed, 21 insertions(+), 8 deletions(-)

diff --git a/arch/Kconfig b/arch/Kconfig
index a3308a220f86..350ea5df5e8d 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -1314,6 +1314,9 @@ config HAVE_NOINSTR_HACK
 config HAVE_NOINSTR_VALIDATION
 	bool
 
+config NEED_MODULE_PERMISSIONS_FIX
+	bool
+
 config HAVE_UACCESS_VALIDATION
 	bool
 	select OBJTOOL
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 71019b3b54ea..62faa62b5959 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -310,6 +310,7 @@ config X86
 	select HOTPLUG_SPLIT_STARTUP		if SMP && X86_32
 	select IRQ_FORCED_THREADING
 	select LOCK_MM_AND_FIND_VMA
+	select NEED_MODULE_PERMISSIONS_FIX
 	select NEED_PER_CPU_EMBED_FIRST_CHUNK
 	select NEED_PER_CPU_PAGE_FIRST_CHUNK
 	select NEED_SG_DMA_LENGTH
diff --git a/arch/x86/include/asm/bug.h b/arch/x86/include/asm/bug.h
index 8593976b32cb..59e155ee3c76 100644
--- a/arch/x86/include/asm/bug.h
+++ b/arch/x86/include/asm/bug.h
@@ -42,7 +42,7 @@
 #define _BUG_FLAGS(cond_str, ins, flags, extra)				\
 do {									\
 	asm_inline volatile("1:\t" ins "\n"				\
-		     ".pushsection __bug_table,\"aw\"\n"		\
+		     ".pushsection __bug_table,\"a\"\n"			\
 		     "2:\t" __BUG_REL(1b) "\t# bug_entry::bug_addr\n"	\
 		     "\t"  __BUG_REL(%c0) "\t# bug_entry::file\n"	\
 		     "\t.word %c1"        "\t# bug_entry::line\n"	\
@@ -60,7 +60,7 @@ do {									\
 #define _BUG_FLAGS(cond_str, ins, flags, extra)				\
 do {									\
 	asm_inline volatile("1:\t" ins "\n"				\
-		     ".pushsection __bug_table,\"aw\"\n"		\
+		     ".pushsection __bug_table,\"a\"\n"			\
 		     "2:\t" __BUG_REL(1b) "\t# bug_entry::bug_addr\n"	\
 		     "\t.word %c0"        "\t# bug_entry::flags\n"	\
 		     "\t.org 2b+%c1\n"					\
diff --git a/arch/x86/include/asm/jump_label.h b/arch/x86/include/asm/jump_label.h
index 61dd1dee7812..cd21554b3675 100644
--- a/arch/x86/include/asm/jump_label.h
+++ b/arch/x86/include/asm/jump_label.h
@@ -13,7 +13,7 @@
 #include <linux/types.h>
 
 #define JUMP_TABLE_ENTRY(key, label)			\
-	".pushsection __jump_table,  \"aw\" \n\t"	\
+	".pushsection __jump_table,  \"a\"\n\t"		\
 	_ASM_ALIGN "\n\t"				\
 	".long 1b - . \n\t"				\
 	".long " label " - . \n\t"			\
diff --git a/scripts/Makefile.modfinal b/scripts/Makefile.modfinal
index 542ba462ed3e..7a888e1ff70f 100644
--- a/scripts/Makefile.modfinal
+++ b/scripts/Makefile.modfinal
@@ -28,12 +28,24 @@ ccflags-remove-y := $(CC_FLAGS_CFI)
 .module-common.o: $(srctree)/scripts/module-common.c FORCE
 	$(call if_changed_rule,cc_o_c)
 
+ifdef CONFIG_NEED_MODULE_PERMISSIONS_FIX
+cmd_fix_mod_permissions =						\
+	$(OBJCOPY) --set-section-flags __jump_table=alloc,data		\
+		   --set-section-flags __bug_table=alloc,data $@	\
+		   --set-section-flags .static_call_sites=alloc,data $@
+endif
+
 quiet_cmd_ld_ko_o = LD [M]  $@
       cmd_ld_ko_o =							\
 	$(LD) -r $(KBUILD_LDFLAGS)					\
 		$(KBUILD_LDFLAGS_MODULE) $(LDFLAGS_MODULE)		\
 		-T $(objtree)/scripts/module.lds -o $@ $(filter %.o, $^)
 
+define rule_ld_ko_o
+	$(call cmd_and_savecmd,ld_ko_o)
+	$(call cmd,fix_mod_permissions)
+endef
+
 quiet_cmd_btf_ko = BTF [M] $@
       cmd_btf_ko = 							\
 	if [ ! -f $(objtree)/vmlinux ]; then				\
@@ -46,14 +58,11 @@ quiet_cmd_btf_ko = BTF [M] $@
 # Same as newer-prereqs, but allows to exclude specified extra dependencies
 newer_prereqs_except = $(filter-out $(PHONY) $(1),$?)
 
-# Same as if_changed, but allows to exclude specified extra dependencies
-if_changed_except = $(if $(call newer_prereqs_except,$(2))$(cmd-check),      \
-	$(cmd);                                                              \
-	printf '%s\n' 'savedcmd_$@ := $(make-cmd)' > $(dot-target).cmd, @:)
+if_changed_rule_except = $(if $(call newer_prereqs_except,$(2))$(cmd-check),$(rule_$(1)),@:)
 
 # Re-generate module BTFs if either module's .ko or vmlinux changed
 %.ko: %.o %.mod.o .module-common.o $(objtree)/scripts/module.lds $(and $(CONFIG_DEBUG_INFO_BTF_MODULES),$(KBUILD_BUILTIN),$(objtree)/vmlinux) FORCE
-	+$(call if_changed_except,ld_ko_o,$(objtree)/vmlinux)
+	+$(call if_changed_rule_except,ld_ko_o,$(objtree)/vmlinux)
 ifdef CONFIG_DEBUG_INFO_BTF_MODULES
 	+$(if $(newer-prereqs),$(call cmd,btf_ko))
 endif
-- 
2.49.0


