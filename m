Return-Path: <live-patching+bounces-2108-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id IO23JiP5qGlzzwAAu9opvQ
	(envelope-from <live-patching+bounces-2108-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Thu, 05 Mar 2026 04:31:47 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 03CFA20A865
	for <lists+live-patching@lfdr.de>; Thu, 05 Mar 2026 04:31:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 97C393013695
	for <lists+live-patching@lfdr.de>; Thu,  5 Mar 2026 03:31:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD3574317D;
	Thu,  5 Mar 2026 03:31:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Gr4kCtCS"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A2FB611E;
	Thu,  5 Mar 2026 03:31:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772681504; cv=none; b=ttViLzZ4RymxUpuGxblWvXzuMXfE7VaDXRQ3GQpnWCWiEXyBQrNbT6ZHGyYUWezrbcibMHYhOzZWEjziCqLQlKH2VZ0onfnQfDWloTX6q0yhvN42ubUoW5b0397Y9Soz8s/CBPXxQmk3f0WdXOg6PRNtXkTQyKc6dHYITDNe3yQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772681504; c=relaxed/simple;
	bh=ro/DIlxvmAZpX3kL05CC6asOTt/nbWmxKieEfFF6Jno=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=F18otYNaZsCrUXRaTgGrnCAJYvC5JpeuY0vhuk3eaTEYSm15h5VmtzDMn5tuInxr1TUndTv46vhJTaOdahn2Ntt8tTp6OWzvLXWn6LHIcEQRz21KX2wWimufVLi+I6xw3JSYOtnHzQI6NVGnNetQGrwbnjbmPhCjuGSpCBe7sEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Gr4kCtCS; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A207C116C6;
	Thu,  5 Mar 2026 03:31:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772681504;
	bh=ro/DIlxvmAZpX3kL05CC6asOTt/nbWmxKieEfFF6Jno=;
	h=From:To:Cc:Subject:Date:From;
	b=Gr4kCtCSnoXpSxdWhju3ZGzveXqO8JrfmwZxP7hWWnWrsKn3sKFnpn0ozsVa5j7Mv
	 n7eDfX2NZ6hwHtoPeFza2t2N0Rfr9cjcMzsM/LsVmfO3LWQicqWhdJ4GkH1ixD/yqG
	 yYNxTkc6zsS5Jr153pHqBIiul464oxH1E1yavyMecZMx0gItf+flavin4tx/62j2RN
	 6Z59dvG//rr4lvRNqrhW/ldeu8eUWca7YLn11ZOMGNUBzLhBDvMlCSp/CkfngFz08e
	 pS9wRvqeBMgf8v4gLeik11Omig0Lj7V/jCsbD2w3wJ/vJe0t1e8NTKCy7miRZJ/yrA
	 fAIdeFZ6sBORw==
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
	Nathan Chancellor <nathan@kernel.org>,
	Nicolas Schier <nsc@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 00/14] objtool/arm64: Port klp-build to arm64
Date: Wed,  4 Mar 2026 19:31:19 -0800
Message-ID: <cover.1772681234.git.jpoimboe@kernel.org>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 03CFA20A865
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2108-lists,live-patching=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[13];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jpoimboe@kernel.org,live-patching@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Action: no action

Port objtool and the klp-build tooling (for building livepatch modules)
to arm64.

Note this doesn't bring all the objtool bells and whistles to arm64, nor
any of the CFG reverse engineering.  This only adds the bare minimum
needed for 'objtool --checksum'.

And note that objtool still doesn't get enabled at all for normal arm64
kernel builds, so this doesn't affect any users other than those running
klp-build directly.

Josh Poimboeuf (14):
  objtool: Fix data alignment in elf_add_data()
  objtool: Fix ERROR_INSN() error message
  arm64: Annotate intra-function calls
  arm64: head: Move boot header to .head.data
  arm64: Fix EFI linking with -fdata-sections
  crypto: arm64: Move data to .rodata
  objtool: Extricate checksum calculation from validate_branch()
  objtool: Allow setting --mnop without --mcount
  kbuild: Only run objtool if there is at least one command
  objtool: Ignore jumps to the end of the function for non-CFG arches
  objtool: Allow empty alternatives
  objtool: Reuse consecutive string references
  objtool: Introduce objtool for arm64
  klp-build: Support cross-compilation

 arch/arm64/Kconfig                            |   2 +
 arch/arm64/kernel/entry.S                     |   2 +
 arch/arm64/kernel/head.S                      |   2 +-
 arch/arm64/kernel/proton-pack.c               |  12 +-
 arch/arm64/kernel/vmlinux.lds.S               |   2 +-
 arch/x86/boot/startup/Makefile                |   2 +-
 include/asm-generic/vmlinux.lds.h             |   2 +-
 include/linux/init.h                          |   1 +
 lib/crypto/arm64/sha2-armv8.pl                |  11 +-
 scripts/Makefile.build                        |   4 +-
 scripts/Makefile.lib                          |  46 +++----
 scripts/Makefile.vmlinux_o                    |  15 +--
 scripts/livepatch/klp-build                   |  11 +-
 tools/objtool/Makefile                        |   4 +
 tools/objtool/arch/arm64/Build                |   2 +
 tools/objtool/arch/arm64/decode.c             | 116 ++++++++++++++++++
 .../arch/arm64/include/arch/cfi_regs.h        |  11 ++
 tools/objtool/arch/arm64/include/arch/elf.h   |  13 ++
 .../objtool/arch/arm64/include/arch/special.h |  21 ++++
 tools/objtool/arch/arm64/special.c            |  21 ++++
 tools/objtool/builtin-check.c                 |   5 -
 tools/objtool/check.c                         |  83 +++++++++----
 tools/objtool/elf.c                           |  11 +-
 tools/objtool/include/objtool/checksum.h      |   6 +-
 tools/objtool/include/objtool/warn.h          |   2 +-
 25 files changed, 323 insertions(+), 84 deletions(-)
 create mode 100644 tools/objtool/arch/arm64/Build
 create mode 100644 tools/objtool/arch/arm64/decode.c
 create mode 100644 tools/objtool/arch/arm64/include/arch/cfi_regs.h
 create mode 100644 tools/objtool/arch/arm64/include/arch/elf.h
 create mode 100644 tools/objtool/arch/arm64/include/arch/special.h
 create mode 100644 tools/objtool/arch/arm64/special.c

-- 
2.53.0


