Return-Path: <live-patching+bounces-2608-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id EDCbGj8+8mlypAEAu9opvQ
	(envelope-from <live-patching+bounces-2608-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Wed, 29 Apr 2026 19:22:07 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 9767549823A
	for <lists+live-patching@lfdr.de>; Wed, 29 Apr 2026 19:22:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 6873D30A1786
	for <lists+live-patching@lfdr.de>; Wed, 29 Apr 2026 17:18:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 90846410D1A;
	Wed, 29 Apr 2026 17:18:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="ivW6JqD+"
X-Original-To: live-patching@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9BA5140FDBE;
	Wed, 29 Apr 2026 17:18:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777483108; cv=none; b=hScl9jCednOSt20+WuXuGV1X59p6nvbeM3sPl90ff2CIYsUDfJqvZtsCyxPbU7ItSCFiT0Y8Nrng9XLRXtdqhc7fde6JkhKy38Y3fsYUdo8hasVfdKHeZAs0eGF6UedgksY6TXR5VET5bM38uBjzYzg9XaOgGTXJ+X44W8HTKww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777483108; c=relaxed/simple;
	bh=WCiGNRn2qwDtYs/NqzSwakKuBgzsRsKcTs+ZB/aD1y4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=T5T4SB7ugdm0U0pejW4wtHZOT4D2xSRWJYYDVbc4dsSeU4b/F/d9K+x6NNeRrK6G9n0lIQd1mQl2BIzSpTbIWp7IwH52BKbl60fgwXftUM8AZK5pbUQk6t2RAGAlmVKhCDcm/+xoGNJOv3JYemWeLk2d4bZaSFBfkZAKQZ6S/qg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=ivW6JqD+; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8CBE416A3;
	Wed, 29 Apr 2026 10:18:20 -0700 (PDT)
Received: from J2N7QTR9R3.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 795CD3F7B4;
	Wed, 29 Apr 2026 10:18:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1777483106; bh=WCiGNRn2qwDtYs/NqzSwakKuBgzsRsKcTs+ZB/aD1y4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ivW6JqD+y0MACxJ+86+b4GWNjMjTyMHjNp9492Vnp74Gq26CLTzxWIN3HdQBj6vzx
	 CMmDkojPEVmcj29TCrxFtWuyskDix1pyV8PclfJYJOnyeDxTNcWZ/UCha04Jv+pqvr
	 HgBDtAw/uBiWnDpGg/6+BcTd8JQDzAXTp4vr/EOk=
Date: Wed, 29 Apr 2026 18:18:19 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Dylan Hatch <dylanbhatch@google.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>,
	Weinan Liu <wnliu@google.com>, Will Deacon <will@kernel.org>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Indu Bhagat <ibhagatgnu@gmail.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Jiri Kosina <jikos@kernel.org>, Jens Remus <jremus@linux.ibm.com>,
	Prasanna Kumar T S M <ptsm@linux.microsoft.com>,
	Puranjay Mohan <puranjay@kernel.org>, Song Liu <song@kernel.org>,
	joe.lawrence@redhat.com, linux-toolchains@vger.kernel.org,
	linux-kernel@vger.kernel.org, live-patching@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [PATCH v5 0/8] unwind, arm64: add sframe unwinder for kernel
Message-ID: <afI9W5gj6Eo-bYi3@J2N7QTR9R3.cambridge.arm.com>
References: <20260428183643.3796063-1-dylanbhatch@google.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260428183643.3796063-1-dylanbhatch@google.com>
X-Rspamd-Queue-Id: 9767549823A
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[arm.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[arm.com:s=foss];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[linux.dev,google.com,kernel.org,gmail.com,infradead.org,goodmis.org,arm.com,linux.ibm.com,linux.microsoft.com,redhat.com,vger.kernel.org,lists.infradead.org];
	TAGGED_FROM(0.00)[bounces-2608-lists,live-patching=lfdr.de];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[arm.com:+];
	RCPT_COUNT_TWELVE(0.00)[20];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[mark.rutland@arm.com,live-patching@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[live-patching];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,arm.com:dkim,J2N7QTR9R3.cambridge.arm.com:mid,sourceware.org:url]

Hi Dylan,

On Tue, Apr 28, 2026 at 06:36:35PM +0000, Dylan Hatch wrote:
> Implement a generic kernel sframe-based [1] unwinder. The main goal is
> to improve reliable stacktrace on arm64 by unwinding across exception
> boundaries.

Thanks for this!

Just as a holding reply: I'm going over the series now, and I have some
partially-written comments that I'll try to finish up and get out
tomorrow.

Mark.

> On x86, the ORC unwinder provides reliable stacktrace through similar
> methodology, but arm64 lacks the necessary support from objtool to
> create ORC unwind tables.
> 
> Currently, there's already a sframe unwinder proposed for userspace: [2].
> To maintain common definitions and algorithms for sframe lookup, a
> substantial portion of this patch series aims to refactor the sframe
> lookup code to support both kernel and userspace sframe sections.
> 
> Currently, only GNU Binutils support sframe. This series relies on the
> Sframe V3 format, which is supported in binutils 2.46.
> 
> These patches are based on Steven Rostedt's sframe/core branch [3],
> which is and aggregation of existing work done for x86 sframe userspace
> unwind, and contains [2]. This branch is, in turn, based on Linux
> v7.0-rc3. This full series (applied to the sframe/core branch) is
> available on github: [4].
> 
> Ref:
> [1]: https://sourceware.org/binutils/docs/sframe-spec.html
> [2]: https://lore.kernel.org/lkml/20260127150554.2760964-1-jremus@linux.ibm.com/
> [3]: https://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git/log/?h=sframe/core
> [4]: https://github.com/dylanbhatch/linux/tree/sframe-v5
> 
> Changes since v4:
>   - (Jens) Fix some minor nits.
>   - Handle .init.text and .exit.text in function address validation.
> 
> Changes since v3:
> 
>   - (Jens) Clean up patch summaries.
>   - (Jens) Rename SFRAME_LOOKUP -> UNWIND_SFRAME_LOOKUP to fit existing
>     naming convention.
>   - (Randy) Correct typo errors in new config options.
>   - (Jens) Move unwind types to a new unwind_types.h to match their
>     usage.
>   - (Jens) Update KERNEL_[COPY|GET] to use label-based error handling
>     like their userspace counterparts.
>   - (Jens) Rename SFRAME_UNWINDER -> HAVE_UNWIND_KERNEL_SFRAME and
>     ARCH_SUPPORTS_SFRAME_UNWINDER -> ARCH_SUPPORTS_UNWIND_KERNEL_SFRAME
>     to match existing naming convention.
>   - (Jens) Move HAVE_UNWIND_KERNEL_SFRAME config option to arch/Kconfig.
>   - (Jens) Rename/move extern definitions of __[start|end]_sframe into
>     include/asm-generic/sections.h.
>   - (Jens) Fix up CFI annotations at kernel entry.
>   - (Jens) Fix error path for unsorted FDE lookup.
>   - (Jens) Zero-out module sframe_section before init.
>   - (Jens) For SFRAME_VALIDATION, use an arch-specific function-address
>     validation helper so that .rodata.text can be correctly handled on
>     arm64 vmlinux.
>   - (Jens) Fixup and better comment kernel stacktrace code.
> 
> Changes since v2:
> 
> The biggest change from v2 is the switch from adding a dedicated,
> in-kernel sframe-lookup library, to refactoring/using the existing
> library developed by Josh, Jens, and Steve. Consequently, this series
> now depends on Sframe V3, though this upgrade would likely have been
> necessary anyway. Below is a full accounting of the changes since v2.
> 
>   - (Josh) Add stricter reliability checks during unwind.
>   - (Puranjay, Indu, Jens) Update to use a common sframe library with
>     userpace unwind, thus resolving the need to support
>     SFRAME_F_FDE_FUNC_START_PCREL, added in binutils 2.45.
>   - (Jens) Add check for sframe V3, thus resolving the prior need for V2
>     and SFRAME_F_FDE_FUNC_START_PCREL support.
>   - (Will) Add ARCH_SUPPORTS_SFRAME_UNWINDER, remove SFRAME_UNWIND_TABLE
>   - (Indu) add support for unsorted FDE tables, allowing for module
>     sframe lookups.
>   - (Mark) Prefer frame-pointer unwind when possible, for better
>     performance.
>   - Simplify compile-time logic, adding stubbs when necessary.
>   - Add support for in-kernel SFRAME_VALIDATION.
>   - Rebase onto core/sframe (with v7.0-rc3 base)
> 
> Dylan Hatch (7):
>   sframe: Allow kernelspace sframe sections
>   arm64, unwind: build kernel with sframe V3 info
>   sframe: Provide PC lookup for vmlinux .sframe section
>   sframe: Allow unsorted FDEs
>   arm64/module, sframe: Add sframe support for modules
>   sframe: Introduce in-kernel SFRAME_VALIDATION
>   unwind: arm64: Use sframe to unwind interrupt frames
> 
> Weinan Liu (1):
>   arm64: entry: add unwind info for various kernel entries
> 
>  MAINTAINERS                                   |   3 +-
>  Makefile                                      |   8 +
>  arch/Kconfig                                  |  27 +-
>  arch/arm64/Kconfig                            |   1 +
>  arch/arm64/include/asm/module.h               |   6 +
>  arch/arm64/include/asm/sections.h             |   1 +
>  arch/arm64/include/asm/stacktrace/common.h    |   6 +
>  arch/arm64/include/asm/unwind_sframe.h        |  55 +++
>  arch/arm64/kernel/entry.S                     |  23 +
>  arch/arm64/kernel/module.c                    |   8 +
>  arch/arm64/kernel/setup.c                     |   2 +
>  arch/arm64/kernel/stacktrace.c                | 246 ++++++++++-
>  arch/arm64/kernel/vdso/Makefile               |   2 +-
>  arch/arm64/kernel/vmlinux.lds.S               |   2 +
>  .../{unwind_user_sframe.h => unwind_sframe.h} |   6 +-
>  arch/x86/include/asm/unwind_user.h            |  12 +-
>  include/asm-generic/sections.h                |   4 +
>  include/asm-generic/vmlinux.lds.h             |  15 +
>  include/linux/sframe.h                        |  67 ++-
>  include/linux/unwind_types.h                  |  46 ++
>  include/linux/unwind_user_types.h             |  41 --
>  kernel/unwind/Makefile                        |   2 +-
>  kernel/unwind/sframe.c                        | 410 ++++++++++++++----
>  kernel/unwind/user.c                          |  41 +-
>  24 files changed, 827 insertions(+), 207 deletions(-)
>  create mode 100644 arch/arm64/include/asm/unwind_sframe.h
>  rename arch/x86/include/asm/{unwind_user_sframe.h => unwind_sframe.h} (50%)
>  create mode 100644 include/linux/unwind_types.h
> 
> -- 
> 2.54.0.545.g6539524ca2-goog
> 

