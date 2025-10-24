Return-Path: <live-patching+bounces-1792-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 07E3FC04A60
	for <lists+live-patching@lfdr.de>; Fri, 24 Oct 2025 09:14:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 508DB1A686D0
	for <lists+live-patching@lfdr.de>; Fri, 24 Oct 2025 07:15:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 56A492BDC28;
	Fri, 24 Oct 2025 07:13:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Sialko9X"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 249D72BDC0B;
	Fri, 24 Oct 2025 07:13:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761289988; cv=none; b=jSnZr8bIsEynPFHXXxFGXNURngGu1EhygzfxlswqFUSGLnQwGH26NAieXdJKBDhQbR0k/jC7CvU9JtcAugtiU/S+uFGLAhRAJljf9LLhcOA0FFOqUFMtt6GxJnDMPUmKlcAEXgmHo8m1uTd+2ojtUIgUysEddabezyFGKZIPP8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761289988; c=relaxed/simple;
	bh=XeXg4lDp3Riw9X2ReIYXwLGjhMu7mwJaazG51IPGv1E=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=JfqzqXFY8PkSgsU9bAzfuuAFL2eHXuGqI7tkT32fzphlFXaIUThxMQabD27RR+pkMFZx5mEx10ayE/xBEUmP4Fr79fuYgNfRUvKhtWt6tGyDLt7UaamDRd5lbG1Zryrfhbmt0ueOnN0Cz4hrTAsM2SRk6dS9jrz6IUQVjwEW4NA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Sialko9X; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C131C4CEF1;
	Fri, 24 Oct 2025 07:13:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761289987;
	bh=XeXg4lDp3Riw9X2ReIYXwLGjhMu7mwJaazG51IPGv1E=;
	h=From:To:Cc:Subject:Date:From;
	b=Sialko9XOrhkYIBQRAghNbwAyLbHAD2JMs9aC1SKh71bd+VZSQiBYR78hf09xFPpP
	 tGLacTHWM1Kv9c62AgB7SKFkUrV7CirL9swbLiiz95Fnmmfs6N1hMuNHtHxxDjVKUj
	 IEem10tmY7PGdFAHOxDIQ9sB9tDAXMskrz40cgZ7d4BEzXj70Da781NKpoCsxnkxR2
	 5GaEUsRHose4HAvbc62sx12HWyfJTrBEQ3Zd9rpVsrCEhF+qIgXna00PNaMpctNsSo
	 bVz2m05W4gIJQ7/J2RHvj0DjpLu+xYoKDqH1wbw/ZjsEGhI90NmIhI8F2gL5GPMUAv
	 t54pL2XbPQs/Q==
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
Subject: [PATCH bpf-next 0/3] Fix ftrace for livepatch + BPF fexit programs
Date: Fri, 24 Oct 2025 00:12:54 -0700
Message-ID: <20251024071257.3956031-1-song@kernel.org>
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

Song Liu (3):
  ftrace: Fix BPF fexit with livepatch
  ftrace: bpf: Fix IPMODIFY + DIRECT in modify_ftrace_direct()
  selftests/bpf: Add tests for livepatch + bpf trampoline

 kernel/bpf/trampoline.c                       |  12 ++-
 kernel/trace/ftrace.c                         |  14 ++-
 tools/testing/selftests/bpf/config            |   3 +
 .../bpf/prog_tests/livepatch_trampoline.c     | 101 ++++++++++++++++++
 .../bpf/progs/livepatch_trampoline.c          |  30 ++++++
 5 files changed, 153 insertions(+), 7 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/livepatch_trampoline.c
 create mode 100644 tools/testing/selftests/bpf/progs/livepatch_trampoline.c

--
2.47.3

