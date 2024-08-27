Return-Path: <live-patching+bounces-526-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 573D3960A68
	for <lists+live-patching@lfdr.de>; Tue, 27 Aug 2024 14:32:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7C6811C227F3
	for <lists+live-patching@lfdr.de>; Tue, 27 Aug 2024 12:32:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 470581BD01F;
	Tue, 27 Aug 2024 12:31:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="ASA3vQ2u";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="czc0dqFT";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="ASA3vQ2u";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="czc0dqFT"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B8AB1BC07B;
	Tue, 27 Aug 2024 12:31:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724761872; cv=none; b=lignf+WLAxI1yLjZOQGAF1SOlaywYQYBk68H/cQTeM6EUaTVdOJQxbWlfyRM2eTkXLjw03gUmJAE1Hwxnon3Bn2GHmhyF0VjZ0gOUBdRfjIeCwHOXRHNjDo3CPRGYwuZlvpZIIxqe5vrnP4atXA3sKCnYzUKpM1V32n52HDDCuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724761872; c=relaxed/simple;
	bh=6NRvS1RZNwSGF4DdnQa4Sni6Ahsc9chE28PR8iuJCV4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ExOFfb4jHhMc2qj1p9AJLvAQ+uhs2Up+VhzDTeWgkAy7Zvf6hZBQJooNb5oi1dY+PQWH7zYj0SnHICRYjBF9HDP08y784gJyrGDvap/zAip4iWHYhIDKsDmIdi3xY9gKReESSZ9NMLeZMQrUZfMjYr3E43/4CCLfVtBQeXmVQqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=ASA3vQ2u; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=czc0dqFT; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=ASA3vQ2u; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=czc0dqFT; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id B734C1FB72;
	Tue, 27 Aug 2024 12:31:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1724761865; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bn+qDqSr7xojaYFSBqbzeU0Y6hv6M/Cugsv7da+QHls=;
	b=ASA3vQ2u3/Kq68fJ4Me5s6HU2INlJ0r6/q5sdQ1acW7K+7w3VCg5ozX7DB5kRlto3mdyBV
	xQX0jIVWQ9pLlggXjZLyhG7XbPdCL2S7WGuMGNA5fJDFztU+ccbtRsTC13ydWvHHoTS2lU
	9ARMBIm/4V/QoFEyRgjkWaoAueqdNhY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1724761865;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bn+qDqSr7xojaYFSBqbzeU0Y6hv6M/Cugsv7da+QHls=;
	b=czc0dqFTxllER4rSuGtCK9JcLopnZc/tIbpQtZzp3jHaq0C5Hwj33GTZUb6SivXfas0Lb/
	r3IXclzU+Frbg/BA==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1724761865; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bn+qDqSr7xojaYFSBqbzeU0Y6hv6M/Cugsv7da+QHls=;
	b=ASA3vQ2u3/Kq68fJ4Me5s6HU2INlJ0r6/q5sdQ1acW7K+7w3VCg5ozX7DB5kRlto3mdyBV
	xQX0jIVWQ9pLlggXjZLyhG7XbPdCL2S7WGuMGNA5fJDFztU+ccbtRsTC13ydWvHHoTS2lU
	9ARMBIm/4V/QoFEyRgjkWaoAueqdNhY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1724761865;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bn+qDqSr7xojaYFSBqbzeU0Y6hv6M/Cugsv7da+QHls=;
	b=czc0dqFTxllER4rSuGtCK9JcLopnZc/tIbpQtZzp3jHaq0C5Hwj33GTZUb6SivXfas0Lb/
	r3IXclzU+Frbg/BA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id ADA9B13A94;
	Tue, 27 Aug 2024 12:31:05 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id VptLKgnHzWbGYwAAD6G6ig
	(envelope-from <lhruska@suse.cz>); Tue, 27 Aug 2024 12:31:05 +0000
From: Lukas Hruska <lhruska@suse.cz>
To: pmladek@suse.com,
	mbenes@suse.cz,
	jpoimboe@kernel.org
Cc: joe.lawrence@redhat.com,
	live-patching@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kbuild@vger.kernel.org,
	mpdesouza@suse.com,
	lhruska@suse.cz
