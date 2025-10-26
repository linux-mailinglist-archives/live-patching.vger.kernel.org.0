Return-Path: <live-patching+bounces-1813-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 768DAC0B3B3
	for <lists+live-patching@lfdr.de>; Sun, 26 Oct 2025 21:55:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 31B9C3AC0AD
	for <lists+live-patching@lfdr.de>; Sun, 26 Oct 2025 20:54:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 92914238178;
	Sun, 26 Oct 2025 20:54:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QZtwZNP7"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5228E4CB5B;
	Sun, 26 Oct 2025 20:54:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761512091; cv=none; b=SeFecsnsRqbP9RJrBMKi318r4JKiw/oBne/9EzQ96hcCKFdvZqoy5VZk9UTN6dWPbJ+WWLIzolkhibKMvSI8X7VxkwaDLeiRVByy1KwhsvhitwJqGFMcPXdMtE9pSG+0Q7SendFkCKoawYcZZQS5KjWW3x3NsZmnqZiOo4rX6DU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761512091; c=relaxed/simple;
	bh=AvRnHey8Dt9Vsn8DADxNsvkPE4zMptWkXpwqLcWiVVs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=YZNMuPk6NEc6Jf80rbqHjag7WY0giN5xFolt+Erw+I/Ph/2XXLWQ8anGaH1w3tlECbl4rHbbRqARaLr4515TLxctmfhRoFG0AJxLSsSSBs3cUFDEW8h527/KnvNJnJJsJtmTe+BYws7RLVzhfjajJ6VTa9cCgHvpF9XcfPOVU2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QZtwZNP7; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CF8CC4CEE7;
	Sun, 26 Oct 2025 20:54:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761512090;
	bh=AvRnHey8Dt9Vsn8DADxNsvkPE4zMptWkXpwqLcWiVVs=;
	h=From:To:Cc:Subject:Date:From;
	b=QZtwZNP7I64SM6yl9eI2HchSaOcBlV0nYUuo9GGcUzAhGLjrR/wEpaDJMbzVcwu/n
	 pf6RZI3rAmfpvx3DQqrmBe3frdSTj024GfXmeVdempRTbkEJhY80iFwgZQ5DqDdiHW
	 VQ8Mp2BEZHlLxXwc8bGd5C38WfmuTXlC2J2MeDTGSiCSHXxKEconIkvix6MeD7Gn8Z
	 2TSSu4Gw4af9eg9+m4vfPDGSMdtKiZOsXH6QSY5EvkzfsRq/lsafWm2BybAGQQFv2j
	 GnpuSH8tC+UUXhUPtkcwxNAYk6KkS9UNn+1MoByNRD+YP3wR27hccjKBx2KrI1juUZ
	 JWI6HIs/tZPvw==
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
Subject: [PATCH v3 bpf 0/3] Fix ftrace for livepatch + BPF fexit programs
Date: Sun, 26 Oct 2025 13:54:42 -0700
Message-ID: <20251026205445.1639632-1-song@kernel.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

livepatch and BPF trampoline are two special users of ftrace. livepatch
uses ftrace with IPMODIFY flag and BPF trampoline uses ftrace direct
functions. When livepatch and BPF trampoline with fexit programs attach to
the same kernel function, BPF trampoline needs to call into the patched
version of the kernel function.

1/3 and 2/3 of this patchset fix two issues with livepatch + fexit cases,
one in the register_ftrace_direct path, the other in the
modify_ftrace_direct path.

3/3 adds selftests for both cases.

---

Changes v2 => v3:
1. Incorporate feedback by AI, which also fixes build error reported by
   Steven and kernel test robot.

v2: https://lore.kernel.org/bpf/20251024182901.3247573-1-song@kernel.org/

Changes v1 => v2:
1. Target bpf tree. (Alexei)
2. Bring back the FTRACE_WARN_ON in __ftrace_hash_update_ipmodify
   for valid code paths. (Steven)
3. Update selftests with cleaner way to find livepatch-sample.ko.
   (offlline discussion with Ihor)

v1: https://lore.kernel.org/bpf/20251024071257.3956031-1-song@kernel.org/

Song Liu (3):
  ftrace: Fix BPF fexit with livepatch
  ftrace: bpf: Fix IPMODIFY + DIRECT in modify_ftrace_direct()
  selftests/bpf: Add tests for livepatch + bpf trampoline

 kernel/bpf/trampoline.c                       |   5 -
 kernel/trace/ftrace.c                         |  46 ++++++--
 tools/testing/selftests/bpf/config            |   3 +
 .../bpf/prog_tests/livepatch_trampoline.c     | 107 ++++++++++++++++++
 .../bpf/progs/livepatch_trampoline.c          |  30 +++++
 5 files changed, 177 insertions(+), 14 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/livepatch_trampoline.c
 create mode 100644 tools/testing/selftests/bpf/progs/livepatch_trampoline.c

--
2.47.3

