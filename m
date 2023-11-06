Return-Path: <live-patching+bounces-20-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BAFA97E29B8
	for <lists+live-patching@lfdr.de>; Mon,  6 Nov 2023 17:26:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7338928111E
	for <lists+live-patching@lfdr.de>; Mon,  6 Nov 2023 16:26:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 166A129410;
	Mon,  6 Nov 2023 16:26:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="NCk+r0Y4";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="DPkgDCIO"
X-Original-To: live-patching@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 645AD29406
	for <live-patching@vger.kernel.org>; Mon,  6 Nov 2023 16:26:43 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98F7AD6E;
	Mon,  6 Nov 2023 08:26:37 -0800 (PST)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
	by smtp-out1.suse.de (Postfix) with ESMTP id 4A44B21FB1;
	Mon,  6 Nov 2023 16:26:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1699287996; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yzy6WdAu4zUhGh00Y0VCC7JcjKgDFG4rvSRes5x9/wE=;
	b=NCk+r0Y4zoBU6ywtEqoW+/+WJBBg1rXmewOi0LEv6MP6U8+nalS0XyEqUleJvtrjN8WVZV
	OwjEj4inL8x0zlfJTn0LbpbT0+SkBbppP3mxMPbL9/+F34QI2itmWniSrbJyzOYk3IJfNA
	yN4FW/E8Dv6SX/sLMT9+ZDutI8Z/5uE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1699287996;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yzy6WdAu4zUhGh00Y0VCC7JcjKgDFG4rvSRes5x9/wE=;
	b=DPkgDCIO8Kxi7hEJ3ed4g4OBpNmgdEGMOd89nz+SXMI+rwzd5r6hHSno/mMeWYBNVRz3Zo
	fP8eIP3Iz0B41zBw==
Received: from localhost.cz (lhruska.udp.ovpn2.prg.suse.de [10.100.204.118])
	by relay2.suse.de (Postfix) with ESMTP id D95612C1D6;
	Mon,  6 Nov 2023 16:26:35 +0000 (UTC)
From: Lukas Hruska <lhruska@suse.cz>
To: Petr Mladek <pmladek@suse.com>,
	Miroslav Benes <mbenes@suse.cz>,
	Josh Poimboeuf <jpoimboe@kernel.org>
Cc: Joe Lawrence <joe.lawrence@redhat.com>,
	live-patching@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kbuild@vger.kernel.org,
	Marcos Paulo de Souza <mpdesouza@suse.com>,
	Josh Poimboeuf <jpoimboe@redhat.com>,
	Lukas Hruska <lhruska@suse.cz>
Subject: [PATCH v1 4/5] livepatch: Add sample livepatch module
Date: Mon,  6 Nov 2023 17:25:12 +0100
Message-ID: <20231106162513.17556-5-lhruska@suse.cz>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231106162513.17556-1-lhruska@suse.cz>
References: <20231106162513.17556-1-lhruska@suse.cz>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Josh Poimboeuf <jpoimboe@redhat.com>

Add a new livepatch sample in samples/livepatch/ to make use of symbols
that must be post-processed to enable load-time relocation resolution.
As the new sample is to be used as an example, it is annotated with
KLP_RELOC_SYMBOL macro.

The livepatch sample updates the function cmdline_proc_show to print the
string referenced by the symbol saved_command_line appended by the
string "livepatch=1".

Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
Signed-off-by: Lukas Hruska <lhruska@suse.cz>
---
 samples/livepatch/Makefile                    |  1 +
 .../livepatch/livepatch-annotated-sample.c    | 84 +++++++++++++++++++
 2 files changed, 85 insertions(+)
 create mode 100644 samples/livepatch/livepatch-annotated-sample.c

diff --git a/samples/livepatch/Makefile b/samples/livepatch/Makefile
index 9f853eeb6140..f2b41f4d6c16 100644
--- a/samples/livepatch/Makefile
+++ b/samples/livepatch/Makefile
@@ -6,3 +6,4 @@ obj-$(CONFIG_SAMPLE_LIVEPATCH) += livepatch-shadow-fix2.o
 obj-$(CONFIG_SAMPLE_LIVEPATCH) += livepatch-callbacks-demo.o
 obj-$(CONFIG_SAMPLE_LIVEPATCH) += livepatch-callbacks-mod.o
 obj-$(CONFIG_SAMPLE_LIVEPATCH) += livepatch-callbacks-busymod.o
+obj-$(CONFIG_SAMPLE_LIVEPATCH) += livepatch-annotated-sample.o
diff --git a/samples/livepatch/livepatch-annotated-sample.c b/samples/livepatch/livepatch-annotated-sample.c
new file mode 100644
index 000000000000..36056670f0fa
--- /dev/null
+++ b/samples/livepatch/livepatch-annotated-sample.c
@@ -0,0 +1,84 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (C) 2014 Seth Jennings <sjenning@redhat.com>
+ */
+
+/*
+ * livepatch-annotated-sample.c - Kernel Live Patching Sample Module
+ */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/livepatch.h>
+
+/*
+ * This (dumb) live patch overrides the function that prints the
+ * kernel boot cmdline when /proc/cmdline is read.
+ *
+ * This livepatch uses the symbol saved_command_line whose relocation
+ * must be resolved during load time. To enable that, this module
+ * must be post-processed by a tool called klp-convert, which embeds
+ * information to be used by the loader to solve the relocation.
+ *
+ * The module is annotated with KLP_RELOC_SYMBOL macros.
+ * These annotations are used by klp-convert to infer that the symbol
+ * saved_command_line is in the object vmlinux.
+ *
+ * Example:
+ *
+ * $ cat /proc/cmdline
+ * <your cmdline>
+ *
+ * $ insmod livepatch-sample.ko
+ * $ cat /proc/cmdline
+ * <your cmdline> livepatch=1
+ *
+ * $ echo 0 > /sys/kernel/livepatch/livepatch_sample/enabled
+ * $ cat /proc/cmdline
+ * <your cmdline>
+ */
+
+extern char *saved_command_line \
+	       KLP_RELOC_SYMBOL(vmlinux, vmlinux, saved_command_line);
+
+#include <linux/seq_file.h>
+static int livepatch_cmdline_proc_show(struct seq_file *m, void *v)
+{
+	seq_printf(m, "%s livepatch=1\n", saved_command_line);
+	return 0;
+}
+
+static struct klp_func funcs[] = {
+	{
+		.old_name = "cmdline_proc_show",
+		.new_func = livepatch_cmdline_proc_show,
+	}, { }
+};
+
+static struct klp_object objs[] = {
+	{
+		/* name being NULL means vmlinux */
+		.funcs = funcs,
+	}, { }
+};
+
+static struct klp_patch patch = {
+	.mod = THIS_MODULE,
+	.objs = objs,
+};
+
+static int livepatch_init(void)
+{
+	return klp_enable_patch(&patch);
+}
+
+static void livepatch_exit(void)
+{
+}
+
+module_init(livepatch_init);
+module_exit(livepatch_exit);
+MODULE_LICENSE("GPL");
+MODULE_INFO(livepatch, "Y");
-- 
2.42.0


