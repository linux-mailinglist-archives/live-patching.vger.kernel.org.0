Return-Path: <live-patching+bounces-1492-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 10ED8ACFA6E
	for <lists+live-patching@lfdr.de>; Fri,  6 Jun 2025 02:38:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6CE143AF605
	for <lists+live-patching@lfdr.de>; Fri,  6 Jun 2025 00:37:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B2DA8F4A;
	Fri,  6 Jun 2025 00:38:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QkHwpp7U"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EEC1A41;
	Fri,  6 Jun 2025 00:38:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749170282; cv=none; b=DUhJDHxpkoK75K9gpauihuFhIgZUVKFpQBA2JwPSorpBxzErIqSmdW9uYuwKtKh0V/dcMFbcTHh/jjwfacC/2IccZVMCE3LSzqW7EowFYT2odivPAhkqSGgi4TIGPfew/kO0QD5oXrRI6zY29AU0rd4x3e9kgT4vS20KgGJDABc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749170282; c=relaxed/simple;
	bh=B/dxso+ZqVxyZ9L1DIu1f3mUQg5Khl1LHdcLnurBQE8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=T+4Bv3UQ2nENeUL+xGsPvem90XjHbjzAoLpzgvtQgW4FBx9+mlKrTHaivtCoteGi9d/5Jo3ql7Kckzn3x4AS5cgfo51+XrUT6OCSlq6ETEAnO7uC27ZtB0iTMC5nIQwzVAjzTyvzjYsWnDuHKr2GB4cPmc1jn783JFItdOCfEx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QkHwpp7U; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 978A1C4CEE7;
	Fri,  6 Jun 2025 00:38:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749170281;
	bh=B/dxso+ZqVxyZ9L1DIu1f3mUQg5Khl1LHdcLnurBQE8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QkHwpp7UsfkA6/Z1jThFJru47Fzv9IFI38HaIN+mfkCqYYummTVtFnGR5P3KTobdl
	 NsK0kAVrBt8Mq2NtNvl4EjfFvpXDKpc5uGgbj1jCWbcVKaATWH3NxkOFIVxrMdb3j7
	 WH/eiAYcm4GR2LZDpytBwTrkJycBJv4yEfJxNaTh3AzZX/OTXBm9x+oQctFNyO8n6P
	 cMtPoypN4WSk4Stah3oZSJjEseh5pQOCfEtUevxsMfUBrMkSmCGGbpxbxcdV/4SZK4
	 msKP551IJTwOlGHaEwaguReM/7j6UuOxNhGHpZPDPSdB7r5sQRysdsGlJqRHU2nM50
	 PBqxqagam1iXg==
Date: Thu, 5 Jun 2025 17:37:58 -0700
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Joe Lawrence <joe.lawrence@redhat.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, 
	Petr Mladek <pmladek@suse.com>, Miroslav Benes <mbenes@suse.cz>, live-patching@vger.kernel.org, 
	Song Liu <song@kernel.org>, laokz <laokz@foxmail.com>, Jiri Kosina <jikos@kernel.org>, 
	Marcos Paulo de Souza <mpdesouza@suse.com>, Weinan Liu <wnliu@google.com>, 
	Fazla Mehrab <a.mehrab@bytedance.com>, Chen Zhongjin <chenzhongjin@huawei.com>, 
	Puranjay Mohan <puranjay@kernel.org>
Subject: Re: [PATCH v2 49/62] kbuild,objtool: Defer objtool validation step
 for CONFIG_LIVEPATCH
Message-ID: <2i7cje4wsmbwa6qykuni3tiihzbkac2db4etcs5a5gjbelkqid@2hcjfnxqghnz>
References: <cover.1746821544.git.jpoimboe@kernel.org>
 <0a12cca631dd6f4c55015e224acefb641b3824ce.1746821544.git.jpoimboe@kernel.org>
 <88a28ee7-ec83-4925-9cae-085b0dcc78fe@redhat.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <88a28ee7-ec83-4925-9cae-085b0dcc78fe@redhat.com>

