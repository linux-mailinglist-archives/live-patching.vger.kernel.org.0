Return-Path: <live-patching+bounces-1794-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id A6EE5C04A6C
	for <lists+live-patching@lfdr.de>; Fri, 24 Oct 2025 09:14:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 954E84F948C
	for <lists+live-patching@lfdr.de>; Fri, 24 Oct 2025 07:14:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 38D772BEC2A;
	Fri, 24 Oct 2025 07:13:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Maae88aV"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 113142BE7BE;
	Fri, 24 Oct 2025 07:13:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761289998; cv=none; b=ZSI4VwrHmOSYZz6ss3gvGlUwLLGd6Ux5MkKjNcJqCaOi5Dd1P3OxSoftvVRmhJK0U2BqXOOVp0BvOFkWDz3leQ2Ch5LEn8KlI+dgfPAEAZ/iwyDrQrKgSAfzuUaAhlUYJyR0fjgcTm4wKKK7JCxFaQYDc6q9kmpON6O397uE1OU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761289998; c=relaxed/simple;
	bh=dRwk2duGjOgiVUXvxpsfAms/uxF7Qo0Z2IsSTZm/nD8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kPotAiMOTZlS4Qs59/q9jKdMAJArJkPKPFEQs7VDlXMuBDbsM6Rt6u/dbJ3Fjt1vNl5mqqw+iQYWkEawDkz+9pWAASRFwoi76FVpMsiSBwm5NHlqyDaeRIOzS3Dk2+uncLKthGz85wH9b7SOMAe6naUCHkeAUs7xTriDjpVkvzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Maae88aV; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A02CDC4CEF1;
	Fri, 24 Oct 2025 07:13:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761289997;
	bh=dRwk2duGjOgiVUXvxpsfAms/uxF7Qo0Z2IsSTZm/nD8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Maae88aVAbOGwjqMk1F1dDkeIsfw2dSf9eGbuRFnTEF3fv0syrwYBx2UC0ohA38d0
	 Rb3yhzTiXtMjgnR+K0+UFTT38cDoN+Rr7gpuruAHxkzsEdK43y/k9DFjpco9/PgPQk
	 COwIGUPMl57sfwaV+c9+mamTdjETGEJwgse4/x1lGTaNrczO8/0l2O+oFw+UE/f5yl
	 VoMWp2vnCyzkuUttRettcveHhdmVVGAsiNWvXybygv8T+Lm3GYCiwFQKKzCQterZ3E
	 BrqfnHm8ANRpXzdUHTycVhqJSAxePylGgVm2Mx65lHil/CweACIA7TXPReO1vRQ9mn
	 ia5dBcsxdPjqA==
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
	Song Liu <song@kernel.org>
Subject: [PATCH bpf-next 2/3] ftrace: bpf: Fix IPMODIFY + DIRECT in modify_ftrace_direct()
Date: Fri, 24 Oct 2025 00:12:56 -0700
Message-ID: <20251024071257.3956031-3-song@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251024071257.3956031-1-song@kernel.org>
References: <20251024071257.3956031-1-song@kernel.org>
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
 kernel/trace/ftrace.c   | 12 ++++++++++--
 2 files changed, 17 insertions(+), 7 deletions(-)

diff --git a/kernel/bpf/trampoline.c b/kernel/bpf/trampoline.c
index 5949095e51c3..8015f5dc3169 100644
--- a/kernel/bpf/trampoline.c
+++ b/kernel/bpf/trampoline.c
@@ -221,6 +221,13 @@ static int register_fentry(struct bpf_trampoline *tr, void *new_addr)
 
 	if (tr->func.ftrace_managed) {
 		ftrace_set_filter_ip(tr->fops, (unsigned long)ip, 0, 1);
+		/*
+		 * Clearing fops->trampoline_mutex and fops->NULL is
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
index 7f432775a6b5..370f620734cf 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -2020,8 +2020,6 @@ static int __ftrace_hash_update_ipmodify(struct ftrace_ops *ops,
 				if (is_ipmodify)
 					goto rollback;
 
-				FTRACE_WARN_ON(rec->flags & FTRACE_FL_DIRECT);
-
 				/*
 				 * Another ops with IPMODIFY is already
 				 * attached. We are now attaching a direct
@@ -6128,6 +6126,15 @@ __modify_ftrace_direct(struct ftrace_ops *ops, unsigned long addr)
 	if (err)
 		return err;
 
+	/*
+	 * Call ftrace_hash_ipmodify_enable() here, so that we can call
+	 * ops->ops_func for the ops. This is needed because the above
+	 * register_ftrace_function_nolock() worked on tmp_ops.
+	 */
+	err = ftrace_hash_ipmodify_enable(ops);
+	if (err)
+		goto out;
+
 	/*
 	 * Now the ftrace_ops_list_func() is called to do the direct callers.
 	 * We can safely change the direct functions attached to each entry.
@@ -6149,6 +6156,7 @@ __modify_ftrace_direct(struct ftrace_ops *ops, unsigned long addr)
 
 	mutex_unlock(&ftrace_lock);
 
+out:
 	/* Removing the tmp_ops will add the updated direct callers to the functions */
 	unregister_ftrace_function(&tmp_ops);
 
-- 
2.47.3


