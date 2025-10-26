Return-Path: <live-patching+bounces-1815-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 74B62C0B3C5
	for <lists+live-patching@lfdr.de>; Sun, 26 Oct 2025 21:55:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5133D3ACCBC
	for <lists+live-patching@lfdr.de>; Sun, 26 Oct 2025 20:55:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D3D0323EA99;
	Sun, 26 Oct 2025 20:55:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R1Ml+YqM"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A70B522AE7F;
	Sun, 26 Oct 2025 20:55:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761512101; cv=none; b=B14C1OPz9BZVe3znd+Hvz8G5DlmJMmqLZQDe2krTN291pBPNTcQBXwOrD7DXLPZu3LBHFvQKTQF22wtzVssCXRlSg31Cr4qTMYK5164TgxghSfq+MdAqC8PqpwB5JLvslylvvGEF/4E0G+FohNb9TDDO1UCzlu5TlN7aXJ+Dbjg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761512101; c=relaxed/simple;
	bh=wZ1H/itya+t08fIrwP5idZ19id6Inpt/pLHZujcFfxw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J4wgA9J0J3UpS2jGuEE1vD8h4dAGiC20gHBwB9iNe6mlCwVHq8c36gtmVgRm4g+y+iuR4AWcKxUq+M21fZ1VX9yK7Gzd33iYX/EQc3ASP3Z4VlOX8/IoP9AnNLPrJXRr3F5HUJWevxC29/GHEnm5wle1q3yLpb6ZIo06+YO0kKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=R1Ml+YqM; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14D18C4CEE7;
	Sun, 26 Oct 2025 20:55:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761512101;
	bh=wZ1H/itya+t08fIrwP5idZ19id6Inpt/pLHZujcFfxw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R1Ml+YqMW1FToTq4y1j8apsOJGXfcQJ2A2SXaipdAP8VA/mOA7XkXDg+Hyqgq+yBM
	 qPBHHCugimVaigFZoDbe1k6OyOhixLIxQpioiKSeziD/+ZdPk3viVZrxh7wQf8zYt7
	 UgOyD74C9v6ypjeBYc+fiLZK9DaRc6coBaKefAckze0IC66rAlbP1LaEIvuQS/0Jyc
	 zG4t2hsc4omSptLp7fc4pP+QNitksPzWM2BX003IxSb42gUwcqk014DxQAmgQa5jYb
	 +EpJwO3EivJ0omZO38VZkXpKFng6Si4lYgSzZ+IThho8o1JsGHSrjr75hMyE4yHv+O
	 I1gRcljf/Jasg==
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
Subject: [PATCH v3 bpf 2/3] ftrace: bpf: Fix IPMODIFY + DIRECT in modify_ftrace_direct()
Date: Sun, 26 Oct 2025 13:54:44 -0700
Message-ID: <20251026205445.1639632-3-song@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251026205445.1639632-1-song@kernel.org>
References: <20251026205445.1639632-1-song@kernel.org>
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
---
 kernel/trace/ftrace.c | 40 +++++++++++++++++++++++++++++++---------
 1 file changed, 31 insertions(+), 9 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 725c224fb4e6..e977538fc0ca 100644
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
@@ -6112,7 +6125,7 @@ EXPORT_SYMBOL_GPL(unregister_ftrace_direct);
 static int
 __modify_ftrace_direct(struct ftrace_ops *ops, unsigned long addr)
 {
-	struct ftrace_hash *hash;
+	struct ftrace_hash *hash = ops->func_hash->filter_hash;
 	struct ftrace_func_entry *entry, *iter;
 	static struct ftrace_ops tmp_ops = {
 		.func		= ftrace_stub,
@@ -6132,13 +6145,21 @@ __modify_ftrace_direct(struct ftrace_ops *ops, unsigned long addr)
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
@@ -6153,6 +6174,7 @@ __modify_ftrace_direct(struct ftrace_ops *ops, unsigned long addr)
 
 	mutex_unlock(&ftrace_lock);
 
+out:
 	/* Removing the tmp_ops will add the updated direct callers to the functions */
 	unregister_ftrace_function(&tmp_ops);
 
-- 
2.47.3


