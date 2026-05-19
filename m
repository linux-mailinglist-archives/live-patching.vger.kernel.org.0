Return-Path: <live-patching+bounces-2854-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id +MweNUAJDGo5UQUAu9opvQ
	(envelope-from <live-patching+bounces-2854-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Tue, 19 May 2026 08:54:56 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 5675B5786FF
	for <lists+live-patching@lfdr.de>; Tue, 19 May 2026 08:54:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id AE56D308CF03
	for <lists+live-patching@lfdr.de>; Tue, 19 May 2026 06:50:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7031C39DBF4;
	Tue, 19 May 2026 06:50:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="aw0u5c4Q"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B46FD39EF22
	for <live-patching@vger.kernel.org>; Tue, 19 May 2026 06:50:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779173410; cv=none; b=BQRbBHhCownATZjRMFowuaaN0RgvsqzUDkLijl1lI3kOCPfWgKx5uOZnIMQyH51baL05lKEv/pXw6gqsyUKwj2QgnG01s88u8MMspW/vkGdFKyzXrMW4lHP/uzxvyRjCYB19+/ztwckn2biaRjua0TCzzy1u9pFwL9umZlD4t3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779173410; c=relaxed/simple;
	bh=WDTuK3fdi4kajo/eFe8LQK/vH1zuFu+EKSRAV6VS5FI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Iw6pTdkaJiO2mwvKZYbOGMMidS+i1+NEgVvMWHmROAal7OM3v1ycUNOrnvi0ySlUt7md8ct/EZ/pyWTUf+SNaNgXpwA3r6B6lOGZrZ4MrhYeEQqvFwLwSyRr69s0OuQ88wD7WeEMfx8jJDv8czkpe9etCtzo1sL5OE5WjeD7wT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--dylanbhatch.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=aw0u5c4Q; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--dylanbhatch.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-c8281d4cef8so1459075a12.2
        for <live-patching@vger.kernel.org>; Mon, 18 May 2026 23:50:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779173407; x=1779778207; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=fuSeZSHQhNTMs2JVzo5tb7dyAIfn+chP1MhDuKP4yrE=;
        b=aw0u5c4QsjyjlmP8r1rS2q5dA5IElsjoZugKBzR6r7eJGPrLPU6t2vqZeZNnDpPUL2
         K35w15m4cDCWK02edQPtClo4lY0YDiyNH7HbRlzbteebzgCY34sEjQyfuTApydKIdvQ7
         96wn4pkZgy4Ru2N1Z7Lw/etOLDE6Ih9/FclAhCEb9JGZsOKgvquNXDos99AbqfTsfs8C
         KSkgFPKV0qvXAYP+ty9ZknWU6QFoSWVXWHR7DOgY+Bio8kTUXA8vAoUYz/mBDEvOyeQf
         FxHEKdh++mZErzlZ9tvNx5ecg8rR5B38tYHJBUhVb5GgZSKui/4xgO3K6lcqN8r/BuRl
         eagg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779173407; x=1779778207;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fuSeZSHQhNTMs2JVzo5tb7dyAIfn+chP1MhDuKP4yrE=;
        b=rvv62xlxyO312Z31fUN0jOqd5wJhpiDoNbHO4QXQLz5Sx/1AZ1j8sckAfyaCVBAds8
         0uVb8ttY/BhrGVOrlRzM2sS09/1/3evtWu+X8N7+THz5cdMVqE/LGH2O2lH00dafk6bE
         ZJnZ2mV0ZwR9VH5bztYIGjHYZS03svelv0UU5hRXMNS2ybti5SfNSk8tEIH3gKJmssjv
         zIZ6v7e8QRGdnfwfaUnGNE/pP3qrcZfpeA556UPLqB0FNdvkcWCBIXa8jNaPU8cAh+f/
         6/89c819ceBAq64qckSsVEg9jwveSz6rYkLnYnXf1LIyzCC+BKYVhN79SbXfYMEOj/hF
         gLbw==
X-Forwarded-Encrypted: i=1; AFNElJ8778oI6ZczX7BtMRqMvwm4Lh1b+icmmz9QBobFrCXDul8FKbANENjnoWWZjJvSZftgArz748CM62NWK6/a@vger.kernel.org
X-Gm-Message-State: AOJu0Yx+Fp7xst2L2ZZ9sTbbaiSbuiF0PHgmBIH6tzR9KjFYDD6ElsMW
	fa4fzyYQLJNkzsXpreU2kvhZ18jq1IPfj2NOFx1kYmhl/TySsp1mJVsjHRzl4UzCLCh/cKM4rbu
	MmlK/O3WD6f723ydIMMrspzhecg==
X-Received: from pgbcq5.prod.google.com ([2002:a05:6a02:4085:b0:c79:8a8e:b046])
 (user=dylanbhatch job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a20:394b:b0:3a3:5726:7e39 with SMTP id adf61e73a8af0-3b22e7c63camr20789443637.23.1779173406773;
 Mon, 18 May 2026 23:50:06 -0700 (PDT)
Date: Tue, 19 May 2026 06:49:42 +0000
In-Reply-To: <20260519064950.493949-1-dylanbhatch@google.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260519064950.493949-1-dylanbhatch@google.com>
X-Mailer: git-send-email 2.54.0.563.g4f69b47b94-goog
Message-ID: <20260519064950.493949-2-dylanbhatch@google.com>
Subject: [PATCH v6 1/9] sframe: Allow kernelspace sframe sections
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
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
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
	TAGGED_FROM(0.00)[bounces-2854-lists,live-patching=lfdr.de];
	TAGGED_RCPT(0.00)[live-patching];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo]
X-Rspamd-Queue-Id: 5675B5786FF
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

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
 kernel/unwind/user.c                          |  45 +--
 10 files changed, 295 insertions(+), 181 deletions(-)
 rename arch/x86/include/asm/{unwind_user_sframe.h => unwind_sframe.h} (50%)
 create mode 100644 include/linux/unwind_types.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 6812f581d44b..54613c683fdb 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -27858,7 +27858,7 @@ F:	Documentation/driver-api/uio-howto.rst
 F:	drivers/uio/
 F:	include/linux/uio_driver.h
 
-USERSPACE STACK UNWINDING
+STACK UNWINDING
 M:	Josh Poimboeuf <jpoimboe@kernel.org>
 M:	Steven Rostedt <rostedt@goodmis.org>
 S:	Maintained
diff --git a/arch/Kconfig b/arch/Kconfig
index 78dad97bf2a4..6eeafd86347b 100644
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
index b80f0ec0f7a7..1c7e31ca5d8e 100644
--- a/arch/x86/include/asm/unwind_user.h
+++ b/arch/x86/include/asm/unwind_user.h
@@ -54,30 +54,30 @@ static inline int unwind_user_get_reg(unsigned long *val, unsigned int regnum)
 
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
index 5400f481b05d..a2ab9a3e07b4 100644
--- a/kernel/unwind/sframe.c
+++ b/kernel/unwind/sframe.c
@@ -13,8 +13,8 @@
 #include <linux/string_helpers.h>
 #include <linux/sframe.h>
 #include <linux/syscalls.h>
-#include <asm/unwind_user_sframe.h>
-#include <linux/unwind_user_types.h>
+#include <linux/unwind_types.h>
+#include <asm/unwind_sframe.h>
 #include <uapi/linux/stacktrace.h>
 
 #include "sframe.h"
@@ -46,8 +46,6 @@ struct sframe_fre_internal {
 	unsigned char	dw_size;
 };
 
-DEFINE_STATIC_SRCU(sframe_srcu);
-
 static __always_inline unsigned char fre_type_to_size(unsigned char fre_type)
 {
 	if (fre_type > 2)
@@ -62,6 +60,77 @@ static __always_inline unsigned char dataword_size_enum_to_size(unsigned char da
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
@@ -71,8 +140,8 @@ static __always_inline int __read_fde(struct sframe_section *sec,
 	struct sframe_fda_v3 _fda;
 
 	fde_addr = sec->fdes_start + (fde_num * sizeof(struct sframe_fde_v3));
-	unsafe_copy_from_user(&_fde, (void __user *)fde_addr,
-			      sizeof(struct sframe_fde_v3), Efault);
+	DATA_COPY(sec, &_fde, fde_addr,
+		  sizeof(struct sframe_fde_v3), Efault);
 
 	func_addr = fde_addr + _fde.func_start_off;
 	if (func_addr < sec->text_start || func_addr >= sec->text_end)
@@ -81,8 +150,8 @@ static __always_inline int __read_fde(struct sframe_section *sec,
 	fda_addr = sec->fres_start + _fde.fres_off;
 	if (fda_addr + sizeof(struct sframe_fda_v3) > sec->fres_end)
 		return -EINVAL;
-	unsafe_copy_from_user(&_fda, (void __user *)fda_addr,
-			      sizeof(struct sframe_fda_v3), Efault);
+	DATA_COPY(sec, &_fda, fda_addr,
+		  sizeof(struct sframe_fda_v3), Efault);
 
 	fde->func_addr	= func_addr;
 	fde->func_size	= _fde.func_size;
@@ -104,21 +173,21 @@ static __always_inline int __find_fde(struct sframe_section *sec,
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
@@ -156,47 +225,47 @@ static __always_inline int __find_fde(struct sframe_section *sec,
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
 __read_default_fre_datawords(struct sframe_section *sec,
@@ -209,19 +278,19 @@ __read_default_fre_datawords(struct sframe_section *sec,
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
@@ -257,17 +326,17 @@ __read_flex_fde_fre_datawords(struct sframe_section *sec,
 
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
@@ -278,10 +347,10 @@ __read_flex_fde_fre_datawords(struct sframe_section *sec,
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
@@ -355,11 +424,11 @@ static __always_inline int __read_fre(struct sframe_section *sec,
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
@@ -382,7 +451,7 @@ static __always_inline int __read_fre(struct sframe_section *sec,
 }
 
 static __always_inline int
-sframe_init_cfa_rule_data(struct unwind_user_cfa_rule_data *cfa_rule_data,
+sframe_init_cfa_rule_data(struct unwind_cfa_rule_data *cfa_rule_data,
 			  u32 ctlword, s32 offset)
 {
 	bool deref_p = SFRAME_V3_FLEX_FDE_CTRLWORD_DEREF_P(ctlword);
@@ -393,13 +462,13 @@ sframe_init_cfa_rule_data(struct unwind_user_cfa_rule_data *cfa_rule_data,
 
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
@@ -407,7 +476,7 @@ sframe_init_cfa_rule_data(struct unwind_user_cfa_rule_data *cfa_rule_data,
 	}
 
 	if (deref_p)
-		cfa_rule_data->rule |= UNWIND_USER_RULE_DEREF;
+		cfa_rule_data->rule |= UNWIND_RULE_DEREF;
 
 	cfa_rule_data->offset = offset;
 
@@ -415,27 +484,27 @@ sframe_init_cfa_rule_data(struct unwind_user_cfa_rule_data *cfa_rule_data,
 }
 
 static __always_inline void
-sframe_init_rule_data(struct unwind_user_rule_data *rule_data,
+sframe_init_rule_data(struct unwind_rule_data *rule_data,
 		      u32 ctlword, s32 offset)
 {
 	bool deref_p = SFRAME_V3_FLEX_FDE_CTRLWORD_DEREF_P(ctlword);
 	bool reg_p = SFRAME_V3_FLEX_FDE_CTRLWORD_REG_P(ctlword);
 
 	if (!ctlword && !offset) {
-		rule_data->rule = UNWIND_USER_RULE_RETAIN;
+		rule_data->rule = UNWIND_RULE_RETAIN;
 		return;
 	}
 	if (reg_p) {
 		unsigned int regnum = SFRAME_V3_FLEX_FDE_CTRLWORD_REGNUM(ctlword);
 
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
@@ -443,7 +512,7 @@ sframe_init_rule_data(struct unwind_user_rule_data *rule_data,
 static __always_inline int __find_fre(struct sframe_section *sec,
 				      struct sframe_fde_internal *fde,
 				      unsigned long ip,
-				      struct unwind_user_frame *frame)
+				      struct unwind_frame *frame)
 {
 	unsigned char fde_pctype = SFRAME_V3_FDE_PCTYPE(fde->info);
 	struct sframe_fre_internal *fre, *prev_fre = NULL;
@@ -503,40 +572,18 @@ static __always_inline int __find_fre(struct sframe_section *sec,
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
@@ -661,20 +708,23 @@ static int sframe_validate_section(struct sframe_section *sec) { return 0; }
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
 
@@ -721,6 +771,45 @@ static int sframe_read_header(struct sframe_section *sec)
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
@@ -757,6 +846,7 @@ int sframe_add_section(unsigned long sframe_start, unsigned long sframe_end,
 	if (!sec)
 		return -ENOMEM;
 
+	sec->sec_type		= SFRAME_USER;
 	sec->sframe_start	= sframe_start;
 	sec->sframe_end		= sframe_end;
 	sec->text_start		= text_start;
@@ -877,3 +967,5 @@ SYSCALL_DEFINE5(stacktrace_setup, int, op, unsigned long, addr_start,
 	}
 	return -EINVAL;
 }
+
+#endif /* CONFIG_HAVE_UNWIND_USER_SFRAME */
diff --git a/kernel/unwind/user.c b/kernel/unwind/user.c
index 3d596da588d0..5670579e3990 100644
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
 
@@ -76,19 +77,19 @@ static int unwind_user_next_common(struct unwind_user_state *state,
 
 	/* Get the Return Address (RA) */
 	switch (frame->ra.rule) {
-	case UNWIND_USER_RULE_RETAIN:
+	case UNWIND_RULE_RETAIN:
 		if (!state->topmost || unwind_user_get_ra_reg(&ra))
 			return -EINVAL;
 		break;
 	/*
-	 * UNWIND_USER_RULE_CFA_OFFSET doesn't make sense for RA.
+	 * UNWIND_RULE_CFA_OFFSET doesn't make sense for RA.
 	 * A return address cannot legitimately be a stack address.
 	 */
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
@@ -97,24 +98,24 @@ static int unwind_user_next_common(struct unwind_user_state *state,
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
 	/*
-	 * UNWIND_USER_RULE_CFA_OFFSET is currently not used for FP
+	 * UNWIND_RULE_CFA_OFFSET is currently not used for FP
 	 * (e.g. SFrame cannot represent this rule).
 	 */
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
@@ -123,7 +124,7 @@ static int unwind_user_next_common(struct unwind_user_state *state,
 		WARN_ON_ONCE(1);
 		return -EINVAL;
 	}
-	if (frame->fp.rule & UNWIND_USER_RULE_DEREF &&
+	if (frame->fp.rule & UNWIND_RULE_DEREF &&
 	    get_user_word(&fp, fp, 0, state->ws))
 		return -EINVAL;
 
@@ -139,13 +140,13 @@ static int unwind_user_next_fp(struct unwind_user_state *state)
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
@@ -153,10 +154,10 @@ static int unwind_user_next_fp(struct unwind_user_state *state)
 
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
2.54.0.563.g4f69b47b94-goog


