Return-Path: <live-patching+bounces-1803-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id D8924C07BFE
	for <lists+live-patching@lfdr.de>; Fri, 24 Oct 2025 20:29:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 842A6354091
	for <lists+live-patching@lfdr.de>; Fri, 24 Oct 2025 18:29:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 28A9E347FCB;
	Fri, 24 Oct 2025 18:29:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PeTiAe5w"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBF1330BF73;
	Fri, 24 Oct 2025 18:29:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761330550; cv=none; b=p5SGJRS7TWYba9+0QI6CvfIvQGysDbDfTLw3QO0kWIwDMf6d4pn/XlvdoAsswYL4Qf8AgCPiSTO32xxcvehG7U8WhCXrDxF3mMTxJesE4l4aR3+IOeMoT6hC32tQIwOF/VSFgHwISWU7es9wtidLohZg1Hfkr6rYnZzVhr8KvlY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761330550; c=relaxed/simple;
	bh=bwkjI1Z6HoV6awRGzw93NVFkPh7LG4O7d4p3ZhdgmIM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=rHuns0URGKsfyXQ7R79jQXfMVCxemzUKrDDIxRZqLWZ9PeupUEmpmOBymtY5hvk63UE5Zw5c9Hnbut2s8ZamUFfjKxO3SnsOMCvAWfdbVajY7IZ7EagzpjBuQxBQGk9//LDXlg2uLeemHNO5ztsW+rp7LSb3tgzjDHntqOPCl6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PeTiAe5w; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8716BC4CEF1;
	Fri, 24 Oct 2025 18:29:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761330549;
	bh=bwkjI1Z6HoV6awRGzw93NVFkPh7LG4O7d4p3ZhdgmIM=;
	h=From:To:Cc:Subject:Date:From;
	b=PeTiAe5wCr0bLREVlQvLBJp8mbjzwK47/LkLNfvhNyQLV5UwWPYUfO13fJ9AC0ARq
	 XwgZhbuc2YBtpY0aNkyGDhcMRhkQOUsKr9L07Y55/dYtQxrNY3Y3h1njzonriYtS/H
	 P9P4AUgyVUxLGlCMt7m1YDRh3+ogji5oie0P6Pa1EwdA5kMMht3Ke6S/FFBM7yceYK
	 HJb2lywqG+AfHS8jagEYVhUpQxJgn580a+pMse7+0SNZKefW1efz27/TsNHNYeYz9L
	 fcEHUQhR5BwKUXC7f2cMWqK6ryEJvt8od0igA/PDpN87iPzibgGJPfO5e/OpuJjU3s
	 BWtzDSDWJ7lRg==
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
Subject: [PATCH v2 bpf 0/3] Fix ftrace for livepatch + BPF fexit programs
Date: Fri, 24 Oct 2025 11:28:58 -0700
Message-ID: <20251024182901.3247573-1-song@kernel.org>
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

 kernel/bpf/trampoline.c                       |  12 +-
 kernel/trace/ftrace.c                         |  42 +++++--
 tools/testing/selftests/bpf/config            |   3 +
 .../bpf/prog_tests/livepatch_trampoline.c     | 107 ++++++++++++++++++
 .../bpf/progs/livepatch_trampoline.c          |  30 +++++
 5 files changed, 180 insertions(+), 14 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/livepatch_trampoline.c
 create mode 100644 tools/testing/selftests/bpf/progs/livepatch_trampoline.c

--
2.47.3

