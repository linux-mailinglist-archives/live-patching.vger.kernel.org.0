Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C16814A912C
	for <lists+live-patching@lfdr.de>; Fri,  4 Feb 2022 00:32:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355990AbiBCXcu (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 3 Feb 2022 18:32:50 -0500
Received: from mail-qt1-f175.google.com ([209.85.160.175]:40661 "EHLO
        mail-qt1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238196AbiBCXcu (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 3 Feb 2022 18:32:50 -0500
Received: by mail-qt1-f175.google.com with SMTP id v5so4325231qto.7;
        Thu, 03 Feb 2022 15:32:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lgYpmcza1wXVQl4qbo8bJCu4YvrZ/+INkQLGcdeKuAc=;
        b=6AQQkgcea/bIUxx9cM4H9UFj6oJsCk0Oc6tL5pMn/waAop+oooWKpJFm35AHQ67wHI
         8MuxgZACs6cpSpZ9mIY9qmgp960onSm3jfFL0/iBu+tHI1VDEgG+vuIHtsc4NkRukWcL
         uvpi3meoURKz45E9DOf9XG4JLTHDsTA7/7Tt+QxgT/6BuK24usv7nrPVXpeiZR+FIPg1
         eaVvlZdHAqGOuhlnOubwiciWffb9ZnL8dooES9OEFiVKG9cBK4abET07wnUL76KBIjXy
         ukVVpg9xxC2JMOzvoU2u/Z3k46LSGpvgZeP4Ad5NmG6R81/l1kduNZQp+O4cHHRJFCNc
         vFCg==
X-Gm-Message-State: AOAM531A+tHJefPDBIgKnzsrLboVdGAeUin/EvNNowqF0BMBn2Pqv6TE
        TdsXI3zjjDHjWVheqSUImLQnSocPUSap4Q==
X-Google-Smtp-Source: ABdhPJyKIAEBjvo3JiReMJ56ZoPw0Uoh2nFeoCFY6j/MDcfdQ1lJ9LxrJ8YykAVxA0s1AdIR1dhZ3g==
X-Received: by 2002:ac8:5a0b:: with SMTP id n11mr366810qta.648.1643931169243;
        Thu, 03 Feb 2022 15:32:49 -0800 (PST)
Received: from localhost (fwdproxy-ash-016.fbsv.net. [2a03:2880:20ff:10::face:b00c])
        by smtp.gmail.com with ESMTPSA id g20sm181745qko.27.2022.02.03.15.32.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Feb 2022 15:32:48 -0800 (PST)
From:   David Vernet <void@manifault.com>
To:     live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        jpoimboe@redhat.com, pmladek@suse.com, jikos@kernel.org,
        mbenes@suse.cz, joe.lawrence@redhat.com, corbet@lwn.net
Cc:     void@manifault.com, kernel-team@fb.com
Subject: [PATCH] livepatch: Skip livepatch tests if ftrace cannot be configured
Date:   Thu,  3 Feb 2022 15:32:07 -0800
Message-Id: <20220203233205.1554034-1-void@manifault.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
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
control, this patch adds a check to set_ftrace_enabled() to skip the tests
if the sysctl invocation fails.

Signed-off-by: David Vernet <void@manifault.com>
---
 tools/testing/selftests/livepatch/functions.sh | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/tools/testing/selftests/livepatch/functions.sh b/tools/testing/selftests/livepatch/functions.sh
index 846c7ed71556..6857fdcb6b45 100644
--- a/tools/testing/selftests/livepatch/functions.sh
+++ b/tools/testing/selftests/livepatch/functions.sh
@@ -78,6 +78,12 @@ function set_ftrace_enabled() {
 	result=$(sysctl -q kernel.ftrace_enabled="$1" 2>&1 && \
 		 sysctl kernel.ftrace_enabled 2>&1)
 	echo "livepatch: $result" > /dev/kmsg
+	# Skip the test if ftrace is busy.  This can happen under normal system
+	# conditions if a trace is marked as permament.
+	if [[ "$result" == *"Device or resource busy"* ]]; then
+		skip "failed to set kernel.ftrace_enabled=$1"
+	fi
+
 }
 
 function cleanup() {
-- 
2.30.2