Subject: [PATCH v3 6/6] selftests: livepatch: Test livepatching function using an external symbol
Date: Tue, 27 Aug 2024 14:30:51 +0200
Message-ID: <20240827123052.9002-7-lhruska@suse.cz>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240827123052.9002-1-lhruska@suse.cz>
References: <20240827123052.9002-1-lhruska@suse.cz>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Spamd-Result: default: False [-6.80 / 50.00];
	REPLY(-4.00)[];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	ARC_NA(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	RCPT_COUNT_SEVEN(0.00)[9];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:email,suse.cz:mid,suse.com:email,imap1.dmz-prg2.suse.org:helo];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_NONE(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Score: -6.80
X-Spam-Flag: NO

The test proves that klp-convert works as intended and it is possible to
livepatch a function that use an external symbol.

Signed-off-by: Lukas Hruska <lhruska@suse.cz>
Reviewed-by: Petr Mladek <pmladek@suse.com>
Tested-by: Petr Mladek <pmladek@suse.com>
---
 tools/testing/selftests/livepatch/Makefile    |  3 +-
 .../testing/selftests/livepatch/functions.sh  | 14 +++++
 .../selftests/livepatch/test-extern.sh        | 57 +++++++++++++++++++
 .../selftests/livepatch/test_modules/Makefile |  2 +
 .../livepatch/test_modules/test_klp_extern.c  | 51 +++++++++++++++++
 .../test_modules/test_klp_extern_hello.c      | 36 ++++++++++++
 6 files changed, 162 insertions(+), 1 deletion(-)
 create mode 100755 tools/testing/selftests/livepatch/test-extern.sh
 create mode 100644 tools/testing/selftests/livepatch/test_modules/test_klp_extern.c
 create mode 100644 tools/testing/selftests/livepatch/test_modules/test_klp_extern_hello.c

diff --git a/tools/testing/selftests/livepatch/Makefile b/tools/testing/selftests/livepatch/Makefile
index 35418a4790be..611ee16bef56 100644
--- a/tools/testing/selftests/livepatch/Makefile
+++ b/tools/testing/selftests/livepatch/Makefile
@@ -10,7 +10,8 @@ TEST_PROGS := \
 	test-state.sh \
 	test-ftrace.sh \
 	test-sysfs.sh \
-	test-syscall.sh
+	test-syscall.sh \
+	test-extern.sh
 
 TEST_FILES := settings
 
diff --git a/tools/testing/selftests/livepatch/functions.sh b/tools/testing/selftests/livepatch/functions.sh
index fc4c6a016d38..9b6a19eee3a2 100644
--- a/tools/testing/selftests/livepatch/functions.sh
+++ b/tools/testing/selftests/livepatch/functions.sh
@@ -7,6 +7,7 @@
 MAX_RETRIES=600
 RETRY_INTERVAL=".1"	# seconds
 KLP_SYSFS_DIR="/sys/kernel/livepatch"
+MODULE_SYSFS_DIR="/sys/module"
 
 # Kselftest framework requirement - SKIP code is 4
 ksft_skip=4
@@ -344,3 +345,16 @@ function check_sysfs_value() {
 		die "Unexpected value in $path: $expected_value vs. $value"
 	fi
 }
+
+# read_module_param_value(modname, param) - read module parameter value
+#  modname - livepatch module creating the sysfs interface
+#  param - parameter name
+function read_module_param() {
+   local mod="$1"; shift
+   local param="$1"; shift
+
+   local path="$MODULE_SYSFS_DIR/$mod/parameters/$param"
+
+   log "% echo \"$mod/parameters/$param: \$(cat $path)\""
+   log "$mod/parameters/$param: $(cat $path)"
+}
diff --git a/tools/testing/selftests/livepatch/test-extern.sh b/tools/testing/selftests/livepatch/test-extern.sh
new file mode 100755
index 000000000000..3dde6cabb07c
--- /dev/null
+++ b/tools/testing/selftests/livepatch/test-extern.sh
@@ -0,0 +1,57 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (C) 2024 Lukas Hruska <lhruska@suse.cz>
+
+. $(dirname $0)/functions.sh
+
+MOD_LIVEPATCH=test_klp_extern
+MOD_HELLO=test_klp_extern_hello
+PARAM_HELLO=hello
+
+setup_config
+
+# - load a module to be livepatched
+# - load a livepatch that modifies the output from 'hello' parameter
+#   of the previously loaded module and verify correct behaviour
+# - unload the livepatch and make sure the patch was removed
+# - unload the module that was livepatched
+
+start_test "livepatch with external symbol"
+
+load_mod $MOD_HELLO
+
+read_module_param $MOD_HELLO $PARAM_HELLO
+
+load_lp $MOD_LIVEPATCH
+
+read_module_param $MOD_HELLO $PARAM_HELLO
+
+disable_lp $MOD_LIVEPATCH
+unload_lp $MOD_LIVEPATCH
+
+read_module_param $MOD_HELLO $PARAM_HELLO
+
+unload_mod $MOD_HELLO
+
+check_result "% insmod test_modules/$MOD_HELLO.ko
+% echo \"$MOD_HELLO/parameters/$PARAM_HELLO: \$(cat /sys/module/$MOD_HELLO/parameters/$PARAM_HELLO)\"
+$MOD_HELLO/parameters/$PARAM_HELLO: Hello from kernel module.
+% insmod test_modules/$MOD_LIVEPATCH.ko
+livepatch: enabling patch '$MOD_LIVEPATCH'
+livepatch: '$MOD_LIVEPATCH': initializing patching transition
+livepatch: '$MOD_LIVEPATCH': starting patching transition
+livepatch: '$MOD_LIVEPATCH': completing patching transition
+livepatch: '$MOD_LIVEPATCH': patching complete
+% echo \"$MOD_HELLO/parameters/$PARAM_HELLO: \$(cat /sys/module/$MOD_HELLO/parameters/$PARAM_HELLO)\"
+$MOD_HELLO/parameters/$PARAM_HELLO: Hello from livepatched module.
+% echo 0 > /sys/kernel/livepatch/$MOD_LIVEPATCH/enabled
+livepatch: '$MOD_LIVEPATCH': initializing unpatching transition
+livepatch: '$MOD_LIVEPATCH': starting unpatching transition
+livepatch: '$MOD_LIVEPATCH': completing unpatching transition
+livepatch: '$MOD_LIVEPATCH': unpatching complete
+% rmmod $MOD_LIVEPATCH
+% echo \"$MOD_HELLO/parameters/$PARAM_HELLO: \$(cat /sys/module/$MOD_HELLO/parameters/$PARAM_HELLO)\"
+$MOD_HELLO/parameters/$PARAM_HELLO: Hello from kernel module.
+% rmmod $MOD_HELLO"
+
+exit 0
diff --git a/tools/testing/selftests/livepatch/test_modules/Makefile b/tools/testing/selftests/livepatch/test_modules/Makefile
index e6e638c4bcba..0d6df14787da 100644
--- a/tools/testing/selftests/livepatch/test_modules/Makefile
+++ b/tools/testing/selftests/livepatch/test_modules/Makefile
@@ -6,6 +6,8 @@ obj-m += test_klp_atomic_replace.o \
 	test_klp_callbacks_demo.o \
 	test_klp_callbacks_demo2.o \
 	test_klp_callbacks_mod.o \
+	test_klp_extern.o \
+	test_klp_extern_hello.o \
 	test_klp_livepatch.o \
 	test_klp_state.o \
 	test_klp_state2.o \
diff --git a/tools/testing/selftests/livepatch/test_modules/test_klp_extern.c b/tools/testing/selftests/livepatch/test_modules/test_klp_extern.c
new file mode 100644
index 000000000000..2a88ae289668
--- /dev/null
+++ b/tools/testing/selftests/livepatch/test_modules/test_klp_extern.c
@@ -0,0 +1,51 @@
+// SPDX-License-Identifier: GPL-2.0
+// Copyright (C) 2024 Lukas Hruska <lhruska@suse.cz>
+
+#define pr_fmt(fmt) "test_klp_extern_hello: " fmt
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/livepatch.h>
+
+extern const char *hello_msg \
+		   KLP_RELOC_SYMBOL(test_klp_extern_hello, test_klp_extern_hello, hello_msg);
+
+static int hello_get(char *buffer, const struct kernel_param *kp)
+{
+	return sysfs_emit(buffer, "%s livepatched module.\n", hello_msg);
+}
+
+static struct klp_func funcs[] = {
+	{
+		.old_name = "hello_get",
+		.new_func = hello_get,
+	}, { }
+};
+
+static struct klp_object objs[] = {
+	{
+		.name = "test_klp_extern_hello",
+		.funcs = funcs,
+	}, { }
+};
+
+static struct klp_patch patch = {
+	.mod = THIS_MODULE,
+	.objs = objs,
+};
+
+static int test_klp_extern_init(void)
+{
+	return klp_enable_patch(&patch);
+}
+
+static void test_klp_extern_exit(void)
+{
+}
+
+module_init(test_klp_extern_init);
+module_exit(test_klp_extern_exit);
+MODULE_LICENSE("GPL");
+MODULE_INFO(livepatch, "Y");
+MODULE_AUTHOR("Lukas Hruska <lhruska@suse.cz>");
+MODULE_DESCRIPTION("Livepatch test: external symbol relocation");
diff --git a/tools/testing/selftests/livepatch/test_modules/test_klp_extern_hello.c b/tools/testing/selftests/livepatch/test_modules/test_klp_extern_hello.c
new file mode 100644
index 000000000000..431c55b5849a
--- /dev/null
+++ b/tools/testing/selftests/livepatch/test_modules/test_klp_extern_hello.c
@@ -0,0 +1,36 @@
+// SPDX-License-Identifier: GPL-2.0
+// Copyright (C) 2024 Lukas Hruska <lhruska@suse.cz>
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+
+const char *hello_msg = "Hello from";
+
+static int hello_get(char *buffer, const struct kernel_param *kp)
+{
+	return sysfs_emit(buffer, "%s kernel module.\n", hello_msg);
+}
+
+static const struct kernel_param_ops hello_ops = {
+	.get	= hello_get,
+};
+
+module_param_cb(hello, &hello_ops, NULL, 0400);
+MODULE_PARM_DESC(hello, "Read only parameter greeting the reader.");
+
+static int test_klp_extern_hello_init(void)
+{
+	return 0;
+}
+
+static void test_klp_extern_hello_exit(void)
+{
+}
+
+module_init(test_klp_extern_hello_init);
+module_exit(test_klp_extern_hello_exit);
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Lukas Hruska <lhruska@suse.cz>");
+MODULE_DESCRIPTION("Livepatch test: external symbol relocation - test module");
-- 
2.46.0


