Return-Path: <live-patching+bounces-2926-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id uEvpCAsMGWp4pwgAu9opvQ
	(envelope-from <live-patching+bounces-2926-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Fri, 29 May 2026 05:46:19 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 130985FCD0A
	for <lists+live-patching@lfdr.de>; Fri, 29 May 2026 05:46:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id E045E300E14A
	for <lists+live-patching@lfdr.de>; Fri, 29 May 2026 03:46:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D584835AC03;
	Fri, 29 May 2026 03:46:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RJpZd1PS"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 027AD355F3A
	for <live-patching@vger.kernel.org>; Fri, 29 May 2026 03:46:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780026371; cv=none; b=czT9irFeEDX9F0s25J5K5pBSqnqo2PkalTuwACLX/XDgQppNUyd/rYxuzh+OUF09j3UNMuekucF8UGTWMRbaTxb/HtX0ElUfAMwIHIJtjhcZuxhUEdmVPFT5tMEsr1EOZ9twt7yYKuGp+Dnqnt+TY6n03pexSWCepzfNfd7WWz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780026371; c=relaxed/simple;
	bh=nBksYrMFM46ar02M41Lt7zeq1/OYLbbxb21YB8g3Qjs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NpebdPJZnbjwjbZHn6JDRoWQXB8QoZUQaR33UbPAVCyysYzKgPGh29czoLVLsNonpBhIwVnq7jrPeVwUo//Fg1LuDDMp14Bu6U59rZFDlzq2e0QQLerfD6L967DRtKyks/7vujoHHJSjNYDz6NSfYped5js5zfMifSFVE9kk8z4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RJpZd1PS; arc=none smtp.client-ip=209.85.216.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-36b7b7b7a80so740916a91.1
        for <live-patching@vger.kernel.org>; Thu, 28 May 2026 20:46:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780026369; x=1780631169; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FAtuZgg6mcW7i7oox+ZRDVynckO1Z1zhWmgkvp0hm1o=;
        b=RJpZd1PS5vI8bedh+9NJcg5pVnfMjRE++2fW9JUMkbpcF3jBmMcw+7UpLJKa3cBrer
         PG4zJtApgSCSBVKD1I+yycQcmgW2gYC4bgvMe817x93X7ItKMX+zdsr2JTEZf2M4DPxi
         YfhrrNt90bINxcQHpQBBwZHvvBo6JPNwtgkjyy5Vmj7D6GVIK1v3WWE0ZZQLG/25Bber
         fReFeP5tkNLpIpOkyEkEz3wNqW3tttlNRJwYOHyeccN/TaZ54lMfKmQiS4BRRtR8HcKM
         1PyfvkPwVbrbi0o3+TYb68OTsrNUNkpQirPaeZYCqMhew1cNZO1Nnu7jSMUL/18cU79W
         dH8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780026369; x=1780631169;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=FAtuZgg6mcW7i7oox+ZRDVynckO1Z1zhWmgkvp0hm1o=;
        b=M3JdM/RE8nUM9MhNVzoOB7S07GXHRGSSXkv1i03xHIz4zN/i5/oIUXdmZ2EA/BDL/z
         8ePWXaZcFYNoR0Cvjiu2hZBtAWvrOj4EEyOvAJwH+D9LPpQc4sIUYzrnzxp8o1LJiolj
         KMKF1pdMgI+poZjKQM9TkZCelVSKmvwhNZWI73DU5xrDjAlZEjFezLTfoamTX0RYFuND
         8RNIlnoJySXeM7yDGT67VQa4hWGIukkGRdFOOeLMQvqzKgUAEKPr3Ao4eKqZDCKQjKkt
         PD9t3NDbS5P5zU88vH8JH/dP7tXHLpw/SNE2JfuEIgZ5K7Vh8UBx0AIljO2wdP2lo0wC
         tgrg==
X-Gm-Message-State: AOJu0YwsdYydJFYmCQ2ZYMJRgw2cC+wzAlfZECQEr/Z+j1PiAOPibv1J
	IOHhG/VQfJwVX48eAmqsK4i8DxETES5blEptmXZqaObgdew3E9YBqgF3ZR15utiRKLnvOg==
X-Gm-Gg: Acq92OFIRhWdqBuERagVFZY6E+SqaGX8g98bIZjH0fpe6R1pdqrgwsbqsoJUXTw//UD
	sHdvc/EQZZle6VFcqyCbEuh9jRW+8mEuhGxJ13Z6ShEEIFIoQwBNvr4zfS9aEZC9oomTBD0TJK9
	ZL0J1GwBJNywqp+LFB6bQKDOr9bzGGO3DOjpZjn+lyRbEzNhVx4S77NnGg2lWDpm9+2CoSrQUh9
	ysD1ikRDdwwXMiyS2NEcXYLpBYGtiz8/0tEe51mX7ESFhTWKX/5sqFrM8jNVFhAlguGCL1m4HM9
	KEdsS9E5FoG+4iBtwIXHQq3SYwytJrbfbhID4sycf1b6a68qi4ObxXzZCr5cKJzxkvgNeWIJpdl
	iPnWXyJmJi3WgQ6biPXfaDggtGMMqZyMleMd1yRlz68bF47kxCCP6OJf7TmrCELfqeC9rtzO3h3
	rp/vUwbXkSN/DtwR2ue+zvkWnc20vozz1GgMdNW6m4rQ2ObGHO2QayqTpTrdW78FjJeu26wkTd9
	zrRe9pyGZ3OJ0hhrva6/a2I3kQ=
X-Received: by 2002:a17:90b:2d10:b0:369:742a:4259 with SMTP id 98e67ed59e1d1-36bbdb09778mr1281601a91.0.1780026369153;
        Thu, 28 May 2026 20:46:09 -0700 (PDT)
Received: from localhost.localdomain ([240e:46d:2000:3837:ec96:b29a:f0bb:6d68])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-36bc6a340b7sm298385a91.11.2026.05.28.20.46.06
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 28 May 2026 20:46:08 -0700 (PDT)
From: Yafang Shao <laoar.shao@gmail.com>
To: jpoimboe@kernel.org,
	jikos@kernel.org,
	mbenes@suse.cz,
	pmladek@suse.com,
	joe.lawrence@redhat.com,
	song@kernel.org
Cc: live-patching@vger.kernel.org,
	Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH v2 4/4] selftests/livepatch: Update tests for replace_set
