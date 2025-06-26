Return-Path: <live-patching+bounces-1589-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 62FD7AEAB7F
	for <lists+live-patching@lfdr.de>; Fri, 27 Jun 2025 02:07:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D1F2C7B7D1D
	for <lists+live-patching@lfdr.de>; Fri, 27 Jun 2025 00:05:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F28182E888A;
	Thu, 26 Jun 2025 23:56:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VLDX8LCc"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB82D2E7F1D;
	Thu, 26 Jun 2025 23:56:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750982213; cv=none; b=AO3BXwWMQPYbVqYbkd7Edfp+avrbTdDXukflN2g0jU70i27e9Bj3vk5kuQKn8XbVD+6uuTsiy78dKdHKQr3aol+/KD20A4EiV1kKx6+DXGvsXi89i9Ftm3+ztCQPch1fW6CJIe1U0u1CMK8IKWizXU6TJMLpg5KHjOXZ/QlmtCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750982213; c=relaxed/simple;
	bh=sUazod9fDHv6Y0sMdgofaAG7+zcMTxL59nufwr9DdXI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ImIYgKw1mHGfqYC7gQHNX6Ie4FA5CNzI/YjCAVhss/u6qEBYSBKEZIvR/mUrxe8pitUmlyN7yGdO5mHqpMQw2gONrhRVvvzM6X/RUUxsjdhPoH2hKmvBTqqwNFs1wNhgv1Rcw9xuK1LckBbwlByr1mh9z8yxZTTONkjKMMJCDT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VLDX8LCc; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CEFDC4CEF2;
	Thu, 26 Jun 2025 23:56:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750982213;
	bh=sUazod9fDHv6Y0sMdgofaAG7+zcMTxL59nufwr9DdXI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VLDX8LCc4khRSgYGajb4pcGE9yk/PfB0yCO0nAxjmy8xZVetm6Uk7aq2nOYVys3RQ
	 t6fJdf0DTaskQ95BA4UhsqBzX6ZURgvVZkgxZ3KR6nzPl+rvThXjI98gKZuu/pBZM9
	 GSSg2QBcXbiKp9MJ1BtPZ6gZ4wI+NCZ7A2DJ2tLc2gvPGT7lTMqWHljHa5tN95DZ4d
	 vi7Z8NDUzR0lJzT5gCbwuepX1sRLNdvFGAij1KCJUCN7iBjyJsLhkfCfIT3wDoapro
	 dtPE+EnND2CNjVk7ZYOKtbKWmVaB2I58NGXltmibbU3qDps+5sgwyZsQukWCPQ/29c
	 DrPhBVdym0U8A==
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org,
	Petr Mladek <pmladek@suse.com>,
	Miroslav Benes <mbenes@suse.cz>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	live-patching@vger.kernel.org,
	Song Liu <song@kernel.org>,
	laokz <laokz@foxmail.com>,
	Jiri Kosina <jikos@kernel.org>,
	Marcos Paulo de Souza <mpdesouza@suse.com>,
	Weinan Liu <wnliu@google.com>,
	Fazla Mehrab <a.mehrab@bytedance.com>,
	Chen Zhongjin <chenzhongjin@huawei.com>,
	Puranjay Mohan <puranjay@kernel.org>,
	Dylan Hatch <dylanbhatch@google.com>
Subject: [PATCH v3 60/64] livepatch/klp-build: Add stub init code for livepatch modules
Date: Thu, 26 Jun 2025 16:55:47 -0700
Message-ID: <47595fe6105e0eca4c219f1f9edbad4b0690a93d.1750980517.git.jpoimboe@kernel.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1750980516.git.jpoimboe@kernel.org>
References: <cover.1750980516.git.jpoimboe@kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a module initialization stub which can be linked with binary diff
objects to produce a livepatch module.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 scripts/livepatch/init.c | 108 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 108 insertions(+)
 create mode 100644 scripts/livepatch/init.c

diff --git a/scripts/livepatch/init.c b/scripts/livepatch/init.c
new file mode 100644
index 000000000000..2274d8f5a482
--- /dev/null
+++ b/scripts/livepatch/init.c
@@ -0,0 +1,108 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Init code for a livepatch kernel module
+ */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/kernel.h>
+#include <linux/slab.h>
+#include <linux/livepatch.h>
+
+extern struct klp_object_ext __start_klp_objects[];
+extern struct klp_object_ext __stop_klp_objects[];
+
+static struct klp_patch *patch;
+
+static int __init livepatch_mod_init(void)
+{
+	struct klp_object *objs;
+	unsigned int nr_objs;
+	int ret;
+
+	nr_objs = __stop_klp_objects - __start_klp_objects;
+
+	if (!nr_objs) {
+		pr_err("nothing to patch!\n");
+		ret = -EINVAL;
+		goto err;
+	}
+
+	patch = kzalloc(sizeof(*patch), GFP_KERNEL);
+	if (!patch) {
+		ret = -ENOMEM;
+		goto err;
+	}
+
+	objs = kzalloc(sizeof(struct klp_object) * (nr_objs + 1),  GFP_KERNEL);
+	if (!objs) {
+		ret = -ENOMEM;
+		goto err_free_patch;
+	}
+
+	for (int i = 0; i < nr_objs; i++) {
+		struct klp_object_ext *obj_ext = __start_klp_objects + i;
+		struct klp_func_ext *funcs_ext = obj_ext->funcs;
+		unsigned int nr_funcs = obj_ext->nr_funcs;
+		struct klp_func *funcs = objs[i].funcs;
+		struct klp_object *obj = objs + i;
+
+		funcs = kzalloc(sizeof(struct klp_func) * (nr_funcs + 1), GFP_KERNEL);
+		if (!funcs) {
+			ret = -ENOMEM;
+			for (int j = 0; j < i; j++)
+				kfree(objs[i].funcs);
+			goto err_free_objs;
+		}
+
+		for (int j = 0; j < nr_funcs; j++) {
+			funcs[j].old_name   = funcs_ext[j].old_name;
+			funcs[j].new_func   = funcs_ext[j].new_func;
+			funcs[j].old_sympos = funcs_ext[j].sympos;
+		}
+
+		obj->name = obj_ext->name;
+		obj->funcs = funcs;
+
+		memcpy(&obj->callbacks, &obj_ext->callbacks, sizeof(struct klp_callbacks));
+	}
+
+	patch->mod = THIS_MODULE;
+	patch->objs = objs;
+
+	/* TODO patch->states */
+
+#ifdef KLP_NO_REPLACE
+	patch->replace = false;
+#else
+	patch->replace = true;
+#endif
+
+	return klp_enable_patch(patch);
+
+err_free_objs:
+	kfree(objs);
+err_free_patch:
+	kfree(patch);
+err:
+	return ret;
+}
+
+static void __exit livepatch_mod_exit(void)
+{
+	unsigned int nr_objs;
+
+	nr_objs = __stop_klp_objects - __start_klp_objects;
+
+	for (int i = 0; i < nr_objs; i++)
+		kfree(patch->objs[i].funcs);
+
+	kfree(patch->objs);
+	kfree(patch);
+}
+
+module_init(livepatch_mod_init);
+module_exit(livepatch_mod_exit);
+MODULE_LICENSE("GPL");
+MODULE_INFO(livepatch, "Y");
+MODULE_DESCRIPTION("Livepatch module");
-- 
2.49.0


