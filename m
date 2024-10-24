Return-Path: <live-patching+bounces-761-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9C83F9ADF49
	for <lists+live-patching@lfdr.de>; Thu, 24 Oct 2024 10:35:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2AF201F21411
	for <lists+live-patching@lfdr.de>; Thu, 24 Oct 2024 08:35:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B97E19DF7A;
	Thu, 24 Oct 2024 08:35:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NTUhlUG5"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22566189BB3;
	Thu, 24 Oct 2024 08:35:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729758948; cv=none; b=PqJvj+1yY+2YwZuCKH2fxQnwYVXNBGeZl+1hwn98g4/vrx5vYzbLYDW/LFwKbd3BsF4QnsPIwxe3y9m5LLN7lbJ9wo3WUyKMmbMdJu+5qEy/Jq7s9ijXjJQZU6nmcF9tqnUj9852JotsdxVbYj9u3hlIhAbCoVWdkX0d5SqIBAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729758948; c=relaxed/simple;
	bh=+XWpmp0csatu8+IK8+JJJs92Lop968ewAxeK1biaZeM=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=ip77BlJFItfvikyrxw71CpX6CkPPezOV/4TKkp5OWyMrkwiLlrpD8HK4aW8yGw7BP5YlAgEEvXFq9NQkDW1RbQrLHxYsJilv3HTXJbQCXjc2gdqNlTETHUosYmysjSkSly/URDmfE76SOX2Q1dCokCblOIuP3gj9fyWiIN7ocJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NTUhlUG5; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-208cf673b8dso4777745ad.3;
        Thu, 24 Oct 2024 01:35:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729758945; x=1730363745; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=k/UlxyhCVOV8IRM2oQpaNcL1Tbi1VmLpqeBuOkUbId0=;
        b=NTUhlUG5WIQkypFFkQZYj56nIvKJqS+nKbCzvccGJJ2BkhCtaGtZmLnJP5EmL25nqi
         8jbH/cbB9maz5+P0Pe64FGTptEHivezlt+OA1/lsgavmre8xjKGY3sP+qrD6zMlkLvd6
         LvCCNOe2yNGyfAHozACNQo3bubO4CRPIi5pQ5E/TvzBng0/+g5rJ15Ye/refGEkwXBJD
         9IsNuq32t6M6+rTieH5DF7bmfdagvRiY6Jh4DVxo0I+fkkOpXcr5M5zhVxqB7EY5c2WO
         W51qr/8Jl+SyN5cnZnzPN3RbNycHDPpUQuvOrBOo9OG2rB/K+fShiGaWIsUQzGss9KzE
         Bsjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729758945; x=1730363745;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=k/UlxyhCVOV8IRM2oQpaNcL1Tbi1VmLpqeBuOkUbId0=;
        b=omoBLi3vFmmSA9vz/xdA7UbW+HyGo8+4rndQRC7hmgxF88/oow+kAfTpSncZqtvRkN
         lUzw1iBLmHL0gVJpqR0TBg/Zn8c7+5TeX45ohksYIT7JOVn68m3wSIMTy0VQlSo479SM
         iIPLbAL5Sjxn7sJzgDvnUpWqt49cP3ZiAssMw/f9g8VCfAhuLMqH5hfie5GNU22PgTqw
         FLM+ecK3oZBSSBMrNrN63ay61wgj5GuM5jEAmoBNnYy+lVpy5TzIKQ7YNi1qnipmPCOi
         yGPeq9HQ38QyL6gkOsKxL62oaPoMi9FvyE5Uu75omJ7pBTighVMl0D7/OxyjfHxeYhVh
         OLbg==
