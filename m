Return-Path: <live-patching+bounces-224-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8D21889AE5F
	for <lists+live-patching@lfdr.de>; Sun,  7 Apr 2024 05:58:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BA79E1C21E02
	for <lists+live-patching@lfdr.de>; Sun,  7 Apr 2024 03:58:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B34FC17F0;
	Sun,  7 Apr 2024 03:58:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="W6x6S4B1"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A48F317C9;
	Sun,  7 Apr 2024 03:58:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712462300; cv=none; b=BbvnP2xvArBZn9+gtU2q+ramLNtHH4aTjTR0ArppCU0ccfpp8n2sk3WGxGwWpnrAkT8YMDw4hh4CpjlprwlRrEcxMlViHpgk80NJ6tHq6ykML1109BKcqTaG4nWaIMVqpGNRITBwyVZ5/c76M0I3yjBeOZDtsXo8NkrQ0pvymE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712462300; c=relaxed/simple;
	bh=kJG4UPq3gYrSdVYtoTJ3t82LwKLshtlWFT045o4aqbk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Ecytu4xmi8i1wUbifjpUmSpylkKlPmX4YWRJ7NXjdEn9W1MK9MZen6BIVqP7Wt8SEi/yYdxRW+KCHz+PiYewUvYWklLipIaPtG0l5wy0g2qL/j4vxdFooqg+s08LDBlYUteAQz0EBC5zmU8wX1513fhQOXEMWYU15AfuO//HXgg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=W6x6S4B1; arc=none smtp.client-ip=209.85.216.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-2a485169476so1106307a91.1;
        Sat, 06 Apr 2024 20:58:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712462298; x=1713067098; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EB07wPSThYRhjFAUuO4zfa5UiCN73c98WhNm8SUJzAs=;
        b=W6x6S4B1SzMcxUnEoYB0E53juHHOOGwQgv6eSumijF2aVdwEcO0wCSXigfjeXvdu1k
         dktkM7bq5M/79z/1qzLJodSas1CjvrRJ259tIC0Lb/sn3sQCHQAQ7mQHTd1wPDc8KjYv
         XLVbg0H3qC6YtDAqbJkD4vih5dwZkoXeQw81kWaJS+8W0secrElsL/48sAtu+Ydl5zCc
         KQgtwxPWnQc0LalM0ZJ0+VVx3trH/UL0zIyti7VArDIPQlSJmxtcmtaBW1hxiEepNV/y
         4KU5tj66W3dp4jOW8h9obSIs8QYV+i9g5yK14y4ljyjB4H0H7XcCeDA9iMlvznQl+VYI
         Q+eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712462298; x=1713067098;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EB07wPSThYRhjFAUuO4zfa5UiCN73c98WhNm8SUJzAs=;
        b=VR8RLsaervJQvqI5/e0izhpIlUvvdnC8BGevw5zbs8emmoxotTOqnr85eq5r98pauv
         C5W038dTUI9fxtwq7IlEp8gKTNva44wvICbYqZoHbrnxbhQ624c7q21rRCKg7SfNlGOX
         GjknI3ayTDrqY7TDz7EAE4pPrUDBBVJbqWx3Hou75BtsQ+N4r6DXf3WLRnEbnZpg1CGL
         QV0cd+2QV+fwtttuYOqBoakbn25bdVoZ9WHUBSFvdrlJNBIzXCORTiMVe1ojqHoVDLKO
         ZmfeUMcqAS8rxOtReQD87eNcH09ZxNQToPlKjsvao/E07uiqDw/IQXH75x8kbPpQ30fb
         EUjw==
X-Forwarded-Encrypted: i=1; AJvYcCW4pmCmlcDYVVRoxkKDnpvYrYL02fPVjDALk/wnC2M+OemqEamxkrIRG4q6t8YVEteJ6i0vIj3cm/Pd0qmzX1AvUT9bMufbGNBmEOErDA==
X-Gm-Message-State: AOJu0Ywn4qw04+xWfP7ens7O8mVLuhKFMbzN796cvPeebdofrX4ZM1gM
	QBJDOr3xHGeqXr1rvjhtNKd4yoQEol/Jv+0IfvuEYCBu/5HLv166
X-Google-Smtp-Source: AGHT+IG4+lAAmw2szQRXgl0+f/8arj0lv5gZb441NK8IFqKC41dN/do3RLPE3RInyihEUDE+uUM5yg==
X-Received: by 2002:a17:902:e413:b0:1e2:9aa7:fd21 with SMTP id m19-20020a170902e41300b001e29aa7fd21mr4127831ple.54.1712462297926;
        Sat, 06 Apr 2024 20:58:17 -0700 (PDT)
