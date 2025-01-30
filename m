Return-Path: <live-patching+bounces-1083-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 00083A22AA0
	for <lists+live-patching@lfdr.de>; Thu, 30 Jan 2025 10:45:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5C143164F0B
	for <lists+live-patching@lfdr.de>; Thu, 30 Jan 2025 09:45:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9687E1B4143;
	Thu, 30 Jan 2025 09:45:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="IsSf5FRF"
X-Original-To: live-patching@vger.kernel.org
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E8B9F1B4C35;
	Thu, 30 Jan 2025 09:45:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738230308; cv=none; b=K4oR0+5g3fXujiwxXwywojiKCv1kSSBBNsSzMrXSVpfOEdSDqTWmnmfaUCoh5NqiuZz/SyMVFzy4c6Fp7OumwyA4W9CgnZgmWltgykp3BdDcCLR6/IltJDRIAdFenF7mj/S2yJ2An4CBHCXvfnz4TRutBghAEB9+7fCstdmV/IE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738230308; c=relaxed/simple;
	bh=bNUQPhEn4wGDCDGlcPX0Dtsaf+qnmhjqp6HCYuyV7ps=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UIel817UqYfdnWe264OGL3lnilTkLysBSYsMa7lzDnsX6PVQiCIZN8Lr2tAx9UwW26p5x1pM08xn+wVQjmp6BiNjt/0ynOQeuKP1sSg2Qgwc1yjE9IoMviDx4x9ZiT5AKGD9DGl7FwRKurxRRv+P93TJ8opDzBTxaJmyzPZM5xs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=IsSf5FRF; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Received: from [10.156.205.88] (unknown [167.220.238.88])
	by linux.microsoft.com (Postfix) with ESMTPSA id EE9E72109CD7;
	Thu, 30 Jan 2025 01:45:02 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com EE9E72109CD7
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1738230306;
	bh=NRGiBYGv+vKqDqDaesyuawX4ZPxUYYpwD/wnO7/ks+Y=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=IsSf5FRFEtFqA4+wMmOLBhT+u99GjlRyAoqK3hukAvyDf6BXvo1bzRR8Hxn03jmpN
	 Lhz5KNPyeMWkhA3VAUsMLmnM3tbO6yKa8Mu1VW2YaE19FRA0sWqnZE1lAWq+I8921f
	 m79XGe6iux/lhe6N2Ds11PSJQQp121cf/U9or2uc=
Message-ID: <d7f69c61-8daf-4996-8c62-108589442604@linux.microsoft.com>
Date: Thu, 30 Jan 2025 15:15:01 +0530
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/8] unwind: build kernel with sframe info
To: Weinan Liu <wnliu@google.com>, Josh Poimboeuf <jpoimboe@kernel.org>,
 Steven Rostedt <rostedt@goodmis.org>, Indu Bhagat <indu.bhagat@oracle.com>,
 Peter Zijlstra <peterz@infradead.org>
Cc: Mark Rutland <mark.rutland@arm.com>, roman.gushchin@linux.dev,
 Will Deacon <will@kernel.org>, Ian Rogers <irogers@google.com>,
 linux-toolchains@vger.kernel.org, linux-kernel@vger.kernel.org,
 live-patching@vger.kernel.org, joe.lawrence@redhat.com,
 linux-arm-kernel@lists.infradead.org
References: <20250127213310.2496133-1-wnliu@google.com>
 <20250127213310.2496133-2-wnliu@google.com>
