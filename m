Return-Path: <live-patching+bounces-2485-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id CIDBJIkm6mnwvAIAu9opvQ
	(envelope-from <live-patching+bounces-2485-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Thu, 23 Apr 2026 16:02:49 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 1A86545369F
	for <lists+live-patching@lfdr.de>; Thu, 23 Apr 2026 16:02:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 600BD3032995
	for <lists+live-patching@lfdr.de>; Thu, 23 Apr 2026 14:00:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A0F0E2F0C48;
	Thu, 23 Apr 2026 14:00:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="FMpo88C1"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3A042EA154
	for <live-patching@vger.kernel.org>; Thu, 23 Apr 2026 14:00:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776952812; cv=none; b=aEdaeedNWJu1d/lAvj4flJTNqVLnoSKKHXCHVH5qaHs/9UuyTNiJqL+I8FC3N4kY3/nffLD56W6ROBA9opAY0c5J+gSSgBQ/NKe4asT8ytSiDL1HuPFnR4puhWvrftD2Q7bWdr/dD2Sc2ExT2yJFOdKJ7Vz7zrWircsPv5D8R4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776952812; c=relaxed/simple;
	bh=e6wZXuQNZj/lX9I9qWia7hKXHCqhnnmYtXf6RYXsHNg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qPRrC/7uDAyNympELi3VTrTe0I0K7gIXYipnaMk+NcgkBD4rf21dBnTozc7WmxbjoYa3fckvdAjKBSozRuX1Ra7n/0jGkhC0V35l0yNTCzexAYrB3cBEBYpndqLPFHdgJi77X1j9fgdnvdh2kiIJg9dvzgUlAKsqEo+ArWHzcRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=FMpo88C1; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-43d64313c39so5240703f8f.3
        for <live-patching@vger.kernel.org>; Thu, 23 Apr 2026 07:00:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1776952807; x=1777557607; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=XRQ+3xe0xHI/qgQNJnJ3B7Leq+8E0R1UPebMSgZhgzM=;
        b=FMpo88C1KZXh+i0ReTiYxHQn+drFez/cF1qEd6tWtMJhU5VqricSWUO5RAUiDVqz3C
         cAk6AVO81wJz9tcHUfDsVOyvcPkQcXoRWnurtgfm5vv1SkHL/dSSVQ5BRbWMS5f0yn0m
         aXTNq9kCFmUJoxRPGliUc4oGanUifw4sZcNrbUPiKQmAoLIZPqZIIjvHJGZ2yy5VVpns
         j5dpf+7ZD/N4dqruc1KPxdh1NE3kDLYhQwkjJEFVI/hCmoiZli2N48wqSHsBhyooseTj
         coeBxSln9/PAGyC/hqBq2A3WkUjaFHDDElCZcezBjeW7x+5XuwOnnOK0PAOvTDcH72yp
         /37Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776952807; x=1777557607;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XRQ+3xe0xHI/qgQNJnJ3B7Leq+8E0R1UPebMSgZhgzM=;
        b=EJll+MqK7HUryDV0j/SsYQCR09ogXT28GLJQL1JpZ2gu9ua1U2gOiCPXYDnYFw3pmK
         /7aBDdcutfXbvYkDo5h7Q6c2bwpiz3ejdMijRkVmjfT3tuUurVQmOp8T6+s8EU9EyWQh
         FULxczLnAWvuoZ0/Wdi5LK1I0epDoXrgs3H5Nf9IWXyC5yi3G9/mJwfuKURfLiPXAglK
         75+1nVzQ4iLleeBBA6bX/PYtc8eWY9tYHqCMPy6i3T6Bh2kUPCumQAtFjYNYmgElK0yj
         zLlcR0uVt87M1drJKyzzzXiRZthmAmYxRABLfpD6JSXZNcfbg76HqS1pvXYa2XNTIrDD
         mn8g==
X-Forwarded-Encrypted: i=1; AFNElJ9wejq6hhNs3FSfER8o1LNuLGTzOR4hMfS6F59JRjRuKXwxN1CAQqYaUWKE+wUtM/5K2DBlYfIC++qU/4ur@vger.kernel.org
X-Gm-Message-State: AOJu0YznrDPtfke6ceAxpxB+BogI+3H5Kxt9fMGJtd//kTIf4u1ogbXn
	tCZrAGixFBYxKZAirGk2weiC757oLVBVR8WGbbItYDGui0KjM7SyLV6vwrtztnelPZw=
X-Gm-Gg: AeBDietdQg7n65zaM56pASva0eEPNJWVKbLdItiOTBxzhn+anzRagXdR3Fs7zEElNBZ
	nBUMIiy6PfTyymKnPT57oYoUT7nL/Fyxx1mmxIcAiq8pncb+22ojHpvND787HCd6gjCby5XAUiI
	6CEjWLJSiKqG6Xg95AZ6m4IM/2zSM7SpPZzhbICnkJUv1Y0tH+Z4gAevksy2bD1+WH3Ven7T1NH
	z3swZJLV1gO+oGoaeK2hXteN/zqgKt3vVroSBquym3ZkimvFGVDEbLnF16YCGVvYmIOOvfIeXZZ
	vZMWSLemooP6ZvYbEpUD8pV8Cy2FsIAmghSekwy/zwJoBC5lZ8X7A8AT7SX8l8V4RN2ECkm78Ch
	rkvW9izarZbyP8J+IbIQ5FQtrwDOvbojmuZCKphT+IFGXgKh0XXeaR4YT/dW92AWrhDguh9/ESP
	6YHIohc/kz35bNXY19WRM4iBhPbBggBaYzHp/7kIgxdMiRMQm3ysJZvyQ=
X-Received: by 2002:a5d:5f92:0:b0:43b:9c73:2933 with SMTP id ffacd0b85a97d-43fe3dc1795mr42546195f8f.15.1776952806300;
        Thu, 23 Apr 2026 07:00:06 -0700 (PDT)
Received: from [10.100.51.209] (nat2.prg.suse.com. [195.250.132.146])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43fe4cb1176sm54804409f8f.3.2026.04.23.07.00.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Apr 2026 07:00:05 -0700 (PDT)
Message-ID: <11c8e139-f9f3-4b22-863a-4e021a3947e7@suse.com>
Date: Thu, 23 Apr 2026 16:00:04 +0200
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] module/kallsyms: sort function symbols and use
 binary search
