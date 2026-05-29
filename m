Return-Path: <live-patching+bounces-2922-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id CDjlIFsMGWp4pwgAu9opvQ
	(envelope-from <live-patching+bounces-2922-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Fri, 29 May 2026 05:47:39 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D9BD85FCD19
	for <lists+live-patching@lfdr.de>; Fri, 29 May 2026 05:47:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 4DC1E30302B5
	for <lists+live-patching@lfdr.de>; Fri, 29 May 2026 03:45:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F68678F26;
	Fri, 29 May 2026 03:45:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pPrfV8lm"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3729347BDC
	for <live-patching@vger.kernel.org>; Fri, 29 May 2026 03:45:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780026357; cv=none; b=cBI2SXvmgplmoo0v2vjxbmjICngZJ2VAAKjowNjj3DF21yDWjCFLBg1DTZE9GVW0yeotPcN6gPRDWlVzu9IsqMkzxZDxOLP3oWazCNt74bmx5vez2BGFeWryVJjo6NM/gwKwm0Waniqk8kBvrEZREt2Zt4aXiV/5BysQLTAwwvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780026357; c=relaxed/simple;
	bh=9yVIst7gZcitXaif6DnzpvVAHecKQ4aPa2my/I9p+BA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=jHbCduboXQWx4TmhCzgGd1v2umlB3UN+gWQqTkv4bX2db21zBjnczDMGq3i/hcTBy4CTbAoRQywpK6CWaJxBJ4bGaObixL+EXFrtEVUXYAZf7hX3OuxOB4Bzx47b53buFhmQsxTgXAmbc4HXwTkVM8oA5cr8xXpFAsACDGiV/c8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=pPrfV8lm; arc=none smtp.client-ip=209.85.216.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-36ad15213fbso3063031a91.0
        for <live-patching@vger.kernel.org>; Thu, 28 May 2026 20:45:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780026355; x=1780631155; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=rt9kwH6gXZB0plCEZBqOHaOMw9QXE3YVFbfNBohKr+Q=;
        b=pPrfV8lmvW02KfqdIvpxdFq2WIIB1TcEvukMhR6q2zOgl01i8sDL+H8XG8FN/RaiaZ
         By07J3kms4ELRkssCBl4wYCzjf2VlW83uPJkQJjYzMzMKIFGXkLxN4b5mzXMiadzJlHM
         e9AFqUCgFoAC8M06tN9Qyo1B6o07/scr7hFA0FuxslSfFhBFPN5XUQUahjjFbV+U7vFv
         yZ0NhrkN3wOP5yKsXS/SZVnyzA9WpxKJvdabrCNXZLVUiy0q+x6xC1p0zG1oRLSJ4b1q
         rUTNYbPqAxGyaRGAvoRnz7O/jMJpnHbBGeDyub+enQxCE4YJqDoz73d6xl/mp6mBuHL9
         IRkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780026355; x=1780631155;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rt9kwH6gXZB0plCEZBqOHaOMw9QXE3YVFbfNBohKr+Q=;
        b=bw7ggpiQyYHUOEi/MhXf8ewZmQ23zNz6n/i9Nm5uqy7G7LjwV1Of3Z/hryLSyiYj3Z
         M7CFtOx3pXDf49hAsVy+jc25JuVKugsbrOA48QDxEWR6VVA1QuZIU/Wh+rVmRi1BSNJ4
         61j0seQErHSSgHdWC3vm3AKH+RKGsYuEXijGgWzf/gyimOSCk1ZfUUbahA/ajxLVzEbS
         uddQ5eYTRV/1XotuJetqiu+lHjz3OxFVyyv9wM5FMadTJyfAfwnxXhXZWDSue8Y8ybgp
         tlHtXK2Ge7NTrjgUUxNDYqFiiA0e9YyJpvuC13KDqIKij+GFU439cp/uAqDXI3dpvDHK
         9yYQ==
X-Gm-Message-State: AOJu0YyAHax0Tgw7/6WkI5vi1Bxg7C4+7HDonIHSjC8Lw6WjLmylESJy
	DnCtn0VdEO0H6p/DgGxYFKA9C9jKWDoMPOzTNQ9DU2yDEQRZ7lkQdEHS
X-Gm-Gg: Acq92OHx5DNvwc6BtKBBCaowlVDvt/qq/nysDvJgUnCXx5jfv+8x0IWpDR/hFgMXRwI
	cU4XSCTMGl9MhaWG9U1NSwJmFxKn4vlJdGKgLOcl/uOjLfX/u/IGPTuliiphJPmGShZlY3f331U
	2Jv4khyNCCH6Wb86MMpXyFS/1D768O/VpoMxPXIYNBSd9G4LrGC2yi2elJ+b2JtuMifeKAoZOWY
	S8Jq/xcgGBKXvM2ERtnxm4aodtkCIhWdaCLxm+WlwnOTrhqCq4iyDs3d/S43oqpBrx6eHqogOqP
	tuXfcB6vhaa01KGP4JOiSDV0nTqGjzMlDI29cFbPds42kZCHH95i1Zf6BTBV7TSD30Mf9THv1cV
	gPs1ysAq+12W0xAcdvTSLDjIJ/EN4lR2VNzFonvDrUk28REOG4clNVmstyahjlFY66VSU7Opb6C
	RM3apFhj/++GeFRu63XDYnJwVMVXkGpjAO0iR0v3uJvAy7BFJmjBmL6XBhvyW+nW5GqdAsZwMRt
	G420iit4gOsXAVHP1Yjmhcdqkg=
X-Received: by 2002:a17:90b:2687:b0:368:147f:bd27 with SMTP id 98e67ed59e1d1-36bbcfe8647mr1420050a91.23.1780026354874;
        Thu, 28 May 2026 20:45:54 -0700 (PDT)
Received: from localhost.localdomain ([240e:46d:2000:3837:ec96:b29a:f0bb:6d68])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-36bc6a340b7sm298385a91.11.2026.05.28.20.45.51
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 28 May 2026 20:45:54 -0700 (PDT)
From: Yafang Shao <laoar.shao@gmail.com>
To: jpoimboe@kernel.org,
	jikos@kernel.org,
	mbenes@suse.cz,
	pmladek@suse.com,
	joe.lawrence@redhat.com,
	song@kernel.org
Cc: live-patching@vger.kernel.org,
	Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH v2 0/4] livepatch: Introduce replace set support
