Return-Path: <live-patching+bounces-1856-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 66858C5D5DB
	for <lists+live-patching@lfdr.de>; Fri, 14 Nov 2025 14:34:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 36E683B951A
	for <lists+live-patching@lfdr.de>; Fri, 14 Nov 2025 13:34:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AFAC931A567;
	Fri, 14 Nov 2025 13:34:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ueYtGgNJ"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A05C136358;
	Fri, 14 Nov 2025 13:34:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763127272; cv=none; b=J4KM/h6/U0NO/cchuibQ0WZXTXttz3ho8HFUipP3Z24JrCNBB8n8A6sYvxMILCU4b5LhQPJyHghWcoSNv0Knu41Ft8+jEXmfhwekjgty4RUggGz5OltMzDlTOrHrlD3qm6362QSDIb2GHYz64Yij2PZnFK2f0mC9BEpRp0pe0jQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763127272; c=relaxed/simple;
	bh=zf5qQNJA0exrvxTbVoHpDniJvWpJhG6NBgdvS5qCzwY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IYH5D0ZAAmGXGGVP0MzaMXCXyjd/+XFglkc43NreG03EpgdKspKLkfwqcE84rcOfs2DsjShzkiEyGVA6i8EmJleausWCAwbdHLsQFl05EuDVj+6MO2eonuBzciCXKRQQYXS04rXQJsNCWrY6uW0hT9pI/EjcUVVGi1P5Dcj2AyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ueYtGgNJ; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7424C16AAE;
	Fri, 14 Nov 2025 13:34:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763127272;
	bh=zf5qQNJA0exrvxTbVoHpDniJvWpJhG6NBgdvS5qCzwY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ueYtGgNJqE2f6qGi6XHRMZ5q0gsBW2QkCVscvdOLDqWyxntqU8M9WuWK0AD0XtsBh
	 Nfm8TLskAvrK4dHhJ9K91lM9czqfmahhBDh/AonvTjW6Wpf8knwN189IfXMzwtkbSr
	 hlVxE+vBmwjl2J4MCUgaWQE3CyYbdlfUNQCEawAdtSDh/FidkeiNe91tiR0tQ6LTXU
	 18wFOU3PzoXuVMfvo6wHbv7BEyo3OHIUmy18khe15uXbmWPezgWPGmc06bdkjc70Cw
	 8uAdrnM/ZgBhh6Lo0nFxJ/nCLbrfhmllLF6WMNXILIBKa3F0v07F4sQ6YUlUBtydTH
	 /EcIig++sOnVQ==
Date: Fri, 14 Nov 2025 13:34:25 +0000
From: Will Deacon <will@kernel.org>
To: Dylan Hatch <dylanbhatch@google.com>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Indu Bhagat <indu.bhagat@oracle.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Jiri Kosina <jikos@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Weinan Liu <wnliu@google.com>, Mark Rutland <mark.rutland@arm.com>,
	Ian Rogers <irogers@google.com>, linux-toolchains@vger.kernel.org,
	linux-kernel@vger.kernel.org, live-patching@vger.kernel.org,
	joe.lawrence@redhat.com, Puranjay Mohan <puranjay@kernel.org>,
	Song Liu <song@kernel.org>,
	Prasanna Kumar T S M <ptsm@linux.microsoft.com>
Subject: Re: [PATCH v2 1/6] unwind: build kernel with sframe info
Message-ID: <aRcv4RX40rXKIjxd@willie-the-truck>
References: <20250904223850.884188-1-dylanbhatch@google.com>
 <20250904223850.884188-2-dylanbhatch@google.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250904223850.884188-2-dylanbhatch@google.com>

On Thu, Sep 04, 2025 at 10:38:45PM +0000, Dylan Hatch wrote:
> Use the -Wa,--gsframe flags to build the code, so GAS will generate
> a new .sframe section for the stack trace information.
> Currently, the sframe format only supports arm64 and x86_64
> architectures. Add this configuration on arm64 to enable sframe
> unwinder in the future.
> 
> Signed-off-by: Weinan Liu <wnliu@google.com>
> Signed-off-by: Dylan Hatch <dylanbhatch@google.com>
> Reviewed-by: Prasanna Kumar T S M <ptsm@linux.microsoft.com>
> ---
>  Makefile                          |  8 ++++++++
>  arch/Kconfig                      |  6 ++++++
>  arch/arm64/Kconfig.debug          | 10 ++++++++++
>  arch/arm64/kernel/vdso/Makefile   |  2 +-
>  include/asm-generic/vmlinux.lds.h | 15 +++++++++++++++
>  5 files changed, 40 insertions(+), 1 deletion(-)
> 
> diff --git a/Makefile b/Makefile
> index b9c661913250..09972c71a3e8 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -1078,6 +1078,14 @@ endif
>  # Ensure compilers do not transform certain loops into calls to wcslen()
>  KBUILD_CFLAGS += -fno-builtin-wcslen
>  
> +# build with sframe table
> +ifdef CONFIG_SFRAME_UNWIND_TABLE
> +CC_FLAGS_SFRAME := -Wa,--gsframe
> +KBUILD_CFLAGS	+= $(CC_FLAGS_SFRAME)
> +KBUILD_AFLAGS	+= $(CC_FLAGS_SFRAME)
> +export CC_FLAGS_SFRAME
> +endif
> +
>  # change __FILE__ to the relative path to the source directory
>  ifdef building_out_of_srctree
>  KBUILD_CPPFLAGS += $(call cc-option,-fmacro-prefix-map=$(srcroot)/=)
> diff --git a/arch/Kconfig b/arch/Kconfig
> index d1b4ffd6e085..4362d2f49d91 100644
> --- a/arch/Kconfig
> +++ b/arch/Kconfig
> @@ -1782,4 +1782,10 @@ config ARCH_WANTS_PRE_LINK_VMLINUX
>  config ARCH_HAS_CPU_ATTACK_VECTORS
>  	bool
>  
> +config AS_SFRAME
> +	def_bool $(as-instr,.cfi_sections .sframe\n.cfi_startproc\n.cfi_endproc)

Is it possible to extend this check so that we reject assemblers that
emit the unsupported "sframe version one" format?

> +config SFRAME_UNWIND_TABLE
> +	bool

Is this extra option actually needed for anything?

>  endmenu
> diff --git a/arch/arm64/Kconfig.debug b/arch/arm64/Kconfig.debug
> index 265c4461031f..d64bf58457de 100644
> --- a/arch/arm64/Kconfig.debug
> +++ b/arch/arm64/Kconfig.debug
> @@ -20,4 +20,14 @@ config ARM64_RELOC_TEST
>  	depends on m
>  	tristate "Relocation testing module"
>  
> +config SFRAME_UNWINDER
> +	bool "Sframe unwinder"
> +	depends on AS_SFRAME
> +	depends on 64BIT

Shouldn't there be an arch dependency here as well? Since architectures
need to make use of sframe in their unwinders, I was expecting something
like 'depends on ARCH_SUPPORTS_SFRAME_UNWINDER' here.

Will

