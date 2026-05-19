Return-Path: <live-patching+bounces-2860-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id gPQhLc8JDGo5UQUAu9opvQ
	(envelope-from <live-patching+bounces-2860-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Tue, 19 May 2026 08:57:19 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 1D3BC578785
	for <lists+live-patching@lfdr.de>; Tue, 19 May 2026 08:57:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id EC49830A23A1
	for <lists+live-patching@lfdr.de>; Tue, 19 May 2026 06:50:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A212D3ACA60;
	Tue, 19 May 2026 06:50:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="YBGh9IYG"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29ABE3A1683
	for <live-patching@vger.kernel.org>; Tue, 19 May 2026 06:50:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779173421; cv=none; b=vE0PcSfiriiCaEJt6WdjSkU/N8leaCqbN9BMTAIxXiWjRinT3q1hinsd5E/NQu6BiAb0X1oE4LvQUKzr41T9rKHEouvM7qL+07BGYdWnzz42Ts04bF4t/nIMJksQgBvpjP1Ae6L/Kq5ysyTYdw4KQjUUAOQgFQooFJx8+3yFw4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779173421; c=relaxed/simple;
	bh=Wv6U+LOAIjI5bqPYzTbLIlOmqvtRtqweB9OdkV7AoY8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=fqak3l/sfeP/yGVBqVzfHU06HGp1n2XZkh7u2nuz0KWY1+TOfRS7f6U/ucA0rRLvGx50yOcdGzHQHsZORV9RGMLMjlk9yvGSxzwzLPtrmJMavHAD+ZfniSCWA1SKhQQxA8kFHufUzlo8pp/ObY7AT3i8WFYosg4xbVgHClMMef4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--dylanbhatch.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=YBGh9IYG; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--dylanbhatch.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-368edd5fec4so3525844a91.0
        for <live-patching@vger.kernel.org>; Mon, 18 May 2026 23:50:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779173418; x=1779778218; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=09BVAzCIUqOtkX4/stwVI7xX6xNgSRElI8wKp45KCp0=;
        b=YBGh9IYGJXyFO5TwX57LRjmGkZ4NMCmbTzgF43//Dx9tiMa0PUrnnUp2SrvxBYzgl7
         2uVNv7j0FZA2E9kSfFmzq5lREMeBRNlBw3Y5DRjfyXjUAHnUFhGkMlKTw+tYwjoliFaV
         wptu1Iw/N1HhMHILgphybfHF7vAWpB8f4eykvsy0RfKucJgPGiDjg4EVSiudZ7xXzzaQ
         uCkYdSiI2OgPQrLibpvrYSP/svj0pXvPbIdoBDIqgfuLPB35uJrAmiCzfkgKgXL3zSVm
         HIOCegqxRQbRULCfKbd++nZh16+oPlSqZU6NfYwV7RI3gx4Q/oR+9vSkPbmKnjSbow3R
         88Ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779173418; x=1779778218;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=09BVAzCIUqOtkX4/stwVI7xX6xNgSRElI8wKp45KCp0=;
        b=dDduTz3y3c8l5+fWZbRq+WyuwDbm+UiFOleFQ92qu1kji8EZDpmSN9QKLTU5rSXfPS
         vCJXUrRhEppaV9PrUOXHSxhr2HIBhTv6X2JaDOd+CiswniyRD87UeeyXjQhJZH8P+Z+x
         YzvrkfwHASMLjtk4rKKaYwtjxFSLA02jkxKkLo8HhlMuVyElTs+8NbCM9u0XT455xv4C
         HRVupScovtqquaPzyzj2JfZOSOvddpgujgJKAD7zsn868LE9IUwCyr9F9QTC/Dbnhn1p
         +/DCgX7G/m/phUBcuhDb3xXQ3O1LDTHCShH+Tnkokr4LHxSHEpYy48TpTQk+MfyBRQKE
         IsJA==
X-Forwarded-Encrypted: i=1; AFNElJ8Gu3yOR8IFP0cYOVVAXtEZwGy1CyP9qNy5m1/t8wmbmtHaHG8C16mXnq4HQ4hWfeylq50wCpT73TF7yz4r@vger.kernel.org
X-Gm-Message-State: AOJu0YzfAVRPjvaby/nT4BFeXU14u3WOsSusicmIgPZnHj4iwd0fG/jm
	bh7j7yHVijjrBvP1kSeLt/FCRKc1Z1myjmg1ty7oDA4IHTi/90dm5ZgmVrzbay10EXyjEsYG6g7
	p1+9zuJir1b8eSWuV8NvY/z+O6A==
X-Received: from pjbta4.prod.google.com ([2002:a17:90b:4ec4:b0:368:edd5:fe57])
 (user=dylanbhatch job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:58c4:b0:367:b9ed:665f with SMTP id 98e67ed59e1d1-36951a6cdf4mr16650731a91.13.1779173418242;
 Mon, 18 May 2026 23:50:18 -0700 (PDT)
Date: Tue, 19 May 2026 06:49:48 +0000
In-Reply-To: <20260519064950.493949-1-dylanbhatch@google.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260519064950.493949-1-dylanbhatch@google.com>
X-Mailer: git-send-email 2.54.0.563.g4f69b47b94-goog
Message-ID: <20260519064950.493949-8-dylanbhatch@google.com>
Subject: [PATCH v6 7/9] sframe: Introduce in-kernel SFRAME_VALIDATION
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
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
	TAGGED_FROM(0.00)[bounces-2860-lists,live-patching=lfdr.de];
	TAGGED_RCPT(0.00)[live-patching];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Queue-Id: 1D3BC578785
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

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
 arch/arm64/include/asm/unwind_sframe.h | 46 ++++++++++++++++++++++++++
 arch/arm64/kernel/vmlinux.lds.S        |  2 ++
 include/linux/sframe.h                 |  2 ++
 kernel/unwind/sframe.c                 | 25 ++++++++++++--
 6 files changed, 75 insertions(+), 3 deletions(-)

diff --git a/arch/Kconfig b/arch/Kconfig
index f931b5848593..fa1f43f47a53 100644
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
index 876412881196..eb269a54b9ef 100644
--- a/arch/arm64/include/asm/unwind_sframe.h
+++ b/arch/arm64/include/asm/unwind_sframe.h
@@ -2,7 +2,53 @@
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
index e1ac876200a3..68700b4d5070 100644
--- a/arch/arm64/kernel/vmlinux.lds.S
+++ b/arch/arm64/kernel/vmlinux.lds.S
@@ -225,12 +225,14 @@ SECTIONS
 
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
index dfa013450705..e8ede0343cb2 100644
--- a/kernel/unwind/sframe.c
+++ b/kernel/unwind/sframe.c
@@ -24,10 +24,18 @@
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
 
@@ -155,7 +163,7 @@ static __always_inline int __read_fde(struct sframe_section *sec,
 		  sizeof(struct sframe_fde_v3), Efault);
 
 	func_addr = fde_addr + _fde.func_start_off;
-	if (func_addr < sec->text_start || func_addr >= sec->text_end)
+	if (!sframe_func_start_addr_valid(sec, func_addr))
 		return -EINVAL;
 
 	fda_addr = sec->fres_start + _fde.fres_off;
@@ -607,6 +615,9 @@ static int safe_read_fde(struct sframe_section *sec,
 {
 	int ret;
 
+	if (sec->sec_type == SFRAME_KERNEL)
+		return __read_fde(sec, fde_num, fde);
+
 	if (!user_read_access_begin((void __user *)sec->sframe_start,
 				    sec->sframe_end - sec->sframe_start))
 		return -EFAULT;
@@ -622,6 +633,9 @@ static int safe_read_fre(struct sframe_section *sec,
 {
 	int ret;
 
+	if (sec->sec_type == SFRAME_KERNEL)
+		return __read_fre(sec, fde, fre_addr, fre);
+
 	if (!user_read_access_begin((void __user *)sec->sframe_start,
 				    sec->sframe_end - sec->sframe_start))
 		return -EFAULT;
@@ -636,6 +650,9 @@ static int safe_read_fre_datawords(struct sframe_section *sec,
 {
 	int ret;
 
+	if (sec->sec_type == SFRAME_KERNEL)
+		return __read_fre_datawords(sec, fde, fre);
+
 	if (!user_read_access_begin((void __user *)sec->sframe_start,
 				    sec->sframe_end - sec->sframe_start))
 		return -EFAULT;
@@ -1021,6 +1038,8 @@ void __init init_sframe_table(void)
 
 	if (WARN_ON(sframe_read_header(&kernel_sfsec)))
 		return;
+	if (WARN_ON(sframe_validate_section(&kernel_sfsec)))
+		return;
 
 	sframe_init = true;
 }
@@ -1084,6 +1103,8 @@ void sframe_module_init(struct module *mod, void *sframe, size_t sframe_size,
 		return;
 	if (WARN_ON(sframe_sort_fdes(sec)))
 		return;
+	if (WARN_ON(sframe_validate_section(sec)))
+		return;
 
 	mod->arch.sframe_init = true;
 }
-- 
2.54.0.563.g4f69b47b94-goog


