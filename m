Return-Path: <live-patching+bounces-2590-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id cKELJNUA8WlQbwEAu9opvQ
	(envelope-from <live-patching+bounces-2590-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Tue, 28 Apr 2026 20:47:49 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 8CC5948AD38
	for <lists+live-patching@lfdr.de>; Tue, 28 Apr 2026 20:47:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 109E63003BE7
	for <lists+live-patching@lfdr.de>; Tue, 28 Apr 2026 18:37:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E5CE81D5147;
	Tue, 28 Apr 2026 18:37:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WmYTxP45"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EEE023A561
	for <live-patching@vger.kernel.org>; Tue, 28 Apr 2026 18:37:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777401427; cv=none; b=LP65t2Ar7ADkmsQGoOISYuFBwccO5teERXSAHjxVziDCGvTlEUrzgXAwWGqxY0Qe7FStxEg6jeh2J3FcKEhDMxBrV5SQTmc3lGin+EKMo63xlD/ihyqqMvMZ75E3fgatfBD8g5SD2M3yn4hhq3xVBN1eJBqlWlOcA3WoQZ8CX+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777401427; c=relaxed/simple;
	bh=AJDvqVWtecpiSsTr6ss6AnaGAsouFU4ZDTZ3xytdTCw=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=NuGg923+vDZDXYCa09vGDVQ0hhomxBgj/vZuta1fjWLINsWtYYq2bn3BF3tIgSx1aZIufTiJR1OHCaZHHdOwYEw7eR3gxMiqk3H6owVAky+egXRYN7xyPBa7Yhkz470qI+BIrcz0QstzERgqURlKwoo9cljcnivhoIP5OmfTxnE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--dylanbhatch.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=WmYTxP45; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--dylanbhatch.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-36472c6a7d8so5241655a91.3
        for <live-patching@vger.kernel.org>; Tue, 28 Apr 2026 11:37:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777401426; x=1778006226; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=0cxKPHTRIaK/ePDfLMLoc6fCf6yDOu/nHtt6cdw9gxo=;
        b=WmYTxP45sRPhB/LbL0hCpKLZd0T2DVGVYoZ4KHLRyHKFIrkJsaJfIZNgU38y1Z8xMf
         DZCxuwRSzJUH9H4I4sPVvr3kFFFs/ei45yN8Na5looPXjqul+zdSp+FVwqi3XU9Tbgfs
         p0UUZOK8InHIhpFen2OXN4wYr1PJR33WMPbiO9yB21GZsL6nLZXw+RFmv1Wd1GJpLyB8
         o8MYUV32PyvUw3KEY7ss1rM3xv5UNuOiHS0cle6znEXBP+3Ycknn0uAwceGJuuY83TzW
         qYUuCUYHoqr4wiPLvcsD4W/rHv5RMdYBWilbS5dIOPD3mBzPYapiSD8k8/NksYnsyd4Y
         Dq4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777401426; x=1778006226;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0cxKPHTRIaK/ePDfLMLoc6fCf6yDOu/nHtt6cdw9gxo=;
        b=a/TkAE8nlK0GMMrh79WtLTs/rtsG7kHiTP3vnPlGLauuxZX1/SUDbAJoZUOniEiqxE
         hYx8BI2h4JFr5rKxnlSEWxeqIiWdtjxBedzOaoc379IKuu92i2V4k6b0pEfFKOMIQ4/L
         SJ+kVEcndiBuOmXWIGeqdHIqz6EQpkA7pdRfQ96u24qQFNtCPd4ztYrg+jqio1gveBM4
         fyOupZrYcEukaIyoCg346NdlRf6RISxPkpeMCh+XEaxwZGSgfWfVp3JI01Qhj7iCcKNV
         PORZVf2X8iBHZYOEpQjmpw7ll5x4x98SFAeB3VJT4h0sDoeO2CukTW9+OvXU1z+aWxnC
         BMdw==
X-Forwarded-Encrypted: i=1; AFNElJ+VoiSXRN0OmjqQiW/8l+Nmm+pFCGja8BBQ5GT4uJ+d0OEJu/aiq1QxOU8T9jWcFCuC/Xh3daqcKuQrdm7+@vger.kernel.org
X-Gm-Message-State: AOJu0YzHBVnLV2YwbbfO5vxVuKQ/mNRoBdn77Grt3MpRQc6kteQtItxu
	sq3trhYcVrrH33IlNGtvIAlam3JXTyS9hqhikFMI7BAUK17vvxSQ5Fj09dTUgzCZvbc+EAakcX8
	TM5xY3S4DI15KyufxFEBtRl9Aqg==
X-Received: from pjop3.prod.google.com ([2002:a17:90a:9303:b0:35d:94b3:bd6b])
 (user=dylanbhatch job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:1b10:b0:35f:b6d3:da7a with SMTP id 98e67ed59e1d1-364920a55f4mr4382325a91.15.1777401425558;
 Tue, 28 Apr 2026 11:37:05 -0700 (PDT)
Date: Tue, 28 Apr 2026 18:36:35 +0000
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.54.0.545.g6539524ca2-goog
Message-ID: <20260428183643.3796063-1-dylanbhatch@google.com>
Subject: [PATCH v5 0/8] unwind, arm64: add sframe unwinder for kernel
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
X-Rspamd-Queue-Id: 8CC5948AD38
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FREEMAIL_TO(0.00)[linux.dev,google.com,kernel.org,gmail.com,infradead.org,goodmis.org,arm.com,linux.ibm.com];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[21];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[dylanbhatch@google.com,live-patching@vger.kernel.org];
	TAGGED_FROM(0.00)[bounces-2590-lists,live-patching=lfdr.de];
	NEURAL_HAM(-0.00)[-0.999];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	TAGGED_RCPT(0.00)[live-patching];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]

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
[4]: https://github.com/dylanbhatch/linux/tree/sframe-v5

Changes since v4:
  - (Jens) Fix some minor nits.
  - Handle .init.text and .exit.text in function address validation.

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
 arch/arm64/include/asm/unwind_sframe.h        |  55 +++
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
 24 files changed, 827 insertions(+), 207 deletions(-)
 create mode 100644 arch/arm64/include/asm/unwind_sframe.h
 rename arch/x86/include/asm/{unwind_user_sframe.h => unwind_sframe.h} (50%)
 create mode 100644 include/linux/unwind_types.h

-- 
2.54.0.545.g6539524ca2-goog


