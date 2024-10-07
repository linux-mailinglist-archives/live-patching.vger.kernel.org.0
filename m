Return-Path: <live-patching+bounces-716-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E32C7992E84
	for <lists+live-patching@lfdr.de>; Mon,  7 Oct 2024 16:13:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8BFA31F2443F
	for <lists+live-patching@lfdr.de>; Mon,  7 Oct 2024 14:13:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 281861D6DB9;
	Mon,  7 Oct 2024 14:11:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Uhoohsx4"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BDB61D6199;
	Mon,  7 Oct 2024 14:11:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728310311; cv=none; b=qpudSNwqNahwx/XF53IHiqpfqXHhlPCP1Hj32bhZ1zDLHEVmnY8B9oPkTMHOjheJnUMDoFJlWV4dU6FkEF2lbZn4vyYjslcZjS6ThkSw2r1DagFRpOrFys7TifGzJZd6EO4sJUccfbwO9Ugm2jvP3sxbUZR/JU6slLMzg9IJHcA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728310311; c=relaxed/simple;
	bh=eejfsxRus9CZwZggt+RZsEBvsrBQQP3CP8F4bYU2aXc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=GJ71Q9l1T5pfCRUcBeXKpdVgxPZ5hJIK1oLoxwERKIcSQd0ZhJh/yiAHKFv/5ac/RjM7ugA5ESi1dTT/+4fuE3S7TBzAy92Azv7UkoZRzPoDpai6ITfbkFiXaCb1EoX4qmoy695wp6hbEa4cU6BBBuXJnrZFfr5MFL7GoFnSBlw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Uhoohsx4; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-20bb39d97d1so37740125ad.2;
        Mon, 07 Oct 2024 07:11:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728310309; x=1728915109; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=RKR3q2SKM1ngNEIOlb7PrdpNEzp4DiGKIdiJrGREDA4=;
        b=Uhoohsx4crvEK5RZI/fkssV/pd/pTJfp4wrq5/HdDFb25KhZBiVuPDqbpVysrv2dYa
         +2fyFpxv8E0X7FCp4N6rNprHooPCGV1CNeB9mTxmEn5YgcFpYLbG0mUXx/EviGALPuhg
         r/bkQsjAeHTRUa3YngMgLf8Pun9GzzY50GinayPuiyQi+DGpISgEM2u3VG0y3GhUx7yu
         EALoClUYHma18bDXPWyf5fhIqsdCBaYxXFLAd6SXHUnvOLkaLTnfeUtAaocO31czjYbM
         HJoiN8SCTyu+BWXpJRPGD5LVGJ0pnhkVQTtq3JvHZ0Aq5fRVWX9BUmVDyBXc2sOjP5Z/
         9qcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728310309; x=1728915109;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RKR3q2SKM1ngNEIOlb7PrdpNEzp4DiGKIdiJrGREDA4=;
        b=iqAu3+pJ6eDwSysCJQfQzknWPw9p2ZXV97E2+3YsVTlukyphTrWiVMhcF+5itwGYqi
         i0NO3Ag3c16PZTNJbze/9kziCTi6KYBWdpJNTyTzeYBcDaLrtUVjGUjXJ8meR4HFwWvZ
         LlJ4cWxXZKdIM1TzEHlNbYYJNRJHJkjU8STZPjkdiQue7GZYoAouK2F57VG/pwE5lCQ0
         9OHa23yu0LguQ21hUaYAWdsra3MShW2jBh4fEADYuaR+DQIdgjKRjiO9d4mUQxwotJEf
         tV/csyiF9xFR+wiuwNsv4Mx1vcG1iMk/VF+TE0FuL8axM89liZQIG0lXajbJhf9iqzI6
         AGlg==
X-Forwarded-Encrypted: i=1; AJvYcCXNXsJJAyHaWy5mBEXyqMXocZfdCMY49oZS3tVH52EEafeUy9dNlRn7huezYsKL8lxQX/PMC1Sa2VOOJz4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxa43BxST5fMf+PHrYQJZTprV515AZDbVqumkutS1rbI6EFIERO
	FqjRBI38RiJrtYDm9wLvo4IgwW1tWWr0WG278lfF2sMBDizMFk+6
