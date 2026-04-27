Return-Path: <live-patching+bounces-2560-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id mEE9B6Fs72kcBQEAu9opvQ
	(envelope-from <live-patching+bounces-2560-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Mon, 27 Apr 2026 16:03:13 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 30F80473F3C
	for <lists+live-patching@lfdr.de>; Mon, 27 Apr 2026 16:03:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 7121D315ECDB
	for <lists+live-patching@lfdr.de>; Mon, 27 Apr 2026 13:54:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8159E3DB656;
	Mon, 27 Apr 2026 13:51:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="PBFqn9Ej"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D5363DB632
	for <live-patching@vger.kernel.org>; Mon, 27 Apr 2026 13:51:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777297898; cv=none; b=tnnBkIugxMXWKHsADc2zH8gAmf6S5dP+fxhTSA6x4tphIrK2ZLGcM0pQOfml0gpjjcVy9LZ/FGbgpDjjFG25gdO2jm1fcMFW2Ub0Q712/h8KJ+IFDOAgATwagjx2yb7rj+eXLOOS1O+VBMq5FWfCaifx4hEiZfP17uZNR90d+6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777297898; c=relaxed/simple;
	bh=BUNNBL75JlgyYl1f+kaaTDb0zhLanoFrSlMfvZwNLkc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fVCh4bOAjqzMeiMdlRowWLYlnQMXMgnoLyVBCePKutPpMIl7k1mTxVNuXq03JirS9VQ3ppIymZcbfZdThaMT4muIN2nbiCmJ0cibQX9xlrNoQyOf/VbiJ5lfNsGzi47Fi79Fr6B7wKkP2YY5xHspO2m2WyHSZDhd9mniFhAW2GM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=PBFqn9Ej; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4891e5b9c1fso87298175e9.2
        for <live-patching@vger.kernel.org>; Mon, 27 Apr 2026 06:51:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1777297894; x=1777902694; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1cYp2AU5vjHi+KVV4ru0tdDsKrXMa/utyY7506Y2ajU=;
        b=PBFqn9Ej99m4KkvJ8FneieEJhPtjz8Dre/19vCy4gjNCnFA65ymFQRTqFt4cpMfLMN
         scKTMjBkZzWJTAhbGMDSDO/pIQ4vHdlgtEaTMS0afiUSDWOyR3HQhS7rbNWLD9STixpg
         sE5Ztq01/amMtW7QYJrtls1yaugp2JYJkULut9wu0d8Hsiyho+5zwTAWNtTJGGon8fY6
         T9GaDDtkR9cxQwExmrzoue/bs0ykVvCG1oWobIyDj/yp+S6NwDgEtU0RnE9SQnK8Ie0X
         o72gzs39ugs/hM/EWSQyaco/vZRMkpzBVaInlytWTb6xHAWhQ/g8ywVs+ItMoa4NYAFk
         8A8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777297894; x=1777902694;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1cYp2AU5vjHi+KVV4ru0tdDsKrXMa/utyY7506Y2ajU=;
        b=f/1bRDiyD2EsyqdvsD7cmcs+nAmqCAzbcozBxrRGLd3jaNb1DGBf2TXCC84KLRq1Fr
         IiATsPEdHVkze7m9iItFHnKaVxfKBbz5/eUtW+00A5WcjEtyZ6Co0BN+e9hHJS+E87mA
         uG9KgHJ5sfeET5LyPCSUxqpg24Q1ZVgzDjeEz5AajRsKZCkVAK323yBC7U1qjJwwCReg
         JgPZ3WeFwcaXOhjIwMQG3lfNY9UpJPKAD+MElzh6ZFEXJOfFrYuclm1ZUWblgJnzlnVi
         Ar96aLrscNx18/huRw78uvirc7WyEteYf33gZhBnfMfE96zMbbrMhiy5bNYIBAUNnYcL
         N4Fw==
X-Forwarded-Encrypted: i=1; AFNElJ/qI8kYgdnWqWhXIWrh09hRHsWjS3GBSN/DMhOFjVOPi+7cIcuEEXo9n52UZ7b+TNtr6/JsATosOZiM98vz@vger.kernel.org
X-Gm-Message-State: AOJu0YxoTW3no0eWoujZpusQlclzhqrP6hB+qeBCuxwgYOsxT6gwAfnf
	dEFxZL+jNOLYgKAHu0v4PK57e+uBwYQsIUwyt2t4fkHW2jLgWLT4it0AeTm4xxQejZc=
X-Gm-Gg: AeBDiev+0AwHUm0Ngr2CADOHc6TJKcNyzbLlyQ9ZY7egMAWDdx07qm013FBUtGVzGTZ
	8sDN0+mxMGnQsEdlVZ9kilw4OE3nPDzK6lA4B7jshVPf+563NjQhFY9wrMeKgvet/c2LIlOtC+n
	R7Gj3hbbIBYVgfQY59DrqxvvOb71wPofpvzpt/ExPTs+LvaVH5XHN0ynSZm5/GhGAoRpP/Ebgoi
	fjxc3HV+gV7qBuaoii7Q2tZfhnzVHsmJpYN0FVzxx1qFSUkSWFAPqJkwDq9p6//U6AtqYFGINKJ
	4TDcyCZyY09bsz/+GB8mtEfjiJREL4JFSrLPXzCP6BvcZO3BOhpjXa/ALSNAuGo89UbEOeD1x72
	puO5uZEavfyxbfH6QCwd0iGPCLYvgJfRFKwPPCdWtd7zz0PjECULYty0sc0f32RAlot1Nb1b2GD
	hpnfrZTgi3sGQg9NeDh+RAIwJXdo5Gi+qx0qNP2iJqOf2HNgpwS137VSDlIrL5Q9RK5A==
X-Received: by 2002:a05:600c:5297:b0:485:9a50:3370 with SMTP id 5b1f17b1804b1-488fb74a431mr664904745e9.8.1777297893506;
        Mon, 27 Apr 2026 06:51:33 -0700 (PDT)
Received: from [10.100.51.209] (nat2.prg.suse.com. [195.250.132.146])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48a5c4b9e8dsm119134175e9.7.2026.04.27.06.51.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Apr 2026 06:51:32 -0700 (PDT)
Message-ID: <88ae41dc-e5e0-442a-9b95-5125adf31e75@suse.com>
Date: Mon, 27 Apr 2026 15:51:31 +0200
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
 <11c8e139-f9f3-4b22-863a-4e021a3947e7@suse.com>
 <20260424091330.GA31168@wp.pl>
Content-Language: en-US
From: Petr Pavlu <petr.pavlu@suse.com>
In-Reply-To: <20260424091330.GA31168@wp.pl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 30F80473F3C
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[suse.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[suse.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-2560-lists,live-patching=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_TO(0.00)[wp.pl];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[suse.com:+];
	RCPT_COUNT_TWELVE(0.00)[13];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[petr.pavlu@suse.com,live-patching@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[live-patching];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,suse.com:dkim,suse.com:mid]

On 4/24/26 11:13 AM, Stanislaw Gruszka wrote:
> On Thu, Apr 23, 2026 at 04:00:04PM +0200, Petr Pavlu wrote:
>> On 3/27/26 12:00 PM, Stanislaw Gruszka wrote:
[...]
>>> diff --git a/kernel/module/kallsyms.c b/kernel/module/kallsyms.c
>>> index f23126d804b2..d69e99e67707 100644
>>> --- a/kernel/module/kallsyms.c
>>> +++ b/kernel/module/kallsyms.c
>>> @@ -10,6 +10,7 @@
>>>  #include <linux/kallsyms.h>
>>>  #include <linux/buildid.h>
>>>  #include <linux/bsearch.h>
>>> +#include <linux/sort.h>
>>>  #include "internal.h"
>>>  
>>>  /* Lookup exported symbol in given range of kernel_symbols */
>>> @@ -103,6 +104,95 @@ static bool is_core_symbol(const Elf_Sym *src, const Elf_Shdr *sechdrs,
>>>  	return true;
>>>  }
>>>  
>>> +static inline bool is_func_symbol(const Elf_Sym *sym)
>>> +{
>>> +	return sym->st_shndx != SHN_UNDEF && sym->st_size != 0 &&
>>> +	       ELF_ST_TYPE(sym->st_info) == STT_FUNC;
>>> +}
>>> +
>>> +static unsigned int bsearch_func_symbol(struct mod_kallsyms *kallsyms,
>>> +					unsigned long addr,
>>> +					unsigned long *bestval,
>>> +					unsigned long *nextval)
>>> +
>>> +{
>>> +	unsigned int mid, low = 1, high = kallsyms->num_func_syms + 1;
>>> +	unsigned int best = 0;
>>> +	unsigned long thisval;
>>> +
>>> +	while (low < high) {
>>> +		mid = low + (high - low) / 2;
>>> +		thisval = kallsyms_symbol_value(&kallsyms->symtab[mid]);
>>> +
>>> +		if (thisval <= addr) {
>>> +			*bestval = thisval;
>>> +			best = mid;
>>> +			low = mid + 1;
>>
>> If thisval == addr, the search moves to the right and finds the last
>> symbol with the same address. I believe it should do the opposite and
>> return the first symbol to match the behavior of
>> search_kallsyms_symbol().
> 
> In the case of multiple symbols sharing the same address, we have
> to pick one and ignore the others. I don’t think it matters much which
> one is chosen in practice. Also, I expect function symbol addresses
> to be unique, so this shouldn’t be a real issue.

I think that the code should consistently pick the same answer. If
someone uses aliases for their functions, the logic shouldn't
arbitrarily return one of them, but preferably the first one, which
should normally be the actual implementation.

> 
>>> +		} else {
>>> +			*nextval = thisval;
>>> +			high = mid;
>>> +		}
>>> +	}
>>> +
>>> +	return best;
>>> +}
>>> +
>>> +static const char *kallsyms_symbol_name(struct mod_kallsyms *kallsyms,
>>> +					unsigned int symnum)
>>> +{
>>> +	return kallsyms->strtab + kallsyms->symtab[symnum].st_name;
>>> +}
>>> +
>>> +static unsigned int search_kallsyms_symbol(struct mod_kallsyms *kallsyms,
>>> +					   unsigned long addr,
>>> +					   unsigned long *bestval,
>>> +					   unsigned long *nextval)
>>> +{
>>> +	unsigned int i, best = 0;
>>> +
>>> +	/*
>>> +	 * Scan for closest preceding symbol and next symbol. (ELF starts
>>> +	 * real symbols at 1). Skip the initial function symbols range
>>> +	 * if num_func_syms is non-zero, those are handled separately for
>>> +	 * the core TEXT segment lookup.
>>> +	 */
>>> +	for (i = 1 + kallsyms->num_func_syms; i < kallsyms->num_symtab; i++) {
>>> +		const Elf_Sym *sym = &kallsyms->symtab[i];
>>> +		unsigned long thisval = kallsyms_symbol_value(sym);
>>> +
>>> +		if (sym->st_shndx == SHN_UNDEF)
>>> +			continue;
>>> +
>>> +		/*
>>> +		 * We ignore unnamed symbols: they're uninformative
>>> +		 * and inserted at a whim.
>>> +		 */
>>> +		if (*kallsyms_symbol_name(kallsyms, i) == '\0' ||
>>> +		    is_mapping_symbol(kallsyms_symbol_name(kallsyms, i)))
>>> +			continue;
>>> +
>>> +		if (thisval <= addr && thisval > *bestval) {
>>> +			best = i;
>>> +			*bestval = thisval;
>>> +		}
>>> +		if (thisval > addr && thisval < *nextval)
>>> +			*nextval = thisval;
>>> +	}
>>> +
>>> +	return best;
>>> +}
>>> +
>>> +static int elf_sym_cmp(const void *a, const void *b)
>>> +{
>>> +	unsigned long val_a = kallsyms_symbol_value((const Elf_Sym *)a);
>>> +	unsigned long val_b = kallsyms_symbol_value((const Elf_Sym *)b);
>>> +
>>> +	if (val_a < val_b)
>>> +		return -1;
>>> +
>>> +	return val_a > val_b;
>>
>> Does this comparison function and the sort() call result in stable
>> sorting? If val_a and val_b are the same, the sorting should preserve
>> the original order.
> 
> The kernel’s sort() implementation is not stable.

Ok, I see it is a heapsort. It would require additional data to keep
information about the original indexes for elf_sym_cmp() to use as
a tiebreaker.

> 
>>> +}
>>> +
>>>  /*
>>>   * We only allocate and copy the strings needed by the parts of symtab
>>>   * we keep.  This is simple, but has the effect of making multiple
>>> @@ -115,9 +205,10 @@ void layout_symtab(struct module *mod, struct load_info *info)
>>>  	Elf_Shdr *symsect = info->sechdrs + info->index.sym;
>>>  	Elf_Shdr *strsect = info->sechdrs + info->index.str;
>>>  	const Elf_Sym *src;
>>> -	unsigned int i, nsrc, ndst, strtab_size = 0;
>>> +	unsigned int i, nsrc, ndst, nfunc, strtab_size = 0;
>>>  	struct module_memory *mod_mem_data = &mod->mem[MOD_DATA];
>>>  	struct module_memory *mod_mem_init_data = &mod->mem[MOD_INIT_DATA];
>>> +	bool is_lp_mod = is_livepatch_module(mod);
>>>  
>>>  	/* Put symbol section at end of init part of module. */
>>>  	symsect->sh_flags |= SHF_ALLOC;
>>> @@ -129,12 +220,14 @@ void layout_symtab(struct module *mod, struct load_info *info)
>>>  	nsrc = symsect->sh_size / sizeof(*src);
>>>  
>>>  	/* Compute total space required for the core symbols' strtab. */
>>> -	for (ndst = i = 0; i < nsrc; i++) {
>>> -		if (i == 0 || is_livepatch_module(mod) ||
>>> +	for (ndst = nfunc = i = 0; i < nsrc; i++) {
>>> +		if (i == 0 || is_lp_mod ||
>>>  		    is_core_symbol(src + i, info->sechdrs, info->hdr->e_shnum,
>>>  				   info->index.pcpu)) {
>>>  			strtab_size += strlen(&info->strtab[src[i].st_name]) + 1;
>>>  			ndst++;
>>> +			if (!is_lp_mod && is_func_symbol(src + i))
>>> +				nfunc++;
>>>  		}
>>>  	}
>>>  
>>> @@ -156,6 +249,7 @@ void layout_symtab(struct module *mod, struct load_info *info)
>>>  	mod_mem_init_data->size = ALIGN(mod_mem_init_data->size,
>>>  					__alignof__(struct mod_kallsyms));
>>>  	info->mod_kallsyms_init_off = mod_mem_init_data->size;
>>> +	info->num_func_syms = nfunc;
>>>  
>>>  	mod_mem_init_data->size += sizeof(struct mod_kallsyms);
>>>  	info->init_typeoffs = mod_mem_init_data->size;
>>> @@ -169,7 +263,7 @@ void layout_symtab(struct module *mod, struct load_info *info)
>>>   */
>>>  void add_kallsyms(struct module *mod, const struct load_info *info)
>>>  {
>>> -	unsigned int i, ndst;
>>> +	unsigned int i, di, nfunc, ndst;
>>>  	const Elf_Sym *src;
>>>  	Elf_Sym *dst;
>>>  	char *s;
>>> @@ -178,6 +272,7 @@ void add_kallsyms(struct module *mod, const struct load_info *info)
>>>  	void *data_base = mod->mem[MOD_DATA].base;
>>>  	void *init_data_base = mod->mem[MOD_INIT_DATA].base;
>>>  	struct mod_kallsyms *kallsyms;
>>> +	bool is_lp_mod = is_livepatch_module(mod);
>>>  
>>>  	kallsyms = init_data_base + info->mod_kallsyms_init_off;
>>
>> This code is followed by the initialization of kallsyms:
>>
>> 	kallsyms->symtab = (void *)symsec->sh_addr;
>> 	kallsyms->num_symtab = symsec->sh_size / sizeof(Elf_Sym);
>> 	/* Make sure we get permanent strtab: don't use info->strtab. */
>> 	kallsyms->strtab = (void *)info->sechdrs[info->index.str].sh_addr;
>> 	kallsyms->typetab = init_data_base + info->init_typeoffs;
>>
>> I suggest adding 'kallsyms->num_func_syms = 0;' after the initialization
>> of kallsyms->num_symtab.
> 
> I relied on zeroed memory initialization, but I can add this explicitly
> for clarity.
> 
>>> @@ -194,19 +289,28 @@ void add_kallsyms(struct module *mod, const struct load_info *info)
>>>  	mod->core_kallsyms.symtab = dst = data_base + info->symoffs;
>>>  	mod->core_kallsyms.strtab = s = data_base + info->stroffs;
>>>  	mod->core_kallsyms.typetab = data_base + info->core_typeoffs;
>>> +
>>>  	strtab_size = info->core_typeoffs - info->stroffs;
>>>  	src = kallsyms->symtab;
>>> -	for (ndst = i = 0; i < kallsyms->num_symtab; i++) {
>>> +	ndst = info->num_func_syms + 1;
>>> +
>>> +	for (nfunc = i = 0; i < kallsyms->num_symtab; i++) {
>>>  		kallsyms->typetab[i] = elf_type(src + i, info);
>>> -		if (i == 0 || is_livepatch_module(mod) ||
>>> +		if (i == 0 || is_lp_mod ||
>>>  		    is_core_symbol(src + i, info->sechdrs, info->hdr->e_shnum,
>>>  				   info->index.pcpu)) {
>>>  			ssize_t ret;
>>>  
>>> -			mod->core_kallsyms.typetab[ndst] =
>>> -				kallsyms->typetab[i];
>>> -			dst[ndst] = src[i];
>>> -			dst[ndst++].st_name = s - mod->core_kallsyms.strtab;
>>> +			if (i == 0)
>>> +				di = 0;
>>> +			else if (!is_lp_mod && is_func_symbol(src + i))
>>> +				di = 1 + nfunc++;
>>> +			else
>>> +				di = ndst++;
>>> +
>>> +			mod->core_kallsyms.typetab[di] = kallsyms->typetab[i];
>>> +			dst[di] = src[i];
>>> +			dst[di].st_name = s - mod->core_kallsyms.strtab;
>>>  			ret = strscpy(s, &kallsyms->strtab[src[i].st_name],
>>>  				      strtab_size);
>>>  			if (ret < 0)
>>> @@ -216,9 +320,13 @@ void add_kallsyms(struct module *mod, const struct load_info *info)
>>>  		}
>>>  	}
>>>  
>>> +	WARN_ON_ONCE(nfunc != info->num_func_syms);
>>> +	sort(dst + 1, nfunc, sizeof(Elf_Sym), elf_sym_cmp, NULL);
>>> +
>>
>> The code sorts mod->core_kallsyms.symtab but mod->core_kallsyms.typetab
>> is not reordered accordingly.
> 
> Right, but for function symbols the typetab entries are all 't',
> so swapping them does not change the type value. The 'T' vs 't'
> distinction is handled later when printing (based on export status).
> But the comment explaining skiping adjusting of
> mod->core_kallsyms.typetab is needed.

Modules can also contain weak functions with elf_type() = 'w'.

> 
>>>  	/* Set up to point into init section. */
>>>  	rcu_assign_pointer(mod->kallsyms, kallsyms);
>>>  	mod->core_kallsyms.num_symtab = ndst;
>>> +	mod->core_kallsyms.num_func_syms = nfunc;
>>>  }
>>>  
>>>  #if IS_ENABLED(CONFIG_STACKTRACE_BUILD_ID)
>>> @@ -241,11 +349,6 @@ void init_build_id(struct module *mod, const struct load_info *info)
>>>  }
>>>  #endif
>>>  
>>> -static const char *kallsyms_symbol_name(struct mod_kallsyms *kallsyms, unsigned int symnum)
>>> -{
>>> -	return kallsyms->strtab + kallsyms->symtab[symnum].st_name;
>>> -}
>>> -
>>>  /*
>>>   * Given a module and address, find the corresponding symbol and return its name
>>>   * while providing its size and offset if needed.
>>> @@ -255,7 +358,10 @@ static const char *find_kallsyms_symbol(struct module *mod,
>>>  					unsigned long *size,
>>>  					unsigned long *offset)
>>>  {
>>> -	unsigned int i, best = 0;
>>> +	unsigned int (*search)(struct mod_kallsyms *kallsyms,
>>> +			       unsigned long addr, unsigned long *bestval,
>>> +			       unsigned long *nextval);
>>> +	unsigned int best;
>>>  	unsigned long nextval, bestval;
>>>  	struct mod_kallsyms *kallsyms = rcu_dereference(mod->kallsyms);
>>>  	struct module_memory *mod_mem = NULL;
>>> @@ -266,6 +372,11 @@ static const char *find_kallsyms_symbol(struct module *mod,
>>>  			continue;
>>>  #endif
>>>  		if (within_module_mem_type(addr, mod, type)) {
>>> +			if (type == MOD_TEXT && kallsyms->num_func_syms > 0)
>>> +				search = bsearch_func_symbol;
>>
>> I'm not sure if it is ok to limit the search only to function symbols
>> when the address lies in MOD_TEXT. The text can theoretically contain
>> non-function symbols.
> 
> Yes, the patch assumes that the only valid symbols in the MOD_TEXT
> are functions. If there are defined OBJECT symbols in .text, the patch
> would break lookup for those.
> 
> While it’s theoretically possible (e.g. hand-written assembly placing
> data in .text ?), I’m not sure this is a practical concern. In general,
> having data in executable segments is discouraged for security reasons. 
> 
>> Could this optimization be adjusted to sort all
>> MOD_TEXT symbols (excluding anonymous and mapping symbols) and move them
>> to the front of the symbol table?
> 
> That’s possible. We could track .text sections indices in
> __layout_sections() and include all valid symbols from those sections,
> and also reorder typetab accordingly.
> 
> However, this adds complexity. I would prefer to first confirm whether
> OBJECT symbols in MOD_TEXT is a real issue before going in that direction.

I'm not aware of specific OBJECT symbols that end up in MOD_TEXT.
Nonetheless, it is a valid case and it is preferable that an
optimization doesn't break their lookup by address.

In general, I'm worried about the several edge cases and inconsistencies
that this optimization introduces. This also includes the fact that it
doesn't work for livepatch modules.

An alternative could be to keep the symbol table untouched and have
a separate array with symbol indexes that is sorted by their addresses,
but it requires evaluation if the additional memory usage is worth it.

-- 
Thanks,
Petr

