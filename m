Return-Path: <live-patching+bounces-2053-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id UDmwJTuNl2lv0QIAu9opvQ
	(envelope-from <live-patching+bounces-2053-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Thu, 19 Feb 2026 23:22:51 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id AEAF81631FB
	for <lists+live-patching@lfdr.de>; Thu, 19 Feb 2026 23:22:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 1409F3006D66
	for <lists+live-patching@lfdr.de>; Thu, 19 Feb 2026 22:22:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B95032ABD0;
	Thu, 19 Feb 2026 22:22:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sw7eC8IT"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58865325729
	for <live-patching@vger.kernel.org>; Thu, 19 Feb 2026 22:22:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771539765; cv=none; b=WXqY2y616+Rnv6OXxfJms99IhLSTmy3CJa8tBk5Eh5E+/p70n7a+sp6aFtvss/yC6kmaClSHssElDJy/mOnvEAo9Ca0dOM1ivYmIy6gtrOxNzcr6UNuE1PaPHCM2Ts9CqvygWDB/XVUkYuyKa+pCjDH8EqRzEAccJ2qIT83Mx3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771539765; c=relaxed/simple;
	bh=0KeAxTHTCFwWfpk5LGrxeawPKwOXim77xDDaf9afRVs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=pAQmipYaeM1QDXDbFIH8FtP3z451xL4F0XlmxhnQm87IbYf2eZGE0lpd5rYtjyOMq0zQsoUYzO5v2THL4bcSvKIYqjCTtPDtzSvbF+4fP9hiHfWbJFFTiFAK3obOkvWEV6tqdNzpctoN1384RBvqsqtFlUmYR70de6rEtjF271Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sw7eC8IT; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1C57C4CEF7;
	Thu, 19 Feb 2026 22:22:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771539765;
	bh=0KeAxTHTCFwWfpk5LGrxeawPKwOXim77xDDaf9afRVs=;
	h=From:To:Cc:Subject:Date:From;
	b=sw7eC8IT7DDkXIU+XDw38uTS4Pur0PkQ3+4ARnUI+Ad1fkmwz/bE/DPxohvotJAdD
	 OPEQZ60XXTbCKvXj8K+eWT6AtHwiq86xHkMiWLE1Xjzih91zPalySNzKNdZcyVy0VH
	 pm5qhR5gqtSX/lxuYO7uVsweS7dr9CKezjucbsQQ/WQ9EjsfpgStTk1FmuF+i+ql7q
	 0L5P153SpA61g0jmr6w3GiGm77i9bj4Q1nZeW2MSWUBm/jzEMldU8wLI0xA+6l2U8s
	 fc6Dw1QKqNAL3ggpgSsB2Fe06znmyKpzFFImmHcMcfSmAMYlReC97l1azZGqc3FYjr
	 T5A97kP+UPwfA==
From: Song Liu <song@kernel.org>
To: live-patching@vger.kernel.org
Cc: jpoimboe@kernel.org,
	jikos@kernel.org,
	mbenes@suse.cz,
	pmladek@suse.com,
	joe.lawrence@redhat.com,
	kernel-team@meta.com,
	Song Liu <song@kernel.org>
Subject: [PATCH v2 0/8] objtool/klp: klp-build LTO support and tests
Date: Thu, 19 Feb 2026 14:22:31 -0800
Message-ID: <20260219222239.3650400-1-song@kernel.org>
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
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2053-lists,live-patching=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: AEAF81631FB
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
 tools/objtool/klp-diff.c                      |  92 +++++++++++-
 .../selftests/livepatch/test_patches/README   |  15 ++
 .../test_patches/klp_test_hash_change.patch   |  30 ++++
 .../test_patches/klp_test_module.patch        |  18 +++
 .../klp_test_nonstatic_to_static.patch        |  40 +++++
 .../klp_test_static_to_nonstatic.patch        |  39 +++++
 .../test_patches/klp_test_vmlinux.patch       |  18 +++
 17 files changed, 688 insertions(+), 22 deletions(-)
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

