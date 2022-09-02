Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1F685AB9A3
	for <lists+live-patching@lfdr.de>; Fri,  2 Sep 2022 22:53:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230214AbiIBUwg convert rfc822-to-8bit (ORCPT
        <rfc822;lists+live-patching@lfdr.de>); Fri, 2 Sep 2022 16:52:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229904AbiIBUwf (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 2 Sep 2022 16:52:35 -0400
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2D24FE049
        for <live-patching@vger.kernel.org>; Fri,  2 Sep 2022 13:52:33 -0700 (PDT)
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.17.1.5/8.17.1.5) with ESMTP id 282JMv8e019529
        for <live-patching@vger.kernel.org>; Fri, 2 Sep 2022 13:52:33 -0700
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0001303.ppops.net (PPS) with ESMTPS id 3jaur6jh85-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <live-patching@vger.kernel.org>; Fri, 02 Sep 2022 13:52:33 -0700
Received: from twshared25017.14.frc2.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:11d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 2 Sep 2022 13:52:31 -0700
Received: by devbig932.frc1.facebook.com (Postfix, from userid 4523)
        id 5F170C63D6AF; Fri,  2 Sep 2022 13:52:19 -0700 (PDT)
From:   Song Liu <song@kernel.org>
To:     <live-patching@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <jpoimboe@kernel.org>, <jikos@kernel.org>, <mbenes@suse.cz>,
        <pmladek@suse.com>, <joe.lawrence@redhat.com>,
        Song Liu <song@kernel.org>
Subject: [PATCH v3 2/2] selftests/livepatch: add sysfs test
Date:   Fri, 2 Sep 2022 13:52:08 -0700
Message-ID: <20220902205208.3117798-3-song@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220902205208.3117798-1-song@kernel.org>
References: <20220902205208.3117798-1-song@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: 7E6BINzTA1Z0RyDfFeTGSZMs64viRsLI
X-Proofpoint-GUID: 7E6BINzTA1Z0RyDfFeTGSZMs64viRsLI
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-09-02_05,2022-08-31_03,2022-06-22_01
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Add a test for livepatch sysfs entries.

Signed-off-by: Song Liu <song@kernel.org>
---
 tools/testing/selftests/livepatch/Makefile    |  3 +-
 .../testing/selftests/livepatch/functions.sh  | 34 ++++++++
 .../testing/selftests/livepatch/test-sysfs.sh | 86 +++++++++++++++++++
 3 files changed, 122 insertions(+), 1 deletion(-)
 create mode 100755 tools/testing/selftests/livepatch/test-sysfs.sh

diff --git a/tools/testing/selftests/livepatch/Makefile b/tools/testing/selftests/livepatch/Makefile
index 1acc9e1fa3fb..02fadc9d55e0 100644
--- a/tools/testing/selftests/livepatch/Makefile
+++ b/tools/testing/selftests/livepatch/Makefile
@@ -6,7 +6,8 @@ TEST_PROGS := \
 	test-callbacks.sh \
 	test-shadow-vars.sh \
 	test-state.sh \
-	test-ftrace.sh
+	test-ftrace.sh \
+	test-sysfs.sh
 
 TEST_FILES := settings
 
diff --git a/tools/testing/selftests/livepatch/functions.sh b/tools/testing/selftests/livepatch/functions.sh
index 9230b869371d..433e23dd9dcb 100644
--- a/tools/testing/selftests/livepatch/functions.sh
+++ b/tools/testing/selftests/livepatch/functions.sh
@@ -6,6 +6,7 @@
 
 MAX_RETRIES=600
 RETRY_INTERVAL=".1"	# seconds
+KLP_SYSFS_DIR="/sys/kernel/livepatch"
 
 # Kselftest framework requirement - SKIP code is 4
 ksft_skip=4
@@ -308,3 +309,36 @@ function check_result {
 
 	cleanup_dmesg_file
 }
