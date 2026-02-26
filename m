Return-Path: <live-patching+bounces-2080-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id gHkKFeiZn2mucwQAu9opvQ
	(envelope-from <live-patching+bounces-2080-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Thu, 26 Feb 2026 01:55:04 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id C916519FA66
	for <lists+live-patching@lfdr.de>; Thu, 26 Feb 2026 01:55:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 74F7A30398B9
	for <lists+live-patching@lfdr.de>; Thu, 26 Feb 2026 00:54:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 15EE8433AD;
	Thu, 26 Feb 2026 00:54:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="T4VJc5FN"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E74A14A21
	for <live-patching@vger.kernel.org>; Thu, 26 Feb 2026 00:54:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772067282; cv=none; b=syWfMxdYLMLEcVbeZFdDnOUebkTKJQhbG0DLpvx0/1B+Vrr830l8zzvuqncesB9lzOFF17/knP7FmZrD7Q7Rr/2DFYQkZSdi9tL2NnKSoxG0ZosE8Ycin+7tvGzDvGBxczhT6MQUseA7D5Xsk6DoHb0ATmBuHbFHszmHiRVdsRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772067282; c=relaxed/simple;
	bh=VNrmhyZBONvzlqVt6I/wF+fc9HywxKsoAHrJWJ+n1Xw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=P84ZRXGLNSsLPtx5QAXaA4eBCznc4D1rOnaGvGN0Bci/Es/fcw0ADftNIPX1HMA9AbP2s09N5ul3SxiR1ulzGYqBPqaKdOpSoKzkaWadu1Pu/8OAMRrN32fgFiI1T1pAtMrIUnGkIxG26BEVFOXQ+2rrHCeV8E92QWWo0S2yVnM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=T4VJc5FN; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 705CEC116D0;
	Thu, 26 Feb 2026 00:54:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772067281;
	bh=VNrmhyZBONvzlqVt6I/wF+fc9HywxKsoAHrJWJ+n1Xw=;
	h=From:To:Cc:Subject:Date:From;
	b=T4VJc5FNTYR/Zm7jLyKCvvFYKEFKhfmEiGWuKSIJwPjsWGXvXWbLwBS9BiEpiJUtS
	 APFs2zIVTA9RtC6JPXSvW3i7JE57tRbCpMGHSDFGJDKomc/4L2CGBDdfffNt5ULVx5
	 NVfYaPcUf1cNkROwCzJNXatftRMzyfFgerIQSAfAZDWMmZlBZKHEDj1Rj06dWcoNAN
	 oaXgfNIOrDyABGzOuZ9HN2Rx9UYA3kmfZ4R4aMdh/YzeYq7dD1dZEW62wLRXejbYKT
	 6WoMxl9Ve9hMiAyx+kAvHL8v7aCOH7ePAxDORACZkGd0gVdZfBQ1oi77HMd4I4TDlQ
	 gu5d2Rhy4RLOA==
From: Song Liu <song@kernel.org>
To: live-patching@vger.kernel.org
Cc: jpoimboe@kernel.org,
	jikos@kernel.org,
	mbenes@suse.cz,
	pmladek@suse.com,
	joe.lawrence@redhat.com,
	kernel-team@meta.com,
	Song Liu <song@kernel.org>
Subject: [PATCH v3 0/8] objtool/klp: klp-build LTO support and tests
Date: Wed, 25 Feb 2026 16:54:28 -0800
Message-ID: <20260226005436.379303-1-song@kernel.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2080-lists,live-patching=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_NEQ_ENVFROM(0.00)[song@kernel.org,live-patching@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[8];
	NEURAL_HAM(-0.00)[-1.000];
	DKIM_TRACE(0.00)[kernel.org:+];
	TAGGED_RCPT(0.00)[live-patching];
	TO_DN_SOME(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: C916519FA66
X-Rspamd-Action: no action

Add support for LTO in klp-build toolchain. The key changes are to the
symbol correlation logic.Basically, we want to:

1. Match symbols with differerent .llvm.<hash> suffixes, e.g., foo.llvm.123
   to foo.llvm.456.
2. Match local symbols with promoted global symbols, e.g., local foo
   with global foo.llvm.123.

1/8 and 2/8 are small cleanup/fix for existing code.
3/8 through 7/8 contains the core logic changes to correlate_symbols().
8/8 contains tests for klp-build toolchain.

Changes v2 => v3:
1. Fix a bug in global => local correlations (patch 7/8).
2. Remove a WARN().
3. Some empty line changes.

Changes v1 => v2:
1. Error out on ambiguous .llvm.<hash>

Song Liu (8):
  objtool/klp: Remove redundent strcmp in correlate_symbols
  objtool/klp: Remove trailing '_' in demangle_name()
  objtool/klp: Use sym->demangled_name for symbol_name hash
  objtool/klp: Also demangle global objects
  objtool/klp: Remove .llvm suffix in demangle_name()
  objtool/klp: Match symbols based on demangled_name for global
    variables
  objtool/klp: Correlate locals to globals
  livepatch: Add tests for klp-build toolchain

 kernel/livepatch/Kconfig                      |  20 +++
 kernel/livepatch/Makefile                     |   2 +
 kernel/livepatch/tests/Makefile               |   6 +
 kernel/livepatch/tests/klp_test_module.c      | 111 ++++++++++++++
 kernel/livepatch/tests/klp_test_module.h      |   8 +
 kernel/livepatch/tests/klp_test_vmlinux.c     | 138 ++++++++++++++++++
 kernel/livepatch/tests/klp_test_vmlinux.h     |  16 ++
 kernel/livepatch/tests/klp_test_vmlinux_aux.c |  59 ++++++++
 tools/objtool/elf.c                           |  95 +++++++++---
 tools/objtool/include/objtool/elf.h           |   3 +
 tools/objtool/klp-diff.c                      |  93 +++++++++++-
 .../selftests/livepatch/test_patches/README   |  15 ++
 .../test_patches/klp_test_hash_change.patch   |  30 ++++
 .../test_patches/klp_test_module.patch        |  18 +++
 .../klp_test_nonstatic_to_static.patch        |  40 +++++
 .../klp_test_static_to_nonstatic.patch        |  39 +++++
 .../test_patches/klp_test_vmlinux.patch       |  18 +++
 17 files changed, 689 insertions(+), 22 deletions(-)
 create mode 100644 kernel/livepatch/tests/Makefile
 create mode 100644 kernel/livepatch/tests/klp_test_module.c
 create mode 100644 kernel/livepatch/tests/klp_test_module.h
 create mode 100644 kernel/livepatch/tests/klp_test_vmlinux.c
 create mode 100644 kernel/livepatch/tests/klp_test_vmlinux.h
 create mode 100644 kernel/livepatch/tests/klp_test_vmlinux_aux.c
 create mode 100644 tools/testing/selftests/livepatch/test_patches/README
 create mode 100644 tools/testing/selftests/livepatch/test_patches/klp_test_hash_change.patch
 create mode 100644 tools/testing/selftests/livepatch/test_patches/klp_test_module.patch
 create mode 100644 tools/testing/selftests/livepatch/test_patches/klp_test_nonstatic_to_static.patch
 create mode 100644 tools/testing/selftests/livepatch/test_patches/klp_test_static_to_nonstatic.patch
 create mode 100644 tools/testing/selftests/livepatch/test_patches/klp_test_vmlinux.patch

--
2.47.3

