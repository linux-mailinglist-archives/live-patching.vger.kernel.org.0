Return-Path: <live-patching+bounces-369-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2AD76916CB2
	for <lists+live-patching@lfdr.de>; Tue, 25 Jun 2024 17:20:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9CD361F24691
	for <lists+live-patching@lfdr.de>; Tue, 25 Jun 2024 15:20:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1112217839E;
	Tue, 25 Jun 2024 15:12:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="foIGtVoL"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89AB217084A
	for <live-patching@vger.kernel.org>; Tue, 25 Jun 2024 15:12:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719328332; cv=none; b=YYejdK9+BEwdfI9Z1Q5jnTDdqe5PNNEYAdHF21QwA0EalzIWiPRMjyfxTsxFhfMk9dwUT/aVy6losx70o6KIt5COzPSjLOWJUGflMZnT6cQN5vobPNK+6/xccA9kbCQV8z2nSzab38Z/U0y6vzxmWOV4+qu/Yn3X2K3b34eFem8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719328332; c=relaxed/simple;
	bh=8jpb4Yoxxs4y/eAlU2Bp4AOclH7+dGcSKq9VO2KzB4I=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=pdzMrsQxvTvU+FBSeqdTHS5ck90PCeT9b/IN3fIcLxU5uQYdwXUYmYrgWWAOgWH0oiJKP9Jz4rEkuL5QC4OpyNZnzFnF4Mjv5I5jBzW+/ooTS9zekVfKkXtD4QkQrqKecS/0hNxAcyTXH8MJXGI0p0+xjVP+J3KnHE2SPa4ycqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=foIGtVoL; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-1fa0f143b85so23437115ad.3
        for <live-patching@vger.kernel.org>; Tue, 25 Jun 2024 08:12:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1719328330; x=1719933130; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bMn9jdgvFtjjwW2r7ncpePmSoYNQZxfsJv31xYTj9kM=;
        b=foIGtVoLmCC8gx9h7EbkKHSQfm2CfWyx0lqspS95KjYzlwRRnyZwHgAxxPH6YapWpR
         ALgYAOCO7wUxN+ejIuUP+FWn/WBZNOBdfCJs4Ai3293u6y9AG+OajUQiajqFAUzlcj70
         S4EG4XQKcyYonJyQGZ1pEDU6KLs+eXTohJhafRwrPYKHKP2nx1n7dtrv5kwtLtSY1j8p
         5B+yDb+cCHREaujCsgh2Dv1KgIa03uqCPEavxLC8+eSxNPJT2L2BzZvXT+cJ/pRC+l96
         tuhM/N4KJuSmXBraqOudAMC+1rkFmaQjKxYleh/c81gnJAAxO3WQje1wYkOr0PXGU5LN
         +OOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719328330; x=1719933130;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bMn9jdgvFtjjwW2r7ncpePmSoYNQZxfsJv31xYTj9kM=;
        b=e11sL1f8BK9KoohLYYv0KTeogEEz1gOa20IAbKECvsDOWIKvbyGxVm1mAS/VMZ1vqK
         HUAJee5XidUko+rHGhcRUj7Z317kQyMkrCtJ5dDouD2bNFwHvxf/g4Q34xGQFDaNOu/8
         JDqXW7spSQmwgPH8ItcP8mq/v9Okq2DV3qA5gEfTcZc2fds+HbEhGV8dMnvFIAcRhlpc
         CMp2ffnNkCvlkDhELoEQBWuSKcHWbsC7hRu+Eo0VmqpXU7f6po31H5hDTgHm4GZDXgZG
         9pHAiYrrSgr7JAe5vMXpgZ0LwZpeb0ZM0d/BPuF2gur/i/MJPdGet3VowEwinRsgsuHA
         9OTQ==
X-Gm-Message-State: AOJu0YwVoQrUwtNB/88s4wOwmXoK/bA1+141nnz4oSwdjGuxwfIVtFTi
	xs4pu6D7B2LREBIvZtNrjaF+b4RKbG7S22dFkw8HQqT0GEQypB6X
X-Google-Smtp-Source: AGHT+IGpOZuTYZlS+iFbD8teXJu8xkQjVSa0L1+Y/0bGKZD4gsMCiBOgwUrJZk3JSv7NAkngAcfrcw==
X-Received: by 2002:a17:902:e5c1:b0:1f6:a606:539e with SMTP id d9443c01a7336-1fa23f3600amr84324705ad.61.1719328329797;
        Tue, 25 Jun 2024 08:12:09 -0700 (PDT)
Received: from localhost.localdomain ([183.193.176.237])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1f9eb323636sm82008935ad.102.2024.06.25.08.12.06
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 25 Jun 2024 08:12:09 -0700 (PDT)
From: Yafang Shao <laoar.shao@gmail.com>
To: jpoimboe@kernel.org,
	jikos@kernel.org,
	mbenes@suse.cz,
	pmladek@suse.com,
	joe.lawrence@redhat.com,
	song@kernel.org,
	mpdesouza@suse.com
Cc: live-patching@vger.kernel.org,
	Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH v3 2/3] selftests/livepatch: Add selftests for "replace" sysfs attribute
Date: Tue, 25 Jun 2024 23:11:22 +0800
Message-Id: <20240625151123.2750-3-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
In-Reply-To: <20240625151123.2750-1-laoar.shao@gmail.com>
References: <20240625151123.2750-1-laoar.shao@gmail.com>
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
Tested-by: Marcos Paulo de Souza <mpdesouza@suse.com>
Reviewed-by: Marcos Paulo de Souza <mpdesouza@suse.com>
Reviewed-by: Petr Mladek <pmladek@suse.com>
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


