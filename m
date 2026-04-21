Return-Path: <live-patching+bounces-2419-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id SGnJORQB6GlJEAIAu9opvQ
	(envelope-from <live-patching+bounces-2419-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Wed, 22 Apr 2026 00:58:28 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 4D69D4405BA
	for <lists+live-patching@lfdr.de>; Wed, 22 Apr 2026 00:58:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 342583116740
	for <lists+live-patching@lfdr.de>; Tue, 21 Apr 2026 22:52:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 11F183A7597;
	Tue, 21 Apr 2026 22:52:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ZPM7ywUu"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAF9D3A75B3
	for <live-patching@vger.kernel.org>; Tue, 21 Apr 2026 22:52:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776811953; cv=none; b=bpBM0tCO56RxDedSLrBv+VoeN/Zl0TklhVgTggZjZfNuj6WX8+T5nNAyFtm2eALJLreKL6CBPl1oq+yoKSslg7aB4wJTR5TD7SDfdkFt8SXvMV+uLDemJqskSukzqOLW1Y8q46ubvmt/PJ7sPyABqRwiL4Kpg5WssiUbQ8/easg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776811953; c=relaxed/simple;
	bh=EJAc+0FQbTFEsl6Wy8lawnseH2UBpttzQ7ZGI4ry5HY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=M+MsWlCS/xPnVyhEYOejXhuN1gxqV3prPJ5bf2MNEXFcfNXv96lwBrCCeoHa5By9e1BdQkijaJFBwDroZXm+ijKvD8wLCQo9w3BY5WasBAfBgE56iVzbJxwaKrrbJewi9QT8MzSKWjl4MiI8Iq0mL3U504dHVFD/8tR6bcRc8Zo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--dylanbhatch.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ZPM7ywUu; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--dylanbhatch.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-82f8bbb4045so2987180b3a.2
        for <live-patching@vger.kernel.org>; Tue, 21 Apr 2026 15:52:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1776811948; x=1777416748; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=nEd1rBfN1UN8u0n4o9rP4+aQumOHvzk1E9l2M+hyRdQ=;
        b=ZPM7ywUuHLJNnZ0bGID8a7NzM6a0LBS/M+Mhv0AbYI9M5D3vMIf+OkhiOZHCd9ufsi
         TLqEvP22nHUarBgF6oyYraz9T/JOlkP9JWBAJFAEIL5kDfMGMzcU/hxG64JDcfYG5kSg
         KDWq4AmQYP9FktptHEueNc8EOmR4ZmEfMwrJ7Q6yOd1znPcmiDXMtxypfUKl0atJCg99
         31CWD1uFG7k5zOWmrzCl1/jvQTrPYzppdYyIGk+QX648ggCP5smz5G1P7nHfennwtGwN
         6yU6+pONqiOUgkP2CWuR4VSA+1lmeySxZPdJVJ6kkDfJp0XKJNPi++rDSU2bpzNxHFgL
         rHfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776811948; x=1777416748;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nEd1rBfN1UN8u0n4o9rP4+aQumOHvzk1E9l2M+hyRdQ=;
        b=WSjgkZbO3eRDP9dGLJOMqkLG8QjRmDUnWZmyI1Kif3XzJFfUIi/BVjXWzXHshxARul
         +RFvCdQFKkVsSxTZqhAEW5LpXR0QVEhW5HyPhR4pPQ+X7IcTz0MWnPEtyC4YvtJ6Xd9p
         GKGWqgACa29NOcHmGy/u8Tj6onHAnUK3JkAgXNfdF9L08Lb8oHLZMUDbXoQ3MEu9s4mS
         lMn4k+gyF7bzGoF24ORfkhzkvDp0DMomeIXS4y9PlmjFGCWU8BkRag+X9e6iScp31ORI
         pwXHBecGxdrrx/wWOjY3wcuKpD4KWGtGG1wdaaa6tPWk8WZ9/yGUvd10j1mRNMDGaYSS
         9F9w==
X-Forwarded-Encrypted: i=1; AFNElJ8u/RwbyjybfGESJL6zgN5YFAgPqVJFYeECx+iUbq0VBfjHSY61kmYZK6NpupSwuk1Mc4hRGQYkmrzQSkwj@vger.kernel.org
X-Gm-Message-State: AOJu0Yyx7SpQSB4l8UOA+T6wrSOIxuse0IWC4s8XnNBjAtTzgEAZ4Nfd
	72bd3CXTF2BaTAwT7DZkhbdTBdnUKdErLkFYNxh5rFOyzNBjj3c8/dEn1zv1nIw6VHyiZ8c/lzZ
	uFmrjegqqWKBbME8ysMy1Ag1lfg==
X-Received: from pfoo23.prod.google.com ([2002:a05:6a00:1a17:b0:82f:aad4:3985])
 (user=dylanbhatch job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:a90:b0:827:433c:ba7e with SMTP id d2e1a72fcca58-82f8c970703mr20257960b3a.41.1776811948135;
 Tue, 21 Apr 2026 15:52:28 -0700 (PDT)
Date: Tue, 21 Apr 2026 22:51:59 +0000
In-Reply-To: <20260421225200.1198447-1-dylanbhatch@google.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260421225200.1198447-1-dylanbhatch@google.com>
X-Mailer: git-send-email 2.54.0.rc1.555.g9c883467ad-goog
Message-ID: <20260421225200.1198447-8-dylanbhatch@google.com>
Subject: [PATCH v4 7/8] sframe: Introduce in-kernel SFRAME_VALIDATION
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
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
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
	TAGGED_FROM(0.00)[bounces-2419-lists,live-patching=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[dylanbhatch@google.com,live-patching@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TAGGED_RCPT(0.00)[live-patching];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 4D69D4405BA
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Generalize the __safe* helpers to support a non-user-access code path.

This requires arch-specific function address validation. This is because
arm64 vmlinux has an .rodata.text section which lies outside the bounds
of the normal .text. It contains code that is never executed by the
kernel mapping, but for which the toolchain nonetheless generates sframe
data, and needs to be considered valid for a PC lookup.

This arch-specific address validation logic is only necessary to support
SFRAME_VALIDATION for the vmlinux .sframe, since these .rodata.text
functions would never be encountered during normal unwinding.

Signed-off-by: Dylan Hatch <dylanbhatch@google.com>
Suggested-by: Jens Remus <jremus@linux.ibm.com>
---
 arch/Kconfig                           |  2 +-
 arch/arm64/include/asm/sections.h      |  1 +
 arch/arm64/include/asm/unwind_sframe.h | 21 +++++++++++++++++++++
 arch/arm64/kernel/vmlinux.lds.S        |  2 ++
 include/linux/sframe.h                 |  2 ++
 kernel/unwind/sframe.c                 | 25 +++++++++++++++++++++++--
 6 files changed, 50 insertions(+), 3 deletions(-)

diff --git a/arch/Kconfig b/arch/Kconfig
index 8d27b3249e7a..cd4849bb675c 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -503,7 +503,7 @@ config HAVE_UNWIND_USER_SFRAME
 
 config SFRAME_VALIDATION
 	bool "Enable .sframe section debugging"
-	depends on HAVE_UNWIND_USER_SFRAME
+	depends on SFRAME_LOOKUP
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
index 876412881196..1e9d7b74c0c8 100644
--- a/arch/arm64/include/asm/unwind_sframe.h
+++ b/arch/arm64/include/asm/unwind_sframe.h
@@ -2,7 +2,28 @@
 #ifndef _ASM_ARM64_UNWIND_SFRAME_H
 #define _ASM_ARM64_UNWIND_SFRAME_H
 
+#include <linux/sframe.h>
+#include <asm/sections.h>
+
 #define SFRAME_REG_SP	31
 #define SFRAME_REG_FP	29
 
+static inline bool sframe_func_start_addr_valid(struct sframe_section *sec,
+						unsigned long func_addr)
+{
+	/*
+	 * The .rodata.text section is outside the normal kernel .text, but the
+	 * toolchain still generates sframe data for it. Allow sframe lookups
+	 * for these functions, even though they are never executed from the
+	 * kernel mapping.
+	 */
+	if (sec->sec_type == SFRAME_KERNEL && sec == &kernel_sfsec &&
+	    func_addr >= (unsigned long)_srodatatext &&
+	    func_addr < (unsigned long)_erodatatext)
+		return true;
+
+	return (sec->text_start <= func_addr && func_addr < sec->text_end);
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
index 20178e02f428..d76968547bad 100644
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
2.54.0.rc1.555.g9c883467ad-goog


