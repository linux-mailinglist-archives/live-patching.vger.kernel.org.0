Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C0DE5D794B
	for <lists+live-patching@lfdr.de>; Tue, 15 Oct 2019 16:58:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732735AbfJOO6F (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 15 Oct 2019 10:58:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43786 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726523AbfJOO6E (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Tue, 15 Oct 2019 10:58:04 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 2D3E03175295;
        Tue, 15 Oct 2019 14:58:04 +0000 (UTC)
Received: from redhat.com (dhcp-17-119.bos.redhat.com [10.18.17.119])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 23E7510027C5;
        Tue, 15 Oct 2019 14:58:03 +0000 (UTC)
Date:   Tue, 15 Oct 2019 10:58:01 -0400
From:   Joe Lawrence <joe.lawrence@redhat.com>
To:     Miroslav Benes <mbenes@suse.cz>
Cc:     rostedt@goodmis.org, mingo@redhat.com, jpoimboe@redhat.com,
        jikos@kernel.org, pmladek@suse.com, linux-kernel@vger.kernel.org,
        live-patching@vger.kernel.org
Subject: Re: [PATCH v2] ftrace: Introduce PERMANENT ftrace_ops flag
Message-ID: <20191015145801.GA9922@redhat.com>
References: <20191014105923.29607-1-mbenes@suse.cz>
 <20191014223100.GA16608@redhat.com>
 <alpine.LSU.2.21.1910151259220.30206@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.21.1910151259220.30206@pobox.suse.cz>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.49]); Tue, 15 Oct 2019 14:58:04 +0000 (UTC)
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue, Oct 15, 2019 at 01:23:10PM +0200, Miroslav Benes wrote:
> > Hi Miroslav,
> > 
> > Maybe we should add a test to verify this new behavior?  See sample
> > version below (lightly tested).  We can add to this one, or patch
> > seperately if you prefer.
> 
> Thanks a lot, Joe. It looks nice. I'll include it in v3. One question 
> below.
>  
> [ ... snip ... ]
> 
> Shouldn't we call push_ftrace_enabled() somewhere at the beginning of the 
> test script? set_dynamic_debug() calls its push_dynamic_debug() directly, 
> but set_ftrace_enabled() is different, because it is called more than once 
> in the script.
> 
> One could argue that ftrace_enabled has to be true at the beginning of 
> testing anyway, but I think it would be cleaner. Btw, we should probably 
> guarantee that ftrace_enabled is true when livepatch selftests are 
> invoked.
> 

Here's a new version that combines the ftrace_enabled configuration with
the debugfs stuff (so its only pushed/pop once per test) and updates all
the tests accordingly.  Feel free to any tweaks or flourishes when
adding to v3.

Thanks,

-- Joe

-->8-- -->8-- -->8-- -->8-- -->8-- -->8-- -->8-- -->8-- -->8-- -->8--

From a22ca55b3f429b7c9ceed6be87a571f77520994c Mon Sep 17 00:00:00 2001
From: Joe Lawrence <joe.lawrence@redhat.com>
Date: Tue, 15 Oct 2019 10:33:18 -0400
Subject: [PATCH] selftests/livepatch: test interaction with ftrace_enabled

Since livepatching depends upon ftrace handlers to implement "patched"
code functionality, verify that the ftrace_enabled sysctl value
interacts with livepatch registration as expected.  At the same time,
ensure that ftrace_enabled is set and part of the test environment
configuration that is saved and restored when running the selftests.

Signed-off-by: Joe Lawrence <joe.lawrence@redhat.com>
---
 tools/testing/selftests/livepatch/Makefile    |  3 +-
 .../testing/selftests/livepatch/functions.sh  | 34 +++++++---
 .../selftests/livepatch/test-callbacks.sh     |  2 +-
 .../selftests/livepatch/test-ftrace.sh        | 65 +++++++++++++++++++
 .../selftests/livepatch/test-livepatch.sh     |  2 +-
 .../selftests/livepatch/test-shadow-vars.sh   |  2 +-
 6 files changed, 95 insertions(+), 13 deletions(-)
 create mode 100755 tools/testing/selftests/livepatch/test-ftrace.sh

