Return-Path: <live-patching+bounces-525-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2FEA3960A6A
	for <lists+live-patching@lfdr.de>; Tue, 27 Aug 2024 14:32:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 549A01C22C6D
	for <lists+live-patching@lfdr.de>; Tue, 27 Aug 2024 12:32:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AEC721BCA19;
	Tue, 27 Aug 2024 12:31:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="I0g1aGK0";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="HVFdO4IA";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="I0g1aGK0";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="HVFdO4IA"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA0891BC9E9;
	Tue, 27 Aug 2024 12:31:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724761870; cv=none; b=qUAn02emdi7HnA9TCEOKlInhJlzTUOQXlWJzYJvoPbI6sNZ/yOMW6c26yBy2fmLtwXIQ2CsurMxEpa9NLWviOkf1ZnNG2wR3IeJ9v6MZcgGxIQKFwC37vwSVckZZlxLWpKLKE5ehbYl+DCEr5NICvAdOUSiVznUxhIj+u3FRlzU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724761870; c=relaxed/simple;
	bh=CiDc3AlGeKOrysrp/CgBganzjOryXmBiKhxPXuepiqk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o6SJEFF9I2UGqj4+dJljMBYhbVVFZ3WgvE5fxSbp4J+d7QH+LLj1hWyGKI9O+9dSZsdHXr5mNGrDGzCJYhINpl3/udr18MwA8/DOpHiFXuFFaxA1WCHMCTaa1lfjBO55sy/YtVzcKsHW9fodLm1BT1Kf1pdZjNcTs3pbPfZQjtk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=I0g1aGK0; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=HVFdO4IA; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=I0g1aGK0; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=HVFdO4IA; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 0AD6D1FB73;
	Tue, 27 Aug 2024 12:31:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1724761867; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=r5AnqN2FneO8Qgbj2+/+ZJF0wdzB6eYns1Tk7nxauVE=;
	b=I0g1aGK0F190P2PsNBcVgPLAOoSD0aonJE2vDUq6kDkQ5ShZV9x3BWKUgIqkzEw5lUjOhM
	zlCFhWAldpuAVNK0KaMvuFoSbpyk56As3lduT87dbBKOXIWUETtXLb0tYghAYyTLH6YpYH
	Vns5NY0+LOjZ0vSqu1v8lp/p4K5wF0c=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1724761867;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=r5AnqN2FneO8Qgbj2+/+ZJF0wdzB6eYns1Tk7nxauVE=;
	b=HVFdO4IA2nAQtO2qw/J8XbPnt1j3Sw+0YM3bkC1xQozeosMb6VpFVXkzVo0AHdpoEHzG08
	keivXZrxKa5xuVCQ==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1724761867; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=r5AnqN2FneO8Qgbj2+/+ZJF0wdzB6eYns1Tk7nxauVE=;
	b=I0g1aGK0F190P2PsNBcVgPLAOoSD0aonJE2vDUq6kDkQ5ShZV9x3BWKUgIqkzEw5lUjOhM
	zlCFhWAldpuAVNK0KaMvuFoSbpyk56As3lduT87dbBKOXIWUETtXLb0tYghAYyTLH6YpYH
	Vns5NY0+LOjZ0vSqu1v8lp/p4K5wF0c=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1724761867;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=r5AnqN2FneO8Qgbj2+/+ZJF0wdzB6eYns1Tk7nxauVE=;
	b=HVFdO4IA2nAQtO2qw/J8XbPnt1j3Sw+0YM3bkC1xQozeosMb6VpFVXkzVo0AHdpoEHzG08
	keivXZrxKa5xuVCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 0466313724;
	Tue, 27 Aug 2024 12:31:07 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 1/EQAQvHzWbLYwAAD6G6ig
	(envelope-from <lhruska@suse.cz>); Tue, 27 Aug 2024 12:31:07 +0000
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
Subject: [PATCH v3 7/6 DONT_MERGE] selftests: livepatch: Test failing IBT checks crashing the module
Date: Tue, 27 Aug 2024 14:30:52 +0200
Message-ID: <20240827123052.9002-8-lhruska@suse.cz>
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
	RCVD_COUNT_TWO(0.00)[2];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:email,suse.cz:mid,imap1.dmz-prg2.suse.org:helo];
	RCPT_COUNT_SEVEN(0.00)[9];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	R_RATELIMIT(0.00)[to_ip_from(RLwfjdgm737utdgph7keiopinp)];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Score: -6.80
X-Spam-Flag: NO

This patch is only an example of how to generate #GP by IBT.
It serves only as an example for those wondering how the Linux behaves
in this case.
Don't merge this patch, because it causes a refcount underflow of the test
module, so it's not possible to unload it.