Date: Fri, 29 May 2026 11:45:38 +0800
Message-ID: <20260529034542.68766-1-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-0.16 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TAGGED_FROM(0.00)[bounces-2922-lists,live-patching=lfdr.de];
	RCVD_COUNT_FIVE(0.00)[5];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_CC(0.00)[vger.kernel.org,gmail.com];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[laoarshao@gmail.com,live-patching@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[8];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	DKIM_TRACE(0.00)[gmail.com:+];
	TAGGED_RCPT(0.00)[live-patching];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Queue-Id: D9BD85FCD19
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

We previously proposed a BPF+livepatch method to enable rapid
experimentation with new kernel features without interrupting production
workloads:

  https://lore.kernel.org/live-patching/20260402092607.96430-1-laoar.shao@gmail.com/

In the resulting discussion, Song and Petr suggested adding a "replace set"
to support scenarios where specific livepatches can be selectively replaced
or skipped.

This patch introduces 'replace_set' to provide finer-grained control over
livepatch management. The core rules and behaviors of a replace_set are
defined as follows:
- Livepatches sharing the same replace_set can mutually replace each
  other.
- Only one livepatch within a given replace_set can be active at a time.
- Livepatches belonging to different replace_sets can coexist on the
  system.
- Livepatches in different replace_sets are prohibited from modifying the
  same function.
- Livepatches in different replace_sets cannot use the same state ID.

Additionally, this design deprecates the traditional non-atomic-replace
model. Previously, setting 'replace' to 0 was the only way to keep
certain livepatches persistent on the system, forcing developers to
disable atomic replacement entirely. With the introduction of replace_set,
developers now have a selective option to keep specific livepatches
persistent while maintaining atomic replacement capabilities elsewhere.

At present, KLP state, shadow variables, and callbacks are not integrated
with the new replace_set mechanism in this patchset. Support for these
features is deferred until Petr's klp-state-transfer infrastructure is
completed and merged:

  https://github.com/pmladek/linux/tree/klp-state-transfer-v1-iter12

v1->v2:
- Incorporate feedback from Petr:
  - Initialize replace_set to 0 by default
  - Improve documentation
  - Enforce that livepatches in different replace_sets cannot use the same
    state->id.
  - Enforce that livepatches in different replace_sets cannot modify the
    same function.
  - Ensure consistent capitalization and naming usage of KLP_REPLACE_SET.
- Incorporate feedback from Sachiko AI:
  - Skip the klp_transition patch during klp_force_transition().

v1 (RFC): https://lore.kernel.org/live-patching/20260513143321.26185-1-laoar.shao@gmail.com/

Yafang Shao (4):
  livepatch: Make klp_find_func() non-static
  livepatch: Support scoped atomic replace using replace_set
  livepatch: Deprecate stack_order
  selftests/livepatch: Update tests for replace_set

 .../ABI/testing/sysfs-kernel-livepatch        |  6 +-
 .../livepatch/cumulative-patches.rst          | 23 +++--
 Documentation/livepatch/livepatch.rst         | 21 ++--
 include/linux/livepatch.h                     |  8 +-
 kernel/livepatch/core.c                       | 52 +++-------
 kernel/livepatch/state.c                      | 51 ++++++++--
 kernel/livepatch/transition.c                 | 11 ++-
 scripts/livepatch/init.c                      |  6 +-
 scripts/livepatch/klp-build                   | 16 +--
 .../selftests/livepatch/test-callbacks.sh     | 33 +++----
 .../selftests/livepatch/test-livepatch.sh     | 98 +------------------
 .../testing/selftests/livepatch/test-sysfs.sh | 91 +++--------------
 .../test_modules/test_klp_atomic_replace.c    | 10 +-
 .../test_modules/test_klp_callbacks_demo.c    |  6 ++
 .../test_modules/test_klp_callbacks_demo2.c   | 10 +-
 .../test_modules/test_klp_livepatch.c         |  6 ++
 .../livepatch/test_modules/test_klp_state.c   |  2 +-
 .../livepatch/test_modules/test_klp_state2.c  |  2 +-
 18 files changed, 165 insertions(+), 287 deletions(-)

-- 
2.47.3


