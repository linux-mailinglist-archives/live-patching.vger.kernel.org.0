Return-Path: <live-patching+bounces-1628-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 00CA4B449D2
	for <lists+live-patching@lfdr.de>; Fri,  5 Sep 2025 00:40:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AD76F3A68DD
	for <lists+live-patching@lfdr.de>; Thu,  4 Sep 2025 22:40:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 06C8A2EC0A6;
	Thu,  4 Sep 2025 22:39:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="iNa5Z+CD"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E3402F0C51
	for <live-patching@vger.kernel.org>; Thu,  4 Sep 2025 22:39:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757025567; cv=none; b=nMS0uwOkAV+JJ1Ky8bYBL98HwadAqMwo65kzRfVwwqsx++B+S5QCw2gojRlAFe01lAhIfgxpWmGOFzM4v3o3T6ZYNw/s720Jhcj2BtPiokulSFiqhALTT11BI7WEJq3NS23ZTKZMMrfGj0D7lYJkRFF+xmM56Ks2MHeMpmQp6D8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757025567; c=relaxed/simple;
	bh=IeZxR7TyG4FPSEisgcdIPCKln5kfppzISNwk9hjNvvc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=L7x0oGJ38qlb7u+LAJJeRjtPpPwQIwev6WHNOCYALbq5R4X3VlCcq0556IXkNxnBWxeJFHjMWMN0DYkdRGNnsdjt2QbX/MxD+4M2sTcpyldVgifpe2IkanMsL8AkwGYozKHTCZ8tuGefHfdNZGMfP5Q3r6wI+TklbX0O6g37UJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--dylanbhatch.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=iNa5Z+CD; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--dylanbhatch.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-32bc286bc1eso361448a91.0
        for <live-patching@vger.kernel.org>; Thu, 04 Sep 2025 15:39:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757025565; x=1757630365; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Y2/9lQLIV+FHCh92ZbMoaFXnxUMAJdtb0VfSyDhZjLY=;
        b=iNa5Z+CDXRv5vn22XlDzI1RWCI9OtL8QlxoqJ0O6PFRsuxyKVRcEleoAKmJQQa4QaO
         VdP4fQtrmMANathpVLDmWK7NdSdH6CkiZJ3zOr9fDM0pg+XtkbtQgiG7z7MDA+Zl9JC/
         fpY6Kij1QI1ecIqdYt1DmRA1Eb4p0O7wi1PVzc9N1lCjl1R3op/iYj6Rbs6lC3Fl1k86
         CN5jtXDOXvJMX4DKrHmYvAoWF982l8mhwzkhDz5A+4RaAnj78qfTIL314mOXNCZEfvgw
         mi2euverO7Rm1JEXUxtVf6hSUzdTNLm22x8w3uxSXI3oW+homyZfr1Eif+EiXU+5Wd2d
         E7+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757025565; x=1757630365;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Y2/9lQLIV+FHCh92ZbMoaFXnxUMAJdtb0VfSyDhZjLY=;
        b=nuXsztdQh5ziv1l0+OBWItPjgX7xnZ3/AWVRt/ia1f12T8BsGhvjzzCy7mwpjooq+o
         sgIyaiqVXGoO+odLD9mkdQsYUtlo5Ih7vTFCmy66VVe0fH7MOY8zs/1QsB08snXRK5wv
         3vrlpr4KPEST/SsaSGYhiF+Jau6dWyNrGdxivKHwmkWxS2xgJuDDQ3TUaB+dAyhVRnfQ
         mDEKgfWayryNwnG6siXA7OyBCV/Lhax2wKQFM3r0g+5gX1eIBv5LNwHXuHBRkm2Xn8Uz
         82P6PqnuVGCmeoorDpCbodsTJIecmpUG60PMUPvD0yE9FIPFTbkoHWLUQpRoWnhG9mcd
         N6QA==
X-Forwarded-Encrypted: i=1; AJvYcCUO2/CrcHkAAX/nGqjlr0S9xVmPem5o9qXm6EuoyHsSGsy1o3spRSzEDz3gb2lgnd30PbYgy7M43HY89gxP@vger.kernel.org
X-Gm-Message-State: AOJu0YzIdGIwsAAL9rm00azKrV0PoYKBILmdRH2LxOqEmy6OiIAwEed7
	3epk00GT1w5V+MZDXQKyQap6pQlR2p68rWtpvevuWM8JKJXZLKxeRAImbU/emvBfMpyuhSD44rv
	26/LkEOJZjBGWBrLMAEsP9eI2Ag==
