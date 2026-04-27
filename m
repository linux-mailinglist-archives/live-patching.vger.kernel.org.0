Return-Path: <live-patching+bounces-2567-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id gJMdH0ys72lIDwEAu9opvQ
	(envelope-from <live-patching+bounces-2567-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Mon, 27 Apr 2026 20:34:52 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C7C98478A7B
	for <lists+live-patching@lfdr.de>; Mon, 27 Apr 2026 20:34:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 1F32730B6E13
	for <lists+live-patching@lfdr.de>; Mon, 27 Apr 2026 18:31:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E338C3ECBC9;
	Mon, 27 Apr 2026 18:31:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="D0Pq8NKJ"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 330FD3EC2F0
	for <live-patching@vger.kernel.org>; Mon, 27 Apr 2026 18:31:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777314686; cv=none; b=QVMfOOUFHlHM9h0QKxNFfA/i0PqxUMRia5X+Mm1yjqruyh+MF7sz6BARfR4TWSwfm/C0IKbeW2g+HuEXdvepZSizeMQNXy4W8oEJMXJcT7UKwqI++gLlc0r+Ls/BWunAi7abPCXKH+Xyn1uX/v6E2hZtU5h0+jFi4ztCqWqPON8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777314686; c=relaxed/simple;
	bh=QU8Gtp2Ecj/0+tiSHgBo9A1bT/rtptLfgh2zpMY5Do0=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=XhL6A+90EXKbQcwMbvUCIrcjWitQW/BlxWV07BtPS3BIpQONCy5+Mx1OWSdv4vLrSac7TDMz65+5EwJOOTuHr27NAgCghxAbW88m5DvfyxFYa2TDjYGJh4oA/gofkfRHMDAi/khtmpz6a5EVPNWFWuXZlwYVW/L6c63DieToY1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=D0Pq8NKJ; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-483487335c2so104036625e9.2
        for <live-patching@vger.kernel.org>; Mon, 27 Apr 2026 11:31:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1777314683; x=1777919483; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bKonRafws8Vd91X048+WRAFvNsFSWQAv1Z7gxzcqzL4=;
        b=D0Pq8NKJG2sc9riogzH2vYvufrHsFkcTlcQc+3dB6Uwo+EWglXn80tOrKsiy4/xKfS
         u8zhiEsT3q+9dduJ5HpTof7fDbKqgyDUVuWJIMO/WaGcIXI5Q/4RAYAhZiYfiKfyJXk1
         PcX6Be1tsfvvsNi9IfulfANHWcMw9Gs9Y3e/OR1S1L9pqY2mISW6Qy8/Uo2JMhSDLMVG
         cauEvWzZaNNyqM0m2yfe5Fg4+cttwXRg0hS0kyTfRWSrptMhY8sqfOHb6OArHc31Fw+6
         jdWExfzVd+qvyIKtyNkf+3K4P0ViYPHhVdE4TN8FoGxmTTecITkk0VNz3Hv/KjgF4SiW
         63Pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777314683; x=1777919483;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=bKonRafws8Vd91X048+WRAFvNsFSWQAv1Z7gxzcqzL4=;
        b=SZ/G3sx4Q5POuy05tNXBDyRh4DFflOeVAVrX1UCy3uUV0dLyYImuYWqfxO3KrIaPNG
         31V45wIi7zj2YGp5pVLDomjr43zD0TQM177+AVYs4bFp35dlZeMH5DWc9knGhcq+X3Dr
         90OyGrvVvU2DvariUulKVyZzrUHXP8Gb75fqfozrox+fhiS2Vl+neTk4BkQxM3M1JmWD
         WomA46jiwq9/MoWEb2wIzosj92D0MPR7PH0+79qsUTxGp8mmO6EPHH2RFUr9msmcxmNe
         wBcJpxYYF03WDFeUPXilPfHUE9jrUHvVQ5eOd2jK4+BzSdRS1nViUG3h+i57rsj4t1Ep
         ZeGA==
X-Gm-Message-State: AOJu0YxbcxFd5tggEZTnoVDcBM1K4lTpRvxMhstQ+O+tzgPiJiyEV5rz
	00XvVaPo459MODB3gbb58CI0A573tye+d9PQ/t2u685OqTz1ndrLW1cYksrVGxJYV5zOHkr2wrk
	2fajwTMA=
X-Gm-Gg: AeBDiesN32Lv/W9Mkj6EuwvInC2WyUG7/lNYB6S/NxT1oJtOGXdA2q4irg1B4TZtTZj
	5JcUzPRUHXhDFTEZjPkHcozs4SSqQUzeZf34NeS/Uy91RsZyXt2XlmAHK2UzT/CshVPyQUCdNRF
	T4p+kXeyMbHGHVgK2kvActE/NTqHt6xGjPPoy2+OeMH1o92pbSlB4+CFIlrnAPiwCpUuFsaQLSv
	1rGGLOm9fx0hB0mEA1Hv3BdCTxdYw29ifivbRROCc1IVjOAxahX3DOzhdCpKAFmb7wwdAY8YcYg
	39fZ0bNAJ2HviAbD/tisUdvTHm8m3x/oN8CCSDEaCVW1Dgd6kmd1E3d3wt8v8jsLo4hdkzrqgCP
	D7ZnaE4cXGpxpkGtS/TPkrPyXDpZp/c0bbn5FFFyMvwDsLC+PRx3ga8xe3/MWVHRkpOtBX7TVyl
	iea8PSkfj8Sec99tN7Ac7UsY4fMljnVuEXrA==
X-Received: by 2002:a05:600c:3556:b0:489:2005:b36e with SMTP id 5b1f17b1804b1-48a76f7a44fmr6695485e9.19.1777314683233;
        Mon, 27 Apr 2026 11:31:23 -0700 (PDT)
Received: from [127.0.0.1] ([2804:1bc4:224:7800:585c:db3a:fcb:e21f])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48a7749cabdsm1182065e9.9.2026.04.27.11.31.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Apr 2026 11:31:22 -0700 (PDT)
From: Marcos Paulo de Souza <mpdesouza@suse.com>
Date: Mon, 27 Apr 2026 15:31:01 -0300
Subject: [PATCH v3 5/6] selftests: livepatch: Check if replace sysfs
 attribute exists
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260427-lp-tests-old-fixes-v3-5-ccf3c90f744c@suse.com>
References: <20260427-lp-tests-old-fixes-v3-0-ccf3c90f744c@suse.com>
In-Reply-To: <20260427-lp-tests-old-fixes-v3-0-ccf3c90f744c@suse.com>
To: Josh Poimboeuf <jpoimboe@kernel.org>, Jiri Kosina <jikos@kernel.org>, 
 Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>, 
 Joe Lawrence <joe.lawrence@redhat.com>, Shuah Khan <shuah@kernel.org>
Cc: live-patching@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Marcos Paulo de Souza <mpdesouza@suse.com>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1777314662; l=4029;
 i=mpdesouza@suse.com; s=20231031; h=from:subject:message-id;
 bh=QU8Gtp2Ecj/0+tiSHgBo9A1bT/rtptLfgh2zpMY5Do0=;
 b=0WwirADiU13Rzp8E+ypmtQBuew7fE2ZrK1v5NLOQLh4Gr6jPkASd0CPUf05wNVK7xgp1fiUEr
 2hCBPgp0W1rAlSaFxHeDS/y+FQ5OP10BLYXqB2nfRMDrMbKWGCbL2ec
X-Developer-Key: i=mpdesouza@suse.com; a=ed25519;
 pk=/Ni/TsKkr69EOmdZXkp1Q/BlzDonbOBRsfPa18ySIwU=
X-Rspamd-Queue-Id: C7C98478A7B
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[suse.com,quarantine];
	R_DKIM_ALLOW(-0.20)[suse.com:s=google];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DKIM_TRACE(0.00)[suse.com:+];
	TAGGED_FROM(0.00)[bounces-2567-lists,live-patching=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_SEVEN(0.00)[10];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,suse.com:email,suse.com:dkim,suse.com:mid]

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