X-Google-Smtp-Source: AGHT+IG0K9MBi9CkbCM8lt/ZPaifrzZFJf9HMlkG7E09vaQ3ea4nLLMhsJ4hlzt0MTSgpTMUXpB8Cg==
X-Received: by 2002:a17:902:f788:b0:20b:8ed8:9c74 with SMTP id d9443c01a7336-20bff1cb9d3mr181970195ad.49.1728310308781;
        Mon, 07 Oct 2024 07:11:48 -0700 (PDT)
Received: from B-M149MD6R-0150.lan ([2409:8a55:2e52:c0f1:4d08:3cf4:6043:d1e7])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20c139a6492sm39921265ad.308.2024.10.07.07.11.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Oct 2024 07:11:48 -0700 (PDT)
From: Wardenjohn <zhangwarden@gmail.com>
To: jpoimboe@kernel.org,
	mbenes@suse.cz,
	jikos@kernel.org,
	pmladek@suse.com,
	joe.lawrence@redhat.com
Cc: live-patching@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Wardenjohn <zhangwarden@gmail.com>
Subject: [PATCH] selftests: livepatch: add test case of stack_order sysfs interface
Date: Mon,  7 Oct 2024 22:11:39 +0800
Message-Id: <20241007141139.49171-1-zhangwarden@gmail.com>
X-Mailer: git-send-email 2.37.3
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add test case of stack_order sysfs interface of livepatch.

Signed-off-by: Wardenjohn <zhangwarden@gmail.com>
---
 .../testing/selftests/livepatch/test-sysfs.sh | 24 +++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/tools/testing/selftests/livepatch/test-sysfs.sh b/tools/testing/selftests/livepatch/test-sysfs.sh
index 05a14f5a7bfb..81776749a4e3 100755
--- a/tools/testing/selftests/livepatch/test-sysfs.sh
+++ b/tools/testing/selftests/livepatch/test-sysfs.sh
@@ -19,6 +19,7 @@ check_sysfs_rights "$MOD_LIVEPATCH" "enabled" "-rw-r--r--"
 check_sysfs_value  "$MOD_LIVEPATCH" "enabled" "1"
 check_sysfs_rights "$MOD_LIVEPATCH" "force" "--w-------"
 check_sysfs_rights "$MOD_LIVEPATCH" "replace" "-r--r--r--"
+check_sysfs_rights "$MOD_LIVEPATCH" "stack_order" "-r--r--r--"
 check_sysfs_rights "$MOD_LIVEPATCH" "transition" "-r--r--r--"
 check_sysfs_value  "$MOD_LIVEPATCH" "transition" "0"
 check_sysfs_rights "$MOD_LIVEPATCH" "vmlinux/patched" "-r--r--r--"
@@ -131,4 +132,27 @@ livepatch: '$MOD_LIVEPATCH': completing unpatching transition
 livepatch: '$MOD_LIVEPATCH': unpatching complete
 % rmmod $MOD_LIVEPATCH"
 
+start_test "sysfs test stack_order read"
+
+load_lp $MOD_LIVEPATCH
+
+check_sysfs_rights "$MOD_LIVEPATCH" "stack_order" "-r--r--r--"
+check_sysfs_value  "$MOD_LIVEPATCH" "stack_order" "1"
+
+disable_lp $MOD_LIVEPATCH
+unload_lp $MOD_LIVEPATCH
+
+check_result "% insmod test_modules/$MOD_LIVEPATCH.ko replace=0
+livepatch: enabling patch '$MOD_LIVEPATCH'
+livepatch: '$MOD_LIVEPATCH': initializing patching transition
+livepatch: '$MOD_LIVEPATCH': starting patching transition
+livepatch: '$MOD_LIVEPATCH': completing patching transition
+livepatch: '$MOD_LIVEPATCH': patching complete
+% echo 0 > /sys/kernel/livepatch/$MOD_LIVEPATCH/enabled
+livepatch: '$MOD_LIVEPATCH': initializing unpatching transition
+livepatch: '$MOD_LIVEPATCH': starting unpatching transition
+livepatch: '$MOD_LIVEPATCH': completing unpatching transition
+livepatch: '$MOD_LIVEPATCH': unpatching complete
+% rmmod $MOD_LIVEPATCH"
+
 exit 0
-- 
2.18.2


