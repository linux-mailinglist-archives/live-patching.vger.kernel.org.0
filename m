Return-Path: <live-patching+bounces-2859-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id uCAiGbAJDGo5UQUAu9opvQ
	(envelope-from <live-patching+bounces-2859-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Tue, 19 May 2026 08:56:48 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C828F57875F
	for <lists+live-patching@lfdr.de>; Tue, 19 May 2026 08:56:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 58C5E30B7C9C
	for <lists+live-patching@lfdr.de>; Tue, 19 May 2026 06:50:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD1C23AA1B6;
	Tue, 19 May 2026 06:50:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="V9wRy1HY"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 745473A6F10
	for <live-patching@vger.kernel.org>; Tue, 19 May 2026 06:50:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779173419; cv=none; b=PYsTD1hI4fFkhMnjhwa/G3L26yDGrW45nWzAbJiEqcS9laueWsjxSKFu8bF6kAZoPZx2mIdxyz9eF7qRayNlS0oB+9LJKfxc7OxuNTv2qQHAaoRi+xPh6yiBBKpmx3QN7f4Tx5d6NRDJv2iaZWMO/TSuGSKYnfN7bLlIvUQbb5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779173419; c=relaxed/simple;
	bh=qLuIsgK7l4IYzZJAwe6cp+L6+Mtw6c1RNOkrQQdzblU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=msEvV5j2U9DAc/N85RNAKQCqsgtSo6X149CXXrWB0p6bCzgqxdq4tBx7dPra1kh6X/bGcfBeyMq5XKEeH1Vv1DzI7JtIS4HGmkIuX7JevLd4O58iuQZKjpACrO89pREuMgFL3osRGtUyduA2Zt9y0j78C5Tdl2ypVrBY3Kct8IU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--dylanbhatch.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=V9wRy1HY; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--dylanbhatch.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-c82c935e048so2675185a12.0
        for <live-patching@vger.kernel.org>; Mon, 18 May 2026 23:50:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779173416; x=1779778216; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=QOynkzgA4bQwckFWzlp5J6fVHPoziG2ITy2iJkH3gtM=;
        b=V9wRy1HYsiqVkBNGGG0Hp8SW0jmbZBiNf/K+ieRZzez/bE32EPuFmdTfegnzPrEJ5f
         SC5nZjczvG6wUQSproi/eeos7Uu7PkBg3iHjHnyhefceJ5ZIG4omLcr/TN7ECXIO7BCY
         fFzozauSN92Gp7X3135tftSwaPqZk4juqHUaZnvmkYx5woYR/jHBDYV3wHjmQNwNN9ud
         MKboYBTJMNiW7bcpqoHHh5NX1cCCYeCE8B8OodIx+HzJbf8ZMiCejo4dFhBF9fJKOukc
         ZmYb/UmUSMLdlQUNP44XF/axeodVBlRXrZRjavu2X3azUjfbOanXCkjngHN9u+0sqrbj
         gitA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779173416; x=1779778216;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QOynkzgA4bQwckFWzlp5J6fVHPoziG2ITy2iJkH3gtM=;
        b=IER73Xrb2y7LCnBKdAuqzxtseok75DBXifF8JTF/VuiFHHTxD0htvD6tiLZedx2qoe
         RYFQ9BDd8QSk88bE2jFCpA5aL0OeaSwUUQg/yFMn6H1v/fBMbuizVxvHOGC47MOMzbIy
         cpRcG0zOEq7j6HQ8uOKKIqURa+3GfO0xY6QcloOaTrk0HtPXFM9doEwL5T1mw1tGmVPl
         2Zt9HFn/7SpZ0hHzI9ae3eV3t2Y3v2dJiBjbr6bmYuQVk/CUZ7e+c3yivCdW/kO1+Z6l
         YuJwSZsz299fOdAvKX7yiFk23W9KpRIreqMPMcnEPYouT8/NcFFFWKdOICA8MEAmGLoP
         4jdw==
X-Forwarded-Encrypted: i=1; AFNElJ+lNyizB3CdGWmmUUpXQonUVRTLw5lBOWXNH69hAyShdNzaLg5fvvdJv1zN0VH8R3rgmPl08/B/1s7kbVYq@vger.kernel.org
X-Gm-Message-State: AOJu0YwErJqAbM8zJ2gvEhTw7spC5VKKxQiHWjszPu3zr0XCPwRIN6yq
	Q/CVbJsFClqrFDAzA5CcfNUSTnVDisOCyFEmiAOHZBIIqGIWlNVejhFhCFHS0Usc88R77niKD97
	BKQhkQ1jjMoEkYcF77rQvuBmJvw==
X-Received: from pgbcz13.prod.google.com ([2002:a05:6a02:230d:b0:c79:81bb:79ef])
 (user=dylanbhatch job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a20:3ca5:b0:399:831:cc29 with SMTP id adf61e73a8af0-3b22d3ecaddmr16431885637.23.1779173416349;
 Mon, 18 May 2026 23:50:16 -0700 (PDT)
Date: Tue, 19 May 2026 06:49:47 +0000
In-Reply-To: <20260519064950.493949-1-dylanbhatch@google.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260519064950.493949-1-dylanbhatch@google.com>
X-Mailer: git-send-email 2.54.0.563.g4f69b47b94-goog
Message-ID: <20260519064950.493949-7-dylanbhatch@google.com>
Subject: [PATCH v6 6/9] arm64/module, sframe: Add sframe support for modules
From: Dylan Hatch <dylanbhatch@google.com>
To: Roman Gushchin <roman.gushchin@linux.dev>, Weinan Liu <wnliu@google.com>, 
	Will Deacon <will@kernel.org>, Josh Poimboeuf <jpoimboe@kernel.org>, 
	Indu Bhagat <ibhagatgnu@gmail.com>, Peter Zijlstra <peterz@infradead.org>, 
	Steven Rostedt <rostedt@goodmis.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Jiri Kosina <jikos@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
	Jens Remus <jremus@linux.ibm.com>
Cc: Dylan Hatch <dylanbhatch@google.com>, Prasanna Kumar T S M <ptsm@linux.microsoft.com>, 
	Puranjay Mohan <puranjay@kernel.org>, Song Liu <song@kernel.org>, joe.lawrence@redhat.com, 
	linux-toolchains@vger.kernel.org, linux-kernel@vger.kernel.org, 
	live-patching@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	Randy Dunlap <rdunlap@infradead.org>, Mostafa Saleh <smostafa@google.com>, 
	Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_DKIM_ALLOW(-0.20)[google.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_TO(0.00)[linux.dev,google.com,kernel.org,gmail.com,infradead.org,goodmis.org,arm.com,linux.ibm.com];
	RCPT_COUNT_TWELVE(0.00)[24];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[dylanbhatch@google.com,live-patching@vger.kernel.org];
	TAGGED_FROM(0.00)[bounces-2859-lists,live-patching=lfdr.de];
	TAGGED_RCPT(0.00)[live-patching];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo]
X-Rspamd-Queue-Id: C828F57875F
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Add sframe table to mod_arch_specific and support sframe PC lookups when
an .sframe section can be found on incoming modules. SFRAME_F_FDE_SORTED
is not set for module .sframe, so FDES are sorted right after the sframe
header is read.

Signed-off-by: Weinan Liu <wnliu@google.com>
Suggested-by: Jens Remus <jremus@linux.ibm.com>
Reviewed-by: Jens Remus <jremus@linux.ibm.com>
Signed-off-by: Dylan Hatch <dylanbhatch@google.com>
---
 arch/arm64/include/asm/module.h |  6 +++
 arch/arm64/kernel/module.c      |  8 +++
 include/linux/sframe.h          |  3 ++
 kernel/unwind/sframe.c          | 90 +++++++++++++++++++++++++++++++--
 4 files changed, 104 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/module.h b/arch/arm64/include/asm/module.h
index fb9b88eebeb1..07f309c51eee 100644
--- a/arch/arm64/include/asm/module.h
+++ b/arch/arm64/include/asm/module.h
@@ -6,6 +6,7 @@
 #define __ASM_MODULE_H
 
 #include <asm-generic/module.h>
+#include <linux/sframe.h>
 
 struct mod_plt_sec {
 	int			plt_shndx;
@@ -17,6 +18,11 @@ struct mod_arch_specific {
 	struct mod_plt_sec	core;
 	struct mod_plt_sec	init;
 
+#ifdef CONFIG_HAVE_UNWIND_KERNEL_SFRAME
+	struct sframe_section sframe_sec;
+	bool sframe_init;
+#endif
+
 	/* for CONFIG_DYNAMIC_FTRACE */
 	struct plt_entry	*ftrace_trampolines;
 	struct plt_entry	*init_ftrace_trampolines;
diff --git a/arch/arm64/kernel/module.c b/arch/arm64/kernel/module.c
index 24adb581af0e..427f187e9531 100644
--- a/arch/arm64/kernel/module.c
+++ b/arch/arm64/kernel/module.c
@@ -18,6 +18,7 @@
 #include <linux/moduleloader.h>
 #include <linux/random.h>
 #include <linux/scs.h>
+#include <linux/sframe.h>
 
 #include <asm/alternative.h>
 #include <asm/insn.h>
@@ -515,5 +516,12 @@ int module_finalize(const Elf_Ehdr *hdr,
 		}
 	}
 
+	s = find_section(hdr, sechdrs, ".sframe");
+	if (s) {
+		struct module_memory *t = &me->mem[MOD_TEXT];
+
+		sframe_module_init(me, (void *)s->sh_addr, s->sh_size,
+				   t->base, t->size);
+	}
 	return module_init_ftrace_plt(hdr, sechdrs, me);
 }
diff --git a/include/linux/sframe.h b/include/linux/sframe.h
index 5b7341b61a7c..27f5a66190af 100644
--- a/include/linux/sframe.h
+++ b/include/linux/sframe.h
@@ -28,6 +28,7 @@ struct sframe_section {
 	unsigned long		fres_start;
 	unsigned long		fres_end;
 	unsigned int		num_fdes;
+	bool			fdes_sorted;
 
 	signed char		ra_off;
 	signed char		fp_off;
@@ -80,6 +81,8 @@ extern int sframe_find_kernel(unsigned long ip, struct unwind_frame *frame);
 #else
 
 static inline void __init init_sframe_table(void) {}
+static inline void sframe_module_init(struct module *mod, void *sframe, size_t sframe_size,
+				      void *text, size_t text_size) {}
 
 #endif /* CONFIG_HAVE_UNWIND_KERNEL_SFRAME */
 
diff --git a/kernel/unwind/sframe.c b/kernel/unwind/sframe.c
index c8ec1e9989fc..dfa013450705 100644
--- a/kernel/unwind/sframe.c
+++ b/kernel/unwind/sframe.c
@@ -12,6 +12,7 @@
 #include <linux/mm.h>
 #include <linux/string_helpers.h>
 #include <linux/sframe.h>
+#include <linux/sort.h>
 #include <linux/syscalls.h>
 #include <linux/unwind_types.h>
 #include <asm/unwind_sframe.h>
@@ -186,6 +187,9 @@ static __always_inline int __find_fde(struct sframe_section *sec,
 	struct sframe_fde_v3 *first, *low, *high, *found = NULL;
 	int ret;
 
+	if (!sec->fdes_sorted)
+		return -EINVAL;
+
 	first = (void *)sec->fdes_start;
 	low = first;
 	high = first + sec->num_fdes - 1;
@@ -740,7 +744,6 @@ static int sframe_read_header(struct sframe_section *sec)
 
 	if (shdr.preamble.magic != SFRAME_MAGIC ||
 	    shdr.preamble.version != SFRAME_VERSION_3 ||
-	    !(shdr.preamble.flags & SFRAME_F_FDE_SORTED) ||
 	    !(shdr.preamble.flags & SFRAME_F_FDE_FUNC_START_PCREL) ||
 	    shdr.auxhdr_len) {
 		dbg_sec("bad/unsupported sframe header\n");
@@ -770,6 +773,7 @@ static int sframe_read_header(struct sframe_section *sec)
 		return -EINVAL;
 	}
 
+	sec->fdes_sorted	= shdr.preamble.flags & SFRAME_F_FDE_SORTED;
 	sec->num_fdes		= num_fdes;
 	sec->fdes_start		= fdes_start;
 	sec->fres_start		= fres_start;
@@ -984,10 +988,27 @@ SYSCALL_DEFINE5(stacktrace_setup, int, op, unsigned long, addr_start,
 
 int sframe_find_kernel(unsigned long ip, struct unwind_frame *frame)
 {
-	if (!frame || !sframe_init)
+	struct sframe_section *sec;
+
+	if (!frame)
 		return -EINVAL;
 
-	return  __sframe_find(&kernel_sfsec, ip, frame);
+	if (is_ksym_addr(ip)) {
+		if (!sframe_init)
+			return -EINVAL;
+
+		sec = &kernel_sfsec;
+	} else {
+		struct module *mod;
+
+		mod = __module_address(ip);
+		if (!mod || !mod->arch.sframe_init)
+			return -EINVAL;
+
+		sec = &mod->arch.sframe_sec;
+	}
+
+	return  __sframe_find(sec, ip, frame);
 }
 
 void __init init_sframe_table(void)
@@ -1004,4 +1025,67 @@ void __init init_sframe_table(void)
 	sframe_init = true;
 }
 
+static int sframe_sort_cmp_fde(const void *a, const void *b)
+{
+	const struct sframe_fde_v3 *fde_a = a, *fde_b = b;
+	unsigned long func_start_a, func_start_b;
+
+	func_start_a = (unsigned long)fde_a + fde_a->func_start_off;
+	func_start_b = (unsigned long)fde_b + fde_b->func_start_off;
+
+	return cmp_int(func_start_a, func_start_b);
+}
+
+static void sframe_sort_swap_fde(void *a, void *b, int size)
+{
+	struct sframe_fde_v3 *fde_a = a, *fde_b = b;
+	struct sframe_fde_v3 temp;
+	long delta;
+
+	/* Swap potentially unaligned FDE */
+	memcpy(&temp, fde_a, sizeof(struct sframe_fde_v3));
+	memcpy(fde_a, fde_b, sizeof(struct sframe_fde_v3));
+	memcpy(fde_b, &temp, sizeof(struct sframe_fde_v3));
+
+	/* Adjust FDE function start offset from FDE */
+	delta = (long)((unsigned long)fde_b - (unsigned long)fde_a);
+	fde_a->func_start_off += delta;
+	fde_b->func_start_off -= delta;
+}
+
+static int sframe_sort_fdes(struct sframe_section *sec)
+{
+	void *fdes = (void *)sec->fdes_start;
+	size_t num_fdes = sec->num_fdes;
+
+	if (sec->sec_type != SFRAME_KERNEL)
+		return -EINVAL;
+	if (sec->fdes_sorted)
+		return 0;
+
+	sort(fdes, num_fdes, sizeof(struct sframe_fde_v3),
+	     sframe_sort_cmp_fde, sframe_sort_swap_fde);
+	sec->fdes_sorted = true;
+	return 0;
+}
+
+void sframe_module_init(struct module *mod, void *sframe, size_t sframe_size,
+			void *text, size_t text_size)
+{
+	struct sframe_section *sec = &mod->arch.sframe_sec;
+
+	sec->sec_type	 = SFRAME_KERNEL;
+	sec->sframe_start = (unsigned long)sframe;
+	sec->sframe_end   = (unsigned long)sframe + sframe_size;
+	sec->text_start   = (unsigned long)text;
+	sec->text_end     = (unsigned long)text + text_size;
+
+	if (WARN_ON(sframe_read_header(sec)))
+		return;
+	if (WARN_ON(sframe_sort_fdes(sec)))
+		return;
+
+	mod->arch.sframe_init = true;
+}
+
 #endif /* CONFIG_HAVE_UNWIND_KERNEL_SFRAME */
-- 
2.54.0.563.g4f69b47b94-goog


