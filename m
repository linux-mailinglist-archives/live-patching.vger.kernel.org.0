Return-Path: <live-patching+bounces-2566-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 0FmdKTms72lIDwEAu9opvQ
	(envelope-from <live-patching+bounces-2566-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Mon, 27 Apr 2026 20:34:33 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 2C5D5478A65
	for <lists+live-patching@lfdr.de>; Mon, 27 Apr 2026 20:34:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id B19983015718
	for <lists+live-patching@lfdr.de>; Mon, 27 Apr 2026 18:31:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 444343ECBC3;
	Mon, 27 Apr 2026 18:31:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="DS2xoav6"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93A6B3EC2F4
	for <live-patching@vger.kernel.org>; Mon, 27 Apr 2026 18:31:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777314683; cv=none; b=syued8mevcmSDG28OZDk74G0KMfDC1dl2pUA3QfO2O2AkC/OwpaYfh2Ev0kpx9NNRBrVmOrO5WVFJHFuGbfBA+T24dgTdVFNX7FbTqjzbfxCGXKjN8brir2iKpXj0s33Ob+rq6yjdKiQI0g50JBpqG/8VOZMfIf8l7CYkHrAFBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777314683; c=relaxed/simple;
	bh=cabsWImOrTfadEvXIKkGEu46ZFIbjUR+jCHHWZS1nFI=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=T8cx2wbm2N83D9WRTS+jQ1jDmwfatWoO9EhvXseqVlik1o9+u3Wa9wkA70kgt0waZsM0udtl6MoSE+uwAyj8UwZdaXLprQfAe7+mgnvxgHvwqV5UyNMHXLVK2Mwrya7O25aIfdNDv7M1qqeQdezj6y6GucCcikqTzo4jNJtRqhM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=DS2xoav6; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4891f625344so95610385e9.0
        for <live-patching@vger.kernel.org>; Mon, 27 Apr 2026 11:31:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1777314680; x=1777919480; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZSv7mvHEKazo1ADkBY1eKHJ65hhcoj1auW86Wb7XPbw=;
        b=DS2xoav6lvwb9x9e3FcavzXeNTDLCQQYvlQZs5NK1rdd1r59M1/+LcE3yQZrCse77l
         Br5/a59/Bw7fIyMMn5iI9wSj6/aKFhEiNmfKFlKAO2cmNlZePC5NZK3JShBC+QTvGmdM
         SZ/yif5Wm6V5hzYOssVD356sm71Amac+/x4VKkoix/O9sTUVAI+NrxL1VbV5Gxy5A/zM
         TeAFmYKpcc/Af9kSec7V7HFqBmhgpO8EzLvwj37TUdLiMw4enn8KTfwu8pjhYgPNo8yr
         Afq5kreRiLepPyaRj4cbWpMnwODSNPhUd1JLuNXQunmfFgLM0/rP6RAyVwj/sbCN3meg
         MiIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777314680; x=1777919480;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=ZSv7mvHEKazo1ADkBY1eKHJ65hhcoj1auW86Wb7XPbw=;
        b=VPdJg0uWiQmfK6Jj+Ui+onZZu0aMOYHOviEo3PbZi5RaISGaH3Frhfduy6dalIEame
         s+APXegwxj9xf8NXLRUlDKCdpSJNBF/pwCo0BDN0tBuV/hHkjSxdhbeVnSn0f/tOtvfs
         ET6YIEHgjKkZwbQ052YJC80OmdwPyHoj+shPulToonkIkr5T0qJa2oeE56YgeoSe9fnM
         ed+FSHj/iIXostSwd58Ik9CBwyKSN+d2ghTfY4C7e7AuWY48yL92KkFj4hhGYkwO49Zi
         PK0cFwUwh5jKWu7d+Aj2JsK8GWIkXpIaAhhc+ZT/wlxXnziAFRbixYc86MqIdhxhL1ts
         Ec7w==
X-Gm-Message-State: AOJu0YzWUrpFR4pjNIp89P5+XptR6mJOSIuxr58U0eFFMNMWNt2Jv2iw
	uWWto/GE5LmdBowoRZDjkAO4RxRvXd+8ijRV0lJFYUoPg1N8dcZVphm/sppw5QT46SlzJZXriKJ
	8xPrnP8E=
X-Gm-Gg: AeBDietL6cbFZdAR5a/kICGDID/Nug845ZiPkJ7C4NMPqBBkm0OF9I8qIgF8YHUs5yc
	RtfrCjzqaWIIa8IuSqEfCc8PPUE6aTMOc198yEzay7IgPkTFAD0vpVSf2JsYh2xlm2DBavNvRL7
	ThD2uC7Xlw0g8j++WRiMHnME1ZDLH9RVsZ2UX+wLHTyMPRKYeaN86FfYAWvkUcZpQ0kt76UNN8b
	Jb/8Q7vDIla0Y09OuyECA2aNfu98XCRQYXsWk6Syx8CB0Fol9xk5Ogb00Lkd4kchjWGcU/xjmeq
	zPfo3DOjgKngnMSGpB7hY263NLwzWJJs7Gw3CHT4srOYGF5zK4PgE0/kvOTHwtxu/tSAXDbmhgY
	Od41luHraoNzBDk82SC6jqfCju0DkW70EZNp09ZcknwlCcYCVqXYZqBy2+2dPkkQAWAW4qcOuC4
	7PlsdfJ9kgja3gr3pEqRNxDXRsy8UtJWEHhg==
X-Received: by 2002:a05:600c:2e4c:b0:489:32b:ac0b with SMTP id 5b1f17b1804b1-48a77635c61mr1553295e9.6.1777314679620;
        Mon, 27 Apr 2026 11:31:19 -0700 (PDT)
Received: from [127.0.0.1] ([2804:1bc4:224:7800:585c:db3a:fcb:e21f])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48a7749cabdsm1182065e9.9.2026.04.27.11.31.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Apr 2026 11:31:19 -0700 (PDT)
From: Marcos Paulo de Souza <mpdesouza@suse.com>
Date: Mon, 27 Apr 2026 15:31:00 -0300
Subject: [PATCH v3 4/6] selftests: livepatch: Check if patched sysfs
 attribute exists
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260427-lp-tests-old-fixes-v3-4-ccf3c90f744c@suse.com>
References: <20260427-lp-tests-old-fixes-v3-0-ccf3c90f744c@suse.com>
In-Reply-To: <20260427-lp-tests-old-fixes-v3-0-ccf3c90f744c@suse.com>
To: Josh Poimboeuf <jpoimboe@kernel.org>, Jiri Kosina <jikos@kernel.org>, 
 Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>, 
 Joe Lawrence <joe.lawrence@redhat.com>, Shuah Khan <shuah@kernel.org>
Cc: live-patching@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Marcos Paulo de Souza <mpdesouza@suse.com>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1777314662; l=3506;
 i=mpdesouza@suse.com; s=20231031; h=from:subject:message-id;
 bh=cabsWImOrTfadEvXIKkGEu46ZFIbjUR+jCHHWZS1nFI=;
 b=RtWCyDoZ0CDWVtPSx0XGCigfMLI0Lb5+rOa/9wKam/t4YGJk/K8YQBnkY4lt+BILQ/S6deQd5
 3YeSCj30LdiCXyvcQMn6XyU+TV/k7AU928KD1L1SAMjFi78o5EmD2J7
X-Developer-Key: i=mpdesouza@suse.com; a=ed25519;
 pk=/Ni/TsKkr69EOmdZXkp1Q/BlzDonbOBRsfPa18ySIwU=
X-Rspamd-Queue-Id: 2C5D5478A65
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[suse.com,quarantine];
	R_DKIM_ALLOW(-0.20)[suse.com:s=google];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DKIM_TRACE(0.00)[suse.com:+];
	TAGGED_FROM(0.00)[bounces-2566-lists,live-patching=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_SEVEN(0.00)[10];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,suse.com:email,suse.com:dkim,suse.com:mid]

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


