Return-Path: <live-patching+bounces-861-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 18AA19D4B60
	for <lists+live-patching@lfdr.de>; Thu, 21 Nov 2024 12:14:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 92E711F23F21
	for <lists+live-patching@lfdr.de>; Thu, 21 Nov 2024 11:14:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A4471D5CCD;
	Thu, 21 Nov 2024 11:12:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="v0DFFyY3"
X-Original-To: live-patching@vger.kernel.org
Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C5A51D5164
	for <live-patching@vger.kernel.org>; Thu, 21 Nov 2024 11:12:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732187579; cv=none; b=OR/4sTq5OUAK4onnbe3GhuUJllJOf8+nb0WKoVPojTof8oQhYMEetsOXkAWSLP868+EjPJnGkJFw0LaNrK7KQB4R4okke+/GGk7BCY0QX4CNcGOx4vNBcqtIBMfVNC0KihZC5WlydcAbcjZCtVTiMPEIsJcInlrxnef6vEmzZQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732187579; c=relaxed/simple;
	bh=VE7MUh5+iQwKTqpfwZLY1fHwwKqkM6/FBkofRYDxa4A=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=jvn77Cfzer3tzek+fj/3+p3lrf0wyuuFjNSHgTJcbbtgY6jXf9TxYnO2osotsJxsFP0WSPwKI9izB/2o7gW6aqqJY5WIP4eIWlk6xYjrvTz+5cuAnZ5Bcsxe5G4rvRJl1NjUjfOZPQsO7sst2awT2w2tSdeoACcNCIHCLpjZFCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=v0DFFyY3; arc=none smtp.client-ip=91.218.175.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1732187575;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=76vuuYqaL6aHm6G8MsofNUQkaRfjxHCsBlGojg6fu/w=;
	b=v0DFFyY3c+fP379s2O8ntaMxncgP50oL8ok+XwJR+nv8GTJaaRM1sY7EDLEHdCEWopAzr6
	s/wXD2j+z57GgD3is8vJF6bR92EpA05HOie6UyhKBUeBJy9u8Uu3x69w60SLsI7+nA7nX3
	V43XaTup8AB7rlCPqqD9S9TRHRygSFg=
From: George Guo <dongtai.guo@linux.dev>
To: jpoimboe@kernel.org,
	jikos@kernel.org,
	mbenes@suse.cz,
	pmladek@suse.com,
	joe.lawrence@redhat.com,
	shuah@kernel.org
Cc: live-patching@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	George Guo <guodongtai@kylinos.cn>
Subject: [PATCH livepatch/master v1 6/6] selftests/livepatch: fix test-sysfs.sh execution error
Date: Thu, 21 Nov 2024 19:11:35 +0800
Message-Id: <20241121111135.2125391-6-dongtai.guo@linux.dev>
In-Reply-To: <20241121111135.2125391-1-dongtai.guo@linux.dev>
References: <20241121111135.2125391-1-dongtai.guo@linux.dev>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: George Guo <guodongtai@kylinos.cn>

The script test-sysfs.sh fails with the following error:

$ sudo ./test-sysfs.sh
TEST: sysfs test ... not ok

- expected
+ result
 % insmod test_modules/test_klp_livepatch.ko
 livepatch: enabling patch 'test_klp_livepatch'
-livepatch: 'test_klp_livepatch': initializing patching transition
-livepatch: 'test_klp_livepatch': starting patching transition
-livepatch: 'test_klp_livepatch': completing patching transition
-livepatch: 'test_klp_livepatch': patching complete
+transition: 'test_klp_livepatch': initializing patching transition
+transition: 'test_klp_livepatch': starting patching transition
+transition: 'test_klp_livepatch': completing patching transition
+transition: 'test_klp_livepatch': patching complete
 % echo 0 > /sys/kernel/livepatch/test_klp_livepatch/enabled
-livepatch: 'test_klp_livepatch': initializing unpatching transition
-livepatch: 'test_klp_livepatch': starting unpatching transition
-livepatch: 'test_klp_livepatch': completing unpatching transition
-livepatch: 'test_klp_livepatch': unpatching complete
+transition: 'test_klp_livepatch': initializing unpatching transition
+transition: 'test_klp_livepatch': starting unpatching transition
+transition: 'test_klp_livepatch': completing unpatching transition
+transition: 'test_klp_livepatch': unpatching complete
 % rmmod test_klp_livepatch

