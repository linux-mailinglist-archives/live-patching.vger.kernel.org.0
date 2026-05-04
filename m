Return-Path: <live-patching+bounces-2698-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id wCaTKxfn+Gmt2wIAu9opvQ
	(envelope-from <live-patching+bounces-2698-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Mon, 04 May 2026 20:36:07 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F73A4C29E5
	for <lists+live-patching@lfdr.de>; Mon, 04 May 2026 20:36:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id A584B3020EB4
	for <lists+live-patching@lfdr.de>; Mon,  4 May 2026 18:35:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6BCA13E6383;
	Mon,  4 May 2026 18:35:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="KiBYygIP"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E98C3E51D6
	for <live-patching@vger.kernel.org>; Mon,  4 May 2026 18:35:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777919709; cv=none; b=pDXURuwjxBkV8m94vAVrA4N1mOLtBnsJFx+ONczdziRH4f8+aiWp8yrGxgsJ3JWogv8V7UVoaXWpfalnqdytsRya852CeEYhC0M4brQvXP7RvD4Y+ACnFpWHy9E5rgmNFojXeQreCWVSlDK0nAnvl5RT3NhEHuthV7v/nNjgYks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777919709; c=relaxed/simple;
	bh=bsQGxHVEbWFMcU98H+Usr8BrpVvRynWHs4uJrO7ovMk=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=FXoXFZnrGkgYEQzXvB93ejrL249gNXl52SjbmQSfWrCrWDMJHP7RXNNSZKh2fTwGKk+bFanHW9ixuGq3VReRLpg5BIFt7uSifq6jv2ljn/0edWcaL5P3q1ABgJnnkWUCSjK6bD41bgxDJZh+OTKFioVsm6vkIe7biJMoFge0/70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=KiBYygIP; arc=none smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-449e96a8a80so2538569f8f.3
        for <live-patching@vger.kernel.org>; Mon, 04 May 2026 11:35:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1777919706; x=1778524506; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0N/qPZtLyDR9JYuc7La36zdYueKjOOpudQKv7E6xcTI=;
        b=KiBYygIPPai1vF+9X0SB07esZAWTaQKmjxFHNkYc4QE0+vz8SBRxccSmmqXDEkg0GF
         9VGXzD855YEVK+1JPh8scdB3Lis+eJIuO85aPkix2eLLMarw8ViSIbbJkeIdiobcvjxi
         9JxFxp6Q0mxanW4Vl/iOhAIAD79cGM0dyfzj9tK2+17utWMqAHpqN6Z9rN+1e1xj2nMO
         6WTwhf/JJNrUGkIVzwUYrD/wcRUl1bv+vwJ5qelesjToKFZWCYuJTcaIp6H+MHhd8JCP
         qVvIswOx2HDhmEDAMb7yXpAqfv4BI7VMRBR8HxZZhTsnyHzIol6biH/1XZSrkcRI7mQ5
         Yxvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777919706; x=1778524506;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=0N/qPZtLyDR9JYuc7La36zdYueKjOOpudQKv7E6xcTI=;
        b=G0tFCsb2Fvt4NVbAPuSERSv0Ozy/u4jKDO8K5KPMY3GpFlAiFqa59Lrb6fPVkgrVZO
         WZNoPJkzIHcXJYzC8N8edXovYjr4ub379cJzpA4Xf/rPIrrosVEBoqiNEhNkYHRfM4XF
         d59vLgA/BwYaS/qJjhraR3w62oBWgZSw16pQLOWIR18miC4agbY6y5r4TTOMp2nmpDsi
         VoZQMvAZ2Sm5nAouFVkQuT6NCYhQ8xzZU7dzTRJwH+9bhbw0E9Z7qTr/RrfKakSLHOkg
         h9MT6TqV2B/ffjNXTz8F+nXVBKGbJYh3v53R8p6M4RD4LP9ZFejmRXHWHSznF4v5UTLb
         iIYA==
X-Gm-Message-State: AOJu0YwI6t6/6DA4Wkf0Sq7WMyuf5QvWWrPWBYsR83G0oHx2QUYpgpz1
	oyS0I9EagyC87a3oH/Vm4xx+zsuIqHy+GV/mHbrJdwm9r1+h7kREvTDUjuyGjNnZusU=
X-Gm-Gg: AeBDieu/frzaVBc5d50WSyKQC1an3thxOSQfD7ci6f1FPf8dMYEaRsVHToCeilcWodE
	fCfnXgyQ4eMoU9DG12dMXLibDG89i2/R8g9wXq+QU0SVesGOh40JYattp+rLmURINCfylpWn8LZ
	TgnWhmtiu8SrBo4uegoLSlV933KeaCUqOfyOjG4HJCiImzebDfchE5Ov2ce/695BNt1Wawtp9Zg
	bLs11BwugXGIe+H6rYSGewYT5blUgMjWdH4Q8jrEWBOaIhERGBiA9novAAIOmjv7WYMjGnFnrhC
	KBGlyleJztuZwsGu6/lc01pzRf5I35tLb3KRbhxGTXzFuRX7TW1rEO8S5OGj4UEtyVj4FPKpgRa
	gebXTGw0gHXJpwEV4r1bDGxl4tUH/YXNqateJywKXmd1QuhBdPfqbYwIZzWSBHa3jU7PQw4F5vl
	QkHMnU5DjRZX3EaJdFTaRV6/mLw7UldkJdYw==
X-Received: by 2002:a05:6000:220e:b0:43d:77f4:7145 with SMTP id ffacd0b85a97d-4500476f6e2mr142276f8f.19.1777919705746;
        Mon, 04 May 2026 11:35:05 -0700 (PDT)
Received: from [127.0.0.1] ([2804:1bc4:224:7800:585c:db3a:fcb:e21f])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-44a98b76eddsm26745511f8f.34.2026.05.04.11.35.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 May 2026 11:35:05 -0700 (PDT)
From: Marcos Paulo de Souza <mpdesouza@suse.com>
Date: Mon, 04 May 2026 15:34:42 -0300
Subject: [PATCH v5 1/6] selftests: livepatch: Check for
 ARCH_HAS_SYSCALL_WRAPPER config
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260504-lp-tests-old-fixes-v5-1-0be26d94ab9a@suse.com>
References: <20260504-lp-tests-old-fixes-v5-0-0be26d94ab9a@suse.com>
In-Reply-To: <20260504-lp-tests-old-fixes-v5-0-0be26d94ab9a@suse.com>
To: Josh Poimboeuf <jpoimboe@kernel.org>, Jiri Kosina <jikos@kernel.org>, 
 Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>, 
 Joe Lawrence <joe.lawrence@redhat.com>, Shuah Khan <shuah@kernel.org>
Cc: live-patching@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Marcos Paulo de Souza <mpdesouza@suse.com>, 
 marcos@mpdesouza.com
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1777919697; l=1999;
 i=mpdesouza@suse.com; s=20231031; h=from:subject:message-id;
 bh=bsQGxHVEbWFMcU98H+Usr8BrpVvRynWHs4uJrO7ovMk=;
 b=MxLHXzKClp0LDuPuXWIAf6yyKxcAG5hsA/Gib7N3J9fRNg90pqPKEo1UQYlZ1lFzPt/35dy61
 O1/NpYWScH1AxUDieaBSRacr5/ujVHk/CBbZ0ESktAHxMRbzEXutBZ6
X-Developer-Key: i=mpdesouza@suse.com; a=ed25519;
 pk=/Ni/TsKkr69EOmdZXkp1Q/BlzDonbOBRsfPa18ySIwU=
X-Rspamd-Queue-Id: 2F73A4C29E5
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[suse.com,quarantine];
	R_DKIM_ALLOW(-0.20)[suse.com:s=google];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[suse.com:+];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2698-lists,live-patching=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[mpdesouza@suse.com,live-patching@vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_FIVE(0.00)[5];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_SEVEN(0.00)[11];
	TO_DN_SOME(0.00)[]

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


