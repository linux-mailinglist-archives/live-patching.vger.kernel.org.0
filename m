Return-Path: <live-patching+bounces-523-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 94B73960A5F
	for <lists+live-patching@lfdr.de>; Tue, 27 Aug 2024 14:32:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4C1641F21EF7
	for <lists+live-patching@lfdr.de>; Tue, 27 Aug 2024 12:32:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D5E91BC065;
	Tue, 27 Aug 2024 12:31:07 +0000 (UTC)
X-Original-To: live-patching@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAD5C1BB6BD;
	Tue, 27 Aug 2024 12:31:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724761867; cv=none; b=Tbs4e/5rmOlooMBJvv7PvB6kiYcFQWAcKyHeb63RFvbvQwEvv85I005iyABmIZPxccL1olgLNc0exH2htQWq/tPqY1x1HpMUpH6xpY6Rh0z9NeZTs7iVhRuDla28TBftd3yMfur0iv73gOzySJCAGKgrYcVREUdW8ZpkfQqxgKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724761867; c=relaxed/simple;
	bh=aRdmym/AY2Rh1oDH9QAjsr3DwL+0OSdCczjrdKZB6Ao=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qonV3lPGGqEtwyhilzD8YcCXXfliFPWvUHSHmLDz0jseYpiklFveAy08yUhs7jK765lxZFumhnvne6E8EDgmnu5bvTpsHqP9pF1fyeqjhudEpDH7bdZyxZIuhFgc+Bh3hfAHQByhNFNKlZfm4jvkdqFOzQeb6bvzFd2lBOXKPeQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 1CF1B1FB6A;
	Tue, 27 Aug 2024 12:31:03 +0000 (UTC)
Authentication-Results: smtp-out2.suse.de;
	none
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 1562613724;
	Tue, 27 Aug 2024 12:31:03 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id xm45BQfHzWbBYwAAD6G6ig
	(envelope-from <lhruska@suse.cz>); Tue, 27 Aug 2024 12:31:03 +0000
From: Lukas Hruska <lhruska@suse.cz>
To: pmladek@suse.com,
	mbenes@suse.cz,
	jpoimboe@kernel.org
Cc: joe.lawrence@redhat.com,
	live-patching@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kbuild@vger.kernel.org,
	mpdesouza@suse.com,
	lhruska@suse.cz,
	Josh Poimboeuf <jpoimboe@redhat.com>
Subject: [PATCH v3 4/6] livepatch: Add sample livepatch module
Date: Tue, 27 Aug 2024 14:30:49 +0200
Message-ID: <20240827123052.9002-5-lhruska@suse.cz>
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
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Spam-Level: 
X-Spamd-Result: default: False [-4.00 / 50.00];
	REPLY(-4.00)[]
X-Spam-Score: -4.00
X-Spam-Flag: NO
X-Rspamd-Queue-Id: 1CF1B1FB6A
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org

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
Reviewed-by: Petr Mladek <pmladek@suse.com>
---
 samples/livepatch/Makefile                  |  1 +
 samples/livepatch/livepatch-extern-symbol.c | 84 +++++++++++++++++++++
 2 files changed, 85 insertions(+)
 create mode 100644 samples/livepatch/livepatch-extern-symbol.c

diff --git a/samples/livepatch/Makefile b/samples/livepatch/Makefile
index 9f853eeb6140..5cc81d5db17c 100644
--- a/samples/livepatch/Makefile
+++ b/samples/livepatch/Makefile
@@ -6,3 +6,4 @@ obj-$(CONFIG_SAMPLE_LIVEPATCH) += livepatch-shadow-fix2.o
 obj-$(CONFIG_SAMPLE_LIVEPATCH) += livepatch-callbacks-demo.o
 obj-$(CONFIG_SAMPLE_LIVEPATCH) += livepatch-callbacks-mod.o
 obj-$(CONFIG_SAMPLE_LIVEPATCH) += livepatch-callbacks-busymod.o
+obj-$(CONFIG_SAMPLE_LIVEPATCH) += livepatch-extern-symbol.o
diff --git a/samples/livepatch/livepatch-extern-symbol.c b/samples/livepatch/livepatch-extern-symbol.c
new file mode 100644
index 000000000000..276a43d157b4
--- /dev/null
+++ b/samples/livepatch/livepatch-extern-symbol.c
@@ -0,0 +1,84 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (C) 2014 Seth Jennings <sjenning@redhat.com>
+ */
+
+/*
+ * livepatch-extern-symbol.c - Kernel Live Patching Sample Module
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
2.46.0


