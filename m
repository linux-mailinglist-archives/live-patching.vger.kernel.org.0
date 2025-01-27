Return-Path: <live-patching+bounces-1067-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B92D7A1FFE1
	for <lists+live-patching@lfdr.de>; Mon, 27 Jan 2025 22:33:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D035B18876A6
	for <lists+live-patching@lfdr.de>; Mon, 27 Jan 2025 21:33:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 963CB1D88AC;
	Mon, 27 Jan 2025 21:33:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="yDhCOPMf"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C84A1D88D7
	for <live-patching@vger.kernel.org>; Mon, 27 Jan 2025 21:33:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738013602; cv=none; b=AWnbGZ+jcI9WwGeUlh2fwveKCE3rilLEgia6aWfBksEO2fy2DfXjhKpgN75ywsXo7bZKiHp4is4wLcTDURQck5e9oWMtkrSq2dSgZknjoIbjJkNDboZ24vwkxVf5cwLJA65tEpblmtf9qqQy6OaO9+Rh+0jJ+WF7Gkbri8wVivU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738013602; c=relaxed/simple;
	bh=9oKiDkKvJTK4GGdONK6MHet9yz3DnsUwM+9HToGNX50=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=gZVwsJBEu152Ni2RqNFzuttZxyAQu+LgA/7ytMlytgmOozjrHfkrJpP/St3b2svneznSrs9ukfFrhFZnrljwTuWSWkdvaIrYrgHk6W9tot/rzXZ3n307K9xhKSU+31a+fQQcYTf+nWa5nE8qDpGOOarjtzzfdEy9F4TbrGZe04U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--wnliu.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=yDhCOPMf; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--wnliu.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2166a1a5cc4so91685125ad.3
        for <live-patching@vger.kernel.org>; Mon, 27 Jan 2025 13:33:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1738013600; x=1738618400; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Pei6TS7zN6KpP575svXWNqasjmENv16fLc/niEfJAUg=;
        b=yDhCOPMfodltR13UWMIv7sIsox1eerKhwIoM9xXiLbXmwYDFilPfGtkvkbhonBEZ2U
         T46UX0TlyqsoGJKgv246NpS58TE+780pa8xO4IoDMsEwTDp4bcUKmGRNCKkZuTdhXOfV
         ptE5ZFfP7bG7Af6diAF+PAxEPBleiY+JqmMAXc52ebDWekMMh+O2WUVaxFZgWrd9IjQ+
         LA40oXEUWDITAjs9MptIjpe5VfSFD6PCEWK0QoSRWQRljXhh80mkLrD7XDYr3mnfF4ao
         jgQhNDuqpy4007t8Lz3NzNKuGvc+hJfCGFANcUyZGFpurJMZ833GbsYij61z2c4UWhuF
         Ip/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738013600; x=1738618400;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Pei6TS7zN6KpP575svXWNqasjmENv16fLc/niEfJAUg=;
        b=oMbNFgRHByLwH2qo9KRZpCU4z6JDOt2J94mIbJcZeU7d3Z8eNpvk2bbjuaCFeT4j6d
         0tbkA+AG+qFeDW7Dkg3C59jKvMWZ5+EMnDIXNoZaA6QS8MRpaWkBSOHUfyjJMymh2+mh
         V0k3vqhXax+g20NftBwMexLuwFikmhtwSPQ05Wwd68m/1ITxDwN/J95m/gS9IGqfw0vm
         3gqIDsFQEy0yA6f3XKFOzVwIs7II54cLKlRfLlp4L/6mFTF+cHQJHxDrQBCix1o+p7tk
         Ex5zxMgX0Uj+YMfyaBKJgyOJ5WyZsShGV/z/utdaFchQK4sVGjjHsvSPm5aS5mUSO+Y/
         TJcw==
X-Forwarded-Encrypted: i=1; AJvYcCXygsQxgF+r6NKPd5pcviqjv+gGWDbQpQZUvLPObiGqTL1g8qNimT57gb8UDPEvD/4nPpXe/fux2kc4KP+Q@vger.kernel.org
X-Gm-Message-State: AOJu0YyY4LH5Yd5UR1NVhhm3YS+UBaui4MCqQe7xzMmXkoUpJo/a0zP3
	VkeD3lAWUBfHpOvFQ9wMj+1CkbfiOs+yPWzrJ/bhLut1BvPKKHnz1Ze46bukX3BbecgcYeax5w=
	=
