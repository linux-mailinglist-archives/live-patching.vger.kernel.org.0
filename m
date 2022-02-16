Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72AF54B8D9B
	for <lists+live-patching@lfdr.de>; Wed, 16 Feb 2022 17:13:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234566AbiBPQN6 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 16 Feb 2022 11:13:58 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:60310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236177AbiBPQNy (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 16 Feb 2022 11:13:54 -0500
Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com [209.85.219.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9325E1F6B91;
        Wed, 16 Feb 2022 08:13:41 -0800 (PST)
Received: by mail-qv1-f41.google.com with SMTP id p7so2766105qvk.11;
        Wed, 16 Feb 2022 08:13:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=azl/iLsb26myp3zpwyeRv5JZYujJh0LXxE2G7XtXIR8=;
        b=ZlI6F6ExorJPmowwEofDsxizZXSD4b+rtVpSdBigUkE8c6NnxouQ222XUwPOjpUkms
         b+hO+m0ixieNNJbrWhlZ0Acd0KICXpNjn5rNxLJwrMzIsHwAzMUmwvW9gW9D4Y4wH1vE
         P1Ky6g20NDOPhfXQn/PXKHnttIBF9X8P+WfQP4i8OXb/taIo2SDxV0YnaV/vUiHZa3e9
         4yk5A2t2+QIGQvLmcS9X5RqBS3eMfXvmRSuFZJQO9sav1IdC97W9FhExWi9RZ2rdMug9
         crLS2JOFMhPLCUTw1gaSdLwInGIHSRTWdzO/Xy6jSYTK5I9J+/HsshsF4zvnank2nwEq
         cU6A==
X-Gm-Message-State: AOAM533+Ua4s1SNaDyTtuByUPkMI4CL3N453Z19qJKl0xCfkG9P/PZPv
        JApBx6JF8/LGvSGHr2081h/XSWlmsTCdzg==
X-Google-Smtp-Source: ABdhPJyGH0FygRPJsxuUBPWKFoFaQdmcFa2SP2guTbMOLt2/LvJ9Z/RVSzok6rD0gGaujjxNiwM3bQ==
X-Received: by 2002:a05:622a:196:b0:2ce:c222:b601 with SMTP id s22-20020a05622a019600b002cec222b601mr2507862qtw.179.1645028020167;
        Wed, 16 Feb 2022 08:13:40 -0800 (PST)
Received: from localhost (fwdproxy-ash-024.fbsv.net. [2a03:2880:20ff:18::face:b00c])
        by smtp.gmail.com with ESMTPSA id e9sm22957221qtx.37.2022.02.16.08.13.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Feb 2022 08:13:38 -0800 (PST)
From:   David Vernet <void@manifault.com>
To:     live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        jpoimboe@redhat.com, pmladek@suse.com, jikos@kernel.org,
        mbenes@suse.cz, joe.lawrence@redhat.com, corbet@lwn.net
Cc:     void@manifault.com, kernel-team@fb.com
Subject: [PATCH v3] livepatch: Skip livepatch tests if ftrace cannot be configured
Date:   Wed, 16 Feb 2022 08:11:01 -0800
Message-Id: <20220216161100.3243100-1-void@manifault.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

livepatch has a set of selftests that are used to validate the behavior of
the livepatching subsystem.  One of the testcases in the livepatch
testsuite is test-ftrace.sh, which among other things, validates that
livepatching gracefully fails when ftrace is disabled.  In the event that
ftrace cannot be disabled using 'sysctl kernel.ftrace_enabled=0', the test
will fail later due to it unexpectedly successfully loading the
test_klp_livepatch module.

While the livepatch selftests are careful to remove any of the livepatch
test modules between testcases to avoid this situation, ftrace may still
fail to be disabled if another trace is active on the system that was
enabled with FTRACE_OPS_FL_PERMANENT.  For example, any active BPF programs
that use trampolines will cause this test to fail due to the trampoline
being implemented with register_ftrace_direct().  The following is an
example of such a trace:

tcp_drop (1) R I D      tramp: ftrace_regs_caller+0x0/0x58
(call_direct_funcs+0x0/0x30)
        direct-->bpf_trampoline_6442550536_0+0x0/0x1000

In order to make the test more resilient to system state that is out of its
control, this patch updates set_ftrace_enabled() to detect sysctl failures,
and skip the testrun when appropriate.

Suggested-by: Petr Mladek <pmladek@suse.com>
Signed-off-by: David Vernet <void@manifault.com>
---
v3:
  - Fixed a bug in v1 and v2 pointed out by Petr in
    https://lore.kernel.org/all/20220209154934.5w5k5tqcqldbfjt3@dev0025.ash9.facebook.com/
    wherein we'd incorrectly skip() in test-ftrace.sh when we expected to
    fail to set sysctl due to ftrace being in-use by livepatch.
  - Applied Petr's suggestions for the patch, which address the
    aforementioned issue by adding a --fail flag to set_ftrace_enabled().
    This allows callers to signal that they expect an invocation to fail.
  - Updates the caller in test-ftrace.sh that expects the call to
    set_ftrace_enabled() to fail, to pass this --fail flag.
  - Slightly updates the commit summary to reflect that we only skip the
    test "when appropriate" rather than if the call to sysctl fails.

v2:
  - Fix typo in newly added comment (s/permament/permanent).
  - Adjust the location of the added newline to be before the new comment
    rather than that the end of the function.
  - Make the failure-path check a bit less brittle by checking for the
    exact expected string, rather than specifically for "Device or resource
    busy".

 .../testing/selftests/livepatch/functions.sh  | 22 ++++++++++++++++---
 .../selftests/livepatch/test-ftrace.sh        |  3 ++-
 2 files changed, 21 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/livepatch/functions.sh b/tools/testing/selftests/livepatch/functions.sh
index 846c7ed71556..9230b869371d 100644
--- a/tools/testing/selftests/livepatch/functions.sh
+++ b/tools/testing/selftests/livepatch/functions.sh
@@ -75,9 +75,25 @@ function set_dynamic_debug() {
 }
 
 function set_ftrace_enabled() {
-	result=$(sysctl -q kernel.ftrace_enabled="$1" 2>&1 && \
-		 sysctl kernel.ftrace_enabled 2>&1)
-	echo "livepatch: $result" > /dev/kmsg
+	local can_fail=0
+	if [[ "$1" == "--fail" ]] ; then
+		can_fail=1
+		shift
+	fi
+
+	local err=$(sysctl -q kernel.ftrace_enabled="$1" 2>&1)
+	local result=$(sysctl --values kernel.ftrace_enabled)
+
+	if [[ "$result" != "$1" ]] ; then
+		if [[ $can_fail -eq 1 ]] ; then
+			echo "livepatch: $err" > /dev/kmsg
+			return
+		fi
+
+		skip "failed to set kernel.ftrace_enabled = $1"
+	fi
+
+	echo "livepatch: kernel.ftrace_enabled = $result" > /dev/kmsg
 }
 
 function cleanup() {
diff --git a/tools/testing/selftests/livepatch/test-ftrace.sh b/tools/testing/selftests/livepatch/test-ftrace.sh
index 552e165512f4..825540a5194d 100755
--- a/tools/testing/selftests/livepatch/test-ftrace.sh
+++ b/tools/testing/selftests/livepatch/test-ftrace.sh
@@ -25,7 +25,8 @@ if [[ "$(cat /proc/cmdline)" != "$MOD_LIVEPATCH: this has been live patched" ]]
 	die "livepatch kselftest(s) failed"
 fi
 
-set_ftrace_enabled 0
+# Check that ftrace could not get disabled when a livepatch is enabled
+set_ftrace_enabled --fail 0
 if [[ "$(cat /proc/cmdline)" != "$MOD_LIVEPATCH: this has been live patched" ]] ; then
 	echo -e "FAIL\n\n"
 	die "livepatch kselftest(s) failed"
-- 
2.30.2

