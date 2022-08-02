Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD5E25874F6
	for <lists+live-patching@lfdr.de>; Tue,  2 Aug 2022 03:09:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231518AbiHBBJN convert rfc822-to-8bit (ORCPT
        <rfc822;lists+live-patching@lfdr.de>); Mon, 1 Aug 2022 21:09:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230203AbiHBBJM (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 1 Aug 2022 21:09:12 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8A9E32D90
        for <live-patching@vger.kernel.org>; Mon,  1 Aug 2022 18:09:11 -0700 (PDT)
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 271NFlD3031507
        for <live-patching@vger.kernel.org>; Mon, 1 Aug 2022 18:09:11 -0700
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3hn3y3f783-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <live-patching@vger.kernel.org>; Mon, 01 Aug 2022 18:09:11 -0700
Received: from twshared34609.14.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Mon, 1 Aug 2022 18:09:08 -0700
Received: by devbig932.frc1.facebook.com (Postfix, from userid 4523)
        id 3B94BB034346; Mon,  1 Aug 2022 18:09:04 -0700 (PDT)
From:   Song Liu <song@kernel.org>
To:     <live-patching@vger.kernel.org>
CC:     <jpoimboe@kernel.org>, <jikos@kernel.org>, <mbenes@suse.cz>,
        <pmladek@suse.com>, <joe.lawrence@redhat.com>,
        <kernel-team@fb.com>, Song Liu <song@kernel.org>
Subject: [PATCH v2 2/2] selftests/livepatch: add sysfs test
Date:   Mon, 1 Aug 2022 18:08:57 -0700
Message-ID: <20220802010857.3574103-3-song@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220802010857.3574103-1-song@kernel.org>
References: <20220802010857.3574103-1-song@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: A_5xLq79mKXyixKjIjRFQiqCOH61lVBI
X-Proofpoint-GUID: A_5xLq79mKXyixKjIjRFQiqCOH61lVBI
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-01_12,2022-08-01_01,2022-06-22_01
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Add a test for livepatch sysfs entries.

Signed-off-by: Song Liu <song@kernel.org>
---
 tools/testing/selftests/livepatch/Makefile    |  3 +-
 .../testing/selftests/livepatch/test-sysfs.sh | 40 +++++++++++++++++++
 2 files changed, 42 insertions(+), 1 deletion(-)
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
 
diff --git a/tools/testing/selftests/livepatch/test-sysfs.sh b/tools/testing/selftests/livepatch/test-sysfs.sh
new file mode 100755
index 000000000000..eb4a69ba1c2c
--- /dev/null
+++ b/tools/testing/selftests/livepatch/test-sysfs.sh
@@ -0,0 +1,40 @@
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
+grep . "/sys/kernel/livepatch/$MOD_LIVEPATCH"/* > /dev/kmsg
+grep . "/sys/kernel/livepatch/$MOD_LIVEPATCH"/*/* > /dev/kmsg
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
+/sys/kernel/livepatch/test_klp_livepatch/enabled:1
+/sys/kernel/livepatch/test_klp_livepatch/transition:0
+/sys/kernel/livepatch/test_klp_livepatch/vmlinux/patched:1
+% echo 0 > /sys/kernel/livepatch/$MOD_LIVEPATCH/enabled
+livepatch: '$MOD_LIVEPATCH': initializing unpatching transition
+livepatch: '$MOD_LIVEPATCH': starting unpatching transition
+livepatch: '$MOD_LIVEPATCH': completing unpatching transition
+livepatch: '$MOD_LIVEPATCH': unpatching complete
+% rmmod $MOD_LIVEPATCH"
+
+exit 0
-- 
2.30.2

