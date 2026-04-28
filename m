Return-Path: <live-patching+bounces-2594-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id GNJrBMf+8GnubgEAu9opvQ
	(envelope-from <live-patching+bounces-2594-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Tue, 28 Apr 2026 20:39:03 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 9A50248ABF5
	for <lists+live-patching@lfdr.de>; Tue, 28 Apr 2026 20:39:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id A0E6330693DF
	for <lists+live-patching@lfdr.de>; Tue, 28 Apr 2026 18:37:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A56747B405;
	Tue, 28 Apr 2026 18:37:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jTZeXEuC"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE0E523A561
	for <live-patching@vger.kernel.org>; Tue, 28 Apr 2026 18:37:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777401441; cv=none; b=hG+XqVIziCSh8Yq0Lo9cnAe/dhwPEH2w9sOyHIvp6vP5DTFAYa5sC5/bpwoJnIYsAc2vrk4+0iYofq2iJ3G/MMu0LS18LsN69eCak38JFY1qppN1eDsXiIgQWis6HTGyJctfx5ezdDU8YHFZtgKw7SGsNovazveNv3DCYrj17kM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777401441; c=relaxed/simple;
	bh=57pPL7fXM2OfA7mEwfEVfLeqPvT/qphbCXDrvxnSDNE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=uCGRetA2/57+bFeIvoXvUashVuGREqY1FMLtu/z+qGIAc3S8Bw6X6oZutAX4979MvlWraFrpv9WIx5L+TeWR3T+81PPMP7hr3N08A0bTWSiumUg0/gLnUGTk70mKDUv2xfjBT12vj46XF6p7gaJ4fC9+OusWR0omPnMQ+BoybfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--dylanbhatch.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jTZeXEuC; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--dylanbhatch.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-82fa860e71eso5686507b3a.0
        for <live-patching@vger.kernel.org>; Tue, 28 Apr 2026 11:37:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777401439; x=1778006239; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=uAHjM+ToD9UfswYHel5T1N/OddHAZ2XMTwnzhPtkH7g=;
        b=jTZeXEuCbG9Pm2ikTqnhd0sLrkgpkhCQACujYB1rEOmNwRO8oMPrVWTHLC/7eW3thJ
         /aD/55xNoMuVtZGi8n5T9Zd18qV9tyhRNkY9TWtm8FfSbeVp0WAeDk4II7Kts+sI5HbZ
         0sCymuBjA628Z5JwfetWoherPzqy1hWo1YYa7X3AWoPlEWvzocPozBRBHBqroppVXQ2a
         fwC6t1lNY38mPJacSTanr4pDAkYIcwqK5Aen+n4twOLgWxAhdW+WMRk1VV80RR3JY5C0
         l1KqdMncOiV80HfKU32yfMvFKrs4uIumYfjgcBcfXI2DH60eHyxpCIp/XP/CAJOdllxZ
         adfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777401439; x=1778006239;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uAHjM+ToD9UfswYHel5T1N/OddHAZ2XMTwnzhPtkH7g=;
        b=JzZFy0YqIcNW5ITNAhHPGUQUMGUK8vCOAASsdFtvrRmAi0A8gK3LJRUcqQNaMfHFXx
         CeQ9ZjQse4UqvDs+PYtOmjLRQk6pxN4+5BghVoW2hSZwx/9Kuz0y45dJAYCwrQ1g8rF+
         db22F/hg0ibNec8WmUNs7Es9BJKYNStxyZ+zQFGky3N0jdOdKyHOzrmT9uWAo5t5awZW
         iCq0PFbYof4idWgZGJYLaDeHono9I6zpwOXkxupngCeOLqk7Bcm6SYxLIGqQzpWC6ipG
         /oHimEMsnysxYD4zHTtVMy1wR8oWSJ7xzVKrIaF0sp72jR88IdpTOWSMQscrI+holHEq
         g5Ig==
X-Forwarded-Encrypted: i=1; AFNElJ9+RCTvGlj+7UM6+jJ735XwRN8d1PtV+MqNAUwUK+H0zUjFbGDtspctfJj3jkGko38BRwtu0aPcnHoRs7P5@vger.kernel.org
X-Gm-Message-State: AOJu0YyN+OBKrY7ogz/p+A6r7ZrEbXlyCZ+HPLr1pMtSgKk2LtIrov1V
	9lf8BuezLuuvAovKlHLSDI1W5/0ahKr4PnuStD3X46L8V74p1+6+tleNiYgeddS6TSqgRCIDXlM
	N3gd4QN9YpbQI/qy+XZn0N3oVeg==
X-Received: from pfblh13.prod.google.com ([2002:a05:6a00:710d:b0:82f:b5a0:b27])
 (user=dylanbhatch job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:1789:b0:82c:9c47:fefb with SMTP id d2e1a72fcca58-834ddad2852mr4478288b3a.20.1777401438937;
 Tue, 28 Apr 2026 11:37:18 -0700 (PDT)
Date: Tue, 28 Apr 2026 18:36:39 +0000
In-Reply-To: <20260428183643.3796063-1-dylanbhatch@google.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260428183643.3796063-1-dylanbhatch@google.com>
X-Mailer: git-send-email 2.54.0.545.g6539524ca2-goog
Message-ID: <20260428183643.3796063-5-dylanbhatch@google.com>
Subject: [PATCH v5 4/8] sframe: Provide PC lookup for vmlinux .sframe section
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
X-Rspamd-Queue-Id: 9A50248ABF5
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FREEMAIL_TO(0.00)[linux.dev,google.com,kernel.org,gmail.com,infradead.org,goodmis.org,arm.com,linux.ibm.com];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[21];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[dylanbhatch@google.com,live-patching@vger.kernel.org];
	TAGGED_FROM(0.00)[bounces-2594-lists,live-patching=lfdr.de];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	TAGGED_RCPT(0.00)[live-patching];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]

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
index 89dd8c5a6a10..430bff9533ee 100644
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
2.54.0.545.g6539524ca2-goog


