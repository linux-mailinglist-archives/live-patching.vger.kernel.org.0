Return-Path: <live-patching+bounces-1824-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 794EFC0FC94
	for <lists+live-patching@lfdr.de>; Mon, 27 Oct 2025 18:52:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4B607468A66
	for <lists+live-patching@lfdr.de>; Mon, 27 Oct 2025 17:51:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B694C31AF0A;
	Mon, 27 Oct 2025 17:50:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lNeRGrqq"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B7363195F6;
	Mon, 27 Oct 2025 17:50:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761587448; cv=none; b=A9a5rpnSAeW+h0l4briM7uGmEmldIL871O8A9aW/FNvb39P0xuEPFb3wwHeUBJP6FQaRWoI97b3IByynkjUguGZr6oHlPbFcP7Rn1qBcf4Qty1R6Pd/xS6PHclU5jdo4MlmvosanZ0i59fLIwaB7azRN7g5O+fymckTwwbmVwV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761587448; c=relaxed/simple;
	bh=gWMR3EMNxsqGBFIYnPRgcYxp7Xq38xPHaG0jSJHKz9Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AqwISRKtZQij84Ye5uUQ3sti/nu5Ftub/yuZ7Y9fYGAU9zrKk6ct2B/Je0/QQf4fpjetUyKIxBkPTBohy7aU3iOJSfxX69IMiS+nYweHgL1RTh01VW3tqaNz7j2a8ddamDL5T2csF9YQZFw+XZTJn4twkzjoqOPdETmmi7jUCCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lNeRGrqq; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE115C113D0;
	Mon, 27 Oct 2025 17:50:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761587447;
	bh=gWMR3EMNxsqGBFIYnPRgcYxp7Xq38xPHaG0jSJHKz9Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lNeRGrqqswfbqCvnnNXM4slvXS54r/yMWNN1xkzeG+Gl/Iv3utGAVx6q4Lgg5EdkM
	 kBPvV6wL3+rFWlkUL87LCyvE9HECFfj9TWrVWj8I+hEaT5EOD1jfMlS6KStK32WXhF
	 QytGmZuE+bh9M8JMpe1yakYqDq6qKEaueM6n4QHF8ecXQ8MqBbOJ0wyLGHDYP9j1ZP
	 MNlvrAU1F5R7nPcbrXb1iILIclxPwh6YfSgdStUe1rkZBjgZmDIzBLRq5wSQrudomo
	 47YhG2IjwVz7J1qyTOK1Q7RmwU8YPDDQxSMPdG/BIhsqmOsf2naC+1tI48GiMSUpnd
	 Dziq0LiyNgBow==
From: Song Liu <song@kernel.org>
To: bpf@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	live-patching@vger.kernel.org
Cc: ast@kernel.org,
	daniel@iogearbox.net,
	andrii@kernel.org,
	rostedt@goodmis.org,
	andrey.grodzovsky@crowdstrike.com,
	mhiramat@kernel.org,
	kernel-team@meta.com,
	olsajiri@gmail.com,
	Song Liu <song@kernel.org>,
	stable@vger.kernel.org,
	Jiri Olsa <jolsa@kernel.org>
Subject: [PATCH v4 bpf 1/3] ftrace: Fix BPF fexit with livepatch
Date: Mon, 27 Oct 2025 10:50:21 -0700
Message-ID: <20251027175023.1521602-2-song@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251027175023.1521602-1-song@kernel.org>
References: <20251027175023.1521602-1-song@kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When livepatch is attached to the same function as bpf trampoline with
a fexit program, bpf trampoline code calls register_ftrace_direct()
twice. The first time will fail with -EAGAIN, and the second time it
will succeed. This requires register_ftrace_direct() to unregister
the address on the first attempt. Otherwise, the bpf trampoline cannot
attach. Here is an easy way to reproduce this issue:

  insmod samples/livepatch/livepatch-sample.ko
  bpftrace -e 'fexit:cmdline_proc_show {}'
  ERROR: Unable to attach probe: fexit:vmlinux:cmdline_proc_show...

