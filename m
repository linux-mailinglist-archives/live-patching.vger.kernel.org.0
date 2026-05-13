Return-Path: <live-patching+bounces-2751-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id Q8vuBUrxA2prBAIAu9opvQ
	(envelope-from <live-patching+bounces-2751-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Wed, 13 May 2026 05:34:34 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 6156552CC56
	for <lists+live-patching@lfdr.de>; Wed, 13 May 2026 05:34:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 9338E305A8B9
	for <lists+live-patching@lfdr.de>; Wed, 13 May 2026 03:34:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E6340364032;
	Wed, 13 May 2026 03:34:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tqGuPuh2"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C373E13C9C4;
	Wed, 13 May 2026 03:34:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778643270; cv=none; b=kUhwaaLs70weGMt2kJwVj9E0CRlHWi4j0NRCzhfre0kof41gssnVeHwkxtkWA6M9wGz/Pz7E/7ZjjprSBb6MoWbohIayY7Cu11QmjUpbtkwVzlSdNjEwAkhpPL9Mf6YQhnESuqI11D8Dkhswyi9iYADvGd3WDGRNMuVC/81hevo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778643270; c=relaxed/simple;
	bh=3oqfclx78zKWNl/PM+bomMzSvStvzcGz0lbbX8cPMeE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=mzQQxMA/QiL4JpxtyVgruzsgxI52vk3gBDHXu+0PCT6y0D5v0mQ3oXWaTDhp39HW0HL1lHg7/aCrBqcovE8fNQS7/ic/ssHB9RprOKIr1qadwPAqnQl6TZbPZvb+pwfxGhoaf0xh6orEaZK1NuaSraLomMVd5OT60r2u/R2e344=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tqGuPuh2; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E07F5C2BCC7;
	Wed, 13 May 2026 03:34:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778643270;
	bh=3oqfclx78zKWNl/PM+bomMzSvStvzcGz0lbbX8cPMeE=;
	h=From:To:Cc:Subject:Date:From;
	b=tqGuPuh2s9Yuad2jAFCuchftjpS/NeJlQ3UArT0ujCd4EvuVE9a7MyLMtR9ZM3WEf
	 IwxWJgdjuABmwEjiT/wxwtY4HHpQ1LHLwY0IkgYwvIxfwjw/Uo7keM90Esdn3Hnm0m
	 ImSiR/QXRbFZHeBI8QwKaxH2QzONBFSuyj5aOFEqiJanktyPDe5jgsJu4a+Pa4CYf8
	 DbmR53T0vpceirjX8UUiCR1zYmh0U5kKyayBoNXrBIgVGb3Jk59+h1c157om2vRcpX
	 RD7tcNAXdbrJO7qTWXdbXm1DvN3awXJkElwGBpNvRjhZlcRfBxjCt/TAvfgoBbxEjV
	 Czs6+9J/Avhqg==
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org,
	live-patching@vger.kernel.org,
	Peter Zijlstra <peterz@infradead.org>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	Song Liu <song@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	Mark Rutland <mark.rutland@arm.com>,
	Miroslav Benes <mbenes@suse.cz>,
	Petr Mladek <pmladek@suse.com>
Subject: [PATCH v3 00/21] objtool/arm64: Port klp-build to arm64
Date: Tue, 12 May 2026 20:33:34 -0700
Message-ID: <cover.1778642120.git.jpoimboe@kernel.org>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 6156552CC56
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2751-lists,live-patching=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[12];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jpoimboe@kernel.org,live-patching@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Action: no action

Based on tip/objtool/core.

v3:
- Too many changes to list.  Did a lot of testing and fixed a bunch of
  issues (many of which have already been merged in tip/objtool/core).

v2: https://lore.kernel.org/cover.1773787568.git.jpoimboe@kernel.org
- patches 1-2 were merged, rebase on tip/master
- improve commit message for "objtool: Extricate checksum calculation from validate_branch()"
- add review tags

v1: https://lore.kernel.org/cover.1772681234.git.jpoimboe@kernel.org

Port objtool and the klp-build tooling (for building livepatch modules)
to arm64.

Note this doesn't bring all the objtool bells and whistles to arm64, nor
any of the CFG reverse engineering.  This only adds the bare minimum
needed for 'objtool --checksum'.

And note that objtool still doesn't get enabled at all for normal arm64
kernel builds, so this doesn't affect any users other than those running
klp-build directly.


Josh Poimboeuf (21):
  klp-build: Reject patches to init/*.c
  arm64: Annotate intra-function calls
  arm64: Fix EFI linking with -fdata-sections
  arm64: Rename TRAMP_VALIAS -> TRAMP_VALIAS_ASM in asm-offsets
  arm64: vdso: Discard .discard.* sections
  arm64: Annotate special section entries
  crypto: arm64: Move data to .rodata
  objtool: Allow setting --mnop without --mcount
  kbuild: Only run objtool if there is at least one command
  objtool: Ignore jumps to the end of the function for checksum runs
  objtool: Allow empty alternatives
  objtool: Refactor elf_add_data() to use a growable data buffer
  objtool: Reuse string references
  objtool: Prevent kCFI hashes from being decoded as instructions
  objtool/klp: Add arm64 support for prefix/PFE detection
  objtool/klp: Filter arm64 mapping symbols in find_symbol_by_offset()
  objtool/klp: Don't correlate arm64 mapping symbols
  objtool/klp: Clone inline alternative replacements
  objtool/klp: Introduce objtool for arm64
  klp-build: Support cross-compilation
  klp-build: Add arm64 syscall patching macro

 arch/arm64/Kconfig                            |   2 +
 arch/arm64/include/asm/alternative-macros.h   |  27 +-
 arch/arm64/include/asm/asm-bug.h              |   2 +
 arch/arm64/include/asm/asm-extable.h          |  21 +-
 arch/arm64/include/asm/jump_label.h           |   2 +
 arch/arm64/kernel/asm-offsets.c               |   7 +-
 arch/arm64/kernel/entry.S                     |  10 +-
 arch/arm64/kernel/proton-pack.c               |  12 +-
 arch/arm64/kernel/vdso/vdso.lds.S             |   1 +
 arch/arm64/kernel/vmlinux.lds.S               |   2 +-
 arch/x86/boot/startup/Makefile                |   2 +-
 include/linux/annotate.h                      |  14 +-
 include/linux/livepatch_helpers.h             |  19 ++
 include/linux/objtool_types.h                 |   1 +
 lib/crypto/arm64/sha2-armv8.pl                |  18 +-
 scripts/Makefile.build                        |   4 +-
 scripts/Makefile.lib                          |  52 ++--
 scripts/Makefile.vmlinux_o                    |  15 +-
 scripts/livepatch/klp-build                   |  24 +-
 tools/include/linux/objtool_types.h           |   1 +
 tools/objtool/Makefile                        |   4 +
 tools/objtool/arch/arm64/Build                |   2 +
 tools/objtool/arch/arm64/decode.c             | 177 +++++++++++++
 .../arch/arm64/include/arch/cfi_regs.h        |  11 +
 tools/objtool/arch/arm64/include/arch/elf.h   |  15 ++
 .../objtool/arch/arm64/include/arch/special.h |  21 ++
 tools/objtool/arch/arm64/special.c            |  21 ++
 tools/objtool/arch/x86/include/arch/elf.h     |   2 +
 tools/objtool/builtin-check.c                 |   5 -
 tools/objtool/check.c                         |  65 +++--
 tools/objtool/elf.c                           | 170 +++++++------
 tools/objtool/include/objtool/elf.h           |  48 +++-
 tools/objtool/klp-diff.c                      | 237 ++++++++++++++++--
 33 files changed, 819 insertions(+), 195 deletions(-)
 create mode 100644 tools/objtool/arch/arm64/Build
 create mode 100644 tools/objtool/arch/arm64/decode.c
 create mode 100644 tools/objtool/arch/arm64/include/arch/cfi_regs.h
 create mode 100644 tools/objtool/arch/arm64/include/arch/elf.h
 create mode 100644 tools/objtool/arch/arm64/include/arch/special.h
 create mode 100644 tools/objtool/arch/arm64/special.c

-- 
2.53.0


