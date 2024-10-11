Return-Path: <live-patching+bounces-736-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2367F99A743
	for <lists+live-patching@lfdr.de>; Fri, 11 Oct 2024 17:13:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DBDE32850ED
	for <lists+live-patching@lfdr.de>; Fri, 11 Oct 2024 15:13:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 11DAF1940AA;
	Fri, 11 Oct 2024 15:13:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="V9OYwIzh"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 828BF39FD6;
	Fri, 11 Oct 2024 15:13:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728659596; cv=none; b=ClRvKnS4+XxJGOFkG+DeBKwrOn+mL+/G+fuvG0cmJEDNc5iI81qnnFn+SV3SfahJVRJQVrrrnwMIWDvk7/m9V6yuTolUY04zNugQ0VAKDRg61/LJT8vFve1TSNabcWuDOkKlQupWItiaw2K3BLwDyaz8VcJ2P8//N+DngJDZTK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728659596; c=relaxed/simple;
	bh=qfJ6SYyaKgtTNtmaghdxqcBU8qL4mlW0+Yoo1iglsXQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=kzX2GCLAWtJj9R9KhOBYCByAy2RxlIkU28paMZRXLxKnlFeF/MRou8wsirKCfuvVacd6BBdUWe+lhuy+QEjolKNSqx4QVj3/EEsy4GixlSimetdVksj01fdv/pxxjXGNCAOzGqXN+HvQN4aIV4/Q87TdtYl5fbXKex+ux4bpgio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=V9OYwIzh; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-20ca96a155cso5223115ad.2;
        Fri, 11 Oct 2024 08:13:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728659594; x=1729264394; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TCPKQV/L/FHSvfwy3GXxZPDOsntjDyM+mZ15ZRWZ2Uo=;
        b=V9OYwIzhkdZuzf4UR6beGvbGRLaKjpa/EwK3zQDEDSVO/+Kj9+/5tvsGoUY/Wt1Z+8
         r+B7Q1dirczVmu5LPyY0J250+WYYSiDVEQ1VKUJTRno2M3iwZDcXApzi2qxv1UD19q9m
         lvOMHPV9pLsiIU7In8MtmKrXjMswGQxJZ/EbstXN5SrcZoGJs+jyy66/Yw7JSwiClfbd
         FZsEGCZw4tgr+4rDedYy+w/wC93fhvk9BKjfAVfsdxSWZjIk6AmDjhFAf5VvOsQknMwg
         yygV+eCkPLZu+3igXursvSNHmt6Bc4McX6QyY6JdJjJpPR/shkxCQfmXfn51hxKPpu86
         2nTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728659594; x=1729264394;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TCPKQV/L/FHSvfwy3GXxZPDOsntjDyM+mZ15ZRWZ2Uo=;
        b=CtkByTbmUIejqtuXdoOkv6E+3LGQGkdSGV7ky++TxB2lluEJLCHl8J6EqXKpE21gQA
         hQJ3WIX76vrpIVtPFa6NMyuA+2tY7t5X7irxiheCssa3eJRnBDWBXrEBPsfBOhimbbXr
         ggsChxnfcaRFsQF9W8feA6o346rulkcR2zbuRRBtJuMIQXlJOiAZWem0btTx7v/vc3Lj
         KSnInWYtalC5x/+1aS9HBWLhJ3vwYdIz/L7EKHYFE7N49D8+D/2e+v69TFMHxrTqdTA1
         xaPHII31nG1ZluvAy9+zjr2BD78eSvVfGyCiF0McqYTFl0q7Ek/7kh/DlBbatmN/RYhd
         TVbA==
X-Forwarded-Encrypted: i=1; AJvYcCX3I/64h3l2Dse/wgmFyDNggnmEnmCONN4zryhw1WYydv/dSobezKOfM0XJPBJgFtwQ6PjbZVC+xek2b4s=@vger.kernel.org
X-Gm-Message-State: AOJu0YyJDEtvgxh1e68W9c4FCYlItguVD7y6Fm4NLv1i/8/B4LTsjTEi
	aRPhpCT3EF46LeLsHJlAkSOwi61D/x9OgqXp+Tx7ZDRvUmKYzMcj
