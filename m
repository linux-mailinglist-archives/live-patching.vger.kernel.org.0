Return-Path: <live-patching+bounces-2343-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 4JSNOYsn3WmJaQkAu9opvQ
	(envelope-from <live-patching+bounces-2343-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Mon, 13 Apr 2026 19:27:39 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id D49C73F16D9
	for <lists+live-patching@lfdr.de>; Mon, 13 Apr 2026 19:27:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 35694301D097
	for <lists+live-patching@lfdr.de>; Mon, 13 Apr 2026 17:27:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8AA67361DDE;
	Mon, 13 Apr 2026 17:26:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Gc9Fi0E9"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFABB364943
	for <live-patching@vger.kernel.org>; Mon, 13 Apr 2026 17:26:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776101207; cv=none; b=d9VAuld8ftbpXOzu6sApXeAVC2jIQO2eJVtTNi0Fw4n+84sfkBS14r9BoO0Onfq4SUWDoPOxyrVsE2VdUYQUCunsepQNjp+FuP4BQ6HJuc4NudtdLhgFAwk2A2IhAri1jod1h9F5ijAZW2kBtO6zz+mWhkROtK0Wv3sA2nX9J7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776101207; c=relaxed/simple;
	bh=6ReFlyvGzXzUCafoIGtDH3q4ySU8bPRHczfokrsszrs=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=CIHko5JS9etB6aFsj4bKyW7VXq44yall6rU8Rz3KScWrX5Ylq/oeY/44SuL4AlGhLBKI6CLB5e8+vHJvtLPHqy6CvL1rsfpUr6hVj4h/J/hJNde4RKfqciFiB27lIEzk4XZkwKSIz2D2X/GFKpY1MwgoGxB4LbcP1PajNxPgbc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Gc9Fi0E9; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-488a041eae5so34535135e9.1
        for <live-patching@vger.kernel.org>; Mon, 13 Apr 2026 10:26:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1776101201; x=1776706001; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=f+AJJ/Q5Rc6YFzJLqVkyhH/nYiW7ogrRYDhpSnoYYWk=;
        b=Gc9Fi0E9t57eYIQRnNTVd8PorF6UoOOJse0B/hFk7W3mwfmG1S9VgHaM79fRi0xC9U
         WQeIzvVZPwBUz9+OtgElLvwqRxYHhMBiT+R0tZW77WFmA9nJ5sdrSi60ldz2sLm9gl9H
         5PExFGfzEAVnBIDG/+f8IpfGMBfEVKGdYf5YEhgjlD+jHLdGwA4IRMVecGk9aKrywwuz
         6rSHJzMEfl2AX4NabrD3I4WzpbiR3P3J2MjFDTl9RzFdtcqvbP75is5Pk3AcngkCIq2J
         8v4l+fr0Nb4ghMH1ut9DOcnPBnvknm0Zu4SG5oN0boyj3G6N6pBKB+g8KsaxC2GqyUna
         wQKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776101201; x=1776706001;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=f+AJJ/Q5Rc6YFzJLqVkyhH/nYiW7ogrRYDhpSnoYYWk=;
        b=U3wrKQzaBqmBFknoiRW6yMhAWpDUu0LCS/DfbUEfBFUnF77qDtQxXbtzvEJSpuuOtQ
         gWNXXhgmlDqcwBxUqO658cXpLaKxeikgd4U0pZPq2izx5LwEAa3HHuwTfw1vC6XlFmf6
         VFpQA42Qb9dSHfobji3OUw4s9LYKiBUreKGzNPuAkRaXoiahRG8MpwcVIiBuYu6EBf5L
         dw4p0LRYV5P5R79eEkPQGpNzI5sc9b+AE1ebsdIVQCs5JQqo9ElpeSyF29SLQ3uOTn/Y
         75f4fZhhJGgqlW/VCbx8ROwsU00rOs6ODSlmW5nEkrQjPYvoxPW4iYu9PjVSaM5zfr7V
         8h6A==
X-Gm-Message-State: AOJu0YwAuTQEeXHqXmdOL8NZsHuCa0ufzDBdkPbOA9KZk1mexIcStv9E
	BnBPgmhzJ7GBzWWTOc4dJVQuUnlP/pP+M5F9SwCPOPuP7VrRYTZttthZgvVd2Ty8XSZa0/qowRY
	mTTWrzP8=
X-Gm-Gg: AeBDietxpWscF5Z545AjreByFevB9llFsFYG9aOmQaf0gxWvVEpQMnsp/W4GKe372hG
	qiLxa9TQ7npswNySbv+i7UKUFDsOs2if9wX5jVT2dIaOOb7DL8QiCv5g1ul5cODqsiZj36NfMn5
	W68CGe/K4buZNPEy9wtl02jUpcqMF6nDfNa9sWKrilXgUtnCJFY/ex5wqmQKhq5u57w8/CgzdUA
	HZY6ruBlg0fOPWIW/Kt5kH9GKcsl1K7/Ebit7F8AV2x+qQDjpr5/A5TjqMw+45GXNQd4+vkOQhF
	RjR/Gj9/hD4OBrWj5LPPQBuW6NjsvT63QftZhGq7IvdRegzP3FrNNUQhaH8bfzw2/if0cuqnSqb
	Hz3euuak44nQsKXRA/OZBNWmJqzi0OolVQ04yBOyP0UWkXtvz6g7uf8DDE6u4SqBRExSyM9kTU3
	DOR0aNA9o67qR4n3TVu4i9tb0VMPBPJWxKUQ==
X-Received: by 2002:a05:600c:800f:b0:47e:e2eb:bc22 with SMTP id 5b1f17b1804b1-488d67b8d81mr189094775e9.5.1776101200774;
        Mon, 13 Apr 2026 10:26:40 -0700 (PDT)
Received: from [127.0.0.1] ([2804:1bc4:224:7800:585c:db3a:fcb:e21f])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-488d5734a94sm298657835e9.0.2026.04.13.10.26.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Apr 2026 10:26:40 -0700 (PDT)
From: Marcos Paulo de Souza <mpdesouza@suse.com>
Date: Mon, 13 Apr 2026 14:26:17 -0300
Subject: [PATCH v2 6/6] selftests: livepatch: Check if stack_order sysfs
 attribute exists
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260413-lp-tests-old-fixes-v2-6-367c7cb5006f@suse.com>
References: <20260413-lp-tests-old-fixes-v2-0-367c7cb5006f@suse.com>
In-Reply-To: <20260413-lp-tests-old-fixes-v2-0-367c7cb5006f@suse.com>
To: Josh Poimboeuf <jpoimboe@kernel.org>, Jiri Kosina <jikos@kernel.org>, 
 Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>, 
 Joe Lawrence <joe.lawrence@redhat.com>, Shuah Khan <shuah@kernel.org>
Cc: live-patching@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Marcos Paulo de Souza <mpdesouza@suse.com>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1776101176; l=3509;
 i=mpdesouza@suse.com; s=20231031; h=from:subject:message-id;
 bh=6ReFlyvGzXzUCafoIGtDH3q4ySU8bPRHczfokrsszrs=;
 b=7mb/+qSN7QPVFL9r2CbQslH6NyjmQ1Kc3ZDLHqKzrykSfcBDIlOcpMSrm1KgYWMdNt6lKLlKV
 b/sxwXOmmChClWXI5E7SRC0KLvJ4n/sYBv24cbOkC4xQ18AFQOw06rJ
X-Developer-Key: i=mpdesouza@suse.com; a=ed25519;
 pk=/Ni/TsKkr69EOmdZXkp1Q/BlzDonbOBRsfPa18ySIwU=
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[suse.com,quarantine];
	R_DKIM_ALLOW(-0.20)[suse.com:s=google];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DKIM_TRACE(0.00)[suse.com:+];
	TAGGED_FROM(0.00)[bounces-2343-lists,live-patching=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_SEVEN(0.00)[10];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,suse.com:dkim,suse.com:email,suse.com:mid]
X-Rspamd-Queue-Id: D49C73F16D9
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

In order to run the selftests on older kernels, check if given kernel
has support for the attribute. If the attribute is not supported, skip
the checks.

Signed-off-by: Marcos Paulo de Souza <mpdesouza@suse.com>
---
 tools/testing/selftests/livepatch/test-sysfs.sh | 43 ++++++++++++++-----------
 1 file changed, 25 insertions(+), 18 deletions(-)

diff --git a/tools/testing/selftests/livepatch/test-sysfs.sh b/tools/testing/selftests/livepatch/test-sysfs.sh
index 0cdaeef00983..77f515529646 100755
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
 
@@ -39,6 +38,12 @@ if does_sysfs_exists "$MOD_LIVEPATCH" "replace"; then
 	HAS_REPLACE_ATTR=1
 fi
 
+if does_sysfs_exists "$MOD_LIVEPATCH" "stack_order"; then
+	check_sysfs_rights "$MOD_LIVEPATCH" "stack_order" "-r--r--r--"
+	check_sysfs_value  "$MOD_LIVEPATCH" "stack_order" "1"
+	HAS_STACK_ORDER_ATTR=1
+fi
+
 disable_lp $MOD_LIVEPATCH
 
 unload_lp $MOD_LIVEPATCH
@@ -150,33 +155,34 @@ livepatch: '$MOD_LIVEPATCH': unpatching complete
 % rmmod $MOD_LIVEPATCH"
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
@@ -216,5 +222,6 @@ livepatch: '$MOD_LIVEPATCH': starting unpatching transition
 livepatch: '$MOD_LIVEPATCH': completing unpatching transition
 livepatch: '$MOD_LIVEPATCH': unpatching complete
 % rmmod $MOD_LIVEPATCH"
+fi
 
 exit 0

-- 
2.52.0