Signed-off-by: Lukas Hruska <lhruska@suse.cz>
---
 tools/testing/selftests/livepatch/Makefile    |  4 ++
 tools/testing/selftests/livepatch/test-ibt.sh | 57 +++++++++++++++++++
 .../selftests/livepatch/test_modules/Makefile |  2 +
 .../test_modules/test_klp_extern_hello.c      | 20 +++++++
 .../livepatch/test_modules/test_klp_ibt.c     | 51 +++++++++++++++++
 5 files changed, 134 insertions(+)
 create mode 100644 tools/testing/selftests/livepatch/test-ibt.sh
 create mode 100644 tools/testing/selftests/livepatch/test_modules/test_klp_ibt.c

diff --git a/tools/testing/selftests/livepatch/Makefile b/tools/testing/selftests/livepatch/Makefile
index 611ee16bef56..3ef2040e4c50 100644
--- a/tools/testing/selftests/livepatch/Makefile
+++ b/tools/testing/selftests/livepatch/Makefile
@@ -13,6 +13,10 @@ TEST_PROGS := \
 	test-syscall.sh \
 	test-extern.sh
 
+ifdef CONFIG_X86_KERNEL_IBT
+	TEST_PROGS += test-ibt.sh
+endif
+
 TEST_FILES := settings
 
 include ../lib.mk
diff --git a/tools/testing/selftests/livepatch/test-ibt.sh b/tools/testing/selftests/livepatch/test-ibt.sh
new file mode 100644
index 000000000000..c5f49fb7af4d
--- /dev/null
+++ b/tools/testing/selftests/livepatch/test-ibt.sh
@@ -0,0 +1,57 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (C) 2024 Lukas Hruska <lhruska@suse.cz>
+
+. $(dirname $0)/functions.sh
+
+MOD_LIVEPATCH=test_klp_ibt
+MOD_HELLO=test_klp_extern_hello
+PARAM_HELLO=hello
+
+setup_config
+
+# - load a module to be livepatched
+# - load a livepatch that calls the unused function which does not have endbr64
+#   as its first instruction
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
index 0d6df14787da..49a22ea90f3a 100644
--- a/tools/testing/selftests/livepatch/test_modules/Makefile
+++ b/tools/testing/selftests/livepatch/test_modules/Makefile
@@ -15,6 +15,8 @@ obj-m += test_klp_atomic_replace.o \
 	test_klp_shadow_vars.o \
 	test_klp_syscall.o
 
+obj-$(CONFIG_X86_KERNEL_IBT) += test_klp_ibt.o
+
 # Ensure that KDIR exists, otherwise skip the compilation
 modules:
 ifneq ("$(wildcard $(KDIR))", "")
diff --git a/tools/testing/selftests/livepatch/test_modules/test_klp_extern_hello.c b/tools/testing/selftests/livepatch/test_modules/test_klp_extern_hello.c
index 431c55b5849a..37e1cd2cecdb 100644
--- a/tools/testing/selftests/livepatch/test_modules/test_klp_extern_hello.c
+++ b/tools/testing/selftests/livepatch/test_modules/test_klp_extern_hello.c
@@ -13,6 +13,26 @@ static int hello_get(char *buffer, const struct kernel_param *kp)
 	return sysfs_emit(buffer, "%s kernel module.\n", hello_msg);
 }
 
+#ifdef CONFIG_X86_KERNEL_IBT
+static __attribute__((nocf_check)) int hello_get_alt(char *buffer, const struct kernel_param *kp)
+{
+	return sysfs_emit(buffer, "%s unused function.\n", hello_msg);
+}
+
+static int fail_get(char *buffer, const struct kernel_param *kp)
+{
+	int __attribute__((nocf_check)) (* volatile klpe_hello_get_alt)(char *, const struct kernel_param *) = hello_get_alt;
+	return (*klpe_hello_get_alt)(buffer, kp);
+}
+
+static const struct kernel_param_ops fail_ops = {
+	.get	= fail_get,
+};
+
+module_param_cb(fail, &fail_ops, NULL, 0400);
+MODULE_PARM_DESC(fail, "Read only parameter failing the reader.");
+#endif
+
 static const struct kernel_param_ops hello_ops = {
 	.get	= hello_get,
 };
diff --git a/tools/testing/selftests/livepatch/test_modules/test_klp_ibt.c b/tools/testing/selftests/livepatch/test_modules/test_klp_ibt.c
new file mode 100644
index 000000000000..3b76d175d398
--- /dev/null
+++ b/tools/testing/selftests/livepatch/test_modules/test_klp_ibt.c
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
+extern int hello_get_alt(char *buffer, const struct kernel_param *kp)
+			KLP_RELOC_SYMBOL(test_klp_extern_hello, test_klp_extern_hello, hello_get_alt);
+
+static int hello_get(char *buffer, const struct kernel_param *kp)
+{
+	return hello_get_alt(buffer, kp);
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
+MODULE_DESCRIPTION("Livepatch test: external function call with IBT enabled");
-- 
2.46.0


