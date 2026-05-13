Return-Path: <live-patching+bounces-2763-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 0HOGOlbyA2prBAIAu9opvQ
	(envelope-from <live-patching+bounces-2763-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Wed, 13 May 2026 05:39:02 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 4E6CC52CD62
	for <lists+live-patching@lfdr.de>; Wed, 13 May 2026 05:39:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 913A13109A00
	for <lists+live-patching@lfdr.de>; Wed, 13 May 2026 03:34:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 08EBC3A48C2;
	Wed, 13 May 2026 03:34:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZMwNtuUs"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D460A3998B2;
	Wed, 13 May 2026 03:34:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778643278; cv=none; b=bh48TOpnAkQKvB/v53jaWj53fGgLPdNkR84HmBemlml3wfVE+PUTSa+XyNp8NiK4DEdndBn5rFG+/7rN6ZslmTA0dv46CSrJKdoaYUto51tP9KQsNC+2Qy7GRNn1UM98y4+QHiFE63cWbQDvqBpa2EALNIxe3/AwcpeU20TJKZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778643278; c=relaxed/simple;
	bh=6qM6eS73y/2HGC/l7RWciS6d5w9G1tF/qeUGxjijkEE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H6Rkvfx7I2WHbVRCzQ1ab856YAppjBi+DzXUDDvWKIgXeGX8GWhtpkOX6K0Z1BXp/cA8/n3eoC2w14oKLj+SpbQY12OpdzgdEDHgqXJLF1sCO4CH2gcEAKd8qWZZjYhnq7Vj8i2mvmVAMGi+TACV1DahIDOvkYLGXF3Kz1JvxVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZMwNtuUs; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67B16C4AF0E;
	Wed, 13 May 2026 03:34:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778643276;
	bh=6qM6eS73y/2HGC/l7RWciS6d5w9G1tF/qeUGxjijkEE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZMwNtuUso1KmF3zovvyP98IAAheQGw5HYUfApTI9FkfqlQEPmOsu/B2SkcYXBcXdi
	 RuPi4hHEHz9ECpJJRlUzuCbIIBuIh2TYi7+hUzejgskeqL8abZ3yNnY8SjvvCAG65G
	 frbBT1pD1JuWcqPdEz4mp+Xpsy1LnHXnXdK2NNtUMwUTxoJ5XUyHDOmJNxJH/w7iNw
	 bDZD2CxdEKArrOJPU3e30Cl5cd+fYKhk0LlX5b40qGA/Hi8AM+ynQ572kUIMBJujGQ
	 EgOzyvtCU3pmQLgImOtnqoRhFJQ6Ni8QeH/uIrDMypcvHoBF/Yb3yctQp2KWU1KSLp
	 bAMIXincMPPIg==
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org,
	live-patching@vger.kernel.org,
	Peter Zijlstra <peterz@infradead.org>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	Song Liu <song@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	Mark Rutland <mark.rutland@arm.com>,
	Miroslav Benes <mbenes@suse.cz>,
	Petr Mladek <pmladek@suse.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Nicolas Schier <nsc@kernel.org>
Subject: [PATCH v3 09/21] kbuild: Only run objtool if there is at least one command
Date: Tue, 12 May 2026 20:33:43 -0700
Message-ID: <8699672b82fef17e73a5f2e5528478778dbdab31.1778642120.git.jpoimboe@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1778642120.git.jpoimboe@kernel.org>
References: <cover.1778642120.git.jpoimboe@kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4E6CC52CD62
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2763-lists,live-patching=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[14];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jpoimboe@kernel.org,live-patching@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Action: no action

Split the objtool args into commands and options, such that if no
commands have been enabled, objtool doesn't run.

This is in preparation for enabling objtool and klp-build for arm64.

Reviewed-by: Nathan Chancellor <nathan@kernel.org>
Reviewed-by: Nicolas Schier <nsc@kernel.org>
Tested-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 arch/x86/boot/startup/Makefile |  2 +-
 scripts/Makefile.build         |  4 +--
 scripts/Makefile.lib           | 52 ++++++++++++++++++----------------
 scripts/Makefile.vmlinux_o     | 15 ++++------
 4 files changed, 36 insertions(+), 37 deletions(-)

diff --git a/arch/x86/boot/startup/Makefile b/arch/x86/boot/startup/Makefile
index 5e499cfb29b5c..a08297829fc63 100644
--- a/arch/x86/boot/startup/Makefile
+++ b/arch/x86/boot/startup/Makefile
@@ -36,7 +36,7 @@ $(patsubst %.o,$(obj)/%.o,$(lib-y)): OBJECT_FILES_NON_STANDARD := y
 # relocations, even if other objtool actions are being deferred.
 #
 $(pi-objs): objtool-enabled	= 1
-$(pi-objs): objtool-args	= $(if $(delay-objtool),--dry-run,$(objtool-args-y)) --noabs
+$(pi-objs): objtool-args	= $(if $(delay-objtool),--dry-run,$(objtool-cmds-y) $(objtool-opts-y)) --noabs
 
 #
 # Confine the startup code by prefixing all symbols with __pi_ (for position
diff --git a/scripts/Makefile.build b/scripts/Makefile.build
index 3498d25b15e85..c4accfcd177d4 100644
--- a/scripts/Makefile.build
+++ b/scripts/Makefile.build
@@ -277,7 +277,7 @@ endif # CONFIG_FTRACE_MCOUNT_USE_RECORDMCOUNT
 is-standard-object = $(if $(filter-out y%, $(OBJECT_FILES_NON_STANDARD_$(target-stem).o)$(OBJECT_FILES_NON_STANDARD)n),$(is-kernel-object))
 
 ifdef CONFIG_OBJTOOL
-$(obj)/%.o: private objtool-enabled = $(if $(is-standard-object),$(if $(delay-objtool),$(is-single-obj-m),y))
+$(obj)/%.o: private objtool-enabled = $(and $(is-standard-object),$(objtool-cmds-y),$(if $(delay-objtool),$(is-single-obj-m),y))
 endif
 
 ifneq ($(findstring 1, $(KBUILD_EXTRA_WARN)),)
@@ -501,7 +501,7 @@ define rule_ld_multi_m
 	$(call cmd,gen_objtooldep)
 endef
 
-$(multi-obj-m): private objtool-enabled := $(delay-objtool)
+$(multi-obj-m): private objtool-enabled := $(if $(objtool-cmds-y),$(delay-objtool))
 $(multi-obj-m): private part-of-module := y
 $(multi-obj-m): %.o: %.mod FORCE
 	$(call if_changed_rule,ld_multi_m)
diff --git a/scripts/Makefile.lib b/scripts/Makefile.lib
index 7e216d82e9887..7f803796d20cf 100644
--- a/scripts/Makefile.lib
+++ b/scripts/Makefile.lib
@@ -183,30 +183,34 @@ ifdef CONFIG_OBJTOOL
 
 objtool := $(objtree)/tools/objtool/objtool
 
-objtool-args-$(CONFIG_HAVE_JUMP_LABEL_HACK)		+= --hacks=jump_label
-objtool-args-$(CONFIG_HAVE_NOINSTR_HACK)		+= --hacks=noinstr
-objtool-args-$(CONFIG_MITIGATION_CALL_DEPTH_TRACKING)	+= --hacks=skylake
-objtool-args-$(CONFIG_X86_KERNEL_IBT)			+= --ibt
-objtool-args-$(CONFIG_CALL_PADDING)			+= --prefix=$(CONFIG_FUNCTION_PADDING_BYTES)
-ifdef CONFIG_CALL_PADDING
-objtool-args-$(CONFIG_CFI)				+= --cfi
-objtool-args-$(CONFIG_FINEIBT)				+= --fineibt
-endif
-objtool-args-$(CONFIG_FTRACE_MCOUNT_USE_OBJTOOL)	+= --mcount
-ifdef CONFIG_FTRACE_MCOUNT_USE_OBJTOOL
-objtool-args-$(CONFIG_HAVE_OBJTOOL_NOP_MCOUNT)		+= --mnop
-endif
-objtool-args-$(CONFIG_UNWINDER_ORC)			+= --orc
-objtool-args-$(CONFIG_MITIGATION_RETPOLINE)		+= --retpoline
-objtool-args-$(CONFIG_MITIGATION_RETHUNK)		+= --rethunk
-objtool-args-$(CONFIG_MITIGATION_SLS)			+= --sls
-objtool-args-$(CONFIG_STACK_VALIDATION)			+= --stackval
-objtool-args-$(CONFIG_HAVE_STATIC_CALL_INLINE)		+= --static-call
-objtool-args-$(CONFIG_HAVE_UACCESS_VALIDATION)		+= --uaccess
-objtool-args-$(or $(CONFIG_GCOV_KERNEL),$(CONFIG_KCOV))	+= --no-unreachable
-objtool-args-$(CONFIG_OBJTOOL_WERROR)			+= --werror
+# objtool commands
+objtool-cmds-$(CONFIG_HAVE_JUMP_LABEL_HACK)		+= --hacks=jump_label
+objtool-cmds-$(CONFIG_HAVE_NOINSTR_HACK)		+= --hacks=noinstr
+objtool-cmds-$(CONFIG_MITIGATION_CALL_DEPTH_TRACKING)	+= --hacks=skylake
+objtool-cmds-$(CONFIG_X86_KERNEL_IBT)			+= --ibt
+objtool-cmds-$(CONFIG_CALL_PADDING)			+= --prefix=$(CONFIG_FUNCTION_PADDING_BYTES)
+objtool-cmds-$(CONFIG_FTRACE_MCOUNT_USE_OBJTOOL)	+= --mcount
+objtool-cmds-$(CONFIG_UNWINDER_ORC)			+= --orc
+objtool-cmds-$(CONFIG_MITIGATION_RETPOLINE)		+= --retpoline
+objtool-cmds-$(CONFIG_MITIGATION_RETHUNK)		+= --rethunk
+objtool-cmds-$(CONFIG_MITIGATION_SLS)			+= --sls
+objtool-cmds-$(CONFIG_STACK_VALIDATION)			+= --stackval
+objtool-cmds-$(CONFIG_HAVE_STATIC_CALL_INLINE)		+= --static-call
+objtool-cmds-$(CONFIG_HAVE_UACCESS_VALIDATION)		+= --uaccess
+objtool-cmds-y						+= $(OBJTOOL_ARGS)
 
-objtool-args = $(objtool-args-y)					\
+# objtool options
+ifdef CONFIG_CALL_PADDING
+objtool-opts-$(CONFIG_CFI)				+= --cfi
+objtool-opts-$(CONFIG_FINEIBT)				+= --fineibt
+endif
+ifdef CONFIG_FTRACE_MCOUNT_USE_OBJTOOL
+objtool-opts-$(CONFIG_HAVE_OBJTOOL_NOP_MCOUNT)		+= --mnop
+endif
+objtool-opts-$(or $(CONFIG_GCOV_KERNEL),$(CONFIG_KCOV))	+= --no-unreachable
+objtool-opts-$(CONFIG_OBJTOOL_WERROR)			+= --werror
+
+objtool-args = $(objtool-cmds-y) $(objtool-opts-y)			\
 	$(if $(delay-objtool), --link)					\
 	$(if $(part-of-module), --module)
 
@@ -215,7 +219,7 @@ delay-objtool := $(or $(CONFIG_LTO_CLANG),$(CONFIG_X86_KERNEL_IBT),$(CONFIG_KLP_
 cmd_objtool = $(if $(objtool-enabled), ; $(objtool) $(objtool-args) $@)
 cmd_gen_objtooldep = $(if $(objtool-enabled), { echo ; echo '$@: $$(wildcard $(objtool))' ; } >> $(dot-target).cmd)
 
-objtool-enabled := y
+objtool-enabled = $(if $(objtool-cmds-y),y)
 
 endif # CONFIG_OBJTOOL
 
diff --git a/scripts/Makefile.vmlinux_o b/scripts/Makefile.vmlinux_o
index 527352c222ff6..09af33203bd8d 100644
--- a/scripts/Makefile.vmlinux_o
+++ b/scripts/Makefile.vmlinux_o
@@ -36,18 +36,13 @@ endif
 # For !delay-objtool + CONFIG_NOINSTR_VALIDATION, it runs on both translation
 # units and vmlinux.o, with the latter only used for noinstr/unret validation.
 
-objtool-enabled := $(or $(delay-objtool),$(CONFIG_NOINSTR_VALIDATION))
-
-ifeq ($(delay-objtool),y)
-vmlinux-objtool-args-y					+= $(objtool-args-y)
-else
-vmlinux-objtool-args-$(CONFIG_OBJTOOL_WERROR)		+= --werror
+ifneq ($(delay-objtool),y)
+objtool-cmds-y					 =
+objtool-opts-y					+= --link
 endif
 
-vmlinux-objtool-args-$(CONFIG_NOINSTR_VALIDATION)	+= --noinstr \
-							   $(if $(or $(CONFIG_MITIGATION_UNRET_ENTRY),$(CONFIG_MITIGATION_SRSO)), --unret)
-
-objtool-args = $(vmlinux-objtool-args-y) --link
+objtool-cmds-$(CONFIG_NOINSTR_VALIDATION)	+= --noinstr \
+						   $(if $(or $(CONFIG_MITIGATION_UNRET_ENTRY),$(CONFIG_MITIGATION_SRSO)), --unret)
 
 # Link of vmlinux.o used for section mismatch analysis
 # ---------------------------------------------------------------------------
-- 
2.53.0


