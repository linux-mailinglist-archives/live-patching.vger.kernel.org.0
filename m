Return-Path: <live-patching+bounces-2703-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id EDUbCbDn+Gmt2wIAu9opvQ
	(envelope-from <live-patching+bounces-2703-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Mon, 04 May 2026 20:38:40 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F71E4C2AAA
	for <lists+live-patching@lfdr.de>; Mon, 04 May 2026 20:38:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id DF31630A1BB4
	for <lists+live-patching@lfdr.de>; Mon,  4 May 2026 18:35:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B57C92253EC;
	Mon,  4 May 2026 18:35:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="P87wQR3h"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3F243E1D04
	for <live-patching@vger.kernel.org>; Mon,  4 May 2026 18:35:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777919732; cv=none; b=neg7DZKTc5imFoiFlYOvZGYKaWCp6bgTOPnYU7o3kyAwItYbMqQ+FbY7/vgeFp/5H3qFr9Mre36/Az7vyAHqAz8oa/7+QVF5ejBkgFajPApTArD/ZLtLXLxcKlMI6nCFunl7W3QCBQC84iIU++jbwOv89nkM9GHguK88nSgFyTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777919732; c=relaxed/simple;
	bh=ZvTXbQvvVARQQXEwnJaBzX4ewSTwJzx3zawM/8FKYoo=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=IBv/RFeZ6thAW7IU6a6BXsf4opjhEVPD5AQsXbqF+J61XExbJdFzXYWGdTs0eORdeNgnd2p4NB2SYuCUho/q29XkLLvL+MTdUaMfuptZ8lPvmylUql+2enZjFN6jdt/BFYJJLFobL1ywUWxS67+m8G965pK7d4BXYa30j61Pz34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=P87wQR3h; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-48a563e4ef7so42499825e9.0
        for <live-patching@vger.kernel.org>; Mon, 04 May 2026 11:35:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1777919728; x=1778524528; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RYEFtul8vd0vBjHaC+i5w2P21RsoXDngoLSxAnb1syM=;
        b=P87wQR3hvOACpwTGLleegcbEsY6eNiCD0x5hV7zNWXJXoTINZ4h5iI5O7djvYA5f+A
         KR8ONyRE/LwAIpyEjTxeJWjr/ruzXOI7UmYfx4iVcqPghkcFl0gztdcC0LVOsxTB+8h0
         /x2vG33g2KOHNxykEzcXPCVAILcwB53lCSU5JAcnAVQjULFONfLNvh/s3q/EBvVuaeRs
         U/fbZoS+/VVI9hefQbqPJl0PluqjmraXI7x14ESkEZKMRMKSzNVCEq+F938rJqo95euD
         MOeLzj1rzxvrM4bxwpXrF7ASj9W87JyRXj48pPqNAuYDYy5dPIL/YXFgcWHflQ+er8+x
         gEPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777919728; x=1778524528;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=RYEFtul8vd0vBjHaC+i5w2P21RsoXDngoLSxAnb1syM=;
        b=ZkszXxwvIQ4cVeyWoPwBvjeYf5nCucWpbr6TCuit9IfY1FNoxW81FHKlwA59OvSc2p
         HiJcvyk8uFLEdwZW/9IygQdAYGM1cYlJBRFPRbtbdx0QgkHooc3CN3m7fdi7uQE4h5rb
         gxTZDJ/pWI65h3r9Ww8xSF8auJyQjiQGUtHxrNzfR1czwFNu+5wHl5MRaU15uqfEtmaB
         doHJ73z5p0l6lUxuhmqALBr/UWDjsy0IsDsjRwIK4nnqMomx6/VQyVY2W0FxZ7jTcQdM
         nNdFs0JnluCyLIEU+EF3JsXB04ZoUEKs+mHIRcRJrvNcKwybqyVAxFpfGjp63qD/wHXS
         33Hw==
X-Gm-Message-State: AOJu0YwU7c38YVwBT+0COqOs/qHs+UmrkAWvXfmON/JImDtZ56qbIXXJ
	11qgEqEfWVyNOnHnD1bGNBmzdYXQGb5MD2Uce2c2+x8baZ0PZgaK/5Z5+26PdcGZmN0=
X-Gm-Gg: AeBDievQdSNBV3yuto0qF2VU8/nq0/fwLLd4LJLijbZEAv7tf9xWket17grlKTFm5MB
	P4TA74moNr343GVzlZi5JnPLw1xJb0KZlITTJYKVwaNHGvky4VjSeA7DLLOexPZbmqGrzbDVD8J
	M8/VPRSP32dGOPmjNChTCPFVS8RZ1J0t8S2VYp8M6BEWzVUdfW7oUEOd2pkYD0aEkS/ek6F5OTk
	GhBnU1OY8wlqQ7I/dn9/DBrMaKMWQiySLPbEwLFJ2f7e7rpoC1YyUNqJvOQGZnzOx/VCAX7j9k0
	dj7E0/WAQvlFgdNzFeT+Dm/T0Y+2EUqJaDE1P4b74YA8ZmFLvrMa458CAtGsj2t0MEFJOe+tf6z
	SRiRatr6GNmhZJWX/NFAkBFjHkZeu9OkcnvtZjtSMXA/HFJ6YsZVO9U10iQCO5GlhHTe10oII3n
	cFtr9VQIGxHpKqssiI8B1CVKFC7Khbk5qAhw==
X-Received: by 2002:a05:600c:c095:b0:487:12c:e7e1 with SMTP id 5b1f17b1804b1-48a98637de2mr170634125e9.11.1777919728436;
        Mon, 04 May 2026 11:35:28 -0700 (PDT)
Received: from [127.0.0.1] ([2804:1bc4:224:7800:585c:db3a:fcb:e21f])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-44a98b76eddsm26745511f8f.34.2026.05.04.11.35.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 May 2026 11:35:28 -0700 (PDT)
From: Marcos Paulo de Souza <mpdesouza@suse.com>
Date: Mon, 04 May 2026 15:34:47 -0300
Subject: [PATCH v5 6/6] selftests: livepatch: Check if stack_order sysfs
 attribute exists
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260504-lp-tests-old-fixes-v5-6-0be26d94ab9a@suse.com>
References: <20260504-lp-tests-old-fixes-v5-0-0be26d94ab9a@suse.com>
In-Reply-To: <20260504-lp-tests-old-fixes-v5-0-0be26d94ab9a@suse.com>
To: Josh Poimboeuf <jpoimboe@kernel.org>, Jiri Kosina <jikos@kernel.org>, 
 Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>, 
 Joe Lawrence <joe.lawrence@redhat.com>, Shuah Khan <shuah@kernel.org>
Cc: live-patching@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Marcos Paulo de Souza <mpdesouza@suse.com>, 
 marcos@mpdesouza.com
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1777919697; l=3644;
 i=mpdesouza@suse.com; s=20231031; h=from:subject:message-id;
 bh=ZvTXbQvvVARQQXEwnJaBzX4ewSTwJzx3zawM/8FKYoo=;
 b=MXIRvCBUPAt1B8d+Ub66kDeZOy+KYi/sFRWYhXtX4PVbgZDg9tmKGz+KegOVLCLPEnNS7YQ50
 fYgaRWKlDmHA532Wmwp/RnPTr3WHqx47d1Fukc3LM7mobwTBD14ObX8
X-Developer-Key: i=mpdesouza@suse.com; a=ed25519;
 pk=/Ni/TsKkr69EOmdZXkp1Q/BlzDonbOBRsfPa18ySIwU=
X-Rspamd-Queue-Id: 7F71E4C2AAA
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
	TAGGED_FROM(0.00)[bounces-2703-lists,live-patching=lfdr.de];
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
	RCPT_COUNT_SEVEN(0.00)[11];
	TO_DN_SOME(0.00)[]

The commit 3dae09de4061 ("livepatch: Add stack_order sysfs attribute"),
merged in v6.14, introduced a new sysfs attribute.

In order to run the selftests on older kernels, check if given kernel
has support for the attribute. If the attribute is not supported, skip
the checks.

Signed-off-by: Marcos Paulo de Souza <mpdesouza@suse.com>
---
 tools/testing/selftests/livepatch/test-sysfs.sh | 43 ++++++++++++++-----------
 1 file changed, 25 insertions(+), 18 deletions(-)

diff --git a/tools/testing/selftests/livepatch/test-sysfs.sh b/tools/testing/selftests/livepatch/test-sysfs.sh
index fed656021271..3b16285c6e67 100755
--- a/tools/testing/selftests/livepatch/test-sysfs.sh
+++ b/tools/testing/selftests/livepatch/test-sysfs.sh
@@ -10,6 +10,7 @@ MOD_LIVEPATCH3=test_klp_syscall
 
 HAS_PATCH_ATTR=0
 HAS_REPLACE_ATTR=0
+HAS_STACK_ORDER_ATTR=0
 
 setup_config
 
@@ -23,8 +24,6 @@ check_sysfs_rights "$MOD_LIVEPATCH" "" "drwxr-xr-x"
 check_sysfs_rights "$MOD_LIVEPATCH" "enabled" "-rw-r--r--"
 check_sysfs_value  "$MOD_LIVEPATCH" "enabled" "1"
 check_sysfs_rights "$MOD_LIVEPATCH" "force" "--w-------"
-check_sysfs_rights "$MOD_LIVEPATCH" "stack_order" "-r--r--r--"
-check_sysfs_value  "$MOD_LIVEPATCH" "stack_order" "1"
 check_sysfs_rights "$MOD_LIVEPATCH" "transition" "-r--r--r--"
 check_sysfs_value  "$MOD_LIVEPATCH" "transition" "0"
 
@@ -39,6 +38,12 @@ if does_sysfs_exist "$MOD_LIVEPATCH" "replace"; then
 	HAS_REPLACE_ATTR=1
 fi
 
+if does_sysfs_exist "$MOD_LIVEPATCH" "stack_order"; then
+	check_sysfs_rights "$MOD_LIVEPATCH" "stack_order" "-r--r--r--"
+	check_sysfs_value  "$MOD_LIVEPATCH" "stack_order" "1"
+	HAS_STACK_ORDER_ATTR=1
+fi
+
 disable_lp $MOD_LIVEPATCH
 
 unload_lp $MOD_LIVEPATCH
@@ -149,33 +154,34 @@ livepatch: '$MOD_ATOMIC_REPLACE': unpatching complete
 % rmmod $MOD_ATOMIC_REPLACE"
 fi
 
-start_test "sysfs test stack_order value"
+if [[ "$HAS_STACK_ORDER_ATTR" == "1" ]]; then
+	start_test "sysfs test stack_order value"
 
-load_lp $MOD_LIVEPATCH
+	load_lp $MOD_LIVEPATCH
 
-check_sysfs_value  "$MOD_LIVEPATCH" "stack_order" "1"
+	check_sysfs_value  "$MOD_LIVEPATCH" "stack_order" "1"
 
-load_lp $MOD_LIVEPATCH2
+	load_lp $MOD_LIVEPATCH2
 
-check_sysfs_value  "$MOD_LIVEPATCH2" "stack_order" "2"
+	check_sysfs_value  "$MOD_LIVEPATCH2" "stack_order" "2"
 
-load_lp $MOD_LIVEPATCH3
+	load_lp $MOD_LIVEPATCH3
 
-check_sysfs_value  "$MOD_LIVEPATCH3" "stack_order" "3"
+	check_sysfs_value  "$MOD_LIVEPATCH3" "stack_order" "3"
 
-disable_lp $MOD_LIVEPATCH2
-unload_lp $MOD_LIVEPATCH2
+	disable_lp $MOD_LIVEPATCH2
+	unload_lp $MOD_LIVEPATCH2
 
-check_sysfs_value  "$MOD_LIVEPATCH" "stack_order" "1"
-check_sysfs_value  "$MOD_LIVEPATCH3" "stack_order" "2"
+	check_sysfs_value  "$MOD_LIVEPATCH" "stack_order" "1"
+	check_sysfs_value  "$MOD_LIVEPATCH3" "stack_order" "2"
 
-disable_lp $MOD_LIVEPATCH3
-unload_lp $MOD_LIVEPATCH3
+	disable_lp $MOD_LIVEPATCH3
+	unload_lp $MOD_LIVEPATCH3
 
-disable_lp $MOD_LIVEPATCH
-unload_lp $MOD_LIVEPATCH
+	disable_lp $MOD_LIVEPATCH
+	unload_lp $MOD_LIVEPATCH
 
-check_result "% insmod test_modules/$MOD_LIVEPATCH.ko
+	check_result "% insmod test_modules/$MOD_LIVEPATCH.ko
 livepatch: enabling patch '$MOD_LIVEPATCH'
 livepatch: '$MOD_LIVEPATCH': initializing patching transition
 livepatch: '$MOD_LIVEPATCH': starting patching transition
@@ -215,5 +221,6 @@ livepatch: '$MOD_LIVEPATCH': starting unpatching transition
 livepatch: '$MOD_LIVEPATCH': completing unpatching transition
 livepatch: '$MOD_LIVEPATCH': unpatching complete
 % rmmod $MOD_LIVEPATCH"
+fi
 
 exit 0

-- 
2.54.0


