Return-Path: <live-patching+bounces-2416-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id WEjuIGgA6GlJEAIAu9opvQ
	(envelope-from <live-patching+bounces-2416-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Wed, 22 Apr 2026 00:55:36 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id DC12244053A
	for <lists+live-patching@lfdr.de>; Wed, 22 Apr 2026 00:55:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 12DA630F30A7
	for <lists+live-patching@lfdr.de>; Tue, 21 Apr 2026 22:52:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2FEB13A6F06;
	Tue, 21 Apr 2026 22:52:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="c36Lf7T5"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4D594414
	for <live-patching@vger.kernel.org>; Tue, 21 Apr 2026 22:52:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776811942; cv=none; b=LjiwfzRAlVI908VFToKsowH2Nzr7Oa4RLpE3MmdOVnlEjEO44j6cuolpUWohzHQ8yyDpexAcxbHainnMdFIyjv5HGRl1rpCNWgLT6Zx4lXWs7BYqKQCkspq894bExBPCswyCy9cyFRDWKuKDDIf/Pw7nVX6rj54oKqozmd84R1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776811942; c=relaxed/simple;
	bh=HVaWq1dxFNQfepawJxR+vwfJ462W5or0AaOM9S8qC4g=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=tj8vuQNWyf18NwPTILrwQsHOa7rySr25u3dbJKJrh5GBKIOva/bbLu1wFd3k8p6/b7yw97tdG96jQJ4bizeS91wiHBEaIuSxekAHJ+xXnA6GVutwUh/N4U5m43QjakCXwQqB1d7XVTzAUQjFJA5cWptSkf8IAvK8auVw8nKA+JM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--dylanbhatch.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=c36Lf7T5; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--dylanbhatch.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-82f6610a6c8so2382463b3a.2
        for <live-patching@vger.kernel.org>; Tue, 21 Apr 2026 15:52:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1776811940; x=1777416740; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=r/yLmRqvzN2aFF0ctBbudoPYYemVc0jOSsthBuuHiX4=;
        b=c36Lf7T5nK9liCQZTVHULZ54xQwFTg/QcKCha/Nqhjq6XcOWCzX8ASuLjTDNcaXVz8
         FCaBtWxae+hNgm68T/sgqVSiuiz0b//T8BXkR1Lk4RuZlo4eJUNDRtr3wtMHR032XDL9
         2/+lVX6hswUNgltJmQlnooR1EiiglgU8cesIasV+9QWweSljkInfk/BURnBlRpOLhH7t
         I/SikEXpQSjaUniI4NgobxxM1PGFlJkQF8SmO6lehv2aAzi2R2yJI5LQHvpu1rh5srKu
         C9H/HK4kFr2NqTL2PKP3YDogs8WG0PAM+hyflZ2A3VaTZST6KYHBd2Ir/9uBWEuZUi22
         HBUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776811940; x=1777416740;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=r/yLmRqvzN2aFF0ctBbudoPYYemVc0jOSsthBuuHiX4=;
        b=cfj02XkgCBZ2krrgarIhzo2U7bsaKYxoWTMV2MGIeWyQI5kUxW6E4lapWHHNX8+EmA
         VjP7vYUW7NdaSf2QR0yp7LSLWZQKi6kEUARcq6iu9Ikk+ppeSGxoYYeALQBaNAdM/ep6
         b/1vsoxsUCTPd53F1maqMc6XOuXLv9KBiEr6LWeIsHOGH5CJe7FfD9qtKnl70KlioGHo
         /cGGadVmro1KKkJ6UKIGag/BTxu0NZCEayV3Z+ognRiBgLCdT3YfO38ta7u8A5SzAhxw
         wSmdR5yI5tMeU0p4J4q1XUcr2KOZek+0TXNIBdpSpfCXevjNERcRiZfY3kSZ1RxF2SnX
         279g==
X-Forwarded-Encrypted: i=1; AFNElJ8Uz3sLDwiQHVV9vTVH7EWBXZJf20vT3kYGaFA84IrL3c807W13f9KlR+FIaL2sht6DkXGa32XsHhqM1o4P@vger.kernel.org
X-Gm-Message-State: AOJu0Yy3c83jvtkMSJqH8aCyoI0VMjoz0049T2OFk+Ds83+LzBOLhrKH
	gudFAKUxQry1aMKuo+qT9E+Wr8Okp7UYaPeRaKyiTU7MwlaS7GGgsW0cgaObKOcwEh3xM0LfACQ
	c5d+tZNjPA6rVbqhej5gLeDvDiQ==
X-Received: from pfbde11.prod.google.com ([2002:a05:6a00:468b:b0:82f:3ec7:cdd])
 (user=dylanbhatch job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:ae10:b0:82f:9300:cc44 with SMTP id d2e1a72fcca58-82f9300d8d3mr17127125b3a.8.1776811939880;
 Tue, 21 Apr 2026 15:52:19 -0700 (PDT)
Date: Tue, 21 Apr 2026 22:51:56 +0000
In-Reply-To: <20260421225200.1198447-1-dylanbhatch@google.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260421225200.1198447-1-dylanbhatch@google.com>
X-Mailer: git-send-email 2.54.0.rc1.555.g9c883467ad-goog
Message-ID: <20260421225200.1198447-5-dylanbhatch@google.com>
Subject: [PATCH v4 4/8] sframe: Provide PC lookup for vmlinux .sframe section
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
	TAGGED_FROM(0.00)[bounces-2416-lists,live-patching=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[dylanbhatch@google.com,live-patching@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TAGGED_RCPT(0.00)[live-patching];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: DC12244053A
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

With SFRAME_UNWINDER, read in the .sframe section at boot. This provides
unwind data as an alternative/supplement to frame pointer-based
unwinding.

Reviewed-by: Jens Remus <jremus@linux.ibm.com>
Signed-off-by: Dylan Hatch <dylanbhatch@google.com>
---
 arch/arm64/kernel/setup.c |  2 ++
 include/linux/sframe.h    | 14 ++++++++++++++
 kernel/unwind/sframe.c    | 36 ++++++++++++++++++++++++++++++++++++
 3 files changed, 52 insertions(+)

diff --git a/arch/arm64/kernel/setup.c b/arch/arm64/kernel/setup.c
index 23c05dc7a8f2..4a633bc7aefb 100644
--- a/arch/arm64/kernel/setup.c
+++ b/arch/arm64/kernel/setup.c
@@ -32,6 +32,7 @@
 #include <linux/sched/task.h>
 #include <linux/scs.h>
 #include <linux/mm.h>
+#include <linux/sframe.h>
 
 #include <asm/acpi.h>
 #include <asm/fixmap.h>
@@ -375,6 +376,7 @@ void __init __no_sanitize_address setup_arch(char **cmdline_p)
 			"This indicates a broken bootloader or old kernel\n",
 			boot_args[1], boot_args[2], boot_args[3]);
 	}
+	init_sframe_table();
 }
 
 static inline bool cpu_can_disable(unsigned int cpu)
diff --git a/include/linux/sframe.h b/include/linux/sframe.h
index 0cb2924367bc..5b7341b61a7c 100644
--- a/include/linux/sframe.h
+++ b/include/linux/sframe.h
@@ -69,4 +69,18 @@ static inline int sframe_find_user(unsigned long ip, struct unwind_frame *frame)
 
 #endif /* CONFIG_HAVE_UNWIND_USER_SFRAME */
 
+#ifdef CONFIG_HAVE_UNWIND_KERNEL_SFRAME
+
+void __init init_sframe_table(void);
+void sframe_module_init(struct module *mod, void *sframe, size_t sframe_size,
+			void *text, size_t text_size);
+
+extern int sframe_find_kernel(unsigned long ip, struct unwind_frame *frame);
+
+#else
+
+static inline void __init init_sframe_table(void) {}
+
+#endif /* CONFIG_HAVE_UNWIND_KERNEL_SFRAME */
+
 #endif /* _LINUX_SFRAME_H */
diff --git a/kernel/unwind/sframe.c b/kernel/unwind/sframe.c
index ae15f5c06939..fb3b6b2d8677 100644
--- a/kernel/unwind/sframe.c
+++ b/kernel/unwind/sframe.c
@@ -14,10 +14,20 @@
 #include <linux/sframe.h>
 #include <linux/unwind_types.h>
 #include <asm/unwind_sframe.h>
+#ifdef CONFIG_HAVE_UNWIND_KERNEL_SFRAME
+#include <linux/kallsyms.h>
+#endif
 
 #include "sframe.h"
 #include "sframe_debug.h"
 
+#ifdef CONFIG_HAVE_UNWIND_KERNEL_SFRAME
+
+static bool sframe_init __ro_after_init;
+static struct sframe_section kernel_sfsec __ro_after_init;
+
+#endif /* CONFIG_HAVE_UNWIND_KERNEL_SFRAME */
+
 struct sframe_fde_internal {
 	unsigned long	func_addr;
 	u32		func_size;
@@ -930,3 +940,29 @@ void sframe_free_mm(struct mm_struct *mm)
 }
 
 #endif /* CONFIG_HAVE_UNWIND_USER_SFRAME */
+
+#ifdef CONFIG_HAVE_UNWIND_KERNEL_SFRAME
+
+int sframe_find_kernel(unsigned long ip, struct unwind_frame *frame)
+{
+	if (!frame || !sframe_init)
+		return -EINVAL;
+
+	return  __sframe_find(&kernel_sfsec, ip, frame);
+}
+
+void __init init_sframe_table(void)
+{
+	kernel_sfsec.sec_type		= SFRAME_KERNEL;
+	kernel_sfsec.sframe_start	= (unsigned long)__start_sframe;
+	kernel_sfsec.sframe_end		= (unsigned long)__end_sframe;
+	kernel_sfsec.text_start		= (unsigned long)_stext;
+	kernel_sfsec.text_end		= (unsigned long)_etext;
+
+	if (WARN_ON(sframe_read_header(&kernel_sfsec)))
+		return;
+
+	sframe_init = true;
+}
+
+#endif /* CONFIG_HAVE_UNWIND_KERNEL_SFRAME */
-- 
2.54.0.rc1.555.g9c883467ad-goog


