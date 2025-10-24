Return-Path: <live-patching+bounces-1793-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A6EF6C04A66
	for <lists+live-patching@lfdr.de>; Fri, 24 Oct 2025 09:14:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F33031A6890C
	for <lists+live-patching@lfdr.de>; Fri, 24 Oct 2025 07:15:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 505D12BE652;
	Fri, 24 Oct 2025 07:13:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="slO9vjQm"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FD032BE62C;
	Fri, 24 Oct 2025 07:13:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761289994; cv=none; b=QXSFk485aazNpdPK3YJREHUq6frYWc6ZTywxDHFbc9Wy/WjOV/es5cO16MPesfANmRh5rndwOVXjHOuyqfM11bTjaynL/uPMGsa3NLaa4V+Z/9I5o/Db4QhH0yIQ6aXSIiJWAgm76YEITo5kZHLSbIg9beAeLJgY/Gj3liF0Eqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761289994; c=relaxed/simple;
	bh=v3alifd4spQ4PX27XFDQRRV9caTSEiUjeuzCpr8NHJA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p7iGq5/GCShnrLZEm4x67zER9p3aM/v2Q3k9JsqxqstXTndv8e1cfNRK0B7tErRpI+WLrBlJ/MbTjF8HD1YjVP/Grh41DtvNoae8GYF7wSoTPH+49InKjSunSDSfkCtS6ZAAvZrexcgBs11OqgCPWr19I1KVo2AQCsXxHcukIM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=slO9vjQm; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9234EC4CEF1;
	Fri, 24 Oct 2025 07:13:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761289992;
	bh=v3alifd4spQ4PX27XFDQRRV9caTSEiUjeuzCpr8NHJA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=slO9vjQmohw3KD4gaVx23GIBynYcBHWGWsdR9gJInZcmxuREA867pdoHoW4T+ttlm
	 U+jIAAar+byTVT2FJiCrQPlc+EiBSlhgyn1I5nUtkVN4WjxllStTQMjECO/kG90K+5
	 qXd3QSS2Y6UvydxEiFkHbPe6kuestvsq2i8h56Jzf85ddSwxVuCj4cElaru79FkxrM
	 6Gl3IPkBlUYcZwuMNgc+tKWv56DeopCAHLHPZrk6f/FK9xt7aJ/4B5ATvjZyam1kOD
	 1fkxTHpFohk3/eiWgjVaVSMKY/BBqCtpfYaoYK3cv16yiNbArjtL1EFidZk0r2IktR
	 3+KkNYqSGJvlg==
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
	Song Liu <song@kernel.org>,
	stable@vger.kernel.org
Subject: [PATCH bpf-next 1/3] ftrace: Fix BPF fexit with livepatch
Date: Fri, 24 Oct 2025 00:12:55 -0700
Message-ID: <20251024071257.3956031-2-song@kernel.org>
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

Fixes: d05cb470663a ("ftrace: Fix modification of direct_function hash while in use")
Cc: stable@vger.kernel.org # v6.6+
Reported-by: Andrey Grodzovsky <andrey.grodzovsky@crowdstrike.com>
Closes: https://lore.kernel.org/live-patching/c5058315a39d4615b333e485893345be@crowdstrike.com/
Cc: Steven Rostedt (Google) <rostedt@goodmis.org>
Cc: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Acked-and-tested-by: Andrey Grodzovsky <andrey.grodzovsky@crowdstrike.com>
Signed-off-by: Song Liu <song@kernel.org>
---
 kernel/trace/ftrace.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 42bd2ba68a82..7f432775a6b5 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -6048,6 +6048,8 @@ int register_ftrace_direct(struct ftrace_ops *ops, unsigned long addr)
 	ops->direct_call = addr;
 
 	err = register_ftrace_function_nolock(ops);
+	if (err)
+		remove_direct_functions_hash(hash, addr);
 
  out_unlock:
 	mutex_unlock(&direct_mutex);
-- 
2.47.3


