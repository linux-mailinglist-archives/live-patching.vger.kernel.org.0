Return-Path: <live-patching+bounces-2006-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id oHviAXAojmkMAQEAu9opvQ
	(envelope-from <live-patching+bounces-2006-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Thu, 12 Feb 2026 20:22:24 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 47BBF130A98
	for <lists+live-patching@lfdr.de>; Thu, 12 Feb 2026 20:22:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 21592300B53F
	for <lists+live-patching@lfdr.de>; Thu, 12 Feb 2026 19:22:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC8E721FF3F;
	Thu, 12 Feb 2026 19:22:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HMmEsmBG"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88CC026ACC
	for <live-patching@vger.kernel.org>; Thu, 12 Feb 2026 19:22:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770924138; cv=none; b=uEAu01Kv4KibZntYNJHWB02XZkTREFAsQW6LE3K44Knp7iyE5oDRF5VBNxCTIcL0je/N8xxWZ4mX7MnC9etxTpxP41tTlkEtmYXuB1XWc4dt5QfZC7HURCpPfhmT0xfyYZsmJSMVH4GRSwtAjr8OUv+PMt+9akEsntoh39KLVP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770924138; c=relaxed/simple;
	bh=uHUQ3bFDBWs/nPDRrsm4zZkuoC4J/UpJMmYx7WSRf8g=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=mNmqLOkJW0WTflmkrGpuqHmInZ5H7qZJfoXSgY4oAD17q3v5I8/EgLsw1H/HPtl4PpIMVJISvxPIoO7sO25S9Ts9NE2QPvrBKvBmEkOz/d1ke1MrEBnxyFvNZSqkoB/0hRXGgCqn2Aib1XHRTeapnbMxFnN4gECH/ewqPNeLvXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HMmEsmBG; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC374C4CEF7;
	Thu, 12 Feb 2026 19:22:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770924138;
	bh=uHUQ3bFDBWs/nPDRrsm4zZkuoC4J/UpJMmYx7WSRf8g=;
	h=From:To:Cc:Subject:Date:From;
	b=HMmEsmBGmhj99e3GA7BG5UsXAj4BdMYI3TLVTzMjtiCoQOVbLE8W8VJvW3Jp6pQcz
	 KCrV0mtg1xKk7BtwWT3HOSNoSVkruMW8n9OO9P5VeDGoOov8fsiNbm84e1A+bvMi+C
	 uoLSb16zHY5y09sqBkGkIJ1ntM8JfWW5pGQ3Gmfm5pCvesnDUPvBluuFKW72JRzYyy
	 DP//7JCJXnUZ9o9NEDsOS5Or8DFCEQdvtKepL+DCqRieUKUwEff3M4lvoq5PZ+f1qF
	 5GiuohM7kmOEV3HkR24wCk6VCLvOp1yLZc+dCimWk9cxIiARJnIYFMWkBlGnvMiyw9
	 GAVKaouWVND8w==
From: Song Liu <song@kernel.org>
To: live-patching@vger.kernel.org
Cc: jpoimboe@kernel.org,
	jikos@kernel.org,
	mbenes@suse.cz,
	pmladek@suse.com,
	joe.lawrence@redhat.com,
	kernel-team@meta.com,
	Song Liu <song@kernel.org>
Subject: [PATCH 0/8] objtool/klp: klp-build LTO support and tests
Date: Thu, 12 Feb 2026 11:21:53 -0800
Message-ID: <20260212192201.3593879-1-song@kernel.org>
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
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-2006-lists,live-patching=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	DKIM_TRACE(0.00)[kernel.org:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[song@kernel.org,live-patching@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	RCPT_COUNT_SEVEN(0.00)[8];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 47BBF130A98
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
 scripts/setlocalversion                       |   9 ++
 tools/objtool/elf.c                           |  95 +++++++++---
 tools/objtool/include/objtool/elf.h           |   2 +
 tools/objtool/klp-diff.c                      |  59 +++++++-
 .../selftests/livepatch/test_patches/README   |  15 ++
 .../test_patches/klp_test_hash_change.patch   |  30 ++++
 .../test_patches/klp_test_module.patch        |  18 +++
 .../klp_test_nonstatic_to_static.patch        |  40 +++++
 .../klp_test_static_to_nonstatic.patch        |  39 +++++
 .../test_patches/klp_test_vmlinux.patch       |  18 +++
 18 files changed, 663 insertions(+), 22 deletions(-)
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

