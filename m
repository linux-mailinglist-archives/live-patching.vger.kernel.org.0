Return-Path: <live-patching+bounces-416-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 564BA9402CD
	for <lists+live-patching@lfdr.de>; Tue, 30 Jul 2024 02:54:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0D0201F228EC
	for <lists+live-patching@lfdr.de>; Tue, 30 Jul 2024 00:54:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A81461373;
	Tue, 30 Jul 2024 00:54:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WmsMjIP+"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A1B07464;
	Tue, 30 Jul 2024 00:54:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722300884; cv=none; b=FsmDygTbuSnPVrq29QNGx1UlDxmyZbxvfuvLVqNC2Vrkv/oY4d2EE6XpzgoBf8BiRnaDsDQfzckFLyzlYTTmBHJe2HxJL9iF8H8feQjYxZEpU/TPQKWf7kOEhNLdOgbs2LxSZAYG55/yz1oTGhEx+jT0Ob1kHctKyIm98d6YKcY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722300884; c=relaxed/simple;
	bh=Mg9VPmF3hpcgKy3QawKIGhZMvsuH7nxyRyTuwBFazQo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=YtLSxXgT+LKNF5N5IaqIk74/IJBqXzUX9HwcHHFiUvXSWIAK0unem0AKewH+uV2QGGVivpMyJ6YfmzpuupJtRAh8CouU1URDUiftrkQ8Zc+jNqZULVlfXCHxf2ItYTZByN28fYThmkl13dqd7b6DdDhHf3vadEAjtqKCHHISqUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WmsMjIP+; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C848C32786;
	Tue, 30 Jul 2024 00:54:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722300884;
	bh=Mg9VPmF3hpcgKy3QawKIGhZMvsuH7nxyRyTuwBFazQo=;
	h=From:To:Cc:Subject:Date:From;
	b=WmsMjIP+WllllCW/+Jgs1ydqS8bW24IfZrH9ZmWr5ZAH1A7YKST/jpRhWYG68cz8u
	 YahMAnDKFzCZiraIB8XaSHr+E9bK9YWgcFIUZbg6jVvHMI86Jv0iClHJI8YzbwcJcS
	 VmZ8TGaAkDZTwgSSITopB94AdmNo8HGOfdEgX9yut98kdb6ERFLjdG8S5M+PuSie4E
	 iRxbkQiDLddptn56I54YgDR7coelVOWJrM3IVVoIFSYRSVSy5/gST/CPI0Epw9P86E
	 bhefDgnqK4GD/zhVhq5kEvas3t3vvECKqJyJJs57U4MS97KGM37EHHNDOhZmDtwpIr
	 9i8Rjx9vQzuGQ==
From: Song Liu <song@kernel.org>
To: live-patching@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org
Cc: jpoimboe@kernel.org,
	jikos@kernel.org,
	mbenes@suse.cz,
	pmladek@suse.com,
	joe.lawrence@redhat.com,
	nathan@kernel.org,
	morbo@google.com,
	justinstitt@google.com,
	mcgrof@kernel.org,
	thunder.leizhen@huawei.com,
	kees@kernel.org,
	kernel-team@meta.com,
	song@kernel.org,
	mmaurer@google.com,
	samitolvanen@google.com,
	mhiramat@kernel.org,
	rostedt@goodmis.org
Subject: [PATCH 0/3] Fix kallsyms with CONFIG_LTO_CLANG
Date: Mon, 29 Jul 2024 17:54:30 -0700
Message-ID: <20240730005433.3559731-1-song@kernel.org>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

With CONFIG_LTO_CLANG, the compiler/linker adds .llvm.<hash> suffix to
local symbols to avoid duplications. Existing scripts/kallsyms sorts
symbols without .llvm.<hash> suffix. However, this causes quite some
issues later on. Some users of kallsyms, such as livepatch, have to match
symbols exactly; while other users, such as kprobe, would match symbols
without the suffix.

Address this by sorting full symbols (with .llvm.<hash>) at build time, and
split kallsyms APIs to explicitly match full symbols or without suffix.
Specifically, exiting APIs will match symbols exactly. Two new APIs are
added to match symbols with suffix. Use the new APIs in tracing/kprobes.

Song Liu (3):
  kallsyms: Do not cleanup .llvm.<hash> suffix before sorting symbols
  kallsyms: Add APIs to match symbol without .llmv.<hash> suffix.
  tracing/kprobes: Use APIs that matches symbols with .llvm.<hash>
    suffix

 include/linux/kallsyms.h    | 14 +++++++
 kernel/kallsyms.c           | 83 ++++++++++++++++++++++++++-----------
 kernel/kallsyms_selftest.c  | 22 +---------
 kernel/trace/trace_kprobe.c | 10 ++++-
 scripts/kallsyms.c          | 30 +-------------
 scripts/link-vmlinux.sh     |  4 --
 6 files changed, 83 insertions(+), 80 deletions(-)

--
2.43.0

