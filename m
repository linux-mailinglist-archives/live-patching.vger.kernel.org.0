Return-Path: <live-patching+bounces-2857-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id uF5THZsJDGo5UQUAu9opvQ
	(envelope-from <live-patching+bounces-2857-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Tue, 19 May 2026 08:56:27 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id E2320578758
	for <lists+live-patching@lfdr.de>; Tue, 19 May 2026 08:56:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 588D430B007C
	for <lists+live-patching@lfdr.de>; Tue, 19 May 2026 06:50:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3EA163A874D;
	Tue, 19 May 2026 06:50:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="OchiI2QX"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B5F43A5421
	for <live-patching@vger.kernel.org>; Tue, 19 May 2026 06:50:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779173418; cv=none; b=cfMcYq0dogCrLueR9SFdW/1pYT8IThevWPa9S4MKDbGhEdnBIAvx/j1k2UnHHwhopKvv4u7z3On5xQCS0RGzc95s4abO4q9y5KAz0Lev5aVmEurVoOml9T8b4ImuZ4qD1GJr5GUY8oFr18d4chlQJ5DnNL6tjrTVPTocGJSBbJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779173418; c=relaxed/simple;
	bh=V6Ajkzq20UUV0WbggGVXFzXuOLKKixDOGIhYnh7QZdI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=WXHVbK11WYLCC6gaj78eFMfxzpPJtNy+mc7MzSBDFHaTK8ufBRXWMN8E8DLEP9w+3t6NnBGD4jFddwGfxFsPnpXf8PjEshAbFm696omoispw4UMwwGqiyAn/OKifi5vaYmjSb91yY5BmaejYyiU2dpkvltRhC0u/Y5VPr2rNCl4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--dylanbhatch.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=OchiI2QX; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--dylanbhatch.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-82fa2165c3eso2048658b3a.0
        for <live-patching@vger.kernel.org>; Mon, 18 May 2026 23:50:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779173415; x=1779778215; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=3OKDn3irXxkoNpNbFP+MgIX3i55bASKNugifIVvfI/8=;
        b=OchiI2QX0ShN1ISwRhOsyHZR2SDMt6B2hSadFMsctlvKoQGtHDBceeb82299I1bJIA
         f8J8zzhjpmkg1aO5kDdANVuM5O4V64+G/h/zwQrv7m33xp1R4TD9raVP1fTJ+p0Rnv1M
         uzZacvIyXaVR51/VeaitqaIXNmYDzeOiOWFS+MYaUSJyaum4Nkct+d20Tfq55yrz6drg
         uec65dIhrvSQ8gMGnYZehssWVIrV+JagIpPoe/PrRuXaaZWDiefbiM2GtChpS42y1+Bz
         b0IXGLl/HuVExEfXkO/uI9ABnlPcnIwTEhgGIVv0IM0A8wAhKgWaBc77C0m65UuEiHZ4
         8r4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779173415; x=1779778215;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3OKDn3irXxkoNpNbFP+MgIX3i55bASKNugifIVvfI/8=;
        b=lra4uqmPUhCClG0YuZ0pKgYiOTERxn+xP6Kh9njLpSzAk0DcIso3QZSrdhWVf0AB2X
         RbRD8GQCskD4aPWiYbv4v1UXnGZMEjETyhwGme9rLMiCpfd57oZ2anOsNS0iW9hZvsXq
         qkTt/OX0blr/VL2wNxM0ICyw+M6VJirsRDDF4L4zo8K4qJGKqLhnmqO1eWaPv5ZuZ9D7
         BnM9pjAcs9WYU0jDc+nBNjxxqlDsuGA57symv4WpA+qUO/42O0nXYdv74eXriPgtBtSQ
         LXL5GjdHX20MB5NFPVWIqmpo35pTR/0ISwPnqOz+hn7YLB53qUL2evRAKIv8lnjklVyi
         B97w==
X-Forwarded-Encrypted: i=1; AFNElJ8iFSogYBY+PxgJki4okcSuQLnI/j3exJmNFXt0duUq8skinKss16GpoUoN2QYHekvq5fBAb9SPpbn+nChj@vger.kernel.org
X-Gm-Message-State: AOJu0YwHIuBjTpbZz7hRgH4uYTPw3CuKnzprM71s1lo+InzRvbyv10hE
	TBOUKXpQhhKfE5hE8l2HRcReAetAnBvfzWs8Mw/GD+zE/s86DNFU1f24KDM6Lvm0qAmIhSsKgEZ
	VWzPgmYDomYrd9BKntWhW8T7OmQ==
X-Received: from pfbcm24.prod.google.com ([2002:a05:6a00:3398:b0:82f:a139:b084])
 (user=dylanbhatch job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:98d:b0:835:4447:69cf with SMTP id d2e1a72fcca58-83f33d27819mr18277938b3a.27.1779173414630;
 Mon, 18 May 2026 23:50:14 -0700 (PDT)
Date: Tue, 19 May 2026 06:49:46 +0000
In-Reply-To: <20260519064950.493949-1-dylanbhatch@google.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260519064950.493949-1-dylanbhatch@google.com>
X-Mailer: git-send-email 2.54.0.563.g4f69b47b94-goog
Message-ID: <20260519064950.493949-6-dylanbhatch@google.com>
Subject: [PATCH v6 5/9] sframe: Provide PC lookup for vmlinux .sframe section
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
	TAGGED_FROM(0.00)[bounces-2857-lists,live-patching=lfdr.de];
	TAGGED_RCPT(0.00)[live-patching];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo]
X-Rspamd-Queue-Id: E2320578758
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

With HAVE_UNWIND_KERNEL_SFRAME, read in the .sframe section at boot.
This provides unwind data as an alternative/supplement to frame pointer
based unwinding.

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
index a2ab9a3e07b4..c8ec1e9989fc 100644
--- a/kernel/unwind/sframe.c
+++ b/kernel/unwind/sframe.c
@@ -16,10 +16,20 @@
 #include <linux/unwind_types.h>
 #include <asm/unwind_sframe.h>
 #include <uapi/linux/stacktrace.h>
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
@@ -969,3 +979,29 @@ SYSCALL_DEFINE5(stacktrace_setup, int, op, unsigned long, addr_start,
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
2.54.0.563.g4f69b47b94-goog