On Wed, May 28, 2025 at 10:45:22AM -0400, Joe Lawrence wrote:
> > -	if is_enabled CONFIG_LTO_CLANG || is_enabled CONFIG_X86_KERNEL_IBT; then
> > +	if is_enabled CONFIG_LTO_CLANG || is_enabled CONFIG_X86_KERNEL_IBT ||
> > +	   is_enabled CONFIG_LIVEPATCH; then
> >  		# Use vmlinux.o instead of performing the slow LTO link again.
> >  		objs=vmlinux.o
> >  		libs=
> 
> At this commit, I'm getting the following linker error on ppc64le:
> 
> ld -EL -m elf64lppc -z noexecstack --no-warn-rwx-segments -pie -z notext
> --build-id=sha1 -X --orphan-handling=error
> --script=./arch/powerpc/kernel/vmlinux.lds -o .tmp_vmlinux1
> --whole-archive vmlinux.o .vmlinux.export.o init/version-timestamp.o
> --no-whole-archive --start-group --end-group .tmp_vmlinux0.kallsyms.o
> arch/powerpc/tools/vmlinux.arch.o
> 
> vmlinux.o:(__ftr_alt_97+0x20): relocation truncated to fit:
> R_PPC64_REL14 against `.text'+4b54
> vmlinux.o:(__ftr_alt_97+0x270): relocation truncated to fit:
> R_PPC64_REL14 against `.text'+173ecc

Looks like objtool is causing the the __ftr_alt_* sections to get placed
far away from .text somehow.

I guess objtool-on-vmlinux isn't quite ready for primetime on powerpc.
Though my next TODO is to get all this working there.

Until then, here's the fix:

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 996d59e59e5d..23269e8ee906 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -265,6 +265,7 @@ config X86
 	select HAVE_FUNCTION_ERROR_INJECTION
 	select HAVE_KRETPROBES
 	select HAVE_RETHOOK
+	select HAVE_KLP_BUILD			if X86_64
 	select HAVE_LIVEPATCH			if X86_64
 	select HAVE_MIXED_BREAKPOINTS_REGS
 	select HAVE_MOD_ARCH_SPECIFIC
diff --git a/kernel/livepatch/Kconfig b/kernel/livepatch/Kconfig
index 53d51ed619a3..4c0a9c18d0b2 100644
--- a/kernel/livepatch/Kconfig
+++ b/kernel/livepatch/Kconfig
@@ -18,3 +18,15 @@ config LIVEPATCH
 	  module uses the interface provided by this option to register
 	  a patch, causing calls to patched functions to be redirected
 	  to new function code contained in the patch module.
+
+config HAVE_KLP_BUILD
+	bool
+	help
+	  Arch supports klp-build
+
+config KLP_BUILD
+	def_bool y
+	depends on LIVEPATCH && HAVE_KLP_BUILD
+	select OBJTOOL
+	help
+	  Enable klp-build support
diff --git a/scripts/Makefile.lib b/scripts/Makefile.lib
index a68390ff5cd9..d9426fd4ab33 100644
--- a/scripts/Makefile.lib
+++ b/scripts/Makefile.lib
@@ -278,7 +278,7 @@ objtool-args = $(objtool-args-y)					\
 	$(if $(delay-objtool), --link)					\
 	$(if $(part-of-module), --module)
 
-delay-objtool := $(or $(CONFIG_LTO_CLANG),$(CONFIG_X86_KERNEL_IBT),$(CONFIG_LIVEPATCH))
+delay-objtool := $(or $(CONFIG_LTO_CLANG),$(CONFIG_X86_KERNEL_IBT),$(CONFIG_KLP_BUILD))
 
 cmd_objtool = $(if $(objtool-enabled), ; $(objtool) $(objtool-args) $@)
 cmd_gen_objtooldep = $(if $(objtool-enabled), { echo ; echo '$@: $$(wildcard $(objtool))' ; } >> $(dot-target).cmd)
diff --git a/scripts/link-vmlinux.sh b/scripts/link-vmlinux.sh
index acffa3c935f2..59f875236292 100755
--- a/scripts/link-vmlinux.sh
+++ b/scripts/link-vmlinux.sh
@@ -61,7 +61,7 @@ vmlinux_link()
 	shift
 
 	if is_enabled CONFIG_LTO_CLANG || is_enabled CONFIG_X86_KERNEL_IBT ||
-	   is_enabled CONFIG_LIVEPATCH; then
+	   is_enabled CONFIG_KLP_BUILD; then
 		# Use vmlinux.o instead of performing the slow LTO link again.
 		objs=vmlinux.o
 		libs=