Date: Fri, 29 May 2026 11:45:42 +0800
Message-ID: <20260529034542.68766-5-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260529034542.68766-1-laoar.shao@gmail.com>
References: <20260529034542.68766-1-laoar.shao@gmail.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-0.16 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TAGGED_FROM(0.00)[bounces-2926-lists,live-patching=lfdr.de];
	RCVD_COUNT_FIVE(0.00)[5];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_CC(0.00)[vger.kernel.org,gmail.com];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[laoarshao@gmail.com,live-patching@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[8];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	DKIM_TRACE(0.00)[gmail.com:+];
	TAGGED_RCPT(0.00)[live-patching];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:rdns,sin.lore.kernel.org:helo]
X-Rspamd-Queue-Id: 130985FCD0A
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

The changes are as follows:
- Replace "replace" with "replace_set"
- For atomic-replace test cases, we configure two different livepatches
  that share the same replace_set.
- For non-atomic-replace test cases, we configure multiple livepatches,
  each with a different replace_set.

The result are as follows,

$ ./test-callbacks.sh
TEST: target module before livepatch ... ok
TEST: module_coming notifier ... ok
TEST: module_going notifier ... ok
TEST: module_coming and module_going notifiers ... ok
TEST: target module not present ... ok
TEST: pre-patch callback -ENODEV ... ok
TEST: module_coming + pre-patch callback -ENODEV ... ok
TEST: multiple target modules ... ok
TEST: busy target module ... ok
TEST: multiple livepatches ... ok
TEST: atomic replace ... ok

$ ./test-ftrace.sh
TEST: livepatch interaction with ftrace_enabled sysctl ... ok
TEST: trace livepatched function and check that the live patch remains in effect ... ok
TEST: livepatch a traced function and check that the live patch remains in effect ... ok