To: Stanislaw Gruszka <stf_xl@wp.pl>
Cc: linux-modules@vger.kernel.org, Sami Tolvanen <samitolvanen@google.com>,
 Luis Chamberlain <mcgrof@kernel.org>, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, live-patching@vger.kernel.org,
 Daniel Gomez <da.gomez@kernel.org>, Aaron Tomlin <atomlin@atomlin.com>,
 Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu
 <mhiramat@kernel.org>, Jordan Rome <linux@jordanrome.com>,
 Viktor Malik <vmalik@redhat.com>
References: <20260327110005.16499-1-stf_xl@wp.pl>
 <20260327110005.16499-2-stf_xl@wp.pl>
Content-Language: en-US
From: Petr Pavlu <petr.pavlu@suse.com>
In-Reply-To: <20260327110005.16499-2-stf_xl@wp.pl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[suse.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[suse.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[13];
	TAGGED_FROM(0.00)[bounces-2485-lists,live-patching=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_TO(0.00)[wp.pl];
	DKIM_TRACE(0.00)[suse.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	MAILSPIKE_FAIL(0.00)[2600:3c0a:e001:db::12fc:5321:query timed out];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[petr.pavlu@suse.com,live-patching@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	DBL_BLOCKED_OPENRESOLVER(0.00)[wp.pl:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,nano:email]
X-Rspamd-Queue-Id: 1A86545369F
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On 3/27/26 12:00 PM, Stanislaw Gruszka wrote:
> Module symbol lookup via find_kallsyms_symbol() performs a linear scan
> over the entire symtab when resolving an address. The number of symbols
> in module symtabs has grown over the years, largely due to additional
> metadata in non-standard sections, making this lookup very slow.
> 
> Improve this by separating function symbols during module load, placing
> them at the beginning of the symtab, sorting them by address, and using
> binary search when resolving addresses in module text.
> 
> This also should improve times for linear symbol name lookups, as valid
> function symbols are now located at the beginning of the symtab.
> 
> The cost of sorting is small relative to module load time. In repeated
> module load tests [1], depending on .config options, this change
> increases load time between 2% and 4%. With cold caches, the difference
> is not measurable, as memory access latency dominates.
> 
> The sorting theoretically could be done in compile time, but much more
> complicated as we would have to simulate kernel addresses resolution
> for symbols, and then correct relocation entries. That would be risky
> if get out of sync.
> 
> The improvement can be observed when listing ftrace filter functions.
> 
> Before:
> 
> root@nano:~# time cat /sys/kernel/tracing/available_filter_functions | wc -l
> 74908
> 
> real	0m1.315s
> user	0m0.000s
> sys	0m1.312s
> 
> After:
> 
> root@nano:~# time cat /sys/kernel/tracing/available_filter_functions | wc -l
> 74911
> 
> real	0m0.167s
> user	0m0.004s
> sys	0m0.175s
> 
> (there are three more symbols introduced by the patch)
> 
> For livepatch modules, the symtab layout is preserved and the existing
> linear search is used. For this case, it should be possible to keep
> the original ELF symtab instead of copying it 1:1, but that is outside
> the scope of this patch.
> 
> Link: https://gist.github.com/sgruszka/09f3fb1dad53a97b1aad96e1927ab117 [1]
> Signed-off-by: Stanislaw Gruszka <stf_xl@wp.pl>

Sorry for the delay reviewing this patch.

> ---
> v1 -> v2: 
>  - fix searching data symbols for CONFIG_KALLSYMS_ALL
>  - use kallsyms_symbol_value() in elf_sym_cmp()
> 
>  include/linux/module.h   |   1 +
>  kernel/module/internal.h |   1 +
>  kernel/module/kallsyms.c | 171 +++++++++++++++++++++++++++++----------
>  3 files changed, 130 insertions(+), 43 deletions(-)
> 
> diff --git a/include/linux/module.h b/include/linux/module.h
> index ac254525014c..67c053afa882 100644
> --- a/include/linux/module.h
> +++ b/include/linux/module.h
> @@ -379,6 +379,7 @@ struct module_memory {
>  struct mod_kallsyms {
>  	Elf_Sym *symtab;
>  	unsigned int num_symtab;
> +	unsigned int num_func_syms;
>  	char *strtab;
>  	char *typetab;
>  };
> diff --git a/kernel/module/internal.h b/kernel/module/internal.h
> index 618202578b42..6a4d498619b1 100644
> --- a/kernel/module/internal.h
> +++ b/kernel/module/internal.h
> @@ -73,6 +73,7 @@ struct load_info {
>  	bool sig_ok;
>  #ifdef CONFIG_KALLSYMS
>  	unsigned long mod_kallsyms_init_off;
> +	unsigned long num_func_syms;
>  #endif
>  #ifdef CONFIG_MODULE_DECOMPRESS
>  #ifdef CONFIG_MODULE_STATS
> diff --git a/kernel/module/kallsyms.c b/kernel/module/kallsyms.c
> index f23126d804b2..d69e99e67707 100644
> --- a/kernel/module/kallsyms.c
> +++ b/kernel/module/kallsyms.c
> @@ -10,6 +10,7 @@
>  #include <linux/kallsyms.h>
>  #include <linux/buildid.h>
>  #include <linux/bsearch.h>
> +#include <linux/sort.h>
>  #include "internal.h"
>  
>  /* Lookup exported symbol in given range of kernel_symbols */
> @@ -103,6 +104,95 @@ static bool is_core_symbol(const Elf_Sym *src, const Elf_Shdr *sechdrs,
>  	return true;
>  }
>  
> +static inline bool is_func_symbol(const Elf_Sym *sym)
> +{
> +	return sym->st_shndx != SHN_UNDEF && sym->st_size != 0 &&
> +	       ELF_ST_TYPE(sym->st_info) == STT_FUNC;
> +}
> +
> +static unsigned int bsearch_func_symbol(struct mod_kallsyms *kallsyms,
> +					unsigned long addr,
> +					unsigned long *bestval,
> +					unsigned long *nextval)
> +
> +{
> +	unsigned int mid, low = 1, high = kallsyms->num_func_syms + 1;
> +	unsigned int best = 0;
> +	unsigned long thisval;
> +
> +	while (low < high) {
> +		mid = low + (high - low) / 2;
> +		thisval = kallsyms_symbol_value(&kallsyms->symtab[mid]);
> +
> +		if (thisval <= addr) {
> +			*bestval = thisval;
> +			best = mid;
> +			low = mid + 1;

If thisval == addr, the search moves to the right and finds the last
symbol with the same address. I believe it should do the opposite and
return the first symbol to match the behavior of
search_kallsyms_symbol().

> +		} else {
> +			*nextval = thisval;
> +			high = mid;
> +		}
> +	}
> +
> +	return best;
> +}
> +
> +static const char *kallsyms_symbol_name(struct mod_kallsyms *kallsyms,
> +					unsigned int symnum)
> +{
> +	return kallsyms->strtab + kallsyms->symtab[symnum].st_name;
> +}
> +
> +static unsigned int search_kallsyms_symbol(struct mod_kallsyms *kallsyms,
> +					   unsigned long addr,
> +					   unsigned long *bestval,
> +					   unsigned long *nextval)
> +{
> +	unsigned int i, best = 0;
> +
> +	/*
> +	 * Scan for closest preceding symbol and next symbol. (ELF starts
> +	 * real symbols at 1). Skip the initial function symbols range
> +	 * if num_func_syms is non-zero, those are handled separately for
> +	 * the core TEXT segment lookup.
> +	 */
> +	for (i = 1 + kallsyms->num_func_syms; i < kallsyms->num_symtab; i++) {
> +		const Elf_Sym *sym = &kallsyms->symtab[i];
> +		unsigned long thisval = kallsyms_symbol_value(sym);
> +
> +		if (sym->st_shndx == SHN_UNDEF)
> +			continue;
> +
> +		/*
> +		 * We ignore unnamed symbols: they're uninformative
> +		 * and inserted at a whim.
> +		 */
> +		if (*kallsyms_symbol_name(kallsyms, i) == '\0' ||
> +		    is_mapping_symbol(kallsyms_symbol_name(kallsyms, i)))
> +			continue;
> +
> +		if (thisval <= addr && thisval > *bestval) {
> +			best = i;
> +			*bestval = thisval;
> +		}
> +		if (thisval > addr && thisval < *nextval)
> +			*nextval = thisval;
> +	}
> +
> +	return best;
> +}
> +
> +static int elf_sym_cmp(const void *a, const void *b)
> +{
> +	unsigned long val_a = kallsyms_symbol_value((const Elf_Sym *)a);
> +	unsigned long val_b = kallsyms_symbol_value((const Elf_Sym *)b);
> +
> +	if (val_a < val_b)
> +		return -1;
> +
> +	return val_a > val_b;

Does this comparison function and the sort() call result in stable
sorting? If val_a and val_b are the same, the sorting should preserve
the original order.

> +}
> +
>  /*
>   * We only allocate and copy the strings needed by the parts of symtab
>   * we keep.  This is simple, but has the effect of making multiple
> @@ -115,9 +205,10 @@ void layout_symtab(struct module *mod, struct load_info *info)
>  	Elf_Shdr *symsect = info->sechdrs + info->index.sym;
>  	Elf_Shdr *strsect = info->sechdrs + info->index.str;
>  	const Elf_Sym *src;
> -	unsigned int i, nsrc, ndst, strtab_size = 0;
> +	unsigned int i, nsrc, ndst, nfunc, strtab_size = 0;
>  	struct module_memory *mod_mem_data = &mod->mem[MOD_DATA];
>  	struct module_memory *mod_mem_init_data = &mod->mem[MOD_INIT_DATA];
> +	bool is_lp_mod = is_livepatch_module(mod);
>  
>  	/* Put symbol section at end of init part of module. */
>  	symsect->sh_flags |= SHF_ALLOC;
> @@ -129,12 +220,14 @@ void layout_symtab(struct module *mod, struct load_info *info)
>  	nsrc = symsect->sh_size / sizeof(*src);
>  
>  	/* Compute total space required for the core symbols' strtab. */
> -	for (ndst = i = 0; i < nsrc; i++) {
> -		if (i == 0 || is_livepatch_module(mod) ||
> +	for (ndst = nfunc = i = 0; i < nsrc; i++) {
> +		if (i == 0 || is_lp_mod ||
>  		    is_core_symbol(src + i, info->sechdrs, info->hdr->e_shnum,
>  				   info->index.pcpu)) {
>  			strtab_size += strlen(&info->strtab[src[i].st_name]) + 1;
>  			ndst++;
> +			if (!is_lp_mod && is_func_symbol(src + i))
> +				nfunc++;
>  		}
>  	}
>  
> @@ -156,6 +249,7 @@ void layout_symtab(struct module *mod, struct load_info *info)
>  	mod_mem_init_data->size = ALIGN(mod_mem_init_data->size,
>  					__alignof__(struct mod_kallsyms));
>  	info->mod_kallsyms_init_off = mod_mem_init_data->size;
> +	info->num_func_syms = nfunc;
>  
>  	mod_mem_init_data->size += sizeof(struct mod_kallsyms);
>  	info->init_typeoffs = mod_mem_init_data->size;
> @@ -169,7 +263,7 @@ void layout_symtab(struct module *mod, struct load_info *info)
>   */
>  void add_kallsyms(struct module *mod, const struct load_info *info)
>  {
> -	unsigned int i, ndst;
> +	unsigned int i, di, nfunc, ndst;
>  	const Elf_Sym *src;
>  	Elf_Sym *dst;
>  	char *s;
> @@ -178,6 +272,7 @@ void add_kallsyms(struct module *mod, const struct load_info *info)
>  	void *data_base = mod->mem[MOD_DATA].base;
>  	void *init_data_base = mod->mem[MOD_INIT_DATA].base;
>  	struct mod_kallsyms *kallsyms;
> +	bool is_lp_mod = is_livepatch_module(mod);
>  
>  	kallsyms = init_data_base + info->mod_kallsyms_init_off;

This code is followed by the initialization of kallsyms:

	kallsyms->symtab = (void *)symsec->sh_addr;
	kallsyms->num_symtab = symsec->sh_size / sizeof(Elf_Sym);
	/* Make sure we get permanent strtab: don't use info->strtab. */
	kallsyms->strtab = (void *)info->sechdrs[info->index.str].sh_addr;
	kallsyms->typetab = init_data_base + info->init_typeoffs;

I suggest adding 'kallsyms->num_func_syms = 0;' after the initialization
of kallsyms->num_symtab.

>  
> @@ -194,19 +289,28 @@ void add_kallsyms(struct module *mod, const struct load_info *info)
>  	mod->core_kallsyms.symtab = dst = data_base + info->symoffs;
>  	mod->core_kallsyms.strtab = s = data_base + info->stroffs;
>  	mod->core_kallsyms.typetab = data_base + info->core_typeoffs;
> +
>  	strtab_size = info->core_typeoffs - info->stroffs;
>  	src = kallsyms->symtab;
> -	for (ndst = i = 0; i < kallsyms->num_symtab; i++) {
> +	ndst = info->num_func_syms + 1;
> +
> +	for (nfunc = i = 0; i < kallsyms->num_symtab; i++) {
>  		kallsyms->typetab[i] = elf_type(src + i, info);
> -		if (i == 0 || is_livepatch_module(mod) ||
> +		if (i == 0 || is_lp_mod ||
>  		    is_core_symbol(src + i, info->sechdrs, info->hdr->e_shnum,
>  				   info->index.pcpu)) {
>  			ssize_t ret;
>  
> -			mod->core_kallsyms.typetab[ndst] =
> -				kallsyms->typetab[i];
> -			dst[ndst] = src[i];
> -			dst[ndst++].st_name = s - mod->core_kallsyms.strtab;
> +			if (i == 0)
> +				di = 0;
> +			else if (!is_lp_mod && is_func_symbol(src + i))
> +				di = 1 + nfunc++;
> +			else
> +				di = ndst++;
> +
> +			mod->core_kallsyms.typetab[di] = kallsyms->typetab[i];
> +			dst[di] = src[i];
> +			dst[di].st_name = s - mod->core_kallsyms.strtab;
>  			ret = strscpy(s, &kallsyms->strtab[src[i].st_name],
>  				      strtab_size);
>  			if (ret < 0)
> @@ -216,9 +320,13 @@ void add_kallsyms(struct module *mod, const struct load_info *info)
>  		}
>  	}
>  
> +	WARN_ON_ONCE(nfunc != info->num_func_syms);
> +	sort(dst + 1, nfunc, sizeof(Elf_Sym), elf_sym_cmp, NULL);
> +

The code sorts mod->core_kallsyms.symtab but mod->core_kallsyms.typetab
is not reordered accordingly.

>  	/* Set up to point into init section. */
>  	rcu_assign_pointer(mod->kallsyms, kallsyms);
>  	mod->core_kallsyms.num_symtab = ndst;
> +	mod->core_kallsyms.num_func_syms = nfunc;
>  }
>  
>  #if IS_ENABLED(CONFIG_STACKTRACE_BUILD_ID)
> @@ -241,11 +349,6 @@ void init_build_id(struct module *mod, const struct load_info *info)
>  }
>  #endif
>  
> -static const char *kallsyms_symbol_name(struct mod_kallsyms *kallsyms, unsigned int symnum)
> -{
> -	return kallsyms->strtab + kallsyms->symtab[symnum].st_name;
> -}
> -
>  /*
>   * Given a module and address, find the corresponding symbol and return its name
>   * while providing its size and offset if needed.
> @@ -255,7 +358,10 @@ static const char *find_kallsyms_symbol(struct module *mod,
>  					unsigned long *size,
>  					unsigned long *offset)
>  {
> -	unsigned int i, best = 0;
> +	unsigned int (*search)(struct mod_kallsyms *kallsyms,
> +			       unsigned long addr, unsigned long *bestval,
> +			       unsigned long *nextval);
> +	unsigned int best;
>  	unsigned long nextval, bestval;
>  	struct mod_kallsyms *kallsyms = rcu_dereference(mod->kallsyms);
>  	struct module_memory *mod_mem = NULL;
> @@ -266,6 +372,11 @@ static const char *find_kallsyms_symbol(struct module *mod,
>  			continue;
>  #endif
>  		if (within_module_mem_type(addr, mod, type)) {
> +			if (type == MOD_TEXT && kallsyms->num_func_syms > 0)
> +				search = bsearch_func_symbol;

I'm not sure if it is ok to limit the search only to function symbols
when the address lies in MOD_TEXT. The text can theoretically contain
non-function symbols. Could this optimization be adjusted to sort all
MOD_TEXT symbols (excluding anonymous and mapping symbols) and move them
to the front of the symbol table?

> +			else
> +				search = search_kallsyms_symbol;
> +
>  			mod_mem = &mod->mem[type];
>  			break;
>  		}
> @@ -278,33 +389,7 @@ static const char *find_kallsyms_symbol(struct module *mod,
>  	nextval = (unsigned long)mod_mem->base + mod_mem->size;
>  	bestval = (unsigned long)mod_mem->base - 1;
>  
> -	/*
> -	 * Scan for closest preceding symbol, and next symbol. (ELF
> -	 * starts real symbols at 1).
> -	 */
> -	for (i = 1; i < kallsyms->num_symtab; i++) {
> -		const Elf_Sym *sym = &kallsyms->symtab[i];
> -		unsigned long thisval = kallsyms_symbol_value(sym);
> -
> -		if (sym->st_shndx == SHN_UNDEF)
> -			continue;
> -
> -		/*
> -		 * We ignore unnamed symbols: they're uninformative
> -		 * and inserted at a whim.
> -		 */
> -		if (*kallsyms_symbol_name(kallsyms, i) == '\0' ||
> -		    is_mapping_symbol(kallsyms_symbol_name(kallsyms, i)))
> -			continue;
> -
> -		if (thisval <= addr && thisval > bestval) {
> -			best = i;
> -			bestval = thisval;
> -		}
> -		if (thisval > addr && thisval < nextval)
> -			nextval = thisval;
> -	}
> -
> +	best = search(kallsyms, addr, &bestval, &nextval);
>  	if (!best)
>  		return NULL;
>  

-- 
Thanks,
Petr