ERROR: livepatch kselftest(s) failed

The issue arises due to a mismatch in expected log output during livepatch
transition. Specifically, the logs previously contained "livepatch:" but have
now been updated to "transition:". This results in test failures when comparing
the output with the expected values.

This patch updates the expected test output to reflect the new log format.

Signed-off-by: George Guo <guodongtai@kylinos.cn>
---
 .../testing/selftests/livepatch/test-sysfs.sh | 64 +++++++++----------
 1 file changed, 32 insertions(+), 32 deletions(-)

diff --git a/tools/testing/selftests/livepatch/test-sysfs.sh b/tools/testing/selftests/livepatch/test-sysfs.sh
index 05a14f5a7bfb..f9a27505d7a4 100755
--- a/tools/testing/selftests/livepatch/test-sysfs.sh
+++ b/tools/testing/selftests/livepatch/test-sysfs.sh
@@ -30,15 +30,15 @@ unload_lp $MOD_LIVEPATCH
 
 check_result "% insmod test_modules/$MOD_LIVEPATCH.ko
 livepatch: enabling patch '$MOD_LIVEPATCH'
-livepatch: '$MOD_LIVEPATCH': initializing patching transition
-livepatch: '$MOD_LIVEPATCH': starting patching transition
-livepatch: '$MOD_LIVEPATCH': completing patching transition
-livepatch: '$MOD_LIVEPATCH': patching complete
+transition: '$MOD_LIVEPATCH': initializing patching transition
+transition: '$MOD_LIVEPATCH': starting patching transition
+transition: '$MOD_LIVEPATCH': completing patching transition
+transition: '$MOD_LIVEPATCH': patching complete
 % echo 0 > /sys/kernel/livepatch/$MOD_LIVEPATCH/enabled
-livepatch: '$MOD_LIVEPATCH': initializing unpatching transition
-livepatch: '$MOD_LIVEPATCH': starting unpatching transition
-livepatch: '$MOD_LIVEPATCH': completing unpatching transition
-livepatch: '$MOD_LIVEPATCH': unpatching complete
+transition: '$MOD_LIVEPATCH': initializing unpatching transition
+transition: '$MOD_LIVEPATCH': starting unpatching transition
+transition: '$MOD_LIVEPATCH': completing unpatching transition
+transition: '$MOD_LIVEPATCH': unpatching complete
 % rmmod $MOD_LIVEPATCH"
 
 start_test "sysfs test object/patched"
@@ -59,12 +59,12 @@ unload_lp $MOD_LIVEPATCH
 
 check_result "% insmod test_modules/test_klp_callbacks_demo.ko
 livepatch: enabling patch 'test_klp_callbacks_demo'
-livepatch: 'test_klp_callbacks_demo': initializing patching transition
+transition: 'test_klp_callbacks_demo': initializing patching transition
 test_klp_callbacks_demo: pre_patch_callback: vmlinux
-livepatch: 'test_klp_callbacks_demo': starting patching transition
-livepatch: 'test_klp_callbacks_demo': completing patching transition
+transition: 'test_klp_callbacks_demo': starting patching transition
+transition: 'test_klp_callbacks_demo': completing patching transition
 test_klp_callbacks_demo: post_patch_callback: vmlinux
-livepatch: 'test_klp_callbacks_demo': patching complete
+transition: 'test_klp_callbacks_demo': patching complete
 % insmod test_modules/test_klp_callbacks_mod.ko
 livepatch: applying patch 'test_klp_callbacks_demo' to loading module 'test_klp_callbacks_mod'
 test_klp_callbacks_demo: pre_patch_callback: test_klp_callbacks_mod -> [MODULE_STATE_COMING] Full formed, running module_init