$ ./test-kprobe.sh
TEST: livepatch interaction with kprobed function with post_handler ... ok
TEST: livepatch interaction with kprobed function without post_handler ... ok

$ ./test-livepatch.sh
TEST: basic function patching ... ok
TEST: multiple livepatches ... ok
TEST: module function patching ... ok
TEST: module function patching (livepatch first) ... ok

$ ./test-shadow-vars.sh
TEST: basic shadow variable API ... ok

$ ./test-state.sh
TEST: system state modification ... ok
TEST: taking over system state modification ... ok
TEST: compatible cumulative livepatches ... ok
TEST: incompatible cumulative livepatches ... ok

$ ./test-syscall.sh
TEST: patch getpid syscall while being heavily hammered ... ok

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
---
 .../selftests/livepatch/test-callbacks.sh     | 33 +++----
 .../selftests/livepatch/test-livepatch.sh     | 98 +------------------
 .../testing/selftests/livepatch/test-sysfs.sh | 22 ++---
 .../test_modules/test_klp_atomic_replace.c    | 10 +-
 .../test_modules/test_klp_callbacks_demo.c    |  6 ++
 .../test_modules/test_klp_callbacks_demo2.c   | 10 +-
 .../test_modules/test_klp_livepatch.c         |  6 ++
 .../livepatch/test_modules/test_klp_state.c   |  2 +-
 .../livepatch/test_modules/test_klp_state2.c  |  2 +-
 9 files changed, 55 insertions(+), 134 deletions(-)

diff --git a/tools/testing/selftests/livepatch/test-callbacks.sh b/tools/testing/selftests/livepatch/test-callbacks.sh
index 2a03deb26a12..692da8ea4c25 100755
--- a/tools/testing/selftests/livepatch/test-callbacks.sh
+++ b/tools/testing/selftests/livepatch/test-callbacks.sh
@@ -451,8 +451,8 @@ $MOD_TARGET_BUSY: busymod_work_func exit
 $MOD_TARGET_BUSY: ${MOD_TARGET_BUSY}_exit"
 
 
-# Test loading multiple livepatches.  This test-case is mainly for comparing
-# with the next test-case.
+# Test loading multiple livepatches sharing different replace_set.
+# This test-case is mainly for comparing with the next test-case.
 #
 # - Load and unload two livepatches, pre and post (un)patch callbacks
 #   execute as each patch progresses through its (un)patching
@@ -460,14 +460,14 @@ $MOD_TARGET_BUSY: ${MOD_TARGET_BUSY}_exit"
 
 start_test "multiple livepatches"
 
-load_lp $MOD_LIVEPATCH
-load_lp $MOD_LIVEPATCH2
+load_lp $MOD_LIVEPATCH replace_set=0
+load_lp $MOD_LIVEPATCH2 replace_set=1
 disable_lp $MOD_LIVEPATCH2
 disable_lp $MOD_LIVEPATCH
 unload_lp $MOD_LIVEPATCH2
 unload_lp $MOD_LIVEPATCH
 
-check_result "% insmod test_modules/$MOD_LIVEPATCH.ko
+check_result "% insmod test_modules/$MOD_LIVEPATCH.ko replace_set=0
 livepatch: enabling patch '$MOD_LIVEPATCH'
 livepatch: '$MOD_LIVEPATCH': initializing patching transition
 $MOD_LIVEPATCH: pre_patch_callback: vmlinux
@@ -475,7 +475,7 @@ livepatch: '$MOD_LIVEPATCH': starting patching transition
 livepatch: '$MOD_LIVEPATCH': completing patching transition
 $MOD_LIVEPATCH: post_patch_callback: vmlinux
 livepatch: '$MOD_LIVEPATCH': patching complete
-% insmod test_modules/$MOD_LIVEPATCH2.ko
+% insmod test_modules/$MOD_LIVEPATCH2.ko replace_set=1
 livepatch: enabling patch '$MOD_LIVEPATCH2'
 livepatch: '$MOD_LIVEPATCH2': initializing patching transition
 $MOD_LIVEPATCH2: pre_patch_callback: vmlinux
