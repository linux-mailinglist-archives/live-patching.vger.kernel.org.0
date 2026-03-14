Return-Path: <live-patching+bounces-2206-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id dSRcNa6vtGnOrwAAu9opvQ
	(envelope-from <live-patching+bounces-2206-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Sat, 14 Mar 2026 01:45:34 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id E2E6628B081
	for <lists+live-patching@lfdr.de>; Sat, 14 Mar 2026 01:45:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 1212F3010724
	for <lists+live-patching@lfdr.de>; Sat, 14 Mar 2026 00:45:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8945F280CD2;
	Sat, 14 Mar 2026 00:45:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nY0/fL18"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6670D221F06;
	Sat, 14 Mar 2026 00:45:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773449128; cv=none; b=obyi3rY9trvtGmvn7Poe3NptrBu4wkwrBtX+iHmWhUKBIcedHauw5+XdL9LvlsjotVHr9DiLE6XAKHbG/Lxn/lGd2k0u6oyJxJtQiuduNh12mVuC2Nyw7bUUU5bXUzVB0C/522iWYu2CIXtU1izb+mRmXsNFz7KN08E0fqbDAE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773449128; c=relaxed/simple;
	bh=/V0uuyTzcQCpPt9FAfdP68pgwdCXchE6IRs8x/fuKmo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lOIcHMjPbbZOPjaIOvx2EfwM51f0ujTcoCSUmAff1lhEum0yGzyfAO8Q+LKxBQ8p7bNtJJOXFAUdrzNc18wgTeWSawAffaAnX5yzv3PhutdcI/HSsMAJG6wWLNUhWzpNScg2FmJvH17MNNzFddB34caI+H/z5CU5NScKp0gzT74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nY0/fL18; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 920F3C19421;
	Sat, 14 Mar 2026 00:45:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773449128;
	bh=/V0uuyTzcQCpPt9FAfdP68pgwdCXchE6IRs8x/fuKmo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nY0/fL187q+R4CU2/4X+/6CEvQzvajl5IhjeFhmLw6SAABAzmlYETnlapZ1bFX7L3
	 7IFQC3US5b3dBBbEZ7Cy6dvr667FcoJbE/N5hCs+z2jP6+Ix8w3eitB2tUVsu8I3y2
	 JYY4Mgm22Num9+1VwufG2hZjmBFDC5e5gkSgqlje9FKKHQb7jblC6b7IYLPfj/b/ww
	 PHhc10cvDxevO4Fe/DzdU4IWuG9yi7PFtIVhg0u/f463YRsNYndFitFkQXZzNHnsHh
	 oLwyrz22RyTTwlGG9DSEJar3wWa+/IGjn8bMrHtXCbRgb7ZkwV2D0LA6KrBxAlDavl
	 2TS9swuXAFxoA==
Date: Fri, 13 Mar 2026 17:45:22 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
	live-patching@vger.kernel.org,
	Peter Zijlstra <peterz@infradead.org>,
	Joe Lawrence <joe.lawrence@redhat.com>, Song Liu <song@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, linux-arm-kernel@lists.infradead.org,
	Mark Rutland <mark.rutland@arm.com>,
	Nicolas Schier <nsc@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 09/14] kbuild: Only run objtool if there is at least one
 command
Message-ID: <20260314004522.GA3886710@ax162>
References: <cover.1772681234.git.jpoimboe@kernel.org>
 <b5f73df0d598e77104f7d2de5a84d69e75e80b9f.1772681234.git.jpoimboe@kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b5f73df0d598e77104f7d2de5a84d69e75e80b9f.1772681234.git.jpoimboe@kernel.org>
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2206-lists,live-patching=lfdr.de];
	RCPT_COUNT_TWELVE(0.00)[13];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[nathan@kernel.org,live-patching@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel.org:+];
	TAGGED_RCPT(0.00)[live-patching];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: E2E6628B081
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Wed, Mar 04, 2026 at 07:31:28PM -0800, Josh Poimboeuf wrote:
> Split the objtool args into commands and options, such that if no
> commands have been enabled, objtool doesn't run.
> 
> This is in preparation in enabling objtool and klp-build for arm64.
> 
> Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>

Reviewed-by: Nathan Chancellor <nathan@kernel.org>
Tested-by: Nathan Chancellor <nathan@kernel.org>

I assume this will go with the rest of the series.

