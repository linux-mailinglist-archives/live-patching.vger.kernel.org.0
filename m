Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F0FC611DBE5
	for <lists+live-patching@lfdr.de>; Fri, 13 Dec 2019 02:56:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731874AbfLMB4U (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 12 Dec 2019 20:56:20 -0500
Received: from mail-io1-f68.google.com ([209.85.166.68]:36622 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731867AbfLMB4U (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 12 Dec 2019 20:56:20 -0500
Received: by mail-io1-f68.google.com with SMTP id a22so789611ios.3
        for <live-patching@vger.kernel.org>; Thu, 12 Dec 2019 17:56:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QpJgpn5xWwVD9J6P9JsUIUWPTgZ7VxyS6OWeolrkzBI=;
        b=GFzm6ZniEqoDdzO+qsDrFCn2PlIlt4Kf5CvCuVwkcCzKJHi1qzv2Rly2Hu/ARaqshP
         BKY/7qK+vmWdEZX8nyAjOe5b89WLSu9YRd2qFBRCX1htrD9vZKfQkbHZkWC7dW8B3DL/
         YKb9dlHn9T6qvm2tQMYJvxVrb5y6G9v1wPfVw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QpJgpn5xWwVD9J6P9JsUIUWPTgZ7VxyS6OWeolrkzBI=;
        b=TCF3T0u0nW9wHj2aXJowAh2LWwxri2eWgGKLjF1YveZFaT78bUGNSB6ttp2Z4BSknC
         RuXjVVLfRG4SvkBscgMrWko/jYKg9SGsmIoKNT+EsOHBU6CsnGQf4+DxgpPav+NilH+u
         yKnKtGb8jI0G7Qigg8PHxxgEW8SrZeVHLgp/WDq94N5BSiMHpqa1bIS2Mg3qSwKbk39H
         RYdHSKv0YXuGKN+RnYhgoaAamawkQDPEX1DPSUCe+KFjUMLu9n6ewhm7I7Xatt00lMEX
         O4QLLyk6VqfBU4DYLwI88k/yhhUGSRvpwrLhdMIo4h2GbCMkhYYlLSXb8iEjO2g6vOhP
         cRmQ==
X-Gm-Message-State: APjAAAW1DseINKn0c0qwewCTTQB77WpUFQRMLB1Wo5k/BWlfhMoYIQc3
        W+z+22+zjCUmoQNBm/q/8fTgz6raz6pcZw==
X-Google-Smtp-Source: APXvYqznGK3WNdNstYWfdpigO3kQ1gScdYqkS3+WOfJTJh+/XlPm0/REhsuCLncgscsqVxIXlo71sw==
X-Received: by 2002:a5e:9608:: with SMTP id a8mr5549510ioq.18.1576202179412;
        Thu, 12 Dec 2019 17:56:19 -0800 (PST)
Received: from shuah-t480s.internal (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id w28sm2274755ila.64.2019.12.12.17.56.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Dec 2019 17:56:18 -0800 (PST)
From:   Shuah Khan <skhan@linuxfoundation.org>
To:     jpoimboe@redhat.com, jikos@kernel.org, mbenes@suse.cz,
        pmladek@suse.com, joe.lawrence@redhat.com, shuah@kernel.org
Cc:     Shuah Khan <skhan@linuxfoundation.org>,
        live-patching@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] selftests: livepatch: Fix it to do root uid check and skip
Date:   Thu, 12 Dec 2019 18:56:17 -0700
Message-Id: <20191213015617.23110-1-skhan@linuxfoundation.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

livepatch test configures the system and debug environment to run
tests. Some of these actions fail without root access and test
dumps several permission denied messages before it exits.

Fix it to check root uid and exit with skip code instead.

Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
---
 tools/testing/selftests/livepatch/functions.sh | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/livepatch/functions.sh b/tools/testing/selftests/livepatch/functions.sh
index 31eb09e38729..014b587692f0 100644
--- a/tools/testing/selftests/livepatch/functions.sh
+++ b/tools/testing/selftests/livepatch/functions.sh
@@ -7,6 +7,9 @@
 MAX_RETRIES=600
 RETRY_INTERVAL=".1"	# seconds
 
+# Kselftest framework requirement - SKIP code is 4
+ksft_skip=4
+
 # log(msg) - write message to kernel log
 #	msg - insightful words
 function log() {
@@ -18,7 +21,16 @@ function log() {
 function skip() {
 	log "SKIP: $1"
 	echo "SKIP: $1" >&2
-	exit 4
+	exit $ksft_skip
+}
+
+# root test
+function is_root() {
+	uid=$(id -u)
+	if [ $uid -ne 0 ]; then
+		echo "skip all tests: must be run as root" >&2
+		exit $ksft_skip
+	fi
 }
 
 # die(msg) - game over, man
@@ -45,6 +57,7 @@ function pop_config() {
 }
 
 function set_dynamic_debug() {
+	is_root
         cat <<-EOF > /sys/kernel/debug/dynamic_debug/control
 		file kernel/livepatch/* +p
 		func klp_try_switch_task -p
@@ -62,6 +75,7 @@ function set_ftrace_enabled() {
 #		 for verbose livepatching output and turn on
 #		 the ftrace_enabled sysctl.
 function setup_config() {
+	is_root
 	push_config
 	set_dynamic_debug
 	set_ftrace_enabled 1
-- 
2.20.1

