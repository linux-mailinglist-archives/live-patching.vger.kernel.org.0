Return-Path: <live-patching+bounces-439-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 58030947C24
	for <lists+live-patching@lfdr.de>; Mon,  5 Aug 2024 15:46:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0F5AA1F219AE
	for <lists+live-patching@lfdr.de>; Mon,  5 Aug 2024 13:46:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 52FDE3A1C9;
	Mon,  5 Aug 2024 13:45:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ekGjk3mS"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24697175A5;
	Mon,  5 Aug 2024 13:45:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722865552; cv=none; b=AigGFl70P2iaLIe5WlvR5KAs6nDAvPtzkHwbmB1E0IB25BQEKo35DMoL8eUkDMnOlDnsS8/oQ3d9LRv966JS1Q0Ptn0YgIsHhXhfMaAf3+lfcODyrdFDsD8ynIwdVkXTpCE/XnKd2odgfol+6UkQTMV8Eg1I0/mXyV2KZ2jVcDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722865552; c=relaxed/simple;
	bh=keSREImhSQR78gJomMJZgGaRF0sCwHZLVIDuIOHWJ/Q=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=H4aA6WDTT7OSaagUXv9K/a80WnEH0btV8Cu/DkB6cpdzJumhgrNEzFg2xfyh+Hc5bvrDl4oy97KGTVY82dVpW+khIl7O2pRY+2Onhj2EvvlPCvSALOoWMk9Fw8JaC9JS1t6KD4VDa1RtfaKje6g2E50nBkmzQZ4Eyg7lld3WyMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ekGjk3mS; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50F28C32782;
	Mon,  5 Aug 2024 13:45:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722865551;
	bh=keSREImhSQR78gJomMJZgGaRF0sCwHZLVIDuIOHWJ/Q=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=ekGjk3mS5nseP6C7INEC3zE49Ivk0nWL6Ie9lCsDuqvOvphwfxKy2KWoSEk9QcPyt
	 sXmeS3B+sBWpbXmmkj64TcFMggj3sfB5UcfsGwMKxZEqv+CkGb42o0sIt6IhOYaDoK
	 uv2ULb/4WRc7VlQdJ5Xzs+d32wAabDe+FhkmnC8V4G1XJ0IfwFeFXZulGOfK5ROPF9
	 Aq5KGzfymgjSPDuZFxoFiDBsXHomgTOt19pR1sNYHjdnkzwBrRLVUtYxuqBasoOHpD
	 4bSCxB1Q3iMSkP+BP7TV9Ihjf3qkUSlCXsAWvFcw/9pYYDeu8BwbPOlTeigmXRL9vx
	 2sAQ/K2Y1CKKg==
Date: Mon, 5 Aug 2024 22:45:44 +0900
From: Masami Hiramatsu (Google) <mhiramat@kernel.org>
To: Song Liu <song@kernel.org>
Cc: live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, jpoimboe@kernel.org, jikos@kernel.org,
 mbenes@suse.cz, pmladek@suse.com, joe.lawrence@redhat.com,
 nathan@kernel.org, morbo@google.com, justinstitt@google.com,
 mcgrof@kernel.org, thunder.leizhen@huawei.com, kees@kernel.org,
 kernel-team@meta.com, mmaurer@google.com, samitolvanen@google.com,
 mhiramat@kernel.org, rostedt@goodmis.org
Subject: Re: [PATCH v2 2/3] kallsyms: Add APIs to match symbol without .XXXX
 suffix.
Message-Id: <20240805224544.e0a4277dff4ac41d867c6bc1@kernel.org>
In-Reply-To: <20240802210836.2210140-3-song@kernel.org>
References: <20240802210836.2210140-1-song@kernel.org>
	<20240802210836.2210140-3-song@kernel.org>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri,  2 Aug 2024 14:08:34 -0700
Song Liu <song@kernel.org> wrote:

> With CONFIG_LTO_CLANG=y, the compiler may add suffix to function names
> to avoid duplication. This causes confusion with users of kallsyms.
> On one hand, users like livepatch are required to match the symbols
> exactly. On the other hand, users like kprobe would like to match to
> original function names.
> 
> Solve this by splitting kallsyms APIs. Specifically, existing APIs now
> should match the symbols exactly. Add two APIs that match only the part
> without .XXXX suffix. Specifically, the following two APIs are added.
> 
> 1. kallsyms_lookup_name_without_suffix()
> 2. kallsyms_on_each_match_symbol_without_suffix()
> 
> These APIs will be used by kprobe.
> 
> Also cleanup some code and update kallsyms_selftests accordingly.
> 
> Signed-off-by: Song Liu <song@kernel.org>

Looks good to me, but I have a nitpick. 


> --- a/kernel/kallsyms.c
> +++ b/kernel/kallsyms.c
> @@ -164,30 +164,27 @@ static void cleanup_symbol_name(char *s)
>  {
>  	char *res;
>  
> -	if (!IS_ENABLED(CONFIG_LTO_CLANG))
> -		return;
> -
>  	/*
>  	 * LLVM appends various suffixes for local functions and variables that
>  	 * must be promoted to global scope as part of LTO.  This can break
>  	 * hooking of static functions with kprobes. '.' is not a valid
> -	 * character in an identifier in C. Suffixes only in LLVM LTO observed:
> -	 * - foo.llvm.[0-9a-f]+
> +	 * character in an identifier in C, so we can just remove the
> +	 * suffix.
>  	 */
> -	res = strstr(s, ".llvm.");
> +	res = strstr(s, ".");

nit: "strchr(s, '.')" ?

Anyway,

Reviewed-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>

Thank you,


-- 
Masami Hiramatsu (Google) <mhiramat@kernel.org>