Content-Language: en-US
From: Prasanna Kumar T S M <ptsm@linux.microsoft.com>
In-Reply-To: <20250127213310.2496133-2-wnliu@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 28-01-2025 03:03, Weinan Liu wrote:
> Use the -Wa,--gsframe flags to build the code, so GAS will generate
> a new .sframe section for the stack trace information.
> Currently, the sframe format only supports arm64 and x86_64
> architectures. Add this configuration on arm64 to enable sframe
> unwinder in the future.
>
> Signed-off-by: Weinan Liu <wnliu@google.com>
> ---
>   Makefile                          |  6 ++++++
>   arch/Kconfig                      |  8 ++++++++
>   arch/arm64/Kconfig.debug          | 10 ++++++++++
>   include/asm-generic/vmlinux.lds.h | 12 ++++++++++++
>   4 files changed, 36 insertions(+)
>
> diff --git a/Makefile b/Makefile
> index b9464c88ac72..35200c39b98d 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -1064,6 +1064,12 @@ ifdef CONFIG_CC_IS_GCC
>   KBUILD_CFLAGS   += -fconserve-stack
>   endif
>   
> +# build with sframe table
> +ifdef CONFIG_SFRAME_UNWIND_TABLE
> +KBUILD_CFLAGS	+= -Wa,--gsframe
> +KBUILD_AFLAGS	+= -Wa,--gsframe
> +endif
> +
>   # change __FILE__ to the relative path to the source directory
>   ifdef building_out_of_srctree
>   KBUILD_CPPFLAGS += $(call cc-option,-fmacro-prefix-map=$(srcroot)/=)
> diff --git a/arch/Kconfig b/arch/Kconfig
> index 6682b2a53e34..ae70f7dbe326 100644
> --- a/arch/Kconfig
> +++ b/arch/Kconfig
> @@ -1736,4 +1736,12 @@ config ARCH_WANTS_PRE_LINK_VMLINUX
>   	  An architecture can select this if it provides arch/<arch>/tools/Makefile
>   	  with .arch.vmlinux.o target to be linked into vmlinux.
>   
> +config AS_HAS_SFRAME_SUPPORT
> +	# Detect availability of the AS option -Wa,--gsframe for generating
> +	# sframe unwind table.
> +	def_bool $(cc-option,-Wa$(comma)--gsframe)
> +
> +config SFRAME_UNWIND_TABLE
> +	bool
> +
>   endmenu
> diff --git a/arch/arm64/Kconfig.debug b/arch/arm64/Kconfig.debug
> index 265c4461031f..ed619fcb18b3 100644
> --- a/arch/arm64/Kconfig.debug
> +++ b/arch/arm64/Kconfig.debug
> @@ -20,4 +20,14 @@ config ARM64_RELOC_TEST
>   	depends on m
>   	tristate "Relocation testing module"
>   
> +config SFRAME_UNWINDER
> +	bool "Sframe unwinder"
> +	depends on AS_HAS_SFRAME_SUPPORT
> +	depends on 64BIT
> +	select SFRAME_UNWIND_TABLE
> +	help
> +	  This option enables the sframe (Simple Frame) unwinder for unwinding
> +	  kernel stack traces. It uses unwind table that is direclty generated
> +	  by toolchain based on DWARF CFI information
> +
>   source "drivers/hwtracing/coresight/Kconfig"
> diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
> index 54504013c749..6a437bd084c7 100644
> --- a/include/asm-generic/vmlinux.lds.h
> +++ b/include/asm-generic/vmlinux.lds.h
> @@ -469,6 +469,8 @@ defined(CONFIG_AUTOFDO_CLANG) || defined(CONFIG_PROPELLER_CLANG)
>   		*(.rodata1)						\
>   	}								\
>   									\
> +	SFRAME								\
> +									\
>   	/* PCI quirks */						\
>   	.pci_fixup        : AT(ADDR(.pci_fixup) - LOAD_OFFSET) {	\
>   		BOUNDED_SECTION_PRE_LABEL(.pci_fixup_early,  _pci_fixups_early,  __start, __end) \
> @@ -886,6 +888,16 @@ defined(CONFIG_AUTOFDO_CLANG) || defined(CONFIG_PROPELLER_CLANG)
>   #define TRACEDATA
>   #endif
>   
> +#ifdef CONFIG_SFRAME_UNWIND_TABLE
> +#define SFRAME							\
> +	/* sframe */						\
> +	.sframe        : AT(ADDR(.sframe) - LOAD_OFFSET) {	\
> +		BOUNDED_SECTION_BY(.sframe, _sframe_header)	\
> +	}
> +#else
> +#define SFRAME
> +#endif
> +
>   #ifdef CONFIG_PRINTK_INDEX
>   #define PRINTK_INDEX							\
>   	.printk_index : AT(ADDR(.printk_index) - LOAD_OFFSET) {		\

Looks good to me.

Reviewed-by: Prasanna Kumar T S M <ptsm@linux.microsoft.com>.


