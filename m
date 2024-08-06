Return-Path: <live-patching+bounces-442-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4C2859497B0
	for <lists+live-patching@lfdr.de>; Tue,  6 Aug 2024 20:43:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0780F1F24672
	for <lists+live-patching@lfdr.de>; Tue,  6 Aug 2024 18:43:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D1A2C7D40B;
	Tue,  6 Aug 2024 18:43:40 +0000 (UTC)
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A989C79B87;
	Tue,  6 Aug 2024 18:43:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722969820; cv=none; b=REY1X68+/svLUGotSnYde6kQl1s5R4jC0hKVodyKpEGX7KvZUSM2k4raCb5nkUqNwJ0/1wgn4YBnBVm7WNFj8qkxaymwShGtbtd3a+ZPv8HGF2PhEksPlY19T23dT53yEhEf5+Ls6kggj33Qmzl71bvefSZC5GaloxSr+kPqJEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722969820; c=relaxed/simple;
	bh=IDtB+cHkmqBFqQhVZ6SoKgzkGaHOuyyoyb2jRwqf7sA=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PNjmwRYAGMQgDK4JaUxrMNXvjRwiMugBwUMmKZXSmTgQ/Yv4OAR/A3zXfKp285bXcO4qpSRlWt5aodVH8P5IdC809hxZzkzACMUAaxkyadXWutV727zrxwnmj5picn/OtDf8GlYqNxiibRUwILzetqxD3S+YyKZhqq74sQU52y8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31E81C32786;
	Tue,  6 Aug 2024 18:43:38 +0000 (UTC)
Date: Tue, 6 Aug 2024 14:44:26 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Song Liu <song@kernel.org>
Cc: live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, jpoimboe@kernel.org, jikos@kernel.org,
 mbenes@suse.cz, pmladek@suse.com, joe.lawrence@redhat.com,
 nathan@kernel.org, morbo@google.com, justinstitt@google.com,
 mcgrof@kernel.org, thunder.leizhen@huawei.com, kees@kernel.org,
 kernel-team@meta.com, mmaurer@google.com, samitolvanen@google.com,
 mhiramat@kernel.org
Subject: Re: [PATCH v2 3/3] tracing/kprobes: Use APIs that matches symbols
 without .XXX suffix
Message-ID: <20240806144426.00ed349f@gandalf.local.home>
In-Reply-To: <20240802210836.2210140-4-song@kernel.org>
References: <20240802210836.2210140-1-song@kernel.org>
	<20240802210836.2210140-4-song@kernel.org>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri,  2 Aug 2024 14:08:35 -0700
Song Liu <song@kernel.org> wrote:

> Use the new kallsyms APIs that matches symbols name with .XXX
> suffix. This allows userspace tools to get kprobes on the expected
> function name, while the actual symbol has a .llvm.<hash> suffix.
> 
> This only effects kernel compile with CONFIG_LTO_CLANG.
> 
> Signed-off-by: Song Liu <song@kernel.org>
> ---
>  kernel/kprobes.c            |  6 +++++-
>  kernel/trace/trace_kprobe.c | 11 ++++++++++-
>  2 files changed, 15 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/kprobes.c b/kernel/kprobes.c
> index e85de37d9e1e..99102283b076 100644
> --- a/kernel/kprobes.c
> +++ b/kernel/kprobes.c
> @@ -70,7 +70,11 @@ static DEFINE_PER_CPU(struct kprobe *, kprobe_instance);
>  kprobe_opcode_t * __weak kprobe_lookup_name(const char *name,
>  					unsigned int __unused)
>  {
> -	return ((kprobe_opcode_t *)(kallsyms_lookup_name(name)));
> +	unsigned long addr = kallsyms_lookup_name(name);
> +
> +	if (IS_ENABLED(CONFIG_LTO_CLANG) && !addr)
> +		addr = kallsyms_lookup_name_without_suffix(name);
> +	return ((kprobe_opcode_t *)(addr));
>  }
>  
>  /*
> diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
> index 61a6da808203..d2ad0c561c83 100644
> --- a/kernel/trace/trace_kprobe.c
> +++ b/kernel/trace/trace_kprobe.c
> @@ -203,6 +203,10 @@ unsigned long trace_kprobe_address(struct trace_kprobe *tk)
>  	if (tk->symbol) {
>  		addr = (unsigned long)
>  			kallsyms_lookup_name(trace_kprobe_symbol(tk));
> +
> +		if (IS_ENABLED(CONFIG_LTO_CLANG) && !addr)
> +			addr = kallsyms_lookup_name_without_suffix(trace_kprobe_symbol(tk));
> +

So you do the lookup twice if this is enabled?

Why not just use "kallsyms_lookup_name_without_suffix()" the entire time,
and it should work just the same as "kallsyms_lookup_name()" if it's not
needed?

>  		if (addr)
>  			addr += tk->rp.kp.offset;
>  	} else {
> @@ -766,8 +770,13 @@ static unsigned int number_of_same_symbols(const char *mod, const char *func_nam
>  {
>  	struct sym_count_ctx ctx = { .count = 0, .name = func_name };
>  
> -	if (!mod)
> +	if (!mod) {
>  		kallsyms_on_each_match_symbol(count_symbols, func_name, &ctx.count);
> +		if (IS_ENABLED(CONFIG_LTO_CLANG) && !ctx.count) {
> +			kallsyms_on_each_match_symbol_without_suffix(
> +				count_symbols, func_name, &ctx.count);

Same here.

-- Steve

> +		}
> +	}
>  
>  	module_kallsyms_on_each_symbol(mod, count_mod_symbols, &ctx);
>  


