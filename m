Return-Path: <live-patching+bounces-2263-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id aAvhHpVlxmnnJgUAu9opvQ
	(envelope-from <live-patching+bounces-2263-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Fri, 27 Mar 2026 12:10:13 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id F1089343224
	for <lists+live-patching@lfdr.de>; Fri, 27 Mar 2026 12:10:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 56081314EEC7
	for <lists+live-patching@lfdr.de>; Fri, 27 Mar 2026 11:00:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C46D3E557F;
	Fri, 27 Mar 2026 11:00:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wp.pl header.i=@wp.pl header.b="lSHHUv4g"
X-Original-To: live-patching@vger.kernel.org
Received: from mx4.wp.pl (mx4.wp.pl [212.77.101.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E8993E5575
	for <live-patching@vger.kernel.org>; Fri, 27 Mar 2026 11:00:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.77.101.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774609231; cv=none; b=CMJhxTrXOtJWrf/DxIl0LU+idTFFznzUTiYNnCXX161RdHkw2GK6tW/0T8SL1sFOPr1d33S8LCwnWOiptTE5JJpRfG3rC6AMt/Vw89PUjf4oJTcgJ3ccpJvFkT+1j4UgnnACslfDwSzJEcYiP1MC+bWpsehxpcGIDTiBznwwbWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774609231; c=relaxed/simple;
	bh=iCdJ4QZX9SSl/F5+CfYyEv98uB4723rmljuqg7Z4XAA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ppWJAmhipkMw7FODzWi5byH9AIK+BrnYjGt3sflMpLtA6V03NT9SfFZjJH8cH/NLbOio3ZBK6pnEnjtIQQ43Dct9KgmOHrkQjGUVzQO9Isti1ldZ9y77gXph29b+hEbe07wo0nUCPEWiZXvuM8Q+plMYZOg0V3luU3BTcFRYP+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=wp.pl; spf=pass smtp.mailfrom=wp.pl; dkim=pass (2048-bit key) header.d=wp.pl header.i=@wp.pl header.b=lSHHUv4g; arc=none smtp.client-ip=212.77.101.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=wp.pl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wp.pl
Received: (wp-smtpd smtp.wp.pl 20921 invoked from network); 27 Mar 2026 12:00:12 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=20241105;
          t=1774609212; bh=XlX7VNpMwM1n+We30ppZSwEuS4rFHvL/ia/TMGGX0vo=;
          h=From:To:Cc:Subject;
          b=lSHHUv4gSlECFhmjgXkj558bF7X1iVUBwUTEFsPhzEa33VUVx1IMWeUgAT4+IH3qS
           crS9Ze+q6MyuFgIOEuv0ME4NT0ekE0hSWwWGgLlN/ermt3xn+Qu7fnZkUm26JjmEoO
           v5aH9izeveVa02sKB7CDPjDOEOrgUuKsVx98ON9KdDQGI7BaJRKa/N2XnPGH405sL3
           z05tgRCkTDaoUIRM7hCnn0ICEcN1Ne2ANqazVD0Y4Ibx9QSQEVRZVk2uIWaRAkkt1n
           MLKjlgXXRYpFIIGhGLPvj0YeaDrPbn/+5Xttt9BplKe0akmLEqr4xlKWRXZiKki/f3
           9UyMAZA4rIElQ==
Received: from 77-236-5-223.static.play.pl (HELO localhost) (stf_xl@wp.pl@[77.236.5.223])
          (envelope-sender <stf_xl@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with TLS_AES_256_GCM_SHA384 encrypted SMTP
          for <linux-modules@vger.kernel.org>; 27 Mar 2026 12:00:12 +0100
From: Stanislaw Gruszka <stf_xl@wp.pl>
To: linux-modules@vger.kernel.org,
	Sami Tolvanen <samitolvanen@google.com>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Petr Pavlu <petr.pavlu@suse.com>
Cc: linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	live-patching@vger.kernel.org,
	Daniel Gomez <da.gomez@kernel.org>,
	Aaron Tomlin <atomlin@atomlin.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Jordan Rome <linux@jordanrome.com>,
	Viktor Malik <vmalik@redhat.com>
Subject: [PATCH v2 2/2] module/kallsyms: sort function symbols and use binary search
Date: Fri, 27 Mar 2026 12:00:05 +0100
Message-Id: <20260327110005.16499-2-stf_xl@wp.pl>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20260327110005.16499-1-stf_xl@wp.pl>
References: <20260327110005.16499-1-stf_xl@wp.pl>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-WP-MailID: 9b5fb6f572a47d59f4b0eca914a8ce2f
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 0000002 [AfHC]                               
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[wp.pl,none];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[wp.pl:s=20241105];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-2263-lists,live-patching=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_FROM(0.00)[wp.pl];
	RCPT_COUNT_TWELVE(0.00)[13];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[stf_xl@wp.pl,live-patching@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[wp.pl:+];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,wp.pl:dkim,wp.pl:email,wp.pl:mid,nano:email]
X-Rspamd-Queue-Id: F1089343224
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Module symbol lookup via find_kallsyms_symbol() performs a linear scan
over the entire symtab when resolving an address. The number of symbols
in module symtabs has grown over the years, largely due to additional
metadata in non-standard sections, making this lookup very slow.

Improve this by separating function symbols during module load, placing
them at the beginning of the symtab, sorting them by address, and using
binary search when resolving addresses in module text.

This also should improve times for linear symbol name lookups, as valid
function symbols are now located at the beginning of the symtab.

The cost of sorting is small relative to module load time. In repeated
module load tests [1], depending on .config options, this change
increases load time between 2% and 4%. With cold caches, the difference
is not measurable, as memory access latency dominates.

The sorting theoretically could be done in compile time, but much more
complicated as we would have to simulate kernel addresses resolution
for symbols, and then correct relocation entries. That would be risky
if get out of sync.

The improvement can be observed when listing ftrace filter functions.

Before:

root@nano:~# time cat /sys/kernel/tracing/available_filter_functions | wc -l
74908

real	0m1.315s
user	0m0.000s
sys	0m1.312s

After:

root@nano:~# time cat /sys/kernel/tracing/available_filter_functions | wc -l
74911

real	0m0.167s
user	0m0.004s
sys	0m0.175s

(there are three more symbols introduced by the patch)

For livepatch modules, the symtab layout is preserved and the existing
linear search is used. For this case, it should be possible to keep
the original ELF symtab instead of copying it 1:1, but that is outside
the scope of this patch.

Link: https://gist.github.com/sgruszka/09f3fb1dad53a97b1aad96e1927ab117 [1]
Signed-off-by: Stanislaw Gruszka <stf_xl@wp.pl>
---
v1 -> v2: 
 - fix searching data symbols for CONFIG_KALLSYMS_ALL
 - use kallsyms_symbol_value() in elf_sym_cmp()

 include/linux/module.h   |   1 +
 kernel/module/internal.h |   1 +
 kernel/module/kallsyms.c | 171 +++++++++++++++++++++++++++++----------
 3 files changed, 130 insertions(+), 43 deletions(-)

diff --git a/include/linux/module.h b/include/linux/module.h
index ac254525014c..67c053afa882 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -379,6 +379,7 @@ struct module_memory {
 struct mod_kallsyms {
 	Elf_Sym *symtab;
 	unsigned int num_symtab;
+	unsigned int num_func_syms;
 	char *strtab;
 	char *typetab;
 };
diff --git a/kernel/module/internal.h b/kernel/module/internal.h
index 618202578b42..6a4d498619b1 100644
--- a/kernel/module/internal.h
+++ b/kernel/module/internal.h
@@ -73,6 +73,7 @@ struct load_info {
 	bool sig_ok;
 #ifdef CONFIG_KALLSYMS
 	unsigned long mod_kallsyms_init_off;
+	unsigned long num_func_syms;
 #endif
 #ifdef CONFIG_MODULE_DECOMPRESS
 #ifdef CONFIG_MODULE_STATS
diff --git a/kernel/module/kallsyms.c b/kernel/module/kallsyms.c
index f23126d804b2..d69e99e67707 100644
--- a/kernel/module/kallsyms.c
+++ b/kernel/module/kallsyms.c
@@ -10,6 +10,7 @@
 #include <linux/kallsyms.h>
 #include <linux/buildid.h>
 #include <linux/bsearch.h>
+#include <linux/sort.h>
 #include "internal.h"
 
 /* Lookup exported symbol in given range of kernel_symbols */
@@ -103,6 +104,95 @@ static bool is_core_symbol(const Elf_Sym *src, const Elf_Shdr *sechdrs,
 	return true;
 }
 
+static inline bool is_func_symbol(const Elf_Sym *sym)
+{
+	return sym->st_shndx != SHN_UNDEF && sym->st_size != 0 &&
+	       ELF_ST_TYPE(sym->st_info) == STT_FUNC;
+}
+
+static unsigned int bsearch_func_symbol(struct mod_kallsyms *kallsyms,
+					unsigned long addr,
+					unsigned long *bestval,
+					unsigned long *nextval)
+
+{
+	unsigned int mid, low = 1, high = kallsyms->num_func_syms + 1;
+	unsigned int best = 0;
+	unsigned long thisval;
+
+	while (low < high) {
+		mid = low + (high - low) / 2;
+		thisval = kallsyms_symbol_value(&kallsyms->symtab[mid]);
+
+		if (thisval <= addr) {
+			*bestval = thisval;
+			best = mid;
+			low = mid + 1;
+		} else {
+			*nextval = thisval;
+			high = mid;
+		}
+	}
+
+	return best;
+}
+
+static const char *kallsyms_symbol_name(struct mod_kallsyms *kallsyms,
+					unsigned int symnum)
+{
+	return kallsyms->strtab + kallsyms->symtab[symnum].st_name;
+}
+
+static unsigned int search_kallsyms_symbol(struct mod_kallsyms *kallsyms,
+					   unsigned long addr,
+					   unsigned long *bestval,
+					   unsigned long *nextval)
+{
+	unsigned int i, best = 0;
+
+	/*
+	 * Scan for closest preceding symbol and next symbol. (ELF starts
+	 * real symbols at 1). Skip the initial function symbols range
+	 * if num_func_syms is non-zero, those are handled separately for
+	 * the core TEXT segment lookup.
+	 */
+	for (i = 1 + kallsyms->num_func_syms; i < kallsyms->num_symtab; i++) {
+		const Elf_Sym *sym = &kallsyms->symtab[i];
+		unsigned long thisval = kallsyms_symbol_value(sym);
+
+		if (sym->st_shndx == SHN_UNDEF)
+			continue;
+
+		/*
+		 * We ignore unnamed symbols: they're uninformative
+		 * and inserted at a whim.
+		 */
+		if (*kallsyms_symbol_name(kallsyms, i) == '\0' ||
+		    is_mapping_symbol(kallsyms_symbol_name(kallsyms, i)))
+			continue;
+
+		if (thisval <= addr && thisval > *bestval) {
+			best = i;
+			*bestval = thisval;
+		}
+		if (thisval > addr && thisval < *nextval)
+			*nextval = thisval;
+	}
+
+	return best;
+}
+
+static int elf_sym_cmp(const void *a, const void *b)
+{
+	unsigned long val_a = kallsyms_symbol_value((const Elf_Sym *)a);
+	unsigned long val_b = kallsyms_symbol_value((const Elf_Sym *)b);
+
+	if (val_a < val_b)
+		return -1;
+
+	return val_a > val_b;
+}
+
 /*
  * We only allocate and copy the strings needed by the parts of symtab
  * we keep.  This is simple, but has the effect of making multiple
@@ -115,9 +205,10 @@ void layout_symtab(struct module *mod, struct load_info *info)
 	Elf_Shdr *symsect = info->sechdrs + info->index.sym;
 	Elf_Shdr *strsect = info->sechdrs + info->index.str;
 	const Elf_Sym *src;
-	unsigned int i, nsrc, ndst, strtab_size = 0;
+	unsigned int i, nsrc, ndst, nfunc, strtab_size = 0;
 	struct module_memory *mod_mem_data = &mod->mem[MOD_DATA];
 	struct module_memory *mod_mem_init_data = &mod->mem[MOD_INIT_DATA];
+	bool is_lp_mod = is_livepatch_module(mod);
 
 	/* Put symbol section at end of init part of module. */
 	symsect->sh_flags |= SHF_ALLOC;
@@ -129,12 +220,14 @@ void layout_symtab(struct module *mod, struct load_info *info)
 	nsrc = symsect->sh_size / sizeof(*src);
 
 	/* Compute total space required for the core symbols' strtab. */
-	for (ndst = i = 0; i < nsrc; i++) {
-		if (i == 0 || is_livepatch_module(mod) ||
+	for (ndst = nfunc = i = 0; i < nsrc; i++) {
+		if (i == 0 || is_lp_mod ||
 		    is_core_symbol(src + i, info->sechdrs, info->hdr->e_shnum,
 				   info->index.pcpu)) {
 			strtab_size += strlen(&info->strtab[src[i].st_name]) + 1;
 			ndst++;
+			if (!is_lp_mod && is_func_symbol(src + i))
+				nfunc++;
 		}
 	}
 
@@ -156,6 +249,7 @@ void layout_symtab(struct module *mod, struct load_info *info)
 	mod_mem_init_data->size = ALIGN(mod_mem_init_data->size,
 					__alignof__(struct mod_kallsyms));
 	info->mod_kallsyms_init_off = mod_mem_init_data->size;
+	info->num_func_syms = nfunc;
 
 	mod_mem_init_data->size += sizeof(struct mod_kallsyms);
 	info->init_typeoffs = mod_mem_init_data->size;
@@ -169,7 +263,7 @@ void layout_symtab(struct module *mod, struct load_info *info)
  */
 void add_kallsyms(struct module *mod, const struct load_info *info)
 {
-	unsigned int i, ndst;
+	unsigned int i, di, nfunc, ndst;
 	const Elf_Sym *src;
 	Elf_Sym *dst;
 	char *s;
@@ -178,6 +272,7 @@ void add_kallsyms(struct module *mod, const struct load_info *info)
 	void *data_base = mod->mem[MOD_DATA].base;
 	void *init_data_base = mod->mem[MOD_INIT_DATA].base;
 	struct mod_kallsyms *kallsyms;
+	bool is_lp_mod = is_livepatch_module(mod);
 
 	kallsyms = init_data_base + info->mod_kallsyms_init_off;
 
@@ -194,19 +289,28 @@ void add_kallsyms(struct module *mod, const struct load_info *info)
 	mod->core_kallsyms.symtab = dst = data_base + info->symoffs;
 	mod->core_kallsyms.strtab = s = data_base + info->stroffs;
 	mod->core_kallsyms.typetab = data_base + info->core_typeoffs;
+
 	strtab_size = info->core_typeoffs - info->stroffs;
 	src = kallsyms->symtab;
-	for (ndst = i = 0; i < kallsyms->num_symtab; i++) {
+	ndst = info->num_func_syms + 1;
+
+	for (nfunc = i = 0; i < kallsyms->num_symtab; i++) {
 		kallsyms->typetab[i] = elf_type(src + i, info);
-		if (i == 0 || is_livepatch_module(mod) ||
+		if (i == 0 || is_lp_mod ||
 		    is_core_symbol(src + i, info->sechdrs, info->hdr->e_shnum,
 				   info->index.pcpu)) {
 			ssize_t ret;
 
-			mod->core_kallsyms.typetab[ndst] =
-				kallsyms->typetab[i];
-			dst[ndst] = src[i];
-			dst[ndst++].st_name = s - mod->core_kallsyms.strtab;
+			if (i == 0)
+				di = 0;
+			else if (!is_lp_mod && is_func_symbol(src + i))
+				di = 1 + nfunc++;
+			else
+				di = ndst++;
+
+			mod->core_kallsyms.typetab[di] = kallsyms->typetab[i];
+			dst[di] = src[i];
+			dst[di].st_name = s - mod->core_kallsyms.strtab;
 			ret = strscpy(s, &kallsyms->strtab[src[i].st_name],
 				      strtab_size);
 			if (ret < 0)
@@ -216,9 +320,13 @@ void add_kallsyms(struct module *mod, const struct load_info *info)
 		}
 	}
 
+	WARN_ON_ONCE(nfunc != info->num_func_syms);
+	sort(dst + 1, nfunc, sizeof(Elf_Sym), elf_sym_cmp, NULL);
+
 	/* Set up to point into init section. */
 	rcu_assign_pointer(mod->kallsyms, kallsyms);
 	mod->core_kallsyms.num_symtab = ndst;
+	mod->core_kallsyms.num_func_syms = nfunc;
 }
 
 #if IS_ENABLED(CONFIG_STACKTRACE_BUILD_ID)
@@ -241,11 +349,6 @@ void init_build_id(struct module *mod, const struct load_info *info)
 }
 #endif
 
-static const char *kallsyms_symbol_name(struct mod_kallsyms *kallsyms, unsigned int symnum)
-{
-	return kallsyms->strtab + kallsyms->symtab[symnum].st_name;
-}
-
 /*
  * Given a module and address, find the corresponding symbol and return its name
  * while providing its size and offset if needed.
@@ -255,7 +358,10 @@ static const char *find_kallsyms_symbol(struct module *mod,
 					unsigned long *size,
 					unsigned long *offset)
 {
-	unsigned int i, best = 0;
+	unsigned int (*search)(struct mod_kallsyms *kallsyms,
+			       unsigned long addr, unsigned long *bestval,
+			       unsigned long *nextval);
+	unsigned int best;
 	unsigned long nextval, bestval;
 	struct mod_kallsyms *kallsyms = rcu_dereference(mod->kallsyms);
 	struct module_memory *mod_mem = NULL;
@@ -266,6 +372,11 @@ static const char *find_kallsyms_symbol(struct module *mod,
 			continue;
 #endif
 		if (within_module_mem_type(addr, mod, type)) {
+			if (type == MOD_TEXT && kallsyms->num_func_syms > 0)
+				search = bsearch_func_symbol;
+			else
+				search = search_kallsyms_symbol;
+
 			mod_mem = &mod->mem[type];
 			break;
 		}
@@ -278,33 +389,7 @@ static const char *find_kallsyms_symbol(struct module *mod,
 	nextval = (unsigned long)mod_mem->base + mod_mem->size;
 	bestval = (unsigned long)mod_mem->base - 1;
 
-	/*
-	 * Scan for closest preceding symbol, and next symbol. (ELF
-	 * starts real symbols at 1).
-	 */
-	for (i = 1; i < kallsyms->num_symtab; i++) {
-		const Elf_Sym *sym = &kallsyms->symtab[i];
-		unsigned long thisval = kallsyms_symbol_value(sym);
-
-		if (sym->st_shndx == SHN_UNDEF)
-			continue;
-
-		/*
-		 * We ignore unnamed symbols: they're uninformative
-		 * and inserted at a whim.
-		 */
-		if (*kallsyms_symbol_name(kallsyms, i) == '\0' ||
-		    is_mapping_symbol(kallsyms_symbol_name(kallsyms, i)))
-			continue;
-
-		if (thisval <= addr && thisval > bestval) {
-			best = i;
-			bestval = thisval;
-		}
-		if (thisval > addr && thisval < nextval)
-			nextval = thisval;
-	}
-
+	best = search(kallsyms, addr, &bestval, &nextval);
 	if (!best)
 		return NULL;
 
-- 
2.50.1


