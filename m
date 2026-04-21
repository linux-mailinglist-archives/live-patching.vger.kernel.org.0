Return-Path: <live-patching+bounces-2412-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id MNvEG5z/52lJEAIAu9opvQ
	(envelope-from <live-patching+bounces-2412-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Wed, 22 Apr 2026 00:52:12 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D47014404A2
	for <lists+live-patching@lfdr.de>; Wed, 22 Apr 2026 00:52:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id ABF233037F19
	for <lists+live-patching@lfdr.de>; Tue, 21 Apr 2026 22:52:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A2808379ED6;
	Tue, 21 Apr 2026 22:52:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Rg7sVRus"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 309B232D7FA
	for <live-patching@vger.kernel.org>; Tue, 21 Apr 2026 22:52:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776811929; cv=none; b=d9XVOT6XuLt8OXqzF8V8icjciuGlrTEky0dDCHUKBdvdVg7YfBfyaTBr4iXbEevibkyIyYkKgDIdLTUG08b+LEwZbpKIwV0Jn4M0rzj120TJQWRsVYp/9k/5M9cwSssIYsuxPXiijTFGRVZfYC9d3rRYkfpXLO+nQihnH5PI880=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776811929; c=relaxed/simple;
	bh=faoU1qOsT+cISXhTB6VFhtd7V9b58T5GMOQTcv5af9k=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=qP9r2kWWRTGvRXt+9JObYiNntIMeZMjWVHBQJyy3/za1Xe13BeXXg86wkAXFrLGW5gtdiI9NyeRoCgs+sYCjCrtQ8NS40Lgt3RxgE8VzUyeiQVwBLSh78RMX6SwXxRQX++04UQOvr/A716IZuLwN3KMvXl5SbHqonaGwQfDKtS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--dylanbhatch.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Rg7sVRus; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--dylanbhatch.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-c6e24ee93a6so2996191a12.0
        for <live-patching@vger.kernel.org>; Tue, 21 Apr 2026 15:52:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1776811927; x=1777416727; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=n45LXp1+vniYlrGp0e6dQKzFc3A3nIm5Tab9EOuG3Yg=;
        b=Rg7sVRusGYsmQBmciK/K2fV8GuONaZVGiyErLK2U7gq4PU/U4Tgd5Ryjw2sApCxIeQ
         r0H7knedtjBhhl6VaxlZgUsn9WiCkpshZCJw/ycNBzIOvsIrB9IyFwplFnjWTIAOjzPE
         lxXY1TgbUaMu+sKxmmxIpn/nCHYX4BzhNEfj0NqjtLl5KxfZ/AC5QDoBHUyXU6m3mcKg
         VSwhjHv6qzPYhSzLSWIcBq2R/3voTFPVm6/80O3kzqA/1s1QCiJpPlXIS7oEfLG6+dSJ
         qsuVljPUTT5kfQjuaOQA/XfZ6udN2PubX6972krRUDOOgRzkdnltCf7zcffx2gSiWpvf
         BiSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776811927; x=1777416727;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=n45LXp1+vniYlrGp0e6dQKzFc3A3nIm5Tab9EOuG3Yg=;
        b=Xcbv9dvsw92TsirUHncUKVr4aSKD0FZaFTyV4pq58RXcotUDXeZHslAnrTrtXF5NUD
         XBFcMSAlFIn5iZAOVuHyb6bnfXtaefO7YZGk76yKAxadLGSiepDtEksr1cX2VmmUxVnL
         gEMJfoga5KBtRpZQNisWPhRRfIuCm9eqbVn+WzwPPGWyXLBdMI+OyWcwi21uxkCtnSvt
         elgXlCnmotiv+i/tf8wGLAChMPAMM++w+WRSOoZBJvEPB9clseT3yBfbjWpsNozI5VXg
         iNJTmRPfSUMPCZ00rVHSYljjD6YjhO5C5KdchDy2MpB2KtQy1PphrE8xWsGLpa1He+8X
         uUOA==
X-Forwarded-Encrypted: i=1; AFNElJ9PfBsea7sfzQy/stmp/buwtLNLk5qnaHRhl4xyHhEVp+/SzIny8ZRD4Xq+NCdGVC0luISA5Ue8PkacRLg4@vger.kernel.org
X-Gm-Message-State: AOJu0YxIrz2aTv3/1wtLfBQbDSh0dQET4++P7RRTZEOqAP4UWED05g7Z
	4CnRB8RoM01qcv6RzhGE6jS6sopDt9CyCgTKksxxL2M8AGxWNkTwolfHjQV50BQdesUPL+dxVvB
	MRSmaDM09ZuxXtt+iFCgZi6YsFA==
X-Received: from pfna24.prod.google.com ([2002:aa7:80d8:0:b0:82f:5576:285b])
 (user=dylanbhatch job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:4b01:b0:82f:49b5:cfc3 with SMTP id d2e1a72fcca58-82f8b551df5mr16857789b3a.18.1776811927282;
 Tue, 21 Apr 2026 15:52:07 -0700 (PDT)
Date: Tue, 21 Apr 2026 22:51:52 +0000
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.54.0.rc1.555.g9c883467ad-goog
Message-ID: <20260421225200.1198447-1-dylanbhatch@google.com>
Subject: [PATCH v4 0/8] unwind, arm64: add sframe unwinder for kernel
From: Dylan Hatch <dylanbhatch@google.com>
To: Roman Gushchin <roman.gushchin@linux.dev>, Weinan Liu <wnliu@google.com>, 
	Will Deacon <will@kernel.org>, Josh Poimboeuf <jpoimboe@kernel.org>, 
	Indu Bhagat <ibhagatgnu@gmail.com>, Peter Zijlstra <peterz@infradead.org>, 
	Steven Rostedt <rostedt@goodmis.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Jiri Kosina <jikos@kernel.org>, Jens Remus <jremus@linux.ibm.com>
Cc: Dylan Hatch <dylanbhatch@google.com>, Mark Rutland <mark.rutland@arm.com>, 
	Prasanna Kumar T S M <ptsm@linux.microsoft.com>, Puranjay Mohan <puranjay@kernel.org>, 
	Song Liu <song@kernel.org>, joe.lawrence@redhat.com, linux-toolchains@vger.kernel.org, 
	linux-kernel@vger.kernel.org, live-patching@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, Randy Dunlap <rdunlap@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FREEMAIL_TO(0.00)[linux.dev,google.com,kernel.org,gmail.com,infradead.org,goodmis.org,arm.com,linux.ibm.com];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[21];
	TAGGED_FROM(0.00)[bounces-2412-lists,live-patching=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[dylanbhatch@google.com,live-patching@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	TAGGED_RCPT(0.00)[live-patching];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sourceware.org:url,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: D47014404A2
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
v7.0-rc3. This full series (applied to the sframe/core branch) is
available on github: [4].

Ref:
[1]: https://sourceware.org/binutils/docs/sframe-spec.html
[2]: https://lore.kernel.org/lkml/20260127150554.2760964-1-jremus@linux.ibm.com/
[3]: https://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git/log/?h=sframe/core
[4]: https://github.com/dylanbhatch/linux/tree/sframe-v3-with-v3

Changes since v3:

  - (Jens) Clean up patch summaries.
  - (Jens) Rename SFRAME_LOOKUP -> UNWIND_SFRAME_LOOKUP to fit existing
    naming convention.
  - (Randy) Correct typo errors in new config options.
  - (Jens) Move unwind types to a new unwind_types.h to match their
    usage.
  - (Jens) Update KERNEL_[COPY|GET] to use label-based error handling
    like their userspace counterparts.
  - (Jens) Rename SFRAME_UNWINDER -> HAVE_UNWIND_KERNEL_SFRAME and
    ARCH_SUPPORTS_SFRAME_UNWINDER -> ARCH_SUPPORTS_UNWIND_KERNEL_SFRAME
    to match existing naming convention.
  - (Jens) Move HAVE_UNWIND_KERNEL_SFRAME config option to arch/Kconfig.
  - (Jens) Rename/move extern definitions of __[start|end]_sframe into
    include/asm-generic/sections.h.
  - (Jens) Fix up CFI annotations at kernel entry.
  - (Jens) Fix error path for unsorted FDE lookup.
  - (Jens) Zero-out module sframe_section before init.
  - (Jens) For SFRAME_VALIDATION, use an arch-specific function-address
    validation helper so that .rodata.text can be correctly handled on
    arm64 vmlinux.
  - (Jens) Fixup and better comment kernel stacktrace code.

Changes since v2:

The biggest change from v2 is the switch from adding a dedicated,
in-kernel sframe-lookup library, to refactoring/using the existing
library developed by Josh, Jens, and Steve. Consequently, this series
now depends on Sframe V3, though this upgrade would likely have been
necessary anyway. Below is a full accounting of the changes since v2.

  - (Josh) Add stricter reliability checks during unwind.
  - (Puranjay, Indu, Jens) Update to use a common sframe library with
    userpace unwind, thus resolving the need to support
    SFRAME_F_FDE_FUNC_START_PCREL, added in binutils 2.45.
  - (Jens) Add check for sframe V3, thus resolving the prior need for V2
    and SFRAME_F_FDE_FUNC_START_PCREL support.
  - (Will) Add ARCH_SUPPORTS_SFRAME_UNWINDER, remove SFRAME_UNWIND_TABLE
  - (Indu) add support for unsorted FDE tables, allowing for module
    sframe lookups.
  - (Mark) Prefer frame-pointer unwind when possible, for better
    performance.
  - Simplify compile-time logic, adding stubbs when necessary.
  - Add support for in-kernel SFRAME_VALIDATION.
  - Rebase onto core/sframe (with v7.0-rc3 base)

Dylan Hatch (7):
  sframe: Allow kernelspace sframe sections
  arm64, unwind: build kernel with sframe V3 info
  sframe: Provide PC lookup for vmlinux .sframe section
  sframe: Allow unsorted FDEs
  arm64/module, sframe: Add sframe support for modules
  sframe: Introduce in-kernel SFRAME_VALIDATION
  unwind: arm64: Use sframe to unwind interrupt frames

Weinan Liu (1):
  arm64: entry: add unwind info for various kernel entries

 MAINTAINERS                                   |   3 +-
 Makefile                                      |   8 +
 arch/Kconfig                                  |  27 +-
 arch/arm64/Kconfig                            |   1 +
 arch/arm64/include/asm/module.h               |   6 +
 arch/arm64/include/asm/sections.h             |   1 +
 arch/arm64/include/asm/stacktrace/common.h    |   6 +
 arch/arm64/include/asm/unwind_sframe.h        |  29 ++
 arch/arm64/kernel/entry.S                     |  23 +
 arch/arm64/kernel/module.c                    |   8 +
 arch/arm64/kernel/setup.c                     |   2 +
 arch/arm64/kernel/stacktrace.c                | 246 ++++++++++-
 arch/arm64/kernel/vdso/Makefile               |   2 +-
 arch/arm64/kernel/vmlinux.lds.S               |   2 +
 .../{unwind_user_sframe.h => unwind_sframe.h} |   6 +-
 arch/x86/include/asm/unwind_user.h            |  12 +-
 include/asm-generic/sections.h                |   4 +
 include/asm-generic/vmlinux.lds.h             |  15 +
 include/linux/sframe.h                        |  67 ++-
 include/linux/unwind_types.h                  |  46 ++
 include/linux/unwind_user_types.h             |  41 --
 kernel/unwind/Makefile                        |   2 +-
 kernel/unwind/sframe.c                        | 410 ++++++++++++++----
 kernel/unwind/user.c                          |  41 +-
 24 files changed, 801 insertions(+), 207 deletions(-)
 create mode 100644 arch/arm64/include/asm/unwind_sframe.h
 rename arch/x86/include/asm/{unwind_user_sframe.h => unwind_sframe.h} (50%)
 create mode 100644 include/linux/unwind_types.h

-- 
2.54.0.rc1.555.g9c883467ad-goog


