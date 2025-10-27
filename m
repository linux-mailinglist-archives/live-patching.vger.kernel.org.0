Return-Path: <live-patching+bounces-1825-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3AA17C0FC9D
	for <lists+live-patching@lfdr.de>; Mon, 27 Oct 2025 18:52:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AAE61468B35
	for <lists+live-patching@lfdr.de>; Mon, 27 Oct 2025 17:51:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CECCD3168FC;
	Mon, 27 Oct 2025 17:50:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VxAFBYBV"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A06B42D640D;
	Mon, 27 Oct 2025 17:50:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761587452; cv=none; b=V4EHMq8KRfNcYzRjuVKMG1ArsVom+BrZVdnpckwM9ne1i+5P08ETH7EuXsj6070hBLU6bQAo4r8ePz80rBFNSmwPzJO0zXJihgKRx4FqeCIp0Pp0e2etentbI/X3GWchfshXKTNtkoWichFa7iUeJrAEv3B7CwiFIpUN3bNdwXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761587452; c=relaxed/simple;
	bh=DyNToPloyJM1mLk/97Yrs8UCsJCSjKY0Z2CKy3b7YtI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T6dtivjDnwoRK5/iCc4/Y6oFThXi6i4Ids/7WoITRBH9eGG4Ook0968EmA/nxkJzYVxbh/2yggAbDFTqf/V1SDe64niw9O2mYdYo8nancVjf4c9RF/gJnfVT6ZOR6mnvFbgtDW6cIkfQ7j/bb9ZiDEhIe0U7zyj8D0dVPptXMxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VxAFBYBV; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA6F3C4CEF1;
	Mon, 27 Oct 2025 17:50:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761587452;
	bh=DyNToPloyJM1mLk/97Yrs8UCsJCSjKY0Z2CKy3b7YtI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VxAFBYBV4SrlZqNVoni6AJdC3t+nf1EXwC7u8xsZK1Q6juWkXpkyr/OenTRlNaAwB
	 ShzSO4OTAi7rCk9cseao5CbEEWKgKiz/0gpy3GVu3O1LxC/CvcTkZXSgYlD2fl7ENp
	 cRBpatf1ULxLE46/YXg2pvcka8Wt4VsO42JAApY1sIKL85UIHzK6Q8BTKmdc6Ju3E7
	 iJu3270DOS2zXva8ou29QxFKsCh6u/K/ofBD0hRjd2xXMIUh3ufT0j0CHCQzr56uKZ
	 5KCeXk5xiL6KYbgWnB7MFm+hdLlmvQxMocsJmHCyYC7uAIHhz8W5VGnm0cf9BIRnRA
	 sP+6AmmBYancw==
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
	Jiri Olsa <jolsa@kernel.org>
Subject: [PATCH v4 bpf 2/3] ftrace: bpf: Fix IPMODIFY + DIRECT in modify_ftrace_direct()
Date: Mon, 27 Oct 2025 10:50:22 -0700
Message-ID: <20251027175023.1521602-3-song@kernel.org>
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

Fix this by adding __ftrace_hash_update_ipmodify() to
__modify_ftrace_direct() and adjust some logic around the call.

Signed-off-by: Song Liu <song@kernel.org>
Reviewed-by: Jiri Olsa <jolsa@kernel.org>
---
 kernel/trace/ftrace.c | 40 +++++++++++++++++++++++++++++++---------
 1 file changed, 31 insertions(+), 9 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index cbeb7e833131..59cfacb8a5bb 100644
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
+				 * then it is only changing where the direct
+				 * pointer is jumping to, and the record already
+				 * points to a direct trampoline. If it isn't,
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
@@ -6114,7 +6127,7 @@ EXPORT_SYMBOL_GPL(unregister_ftrace_direct);
 static int
 __modify_ftrace_direct(struct ftrace_ops *ops, unsigned long addr)
 {
-	struct ftrace_hash *hash;
+	struct ftrace_hash *hash = ops->func_hash->filter_hash;
 	struct ftrace_func_entry *entry, *iter;
 	static struct ftrace_ops tmp_ops = {
 		.func		= ftrace_stub,
@@ -6134,13 +6147,21 @@ __modify_ftrace_direct(struct ftrace_ops *ops, unsigned long addr)
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
@@ -6155,6 +6176,7 @@ __modify_ftrace_direct(struct ftrace_ops *ops, unsigned long addr)
 
 	mutex_unlock(&ftrace_lock);
 
+out:
 	/* Removing the tmp_ops will add the updated direct callers to the functions */
 	unregister_ftrace_function(&tmp_ops);
 
-- 
2.47.3