diff --git a/tools/testing/selftests/livepatch/Makefile b/tools/testing/selftests/livepatch/Makefile
index fd405402c3ff..1886d9d94b88 100644
--- a/tools/testing/selftests/livepatch/Makefile
+++ b/tools/testing/selftests/livepatch/Makefile
@@ -4,6 +4,7 @@ TEST_PROGS_EXTENDED := functions.sh
 TEST_PROGS := \
 	test-livepatch.sh \
 	test-callbacks.sh \
-	test-shadow-vars.sh
+	test-shadow-vars.sh \
+	test-ftrace.sh
 
 include ../lib.mk
diff --git a/tools/testing/selftests/livepatch/functions.sh b/tools/testing/selftests/livepatch/functions.sh
index 79b0affd21fb..31eb09e38729 100644
--- a/tools/testing/selftests/livepatch/functions.sh
+++ b/tools/testing/selftests/livepatch/functions.sh
@@ -29,29 +29,45 @@ function die() {
 	exit 1
 }
 
-function push_dynamic_debug() {
-        DYNAMIC_DEBUG=$(grep '^kernel/livepatch' /sys/kernel/debug/dynamic_debug/control | \
-                awk -F'[: ]' '{print "file " $1 " line " $2 " " $4}')
+function push_config() {
+	DYNAMIC_DEBUG=$(grep '^kernel/livepatch' /sys/kernel/debug/dynamic_debug/control | \
+			awk -F'[: ]' '{print "file " $1 " line " $2 " " $4}')
+	FTRACE_ENABLED=$(sysctl --values kernel.ftrace_enabled)
 }
 
-function pop_dynamic_debug() {
+function pop_config() {
 	if [[ -n "$DYNAMIC_DEBUG" ]]; then
 		echo -n "$DYNAMIC_DEBUG" > /sys/kernel/debug/dynamic_debug/control
 	fi
+	if [[ -n "$FTRACE_ENABLED" ]]; then
+		sysctl kernel.ftrace_enabled="$FTRACE_ENABLED" &> /dev/null
+	fi
 }
 
-# set_dynamic_debug() - save the current dynamic debug config and tweak
-# 			it for the self-tests.  Set a script exit trap
-#			that restores the original config.
 function set_dynamic_debug() {
-        push_dynamic_debug
-        trap pop_dynamic_debug EXIT INT TERM HUP
         cat <<-EOF > /sys/kernel/debug/dynamic_debug/control
 		file kernel/livepatch/* +p
 		func klp_try_switch_task -p
 		EOF
 }
 
+function set_ftrace_enabled() {
+	local sysctl="$1"
+	result=$(sysctl kernel.ftrace_enabled="$1" 2>&1 | paste --serial --delimiters=' ')
+	echo "livepatch: $result" > /dev/kmsg
+}
+
+# setup_config - save the current config and set a script exit trap that
+#		 restores the original config.  Setup the dynamic debug
+#		 for verbose livepatching output and turn on
+#		 the ftrace_enabled sysctl.
+function setup_config() {
+	push_config
+	set_dynamic_debug
+	set_ftrace_enabled 1
+	trap pop_config EXIT INT TERM HUP
+}
+
 # loop_until(cmd) - loop a command until it is successful or $MAX_RETRIES,
 #		    sleep $RETRY_INTERVAL between attempts
 #	cmd - command and its arguments to run
diff --git a/tools/testing/selftests/livepatch/test-callbacks.sh b/tools/testing/selftests/livepatch/test-callbacks.sh
index e97a9dcb73c7..a35289b13c9c 100755
--- a/tools/testing/selftests/livepatch/test-callbacks.sh
+++ b/tools/testing/selftests/livepatch/test-callbacks.sh
@@ -9,7 +9,7 @@ MOD_LIVEPATCH2=test_klp_callbacks_demo2
 MOD_TARGET=test_klp_callbacks_mod
 MOD_TARGET_BUSY=test_klp_callbacks_busy
 
-set_dynamic_debug
+setup_config
 
 
 # TEST: target module before livepatch
diff --git a/tools/testing/selftests/livepatch/test-ftrace.sh b/tools/testing/selftests/livepatch/test-ftrace.sh
new file mode 100755
index 000000000000..e2a76887f40a
--- /dev/null
+++ b/tools/testing/selftests/livepatch/test-ftrace.sh
@@ -0,0 +1,65 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (C) 2019 Joe Lawrence <joe.lawrence@redhat.com>
+
+. $(dirname $0)/functions.sh
+
+MOD_LIVEPATCH=test_klp_livepatch
+
+setup_config
+
+
+# TEST: livepatch interaction with ftrace_enabled sysctl
+# - turn ftrace_enabled OFF and verify livepatches can't load
+# - turn ftrace_enabled ON and verify livepatch can load
+# - verify that ftrace_enabled can't be turned OFF while a livepatch is loaded
+
+echo -n "TEST: livepatch interaction with ftrace_enabled sysctl ... "
+dmesg -C
+
+set_ftrace_enabled 0
+load_failing_mod $MOD_LIVEPATCH
+
+set_ftrace_enabled 1
+load_lp $MOD_LIVEPATCH
+if [[ "$(cat /proc/cmdline)" != "$MOD_LIVEPATCH: this has been live patched" ]] ; then
+	echo -e "FAIL\n\n"
+	die "livepatch kselftest(s) failed"
+fi
+
+set_ftrace_enabled 0
+if [[ "$(cat /proc/cmdline)" != "$MOD_LIVEPATCH: this has been live patched" ]] ; then
+	echo -e "FAIL\n\n"
+	die "livepatch kselftest(s) failed"
+fi
+disable_lp $MOD_LIVEPATCH
+unload_lp $MOD_LIVEPATCH
+
+check_result "livepatch: kernel.ftrace_enabled = 0
+% modprobe $MOD_LIVEPATCH
+livepatch: enabling patch '$MOD_LIVEPATCH'
+livepatch: '$MOD_LIVEPATCH': initializing patching transition
+livepatch: failed to register ftrace handler for function 'cmdline_proc_show' (-16)
+livepatch: failed to patch object 'vmlinux'
+livepatch: failed to enable patch '$MOD_LIVEPATCH'
+livepatch: '$MOD_LIVEPATCH': canceling patching transition, going to unpatch
+livepatch: '$MOD_LIVEPATCH': completing unpatching transition
+livepatch: '$MOD_LIVEPATCH': unpatching complete
+modprobe: ERROR: could not insert '$MOD_LIVEPATCH': Device or resource busy
+livepatch: kernel.ftrace_enabled = 1
+% modprobe $MOD_LIVEPATCH
+livepatch: enabling patch '$MOD_LIVEPATCH'
+livepatch: '$MOD_LIVEPATCH': initializing patching transition
+livepatch: '$MOD_LIVEPATCH': starting patching transition
+livepatch: '$MOD_LIVEPATCH': completing patching transition
+livepatch: '$MOD_LIVEPATCH': patching complete
+livepatch: sysctl: setting key \"kernel.ftrace_enabled\": Device or resource busy kernel.ftrace_enabled = 0
+% echo 0 > /sys/kernel/livepatch/$MOD_LIVEPATCH/enabled
+livepatch: '$MOD_LIVEPATCH': initializing unpatching transition
+livepatch: '$MOD_LIVEPATCH': starting unpatching transition
+livepatch: '$MOD_LIVEPATCH': completing unpatching transition
+livepatch: '$MOD_LIVEPATCH': unpatching complete
+% rmmod $MOD_LIVEPATCH"
+
+
+exit 0
diff --git a/tools/testing/selftests/livepatch/test-livepatch.sh b/tools/testing/selftests/livepatch/test-livepatch.sh
index f05268aea859..493e3df415a1 100755
--- a/tools/testing/selftests/livepatch/test-livepatch.sh
+++ b/tools/testing/selftests/livepatch/test-livepatch.sh
@@ -7,7 +7,7 @@
 MOD_LIVEPATCH=test_klp_livepatch
 MOD_REPLACE=test_klp_atomic_replace
 
-set_dynamic_debug
+setup_config
 
 
 # TEST: basic function patching
diff --git a/tools/testing/selftests/livepatch/test-shadow-vars.sh b/tools/testing/selftests/livepatch/test-shadow-vars.sh
index 04a37831e204..1aae73299114 100755
--- a/tools/testing/selftests/livepatch/test-shadow-vars.sh
+++ b/tools/testing/selftests/livepatch/test-shadow-vars.sh
@@ -6,7 +6,7 @@
 
 MOD_TEST=test_klp_shadow_vars
 
-set_dynamic_debug
+setup_config
 
 
 # TEST: basic shadow variable API
-- 
2.21.0

