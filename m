Return-Path: <live-patching+bounces-1805-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id D9689C07C07
	for <lists+live-patching@lfdr.de>; Fri, 24 Oct 2025 20:29:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 99935500FB6
	for <lists+live-patching@lfdr.de>; Fri, 24 Oct 2025 18:29:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A68A7347FEA;
	Fri, 24 Oct 2025 18:29:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XrwhqdDu"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A25633B976;
	Fri, 24 Oct 2025 18:29:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761330559; cv=none; b=R9MZkqmwR66Sog7zOgUT5Nf59FIIN2b0Id72xUuzyZ6hD9Ic7xXdRvGc0/UrGIb2In2gK3ICSpQa94WqGUMQlzL4pjZFkw9wvM5HyuX/8nvbK4c1eLfsg/lS6+PfijpsjhcybVDQYwIwhCY9QJXoKxCxmd/0fo4u3WRIR0jpKC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761330559; c=relaxed/simple;
	bh=CuFquOgexCVd1mlcoVNtRwQyICPqfxS/3eL2uQ/sCsQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MD9gg0raoWejTwQ7hbxwWNVUc+5pZoIrmVJNfM8lWuG4eSCIedCTZf8eU+KZrhJimvmcDPhmUfIeAeqCFkND/ZN1LqoSs6mlw9bLnJYjYirAxzyuPT4LvIVTCEwNaXf5Y1JU20oqIDBXzwFAjz7E2HAi+MF4VFxwePpg7KUMQeQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XrwhqdDu; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14025C4CEF1;
	Fri, 24 Oct 2025 18:29:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761330559;
	bh=CuFquOgexCVd1mlcoVNtRwQyICPqfxS/3eL2uQ/sCsQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XrwhqdDumRJbhPK6BzmigvPcv9xcludyukuesmRpVJsV7xwxvF+VGLMCx7yjbujqa
	 SxoOKR8BT1RBOw0JHTUcpoG8L/TgpiAq/remHkksvQ3hAKhk8fX9RGEbl8EoFrcXdk
	 jkPu0oPPOShC+ffjzqDQfvCw0RDbAbmpA9QZ3Y/JqaN3kkr9KligzEuFcSLXNWjCPh
	 JUMoZ4V8KKXc89tBFHZm89HVO72MqhnhgGQcICjuRKZtfR8/Av5wq21RRQTDgxDb4o
	 3fsNYBjvjlNFDwF3ktsgupDr0SjyzVB1+FhYJ5KfyHZdvjdy730uCZ8lU/PKcj1uKP
	 YO8tgoJeptBnQ==
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
	Song Liu <song@kernel.org>
Subject: [PATCH v2 bpf 2/3] ftrace: bpf: Fix IPMODIFY + DIRECT in modify_ftrace_direct()
Date: Fri, 24 Oct 2025 11:29:00 -0700
Message-ID: <20251024182901.3247573-3-song@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251024182901.3247573-1-song@kernel.org>
References: <20251024182901.3247573-1-song@kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ftrace_hash_ipmodify_enable() checks IPMODIFY and DIRECT ftrace_ops on
the same kernel function. When needed, ftrace_hash_ipmodify_enable()
calls ops->ops_func() to prepare the direct ftrace (BPF trampoline) to
share the same function as the IPMODIFY ftrace (livepatch).

ftrace_hash_ipmodify_enable() is called in register_ftrace_direct() path,
but not called in modify_ftrace_direct() path. As a result, the following
operations will break livepatch:

1. Load livepatch to a kernel function;
2. Attach fentry program to the kernel function;
3. Attach fexit program to the kernel function.

After 3, the kernel function being used will not be the livepatched
version, but the original version.

Fix this by adding ftrace_hash_ipmodify_enable() to modify_ftrace_direct()
and adjust some logic around the call.

Signed-off-by: Song Liu <song@kernel.org>
---
 kernel/bpf/trampoline.c | 12 +++++++-----
 kernel/trace/ftrace.c   | 40 +++++++++++++++++++++++++++++++---------
 2 files changed, 38 insertions(+), 14 deletions(-)

