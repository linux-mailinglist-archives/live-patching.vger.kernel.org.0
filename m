Return-Path: <live-patching+bounces-422-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BF0949412C2
	for <lists+live-patching@lfdr.de>; Tue, 30 Jul 2024 15:04:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E73AA1C22DE5
	for <lists+live-patching@lfdr.de>; Tue, 30 Jul 2024 13:04:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 86FF21EEE0;
	Tue, 30 Jul 2024 13:04:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kfHN9phs"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5857F623;
	Tue, 30 Jul 2024 13:04:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722344665; cv=none; b=KadhSg9JOSSQlgPTTtag6XYl0eQz+YdqDKZR+5i20RBWdUAzwP5vM3RQjHAE4NKKXisVu6XDLq2p9MqhRkGAWXaY+tl28aUuaGv6EEkUehj1Oj6gctH79wAQ6UhLjBdqmLVGp302+oM6nmVXkQ+mNX67/GgNJ1pymdpElt/yNSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722344665; c=relaxed/simple;
	bh=Vds91/wtGjgWmouaxLlCIsUy+law5p/u5wFwIQDfHaU=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=EW9oSL/IFAS/VnrES/0WsOqGzLWhrRln/sQZXBLQXSiv4dKJUVF4U2fG1y5aMnDR9lASEkvWJ+IgjhzbO3k2teU3sDq9UK/dA6XebfT+auN+uHlf/o+S5FaIA2mAWnwujbREnYz+5TXFdChZDq0DP6Zg2+ocAbEiPNI0qlcj+ag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kfHN9phs; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 210EFC32782;
	Tue, 30 Jul 2024 13:04:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722344664;
	bh=Vds91/wtGjgWmouaxLlCIsUy+law5p/u5wFwIQDfHaU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=kfHN9phsPk9frydWNCHlfkOLGu1hsD7bZCcTVbqpHQnGCM41VuzFJjkYE2djFG/uU
	 2uQNIzZEO4uRvgdwdthH5H8IGcbtGoX+ECVQ7fnSmod/4yUb+NuLhkvM5n34ZEzfAH
	 3hmavpi+iGBFebQcExbEO1JQAuTUVuJgVuQId4WL+Bx6QxwllIXLF6S73YIb/h9OFN
	 X8WN8M8qvMoZNG4Fxy0d5lpg6G3GUvkFch1inmJZhaWgfPsUgQHnX/uBIhEx8+Boew
	 L0NAa7sO5Ufy370etXsv1fB27rAPYtcQLMAv8SU1XjK1QMAutFY5nt8cwOOhv71z42
	 bhpJniyvcYe8Q==
Date: Tue, 30 Jul 2024 22:04:17 +0900
From: Masami Hiramatsu (Google) <mhiramat@kernel.org>
To: Song Liu <song@kernel.org>
Cc: live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, jpoimboe@kernel.org, jikos@kernel.org,
 mbenes@suse.cz, pmladek@suse.com, joe.lawrence@redhat.com,
 nathan@kernel.org, morbo@google.com, justinstitt@google.com,
 mcgrof@kernel.org, thunder.leizhen@huawei.com, kees@kernel.org,
 kernel-team@meta.com, mmaurer@google.com, samitolvanen@google.com,
 mhiramat@kernel.org, rostedt@goodmis.org
Subject: Re: [PATCH 3/3] tracing/kprobes: Use APIs that matches symbols with
 .llvm.<hash> suffix
Message-Id: <20240730220417.33bd5f0d75c3742c413136d1@kernel.org>
In-Reply-To: <20240730005433.3559731-4-song@kernel.org>
References: <20240730005433.3559731-1-song@kernel.org>
	<20240730005433.3559731-4-song@kernel.org>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 29 Jul 2024 17:54:33 -0700
Song Liu <song@kernel.org> wrote:

> Use the new kallsyms APIs that matches symbols name with .llvm.<hash>
> suffix. This allows userspace tools to get kprobes on the expected
> function name, while the actual symbol has a .llvm.<hash> suffix.
> 

_kprobe_addr@kernel/kprobes.c may also fail with this change.

Thanks,

> This only effects kernel compared with CONFIG_LTO_CLANG.
> 
> Signed-off-by: Song Liu <song@kernel.org>
> ---
>  kernel/trace/trace_kprobe.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
> index 61a6da808203..c319382c1a09 100644
> --- a/kernel/trace/trace_kprobe.c
> +++ b/kernel/trace/trace_kprobe.c
> @@ -202,7 +202,8 @@ unsigned long trace_kprobe_address(struct trace_kprobe *tk)
>  
>  	if (tk->symbol) {
>  		addr = (unsigned long)
> -			kallsyms_lookup_name(trace_kprobe_symbol(tk));
> +			kallsyms_lookup_name_or_prefix(trace_kprobe_symbol(tk));
> +
>  		if (addr)
>  			addr += tk->rp.kp.offset;
>  	} else {
> @@ -766,8 +767,13 @@ static unsigned int number_of_same_symbols(const char *mod, const char *func_nam
>  {
>  	struct sym_count_ctx ctx = { .count = 0, .name = func_name };
>  
> -	if (!mod)
> +	if (!mod) {
>  		kallsyms_on_each_match_symbol(count_symbols, func_name, &ctx.count);
> +		if (IS_ENABLED(CONFIG_LTO_CLANG) && !ctx.count) {
> +			kallsyms_on_each_match_symbol_or_prefix(
> +				count_symbols, func_name, &ctx.count);
> +		}
> +	}
>  
>  	module_kallsyms_on_each_symbol(mod, count_mod_symbols, &ctx);
>  
> -- 
> 2.43.0
> 


-- 
Masami Hiramatsu (Google) <mhiramat@kernel.org>