X-Forwarded-Encrypted: i=1; AJvYcCWF00z+of2VAuAP62QNPrvJ6bcBAM4T9M0wIR0herkMhVuZp2D8Vq5opkZD6JET8q9TxkV31T7fyqeGDyA=@vger.kernel.org
X-Gm-Message-State: AOJu0YxMtChqhpgDk8n0x08bwGfVCrMl8nEvYQa/a3XjApM9K0eL5l3V
	4DG8/KxYnDUdtVS6VLz6LRd4CN5EjHiiVj+y9wVjY7kGrIRMKr/M
X-Google-Smtp-Source: AGHT+IGVjMn0N+dRQFGhE7Bu5a8g2NkDHeviPsQKLPYnN2fxt1S84mkGyiNmnTUo/yeA1g66tT9bIA==
X-Received: by 2002:a17:903:1ce:b0:20c:fb47:5c05 with SMTP id d9443c01a7336-20fb99f61f6mr11338655ad.46.1729758945274;
        Thu, 24 Oct 2024 01:35:45 -0700 (PDT)
Received: from localhost.localdomain ([205.204.117.124])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20e7ef0c439sm68827765ad.94.2024.10.24.01.35.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2024 01:35:44 -0700 (PDT)
From: Wardenjohn <zhangwarden@gmail.com>
To: jpoimboe@kernel.org,
	mbenes@suse.cz,
	jikos@kernel.org,
	pmladek@suse.com,
	joe.lawrence@redhat.com
Cc: live-patching@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Wardenjohn <zhangwarden@gmail.com>
Subject: [PATCH V3] selftests: livepatch: add test cases of stack_order sysfs interface
Date: Thu, 24 Oct 2024 16:35:30 +0800
Message-Id: <20241024083530.58775-1-zhangwarden@gmail.com>
X-Mailer: git-send-email 2.37.3
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add selftest test cases to sysfs attribute 'stack_order'.

Suggested-by: Petr Mladek <pmladek@suse.com>
Signed-off-by: Wardenjohn <zhangwarden@gmail.com>
---
 .../testing/selftests/livepatch/test-sysfs.sh | 71 +++++++++++++++++++
 1 file changed, 71 insertions(+)

diff --git a/tools/testing/selftests/livepatch/test-sysfs.sh b/tools/testing/selftests/livepatch/test-sysfs.sh
index 05a14f5a7bfb..e44a051be307 100755
--- a/tools/testing/selftests/livepatch/test-sysfs.sh
+++ b/tools/testing/selftests/livepatch/test-sysfs.sh
@@ -5,6 +5,8 @@
 . $(dirname $0)/functions.sh
 
 MOD_LIVEPATCH=test_klp_livepatch
+MOD_LIVEPATCH2=test_klp_callbacks_demo
+MOD_LIVEPATCH3=test_klp_syscall
 
 setup_config
 
@@ -19,6 +21,8 @@ check_sysfs_rights "$MOD_LIVEPATCH" "enabled" "-rw-r--r--"
 check_sysfs_value  "$MOD_LIVEPATCH" "enabled" "1"
 check_sysfs_rights "$MOD_LIVEPATCH" "force" "--w-------"
 check_sysfs_rights "$MOD_LIVEPATCH" "replace" "-r--r--r--"
+check_sysfs_rights "$MOD_LIVEPATCH" "stack_order" "-r--r--r--"
+check_sysfs_value  "$MOD_LIVEPATCH" "stack_order" "1"
 check_sysfs_rights "$MOD_LIVEPATCH" "transition" "-r--r--r--"
 check_sysfs_value  "$MOD_LIVEPATCH" "transition" "0"
 check_sysfs_rights "$MOD_LIVEPATCH" "vmlinux/patched" "-r--r--r--"
@@ -131,4 +135,71 @@ livepatch: '$MOD_LIVEPATCH': completing unpatching transition
 livepatch: '$MOD_LIVEPATCH': unpatching complete
 % rmmod $MOD_LIVEPATCH"
 
