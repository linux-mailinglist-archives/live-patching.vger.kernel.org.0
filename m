Return-Path: <live-patching+bounces-1607-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7C455AEBE7D
	for <lists+live-patching@lfdr.de>; Fri, 27 Jun 2025 19:34:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D81AB645FBD
	for <lists+live-patching@lfdr.de>; Fri, 27 Jun 2025 17:33:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD9572EA742;
	Fri, 27 Jun 2025 17:34:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Rd86oQeu"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93E6529898B;
	Fri, 27 Jun 2025 17:34:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751045658; cv=none; b=R03m+7O4qLLH51UWmbof/RyUrqVsFJ/J7r0jn3vqcf3qEqrIO2QmtzyCTTcFGy1e5dWFGqwNaHkvCAGQSrkeREeZn1CW4/woLAqVQgOMbRJio8aDSOCCq/StRN0vF4mDrJoTJlCJh6L5yoswvelM5iSg3AeEkm/qvrRqQyxMztc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751045658; c=relaxed/simple;
	bh=scIUg8oZn6v9KjoDf9+/e3ggrQ+szZUhAp6+utGEK7o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HmTMYAYQgaf2h4mUZrMpQoY7qXEbi6K2QY2Glfkci5Tct4ytdAS+NqgKPRwESET6cy7vx00MZPfbgJmS2qp8sQfDUWElWZw8C+tZ8KWZMlemRqmSjRHddwcmCBU7x8hZaq0JZVJeC+qZ4RhG8VsNLb4UcjOp7nCIguaMr/4pqzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Rd86oQeu; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAA72C4CEE3;
	Fri, 27 Jun 2025 17:34:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751045658;
	bh=scIUg8oZn6v9KjoDf9+/e3ggrQ+szZUhAp6+utGEK7o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Rd86oQeuOpOZOWgaBJlSjcHu4r8b+IQwmbPHDdf4E69tv5Ng3BRt95OplczO9kdT0
	 0Cc1FbOSqU7WkGNf0kz4mAGo5LH0zKz6w4SMwvzXgTrVTAyt6OBHmZdFnGdBKInWs3
	 wYuwktQeiuFqC+04Z39xbcVJcUwiR63TirMYygsBO4k/I66MyEtDvSrL7Ua1PRFymg
	 zDgHn1dBWv3OP8WywLcI8rIn8R2nMEI9xSLj0x1ngEahLofw1qenciTuAGZO4urSyF
	 TeQljAziqqpsiAS4Wfn2A/NjXLCE1dRh+DWiR3KearDBAZCfKFCcxI4c3rA4XxQBYv
	 TM1ANHkK6Y3cA==
Date: Fri, 27 Jun 2025 10:34:15 -0700
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, 
	Petr Mladek <pmladek@suse.com>, Miroslav Benes <mbenes@suse.cz>, 
	Joe Lawrence <joe.lawrence@redhat.com>, live-patching@vger.kernel.org, Song Liu <song@kernel.org>, 
	laokz <laokz@foxmail.com>, Jiri Kosina <jikos@kernel.org>, 
	Marcos Paulo de Souza <mpdesouza@suse.com>, Weinan Liu <wnliu@google.com>, 
	Fazla Mehrab <a.mehrab@bytedance.com>, Chen Zhongjin <chenzhongjin@huawei.com>, 
	Puranjay Mohan <puranjay@kernel.org>, Dylan Hatch <dylanbhatch@google.com>, 
	Masahiro Yamada <masahiroy@kernel.org>
Subject: Re: [PATCH v3 42/64] kbuild,x86: Fix special section module
 permissions
Message-ID: <4ezl3egjv36fjkxkkswcianc5cg7ui6jpqw56e4ohlwipmuxai@kvgemh72rmga>
References: <cover.1750980516.git.jpoimboe@kernel.org>
 <cf1cfb9042005be7bf0a1c3f2bdbeebc769e3ee4.1750980517.git.jpoimboe@kernel.org>
 <20250627105328.GZ1613200@noisy.programming.kicks-ass.net>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250627105328.GZ1613200@noisy.programming.kicks-ass.net>