X-Google-Smtp-Source: AGHT+IHy96MyTB0pkWlUUJ6E8LnjrTTKObtRIYDMqttTIQgktOfu9B5oK7HG5r5CV4MNuHJ8A85VZ/GzHRPhLbfOwQ==
X-Received: from pjbpx16.prod.google.com ([2002:a17:90b:2710:b0:32a:a943:aa8a])
 (user=dylanbhatch job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:288b:b0:32b:a307:23dc with SMTP id 98e67ed59e1d1-32ba30726e7mr3995474a91.24.1757025565433;
 Thu, 04 Sep 2025 15:39:25 -0700 (PDT)
Date: Thu,  4 Sep 2025 22:38:48 +0000
In-Reply-To: <20250904223850.884188-1-dylanbhatch@google.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250904223850.884188-1-dylanbhatch@google.com>
X-Mailer: git-send-email 2.51.0.355.g5224444f11-goog
Message-ID: <20250904223850.884188-5-dylanbhatch@google.com>
Subject: [PATCH v2 4/6] unwind: Implement generic sframe unwinder library
From: Dylan Hatch <dylanbhatch@google.com>
To: Josh Poimboeuf <jpoimboe@kernel.org>, Steven Rostedt <rostedt@goodmis.org>, 
	Indu Bhagat <indu.bhagat@oracle.com>, Peter Zijlstra <peterz@infradead.org>, 
	Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Jiri Kosina <jikos@kernel.org>
Cc: Dylan Hatch <dylanbhatch@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Weinan Liu <wnliu@google.com>, Mark Rutland <mark.rutland@arm.com>, Ian Rogers <irogers@google.com>, 
	linux-toolchains@vger.kernel.org, linux-kernel@vger.kernel.org, 
	live-patching@vger.kernel.org, joe.lawrence@redhat.com, 
	Puranjay Mohan <puranjay@kernel.org>, Song Liu <song@kernel.org>, 
	Prasanna Kumar T S M <ptsm@linux.microsoft.com>
Content-Type: text/plain; charset="UTF-8"

From: Weinan Liu <wnliu@google.com>

This change introduces a kernel space unwinder using sframe table for
architectures without ORC unwinder support.

The implementation is adapted from Josh's userspace sframe unwinder
proposal[1] according to the sframe v2 spec[2].

[1] https://lore.kernel.org/lkml/42c0a99236af65c09c8182e260af7bcf5aa1e158.1730150953.git.jpoimboe@kernel.org/
[2] https://sourceware.org/binutils/docs/sframe-spec.html

Signed-off-by: Weinan Liu <wnliu@google.com>
Signed-off-by: Dylan Hatch <dylanbhatch@google.com>
Reviewed-by: Prasanna Kumar T S M <ptsm@linux.microsoft.com>
---
 include/linux/sframe_lookup.h |  43 ++++++++
 kernel/Makefile               |   1 +
 kernel/sframe_lookup.c        | 196 ++++++++++++++++++++++++++++++++++
 3 files changed, 240 insertions(+)
 create mode 100644 include/linux/sframe_lookup.h
 create mode 100644 kernel/sframe_lookup.c

diff --git a/include/linux/sframe_lookup.h b/include/linux/sframe_lookup.h
new file mode 100644
index 000000000000..1c26cf1f38d4
--- /dev/null
+++ b/include/linux/sframe_lookup.h
@@ -0,0 +1,43 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _LINUX_SFRAME_LOOKUP_H
+#define _LINUX_SFRAME_LOOKUP_H
+
+/**
+ * struct sframe_ip_entry - sframe unwind info for given ip
+ * @cfa_offset: Offset for the Canonical Frame Address(CFA) from Frame
+ *              Pointer(FP) or Stack Pointer(SP)
+ * @ra_offset: Offset for the Return Address from CFA.
+ * @fp_offset: Offset for the Frame Pointer (FP) from CFA.
+ * @use_fp: Use FP to get next CFA or not
+ */
+struct sframe_ip_entry {
+	int32_t cfa_offset;
+	int32_t ra_offset;
+	int32_t fp_offset;
+	bool use_fp;
+};
+
+/**
+ * struct sframe_table - sframe struct of a table
+ * @sfhdr_p: Pointer to sframe header
+ * @fde_p: Pointer to the first of sframe frame description entry(FDE).
+ * @fre_p: Pointer to the first of sframe frame row entry(FRE).
+ */
+struct sframe_table {
+	struct sframe_header *sfhdr_p;
+	struct sframe_fde *fde_p;
+	char *fre_p;
+};
+
+#ifdef CONFIG_SFRAME_UNWINDER
+void init_sframe_table(void);
+int sframe_find_pc(unsigned long pc, struct sframe_ip_entry *entry);
+#else
+static inline void init_sframe_table(void) {}
+static inline int sframe_find_pc(unsigned long pc, struct sframe_ip_entry *entry)
+{
+	return -EINVAL;
+}
+#endif
+
+#endif /* _LINUX_SFRAME_LOOKUP_H */
diff --git a/kernel/Makefile b/kernel/Makefile
index c60623448235..17e9cfe09dc0 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -138,6 +138,7 @@ obj-$(CONFIG_WATCH_QUEUE) += watch_queue.o
 
 obj-$(CONFIG_RESOURCE_KUNIT_TEST) += resource_kunit.o
 obj-$(CONFIG_SYSCTL_KUNIT_TEST) += sysctl-test.o
+obj-$(CONFIG_SFRAME_UNWINDER) += sframe_lookup.o
 
 CFLAGS_kstack_erase.o += $(DISABLE_KSTACK_ERASE)
 CFLAGS_kstack_erase.o += $(call cc-option,-mgeneral-regs-only)
diff --git a/kernel/sframe_lookup.c b/kernel/sframe_lookup.c
new file mode 100644
index 000000000000..51cd24a75956
--- /dev/null
+++ b/kernel/sframe_lookup.c
@@ -0,0 +1,196 @@
+// SPDX-License-Identifier: GPL-2.0-only
+#define pr_fmt(fmt)	"sframe: " fmt
+
+#include <linux/module.h>
+#include <linux/sort.h>
+#include <linux/sframe_lookup.h>
+#include <linux/kallsyms.h>
+#include "sframe.h"
+
+extern char __start_sframe_header[];
+extern char __stop_sframe_header[];
+
+static bool sframe_init __ro_after_init;
+static struct sframe_table sftbl;
+
+#define SFRAME_READ_TYPE(in, out, type)					\
+({									\
+	type __tmp;							\
+	memcpy(&__tmp, in, sizeof(__tmp));				\
+	in += sizeof(__tmp);						\
+	out = __tmp;							\
+})
+
+#define SFRAME_READ_ROW_ADDR(in_addr, out_addr, type)			\
+({									\
+	switch (type) {							\
+	case SFRAME_FRE_TYPE_ADDR1:					\
+		SFRAME_READ_TYPE(in_addr, out_addr, u8);		\
+		break;							\
+	case SFRAME_FRE_TYPE_ADDR2:					\
+		SFRAME_READ_TYPE(in_addr, out_addr, u16);		\
+		break;							\
+	case SFRAME_FRE_TYPE_ADDR4:					\
+		SFRAME_READ_TYPE(in_addr, out_addr, u32);		\
+		break;							\
+	default:							\
+		break;							\
+	}								\
+})
+
+#define SFRAME_READ_ROW_OFFSETS(in_addr, out_addr, size)		\
+({									\
+	switch (size) {							\
+	case 1:								\
+		SFRAME_READ_TYPE(in_addr, out_addr, s8);		\
+		break;							\
+	case 2:								\
+		SFRAME_READ_TYPE(in_addr, out_addr, s16);		\
+		break;							\
+	case 4:								\
+		SFRAME_READ_TYPE(in_addr, out_addr, s32);		\
+		break;							\
+	default:							\
+		break;							\
+	}								\
+})
+
+static struct sframe_fde *find_fde(const struct sframe_table *tbl, unsigned long pc)
+{
+	int l, r, m, f;
+	int32_t ip;
+	struct sframe_fde *fdep;
+
+	if (!tbl || !tbl->sfhdr_p || !tbl->fde_p)
+		return NULL;
+
+	ip = (pc - (unsigned long)tbl->sfhdr_p);
+
+	/* Do a binary range search to find the rightmost FDE start_addr < ip */
+	l = m = f = 0;
+	r = tbl->sfhdr_p->num_fdes;
+	while (l < r) {
+		m = l + ((r - l) / 2);
+		fdep = tbl->fde_p + m;
+		if (fdep->start_addr > ip)
+			r = m;
+		else
+			l = m + 1;
+	}
+	/* use l - 1 because l will be the first item fdep->start_addr > ip */
+	f = l - 1;
+	if (f >= tbl->sfhdr_p->num_fdes || f < 0)
+		return NULL;
+	fdep = tbl->fde_p + f;
+	if (ip < fdep->start_addr || ip > fdep->start_addr + fdep->func_size)
+		return NULL;
+
+	return fdep;
+}
+
+static int find_fre(const struct sframe_table *tbl, unsigned long pc,
+		const struct sframe_fde *fdep, struct sframe_ip_entry *entry)
+{
+	int i, offset_size, offset_count;
+	char *fres, *offsets_loc;
+	int32_t ip_off;
+	uint32_t next_row_ip_off;
+	uint8_t fre_info, fde_type = SFRAME_FUNC_FDE_TYPE(fdep->info),
+			fre_type = SFRAME_FUNC_FRE_TYPE(fdep->info);
+
+	fres = tbl->fre_p + fdep->fres_off;
+
+	/*  Whether PCs in the FREs should be treated as masks or not */
+	if (fde_type == SFRAME_FDE_TYPE_PCMASK)
+		ip_off = pc % fdep->rep_size;
+	else
+		ip_off = (int32_t)(pc - (unsigned long)tbl->sfhdr_p) - fdep->start_addr;
+
+	if (ip_off < 0 || ip_off > fdep->func_size)
+		return -EINVAL;
+
+	/*
+	 * FRE structure starts by address of the entry with variants length. Use
+	 * two pointers to track current head(fres) and the address of last
+	 * offset(offsets_loc)
+	 */
+	for (i = 0; i < fdep->fres_num; i++) {
+		SFRAME_READ_ROW_ADDR(fres, next_row_ip_off, fre_type);
+		if (ip_off < next_row_ip_off)
+			break;
+		SFRAME_READ_TYPE(fres, fre_info, u8);
+		offsets_loc = fres;
+		/*
+		 * jump to the start of next fre
+		 * fres += fre_offets_cnt*offset_size
+		 */
+		fres += SFRAME_FRE_OFFSET_COUNT(fre_info) << SFRAME_FRE_OFFSET_SIZE(fre_info);
+	}
+
+	offset_size = 1 << SFRAME_FRE_OFFSET_SIZE(fre_info);
+	offset_count = SFRAME_FRE_OFFSET_COUNT(fre_info);
+
+	if (offset_count > 0) {
+		SFRAME_READ_ROW_OFFSETS(offsets_loc, entry->cfa_offset, offset_size);
+		offset_count--;
+	}
+	if (offset_count > 0 && !entry->ra_offset) {
+		SFRAME_READ_ROW_OFFSETS(offsets_loc, entry->ra_offset, offset_size);
+		offset_count--;
+	}
+	if (offset_count > 0 && !entry->fp_offset) {
+		SFRAME_READ_ROW_OFFSETS(offsets_loc, entry->fp_offset, offset_size);
+		offset_count--;
+	}
+	if (offset_count)
+		return -EINVAL;
+
+	entry->use_fp = SFRAME_FRE_CFA_BASE_REG_ID(fre_info) == SFRAME_BASE_REG_FP;
+
+	return 0;
+}
+
+int sframe_find_pc(unsigned long pc, struct sframe_ip_entry *entry)
+{
+	struct sframe_fde *fdep;
+	struct sframe_table *sftbl_p = &sftbl;
+	int err;
+
+	if (!sframe_init)
+		return -EINVAL;
+
+	memset(entry, 0, sizeof(*entry));
+	entry->ra_offset = sftbl_p->sfhdr_p->cfa_fixed_ra_offset;
+	entry->fp_offset = sftbl_p->sfhdr_p->cfa_fixed_fp_offset;
+
+	fdep = find_fde(sftbl_p, pc);
+	if (!fdep)
+		return -EINVAL;
+	err = find_fre(sftbl_p, pc, fdep, entry);
+	if (err)
+		return err;
+
+	return 0;
+}
+
+void __init init_sframe_table(void)
+{
+	size_t sframe_size = (void *)__stop_sframe_header - (void *)__start_sframe_header;
+	void *sframe_buf = __start_sframe_header;
+
+	if (sframe_size <= 0)
+		return;
+	sftbl.sfhdr_p = sframe_buf;
+	if (!sftbl.sfhdr_p || sftbl.sfhdr_p->preamble.magic != SFRAME_MAGIC ||
+	    sftbl.sfhdr_p->preamble.version != SFRAME_VERSION_2 ||
+	    !(sftbl.sfhdr_p->preamble.flags & SFRAME_F_FDE_SORTED)) {
+		pr_warn("WARNING: Unable to read sframe header.  Disabling unwinder.\n");
+		return;
+	}
+
+	sftbl.fde_p = (struct sframe_fde *)(__start_sframe_header + SFRAME_HEADER_SIZE(*sftbl.sfhdr_p)
+						+ sftbl.sfhdr_p->fdes_off);
+	sftbl.fre_p = __start_sframe_header + SFRAME_HEADER_SIZE(*sftbl.sfhdr_p)
+		+ sftbl.sfhdr_p->fres_off;
+	sframe_init = true;
+}
-- 
2.51.0.355.g5224444f11-goog