+start_test "sysfs test stack_order value"
+
+load_lp $MOD_LIVEPATCH
+
+check_sysfs_value  "$MOD_LIVEPATCH" "stack_order" "1"
+
+load_lp $MOD_LIVEPATCH2
+
+check_sysfs_value  "$MOD_LIVEPATCH2" "stack_order" "2"
+
+load_lp $MOD_LIVEPATCH3
+
+check_sysfs_value  "$MOD_LIVEPATCH3" "stack_order" "3"
+
+disable_lp $MOD_LIVEPATCH2
+unload_lp $MOD_LIVEPATCH2
+
+check_sysfs_value  "$MOD_LIVEPATCH" "stack_order" "1"
+check_sysfs_value  "$MOD_LIVEPATCH3" "stack_order" "2"
+
+disable_lp $MOD_LIVEPATCH3
+unload_lp $MOD_LIVEPATCH3
+
+disable_lp $MOD_LIVEPATCH
+unload_lp $MOD_LIVEPATCH
+
+check_result "% insmod test_modules/$MOD_LIVEPATCH.ko
+livepatch: enabling patch '$MOD_LIVEPATCH'
+livepatch: '$MOD_LIVEPATCH': initializing patching transition
+livepatch: '$MOD_LIVEPATCH': starting patching transition
+livepatch: '$MOD_LIVEPATCH': completing patching transition
+livepatch: '$MOD_LIVEPATCH': patching complete
+% insmod test_modules/$MOD_LIVEPATCH2.ko
+livepatch: enabling patch '$MOD_LIVEPATCH2'
+livepatch: '$MOD_LIVEPATCH2': initializing patching transition
+$MOD_LIVEPATCH2: pre_patch_callback: vmlinux
+livepatch: '$MOD_LIVEPATCH2': starting patching transition
+livepatch: '$MOD_LIVEPATCH2': completing patching transition
+$MOD_LIVEPATCH2: post_patch_callback: vmlinux
+livepatch: '$MOD_LIVEPATCH2': patching complete
+% insmod test_modules/$MOD_LIVEPATCH3.ko
+livepatch: enabling patch '$MOD_LIVEPATCH3'
+livepatch: '$MOD_LIVEPATCH3': initializing patching transition
+livepatch: '$MOD_LIVEPATCH3': starting patching transition
+livepatch: '$MOD_LIVEPATCH3': completing patching transition
+livepatch: '$MOD_LIVEPATCH3': patching complete
+% echo 0 > /sys/kernel/livepatch/$MOD_LIVEPATCH2/enabled
+livepatch: '$MOD_LIVEPATCH2': initializing unpatching transition
+$MOD_LIVEPATCH2: pre_unpatch_callback: vmlinux
+livepatch: '$MOD_LIVEPATCH2': starting unpatching transition
+livepatch: '$MOD_LIVEPATCH2': completing unpatching transition
+$MOD_LIVEPATCH2: post_unpatch_callback: vmlinux
+livepatch: '$MOD_LIVEPATCH2': unpatching complete
+% rmmod $MOD_LIVEPATCH2
+% echo 0 > /sys/kernel/livepatch/$MOD_LIVEPATCH3/enabled
+livepatch: '$MOD_LIVEPATCH3': initializing unpatching transition
+livepatch: '$MOD_LIVEPATCH3': starting unpatching transition
+livepatch: '$MOD_LIVEPATCH3': completing unpatching transition
+livepatch: '$MOD_LIVEPATCH3': unpatching complete
+% rmmod $MOD_LIVEPATCH3
+% echo 0 > /sys/kernel/livepatch/$MOD_LIVEPATCH/enabled
+livepatch: '$MOD_LIVEPATCH': initializing unpatching transition
+livepatch: '$MOD_LIVEPATCH': starting unpatching transition
+livepatch: '$MOD_LIVEPATCH': completing unpatching transition
+livepatch: '$MOD_LIVEPATCH': unpatching complete
+% rmmod $MOD_LIVEPATCH"
+
 exit 0
-- 
2.43.5


