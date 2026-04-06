Return-Path: <live-patching+bounces-2302-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id WKoBKbsA1GnmpAcAu9opvQ
	(envelope-from <live-patching+bounces-2302-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Mon, 06 Apr 2026 20:51:39 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A32713A661B
	for <lists+live-patching@lfdr.de>; Mon, 06 Apr 2026 20:51:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 95B78301093D
	for <lists+live-patching@lfdr.de>; Mon,  6 Apr 2026 18:50:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 709FA396B9A;
	Mon,  6 Apr 2026 18:50:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Zs/7F3qF"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 035A7396B6D
	for <live-patching@vger.kernel.org>; Mon,  6 Apr 2026 18:50:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775501427; cv=none; b=n7iXig1pgBRJwvOLui4wANov6go0qDkeu53CvrR3g9sYUfdWO2h6KeA+gMpiVbRJHEEwAUHMWcBk182waVOdxLoD3j3P2ZAR8nnIuS9mLIH0qy/3wyvhqd9E+BWAHaMFOGFRyihq32r367UxZLSsOToG/4hqRKl6QeQn+c3FvsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775501427; c=relaxed/simple;
	bh=932M4EHTQvdCDGtwUM/Vrh9msTuo3oJ8/i3ljoodip0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=T3PvJTGQBsg/ska/RzAvGbdiJeHye0kxq6Lgax9qThry/I++YGeP7ZDvEi3l3gos5Htg2nuIEzcFN2Ib7OXwMVdSiy1hXaCQJrZIF0nTdhfWHcHE0tMtGd0qwggPxba96s2hFzMaHe6obyd/sVUC5UwjpcZRXOTMd2bM3Lv+g70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--dylanbhatch.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Zs/7F3qF; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--dylanbhatch.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-c7424d91b2dso2099808a12.1
        for <live-patching@vger.kernel.org>; Mon, 06 Apr 2026 11:50:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1775501425; x=1776106225; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=MdqPVoHRwnHco6kAfBJ1zgi0YfCPZYijdJUSHSI46+Y=;
        b=Zs/7F3qFENa1CeApZhnBxldxz+NPDMjEOdU0C5DNbQ9UrThdKrHmL1UFXUba1/Pjvv
         THegru/w7KvZP4JLCX+R504SRbcnVsx5l9ZGBosgRbpp5Ks0UcdxwYEHO7hMZrZo2ESg
         HXFxX4H3PRH4KzJhN4Bs1DK0ApXOvkhBDMCBEcXDn/HNYFq2RO0vjD+h3MGD+RBo/GF6
         p2t07Bc4dNB1XT62mv+FGOxwB3P3zHdLWxyCN6BSwr0Tm0UWPOV3fBSREvn/RxfLkzJr
         SZ2I7RAQRxmFdH84JXeiro5beG7Qe7G+HdrgI8noHahg84P25AXYmJaKDULQo2joSwM0
         32Nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775501425; x=1776106225;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MdqPVoHRwnHco6kAfBJ1zgi0YfCPZYijdJUSHSI46+Y=;
        b=MbPIXV3jf2qnhr+s/JBt7tLOQv0ur/Wr8z8m9KX40oMuWEiR6no+uL+PwNDpXi+HKM
         2tlZv3lAbJs3sEBqnvL5YehPgVa9EUZ5CbQuhwJaahtbsLp57BjRsMkmXI/e/0WTyBj3
         cUrLsZn+DEGStru0VniFmuiOaQSxjuw3eCXiCP55Gv2FG9JR1oDrLH1ieDacwgCGyFT1
         dcvv92Y8KxTG9SAXPaqRNwkGzWsn4tyEllJW4fZxAyugxx0syj/qe0Wj11sPKFdrZzh3
         sT8dncqfIVwZYDtIuLRf4UsbqQ4GWwhFCDv/XoDB82b8a1VYpa17nwgQXy+vERbGeS37
         WDTg==
X-Forwarded-Encrypted: i=1; AJvYcCXX9x8gzomM8xaoRvS5+Qx62rjc5VRd4KJe2iHUxfxp204Fx1RRTUmZTrBvrnkS+og2+DqH+GDE1yk0A0kE@vger.kernel.org
X-Gm-Message-State: AOJu0YzqXgb5nwjo5sRx0fxbhx9XYcyk7CGP1o8zqqTgGxJdH8apMF98
	2KWSvS0aYpqlyXmY9kI+CIM5bQUllcxK+5cY3pafWots2KW2NbKul5R84KZw6ZTFw+zpRPoZxxR
	jEG0ND1LNIMgORoqCjtL56YnTIw==
X-Received: from pfo22.prod.google.com ([2002:a05:6a00:2f6:b0:829:a228:6330])
 (user=dylanbhatch job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:a0f:b0:829:8a84:b9fc with SMTP id d2e1a72fcca58-82d0da33e8fmr12546186b3a.8.1775501425116;
 Mon, 06 Apr 2026 11:50:25 -0700 (PDT)
Date: Mon,  6 Apr 2026 18:49:56 +0000
In-Reply-To: <20260406185000.1378082-1-dylanbhatch@google.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260406185000.1378082-1-dylanbhatch@google.com>
X-Mailer: git-send-email 2.53.0.1213.gd9a14994de-goog
Message-ID: <20260406185000.1378082-5-dylanbhatch@google.com>
Subject: [PATCH v3 4/8] sframe: Provide PC lookup for vmlinux .sframe section.
From: Dylan Hatch <dylanbhatch@google.com>
To: Roman Gushchin <roman.gushchin@linux.dev>, Weinan Liu <wnliu@google.com>, 
	Will Deacon <will@kernel.org>, Josh Poimboeuf <jpoimboe@kernel.org>, 
	Indu Bhagat <indu.bhagat@oracle.com>, Peter Zijlstra <peterz@infradead.org>, 
	Steven Rostedt <rostedt@goodmis.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Jiri Kosina <jikos@kernel.org>
Cc: Dylan Hatch <dylanbhatch@google.com>, Mark Rutland <mark.rutland@arm.com>, 
	Prasanna Kumar T S M <ptsm@linux.microsoft.com>, Puranjay Mohan <puranjay@kernel.org>, 
	Song Liu <song@kernel.org>, joe.lawrence@redhat.com, linux-toolchains@vger.kernel.org, 
	linux-kernel@vger.kernel.org, live-patching@vger.kernel.org, 
	Jens Remus <jremus@linux.ibm.com>, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-2302-lists,live-patching=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[20];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[dylanbhatch@google.com,live-patching@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	TAGGED_RCPT(0.00)[live-patching];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: A32713A661B
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

With SFRAME_UNWINDER, read in the .sframe section at boot. This provides
unwind data as an alternative/supplement to frame pointer-based
unwinding.

Signed-off-by: Dylan Hatch <dylanbhatch@google.com>
---
 arch/arm64/kernel/setup.c |  2 ++
 include/linux/sframe.h    | 14 ++++++++++++++
 kernel/unwind/sframe.c    | 39 +++++++++++++++++++++++++++++++++++++++
 3 files changed, 55 insertions(+)

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
index 673b9edfc921..905775c3fde2 100644
--- a/include/linux/sframe.h
+++ b/include/linux/sframe.h
@@ -109,4 +109,18 @@ static inline int sframe_find_user(unsigned long ip, struct unwind_frame *frame)
 
 #endif /* CONFIG_HAVE_UNWIND_USER_SFRAME */
 
+#ifdef CONFIG_SFRAME_UNWINDER
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
+#endif /* CONFIG_SFRAME_UNWINDER */
+
 #endif /* _LINUX_SFRAME_H */
diff --git a/kernel/unwind/sframe.c b/kernel/unwind/sframe.c
index cad4384dfb4f..321d0615aec7 100644
--- a/kernel/unwind/sframe.c
+++ b/kernel/unwind/sframe.c
@@ -13,10 +13,23 @@
 #include <linux/string_helpers.h>
 #include <linux/sframe.h>
 #include <asm/unwind_sframe.h>
+#ifdef CONFIG_SFRAME_UNWINDER
+#include <linux/kallsyms.h>
+#endif
 
 #include "sframe.h"
 #include "sframe_debug.h"
 
+#ifdef CONFIG_SFRAME_UNWINDER
+
+extern char __start_sframe_header[];
+extern char __stop_sframe_header[];
+
+static bool sframe_init __ro_after_init;
+static struct sframe_section kernel_sfsec __ro_after_init;
+
+#endif /* CONFIG_SFRAME_UNWINDER */
+
 struct sframe_fde_internal {
 	unsigned long	func_addr;
 	u32		func_size;
@@ -930,3 +943,29 @@ void sframe_free_mm(struct mm_struct *mm)
 }
 
 #endif /* CONFIG_HAVE_UNWIND_USER_SFRAME */
+
+#ifdef CONFIG_SFRAME_UNWINDER
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
+	kernel_sfsec.sframe_start	= (unsigned long)__start_sframe_header;
+	kernel_sfsec.sframe_end		= (unsigned long)__stop_sframe_header;
+	kernel_sfsec.text_start		= (unsigned long)_stext;
+	kernel_sfsec.text_end		= (unsigned long)_etext;
+
+	if (WARN_ON(sframe_read_header(&kernel_sfsec)))
+		return;
+
+	sframe_init = true;
+}
+
+#endif /* CONFIG_SFRAME_UNWINDER */
-- 
2.53.0.1213.gd9a14994de-goog


