Return-Path: <live-patching+bounces-1461-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id F2B9DAC3DF9
	for <lists+live-patching@lfdr.de>; Mon, 26 May 2025 12:44:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BE0697A29A9
	for <lists+live-patching@lfdr.de>; Mon, 26 May 2025 10:42:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 97FAE1C07C4;
	Mon, 26 May 2025 10:44:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="FQ2fWIAK"
X-Original-To: live-patching@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00C442566;
	Mon, 26 May 2025 10:44:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748256246; cv=none; b=iaJqzRUAR0wF97zWdSNDR3nPpxT9j4YHkQ9Vzvi6m2GjvFflWfn9LnblK0HeDcosIOnqnU7PcqBeoQX3W9spiakLvJiGxyZhz/qI3NokSxwIADSgyCNtFTzGCrLMKRryPOohGAOGI6Q0ZAJ58HZxIHbW3gPtyWmjzn/iBvlwxt0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748256246; c=relaxed/simple;
	bh=1I7PdYugHiRgLZ0cApCjHoC+bBN3bd/ZZQOkfdIeqQ0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qQbM9Xuu8ooY9UTmvGuPdBbWZnAKZtU35NEMW/OTlA/vXntl57nC0THvEGUrMinkriBfvZIwabDS1BBWutiaLxPSDNgghpGTKTydj3TsB7bNmvEjBO7yOcM+iTLjB78SJXz7z4MEl6QShQg5u/plCUOjbBmLoqKocG34wPqA2Nw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=FQ2fWIAK; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=5MSK+hCGwuICLk6ahEH9v1jcbgabrh3lw7OluZQ3VCY=; b=FQ2fWIAKlWxgWLdIgwUw6GJbhK
	YU9bl3VGl3vjnMe1uqEWwqa8Lz5HYcHBO5qkjDNuqKtSN4bJYN5ij8CYTbuGgGrPcM/DmlHPfV43P
	G06ubRAiH8xqRsNa1cwGzq5Ham89CI6HkGASwiMmQvdoPXo7PY9m6LNw3GDwLq+geoIXngAtmM1AG
	HXVyZoujQxP6keCo/ocN+DObeP9unB/iS3iw1oxHqfl1c8N4vUGT/w0Typw8UyNOvqGCwbPax4yw5
	ml6KyLl5eonXqTBvcS+L1ncON30ZjKgGMb18PTu30eOLJ1BOk0kpnANKVUjrWs+ho0LLbDsIGpm1N
	92W8ImrQ==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uJVJD-0000000BJxA-31tj;
	Mon, 26 May 2025 10:43:55 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 4906C300472; Mon, 26 May 2025 12:43:55 +0200 (CEST)
Date: Mon, 26 May 2025 12:43:55 +0200
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
	Puranjay Mohan <puranjay@kernel.org>
Subject: Re: [PATCH v2 29/62] objtool: Mark prefix functions
Message-ID: <20250526104355.GM24938@noisy.programming.kicks-ass.net>
References: <cover.1746821544.git.jpoimboe@kernel.org>
 <c4233972de0b0f2e6c94d4a225c953748d7c446b.1746821544.git.jpoimboe@kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c4233972de0b0f2e6c94d4a225c953748d7c446b.1746821544.git.jpoimboe@kernel.org>

On Fri, May 09, 2025 at 01:16:53PM -0700, Josh Poimboeuf wrote:
> In preparation for the objtool klp diff subcommand, introduce a flag to
> identify __pfx_*() and __cfi_*() functions in advance so they don't need
> to be manually identified every time a check is needed.
> 
> Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
> ---
>  tools/objtool/check.c               | 3 +--
>  tools/objtool/elf.c                 | 5 +++++
>  tools/objtool/include/objtool/elf.h | 6 ++++++
>  3 files changed, 12 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/objtool/check.c b/tools/objtool/check.c
> index a2a025ec57e8..6b2e57d9aaf8 100644
> --- a/tools/objtool/check.c
> +++ b/tools/objtool/check.c
> @@ -3601,8 +3601,7 @@ static int validate_branch(struct objtool_file *file, struct symbol *func,
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
> index 59568381486c..9a1fc0392b7f 100644
> --- a/tools/objtool/elf.c
> +++ b/tools/objtool/elf.c
> @@ -442,6 +442,11 @@ static void elf_add_symbol(struct elf *elf, struct symbol *sym)
>  	elf_hash_add(symbol, &sym->hash, sym->idx);
>  	elf_hash_add(symbol_name, &sym->name_hash, str_hash(sym->name));
>  
> +	if (is_func_sym(sym) && sym->len == 16 &&

Where did that 'sym->len == 16' thing come from? I mean, they are, but
the old code didn't assert that.

I would rather objtool issue a warn if not 16, but still consider these
as prefix.

> +	    (strstarts(sym->name, "__pfx") || strstarts(sym->name, "__cfi_")))
> +		sym->prefix = 1;
> +
> +
>  	if (is_func_sym(sym) && strstr(sym->name, ".cold"))
>  		sym->cold = 1;
>  	sym->pfunc = sym->cfunc = sym;