Fix this by cleaning up the hash when register_ftrace_function_nolock hits
errors.

Also, move the code that resets ops->func and ops->trampoline to the error
path of register_ftrace_direct(); and add a helper function reset_direct()
in register_ftrace_direct() and unregister_ftrace_direct().

Fixes: d05cb470663a ("ftrace: Fix modification of direct_function hash while in use")
Cc: stable@vger.kernel.org # v6.6+
Reported-by: Andrey Grodzovsky <andrey.grodzovsky@crowdstrike.com>
Closes: https://lore.kernel.org/live-patching/c5058315a39d4615b333e485893345be@crowdstrike.com/
Cc: Steven Rostedt (Google) <rostedt@goodmis.org>
Cc: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Acked-and-tested-by: Andrey Grodzovsky <andrey.grodzovsky@crowdstrike.com>
Signed-off-by: Song Liu <song@kernel.org>
Reviewed-by: Jiri Olsa <jolsa@kernel.org>
---
 kernel/bpf/trampoline.c |  5 -----
 kernel/trace/ftrace.c   | 20 ++++++++++++++------
 2 files changed, 14 insertions(+), 11 deletions(-)

diff --git a/kernel/bpf/trampoline.c b/kernel/bpf/trampoline.c
index 5949095e51c3..f2cb0b097093 100644
--- a/kernel/bpf/trampoline.c
+++ b/kernel/bpf/trampoline.c
@@ -479,11 +479,6 @@ static int bpf_trampoline_update(struct bpf_trampoline *tr, bool lock_direct_mut
 		 * BPF_TRAMP_F_SHARE_IPMODIFY is set, we can generate the
 		 * trampoline again, and retry register.
 		 */
-		/* reset fops->func and fops->trampoline for re-register */
-		tr->fops->func = NULL;
-		tr->fops->trampoline = 0;
-
-		/* free im memory and reallocate later */
 		bpf_tramp_image_free(im);
 		goto again;
 	}
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 42bd2ba68a82..cbeb7e833131 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -5953,6 +5953,17 @@ static void register_ftrace_direct_cb(struct rcu_head *rhp)
 	free_ftrace_hash(fhp);
 }
 
+static void reset_direct(struct ftrace_ops *ops, unsigned long addr)
+{
+	struct ftrace_hash *hash = ops->func_hash->filter_hash;
+
+	remove_direct_functions_hash(hash, addr);
+
+	/* cleanup for possible another register call */
+	ops->func = NULL;
+	ops->trampoline = 0;
+}
+
 /**
  * register_ftrace_direct - Call a custom trampoline directly
  * for multiple functions registered in @ops
@@ -6048,6 +6059,8 @@ int register_ftrace_direct(struct ftrace_ops *ops, unsigned long addr)
 	ops->direct_call = addr;
 
 	err = register_ftrace_function_nolock(ops);
+	if (err)
+		reset_direct(ops, addr);
 
  out_unlock:
 	mutex_unlock(&direct_mutex);
@@ -6080,7 +6093,6 @@ EXPORT_SYMBOL_GPL(register_ftrace_direct);
 int unregister_ftrace_direct(struct ftrace_ops *ops, unsigned long addr,
 			     bool free_filters)
 {
-	struct ftrace_hash *hash = ops->func_hash->filter_hash;
 	int err;
 
 	if (check_direct_multi(ops))
@@ -6090,13 +6102,9 @@ int unregister_ftrace_direct(struct ftrace_ops *ops, unsigned long addr,
 
 	mutex_lock(&direct_mutex);
 	err = unregister_ftrace_function(ops);
-	remove_direct_functions_hash(hash, addr);
+	reset_direct(ops, addr);
 	mutex_unlock(&direct_mutex);
 
-	/* cleanup for possible another register call */
-	ops->func = NULL;
-	ops->trampoline = 0;
-
 	if (free_filters)
 		ftrace_free_filter(ops);
 	return err;
-- 
2.47.3