@@ -76,12 +76,12 @@ test_klp_callbacks_demo: pre_unpatch_callback: test_klp_callbacks_mod -> [MODULE
 livepatch: reverting patch 'test_klp_callbacks_demo' on unloading module 'test_klp_callbacks_mod'
 test_klp_callbacks_demo: post_unpatch_callback: test_klp_callbacks_mod -> [MODULE_STATE_GOING] Going away
 % echo 0 > /sys/kernel/livepatch/test_klp_callbacks_demo/enabled
-livepatch: 'test_klp_callbacks_demo': initializing unpatching transition
+transition: 'test_klp_callbacks_demo': initializing unpatching transition
 test_klp_callbacks_demo: pre_unpatch_callback: vmlinux
-livepatch: 'test_klp_callbacks_demo': starting unpatching transition
-livepatch: 'test_klp_callbacks_demo': completing unpatching transition
+transition: 'test_klp_callbacks_demo': starting unpatching transition
+transition: 'test_klp_callbacks_demo': completing unpatching transition
 test_klp_callbacks_demo: post_unpatch_callback: vmlinux
-livepatch: 'test_klp_callbacks_demo': unpatching complete
+transition: 'test_klp_callbacks_demo': unpatching complete
 % rmmod test_klp_callbacks_demo"
 
 start_test "sysfs test replace enabled"
@@ -97,15 +97,15 @@ unload_lp $MOD_LIVEPATCH
 
 check_result "% insmod test_modules/$MOD_LIVEPATCH.ko replace=1
 livepatch: enabling patch '$MOD_LIVEPATCH'
-livepatch: '$MOD_LIVEPATCH': initializing patching transition
-livepatch: '$MOD_LIVEPATCH': starting patching transition
-livepatch: '$MOD_LIVEPATCH': completing patching transition
-livepatch: '$MOD_LIVEPATCH': patching complete
+transition: '$MOD_LIVEPATCH': initializing patching transition
+transition: '$MOD_LIVEPATCH': starting patching transition
+transition: '$MOD_LIVEPATCH': completing patching transition
+transition: '$MOD_LIVEPATCH': patching complete
 % echo 0 > /sys/kernel/livepatch/$MOD_LIVEPATCH/enabled
-livepatch: '$MOD_LIVEPATCH': initializing unpatching transition
-livepatch: '$MOD_LIVEPATCH': starting unpatching transition
-livepatch: '$MOD_LIVEPATCH': completing unpatching transition
-livepatch: '$MOD_LIVEPATCH': unpatching complete
+transition: '$MOD_LIVEPATCH': initializing unpatching transition
+transition: '$MOD_LIVEPATCH': starting unpatching transition
+transition: '$MOD_LIVEPATCH': completing unpatching transition
+transition: '$MOD_LIVEPATCH': unpatching complete
 % rmmod $MOD_LIVEPATCH"
 
 start_test "sysfs test replace disabled"
@@ -120,15 +120,15 @@ unload_lp $MOD_LIVEPATCH
 
 check_result "% insmod test_modules/$MOD_LIVEPATCH.ko replace=0
 livepatch: enabling patch '$MOD_LIVEPATCH'
-livepatch: '$MOD_LIVEPATCH': initializing patching transition
-livepatch: '$MOD_LIVEPATCH': starting patching transition
-livepatch: '$MOD_LIVEPATCH': completing patching transition
-livepatch: '$MOD_LIVEPATCH': patching complete
+transition: '$MOD_LIVEPATCH': initializing patching transition
+transition: '$MOD_LIVEPATCH': starting patching transition
+transition: '$MOD_LIVEPATCH': completing patching transition
+transition: '$MOD_LIVEPATCH': patching complete
 % echo 0 > /sys/kernel/livepatch/$MOD_LIVEPATCH/enabled
-livepatch: '$MOD_LIVEPATCH': initializing unpatching transition
-livepatch: '$MOD_LIVEPATCH': starting unpatching transition
-livepatch: '$MOD_LIVEPATCH': completing unpatching transition
-livepatch: '$MOD_LIVEPATCH': unpatching complete
+transition: '$MOD_LIVEPATCH': initializing unpatching transition
+transition: '$MOD_LIVEPATCH': starting unpatching transition
+transition: '$MOD_LIVEPATCH': completing unpatching transition
+transition: '$MOD_LIVEPATCH': unpatching complete
 % rmmod $MOD_LIVEPATCH"
 
 exit 0
-- 
2.39.2


