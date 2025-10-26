Return-Path: <live-patching+bounces-1814-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D4F3EC0B3B9
	for <lists+live-patching@lfdr.de>; Sun, 26 Oct 2025 21:55:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C56DC3AC116
	for <lists+live-patching@lfdr.de>; Sun, 26 Oct 2025 20:54:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EEB53271456;
	Sun, 26 Oct 2025 20:54:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="anz+i4OW"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9C1B242D88;
	Sun, 26 Oct 2025 20:54:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761512096; cv=none; b=PXxBzlVYf6qfIALDOC13zaCjgenT+hPeffxp4+ij7cUYq4bFOLXMGEEmEFqJwHuNgLaWdByhZxYmbUISfI39XaPIjzVCmeAsFvN7uvr51ghlxdipjmkKaeTvp4ADs/d1ykE8Hw7JD2uVovSHdXkbIMRbnPbsqvAN0gmeIIDG2LE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761512096; c=relaxed/simple;
	bh=qFc6IRw1WWz00LHSXBgPQUKtZpcZ1L54GRHkY9G2rMM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ztu7uu4Ee3wtK21UEMNdsJ5iuN0o1T6imzZVJJ8Gr5O1Ls89QojgJzFxMu6TwX0+uXxDowowGzdNIGHY8JXUlXy/Qn+LBkamMSuZB6KN+nh5DmVJRr4VDLiiq7e+bjLdEgLEPznozjJsIiXFh0gZlm4K0sziptRTG4jSM3nG3OA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=anz+i4OW; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECCC6C4CEE7;
	Sun, 26 Oct 2025 20:54:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761512096;
	bh=qFc6IRw1WWz00LHSXBgPQUKtZpcZ1L54GRHkY9G2rMM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=anz+i4OW3cXJ/mxNt5O6T4jC4aYbmxhkjY3LrgBxtI8HGBdSEdWzWIeWkfXxRvWJk
	 Yzvt+mhrIAM8ZRjxyEWPuBWq/7UJH7QsVqyFrmaXMlFjTxuSkp52TELHZt1vnjEFTv
	 HFwb6nUGHbjjl3B9gApPEb82od2untr68lq6AwgYnABqp9Pt3G/6eNl1LPUtGpgnW0
	 Oa3OjGLAhWh+359mB3rprkPROWoXCr92SOozVox3SNBsM5phCIezwFQqKceVccFl6D
	 BTmqW6wq+/rO8skVc7askY3igqZX7rJjJMhUIewHKM884mo+7fR8A+NbGn5xypFX+6
	 1uSxA9vNsvAnA==
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
	stable@vger.kernel.org
Subject: [PATCH v3 bpf 1/3] ftrace: Fix BPF fexit with livepatch
Date: Sun, 26 Oct 2025 13:54:43 -0700
Message-ID: <20251026205445.1639632-2-song@kernel.org>
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

Also, move the code that resets ops->func and ops->trampoline to
the error path of register_ftrace_direct().

Fixes: d05cb470663a ("ftrace: Fix modification of direct_function hash while in use")
Cc: stable@vger.kernel.org # v6.6+
Reported-by: Andrey Grodzovsky <andrey.grodzovsky@crowdstrike.com>
Closes: https://lore.kernel.org/live-patching/c5058315a39d4615b333e485893345be@crowdstrike.com/
Cc: Steven Rostedt (Google) <rostedt@goodmis.org>
Cc: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Acked-and-tested-by: Andrey Grodzovsky <andrey.grodzovsky@crowdstrike.com>
Signed-off-by: Song Liu <song@kernel.org>
---
 kernel/bpf/trampoline.c | 5 -----
 kernel/trace/ftrace.c   | 6 ++++++
 2 files changed, 6 insertions(+), 5 deletions(-)

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
index 42bd2ba68a82..725c224fb4e6 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -6048,6 +6048,12 @@ int register_ftrace_direct(struct ftrace_ops *ops, unsigned long addr)
 	ops->direct_call = addr;
 
 	err = register_ftrace_function_nolock(ops);
+	if (err) {
+		/* cleanup for possible another register call */
+		ops->func = NULL;
+		ops->trampoline = 0;
+		remove_direct_functions_hash(hash, addr);
+	}
 
  out_unlock:
 	mutex_unlock(&direct_mutex);
-- 
2.47.3


