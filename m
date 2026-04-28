Return-Path: <live-patching+bounces-2597-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id EMLRBuj+8GnubgEAu9opvQ
	(envelope-from <live-patching+bounces-2597-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Tue, 28 Apr 2026 20:39:36 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id A149648AC14
	for <lists+live-patching@lfdr.de>; Tue, 28 Apr 2026 20:39:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 152E83079E2D
	for <lists+live-patching@lfdr.de>; Tue, 28 Apr 2026 18:37:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B500B47CC67;
	Tue, 28 Apr 2026 18:37:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="uRZkCkQg"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF6B447B436
	for <live-patching@vger.kernel.org>; Tue, 28 Apr 2026 18:37:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777401450; cv=none; b=BPeNsieXRpnUYKMWwZDGeaIy5Skr4JdxNN50AvoK4SeUBWx8c3K/ZFTQSItW0AEWPbJAx7l2/PRxBs+pUMcY62O1O6Rm2s1v95EFJWpxZBknddtY+0I5jF5SYSI/D7vLLu2pTpSn9fwqtvhRFN4yh1xvwVslXxp1Db7GmBmEPHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777401450; c=relaxed/simple;
	bh=wm8fmz57HEth2J1hN6vgXStLpyz5KgZ/vbS889B0dtc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=BAmK2R27V7u48aaFi7WTUru81F7v2eN6Tmb7eQxapEZwySDnvG7W1oh0D3rsbBxz+ZTZmFEcmvWXBR4TYs4ZIeSNPxJdBgEwR0ElsvA9aixdKzkL5DLUPoAFJdyaVPzGSwf0nMnGS+ixIUKxeMSGg96kFJH4DKZAk/MQnWM0u8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--dylanbhatch.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=uRZkCkQg; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--dylanbhatch.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2b458add85aso25501445ad.2
        for <live-patching@vger.kernel.org>; Tue, 28 Apr 2026 11:37:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777401448; x=1778006248; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Goh3F7XcpkTSr7iRpzcfIAl6DDNpb912M5nWLNqSnmg=;
        b=uRZkCkQgy1PKvqXpmzO4WYWxYJLJbamh9mliJPRtSNHvwF907HMdmgAXWVhvINHonG
         jYPPNcBRkqHuOJ2+zoKypMm+LA7rWzEpgG3dI0O2jMJnRkJ6oKykwYofV3fWzA7bmebN
         j0+f6hP9wdQx1GWEkKmWRk4ja7H1WV1rIvK84anqqdmt8z95XsnqZTBOg93wvOdUASwU
         +i+z8d92fjSoNUTNi1ETzgwOnTCx6yPOyffCtQgkx/FTzYXjHjoAV4SlwiDrrY7fLuc8
         DZqF6uEZquvvETjiRANAIoWdVAtA7Ng2gE996+0RoZBk+M2ZiZTEQp0QRJoQQ33tWA/N
         7T8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777401448; x=1778006248;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Goh3F7XcpkTSr7iRpzcfIAl6DDNpb912M5nWLNqSnmg=;
        b=HFyVNqhSmQ+bqj4P2O5+gVHaaTG5BrP0BeB4244sbdAYVAfhNwqTgMUtAITtJ29OBi
         5C+pRXMPaE/1DEXKeyPUN7+Z0lrS9zOwT9sW0Tf3Wv+xXDT7xE0y6J3G/7CUVrW4R11p
         uWahF+FoSemKn7bkyxzfV7DH8MbDZpY+qQ0fVVPeU+r2S1QnGxPJSg+GuTgluKIVwvCn
         X2PgNfSnrl6LvksTOiAvymWq2NvXQHK0M2cF2bFfrNw0WR6bszzyN6IrP9EfUkMw3Z4i
         gcN7xCk3HWMuVlD8d9I8UhJgs568OlTqTSS1nqiEUb1idzONO4SJ17cTVqBjaxw6oHqw
         0/Nw==
X-Forwarded-Encrypted: i=1; AFNElJ/2AD+OiQvmiZmvRr6Oyc1dOk6yOr6R+UnPFxq+euXOtds+cPNp7PpkPi+nFeHybFmWTkkgM5APgmMlR2fJ@vger.kernel.org
X-Gm-Message-State: AOJu0YwnQ3/xmigiztbLiqXGUUC4RiYhlXwwNOUpW5aBekUhjIbYRbwr
	qKU2cR6HhlHtZ1QXI8zp/1yp4t6cbHhe8yt+BX6xpxUkNRIGJzDtY0Px/OSJNQuX2jzRPr7UDDN
	Qs/2Tog5iE7jGSKJWevXRC2kD6w==
X-Received: from plbkg3.prod.google.com ([2002:a17:903:603:b0:2b4:5fd0:a45d])
 (user=dylanbhatch job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:3583:b0:2b0:59c4:e9dc with SMTP id d9443c01a7336-2b987407cfamr4803655ad.22.1777401447910;
 Tue, 28 Apr 2026 11:37:27 -0700 (PDT)
Date: Tue, 28 Apr 2026 18:36:42 +0000
In-Reply-To: <20260428183643.3796063-1-dylanbhatch@google.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260428183643.3796063-1-dylanbhatch@google.com>
X-Mailer: git-send-email 2.54.0.545.g6539524ca2-goog
Message-ID: <20260428183643.3796063-8-dylanbhatch@google.com>
Subject: [PATCH v5 7/8] sframe: Introduce in-kernel SFRAME_VALIDATION
From: Dylan Hatch <dylanbhatch@google.com>
To: Roman Gushchin <roman.gushchin@linux.dev>, Weinan Liu <wnliu@google.com>, 
	Will Deacon <will@kernel.org>, Josh Poimboeuf <jpoimboe@kernel.org>, 
	Indu Bhagat <ibhagatgnu@gmail.com>, Peter Zijlstra <peterz@infradead.org>, 
	Steven Rostedt <rostedt@goodmis.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Jiri Kosina <jikos@kernel.org>, Jens Remus <jremus@linux.ibm.com>
Cc: Dylan Hatch <dylanbhatch@google.com>, Mark Rutland <mark.rutland@arm.com>, 
	Prasanna Kumar T S M <ptsm@linux.microsoft.com>, Puranjay Mohan <puranjay@kernel.org>, 
	Song Liu <song@kernel.org>, joe.lawrence@redhat.com, linux-toolchains@vger.kernel.org, 
	linux-kernel@vger.kernel.org, live-patching@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, Randy Dunlap <rdunlap@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: A149648AC14
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FREEMAIL_TO(0.00)[linux.dev,google.com,kernel.org,gmail.com,infradead.org,goodmis.org,arm.com,linux.ibm.com];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[21];
	TAGGED_FROM(0.00)[bounces-2597-lists,live-patching=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[dylanbhatch@google.com,live-patching@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	TAGGED_RCPT(0.00)[live-patching];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]

Generalize the __safe* helpers to support a non-user-access code path.

This requires arch-specific function address validation. This is because
arm64 vmlinux keeps .exit.text (normally discarded), and .rodata.text
sections both of which lie outside the bounds of the normal .text.
.rodata.text contains code that is never executed by the kernel mapping,
but for which the toolchain nonetheless generates sframe data, and needs
to be considered valid for a PC lookup.

Additionally .init.text lies outside .text for all arches and must be
accounted for as well.

Suggested-by: Jens Remus <jremus@linux.ibm.com>
Reviewed-by: Jens Remus <jremus@linux.ibm.com>
Signed-off-by: Dylan Hatch <dylanbhatch@google.com>
---
 arch/Kconfig                           |  2 +-
 arch/arm64/include/asm/sections.h      |  1 +
 arch/arm64/include/asm/unwind_sframe.h | 47 ++++++++++++++++++++++++++
 arch/arm64/kernel/vmlinux.lds.S        |  2 ++
 include/linux/sframe.h                 |  2 ++
 kernel/unwind/sframe.c                 | 25 ++++++++++++--
 6 files changed, 76 insertions(+), 3 deletions(-)

diff --git a/arch/Kconfig b/arch/Kconfig
index 8d27b3249e7a..a528f5b23647 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -503,7 +503,7 @@ config HAVE_UNWIND_USER_SFRAME
 
 config SFRAME_VALIDATION
 	bool "Enable .sframe section debugging"
-	depends on HAVE_UNWIND_USER_SFRAME
+	depends on UNWIND_SFRAME_LOOKUP
 	depends on DYNAMIC_DEBUG
 	help
 	  When adding an .sframe section for a task, validate the entire
diff --git a/arch/arm64/include/asm/sections.h b/arch/arm64/include/asm/sections.h
index 51b0d594239e..5edb4304f661 100644
--- a/arch/arm64/include/asm/sections.h
+++ b/arch/arm64/include/asm/sections.h
@@ -23,6 +23,7 @@ extern char __irqentry_text_start[], __irqentry_text_end[];
 extern char __mmuoff_data_start[], __mmuoff_data_end[];
 extern char __entry_tramp_text_start[], __entry_tramp_text_end[];
 extern char __relocate_new_kernel_start[], __relocate_new_kernel_end[];
+extern char _srodatatext[], _erodatatext[];
 
 static inline size_t entry_tramp_text_size(void)
 {
diff --git a/arch/arm64/include/asm/unwind_sframe.h b/arch/arm64/include/asm/unwind_sframe.h
index 876412881196..66ebe5f38bd0 100644
--- a/arch/arm64/include/asm/unwind_sframe.h
+++ b/arch/arm64/include/asm/unwind_sframe.h
@@ -2,7 +2,54 @@
 #ifndef _ASM_ARM64_UNWIND_SFRAME_H
 #define _ASM_ARM64_UNWIND_SFRAME_H
 
+#include <linux/module.h>
+#include <linux/sframe.h>
+#include <asm/sections.h>
+
 #define SFRAME_REG_SP	31
 #define SFRAME_REG_FP	29
 
+static inline bool sframe_func_start_addr_valid(struct sframe_section *sec,
+						unsigned long func_addr)
+{
+	/* Common case for unwinding */
+	if (sec->text_start <= func_addr && func_addr < sec->text_end)
+		return true;
+
+	if (sec->sec_type != SFRAME_KERNEL)
+		return false;
+
+	/*
+	 * Account for vmlinux and module code outside the normal .text section.
+	 * The toolchain still generates sframe data for these functions, so
+	 * sframe lookups on them should be allowed.
+	 */
+	if (sec == &kernel_sfsec) {
+		if (is_kernel_inittext(func_addr))
+			return true;
+
+		/* .exit.text is retained in vmlinux on arm64. */
+		if (func_addr >= (unsigned long)__exittext_begin &&
+		    func_addr < (unsigned long)__exittext_end)
+			return true;
+
+
+		/*
+		 * .rodata.text is never executed from the kernel mapping, but
+		 * still has sframe data
+		 */
+		if (func_addr >= (unsigned long)_srodatatext &&
+		    func_addr < (unsigned long)_erodatatext)
+			return true;
+	} else {
+		struct module *mod = container_of(sec, struct module,
+						  arch.sframe_sec);
+		if (within_module_mem_type(func_addr, mod, MOD_INIT_TEXT))
+			return true;
+	}
+
+	return false;
+}
+#define sframe_func_start_addr_valid sframe_func_start_addr_valid
+
 #endif /* _ASM_ARM64_UNWIND_SFRAME_H */
diff --git a/arch/arm64/kernel/vmlinux.lds.S b/arch/arm64/kernel/vmlinux.lds.S
index 2964aad0362e..8c2dae6e7a86 100644
--- a/arch/arm64/kernel/vmlinux.lds.S
+++ b/arch/arm64/kernel/vmlinux.lds.S
@@ -213,12 +213,14 @@ SECTIONS
 
 	/* code sections that are never executed via the kernel mapping */
 	.rodata.text : {
+		_srodatatext = .;
 		TRAMP_TEXT
 		HIBERNATE_TEXT
 		KEXEC_TEXT
 		IDMAP_TEXT
 		. = ALIGN(PAGE_SIZE);
 	}
+	_erodatatext = .;
 
 	idmap_pg_dir = .;
 	. += PAGE_SIZE;
diff --git a/include/linux/sframe.h b/include/linux/sframe.h
index 27f5a66190af..ac3aa9db7d91 100644
--- a/include/linux/sframe.h
+++ b/include/linux/sframe.h
@@ -34,6 +34,8 @@ struct sframe_section {
 	signed char		fp_off;
 };
 
+extern struct sframe_section kernel_sfsec __ro_after_init;
+
 #endif /* CONFIG_UNWIND_SFRAME_LOOKUP */
 
 #ifdef CONFIG_HAVE_UNWIND_USER_SFRAME
diff --git a/kernel/unwind/sframe.c b/kernel/unwind/sframe.c
index 70001c8e586d..99c2a39c51ce 100644
--- a/kernel/unwind/sframe.c
+++ b/kernel/unwind/sframe.c
@@ -21,10 +21,18 @@
 #include "sframe.h"
 #include "sframe_debug.h"
 
+#ifndef sframe_func_start_addr_valid
+static inline bool sframe_func_start_addr_valid(struct sframe_section *sec,
+						unsigned long func_addr)
+{
+	return (sec->text_start <= func_addr && func_addr < sec->text_end);
+}
+#endif
+
 #ifdef CONFIG_HAVE_UNWIND_KERNEL_SFRAME
 
 static bool sframe_init __ro_after_init;
-static struct sframe_section kernel_sfsec __ro_after_init;
+struct sframe_section kernel_sfsec __ro_after_init;
 
 #endif /* CONFIG_HAVE_UNWIND_KERNEL_SFRAME */
 
@@ -152,7 +160,7 @@ static __always_inline int __read_fde(struct sframe_section *sec,
 		  sizeof(struct sframe_fde_v3), Efault);
 
 	func_addr = fde_addr + _fde.func_start_off;
-	if (func_addr < sec->text_start || func_addr > sec->text_end)
+	if (!sframe_func_start_addr_valid(sec, func_addr))
 		return -EINVAL;
 
 	fda_addr = sec->fres_start + _fde.fres_off;
@@ -636,6 +644,9 @@ static int safe_read_fde(struct sframe_section *sec,
 {
 	int ret;
 
+	if (sec->sec_type == SFRAME_KERNEL)
+		return __read_fde(sec, fde_num, fde);
+
 	if (!user_read_access_begin((void __user *)sec->sframe_start,
 				    sec->sframe_end - sec->sframe_start))
 		return -EFAULT;
@@ -651,6 +662,9 @@ static int safe_read_fre(struct sframe_section *sec,
 {
 	int ret;
 
+	if (sec->sec_type == SFRAME_KERNEL)
+		return __read_fre(sec, fde, fre_addr, fre);
+
 	if (!user_read_access_begin((void __user *)sec->sframe_start,
 				    sec->sframe_end - sec->sframe_start))
 		return -EFAULT;
@@ -665,6 +679,9 @@ static int safe_read_fre_datawords(struct sframe_section *sec,
 {
 	int ret;
 
+	if (sec->sec_type == SFRAME_KERNEL)
+		return __read_fre_datawords(sec, fde, fre);
+
 	if (!user_read_access_begin((void __user *)sec->sframe_start,
 				    sec->sframe_end - sec->sframe_start))
 		return -EFAULT;
@@ -1013,6 +1030,8 @@ void __init init_sframe_table(void)
 
 	if (WARN_ON(sframe_read_header(&kernel_sfsec)))
 		return;
+	if (WARN_ON(sframe_validate_section(&kernel_sfsec)))
+		return;
 
 	sframe_init = true;
 }
@@ -1031,6 +1050,8 @@ void sframe_module_init(struct module *mod, void *sframe, size_t sframe_size,
 
 	if (WARN_ON(sframe_read_header(&sec)))
 		return;
+	if (WARN_ON(sframe_validate_section(&sec)))
+		return;
 
 	mod->arch.sframe_sec = sec;
 	mod->arch.sframe_init = true;
-- 
2.54.0.545.g6539524ca2-goog


