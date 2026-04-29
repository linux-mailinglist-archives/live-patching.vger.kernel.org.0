Return-Path: <live-patching+bounces-2604-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id yM87GMMZ8mljnwEAu9opvQ
	(envelope-from <live-patching+bounces-2604-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Wed, 29 Apr 2026 16:46:27 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B3654961F7
	for <lists+live-patching@lfdr.de>; Wed, 29 Apr 2026 16:46:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id B7057305BDBE
	for <lists+live-patching@lfdr.de>; Wed, 29 Apr 2026 14:36:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C08F33D6D7;
	Wed, 29 Apr 2026 14:35:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Q3ZiEVGN"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C91D537646C
	for <live-patching@vger.kernel.org>; Wed, 29 Apr 2026 14:35:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777473348; cv=none; b=VEMqCCnJpr7fcoom70PBhGV+pkv0f51k/0HSgUYyBjPCVhP+DyYlp1nEdH5CtYmzvyLZJ2j0l/Lo75Ld9YDSCGWFbefkp/AZ3YnRj83JaUZi72LKxYi4aV9zIa8yXn5gNg/74rT8n9BVnoIjVeodMMrLAqOKQZgszvLk4cQLREE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777473348; c=relaxed/simple;
	bh=cabsWImOrTfadEvXIKkGEu46ZFIbjUR+jCHHWZS1nFI=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=fk2COYWqIO9xMigypEY91Xo8GeT5wNdD0laF8/sMpOkRKRf7Ak1MWV0lc6BLHPtYg44DtvQtl9wBXV/E8gpZR+Bq0xtl2+sY1k5guLO27w2Jb8zatoLdQZPTpVhTYL2e8D2tpLIptaJ31QtjwBNHlJ/XG0Fa3hcKw1bRstKxdRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Q3ZiEVGN; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-48a563e4ef7so92422675e9.0
        for <live-patching@vger.kernel.org>; Wed, 29 Apr 2026 07:35:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1777473345; x=1778078145; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZSv7mvHEKazo1ADkBY1eKHJ65hhcoj1auW86Wb7XPbw=;
        b=Q3ZiEVGN8WRe6zbr9LDKiikfP6zZStNgmRcmPHT2csVQ9TH+iK24tBHY/Ivz+4b/jZ
         RwbRVHdqGQZI4dRwGbpiUSlyWkgJfPASaLThG7nH3qL20l4VJbu3u6YPuftWInhnVzyG
         YE3UN95VbaRug54yMzXHwmCVKi9b4uB4If5venNw4zZcBzLshtQKFyNAB1BDS2P+cwHg
         mQBvJfRGuEK15jd37UzgRp/0zgswD5snSo6VqG3DRX/r8Iq3wN5ZDgtRwyQav+Lt6LVK
         Mb9H/OcdSBNijY2hEsvBWa1xQ84uWlxXlf6F5qtQmA7VaU3zghgZZyWr7ird+TPaEfQD
         vaXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777473345; x=1778078145;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=ZSv7mvHEKazo1ADkBY1eKHJ65hhcoj1auW86Wb7XPbw=;
        b=ST8sQK52T+9l0g+4rBAPF+QmpOrUm5yj7AzvWlCfMfps1/DhqTRpZcDxj16vSODG+8
         jmtkh6LcD5BPVp0mm2tYLiCtSvv+jCZeiAIB+7M3pUbYgNL985UXU90VYFVIWp5LwAqc
         wGlyV5cpretVZm02+wd/TdtjYOcWlCSut/onYYdFZG5GnsG3r+Z2Fy0XOMFRpOuaMTd3
         qMwdbtUBYs/zv7vutN5NoLpAbTRUCChdJe/zurnnmvA7aalA36pS9KWUgV9Kv5rPazIL
         pZHoYagsHqjPieTW3rjzXvzgi5ei42QajBnkXTUDQ7wDSiIKK3nCLdBiV3QfJhIcM+4k
         0Fjg==
X-Gm-Message-State: AOJu0YwjSmFF6kbz4Pfzt/Uni159rnVQwqDuyfDERmuBAVhwmnpet7jB
	1AV2YpDlAqMJJjes0Wa/t113zJKV7fQFicxiaok+1Gz27uZTo+kV4AhS0KMPaJsFjmg=
X-Gm-Gg: AeBDiev1a1i1isXIu7MIqywAnCovotd69Etqh2Ag02jMMf/PhyhgB7ZMqMtX59q1FbZ
	2Hw+Awor6wfpBGk2RSPQP3cPjYMAc+KmEGPq7u/RgJ6mOzCjpfkDRw6HfUEn3DJ/afu91yqq2/r
	6IRP+musNVEMgVlH7SHtILgQDD9yE9l5FnIKGAlsEnSdezKUBt36yKnL2CWZnaoPZOOLWQxqwN/
	rd8IxvcohRu1genoLBwK4PiYDaCekftrQAVHJ8VaJAFsWjf/r3FP01Wz7GJqTiK88SEPFvnhGRd
	VrTD3uG2rIkcR7Jhq1kp55yeLdEWm3cgncbg3sZVmM0hdpxbkXOb8rnk0k5dDXeIc/+wHGkBl1c
	jjiXAIeFLtgRTIotFb/HV3nptLCHRS2pFP1satiOKWkVeqRHYRrbhWy8FWw6gCu73y8fWXgu4M5
	fcHfyBnvC9wpUTBZW0C1aMBTStJzEtmOgpcw==
X-Received: by 2002:a05:600c:4593:b0:48a:599a:36fe with SMTP id 5b1f17b1804b1-48a77b1d78cmr135218455e9.24.1777473345121;
        Wed, 29 Apr 2026 07:35:45 -0700 (PDT)
Received: from [127.0.0.1] ([2804:1bc4:224:7800:585c:db3a:fcb:e21f])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48a7c305371sm19982835e9.18.2026.04.29.07.35.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Apr 2026 07:35:44 -0700 (PDT)
From: Marcos Paulo de Souza <mpdesouza@suse.com>
Date: Wed, 29 Apr 2026 11:35:18 -0300
Subject: [PATCH v4 4/6] selftests: livepatch: Check if patched sysfs
 attribute exists
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260429-lp-tests-old-fixes-v4-4-59b9741989d0@suse.com>
References: <20260429-lp-tests-old-fixes-v4-0-59b9741989d0@suse.com>
In-Reply-To: <20260429-lp-tests-old-fixes-v4-0-59b9741989d0@suse.com>
To: Josh Poimboeuf <jpoimboe@kernel.org>, Jiri Kosina <jikos@kernel.org>, 
 Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>, 
 Joe Lawrence <joe.lawrence@redhat.com>, Shuah Khan <shuah@kernel.org>
Cc: live-patching@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Marcos Paulo de Souza <mpdesouza@suse.com>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1777473323; l=3506;
 i=mpdesouza@suse.com; s=20231031; h=from:subject:message-id;
 bh=cabsWImOrTfadEvXIKkGEu46ZFIbjUR+jCHHWZS1nFI=;
 b=962zclveMkH6fDa7AmvE9EZE/Ell/osKqQAs2NxSNzk+Eh5hUA0XXis/5DGO9zBopvX0M57oz
 JHGAKaQiN6GCNlAeUm/plisCnIWRsIU6mGIs30DKHWp3YCLGNZzx0zs
X-Developer-Key: i=mpdesouza@suse.com; a=ed25519;
 pk=/Ni/TsKkr69EOmdZXkp1Q/BlzDonbOBRsfPa18ySIwU=
X-Rspamd-Queue-Id: 7B3654961F7
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[suse.com,quarantine];
	R_DKIM_ALLOW(-0.20)[suse.com:s=google];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[suse.com:+];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2604-lists,live-patching=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[mpdesouza@suse.com,live-patching@vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_FIVE(0.00)[5];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_SEVEN(0.00)[10];
	TO_DN_SOME(0.00)[]

The commit bb26cfd9e77e
("livepatch: add sysfs entry "patched" for each klp_object") was merged
in v6.1, introducing a new sysfs attribute.

In order to run the selftests on older kernels, check if given kernel
has support for the attribute. If the attribute is not supported, skip
the checks.

Signed-off-by: Marcos Paulo de Souza <mpdesouza@suse.com>
---
 tools/testing/selftests/livepatch/test-sysfs.sh | 38 +++++++++++++++----------
 1 file changed, 23 insertions(+), 15 deletions(-)

diff --git a/tools/testing/selftests/livepatch/test-sysfs.sh b/tools/testing/selftests/livepatch/test-sysfs.sh
index 58fe1d96997c..394cf3ff99cd 100755
--- a/tools/testing/selftests/livepatch/test-sysfs.sh
+++ b/tools/testing/selftests/livepatch/test-sysfs.sh
@@ -8,6 +8,8 @@ MOD_LIVEPATCH=test_klp_livepatch
 MOD_LIVEPATCH2=test_klp_callbacks_demo
 MOD_LIVEPATCH3=test_klp_syscall
 
+HAS_PATCH_ATTR=0
+
 setup_config
 
 # - load a livepatch and verifies the sysfs entries work as expected
@@ -25,8 +27,12 @@ check_sysfs_rights "$MOD_LIVEPATCH" "stack_order" "-r--r--r--"
 check_sysfs_value  "$MOD_LIVEPATCH" "stack_order" "1"
 check_sysfs_rights "$MOD_LIVEPATCH" "transition" "-r--r--r--"
 check_sysfs_value  "$MOD_LIVEPATCH" "transition" "0"
-check_sysfs_rights "$MOD_LIVEPATCH" "vmlinux/patched" "-r--r--r--"
-check_sysfs_value  "$MOD_LIVEPATCH" "vmlinux/patched" "1"
+
+if does_sysfs_exist "$MOD_LIVEPATCH/vmlinux" "patched"; then
+	check_sysfs_rights "$MOD_LIVEPATCH" "vmlinux/patched" "-r--r--r--"
+	check_sysfs_value  "$MOD_LIVEPATCH" "vmlinux/patched" "1"
+	HAS_PATCH_ATTR=1
+fi
 
 disable_lp $MOD_LIVEPATCH
 
@@ -45,23 +51,24 @@ livepatch: '$MOD_LIVEPATCH': completing unpatching transition
 livepatch: '$MOD_LIVEPATCH': unpatching complete
 % rmmod $MOD_LIVEPATCH"
 
-start_test "sysfs test object/patched"
+if [[ "$HAS_PATCH_ATTR" == "1" ]]; then
+	start_test "sysfs test object/patched"
 
-MOD_LIVEPATCH=test_klp_callbacks_demo
-MOD_TARGET=test_klp_callbacks_mod
-load_lp $MOD_LIVEPATCH
+	MOD_LIVEPATCH=test_klp_callbacks_demo
+	MOD_TARGET=test_klp_callbacks_mod
+	load_lp $MOD_LIVEPATCH
 
-# check the "patch" file changes as target module loads/unloads
-check_sysfs_value  "$MOD_LIVEPATCH" "$MOD_TARGET/patched" "0"
-load_mod $MOD_TARGET
-check_sysfs_value  "$MOD_LIVEPATCH" "$MOD_TARGET/patched" "1"
-unload_mod $MOD_TARGET
-check_sysfs_value  "$MOD_LIVEPATCH" "$MOD_TARGET/patched" "0"
+	# check the "patch" file changes as target module loads/unloads
+	check_sysfs_value  "$MOD_LIVEPATCH" "$MOD_TARGET/patched" "0"
+	load_mod $MOD_TARGET
+	check_sysfs_value  "$MOD_LIVEPATCH" "$MOD_TARGET/patched" "1"
+	unload_mod $MOD_TARGET
+	check_sysfs_value  "$MOD_LIVEPATCH" "$MOD_TARGET/patched" "0"
 
-disable_lp $MOD_LIVEPATCH
-unload_lp $MOD_LIVEPATCH
+	disable_lp $MOD_LIVEPATCH
+	unload_lp $MOD_LIVEPATCH
 
-check_result "% insmod test_modules/test_klp_callbacks_demo.ko
+	check_result "% insmod test_modules/test_klp_callbacks_demo.ko
 livepatch: enabling patch 'test_klp_callbacks_demo'
 livepatch: 'test_klp_callbacks_demo': initializing patching transition
 test_klp_callbacks_demo: pre_patch_callback: vmlinux
@@ -87,6 +94,7 @@ livepatch: 'test_klp_callbacks_demo': completing unpatching transition
 test_klp_callbacks_demo: post_unpatch_callback: vmlinux
 livepatch: 'test_klp_callbacks_demo': unpatching complete
 % rmmod test_klp_callbacks_demo"
+fi
 
 start_test "sysfs test replace enabled"
 

-- 
2.54.0


