Return-Path: <live-patching+bounces-2596-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id SJCYDN/+8GnubgEAu9opvQ
	(envelope-from <live-patching+bounces-2596-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Tue, 28 Apr 2026 20:39:27 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id CF7BE48AC0C
	for <lists+live-patching@lfdr.de>; Tue, 28 Apr 2026 20:39:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id CCE3130764D4
	for <lists+live-patching@lfdr.de>; Tue, 28 Apr 2026 18:37:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2DABC47B42F;
	Tue, 28 Apr 2026 18:37:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dBOUo4oH"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D06947B426
	for <live-patching@vger.kernel.org>; Tue, 28 Apr 2026 18:37:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777401448; cv=none; b=pguES06/vfDlxh2A+qOa3VcF+E9oO21ZlIjU32/Lz9g4SBw1R2WXG+/vQwkHqzRSif9/EPaymLZPWndj9xifZSF5qzQGjHDze/S5qYP0iUPk2GXvcsLhzpsbqfzLaI1/Fqa1QglhQf4FDNoweGaTXHjA1ip0OQ+XwamS7DZ0Vlk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777401448; c=relaxed/simple;
	bh=VU/AUcZ1EaUk6V/EpDZo4mcmhiF2Ge8dGm5Jwl/Qplw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=YIVdMN4VSofdkONZBvuoNUjmgn8kf6rma5RlYsPfaiCXTznXetKxHRwnlLclakgijQGyykyhdxZcKxS9RByLhXDXnuac/cwKgkdPOp2l61Y7MNH04gWCkVhLcpAzoG5gDxPyWvkadmT9noocBO2VRM9fJGCcLAhoX+1r144UAGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--dylanbhatch.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=dBOUo4oH; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--dylanbhatch.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2b2eba42b8dso105381215ad.0
        for <live-patching@vger.kernel.org>; Tue, 28 Apr 2026 11:37:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777401446; x=1778006246; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=M7EyQfNtegfTWEfYy8kG9xX+fYrEWmDcicnmg1Ulors=;
        b=dBOUo4oHYE93I9Lvkkoi0jRWP3BrC2uBsU4+R3xwErIwl6rzl02duWiAfEaaoCVY01
         bH7dQ616qBGVzMAJUElNLC0xxjtlzRXJEqMJHyVBpRG1qEKhm1tR4XrWdMQA1xcB9qF/
         IFu01l1N/MoaJVSYvHKyoW422v4ZtuTA6Wfd1G+GHpOsltIX+xd2WqEHNH7/DPzt9cwC
         NgOiWWk54EWxe0kC9qrZZOK+J6pP1uc0vjHSa/HIsxl+4ihtfutPSyuzmCZgqlsKuHDr
         peKpe1ST94TvIUOhk7vESFjM0+lQqPUmX8hcv5P20TvRe4/2OoB7nv3NVcaeepgQC8Q6
         QXwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777401446; x=1778006246;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=M7EyQfNtegfTWEfYy8kG9xX+fYrEWmDcicnmg1Ulors=;
        b=k/f7Xcuq2AZckExHAm783jSBUPpWi3NnqGNrLKMkEU9PFuOjKpaBBkj4dpPwIONmFb
         8Ke+F8dKvinIhXkHC0WTEQZXMDLb9eA98N4v5eWWvbTmhLtafrMgduyJs6RadqYs8DeL
         aaXUTcsR0eRfm991gg+5NWgjIinPze8Wbfrxcldig0VX+vqD4++H9E1lwwLtf323EgDy
         3o4bpB3vTjw1V6wgjVgoAQshLoqhuowqsNxBKrsxbIC3w2t6W+TyMxf6CszCtI9Yr4bw
         SthcKfjV0b+p5VzjMS8SSXXTN2+1nRXf4mfSKEVi7Nl3HWjSaxj9glvsncz7TZfU/ClN
         iw/A==
X-Forwarded-Encrypted: i=1; AFNElJ+Yfa1EDsPdwN8cUDMQe7dP6V1XQ2EsEmKkQHHIxmn5x+HJrvHLqoDiJ2J2N/QRfqnQoRsXl+gMrcqbX3zm@vger.kernel.org
X-Gm-Message-State: AOJu0YyCpen0LxEJYZyfnZlyp/mRAIMvQJ7beJ7IexfCYzh8Gwfm14o/
	sUG/yeiqbXyWwYpfRm+/h+lmkYapV+XHfUhwJDVk+0mhRd+UN/ZmnL0VgKTk8yb0kGi+U7RdDLV
	TpkBJtot35R9YoIMp1JrKOAj6+Q==
X-Received: from pgbdp11.prod.google.com ([2002:a05:6a02:f0b:b0:c6d:caaa:3364])
 (user=dylanbhatch job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a20:7286:b0:3a2:d629:16a2 with SMTP id adf61e73a8af0-3a39bfc6a83mr4727109637.10.1777401445332;
 Tue, 28 Apr 2026 11:37:25 -0700 (PDT)
Date: Tue, 28 Apr 2026 18:36:41 +0000
In-Reply-To: <20260428183643.3796063-1-dylanbhatch@google.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260428183643.3796063-1-dylanbhatch@google.com>
X-Mailer: git-send-email 2.54.0.545.g6539524ca2-goog
Message-ID: <20260428183643.3796063-7-dylanbhatch@google.com>
Subject: [PATCH v5 6/8] arm64/module, sframe: Add sframe support for modules
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
X-Rspamd-Queue-Id: CF7BE48AC0C
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
	TAGGED_FROM(0.00)[bounces-2596-lists,live-patching=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[dylanbhatch@google.com,live-patching@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	TAGGED_RCPT(0.00)[live-patching];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]

Add sframe table to mod_arch_specific and support sframe PC lookups when
an .sframe section can be found on incoming modules.

Signed-off-by: Weinan Liu <wnliu@google.com>
Reviewed-by: Jens Remus <jremus@linux.ibm.com>
Signed-off-by: Dylan Hatch <dylanbhatch@google.com>
---
 arch/arm64/include/asm/module.h |  6 +++++
 arch/arm64/kernel/module.c      |  8 +++++++
 include/linux/sframe.h          |  2 ++
 kernel/unwind/sframe.c          | 40 +++++++++++++++++++++++++++++++--
 4 files changed, 54 insertions(+), 2 deletions(-)

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
index 8ae31ed36226..27f5a66190af 100644
--- a/include/linux/sframe.h
+++ b/include/linux/sframe.h
@@ -81,6 +81,8 @@ extern int sframe_find_kernel(unsigned long ip, struct unwind_frame *frame);
 #else
 
 static inline void __init init_sframe_table(void) {}
+static inline void sframe_module_init(struct module *mod, void *sframe, size_t sframe_size,
+				      void *text, size_t text_size) {}
 
 #endif /* CONFIG_HAVE_UNWIND_KERNEL_SFRAME */
 
diff --git a/kernel/unwind/sframe.c b/kernel/unwind/sframe.c
index dcf4deb378dc..70001c8e586d 100644
--- a/kernel/unwind/sframe.c
+++ b/kernel/unwind/sframe.c
@@ -980,10 +980,27 @@ void sframe_free_mm(struct mm_struct *mm)
 
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
@@ -1000,4 +1017,23 @@ void __init init_sframe_table(void)
 	sframe_init = true;
 }
 
+void sframe_module_init(struct module *mod, void *sframe, size_t sframe_size,
+			void *text, size_t text_size)
+{
+	struct sframe_section sec;
+
+	memset(&sec, 0, sizeof(sec));
+	sec.sec_type	 = SFRAME_KERNEL;
+	sec.sframe_start = (unsigned long)sframe;
+	sec.sframe_end   = (unsigned long)sframe + sframe_size;
+	sec.text_start   = (unsigned long)text;
+	sec.text_end     = (unsigned long)text + text_size;
+
+	if (WARN_ON(sframe_read_header(&sec)))
+		return;
+
+	mod->arch.sframe_sec = sec;
+	mod->arch.sframe_init = true;
+}
+
 #endif /* CONFIG_HAVE_UNWIND_KERNEL_SFRAME */
-- 
2.54.0.545.g6539524ca2-goog


