Return-Path: <live-patching+bounces-2562-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id eadJNeSr72lIDwEAu9opvQ
	(envelope-from <live-patching+bounces-2562-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Mon, 27 Apr 2026 20:33:08 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 69365478A29
	for <lists+live-patching@lfdr.de>; Mon, 27 Apr 2026 20:33:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 70FB53034A84
	for <lists+live-patching@lfdr.de>; Mon, 27 Apr 2026 18:31:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 235173EBF33;
	Mon, 27 Apr 2026 18:31:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="AwgLhmko"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 785413EBF39
	for <live-patching@vger.kernel.org>; Mon, 27 Apr 2026 18:31:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777314669; cv=none; b=vEEluyA1fRPuXOCuVys/r9aS2whwGk8ssakIxlWHBZyitTC1mAUovgU7f1yE3jNVAhhkimClRi2MqUXj/mjYIExFOgVsG9zMBM5yLKqjgrDvYTJvrHtw1VIGjjWMXVzSWJudS0JldbSzoIbirQ3u+GFoN72Tu0gRXS8B9wzHoK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777314669; c=relaxed/simple;
	bh=UTlYNp5mbd0LbF5vRrVO6ScM3O+gNgPXwFXJqh1/l5w=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=PFiRxTv2K/3RAqAZIcc1s3toGcB3Yvjua2PJv70R9cRod7hdyEobuzmKYGsPFv6gxADsPEFdiJEcb1ccljzQdZzq8b/U7ujWm8Hm474YDnC5LZOMJGC0jUGPFgiFuCDRbzPNoYCUhS/bCyNlxlqIs7grMmKIwqvEVfh/P5r4LPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=AwgLhmko; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-488b0046078so96525555e9.1
        for <live-patching@vger.kernel.org>; Mon, 27 Apr 2026 11:31:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1777314666; x=1777919466; darn=vger.kernel.org;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:from:to:cc:subject:date:message-id:reply-to;
        bh=7wqb7cmgBdl/lwe8M3N7TcsJokYHNGDsa9MhnK+ICQg=;
        b=AwgLhmkomTXYxYwePJzT53+9alRpUk8LXJaMXIuY8Fcz084C7CL6xcZNHA3kGAf1Cx
         IY8zx0kDE3o/HgBI6C0kUjRLjIH6v15mBaUUlddG7cM4OP1s7+/zRBY3gxHnFmnVJ7qa
         jfyYKHW6eV6kbnGGNM24sQFKJAm3p726pk1tnJ/HJvCNEbKDRL/O2M5f4cjVEtW4pdzA
         87cI9z1nNkjCM/W5CtLwz7LPQtdcBl0npm9ug/ITsZf+zotjp8PqMQqxjZ2uf+T4MlaR
         jpP60TcV9VvcVqjLTAeYZty01YUJ9S5XqoxmtgdEkIfNQ83sBYxXruVBVgKaNqcWpc2Q
         /e/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777314666; x=1777919466;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7wqb7cmgBdl/lwe8M3N7TcsJokYHNGDsa9MhnK+ICQg=;
        b=IuoqMTJlCd4h9Q5VhSPXNXmuIeAJvdXtGDEEFlIul4uVGCr1/Jt8DeU9GZTZst32pr
         yaoAeTSY9YfIPdwD9mVEM6lLlGxwKdkDRz0mo4dD6/Qi3bDm+d8NeaXSLzO6KzbWDMbw
         3a9KLiy+4lc0bUNomM6SKfGlx4/5R6pVXidTvutbGuAo6bCc/GHVBY9Eak4M+JAYvZB1
         RNerDFFPq74FBVW8UzXtsKodOa0dyQY5Nu1b0Gs8/bwIPPk6uF7h4QZRnXbAqJlRQFI4
         AsgtAnkZfhdetKaEwKIQv7tIHDKeG+BIKwTL2qiw96T0v0Lr5f+0ztNkhXTAjuNHZyV2
         U0BA==
X-Gm-Message-State: AOJu0YxanRTPAA+4rnwDSHGyxD7FYSh8AuW6uB9RZXgAb3K06E1HuIlN
	McjIEAwOAc9oINZiMbFtrNTiM8St152MOiG9bSK0+8JWC4+X54e0hR9jrRVT+QFGnkxlxZ6x/Y0
	mUxTtlbw=
X-Gm-Gg: AeBDieuS4sK6uybmDq42YZ3meaqjM+VNs0pz6CJNkNL7GXqvBA6SIawdLoZ/vOo/wmG
	Od/vbfFpDf5EVnrQhaRgThanXb8xk6905KbSUX05Sk5Q73jL11Ik6Xxh1wazZiV97oYZYAFNzTs
	eKeVC9W7gd3sGvuCAZbIP52BQckdIP5WBzb3DOKi/tpAs4h6Dg6Vqhn9et6NaPTRorPqyMq2W4k
	zbbjStHJZh4Kxz11lc43mrF2+KQ6EdurMM+YVqqJryyzbUWYYii1TXDkdfqDJS7WCmq9iHJKW5p
	wMkeszlnlpG3hqpgbGxJ86qATfwPhjGhPKmNi3ozZPRa0dxLpbE8a53epTzgqBr7ohGT73x96Yo
	hl3XXUF5k02dSmUl7M46HjzL+fo3xbfV04pjUl5OQumUF/NnScS4/hlMe8WPt1OMbwP0aTlc38h
	8YMf3yObkX5l9t5dOAKdtLTkmJDJxOM43Biw==
X-Received: by 2002:a05:600c:8b05:b0:48a:554d:b9a2 with SMTP id 5b1f17b1804b1-48a76f4b377mr6906985e9.6.1777314665606;
        Mon, 27 Apr 2026 11:31:05 -0700 (PDT)
Received: from [127.0.0.1] ([2804:1bc4:224:7800:585c:db3a:fcb:e21f])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48a7749cabdsm1182065e9.9.2026.04.27.11.31.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Apr 2026 11:31:05 -0700 (PDT)
From: Marcos Paulo de Souza <mpdesouza@suse.com>
Subject: [PATCH v3 0/6] kselftests: livepatch: Adapt tests to be executed
 on 4.12 kernels
Date: Mon, 27 Apr 2026 15:30:56 -0300
Message-Id: <20260427-lp-tests-old-fixes-v3-0-ccf3c90f744c@suse.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAGCr72kC/3WNyw6CMBREf4V0bU0ftogr/8O4oOVWapASLhAN4
 d9t0UQXujyZmTMzQeg9IDlkM+lh8uhDG0FuMmLrsr0A9VVkIpjQTLKCNh0dAAekoamo83dA6gq
 lSmP3YEVO4rDrYQ3i7nR+MY7mCnZIptSoPQ6hf6yvE0+99wGXvw4mThnNeWl15YwUSh5xRNjac
 CPJP4mPYffHIKJB6tzm1ijGtPsyLMvyBB3xARkHAQAA
X-Change-ID: 20260309-lp-tests-old-fixes-f955abc8ec27
To: Josh Poimboeuf <jpoimboe@kernel.org>, Jiri Kosina <jikos@kernel.org>, 
 Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>, 
 Joe Lawrence <joe.lawrence@redhat.com>, Shuah Khan <shuah@kernel.org>
Cc: live-patching@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Marcos Paulo de Souza <mpdesouza@suse.com>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1777314662; l=3039;
 i=mpdesouza@suse.com; s=20231031; h=from:subject:message-id;
 bh=UTlYNp5mbd0LbF5vRrVO6ScM3O+gNgPXwFXJqh1/l5w=;
 b=CFpb6LG4ZlnSp1ttI98UaYIMdEbMGbOR0QEhGt4KwLssd+Ik6ujKZiI2XpjtcFU42X6Fyc5vx
 BMY1anMQZ1pDxW2EFRBP8Rwatf7S0pGioyPNo0PEg3/9PH4L5t6Jdba
X-Developer-Key: i=mpdesouza@suse.com; a=ed25519;
 pk=/Ni/TsKkr69EOmdZXkp1Q/BlzDonbOBRsfPa18ySIwU=
X-Rspamd-Queue-Id: 69365478A29
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[suse.com,quarantine];
	R_DKIM_ALLOW(-0.20)[suse.com:s=google];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DKIM_TRACE(0.00)[suse.com:+];
	TAGGED_FROM(0.00)[bounces-2562-lists,live-patching=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[mpdesouza@suse.com,live-patching@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_SEVEN(0.00)[10];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.com:dkim,suse.com:mid,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,msgid.link:url]

This is the third version of the patchset, now with far less changes. There
are still somethings that I would like to work next, like adapting the
newest test introduced in the last submsision, but this is something for
a new iteration.

Original cover-letter:
These patches don't really change how the patches are run, just skip
some tests on kernels that don't support a feature (like kprobe and
livepatched living together) or when a livepatch sysfs attribute is
missing.

These patches are based on printk/for-next branch.

Please review! Thanks!

Signed-off-by: Marcos Paulo de Souza <mpdesouza@suse.com>
---
Changes in v3:
- Patch 1 was changed to reorganize the ifdeffery to handle multiple archs syscall wrapper (Miroslav)
- Patch 3 was changed to rework the commit message and to address function naming (Joe)
- Patches 4, 5 and 6 where had the commit messages to include the kernel version where
  the given sysfs attributes were included (Petr Mladek)
- Link to v2: https://patch.msgid.link/20260413-lp-tests-old-fixes-v2-0-367c7cb5006f@suse.com

Changes in v2:
- Patch descriptions were changed to remove "test-X", since it was polluting the commit subjects (Miroslav Benes)
- Patch 8 was dropped since it was checking for a message from an out-of-tree patch. (Petr Mladek)
- Patch 3 was dropped as should be treated as expected failure for older kernels. (Petr Mladek)
- Patch 2 was changed to use y/n instead of 1/0, since it's more natural to use it.
- Patch 1 was changed to handle ppc and loongson, and error out if dealing with a different architecture that sets
  CONFIG_ARCH_HAS_SYSCALL_WRAPPER and haven't changed the test to include the proper wrapper prefix.
- Patch 4 was changed to invert the return of the bash function to return 1 in failure, like
  a normal bash function (Joe Lawrence)
- Patches 5, 6 an 7 were changed to not split the tests, but to only run the tests
  when the attribute were present (Miroslav Benes)
- Link to v1: https://patch.msgid.link/20260313-lp-tests-old-fixes-v1-0-71ac6dfb3253@suse.com

---
Marcos Paulo de Souza (6):
      selftests: livepatch: Check for ARCH_HAS_SYSCALL_WRAPPER config
      selftests: livepatch: Replace true/false module parameter by y/n
      selftests: livepatch: Introduce does_sysfs_exist function
      selftests: livepatch: Check if patched sysfs attribute exists
      selftests: livepatch: Check if replace sysfs attribute exists
      selftests: livepatch: Check if stack_order sysfs attribute exists

 tools/testing/selftests/livepatch/functions.sh     |  10 ++
 tools/testing/selftests/livepatch/test-kprobe.sh   |   8 +-
 tools/testing/selftests/livepatch/test-sysfs.sh    | 120 ++++++++++++---------
 .../livepatch/test_modules/test_klp_syscall.c      |  27 +++--
 4 files changed, 104 insertions(+), 61 deletions(-)
---
base-commit: b8e6ad22f78aa279dece2f86efe6429953d36452
change-id: 20260309-lp-tests-old-fixes-f955abc8ec27

Best regards,
--  
Marcos Paulo de Souza <mpdesouza@suse.com>


