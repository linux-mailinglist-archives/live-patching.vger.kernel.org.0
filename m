Return-Path: <live-patching+bounces-2618-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 2FK0OVUn9GkH+wEAu9opvQ
	(envelope-from <live-patching+bounces-2618-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Fri, 01 May 2026 06:08:53 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 4A0FB4AA09C
	for <lists+live-patching@lfdr.de>; Fri, 01 May 2026 06:08:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id E1844301494D
	for <lists+live-patching@lfdr.de>; Fri,  1 May 2026 04:08:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D37222BEC5E;
	Fri,  1 May 2026 04:08:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TMjOyVYu"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B055D28B7DB;
	Fri,  1 May 2026 04:08:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777608530; cv=none; b=angDoTKE+paJdUMKVW8qcGP9ozpGqKwDhElMY8jn5rCk7kSaLtr4Rp80S173irzg+dS19nu8XzeCieH8bC4cioct+sHKIbwOQ659YOLYYa+go9H/vk8diXGovDvg+DamCfmrGl9X+BEkZ42It2ALvdGHrhZT9GZwQj8pxZKgR+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777608530; c=relaxed/simple;
	bh=zVKGX0mefaERc04tRYSdxjV9XlZK734ckhmh1gMG2YA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=B3rYOWaIgLQGKS6+OsEc0m9Ur1QxWz/jJpLYP0L9oUpYZ8bL4km8MvDacKhkaEKgIRza8iywI1AX0yYA+sZH6GFoXGnBi4qA7cLOwYzEYywF2RarTDxKNnlWA6ORd1LmjvfcDAczGHHxHDBJxh0GegjZwfKwx8vWYvBiGBx9gwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TMjOyVYu; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09ACBC2BCB7;
	Fri,  1 May 2026 04:08:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777608530;
	bh=zVKGX0mefaERc04tRYSdxjV9XlZK734ckhmh1gMG2YA=;
	h=From:To:Cc:Subject:Date:From;
	b=TMjOyVYuRQQDQ2oqv2xFEwm65uUuny9C/qH0i4J98FuWyFsFfcdPA/3IfWwZN896b
	 19WKv+wtOiBY4o+Ibf1ETU04zwIVGTiDhbjq9r1paMWOUOBhBIYn8xKs33Fm0lsGJO
	 kJPJVKF0oLK48i0yvWSalfPkK2TaHbY5mpgRRB5rUhBiQupIUeNfdvrmV6ZEAtJTS8
	 nsL39Tv+NK/L2CB5jGl8t2mxb3ZrqoDgttiAPg2Ho3zn8DRD8Y5ruo/l02q21+3jMp
	 kY7Qr8FbXo6ZKwFEE8tXyFSz7KF/cPCFYvyGTdKE9D3rlZDTGHapNmrhHfW3M6YGPJ
	 uDX0HikJul2Jg==
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org,
	live-patching@vger.kernel.org,
	Peter Zijlstra <peterz@infradead.org>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	Song Liu <song@kernel.org>,
	Miroslav Benes <mbenes@suse.cz>,
	Petr Mladek <pmladek@suse.com>
Subject: [PATCH v2 00/53] objtool/klp: Some klp-build fixes and improvements
Date: Thu, 30 Apr 2026 21:07:48 -0700
Message-ID: <cover.1777575752.git.jpoimboe@kernel.org>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4A0FB4AA09C
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
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
	TAGGED_FROM(0.00)[bounces-2618-lists,live-patching=lfdr.de];
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

Changes since v1 (https://lore.kernel.org/cover.1776916871.git.jpoimboe@kernel.org):

- Add comment for find_reloc_by_dest_range() first-match behavior
  [Peter]
- Simplify is_cold_func() [Peter]
- Grow __cfi_ symbols [Peter]
- Rename "Ignore __UNIQUE_ID_*() PCI stub functions" to more general
  "Don't report uncorrelated functions as new" [Song]
- Move rodata non-correlation into pointer-comparison fix [Miroslav]
- Add comments for convert_reloc_sym() return values [Song]
- Remove redundant SRC/OBJ variables [Song]
- Use "if (mismatch) {} else" in for_each_sym_by_*() [Song]
- Flatten nested if-else chain in short-circuit validation [Song]
- Add comments with examples to symbol correlation algorithm [Song]
- Move callback refactor to earlier in the patch set [Miroslav]
- Fix reloc corruption in convert_reloc_sym_to_secsym() [Sashiko]
- Include offset in object checksum hashing [Sashiko]
- Fix klp-build checksum comparison output for added/removed
  instructions [Sashiko]
- Fix kCFI prefix finding/cloning
- Add reloc symbol conversion simplification cleanup
- Improve local label check for uncorrelated symbols
- Drop "Make function prefix handling more generic" for now (refactored
  version will come with arm64 patches)
- Refactor inline alternative cloning into separate
  clone_inline_alternatives()
- Add Acked-by/Reviewed-by tags

---

While working on the (upcoming) arm64 support, I ended up shaking out a
lot of bugs by tested several patches on a variety of configs (distro,
LTO, FineIBT, kCFI, etc).

While arm64 support seems to be working well, I decided to leave those
patches out of this set to try to keep the number of patches
"reasonable".

And these stand alone as nice improvements for x86 anyway.

Full arm64 support (this set + more) can be found here:

  git://git.kernel.org/pub/scm/linux/kernel/git/jpoimboe/linux.git klp-build-arm64

Joe Lawrence (2):
  objtool/klp: Fix is_uncorrelated_static_local() for Clang
  objtool/klp: Fix create_fake_symbols() skipping entsize-based sections

Josh Poimboeuf (51):
  objtool/klp: Fix .data..once static local non-correlation
  objtool/klp: Don't correlate __ADDRESSABLE() symbols
  objtool/klp: Don't correlate absolute symbols
  objtool/klp: Don't correlate __initstub__ symbols
  objtool/klp: Don't report uncorrelated functions as new
  objtool/klp: Improve local label check
  objtool: Replace iterator callback with for_each_sym_by_mangled_name()
  objtool/klp: Fix --debug-checksum for duplicate symbol names
  objtool/klp: Fix handling of zero-length .altinstr_replacement
    sections
  objtool/klp: Fix cloning of zero-length section symbols
  objtool/klp: Fix XXH3 state memory leak
  objtool/klp: Fix extraction of text annotations for alternatives
  objtool/klp: Fix kCFI trap handling
  objtool/klp: Fix relocation conversion failures for R_X86_64_NONE
  objtool: Move mark_rodata() to elf.c
  objtool/klp: Simplify reloc symbol conversion
  objtool/klp: Fix pointer comparisons for rodata objects
  objtool/klp: Don't correlate .rodata.cst* constant pool objects
  objtool/klp: Fix reloc corruption in convert_reloc_sym_to_secsym()
  objtool: Fix reloc hash collision in find_reloc_by_dest_range()
  klp-build: Fix hang on out-of-date .config
  klp-build: Fix checksum comparison for changed offsets
  klp-build: Don't use errexit
  klp-build: Validate patch file existence
  klp-build: Suppress excessive fuzz output by default
  klp-build: Fix patch cleanup on interrupt
  klp-build: Reject patches to vDSO
  klp-build: Reject patches to realmode
  klp-build: Print "objtool klp diff" command in verbose mode
  klp-build: Remove redundant SRC and OBJ variables
  objtool/klp: Don't set sym->file for section symbols
  objtool: Include libsubcmd headers directly from source tree
  objtool/klp: Create empty checksum sections for function-less object
    files
  objtool/klp: Handle Clang .data..Lanon anonymous data sections
  objtool: Add is_alias_sym() helper
  objtool: Add is_cold_func() helper
  objtool/klp: Extricate checksum calculation from validate_branch()
  objtool: Consolidate file decoding into decode_file()
  objtool/klp: Add "objtool klp checksum" subcommand
  klp-build: Use "objtool klp checksum" subcommand
  objtool/klp: Remove "objtool --checksum"
  klp-build: Validate short-circuit prerequisites
  objtool/klp: Calculate object checksums
  objtool/klp: Rewrite symbol correlation algorithm
  objtool/klp: Add correlation debugging output
  objtool: Add insn_sym() helper
  objtool/klp: Fix position-dependent checksums for non-relocated
    jumps/calls
  objtool: Grow __cfi_* prefix symbols for all CFI+CALL_PADDING
  objtool/klp: Fix kCFI prefix finding/cloning
  objtool: Improve and simplify prefix symbol detection
  objtool/klp: Cache dont_correlate() result

 arch/x86/Kconfig                         |   4 -
 lib/Kconfig.debug                        |   2 +-
 scripts/Makefile.lib                     |   7 +-
 scripts/livepatch/klp-build              | 250 ++++---
 tools/objtool/Build                      |   2 +-
 tools/objtool/Makefile                   |   4 +-
 tools/objtool/arch/x86/decode.c          |  17 +-
 tools/objtool/builtin-check.c            |  26 +-
 tools/objtool/builtin-klp.c              |   1 +
 tools/objtool/check.c                    | 412 ++++-------
 tools/objtool/disas.c                    |  22 +-
 tools/objtool/elf.c                      | 124 ++--
 tools/objtool/include/objtool/arch.h     |   3 +
 tools/objtool/include/objtool/builtin.h  |   7 +-
 tools/objtool/include/objtool/check.h    |  34 +-
 tools/objtool/include/objtool/checksum.h |  53 +-
 tools/objtool/include/objtool/elf.h      |  59 +-
 tools/objtool/include/objtool/klp.h      |   1 +
 tools/objtool/include/objtool/warn.h     |  57 +-
 tools/objtool/klp-checksum.c             | 347 ++++++++++
 tools/objtool/klp-diff.c                 | 826 ++++++++++++++++-------
 tools/objtool/objtool.c                  |   3 -
 tools/objtool/trace.c                    |   8 +-
 23 files changed, 1493 insertions(+), 776 deletions(-)
 create mode 100644 tools/objtool/klp-checksum.c

-- 
2.53.0


