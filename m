Return-Path: <live-patching+bounces-1804-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9EF91C07C28
	for <lists+live-patching@lfdr.de>; Fri, 24 Oct 2025 20:31:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B20D13A3EBA
	for <lists+live-patching@lfdr.de>; Fri, 24 Oct 2025 18:29:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE752348454;
	Fri, 24 Oct 2025 18:29:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="h4KvQ2se"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE90933B976;
	Fri, 24 Oct 2025 18:29:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761330554; cv=none; b=YnxOJ/DhOuE/5FE51xhNTDnWkIvBLsQZ29WMXSiP3dueRaxrr5oIoLnI22kdn1fcFKtLwOeZhZ3KLxiU5r8pe2xFI7NB2eEkb9atun2Ivr5vf6FJdK+3+pgg22aXgNiOxVHDRbrlvMbQ8WV8dTM3i2j7YB2UQod1So2Th4Xiv2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761330554; c=relaxed/simple;
	bh=v3alifd4spQ4PX27XFDQRRV9caTSEiUjeuzCpr8NHJA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CVty0jw5qUcR7wNaXriI7yV8eqdoo4DAlnCrLWjWqYdAqXzUkkf9lclBMVAFBfcVh+vB6/QTk5fkqZ2bzNuTIHKnDh4hJd7maCpYHv9wwbr9FKEwtKRosMrJ8HXk9ZdrlOMGYJYn3fRdSorZeLkwc+Yq+ivTLmO//vb1fZEdVtg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=h4KvQ2se; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4609FC4CEF1;
	Fri, 24 Oct 2025 18:29:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761330554;
	bh=v3alifd4spQ4PX27XFDQRRV9caTSEiUjeuzCpr8NHJA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h4KvQ2sebG4kL6bDk7EA+rTGfM4XK64u+ryWXQdxt9IXKM2d0KkxltYKGER+X3D4c
	 SzQV0WPSRVLNQ8DYAQBKsNbCN4Fn0sI0UFvGuWi4UpGBiK7LboU56feyPx09/GfRux
	 AjrwnIeYwQnN1lrMuZGVUrYpdm3B93h8ZweuaTzY2mEMOUXz/EcSuBPk9ARtLMuTgr
	 42NiXx9mLGHeTFjvoSJSkb5+Ytn4i5IZmIumrGYmAmmJXuLRkhz4piEjX2cZuKjSsb
	 4F/x6MYhbK06Vs9bO0eRfs0PdbSq8wWltmN+gJqDzVan/J04UGPk3bsroGsI8lWBQT
	 PzgISn2g8xASg==
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
Subject: [PATCH v2 bpf 1/3] ftrace: Fix BPF fexit with livepatch
Date: Fri, 24 Oct 2025 11:28:59 -0700
Message-ID: <20251024182901.3247573-2-song@kernel.org>
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