Received: from localhost.localdomain ([39.144.103.93])
        by smtp.gmail.com with ESMTPSA id w8-20020a170902e88800b001e27462b988sm3731093plg.61.2024.04.06.20.58.03
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 06 Apr 2024 20:58:17 -0700 (PDT)
From: Yafang Shao <laoar.shao@gmail.com>
To: jpoimboe@kernel.org,
	jikos@kernel.org,
	mbenes@suse.cz,
	pmladek@suse.com,
	joe.lawrence@redhat.com,
	mcgrof@kernel.org
Cc: live-patching@vger.kernel.org,
	linux-modules@vger.kernel.org,
	Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH v2 2/2] livepatch: Delete the associated module of disabled livepatch
Date: Sun,  7 Apr 2024 11:57:30 +0800
Message-Id: <20240407035730.20282-3-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
In-Reply-To: <20240407035730.20282-1-laoar.shao@gmail.com>
References: <20240407035730.20282-1-laoar.shao@gmail.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In our production environment, upon loading a new atomic replace livepatch,
we encountered an issue where the kernel module of the old livepatch
remained, despite being replaced by the new one. This issue can be
reproduced using the following steps:

- Pre setup: Build two atomic replace livepatches

- First step: Load the first livepatch using the insmod command
  $ insmod livepatch-test_0.ko

  $ ls /sys/kernel/livepatch/
  livepatch_test_0

  $ cat /sys/kernel/livepatch/livepatch_test_0/enabled
  1

  $ lsmod  | grep livepatch
  livepatch_test_0       16384  1

- Second step: Load the new livepatch using the insmod command
  $ insmod livepatch-test_1.ko

  $ ls /sys/kernel/livepatch/
  livepatch_test_1                  <<<< livepatch_test_0 was replaced

  $ cat /sys/kernel/livepatch/livepatch_test_1/enabled
  1

  $ lsmod  | grep livepatch
  livepatch_test_1       16384  1
  livepatch_test_0       16384  0    <<<< leftover

Detecting which livepatch will be replaced by the new one from userspace is
not reliable, necessitating the need for the operation to be performed
within the kernel itself. With this improvement, executing
`insmod livepatch-test_1.ko` will automatically remove the
livepatch-test_0.ko module.

Following this change, the associated kernel module will be removed when
executing `echo 0 > /sys/kernel/livepatch/${livepath}/enabled`. Therefore,
adjustments need to be made to the selftests accordingly.

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
---
 kernel/livepatch/core.c                       | 16 +++++++++----
 .../testing/selftests/livepatch/functions.sh  |  2 ++
 .../selftests/livepatch/test-callbacks.sh     | 24 +++++--------------
 .../selftests/livepatch/test-ftrace.sh        |  3 +--
 .../selftests/livepatch/test-livepatch.sh     | 11 +++------
 .../testing/selftests/livepatch/test-state.sh | 15 ++++--------
 .../selftests/livepatch/test-syscall.sh       |  3 +--
 .../testing/selftests/livepatch/test-sysfs.sh |  6 ++---
 8 files changed, 30 insertions(+), 50 deletions(-)

diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
index ecbc9b6aba3a..6850158bcef4 100644
--- a/kernel/livepatch/core.c
+++ b/kernel/livepatch/core.c
@@ -709,8 +709,10 @@ static void klp_free_patch_start(struct klp_patch *patch)
  * the last function accessing the livepatch structures when the patch
  * gets disabled.
  */
