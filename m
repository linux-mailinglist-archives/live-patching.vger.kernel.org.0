Return-Path: <live-patching+bounces-2418-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 4MAJMsIA6GlJEAIAu9opvQ
	(envelope-from <live-patching+bounces-2418-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Wed, 22 Apr 2026 00:57:06 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 3306844058D
	for <lists+live-patching@lfdr.de>; Wed, 22 Apr 2026 00:57:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 9E3A331077EC
	for <lists+live-patching@lfdr.de>; Tue, 21 Apr 2026 22:52:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 798C73A6B74;
	Tue, 21 Apr 2026 22:52:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="nKOpW3be"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 033CA3A63EB
	for <live-patching@vger.kernel.org>; Tue, 21 Apr 2026 22:52:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776811948; cv=none; b=EUCfyoZcF/jTlDYPRp8wdJUp3ItXGMmy4KeaIYu4xF+zFM22pyLBN7W1kpyRahD5vD04g2mtSL+QtdkRBCE3wjrCWwSwNPqJMi1VXBFp8Whc6G6gzhZl7zxBFFHcz6E5ylOoc7Pl/MMLF9NRUZnnMFPg0jLsLvG2AAhDgrjPgKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776811948; c=relaxed/simple;
	bh=U/oW1pM1+B2l4PEI4R6STohHvDoOjFzqqD4QLLeJcnE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=eChX+h5+tUKk65d6nuQiGYGAazdpxobAS+fCxlVwD7RZdupQ1RkIUeLwoLn90u321JY3ECk9Jh71CzpPEkmue+3eGTcIbpUQsMDJVayWKJP+FZhQAwsHQEPsZ44bqPYcTfsH/4werjFL1ZB952NXqb+TZhdkD3y1hGpKyfHxrxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--dylanbhatch.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=nKOpW3be; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--dylanbhatch.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-82cf8dcd079so3114035b3a.1
        for <live-patching@vger.kernel.org>; Tue, 21 Apr 2026 15:52:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1776811945; x=1777416745; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=EFJJ7xjnagN752ApaKO1ffV+VO/ox5jo3HxnwGPNp0Q=;
        b=nKOpW3be3BClMnuJv43QqUsSkF5RWu0qTv0njVxcgQxDAXqe00mwZpRu0hIPvOZqu4
         l7HeWoiEGX5+enRulpUIMjXHsNfNdIjk5eh0+t3jCaN1CMGfkUpXoX4/V9c3Sl4fXDPB
         YC78Sb6Q8ggD4fq9deYxwZsxo4pqjqGEip3rfOXVINHG3uAgUA8ILlpEgAKjSi4kkl27
         RZ+vAHGFqPRwB/OTL9/h6xtj0lOVZG4B3mWzx8SiPTdvWM5xVTcuVRL2KqIxdgjq3i3G
         meTVgeITjL6V8GIdP+RDkIaYAsrEvgys4rB9jBhSyYNR/Y1ilxQ0gRFssjY2W2qgQPFe
         knOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776811945; x=1777416745;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EFJJ7xjnagN752ApaKO1ffV+VO/ox5jo3HxnwGPNp0Q=;
        b=dJp1PLzZRh/WUe1dpoi+HRUVUaLUiiJYdR6jf3n5do64iwVHBdy2apJOhR7xSQRdG6
         P+/tANkohAvMINhLJon8ZwHQSan5qQkKemQnR9LwO3IfwutSvI3Q0fRkVopa8yclVsRh
         IQylf5tfebuxLYfGQlrStaIM+KD+gEkkFeU9Lr2wf22mTlj0MRaRzQU5DAV3FyJAfE4s
         6WODNmEyHHBm/zr6YE+sm+a5Im57WUmwJHEbCDlG/CAF9RfHquT0BG4WxfBMB9+fKS7z
         +12zDw3/jefcIq9njOEEm/sfrl/mIo5aRI+r9XpbhLt4zTJIaRe5OMRoM6M4pvGOxdTz
         i7Kg==
X-Forwarded-Encrypted: i=1; AFNElJ/NGUSSuUCS8rbeIn4YEZIVXKQLG7VP6x+3kE0Q6RRCPVTI2wV922EzD9iwI0PVkMBLo8Xa6zUB2OfNAfbV@vger.kernel.org
X-Gm-Message-State: AOJu0Yz5req4Y4ddlrZ/SuA/6uGFlisgYIdHJZZps0KOggVcKAMXQ6bv
	hn4NDb4Cgz3dAO5nOOSH3S3HW7O/er9ahplPOloOIA45QejiamM65tjl2/OmeZ0lKWzYWNGrLoO
	F6N8aqzYAiaFGG38HE/pBHSubTQ==
X-Received: from pfbci14.prod.google.com ([2002:a05:6a00:28ce:b0:82f:7242:4cb9])
 (user=dylanbhatch job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:2d1f:b0:82c:e19d:cabd with SMTP id d2e1a72fcca58-82f8c7ee387mr20113311b3a.10.1776811945127;
 Tue, 21 Apr 2026 15:52:25 -0700 (PDT)
Date: Tue, 21 Apr 2026 22:51:58 +0000
In-Reply-To: <20260421225200.1198447-1-dylanbhatch@google.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260421225200.1198447-1-dylanbhatch@google.com>
X-Mailer: git-send-email 2.54.0.rc1.555.g9c883467ad-goog
Message-ID: <20260421225200.1198447-7-dylanbhatch@google.com>
Subject: [PATCH v4 6/8] arm64/module, sframe: Add sframe support for modules
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
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
	TAGGED_FROM(0.00)[bounces-2418-lists,live-patching=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[dylanbhatch@google.com,live-patching@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TAGGED_RCPT(0.00)[live-patching];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 3306844058D
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

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
index 243027244854..20178e02f428 100644
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
2.54.0.rc1.555.g9c883467ad-goog


