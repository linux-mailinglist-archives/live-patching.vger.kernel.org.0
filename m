Return-Path: <live-patching+bounces-432-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2943F9464D0
	for <lists+live-patching@lfdr.de>; Fri,  2 Aug 2024 23:08:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D9E1F283280
	for <lists+live-patching@lfdr.de>; Fri,  2 Aug 2024 21:08:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3106061FF0;
	Fri,  2 Aug 2024 21:08:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ejuWtFmV"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01319219FC;
	Fri,  2 Aug 2024 21:08:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722632929; cv=none; b=HnyZlCMUBCnpHpkzEiwIA5u87Hb+wPa25kAS9Wdr0HyNYiuXLAExhh5C5DY4JypcV+jCWupkACCNLgYft4SWOuuqvpMmIAPTyotaw4uHCQtEXn/ceHkme0i/sETxVXiS4C2tC9KH4Z0UKZTccdUEQRO0MDWNm4V9HcRXaW71vT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722632929; c=relaxed/simple;
	bh=rKeew/LVSi1nYEKIe21+NRX/sk9+UYPtQUpEfCVuEPg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=rFJ0tivHZNmNq766XrIVI+IECeByGbh0ReaNba/1iB471ZOpdj1BZv11kpzGMPIoN6N1DgjLeMLznEKZKEdJ+I0kLSkQeurWnOAOzC14cW3FOc1+7kbGf/Mt9wKhPmeFbioTUeUspvUt9Wt/gyHqTOepflqcQGPiI8hOLBIzuEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ejuWtFmV; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F7F6C32782;
	Fri,  2 Aug 2024 21:08:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722632928;
	bh=rKeew/LVSi1nYEKIe21+NRX/sk9+UYPtQUpEfCVuEPg=;
	h=From:To:Cc:Subject:Date:From;
	b=ejuWtFmViglvHp19JdY95N2VMi9snvGFQ1AMA+7hpqmkJtRSteHNGP8m/oA6sGaQH
	 iDQXE+8kJtXgcBtEvT+cdRJBmkQCsOGif+h7evRVZNEovATezJ1UKrVJLMlH+qrN1x
	 bbISSR71U+c8SQKTLR5srppvUJSrDWFo9Bkr/gMZqKunZr48XVeeGmKgEUeYRoOPmU
	 TtQXAxblogXGTNJZy+0NGJnORLZEgCJJNCj3wNC1uI/qbpwfP2IIMDIyHkp7lNa9K7
	 Nq3m6ud7ZfpiJx68/eCAN/iy3fqdIMjgcZTLcZKKo8UDT1a3MtbPu8Oco2n3XQCaHP
	 Jb5fOPACBnESQ==
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
Subject: [PATCH v2 0/3] Fix kallsyms with CONFIG_LTO_CLANG
Date: Fri,  2 Aug 2024 14:08:32 -0700
Message-ID: <20240802210836.2210140-1-song@kernel.org>
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

Address this by sorting full symbols at build time, and split kallsyms
APIs to explicitly match full symbols or without suffix. Specifically,
exiting APIs will match symbols exactly. Two new APIs are added to match
symbols with suffix. Use the new APIs in tracing/kprobes.


Changes v1 => v2:
1. Update the APIs to remove all .XXX suffixes (v1 only removes .llvm.*).
2. Rename the APIs as *_without_suffix. (Masami Hiramatsu)
3. Fix another user from kprobe. (Masami Hiramatsu)
4. Add tests for the new APIs in kallsyms_selftests.

v1: https://lore.kernel.org/live-patching/20240730005433.3559731-1-song@kernel.org/T/#u

Song Liu (3):
  kallsyms: Do not cleanup .llvm.<hash> suffix before sorting symbols
  kallsyms: Add APIs to match symbol without .XXXX suffix.
  tracing/kprobes: Use APIs that matches symbols without .XXX suffix

 include/linux/kallsyms.h    | 14 ++++++
 kernel/kallsyms.c           | 88 +++++++++++++++++++++++++------------
 kernel/kallsyms_selftest.c  | 75 ++++++++++++++++++++++---------
 kernel/kprobes.c            |  6 ++-
 kernel/trace/trace_kprobe.c | 11 ++++-
 scripts/kallsyms.c          | 31 +------------
 scripts/link-vmlinux.sh     |  4 --
 7 files changed, 145 insertions(+), 84 deletions(-)

--
2.43.0

