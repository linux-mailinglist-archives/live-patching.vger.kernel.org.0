Return-Path: <live-patching+bounces-2304-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id aPgEHZcA1GnmpAcAu9opvQ
	(envelope-from <live-patching+bounces-2304-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Mon, 06 Apr 2026 20:51:03 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 194E03A660D
	for <lists+live-patching@lfdr.de>; Mon, 06 Apr 2026 20:51:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 2CA02300B59D
	for <lists+live-patching@lfdr.de>; Mon,  6 Apr 2026 18:50:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF105396D2E;
	Mon,  6 Apr 2026 18:50:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="gGydB3jz"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E536396560
	for <live-patching@vger.kernel.org>; Mon,  6 Apr 2026 18:50:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775501432; cv=none; b=im/o0LZaJCBKrOT93bZ/X9D4GhC/MazRb9QT3LOZOCloQy6/YIdzxbcYqjCv0gFYo0ExH+fur6Jdfy/1mSyvHstdU2RvNy1pCroqIiR2s6nzFbKXoBwz8hy+Zij8M9+lTEa7bHJccMpaj6EiXW6ZGll/Wg8eOFhUPBQqGu+CqGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775501432; c=relaxed/simple;
	bh=dqzZzfSk8bT1Zi1G9izPmtih5cUu0n+nhrzQ2I/IFpA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=WVIpWM7ubU+Kc5jR5pkaVR0Yu5DpMfCQC0+JeSdKaW2qpzqVxd1LcaCmPS2iy06h/InqGLOA783QkZrT2OdRDL98Xd9dsyc8lmQ21aMpbTRrZRWbU2PHLOrRY7ARPzbSHXCz7VBOgMDsod8hFvSLOeyFAvdBTQQiJguuIWIqmBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--dylanbhatch.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=gGydB3jz; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--dylanbhatch.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-c76acbe2829so6483092a12.3
        for <live-patching@vger.kernel.org>; Mon, 06 Apr 2026 11:50:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1775501431; x=1776106231; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Yhzt+2m7KvQldPypN2XKP0c6VTxJwPXKSi6TvYWyEKw=;
        b=gGydB3jzpUoYtWr8tT2HdODRmpoeN7NeVKkhYXeSAQfIurDsglLkfPzfNYwUWkiNjP
         lRQPWq39vd3nJ+w+Np6AwyQ7NJNxnDbLSVYqk02viFZLK8a0cUdUZombqiflS2oWQJeI
         v8+32CZb9vXvsqZZpHZ7VvakPyArqHEg8gEb9i3Fp7tFYC5DB1fyqjkR3LHrwF+M+/hc
         wqfFjsd4ukLLDjHiuLL3weP1E6g7n7ndlg1lDP5I82oc10/BSupkvk51YYeUhjfz32Nv
         iQ8ossIb22rlFDjqaGG0JS4DNodEc3YvpoucMtiXr3uYEdLDkFHGVHiQ3MENdNzBq+El
         fm7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775501431; x=1776106231;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Yhzt+2m7KvQldPypN2XKP0c6VTxJwPXKSi6TvYWyEKw=;
        b=XVHCls+CvSLcPRfI8BSlFkGXJJuwAk0ZNKu44CCckseKEerObymOboZhD8n0+eAmlF
         /TaZqGwq2ykKTTwQ7Dsc+LD/aKE6rWSJtCTjt8L9ofatBbAxWUHCtW0/tXZbD6No5aAM
         MjgiMAE+6as+pfg5MmoivyVyiriov8T7mf0wpfVK9b8QVRR1qXXGKf8kAjoufQU6BYwI
         5O5/FXHRRxj2JxzFQOVYVWVtnrQYVbqK8sghwQRNyOINmRWgr3PssILa7frdf+uEWh8f
         i0vbVbwImAG0bJWxPFH7rp61a4srsQvx8xAjBpkmtge4Tm9XMoeoajMPPhUF2uUGkFB5
         rU7g==
X-Forwarded-Encrypted: i=1; AJvYcCVeMAJnKilENuUhRcVavuPAezWxDVFlaf0r0z3E+cr4snYQ10CFp2+R/xSXZ+TfOTNLo8IUL7nl7JQM//sG@vger.kernel.org
X-Gm-Message-State: AOJu0Yw3XPXqyRwgOKZzcFp71AwN0URztFmNY76Nxi8K6JELjM1Xh+Eh
	HUe+1jzQOdJLI9mqp5RocHTxBijIU3BiXpUMntYSUhHnaIev8EAhSRbmhHZvaaIwcAfIfKDGiIw
	yStp2Y2k47uuz5Ftof2ACnSBdXw==
X-Received: from pfmu23.prod.google.com ([2002:aa7:8397:0:b0:829:7ce4:7fcc])
 (user=dylanbhatch job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:ab84:b0:82a:8865:6fe6 with SMTP id d2e1a72fcca58-82d0db6ab99mr12608374b3a.28.1775501430507;
 Mon, 06 Apr 2026 11:50:30 -0700 (PDT)
Date: Mon,  6 Apr 2026 18:49:58 +0000
In-Reply-To: <20260406185000.1378082-1-dylanbhatch@google.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260406185000.1378082-1-dylanbhatch@google.com>
X-Mailer: git-send-email 2.53.0.1213.gd9a14994de-goog
Message-ID: <20260406185000.1378082-7-dylanbhatch@google.com>
Subject: [PATCH v3 6/8] arm64/module, sframe: Add sframe support for modules.
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-2304-lists,live-patching=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	TAGGED_RCPT(0.00)[live-patching];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 194E03A660D
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Add sframe table to mod_arch_specific and support sframe PC lookups when
an .sframe section can be found on incoming modules.

Signed-off-by: Dylan Hatch <dylanbhatch@google.com>
Signed-off-by: Weinan Liu <wnliu@google.com>
---
 arch/arm64/include/asm/module.h |  6 +++++
 arch/arm64/kernel/module.c      |  8 +++++++
 include/linux/sframe.h          |  2 ++
 kernel/unwind/sframe.c          | 39 +++++++++++++++++++++++++++++++--
 4 files changed, 53 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/module.h b/arch/arm64/include/asm/module.h
index fb9b88eebeb1..59fb6fba88d0 100644
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
 
+#ifdef CONFIG_SFRAME_UNWINDER
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
index 593b60715cd6..06fdda1dd116 100644
--- a/include/linux/sframe.h
+++ b/include/linux/sframe.h
@@ -121,6 +121,8 @@ extern int sframe_find_kernel(unsigned long ip, struct unwind_frame *frame);
 #else
 
 static inline void __init init_sframe_table(void) {}
+static inline void sframe_module_init(struct module *mod, void *sframe, size_t sframe_size,
+				      void *text, size_t text_size) {}
 
 #endif /* CONFIG_SFRAME_UNWINDER */
 
diff --git a/kernel/unwind/sframe.c b/kernel/unwind/sframe.c
index 4dd3612f9e7a..180f64040846 100644
--- a/kernel/unwind/sframe.c
+++ b/kernel/unwind/sframe.c
@@ -982,10 +982,27 @@ void sframe_free_mm(struct mm_struct *mm)
 
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
@@ -1002,4 +1019,22 @@ void __init init_sframe_table(void)
 	sframe_init = true;
 }
 
+void sframe_module_init(struct module *mod, void *sframe, size_t sframe_size,
+			void *text, size_t text_size)
+{
+	struct sframe_section sec;
+
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
 #endif /* CONFIG_SFRAME_UNWINDER */
-- 
2.53.0.1213.gd9a14994de-goog