> ---
>  arch/x86/boot/startup/Makefile |  2 +-
>  scripts/Makefile.build         |  4 +--
>  scripts/Makefile.lib           | 46 ++++++++++++++++++----------------
>  scripts/Makefile.vmlinux_o     | 15 ++++-------
>  4 files changed, 33 insertions(+), 34 deletions(-)
> 
> diff --git a/arch/x86/boot/startup/Makefile b/arch/x86/boot/startup/Makefile
> index 5e499cfb29b5..a08297829fc6 100644
> --- a/arch/x86/boot/startup/Makefile
> +++ b/arch/x86/boot/startup/Makefile
> @@ -36,7 +36,7 @@ $(patsubst %.o,$(obj)/%.o,$(lib-y)): OBJECT_FILES_NON_STANDARD := y
>  # relocations, even if other objtool actions are being deferred.
>  #
>  $(pi-objs): objtool-enabled	= 1
> -$(pi-objs): objtool-args	= $(if $(delay-objtool),--dry-run,$(objtool-args-y)) --noabs
> +$(pi-objs): objtool-args	= $(if $(delay-objtool),--dry-run,$(objtool-cmds-y) $(objtool-opts-y)) --noabs
>  
>  #
>  # Confine the startup code by prefixing all symbols with __pi_ (for position
> diff --git a/scripts/Makefile.build b/scripts/Makefile.build
> index 32e209bc7985..d2d0776df947 100644
> --- a/scripts/Makefile.build
> +++ b/scripts/Makefile.build
> @@ -277,7 +277,7 @@ endif # CONFIG_FTRACE_MCOUNT_USE_RECORDMCOUNT
>  is-standard-object = $(if $(filter-out y%, $(OBJECT_FILES_NON_STANDARD_$(target-stem).o)$(OBJECT_FILES_NON_STANDARD)n),$(is-kernel-object))
>  
>  ifdef CONFIG_OBJTOOL
> -$(obj)/%.o: private objtool-enabled = $(if $(is-standard-object),$(if $(delay-objtool),$(is-single-obj-m),y))
> +$(obj)/%.o: private objtool-enabled = $(if $(is-standard-object),$(if $(objtool-cmds-y),$(if $(delay-objtool),$(is-single-obj-m),y)))
>  endif
>  
>  ifneq ($(findstring 1, $(KBUILD_EXTRA_WARN)),)
> @@ -499,7 +499,7 @@ define rule_ld_multi_m
>  	$(call cmd,gen_objtooldep)
>  endef
>  
> -$(multi-obj-m): private objtool-enabled := $(delay-objtool)
> +$(multi-obj-m): private objtool-enabled := $(if $(objtool-cmds-y),$(delay-objtool))
>  $(multi-obj-m): private part-of-module := y
>  $(multi-obj-m): %.o: %.mod FORCE
>  	$(call if_changed_rule,ld_multi_m)
> diff --git a/scripts/Makefile.lib b/scripts/Makefile.lib
> index 0718e39cedda..40a462581666 100644
> --- a/scripts/Makefile.lib
> +++ b/scripts/Makefile.lib
> @@ -183,27 +183,31 @@ ifdef CONFIG_OBJTOOL
>  
>  objtool := $(objtree)/tools/objtool/objtool
>  
> -objtool-args-$(CONFIG_HAVE_JUMP_LABEL_HACK)		+= --hacks=jump_label
> -objtool-args-$(CONFIG_HAVE_NOINSTR_HACK)		+= --hacks=noinstr
> -objtool-args-$(CONFIG_MITIGATION_CALL_DEPTH_TRACKING)	+= --hacks=skylake
> -objtool-args-$(CONFIG_X86_KERNEL_IBT)			+= --ibt
> -objtool-args-$(CONFIG_FINEIBT)				+= --cfi
> -objtool-args-$(CONFIG_FTRACE_MCOUNT_USE_OBJTOOL)	+= --mcount
> -ifdef CONFIG_FTRACE_MCOUNT_USE_OBJTOOL
> -objtool-args-$(CONFIG_HAVE_OBJTOOL_NOP_MCOUNT)		+= --mnop
> -endif
> -objtool-args-$(CONFIG_UNWINDER_ORC)			+= --orc
> -objtool-args-$(CONFIG_MITIGATION_RETPOLINE)		+= --retpoline
> -objtool-args-$(CONFIG_MITIGATION_RETHUNK)		+= --rethunk
> -objtool-args-$(CONFIG_MITIGATION_SLS)			+= --sls
> -objtool-args-$(CONFIG_STACK_VALIDATION)			+= --stackval
> -objtool-args-$(CONFIG_HAVE_STATIC_CALL_INLINE)		+= --static-call
> -objtool-args-$(CONFIG_HAVE_UACCESS_VALIDATION)		+= --uaccess
> -objtool-args-$(or $(CONFIG_GCOV_KERNEL),$(CONFIG_KCOV))	+= --no-unreachable
> -objtool-args-$(CONFIG_PREFIX_SYMBOLS)			+= --prefix=$(CONFIG_FUNCTION_PADDING_BYTES)
> -objtool-args-$(CONFIG_OBJTOOL_WERROR)			+= --werror
> +# objtool commands
> +objtool-cmds-$(CONFIG_HAVE_JUMP_LABEL_HACK)		+= --hacks=jump_label
> +objtool-cmds-$(CONFIG_HAVE_NOINSTR_HACK)		+= --hacks=noinstr
> +objtool-cmds-$(CONFIG_MITIGATION_CALL_DEPTH_TRACKING)	+= --hacks=skylake
> +objtool-cmds-$(CONFIG_X86_KERNEL_IBT)			+= --ibt
> +objtool-cmds-$(CONFIG_FINEIBT)				+= --cfi
> +objtool-cmds-$(CONFIG_FTRACE_MCOUNT_USE_OBJTOOL)	+= --mcount
> +objtool-cmds-$(CONFIG_UNWINDER_ORC)			+= --orc
> +objtool-cmds-$(CONFIG_MITIGATION_RETPOLINE)		+= --retpoline
> +objtool-cmds-$(CONFIG_MITIGATION_RETHUNK)		+= --rethunk
> +objtool-cmds-$(CONFIG_MITIGATION_SLS)			+= --sls
> +objtool-cmds-$(CONFIG_STACK_VALIDATION)			+= --stackval
> +objtool-cmds-$(CONFIG_HAVE_STATIC_CALL_INLINE)		+= --static-call
> +objtool-cmds-$(CONFIG_HAVE_UACCESS_VALIDATION)		+= --uaccess
> +objtool-cmds-$(CONFIG_PREFIX_SYMBOLS)			+= --prefix=$(CONFIG_FUNCTION_PADDING_BYTES)
> +objtool-cmds-y						+= $(OBJTOOL_ARGS)
>  
> -objtool-args = $(objtool-args-y)					\
> +# objtool options
> +ifdef CONFIG_FTRACE_MCOUNT_USE_OBJTOOL
> +objtool-opts-$(CONFIG_HAVE_OBJTOOL_NOP_MCOUNT)		+= --mnop
> +endif
> +objtool-opts-$(or $(CONFIG_GCOV_KERNEL),$(CONFIG_KCOV))	+= --no-unreachable
> +objtool-opts-$(CONFIG_OBJTOOL_WERROR)			+= --werror
> +
> +objtool-args = $(objtool-cmds-y) $(objtool-opts-y)			\
>  	$(if $(delay-objtool), --link)					\
>  	$(if $(part-of-module), --module)
>  
> @@ -212,7 +216,7 @@ delay-objtool := $(or $(CONFIG_LTO_CLANG),$(CONFIG_X86_KERNEL_IBT),$(CONFIG_KLP_
>  cmd_objtool = $(if $(objtool-enabled), ; $(objtool) $(objtool-args) $@)
>  cmd_gen_objtooldep = $(if $(objtool-enabled), { echo ; echo '$@: $$(wildcard $(objtool))' ; } >> $(dot-target).cmd)
>  
> -objtool-enabled := y
> +objtool-enabled = $(if $(objtool-cmds-y),y)
>  
>  endif # CONFIG_OBJTOOL
>  
> diff --git a/scripts/Makefile.vmlinux_o b/scripts/Makefile.vmlinux_o
> index 527352c222ff..09af33203bd8 100644
> --- a/scripts/Makefile.vmlinux_o
> +++ b/scripts/Makefile.vmlinux_o
> @@ -36,18 +36,13 @@ endif
>  # For !delay-objtool + CONFIG_NOINSTR_VALIDATION, it runs on both translation
>  # units and vmlinux.o, with the latter only used for noinstr/unret validation.
>  
> -objtool-enabled := $(or $(delay-objtool),$(CONFIG_NOINSTR_VALIDATION))
> -
> -ifeq ($(delay-objtool),y)
> -vmlinux-objtool-args-y					+= $(objtool-args-y)
> -else
> -vmlinux-objtool-args-$(CONFIG_OBJTOOL_WERROR)		+= --werror
> +ifneq ($(delay-objtool),y)
> +objtool-cmds-y					 =
> +objtool-opts-y					+= --link
>  endif
>  
> -vmlinux-objtool-args-$(CONFIG_NOINSTR_VALIDATION)	+= --noinstr \
> -							   $(if $(or $(CONFIG_MITIGATION_UNRET_ENTRY),$(CONFIG_MITIGATION_SRSO)), --unret)
> -
> -objtool-args = $(vmlinux-objtool-args-y) --link
> +objtool-cmds-$(CONFIG_NOINSTR_VALIDATION)	+= --noinstr \
> +						   $(if $(or $(CONFIG_MITIGATION_UNRET_ENTRY),$(CONFIG_MITIGATION_SRSO)), --unret)
>  
>  # Link of vmlinux.o used for section mismatch analysis
>  # ---------------------------------------------------------------------------
> -- 
> 2.53.0
> 

