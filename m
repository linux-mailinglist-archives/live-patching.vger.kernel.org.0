Return-Path: <live-patching+bounces-2202-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 8IuhN8p6tGmOogAAu9opvQ
	(envelope-from <live-patching+bounces-2202-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Fri, 13 Mar 2026 21:59:54 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 593ED289F6E
	for <lists+live-patching@lfdr.de>; Fri, 13 Mar 2026 21:59:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 72D79307C400
	for <lists+live-patching@lfdr.de>; Fri, 13 Mar 2026 20:59:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 26A5638239D;
	Fri, 13 Mar 2026 20:59:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Tdb07EKE"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D83223CF023
	for <live-patching@vger.kernel.org>; Fri, 13 Mar 2026 20:59:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773435549; cv=none; b=s3cIJ5blBwPo/zaV+eyOnqn/sJnR4DI6cy3rsdg8XYtXKDIY+ub/+IQWXftqFDH9PX5EnV4VjtgolsTIwLTa22JPKBff2wJ8s00BXzKBvstd3t4WpeyKURFvs91ICOSVWrao8cltnbmQAkifcczqBkLCkI2AkRlR7FFNPzJ0JXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773435549; c=relaxed/simple;
	bh=5yfrb4REjla72hyuadKvBD65CovUyvEY7fUSzyt+1JE=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=WZbxHg5W83zros/ulGtWs0fl+CctUtxzQRuosUJXOgdp30a/BFNifk5Qn2hqbrvXkPh/UOH4aKLKkTT1SYKQV8UFXLp8JF74MMwdkE1iLANAVIfjfoNCzqRvUkYjUBnfjwLPrxuCM+y3VbnEfOA7jYydfSNyHVw6s2Jhl4XMek8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Tdb07EKE; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-48539cbb7b1so15372825e9.3
        for <live-patching@vger.kernel.org>; Fri, 13 Mar 2026 13:59:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1773435543; x=1774040343; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JUlmk5Uej4Q4zAW57SpQCMgrWe47+shWlWuNt0RZn1k=;
        b=Tdb07EKEWDRIoh1bQToLzd4cD8nKezLZqPgVgGVxU1NuWDRNK57GQuUNtija/U1p28
         ePlcdg5WNMV7cl3/HIjHMIrY+ye8NkaskvMGLNezYTfAtRdpS9yuTZ9R1uXgrChyN4E/
         yR5FZkzL3qs2RXUmY+lu9PX+FM4VG7A6fVw+GcXfxYtex46TCv5ZOQlGmi2PFKhOzhUB
         4+/hWNqoG/HZGvUj8dy2k5nPlF0y5hRrHTRR5N83bpya3KKFDFZMr9nxBs9z3IpxmiE/
         d8L25cnL/iA23W5t7M8yy3uBe+KFPfQATMIfEL2pKZCNaXt0grrGZWJdo7pRQBhYHB0T
         dk9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773435543; x=1774040343;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=JUlmk5Uej4Q4zAW57SpQCMgrWe47+shWlWuNt0RZn1k=;
        b=B6RNod2DCubrE/lE07t+Ss3zvT04PtdwSP53BsOmE/ZVZjkfSphVtFrZsK+mzd2YZ8
         1anLbGuOLmrtKiCucvHry1o+BvM0FJst2wgyTjRvga65zaCWnP6T2rM/CqVqSO6qyuoo
         CriZhrspqg+t2YpCWCueHf2uQozpogZcErjKHxaVA5yYscn16S3KxHoz0fr6vRZH57jh
         wPVZA6AI25uRUMU11OaZh/PRSi/fhM7+4XeHg/igdw/Q+EEChAtt7cqJO2O6btw4kSy6
         w9SSAc5NgOxuIVBzF+AgZQ36u6FbnSw1wRGkP1z4XFd2o+HF87zWMTtn2qJu2jYwhBfn
         glBA==
X-Gm-Message-State: AOJu0YypyUBERKaM079KkisGsIJnPd4kCFKms/9jPtfbA4xmd6n5LDpO
	PE0ctRVvU0ZhleeDRWSUurFvitgzaCtu7uKoUOFV4h8kCzJcbbiBa7u5mdf+aBxNSuQ=
X-Gm-Gg: ATEYQzzuXlbn+JW/1S+lQ5TwDu8U2acg9axFRN7oYDWOXwvle0q07Jm++5DnPasXnNY
	4LpbX16I3BPQ76KrC53YJCrnsuLXZYbyYwOdVLrcdFjEJnyogX1G/c5hWydih+dJKdY5FcGMjPP
	ntOvrgIsOo6u0Jv6NQZ/b2Ip8p9tjW8GEy2XLb6PFRuXZxCVhB7+oXNGRC7hRl71zeqQKkMngb0
	vMGjQZnIyMMToFQe3laljlPa/rbEU48mEPCq0L4AbBjHHY6VM4FgrIX/9TSUQLvCLiQhfxi37ps
	DM0ncSpLez9lgghta+UrEC0GojoHcsmHsc5Tn0L0zf9mGG7lZYsNg0+gCSeKhXgrQq4dkQlLB4C
	ZUQhjvqEpkQlRgMwe/Wk/0qdYdA0VKb8nlUT21QLIlvmQepUwQHAJDkJP9IMtnXXnA6hz0J8VtN
	6K3Q+T2vBFjrRU3pBaTNT5
X-Received: by 2002:a05:600c:3b90:b0:485:345b:ccb1 with SMTP id 5b1f17b1804b1-48556720f86mr72676115e9.27.1773435542687;
        Fri, 13 Mar 2026 13:59:02 -0700 (PDT)
Received: from [127.0.0.1] ([2804:5078:834:1300:58f2:fc97:371f:3])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2beab526d3csm4042611eec.18.2026.03.13.13.58.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Mar 2026 13:59:01 -0700 (PDT)
From: Marcos Paulo de Souza <mpdesouza@suse.com>
Date: Fri, 13 Mar 2026 17:58:36 -0300
Subject: [PATCH 5/8] selftests: livepatch: sysfs: Split tests of replace
 attribute
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260313-lp-tests-old-fixes-v1-5-71ac6dfb3253@suse.com>
References: <20260313-lp-tests-old-fixes-v1-0-71ac6dfb3253@suse.com>
In-Reply-To: <20260313-lp-tests-old-fixes-v1-0-71ac6dfb3253@suse.com>
To: Josh Poimboeuf <jpoimboe@kernel.org>, Jiri Kosina <jikos@kernel.org>, 
 Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>, 
 Joe Lawrence <joe.lawrence@redhat.com>, Shuah Khan <shuah@kernel.org>
Cc: live-patching@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Marcos Paulo de Souza <mpdesouza@suse.com>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1773435515; l=6599;
 i=mpdesouza@suse.com; s=20231031; h=from:subject:message-id;
 bh=5yfrb4REjla72hyuadKvBD65CovUyvEY7fUSzyt+1JE=;
 b=IqJehXZ8pHnYEfwizMu/gVOB6kUw2ak2avpUcTUa8h9svETYAo3obiieKHnthJ1fojDANuMtN
 UEnxmJijSNAATMeixB7B1zX3mHBE87dfSXPfQcl7GdNhlH2MQbBDTHS
X-Developer-Key: i=mpdesouza@suse.com; a=ed25519;
 pk=/Ni/TsKkr69EOmdZXkp1Q/BlzDonbOBRsfPa18ySIwU=
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
	TAGGED_FROM(0.00)[bounces-2202-lists,live-patching=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[mpdesouza@suse.com,live-patching@vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_FIVE(0.00)[5];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-0.998];
	RCPT_COUNT_SEVEN(0.00)[10];
	TO_DN_SOME(0.00)[]
X-Rspamd-Queue-Id: 593ED289F6E
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

In order to run the selftests on older kernels, split the sysfs tests to
another file, making it able to skip the tests when the attributes
don't exists.

No functional changes.

Signed-off-by: Marcos Paulo de Souza <mpdesouza@suse.com>
---
 tools/testing/selftests/livepatch/Makefile         |  1 +
 .../selftests/livepatch/test-sysfs-replace-attr.sh | 75 ++++++++++++++++++++++
 tools/testing/selftests/livepatch/test-sysfs.sh    | 48 --------------
 3 files changed, 76 insertions(+), 48 deletions(-)

diff --git a/tools/testing/selftests/livepatch/Makefile b/tools/testing/selftests/livepatch/Makefile
index a080eb54a215d..b95aa6e78a273 100644
--- a/tools/testing/selftests/livepatch/Makefile
+++ b/tools/testing/selftests/livepatch/Makefile
@@ -10,6 +10,7 @@ TEST_PROGS := \
 	test-state.sh \
 	test-ftrace.sh \
 	test-sysfs.sh \
+	test-sysfs-replace-attr.sh \
 	test-syscall.sh \
 	test-kprobe.sh
 
diff --git a/tools/testing/selftests/livepatch/test-sysfs-replace-attr.sh b/tools/testing/selftests/livepatch/test-sysfs-replace-attr.sh
new file mode 100755
index 0000000000000..d1051211fe320
--- /dev/null
+++ b/tools/testing/selftests/livepatch/test-sysfs-replace-attr.sh
@@ -0,0 +1,75 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (C) 2022 Song Liu <song@kernel.org>
+
+. $(dirname $0)/functions.sh
+
+MOD_LIVEPATCH=test_klp_livepatch
+
+setup_config
+
+# - load a livepatch and verifies the sysfs replace attribute exists
+
+start_test "check sysfs replace attribute"
+
+load_lp $MOD_LIVEPATCH
+
+check_sysfs_exists "$MOD_LIVEPATCH" "replace"
+file_exists=$?
+
+disable_lp $MOD_LIVEPATCH
+
+unload_lp $MOD_LIVEPATCH
+
+if [[ "$file_exists" == "0" ]]; then
+	skip "sysfs attribute doesn't exists."
+fi
+
+start_test "sysfs test replace enabled"
+
+MOD_LIVEPATCH=test_klp_atomic_replace
+load_lp $MOD_LIVEPATCH replace=1
+
+check_sysfs_rights "$MOD_LIVEPATCH" "replace" "-r--r--r--"
+check_sysfs_value  "$MOD_LIVEPATCH" "replace" "1"
+
+disable_lp $MOD_LIVEPATCH
+unload_lp $MOD_LIVEPATCH
+
+check_result "% insmod test_modules/$MOD_LIVEPATCH.ko replace=1
+livepatch: enabling patch '$MOD_LIVEPATCH'
+livepatch: '$MOD_LIVEPATCH': initializing patching transition
+livepatch: '$MOD_LIVEPATCH': starting patching transition
+livepatch: '$MOD_LIVEPATCH': completing patching transition
+livepatch: '$MOD_LIVEPATCH': patching complete
+% echo 0 > $SYSFS_KLP_DIR/$MOD_LIVEPATCH/enabled
+livepatch: '$MOD_LIVEPATCH': initializing unpatching transition
+livepatch: '$MOD_LIVEPATCH': starting unpatching transition
+livepatch: '$MOD_LIVEPATCH': completing unpatching transition
+livepatch: '$MOD_LIVEPATCH': unpatching complete
+% rmmod $MOD_LIVEPATCH"
+
+start_test "sysfs test replace disabled"
+
+load_lp $MOD_LIVEPATCH replace=0
+
+check_sysfs_rights "$MOD_LIVEPATCH" "replace" "-r--r--r--"
+check_sysfs_value  "$MOD_LIVEPATCH" "replace" "0"
+
+disable_lp $MOD_LIVEPATCH
+unload_lp $MOD_LIVEPATCH
+
+check_result "% insmod test_modules/$MOD_LIVEPATCH.ko replace=0
+livepatch: enabling patch '$MOD_LIVEPATCH'
+livepatch: '$MOD_LIVEPATCH': initializing patching transition
+livepatch: '$MOD_LIVEPATCH': starting patching transition
+livepatch: '$MOD_LIVEPATCH': completing patching transition
+livepatch: '$MOD_LIVEPATCH': patching complete
+% echo 0 > $SYSFS_KLP_DIR/$MOD_LIVEPATCH/enabled
+livepatch: '$MOD_LIVEPATCH': initializing unpatching transition
+livepatch: '$MOD_LIVEPATCH': starting unpatching transition
+livepatch: '$MOD_LIVEPATCH': completing unpatching transition
+livepatch: '$MOD_LIVEPATCH': unpatching complete
+% rmmod $MOD_LIVEPATCH"
+
+exit 0
diff --git a/tools/testing/selftests/livepatch/test-sysfs.sh b/tools/testing/selftests/livepatch/test-sysfs.sh
index 58fe1d96997cd..0865a7959496a 100755
--- a/tools/testing/selftests/livepatch/test-sysfs.sh
+++ b/tools/testing/selftests/livepatch/test-sysfs.sh
@@ -20,7 +20,6 @@ check_sysfs_rights "$MOD_LIVEPATCH" "" "drwxr-xr-x"
 check_sysfs_rights "$MOD_LIVEPATCH" "enabled" "-rw-r--r--"
 check_sysfs_value  "$MOD_LIVEPATCH" "enabled" "1"
 check_sysfs_rights "$MOD_LIVEPATCH" "force" "--w-------"
-check_sysfs_rights "$MOD_LIVEPATCH" "replace" "-r--r--r--"
 check_sysfs_rights "$MOD_LIVEPATCH" "stack_order" "-r--r--r--"
 check_sysfs_value  "$MOD_LIVEPATCH" "stack_order" "1"
 check_sysfs_rights "$MOD_LIVEPATCH" "transition" "-r--r--r--"
@@ -88,53 +87,6 @@ test_klp_callbacks_demo: post_unpatch_callback: vmlinux
 livepatch: 'test_klp_callbacks_demo': unpatching complete
 % rmmod test_klp_callbacks_demo"
 
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
-
 start_test "sysfs test stack_order value"
 
 load_lp $MOD_LIVEPATCH

-- 
2.52.0