-static void klp_free_patch_finish(struct klp_patch *patch)
+static void klp_free_patch_finish(struct klp_patch *patch, bool delete)
 {
+	struct module *mod = patch->mod;
+
 	/*
 	 * Avoid deadlock with enabled_store() sysfs callback by
 	 * calling this outside klp_mutex. It is safe because
@@ -721,8 +723,12 @@ static void klp_free_patch_finish(struct klp_patch *patch)
 	wait_for_completion(&patch->finish);
 
 	/* Put the module after the last access to struct klp_patch. */
-	if (!patch->forced)
-		module_put(patch->mod);
+	if (!patch->forced) {
+		module_put(mod);
+		if (!delete)
+			return;
+		delete_module(mod);
+	}
 }
 
 /*
@@ -735,7 +741,7 @@ static void klp_free_patch_work_fn(struct work_struct *work)
 	struct klp_patch *patch =
 		container_of(work, struct klp_patch, free_work);
 
-	klp_free_patch_finish(patch);
+	klp_free_patch_finish(patch, true);
 }
 
 void klp_free_patch_async(struct klp_patch *patch)
@@ -1124,7 +1130,7 @@ int klp_enable_patch(struct klp_patch *patch)
 
 	mutex_unlock(&klp_mutex);
 
-	klp_free_patch_finish(patch);
+	klp_free_patch_finish(patch, false);
 
 	return ret;
 }
diff --git a/tools/testing/selftests/livepatch/functions.sh b/tools/testing/selftests/livepatch/functions.sh
index fc4c6a016d38..21c48f9b020e 100644
--- a/tools/testing/selftests/livepatch/functions.sh
+++ b/tools/testing/selftests/livepatch/functions.sh
@@ -220,6 +220,8 @@ function load_failing_mod() {
 function unload_mod() {
 	local mod="$1"
 
+	[[ ! -d "/sys/module/$mod" ]] && return
+
 	# Wait for module reference count to clear ...
 	loop_until '[[ $(cat "/sys/module/$mod/refcnt") == "0" ]]' ||
 		die "failed to unload module $mod (refcnt)"
diff --git a/tools/testing/selftests/livepatch/test-callbacks.sh b/tools/testing/selftests/livepatch/test-callbacks.sh
index 32b150e25b10..833cc66915f7 100755
--- a/tools/testing/selftests/livepatch/test-callbacks.sh
+++ b/tools/testing/selftests/livepatch/test-callbacks.sh
@@ -55,7 +55,6 @@ livepatch: '$MOD_LIVEPATCH': completing unpatching transition
 $MOD_LIVEPATCH: post_unpatch_callback: vmlinux
 $MOD_LIVEPATCH: post_unpatch_callback: $MOD_TARGET -> [MODULE_STATE_LIVE] Normal state
 livepatch: '$MOD_LIVEPATCH': unpatching complete
-% rmmod $MOD_LIVEPATCH
 % rmmod $MOD_TARGET
 $MOD_TARGET: ${MOD_TARGET}_exit"
 
@@ -103,7 +102,6 @@ livepatch: '$MOD_LIVEPATCH': completing unpatching transition
 $MOD_LIVEPATCH: post_unpatch_callback: vmlinux
 $MOD_LIVEPATCH: post_unpatch_callback: $MOD_TARGET -> [MODULE_STATE_LIVE] Normal state
 livepatch: '$MOD_LIVEPATCH': unpatching complete
-% rmmod $MOD_LIVEPATCH
 % rmmod $MOD_TARGET
 $MOD_TARGET: ${MOD_TARGET}_exit"
 
@@ -152,8 +150,7 @@ $MOD_LIVEPATCH: pre_unpatch_callback: vmlinux
 livepatch: '$MOD_LIVEPATCH': starting unpatching transition
 livepatch: '$MOD_LIVEPATCH': completing unpatching transition
 $MOD_LIVEPATCH: post_unpatch_callback: vmlinux
-livepatch: '$MOD_LIVEPATCH': unpatching complete
-% rmmod $MOD_LIVEPATCH"
+livepatch: '$MOD_LIVEPATCH': unpatching complete"
 
 
 # This test is similar to the previous test, however the livepatch is
@@ -201,8 +198,7 @@ $MOD_LIVEPATCH: pre_unpatch_callback: vmlinux
 livepatch: '$MOD_LIVEPATCH': starting unpatching transition
 livepatch: '$MOD_LIVEPATCH': completing unpatching transition
 $MOD_LIVEPATCH: post_unpatch_callback: vmlinux
-livepatch: '$MOD_LIVEPATCH': unpatching complete
-% rmmod $MOD_LIVEPATCH"
+livepatch: '$MOD_LIVEPATCH': unpatching complete"
 
 
 # A simple test of loading a livepatch without one of its patch target
@@ -233,8 +229,7 @@ $MOD_LIVEPATCH: pre_unpatch_callback: vmlinux
 livepatch: '$MOD_LIVEPATCH': starting unpatching transition
 livepatch: '$MOD_LIVEPATCH': completing unpatching transition
 $MOD_LIVEPATCH: post_unpatch_callback: vmlinux
-livepatch: '$MOD_LIVEPATCH': unpatching complete
-% rmmod $MOD_LIVEPATCH"
+livepatch: '$MOD_LIVEPATCH': unpatching complete"
 
 
 # Test a scenario where a vmlinux pre-patch callback returns a non-zero
@@ -316,8 +311,7 @@ $MOD_LIVEPATCH: pre_unpatch_callback: vmlinux
 livepatch: '$MOD_LIVEPATCH': starting unpatching transition
 livepatch: '$MOD_LIVEPATCH': completing unpatching transition
 $MOD_LIVEPATCH: post_unpatch_callback: vmlinux
-livepatch: '$MOD_LIVEPATCH': unpatching complete
-% rmmod $MOD_LIVEPATCH"
+livepatch: '$MOD_LIVEPATCH': unpatching complete"
 
 
 # Test loading multiple targeted kernel modules.  This test-case is
@@ -373,7 +367,6 @@ livepatch: '$MOD_LIVEPATCH': completing unpatching transition
 $MOD_LIVEPATCH: post_unpatch_callback: vmlinux
 $MOD_LIVEPATCH: post_unpatch_callback: $MOD_TARGET_BUSY -> [MODULE_STATE_LIVE] Normal state
 livepatch: '$MOD_LIVEPATCH': unpatching complete
-% rmmod $MOD_LIVEPATCH
 % rmmod $MOD_TARGET_BUSY
 $MOD_TARGET_BUSY: ${MOD_TARGET_BUSY}_exit"
 
@@ -445,7 +438,6 @@ livepatch: '$MOD_LIVEPATCH': completing unpatching transition
 $MOD_LIVEPATCH: post_unpatch_callback: vmlinux
 $MOD_LIVEPATCH: post_unpatch_callback: $MOD_TARGET_BUSY -> [MODULE_STATE_LIVE] Normal state
 livepatch: '$MOD_LIVEPATCH': unpatching complete
-% rmmod $MOD_LIVEPATCH
 % rmmod $MOD_TARGET_BUSY
 $MOD_TARGET_BUSY: busymod_work_func exit
 $MOD_TARGET_BUSY: ${MOD_TARGET_BUSY}_exit"
@@ -496,9 +488,7 @@ $MOD_LIVEPATCH: pre_unpatch_callback: vmlinux
 livepatch: '$MOD_LIVEPATCH': starting unpatching transition
 livepatch: '$MOD_LIVEPATCH': completing unpatching transition
 $MOD_LIVEPATCH: post_unpatch_callback: vmlinux
-livepatch: '$MOD_LIVEPATCH': unpatching complete
-% rmmod $MOD_LIVEPATCH2
-% rmmod $MOD_LIVEPATCH"
+livepatch: '$MOD_LIVEPATCH': unpatching complete"
 
 
 # Load multiple livepatches, but the second as an 'atomic-replace'
@@ -545,9 +535,7 @@ $MOD_LIVEPATCH2: pre_unpatch_callback: vmlinux
 livepatch: '$MOD_LIVEPATCH2': starting unpatching transition
 livepatch: '$MOD_LIVEPATCH2': completing unpatching transition
 $MOD_LIVEPATCH2: post_unpatch_callback: vmlinux
-livepatch: '$MOD_LIVEPATCH2': unpatching complete
-% rmmod $MOD_LIVEPATCH2
-% rmmod $MOD_LIVEPATCH"
+livepatch: '$MOD_LIVEPATCH2': unpatching complete"
 
 
 exit 0
diff --git a/tools/testing/selftests/livepatch/test-ftrace.sh b/tools/testing/selftests/livepatch/test-ftrace.sh
index 730218bce99c..81539fe3c082 100755
--- a/tools/testing/selftests/livepatch/test-ftrace.sh
+++ b/tools/testing/selftests/livepatch/test-ftrace.sh
@@ -57,8 +57,7 @@ livepatch: sysctl: setting key \"kernel.ftrace_enabled\": Device or resource bus
 livepatch: '$MOD_LIVEPATCH': initializing unpatching transition
 livepatch: '$MOD_LIVEPATCH': starting unpatching transition
 livepatch: '$MOD_LIVEPATCH': completing unpatching transition
-livepatch: '$MOD_LIVEPATCH': unpatching complete
-% rmmod $MOD_LIVEPATCH"
+livepatch: '$MOD_LIVEPATCH': unpatching complete"
 
 
 exit 0
diff --git a/tools/testing/selftests/livepatch/test-livepatch.sh b/tools/testing/selftests/livepatch/test-livepatch.sh
index e3455a6b1158..8209f4f239fb 100755
--- a/tools/testing/selftests/livepatch/test-livepatch.sh
+++ b/tools/testing/selftests/livepatch/test-livepatch.sh
@@ -41,8 +41,7 @@ livepatch: '$MOD_LIVEPATCH': patching complete
 livepatch: '$MOD_LIVEPATCH': initializing unpatching transition
 livepatch: '$MOD_LIVEPATCH': starting unpatching transition
 livepatch: '$MOD_LIVEPATCH': completing unpatching transition
-livepatch: '$MOD_LIVEPATCH': unpatching complete
-% rmmod $MOD_LIVEPATCH"
+livepatch: '$MOD_LIVEPATCH': unpatching complete"
 
 
 # - load a livepatch that modifies the output from /proc/cmdline and
@@ -95,14 +94,12 @@ livepatch: '$MOD_REPLACE': initializing unpatching transition
 livepatch: '$MOD_REPLACE': starting unpatching transition
 livepatch: '$MOD_REPLACE': completing unpatching transition
 livepatch: '$MOD_REPLACE': unpatching complete
-% rmmod $MOD_REPLACE
 $MOD_LIVEPATCH: this has been live patched
 % echo 0 > /sys/kernel/livepatch/$MOD_LIVEPATCH/enabled
 livepatch: '$MOD_LIVEPATCH': initializing unpatching transition
 livepatch: '$MOD_LIVEPATCH': starting unpatching transition
 livepatch: '$MOD_LIVEPATCH': completing unpatching transition
-livepatch: '$MOD_LIVEPATCH': unpatching complete
-% rmmod $MOD_LIVEPATCH"
+livepatch: '$MOD_LIVEPATCH': unpatching complete"
 
 
 # - load a livepatch that modifies the output from /proc/cmdline and
@@ -149,14 +146,12 @@ livepatch: '$MOD_REPLACE': starting patching transition
 livepatch: '$MOD_REPLACE': completing patching transition
 livepatch: '$MOD_REPLACE': patching complete
 $MOD_REPLACE: this has been live patched
-% rmmod $MOD_LIVEPATCH
 $MOD_REPLACE: this has been live patched
 % echo 0 > /sys/kernel/livepatch/$MOD_REPLACE/enabled
 livepatch: '$MOD_REPLACE': initializing unpatching transition
 livepatch: '$MOD_REPLACE': starting unpatching transition
 livepatch: '$MOD_REPLACE': completing unpatching transition
-livepatch: '$MOD_REPLACE': unpatching complete
-% rmmod $MOD_REPLACE"
+livepatch: '$MOD_REPLACE': unpatching complete"
 
 
 exit 0
diff --git a/tools/testing/selftests/livepatch/test-state.sh b/tools/testing/selftests/livepatch/test-state.sh
index 10a52ac06185..2cc0ef3752c2 100755
--- a/tools/testing/selftests/livepatch/test-state.sh
+++ b/tools/testing/selftests/livepatch/test-state.sh
@@ -37,8 +37,7 @@ livepatch: '$MOD_LIVEPATCH': starting unpatching transition
 livepatch: '$MOD_LIVEPATCH': completing unpatching transition
 $MOD_LIVEPATCH: post_unpatch_callback: vmlinux
 $MOD_LIVEPATCH: free_loglevel_state: freeing space for the stored console_loglevel
-livepatch: '$MOD_LIVEPATCH': unpatching complete
-% rmmod $MOD_LIVEPATCH"
+livepatch: '$MOD_LIVEPATCH': unpatching complete"
 
 
 # Take over system state change by a cumulative patch
@@ -71,7 +70,6 @@ livepatch: '$MOD_LIVEPATCH2': completing patching transition
 $MOD_LIVEPATCH2: post_patch_callback: vmlinux
 $MOD_LIVEPATCH2: fix_console_loglevel: taking over the console_loglevel change
 livepatch: '$MOD_LIVEPATCH2': patching complete
-% rmmod $MOD_LIVEPATCH
 % echo 0 > /sys/kernel/livepatch/$MOD_LIVEPATCH2/enabled
 livepatch: '$MOD_LIVEPATCH2': initializing unpatching transition
 $MOD_LIVEPATCH2: pre_unpatch_callback: vmlinux
@@ -80,8 +78,7 @@ livepatch: '$MOD_LIVEPATCH2': starting unpatching transition
 livepatch: '$MOD_LIVEPATCH2': completing unpatching transition
 $MOD_LIVEPATCH2: post_unpatch_callback: vmlinux
 $MOD_LIVEPATCH2: free_loglevel_state: freeing space for the stored console_loglevel
-livepatch: '$MOD_LIVEPATCH2': unpatching complete
-% rmmod $MOD_LIVEPATCH2"
+livepatch: '$MOD_LIVEPATCH2': unpatching complete"
 
 
 # Take over system state change by a cumulative patch
@@ -116,7 +113,6 @@ livepatch: '$MOD_LIVEPATCH3': completing patching transition
 $MOD_LIVEPATCH3: post_patch_callback: vmlinux
 $MOD_LIVEPATCH3: fix_console_loglevel: taking over the console_loglevel change
 livepatch: '$MOD_LIVEPATCH3': patching complete
-% rmmod $MOD_LIVEPATCH2
 % insmod test_modules/$MOD_LIVEPATCH2.ko
 livepatch: enabling patch '$MOD_LIVEPATCH2'
 livepatch: '$MOD_LIVEPATCH2': initializing patching transition
@@ -135,9 +131,7 @@ livepatch: '$MOD_LIVEPATCH2': starting unpatching transition
 livepatch: '$MOD_LIVEPATCH2': completing unpatching transition
 $MOD_LIVEPATCH2: post_unpatch_callback: vmlinux
 $MOD_LIVEPATCH2: free_loglevel_state: freeing space for the stored console_loglevel
-livepatch: '$MOD_LIVEPATCH2': unpatching complete
-% rmmod $MOD_LIVEPATCH2
-% rmmod $MOD_LIVEPATCH3"
+livepatch: '$MOD_LIVEPATCH2': unpatching complete"
 
 
 # Failure caused by incompatible cumulative livepatches
@@ -170,7 +164,6 @@ livepatch: '$MOD_LIVEPATCH2': starting unpatching transition
 livepatch: '$MOD_LIVEPATCH2': completing unpatching transition
 $MOD_LIVEPATCH2: post_unpatch_callback: vmlinux
 $MOD_LIVEPATCH2: free_loglevel_state: freeing space for the stored console_loglevel
-livepatch: '$MOD_LIVEPATCH2': unpatching complete
-% rmmod $MOD_LIVEPATCH2"
+livepatch: '$MOD_LIVEPATCH2': unpatching complete"
 
 exit 0
diff --git a/tools/testing/selftests/livepatch/test-syscall.sh b/tools/testing/selftests/livepatch/test-syscall.sh
index b76a881d4013..a4e26cb7f524 100755
--- a/tools/testing/selftests/livepatch/test-syscall.sh
+++ b/tools/testing/selftests/livepatch/test-syscall.sh
@@ -47,7 +47,6 @@ $MOD_SYSCALL: Remaining not livepatched processes: 0
 livepatch: '$MOD_SYSCALL': initializing unpatching transition
 livepatch: '$MOD_SYSCALL': starting unpatching transition
 livepatch: '$MOD_SYSCALL': completing unpatching transition
-livepatch: '$MOD_SYSCALL': unpatching complete
-% rmmod $MOD_SYSCALL"
+livepatch: '$MOD_SYSCALL': unpatching complete"
 
 exit 0
diff --git a/tools/testing/selftests/livepatch/test-sysfs.sh b/tools/testing/selftests/livepatch/test-sysfs.sh
index 6c646afa7395..9adfcead84f6 100755
--- a/tools/testing/selftests/livepatch/test-sysfs.sh
+++ b/tools/testing/selftests/livepatch/test-sysfs.sh
@@ -37,8 +37,7 @@ livepatch: '$MOD_LIVEPATCH': patching complete
 livepatch: '$MOD_LIVEPATCH': initializing unpatching transition
 livepatch: '$MOD_LIVEPATCH': starting unpatching transition
 livepatch: '$MOD_LIVEPATCH': completing unpatching transition
-livepatch: '$MOD_LIVEPATCH': unpatching complete
-% rmmod $MOD_LIVEPATCH"
+livepatch: '$MOD_LIVEPATCH': unpatching complete"
 
 start_test "sysfs test object/patched"
 
@@ -80,7 +79,6 @@ test_klp_callbacks_demo: pre_unpatch_callback: vmlinux
 livepatch: 'test_klp_callbacks_demo': starting unpatching transition
 livepatch: 'test_klp_callbacks_demo': completing unpatching transition
 test_klp_callbacks_demo: post_unpatch_callback: vmlinux
-livepatch: 'test_klp_callbacks_demo': unpatching complete
-% rmmod test_klp_callbacks_demo"
+livepatch: 'test_klp_callbacks_demo': unpatching complete"
 
 exit 0
-- 
2.39.1


