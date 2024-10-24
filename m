Return-Path: <live-patching+bounces-757-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C651D9ADB16
	for <lists+live-patching@lfdr.de>; Thu, 24 Oct 2024 06:44:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E6D731C212D6
	for <lists+live-patching@lfdr.de>; Thu, 24 Oct 2024 04:44:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3881B171E5F;
	Thu, 24 Oct 2024 04:43:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bv4fraZz"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20E71A932;
	Thu, 24 Oct 2024 04:43:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729745023; cv=none; b=aPJ77ZoOG3Wm8/39NGjvoGUJ7IQ0sOL10KLxC0yqUzDGICMe+3eusCITEZ1XeI9XS3iscjAtpUDBijIsIObY3PtUWjJIz3EaJxuZmfmysSNmbK8Am5ay8lzlnLMo+o1TjSeHgXOzFqJ34hI4wvykeVj4vxQ23b7EoJGNlWr07a4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729745023; c=relaxed/simple;
	bh=uGT2a7eIuh7eT/TPW0PYBtgNw6ZDAs0eKMC54ruytgQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=gL+tNSTfNKmLxogqKFFwsgw69zYlI2XRCQwMlezj55xF/RvLsKgvvIqlfjb31hgefKp92zV5pZqgcFi+By5tbp7YBv/h7mZ5tL9MT9ukQ2VuHi3kDANGd8P6nkDQ0DQZPcOqXm62CcPgfF//X3XoGhCsl5PYVS8kwx2dSlhwG9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bv4fraZz; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-20ca388d242so3232085ad.2;
        Wed, 23 Oct 2024 21:43:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729745020; x=1730349820; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HSfXA/bkU0v3WpFCkUBUuBtJeW8OFa0SK9U0qdjAEyU=;
        b=bv4fraZzBw+hH05MmXES7grxh2NecGw8anm1WMdEfMbtVL6V4Xm61bsq0+WC4MNNOO
         //eQtbO7psiE8zn3P2br3ZTWykvqOQwGyLn/S3wsru84+No4Ld8F9dFMVxiKQAzFf+Ts
         BPQN3HiAOEhJ2iqpvFym8LopKnxqfvKXg+adtvFzE0udZsQ++td4gxmKN9oo3bhNnYUT
         KDiCnG9RhmCYsujgweNu7VuwPgteYRb6dhWtcL0eSxyUY7dKGVF6H/7YHrvqkYbr+s10
         6FI8SGy6kjc087hmLnjDu9elGMuE/QGcjIhW/He9FmolP1+gzIycS3oauCwzfn9OT4cb
         RGrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729745020; x=1730349820;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HSfXA/bkU0v3WpFCkUBUuBtJeW8OFa0SK9U0qdjAEyU=;
        b=DkQAnhBbXJc6AO9A3IaAi5MWmRSzChebOfkEIJsQLDHSkfnxkenPO6HLwB5VX1LlmV
         I/FbGnjZF2cA+Pf7NSJRi0BhlsLBBVviVq899f9abtwJGa2DgbBay1FJ3+OFNRZEFf6d
         pQ038pckTHTEQrd2OgHzhEZp+PFkpuuVzImLiJl2JU+plqjPe8ROX15N61tmwAWnLN3h
         +YQPZElo2GtAs2Ld5BiwT55dmH8YBhpKG+rdIXllY8qwGRg0+NK4tSUizX1dAKqxyOLM
         uBlqq1/eQH1TKxSU69WOAwHYtRcy3SgB2RVy3rF4XxpVOGHBECrwUE8YC1Vj40dxeciJ
         Q0lg==
X-Forwarded-Encrypted: i=1; AJvYcCWKUwIUnO6mWX/J7SAkLQlUfnb8Wd+VmQTXm/3JUy8GjlRK8sXyuZzSu70w5vrjRdw+0Uq6gbpoBFaerM8=@vger.kernel.org
X-Gm-Message-State: AOJu0YwxtXkLWQDWN/+3GVrjE2Y5k2F0YPBnhONXxef/j1T2zozul5QM
	VYP6hnoTnYVO2IVzhfUQsZGTQW/F5o+8fvm6DOLTXlsHm0+ryFNw
X-Google-Smtp-Source: AGHT+IHtg6Dd97+IoD4wYK+OrFGwBdDzeq88nxL2F+WsecmeAzTEU+sHqpxeATdPmEPTvdXukTNezw==
X-Received: by 2002:a17:903:1ca:b0:20b:983c:f095 with SMTP id d9443c01a7336-20fa9eb5a1emr61467885ad.51.1729745020358;
        Wed, 23 Oct 2024 21:43:40 -0700 (PDT)
Received: from localhost.localdomain ([205.204.117.124])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20e7eee63a1sm65582835ad.18.2024.10.23.21.43.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Oct 2024 21:43:40 -0700 (PDT)
From: Wardenjohn <zhangwarden@gmail.com>
To: jpoimboe@kernel.org,
	mbenes@suse.cz,
	jikos@kernel.org,
	pmladek@suse.com,
	joe.lawrence@redhat.com
Cc: live-patching@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Wardenjohn <zhangwarden@gmail.com>
Subject: [PATCH V2] selftests: livepatch: add test cases of stack_order sysfs interface
Date: Thu, 24 Oct 2024 12:43:17 +0800
Message-Id: <20241024044317.46666-2-zhangwarden@gmail.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20241024044317.46666-1-zhangwarden@gmail.com>
References: <20241024044317.46666-1-zhangwarden@gmail.com>
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
index 05a14f5a7bfb..718027cc3aba 100755
--- a/tools/testing/selftests/livepatch/test-sysfs.sh
+++ b/tools/testing/selftests/livepatch/test-sysfs.sh
@@ -5,6 +5,8 @@
 . $(dirname $0)/functions.sh
 
 MOD_LIVEPATCH=test_klp_livepatch
+MOD_LIVEPATCH2=test_klp_callbacks_demo
+MOD_LIVEPATCH3=test_klp_syscall
 
 setup_config
 
@@ -21,6 +23,8 @@ check_sysfs_rights "$MOD_LIVEPATCH" "force" "--w-------"
 check_sysfs_rights "$MOD_LIVEPATCH" "replace" "-r--r--r--"
 check_sysfs_rights "$MOD_LIVEPATCH" "transition" "-r--r--r--"
 check_sysfs_value  "$MOD_LIVEPATCH" "transition" "0"
+check_sysfs_rights "$MOD_LIVEPATCH" "stack_order" "-r--r--r--"
+check_sysfs_value  "$MOD_LIVEPATCH" "stack_order" "1"
 check_sysfs_rights "$MOD_LIVEPATCH" "vmlinux/patched" "-r--r--r--"
 check_sysfs_value  "$MOD_LIVEPATCH" "vmlinux/patched" "1"
 
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