X-Google-Smtp-Source: AGHT+IGOtgR3KbGnEYLE6FFjS714pAouVBqlminP1LrjG71lhn2ouvKM6hFjGAXq+wHlmIn9MtDKZQ==
X-Received: by 2002:a17:902:e845:b0:20b:b26e:c149 with SMTP id d9443c01a7336-20ca1467cf5mr39203505ad.29.1728659593626;
        Fri, 11 Oct 2024 08:13:13 -0700 (PDT)
Received: from localhost.localdomain ([120.229.27.134])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20c8bc48f03sm24457545ad.117.2024.10.11.08.13.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Oct 2024 08:13:13 -0700 (PDT)
From: Wardenjohn <zhangwarden@gmail.com>
To: jpoimboe@kernel.org,
	mbenes@suse.cz,
	jikos@kernel.org,
	pmladek@suse.com,
	joe.lawrence@redhat.com
Cc: live-patching@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Wardenjohn <zhangwarden@gmail.com>
Subject: [PATCH] selftests: livepatch: add test cases of stack_order sysfs interface
Date: Fri, 11 Oct 2024 23:11:51 +0800
Message-Id: <20241011151151.67869-2-zhangwarden@gmail.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20241011151151.67869-1-zhangwarden@gmail.com>
References: <20241011151151.67869-1-zhangwarden@gmail.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add selftest test cases to sysfs attribute 'stack_order'.

Signed-off-by: Wardenjohn <zhangwarden@gmail.com>
---
 .../testing/selftests/livepatch/test-sysfs.sh | 74 +++++++++++++++++++
 1 file changed, 74 insertions(+)

diff --git a/tools/testing/selftests/livepatch/test-sysfs.sh b/tools/testing/selftests/livepatch/test-sysfs.sh
index 05a14f5a7bfb..71a2e95636b1 100755
--- a/tools/testing/selftests/livepatch/test-sysfs.sh
+++ b/tools/testing/selftests/livepatch/test-sysfs.sh
@@ -5,6 +5,8 @@
 . $(dirname $0)/functions.sh
 
 MOD_LIVEPATCH=test_klp_livepatch
+MOD_LIVEPATCH2=test_klp_callbacks_demo
+MOD_LIVEPATCH3=test_klp_syscall
 
 setup_config
 
@@ -131,4 +133,76 @@ livepatch: '$MOD_LIVEPATCH': completing unpatching transition
 livepatch: '$MOD_LIVEPATCH': unpatching complete
 % rmmod $MOD_LIVEPATCH"
 
+start_test "sysfs test stack_order read"
+
+load_lp $MOD_LIVEPATCH
+
+check_sysfs_rights "$MOD_LIVEPATCH" "stack_order" "-r--r--r--"
+check_sysfs_value  "$MOD_LIVEPATCH" "stack_order" "1"
+
+load_lp $MOD_LIVEPATCH2
+
+check_sysfs_rights "$MOD_LIVEPATCH" "stack_order" "-r--r--r--"
+check_sysfs_value  "$MOD_LIVEPATCH2" "stack_order" "2"
+
+load_lp $MOD_LIVEPATCH3
+
+check_sysfs_rights "$MOD_LIVEPATCH3" "stack_order" "-r--r--r--"
+check_sysfs_value  "$MOD_LIVEPATCH3" "stack_order" "3"
+
+disable_lp $MOD_LIVEPATCH2
+unload_lp $MOD_LIVEPATCH2
+
+check_sysfs_rights "$MOD_LIVEPATCH" "stack_order" "-r--r--r--"
+check_sysfs_value  "$MOD_LIVEPATCH" "stack_order" "1"
+check_sysfs_rights "$MOD_LIVEPATCH3" "stack_order" "-r--r--r--"
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


