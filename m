Return-Path: <live-patching+bounces-2853-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 0JPJJ4EJDGrSUQUAu9opvQ
	(envelope-from <live-patching+bounces-2853-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Tue, 19 May 2026 08:56:01 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 0943F578742
	for <lists+live-patching@lfdr.de>; Tue, 19 May 2026 08:56:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id D43F73031AF1
	for <lists+live-patching@lfdr.de>; Tue, 19 May 2026 06:50:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 436B539EF14;
	Tue, 19 May 2026 06:50:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tqG5q8Jk"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCAFD39D6EC
	for <live-patching@vger.kernel.org>; Tue, 19 May 2026 06:50:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779173406; cv=none; b=bZUUkUEOcnJtKo/7/5Zk9z4fw7JU+04RyOmEioOsm/tzuLmM0QltBZTYfnN5Gk4mdFBF+/36Ml17sI3hHIYSe+V1eHKC7uvCP+MGuNdX9iEHIlSNf2P18pcTTaz8/4xpzwdDnFpLBWvN7AgHf7z+0rGWwlC3WIshjWv3iXVtPxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779173406; c=relaxed/simple;
	bh=Tr/BFAdCt8HMSg5jnx6LdjpABmpG/TariBrsqrKhcyc=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=Vai12+0eBXUgBnq5mL/qufjqaJ4PoY6zZE2q/+OE1DyZlmroHifaR2wruPT7JkF1Br3oyoLFtm+Yl+e3BT8WGX7Mj8uy56uL0DINicLGwztHS42x05hnZKxUgnGQXe9S9nGD+GsWyTl2RkKE8VxahCaDOBgtBpJKGEd8+jslmrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--dylanbhatch.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=tqG5q8Jk; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--dylanbhatch.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-8354503d9acso4431780b3a.1
        for <live-patching@vger.kernel.org>; Mon, 18 May 2026 23:50:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779173404; x=1779778204; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=kSFThGuCuGJkcernOW97Ikx5o82bS8XwRL4VuiLdL4k=;
        b=tqG5q8Jk8+DGsECmxq8q6k4b5WLiEZD56SLhpRLsBXM1LMVhoWsox2T4aAAkKA//Z2
         nBmXrtek3l31VKKJnLJ7Ll012LzD7fdHvzK14nYB6jf+3dBz6btIvraBzVrNytiHQt5K
         uli8nP3gShboi4GEXOl/7cN111+Xw8SmZp/Ff4qnj+jnNgLgHD4ncKKe+tFmOi7SqITO
         gpt1+DysZDTFgbk+n259likklF0/ZTY+ns51hJs8NuviI54YLqsi2QivjMC17GssmQCy
         1aRCjgN6bg4m506911AusOt9qWZ+wKPqKdHo8b7Vu7Vw3QVI7lCk6GYabOpBdLRPs5RQ
         zGvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779173404; x=1779778204;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=kSFThGuCuGJkcernOW97Ikx5o82bS8XwRL4VuiLdL4k=;
        b=DRmWXlyE9DTIzv5NXvWPcQ9PJAoXGORFwW3NhveGM6epcJcm6FXB0MBAmT5UJtaW0T
         DTFNjKmHXT3ukwHtZqFZkjVJ4GQSs+r3WU0Hb+3++WSURiBIGI/ivu/ZnjCcVy8dyrzi
         GY7fLHDGj7SHxGDbNB6+xvIRd3j63LrPmTve7tgBoEJjdCi61MkguF2Q9cJ2vrtQa3xu
         3zE2sg3JIzBfgO+CGCMPVufH1KS/vpn67TvDpJ1Euf1un79eDm6KVXV6VeexwyGVZ2yl
         JOUL5I0RHv0KnSshJCdJ0DZollrhgvFmQpzJt92F+VXv6rVttYNIpVWYJGH3vJkd1m0z
         s/fA==
X-Forwarded-Encrypted: i=1; AFNElJ+PwNSq6+03LsReNElIhDSZblNP6e4Cabt32GobIK6u7WGaMRrsiCy5XiC1Rb8GOhrcdAMggsq/gu2yZ2M0@vger.kernel.org
X-Gm-Message-State: AOJu0Yzf1vUgNlmoe4oF5yrCkp2abS8QWj+IcWPQ96fWBC2Bvx4QQCw5
	6BZVqsxd4aHqAhV4n96K6sIJ+Kn/q7hPVQKyqHabz2m+KeLvPGUoV6ceIxtmM9jev0CPNS7NuU5
	1iYq2iBy8R+g5kMWKj2ZHyzFOEw==
X-Received: from pfam20.prod.google.com ([2002:aa7:8a14:0:b0:835:687a:d19d])
 (user=dylanbhatch job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:2d8a:b0:82f:9d21:d352 with SMTP id d2e1a72fcca58-83f33aebdaemr18079357b3a.9.1779173403694;
 Mon, 18 May 2026 23:50:03 -0700 (PDT)
Date: Tue, 19 May 2026 06:49:41 +0000
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.54.0.563.g4f69b47b94-goog
Message-ID: <20260519064950.493949-1-dylanbhatch@google.com>
Subject: [PATCH v6 0/9] unwind, arm64: add sframe unwinder for kernel
From: Dylan Hatch <dylanbhatch@google.com>
To: Roman Gushchin <roman.gushchin@linux.dev>, Weinan Liu <wnliu@google.com>, 
	Will Deacon <will@kernel.org>, Josh Poimboeuf <jpoimboe@kernel.org>, 
	Indu Bhagat <ibhagatgnu@gmail.com>, Peter Zijlstra <peterz@infradead.org>, 
	Steven Rostedt <rostedt@goodmis.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Jiri Kosina <jikos@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
	Jens Remus <jremus@linux.ibm.com>
Cc: Dylan Hatch <dylanbhatch@google.com>, Prasanna Kumar T S M <ptsm@linux.microsoft.com>, 
	Puranjay Mohan <puranjay@kernel.org>, Song Liu <song@kernel.org>, joe.lawrence@redhat.com, 
	linux-toolchains@vger.kernel.org, linux-kernel@vger.kernel.org, 
	live-patching@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	Randy Dunlap <rdunlap@infradead.org>, Mostafa Saleh <smostafa@google.com>, 
	Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_DKIM_ALLOW(-0.20)[google.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_TO(0.00)[linux.dev,google.com,kernel.org,gmail.com,infradead.org,goodmis.org,arm.com,linux.ibm.com];
	RCPT_COUNT_TWELVE(0.00)[24];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[dylanbhatch@google.com,live-patching@vger.kernel.org];
	TAGGED_FROM(0.00)[bounces-2853-lists,live-patching=lfdr.de];
	TAGGED_RCPT(0.00)[live-patching];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Queue-Id: 0943F578742
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Implement a generic kernel sframe-based [1] unwinder. The main goal is
to improve reliable stacktrace on arm64 by unwinding across exception
boundaries.

On x86, the ORC unwinder provides reliable stacktrace through similar
methodology, but arm64 lacks the necessary support from objtool to
create ORC unwind tables.

Currently, there's already a sframe unwinder proposed for userspace: [2].
To maintain common definitions and algorithms for sframe lookup, a
substantial portion of this patch series aims to refactor the sframe
lookup code to support both kernel and userspace sframe sections.

Currently, only GNU Binutils support sframe. This series relies on the
Sframe V3 format, which is supported in binutils 2.46.

These patches are based on Steven Rostedt's sframe/core branch [3],
which is and aggregation of existing work done for x86 sframe userspace
unwind, and contains [2]. This branch is, in turn, based on Linux
v7.1-rc2. This full series (applied to the sframe/core branch) is
available on github: [4].

Ref:
[1]: https://sourceware.org/binutils/docs/sframe-spec.html
[2]: https://lore.kernel.org/all/20260505121718.3572346-1-jremus@linux.ibm.com/
[3]: https://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git/log/?h=sframe/core
[4]: https://github.com/dylanbhatch/linux/tree/sframe-v6

Changes since v5:
- Rebase on latest sframe/core branch [3] (based on v7.1-rc2).
- (Mark) Drop CFI annotations from el1*_64_* entry functions.
- (Mark) Add CFI annotations for leaf functions in lib/ and crypto/.
- (Jens) Sort module FDEs at load-time, drop linear search method.
- (Jens) Fix mistake in module SFrame validation where temp copy is not
  yet embedded within a struct module.
- (Jens) Initialize debug info for kernel .sframe sections.
- (Mark) Move kernel-specific unwind fields to struct kunwind_state.
- (Mark) Drop SP from unwind state.
- (Mark) Rename unwind_next_frame_sframe -> kunwind_next_regs_sframe,
  add checks to assert a correct KUNWIND_SOURCE_REGS_PC state.
- (Mark) Drop unused flexible FDE handling.
- (Mark) Check CFA alignment to 16 bytes instead of 8 bytes.
- (Mark) For non-KUNWIND_SOURCE_REGS_PC state, drop the fallback to
  SFrame unwind if FP unwind fails in kunwind_next().

Dylan Hatch (8):
  sframe: Allow kernelspace sframe sections
  arm64, unwind: build kernel with sframe V3 info
  arm64, crypto/lib: Annotate leaf functions with CFI info.
  sframe: Provide PC lookup for vmlinux .sframe section
  arm64/module, sframe: Add sframe support for modules
  sframe: Introduce in-kernel SFRAME_VALIDATION
  sframe: Initialize debug info for kernel sections
  unwind: arm64: Use sframe to unwind interrupt frames

Weinan Liu (1):
  arm64: entry: add unwind info for call_on_irq_stack()

 MAINTAINERS                                   |   4 +-
 Makefile                                      |   8 +
 arch/Kconfig                                  |  27 +-
 arch/arm64/Kconfig                            |   1 +
 arch/arm64/crypto/aes-ce-ccm-core.S           |  12 +-
 arch/arm64/crypto/aes-neonbs-core.S           |  40 +-
 arch/arm64/crypto/ghash-ce-core.S             |  20 +-
 arch/arm64/crypto/sm4-ce-ccm-core.S           |  16 +-
 arch/arm64/crypto/sm4-ce-cipher-core.S        |   4 +-
 arch/arm64/crypto/sm4-ce-core.S               |  44 +-
 arch/arm64/crypto/sm4-ce-gcm-core.S           |  16 +-
 arch/arm64/crypto/sm4-neon-core.S             |  12 +-
 arch/arm64/include/asm/linkage.h              |  30 ++
 arch/arm64/include/asm/module.h               |   6 +
 arch/arm64/include/asm/sections.h             |   1 +
 arch/arm64/include/asm/unwind_sframe.h        |  54 +++
 arch/arm64/kernel/entry.S                     |  14 +
 arch/arm64/kernel/module.c                    |   8 +
 arch/arm64/kernel/setup.c                     |   2 +
 arch/arm64/kernel/stacktrace.c                | 222 +++++++++-
 arch/arm64/kernel/vdso/Makefile               |   2 +-
 arch/arm64/kernel/vmlinux.lds.S               |   2 +
 arch/arm64/lib/clear_page.S                   |   4 +-
 arch/arm64/lib/clear_user.S                   |   4 +-
 arch/arm64/lib/copy_from_user.S               |   4 +-
 arch/arm64/lib/copy_page.S                    |   4 +-
 arch/arm64/lib/copy_to_user.S                 |   4 +-
 arch/arm64/lib/memchr.S                       |   4 +-
 arch/arm64/lib/memcmp.S                       |   4 +-
 arch/arm64/lib/memcpy.S                       |   8 +-
 arch/arm64/lib/memset.S                       |   8 +-
 arch/arm64/lib/mte.S                          |  28 +-
 arch/arm64/lib/strchr.S                       |   4 +-
 arch/arm64/lib/strcmp.S                       |   4 +-
 arch/arm64/lib/strlen.S                       |   4 +-
 arch/arm64/lib/strncmp.S                      |   4 +-
 arch/arm64/lib/strnlen.S                      |   4 +-
 arch/arm64/lib/tishift.S                      |  12 +-
 .../{unwind_user_sframe.h => unwind_sframe.h} |   6 +-
 arch/x86/include/asm/unwind_user.h            |  12 +-
 include/asm-generic/sections.h                |   4 +
 include/asm-generic/vmlinux.lds.h             |  15 +
 include/linux/sframe.h                        |  67 ++-
 include/linux/unwind_types.h                  |  46 ++
 include/linux/unwind_user_types.h             |  41 --
 kernel/unwind/Makefile                        |   2 +-
 kernel/unwind/sframe.c                        | 419 ++++++++++++++----
 kernel/unwind/sframe_debug.h                  |  13 +
 kernel/unwind/user.c                          |  45 +-
 49 files changed, 979 insertions(+), 340 deletions(-)
 create mode 100644 arch/arm64/include/asm/unwind_sframe.h
 rename arch/x86/include/asm/{unwind_user_sframe.h => unwind_sframe.h} (50%)
 create mode 100644 include/linux/unwind_types.h

-- 
2.54.0.563.g4f69b47b94-goog


