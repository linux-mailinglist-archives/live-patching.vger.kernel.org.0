Return-Path: <live-patching+bounces-2568-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id kE52KHSs72lIDwEAu9opvQ
	(envelope-from <live-patching+bounces-2568-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Mon, 27 Apr 2026 20:35:32 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 478D7478ABE
	for <lists+live-patching@lfdr.de>; Mon, 27 Apr 2026 20:35:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 1C2EF30C64B9
	for <lists+live-patching@lfdr.de>; Mon, 27 Apr 2026 18:31:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CEBA03ECBD6;
	Mon, 27 Apr 2026 18:31:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="esKtUfa9"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B06A3EC2F0
	for <live-patching@vger.kernel.org>; Mon, 27 Apr 2026 18:31:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777314690; cv=none; b=F14hwYkmymh1KdSlT9SVFcs05ql3Rt3owXyi4dMG60/FmuGTECO49pnigt4bKaNfI3k24RPKTw6VGg2vySLYf/mBbjVIkg/ncY1kcg/r5pK/Dc35h5P2VUN6DIEOFmGf/DD9LiL0DxkyAdBTc8/07bGbkUKL62a95P5Axa2sjpE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777314690; c=relaxed/simple;
	bh=F9d6PBr1+/K4ckE8UJhOXONnbp2b82hTORgGVjrcAuU=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Io/Nij1xl4no2RRlFtN1CSX78PPaLEEfPSiYAIooAfZB3KL/efitnLLllML4simzRc/4nyZUfBUX56Ene7nIjoilvvN/o/UAb8UKBYAli9yShKr8jwYaA6gWPweaPoyVY1ZJ6639zJzFw5HfLMMb8l2cHp7CAUcT0Z6hepREqJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=esKtUfa9; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4891f625344so95611385e9.0
        for <live-patching@vger.kernel.org>; Mon, 27 Apr 2026 11:31:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1777314687; x=1777919487; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UjtkWRBFA/1Gy4WW9Vb+jxm+URT45UeeL62kECqzZxA=;
        b=esKtUfa9aFarEBAknLOyrg+h0DxoUCjIYioRW1SPtVgKzq4sIA1QK98AA/S+nO6pvK
         68Hur9JS0Pm6ISvhmor47ZKcf7vaYrrrwV6TSZdHd2hIUvC2vg3IVSmxprTlVve+/9AN
         bt80B5PNE9zrGGbhk5vJtX8h1t01WEQTt0gayW5B2CqQ0JIOmBvPU6W6zPN4i6+sUPUR
         p4P8Y4Rl5Bf0oXGoReK1lR7pnShOi9jaKzhJfVAPSrWIieV5jVE/Q1X8S8BfTQ7YrMLj
         CcpZasabug7frFLqfbtCWcBYtqvqPfdN8AzZmUGA7ei18zQy7qCSRQKKadaMpcO5YXa+
         eovQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777314687; x=1777919487;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=UjtkWRBFA/1Gy4WW9Vb+jxm+URT45UeeL62kECqzZxA=;
        b=BrDwf95DnzQ809sL72MfsHequWA0BKdCXv8oy2SMuCKcAeQIbPyGdoBCNWVCTIwDaH
         vfnTEyCuzh+zxZP9sNzxsz1ZGRDDnMbYVadqV/pmrDwk2D/nlvboq9+tVcoTx7TUwUII
         7bI8W4U6dhokuDTOe1OjbWIoYdHWSieCbj05fcCgIwyLx2GhZDJ2Deejph6bt90EV2Gx
         c5KZszmKD1no/3JFUgWR+9RDWfMer0EP4L0VO80kaCK6zYBRvOxi7eDiQWL2fevFZpl2
         wm2LhkOKaHF4kE1dwImzWO4+5hfHOEm4NblpjVWmY2vRz4yIjIlFzCpWgioe9XxRQlRM
         KV1g==
X-Gm-Message-State: AOJu0Yw6BtDLQ8XexYsG1GPMqMEkvkPi3S81CtizVQWlzXXJTwWIAjsB
	aibji3xuGCi412jOfJS3dRBoZcESP65K1ATJUHMt5gi3Mme7Vdmhf/7APxctnHlac0RzZ+75jAL
	qAgumpd8=
X-Gm-Gg: AeBDiethWwVRMulGILjprGMrgR2US5NVo84RpUyU+JxKyNjfxxAO3kRKeRKJrl7yVuq
	TW0ueB+k8TjfJS24SCTJvzuVAZIWbUmK3uUhbEsN4HkSuw5sqYuPXJp9wKPNQVrobO0qX0ZQw7Z
	25MowLeKr1/8Of+cIFwnuMFIaMAyxPCYHq0vfiNAS0fKbnri7sw19g6oNSbfxTBiJ2cQ1PIbR4O
	d46Dy9OpaiHdm54tUtmPTEPGarCK5KhCMFPIQx1P/kzp5uz1mS35tTl0tqzU/u28dR0wmZBsSru
	xokbYGO3GDDnIBegzr8diUqkU89xWyuJBZcBZQ29wlny1JZq4tJTMuRCj0DOgf6nBaCVvx92E/+
	XjlLodFnwpFmyo+i5VhWZbf9cJIXp/wI9irfVzX1kKMCeWOaIcPC+WQWUG/oW1a181/eJMAEOs8
	aPReOo9NRuaA0oXN9KJimQ0qR2el0LzRjjEA==
X-Received: by 2002:a05:600c:1c1b:b0:48a:5339:a46 with SMTP id 5b1f17b1804b1-48a7763cb34mr2682085e9.9.1777314687237;
        Mon, 27 Apr 2026 11:31:27 -0700 (PDT)
Received: from [127.0.0.1] ([2804:1bc4:224:7800:585c:db3a:fcb:e21f])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48a7749cabdsm1182065e9.9.2026.04.27.11.31.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Apr 2026 11:31:26 -0700 (PDT)
From: Marcos Paulo de Souza <mpdesouza@suse.com>
Date: Mon, 27 Apr 2026 15:31:02 -0300
Subject: [PATCH v3 6/6] selftests: livepatch: Check if stack_order sysfs
 attribute exists
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260427-lp-tests-old-fixes-v3-6-ccf3c90f744c@suse.com>
References: <20260427-lp-tests-old-fixes-v3-0-ccf3c90f744c@suse.com>
In-Reply-To: <20260427-lp-tests-old-fixes-v3-0-ccf3c90f744c@suse.com>
To: Josh Poimboeuf <jpoimboe@kernel.org>, Jiri Kosina <jikos@kernel.org>, 
 Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>, 
 Joe Lawrence <joe.lawrence@redhat.com>, Shuah Khan <shuah@kernel.org>
Cc: live-patching@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Marcos Paulo de Souza <mpdesouza@suse.com>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1777314662; l=3634;
 i=mpdesouza@suse.com; s=20231031; h=from:subject:message-id;
 bh=F9d6PBr1+/K4ckE8UJhOXONnbp2b82hTORgGVjrcAuU=;
 b=dFnpCs2V4iZjjH921Uun2jOYSBmBjt2A650cuRcFLbWx3CAphw9odj2L2W2DVcgAEraJS8HHn
 Ird6vvqQxbLCp0coplJ12QM63W7b8HghUh8w+tLIbBd8X63lV2kSMAQ
X-Developer-Key: i=mpdesouza@suse.com; a=ed25519;
 pk=/Ni/TsKkr69EOmdZXkp1Q/BlzDonbOBRsfPa18ySIwU=
X-Rspamd-Queue-Id: 478D7478ABE
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
	DKIM_TRACE(0.00)[suse.com:+];
	TAGGED_FROM(0.00)[bounces-2568-lists,live-patching=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_SEVEN(0.00)[10];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.com:dkim,suse.com:mid,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]

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
index 744c612a90d3..ce67a2b770d0 100755
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
2.54.0


