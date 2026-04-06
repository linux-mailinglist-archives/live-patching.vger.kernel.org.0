Return-Path: <live-patching+bounces-2298-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id qE2MBccC1GkwpQcAu9opvQ
	(envelope-from <live-patching+bounces-2298-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Mon, 06 Apr 2026 21:00:23 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 100813A6759
	for <lists+live-patching@lfdr.de>; Mon, 06 Apr 2026 21:00:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id C700D3009E0B
	for <lists+live-patching@lfdr.de>; Mon,  6 Apr 2026 18:50:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4AFB33932C9;
	Mon,  6 Apr 2026 18:50:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="irq/aGum"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAC213542CF
	for <live-patching@vger.kernel.org>; Mon,  6 Apr 2026 18:50:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775501414; cv=none; b=aehGkrSy97TX3UgmNCT24TwhowXhhK4mkp7yHf0xzjcbaIlVk+7OSvQmyJzBUXWvh7hs4BdA3YGrRL1rHott7kimDIClJxgF9jb/9qiWw1du2V2xGPt8kSbD7QEPnY1d/k69uGqG7XvYrhZNAJGpl6Fi8DG01KeU0NAeMVIqOQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775501414; c=relaxed/simple;
	bh=riN6fr/MFnf3sOtrSsvZ6UMfTXrP253QR6mtbcn7vLM=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=Yf4e8FCD0+PeNtZYmB/4fhSu25OFZuciNX+2eVEWFZavuvcIvSZ72SCgsEYfNzE3/FMgc7X9M6Cfo/G9vdutk8hrttrupc0cMcJ7tZh9cbN6UFiwqtPnve08Z8eKlbUyXHMwDFAL0x++ZpNqtxX/rnzmHysWqnAY94UE/d4fMHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--dylanbhatch.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=irq/aGum; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--dylanbhatch.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-82c714cb672so2153287b3a.0
        for <live-patching@vger.kernel.org>; Mon, 06 Apr 2026 11:50:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1775501411; x=1776106211; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Tw0/fXAq4NvxlO+cgBvvlksUtU/q9839xS4Koaoen6E=;
        b=irq/aGumpjEHJDlp7egYPvKxA3X+PVl6w9pGTAia8bRsbkLRHfpMhiTjxnya1mWULY
         odP3qvejYt+ldqb2xWnjP72XGgWtir97ncYm2ArLYj2BiIH8JFqClWKCr6bYmshGe3WO
         nGjeEPF+8ExaDB0WRO2Y5oofWSJtphJnw5hbzReSOVzaApwI52AG+jToFMDfHWRMNqpp
         AC3N0hrAtqujzKP3MeZY6CtfCBwwjjfewZxn/5Ow2lszynSGKMXN5+C61GoFHJO6VYEc
         YxnTIKS0Mecq3yPTIl+hLLg5419FgkjDFObpC5We3mkke1oiL4LDWYOr/2Hz0WfT0hnB
         jaiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775501411; x=1776106211;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Tw0/fXAq4NvxlO+cgBvvlksUtU/q9839xS4Koaoen6E=;
        b=pX47CcRlum6LR1ngb3aen5Ewov1OYZVsJXMWX7ijPq3eRCnW2jKN5xQTfDNpj8a7UB
         Gj7fmcSkh2QXDwN5ooRsz9iVEXZLewH3o+nn8qDBFh56/yhGukrp4T/4Tb/JdLEg0wDR
         qGgg2daB+BEWbEqBFRqxlwf3qDmXIsTDxgGxsyZpftkMZOo/AK03e6YWEAz0FPWA8m0i
         e3XlJtXySr5S48zPFNhZu6ts5wGmlJnstJ5skg4kNobddfV3NVPjLgBsJyvyI4nf2Kf2
         RpJcN33jC8mrEfTaWt5r2r+FvSg3/Y2vg3gb27lh5pphz3JxPaS2ByTAEqJrVs9E1Pfy
         gtlA==
X-Forwarded-Encrypted: i=1; AJvYcCV91T5VunbdqMWtoSwK6t0B2gm9pjv9VM8+fT+P3wg5fP+0Q55ddazgc1I3DLvtu1YrL2QHnd4OIx4m6kao@vger.kernel.org
X-Gm-Message-State: AOJu0Yycqc3sgMq0vGKgkwYB8PzHGttx217FUIEM4FTzhxm5qHd5DQ+E
	5681AoSzsmnXj3019rme+XiVLYW9cnjVOch6LoUrgfXBgAcpt2KC8hwA8OQJMgBBEeFYmaDtYIu
	J7zQxFBo/aldsGTO5WT35rZM++A==
X-Received: from pfbeq2.prod.google.com ([2002:a05:6a00:37c2:b0:82c:63f8:59db])
 (user=dylanbhatch job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:1950:b0:82a:1337:493c with SMTP id d2e1a72fcca58-82d0da4cd94mr13275110b3a.14.1775501411087;
 Mon, 06 Apr 2026 11:50:11 -0700 (PDT)
Date: Mon,  6 Apr 2026 18:49:52 +0000
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.53.0.1213.gd9a14994de-goog
Message-ID: <20260406185000.1378082-1-dylanbhatch@google.com>
Subject: [PATCH v3 0/8] unwind, arm64: add sframe unwinder for kernel
From: Dylan Hatch <dylanbhatch@google.com>
To: Roman Gushchin <roman.gushchin@linux.dev>, Weinan Liu <wnliu@google.com>, 
	Will Deacon <will@kernel.org>, Josh Poimboeuf <jpoimboe@kernel.org>, 
	Indu Bhagat <indu.bhagat@oracle.com>, Peter Zijlstra <peterz@infradead.org>, 
	Steven Rostedt <rostedt@goodmis.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Jiri Kosina <jikos@kernel.org>
Cc: Dylan Hatch <dylanbhatch@google.com>, Mark Rutland <mark.rutland@arm.com>, 
	Prasanna Kumar T S M <ptsm@linux.microsoft.com>, Puranjay Mohan <puranjay@kernel.org>, 
	Song Liu <song@kernel.org>, joe.lawrence@redhat.com, linux-toolchains@vger.kernel.org, 
	linux-kernel@vger.kernel.org, live-patching@vger.kernel.org, 
	Jens Remus <jremus@linux.ibm.com>, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-2298-lists,live-patching=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[20];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[dylanbhatch@google.com,live-patching@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	TAGGED_RCPT(0.00)[live-patching];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,sourceware.org:url]
X-Rspamd-Queue-Id: 100813A6759
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
  sframe: Allow kernelspace sframe sections.
  arm64, unwind: build kernel with sframe V3 info
  sframe: Provide PC lookup for vmlinux .sframe section.
  sframe: Allow unsorted FDEs.
  arm64/module, sframe: Add sframe support for modules.
  sframe: Introduce in-kernel SFRAME_VALIDATION.
  unwind: arm64: Use sframe to unwind interrupt frames.

Weinan Liu (1):
  arm64: entry: add unwind info for various kernel entries

 MAINTAINERS                                   |   3 +-
 Makefile                                      |   8 +
 arch/Kconfig                                  |  13 +-
 arch/arm64/Kconfig                            |   1 +
 arch/arm64/Kconfig.debug                      |  13 +
 arch/arm64/include/asm/module.h               |   6 +
 arch/arm64/include/asm/stacktrace/common.h    |   6 +
 arch/arm64/include/asm/unwind_sframe.h        |  12 +
 arch/arm64/kernel/entry.S                     |  10 +
 arch/arm64/kernel/module.c                    |   8 +
 arch/arm64/kernel/setup.c                     |   2 +
 arch/arm64/kernel/stacktrace.c                | 242 ++++++++++-
 arch/arm64/kernel/vdso/Makefile               |   2 +-
 .../{unwind_user_sframe.h => unwind_sframe.h} |   6 +-
 arch/x86/include/asm/unwind_user.h            |  12 +-
 include/asm-generic/vmlinux.lds.h             |  15 +
 include/linux/sframe.h                        | 105 ++++-
 include/linux/unwind_user_types.h             |  41 --
 kernel/unwind/Makefile                        |   2 +-
 kernel/unwind/sframe.c                        | 408 ++++++++++++++----
 kernel/unwind/user.c                          |  40 +-
 21 files changed, 749 insertions(+), 206 deletions(-)
 create mode 100644 arch/arm64/include/asm/unwind_sframe.h
 rename arch/x86/include/asm/{unwind_user_sframe.h => unwind_sframe.h} (50%)

-- 
2.53.0.1213.gd9a14994de-goog


