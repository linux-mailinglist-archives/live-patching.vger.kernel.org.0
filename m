Return-Path: <live-patching+bounces-2605-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id SM7yHpkZ8mljnwEAu9opvQ
	(envelope-from <live-patching+bounces-2605-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Wed, 29 Apr 2026 16:45:45 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 0DD5C4961A8
	for <lists+live-patching@lfdr.de>; Wed, 29 Apr 2026 16:45:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id DDA3F313A81A
	for <lists+live-patching@lfdr.de>; Wed, 29 Apr 2026 14:36:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 14DF5361DAE;
	Wed, 29 Apr 2026 14:35:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="PUq9L9aS"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7150E376BCA
	for <live-patching@vger.kernel.org>; Wed, 29 Apr 2026 14:35:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777473353; cv=none; b=EdaHpbj+/5wnXdVo9Hd4WIbH2uOlabiIAH1UJf//bY16TrYfBXquBA1HMj/J5IbvrDQ3+vSpLsVvgVp1CZtaxLpeeYJbZWitvmvKOT7z+cXWu08yKyhFvASzVgYeTCNoZ9Z3jeeJkxr9DxsZ3LqJ2nOA8DdBltwgfX3swP5QuY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777473353; c=relaxed/simple;
	bh=QU8Gtp2Ecj/0+tiSHgBo9A1bT/rtptLfgh2zpMY5Do0=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=YifVVbk7dh6vHby15AtJVCmg6h9a1WWs7nqYUiFuKesEspcebFcAWF7Tzx+V7GvE1/PREcDcCVqLXzLz6WZRg+KkWCJe3p7MhOgWx0PbMXlOQLFD3aec59k1OcVc5pby0CmM0DHCj/FjafWrQKaSLhiI2a2OmI5YnI7VsOa7dck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=PUq9L9aS; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-488ff90d6c7so109256535e9.2
        for <live-patching@vger.kernel.org>; Wed, 29 Apr 2026 07:35:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1777473350; x=1778078150; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bKonRafws8Vd91X048+WRAFvNsFSWQAv1Z7gxzcqzL4=;
        b=PUq9L9aSq8zhpMWWppSsKzIjONfBvuFVOuDgoniLT60yiXemuIbnOs3KeZ6XCiNKOt
         bRNhKW3nxt+RPxEfNRxWRh3vfx+FLWGz2Usk7dxPE0AN1LqEazEWO/Jdyg7LQk+Hb8fN
         wZvcnFYSFgN9r0PQi40RwolRY5WmTbz5SjGQZGh0/anEWbNBajD3gFS9WHSB4CuKZ1xf
         WV+sG2aTFhTGUY7wlZVNVAsSseFfkLPx4vw/SxNtzlYUboego+5y37X29TQtphbTwZMi
         JAfEBNUIIKsn0PEPnZfZHTbBvkqJ8lhzQstZNUPD/ZqOAgNq7Pv6XcmWBPyTM/3TCFEj
         XfWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777473350; x=1778078150;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=bKonRafws8Vd91X048+WRAFvNsFSWQAv1Z7gxzcqzL4=;
        b=RRjUcG2WXaOi131jPFYi5BviSEtIpd8JfOvopkv3uomyMxlY6nBuLi1tojg++VaX9i
         bKrBmvgdz58ntMRAbWCna0077VxGofjkmvIxxqM0DUZ0br2LCtnuOsjgy4YxfW15MR5n
         9HA9/JjxGA3dCaDTf5+b1jTjTP2fuWK+GkFfxjtG7GVlC6N/Lp3ygTNRdlHMrXd3myJK
         qz/XP4KQFehj9edd9M3vX3MJgzAY0GNFSrF3GBNoUkns/ZU4Dj4OzFCQD1gT1IDJZfYZ
         YZJnbdb/HcLpbmTzzok4X7s+flnYJObztBfi9qfbrLUOoC53g5EZUfxFeok5SxoZ72pr
         jr0w==
X-Gm-Message-State: AOJu0Yy8pvSPOd0C+J7B6j8D8bkdlPYoYfZwHCX9SUEBG98d7tbakeUG
	JKCIsoc2KaPLsySG0kH4M4h6rIGTUVI9YU2qXEfAfs+8OWcOK985yJ4OTNS69zejcWE=
X-Gm-Gg: AeBDies3R+wrGg3g2F1gMWrzYakg3N5uoE2HVUajzyNc7RDjybeiARxj5S8xRIGNolw
	AvQQCoZRhb3uWX+5EC8npbPcW1Ryidnj10nXj9/zv4ZxH4OS/yAfKuoBr0fQNfO0QPj0+YnDy3P
	EBzZA6d77+XN4hZT1aCB1I4CFE2G4aHvcYcOaxXNVbB6rjzMTVj+YWOL3jIgH9L29YVqeW+rqF7
	FYdDpoumsO4B7Xo8Xw6sTDHNMsSfBbVu/UHmIVElvw8RSdkR5f8tHpglP54G6dTJPa4REVcRwuq
	obFE5XJyfBmZKMEyvZmij6QVczuSz3sQxKnGDmHIMz5Y545p1vOMIx+60ZqOYXyrxOcAeOP/U38
	SEb73dsfQowfindQy9e2esY+v/gZbzabc7JXA66uRY35olVjo8YLhSOSHWF5SbmqB0j5k6/cbDa
	JPvnbRxq2YatTa/3VuO+PygRjlY+5Ui58gDw==
X-Received: by 2002:a05:600c:470c:b0:48a:7965:b92a with SMTP id 5b1f17b1804b1-48a7b54bf53mr76042645e9.26.1777473349588;
        Wed, 29 Apr 2026 07:35:49 -0700 (PDT)
Received: from [127.0.0.1] ([2804:1bc4:224:7800:585c:db3a:fcb:e21f])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48a7c305371sm19982835e9.18.2026.04.29.07.35.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Apr 2026 07:35:49 -0700 (PDT)
From: Marcos Paulo de Souza <mpdesouza@suse.com>
Date: Wed, 29 Apr 2026 11:35:19 -0300
Subject: [PATCH v4 5/6] selftests: livepatch: Check if replace sysfs
 attribute exists
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260429-lp-tests-old-fixes-v4-5-59b9741989d0@suse.com>
References: <20260429-lp-tests-old-fixes-v4-0-59b9741989d0@suse.com>
In-Reply-To: <20260429-lp-tests-old-fixes-v4-0-59b9741989d0@suse.com>
To: Josh Poimboeuf <jpoimboe@kernel.org>, Jiri Kosina <jikos@kernel.org>, 
 Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>, 
 Joe Lawrence <joe.lawrence@redhat.com>, Shuah Khan <shuah@kernel.org>
Cc: live-patching@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Marcos Paulo de Souza <mpdesouza@suse.com>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1777473323; l=4029;
 i=mpdesouza@suse.com; s=20231031; h=from:subject:message-id;
 bh=QU8Gtp2Ecj/0+tiSHgBo9A1bT/rtptLfgh2zpMY5Do0=;
 b=Lycen9BKPhebiEKZl9TSNU987mTmLpYyteRqgP3CTcgN9CiXnSvtJsHnTuX552EMfhHDVA5CV
 Iece6KPnFmpCXsw/Ke/Cefp3DdzK+NbDfHzaLQ/yplv0MfTTqNcig28
X-Developer-Key: i=mpdesouza@suse.com; a=ed25519;
 pk=/Ni/TsKkr69EOmdZXkp1Q/BlzDonbOBRsfPa18ySIwU=
X-Rspamd-Queue-Id: 0DD5C4961A8
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
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[suse.com:+];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2605-lists,live-patching=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[mpdesouza@suse.com,live-patching@vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_FIVE(0.00)[5];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_SEVEN(0.00)[10];
	TO_DN_SOME(0.00)[]

The commit adb68ed26a3e ("livepatch: Add "replace" sysfs attribute"),
merged in v6.11, introduced a new sysfs attribute.

In order to run the selftests on older kernels, check if given kernel
has support for the attribute. If the attribute is not supported, skip
the checks.

Signed-off-by: Marcos Paulo de Souza <mpdesouza@suse.com>
---
 tools/testing/selftests/livepatch/test-sysfs.sh | 39 +++++++++++++++----------
 1 file changed, 23 insertions(+), 16 deletions(-)

diff --git a/tools/testing/selftests/livepatch/test-sysfs.sh b/tools/testing/selftests/livepatch/test-sysfs.sh
index 394cf3ff99cd..744c612a90d3 100755
--- a/tools/testing/selftests/livepatch/test-sysfs.sh
+++ b/tools/testing/selftests/livepatch/test-sysfs.sh
@@ -9,6 +9,7 @@ MOD_LIVEPATCH2=test_klp_callbacks_demo
 MOD_LIVEPATCH3=test_klp_syscall
 
 HAS_PATCH_ATTR=0
+HAS_REPLACE_ATTR=0
 
 setup_config
 
@@ -22,7 +23,6 @@ check_sysfs_rights "$MOD_LIVEPATCH" "" "drwxr-xr-x"
 check_sysfs_rights "$MOD_LIVEPATCH" "enabled" "-rw-r--r--"
 check_sysfs_value  "$MOD_LIVEPATCH" "enabled" "1"
 check_sysfs_rights "$MOD_LIVEPATCH" "force" "--w-------"
-check_sysfs_rights "$MOD_LIVEPATCH" "replace" "-r--r--r--"
 check_sysfs_rights "$MOD_LIVEPATCH" "stack_order" "-r--r--r--"
 check_sysfs_value  "$MOD_LIVEPATCH" "stack_order" "1"
 check_sysfs_rights "$MOD_LIVEPATCH" "transition" "-r--r--r--"
@@ -34,6 +34,11 @@ if does_sysfs_exist "$MOD_LIVEPATCH/vmlinux" "patched"; then
 	HAS_PATCH_ATTR=1
 fi
 
+if does_sysfs_exist "$MOD_LIVEPATCH" "replace"; then
+	check_sysfs_rights "$MOD_LIVEPATCH" "replace" "-r--r--r--"
+	HAS_REPLACE_ATTR=1
+fi
+
 disable_lp $MOD_LIVEPATCH
 
 unload_lp $MOD_LIVEPATCH
@@ -96,18 +101,19 @@ livepatch: 'test_klp_callbacks_demo': unpatching complete
 % rmmod test_klp_callbacks_demo"
 fi
 
-start_test "sysfs test replace enabled"
+if [[ "$HAS_REPLACE_ATTR" == "1" ]]; then
+	start_test "sysfs test replace enabled"
 
-MOD_LIVEPATCH=test_klp_atomic_replace
-load_lp $MOD_LIVEPATCH replace=1
+	MOD_LIVEPATCH=test_klp_atomic_replace
+	load_lp $MOD_LIVEPATCH replace=1
 
-check_sysfs_rights "$MOD_LIVEPATCH" "replace" "-r--r--r--"
-check_sysfs_value  "$MOD_LIVEPATCH" "replace" "1"
+	check_sysfs_rights "$MOD_LIVEPATCH" "replace" "-r--r--r--"
+	check_sysfs_value  "$MOD_LIVEPATCH" "replace" "1"
 
-disable_lp $MOD_LIVEPATCH
-unload_lp $MOD_LIVEPATCH
+	disable_lp $MOD_LIVEPATCH
+	unload_lp $MOD_LIVEPATCH
 
-check_result "% insmod test_modules/$MOD_LIVEPATCH.ko replace=1
+	check_result "% insmod test_modules/$MOD_LIVEPATCH.ko replace=1
 livepatch: enabling patch '$MOD_LIVEPATCH'
 livepatch: '$MOD_LIVEPATCH': initializing patching transition
 livepatch: '$MOD_LIVEPATCH': starting patching transition
@@ -120,17 +126,17 @@ livepatch: '$MOD_LIVEPATCH': completing unpatching transition
 livepatch: '$MOD_LIVEPATCH': unpatching complete
 % rmmod $MOD_LIVEPATCH"
 
-start_test "sysfs test replace disabled"
+	start_test "sysfs test replace disabled"
 
-load_lp $MOD_LIVEPATCH replace=0
+	load_lp $MOD_LIVEPATCH replace=0
 
-check_sysfs_rights "$MOD_LIVEPATCH" "replace" "-r--r--r--"
-check_sysfs_value  "$MOD_LIVEPATCH" "replace" "0"
+	check_sysfs_rights "$MOD_LIVEPATCH" "replace" "-r--r--r--"
+	check_sysfs_value  "$MOD_LIVEPATCH" "replace" "0"
 
-disable_lp $MOD_LIVEPATCH
-unload_lp $MOD_LIVEPATCH
+	disable_lp $MOD_LIVEPATCH
+	unload_lp $MOD_LIVEPATCH
 
-check_result "% insmod test_modules/$MOD_LIVEPATCH.ko replace=0
+	check_result "% insmod test_modules/$MOD_LIVEPATCH.ko replace=0
 livepatch: enabling patch '$MOD_LIVEPATCH'
 livepatch: '$MOD_LIVEPATCH': initializing patching transition
 livepatch: '$MOD_LIVEPATCH': starting patching transition
@@ -142,6 +148,7 @@ livepatch: '$MOD_LIVEPATCH': starting unpatching transition
 livepatch: '$MOD_LIVEPATCH': completing unpatching transition
 livepatch: '$MOD_LIVEPATCH': unpatching complete
 % rmmod $MOD_LIVEPATCH"
+fi
 
 start_test "sysfs test stack_order value"
 

-- 
2.54.0


