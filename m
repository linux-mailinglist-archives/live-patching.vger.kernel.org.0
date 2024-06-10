Return-Path: <live-patching+bounces-344-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 62DB0901943
	for <lists+live-patching@lfdr.de>; Mon, 10 Jun 2024 03:34:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 01D6F1F21A44
	for <lists+live-patching@lfdr.de>; Mon, 10 Jun 2024 01:34:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9681F17C2;
	Mon, 10 Jun 2024 01:34:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lNeCaU4K"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CB804405
	for <live-patching@vger.kernel.org>; Mon, 10 Jun 2024 01:34:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717983246; cv=none; b=jCNFXW5R1C3jTluGzOGniHIjyyUbmGqfUqYSE2EFZIwGw/i3UxsegLeSnLi5YXfu2MDupfLwT9g7mfbYBrFNN6LGd99+C93oewMuGU8fMlyFOS9Ldkrmd+RanlR1TbReR+Wf99+GvG8THfd1c3+AbhPYzSzv7BQdDaR0ylKIjFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717983246; c=relaxed/simple;
	bh=jmIqpJvymZuEQ7ZhiDMw/Ii6LHGr3x430lM0oBzc+c8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=E06S1swLAfeMExGSLsxe2EL4qM/UCE9sPSus+gjZRnYglK1m6MENT+uCzZ7T6dO2Eq+uUpZ5Gy61XXlbpbpfWxj9ub2939ouXYzQilAJOliP6R4BBj3clwJjGHGAQ6+v+v6TDVCx2yyu2bKJgc6+PcUb7z258PzX+c4koguS+qI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lNeCaU4K; arc=none smtp.client-ip=209.85.215.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-681bc7f50d0so3306347a12.0
        for <live-patching@vger.kernel.org>; Sun, 09 Jun 2024 18:34:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1717983244; x=1718588044; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Nw8Z2fETsMJ3SJLBWNksiYDNzIXyakLfnOekQ8dyfms=;
        b=lNeCaU4KHwlfdZ8PRa6/117xQnFhvLbBMViTji0rRzsF+RGaSeY3QikCbKykJne0j1
         Immu6kQy1/axSkBaYjMlYJlr0owLm3DNgbc7gXOu24c+B2Dt2R8rtIZ2OTGCvoxBeJzY
         JVigRIufPSDqj7Dg3xN2dOlW2PDByBQwfoYgCB+c49GeqDVhOMc2iKefvpZQAO/Fh3P4
         iAJb7QUL9Fc8iUzsy62I/6ISqAtfWk8/7YxTHwclzLjSWGNBuxrY2sfLkm+zqhbzH14+
         R4jJsc2M1UHQug7si8rL8FiVdkqAgNTFzZnSQay8CD/QDTZWALIBNHutpT99j149WzsK
         EjtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717983244; x=1718588044;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Nw8Z2fETsMJ3SJLBWNksiYDNzIXyakLfnOekQ8dyfms=;
        b=a+a2dRgoVZXSzKyKXgX5InEhP9ZDlanJKtnNsuKgZdwgmBgaRkK0F1uq1rBRpQkgbV
         Oxyn8WO9aGprp1AHWI3zo3HoUpqw+lS9TEMGAxjJKPCidQQmxv0Ui3Fcx+toIYMpQJLt
         6qTyVoW2ZjIPNKlqEtZkjwpD87WyDI4v0RX7f3tQcg3E0TXWr9t7V56tuIaV63vL8unS
         TFwfaOmEXK7iXA603PUBgPtNfgqTb2kujcyhg3p2yUZUN8MAWyIKA2IhFDUYzOTiPec4
         6bpuwXMAmFXqLwWC3r0dWh8FxnEdXDE39Ga7j89vmlWA7VQJi0CmOHWO9GcEzlilMIYQ
         fkzA==
X-Gm-Message-State: AOJu0YwPRocIfVP3W2hEk3rW9odf8NOOMYspVk3Kpi9dG0EfM1V4nvV5
	OfOafQS190gKt17vgTsORRXmgkQAXSdh+MlHsbzxsQF/R3Q7XhCg
