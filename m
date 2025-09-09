Return-Path: <live-patching+bounces-1635-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 94861B502F8
	for <lists+live-patching@lfdr.de>; Tue,  9 Sep 2025 18:44:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CD0D0188203C
	for <lists+live-patching@lfdr.de>; Tue,  9 Sep 2025 16:45:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF54D352FFA;
	Tue,  9 Sep 2025 16:44:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pkIU5oW3"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C408D352FE8;
	Tue,  9 Sep 2025 16:44:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757436284; cv=none; b=itQ7evQwwR2Gt/wLETTjXOqb8/1wmMmiQV6Oh6OpOyYufCHaq6kwB275+J3zg/LIfebVEzkIPnT61NQRD+0tQVum4c5b12/vO+I9W4CF+CueW4h3J+TCaQz+xmUhAJZJMP8dmJx2tFvm5Gd42KDKMEXesT7YNvfFtWQB/I81tlY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757436284; c=relaxed/simple;
	bh=ufz9uBMb6uGYsOjnNZfX7TVsopF4HfgSP/RmS/pqWUU=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=OE/dfcVLHyubM2QIwoZbkjSvh5rooGxDcWLxGs6aq3439nTQajKDge4Ix+DOTE7uvwYli309ReLaFptHMolJ9UW7eiGYo8dSINXRTEP0Yfx3fvLdboBJg2a9syQJ2foRPLsqLE2j2eUH22C+0YITQBYZxJkGaM3n7+8iQD90O2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pkIU5oW3; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 118E2C4CEF9;
	Tue,  9 Sep 2025 16:44:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757436284;
	bh=ufz9uBMb6uGYsOjnNZfX7TVsopF4HfgSP/RmS/pqWUU=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=pkIU5oW3O/18tk4WaWw2dyA245Hlwbhoq+BH+BPzbmuDFqdL3z/bk7zyXnLU+6No9
	 W/MPd4WsPAU2AnvhuJGqUFZlasj0yrE+a3jv+vZpoeFIXg7z6GfC3pMJFKKw62zzHP
	 Knx70sgWSDv/qjAQi6fJlzY/mRblbC5MFjKvK0eGOThFQSmRIH6XtgXY8T83J9WfpU
	 swXtE05sKakz7aRznQl8YGbEhEliaZ98QzFxFU2KfdHzAe9qFXjaQSKCwRFv5n4Wdi
	 7KODtr3xKF+MEIvTzUqoPTXMPEkBZlVFUvTeF9dv0Run2N4hPnQ2vFYGWcwk735BIX
	 xEz0n+jfTdBCg==
From: Puranjay Mohan <puranjay@kernel.org>
To: Dylan Hatch <dylanbhatch@google.com>, Josh Poimboeuf
 <jpoimboe@kernel.org>, Steven Rostedt <rostedt@goodmis.org>, Indu Bhagat
 <indu.bhagat@oracle.com>, Peter Zijlstra <peterz@infradead.org>, Will
 Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, Jiri
 Kosina <jikos@kernel.org>
Cc: Dylan Hatch <dylanbhatch@google.com>, Roman Gushchin
 <roman.gushchin@linux.dev>, Weinan Liu <wnliu@google.com>, Mark Rutland
 <mark.rutland@arm.com>, Ian Rogers <irogers@google.com>,
 linux-toolchains@vger.kernel.org, linux-kernel@vger.kernel.org,
 live-patching@vger.kernel.org, joe.lawrence@redhat.com, Song Liu
 <song@kernel.org>, Prasanna Kumar T S M <ptsm@linux.microsoft.com>
Subject: Re: [PATCH v2 4/6] unwind: Implement generic sframe unwinder library
In-Reply-To: <20250904223850.884188-5-dylanbhatch@google.com>
References: <20250904223850.884188-1-dylanbhatch@google.com>
 <20250904223850.884188-5-dylanbhatch@google.com>
Date: Tue, 09 Sep 2025 16:44:40 +0000
Message-ID: <mb61p4itb4ltz.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Dylan Hatch <dylanbhatch@google.com> writes:

