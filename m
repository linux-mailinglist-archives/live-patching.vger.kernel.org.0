Return-Path: <live-patching+bounces-2427-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id kN8mGTad6Wm3ewIAu9opvQ
	(envelope-from <live-patching+bounces-2427-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Thu, 23 Apr 2026 06:16:54 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 035FB44CDC6
	for <lists+live-patching@lfdr.de>; Thu, 23 Apr 2026 06:16:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id E448A303829D
	for <lists+live-patching@lfdr.de>; Thu, 23 Apr 2026 04:04:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2DCEF34E763;
	Thu, 23 Apr 2026 04:04:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FsC7GsKl"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A59533C50D;
	Thu, 23 Apr 2026 04:04:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776917064; cv=none; b=nDR8JcMjrMqMz9sGuwEYkaI7skry9gvryYxv4e22hhO31D/bYoK+Ye6/vsrSvVAaNgnYudd8PAz1xJJUYa0+JPyVxSkx5bV+HsjHAi5mlIf/uuJJMaWIhm+30lO6mzYm9/yuCRSpPystfbMn6VNEXRd+9/SuoSgn8wsA5cfuCqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776917064; c=relaxed/simple;
	bh=6PwMstg7W29VvMhac81st8EasMYKQtNfD6lNNNDT7GM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=dZvHz9Fg8T1f4P6+qTwQyDO9SkqblHvBQOXjZM70sBbZE4kl+14mea0Jf1wmhqmvAKKwW+ktNkBBxA7Xj1k7MWpl6gj1Hg36l0lFTxpU3fKbxuK+JcTs14FnKrWXWPeWZUfXwvK0DJczAcfc4BDtAozegK7+MHiSWOwmBJVuwhk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FsC7GsKl; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43EBBC2BCB2;
	Thu, 23 Apr 2026 04:04:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776917063;
	bh=6PwMstg7W29VvMhac81st8EasMYKQtNfD6lNNNDT7GM=;
	h=From:To:Cc:Subject:Date:From;
	b=FsC7GsKlJnlYbjYGVTUUSp0bgvt37dIxCeFGghvzA01cgbgR+Rrw5s2k4+mEQJ+Nx
	 1bB36FDprnWHM4Qs2y2v5JAAaPG49wA2vg/OJ8vUARb56k6PZQIjcNxDOdCDiZbv3p
	 4Wl4FhTCwwM1htwl/NVicNxAKljzc47yDy4zgk8OAcvYfdsPlneGHe31oepdpwje8C
	 aK688kQHyA6eJK23ORdQH+gqyjJ0I/wh+qe24fepIFz1JlrkTKSmvAARMf3AzBSYM5
	 v3QGawGVFZlcYb0oSVg4scxiGbxONBmWQdzM12PXHgIStP0RT8AVRCjFSWfS3MO2ko
	 pAnV6GiRsZ4oQ==
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org,
	live-patching@vger.kernel.org,
	Peter Zijlstra <peterz@infradead.org>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	Song Liu <song@kernel.org>,
	Miroslav Benes <mbenes@suse.cz>,
	Petr Mladek <pmladek@suse.com>
Subject: [PATCH 00/48] objtool/klp: Some klp-build fixes and improvements
Date: Wed, 22 Apr 2026 21:03:28 -0700
Message-ID: <cover.1776916871.git.jpoimboe@kernel.org>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2427-lists,live-patching=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_NEQ_ENVFROM(0.00)[jpoimboe@kernel.org,live-patching@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[8];
	NEURAL_HAM(-0.00)[-1.000];
	DKIM_TRACE(0.00)[kernel.org:+];
	TAGGED_RCPT(0.00)[live-patching];
	TO_DN_SOME(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 035FB44CDC6
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

While working on the (upcoming) arm64 support, I ended up shaking out a
lot of bugs by tested several patches on a variety of configs (distro,
LTO, FineIBT, kCFI, etc).

While arm64 support seems to be working well, I decided to leave those
patches out of this set to try to keep the number of patches
"reasonable".

And these stand alone as nice improvements for x86 anyway.

Full arm64 support (this set + 19 more) can be found here:

  git://git.kernel.org/pub/scm/linux/kernel/git/jpoimboe/linux.git klp-build-arm64


Joe Lawrence (2):
  objtool/klp: Fix is_uncorrelated_static_local() for Clang
  objtool/klp: Fix create_fake_symbols() skipping entsize-based sections

Josh Poimboeuf (46):
  objtool/klp: Fix .data..once static local non-correlation
  objtool/klp: Don't correlate __ADDRESSABLE() symbols
  objtool/klp: Ignore __UNIQUE_ID_*() PCI stub functions
  objtool: Move mark_rodata() to elf.c
  objtool/klp: Don't correlate rodata symbols
  objtool/klp: Don't correlate absolute symbols
  objtool/klp: Don't correlate __initstub__ symbols
  objtool/klp: Fix --debug-checksum for duplicate symbol names
  objtool/klp: Fix handling of zero-length .altinstr_replacement
    sections
  objtool/klp: Fix cloning of zero-length section symbols
  objtool/klp: Fix XXH3 state memory leak
  objtool/klp: Fix extraction of text annotations for alternatives
  objtool/klp: Fix kCFI trap handling
  objtool/klp: Fix relocation conversion failures for R_X86_64_NONE
  objtool: Fix reloc hash collision in find_reloc_by_dest_range()
  klp-build: Fix hang on out-of-date .config
  klp-build: Fix checksum comparison for changed offsets
  klp-build: Don't use errexit
  klp-build: Validate patch file existence
  klp-build: Suppress excessive fuzz output by default
  klp-build: Fix patch cleanup on interrupt
  klp-build: Reject patches to vDSO
  klp-build: Reject patches to realmode
  objtool/klp: Don't set sym->file for section symbols
  objtool: Include libsubcmd headers directly from source tree
  objtool/klp: Create empty checksum sections for function-less object
    files
  klp-build: Print "objtool klp diff" command in verbose mode
  objtool/klp: Handle Clang .data..Lanon anonymous data sections
  objtool: Add is_alias_sym() helper
  objtool: Add is_cold_func() helper
  objtool/klp: Extricate checksum calculation from validate_branch()
  objtool: Consolidate file decoding into decode_file()
  objtool/klp: Add "objtool klp checksum" subcommand
  klp-build: Use "objtool klp checksum" subcommand
  objtool/klp: Remove "objtool --checksum"
  klp-build: Validate short-circuit prerequisites
  objtool: Replace iterator callbacks with for_each_sym_by_*()
  objtool/klp: Calculate object checksums
  objtool/klp: Rewrite symbol correlation algorithm
  objtool/klp: Add correlation debugging output
  objtool: Add insn_sym() helper
  objtool/klp: Fix position-dependent checksums for non-relocated
    jumps/calls
  x86/Kconfig: Enable CONFIG_PREFIX_SYMBOLS for FineIBT
  objtool/klp: Make function prefix handling more generic
  objtool: Improve and simplify prefix symbol detection
  objtool/klp: Cache dont_correlate() result

 arch/x86/Kconfig                         |   2 +-
 scripts/livepatch/klp-build              | 183 +++--
 tools/objtool/Build                      |   2 +-
 tools/objtool/Makefile                   |   4 +-
 tools/objtool/arch/x86/decode.c          |  17 +-
 tools/objtool/builtin-check.c            |  17 +-
 tools/objtool/builtin-klp.c              |   1 +
 tools/objtool/check.c                    | 363 ++--------
 tools/objtool/disas.c                    |  22 +-
 tools/objtool/elf.c                      |  96 +--
 tools/objtool/include/objtool/arch.h     |   3 +
 tools/objtool/include/objtool/check.h    |  33 +-
 tools/objtool/include/objtool/checksum.h |  52 +-
 tools/objtool/include/objtool/elf.h      |  69 +-
 tools/objtool/include/objtool/klp.h      |   1 +
 tools/objtool/include/objtool/warn.h     |  57 +-
 tools/objtool/klp-checksum.c             | 346 +++++++++
 tools/objtool/klp-diff.c                 | 861 +++++++++++++++++------
 tools/objtool/objtool.c                  |   3 -
 tools/objtool/trace.c                    |   8 +-
 20 files changed, 1431 insertions(+), 709 deletions(-)
 create mode 100644 tools/objtool/klp-checksum.c

-- 
2.53.0


