Return-Path: <live-patching+bounces-270-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id EFA2F8C77A8
	for <lists+live-patching@lfdr.de>; Thu, 16 May 2024 15:31:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4C65EB213A2
	for <lists+live-patching@lfdr.de>; Thu, 16 May 2024 13:31:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 19AC214B976;
	Thu, 16 May 2024 13:30:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="hr4AQaQM";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="X//hLmyB";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="hr4AQaQM";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="X//hLmyB"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35A711482E4;
	Thu, 16 May 2024 13:30:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715866232; cv=none; b=j8A0DfHY91OSGmPpBWasgqZ0Zd1yvALiHat2QOSH2EXfHcE0492THMYnXteZe7UXODMhPkF3WxCOfbiUSsTSjsCWCg4lZzqKRyOEeI0Cc3/5ITdmi9+6y2APlyW9ta2zsOdGp9ZtS9l+hYYHWS9wOb9GZi/j69GMQKD5VAjBEDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715866232; c=relaxed/simple;
	bh=/a8ibU8/gXITbtEi7U+oftRxDNY7QKjObu2iWv+fd7Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lGOodRbfeQ1qc3JOhOMDTRTPlmOPtvrTv6dgun1CwX0SK2pUUvri2SOEDDaupKXMmZtAmSDn4sIQW+hGdnVXkPF9tJiz6AkQDvGNvlHuigafRe7hEQtqnL7NWlKlf6Oko/v4v4orQ1VXcvcQzEBtlOPzDVZEgGypRCgegEENznA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=hr4AQaQM; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=X//hLmyB; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=hr4AQaQM; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=X//hLmyB; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 40C805C444;
	Thu, 16 May 2024 13:30:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1715866228; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lnZFo3Iy+J1iEPCpBsqGDWmm+yj4ryikbowVcS024io=;
	b=hr4AQaQM/lhBp2UTL7t/9BhCAZ2BNZbFA0KCAx4U9KF4u/AxFtJ/IWhnk7xpD3+63E5cGu
	wVv5GJ9+u0BcMyaRPj40Vkci2MsM2WadKv7/438SieArwhtZi+kA4gN0eykpKjsleLq+hM
	xpVKDIz42ZNjgr918xcNFsntPvO4+lA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1715866228;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lnZFo3Iy+J1iEPCpBsqGDWmm+yj4ryikbowVcS024io=;
	b=X//hLmyB9NtGZhGGvlMlLt36v97uQwEB4a0N6P1GkHk6+M5YNfqdVK+d1NPNGFD6AC5PHS
	9X6JenhJupNZAOAg==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1715866228; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lnZFo3Iy+J1iEPCpBsqGDWmm+yj4ryikbowVcS024io=;
	b=hr4AQaQM/lhBp2UTL7t/9BhCAZ2BNZbFA0KCAx4U9KF4u/AxFtJ/IWhnk7xpD3+63E5cGu
	wVv5GJ9+u0BcMyaRPj40Vkci2MsM2WadKv7/438SieArwhtZi+kA4gN0eykpKjsleLq+hM
	xpVKDIz42ZNjgr918xcNFsntPvO4+lA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1715866228;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lnZFo3Iy+J1iEPCpBsqGDWmm+yj4ryikbowVcS024io=;
	b=X//hLmyB9NtGZhGGvlMlLt36v97uQwEB4a0N6P1GkHk6+M5YNfqdVK+d1NPNGFD6AC5PHS
	9X6JenhJupNZAOAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3637A13991;
	Thu, 16 May 2024 13:30:28 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id JqnbDHQKRmZ5CQAAD6G6ig
	(envelope-from <lhruska@suse.cz>); Thu, 16 May 2024 13:30:28 +0000
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
Subject: [PATCH v2 4/6] livepatch: Add sample livepatch module
Date: Thu, 16 May 2024 15:30:07 +0200
Message-ID: <20240516133009.20224-5-lhruska@suse.cz>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240516133009.20224-1-lhruska@suse.cz>
References: <20240516133009.20224-1-lhruska@suse.cz>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spam-Score: -6.80
X-Spam-Level: 
X-Spamd-Result: default: False [-6.80 / 50.00];
	REPLY(-4.00)[];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCPT_COUNT_SEVEN(0.00)[10];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.cz:email,imap1.dmz-prg2.suse.org:helo];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_TLS_ALL(0.00)[]

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
index 9f853eeb6140..f2b41f4d6c16 100644
--- a/samples/livepatch/Makefile
+++ b/samples/livepatch/Makefile
@@ -6,3 +6,4 @@ obj-$(CONFIG_SAMPLE_LIVEPATCH) += livepatch-shadow-fix2.o
 obj-$(CONFIG_SAMPLE_LIVEPATCH) += livepatch-callbacks-demo.o
 obj-$(CONFIG_SAMPLE_LIVEPATCH) += livepatch-callbacks-mod.o
 obj-$(CONFIG_SAMPLE_LIVEPATCH) += livepatch-callbacks-busymod.o
+obj-$(CONFIG_SAMPLE_LIVEPATCH) += livepatch-annotated-sample.o
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
2.45.0