X-Google-Smtp-Source: AGHT+IEMTExwZtsXN3STDozK6w46Zkzvbw9u59UoRiEucVYZxX19N4qSpR81Z4ts/DVwHtFz0R96LA==
X-Received: by 2002:a17:902:e5d1:b0:1f7:1ab0:3b39 with SMTP id d9443c01a7336-1f71ab03e14mr5755065ad.25.1717983244484;
        Sun, 09 Jun 2024 18:34:04 -0700 (PDT)
Received: from 192.168.124.8 ([125.121.34.85])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1f6bd7fd9b4sm71326555ad.281.2024.06.09.18.34.00
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 09 Jun 2024 18:34:04 -0700 (PDT)
From: Yafang Shao <laoar.shao@gmail.com>
To: jpoimboe@kernel.org,
	jikos@kernel.org,
	mbenes@suse.cz,
	pmladek@suse.com,
	joe.lawrence@redhat.com
Cc: live-patching@vger.kernel.org,
	Yafang Shao <laoar.shao@gmail.com>,
	Marcos Paulo de Souza <mpdesouza@suse.com>
Subject: [PATCH v2 2/3] selftests/livepatch: Add selftests for "replace" sysfs attribute
Date: Mon, 10 Jun 2024 09:32:36 +0800
Message-Id: <20240610013237.92646-3-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
In-Reply-To: <20240610013237.92646-1-laoar.shao@gmail.com>
References: <20240610013237.92646-1-laoar.shao@gmail.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add selftests for both atomic replace and non atomic replace
livepatches. The result is as follows,

  TEST: sysfs test ... ok
  TEST: sysfs test object/patched ... ok
  TEST: sysfs test replace enabled ... ok
  TEST: sysfs test replace disabled ... ok

Suggested-by: Marcos Paulo de Souza <mpdesouza@suse.com>
Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
---
 .../testing/selftests/livepatch/test-sysfs.sh | 48 +++++++++++++++++++
 1 file changed, 48 insertions(+)

diff --git a/tools/testing/selftests/livepatch/test-sysfs.sh b/tools/testing/selftests/livepatch/test-sysfs.sh
index 6c646afa7395..05a14f5a7bfb 100755
--- a/tools/testing/selftests/livepatch/test-sysfs.sh
+++ b/tools/testing/selftests/livepatch/test-sysfs.sh
@@ -18,6 +18,7 @@ check_sysfs_rights "$MOD_LIVEPATCH" "" "drwxr-xr-x"
 check_sysfs_rights "$MOD_LIVEPATCH" "enabled" "-rw-r--r--"
 check_sysfs_value  "$MOD_LIVEPATCH" "enabled" "1"
 check_sysfs_rights "$MOD_LIVEPATCH" "force" "--w-------"
+check_sysfs_rights "$MOD_LIVEPATCH" "replace" "-r--r--r--"
 check_sysfs_rights "$MOD_LIVEPATCH" "transition" "-r--r--r--"
 check_sysfs_value  "$MOD_LIVEPATCH" "transition" "0"
 check_sysfs_rights "$MOD_LIVEPATCH" "vmlinux/patched" "-r--r--r--"
@@ -83,4 +84,51 @@ test_klp_callbacks_demo: post_unpatch_callback: vmlinux
 livepatch: 'test_klp_callbacks_demo': unpatching complete
 % rmmod test_klp_callbacks_demo"
 
+start_test "sysfs test replace enabled"
+
+MOD_LIVEPATCH=test_klp_atomic_replace
+load_lp $MOD_LIVEPATCH replace=1
+
+check_sysfs_rights "$MOD_LIVEPATCH" "replace" "-r--r--r--"
+check_sysfs_value  "$MOD_LIVEPATCH" "replace" "1"
+
+disable_lp $MOD_LIVEPATCH
+unload_lp $MOD_LIVEPATCH
+
+check_result "% insmod test_modules/$MOD_LIVEPATCH.ko replace=1
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
+start_test "sysfs test replace disabled"
+
+load_lp $MOD_LIVEPATCH replace=0
+
+check_sysfs_rights "$MOD_LIVEPATCH" "replace" "-r--r--r--"
+check_sysfs_value  "$MOD_LIVEPATCH" "replace" "0"
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
2.39.1


