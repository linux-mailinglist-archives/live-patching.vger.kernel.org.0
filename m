Return-Path: <live-patching+bounces-2204-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 0KVKEuZ6tGmOogAAu9opvQ
	(envelope-from <live-patching+bounces-2204-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Fri, 13 Mar 2026 22:00:22 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id E11E7289F8C
	for <lists+live-patching@lfdr.de>; Fri, 13 Mar 2026 22:00:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 711793090207
	for <lists+live-patching@lfdr.de>; Fri, 13 Mar 2026 20:59:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E66E03D5674;
	Fri, 13 Mar 2026 20:59:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="RzDVTsBb"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B85973D5665
	for <live-patching@vger.kernel.org>; Fri, 13 Mar 2026 20:59:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773435558; cv=none; b=JRTi/gSPvyFMufU43TI3FYBf/aPhinHQZ9yXIbe3oOEDABoiZk4wN5es7/mC6c3KNeXZgdwSb7n+FhIoV2fjv1qejhF99E+VlEvvOGeGp9WbOyH/al5H4jHR1aYScHXBwiyumvuRJkLd1fHhUXObcUBGJHAygwcj/iVhRwkYbcQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773435558; c=relaxed/simple;
	bh=7miD+iiagzq5C2pRyxmlazC6IojzoSp0vrZTCyoeCrc=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=BAvULu8mligz1Jwj3cyMOZfhIQCrcVT+3Yw09F2gXP+GoAHtb8pyk0aQwkUz5Ov8woUy84lpRI9P7j+PdkZfv5B5bF5zRHMF2fWaQcBJ4OmmbjluAKwxuVcfp1h+usAZlymQVqTQDcqX68Dv1FdkOwpsHMk7eQHIJRv6IHzsG5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=RzDVTsBb; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4853e1ce427so29423395e9.3
        for <live-patching@vger.kernel.org>; Fri, 13 Mar 2026 13:59:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1773435552; x=1774040352; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CtpindbIzqkRgW7Z2vVcHsOf0RGWeyCQynvMr4lGYeE=;
        b=RzDVTsBb4+kQ4+bDTyzmjLlcHSSoP9B8q6WireKq4OM1N4oQzwSYLdL3HhfbM9H+Qz
         eKbEfuH2DJss0wJE/k6OWjZbW4ECo2LFRBWPFsW7EQf+37BbAAz8Ki2buija+fWMPv01
         niOV7riQGMzsPK7IP7p+YKqhD3QRH8H1YJc+oBta5t9+jutVY2VEjh4X900fmz917FMX
         w5sh/LzNxXQT3U4fvnV3U7EiZhhM3l1tzBmkLo/FDBd3Fc8f7D8GluJ380UFAJ2KB+21
         6MncctgOPIrpzrP0QJ8fKkXkrQE3fF3c51mDCoGVGVWkfe+qUzhSxA/8vJ8gaAgtBU+g
         dshQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773435552; x=1774040352;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=CtpindbIzqkRgW7Z2vVcHsOf0RGWeyCQynvMr4lGYeE=;
        b=EC1Q977ylUD/vHPn82zyxgTQ06zukaI7S9A3AwpC0Wu3H76ETK6kNV0umgHCsqiBh/
         biB60kEAbuksKBKrY1+RrXRPO6ogfl6R6ttgcmxM6MWPHyWz9eEKq4kAzdXoPRF996WS
         Jq5bAVmkftlEHlUESwCkn35WNK98DE3DLRpF+A/3Ve48dNqQnShC3yLSFGgizajF1bBi
         wZs9+mUsaRUkQWp6PXvBKpU0pBountSY3JKrMnB6U6hdqyECx52ipHHygupzdfY4rSTr
         intb+ohZGWeg19MYABGJ+4sGSAg+Sxsq/I+SmMdx4hzw0DZOFaurbMBQFklVSbc3eNHl
         ExVw==
X-Gm-Message-State: AOJu0YwVEveAHMBS+7WQrhlFFGP7+Ees8RoAj/4yXo3L2VFcEO9JWJ/y
	3e03JzcAHT/WugSYLXVI6qjhLzldrQR5N25nKB7Hs0AjgDC2upzNeHs+s6RWOv727+w=
X-Gm-Gg: ATEYQzzGuK62MalONBtjnZgwmLcjJOuHwvwZMI7ZAhtPSL0FffPnux8Obtbv7HcjkT9
	cacjsrSRFhfadL19DT8NDWYdyBsroo3c8AOPetbO6up9jvBoenm7pIhat1JQdyLHsERsOmqqpy7
	uSXl0gJGmCErRzPlK01h1A7yWUo4dPkvO2dp+H/YT08x1KEkeqjlX0AaYViZmWCEc54c0hwMOh6
	SszhyLo3SBoWCm7KTRjcldLGU554JN9houXD+Q7XG9cawi3XKM6/sd+wufKYA1LaM8cZ/9SKzJW
	kCEnQN6EsktTqxa6Hyvh86G9QZBJ+f2K3q+6txTAVtoYuk7VXvMiXZVaSzTLgWDmMrHI+knbfoS
	gyZPVLaljkFrEjRp0vhQdLWe9yyZeQ1+xa88RwZG5G7fWxmYR5VEdnOXMqLsNva4ZklWcFfxLxo
	+wXStJC6EKaUNDekoI5C7N
X-Received: by 2002:a05:600c:4f8f:b0:485:40c6:f507 with SMTP id 5b1f17b1804b1-48556711c6cmr83526535e9.30.1773435551766;
        Fri, 13 Mar 2026 13:59:11 -0700 (PDT)
Received: from [127.0.0.1] ([2804:5078:834:1300:58f2:fc97:371f:3])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2beab526d3csm4042611eec.18.2026.03.13.13.59.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Mar 2026 13:59:10 -0700 (PDT)
From: Marcos Paulo de Souza <mpdesouza@suse.com>
Date: Fri, 13 Mar 2026 17:58:38 -0300
Subject: [PATCH 7/8] selftests: livepatch: sysfs: Split tests of patched
 attribute
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260313-lp-tests-old-fixes-v1-7-71ac6dfb3253@suse.com>
References: <20260313-lp-tests-old-fixes-v1-0-71ac6dfb3253@suse.com>
In-Reply-To: <20260313-lp-tests-old-fixes-v1-0-71ac6dfb3253@suse.com>
To: Josh Poimboeuf <jpoimboe@kernel.org>, Jiri Kosina <jikos@kernel.org>, 
 Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>, 
 Joe Lawrence <joe.lawrence@redhat.com>, Shuah Khan <shuah@kernel.org>
Cc: live-patching@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Marcos Paulo de Souza <mpdesouza@suse.com>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1773435515; l=8340;
 i=mpdesouza@suse.com; s=20231031; h=from:subject:message-id;
 bh=7miD+iiagzq5C2pRyxmlazC6IojzoSp0vrZTCyoeCrc=;
 b=uqFFQEX3HHu+zZW7rPQBC5tgv3eZjksDN3DnrZZTJSoo2WkJagFHOjl28pWkfB32qKuM46tb1
 cUCGhosNsX3CVCG+M5/SA0H3NlXSuYSkLfbexViZpdixDx9EgM6z4Gi
X-Developer-Key: i=mpdesouza@suse.com; a=ed25519;
 pk=/Ni/TsKkr69EOmdZXkp1Q/BlzDonbOBRsfPa18ySIwU=
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[suse.com,quarantine];
	R_DKIM_ALLOW(-0.20)[suse.com:s=google];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DKIM_TRACE(0.00)[suse.com:+];
	TAGGED_FROM(0.00)[bounces-2204-lists,live-patching=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	NEURAL_HAM(-0.00)[-0.998];
	RCPT_COUNT_SEVEN(0.00)[10];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:dkim,suse.com:email,suse.com:mid,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,test-sysfs-patched-attr.sh:url]
X-Rspamd-Queue-Id: E11E7289F8C
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

In order to run the selftests on older kernels, split the sysfs tests to
another file, making it able to skip the tests when the attributes
don't exists.

No functional changes.

Signed-off-by: Marcos Paulo de Souza <mpdesouza@suse.com>
---
 tools/testing/selftests/livepatch/Makefile         |  1 +
 .../selftests/livepatch/test-sysfs-patched-attr.sh | 95 ++++++++++++++++++++++
 tools/testing/selftests/livepatch/test-sysfs.sh    | 45 ----------
 3 files changed, 96 insertions(+), 45 deletions(-)

diff --git a/tools/testing/selftests/livepatch/Makefile b/tools/testing/selftests/livepatch/Makefile
index 1982056670fc2..31ca4669b6ae7 100644
--- a/tools/testing/selftests/livepatch/Makefile
+++ b/tools/testing/selftests/livepatch/Makefile
@@ -12,6 +12,7 @@ TEST_PROGS := \
 	test-sysfs.sh \
 	test-sysfs-replace-attr.sh \
 	test-sysfs-stack-attr.sh \
+	test-sysfs-patched-attr.sh \
 	test-syscall.sh \
 	test-kprobe.sh
 
diff --git a/tools/testing/selftests/livepatch/test-sysfs-patched-attr.sh b/tools/testing/selftests/livepatch/test-sysfs-patched-attr.sh
new file mode 100755
index 0000000000000..2cefd1159fb11
--- /dev/null
+++ b/tools/testing/selftests/livepatch/test-sysfs-patched-attr.sh
@@ -0,0 +1,95 @@
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
+# - load a livepatch and verifies the sysfs patched attribute
+
+start_test "check sysfs patched attribute"
+
+load_lp $MOD_LIVEPATCH
+
+check_sysfs_exists "$MOD_LIVEPATCH" "vmlinux/patched"
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
+start_test "check sysfs patched values"
+
+load_lp $MOD_LIVEPATCH
+
+check_sysfs_rights "$MOD_LIVEPATCH" "vmlinux/patched" "-r--r--r--"
+check_sysfs_value  "$MOD_LIVEPATCH" "vmlinux/patched" "1"
+
+disable_lp $MOD_LIVEPATCH
+
+unload_lp $MOD_LIVEPATCH
+
+check_result "% insmod test_modules/$MOD_LIVEPATCH.ko
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
+start_test "sysfs test object/patched"
+
+MOD_LIVEPATCH=test_klp_callbacks_demo
+MOD_TARGET=test_klp_callbacks_mod
+load_lp $MOD_LIVEPATCH
+
+# check the "patch" file changes as target module loads/unloads
+check_sysfs_value  "$MOD_LIVEPATCH" "$MOD_TARGET/patched" "0"
+load_mod $MOD_TARGET
+check_sysfs_value  "$MOD_LIVEPATCH" "$MOD_TARGET/patched" "1"
+unload_mod $MOD_TARGET
+check_sysfs_value  "$MOD_LIVEPATCH" "$MOD_TARGET/patched" "0"
+
+disable_lp $MOD_LIVEPATCH
+unload_lp $MOD_LIVEPATCH
+
+check_result "% insmod test_modules/test_klp_callbacks_demo.ko
+livepatch: enabling patch 'test_klp_callbacks_demo'
+livepatch: 'test_klp_callbacks_demo': initializing patching transition
+test_klp_callbacks_demo: pre_patch_callback: vmlinux
+livepatch: 'test_klp_callbacks_demo': starting patching transition
+livepatch: 'test_klp_callbacks_demo': completing patching transition
+test_klp_callbacks_demo: post_patch_callback: vmlinux
+livepatch: 'test_klp_callbacks_demo': patching complete
+% insmod test_modules/test_klp_callbacks_mod.ko
+livepatch: applying patch 'test_klp_callbacks_demo' to loading module 'test_klp_callbacks_mod'
+test_klp_callbacks_demo: pre_patch_callback: test_klp_callbacks_mod -> [MODULE_STATE_COMING] Full formed, running module_init
+test_klp_callbacks_demo: post_patch_callback: test_klp_callbacks_mod -> [MODULE_STATE_COMING] Full formed, running module_init
+test_klp_callbacks_mod: test_klp_callbacks_mod_init
+% rmmod test_klp_callbacks_mod
+test_klp_callbacks_mod: test_klp_callbacks_mod_exit
+test_klp_callbacks_demo: pre_unpatch_callback: test_klp_callbacks_mod -> [MODULE_STATE_GOING] Going away
+livepatch: reverting patch 'test_klp_callbacks_demo' on unloading module 'test_klp_callbacks_mod'
+test_klp_callbacks_demo: post_unpatch_callback: test_klp_callbacks_mod -> [MODULE_STATE_GOING] Going away
+% echo 0 > $SYSFS_KLP_DIR/test_klp_callbacks_demo/enabled
+livepatch: 'test_klp_callbacks_demo': initializing unpatching transition
+test_klp_callbacks_demo: pre_unpatch_callback: vmlinux
+livepatch: 'test_klp_callbacks_demo': starting unpatching transition
+livepatch: 'test_klp_callbacks_demo': completing unpatching transition
+test_klp_callbacks_demo: post_unpatch_callback: vmlinux
+livepatch: 'test_klp_callbacks_demo': unpatching complete
+% rmmod test_klp_callbacks_demo"
+
+exit 0
diff --git a/tools/testing/selftests/livepatch/test-sysfs.sh b/tools/testing/selftests/livepatch/test-sysfs.sh
index 3327bde59e73d..d24c13ad86124 100755
--- a/tools/testing/selftests/livepatch/test-sysfs.sh
+++ b/tools/testing/selftests/livepatch/test-sysfs.sh
@@ -20,8 +20,6 @@ check_sysfs_value  "$MOD_LIVEPATCH" "enabled" "1"
 check_sysfs_rights "$MOD_LIVEPATCH" "force" "--w-------"
 check_sysfs_rights "$MOD_LIVEPATCH" "transition" "-r--r--r--"
 check_sysfs_value  "$MOD_LIVEPATCH" "transition" "0"
-check_sysfs_rights "$MOD_LIVEPATCH" "vmlinux/patched" "-r--r--r--"
-check_sysfs_value  "$MOD_LIVEPATCH" "vmlinux/patched" "1"
 
 disable_lp $MOD_LIVEPATCH
 
@@ -40,47 +38,4 @@ livepatch: '$MOD_LIVEPATCH': completing unpatching transition
 livepatch: '$MOD_LIVEPATCH': unpatching complete
 % rmmod $MOD_LIVEPATCH"
 
-start_test "sysfs test object/patched"
-
-MOD_LIVEPATCH=test_klp_callbacks_demo
-MOD_TARGET=test_klp_callbacks_mod
-load_lp $MOD_LIVEPATCH
-
-# check the "patch" file changes as target module loads/unloads
-check_sysfs_value  "$MOD_LIVEPATCH" "$MOD_TARGET/patched" "0"
-load_mod $MOD_TARGET
-check_sysfs_value  "$MOD_LIVEPATCH" "$MOD_TARGET/patched" "1"
-unload_mod $MOD_TARGET
-check_sysfs_value  "$MOD_LIVEPATCH" "$MOD_TARGET/patched" "0"
-
-disable_lp $MOD_LIVEPATCH
-unload_lp $MOD_LIVEPATCH
-
-check_result "% insmod test_modules/test_klp_callbacks_demo.ko
-livepatch: enabling patch 'test_klp_callbacks_demo'
-livepatch: 'test_klp_callbacks_demo': initializing patching transition
-test_klp_callbacks_demo: pre_patch_callback: vmlinux
-livepatch: 'test_klp_callbacks_demo': starting patching transition
-livepatch: 'test_klp_callbacks_demo': completing patching transition
-test_klp_callbacks_demo: post_patch_callback: vmlinux
-livepatch: 'test_klp_callbacks_demo': patching complete
-% insmod test_modules/test_klp_callbacks_mod.ko
-livepatch: applying patch 'test_klp_callbacks_demo' to loading module 'test_klp_callbacks_mod'
-test_klp_callbacks_demo: pre_patch_callback: test_klp_callbacks_mod -> [MODULE_STATE_COMING] Full formed, running module_init
-test_klp_callbacks_demo: post_patch_callback: test_klp_callbacks_mod -> [MODULE_STATE_COMING] Full formed, running module_init
-test_klp_callbacks_mod: test_klp_callbacks_mod_init
-% rmmod test_klp_callbacks_mod
-test_klp_callbacks_mod: test_klp_callbacks_mod_exit
-test_klp_callbacks_demo: pre_unpatch_callback: test_klp_callbacks_mod -> [MODULE_STATE_GOING] Going away
-livepatch: reverting patch 'test_klp_callbacks_demo' on unloading module 'test_klp_callbacks_mod'
-test_klp_callbacks_demo: post_unpatch_callback: test_klp_callbacks_mod -> [MODULE_STATE_GOING] Going away
-% echo 0 > $SYSFS_KLP_DIR/test_klp_callbacks_demo/enabled
-livepatch: 'test_klp_callbacks_demo': initializing unpatching transition
-test_klp_callbacks_demo: pre_unpatch_callback: vmlinux
-livepatch: 'test_klp_callbacks_demo': starting unpatching transition
-livepatch: 'test_klp_callbacks_demo': completing unpatching transition
-test_klp_callbacks_demo: post_unpatch_callback: vmlinux
-livepatch: 'test_klp_callbacks_demo': unpatching complete
-% rmmod test_klp_callbacks_demo"
-
 exit 0

-- 
2.52.0


