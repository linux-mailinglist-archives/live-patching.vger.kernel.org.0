Return-Path: <live-patching+bounces-2601-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 6FazDVkZ8mljnwEAu9opvQ
	(envelope-from <live-patching+bounces-2601-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Wed, 29 Apr 2026 16:44:41 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 55758496109
	for <lists+live-patching@lfdr.de>; Wed, 29 Apr 2026 16:44:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 4D7733051C57
	for <lists+live-patching@lfdr.de>; Wed, 29 Apr 2026 14:35:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 083E634D926;
	Wed, 29 Apr 2026 14:35:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="ZEkVqEDX"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7606037419B
	for <live-patching@vger.kernel.org>; Wed, 29 Apr 2026 14:35:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777473334; cv=none; b=QUg3nouF05bG/JEHYAdWDr5Rgu3jakKtCN6XesGI2XPJd2Lkj4GONzf6N0j3gtXxld+EA6HKc3Fcz4RJPswTCMCHyNJ7WZ29oFOptKvOnxuU5IJaWJ7QqHCJtqxuA0VofVzde6nkM191YyG/QUsV2lY9ziyjVbz8eApR8QHTTM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777473334; c=relaxed/simple;
	bh=bsQGxHVEbWFMcU98H+Usr8BrpVvRynWHs4uJrO7ovMk=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=E1Blbf9HhW7RScgjnV/mV58HsPC7OMgc1+gD79ebHHkjqQNDfzjQOz1MIppzTUuGF1fsnS7SK5MQjtH0RTBzfLZTITuaMB1D0gRF7LCvAerx7fDrxoYbYnrCZfeaQp/waFnbiD0IzI8e36ely8C9diSA3PMoIVSHeLlQQPq1LZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=ZEkVqEDX; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4852a9c6309so114753815e9.0
        for <live-patching@vger.kernel.org>; Wed, 29 Apr 2026 07:35:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1777473332; x=1778078132; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0N/qPZtLyDR9JYuc7La36zdYueKjOOpudQKv7E6xcTI=;
        b=ZEkVqEDXS5a8xENdLT/u/17+JJpbvEhFqqPvnB0gmhv2ZVVHOZk9QlT0yVekSIV8o0
         uzsPMW4UgMdqT7N5n32r2wfljd4WRaV9oYaHBelLmqHhtRpryXtbGGoHNcF+Y1BlF6R8
         As0O33MTVFcWRAEX8kNZBp4GKFu+g54XgVPEgRCGNCcMGxjI/XOP8BkTGfEGLOufplrB
         SGnjrNGx54IqKWWBgrX7fmgY94cfXTYaguOKMh8R9QpP3dTLeWqVcWE6TOjHBQ8y/BJl
         IUk8IkBakosb7ELVpKkmX8g1/gXC/C106FxhHEQKA8F8RdTR6U1aXLfYCAes2Zved8H2
         g/LA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777473332; x=1778078132;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=0N/qPZtLyDR9JYuc7La36zdYueKjOOpudQKv7E6xcTI=;
        b=nY0d9/5rqHaCT5orNzyapqeIG5hQVzhI9BnuDuVNoQOyhSiJXdztFXhjcWsmxSTAM9
         LO81usIZoWHp1/hMgyCjtacoTjce8ZGQxdLEr0k/eu1QJnOcklcm6KDNtAHXdiQ8oFH4
         b2Y9i8grw3KyIAO9n9k8hg/uzjTNLYyZ/gnwFeg1n6EpbJABk7ts5X+7qy2NPwn6bp5t
         HilNj4fWaNhnIbd4TsHhHM3T4EQC3c8bwCwGiJgOVQO8NQd6l6ke7Np5XTAyaSHNqy9/
         gMOl4Ywx6HAc/jUyQG4VFe6sIGZsz7szHiepoLhgUk2fU9HKF+v6EgWwPgID6MTOvYXa
         +duw==
X-Gm-Message-State: AOJu0Yxh3bTVfNCGopsCe8xmfM/3/47/uJDWXGPjFU4YlrpNIUhoyhT1
	hx+sDfpeHbU0rnUqNfz1r1Pp8rOhffdPjSro9rSU6Qb1nUerspgZty9N7ZrUI+oaHa/XYFl8OxJ
	v/p0RIr0=
X-Gm-Gg: AeBDiesj2KhYB08BsYBCfJCfy+7TK5/nX/mmJzZ9pCr/uHsF0KzkXTT2JS2m00xkUfE
	y89yLQWYmBejAa2x75CxcIm/ftgz+WpXVPUgdb4TAU+swEy4vu4hDBIlfSvLxckFZmWf9qH+LJo
	7yVIY7qsVoDr8ZKeBMmOS40AbvfA+YuI+mBu2siYe+NkAWZDIX2Lu+PoD6Y+kjgAjrRdZKSsJOV
	HhyUY+GkVM4UbqDITRE5y+Fq1Q5W7FzWwFmN0+y3bUfxX8AZBo1poLXCVcyR761f5c1FcIgOMM5
	TTK3KQLvSSRsCSOTv1e1Bm6J9Rtq52BMXzHIf6g43vg2s7bTdidgzD499GCCxpyg6tDmdySkIGE
	/81uO9n5FZBPT5vU9dY7hPIRQh8G1V5mXOk4ddkISfIIKgsfn9mWlQz790BJLu+V6DeAwK7mFx9
	XAE+S0EvdwG05HV+g+sL100Yx311LbCrIqQDg0QusAQ82G
X-Received: by 2002:a05:600c:4341:b0:48a:53ea:1408 with SMTP id 5b1f17b1804b1-48a77afcf0amr63409555e9.8.1777473331729;
        Wed, 29 Apr 2026 07:35:31 -0700 (PDT)
Received: from [127.0.0.1] ([2804:1bc4:224:7800:585c:db3a:fcb:e21f])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48a7c305371sm19982835e9.18.2026.04.29.07.35.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Apr 2026 07:35:30 -0700 (PDT)
From: Marcos Paulo de Souza <mpdesouza@suse.com>
Date: Wed, 29 Apr 2026 11:35:15 -0300
Subject: [PATCH v4 1/6] selftests: livepatch: Check for
 ARCH_HAS_SYSCALL_WRAPPER config
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260429-lp-tests-old-fixes-v4-1-59b9741989d0@suse.com>
References: <20260429-lp-tests-old-fixes-v4-0-59b9741989d0@suse.com>
In-Reply-To: <20260429-lp-tests-old-fixes-v4-0-59b9741989d0@suse.com>
To: Josh Poimboeuf <jpoimboe@kernel.org>, Jiri Kosina <jikos@kernel.org>, 
 Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>, 
 Joe Lawrence <joe.lawrence@redhat.com>, Shuah Khan <shuah@kernel.org>
Cc: live-patching@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Marcos Paulo de Souza <mpdesouza@suse.com>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1777473323; l=1999;
 i=mpdesouza@suse.com; s=20231031; h=from:subject:message-id;
 bh=bsQGxHVEbWFMcU98H+Usr8BrpVvRynWHs4uJrO7ovMk=;
 b=tvmzg76o/nu6Ldl32Hq08Kp/ieaTRU6Q+seXgfYYcQaFHBNyqt47Rl0yDMlUCxGPdyjY+T6tJ
 oiFKI6R3eiCBdTM2/oaeYPX+5HZRrmRfkyJEhZ4saJrDz4ve6P4wZad
X-Developer-Key: i=mpdesouza@suse.com; a=ed25519;
 pk=/Ni/TsKkr69EOmdZXkp1Q/BlzDonbOBRsfPa18ySIwU=
X-Rspamd-Queue-Id: 55758496109
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[suse.com,quarantine];
	R_DKIM_ALLOW(-0.20)[suse.com:s=google];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DKIM_TRACE(0.00)[suse.com:+];
	TAGGED_FROM(0.00)[bounces-2601-lists,live-patching=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[mpdesouza@suse.com,live-patching@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_SEVEN(0.00)[10];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.com:dkim,suse.com:mid,sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]

Older kernels that lack CONFIG_ARCH_HAS_SYSCALL_WRAPPER config don't
have any prefixes for their syscalls. The same applies to current
powerpc and loongarch, covering all currently supported architectures
that support livepatch.

The other supported architectures have specific prefixes, so error out
when a new architecture adds livepatch support with wrappers but didn't
update the test to include it.

Signed-off-by: Marcos Paulo de Souza <mpdesouza@suse.com>
---
 .../livepatch/test_modules/test_klp_syscall.c      | 27 +++++++++++++++-------
 1 file changed, 19 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/livepatch/test_modules/test_klp_syscall.c b/tools/testing/selftests/livepatch/test_modules/test_klp_syscall.c
index dd802783ea84..0630ffd9d9a1 100644
--- a/tools/testing/selftests/livepatch/test_modules/test_klp_syscall.c
+++ b/tools/testing/selftests/livepatch/test_modules/test_klp_syscall.c
@@ -12,15 +12,26 @@
 #include <linux/slab.h>
 #include <linux/livepatch.h>
 
-#if defined(__x86_64__)
-#define FN_PREFIX __x64_
-#elif defined(__s390x__)
-#define FN_PREFIX __s390x_
-#elif defined(__aarch64__)
-#define FN_PREFIX __arm64_
+/*
+ * Before CONFIG_ARCH_HAS_SYSCALL_WRAPPER was introduced there were no
+ * prefixes for system calls.
+ * powerpc set this config based on configs, so it can be enabled or not.
+ */
+#if defined(CONFIG_ARCH_HAS_SYSCALL_WRAPPER)
+  #if defined(__x86_64__)
+    #define FN_PREFIX __x64_
+  #elif defined(__s390x__)
+    #define FN_PREFIX __s390x_
+  #elif defined(__aarch64__)
+    #define FN_PREFIX __arm64_
+  #elif defined(__powerpc__)
+    #define FN_PREFIX
+  #else
+    #error "Missing syscall wrapper for the given architecture."
+  #endif
 #else
-/* powerpc does not select ARCH_HAS_SYSCALL_WRAPPER */
-#define FN_PREFIX
+  /* Do not set a prefix for architectures that do not enable wrappers. */
+  #define FN_PREFIX
 #endif
 
 /* Protects klp_pids */

-- 
2.54.0


