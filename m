Return-Path: <live-patching+bounces-2308-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id A6OJGIkn1GkwrwcAu9opvQ
	(envelope-from <live-patching+bounces-2308-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Mon, 06 Apr 2026 23:37:13 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id AE2593A794C
	for <lists+live-patching@lfdr.de>; Mon, 06 Apr 2026 23:37:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 9B8E8301DCD6
	for <lists+live-patching@lfdr.de>; Mon,  6 Apr 2026 21:37:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A157539C65F;
	Mon,  6 Apr 2026 21:37:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="nXcbK72i"
X-Original-To: live-patching@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E30E31D375;
	Mon,  6 Apr 2026 21:37:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775511428; cv=none; b=B6dv60BCTWZF6TNiPfRLiqqC3g3DlAhvh8c11Mq4pUDZL3kguk2Q2quWk7y6JW9rOby6GinHIZUMTJJIqe7vc2bzUYxIt62aLQBLiJqhwG+od/sig2bf1g1D3eBrJ/Hc5UEqF4Bf2+KrDA37H6CfcGhyjKVx4i11714Ki2S+Y9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775511428; c=relaxed/simple;
	bh=Edr+O/wyDNRSwTjfWwwo3iJRcLkp4FqgPH9it/1gUFg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sLzdE27fGovF3G7kfVi1VuI9qXp6u1jR2xJhy+9PtAoGAFRz0ywFHwc4YkSCSf2BtDpYoW5Kol2w/GzZDs6gsdZQ69YtKUTVAbqiZH5TY+lk7mvjcTDpkkRERBGretl0i2Af7zSP0ORUOJhMzqbMc1p3kyeodC19IjM5I/64xBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=nXcbK72i; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
	Message-ID:Sender:Reply-To:Content-ID:Content-Description;
	bh=REdg9oGBxbtYlBzrZT3ikKJfF2IDKrFyDR1UDvFouzI=; b=nXcbK72i3tGau6aazX/4c7lKMl
	xRW/T7tfxnSnEuyqDZ+tTmN/jKlfq9UlrDdupuorS23zNpxRDV9AKYZwudQZV1jHBPz8PuhN/nlzd
	xkeLyYlrhyKz33an2uKJr7guuiNN726RzeNa4Y1TTFDy/kFPn4UaB5CQvE4MyoGdI32wKHbuimHT4
	f7MQIcwWAumTc6Oeid/LTPhTkD4QnpUXosGtdJRoJgbOzrGf8VY18t5nCiDjC5GTZXZoOHlsvSgo+
	7EQBUuU0YvRmm640U7GahLY9sQw0hsQE6Snw9iwVKpVUYt7LwPO8PMXd1vDV/bp8hp+vGaPrA2TOl
	QPgNCWJQ==;
Received: from [50.53.43.113] (helo=[192.168.254.34])
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w9rcv-00000005XAd-0FNs;
	Mon, 06 Apr 2026 21:36:57 +0000
Message-ID: <99d9bb6f-443e-4cb2-9aa4-1eadf9ebbb7e@infradead.org>
Date: Mon, 6 Apr 2026 14:36:55 -0700
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/8] arm64, unwind: build kernel with sframe V3 info
To: Dylan Hatch <dylanbhatch@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Weinan Liu <wnliu@google.com>,
 Will Deacon <will@kernel.org>, Josh Poimboeuf <jpoimboe@kernel.org>,
 Indu Bhagat <indu.bhagat@oracle.com>, Peter Zijlstra <peterz@infradead.org>,
 Steven Rostedt <rostedt@goodmis.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Jiri Kosina <jikos@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>,
 Prasanna Kumar T S M <ptsm@linux.microsoft.com>,
 Puranjay Mohan <puranjay@kernel.org>, Song Liu <song@kernel.org>,
 joe.lawrence@redhat.com, linux-toolchains@vger.kernel.org,
 linux-kernel@vger.kernel.org, live-patching@vger.kernel.org,
 Jens Remus <jremus@linux.ibm.com>, linux-arm-kernel@lists.infradead.org
References: <20260406185000.1378082-1-dylanbhatch@google.com>
 <20260406185000.1378082-3-dylanbhatch@google.com>
Content-Language: en-US
From: Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <20260406185000.1378082-3-dylanbhatch@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[infradead.org,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[infradead.org:s=bombadil.20210309];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2308-lists,live-patching=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[20];
	DKIM_TRACE(0.00)[infradead.org:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[rdunlap@infradead.org,live-patching@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[live-patching];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: AE2593A794C
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr



On 4/6/26 11:49 AM, Dylan Hatch wrote:
> Build with -Wa,--gsframe-3 flags to generate a .sframe section. This
> will be used for in-kernel reliable stacktrace in cases where the frame
> pointer alone is insufficient.
> 
> Currently, the sframe format only supports arm64, x86_64 and s390x
> architectures.
> 
> Signed-off-by: Weinan Liu <wnliu@google.com>
> Signed-off-by: Dylan Hatch <dylanbhatch@google.com>
> Reviewed-by: Prasanna Kumar T S M <ptsm@linux.microsoft.com>
> ---
>  MAINTAINERS                            |  1 +
>  Makefile                               |  8 ++++++++
>  arch/Kconfig                           |  7 +++++++
>  arch/arm64/Kconfig                     |  1 +
>  arch/arm64/Kconfig.debug               | 13 +++++++++++++
>  arch/arm64/include/asm/unwind_sframe.h | 12 ++++++++++++
>  arch/arm64/kernel/vdso/Makefile        |  2 +-
>  include/asm-generic/vmlinux.lds.h      | 15 +++++++++++++++
>  8 files changed, 58 insertions(+), 1 deletion(-)
>  create mode 100644 arch/arm64/include/asm/unwind_sframe.h
> 


> diff --git a/arch/Kconfig b/arch/Kconfig
> index 6695c222c728..c87e489fa978 100644
> --- a/arch/Kconfig
> +++ b/arch/Kconfig
> @@ -520,6 +520,13 @@ config SFRAME_VALIDATION
>  
>  	  If unsure, say N.
>  
> +config ARCH_SUPPORTS_SFRAME_UNWINDER
> +	bool
> +	help
> +	  An architecture can select this if it  enables the sframe (Simple

	                         drop one space^^    (if it)
	
> +	  Frame) unwinder for unwinding kernel stack traces. It uses unwind

	                                                             an unwind

> +	  table that is directly generatedby toolchain based on DWARF CFI information.

	                         generated by the toolchain

> +
>  config HAVE_PERF_REGS
>  	bool
>  	help


> index 265c4461031f..df291d64812f 100644
> --- a/arch/arm64/Kconfig.debug
> +++ b/arch/arm64/Kconfig.debug
> @@ -20,4 +20,17 @@ config ARM64_RELOC_TEST
>  	depends on m
>  	tristate "Relocation testing module"
>  
> +config SFRAME_UNWINDER
> +	bool "Sframe unwinder"
> +	depends on AS_SFRAME3
> +	depends on 64BIT
> +	depends on ARCH_SUPPORTS_SFRAME_UNWINDER
> +	select SFRAME_LOOKUP
> +	help
> +	  This option enables the sframe (Simple Frame) unwinder for unwinding
> +	  kernel stack traces. It uses unwind table that is directly generated

	                          uses an unwind table

> +	  by toolchain based on DWARF CFI information. In, practice this can

	  by the toolchain

> +	  provide more reliable stacktrace results than unwinding with frame
> +	  pointers alone.
> +
>  source "drivers/hwtracing/coresight/Kconfig"


-- 
~Randy