+
+# check_sysfs_rights(modname, rel_path, expected_rights) - check sysfs
+# path permissions
+#	modname - livepatch module creating the sysfs interface
+#	rel_path - relative path of the sysfs interface
+#	expected_rights - expected access rights
+function check_sysfs_rights() {
+	local mod="$1"; shift
+	local rel_path="$1"; shift
+	local expected_rights="$1"; shift
+
+	local path="$KLP_SYSFS_DIR/$mod/$rel_path"
+	local rights=$(/bin/stat --format '%A' "$path")
+	if test "$rights" != "$expected_rights" ; then
+		die "Unexpected access rights of $path: $expected_rights vs. $rights"
+	fi
+}
+
+# check_sysfs_value(modname, rel_path, expected_value) - check sysfs value
+#	modname - livepatch module creating the sysfs interface
+#	rel_path - relative path of the sysfs interface
+#	expected_value - expected value read from the file
+function check_sysfs_value() {
+	local mod="$1"; shift
+	local rel_path="$1"; shift
+	local expected_value="$1"; shift
+
+	local path="$KLP_SYSFS_DIR/$mod/$rel_path"
+	local value=`cat $path`
+	if test "$value" != "$expected_value" ; then
+		die "Unexpected value in $path: $expected_value vs. $value"
+	fi
+}
diff --git a/tools/testing/selftests/livepatch/test-sysfs.sh b/tools/testing/selftests/livepatch/test-sysfs.sh
new file mode 100755
index 000000000000..7f76f280189a
--- /dev/null
+++ b/tools/testing/selftests/livepatch/test-sysfs.sh
@@ -0,0 +1,86 @@
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
+# - load a livepatch and verifies the sysfs entries work as expected
+
+start_test "sysfs test"
+
+load_lp $MOD_LIVEPATCH
+
+check_sysfs_rights "$MOD_LIVEPATCH" "" "drwxr-xr-x"
+check_sysfs_rights "$MOD_LIVEPATCH" "enabled" "-rw-r--r--"
+check_sysfs_value  "$MOD_LIVEPATCH" "enabled" "1"
+check_sysfs_rights "$MOD_LIVEPATCH" "force" "--w-------"
+check_sysfs_rights "$MOD_LIVEPATCH" "transition" "-r--r--r--"
+check_sysfs_value  "$MOD_LIVEPATCH" "transition" "0"
+check_sysfs_rights "$MOD_LIVEPATCH" "vmlinux/patched" "-r--r--r--"
+check_sysfs_value  "$MOD_LIVEPATCH" "vmlinux/patched" "1"
+
+disable_lp $MOD_LIVEPATCH
+
+unload_lp $MOD_LIVEPATCH
+
+check_result "% modprobe $MOD_LIVEPATCH
+livepatch: enabling patch '$MOD_LIVEPATCH'
+livepatch: '$MOD_LIVEPATCH': initializing patching transition
+livepatch: '$MOD_LIVEPATCH': starting patching transition
+livepatch: '$MOD_LIVEPATCH': completing patching transition
+livepatch: '$MOD_LIVEPATCH': patching complete
+% echo 0 > /sys/kernel/livepatch/$MOD_LIVEPATCH/enabled
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
+check_result "% modprobe test_klp_callbacks_demo
+livepatch: enabling patch 'test_klp_callbacks_demo'
+livepatch: 'test_klp_callbacks_demo': initializing patching transition
+test_klp_callbacks_demo: pre_patch_callback: vmlinux
+livepatch: 'test_klp_callbacks_demo': starting patching transition
+livepatch: 'test_klp_callbacks_demo': completing patching transition
+test_klp_callbacks_demo: post_patch_callback: vmlinux
+livepatch: 'test_klp_callbacks_demo': patching complete
+% modprobe test_klp_callbacks_mod
+livepatch: applying patch 'test_klp_callbacks_demo' to loading module 'test_klp_callbacks_mod'
+test_klp_callbacks_demo: pre_patch_callback: test_klp_callbacks_mod -> [MODULE_STATE_COMING] Full formed, running module_init
+test_klp_callbacks_demo: post_patch_callback: test_klp_callbacks_mod -> [MODULE_STATE_COMING] Full formed, running module_init
+test_klp_callbacks_mod: test_klp_callbacks_mod_init
+% rmmod test_klp_callbacks_mod
+test_klp_callbacks_mod: test_klp_callbacks_mod_exit
+test_klp_callbacks_demo: pre_unpatch_callback: test_klp_callbacks_mod -> [MODULE_STATE_GOING] Going away
+livepatch: reverting patch 'test_klp_callbacks_demo' on unloading module 'test_klp_callbacks_mod'
+test_klp_callbacks_demo: post_unpatch_callback: test_klp_callbacks_mod -> [MODULE_STATE_GOING] Going away
+% echo 0 > /sys/kernel/livepatch/test_klp_callbacks_demo/enabled
+livepatch: 'test_klp_callbacks_demo': initializing unpatching transition
+test_klp_callbacks_demo: pre_unpatch_callback: vmlinux
+livepatch: 'test_klp_callbacks_demo': starting unpatching transition
+livepatch: 'test_klp_callbacks_demo': completing unpatching transition
+test_klp_callbacks_demo: post_unpatch_callback: vmlinux
+livepatch: 'test_klp_callbacks_demo': unpatching complete
+% rmmod test_klp_callbacks_demo"
+
+exit 0
-- 
2.30.2

