Return-Path: <live-patching+bounces-2697-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id eF0eJeDm+Gmt2wIAu9opvQ
	(envelope-from <live-patching+bounces-2697-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Mon, 04 May 2026 20:35:12 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id E985E4C29A7
	for <lists+live-patching@lfdr.de>; Mon, 04 May 2026 20:35:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id F256C3031E90
	for <lists+live-patching@lfdr.de>; Mon,  4 May 2026 18:35:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB1383E6385;
	Mon,  4 May 2026 18:35:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="arjgYJxT"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5486F3DFC60
	for <live-patching@vger.kernel.org>; Mon,  4 May 2026 18:35:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777919705; cv=none; b=kRJ6DzK6EJWjMKFkdFIkefgHCJC/VklAD5tZO8L88CejZBlu68vyETnsLW12pboMxYU8+PU8iU8VQ8ZS4LmZK+hrWrGevFBPoBRq7CChuYJ8I9w0DRluO8Dd6jg3bRm6kLg8OkeExg41+xblR82XpkAhlCM39PbM4Y/XRjDjTug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777919705; c=relaxed/simple;
	bh=ZCXzVLh7k8zrxOkjneqBq8c3or63s58jUjGXB11l9rc=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=TBgYTLWf1n04dDCxzVtd7QZx9+2vzGpP3TFukmiMYfqBUonbIsvzeCf5+f0KOzMIl6A7/AYmvIJ4Z+hhzNe9YJefJ8OVVg3zHhQN0sM1BjK/MUEXqHYsujMl4g431UpMW8L5LQQworbtv9D6rb6Q9r5+PqHNfdzCWMFRTF10lv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=arjgYJxT; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-48a3e9862f0so29227035e9.1
        for <live-patching@vger.kernel.org>; Mon, 04 May 2026 11:35:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1777919702; x=1778524502; darn=vger.kernel.org;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:from:to:cc:subject:date:message-id:reply-to;
        bh=QYU5gYFLbPPaf5T/z0eHuDOOHmWqKUG7f093weSaqao=;
        b=arjgYJxTcRnA5uO9GCLh3iTIoisqWT3QCiwotvFMgh57kwxkxK/3NAbq0VaNh9SUHf
         6z45+PttjAXzKxJ1mIVLB/vhj0qw0kWPFyTMMWIjMJ2btO77u6wxrSClgePaXHVOAh3y
         OtKH9DK5+DrDVJfW2b9NaC7jHIqnCXfZ2Kj0tIUHdksb5m3YW/wYJDssVujSxuANYW9+
         Hiyts2ApipT4gb0ulc/hNsljYCiEZTVs2eq5lemWfRLwvl2GDg3VFrvqpu/dYz+W6D56
         xZ2ARV907oVDymwwD6wqUr5s3ZYPYhgqqGv5xVc/++jQPAxe4d7FT1kjx6+XB4dI5wXK
         XFug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777919702; x=1778524502;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QYU5gYFLbPPaf5T/z0eHuDOOHmWqKUG7f093weSaqao=;
        b=p7IBAA8CoAuTsHpSGWXKnhdYcHdbYu9QZLMqSzKxdfoTCfnOS6+fiFuJHfOYELtLxi
         IME9ERKX+ebTGZ3XGkjGeGktllq53T9Vxj7tkQqLfXVctQjegy2Yleywkk79zoRoLDfA
         /hHjnUGTAmVgCeYYSpWAMt8zkaSpcarJNEl/x3xs0OUR+ew0gvEq6Fiw0ngUEwCiLmEo
         JOr7JtdW1SXlVplKzVjUP+VSI78l/1MEcE1Qz4oTSMMNdcL/6siF9Bi05SnjKgKTD3u6
         YXFMuFpb1HkNbDw1WYHvIjJO2h4FT1YZhqHtrdF3q+YUBRgpxT6MLyMdFJ5dqZ7QvFaY
         +6hQ==
X-Gm-Message-State: AOJu0Yw04Qbk/mahK3sDKHdad3Stn9aat2QNt5B/U7MnFblFVwUe0l2+
	4z8MdGtNmjl/Ge4hi37+tFPCcwjaEqSGjEd2ppTDX5qvcnkjUi0k0p6tVZfOHQKlXPSc1xU8j3l
	kNPJqASA=
X-Gm-Gg: AeBDiesZLYSkUgg0sBUV58cRSibUlqv2wT3SiEiKJ6bj3pSOKIpjf2HBiAUAxvAzYwG
	N9vt4nckKEKxaUd1S/ZDaYkk6PVUVUu7kDT/nUrvyBu68tToWYgVBUcwnTJGP+VrK5E8TCJCUP0
	EvOPcZ7iZuzyvCAHil2ITfffPatzdGbcpgoGDKWhQf6oxRnZ20a+3NPXiwcnhPTvYoWZAavux4E
	ANblRKA2ExSTQ/06JCPKGAtP4Jf8dDwRkNJFl4pDB8lE62ulMP8e94QhfekfLZvcqPMZ6zk54Iw
	u01A3OFmOdlMU1YPmQyWLuAgkjc/O8kPpBkKvWscrvOHy5ethNPQcMXL6LF1ihDa/KhxQ5IkA9W
	l7S4iGpFiPhtf9Ov7lzoX8fG4sR0oo1LaCcVMGXHl+299K2IQTkon9vkvq5xhlSwQdjwVqAwH9u
	LM4aD4wqPxoKkFBxwwHkHt6DHIrK2jK8bCYQ==
X-Received: by 2002:a05:600c:4b1a:b0:488:8be1:ca3a with SMTP id 5b1f17b1804b1-48d142726f3mr8222095e9.15.1777919701737;
        Mon, 04 May 2026 11:35:01 -0700 (PDT)
Received: from [127.0.0.1] ([2804:1bc4:224:7800:585c:db3a:fcb:e21f])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-44a98b76eddsm26745511f8f.34.2026.05.04.11.34.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 May 2026 11:35:01 -0700 (PDT)
From: Marcos Paulo de Souza <mpdesouza@suse.com>
Subject: [PATCH v5 0/6] kselftests: livepatch: Adapt tests to be executed
 on 4.12 kernels
Date: Mon, 04 May 2026 15:34:41 -0300
Message-Id: <20260504-lp-tests-old-fixes-v5-0-0be26d94ab9a@suse.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAMHm+GkC/3XQ3YrCMBAF4FeRXBvJb2O88j2WvWimE42olU4Nu
 0jf3VQFi9TLw8x8B+bGCLuExDaLG+swJ0rtuQS7XDDY1+cd8tSUzJRQldDC8+OF90g98fbY8Jj
 +kHj01tYB1gjKsXJ46fAxKHc/v89M13BA6Edp3Ngn6tvu/9Ga5bj3KpB6riBLLriTNVRNDFpZv
 aUr4QraExv9rN6C+SKoIujKgYNghajih6AngnKzgi4CQNTgRXTGwIdgpsLsm7IpgvXBOyP92jd
 iIgzDcAdlZHgniwEAAA==
X-Change-ID: 20260309-lp-tests-old-fixes-f955abc8ec27
To: Josh Poimboeuf <jpoimboe@kernel.org>, Jiri Kosina <jikos@kernel.org>, 
 Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>, 
 Joe Lawrence <joe.lawrence@redhat.com>, Shuah Khan <shuah@kernel.org>
Cc: live-patching@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Marcos Paulo de Souza <mpdesouza@suse.com>, 
 marcos@mpdesouza.com
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1777919697; l=3566;
 i=mpdesouza@suse.com; s=20231031; h=from:subject:message-id;
 bh=ZCXzVLh7k8zrxOkjneqBq8c3or63s58jUjGXB11l9rc=;
 b=gXqdpOaKgu7MoxLhRVsNKp5jGTOcZw7OA8dCObU23wSMhZ7QeQZHbKDJo7eX9c2+UUEVPZnBp
 r+Olb9yDqXDDT4gJ9138OmL35+TxzgQO8JsBLSJAXRvT3ssECiUKsJs
X-Developer-Key: i=mpdesouza@suse.com; a=ed25519;
 pk=/Ni/TsKkr69EOmdZXkp1Q/BlzDonbOBRsfPa18ySIwU=
X-Rspamd-Queue-Id: E985E4C29A7
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[suse.com,quarantine];
	R_DKIM_ALLOW(-0.20)[suse.com:s=google];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[suse.com:+];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2697-lists,live-patching=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[mpdesouza@suse.com,live-patching@vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_FIVE(0.00)[5];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_SEVEN(0.00)[11];
	TO_DN_SOME(0.00)[]

This is the fifth version of the patchset, which fixes the last Sashiko
comment, about overwriting MOD_LIVEPATCH global variable and using a
local variable to avoid module load clashing when an older kernel
don't support some sysfs attributes.

Original cover-letter:
These patches don't really change how the patches are run, just skip
some tests on kernels that don't support a feature (like kprobe and
livepatched living together) or when a livepatch sysfs attribute is
missing.

These patches are based on printk/for-next branch.

Please review! Thanks!

Signed-off-by: Marcos Paulo de Souza <mpdesouza@suse.com>
---
Changes in v5:
- Edit the last three patches to avoid overwriting MOD_LIVEPATCH
  variable, using a local variable. This fixed the last Sashiko report.
- Link to v4: https://patch.msgid.link/20260429-lp-tests-old-fixes-v4-0-59b9741989d0@suse.com

Changes in v4:
- Patch 5 was changed in order to address a comment made by Sashiko, where
  subsequent tests rewrite the variables that contain the modules being loaded.
- Link to v3: https://patch.msgid.link/20260427-lp-tests-old-fixes-v3-0-ccf3c90f744c@suse.com

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

 tools/testing/selftests/livepatch/functions.sh     |  10 +
 tools/testing/selftests/livepatch/test-kprobe.sh   |   8 +-
 tools/testing/selftests/livepatch/test-sysfs.sh    | 219 +++++++++++----------
 .../livepatch/test_modules/test_klp_syscall.c      |  27 ++-
 4 files changed, 153 insertions(+), 111 deletions(-)
---
base-commit: 712c0756828becbfc629ff8d8b82deff5d1115e4
change-id: 20260309-lp-tests-old-fixes-f955abc8ec27

Best regards,
--  
Marcos Paulo de Souza <mpdesouza@suse.com>


