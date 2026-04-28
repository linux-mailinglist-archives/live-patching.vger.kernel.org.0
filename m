Return-Path: <live-patching+bounces-2591-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id aHlFLnD+8GnubgEAu9opvQ
	(envelope-from <live-patching+bounces-2591-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Tue, 28 Apr 2026 20:37:36 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 3F50748ABA1
	for <lists+live-patching@lfdr.de>; Tue, 28 Apr 2026 20:37:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 910C730A85A5
	for <lists+live-patching@lfdr.de>; Tue, 28 Apr 2026 18:37:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 49BC947AF57;
	Tue, 28 Apr 2026 18:37:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Cz3/+s3R"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88DC947AF6D
	for <live-patching@vger.kernel.org>; Tue, 28 Apr 2026 18:37:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777401432; cv=none; b=AoTaSmEQ4ByKV4EROgMLtqaGhxLYzk4mYb1bmFvNA3hYS6b94PyW/Qtzf29KbuDjTwiw7x96E5Z/tiHKl3NvQDvXJ3n2wImro0ttZOEcjw1OmgWDAKHA79LNJn5FoQBljF01c6Av/G2+s3nPNpxnnnyYVPli8FxUl6GBaUadSVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777401432; c=relaxed/simple;
	bh=Lo85YR5j9U8ig7qvJ3SItDU29ffD3ql/EbDOKlz8kVY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=mPYr9I7qZlhfVC6uXMaQ0+k3TGd7rKrOjlgqG2Zwcbh6ekMTDVBSGVOOlFASV/jOjBFTECXQW7mc03xrF+zyssRw19oaA2uWkOF5rS/o/Eh0diNil+a5/lGpFA/P4Zx0Cr6cDMJETCFwmk2LYa3B1qmmIdrSnv1KuHy79hrJCf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--dylanbhatch.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Cz3/+s3R; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--dylanbhatch.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-82f756ebd0dso7809913b3a.1
        for <live-patching@vger.kernel.org>; Tue, 28 Apr 2026 11:37:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777401429; x=1778006229; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=cR5jdpb+bWj/e77nnnl7XPxPTyO+ySghN9I5TqEyziU=;
        b=Cz3/+s3RN4oQ1yCWcR9gso2lZ07Mg+LgYwayaSQYuCvnI1/ObvA+Y722dMVqlvM+XM
         +JaBzWvUSd2zTBg1fJ2ETBQlXx5arp6WKSN3gvy+1gDVMEJcAXEkrQ8hVmp7bmtw3U85
         9Z7PPEpai4QSyujDLQXZDfBWRxcEh5cWLB25qdBwRst4gPrhyU67jXfblD5BoF/XGIeg
         OY9HIZFFYN8T/2n4K5sLhnaSNc2H88Z+rk9FqOkW0vMx/JoH36kBTrkHFqh+q4xbI9VD
         ocs6BFFOd70MfOnPsAKSobAv7CIrYUS6vJpZJyRaIm6hpO9oe0UpfECJ3k3NB6sp1HxU
         FJLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777401429; x=1778006229;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cR5jdpb+bWj/e77nnnl7XPxPTyO+ySghN9I5TqEyziU=;
        b=gOMug2XERZ1g6SIE/jsnK4zT/kx/8blH1jniSWCtqJyKGGEsQUYFOLG5Bleuc3U0Ya
         Ad8zjcX+sC31mWIRg7utiJU9ND3NQS4XuYqyJc8yXzNB5GlvvEpDifikWkv1grhYW6sg
         whGluwthJ2kYTsI7igXaz0P1nAPmj2JZCLQoOPDx689zafMEQnea3VWXYO06l8OIqK1T
         p01yWOmRKxzY5xqtql2BpL4T5OblZQBpq2FIFsgHwFdSTp/IV6n6vK1kwxDfuNJ8tNzF
         iCIvOtfgQoyi+T/tVkglKg3fiQXdpEnHL8iOSviOfY6kUmL95vK9vOtIcK2aU8vFvS7n
         MxWA==
X-Forwarded-Encrypted: i=1; AFNElJ+gPXoygjX1tJDgZzyDKEdQQD3CtNfNdULL2MzpLUjQ8JAgw5Tt2zrFUp6zzyXj4LUC/fGLBcb87+UyF3im@vger.kernel.org
X-Gm-Message-State: AOJu0YxEUKpEQg12OA09AB2Wsi0aqYQwcoFZP/mFgMNNbrGKr99a0bB7
	+jqLeqCPCfy6RRxBJgoQ0hUUdjvoDCYy5hpZKk7pPEpihoTxJcaBkg617gf5gwT4t8tNcVbjX44
	ls3LeCuAAZSo40xOGz8QTab2aVg==
X-Received: from pfnw7.prod.google.com ([2002:aa7:8587:0:b0:82f:5a4:a02c])
 (user=dylanbhatch job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:4b0c:b0:82f:5726:be23 with SMTP id d2e1a72fcca58-834ddc94432mr4138635b3a.49.1777401428545;
 Tue, 28 Apr 2026 11:37:08 -0700 (PDT)
Date: Tue, 28 Apr 2026 18:36:36 +0000
In-Reply-To: <20260428183643.3796063-1-dylanbhatch@google.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260428183643.3796063-1-dylanbhatch@google.com>
X-Mailer: git-send-email 2.54.0.545.g6539524ca2-goog
Message-ID: <20260428183643.3796063-2-dylanbhatch@google.com>
Subject: [PATCH v5 1/8] sframe: Allow kernelspace sframe sections
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
X-Rspamd-Queue-Id: 3F50748ABA1
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-2591-lists,live-patching=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_TO(0.00)[linux.dev,google.com,kernel.org,gmail.com,infradead.org,goodmis.org,arm.com,linux.ibm.com];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[21];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[dylanbhatch@google.com,live-patching@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TAGGED_RCPT(0.00)[live-patching];
	TO_DN_SOME(0.00)[]

Generalize the sframe lookup code to support kernelspace sections. This
is done by defining a SFRAME_LOOKUP option that can be activated
separate from HAVE_UNWIND_USER_SFRAME, as there will be other client to
this library than just userspace unwind.

Sframe section location is now tracked in a separate sec_type field to
determine whether user-access functions are necessary to read the sframe
data. Relevant type delarations are moved and renamed to reflect the
non-user sframe support.

Reviewed-by: Jens Remus <jremus@linux.ibm.com>
Signed-off-by: Dylan Hatch <dylanbhatch@google.com>
---
 MAINTAINERS                                   |   2 +-
 arch/Kconfig                                  |   4 +
 .../{unwind_user_sframe.h => unwind_sframe.h} |   6 +-
 arch/x86/include/asm/unwind_user.h            |  12 +-
 include/linux/sframe.h                        |  48 ++--
 include/linux/unwind_types.h                  |  46 +++
 include/linux/unwind_user_types.h             |  41 ---
 kernel/unwind/Makefile                        |   2 +-
 kernel/unwind/sframe.c                        | 270 ++++++++++++------
 kernel/unwind/user.c                          |  41 +--
 10 files changed, 293 insertions(+), 179 deletions(-)
 rename arch/x86/include/asm/{unwind_user_sframe.h => unwind_sframe.h} (50%)
 create mode 100644 include/linux/unwind_types.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 8c46465ee7a9..cfc7dec88da4 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -27557,7 +27557,7 @@ F:	Documentation/driver-api/uio-howto.rst
 F:	drivers/uio/
 F:	include/linux/uio_driver.h
 
-USERSPACE STACK UNWINDING
+STACK UNWINDING
 M:	Josh Poimboeuf <jpoimboe@kernel.org>
 M:	Steven Rostedt <rostedt@goodmis.org>
 S:	Maintained
diff --git a/arch/Kconfig b/arch/Kconfig
index f1ed8bc0806d..d7caf2e245ce 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -486,6 +486,9 @@ config AS_SFRAME3
 	def_bool $(as-instr,.cfi_startproc\n.cfi_endproc,-Wa$(comma)--gsframe-3)
 	select AS_SFRAME
 
+config UNWIND_SFRAME_LOOKUP
+	bool
+
 config UNWIND_USER
 	bool
 
@@ -496,6 +499,7 @@ config HAVE_UNWIND_USER_FP
 config HAVE_UNWIND_USER_SFRAME
 	bool
 	select UNWIND_USER
+	select UNWIND_SFRAME_LOOKUP
 
 config SFRAME_VALIDATION
 	bool "Enable .sframe section debugging"
diff --git a/arch/x86/include/asm/unwind_user_sframe.h b/arch/x86/include/asm/unwind_sframe.h
similarity index 50%
rename from arch/x86/include/asm/unwind_user_sframe.h
rename to arch/x86/include/asm/unwind_sframe.h
index d828ae1a4aac..44d42e6ffde4 100644
--- a/arch/x86/include/asm/unwind_user_sframe.h
+++ b/arch/x86/include/asm/unwind_sframe.h
@@ -1,6 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0 */
-#ifndef _ASM_X86_UNWIND_USER_SFRAME_H
-#define _ASM_X86_UNWIND_USER_SFRAME_H
+#ifndef _ASM_X86_UNWIND_SFRAME_H
+#define _ASM_X86_UNWIND_SFRAME_H
 
 #ifdef CONFIG_X86_64
 
@@ -9,4 +9,4 @@
 
 #endif
 
-#endif /* _ASM_X86_UNWIND_USER_SFRAME_H */
+#endif /* _ASM_X86_UNWIND_SFRAME_H */
diff --git a/arch/x86/include/asm/unwind_user.h b/arch/x86/include/asm/unwind_user.h
index ae46906c3b39..8fdab3581b86 100644
--- a/arch/x86/include/asm/unwind_user.h
+++ b/arch/x86/include/asm/unwind_user.h
@@ -55,30 +55,30 @@ static inline int unwind_user_get_reg(unsigned long *val, unsigned int regnum)
 
 #define ARCH_INIT_USER_FP_FRAME(ws)			\
 	.cfa		= {				\
-		.rule		= UNWIND_USER_CFA_RULE_FP_OFFSET,\
+		.rule		= UNWIND_CFA_RULE_FP_OFFSET,\
 		.offset		=  2*(ws),		\
 			},				\
 	.ra		= {				\
-		.rule		= UNWIND_USER_RULE_CFA_OFFSET_DEREF,\
+		.rule		= UNWIND_RULE_CFA_OFFSET_DEREF,\
 		.offset		= -1*(ws),		\
 			},				\
 	.fp		= {				\
-		.rule		= UNWIND_USER_RULE_CFA_OFFSET_DEREF,\
+		.rule		= UNWIND_RULE_CFA_OFFSET_DEREF,\
 		.offset		= -2*(ws),		\
 			},				\
 	.outermost	= false,
 
 #define ARCH_INIT_USER_FP_ENTRY_FRAME(ws)		\
 	.cfa		= {				\
-		.rule		= UNWIND_USER_CFA_RULE_SP_OFFSET,\
+		.rule		= UNWIND_CFA_RULE_SP_OFFSET,\
 		.offset		=  1*(ws),		\
 			},				\
 	.ra		= {				\
-		.rule		= UNWIND_USER_RULE_CFA_OFFSET_DEREF,\
+		.rule		= UNWIND_RULE_CFA_OFFSET_DEREF,\
 		.offset		= -1*(ws),		\
 			},				\
 	.fp		= {				\
-		.rule		= UNWIND_USER_RULE_RETAIN,\
+		.rule		= UNWIND_RULE_RETAIN,\
 			},				\
 	.outermost	= false,
 
diff --git a/include/linux/sframe.h b/include/linux/sframe.h
index b79c5ec09229..0cb2924367bc 100644
--- a/include/linux/sframe.h
+++ b/include/linux/sframe.h
@@ -3,37 +3,46 @@
 #define _LINUX_SFRAME_H
 
 #include <linux/mm_types.h>
+#include <linux/unwind_types.h>
 #include <linux/srcu.h>
-#include <linux/unwind_user_types.h>
 
-#ifdef CONFIG_HAVE_UNWIND_USER_SFRAME
+#ifdef CONFIG_UNWIND_SFRAME_LOOKUP
+
+enum sframe_sec_type {
+	SFRAME_KERNEL,
+	SFRAME_USER,
+};
 
 struct sframe_section {
-	struct rcu_head	rcu;
+	struct rcu_head  rcu;
 #ifdef CONFIG_DYNAMIC_DEBUG
-	const char	*filename;
+	const char		*filename;
 #endif
-	unsigned long	sframe_start;
-	unsigned long	sframe_end;
-	unsigned long	text_start;
-	unsigned long	text_end;
-
-	unsigned long	fdes_start;
-	unsigned long	fres_start;
-	unsigned long	fres_end;
-	unsigned int	num_fdes;
-
-	signed char	ra_off;
-	signed char	fp_off;
+	enum sframe_sec_type	sec_type;
+	unsigned long		sframe_start;
+	unsigned long		sframe_end;
+	unsigned long		text_start;
+	unsigned long		text_end;
+
+	unsigned long		fdes_start;
+	unsigned long		fres_start;
+	unsigned long		fres_end;
+	unsigned int		num_fdes;
+
+	signed char		ra_off;
+	signed char		fp_off;
 };
 
+#endif /* CONFIG_UNWIND_SFRAME_LOOKUP */
+
+#ifdef CONFIG_HAVE_UNWIND_USER_SFRAME
+
 #define INIT_MM_SFRAME .sframe_mt = MTREE_INIT(sframe_mt, 0),
 extern void sframe_free_mm(struct mm_struct *mm);
 
 extern int sframe_add_section(unsigned long sframe_start, unsigned long sframe_end,
 			      unsigned long text_start, unsigned long text_end);
 extern int sframe_remove_section(unsigned long sframe_addr);
-extern int sframe_find(unsigned long ip, struct unwind_user_frame *frame);
 
 static inline bool current_has_sframe(void)
 {
@@ -42,6 +51,8 @@ static inline bool current_has_sframe(void)
 	return mm && !mtree_empty(&mm->sframe_mt);
 }
 
+extern int sframe_find_user(unsigned long ip, struct unwind_frame *frame);
+
 #else /* !CONFIG_HAVE_UNWIND_USER_SFRAME */
 
 #define INIT_MM_SFRAME
@@ -52,9 +63,10 @@ static inline int sframe_add_section(unsigned long sframe_start, unsigned long s
 	return -ENOSYS;
 }
 static inline int sframe_remove_section(unsigned long sframe_addr) { return -ENOSYS; }
-static inline int sframe_find(unsigned long ip, struct unwind_user_frame *frame) { return -ENOSYS; }
 static inline bool current_has_sframe(void) { return false; }
 
+static inline int sframe_find_user(unsigned long ip, struct unwind_frame *frame) { return -ENOSYS; }
+
 #endif /* CONFIG_HAVE_UNWIND_USER_SFRAME */
 
 #endif /* _LINUX_SFRAME_H */
diff --git a/include/linux/unwind_types.h b/include/linux/unwind_types.h
new file mode 100644
index 000000000000..08bcb0aa04aa
--- /dev/null
+++ b/include/linux/unwind_types.h
@@ -0,0 +1,46 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _LINUX_UNWIND_TYPES_H
+#define _LINUX_UNWIND_TYPES_H
+
+#define UNWIND_RULE_DEREF			BIT(31)
+
+enum unwind_cfa_rule {
+	UNWIND_CFA_RULE_SP_OFFSET,		/* CFA = SP + offset */
+	UNWIND_CFA_RULE_FP_OFFSET,		/* CFA = FP + offset */
+	UNWIND_CFA_RULE_REG_OFFSET,	/* CFA = reg + offset */
+	/* DEREF variants */
+	UNWIND_CFA_RULE_REG_OFFSET_DEREF =	/* CFA = *(reg + offset) */
+		UNWIND_CFA_RULE_REG_OFFSET | UNWIND_RULE_DEREF,
+};
+
+struct unwind_cfa_rule_data {
+	enum unwind_cfa_rule rule;
+	s32 offset;
+	unsigned int regnum;
+};
+
+enum unwind_rule {
+	UNWIND_RULE_RETAIN,		/* entity = entity */
+	UNWIND_RULE_CFA_OFFSET,		/* entity = CFA + offset */
+	UNWIND_RULE_REG_OFFSET,		/* entity = register + offset */
+	/* DEREF variants */
+	UNWIND_RULE_CFA_OFFSET_DEREF =	/* entity = *(CFA + offset) */
+		UNWIND_RULE_CFA_OFFSET | UNWIND_RULE_DEREF,
+	UNWIND_RULE_REG_OFFSET_DEREF =	/* entity = *(register + offset) */
+		UNWIND_RULE_REG_OFFSET | UNWIND_RULE_DEREF,
+};
+
+struct unwind_rule_data {
+	enum unwind_rule rule;
+	s32 offset;
+	unsigned int regnum;
+};
+
+struct unwind_frame {
+	struct unwind_cfa_rule_data cfa;
+	struct unwind_rule_data ra;
+	struct unwind_rule_data fp;
+	bool outermost;
+};
+
+#endif /* _LINUX_UNWIND_TYPES_H */
diff --git a/include/linux/unwind_user_types.h b/include/linux/unwind_user_types.h
index 059e5c76f2f3..646e5fb774db 100644
--- a/include/linux/unwind_user_types.h
+++ b/include/linux/unwind_user_types.h
@@ -27,47 +27,6 @@ struct unwind_stacktrace {
 	unsigned long	*entries;
 };
 
-#define UNWIND_USER_RULE_DEREF			BIT(31)
-
-enum unwind_user_cfa_rule {
-	UNWIND_USER_CFA_RULE_SP_OFFSET,		/* CFA = SP + offset */
-	UNWIND_USER_CFA_RULE_FP_OFFSET,		/* CFA = FP + offset */
-	UNWIND_USER_CFA_RULE_REG_OFFSET,	/* CFA = reg + offset */
-	/* DEREF variants */
-	UNWIND_USER_CFA_RULE_REG_OFFSET_DEREF =	/* CFA = *(reg + offset) */
-		UNWIND_USER_CFA_RULE_REG_OFFSET | UNWIND_USER_RULE_DEREF,
-};
-
-struct unwind_user_cfa_rule_data {
-	enum unwind_user_cfa_rule rule;
-	s32 offset;
-	unsigned int regnum;
-};
-
-enum unwind_user_rule {
-	UNWIND_USER_RULE_RETAIN,		/* entity = entity */
-	UNWIND_USER_RULE_CFA_OFFSET,		/* entity = CFA + offset */
-	UNWIND_USER_RULE_REG_OFFSET,		/* entity = register + offset */
-	/* DEREF variants */
-	UNWIND_USER_RULE_CFA_OFFSET_DEREF =	/* entity = *(CFA + offset) */
-		UNWIND_USER_RULE_CFA_OFFSET | UNWIND_USER_RULE_DEREF,
-	UNWIND_USER_RULE_REG_OFFSET_DEREF =	/* entity = *(register + offset) */
-		UNWIND_USER_RULE_REG_OFFSET | UNWIND_USER_RULE_DEREF,
-};
-
-struct unwind_user_rule_data {
-	enum unwind_user_rule rule;
-	s32 offset;
-	unsigned int regnum;
-};
-
-struct unwind_user_frame {
-	struct unwind_user_cfa_rule_data cfa;
-	struct unwind_user_rule_data ra;
-	struct unwind_user_rule_data fp;
-	bool outermost;
-};
-
 struct unwind_user_state {
 	unsigned long				ip;
 	unsigned long				sp;
diff --git a/kernel/unwind/Makefile b/kernel/unwind/Makefile
index 146038165865..c5f9f8124564 100644
--- a/kernel/unwind/Makefile
+++ b/kernel/unwind/Makefile
@@ -1,2 +1,2 @@
  obj-$(CONFIG_UNWIND_USER)		+= user.o deferred.o
- obj-$(CONFIG_HAVE_UNWIND_USER_SFRAME)	+= sframe.o
+ obj-$(CONFIG_UNWIND_SFRAME_LOOKUP)	+= sframe.o
diff --git a/kernel/unwind/sframe.c b/kernel/unwind/sframe.c
index f24997e84e05..89dd8c5a6a10 100644
--- a/kernel/unwind/sframe.c
+++ b/kernel/unwind/sframe.c
@@ -12,8 +12,8 @@
 #include <linux/mm.h>
 #include <linux/string_helpers.h>
 #include <linux/sframe.h>
-#include <asm/unwind_user_sframe.h>
-#include <linux/unwind_user_types.h>
+#include <linux/unwind_types.h>
+#include <asm/unwind_sframe.h>
 
 #include "sframe.h"
 #include "sframe_debug.h"
@@ -44,8 +44,6 @@ struct sframe_fre_internal {
 	unsigned char	dw_size;
 };
 
-DEFINE_STATIC_SRCU(sframe_srcu);
-
 static __always_inline unsigned char fre_type_to_size(unsigned char fre_type)
 {
 	if (fre_type > 2)
@@ -60,6 +58,77 @@ static __always_inline unsigned char dataword_size_enum_to_size(unsigned char da
 	return 1 << dataword_size;
 }
 
+#ifdef CONFIG_HAVE_UNWIND_USER_SFRAME
+
+DEFINE_STATIC_SRCU(sframe_srcu);
+
+#define UNSAFE_USER_COPY(to, from, size, label)				\
+	unsafe_copy_from_user(to, (void __user *)from, size, label)
+
+#define UNSAFE_USER_GET(to, from, type, label)				\
+	unsafe_get_user(to, (type __user *)from, label)
+
+#else /* !CONFIG_HAVE_UNWIND_USER_SFRAME */
+
+#define UNSAFE_USER_COPY(to, from, size, label) do {			\
+	(void)to; (void)from; (void)size;				\
+	goto label;							\
+} while (0)
+
+#define UNSAFE_USER_GET(to, from, type, label) do {			\
+	(void)to; (void)from;						\
+	goto label;							\
+} while (0)
+
+#endif /* !CONFIG_HAVE_UNWIND_USER_SFRAME */
+
+#ifdef CONFIG_HAVE_UNWIND_KERNEL_SFRAME
+
+#define KERNEL_COPY(to, from, size, label) memcpy(to, (void *)from, size)
+#define KERNEL_GET(to, from, type, label) ({ (to) = *(type *)(from); })
+
+#else /* !CONFIG_HAVE_UNWIND_KERNEL_SFRAME */
+
+#define KERNEL_COPY(to, from, size, label) do {				\
+	(void)(to); (void)(from); (void)size;				\
+	goto label;							\
+} while (0)
+
+#define KERNEL_GET(to, from, type, label) do {				\
+	(void)(to); (void)(from);					\
+	goto label;							\
+} while (0)
+
+#endif /* !CONFIG_HAVE_UNWIND_KERNEL_SFRAME */
+
+#define DATA_COPY(sec, to, from, size, label)			\
+({								\
+	switch (sec->sec_type) {				\
+	case SFRAME_KERNEL:					\
+		KERNEL_COPY(to, from, size, label);		\
+		break;						\
+	case SFRAME_USER:					\
+		UNSAFE_USER_COPY(to, from, size, label);	\
+		break;						\
+	default:						\
+		goto label;					\
+	}							\
+})
+
+#define DATA_GET(sec, to, from, type, label)			\
+({								\
+	switch (sec->sec_type) {				\
+	case SFRAME_KERNEL:					\
+		KERNEL_GET(to, from, type, label);		\
+		break;						\
+	case SFRAME_USER:					\
+		UNSAFE_USER_GET(to, from, type, label);		\
+		break;						\
+	default:						\
+		goto label;					\
+	}							\
+})
+
 static __always_inline int __read_fde(struct sframe_section *sec,
 				      unsigned int fde_num,
 				      struct sframe_fde_internal *fde)
@@ -69,8 +138,8 @@ static __always_inline int __read_fde(struct sframe_section *sec,
 	struct sframe_fda_v3 _fda;
 
 	fde_addr = sec->fdes_start + (fde_num * sizeof(struct sframe_fde_v3));
-	unsafe_copy_from_user(&_fde, (void __user *)fde_addr,
-			      sizeof(struct sframe_fde_v3), Efault);
+	DATA_COPY(sec, &_fde, fde_addr,
+		  sizeof(struct sframe_fde_v3), Efault);
 
 	func_addr = fde_addr + _fde.func_start_off;
 	if (func_addr < sec->text_start || func_addr > sec->text_end)
@@ -79,8 +148,8 @@ static __always_inline int __read_fde(struct sframe_section *sec,
 	fda_addr = sec->fres_start + _fde.fres_off;
 	if (fda_addr + sizeof(struct sframe_fda_v3) > sec->fres_end)
 		return -EINVAL;
-	unsafe_copy_from_user(&_fda, (void __user *)fda_addr,
-			      sizeof(struct sframe_fda_v3), Efault);
+	DATA_COPY(sec, &_fda, fda_addr,
+		  sizeof(struct sframe_fda_v3), Efault);
 
 	fde->func_addr	= func_addr;
 	fde->func_size	= _fde.func_size;
@@ -102,21 +171,21 @@ static __always_inline int __find_fde(struct sframe_section *sec,
 				      struct sframe_fde_internal *fde)
 {
 	unsigned long func_addr_low = 0, func_addr_high = ULONG_MAX;
-	struct sframe_fde_v3 __user *first, *low, *high, *found = NULL;
+	struct sframe_fde_v3 *first, *low, *high, *found = NULL;
 	int ret;
 
-	first = (void __user *)sec->fdes_start;
+	first = (void *)sec->fdes_start;
 	low = first;
 	high = first + sec->num_fdes - 1;
 
 	while (low <= high) {
-		struct sframe_fde_v3 __user *mid;
+		struct sframe_fde_v3 *mid;
 		s64 func_off;
 		unsigned long func_addr;
 
 		mid = low + ((high - low) / 2);
 
-		unsafe_get_user(func_off, (s64 __user *)mid, Efault);
+		DATA_GET(sec, func_off, mid, s64, Efault);
 		func_addr = (unsigned long)mid + func_off;
 
 		if (ip >= func_addr) {
@@ -154,47 +223,47 @@ static __always_inline int __find_fde(struct sframe_section *sec,
 	return -EFAULT;
 }
 
-#define ____UNSAFE_GET_USER_INC(to, from, type, label)			\
+#define ____GET_INC(sec, to, from, type, label)				\
 ({									\
 	type __to;							\
-	unsafe_get_user(__to, (type __user *)from, label);		\
+	DATA_GET(sec, __to, from, type, label);				\
 	from += sizeof(__to);						\
 	to = __to;							\
 })
 
-#define __UNSAFE_GET_USER_INC(to, from, size, label, u_or_s)		\
+#define __GET_INC(sec, to, from, size, label, u_or_s)			\
 ({									\
 	switch (size) {							\
 	case 1:								\
-		____UNSAFE_GET_USER_INC(to, from, u_or_s##8, label);	\
+		____GET_INC(sec, to, from, u_or_s##8, label);		\
 		break;							\
 	case 2:								\
-		____UNSAFE_GET_USER_INC(to, from, u_or_s##16, label);	\
+		____GET_INC(sec, to, from, u_or_s##16, label);		\
 		break;							\
 	case 4:								\
-		____UNSAFE_GET_USER_INC(to, from, u_or_s##32, label);	\
+		____GET_INC(sec, to, from, u_or_s##32, label);		\
 		break;							\
 	default:							\
 		return -EFAULT;						\
 	}								\
 })
 
-#define UNSAFE_GET_USER_UNSIGNED_INC(to, from, size, label)		\
-	__UNSAFE_GET_USER_INC(to, from, size, label, u)
+#define GET_UNSIGNED_INC(sec, to, from, size, label)			\
+	__GET_INC(sec, to, from, size, label, u)
 
-#define UNSAFE_GET_USER_SIGNED_INC(to, from, size, label)		\
-	__UNSAFE_GET_USER_INC(to, from, size, label, s)
+#define GET_SIGNED_INC(sec, to, from, size, label)			\
+	__GET_INC(sec, to, from, size, label, s)
 
-#define UNSAFE_GET_USER_INC(to, from, size, label)				\
-	_Generic(to,								\
-		 u8 :	UNSAFE_GET_USER_UNSIGNED_INC(to, from, size, label),	\
-		 u16 :	UNSAFE_GET_USER_UNSIGNED_INC(to, from, size, label),	\
-		 u32 :	UNSAFE_GET_USER_UNSIGNED_INC(to, from, size, label),	\
-		 u64 :	UNSAFE_GET_USER_UNSIGNED_INC(to, from, size, label),	\
-		 s8 :	UNSAFE_GET_USER_SIGNED_INC(to, from, size, label),	\
-		 s16 :	UNSAFE_GET_USER_SIGNED_INC(to, from, size, label),	\
-		 s32 :	UNSAFE_GET_USER_SIGNED_INC(to, from, size, label),	\
-		 s64 :	UNSAFE_GET_USER_SIGNED_INC(to, from, size, label))
+#define GET_INC(sec, to, from, size, label)				\
+	_Generic(to,							\
+		 u8 :	GET_UNSIGNED_INC(sec, to, from, size, label),	\
+		 u16 :	GET_UNSIGNED_INC(sec, to, from, size, label),	\
+		 u32 :	GET_UNSIGNED_INC(sec, to, from, size, label),	\
+		 u64 :	GET_UNSIGNED_INC(sec, to, from, size, label),	\
+		 s8 :	GET_SIGNED_INC(sec, to, from, size, label),	\
+		 s16 :	GET_SIGNED_INC(sec, to, from, size, label),	\
+		 s32 :	GET_SIGNED_INC(sec, to, from, size, label),	\
+		 s64 :	GET_SIGNED_INC(sec, to, from, size, label))
 
 static __always_inline int
 __read_regular_fre_datawords(struct sframe_section *sec,
@@ -207,19 +276,19 @@ __read_regular_fre_datawords(struct sframe_section *sec,
 	s32 cfa_off, ra_off, fp_off;
 	unsigned int cfa_regnum;
 
-	UNSAFE_GET_USER_INC(cfa_off, cur, dataword_size, Efault);
+	GET_INC(sec, cfa_off, cur, dataword_size, Efault);
 	dataword_count--;
 
 	ra_off = sec->ra_off;
 	if (!ra_off && dataword_count) {
 		dataword_count--;
-		UNSAFE_GET_USER_INC(ra_off, cur, dataword_size, Efault);
+		GET_INC(sec, ra_off, cur, dataword_size, Efault);
 	}
 
 	fp_off = sec->fp_off;
 	if (!fp_off && dataword_count) {
 		dataword_count--;
-		UNSAFE_GET_USER_INC(fp_off, cur, dataword_size, Efault);
+		GET_INC(sec, fp_off, cur, dataword_size, Efault);
 	}
 
 	if (dataword_count)
@@ -255,17 +324,17 @@ __read_flex_fde_fre_datawords(struct sframe_section *sec,
 
 	if (dataword_count < 2)
 		return -EFAULT;
-	UNSAFE_GET_USER_INC(cfa_ctl, cur, dataword_size, Efault);
-	UNSAFE_GET_USER_INC(cfa_off, cur, dataword_size, Efault);
+	GET_INC(sec, cfa_ctl, cur, dataword_size, Efault);
+	GET_INC(sec, cfa_off, cur, dataword_size, Efault);
 	dataword_count -= 2;
 
 	ra_off = sec->ra_off;
 	ra_ctl = ra_off ? 2 : 0; /* regnum=0, deref_p=(ra_off != 0), reg_p=0 */
 	if (dataword_count >= 2) {
-		UNSAFE_GET_USER_INC(ra_ctl, cur, dataword_size, Efault);
+		GET_INC(sec, ra_ctl, cur, dataword_size, Efault);
 		dataword_count--;
 		if (ra_ctl) {
-			UNSAFE_GET_USER_INC(ra_off, cur, dataword_size, Efault);
+			GET_INC(sec, ra_off, cur, dataword_size, Efault);
 			dataword_count--;
 		} else {
 			/* Padding RA location info */
@@ -276,10 +345,10 @@ __read_flex_fde_fre_datawords(struct sframe_section *sec,
 	fp_off = sec->fp_off;
 	fp_ctl = fp_off ? 2 : 0; /* regnum=0, deref_p=(fp_off != 0), reg_p=0 */
 	if (dataword_count >= 2) {
-		UNSAFE_GET_USER_INC(fp_ctl, cur, dataword_size, Efault);
+		GET_INC(sec, fp_ctl, cur, dataword_size, Efault);
 		dataword_count--;
 		if (fp_ctl) {
-			UNSAFE_GET_USER_INC(fp_off, cur, dataword_size, Efault);
+			GET_INC(sec, fp_off, cur, dataword_size, Efault);
 			dataword_count--;
 		} else {
 			/* Padding FP location info */
@@ -353,11 +422,11 @@ static __always_inline int __read_fre(struct sframe_section *sec,
 	if (fre_addr + addr_size + 1 > sec->fres_end)
 		return -EFAULT;
 
-	UNSAFE_GET_USER_INC(ip_off, cur, addr_size, Efault);
+	GET_INC(sec, ip_off, cur, addr_size, Efault);
 	if (fde_pctype == SFRAME_FDE_PCTYPE_INC && ip_off > fde->func_size)
 		return -EFAULT;
 
-	UNSAFE_GET_USER_INC(info, cur, 1, Efault);
+	GET_INC(sec, info, cur, 1, Efault);
 	dataword_count = SFRAME_V3_FRE_DATAWORD_COUNT(info);
 	dataword_size  = dataword_size_enum_to_size(SFRAME_V3_FRE_DATAWORD_SIZE(info));
 	if (!dataword_size)
@@ -380,7 +449,7 @@ static __always_inline int __read_fre(struct sframe_section *sec,
 }
 
 static __always_inline int
-sframe_init_cfa_rule_data(struct unwind_user_cfa_rule_data *cfa_rule_data,
+sframe_init_cfa_rule_data(struct unwind_cfa_rule_data *cfa_rule_data,
 			  u32 ctlword, s32 offset)
 {
 	bool deref_p = SFRAME_V3_FLEX_FDE_CTLWORD_DEREF_P(ctlword);
@@ -391,13 +460,13 @@ sframe_init_cfa_rule_data(struct unwind_user_cfa_rule_data *cfa_rule_data,
 
 		switch (regnum) {
 		case SFRAME_REG_SP:
-			cfa_rule_data->rule = UNWIND_USER_CFA_RULE_SP_OFFSET;
+			cfa_rule_data->rule = UNWIND_CFA_RULE_SP_OFFSET;
 			break;
 		case SFRAME_REG_FP:
-			cfa_rule_data->rule = UNWIND_USER_CFA_RULE_FP_OFFSET;
+			cfa_rule_data->rule = UNWIND_CFA_RULE_FP_OFFSET;
 			break;
 		default:
-			cfa_rule_data->rule = UNWIND_USER_CFA_RULE_REG_OFFSET;
+			cfa_rule_data->rule = UNWIND_CFA_RULE_REG_OFFSET;
 			cfa_rule_data->regnum = regnum;
 		}
 	} else {
@@ -405,7 +474,7 @@ sframe_init_cfa_rule_data(struct unwind_user_cfa_rule_data *cfa_rule_data,
 	}
 
 	if (deref_p)
-		cfa_rule_data->rule |= UNWIND_USER_RULE_DEREF;
+		cfa_rule_data->rule |= UNWIND_RULE_DEREF;
 
 	cfa_rule_data->offset = offset;
 
@@ -413,27 +482,27 @@ sframe_init_cfa_rule_data(struct unwind_user_cfa_rule_data *cfa_rule_data,
 }
 
 static __always_inline void
-sframe_init_rule_data(struct unwind_user_rule_data *rule_data,
+sframe_init_rule_data(struct unwind_rule_data *rule_data,
 		      u32 ctlword, s32 offset)
 {
 	bool deref_p = SFRAME_V3_FLEX_FDE_CTLWORD_DEREF_P(ctlword);
 	bool reg_p = SFRAME_V3_FLEX_FDE_CTLWORD_REG_P(ctlword);
 
 	if (!ctlword && !offset) {
-		rule_data->rule = UNWIND_USER_RULE_RETAIN;
+		rule_data->rule = UNWIND_RULE_RETAIN;
 		return;
 	}
 	if (reg_p) {
 		unsigned int regnum = SFRAME_V3_FLEX_FDE_CTLWORD_REGNUM(ctlword);
 
-		rule_data->rule = UNWIND_USER_RULE_REG_OFFSET;
+		rule_data->rule = UNWIND_RULE_REG_OFFSET;
 		rule_data->regnum = regnum;
 	} else {
-		rule_data->rule = UNWIND_USER_RULE_CFA_OFFSET;
+		rule_data->rule = UNWIND_RULE_CFA_OFFSET;
 	}
 
 	if (deref_p)
-		rule_data->rule |= UNWIND_USER_RULE_DEREF;
+		rule_data->rule |= UNWIND_RULE_DEREF;
 
 	rule_data->offset = offset;
 }
@@ -441,7 +510,7 @@ sframe_init_rule_data(struct unwind_user_rule_data *rule_data,
 static __always_inline int __find_fre(struct sframe_section *sec,
 				      struct sframe_fde_internal *fde,
 				      unsigned long ip,
-				      struct unwind_user_frame *frame)
+				      struct unwind_frame *frame)
 {
 	unsigned char fde_pctype = SFRAME_V3_FDE_PCTYPE(fde->info);
 	struct sframe_fre_internal *fre, *prev_fre = NULL;
@@ -501,40 +570,18 @@ static __always_inline int __find_fre(struct sframe_section *sec,
 	return 0;
 }
 
-int sframe_find(unsigned long ip, struct unwind_user_frame *frame)
+static __always_inline int __sframe_find(struct sframe_section *sec,
+					 unsigned long ip,
+					 struct unwind_frame *frame)
 {
-	struct mm_struct *mm = current->mm;
-	struct sframe_section *sec;
 	struct sframe_fde_internal fde;
 	int ret;
 
-	if (!mm)
-		return -EINVAL;
-
-	guard(srcu)(&sframe_srcu);
-
-	sec = mtree_load(&mm->sframe_mt, ip);
-	if (!sec)
-		return -EINVAL;
-
-	if (!user_read_access_begin((void __user *)sec->sframe_start,
-				    sec->sframe_end - sec->sframe_start))
-		return -EFAULT;
-
 	ret = __find_fde(sec, ip, &fde);
 	if (ret)
-		goto end;
-
-	ret = __find_fre(sec, &fde, ip, frame);
-end:
-	user_read_access_end();
-
-	if (ret == -EFAULT) {
-		dbg_sec("removing bad .sframe section\n");
-		WARN_ON_ONCE(sframe_remove_section(sec->sframe_start));
-	}
+		return ret;
 
-	return ret;
+	return __find_fre(sec, &fde, ip, frame);
 }
 
 #ifdef CONFIG_SFRAME_VALIDATION
@@ -657,20 +704,23 @@ static int sframe_validate_section(struct sframe_section *sec) { return 0; }
 #endif /* !CONFIG_SFRAME_VALIDATION */
 
 
-static void free_section(struct sframe_section *sec)
-{
-	dbg_free(sec);
-	kfree(sec);
-}
-
 static int sframe_read_header(struct sframe_section *sec)
 {
 	unsigned long header_end, fdes_start, fdes_end, fres_start, fres_end;
 	struct sframe_header shdr;
 	unsigned int num_fdes;
 
-	if (copy_from_user(&shdr, (void __user *)sec->sframe_start, sizeof(shdr))) {
-		dbg_sec("header usercopy failed\n");
+	switch (sec->sec_type) {
+	case SFRAME_USER:
+		if (copy_from_user(&shdr, (void __user *)sec->sframe_start, sizeof(shdr))) {
+			dbg_sec("header usercopy failed\n");
+			return -EFAULT;
+		}
+		break;
+	case SFRAME_KERNEL:
+		shdr = *(struct sframe_header *)sec->sframe_start;
+		break;
+	default:
 		return -EFAULT;
 	}
 
@@ -717,6 +767,45 @@ static int sframe_read_header(struct sframe_section *sec)
 	return 0;
 }
 
+#ifdef CONFIG_HAVE_UNWIND_USER_SFRAME
+
+int sframe_find_user(unsigned long ip, struct unwind_frame *frame)
+{
+	struct mm_struct *mm = current->mm;
+	struct sframe_section *sec;
+	int ret;
+
+	if (!mm)
+		return -EINVAL;
+
+	guard(srcu)(&sframe_srcu);
+
+	sec = mtree_load(&mm->sframe_mt, ip);
+	if (!sec)
+		return -EINVAL;
+
+	if (!user_read_access_begin((void __user *)sec->sframe_start,
+				    sec->sframe_end - sec->sframe_start))
+		return -EFAULT;
+
+	ret = __sframe_find(sec, ip, frame);
+
+	user_read_access_end();
+
+	if (ret == -EFAULT) {
+		dbg_sec("removing bad .sframe section\n");
+		WARN_ON_ONCE(sframe_remove_section(sec->sframe_start));
+	}
+
+	return ret;
+}
+
+static void free_section(struct sframe_section *sec)
+{
+	dbg_free(sec);
+	kfree(sec);
+}
+
 int sframe_add_section(unsigned long sframe_start, unsigned long sframe_end,
 		       unsigned long text_start, unsigned long text_end)
 {
@@ -753,6 +842,7 @@ int sframe_add_section(unsigned long sframe_start, unsigned long sframe_end,
 	if (!sec)
 		return -ENOMEM;
 
+	sec->sec_type		= SFRAME_USER;
 	sec->sframe_start	= sframe_start;
 	sec->sframe_end		= sframe_end;
 	sec->text_start		= text_start;
@@ -838,3 +928,5 @@ void sframe_free_mm(struct mm_struct *mm)
 
 	mtree_destroy(&mm->sframe_mt);
 }
+
+#endif /* CONFIG_HAVE_UNWIND_USER_SFRAME */
diff --git a/kernel/unwind/user.c b/kernel/unwind/user.c
index eb7d9489f671..9e57dd79559a 100644
--- a/kernel/unwind/user.c
+++ b/kernel/unwind/user.c
@@ -8,6 +8,7 @@
 #include <linux/unwind_user.h>
 #include <linux/uaccess.h>
 #include <linux/sframe.h>
+#include <linux/unwind_types.h>
 
 #define for_each_user_frame(state) \
 	for (unwind_user_start(state); !(state)->done; unwind_user_next(state))
@@ -28,7 +29,7 @@ get_user_word(unsigned long *word, unsigned long base, int off, unsigned int ws)
 }
 
 static int unwind_user_next_common(struct unwind_user_state *state,
-				   const struct unwind_user_frame *frame)
+				   const struct unwind_frame *frame)
 {
 	unsigned long cfa, fp, ra;
 
@@ -40,16 +41,16 @@ static int unwind_user_next_common(struct unwind_user_state *state,
 
 	/* Get the Canonical Frame Address (CFA) */
 	switch (frame->cfa.rule) {
-	case UNWIND_USER_CFA_RULE_SP_OFFSET:
+	case UNWIND_CFA_RULE_SP_OFFSET:
 		cfa = state->sp;
 		break;
-	case UNWIND_USER_CFA_RULE_FP_OFFSET:
+	case UNWIND_CFA_RULE_FP_OFFSET:
 		if (state->fp < state->sp)
 			return -EINVAL;
 		cfa = state->fp;
 		break;
-	case UNWIND_USER_CFA_RULE_REG_OFFSET:
-	case UNWIND_USER_CFA_RULE_REG_OFFSET_DEREF:
+	case UNWIND_CFA_RULE_REG_OFFSET:
+	case UNWIND_CFA_RULE_REG_OFFSET_DEREF:
 		if (!state->topmost || unwind_user_get_reg(&cfa, frame->cfa.regnum))
 			return -EINVAL;
 		break;
@@ -58,7 +59,7 @@ static int unwind_user_next_common(struct unwind_user_state *state,
 		return -EINVAL;
 	}
 	cfa += frame->cfa.offset;
-	if (frame->cfa.rule & UNWIND_USER_RULE_DEREF &&
+	if (frame->cfa.rule & UNWIND_RULE_DEREF &&
 	    get_user_word(&cfa, cfa, 0, state->ws))
 		return -EINVAL;
 
@@ -76,16 +77,16 @@ static int unwind_user_next_common(struct unwind_user_state *state,
 
 	/* Get the Return Address (RA) */
 	switch (frame->ra.rule) {
-	case UNWIND_USER_RULE_RETAIN:
+	case UNWIND_RULE_RETAIN:
 		if (!state->topmost || unwind_user_get_ra_reg(&ra))
 			return -EINVAL;
 		break;
 	/* UNWIND_USER_RULE_CFA_OFFSET not implemented on purpose */
-	case UNWIND_USER_RULE_CFA_OFFSET_DEREF:
+	case UNWIND_RULE_CFA_OFFSET_DEREF:
 		ra = cfa + frame->ra.offset;
 		break;
-	case UNWIND_USER_RULE_REG_OFFSET:
-	case UNWIND_USER_RULE_REG_OFFSET_DEREF:
+	case UNWIND_RULE_REG_OFFSET:
+	case UNWIND_RULE_REG_OFFSET_DEREF:
 		if (!state->topmost || unwind_user_get_reg(&ra, frame->ra.regnum))
 			return -EINVAL;
 		ra += frame->ra.offset;
@@ -94,21 +95,21 @@ static int unwind_user_next_common(struct unwind_user_state *state,
 		WARN_ON_ONCE(1);
 		return -EINVAL;
 	}
-	if (frame->ra.rule & UNWIND_USER_RULE_DEREF &&
+	if (frame->ra.rule & UNWIND_RULE_DEREF &&
 	    get_user_word(&ra, ra, 0, state->ws))
 		return -EINVAL;
 
 	/* Get the Frame Pointer (FP) */
 	switch (frame->fp.rule) {
-	case UNWIND_USER_RULE_RETAIN:
+	case UNWIND_RULE_RETAIN:
 		fp = state->fp;
 		break;
 	/* UNWIND_USER_RULE_CFA_OFFSET not implemented on purpose */
-	case UNWIND_USER_RULE_CFA_OFFSET_DEREF:
+	case UNWIND_RULE_CFA_OFFSET_DEREF:
 		fp = cfa + frame->fp.offset;
 		break;
-	case UNWIND_USER_RULE_REG_OFFSET:
-	case UNWIND_USER_RULE_REG_OFFSET_DEREF:
+	case UNWIND_RULE_REG_OFFSET:
+	case UNWIND_RULE_REG_OFFSET_DEREF:
 		if (!state->topmost || unwind_user_get_reg(&fp, frame->fp.regnum))
 			return -EINVAL;
 		fp += frame->fp.offset;
@@ -117,7 +118,7 @@ static int unwind_user_next_common(struct unwind_user_state *state,
 		WARN_ON_ONCE(1);
 		return -EINVAL;
 	}
-	if (frame->fp.rule & UNWIND_USER_RULE_DEREF &&
+	if (frame->fp.rule & UNWIND_RULE_DEREF &&
 	    get_user_word(&fp, fp, 0, state->ws))
 		return -EINVAL;
 
@@ -133,13 +134,13 @@ static int unwind_user_next_fp(struct unwind_user_state *state)
 	struct pt_regs *regs = task_pt_regs(current);
 
 	if (state->topmost && unwind_user_at_function_start(regs)) {
-		const struct unwind_user_frame fp_entry_frame = {
+		const struct unwind_frame fp_entry_frame = {
 			ARCH_INIT_USER_FP_ENTRY_FRAME(state->ws)
 		};
 		return unwind_user_next_common(state, &fp_entry_frame);
 	}
 
-	const struct unwind_user_frame fp_frame = {
+	const struct unwind_frame fp_frame = {
 		ARCH_INIT_USER_FP_FRAME(state->ws)
 	};
 	return unwind_user_next_common(state, &fp_frame);
@@ -147,10 +148,10 @@ static int unwind_user_next_fp(struct unwind_user_state *state)
 
 static int unwind_user_next_sframe(struct unwind_user_state *state)
 {
-	struct unwind_user_frame frame;
+	struct unwind_frame frame;
 
 	/* sframe expects the frame to be local storage */
-	if (sframe_find(state->ip, &frame))
+	if (sframe_find_user(state->ip, &frame))
 		return -ENOENT;
 	return unwind_user_next_common(state, &frame);
 }
-- 
2.54.0.545.g6539524ca2-goog