@@ -501,14 +501,13 @@ livepatch: '$MOD_LIVEPATCH': unpatching complete
 % rmmod $MOD_LIVEPATCH"
 
 
-# Load multiple livepatches, but the second as an 'atomic-replace'
-# patch.  When the latter loads, the original livepatch should be
-# disabled and *none* of its pre/post-unpatch callbacks executed.  On
-# the other hand, when the atomic-replace livepatch is disabled, its
-# pre/post-unpatch callbacks *should* be executed.
+# Load multiple livepatches sharing the same replace_set.
+# When the latter loads, the original livepatch should be disabled and
+# *none* of its pre/post-unpatch callbacks executed.  On the other hand,
+# when the atomic-replace livepatch is disabled, its pre/post-unpatch
+# callbacks *should* be executed.
 #
-# - Load and unload two livepatches, the second of which has its
-#   .replace flag set true.
+# - Load and unload two livepatches sharing the same replace_set
 #
 # - Pre and post patch callbacks are executed for both livepatches.
 #
@@ -517,13 +516,13 @@ livepatch: '$MOD_LIVEPATCH': unpatching complete
 
 start_test "atomic replace"
 
-load_lp $MOD_LIVEPATCH
-load_lp $MOD_LIVEPATCH2 replace=1
+load_lp $MOD_LIVEPATCH replace_set=0
+load_lp $MOD_LIVEPATCH2 replace_set=0
 disable_lp $MOD_LIVEPATCH2
 unload_lp $MOD_LIVEPATCH2
 unload_lp $MOD_LIVEPATCH
 
-check_result "% insmod test_modules/$MOD_LIVEPATCH.ko
+check_result "% insmod test_modules/$MOD_LIVEPATCH.ko replace_set=0
 livepatch: enabling patch '$MOD_LIVEPATCH'
 livepatch: '$MOD_LIVEPATCH': initializing patching transition
 $MOD_LIVEPATCH: pre_patch_callback: vmlinux
@@ -531,7 +530,7 @@ livepatch: '$MOD_LIVEPATCH': starting patching transition
 livepatch: '$MOD_LIVEPATCH': completing patching transition
 $MOD_LIVEPATCH: post_patch_callback: vmlinux
 livepatch: '$MOD_LIVEPATCH': patching complete
-% insmod test_modules/$MOD_LIVEPATCH2.ko replace=1
+% insmod test_modules/$MOD_LIVEPATCH2.ko replace_set=0
 livepatch: enabling patch '$MOD_LIVEPATCH2'
 livepatch: '$MOD_LIVEPATCH2': initializing patching transition
 $MOD_LIVEPATCH2: pre_patch_callback: vmlinux
diff --git a/tools/testing/selftests/livepatch/test-livepatch.sh b/tools/testing/selftests/livepatch/test-livepatch.sh
index c44c5341a2f1..042999856267 100755
--- a/tools/testing/selftests/livepatch/test-livepatch.sh
+++ b/tools/testing/selftests/livepatch/test-livepatch.sh
@@ -57,12 +57,12 @@ livepatch: '$MOD_LIVEPATCH1': unpatching complete
 
 start_test "multiple livepatches"
 
-load_lp $MOD_LIVEPATCH1
+load_lp $MOD_LIVEPATCH1 replace_set=0
 
 grep 'live patched' /proc/cmdline > /dev/kmsg
 grep 'live patched' /proc/meminfo > /dev/kmsg
 
-load_lp $MOD_REPLACE replace=0
+load_lp $MOD_REPLACE replace_set=1
 
 grep 'live patched' /proc/cmdline > /dev/kmsg
 grep 'live patched' /proc/meminfo > /dev/kmsg
@@ -79,14 +79,14 @@ unload_lp $MOD_LIVEPATCH1
 grep 'live patched' /proc/cmdline > /dev/kmsg
 grep 'live patched' /proc/meminfo > /dev/kmsg
 
