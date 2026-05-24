Return-Path: <live-patching+bounces-2879-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id iMAmIhmPE2rdDQcAu9opvQ
	(envelope-from <live-patching+bounces-2879-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Mon, 25 May 2026 01:51:53 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 304ED5C4D0C
	for <lists+live-patching@lfdr.de>; Mon, 25 May 2026 01:51:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id ADE13300CC23
	for <lists+live-patching@lfdr.de>; Sun, 24 May 2026 23:50:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 551B23B8409;
	Sun, 24 May 2026 23:50:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="bzDU8MgZ"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71FDA36A348
	for <live-patching@vger.kernel.org>; Sun, 24 May 2026 23:50:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779666657; cv=none; b=KFVJaWiKbQmO9IqmAe0hnSiD3tzN3yLR1481YsTNh7Wt4CFfG4QGi0mMlfPbmSG0p9WsXVVL4AtE+tTUP+HxomegRP7j2RPjqs7els7zNZX4yhDyfQA/V1426/S/C6PJsevzaC9CUbHk6dk5S8QTQJah6SLaKCAlB1gIjv0A9jY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779666657; c=relaxed/simple;
	bh=I7SegwAIOnn8Zt1SWPZf8rhhwlN2a4741JSURcMiDOw=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=WWnr+WNxeRVJAIyQNDLhFsUjKQQQ8ayy3+aEn7IwsHzzIP4mAaExmrUAoN6zltCBfFwTY/0zQMeZa6e8tnKivQqEvQHYz70/u8dtbv9oavoJ5f6YOdSTwiNubRPTNjHBdhn5d9QuEQBHJdiEOtRLgWK90GehhbhALb7HQkJ4WuA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=bzDU8MgZ; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-45d96d21e82so4939645f8f.0
        for <live-patching@vger.kernel.org>; Sun, 24 May 2026 16:50:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1779666654; x=1780271454; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sEd9trovmFOEJuYQnYpCKWBckKvvMl+JmjSp64a8XTE=;
        b=bzDU8MgZd5a9/D+mmIT47q+jzXwQgIqHosG/qplwe7BthAo0TfKSgmKLSzb/aq5opX
         bHpMLEMBhHg0axBMkQt6q4uVONkbgOGMjUXtSuQLgDoCtCMiCPXVzbzGa/I7aVpNbj4J
         yy6PvF3SS+LQ0xKK10i9Hx2t9NPWFvU+1VMRGsck1zrcDQgsucEDSTFlj93IUbhass2d
         SBaGHfxXItxTQn8b4LuiOPNANfP+s7NxpgyUsz6n3C4sq9Ec6F+9A2IwRXfukTsFDr2u
         3FNEuJAEp01v7NHS5tbGvopaN/8ucQsckNIXfzhiIrM7RBAy62DeiUNn4Yvx7Ym3nQyD
         Dg9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779666654; x=1780271454;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=sEd9trovmFOEJuYQnYpCKWBckKvvMl+JmjSp64a8XTE=;
        b=I6syxFTGq/t8oiDpw4+TqlvN0Epj7mDaL0971ZZVp7ju9Fwm8zGS1Rl5oydBDzH87y
         aJ3sWiy4Jc8gjaZai9LruXVq2RnATRfi0PVmO9HxehOYhAmyui6+UMfD+PTDVfoGy5XY
         TrJQKw5orPZYQmdNSYEMfI72KxKYUBMWA0KGMAcu1dGiHv8M3IzZY6nIKMhjNlcQdeDx
         HR1VmdepTh19gP8K1JtN83M1l6h8b3J96iDkt0yNMWyNwMU+Fmb1JaZXqunyhiokHBjm
         C69eVwx/gqLaqv1AL5+sK61Rdglw0Ijcpa361S9GTTWB8lLUecqyab9TAEw/O1Qx6KEl
         IipA==
X-Gm-Message-State: AOJu0YxergCOlPihyxjn1qPRISz+TrA7mFeRsfnv0e4jyIDiM3YmIHEj
	WRjzmsecxPpIBYJNhqhhvY62DbN+Ebqj2Da7rhmuTnq9pydyqCfr4qBhIj00yIRlEoc=
X-Gm-Gg: Acq92OHhzrChN+VFRg+B1kERFl/U+tDCv2OUYRbSVF9XHpLcSkkGXavtpSvnBv/6MLP
	lJDwz7b4aMJPgrl8xdA/z4C2pEWdoOIyDKMZ+3lweJXNw9Bt4WNqQXbO+eHm+JnNj/E4HHk0FCT
	Wvg0xCciw1qm+3kbrP6dHTqX1+11L6mU0VE5TF92gbW6d4mCixRohASnhyct+67FUasnl8apiJi
	c3WWRNkUucq1F1M5DPXyAHSLCL9H2F3T8OKb7lT9dcawUxP0pO5AB1vRA95Y6UQK3Sugo1WWfuK
	C5d4Z/USRwhonWTBXADYrgp0HJCCEkI/pBTaZO3UwUSZeQMquS3CKo03dtJWLpVftcGavFwYgQj
	hj+9wK+wZINnr7lsE87X9TZe6KwoUY2gIOqG90B7QVpjutKEK6VRLFnpOqdTPZQcVItfN75xezh
	p7Qv/fbqq8fTQEXpTalv3ym8E=
X-Received: by 2002:a05:6000:1848:b0:43c:f583:126a with SMTP id ffacd0b85a97d-45eb3681dd5mr21176568f8f.14.1779666653913;
        Sun, 24 May 2026 16:50:53 -0700 (PDT)
Received: from [127.0.0.1] ([2804:1bc4:224:7800:585c:db3a:fcb:e21f])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45eb6c9de2dsm21698074f8f.4.2026.05.24.16.50.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 May 2026 16:50:53 -0700 (PDT)
From: Marcos Paulo de Souza <mpdesouza@suse.com>
Date: Sun, 24 May 2026 20:50:32 -0300
Subject: [PATCH 3/4] selftests: livepatch: Adapt mod_target module to pass
 on 4.12 kernels
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260524-livepatch-unload-on-fail-v1-3-7465de7f741d@suse.com>
References: <20260524-livepatch-unload-on-fail-v1-0-7465de7f741d@suse.com>
In-Reply-To: <20260524-livepatch-unload-on-fail-v1-0-7465de7f741d@suse.com>
To: Josh Poimboeuf <jpoimboe@kernel.org>, Jiri Kosina <jikos@kernel.org>, 
 Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>, 
 Joe Lawrence <joe.lawrence@redhat.com>, Shuah Khan <shuah@kernel.org>
Cc: live-patching@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Marcos Paulo de Souza <mpdesouza@suse.com>, 
 marcos@mpdesouza.com
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1779666636; l=7263;
 i=mpdesouza@suse.com; s=20231031; h=from:subject:message-id;
 bh=I7SegwAIOnn8Zt1SWPZf8rhhwlN2a4741JSURcMiDOw=;
 b=1uJcE2ihxX9xMhy8tFuu81DedgR/I+bCRVHF3aRExvGqRtd/379RSWq8vg8SYgCqJCQYEGxLY
 ycGoA8VvjToC/kRcqnAweBnCbRu6ekcKcQTE24TaC5HIl81w+75k/cd
X-Developer-Key: i=mpdesouza@suse.com; a=ed25519;
 pk=/Ni/TsKkr69EOmdZXkp1Q/BlzDonbOBRsfPa18ySIwU=
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[suse.com,quarantine];
	R_DKIM_ALLOW(-0.20)[suse.com:s=google];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DKIM_TRACE(0.00)[suse.com:+];
	TAGGED_FROM(0.00)[bounces-2879-lists,live-patching=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_SEVEN(0.00)[11];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.com:mid,suse.com:dkim,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Queue-Id: 304ED5C4D0C
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Use the stable module_param_cb API instead of proc_fs for exposing module
state. This approach is compatible with kernel 4.12 and later. The end
result is the same: the module has a function that shows a string, which
is later livepatched to show a different string. The only difference is
that the file being checked is now a module parameter instead of a
procfs entry.

Signed-off-by: Marcos Paulo de Souza <mpdesouza@suse.com>
---
 tools/testing/selftests/livepatch/functions.sh     |  1 +
 .../testing/selftests/livepatch/test-livepatch.sh  | 23 +++++++++++-----------
 .../livepatch/test_modules/test_klp_mod_patch.c    | 11 +++++------
 .../livepatch/test_modules/test_klp_mod_target.c   | 22 ++++++++++-----------
 4 files changed, 27 insertions(+), 30 deletions(-)

diff --git a/tools/testing/selftests/livepatch/functions.sh b/tools/testing/selftests/livepatch/functions.sh
index 25f137003865..c8c99851c3a2 100644
--- a/tools/testing/selftests/livepatch/functions.sh
+++ b/tools/testing/selftests/livepatch/functions.sh
@@ -7,6 +7,7 @@
 MAX_RETRIES=600
 RETRY_INTERVAL=".1"	# seconds
 SYSFS_KERNEL_DIR="/sys/kernel"
+SYSFS_MODULE_DIR="/sys/module"
 SYSFS_KLP_DIR="$SYSFS_KERNEL_DIR/livepatch"
 SYSFS_DEBUG_DIR="$SYSFS_KERNEL_DIR/debug"
 SYSFS_KPROBES_DIR="$SYSFS_DEBUG_DIR/kprobes"
diff --git a/tools/testing/selftests/livepatch/test-livepatch.sh b/tools/testing/selftests/livepatch/test-livepatch.sh
index c44c5341a2f1..06aacf0f4dc7 100755
--- a/tools/testing/selftests/livepatch/test-livepatch.sh
+++ b/tools/testing/selftests/livepatch/test-livepatch.sh
@@ -198,26 +198,25 @@ livepatch: '$MOD_REPLACE': unpatching complete
 % rmmod $MOD_REPLACE"
 
 
-# - load a target module that provides /proc/test_klp_mod_target with
-#   original output
-# - load a livepatch that patches the target module's show function
-# - verify the proc entry returns livepatched output
+# - load a target module with module_param_cb get data with original output
+# - load a livepatch that patches the target module's get function
+# - verify the parameter get function returns the livepatched output
 # - disable and unload the livepatch
-# - verify the proc entry returns original output again
+# - verify the parameter get function returns the original output again
 # - unload the target module
 
 start_test "module function patching"
 
 load_mod $MOD_TARGET
 
-if [[ "$(cat /proc/$MOD_TARGET)" != "$MOD_TARGET: original output" ]] ; then
+if [[ "$(cat $SYSFS_MODULE_DIR/$MOD_TARGET/parameters/klp_mod_arg)" != "$MOD_TARGET: original output" ]] ; then
 	echo -e "FAIL\n\n"
 	die "livepatch kselftest(s) failed"
 fi
 
 load_lp $MOD_TARGET_PATCH
 
-if [[ "$(cat /proc/$MOD_TARGET)" != "$MOD_TARGET_PATCH: this has been live patched" ]] ; then
+if [[ "$(cat $SYSFS_MODULE_DIR/$MOD_TARGET/parameters/klp_mod_arg)" != "$MOD_TARGET_PATCH: this has been live patched" ]] ; then
 	echo -e "FAIL\n\n"
 	die "livepatch kselftest(s) failed"
 fi
@@ -225,7 +224,7 @@ fi
 disable_lp $MOD_TARGET_PATCH
 unload_lp $MOD_TARGET_PATCH
 
-if [[ "$(cat /proc/$MOD_TARGET)" != "$MOD_TARGET: original output" ]] ; then
+if [[ "$(cat $SYSFS_MODULE_DIR/$MOD_TARGET/parameters/klp_mod_arg)" != "$MOD_TARGET: original output" ]] ; then
 	echo -e "FAIL\n\n"
 	die "livepatch kselftest(s) failed"
 fi
@@ -252,9 +251,9 @@ $MOD_TARGET: test_klp_mod_target_exit"
 
 # - load a livepatch that targets a not-yet-loaded module
 # - load the target module: klp_module_coming patches it immediately
-# - verify the proc entry returns livepatched output
+# - verify the parameter get function returns the livepatched output
 # - disable and unload the livepatch
-# - verify the proc entry returns original output again
+# - verify the parameter get function returns the original output again
 # - unload the target module
 
 start_test "module function patching (livepatch first)"
@@ -262,7 +261,7 @@ start_test "module function patching (livepatch first)"
 load_lp $MOD_TARGET_PATCH
 load_mod $MOD_TARGET
 
-if [[ "$(cat /proc/$MOD_TARGET)" != "$MOD_TARGET_PATCH: this has been live patched" ]] ; then
+if [[ "$(cat $SYSFS_MODULE_DIR/$MOD_TARGET/parameters/klp_mod_arg)" != "$MOD_TARGET_PATCH: this has been live patched" ]] ; then
 	echo -e "FAIL\n\n"
 	die "livepatch kselftest(s) failed"
 fi
@@ -270,7 +269,7 @@ fi
 disable_lp $MOD_TARGET_PATCH
 unload_lp $MOD_TARGET_PATCH
 
-if [[ "$(cat /proc/$MOD_TARGET)" != "$MOD_TARGET: original output" ]] ; then
+if [[ "$(cat $SYSFS_MODULE_DIR/$MOD_TARGET/parameters/klp_mod_arg)" != "$MOD_TARGET: original output" ]] ; then
 	echo -e "FAIL\n\n"
 	die "livepatch kselftest(s) failed"
 fi
diff --git a/tools/testing/selftests/livepatch/test_modules/test_klp_mod_patch.c b/tools/testing/selftests/livepatch/test_modules/test_klp_mod_patch.c
index 6725b4720365..ab56e57c02a8 100644
--- a/tools/testing/selftests/livepatch/test_modules/test_klp_mod_patch.c
+++ b/tools/testing/selftests/livepatch/test_modules/test_klp_mod_patch.c
@@ -8,17 +8,16 @@
 #include <linux/livepatch.h>
 #include <linux/seq_file.h>
 
-static int livepatch_mod_target_show(struct seq_file *m, void *v)
+static int livepatch_mod_target_get(char *buffer, const struct kernel_param *kp)
 {
-	seq_printf(m, "%s: %s\n", THIS_MODULE->name,
-		   "this has been live patched");
-	return 0;
+	return sprintf(buffer, "%s: %s\n", THIS_MODULE->name,
+		       "this has been live patched");
 }
 
 static struct klp_func funcs[] = {
 	{
-		.old_name = "test_klp_mod_target_show",
-		.new_func = livepatch_mod_target_show,
+		.old_name = "test_klp_mod_target_get",
+		.new_func = livepatch_mod_target_get,
 	},
 	{},
 };
diff --git a/tools/testing/selftests/livepatch/test_modules/test_klp_mod_target.c b/tools/testing/selftests/livepatch/test_modules/test_klp_mod_target.c
index 9643984d2402..1382a266825f 100644
--- a/tools/testing/selftests/livepatch/test_modules/test_klp_mod_target.c
+++ b/tools/testing/selftests/livepatch/test_modules/test_klp_mod_target.c
@@ -5,31 +5,29 @@
 
 #include <linux/module.h>
 #include <linux/kernel.h>
-#include <linux/proc_fs.h>
-#include <linux/seq_file.h>
+#include <linux/moduleparam.h>
 
-static struct proc_dir_entry *pde;
-
-static noinline int test_klp_mod_target_show(struct seq_file *m, void *v)
+static noinline int test_klp_mod_target_get(char *buffer, const struct kernel_param *kp)
 {
-	seq_printf(m, "%s: %s\n", THIS_MODULE->name, "original output");
-	return 0;
+	return sprintf(buffer, "%s: %s\n", THIS_MODULE->name, "original output");
 }
 
+static const struct kernel_param_ops test_klp_mod_target_ops = {
+	.get = test_klp_mod_target_get,
+};
+
+module_param_cb(klp_mod_arg, &test_klp_mod_target_ops, NULL, 0444);
+MODULE_PARM_DESC(klp_mod_arg, "The value of this argument will be livepatched");
+
 static int test_klp_mod_target_init(void)
 {
 	pr_info("%s\n", __func__);
-	pde = proc_create_single("test_klp_mod_target", 0, NULL,
-				 test_klp_mod_target_show);
-	if (!pde)
-		return -ENOMEM;
 	return 0;
 }
 
 static void test_klp_mod_target_exit(void)
 {
 	pr_info("%s\n", __func__);
-	proc_remove(pde);
 }
 
 module_init(test_klp_mod_target_init);

-- 
2.54.0


