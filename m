Return-Path: <live-patching+bounces-532-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 73D4596638A
	for <lists+live-patching@lfdr.de>; Fri, 30 Aug 2024 15:58:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DA7A9B20B29
	for <lists+live-patching@lfdr.de>; Fri, 30 Aug 2024 13:58:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D4DA51B14F4;
	Fri, 30 Aug 2024 13:58:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="14esvp6w";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="PA1KOILx";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="14esvp6w";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="PA1KOILx"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D95B81AF4FE;
	Fri, 30 Aug 2024 13:58:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725026283; cv=none; b=ZfKuH0vLo+VaAukzAwNfahCtlv8omG1Gpgx8GmiItOapdLkxVxNyUInl87701PQ6P0Jg8Q4vhI5wvlCMdKmWlFbwJcrEhFXiY2xyc8+9jVtPuuhcOM1FRM1Yb4JcUZni0IRZqz69I0EW/AdhU+KY5a4zQNfPkQfVPHNRYvOWre4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725026283; c=relaxed/simple;
	bh=fNP/V7dYneE4KrBy5FIhrpMOmupW0xBkMLpX0tjt7ZY=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=jhMF5m1RATdmEDeE6P8HPZZBvPEKmN53t05ME01Y4ZSpR5blXzowI6a2TvNxxERAXm4kQAFn8ETS9HKenc/kTr9N2CCevAykRLtKr8JEvHtkQeTCS5TwRy/fPB/n0LC56o70KK89Vi7BxahdRn3I/ZbE7Z/2VNVMxVwPixflYs4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=14esvp6w; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=PA1KOILx; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=14esvp6w; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=PA1KOILx; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from pobox.suse.cz (unknown [10.100.2.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id C267621A3F;
	Fri, 30 Aug 2024 13:57:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1725026279; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=MfJEI21qPCGoeKZ7JbTIdFZ4xvDmSN0m0l1JyKtgXfE=;
	b=14esvp6wihncIn7uwdmhrx6M6d2XLBUcbyUsIM+LdyitLTSGkc6JzQWNHAc6su8SoJHDtW
	ELMQm2K1yPfaoPG9ABFKqQNPx9OURjftxbMmXcmzI9hVAMdIYDXdtswnHSxEZwcdhSwZ/A
	I42lawYqIpZC8tbSsxqbUEHQZXV/h8I=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1725026279;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=MfJEI21qPCGoeKZ7JbTIdFZ4xvDmSN0m0l1JyKtgXfE=;
	b=PA1KOILxne5tbPJSbiRs+J+3pRo6shJ6h5Y27oGU91XA296ZOhbbuJqgATjihaRsAeJYM8
	n8WvzRWvx2ZUiBCQ==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1725026279; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=MfJEI21qPCGoeKZ7JbTIdFZ4xvDmSN0m0l1JyKtgXfE=;
	b=14esvp6wihncIn7uwdmhrx6M6d2XLBUcbyUsIM+LdyitLTSGkc6JzQWNHAc6su8SoJHDtW
	ELMQm2K1yPfaoPG9ABFKqQNPx9OURjftxbMmXcmzI9hVAMdIYDXdtswnHSxEZwcdhSwZ/A
	I42lawYqIpZC8tbSsxqbUEHQZXV/h8I=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1725026279;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=MfJEI21qPCGoeKZ7JbTIdFZ4xvDmSN0m0l1JyKtgXfE=;
	b=PA1KOILxne5tbPJSbiRs+J+3pRo6shJ6h5Y27oGU91XA296ZOhbbuJqgATjihaRsAeJYM8
	n8WvzRWvx2ZUiBCQ==
Date: Fri, 30 Aug 2024 15:57:59 +0200 (CEST)
From: Miroslav Benes <mbenes@suse.cz>
To: Song Liu <song@kernel.org>
cc: live-patching@vger.kernel.org, linux-kernel@vger.kernel.org, 
    linux-trace-kernel@vger.kernel.org, jpoimboe@kernel.org, jikos@kernel.org, 
    pmladek@suse.com, joe.lawrence@redhat.com, nathan@kernel.org, 
    morbo@google.com, justinstitt@google.com, mcgrof@kernel.org, 
    thunder.leizhen@huawei.com, kees@kernel.org, kernel-team@meta.com, 
    mmaurer@google.com, samitolvanen@google.com, mhiramat@kernel.org, 
    rostedt@goodmis.org
Subject: Re: [PATCH v3 0/2] Fix kallsyms with CONFIG_LTO_CLANG
In-Reply-To: <20240807220513.3100483-1-song@kernel.org>
Message-ID: <alpine.LSU.2.21.2408301556120.1124@pobox.suse.cz>
References: <20240807220513.3100483-1-song@kernel.org>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Level: 
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[19];
	RCVD_COUNT_ZERO(0.00)[0];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	FROM_HAS_DN(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	TO_DN_SOME(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:email]
X-Spam-Score: -4.30
X-Spam-Flag: NO

Hi,

On Wed, 7 Aug 2024, Song Liu wrote:

> With CONFIG_LTO_CLANG, the compiler/linker adds .llvm.<hash> suffix to
> local symbols to avoid duplications. Existing scripts/kallsyms sorts
> symbols without .llvm.<hash> suffix. However, this causes quite some
> issues later on. Some users of kallsyms, such as livepatch, have to match
> symbols exactly.
> 
> Address this by sorting full symbols at build time, and let kallsyms
> lookup APIs to match the symbols exactly.
> 
> Changes v2 => v3:
> 1. Remove the _without_suffix APIs, as kprobe will not use them.
>    (Masami Hiramatsu)
> 
> v2: https://lore.kernel.org/live-patching/20240802210836.2210140-1-song@kernel.org/T/#u
> 
> Changes v1 => v2:
> 1. Update the APIs to remove all .XXX suffixes (v1 only removes .llvm.*).
> 2. Rename the APIs as *_without_suffix. (Masami Hiramatsu)
> 3. Fix another user from kprobe. (Masami Hiramatsu)
> 4. Add tests for the new APIs in kallsyms_selftests.
> 
> v1: https://lore.kernel.org/live-patching/20240730005433.3559731-1-song@kernel.org/T/#u
> 
> Song Liu (2):
>   kallsyms: Do not cleanup .llvm.<hash> suffix before sorting symbols
>   kallsyms: Match symbols exactly with CONFIG_LTO_CLANG
> 
>  kernel/kallsyms.c          | 55 +++++---------------------------------
>  kernel/kallsyms_selftest.c | 22 +--------------
>  scripts/kallsyms.c         | 31 ++-------------------
>  scripts/link-vmlinux.sh    |  4 ---
>  4 files changed, 9 insertions(+), 103 deletions(-)

I was on holiday most of August and the patch set has been merged but let 
me at least add

Acked-by: Miroslav Benes <mbenes@suse.cz>

here since I participated in the discussion at the beginning.

Thank you for cleaning it up!

Miroslav

