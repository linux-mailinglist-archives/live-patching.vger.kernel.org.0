Return-Path: <live-patching+bounces-222-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 9EFC289AE5B
	for <lists+live-patching@lfdr.de>; Sun,  7 Apr 2024 05:58:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4814FB2164D
	for <lists+live-patching@lfdr.de>; Sun,  7 Apr 2024 03:58:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A44D417C9;
	Sun,  7 Apr 2024 03:57:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eaCgJTlP"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A7035223;
	Sun,  7 Apr 2024 03:57:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712462275; cv=none; b=K6sy0W2mNnaUT9F6AYJCB3r11XeBUI/TCfzhzNSX6yyqZSZ9jcchmGK07aBGshzDmf7a7ul/YLxevtYHWeKuGW7+yCMAD85g6WKqWKVGw0IsTRvlotYtU5tcwgErzzRo0Mr8XUFyYq7zvZBHcp/RTft3CxTIwP9pDHuLO/oNy50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712462275; c=relaxed/simple;
	bh=5P3gyt6luPPmfXUIYtr4EbBZQlM9LMkhta9MdN5aLvk=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=amk03j2dAGaWEEypcvN9MbeHfF+PEmyNhBuy25qyfXNM64iwDc6x1pkBtpqWUteDzDk6i66IRwildnObyassOJiasV2cUTOfXOqqLAHTtnpi0ZnKgdkS8qg9+yqTUDX7FzpmGL9OTYmDCP1xHbOQCp2EOuZZTCigThqmO7VEL3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eaCgJTlP; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-6ed01c63657so1514352b3a.2;
        Sat, 06 Apr 2024 20:57:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712462273; x=1713067073; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=CgyjkDSOKWkKDlPYOBX1onNWU+LLIX1Y1moNUFn/Dh4=;
        b=eaCgJTlP9vIqsOf+H9nq3XZDhRB6t/lHcqaWQ0JjSZfklBH/8FK1RakS5af9tpGHId
         4ini+1gG59iTmslf9lomkfVoFHxLNlOXlidfmBAAWPEG7iJo0sZphLVEgxJ5NxqeUDzr
         KYiM8uFsdl1rJatem0w5oDHaJ8UkhCOMnccwEwovcNlMw5JHN5rLv14imMjtfdiFS00Q
         Ghj/8hvrNcco3QyDWtn0KRO3sWBvKAVsieYOAuVmhxrC6Ub7Aj0Fbv3aPmsc5DQe85JP
         l/qCB4z/WMbfaBqj84oBGvkqUW4sBx6iHczmHdfttaphlFehFoez+SP14181NwKxTu5f
         GO1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712462273; x=1713067073;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CgyjkDSOKWkKDlPYOBX1onNWU+LLIX1Y1moNUFn/Dh4=;
        b=jJFbk087z3yf4/3q99an9iK6Du5tq5HubRRnHMj8smvbyPvltC1+xS33N5p01K2ntc
         +tAMtmqCMjZxFO0jKecqHwSUM0RH83lb4ZJAiBJWc9TJB0UsClc8h8980zphMaGIvHMe
         tRKG9zza5XhCl7cOXN1DhLgKoxK/D537MDW6NJMGMWEm9C6bfjtVDgkdgekAhZjGyj6Q
         i4WM07Lx1QU7epb70cH9b5f8WEjTApiwGSYgDRLikqwtVSEFb5R86k9LnXT8VGAIDGvV
         xINzW+weFt+KRotBNQ1aezqiCf/qIEhU4scaXwsyKbSy0WjSNeEvcPaxv9R9Aap5W/rd
         4/aw==
X-Forwarded-Encrypted: i=1; AJvYcCUjCmmw6TM/oamaIcm9DOQapODzu4d0DrcLt5s2tpGltC4C4kAd3u/9CB6k0zCsN/qJX11BTo3xvg3Sbi2dlailijUuDtnw4Wi+jyyEng==
X-Gm-Message-State: AOJu0Yx1LeBFPHFgY45xY1W4xOW/5DE1jMbJNsSByLDotncbcVB9dM/I
	F8PYZNZY9UmXFD81nJvf+pgUjhJ84CAykLfqSJiqmcSgzK5Y/bwa
X-Google-Smtp-Source: AGHT+IHeeOQeU8ChukJHQEp1XaDoK97+N1ZQSN/NB1nKbfp7OWzhd+lcRgZS1Jy6caI+Xk0y+kgtWA==
X-Received: by 2002:a05:6a20:9783:b0:1a7:1d3e:7da with SMTP id hx3-20020a056a20978300b001a71d3e07damr4266711pzc.20.1712462272866;
        Sat, 06 Apr 2024 20:57:52 -0700 (PDT)
Received: from localhost.localdomain ([39.144.103.93])
        by smtp.gmail.com with ESMTPSA id w8-20020a170902e88800b001e27462b988sm3731093plg.61.2024.04.06.20.57.40
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 06 Apr 2024 20:57:52 -0700 (PDT)
From: Yafang Shao <laoar.shao@gmail.com>
To: jpoimboe@kernel.org,
	jikos@kernel.org,
	mbenes@suse.cz,
	pmladek@suse.com,
	joe.lawrence@redhat.com,
	mcgrof@kernel.org
Cc: live-patching@vger.kernel.org,
	linux-modules@vger.kernel.org,
	Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH v2 0/2] livepatch, module: Delete the associated module of disabled livepatch
Date: Sun,  7 Apr 2024 11:57:28 +0800
Message-Id: <20240407035730.20282-1-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In our production environment, upon loading a new atomic replace livepatch,
we encountered an issue where the kernel module of the old livepatch
remained, despite being replaced by the new one. The detailed steps to
reproduce that issue can be found in patch #2.

Detecting which livepatch will be replaced by the new one from userspace is
not reliable, necessitating the need for the operation to be performed
within the kernel itself.

This patchset aims to address this issue by automatically deleting the
associated module of a disabled livepatch. Since a disabled livepatch can't
be enabled again and the kernel module becomes redundant, it is safe to
remove it in this manner.

Changes:
- v1->v2:
  - Avoid using kpatch utility in the example (Joe, Petr)
  - Fix race around changing mod->state (Joe, Petr)
  - Don't set mod->state outside of kernel/module dir (Joe, Petr)
  - Alter selftests accordingly (Joe)
  - Split it into two patches (Petr, Miroslav)
  - Don't delete module from the path klp_enable_patch() (Petr, Miroslav)
  - Make delete_module() safe (Petr)  

Yafang Shao (2):
  module: Add a new helper delete_module()
  livepatch: Delete the associated module of disabled livepatch

 include/linux/module.h                        |  1 +
 kernel/livepatch/core.c                       | 16 ++--
 kernel/module/main.c                          | 82 +++++++++++++++----
 .../testing/selftests/livepatch/functions.sh  |  2 +
 .../selftests/livepatch/test-callbacks.sh     | 24 ++----
 .../selftests/livepatch/test-ftrace.sh        |  3 +-
 .../selftests/livepatch/test-livepatch.sh     | 11 +--
 .../testing/selftests/livepatch/test-state.sh | 15 +---
 .../selftests/livepatch/test-syscall.sh       |  3 +-
 .../testing/selftests/livepatch/test-sysfs.sh |  6 +-
 10 files changed, 95 insertions(+), 68 deletions(-)

-- 
2.39.1