On Fri, Jun 27, 2025 at 12:53:28PM +0200, Peter Zijlstra wrote:
> On Thu, Jun 26, 2025 at 04:55:29PM -0700, Josh Poimboeuf wrote:
> > An upcoming patch will add the SHF_MERGE flag to x86 __jump_table and
> > __bug_table so their entry sizes can be defined in inline asm.
> > 
> > However, those sections have SHF_WRITE, which the Clang linker (lld)
> > explicitly forbids combining with SHF_MERGE.
> > 
> > Those sections are modified at runtime and must remain writable.  While
> > SHF_WRITE is ignored by vmlinux, it's still needed for modules.
> > 
> > To work around the linker interference, remove SHF_WRITE during
> > compilation and restore it after linking the module.
> 
> This is vile... but I'm not sure I have a better solution.
> 
> Eventually we should get the toolchains fixed, but we can't very well
> mandate clang-21+ to build x86 just yet.

Yeah, I really hate this too.  I really tried to find something better,
including mucking with the linker script, but this was unfortunately the
only thing that worked.

Though, looking at it again, I realize we can localize the pain to Clang
(and the makefile) by leaving the code untouched and instead strip
SHF_WRITE before the link and re-add it afterwards.  Then we can tie
this horrible hack to specific Clang versions when it gets fixed.

Something like so:

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
index 71019b3b54ea..0cac13c03a90 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -310,6 +310,7 @@ config X86
 	select HOTPLUG_SPLIT_STARTUP		if SMP && X86_32
 	select IRQ_FORCED_THREADING
 	select LOCK_MM_AND_FIND_VMA
+	select NEED_MODULE_PERMISSIONS_FIX	if LD_IS_LLD
 	select NEED_PER_CPU_EMBED_FIRST_CHUNK
 	select NEED_PER_CPU_PAGE_FIRST_CHUNK
 	select NEED_SG_DMA_LENGTH
diff --git a/scripts/Makefile.modfinal b/scripts/Makefile.modfinal
index 542ba462ed3e..cbc3213427ba 100644
--- a/scripts/Makefile.modfinal
+++ b/scripts/Makefile.modfinal
@@ -28,12 +28,37 @@ ccflags-remove-y := $(CC_FLAGS_CFI)
 .module-common.o: $(srctree)/scripts/module-common.c FORCE
 	$(call if_changed_rule,cc_o_c)
 
+
+ifdef CONFIG_NEED_MODULE_PERMISSIONS_FIX
+
+# The LLVM linker forbids SHF_MERGE+SHF_WRITE.  Hack around that by
+# temporarily removing SHF_WRITE from affected sections before linking.
+
+cmd_fix_mod_permissions_pre_link =					\
+	$(OBJCOPY) --set-section-flags __jump_table=alloc,readonly	\
+		   --set-section-flags __bug_table=alloc,readonly $@	\
+		   --set-section-flags .static_call_sites=alloc,readonly $@
+
+cmd_fix_mod_permissions_post_link =					\
+	$(OBJCOPY) --set-section-flags __jump_table=alloc,data		\
+		   --set-section-flags __bug_table=alloc,data $@	\
+		   --set-section-flags .static_call_sites=alloc,data $@
+
+endif # CONFIG_NEED_MODULE_PERMISSIONS_FIX
+
+
 quiet_cmd_ld_ko_o = LD [M]  $@
       cmd_ld_ko_o =							\
 	$(LD) -r $(KBUILD_LDFLAGS)					\
 		$(KBUILD_LDFLAGS_MODULE) $(LDFLAGS_MODULE)		\
 		-T $(objtree)/scripts/module.lds -o $@ $(filter %.o, $^)
 
+define rule_ld_ko_o
+	$(call cmd,fix_mod_permissions_pre_link)
+	$(call cmd_and_savecmd,ld_ko_o)
+	$(call cmd,fix_mod_permissions_post_link)
+endef
+
 quiet_cmd_btf_ko = BTF [M] $@
       cmd_btf_ko = 							\
 	if [ ! -f $(objtree)/vmlinux ]; then				\
@@ -46,14 +71,11 @@ quiet_cmd_btf_ko = BTF [M] $@
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

