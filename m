Return-Path: <live-patching+bounces-2702-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id iP4pBHHn+Gmt2wIAu9opvQ
	(envelope-from <live-patching+bounces-2702-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Mon, 04 May 2026 20:37:37 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 738774C2A59
	for <lists+live-patching@lfdr.de>; Mon, 04 May 2026 20:37:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 04BEB3080F35
	for <lists+live-patching@lfdr.de>; Mon,  4 May 2026 18:35:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C00F93E5EFD;
	Mon,  4 May 2026 18:35:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="eCfIS8FU"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 079BD3C2782
	for <live-patching@vger.kernel.org>; Mon,  4 May 2026 18:35:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777919727; cv=none; b=bIE3cRTBm7XOf7VDpBBTxnxe0z2Z7r485U/KfwjYvetXjdKfolVW2U8ZI56XCFwz9+syOJjeMOQaXppwfVx3wz77iikDl88TKiH3HQbw/ASI9P4BZ5QQrNfFnWnAZuLG6ZXRP8+NFVr/V1sLUcJu5t1XGB94CRyl8IDEjgaWIbY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777919727; c=relaxed/simple;
	bh=Jhwc3bSB1QoPJ4EdDuot2f3rSW+MDB/+MyoU7VmCXKI=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=AZaz8yJVLfhQg2gEWjSArn/LNqCbbp1I0KaVcBpXYPwXrN2Mu69kl08Jt6Upr/y0uXim/Dy0MjqW/xU3UPkAFv7Twao/IcsMvQ7MYFyc9Sgv8uzyVXyAW48jqKs1rL/E0ZuapN3xTt5GjxhgDZdnjrRzrrM+R06m6DyK4tK2wVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=eCfIS8FU; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-488b150559bso30067855e9.1
        for <live-patching@vger.kernel.org>; Mon, 04 May 2026 11:35:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1777919724; x=1778524524; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bXBN/muC0e6jo/6Omvf0NxeC2cje49LJFllH8PfvrZQ=;
        b=eCfIS8FUgRwd2IqDTFCvDT72YQcrySW8WqumS3BZqMPAaOkLLibegx9z4umXnpZSk2
         PjpfNnmb3Tpk51fmjAwI9UZC15A1MgFccoR2tbV5vMkEr8DJ4wjWiEOvs0VEKA2stmnm
         tDDgxZ6ZCMTEUEqW1+WhnEkZSaKw8fwa1+inuE+gG+xg14azIAHxwjGlic8oj9aZ0Ap6
         SmydRXahvUTIADT3B6Zva9rHPQ02qHCpQBuYQFqCJdfMqIMlv7kxjY91pO3UNJLNUwE7
         pyAFfbpRlUp9fvy2AOf87JXmQxQtVcXyACiO/5XVCzik3lkE7+cDDQk0ak1ntFQM3d2B
         JFNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777919724; x=1778524524;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=bXBN/muC0e6jo/6Omvf0NxeC2cje49LJFllH8PfvrZQ=;
        b=GEoqD1PuyBVzk+fhbZUsOq2nP9LX6/yVTZtxA21Y2rgHW726cP66SHlgUOh8lZ99bp
         QF30bK3C+5yxw/sPBYLM8yceB8pENkCOykrnYu4qupghNqetYONuuHf/t7qJsdfv1IVd
         Sj7tKk+ygw626Oy3gZ4sOm5hLPSgvEyOX7JlmjX4Oe5orZHCYU7MbWzaTF8RInwNcDeE
         2n7z8Vn2YJ2fZzen84cRSVHCL7pDOOlU1EXIN4BczNtsmp31hLueSNwDg7IS76pfBjeB
         K3R3oGP/cQzgzoe/KgB/TLFDNlnYt7L7FomIE1KmACjoC/LVq9Og13aIt4NpPiGP37At
         hjvQ==
X-Gm-Message-State: AOJu0Ywdk6kmXB0PHw4WZfe+9FnhjelfJX57F2158GSrnYoDubSY0ZA1
	74lcIlxXLlUWUCz2WOuNLyS5id1ESJ9Ka0nTjG8GoapY0BFIw2yA4aa1GFsJs/ZnurY=
X-Gm-Gg: AeBDieuyEDcuqTsfU6KVEVXKH3B89qTIcv+XGjVHPZXBv+qdYdawFT59MiGLtrUu/Ih
	3l2YWu29aPkw9bbCX64wnwwJY9/ZOq0P+r5aJ7J2Ef1v7yO086HoIH1r2LN1/UqpFyTkEHoRwMC
	MLzxQEeP50kb3FgYDWGBmZsY+MwRem4XAhj7+TSR7N/l9PD/T9uSFq50RswjKZpiGV+GH+bvmmo
	iUL7Wv2ZN0vweD+77NQbTb2B8aNlCPRfBnP8AZ+wIpMJzKjU5YpNa2cmQXiYnWsK014xNa+tWmq
	70InNokM3OLx2SpejE4fVw9Vrw9B1NjEzN9XvGVd5qUurY1FwxrMQAcit2PQJQZXntntQej9dak
	EiCEntXFOx4t6HUboGzjsst4SJR3RG8SJ/KczUTLBs5Ow8bbjml4XIS6Ok/YFXwqc0qfENFqwBC
	u7piMO8+7lJ8X3+lNl3YtUgKUbMTqMzGfnfJe1kd6SzceL
X-Received: by 2002:a05:6000:178d:b0:43d:773d:7908 with SMTP id ffacd0b85a97d-44bb65df88fmr17335166f8f.32.1777919724327;
        Mon, 04 May 2026 11:35:24 -0700 (PDT)
Received: from [127.0.0.1] ([2804:1bc4:224:7800:585c:db3a:fcb:e21f])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-44a98b76eddsm26745511f8f.34.2026.05.04.11.35.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 May 2026 11:35:22 -0700 (PDT)
From: Marcos Paulo de Souza <mpdesouza@suse.com>
Date: Mon, 04 May 2026 15:34:46 -0300
Subject: [PATCH v5 5/6] selftests: livepatch: Check if replace sysfs
 attribute exists
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260504-lp-tests-old-fixes-v5-5-0be26d94ab9a@suse.com>
References: <20260504-lp-tests-old-fixes-v5-0-0be26d94ab9a@suse.com>
In-Reply-To: <20260504-lp-tests-old-fixes-v5-0-0be26d94ab9a@suse.com>
To: Josh Poimboeuf <jpoimboe@kernel.org>, Jiri Kosina <jikos@kernel.org>, 
 Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>, 
 Joe Lawrence <joe.lawrence@redhat.com>, Shuah Khan <shuah@kernel.org>
Cc: live-patching@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Marcos Paulo de Souza <mpdesouza@suse.com>, 
 marcos@mpdesouza.com
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1777919697; l=6010;
 i=mpdesouza@suse.com; s=20231031; h=from:subject:message-id;
 bh=Jhwc3bSB1QoPJ4EdDuot2f3rSW+MDB/+MyoU7VmCXKI=;
 b=aJO0E/QNJQg57ozcSRwqAd5sHqfwmC10e+h+fy1Gz8CMSKzhVSXA9XSx2MnxUpbz7+dmCfTJy
 rEXnENtkcT7Bm8O+MvuSUoSxn2YfFpH/9qoFlk1Po7t5SQfY0kLq4Qt
X-Developer-Key: i=mpdesouza@suse.com; a=ed25519;
 pk=/Ni/TsKkr69EOmdZXkp1Q/BlzDonbOBRsfPa18ySIwU=
X-Rspamd-Queue-Id: 738774C2A59
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
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[suse.com:+];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2702-lists,live-patching=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
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

The commit adb68ed26a3e ("livepatch: Add "replace" sysfs attribute"),
merged in v6.11, introduced a new sysfs attribute.

In order to run the selftests on older kernels, check if given kernel
has support for the attribute. If the attribute is not supported, skip
the checks.

While at it, create a local variable to hold the module name to be
tested, instead of overwriting MOD_LIVEPATCH.

Signed-off-by: Marcos Paulo de Souza <mpdesouza@suse.com>
---
 tools/testing/selftests/livepatch/test-sysfs.sh | 101 +++++++++++++-----------
 1 file changed, 54 insertions(+), 47 deletions(-)

diff --git a/tools/testing/selftests/livepatch/test-sysfs.sh b/tools/testing/selftests/livepatch/test-sysfs.sh
index 7fa2223f9533..fed656021271 100755
--- a/tools/testing/selftests/livepatch/test-sysfs.sh
+++ b/tools/testing/selftests/livepatch/test-sysfs.sh
@@ -9,6 +9,7 @@ MOD_LIVEPATCH2=test_klp_callbacks_demo
 MOD_LIVEPATCH3=test_klp_syscall
 
 HAS_PATCH_ATTR=0
+HAS_REPLACE_ATTR=0
 
 setup_config
 
@@ -22,7 +23,6 @@ check_sysfs_rights "$MOD_LIVEPATCH" "" "drwxr-xr-x"
 check_sysfs_rights "$MOD_LIVEPATCH" "enabled" "-rw-r--r--"
 check_sysfs_value  "$MOD_LIVEPATCH" "enabled" "1"
 check_sysfs_rights "$MOD_LIVEPATCH" "force" "--w-------"
-check_sysfs_rights "$MOD_LIVEPATCH" "replace" "-r--r--r--"
 check_sysfs_rights "$MOD_LIVEPATCH" "stack_order" "-r--r--r--"
 check_sysfs_value  "$MOD_LIVEPATCH" "stack_order" "1"
 check_sysfs_rights "$MOD_LIVEPATCH" "transition" "-r--r--r--"
@@ -34,6 +34,11 @@ if does_sysfs_exist "$MOD_LIVEPATCH/vmlinux" "patched"; then
 	HAS_PATCH_ATTR=1
 fi
 
+if does_sysfs_exist "$MOD_LIVEPATCH" "replace"; then
+	check_sysfs_rights "$MOD_LIVEPATCH" "replace" "-r--r--r--"
+	HAS_REPLACE_ATTR=1
+fi
+
 disable_lp $MOD_LIVEPATCH
 
 unload_lp $MOD_LIVEPATCH
@@ -95,52 +100,54 @@ livepatch: '$MOD_LIVEPATCH2': unpatching complete
 % rmmod $MOD_LIVEPATCH2"
 fi
 
-start_test "sysfs test replace enabled"
-
-MOD_LIVEPATCH=test_klp_atomic_replace
-load_lp $MOD_LIVEPATCH replace=1
-
-check_sysfs_rights "$MOD_LIVEPATCH" "replace" "-r--r--r--"
-check_sysfs_value  "$MOD_LIVEPATCH" "replace" "1"
-
-disable_lp $MOD_LIVEPATCH
-unload_lp $MOD_LIVEPATCH
-
-check_result "% insmod test_modules/$MOD_LIVEPATCH.ko replace=1
-livepatch: enabling patch '$MOD_LIVEPATCH'
-livepatch: '$MOD_LIVEPATCH': initializing patching transition
-livepatch: '$MOD_LIVEPATCH': starting patching transition
-livepatch: '$MOD_LIVEPATCH': completing patching transition
-livepatch: '$MOD_LIVEPATCH': patching complete
-% echo 0 > $SYSFS_KLP_DIR/$MOD_LIVEPATCH/enabled
-livepatch: '$MOD_LIVEPATCH': initializing unpatching transition
-livepatch: '$MOD_LIVEPATCH': starting unpatching transition
-livepatch: '$MOD_LIVEPATCH': completing unpatching transition
-livepatch: '$MOD_LIVEPATCH': unpatching complete
-% rmmod $MOD_LIVEPATCH"
-
-start_test "sysfs test replace disabled"
-
-load_lp $MOD_LIVEPATCH replace=0
-
-check_sysfs_rights "$MOD_LIVEPATCH" "replace" "-r--r--r--"
-check_sysfs_value  "$MOD_LIVEPATCH" "replace" "0"
-
-disable_lp $MOD_LIVEPATCH
-unload_lp $MOD_LIVEPATCH
-
-check_result "% insmod test_modules/$MOD_LIVEPATCH.ko replace=0
-livepatch: enabling patch '$MOD_LIVEPATCH'
-livepatch: '$MOD_LIVEPATCH': initializing patching transition
-livepatch: '$MOD_LIVEPATCH': starting patching transition
-livepatch: '$MOD_LIVEPATCH': completing patching transition
-livepatch: '$MOD_LIVEPATCH': patching complete
-% echo 0 > $SYSFS_KLP_DIR/$MOD_LIVEPATCH/enabled
-livepatch: '$MOD_LIVEPATCH': initializing unpatching transition
-livepatch: '$MOD_LIVEPATCH': starting unpatching transition
-livepatch: '$MOD_LIVEPATCH': completing unpatching transition
-livepatch: '$MOD_LIVEPATCH': unpatching complete
-% rmmod $MOD_LIVEPATCH"
+if [[ "$HAS_REPLACE_ATTR" == "1" ]]; then
+	start_test "sysfs test replace enabled"
+
+	MOD_ATOMIC_REPLACE=test_klp_atomic_replace
+	load_lp $MOD_ATOMIC_REPLACE replace=1
+
+	check_sysfs_rights "$MOD_ATOMIC_REPLACE" "replace" "-r--r--r--"
+	check_sysfs_value  "$MOD_ATOMIC_REPLACE" "replace" "1"
+
+	disable_lp $MOD_ATOMIC_REPLACE
+	unload_lp $MOD_ATOMIC_REPLACE
+
+	check_result "% insmod test_modules/$MOD_ATOMIC_REPLACE.ko replace=1
+livepatch: enabling patch '$MOD_ATOMIC_REPLACE'
+livepatch: '$MOD_ATOMIC_REPLACE': initializing patching transition
+livepatch: '$MOD_ATOMIC_REPLACE': starting patching transition
+livepatch: '$MOD_ATOMIC_REPLACE': completing patching transition
+livepatch: '$MOD_ATOMIC_REPLACE': patching complete
+% echo 0 > $SYSFS_KLP_DIR/$MOD_ATOMIC_REPLACE/enabled
+livepatch: '$MOD_ATOMIC_REPLACE': initializing unpatching transition
+livepatch: '$MOD_ATOMIC_REPLACE': starting unpatching transition
+livepatch: '$MOD_ATOMIC_REPLACE': completing unpatching transition
+livepatch: '$MOD_ATOMIC_REPLACE': unpatching complete
+% rmmod $MOD_ATOMIC_REPLACE"
+
+	start_test "sysfs test replace disabled"
+
+	load_lp $MOD_ATOMIC_REPLACE replace=0
+
+	check_sysfs_rights "$MOD_ATOMIC_REPLACE" "replace" "-r--r--r--"
+	check_sysfs_value  "$MOD_ATOMIC_REPLACE" "replace" "0"
+
+	disable_lp $MOD_ATOMIC_REPLACE
+	unload_lp $MOD_ATOMIC_REPLACE
+
+	check_result "% insmod test_modules/$MOD_ATOMIC_REPLACE.ko replace=0
+livepatch: enabling patch '$MOD_ATOMIC_REPLACE'
+livepatch: '$MOD_ATOMIC_REPLACE': initializing patching transition
+livepatch: '$MOD_ATOMIC_REPLACE': starting patching transition
+livepatch: '$MOD_ATOMIC_REPLACE': completing patching transition
+livepatch: '$MOD_ATOMIC_REPLACE': patching complete
+% echo 0 > $SYSFS_KLP_DIR/$MOD_ATOMIC_REPLACE/enabled
+livepatch: '$MOD_ATOMIC_REPLACE': initializing unpatching transition
+livepatch: '$MOD_ATOMIC_REPLACE': starting unpatching transition
+livepatch: '$MOD_ATOMIC_REPLACE': completing unpatching transition
+livepatch: '$MOD_ATOMIC_REPLACE': unpatching complete
+% rmmod $MOD_ATOMIC_REPLACE"
+fi
 
 start_test "sysfs test stack_order value"
 

-- 
2.54.0