-check_result "% insmod test_modules/$MOD_LIVEPATCH1.ko
+check_result "% insmod test_modules/$MOD_LIVEPATCH1.ko replace_set=0
 livepatch: enabling patch '$MOD_LIVEPATCH1'
 livepatch: '$MOD_LIVEPATCH1': initializing patching transition
 livepatch: '$MOD_LIVEPATCH1': starting patching transition
 livepatch: '$MOD_LIVEPATCH1': completing patching transition
 livepatch: '$MOD_LIVEPATCH1': patching complete
 $MOD_LIVEPATCH1: this has been live patched
-% insmod test_modules/$MOD_REPLACE.ko replace=0
+% insmod test_modules/$MOD_REPLACE.ko replace_set=1
 livepatch: enabling patch '$MOD_REPLACE'
 livepatch: '$MOD_REPLACE': initializing patching transition
 livepatch: '$MOD_REPLACE': starting patching transition
@@ -108,96 +108,6 @@ livepatch: '$MOD_LIVEPATCH1': completing unpatching transition
 livepatch: '$MOD_LIVEPATCH1': unpatching complete
 % rmmod $MOD_LIVEPATCH1"
 
-
-# - load a livepatch that modifies the output from /proc/cmdline and
-#   verify correct behavior
-# - load two additional livepatches and check the number of livepatch modules
-#   applied
-# - load an atomic replace livepatch and check that the other three modules were
-#   disabled
-# - remove all livepatches besides the atomic replace one and verify that the
-#   atomic replace livepatch is still active
-# - remove the atomic replace livepatch and verify that none are active
-
-start_test "atomic replace livepatch"
-
-load_lp $MOD_LIVEPATCH1
-
-grep 'live patched' /proc/cmdline > /dev/kmsg
-grep 'live patched' /proc/meminfo > /dev/kmsg
-
-for mod in $MOD_LIVEPATCH2 $MOD_LIVEPATCH3; do
-	load_lp "$mod"
-done
-
-mods=($SYSFS_KLP_DIR/*)
-nmods=${#mods[@]}
-if [ "$nmods" -ne 3 ]; then
-	die "Expecting three modules listed, found $nmods"
-fi
-
-load_lp $MOD_REPLACE replace=1
-
-grep 'live patched' /proc/cmdline > /dev/kmsg
-grep 'live patched' /proc/meminfo > /dev/kmsg
-
-loop_until 'mods=($SYSFS_KLP_DIR/*); nmods=${#mods[@]}; [[ "$nmods" -eq 1 ]]' ||
-        die "Expecting only one moduled listed, found $nmods"
-
-# These modules were disabled by the atomic replace
-for mod in $MOD_LIVEPATCH3 $MOD_LIVEPATCH2 $MOD_LIVEPATCH1; do
-	unload_lp "$mod"
-done
-
-grep 'live patched' /proc/cmdline > /dev/kmsg
-grep 'live patched' /proc/meminfo > /dev/kmsg
-
-disable_lp $MOD_REPLACE
-unload_lp $MOD_REPLACE
-
-grep 'live patched' /proc/cmdline > /dev/kmsg
-grep 'live patched' /proc/meminfo > /dev/kmsg
-
-check_result "% insmod test_modules/$MOD_LIVEPATCH1.ko
-livepatch: enabling patch '$MOD_LIVEPATCH1'
-livepatch: '$MOD_LIVEPATCH1': initializing patching transition
-livepatch: '$MOD_LIVEPATCH1': starting patching transition
-livepatch: '$MOD_LIVEPATCH1': completing patching transition
-livepatch: '$MOD_LIVEPATCH1': patching complete
-$MOD_LIVEPATCH1: this has been live patched
-% insmod test_modules/$MOD_LIVEPATCH2.ko
-livepatch: enabling patch '$MOD_LIVEPATCH2'
-livepatch: '$MOD_LIVEPATCH2': initializing patching transition
-livepatch: '$MOD_LIVEPATCH2': starting patching transition
-livepatch: '$MOD_LIVEPATCH2': completing patching transition
-livepatch: '$MOD_LIVEPATCH2': patching complete
-% insmod test_modules/$MOD_LIVEPATCH3.ko
-livepatch: enabling patch '$MOD_LIVEPATCH3'
-livepatch: '$MOD_LIVEPATCH3': initializing patching transition
-$MOD_LIVEPATCH3: pre_patch_callback: vmlinux
-livepatch: '$MOD_LIVEPATCH3': starting patching transition
-livepatch: '$MOD_LIVEPATCH3': completing patching transition
-$MOD_LIVEPATCH3: post_patch_callback: vmlinux
-livepatch: '$MOD_LIVEPATCH3': patching complete
-% insmod test_modules/$MOD_REPLACE.ko replace=1
-livepatch: enabling patch '$MOD_REPLACE'
-livepatch: '$MOD_REPLACE': initializing patching transition
-livepatch: '$MOD_REPLACE': starting patching transition
-livepatch: '$MOD_REPLACE': completing patching transition
-livepatch: '$MOD_REPLACE': patching complete
-$MOD_REPLACE: this has been live patched
-% rmmod $MOD_LIVEPATCH3
-% rmmod $MOD_LIVEPATCH2
-% rmmod $MOD_LIVEPATCH1
-$MOD_REPLACE: this has been live patched
-% echo 0 > $SYSFS_KLP_DIR/$MOD_REPLACE/enabled
-livepatch: '$MOD_REPLACE': initializing unpatching transition
-livepatch: '$MOD_REPLACE': starting unpatching transition
-livepatch: '$MOD_REPLACE': completing unpatching transition
-livepatch: '$MOD_REPLACE': unpatching complete
-% rmmod $MOD_REPLACE"
-
-
 # - load a target module that provides /proc/test_klp_mod_target with
 #   original output
 # - load a livepatch that patches the target module's show function
diff --git a/tools/testing/selftests/livepatch/test-sysfs.sh b/tools/testing/selftests/livepatch/test-sysfs.sh
index 0c31759f34f6..37425ad89f58 100755
--- a/tools/testing/selftests/livepatch/test-sysfs.sh
+++ b/tools/testing/selftests/livepatch/test-sysfs.sh
@@ -20,7 +20,7 @@ check_sysfs_rights "$MOD_LIVEPATCH" "" "drwxr-xr-x"
 check_sysfs_rights "$MOD_LIVEPATCH" "enabled" "-rw-r--r--"
 check_sysfs_value  "$MOD_LIVEPATCH" "enabled" "1"
 check_sysfs_rights "$MOD_LIVEPATCH" "force" "--w-------"
-check_sysfs_rights "$MOD_LIVEPATCH" "replace" "-r--r--r--"
+check_sysfs_rights "$MOD_LIVEPATCH" "replace_set" "-r--r--r--"
 check_sysfs_rights "$MOD_LIVEPATCH" "transition" "-r--r--r--"
 check_sysfs_value  "$MOD_LIVEPATCH" "transition" "0"
 check_sysfs_rights "$MOD_LIVEPATCH" "vmlinux/patched" "-r--r--r--"
@@ -86,18 +86,18 @@ test_klp_callbacks_demo: post_unpatch_callback: vmlinux
 livepatch: 'test_klp_callbacks_demo': unpatching complete
 % rmmod test_klp_callbacks_demo"
 
-start_test "sysfs test replace enabled"
+start_test "sysfs test replace_set 0"
 
 MOD_LIVEPATCH=test_klp_atomic_replace
-load_lp $MOD_LIVEPATCH replace=1
+load_lp $MOD_LIVEPATCH replace_set=0
 
-check_sysfs_rights "$MOD_LIVEPATCH" "replace" "-r--r--r--"
-check_sysfs_value  "$MOD_LIVEPATCH" "replace" "1"
+check_sysfs_rights "$MOD_LIVEPATCH" "replace_set" "-r--r--r--"
+check_sysfs_value  "$MOD_LIVEPATCH" "replace_set" "0"
 
 disable_lp $MOD_LIVEPATCH
 unload_lp $MOD_LIVEPATCH
 
-check_result "% insmod test_modules/$MOD_LIVEPATCH.ko replace=1
+check_result "% insmod test_modules/$MOD_LIVEPATCH.ko replace_set=0
 livepatch: enabling patch '$MOD_LIVEPATCH'
 livepatch: '$MOD_LIVEPATCH': initializing patching transition
 livepatch: '$MOD_LIVEPATCH': starting patching transition
@@ -110,17 +110,17 @@ livepatch: '$MOD_LIVEPATCH': completing unpatching transition
 livepatch: '$MOD_LIVEPATCH': unpatching complete
 % rmmod $MOD_LIVEPATCH"
 
-start_test "sysfs test replace disabled"
+start_test "sysfs test replace_set 1234"
 
-load_lp $MOD_LIVEPATCH replace=0
+load_lp $MOD_LIVEPATCH replace_set=1234
 
-check_sysfs_rights "$MOD_LIVEPATCH" "replace" "-r--r--r--"
-check_sysfs_value  "$MOD_LIVEPATCH" "replace" "0"
+check_sysfs_rights "$MOD_LIVEPATCH" "replace_set" "-r--r--r--"
+check_sysfs_value  "$MOD_LIVEPATCH" "replace_set" "1234"
 
 disable_lp $MOD_LIVEPATCH
 unload_lp $MOD_LIVEPATCH
 
-check_result "% insmod test_modules/$MOD_LIVEPATCH.ko replace=0
+check_result "% insmod test_modules/$MOD_LIVEPATCH.ko replace_set=1234
 livepatch: enabling patch '$MOD_LIVEPATCH'
 livepatch: '$MOD_LIVEPATCH': initializing patching transition
 livepatch: '$MOD_LIVEPATCH': starting patching transition
diff --git a/tools/testing/selftests/livepatch/test_modules/test_klp_atomic_replace.c b/tools/testing/selftests/livepatch/test_modules/test_klp_atomic_replace.c
index 5af7093ca00c..5333503f193a 100644
--- a/tools/testing/selftests/livepatch/test_modules/test_klp_atomic_replace.c
+++ b/tools/testing/selftests/livepatch/test_modules/test_klp_atomic_replace.c
@@ -7,9 +7,9 @@
 #include <linux/kernel.h>
 #include <linux/livepatch.h>
 
-static int replace;
-module_param(replace, int, 0644);
-MODULE_PARM_DESC(replace, "replace (default=0)");
+static int replace_set;
+module_param(replace_set, int, 0644);
+MODULE_PARM_DESC(replace_set, "replace_set (default=0)");
 
 #include <linux/seq_file.h>
 static int livepatch_meminfo_proc_show(struct seq_file *m, void *v)
@@ -36,12 +36,12 @@ static struct klp_object objs[] = {
 static struct klp_patch patch = {
 	.mod = THIS_MODULE,
 	.objs = objs,
-	/* set .replace in the init function below for demo purposes */
+	/* set .replace_set in the init function below for demo purposes */
 };
 
 static int test_klp_atomic_replace_init(void)
 {
-	patch.replace = replace;
+	patch.replace_set = replace_set;
 	return klp_enable_patch(&patch);
 }
 
