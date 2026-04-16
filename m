Return-Path: <live-patching+bounces-2357-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 6FvAI2wq4GlEdAAAu9opvQ
	(envelope-from <live-patching+bounces-2357-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Thu, 16 Apr 2026 02:16:44 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 726284092DE
	for <lists+live-patching@lfdr.de>; Thu, 16 Apr 2026 02:16:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 10FCC30561FE
	for <lists+live-patching@lfdr.de>; Thu, 16 Apr 2026 00:16:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E33B18787A;
	Thu, 16 Apr 2026 00:16:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dIlRp/P7"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28F9217B418;
	Thu, 16 Apr 2026 00:16:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776298601; cv=none; b=sDVrxqvbU7tSr5B5Vkh+nM7uHLvnz4RC8jrzgdgn/92avuKp6DLxiQjsfkl9Zd6LioFMEIhTvf5TTB6NAeJMpuhmT/DTSvC3+3LLAlQOhH/+1y3udK9KWs3IUFDIhXwbI/IieGBetVLRPBS7jTOo6Q5TcgLgNvF1x8tGIERV5FY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776298601; c=relaxed/simple;
	bh=pW7ATLxGItLWgDrh83nUF0l1D7OA11kkykUEjmwOpZQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=t5i4Gx68XNhFZ10fOdxhj0CG/mP2B9T/y4rsRAgYvtbK0hWgm+vHqjfkadKz898WlMlb4hC+ucdoYHD1fOs81VyicJKZCZrAgbu4uy8TJPIN87MOd7EBzi6ub1Akf2eKUhpKudmWCwl5ySQzXXaOYg/8zizFP7sZvTB95znFcFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dIlRp/P7; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA0E9C19424;
	Thu, 16 Apr 2026 00:16:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776298601;
	bh=pW7ATLxGItLWgDrh83nUF0l1D7OA11kkykUEjmwOpZQ=;
	h=From:To:Cc:Subject:Date:From;
	b=dIlRp/P7Np64VuKZiIsR2jsxoQonH5eGmLKgBr28bobzjQcRz3eTZxq7P02dQt2Vf
	 EpJV7sxH8MPIor1NUpPUKZR3HAHI1p7qaeKcFsN88qLd/d0rPc2Kf+dwy3ZQXJfcBf
	 Bmg4pM48NI78HiRr42hVFoZ/4MW/3y9QRw6u4Pz/Y4AHKykrvWaCHizXPltnxd0FR0
	 9k0phSnQDDOuAt4uTMOk40DJv1VVrUYl+B+Nm0TUhImltR7f3HfPldE0SxORd7BiHN
	 Kw3RrsWpuFskzBrqmDl93zuWzWxaXJXlZf/JNf8Dv1KqBtHqPMqzCuIOuAdsEJCl2U
	 VZ4lEKzIi9/+g==
From: Song Liu <song@kernel.org>
To: live-patching@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: jpoimboe@kernel.org,
	jikos@kernel.org,
	mbenes@suse.cz,
	pmladek@suse.com,
	joe.lawrence@redhat.com,
	laoar.shao@gmail.com,
	kernel-team@meta.com,
	Song Liu <song@kernel.org>
Subject: [PATCH] samples/livepatch: Add BPF struct_ops integration sample
Date: Wed, 15 Apr 2026 17:16:28 -0700
Message-ID: <20260416001628.2062468-1-song@kernel.org>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [0.84 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	ASN_FAIL(0.00)[114.105.105.172.asn.rspamd.com:server fail];
	FREEMAIL_CC(0.00)[kernel.org,suse.cz,suse.com,redhat.com,gmail.com,meta.com];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-2357-lists,live-patching=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[song@kernel.org,live-patching@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	NEURAL_HAM(-0.00)[-0.994];
	TAGGED_RCPT(0.00)[live-patching];
	RCPT_COUNT_SEVEN(0.00)[10];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 726284092DE
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Add a sample module that demonstrates how BPF struct_ops can work
together with kernel livepatch. The module livepatches
cmdline_proc_show() and delegates the output to a BPF struct_ops
callback. When no BPF program is attached, a fallback message is
shown; when a BPF struct_ops program is attached, it controls the
/proc/cmdline output via the bpf_klp_seq_write kfunc.

This builds on the existing livepatch-sample.c pattern but shows how
livepatch and BPF struct_ops can be combined to make livepatched
behavior programmable from userspace.

The module is built when both CONFIG_SAMPLE_LIVEPATCH and
CONFIG_BPF_JIT are enabled.

Signed-off-by: Song Liu <song@kernel.org>
---
 samples/livepatch/Makefile        |   3 +
 samples/livepatch/livepatch-bpf.c | 202 ++++++++++++++++++++++++++++++
 2 files changed, 205 insertions(+)
 create mode 100644 samples/livepatch/livepatch-bpf.c

diff --git a/samples/livepatch/Makefile b/samples/livepatch/Makefile
index 9f853eeb6140..1ab4ecbf1f0f 100644
--- a/samples/livepatch/Makefile
+++ b/samples/livepatch/Makefile
@@ -6,3 +6,6 @@ obj-$(CONFIG_SAMPLE_LIVEPATCH) += livepatch-shadow-fix2.o
 obj-$(CONFIG_SAMPLE_LIVEPATCH) += livepatch-callbacks-demo.o
 obj-$(CONFIG_SAMPLE_LIVEPATCH) += livepatch-callbacks-mod.o
 obj-$(CONFIG_SAMPLE_LIVEPATCH) += livepatch-callbacks-busymod.o
+ifdef CONFIG_BPF_JIT
+obj-$(CONFIG_SAMPLE_LIVEPATCH) += livepatch-bpf.o
+endif
diff --git a/samples/livepatch/livepatch-bpf.c b/samples/livepatch/livepatch-bpf.c
new file mode 100644
index 000000000000..4a702a3b4726
--- /dev/null
+++ b/samples/livepatch/livepatch-bpf.c
@@ -0,0 +1,202 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * livepatch-bpf.c - BPF struct_ops + Kernel Live Patching Sample Module
+ *
+ * Copyright (c) 2026 Meta Platforms, Inc. and affiliates.
+ *
+ * This sample demonstrates how BPF struct_ops can control kernel
+ * behavior through livepatch. The module livepatches cmdline_proc_show()
+ * and delegates output to a BPF struct_ops callback. A BPF program can
+ * then attach to override /proc/cmdline output via the bpf_klp_seq_write
+ * kfunc.
+ *
+ * Example:
+ *
+ * $ insmod livepatch-bpf.ko
+ * $ cat /proc/cmdline
+ * livepatch_bpf: no struct_ops attached
+ *
+ * (attach a BPF struct_ops program implementing set_cmdline, e.g.)
+ *
+ * SEC("struct_ops/set_cmdline")
+ * int BPF_PROG(set_cmdline, struct seq_file *m)
+ * {
+ *     char custom[] = "klp_bpf: custom cmdline\n";
+ *     bpf_klp_seq_write(m, custom, sizeof(custom) - 1);
+ *     return 0;
+ * }
+ *
+ * $ cat /proc/cmdline
+ * klp_bpf: custom cmdline
+ *
+ * $ echo 0 > /sys/kernel/livepatch/livepatch_bpf/enabled
+ * $ cat /proc/cmdline
+ * <your cmdline>
+ */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/bpf.h>
+#include <linux/btf.h>
+#include <linux/btf_ids.h>
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/livepatch.h>
+#include <linux/seq_file.h>
+#include <linux/bpf_verifier.h>
+
+struct klp_bpf_cmdline_ops {
+	int (*set_cmdline)(struct seq_file *m);
+};
+
+static struct klp_bpf_cmdline_ops *active_ops;
+
+/* --- kfunc: allow BPF struct_ops programs to write to seq_file --- */
+
+__bpf_kfunc_start_defs();
+
+__bpf_kfunc void bpf_klp_seq_write(struct seq_file *m,
+				    const char *data, u32 data__sz)
+{
+	seq_write(m, data, data__sz);
+}
+
+__bpf_kfunc_end_defs();
+
+BTF_KFUNCS_START(klp_bpf_kfunc_ids)
+BTF_ID_FLAGS(func, bpf_klp_seq_write)
+BTF_KFUNCS_END(klp_bpf_kfunc_ids)
+
+static const struct btf_kfunc_id_set klp_bpf_kfunc_set = {
+	.owner = THIS_MODULE,
+	.set   = &klp_bpf_kfunc_ids,
+};
+
+/* --- Livepatch replacement for cmdline_proc_show --- */
+
+static int livepatch_cmdline_proc_show(struct seq_file *m, void *v)
+{
+	struct klp_bpf_cmdline_ops *ops = READ_ONCE(active_ops);
+
+	if (ops && ops->set_cmdline)
+		return ops->set_cmdline(m);
+
+	seq_printf(m, "%s: no struct_ops attached\n", THIS_MODULE->name);
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
+/* --- struct_ops registration --- */
+
+static int klp_bpf_cmdline_reg(void *kdata, struct bpf_link *link)
+{
+	struct klp_bpf_cmdline_ops *ops = kdata;
+
+	if (cmpxchg(&active_ops, NULL, ops))
+		return -EBUSY;
+
+	return 0;
+}
+
+static void klp_bpf_cmdline_unreg(void *kdata, struct bpf_link *link)
+{
+	WRITE_ONCE(active_ops, NULL);
+}
+
+static int klp_bpf_cmdline_init(struct btf *btf)
+{
+	return 0;
+}
+
+static int klp_bpf_cmdline_init_member(const struct btf_type *t,
+				       const struct btf_member *member,
+				       void *kdata, const void *udata)
+{
+	return 0;
+}
+
+static bool klp_bpf_cmdline_is_valid_access(int off, int size,
+					    enum bpf_access_type type,
+					    const struct bpf_prog *prog,
+					    struct bpf_insn_access_aux *info)
+{
+	return bpf_tracing_btf_ctx_access(off, size, type, prog, info);
+}
+
+static int klp_bpf_cmdline_btf_struct_access(struct bpf_verifier_log *log,
+					     const struct bpf_reg_state *reg,
+					     int off, int size)
+{
+	return -EACCES;
+}
+
+static const struct bpf_verifier_ops klp_bpf_cmdline_verifier_ops = {
+	.is_valid_access = klp_bpf_cmdline_is_valid_access,
+	.btf_struct_access = klp_bpf_cmdline_btf_struct_access,
+};
+
+/* CFI stubs */
+static int klp_bpf_cmdline__set_cmdline(struct seq_file *m)
+{
+	return 0;
+}
+
+static struct klp_bpf_cmdline_ops __bpf_klp_bpf_cmdline_ops = {
+	.set_cmdline = klp_bpf_cmdline__set_cmdline,
+};
+
+static struct bpf_struct_ops bpf_klp_bpf_cmdline_ops = {
+	.verifier_ops = &klp_bpf_cmdline_verifier_ops,
+	.init = klp_bpf_cmdline_init,
+	.init_member = klp_bpf_cmdline_init_member,
+	.reg = klp_bpf_cmdline_reg,
+	.unreg = klp_bpf_cmdline_unreg,
+	.cfi_stubs = &__bpf_klp_bpf_cmdline_ops,
+	.name = "klp_bpf_cmdline_ops",
+	.owner = THIS_MODULE,
+};
+
+/* --- Module init/exit --- */
+
+static int __init livepatch_bpf_init(void)
+{
+	int ret;
+
+	ret = register_btf_kfunc_id_set(BPF_PROG_TYPE_STRUCT_OPS,
+					&klp_bpf_kfunc_set);
+	ret = ret ?: register_bpf_struct_ops(&bpf_klp_bpf_cmdline_ops,
+					     klp_bpf_cmdline_ops);
+	if (ret)
+		return ret;
+
+	return klp_enable_patch(&patch);
+}
+
+static void __exit livepatch_bpf_exit(void)
+{
+}
+
+module_init(livepatch_bpf_init);
+module_exit(livepatch_bpf_exit);
+MODULE_LICENSE("GPL");
+MODULE_INFO(livepatch, "Y");
+MODULE_AUTHOR("Song Liu");
+MODULE_DESCRIPTION("Sample: BPF struct_ops + livepatch integration");
-- 
2.52.0


