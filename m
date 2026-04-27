Return-Path: <live-patching+bounces-2563-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id qCLGAP6r72lIDwEAu9opvQ
	(envelope-from <live-patching+bounces-2563-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Mon, 27 Apr 2026 20:33:34 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 5E7AA478A3F
	for <lists+live-patching@lfdr.de>; Mon, 27 Apr 2026 20:33:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 04106305B58A
	for <lists+live-patching@lfdr.de>; Mon, 27 Apr 2026 18:31:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A500C3ECBC9;
	Mon, 27 Apr 2026 18:31:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="cSwCjEYi"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1579A3EC2EE
	for <live-patching@vger.kernel.org>; Mon, 27 Apr 2026 18:31:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777314672; cv=none; b=fAV6gLsKUovUXKBgIQjv0OzQ3vwpbem/rUbA7S/O33wnKrgWjZ5ELZIxAuU8r2t+Kmx/T5l+Eu7oZ5RjtR2lU4Z4IUoE967dFQJmGF4naH+kHm4yuDBK+U/FjrcmO8s2jCkPxEFsgiWbEqiRBIar1UXmZNx1nbbmB4c0zmEervc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777314672; c=relaxed/simple;
	bh=bsQGxHVEbWFMcU98H+Usr8BrpVvRynWHs4uJrO7ovMk=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=nu79vKgmM8FilY1P2V1wtytPQyQZTxqxvjlQhhvkgoB2jHF27qPQHYhAT4afpLQ9Pi3Y5R7AsfFOj40TMjpIV3WU7eO1vZLkMYrVMbNaMM5fIczORXM9ssTmqyNePBFQph8/dyR2F4cC9LZ4KMajENBgkrpMfNlUHlBwHBPW+l4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=cSwCjEYi; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4891d7164ddso52706385e9.3
        for <live-patching@vger.kernel.org>; Mon, 27 Apr 2026 11:31:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1777314669; x=1777919469; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0N/qPZtLyDR9JYuc7La36zdYueKjOOpudQKv7E6xcTI=;
        b=cSwCjEYingP0i4Rnx0WwAFJJQAy0tbPLsyTJaG2V7DYB3Uk/1XDXLDPe+e6APMU0GP
         3I/SummWkvXARNdaAafJh8qw++6Bt0CFIY61LT6+CdHybxiGitVEvVKS/hCzXN/90LLo
         nrPB4TfKaK9v9E6w48mvkQhhd57NvTS0gKzZR6CY9MXz43gVLay5V0jZOqVxAWIE+Jdn
         KNy3gs2BJdCEC0M1BP8bBYBzU+Mf9F4bs2BKsmtfOzWUL4LWzRiwDEVm4ELxtxe8SoSm
         bb97WIq8xzA4L919ajW50VDJdZUNYn6UYvBEqh5ii7PXLZOJKJrHIZAMTVWq8QjnTTL+
         ebcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777314669; x=1777919469;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=0N/qPZtLyDR9JYuc7La36zdYueKjOOpudQKv7E6xcTI=;
        b=RIw5oQulpCV0SnQIrH9uY/FlVs4xb+K8xSTOU/12xidD3mbLkEojso7Wc12pKYURW1
         Ql6RFBVcq8aDSQshzkC40BuZL0aHDH66nwj972qydCAsn6ZWO3VB7lHbYshAra/pkASH
         IyVTOZY/kXVVG9yT4/rQeE+Q/JYqzMAGXnXU+szYNOiliLREuvXNhonMYsDwFmsaT3f6
         Z24i2JU22PX0wSxzPMrMc1HGyuLJQbM2fldvOmsorRvjjyZ3T8HvGv/hudFRCoG9a8Ut
         gd9Va6TgK85XO4Z3IWATy5SvBk5KIorYaOuigESe2QYIGFCiOyBgXugWDOCXNW5oR80j
         RCTA==
X-Gm-Message-State: AOJu0YzKe+xipo2YZfnGyjCdrxzeW2TwWqwOTsOkADdO3lKBWxh+3sxx
	TDwT9bq7fSj3zBKvO3LJgj27LizL8ULY7s3jZQXvoWsN2K5w6Cwj355ykUXAY2s1YbEEh2bOz8O
	HIk7RNDI=
X-Gm-Gg: AeBDiesWo/+HmhiVFPpJd++hv6DnCwek6r1dzWOpt3mCiBT67Vd5a3iy5HYF5ibUGv4
	5665v/ufsdTbwrVeZh7wxT/8a/NIo7jhIpiYs20gHVyzHjtUNsHYckOSU3vCQV+BIy/bHkgPzH4
	lej4V5ercb8urvGkGczi56tOrBeat8Vnwk7ZC816iTBYC1X6eUdeP29TcGzbuoh67RMcFPg9k1I
	2wDlkLnlEbkjFIYC5vh2ytzoePsyUx8A+dtumRP6nvqufkFlQCUnPuKpKAfbt8QRSIquXxAaEXh
	BIdcisLlbWlXZWOPmz9OwXOh88CxCJKNcxaI3ebKaV1MqIsaUNAenG3/9pJVRNeCv1UOs4EqmsX
	E3/mb0V+OKDa1IkMU3obhfZIaClgdXOuS4cqHa4qi9EfdmNXF+TpcKyMxjihzLIq1Wp5axf1rcE
	8FLk/bz7rXTM97wrpKUxF2lB3hQz5Wwp36ow==
X-Received: by 2002:a05:600c:a41:b0:489:1ca2:eafd with SMTP id 5b1f17b1804b1-48a76f5817amr7653805e9.11.1777314668841;
        Mon, 27 Apr 2026 11:31:08 -0700 (PDT)
Received: from [127.0.0.1] ([2804:1bc4:224:7800:585c:db3a:fcb:e21f])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48a7749cabdsm1182065e9.9.2026.04.27.11.31.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Apr 2026 11:31:08 -0700 (PDT)
From: Marcos Paulo de Souza <mpdesouza@suse.com>
Date: Mon, 27 Apr 2026 15:30:57 -0300
Subject: [PATCH v3 1/6] selftests: livepatch: Check for
 ARCH_HAS_SYSCALL_WRAPPER config
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260427-lp-tests-old-fixes-v3-1-ccf3c90f744c@suse.com>
References: <20260427-lp-tests-old-fixes-v3-0-ccf3c90f744c@suse.com>
In-Reply-To: <20260427-lp-tests-old-fixes-v3-0-ccf3c90f744c@suse.com>
To: Josh Poimboeuf <jpoimboe@kernel.org>, Jiri Kosina <jikos@kernel.org>, 
 Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>, 
 Joe Lawrence <joe.lawrence@redhat.com>, Shuah Khan <shuah@kernel.org>
Cc: live-patching@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Marcos Paulo de Souza <mpdesouza@suse.com>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1777314662; l=1999;
 i=mpdesouza@suse.com; s=20231031; h=from:subject:message-id;
 bh=bsQGxHVEbWFMcU98H+Usr8BrpVvRynWHs4uJrO7ovMk=;
 b=JL5R1tkb4izoTxJFla00P5/7UyXAOGl7QH6mG8IkAUvOFzCVHGM8dCb1cEguqI3G+hg+rBqeK
 yzogw4SsDbXDEUhFdN3HZ/bGRPjJR6HiUGLuTxgownFKczX1zmzUjVx
X-Developer-Key: i=mpdesouza@suse.com; a=ed25519;
 pk=/Ni/TsKkr69EOmdZXkp1Q/BlzDonbOBRsfPa18ySIwU=
X-Rspamd-Queue-Id: 5E7AA478A3F
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[suse.com,quarantine];
	R_DKIM_ALLOW(-0.20)[suse.com:s=google];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DKIM_TRACE(0.00)[suse.com:+];
	TAGGED_FROM(0.00)[bounces-2563-lists,live-patching=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_SEVEN(0.00)[10];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,suse.com:email,suse.com:dkim,suse.com:mid]

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


