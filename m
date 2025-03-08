Return-Path: <live-patching+bounces-1263-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 38BE7A5772B
	for <lists+live-patching@lfdr.de>; Sat,  8 Mar 2025 02:27:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1BBC23B2F2D
	for <lists+live-patching@lfdr.de>; Sat,  8 Mar 2025 01:27:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 31F7B12E5B;
	Sat,  8 Mar 2025 01:27:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Gqm6tWhH"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E908EBA49;
	Sat,  8 Mar 2025 01:27:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741397270; cv=none; b=Va1PfX0YKmeEzHxNDp/xEPqcF/GDW5OtmEWrTCxohomCrZ0UipPxNEqVQtt+hQBuqrxrlZGMQDRvF9hO9+8cBSs14OnfG3g2K8NtaqiZpjqRgPSgfluk+vUJY4GBcbHk932lgtnGruKTf6KcN/IUIwUbj86GWzvGprAl12Bnz5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741397270; c=relaxed/simple;
	bh=Hu8IOn0VSbEg4hk9ZqH8VsMwBi+3CebEMND9m2kLPIY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=aOACkf6HDhFUZkWWF9qO1ybJA7/k/rvEACl13ab9LpxIjTOYWnaIEUopNZTaEhDajAK488obH9dr94m010BWwHPQMig5zryOGO7IzpmHjgTH8tEsmri3V8zHlKqvQKhExRnJTua3VjNu6HInQKP7CwxGoq/Y0mkl9w7GgTffJWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Gqm6tWhH; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A016AC4CED1;
	Sat,  8 Mar 2025 01:27:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741397269;
	bh=Hu8IOn0VSbEg4hk9ZqH8VsMwBi+3CebEMND9m2kLPIY=;
	h=From:To:Cc:Subject:Date:From;
	b=Gqm6tWhH6S9RFR12RcKOPUTP3ZFPc9JOf36/KEdJcR6JQ6Q167AXqyDI29y5S+hqb
	 +eh3ymvU7jaoB2hc+Dm/OcDjHVCI3DIZWbjm8rIrugRAjRLcwSayCKKTejCHwoRm5j
	 VOMAxgVEl8DVxD0b+DeG6jd9XjTxlz2Lgi7lsuefM7WoNal3TSSngznoXmb2rgeONp
	 biJBPRZjcZrY/yTqBM5pdY7zpNPmWTUAH7xgkbZA23kK/3+ZSiAZcpVtOcpli8uhkg
	 MlMmJXwB+Mkuv7Y88WpfJVX5X9/ifsLWQ05eERHpjHojLyqwJCn4Ng7Dku2al0Mz3o
	 P1jmx5vTRQovQ==
From: Song Liu <song@kernel.org>
To: linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-toolchains@vger.kernel.org,
	live-patching@vger.kernel.org
Cc: indu.bhagat@oracle.com,
	puranjay@kernel.org,
	wnliu@google.com,
	irogers@google.com,
	joe.lawrence@redhat.com,
	jpoimboe@kernel.org,
	mark.rutland@arm.com,
	peterz@infradead.org,
	roman.gushchin@linux.dev,
	rostedt@goodmis.org,
	will@kernel.org,
	kernel-team@meta.com,
	song@kernel.org
Subject: [PATCH 0/2] arm64: livepatch: Enable livepatch without sframe
Date: Fri,  7 Mar 2025 17:27:40 -0800
Message-ID: <20250308012742.3208215-1-song@kernel.org>
X-Mailer: git-send-email 2.43.5
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

There are recent efforts to enable livepatch for arm64, with sframe [1] or
without sframe [2]. This set tries to enable livepatch without sframe. Some
of the code, however, are from [1].

Although the sframe implementation is more promising in longer term, it
suffers from the following issues:

  1. sframe is not yet supported in llvm;
  2. There is still bug in binutil [3], so that we cannot yet use sframe
     with gcc;
  3. sframe unwinder hasn't been fully verified in the kernel.

On the other hand, arm64 processors have become more and more important in
the data center world. Therefore, it is getting critical to support
livepatching of arm64 kernels.

With recent change in arm64 unwinder [4], it is possible to reliably
livepatch arm64 kernels without sframe. This is because we do not need
arch_stack_walk_reliable() to get reliable stack trace in all scenarios.
Instead, we only need arch_stack_walk_reliable() to detect when the
stack trace is not reliable, then the livepatch logic can retry the patch
transition at a later time.

Given the increasing need of livepatching, and relatively long time before
sframe is fully ready (for both gcc and clang), we would like to enable
livepatch without sframe.

Thanks!

[1] https://lore.kernel.org/live-patching/20250127213310.2496133-1-wnliu@google.com/
[2] https://lore.kernel.org/live-patching/20250129232936.1795412-1-song@kernel.org/
[3] https://sourceware.org/bugzilla/show_bug.cgi?id=32589
[4] https://lore.kernel.org/linux-arm-kernel/20241017092538.1859841-1-mark.rutland@arm.com/

Song Liu (2):
  arm64: Implement arch_stack_walk_reliable
  arm64: Implement HAVE_LIVEPATCH

 arch/arm64/Kconfig                         |  3 ++
 arch/arm64/include/asm/stacktrace/common.h |  1 +
 arch/arm64/include/asm/thread_info.h       |  4 +-
 arch/arm64/kernel/entry-common.c           |  4 ++
 arch/arm64/kernel/stacktrace.c             | 44 +++++++++++++++++++++-
 5 files changed, 54 insertions(+), 2 deletions(-)

--
2.43.5

