Return-Path: <live-patching+bounces-2509-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id eAf8M00062lfJwAAu9opvQ
	(envelope-from <live-patching+bounces-2509-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Fri, 24 Apr 2026 11:13:49 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 274C445BF9E
	for <lists+live-patching@lfdr.de>; Fri, 24 Apr 2026 11:13:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id B620330157E8
	for <lists+live-patching@lfdr.de>; Fri, 24 Apr 2026 09:13:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1480D38837E;
	Fri, 24 Apr 2026 09:13:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wp.pl header.i=@wp.pl header.b="dwpOoCj8"
X-Original-To: live-patching@vger.kernel.org
Received: from mx4.wp.pl (mx4.wp.pl [212.77.101.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 781402853EE
	for <live-patching@vger.kernel.org>; Fri, 24 Apr 2026 09:13:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.77.101.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777022023; cv=none; b=dQMH65TXylAR0bbeO9s07YBOSXlCLBMegMdHq3gX+HMLQ0MRROhaF3yGa04l9LpHqrtbcSISkQfN5Ee9iebUBePpjYD/Lap1MDgZXYlv4w0dR9JmeNX+uJk0dRPqWo3bcejwqIFUclzU90Ghi52sq8Ymb1a3NuX+E/pjodZ6J7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777022023; c=relaxed/simple;
	bh=QLDylG+k3URMzkymEsBsYoASE6AccSEHWVeWYLXLDu8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cqEwHlPsEodC1bju+1sdrznI82Na+H49pssLuru/vwgDFkn65+Rx+j7VTDILPQCh7BTKnNep+CcWg4FcnSpRqUaHE1oGAaS2JTvnM5Lh7ZkwonnFph1eoDrd/qIKO98XB7XG8DW8pactRIALAKUOj4bGCIddf0lBP+vN33F5+Wg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=wp.pl; spf=pass smtp.mailfrom=wp.pl; dkim=pass (2048-bit key) header.d=wp.pl header.i=@wp.pl header.b=dwpOoCj8; arc=none smtp.client-ip=212.77.101.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=wp.pl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wp.pl
Received: (wp-smtpd smtp.wp.pl 18993 invoked from network); 24 Apr 2026 11:13:31 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=20241105;
          t=1777022011; bh=Loakni+WnkQFdW/+oPUntQhNd0Jq6bZYEe2YfX/DRmo=;
          h=From:To:Cc:Subject;
          b=dwpOoCj8anKOkpLJHo8O2rVGAYpJ7B6WY14ovMMVaj12H5AMnKyNkPqmbcB/Ah8Vf
           FtUWU6gt8Elq3//bk1IR1oo6ekW/g4ubmQJkRVIcYzn7xbiwSsQwwv80+7q7WzSpEA
           Tb66EU5VubclJXklK5YSLuuZP2gD7EAwEJSqL6kB81EdchBNhOw71vCqsarbMBuNQ/
           kt6VGvjUjPgPbhcOM5aaHNngc6hnaOrCREY6IzHXHA6ZWEmUNeeNvb07W2vL3LmP44
           nLiJ/NQ91gkh0HjsAcM4drVRSr2cw+L1cdXp5Zm8hATee33N4NLuGBAiWUSUqcL1Vp
           8uOum9Ysl9Kig==
Received: from krzysztof152.net.autocom.pl (HELO localhost) (stf_xl@wp.pl@[77.236.6.64])
          (envelope-sender <stf_xl@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with TLS_AES_256_GCM_SHA384 encrypted SMTP
          for <petr.pavlu@suse.com>; 24 Apr 2026 11:13:31 +0200
Date: Fri, 24 Apr 2026 11:13:30 +0200
From: Stanislaw Gruszka <stf_xl@wp.pl>
To: Petr Pavlu <petr.pavlu@suse.com>
Cc: linux-modules@vger.kernel.org, Sami Tolvanen <samitolvanen@google.com>,
	Luis Chamberlain <mcgrof@kernel.org>, linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org, live-patching@vger.kernel.org,
	Daniel Gomez <da.gomez@kernel.org>,
	Aaron Tomlin <atomlin@atomlin.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Jordan Rome <linux@jordanrome.com>,
	Viktor Malik <vmalik@redhat.com>
Subject: Re: [PATCH v2 2/2] module/kallsyms: sort function symbols and use
 binary search
Message-ID: <20260424091330.GA31168@wp.pl>
References: <20260327110005.16499-1-stf_xl@wp.pl>
 <20260327110005.16499-2-stf_xl@wp.pl>
 <11c8e139-f9f3-4b22-863a-4e021a3947e7@suse.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <11c8e139-f9f3-4b22-863a-4e021a3947e7@suse.com>
X-WP-MailID: d4c7e2535986542932cd1e849df36f68
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 0000002 [IUES]                               
X-Rspamd-Queue-Id: 274C445BF9E
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[wp.pl,none];
	R_DKIM_ALLOW(-0.20)[wp.pl:s=20241105];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-2509-lists,live-patching=lfdr.de];
	FREEMAIL_FROM(0.00)[wp.pl];
	RCPT_COUNT_TWELVE(0.00)[13];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[stf_xl@wp.pl,live-patching@vger.kernel.org];
	DKIM_TRACE(0.00)[wp.pl:+];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	TAGGED_RCPT(0.00)[live-patching];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,wp.pl:email,wp.pl:dkim,wp.pl:mid]

Hi Petr,

thanks for the review.

On Thu, Apr 23, 2026 at 04:00:04PM +0200, Petr Pavlu wrote:
> On 3/27/26 12:00 PM, Stanislaw Gruszka wrote:
> > Module symbol lookup via find_kallsyms_symbol() performs a linear scan
> > over the entire symtab when resolving an address. The number of symbols
> > in module symtabs has grown over the years, largely due to additional
> > metadata in non-standard sections, making this lookup very slow.
> > 
> > Improve this by separating function symbols during module load, placing
> > them at the beginning of the symtab, sorting them by address, and using
> > binary search when resolving addresses in module text.
> > 
> > This also should improve times for linear symbol name lookups, as valid
> > function symbols are now located at the beginning of the symtab.
> > 
> > The cost of sorting is small relative to module load time. In repeated
> > module load tests [1], depending on .config options, this change
> > increases load time between 2% and 4%. With cold caches, the difference
> > is not measurable, as memory access latency dominates.
> > 
> > The sorting theoretically could be done in compile time, but much more
> > complicated as we would have to simulate kernel addresses resolution
> > for symbols, and then correct relocation entries. That would be risky
> > if get out of sync.
> > 
> > The improvement can be observed when listing ftrace filter functions.
> > 
> > Before:
> > 
> > root@nano:~# time cat /sys/kernel/tracing/available_filter_functions | wc -l
> > 74908
> > 
> > real	0m1.315s
> > user	0m0.000s
> > sys	0m1.312s
> > 
> > After:
> > 
> > root@nano:~# time cat /sys/kernel/tracing/available_filter_functions | wc -l
> > 74911
> > 
> > real	0m0.167s
> > user	0m0.004s
> > sys	0m0.175s
> > 
> > (there are three more symbols introduced by the patch)
> > 
> > For livepatch modules, the symtab layout is preserved and the existing
> > linear search is used. For this case, it should be possible to keep
> > the original ELF symtab instead of copying it 1:1, but that is outside
> > the scope of this patch.
> > 
> > Link: https://gist.github.com/sgruszka/09f3fb1dad53a97b1aad96e1927ab117 [1]
> > Signed-off-by: Stanislaw Gruszka <stf_xl@wp.pl>
> 
> Sorry for the delay reviewing this patch.

No problem.

> > ---
> > v1 -> v2: 
> >  - fix searching data symbols for CONFIG_KALLSYMS_ALL
> >  - use kallsyms_symbol_value() in elf_sym_cmp()
> > 
> >  include/linux/module.h   |   1 +
> >  kernel/module/internal.h |   1 +
> >  kernel/module/kallsyms.c | 171 +++++++++++++++++++++++++++++----------
> >  3 files changed, 130 insertions(+), 43 deletions(-)
> > 
> > diff --git a/include/linux/module.h b/include/linux/module.h
> > index ac254525014c..67c053afa882 100644
> > --- a/include/linux/module.h
> > +++ b/include/linux/module.h
> > @@ -379,6 +379,7 @@ struct module_memory {
> >  struct mod_kallsyms {
> >  	Elf_Sym *symtab;
> >  	unsigned int num_symtab;
> > +	unsigned int num_func_syms;
> >  	char *strtab;
> >  	char *typetab;
> >  };
> > diff --git a/kernel/module/internal.h b/kernel/module/internal.h
> > index 618202578b42..6a4d498619b1 100644
> > --- a/kernel/module/internal.h
> > +++ b/kernel/module/internal.h
> > @@ -73,6 +73,7 @@ struct load_info {
> >  	bool sig_ok;
> >  #ifdef CONFIG_KALLSYMS
> >  	unsigned long mod_kallsyms_init_off;
> > +	unsigned long num_func_syms;
> >  #endif
> >  #ifdef CONFIG_MODULE_DECOMPRESS
> >  #ifdef CONFIG_MODULE_STATS
> > diff --git a/kernel/module/kallsyms.c b/kernel/module/kallsyms.c
> > index f23126d804b2..d69e99e67707 100644
> > --- a/kernel/module/kallsyms.c
> > +++ b/kernel/module/kallsyms.c
> > @@ -10,6 +10,7 @@
> >  #include <linux/kallsyms.h>
> >  #include <linux/buildid.h>
> >  #include <linux/bsearch.h>
> > +#include <linux/sort.h>
> >  #include "internal.h"
> >  
> >  /* Lookup exported symbol in given range of kernel_symbols */
> > @@ -103,6 +104,95 @@ static bool is_core_symbol(const Elf_Sym *src, const Elf_Shdr *sechdrs,
> >  	return true;
> >  }
> >  
> > +static inline bool is_func_symbol(const Elf_Sym *sym)
> > +{
> > +	return sym->st_shndx != SHN_UNDEF && sym->st_size != 0 &&
> > +	       ELF_ST_TYPE(sym->st_info) == STT_FUNC;
> > +}
> > +
> > +static unsigned int bsearch_func_symbol(struct mod_kallsyms *kallsyms,
> > +					unsigned long addr,
> > +					unsigned long *bestval,
> > +					unsigned long *nextval)
> > +
> > +{
> > +	unsigned int mid, low = 1, high = kallsyms->num_func_syms + 1;
> > +	unsigned int best = 0;
> > +	unsigned long thisval;
> > +
> > +	while (low < high) {
> > +		mid = low + (high - low) / 2;
> > +		thisval = kallsyms_symbol_value(&kallsyms->symtab[mid]);
> > +
> > +		if (thisval <= addr) {
> > +			*bestval = thisval;
> > +			best = mid;
> > +			low = mid + 1;
> 
> If thisval == addr, the search moves to the right and finds the last
> symbol with the same address. I believe it should do the opposite and
> return the first symbol to match the behavior of
> search_kallsyms_symbol().

In the case of multiple symbols sharing the same address, we have
to pick one and ignore the others. I don’t think it matters much which
one is chosen in practice. Also, I expect function symbol addresses
to be unique, so this shouldn’t be a real issue.

> > +		} else {
> > +			*nextval = thisval;
> > +			high = mid;
> > +		}
> > +	}
> > +
> > +	return best;
> > +}
> > +
> > +static const char *kallsyms_symbol_name(struct mod_kallsyms *kallsyms,
> > +					unsigned int symnum)
> > +{
> > +	return kallsyms->strtab + kallsyms->symtab[symnum].st_name;
> > +}
> > +
> > +static unsigned int search_kallsyms_symbol(struct mod_kallsyms *kallsyms,
> > +					   unsigned long addr,
> > +					   unsigned long *bestval,
> > +					   unsigned long *nextval)
> > +{
> > +	unsigned int i, best = 0;
> > +
> > +	/*
> > +	 * Scan for closest preceding symbol and next symbol. (ELF starts
> > +	 * real symbols at 1). Skip the initial function symbols range
> > +	 * if num_func_syms is non-zero, those are handled separately for
> > +	 * the core TEXT segment lookup.
> > +	 */
> > +	for (i = 1 + kallsyms->num_func_syms; i < kallsyms->num_symtab; i++) {
> > +		const Elf_Sym *sym = &kallsyms->symtab[i];
> > +		unsigned long thisval = kallsyms_symbol_value(sym);
> > +
> > +		if (sym->st_shndx == SHN_UNDEF)
> > +			continue;
> > +
> > +		/*
> > +		 * We ignore unnamed symbols: they're uninformative
> > +		 * and inserted at a whim.
> > +		 */
> > +		if (*kallsyms_symbol_name(kallsyms, i) == '\0' ||
> > +		    is_mapping_symbol(kallsyms_symbol_name(kallsyms, i)))
> > +			continue;
> > +
> > +		if (thisval <= addr && thisval > *bestval) {
> > +			best = i;
> > +			*bestval = thisval;
> > +		}
> > +		if (thisval > addr && thisval < *nextval)
> > +			*nextval = thisval;
> > +	}
> > +
> > +	return best;
> > +}
> > +
> > +static int elf_sym_cmp(const void *a, const void *b)
> > +{
> > +	unsigned long val_a = kallsyms_symbol_value((const Elf_Sym *)a);
> > +	unsigned long val_b = kallsyms_symbol_value((const Elf_Sym *)b);
> > +
> > +	if (val_a < val_b)
> > +		return -1;
> > +
> > +	return val_a > val_b;
> 
> Does this comparison function and the sort() call result in stable
> sorting? If val_a and val_b are the same, the sorting should preserve
> the original order.

The kernel’s sort() implementation is not stable.

> > +}
> > +
> >  /*
> >   * We only allocate and copy the strings needed by the parts of symtab
> >   * we keep.  This is simple, but has the effect of making multiple
> > @@ -115,9 +205,10 @@ void layout_symtab(struct module *mod, struct load_info *info)
> >  	Elf_Shdr *symsect = info->sechdrs + info->index.sym;
> >  	Elf_Shdr *strsect = info->sechdrs + info->index.str;
> >  	const Elf_Sym *src;
> > -	unsigned int i, nsrc, ndst, strtab_size = 0;
> > +	unsigned int i, nsrc, ndst, nfunc, strtab_size = 0;
> >  	struct module_memory *mod_mem_data = &mod->mem[MOD_DATA];
> >  	struct module_memory *mod_mem_init_data = &mod->mem[MOD_INIT_DATA];
> > +	bool is_lp_mod = is_livepatch_module(mod);
> >  
> >  	/* Put symbol section at end of init part of module. */
> >  	symsect->sh_flags |= SHF_ALLOC;
> > @@ -129,12 +220,14 @@ void layout_symtab(struct module *mod, struct load_info *info)
> >  	nsrc = symsect->sh_size / sizeof(*src);
> >  
> >  	/* Compute total space required for the core symbols' strtab. */
> > -	for (ndst = i = 0; i < nsrc; i++) {
> > -		if (i == 0 || is_livepatch_module(mod) ||
> > +	for (ndst = nfunc = i = 0; i < nsrc; i++) {
> > +		if (i == 0 || is_lp_mod ||
> >  		    is_core_symbol(src + i, info->sechdrs, info->hdr->e_shnum,
> >  				   info->index.pcpu)) {
> >  			strtab_size += strlen(&info->strtab[src[i].st_name]) + 1;
> >  			ndst++;
> > +			if (!is_lp_mod && is_func_symbol(src + i))
> > +				nfunc++;
> >  		}
> >  	}
> >  
> > @@ -156,6 +249,7 @@ void layout_symtab(struct module *mod, struct load_info *info)
> >  	mod_mem_init_data->size = ALIGN(mod_mem_init_data->size,
> >  					__alignof__(struct mod_kallsyms));
> >  	info->mod_kallsyms_init_off = mod_mem_init_data->size;
> > +	info->num_func_syms = nfunc;
> >  
> >  	mod_mem_init_data->size += sizeof(struct mod_kallsyms);
> >  	info->init_typeoffs = mod_mem_init_data->size;
> > @@ -169,7 +263,7 @@ void layout_symtab(struct module *mod, struct load_info *info)
> >   */
> >  void add_kallsyms(struct module *mod, const struct load_info *info)
> >  {
> > -	unsigned int i, ndst;
> > +	unsigned int i, di, nfunc, ndst;
> >  	const Elf_Sym *src;
> >  	Elf_Sym *dst;
> >  	char *s;
> > @@ -178,6 +272,7 @@ void add_kallsyms(struct module *mod, const struct load_info *info)
> >  	void *data_base = mod->mem[MOD_DATA].base;
> >  	void *init_data_base = mod->mem[MOD_INIT_DATA].base;
> >  	struct mod_kallsyms *kallsyms;
> > +	bool is_lp_mod = is_livepatch_module(mod);
> >  
> >  	kallsyms = init_data_base + info->mod_kallsyms_init_off;
> 
> This code is followed by the initialization of kallsyms:
> 
> 	kallsyms->symtab = (void *)symsec->sh_addr;
> 	kallsyms->num_symtab = symsec->sh_size / sizeof(Elf_Sym);
> 	/* Make sure we get permanent strtab: don't use info->strtab. */
> 	kallsyms->strtab = (void *)info->sechdrs[info->index.str].sh_addr;
> 	kallsyms->typetab = init_data_base + info->init_typeoffs;
> 
> I suggest adding 'kallsyms->num_func_syms = 0;' after the initialization
> of kallsyms->num_symtab.

I relied on zeroed memory initialization, but I can add this explicitly
for clarity.

> > @@ -194,19 +289,28 @@ void add_kallsyms(struct module *mod, const struct load_info *info)
> >  	mod->core_kallsyms.symtab = dst = data_base + info->symoffs;
> >  	mod->core_kallsyms.strtab = s = data_base + info->stroffs;
> >  	mod->core_kallsyms.typetab = data_base + info->core_typeoffs;
> > +
> >  	strtab_size = info->core_typeoffs - info->stroffs;
> >  	src = kallsyms->symtab;
> > -	for (ndst = i = 0; i < kallsyms->num_symtab; i++) {
> > +	ndst = info->num_func_syms + 1;
> > +
> > +	for (nfunc = i = 0; i < kallsyms->num_symtab; i++) {
> >  		kallsyms->typetab[i] = elf_type(src + i, info);
> > -		if (i == 0 || is_livepatch_module(mod) ||
> > +		if (i == 0 || is_lp_mod ||
> >  		    is_core_symbol(src + i, info->sechdrs, info->hdr->e_shnum,
> >  				   info->index.pcpu)) {
> >  			ssize_t ret;
> >  
> > -			mod->core_kallsyms.typetab[ndst] =
> > -				kallsyms->typetab[i];
> > -			dst[ndst] = src[i];
> > -			dst[ndst++].st_name = s - mod->core_kallsyms.strtab;
> > +			if (i == 0)
> > +				di = 0;
> > +			else if (!is_lp_mod && is_func_symbol(src + i))
> > +				di = 1 + nfunc++;
> > +			else
> > +				di = ndst++;
> > +
> > +			mod->core_kallsyms.typetab[di] = kallsyms->typetab[i];
> > +			dst[di] = src[i];
> > +			dst[di].st_name = s - mod->core_kallsyms.strtab;
> >  			ret = strscpy(s, &kallsyms->strtab[src[i].st_name],
> >  				      strtab_size);
> >  			if (ret < 0)
> > @@ -216,9 +320,13 @@ void add_kallsyms(struct module *mod, const struct load_info *info)
> >  		}
> >  	}
> >  
> > +	WARN_ON_ONCE(nfunc != info->num_func_syms);
> > +	sort(dst + 1, nfunc, sizeof(Elf_Sym), elf_sym_cmp, NULL);
> > +
> 
> The code sorts mod->core_kallsyms.symtab but mod->core_kallsyms.typetab
> is not reordered accordingly.

Right, but for function symbols the typetab entries are all 't',
so swapping them does not change the type value. The 'T' vs 't'
distinction is handled later when printing (based on export status).
But the comment explaining skiping adjusting of
mod->core_kallsyms.typetab is needed.

> >  	/* Set up to point into init section. */
> >  	rcu_assign_pointer(mod->kallsyms, kallsyms);
> >  	mod->core_kallsyms.num_symtab = ndst;
> > +	mod->core_kallsyms.num_func_syms = nfunc;
> >  }
> >  
> >  #if IS_ENABLED(CONFIG_STACKTRACE_BUILD_ID)
> > @@ -241,11 +349,6 @@ void init_build_id(struct module *mod, const struct load_info *info)
> >  }
> >  #endif
> >  
> > -static const char *kallsyms_symbol_name(struct mod_kallsyms *kallsyms, unsigned int symnum)
> > -{
> > -	return kallsyms->strtab + kallsyms->symtab[symnum].st_name;
> > -}
> > -
> >  /*
> >   * Given a module and address, find the corresponding symbol and return its name
> >   * while providing its size and offset if needed.
> > @@ -255,7 +358,10 @@ static const char *find_kallsyms_symbol(struct module *mod,
> >  					unsigned long *size,
> >  					unsigned long *offset)
> >  {
> > -	unsigned int i, best = 0;
> > +	unsigned int (*search)(struct mod_kallsyms *kallsyms,
> > +			       unsigned long addr, unsigned long *bestval,
> > +			       unsigned long *nextval);
> > +	unsigned int best;
> >  	unsigned long nextval, bestval;
> >  	struct mod_kallsyms *kallsyms = rcu_dereference(mod->kallsyms);
> >  	struct module_memory *mod_mem = NULL;
> > @@ -266,6 +372,11 @@ static const char *find_kallsyms_symbol(struct module *mod,
> >  			continue;
> >  #endif
> >  		if (within_module_mem_type(addr, mod, type)) {
> > +			if (type == MOD_TEXT && kallsyms->num_func_syms > 0)
> > +				search = bsearch_func_symbol;
> 
> I'm not sure if it is ok to limit the search only to function symbols
> when the address lies in MOD_TEXT. The text can theoretically contain
> non-function symbols.

Yes, the patch assumes that the only valid symbols in the MOD_TEXT
are functions. If there are defined OBJECT symbols in .text, the patch
would break lookup for those.

While it’s theoretically possible (e.g. hand-written assembly placing
data in .text ?), I’m not sure this is a practical concern. In general,
having data in executable segments is discouraged for security reasons. 

> Could this optimization be adjusted to sort all
> MOD_TEXT symbols (excluding anonymous and mapping symbols) and move them
> to the front of the symbol table?

That’s possible. We could track .text sections indices in
__layout_sections() and include all valid symbols from those sections,
and also reorder typetab accordingly.

However, this adds complexity. I would prefer to first confirm whether
OBJECT symbols in MOD_TEXT is a real issue before going in that direction.

Regards
Stanislaw

> > +			else
> > +				search = search_kallsyms_symbol;
> > +
> >  			mod_mem = &mod->mem[type];
> >  			break;
> >  		}
> > @@ -278,33 +389,7 @@ static const char *find_kallsyms_symbol(struct module *mod,
> >  	nextval = (unsigned long)mod_mem->base + mod_mem->size;
> >  	bestval = (unsigned long)mod_mem->base - 1;
> >  
> > -	/*
> > -	 * Scan for closest preceding symbol, and next symbol. (ELF
> > -	 * starts real symbols at 1).
> > -	 */
> > -	for (i = 1; i < kallsyms->num_symtab; i++) {
> > -		const Elf_Sym *sym = &kallsyms->symtab[i];
> > -		unsigned long thisval = kallsyms_symbol_value(sym);
> > -
> > -		if (sym->st_shndx == SHN_UNDEF)
> > -			continue;
> > -
> > -		/*
> > -		 * We ignore unnamed symbols: they're uninformative
> > -		 * and inserted at a whim.
> > -		 */
> > -		if (*kallsyms_symbol_name(kallsyms, i) == '\0' ||
> > -		    is_mapping_symbol(kallsyms_symbol_name(kallsyms, i)))
> > -			continue;
> > -
> > -		if (thisval <= addr && thisval > bestval) {
> > -			best = i;
> > -			bestval = thisval;
> > -		}
> > -		if (thisval > addr && thisval < nextval)
> > -			nextval = thisval;
> > -	}
> > -
> > +	best = search(kallsyms, addr, &bestval, &nextval);
> >  	if (!best)
> >  		return NULL;
> >  
> 
> -- 
> Thanks,
> Petr

