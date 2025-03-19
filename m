Return-Path: <live-patching+bounces-1305-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 93076A69B00
	for <lists+live-patching@lfdr.de>; Wed, 19 Mar 2025 22:38:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0233D18965B8
	for <lists+live-patching@lfdr.de>; Wed, 19 Mar 2025 21:38:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2CC6E214A81;
	Wed, 19 Mar 2025 21:38:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="c6Fm9HRR"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2F3F214801;
	Wed, 19 Mar 2025 21:38:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742420297; cv=none; b=k9h6Fie6RmjyTPamj/2o3CtLvSQagIZ+9guzCk8SnsSIAZpNyay4W3QaeT4S83t+JgV6/IW+RPQ1LJzsxYgkJKIZ+AF9wRV3NENAslTl3txGzKNGkOkSfnP4tYrk1ACGbP/jmti6qgIaF7B6kjvkzS4M9S3fYrjcRwuWgXHUnXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742420297; c=relaxed/simple;
	bh=CHbeGKtiOcjgUDiBD5Y2J8NFeMr77PuocseHhs6qAsI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=R+d4fc44WHw4N+818WdBNaDVtx6vTuG0aOi8PdNYBp/SPC57SDk9+1ECp8/hhgcZ9IwCJwyOAZzU5owgDKc8SPaO6tEkNcWWcjXszv2Y7j1P/rl8qpxV2el+JZOE4l2Ywy5aK48LYHi+jbROgAtw+dgOCSO9KL2T3BRB0hTlReU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=c6Fm9HRR; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4031FC4CEE4;
	Wed, 19 Mar 2025 21:38:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742420296;
	bh=CHbeGKtiOcjgUDiBD5Y2J8NFeMr77PuocseHhs6qAsI=;
	h=From:To:Cc:Subject:Date:From;
	b=c6Fm9HRR+4odFsCyCiBiNY3tiO7VQFcmHm7vcY53k4+USjAVqfEwBy7K9MDjYZM8r
	 p78/4M0fY+qLB/c9qFVmY3p3TY57M82R/k3A5lUvGnYM5hIFlz2RCavJkYLliXb/AQ
	 aR9JDA6yILTZ9s+i8i5U0svs4giTrtJQWSoG09WWDn3jWnwrFP3n88gTmfYYu9bh2X
	 dUXekZdqRLOUKVZqoB9s2ouf8dgU/zIM9hrlrvFTqAp7z6M7qWuV+cOTO62T4eh+I0
	 B82mfqzpFJ3Z9VGaaSOYxR1nXK1g2d9WCdAiDkra+g8mdqlqNQLx5TSjmfSNiB/YW7
	 jf6+1evMS83aw==
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
Subject: [PATCH v2 0/2] arm64: livepatch: Enable livepatch without sframe
Date: Wed, 19 Mar 2025 14:37:05 -0700
Message-ID: <20250319213707.1784775-1-song@kernel.org>
X-Mailer: git-send-email 2.47.1
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

Changes v1 => v2:

1. Rework arch_stack_walk_reliable().

v1: https://lore.kernel.org/live-patching/20250308012742.3208215-1-song@kernel.org/

Song Liu (2):
  arm64: Implement arch_stack_walk_reliable
  arm64: Implement HAVE_LIVEPATCH

 arch/arm64/Kconfig                   |  3 ++
 arch/arm64/include/asm/thread_info.h |  4 +-
 arch/arm64/kernel/entry-common.c     |  4 ++
 arch/arm64/kernel/stacktrace.c       | 70 +++++++++++++++++++++-------
 4 files changed, 64 insertions(+), 17 deletions(-)

--
2.47.1