diff --git a/kernel/bpf/trampoline.c b/kernel/bpf/trampoline.c
index 5949095e51c3..023360568d02 100644
--- a/kernel/bpf/trampoline.c
+++ b/kernel/bpf/trampoline.c
@@ -221,6 +221,13 @@ static int register_fentry(struct bpf_trampoline *tr, void *new_addr)
 
 	if (tr->func.ftrace_managed) {
 		ftrace_set_filter_ip(tr->fops, (unsigned long)ip, 0, 1);
+		/*
+		 * Clearing fops->trampoline and fops->NULL is
+		 * needed by the "goto again" case in
+		 * bpf_trampoline_update().
+		 */
+		tr->fops->trampoline = 0;
+		tr->fops->func = NULL;
 		ret = register_ftrace_direct(tr->fops, (long)new_addr);
 	} else {
 		ret = bpf_arch_text_poke(ip, BPF_MOD_CALL, NULL, new_addr);
@@ -479,11 +486,6 @@ static int bpf_trampoline_update(struct bpf_trampoline *tr, bool lock_direct_mut
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
index 7f432775a6b5..0c91247a95ab 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -1971,7 +1971,8 @@ static void ftrace_hash_rec_enable_modify(struct ftrace_ops *ops)
  */
 static int __ftrace_hash_update_ipmodify(struct ftrace_ops *ops,
 					 struct ftrace_hash *old_hash,
-					 struct ftrace_hash *new_hash)
+					 struct ftrace_hash *new_hash,
+					 bool update_target)
 {
 	struct ftrace_page *pg;
 	struct dyn_ftrace *rec, *end = NULL;
@@ -2006,10 +2007,13 @@ static int __ftrace_hash_update_ipmodify(struct ftrace_ops *ops,
 		if (rec->flags & FTRACE_FL_DISABLED)
 			continue;
 
-		/* We need to update only differences of filter_hash */
+		/*
+		 * Unless we are updating the target of a direct function,
+		 * we only need to update differences of filter_hash
+		 */
 		in_old = !!ftrace_lookup_ip(old_hash, rec->ip);
 		in_new = !!ftrace_lookup_ip(new_hash, rec->ip);
-		if (in_old == in_new)
+		if (!update_target && (in_old == in_new))
 			continue;
 
 		if (in_new) {
@@ -2020,7 +2024,16 @@ static int __ftrace_hash_update_ipmodify(struct ftrace_ops *ops,
 				if (is_ipmodify)
 					goto rollback;
 
-				FTRACE_WARN_ON(rec->flags & FTRACE_FL_DIRECT);
+				/*
+				 * If this is called by __modify_ftrace_direct()
+				 * then it is only chaning where the direct
+				 * pointer is jumping to, and the record already
+				 * points to a direct trampoline. If it isn't
+				 * then it is a bug to update ipmodify on a direct
+				 * caller.
+				 */
+				FTRACE_WARN_ON(!update_target &&
+					       (rec->flags & FTRACE_FL_DIRECT));
 
 				/*
 				 * Another ops with IPMODIFY is already
@@ -2076,7 +2089,7 @@ static int ftrace_hash_ipmodify_enable(struct ftrace_ops *ops)
 	if (ftrace_hash_empty(hash))
 		hash = NULL;
 
-	return __ftrace_hash_update_ipmodify(ops, EMPTY_HASH, hash);
+	return __ftrace_hash_update_ipmodify(ops, EMPTY_HASH, hash, false);
 }
 
 /* Disabling always succeeds */
@@ -2087,7 +2100,7 @@ static void ftrace_hash_ipmodify_disable(struct ftrace_ops *ops)
 	if (ftrace_hash_empty(hash))
 		hash = NULL;
 
-	__ftrace_hash_update_ipmodify(ops, hash, EMPTY_HASH);
+	__ftrace_hash_update_ipmodify(ops, hash, EMPTY_HASH, false);
 }
 
 static int ftrace_hash_ipmodify_update(struct ftrace_ops *ops,
@@ -2101,7 +2114,7 @@ static int ftrace_hash_ipmodify_update(struct ftrace_ops *ops,
 	if (ftrace_hash_empty(new_hash))
 		new_hash = NULL;
 
-	return __ftrace_hash_update_ipmodify(ops, old_hash, new_hash);
+	return __ftrace_hash_update_ipmodify(ops, old_hash, new_hash, false);
 }
 
 static void print_ip_ins(const char *fmt, const unsigned char *p)
@@ -6108,7 +6121,7 @@ EXPORT_SYMBOL_GPL(unregister_ftrace_direct);
 static int
 __modify_ftrace_direct(struct ftrace_ops *ops, unsigned long addr)
 {
-	struct ftrace_hash *hash;
+	struct ftrace_hash *hash = ops->func_hash->filter_hash;
 	struct ftrace_func_entry *entry, *iter;
 	static struct ftrace_ops tmp_ops = {
 		.func		= ftrace_stub,
@@ -6128,13 +6141,21 @@ __modify_ftrace_direct(struct ftrace_ops *ops, unsigned long addr)
 	if (err)
 		return err;
 
+	/*
+	 * Call __ftrace_hash_update_ipmodify() here, so that we can call
+	 * ops->ops_func for the ops. This is needed because the above
+	 * register_ftrace_function_nolock() worked on tmp_ops.
+	 */
+	err = __ftrace_hash_update_ipmodify(ops, hash, hash, true);
+	if (err)
+		goto out;
+
 	/*
 	 * Now the ftrace_ops_list_func() is called to do the direct callers.
 	 * We can safely change the direct functions attached to each entry.
 	 */
 	mutex_lock(&ftrace_lock);
 
-	hash = ops->func_hash->filter_hash;
 	size = 1 << hash->size_bits;
 	for (i = 0; i < size; i++) {
 		hlist_for_each_entry(iter, &hash->buckets[i], hlist) {
@@ -6149,6 +6170,7 @@ __modify_ftrace_direct(struct ftrace_ops *ops, unsigned long addr)
 
 	mutex_unlock(&ftrace_lock);
 
+out:
 	/* Removing the tmp_ops will add the updated direct callers to the functions */
 	unregister_ftrace_function(&tmp_ops);
 
-- 
2.47.3