X-Google-Smtp-Source: AGHT+IFd/Wq1OyJXHy44vPMMF9MYBDoQ3usrOzSenxsbZ2jr85PaygJtYqioTPHpK2O5SR75d+WNNDbIww==
X-Received: from pgbbk3.prod.google.com ([2002:a05:6a02:283:b0:7fd:55d9:1f1a])
 (user=wnliu job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:394b:b0:1e5:a0d8:5a33
 with SMTP id adf61e73a8af0-1eb21480ef0mr71993744637.18.1738013600344; Mon, 27
 Jan 2025 13:33:20 -0800 (PST)
Date: Mon, 27 Jan 2025 21:33:02 +0000
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.48.1.262.g85cc9f2d1e-goog
Message-ID: <20250127213310.2496133-1-wnliu@google.com>
Subject: [PATCH 0/8] unwind, arm64: add sframe unwinder for kernel
From: Weinan Liu <wnliu@google.com>
To: Josh Poimboeuf <jpoimboe@kernel.org>, Steven Rostedt <rostedt@goodmis.org>, 
	Indu Bhagat <indu.bhagat@oracle.com>, Peter Zijlstra <peterz@infradead.org>
Cc: Mark Rutland <mark.rutland@arm.com>, roman.gushchin@linux.dev, 
	Will Deacon <will@kernel.org>, Ian Rogers <irogers@google.com>, linux-toolchains@vger.kernel.org, 
	linux-kernel@vger.kernel.org, live-patching@vger.kernel.org, 
	joe.lawrence@redhat.com, linux-arm-kernel@lists.infradead.org, 
	Weinan Liu <wnliu@google.com>
Content-Type: text/plain; charset="UTF-8"

This patchset implements a generic kernel sframe-based [1] unwinder.
The main goal is to support reliable stacktraces on arm64.

On x86 orc unwinder provides reliable stacktraces. But arm64 misses the
required support from objtool: it cannot generate orc unwind tables for
arm64.

Currently, there's already a sframe unwinder proposed for userspace: [2].
Since the sframe unwind table algorithm is similar, these two proposal
could integrate common functionality in the future.

There are some incomplete features or challenges:
  - The unwinder doesn't yet work with kernel modules. The `start_addr` of
    FRE from kernel modules doesn't appear correct, preventing us from
    unwinding functions from kernel modules.
  - Currently, only GCC supports sframe.

Ref:
[1]: https://sourceware.org/binutils/docs/sframe-spec.html
[2]: https://lore.kernel.org/lkml/cover.1730150953.git.jpoimboe@kernel.org/

Madhavan T. Venkataraman (1):
  arm64: Define TIF_PATCH_PENDING for livepatch

Weinan Liu (7):
  unwind: build kernel with sframe info
  arm64: entry: add unwind info for various kernel entries
  unwind: add sframe v2 header
  unwind: Implement generic sframe unwinder library
  unwind: arm64: Add sframe unwinder on arm64
  unwind: arm64: add reliable stacktrace support for arm64
  arm64: Enable livepatch for ARM64

 Makefile                                   |   6 +
 arch/Kconfig                               |   8 +
 arch/arm64/Kconfig                         |   3 +
 arch/arm64/Kconfig.debug                   |  10 +
 arch/arm64/include/asm/stacktrace/common.h |   6 +
 arch/arm64/include/asm/thread_info.h       |   4 +-
 arch/arm64/kernel/entry-common.c           |   4 +
 arch/arm64/kernel/entry.S                  |  10 +
 arch/arm64/kernel/setup.c                  |   2 +
 arch/arm64/kernel/stacktrace.c             | 102 ++++++++++
 include/asm-generic/vmlinux.lds.h          |  12 ++
 include/linux/sframe_lookup.h              |  43 +++++
 kernel/Makefile                            |   1 +
 kernel/sframe.h                            | 215 +++++++++++++++++++++
 kernel/sframe_lookup.c                     | 196 +++++++++++++++++++
 15 files changed, 621 insertions(+), 1 deletion(-)
 create mode 100644 include/linux/sframe_lookup.h
 create mode 100644 kernel/sframe.h
 create mode 100644 kernel/sframe_lookup.c

-- 
2.48.1.262.g85cc9f2d1e-goog


