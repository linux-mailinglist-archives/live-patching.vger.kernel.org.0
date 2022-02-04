Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DD874AA177
	for <lists+live-patching@lfdr.de>; Fri,  4 Feb 2022 21:57:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233567AbiBDU5F (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 4 Feb 2022 15:57:05 -0500
Received: from mail-qv1-f42.google.com ([209.85.219.42]:40579 "EHLO
        mail-qv1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232318AbiBDU5F (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 4 Feb 2022 15:57:05 -0500
Received: by mail-qv1-f42.google.com with SMTP id e20so6329418qvu.7;
        Fri, 04 Feb 2022 12:57:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tOktSJdsPyS4iLL9pxhiI0gDV+7BgjlNV1/kPM9c6Us=;
        b=F592MT/13X4IBH39Xqhm1qQWGvcKv5KAG8b1RiLgm/qsw8AzGcki0zGjkGRYSsxvqD
         ExZf3mPZ6QflL6tGune1RnpzLdvMsIrlzrbQEGqb9nhIuZ/YiJB6hxQ6wcs/t3iniBfW
         AnfY8NhtNv90SvGvzJg6AZaGB2jIei0GuYIOkK2hWRP4zWmM8s1kcKKfy8Vje5d5E5RI
         vG0oAp4jn5qUApdDsWvxnVN9ecNf6TGOIpctSxJQiMyBgBb0xAVCfX1xyUbJWMmeNfC1
         ndBawtg4taHaIPZFbyLKw6jmdrNO50v1/6ZvkHpkKSAOZIWzOHMFEWVgUqr2ZwtQKjWj
         xKeg==
X-Gm-Message-State: AOAM532/tUrGLtu96EUR4wGHRimwts1B1tPBXp8Tm1ObpW0p2wOlPO12
        sEVn6lrI2/dDeiUvN6JED468ofXWE78B2A==
X-Google-Smtp-Source: ABdhPJwIwK6ccRrYu/Hr3BIPks61h8YSYyB+TtDp0At+LYgbbcDKHG43yNs7GBbnJ9tl/6627HEzEw==
X-Received: by 2002:ad4:5b88:: with SMTP id 8mr988632qvp.1.1644008224046;
        Fri, 04 Feb 2022 12:57:04 -0800 (PST)
Received: from localhost (fwdproxy-ash-010.fbsv.net. [2a03:2880:20ff:a::face:b00c])
        by smtp.gmail.com with ESMTPSA id p134sm1474570qke.29.2022.02.04.12.57.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Feb 2022 12:57:03 -0800 (PST)
From:   David Vernet <void@manifault.com>
To:     live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        jpoimboe@redhat.com, pmladek@suse.com, jikos@kernel.org,
        mbenes@suse.cz, joe.lawrence@redhat.com, corbet@lwn.net
Cc:     void@manifault.com, kernel-team@fb.com
Subject: [PATCH v2] livepatch: Skip livepatch tests if ftrace cannot be configured
Date:   Fri,  4 Feb 2022 12:56:26 -0800
Message-Id: <20220204205625.2628328-1-void@manifault.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220203233205.1554034-1-void@manifault.com>
References: <20220203233205.1554034-1-void@manifault.com>
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
v2:
  - Fix typo in newly added comment (s/permament/permanent).
  - Adjust the location of the added newline to be before the new comment
    rather than that the end of the function.
  - Make the failure-path check a bit less brittle by checking for the
    exact expected string, rather than specifically for "Device or resource
    busy".

 tools/testing/selftests/livepatch/functions.sh | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/tools/testing/selftests/livepatch/functions.sh b/tools/testing/selftests/livepatch/functions.sh
index 846c7ed71556..32970324dd7e 100644
--- a/tools/testing/selftests/livepatch/functions.sh
+++ b/tools/testing/selftests/livepatch/functions.sh
@@ -78,6 +78,12 @@ function set_ftrace_enabled() {
 	result=$(sysctl -q kernel.ftrace_enabled="$1" 2>&1 && \
 		 sysctl kernel.ftrace_enabled 2>&1)
 	echo "livepatch: $result" > /dev/kmsg
+
+	# Skip the test if ftrace is busy.  This can happen under normal system
+	# conditions if a trace is marked as permanent.
+	if [[ "$result" != "kernel.ftrace_enabled = $1" ]]; then
+		skip "failed to set kernel.ftrace_enabled=$1"
+	fi
 }
 
 function cleanup() {
-- 
2.30.2

