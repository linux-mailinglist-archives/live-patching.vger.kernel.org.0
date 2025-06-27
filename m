Return-Path: <live-patching+bounces-1598-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 61EBFAEB51B
	for <lists+live-patching@lfdr.de>; Fri, 27 Jun 2025 12:38:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 82E8964603C
	for <lists+live-patching@lfdr.de>; Fri, 27 Jun 2025 10:33:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D4F1298CD7;
	Fri, 27 Jun 2025 10:32:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="UoviRh7l"
X-Original-To: live-patching@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97F5A29824B;
	Fri, 27 Jun 2025 10:32:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751020327; cv=none; b=iE/SrSTj4qsbOVWjILI2OuN76TSVtUhT8LPsi5AyFsnQZ+GhG47ROxbISIms0Fstae09Z+qSzW1lNBWjfZbfH1bId6fcmIWPFqJe4pX9w6lLo5W6mDIIGHQMBz6QgCG0v3EC3ILOBSIM1HvJ3MF96QjZrNCRDqPkjSQwJRbHoak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751020327; c=relaxed/simple;
	bh=dqWLPFhz8rc1ZTXlMaJumoRCie1NT15EY7+LO9HcNC8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IaYCW9+YeGfFuf6ts201KsR8FY4N2mmYhb9X/rsus5xaT89c8YZeVuiWniRaym5tHLQlDY8B48ceCpZ4rZOQxktLywS+ZB2LT1e80RN2aZJrYF1if4Bh8r7meaA4sbrwxaG3VMz5zA/VqWsvuQe6oP+wg2H7WtwArXr2RudWHvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=UoviRh7l; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=a5DbHwM2RC/F41mKJ6XtRMRcJqm5DzALFSyCg+z/++Y=; b=UoviRh7l6mtdS4pvSN45NIy1GS
	Q1xm1CVZa0z5bPkHbwkuDfLXc0hMptb5m/xORqfEiqT7sBQP0QUe0sX2uRp5yoYVei+Y+qB+bIwxS
	g4HTETlpY8Tb0RvGNptLJo52+FkJxz55DgWNclVcnXeAz+a1CPwG4ojcOkGivHp4yS3QOq9lq+yOJ
	hnD4b8USppfLMAV5pcJ2McDMP3TtbthuEeRGT6eGb5EqzGjCG2vToYO840NZSX+m+rS6USYox+gRT
	t5VtAg5Yq4uyhNV3iFAtxvl8ZkRkShBxsFEtCP0pThZOfyknCw31i3rSsY/8h+u876MCgicV9733n
	2Z2pFScg==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uV6NC-0000000Dptg-3zkC;
	Fri, 27 Jun 2025 10:31:59 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 88146300192; Fri, 27 Jun 2025 12:31:58 +0200 (CEST)
Date: Fri, 27 Jun 2025 12:31:58 +0200
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
Subject: Re: [PATCH v3 29/64] objtool: Mark prefix functions
Message-ID: <20250627103158.GV1613200@noisy.programming.kicks-ass.net>
References: <cover.1750980516.git.jpoimboe@kernel.org>
 <f277ca3e78d662268d6303637b1bba71c2a22b1f.1750980517.git.jpoimboe@kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f277ca3e78d662268d6303637b1bba71c2a22b1f.1750980517.git.jpoimboe@kernel.org>

On Thu, Jun 26, 2025 at 04:55:16PM -0700, Josh Poimboeuf wrote:
> In preparation for the objtool klp diff subcommand, introduce a flag to
> identify __pfx_*() and __cfi_*() functions in advance so they don't need
> to be manually identified every time a check is needed.
> 
> Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
> ---
>  tools/objtool/check.c               | 3 +--
>  tools/objtool/elf.c                 | 4 ++++
>  tools/objtool/include/objtool/elf.h | 6 ++++++
>  3 files changed, 11 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/objtool/check.c b/tools/objtool/check.c
> index 80bafcdb42af..55cc3a2a21c9 100644
> --- a/tools/objtool/check.c
> +++ b/tools/objtool/check.c
> @@ -3564,8 +3564,7 @@ static int validate_branch(struct objtool_file *file, struct symbol *func,
>  
>  		if (func && insn_func(insn) && func != insn_func(insn)->pfunc) {
>  			/* Ignore KCFI type preambles, which always fall through */
> -			if (!strncmp(func->name, "__cfi_", 6) ||
> -			    !strncmp(func->name, "__pfx_", 6))
> +			if (is_prefix_func(func))
>  				return 0;
>  
>  			if (file->ignore_unreachables)
> diff --git a/tools/objtool/elf.c b/tools/objtool/elf.c
> index 59568381486c..1bb86151243a 100644
> --- a/tools/objtool/elf.c
> +++ b/tools/objtool/elf.c
> @@ -442,6 +442,10 @@ static void elf_add_symbol(struct elf *elf, struct symbol *sym)
>  	elf_hash_add(symbol, &sym->hash, sym->idx);
>  	elf_hash_add(symbol_name, &sym->name_hash, str_hash(sym->name));
>  
> +	if (is_func_sym(sym) &&
> +	    (strstarts(sym->name, "__pfx_") || strstarts(sym->name, "__cfi_")))
> +		sym->prefix = 1;
> +
>  	if (is_func_sym(sym) && strstr(sym->name, ".cold"))
>  		sym->cold = 1;
>  	sym->pfunc = sym->cfunc = sym;
> diff --git a/tools/objtool/include/objtool/elf.h b/tools/objtool/include/objtool/elf.h
> index f41496b0ad8f..842faec1b9a9 100644
> --- a/tools/objtool/include/objtool/elf.h
> +++ b/tools/objtool/include/objtool/elf.h
> @@ -72,6 +72,7 @@ struct symbol {
>  	u8 frame_pointer     : 1;
>  	u8 ignore	     : 1;
>  	u8 cold		     : 1;
> +	u8 prefix	     : 1;
>  	struct list_head pv_target;
>  	struct reloc *relocs;
>  	struct section *group_sec;
> @@ -229,6 +230,11 @@ static inline bool is_local_sym(struct symbol *sym)
>  	return sym->bind == STB_LOCAL;
>  }
>  
> +static inline bool is_prefix_func(struct symbol *sym)
> +{
> +	return is_func_sym(sym) && sym->prefix;
> +}

func_is_prefix() ?

Also, since we only ever set sym->prefix when is_func_sym(), this helper
could avoid checking that again.

