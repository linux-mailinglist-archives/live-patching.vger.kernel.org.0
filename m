Return-Path: <live-patching+bounces-2600-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id +MMRLUAZ8mljnwEAu9opvQ
	(envelope-from <live-patching+bounces-2600-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Wed, 29 Apr 2026 16:44:16 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id DACA64960D2
	for <lists+live-patching@lfdr.de>; Wed, 29 Apr 2026 16:44:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id D5E3A300A5A4
	for <lists+live-patching@lfdr.de>; Wed, 29 Apr 2026 14:35:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E2B5369985;
	Wed, 29 Apr 2026 14:35:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="gb/2mZoI"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE60135B634
	for <live-patching@vger.kernel.org>; Wed, 29 Apr 2026 14:35:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777473330; cv=none; b=mHBDiF7n71z/iWgpx4KdaLApG8KmDKiKBF+ycuNYn85pvzUNqQZXSqmvGboHcoPG0c8NoSOpDMnuyiOf2MZCbyykTOrz6Fe+ppNC5JIUAwAzwVvpRHU5FVvnvG0DMfIyh9kagBhaBpOUInhzFApHZGh1XMrZo+eMcH1+aX1qRt4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777473330; c=relaxed/simple;
	bh=pLz6jjDt3oVX0vZwPGXcR+Jm8CR4vEEQP0LB5b2GZUE=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=siVlhTW0uzmo2nnO3f5Qg4yagd9lHjEcLNtZ1WnNjikr77m430AGzaDtc+BArAZnBHb8/RUchINjTjydjQ9sa5DXM/sqTcdUVbSdc+P73G7ABaNIUvCIj9VlFY9/QKn34C6k3yOv9DcjspDsWS/hab/hUfsyuhn+YHJG7eexZq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=gb/2mZoI; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-488b0046078so114341405e9.1
        for <live-patching@vger.kernel.org>; Wed, 29 Apr 2026 07:35:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1777473327; x=1778078127; darn=vger.kernel.org;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Y51zaDTB8kvehUPw4hj3xyT4d7Oh4tjGjtgNyZysarw=;
        b=gb/2mZoIwet2i2m8V+4vHddfrd0se9rADJXoEb3fX12fh1O2IJE0jkns6dzKbj9FBc
         toCoz4oo3O3Zn8i9VXhZCDnSq8SS5WMdmmcikbc/l7fURVOhgY9T3KveAhvkIsPIVWmr
         oKhc0Br8CRo48qWclHPS3/O4I2+G49QMlc2g4IoFtUm9xGMz4eQkjaelBJmdt8Noieqv
         aezl9VSSzGbM9I1o11TQhsPLVoqbhceeq6aNng13lG5Iq7l8ozX4KYa8IKJwVcySU+B2
         iGOvTM79udT9KePn8X7bOkl/UlO2ydYPb9j14l8S7XE9AfhjL/RILaVeUHM56wU6oyke
         oDOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777473327; x=1778078127;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Y51zaDTB8kvehUPw4hj3xyT4d7Oh4tjGjtgNyZysarw=;
        b=jR1FxwMAanTZOTWfCe9+jA0Ls1kBK2n4fSxBncncZ7VER0RoQmUPNUIwXtWGp7Tdsn
         vbbSPGPoxoC/7z/IhreyszG8mOUcTD7IjGvi0Z9LS8UeXuPJztsiJpVocf9YuKS7adSi
         Zqp43oYiHpG1PSIOf8QzsiD657XPySeer5dZ7vHzxLQka2Bldn0BJd+tEsbAzWZKxrnf
         LmKoUbGVY148MDzEFtbjBQBVKa4UXwJkAxo3yY4UuqHFpQhcfLdEdOfqgOHz9J/8oFCN
         LXGdVyBDFNDb5gga8OtbqxWSQbe/PKcx3LWHwMrHAJ22wuZSiVMIYhonMldRsouJCl1Q
         vuiQ==
X-Gm-Message-State: AOJu0Yy2BODoG7cIitYcEMAUnEWBm8M6+8ZgVP+BSGOeGjqi0VyVvPs0
	YD3ytOkyqBWoB/b6NTy1HmU0hljl3PRTvLujVrMX5ZrosNJaFdneIsAKvMLoq5kK0mU=
X-Gm-Gg: AeBDieug7LTKd9XsiY1FG6rNvMjFj6TpwEOXYb2KcMxjMIjc0cSk1JEj/v2hIA+4kTI
	U0CqzfdCHIO20Y3+ubyQRXzMbpudTl8+VId9AxC0a+qDuVNm9Dxi2pttrxwJCo0np1/yzlz8Vip
	HAlSE8qlWh3HcRm5pMTkjVjqu3+IFMRHhiAW93thd+H+ytOmkc4A67OJFAMKAQro7WBrSMuJ1a6
	h/FkgQGD7II6LvyoAWPz+7H5o9jIpFB8COWUE0A+z5cCZrY9BLnqCMrFfORvo5IS0eJzZ2jJhr4
	9Sb/JlKmyE2Nu8WnOJVksxvkTKn2QhmIiqu0eDaDrAXOQCgfkCiIyaMpMfMc5+QWo6XD3IEUChO
	Goyr2iHpgQaOLQkhWCyLuf4CgmIrgVg0SFTHur1BMP+pLzFIAWrUOrJXdoLtFJH5Depct+4DX0+
	eLI6aM1PHiJgu2kTJ1boP354CAmFQsNNXQOg==
X-Received: by 2002:a05:600c:8b2f:b0:48a:58ae:9933 with SMTP id 5b1f17b1804b1-48a77b1990dmr123430755e9.18.1777473327066;
        Wed, 29 Apr 2026 07:35:27 -0700 (PDT)
Received: from [127.0.0.1] ([2804:1bc4:224:7800:585c:db3a:fcb:e21f])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48a7c305371sm19982835e9.18.2026.04.29.07.35.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Apr 2026 07:35:26 -0700 (PDT)
From: Marcos Paulo de Souza <mpdesouza@suse.com>
Subject: [PATCH v4 0/6] kselftests: livepatch: Adapt tests to be executed
 on 4.12 kernels
Date: Wed, 29 Apr 2026 11:35:14 -0300
Message-Id: <20260429-lp-tests-old-fixes-v4-0-59b9741989d0@suse.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIACIX8mkC/3XNQQ6CMBAF0KuQrq0pLVBx5T2MCzpMpQaBMEA0h
 Ltb0ERicPkz898fGWHrkNgxGFmLgyNXVz5Eu4BBkVVX5C73mUkhE6FEysuGd0gd8brMuXUPJG7
 TOM4MHBCkZr7YtLgcfO98eWfqzQ2hm6X5o3DU1e1zWR3C+e8zEKqtgSHkguswgyS3RslYnagn3
 EN9Z7M/yK8Q/RGkF1SiQYOJhUjsj6BWgtSbgvICgFWQCqujCFbCNE0vp4SP90kBAAA=
X-Change-ID: 20260309-lp-tests-old-fixes-f955abc8ec27
To: Josh Poimboeuf <jpoimboe@kernel.org>, Jiri Kosina <jikos@kernel.org>, 
 Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>, 
 Joe Lawrence <joe.lawrence@redhat.com>, Shuah Khan <shuah@kernel.org>
Cc: live-patching@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Marcos Paulo de Souza <mpdesouza@suse.com>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1777473323; l=3307;
 i=mpdesouza@suse.com; s=20231031; h=from:subject:message-id;
 bh=pLz6jjDt3oVX0vZwPGXcR+Jm8CR4vEEQP0LB5b2GZUE=;
 b=RvFJ8ZATzZZSn/ENJQW7KgJdICCNvPTpq2TqDO7YdfWGh1dexHKCGyWZcjuBPyXwO1JCpvZxl
 rkA673k+5/ODysfhLJfqF+TTTyT+vNUNy7m2MKV0iwr6QCyXwEKMxIe
X-Developer-Key: i=mpdesouza@suse.com; a=ed25519;
 pk=/Ni/TsKkr69EOmdZXkp1Q/BlzDonbOBRsfPa18ySIwU=
X-Rspamd-Queue-Id: DACA64960D2
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[suse.com,quarantine];
	R_DKIM_ALLOW(-0.20)[suse.com:s=google];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DKIM_TRACE(0.00)[suse.com:+];
	TAGGED_FROM(0.00)[bounces-2600-lists,live-patching=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_SEVEN(0.00)[10];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.com:dkim,suse.com:mid,msgid.link:url,sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]

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
 tools/testing/selftests/livepatch/test-sysfs.sh    | 222 +++++++++++----------
 .../livepatch/test_modules/test_klp_syscall.c      |  27 ++-
 4 files changed, 155 insertions(+), 112 deletions(-)
---
base-commit: b8e6ad22f78aa279dece2f86efe6429953d36452
change-id: 20260309-lp-tests-old-fixes-f955abc8ec27

Best regards,
--  
Marcos Paulo de Souza <mpdesouza@suse.com>


