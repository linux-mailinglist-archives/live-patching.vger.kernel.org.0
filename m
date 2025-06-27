Return-Path: <live-patching+bounces-1599-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DF10FAEB54B
	for <lists+live-patching@lfdr.de>; Fri, 27 Jun 2025 12:48:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4D9CA3BDE2B
	for <lists+live-patching@lfdr.de>; Fri, 27 Jun 2025 10:48:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0BD4A298CD2;
	Fri, 27 Jun 2025 10:48:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="izQjjMRp"
X-Original-To: live-patching@vger.kernel.org
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75471298243;
	Fri, 27 Jun 2025 10:48:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751021312; cv=none; b=FG0EKUHVszcKMHFvQu6LDqb664DHTfTuCP1OkXGFy+hfmKDzrEqHfO+Cyx1/pe/io/P2wjKfzOhghapgGNY2sThBrkuT6Z0YLOkPfvJXC7FWSBMntQ/SFqonQKjDZvCl5zpbfLCCmvdLAkDBDMuUkOrxj3LA24E5hTkw/gMlL6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751021312; c=relaxed/simple;
	bh=zTaImzQvyCJ+Z/cogZQ7ixDMf1PZF1A8ODsuy+Dc06Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bO493XkEfH87/bipCTSWPar6BK93cZf8gFCEU6sCr50zPKEhS7EddSXLuu3AEau7YiimxS+Kkx9ztp0cdWs/eiKvZC0I3CxWwu5MjGAW6+E/BEeEJcgbT65LzmXd/AAYusJi+gcpjzchvCLhfRYwpTN7QTRD33habilbT14tKaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=izQjjMRp; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=BLbSDUVkOwlXKe5Iqrl5Hyd0R2s4vXLOwWtBUjFxWpA=; b=izQjjMRpe6V8jQkCAysNrKkrkV
	nVxOADdvPxa6iSh1wym/acNjmdvxopPXyaA/Y9MsHyFq6wMrh8V4hdPqmSLPrShox6o08Fw4FNbSu
	gcArQAut4Eq8nWh/w6ELSbTsTfTN030NMIG/eLV2GggjZcVOjwmKX06dMvHPl380UQE0JHE61JOmf
	vDfgUjDLmg8UZPlILY0dRkpZ7HTeZtiRXLpEKLrkm7f8ov3OCAxn+D0NM3Tysm26YA0xTgLej0iFF
	PuVeKunew8NTaNs58jDXJcw0s9UTfnkqRzQkbvmQRGpzrWaxbrJMNUAFxeQZTRliJOuXqpFskRRth
	+V3H90bg==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uV6d1-00000006Ifm-2mOg;
	Fri, 27 Jun 2025 10:48:19 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id AE99E30023C; Fri, 27 Jun 2025 12:48:18 +0200 (CEST)
Date: Fri, 27 Jun 2025 12:48:18 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
	Petr Mladek <pmladek@suse.com>, Miroslav Benes <mbenes@suse.cz>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	live-patching@vger.kernel.org, Song Liu <song@kernel.org>,
	laokz <laokz@foxmail.com>, Jiri Kosina <jikos@kernel.org>,
	Marcos Paulo de Souza <mpdesouza@suse.com>,
	Weinan Liu <wnliu@google.com>,
	Fazla Mehrab <a.mehrab@bytedance.com>,
	Chen Zhongjin <chenzhongjin@huawei.com>,
	Puranjay Mohan <puranjay@kernel.org>,
	Dylan Hatch <dylanbhatch@google.com>
Subject: Re: [PATCH v3 44/64] x86/jump_label: Define ELF section entry size
 for jump labels
Message-ID: <20250627104818.GW1613200@noisy.programming.kicks-ass.net>
References: <cover.1750980516.git.jpoimboe@kernel.org>
 <7217634a8158e56703dfe22199f1b9c08c501ae3.1750980517.git.jpoimboe@kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7217634a8158e56703dfe22199f1b9c08c501ae3.1750980517.git.jpoimboe@kernel.org>

On Thu, Jun 26, 2025 at 04:55:31PM -0700, Josh Poimboeuf wrote:
> In preparation for the objtool klp diff subcommand, define the entry
> size for the __jump_table section in its ELF header.  This will allow
> tooling to extract individual entries.
> 
> Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
> ---
>  arch/x86/include/asm/jump_label.h | 17 +++++++++++------
>  kernel/bounds.c                   |  4 ++++
>  2 files changed, 15 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/include/asm/jump_label.h b/arch/x86/include/asm/jump_label.h
> index cd21554b3675..7a6b0e5d85c1 100644
> --- a/arch/x86/include/asm/jump_label.h
> +++ b/arch/x86/include/asm/jump_label.h
> @@ -12,12 +12,17 @@
>  #include <linux/stringify.h>
>  #include <linux/types.h>
>  
> -#define JUMP_TABLE_ENTRY(key, label)			\
> -	".pushsection __jump_table,  \"a\"\n\t"		\
> -	_ASM_ALIGN "\n\t"				\
> -	".long 1b - . \n\t"				\
> -	".long " label " - . \n\t"			\
> -	_ASM_PTR " " key " - . \n\t"			\
> +#ifndef COMPILE_OFFSETS
> +#include <generated/bounds.h>
> +#endif
> +
> +#define JUMP_TABLE_ENTRY(key, label)				\
> +	".pushsection __jump_table,  \"aM\", @progbits, "	\
> +	__stringify(JUMP_ENTRY_SIZE) "\n\t"			\

Argh, can you please not do this line-break. Yes it'll be long, but this
is most confusing.

> +	_ASM_ALIGN "\n\t"					\
> +	".long 1b - . \n\t"					\
> +	".long " label " - . \n\t"				\
> +	_ASM_PTR " " key " - . \n\t"				\
>  	".popsection \n\t"
>  
>  /* This macro is also expanded on the Rust side. */
> diff --git a/kernel/bounds.c b/kernel/bounds.c
> index 02b619eb6106..e4c7ded3dc48 100644
> --- a/kernel/bounds.c
> +++ b/kernel/bounds.c
> @@ -13,6 +13,7 @@
>  #include <linux/kbuild.h>
>  #include <linux/log2.h>
>  #include <linux/spinlock_types.h>
> +#include <linux/jump_label.h>
>  
>  int main(void)
>  {
> @@ -29,6 +30,9 @@ int main(void)
>  #else
>  	DEFINE(LRU_GEN_WIDTH, 0);
>  	DEFINE(__LRU_REFS_WIDTH, 0);
> +#endif
> +#if defined(CONFIG_HAVE_ARCH_JUMP_LABEL_RELATIVE) && defined(CONFIG_JUMP_LABEL)

How is HAVE_ARCH_JUMP_LABEL_RELATIVE relevant here?

> +	DEFINE(JUMP_ENTRY_SIZE, sizeof(struct jump_entry));
>  #endif
>  	/* End of constants */
>  
> -- 
> 2.49.0
> 

