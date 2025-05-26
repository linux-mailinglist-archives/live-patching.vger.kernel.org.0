Return-Path: <live-patching+bounces-1466-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 23C9BAC43B3
	for <lists+live-patching@lfdr.de>; Mon, 26 May 2025 20:27:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E7D9C1659DB
	for <lists+live-patching@lfdr.de>; Mon, 26 May 2025 18:27:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC42823DEAD;
	Mon, 26 May 2025 18:27:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="fsCw3/Oj"
X-Original-To: live-patching@vger.kernel.org
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22F082DCC0C;
	Mon, 26 May 2025 18:27:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748284054; cv=none; b=ZamH2oqezIBep1giHNyyYjcTkP54MrY4b68nxfPNIR9Py/W2HCEqPwse10FY7qau/VrnMPi18RkdGCAn/icx9n53czaCD4yur2PKWf6p7ZAyGGA16HQr7BDDj9I0rjli03dgSEnljbJRgd/NK2CDqoOg9GOgMZgNPZMfFtJ4arM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748284054; c=relaxed/simple;
	bh=RRotaVVE021Cy/Fbxyicu6e1jQ87dRW6abAc/YZVlu4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=i92lSuqY78N2fyxBEiVU/FzjfGMGSCDIJiW2UMB+EhK8Uo2NCMr+cTjpWa2qviNdo7Um3S9VvEO6VQb0Dc7kijLxm4fGq7p8V13RCxNeoQKObQjGblK7BAWDel6by3EPI878qXHRh8INSUTAveiidH++xQpN3QGlRl+o/2xJ1MQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=fsCw3/Oj; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=VUavDUGfEVWk2Egd/2qR9/xJOtTm7q6qZFShbXmDSsc=; b=fsCw3/OjG+gGCbfHbExFyOzhGz
	SS2xQUS6eUw+mmchKKHIPnLtE74ORTr6pV70+7hpB98rIPumAho7avYtS0lOHx95tNr4m8nEzqPQ4
	lHeDRQPwIcKPlI9PgB9a78RidtzYG0HbnM05cU7rDqdFEHBkiICZGlvqhdo2tmO95FTJFQYLAmB2Y
	o/YMgnUSTYmUWxZchkl/MVdhF1dfUPyYLpAcspaizFoEJNh74mwa0hPg17ssFz5fcUUI8KNw6jVaY
	s42PegUbiRUcwN0Rnm/oRKp30/gGX2ygvRfp5NX1Up9xPhp32krAv2B1eIeOK5Ysd/bB6KCQj36lg
	l0wu+47Q==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uJcXf-00000001y9F-3gum;
	Mon, 26 May 2025 18:27:20 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 624D4300472; Mon, 26 May 2025 20:27:19 +0200 (CEST)
Date: Mon, 26 May 2025 20:27:19 +0200
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
Subject: Re: [PATCH v2 52/62] objtool/klp: Introduce klp diff subcommand for
 diffing object files
Message-ID: <20250526182719.GR24938@noisy.programming.kicks-ass.net>
References: <cover.1746821544.git.jpoimboe@kernel.org>
 <f6ffe58daf771670a6732fd0f741ca83b19ee253.1746821544.git.jpoimboe@kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f6ffe58daf771670a6732fd0f741ca83b19ee253.1746821544.git.jpoimboe@kernel.org>

On Fri, May 09, 2025 at 01:17:16PM -0700, Josh Poimboeuf wrote:
> diff --git a/tools/objtool/arch/x86/decode.c b/tools/objtool/arch/x86/decode.c
> index cdf385e54c69..ae4f83fcbadf 100644
> --- a/tools/objtool/arch/x86/decode.c
> +++ b/tools/objtool/arch/x86/decode.c
> @@ -95,6 +95,46 @@ s64 arch_insn_adjusted_addend(struct instruction *insn, struct reloc *reloc)
>  	return phys_to_virt(addend);
>  }
>  
> +static void scan_for_insn(struct section *sec, unsigned long offset,
> +			  unsigned long *insn_off, unsigned int *insn_len)
> +{
> +	unsigned long o = 0;
> +	struct insn insn;
> +
> +	while (1) {
> +
> +		insn_decode(&insn, sec->data->d_buf + o, sec_size(sec) - o,
> +			    INSN_MODE_64);
> +
> +		if (o + insn.length > offset) {
> +			*insn_off = o;
> +			*insn_len = insn.length;
> +			return;
> +		}
> +
> +		o += insn.length;
> +	}
> +}
> +
> +u64 arch_adjusted_addend(struct reloc *reloc)
> +{
> +	unsigned int type = reloc_type(reloc);
> +	s64 addend = reloc_addend(reloc);
> +	unsigned long insn_off;
> +	unsigned int insn_len;
> +
> +	if (type == R_X86_64_PLT32)
> +		return addend + 4;
> +
> +	if (type != R_X86_64_PC32 || !is_text_sec(reloc->sec->base))
> +		return addend;
> +
> +	scan_for_insn(reloc->sec->base, reloc_offset(reloc),
> +		      &insn_off, &insn_len);
> +
> +	return addend + insn_off + insn_len - reloc_offset(reloc);
> +}

This looks like a rather expensive proposition; it will have to decode
the section nr_reloc times.

Does it not make more sense to fully decode the section like 'normal' ?