diff --git a/tools/testing/selftests/livepatch/test_modules/test_klp_callbacks_demo.c b/tools/testing/selftests/livepatch/test_modules/test_klp_callbacks_demo.c
index 3fd8fe1cd1cc..5c3324aa4d75 100644
--- a/tools/testing/selftests/livepatch/test_modules/test_klp_callbacks_demo.c
+++ b/tools/testing/selftests/livepatch/test_modules/test_klp_callbacks_demo.c
@@ -7,6 +7,10 @@
 #include <linux/kernel.h>
 #include <linux/livepatch.h>
 
+static int replace_set;
+module_param(replace_set, int, 0644);
+MODULE_PARM_DESC(replace_set, "replace_set (default=0)");
+
 static int pre_patch_ret;
 module_param(pre_patch_ret, int, 0644);
 MODULE_PARM_DESC(pre_patch_ret, "pre_patch_ret (default=0)");
@@ -102,10 +106,12 @@ static struct klp_object objs[] = {
 static struct klp_patch patch = {
 	.mod = THIS_MODULE,
 	.objs = objs,
+	/* set .replace_set in the init function below for demo purposes */
 };
 
 static int test_klp_callbacks_demo_init(void)
 {
+	patch.replace_set = replace_set;
 	return klp_enable_patch(&patch);
 }
 
diff --git a/tools/testing/selftests/livepatch/test_modules/test_klp_callbacks_demo2.c b/tools/testing/selftests/livepatch/test_modules/test_klp_callbacks_demo2.c
index 5417573e80af..31347e2131a7 100644
--- a/tools/testing/selftests/livepatch/test_modules/test_klp_callbacks_demo2.c
+++ b/tools/testing/selftests/livepatch/test_modules/test_klp_callbacks_demo2.c
@@ -7,9 +7,9 @@
 #include <linux/kernel.h>
 #include <linux/livepatch.h>
 
-static int replace;
-module_param(replace, int, 0644);
-MODULE_PARM_DESC(replace, "replace (default=0)");
+static int replace_set;
+module_param(replace_set, int, 0644);
+MODULE_PARM_DESC(replace_set, "replace_set (default=0)");
 
 static const char *const module_state[] = {
 	[MODULE_STATE_LIVE]	= "[MODULE_STATE_LIVE] Normal state",
@@ -72,12 +72,12 @@ static struct klp_object objs[] = {
 static struct klp_patch patch = {
 	.mod = THIS_MODULE,
 	.objs = objs,
-	/* set .replace in the init function below for demo purposes */
+	/* set .replace_set in the init function below for demo purposes */
 };
 
 static int test_klp_callbacks_demo2_init(void)
 {
-	patch.replace = replace;
+	patch.replace_set = replace_set;
 	return klp_enable_patch(&patch);
 }
 
diff --git a/tools/testing/selftests/livepatch/test_modules/test_klp_livepatch.c b/tools/testing/selftests/livepatch/test_modules/test_klp_livepatch.c
index aff08199de71..fedd2494d187 100644
--- a/tools/testing/selftests/livepatch/test_modules/test_klp_livepatch.c
+++ b/tools/testing/selftests/livepatch/test_modules/test_klp_livepatch.c
@@ -15,6 +15,10 @@ static int livepatch_cmdline_proc_show(struct seq_file *m, void *v)
 	return 0;
 }
 
+static int replace_set;
+module_param(replace_set, int, 0644);
+MODULE_PARM_DESC(replace_set, "replace_set (default=0)");
+
 static struct klp_func funcs[] = {
 	{
 		.old_name = "cmdline_proc_show",
@@ -32,10 +36,12 @@ static struct klp_object objs[] = {
 static struct klp_patch patch = {
 	.mod = THIS_MODULE,
 	.objs = objs,
+	/* set .replace_set in the init function below for demo purposes */
 };
 
 static int test_klp_livepatch_init(void)
 {
+	patch.replace_set = replace_set;
 	return klp_enable_patch(&patch);
 }
 
diff --git a/tools/testing/selftests/livepatch/test_modules/test_klp_state.c b/tools/testing/selftests/livepatch/test_modules/test_klp_state.c
index 57a4253acb01..8c8829c3ec43 100644
--- a/tools/testing/selftests/livepatch/test_modules/test_klp_state.c
+++ b/tools/testing/selftests/livepatch/test_modules/test_klp_state.c
@@ -142,7 +142,7 @@ static struct klp_patch patch = {
 	.mod = THIS_MODULE,
 	.objs = objs,
 	.states = states,
-	.replace = true,
+	.replace_set = 0,
 };
 
 static int test_klp_callbacks_demo_init(void)
diff --git a/tools/testing/selftests/livepatch/test_modules/test_klp_state2.c b/tools/testing/selftests/livepatch/test_modules/test_klp_state2.c
index c978ea4d5e67..8a79d7dcce33 100644
--- a/tools/testing/selftests/livepatch/test_modules/test_klp_state2.c
+++ b/tools/testing/selftests/livepatch/test_modules/test_klp_state2.c
@@ -171,7 +171,7 @@ static struct klp_patch patch = {
 	.mod = THIS_MODULE,
 	.objs = objs,
 	.states = states,
-	.replace = true,
+	.replace_set = 0,
 };
 
 static int test_klp_callbacks_demo_init(void)
-- 
2.47.3