> From: Weinan Liu <wnliu@google.com>
>
> This change introduces a kernel space unwinder using sframe table for
> architectures without ORC unwinder support.
>
> The implementation is adapted from Josh's userspace sframe unwinder
> proposal[1] according to the sframe v2 spec[2].
>
> [1] https://lore.kernel.org/lkml/42c0a99236af65c09c8182e260af7bcf5aa1e158.1730150953.git.jpoimboe@kernel.org/
> [2] https://sourceware.org/binutils/docs/sframe-spec.html
>
> Signed-off-by: Weinan Liu <wnliu@google.com>
> Signed-off-by: Dylan Hatch <dylanbhatch@google.com>
> Reviewed-by: Prasanna Kumar T S M <ptsm@linux.microsoft.com>
> ---
>  include/linux/sframe_lookup.h |  43 ++++++++
>  kernel/Makefile               |   1 +
>  kernel/sframe_lookup.c        | 196 ++++++++++++++++++++++++++++++++++
>  3 files changed, 240 insertions(+)
>  create mode 100644 include/linux/sframe_lookup.h
>  create mode 100644 kernel/sframe_lookup.c
>
> diff --git a/include/linux/sframe_lookup.h b/include/linux/sframe_lookup.h
> new file mode 100644
> index 000000000000..1c26cf1f38d4
> --- /dev/null
> +++ b/include/linux/sframe_lookup.h
> @@ -0,0 +1,43 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#ifndef _LINUX_SFRAME_LOOKUP_H
> +#define _LINUX_SFRAME_LOOKUP_H
> +
> +/**
> + * struct sframe_ip_entry - sframe unwind info for given ip
> + * @cfa_offset: Offset for the Canonical Frame Address(CFA) from Frame
> + *              Pointer(FP) or Stack Pointer(SP)
> + * @ra_offset: Offset for the Return Address from CFA.
> + * @fp_offset: Offset for the Frame Pointer (FP) from CFA.
> + * @use_fp: Use FP to get next CFA or not
> + */
> +struct sframe_ip_entry {
> +	int32_t cfa_offset;
> +	int32_t ra_offset;
> +	int32_t fp_offset;
> +	bool use_fp;
> +};
> +
> +/**
> + * struct sframe_table - sframe struct of a table
> + * @sfhdr_p: Pointer to sframe header
> + * @fde_p: Pointer to the first of sframe frame description entry(FDE).
> + * @fre_p: Pointer to the first of sframe frame row entry(FRE).
> + */
> +struct sframe_table {
> +	struct sframe_header *sfhdr_p;
> +	struct sframe_fde *fde_p;
> +	char *fre_p;
> +};
> +
> +#ifdef CONFIG_SFRAME_UNWINDER
> +void init_sframe_table(void);
> +int sframe_find_pc(unsigned long pc, struct sframe_ip_entry *entry);
> +#else
> +static inline void init_sframe_table(void) {}
> +static inline int sframe_find_pc(unsigned long pc, struct sframe_ip_entry *entry)
> +{
> +	return -EINVAL;
> +}
> +#endif
> +
> +#endif /* _LINUX_SFRAME_LOOKUP_H */
> diff --git a/kernel/Makefile b/kernel/Makefile
> index c60623448235..17e9cfe09dc0 100644
> --- a/kernel/Makefile
> +++ b/kernel/Makefile
> @@ -138,6 +138,7 @@ obj-$(CONFIG_WATCH_QUEUE) += watch_queue.o
>  
>  obj-$(CONFIG_RESOURCE_KUNIT_TEST) += resource_kunit.o
>  obj-$(CONFIG_SYSCTL_KUNIT_TEST) += sysctl-test.o
> +obj-$(CONFIG_SFRAME_UNWINDER) += sframe_lookup.o
>  
>  CFLAGS_kstack_erase.o += $(DISABLE_KSTACK_ERASE)
>  CFLAGS_kstack_erase.o += $(call cc-option,-mgeneral-regs-only)
> diff --git a/kernel/sframe_lookup.c b/kernel/sframe_lookup.c
> new file mode 100644
> index 000000000000..51cd24a75956
> --- /dev/null
> +++ b/kernel/sframe_lookup.c
> @@ -0,0 +1,196 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +#define pr_fmt(fmt)	"sframe: " fmt
> +
> +#include <linux/module.h>
> +#include <linux/sort.h>
> +#include <linux/sframe_lookup.h>
> +#include <linux/kallsyms.h>
> +#include "sframe.h"
> +
> +extern char __start_sframe_header[];
> +extern char __stop_sframe_header[];
> +
> +static bool sframe_init __ro_after_init;
> +static struct sframe_table sftbl;
> +
> +#define SFRAME_READ_TYPE(in, out, type)					\
> +({									\
> +	type __tmp;							\
> +	memcpy(&__tmp, in, sizeof(__tmp));				\
> +	in += sizeof(__tmp);						\
> +	out = __tmp;							\
> +})
> +
> +#define SFRAME_READ_ROW_ADDR(in_addr, out_addr, type)			\
> +({									\
> +	switch (type) {							\
> +	case SFRAME_FRE_TYPE_ADDR1:					\
> +		SFRAME_READ_TYPE(in_addr, out_addr, u8);		\
> +		break;							\
> +	case SFRAME_FRE_TYPE_ADDR2:					\
> +		SFRAME_READ_TYPE(in_addr, out_addr, u16);		\
> +		break;							\
> +	case SFRAME_FRE_TYPE_ADDR4:					\
> +		SFRAME_READ_TYPE(in_addr, out_addr, u32);		\
> +		break;							\
> +	default:							\
> +		break;							\
> +	}								\
> +})
> +
> +#define SFRAME_READ_ROW_OFFSETS(in_addr, out_addr, size)		\
> +({									\
> +	switch (size) {							\
> +	case 1:								\
> +		SFRAME_READ_TYPE(in_addr, out_addr, s8);		\
> +		break;							\
> +	case 2:								\
> +		SFRAME_READ_TYPE(in_addr, out_addr, s16);		\
> +		break;							\
> +	case 4:								\
> +		SFRAME_READ_TYPE(in_addr, out_addr, s32);		\
> +		break;							\
> +	default:							\
> +		break;							\
> +	}								\
> +})
> +
> +static struct sframe_fde *find_fde(const struct sframe_table *tbl, unsigned long pc)
> +{
> +	int l, r, m, f;
> +	int32_t ip;
> +	struct sframe_fde *fdep;
> +
> +	if (!tbl || !tbl->sfhdr_p || !tbl->fde_p)
> +		return NULL;
> +
> +	ip = (pc - (unsigned long)tbl->sfhdr_p);
> +
> +	/* Do a binary range search to find the rightmost FDE start_addr < ip */
> +	l = m = f = 0;
> +	r = tbl->sfhdr_p->num_fdes;
> +	while (l < r) {
> +		m = l + ((r - l) / 2);
> +		fdep = tbl->fde_p + m;
> +		if (fdep->start_addr > ip)
> +			r = m;
> +		else
> +			l = m + 1;
> +	}

The above logic doesn't correctly work for the new scheme with
SFRAME_F_FDE_FUNC_START_PCREL, see [1]

If SFRAME_F_FDE_FUNC_START_PCREL is set in flags then function start
address in SFrame FDE is encoded as the distance from the location of
the sfde_func_start_address to the start PC of the function.

And for modules, sframes will only work if compiled with [1] with
SFRAME_F_FDE_FUNC_START_PCREL flag set as ET_DYN, ET_EXEC, and ET_REL
(relocatable links) generated by ld have sfde_func_start_address as
offset from field itself. see [2] for more details.

So, for the in kernel sframe unwinder that should support both normal
links (kernel) and relocatable links (modules), we need to reject the
sframe section if this flag is not set in init_sframe_table() and in
sframe_module_init().

Then we can fix find_fde() like:

use pc in place of ip directly.

and the check will become

if (fdep->start_addr > (s32)(pc - fdep))

I hope I am not missing something,

Indu,
Do you agree with my comments above?

Thanks,
Puranjay

[1] https://sourceware.org/pipermail/binutils/2025-July/142222.html
[2] https://sourceware.org/bugzilla/show_bug.cgi?id=32666

> +	/* use l - 1 because l will be the first item fdep->start_addr > ip */
> +	f = l - 1;
> +	if (f >= tbl->sfhdr_p->num_fdes || f < 0)
> +		return NULL;
> +	fdep = tbl->fde_p + f;
> +	if (ip < fdep->start_addr || ip > fdep->start_addr + fdep->func_size)
> +		return NULL;
> +
> +	return fdep;
> +}
> +
> +static int find_fre(const struct sframe_table *tbl, unsigned long pc,
> +		const struct sframe_fde *fdep, struct sframe_ip_entry *entry)
> +{
> +	int i, offset_size, offset_count;
> +	char *fres, *offsets_loc;
> +	int32_t ip_off;
> +	uint32_t next_row_ip_off;
> +	uint8_t fre_info, fde_type = SFRAME_FUNC_FDE_TYPE(fdep->info),
> +			fre_type = SFRAME_FUNC_FRE_TYPE(fdep->info);
> +
> +	fres = tbl->fre_p + fdep->fres_off;
> +
> +	/*  Whether PCs in the FREs should be treated as masks or not */
> +	if (fde_type == SFRAME_FDE_TYPE_PCMASK)
> +		ip_off = pc % fdep->rep_size;
> +	else
> +		ip_off = (int32_t)(pc - (unsigned long)tbl->sfhdr_p) - fdep->start_addr;
> +
> +	if (ip_off < 0 || ip_off > fdep->func_size)
> +		return -EINVAL;
> +
> +	/*
> +	 * FRE structure starts by address of the entry with variants length. Use
> +	 * two pointers to track current head(fres) and the address of last
> +	 * offset(offsets_loc)
> +	 */
> +	for (i = 0; i < fdep->fres_num; i++) {
> +		SFRAME_READ_ROW_ADDR(fres, next_row_ip_off, fre_type);
> +		if (ip_off < next_row_ip_off)
> +			break;
> +		SFRAME_READ_TYPE(fres, fre_info, u8);
> +		offsets_loc = fres;
> +		/*
> +		 * jump to the start of next fre
> +		 * fres += fre_offets_cnt*offset_size
> +		 */
> +		fres += SFRAME_FRE_OFFSET_COUNT(fre_info) << SFRAME_FRE_OFFSET_SIZE(fre_info);
> +	}
> +
> +	offset_size = 1 << SFRAME_FRE_OFFSET_SIZE(fre_info);
> +	offset_count = SFRAME_FRE_OFFSET_COUNT(fre_info);
> +
> +	if (offset_count > 0) {
> +		SFRAME_READ_ROW_OFFSETS(offsets_loc, entry->cfa_offset, offset_size);
> +		offset_count--;
> +	}
> +	if (offset_count > 0 && !entry->ra_offset) {
> +		SFRAME_READ_ROW_OFFSETS(offsets_loc, entry->ra_offset, offset_size);
> +		offset_count--;
> +	}
> +	if (offset_count > 0 && !entry->fp_offset) {
> +		SFRAME_READ_ROW_OFFSETS(offsets_loc, entry->fp_offset, offset_size);
> +		offset_count--;
> +	}
> +	if (offset_count)
> +		return -EINVAL;
> +
> +	entry->use_fp = SFRAME_FRE_CFA_BASE_REG_ID(fre_info) == SFRAME_BASE_REG_FP;
> +
> +	return 0;
> +}
> +
> +int sframe_find_pc(unsigned long pc, struct sframe_ip_entry *entry)
> +{
> +	struct sframe_fde *fdep;
> +	struct sframe_table *sftbl_p = &sftbl;
> +	int err;
> +
> +	if (!sframe_init)
> +		return -EINVAL;
> +
> +	memset(entry, 0, sizeof(*entry));
> +	entry->ra_offset = sftbl_p->sfhdr_p->cfa_fixed_ra_offset;
> +	entry->fp_offset = sftbl_p->sfhdr_p->cfa_fixed_fp_offset;
> +
> +	fdep = find_fde(sftbl_p, pc);
> +	if (!fdep)
> +		return -EINVAL;
> +	err = find_fre(sftbl_p, pc, fdep, entry);
> +	if (err)
> +		return err;
> +
> +	return 0;
> +}
> +
> +void __init init_sframe_table(void)
> +{
> +	size_t sframe_size = (void *)__stop_sframe_header - (void *)__start_sframe_header;
> +	void *sframe_buf = __start_sframe_header;
> +
> +	if (sframe_size <= 0)
> +		return;
> +	sftbl.sfhdr_p = sframe_buf;
> +	if (!sftbl.sfhdr_p || sftbl.sfhdr_p->preamble.magic != SFRAME_MAGIC ||
> +	    sftbl.sfhdr_p->preamble.version != SFRAME_VERSION_2 ||
> +	    !(sftbl.sfhdr_p->preamble.flags & SFRAME_F_FDE_SORTED)) {
> +		pr_warn("WARNING: Unable to read sframe header.  Disabling unwinder.\n");
> +		return;
> +	}
> +
> +	sftbl.fde_p = (struct sframe_fde *)(__start_sframe_header + SFRAME_HEADER_SIZE(*sftbl.sfhdr_p)
> +						+ sftbl.sfhdr_p->fdes_off);
> +	sftbl.fre_p = __start_sframe_header + SFRAME_HEADER_SIZE(*sftbl.sfhdr_p)
> +		+ sftbl.sfhdr_p->fres_off;
> +	sframe_init = true;
> +}
> -- 
> 2.51.0.355.g5224444f11-goog

