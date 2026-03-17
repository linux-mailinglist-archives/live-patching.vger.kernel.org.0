Return-Path: <live-patching+bounces-2220-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id GLH8DPfauWlHOgIAu9opvQ
	(envelope-from <live-patching+bounces-2220-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Tue, 17 Mar 2026 23:51:35 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C79F92B3353
	for <lists+live-patching@lfdr.de>; Tue, 17 Mar 2026 23:51:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id CD3C1301B79A
	for <lists+live-patching@lfdr.de>; Tue, 17 Mar 2026 22:51:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F5AF3A641E;
	Tue, 17 Mar 2026 22:51:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VxevCvHp"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AC4D3A4F44;
	Tue, 17 Mar 2026 22:51:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773787892; cv=none; b=Zsx4kXMIzTGLYOUJR9ptHmDwW/w5RdePMcT08SvIZ1mJ8+EWRTjc1MovoP/WjrE1kkbzqleAj1/6PvcxOGjQiAJ3qZKsrMSnXM0S98qBtQQ/I9Xk6SXsODh3J6kAn0irPXJzlS8OA7q5qyiaCv/pWXgnsr4Qzfndt0mqaDp8/50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773787892; c=relaxed/simple;
	bh=7M5eXaWqiZHHjx4e1XlzzVnXsumabdLsCWW8h6CRvew=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=HSaFVN6nv3IQcTLC2IpjC/OD7sy5BFS3WXd6u8VaxfowrWP8/+bdsFRe+R3unyyjUL1QeCsln7B/OMKvROSvx2VqVmg2ojXsKvFkOvuAFx+SuaTv4NtQO3VeRRh9LHC1jSV74ZXCLnKUtRlAbKw8H+SJ/IuKUwOfF+T/CVoyv6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VxevCvHp; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B11FC4CEF7;
	Tue, 17 Mar 2026 22:51:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773787892;
	bh=7M5eXaWqiZHHjx4e1XlzzVnXsumabdLsCWW8h6CRvew=;
	h=From:To:Cc:Subject:Date:From;
	b=VxevCvHp9lmUF7+dNOM9Ms5C+9yz9lhM+jGse9c/iwaf3jCf3nFEnFa1IwYgQaohm
	 OkWKIWfMxvmnya/OHFbUvY8ETvQ0dlghKyMM0YlYtPl9GH/qt3oG17TMoEUGauBUR+
	 8n9M7ua28N33VK8AB1b0uG+HWn9s9nFT/VQMIO36/gPa1Ae6hVhasMu1rUspJQY/2J
	 hS1MdrEy6BguCj0RwfqG9RHF/RS2pseU8N0ylS/OvhaDRUql4FxmsWcgTNdoUyzB63
	 z2oEqCcXfOht9Rpn91W8ofzOIiiNpHgKrLB1Vb+PhPTXD3Sw2mDMb3+e8MxRplHapP
	 EX4v21HOVgMBQ==
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
Subject: [PATCH v2 00/12] objtool/arm64: Port klp-build to arm64
Date: Tue, 17 Mar 2026 15:51:00 -0700
Message-ID: <cover.1773787568.git.jpoimboe@kernel.org>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2220-lists,live-patching=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[13];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jpoimboe@kernel.org,live-patching@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: C79F92B3353
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

v2:
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

Josh Poimboeuf (12):
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
 tools/objtool/elf.c                           |   9 +-
 tools/objtool/include/objtool/checksum.h      |   6 +-
 24 files changed, 321 insertions(+), 82 deletions(-)
 create mode 100644 tools/objtool/arch/arm64/Build
 create mode 100644 tools/objtool/arch/arm64/decode.c
 create mode 100644 tools/objtool/arch/arm64/include/arch/cfi_regs.h
 create mode 100644 tools/objtool/arch/arm64/include/arch/elf.h
 create mode 100644 tools/objtool/arch/arm64/include/arch/special.h
 create mode 100644 tools/objtool/arch/arm64/special.c

-- 
2.53.0


