Return-Path: <live-patching+bounces-2606-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 0OVGAxgZ8mljnwEAu9opvQ
	(envelope-from <live-patching+bounces-2606-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Wed, 29 Apr 2026 16:43:36 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id AC4FF4960B1
	for <lists+live-patching@lfdr.de>; Wed, 29 Apr 2026 16:43:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id DEB7E30AFCAD
	for <lists+live-patching@lfdr.de>; Wed, 29 Apr 2026 14:36:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7049734E744;
	Wed, 29 Apr 2026 14:35:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="bTvQLWEf"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3878377006
	for <live-patching@vger.kernel.org>; Wed, 29 Apr 2026 14:35:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777473357; cv=none; b=WP95P6gE2W4f5CADudpFmZMbPtvYpwniWXWu7SZMbfyiDWYwZmuY5/0Qf/2SgLuG5aEPmMBnzZYn38VBtP7kjLBujDf558vfS1CNBw9vgqEEPPXl3OMXZGwpZuEnGJYdIRFcPA3TfQY+skNoAFDItiolqoF1SnA8oMCb4nSEl4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777473357; c=relaxed/simple;
	bh=q5j+MBRO9EiSUEyD1ouDADHu0UZgT7yndU3RT5A6jPY=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=OzhfkEzyx3cQi+gz/RYrojJL0miywbaFxKnoDp0KnHVxN5rvIJRQ75iz4FJp4wwAzIF6ApaCx632bCezUlYRKZ/IYdbfIemEA2z6MHSxd97vRqbokujiEhTQk0UWLlWALKqkSVFkQAqDYZt/vqo+qKHRPdmQFlNLGH7oe2UAiuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=bTvQLWEf; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4891e5b9c1fso111414305e9.2
        for <live-patching@vger.kernel.org>; Wed, 29 Apr 2026 07:35:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1777473354; x=1778078154; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BTyr/enfNhvA23qY+Ogypltm/UtUUOhWDEUIvxA+akU=;
        b=bTvQLWEfaBR7Tc/Sz+JsUnVLYyphk9QGQk0CUWqOt0DiDYxG8A2DjeEVF4O6flqc+0
         GrFZAUTcp7mGumPLwStKAd9H1N1p/09lWySd3bBuH+CWUR/EntIU6HKto3tGb+8BmXwd
         Cg5tMszUG4oqEOoYtf0FZbTNiZ+W18UnzA8lFKJuW3raLKFS8qZodliuC4x183rYZRi/
         VAKlHfwgeB7hrnhEQF2ne3qfpy/U1wmzYIBISTnLPW3dU+PNSG27VjKWZ0Qm9GLG3ckz
         ndOtKrGAsovUNOUQn4M5U5h0jFTgx5vlW7H80VEoEPDPak2QXpPB61pFA87RU3zo0+zs
         iS+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777473354; x=1778078154;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=BTyr/enfNhvA23qY+Ogypltm/UtUUOhWDEUIvxA+akU=;
        b=d54xCnQIx/K9LvNy2sq4ztWWsF21gIV0L8Knlyk7Opx2xdwm0V48kx0ONo8nMnC+yo
         gnZBJpAeCvVcW8lVpj2icRMODr+pJGaxTtbpxcsVytFu2/8ujikECOtKf0BkGYjocZZq
         5kMLEzoBFg888trby5YwVnXUu0uJm/GqCKU0+jihozqyYqog3K1Jw55zMLIJoLqOaFmW
         gEY1JFHuTjTLeVacH5SR4Th6IjmV1ww8+9lPhfI/vA142PO9XQ755dvhMRqFy/r+e5cl
         aU/Rj/oa9UWjx32IMDcV9EdrlMMsSEkixXcuxEaAZqhHW/Cy221JWBBSabn+m8cwZ4z1
         eKTQ==
X-Gm-Message-State: AOJu0Yzj8KZ4M1BEVB4IyW0H48q1mrWBizC7Uq9QMzXMH98JJe0FgxjX
	Wi5qlflHJ1EzSqGkgmusyrYcSfCTKsP5VJUjpOzGUdC5pR/avZXRZmY18Fikyxbk8TM=
X-Gm-Gg: AeBDieuYYtQicpgcJ+ag7Wo75BXzFmVAlpBcLGGLMU6DAZFpBcIs9hIANOoUyGBgzxj
	ONU83zJy3qyYeWKPgwN7CJb3ZwRghsyMnKsuWiFr+8Etxclv+H0hvqOC07ndXCsLt2AEf2Zzq3o
	ZUP68SWroXzD32oS5/9PF7vOZPYT8mItxkvdovhGJEsNSqUTE9g+6IRMBVDrBXsVrh88O7LoHHc
	977m83vuZxoM2eIDNEwTe38OPQHdAzamw0qKL3d14oHjP3X8P59baqzyhoeLNyovUogmZgMJ9km
	Zzn5D8vmI9AO2V2hSACdlBp4VHCGAtn+dBOpKMgTQyIS2SO9SKgDY2cVyqEvz8RqVaIZgIaPw0+
	O2eI2/cjNP1e6Te+Yd71z8PLU5fS0zuxDJwxQ5LMoHCkTaYZuKg4VMKg4vxOSpYvYxn5qnf79Ep
	flIbGyAFiIGgOPQMj8lbOIAM0yvZ8ngCBeDA==
X-Received: by 2002:a05:600c:8590:b0:48a:58e1:6d17 with SMTP id 5b1f17b1804b1-48a77b19b69mr84220995e9.20.1777473354068;
        Wed, 29 Apr 2026 07:35:54 -0700 (PDT)
Received: from [127.0.0.1] ([2804:1bc4:224:7800:585c:db3a:fcb:e21f])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48a7c305371sm19982835e9.18.2026.04.29.07.35.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Apr 2026 07:35:53 -0700 (PDT)
From: Marcos Paulo de Souza <mpdesouza@suse.com>
Date: Wed, 29 Apr 2026 11:35:20 -0300
Subject: [PATCH v4 6/6] selftests: livepatch: Check if stack_order sysfs
 attribute exists
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260429-lp-tests-old-fixes-v4-6-59b9741989d0@suse.com>
References: <20260429-lp-tests-old-fixes-v4-0-59b9741989d0@suse.com>
In-Reply-To: <20260429-lp-tests-old-fixes-v4-0-59b9741989d0@suse.com>
To: Josh Poimboeuf <jpoimboe@kernel.org>, Jiri Kosina <jikos@kernel.org>, 
 Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>, 
 Joe Lawrence <joe.lawrence@redhat.com>, Shuah Khan <shuah@kernel.org>
Cc: live-patching@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Marcos Paulo de Souza <mpdesouza@suse.com>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1777473323; l=7838;
 i=mpdesouza@suse.com; s=20231031; h=from:subject:message-id;
 bh=q5j+MBRO9EiSUEyD1ouDADHu0UZgT7yndU3RT5A6jPY=;
 b=JEFGM1eKq41Ddh4vD84jBCKrmu/uUMlBVU/BE2NRwMO3n63VtlLeJqCtsRqbwH8nD3r0EUziu
 X9HvtDh0uX5CwPOcFXNGUCQ7m/2JAx8gfMxU3Nzd9dH72JrssAc02IF
X-Developer-Key: i=mpdesouza@suse.com; a=ed25519;
 pk=/Ni/TsKkr69EOmdZXkp1Q/BlzDonbOBRsfPa18ySIwU=
X-Rspamd-Queue-Id: AC4FF4960B1
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[suse.com,quarantine];
	R_DKIM_ALLOW(-0.20)[suse.com:s=google];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DKIM_TRACE(0.00)[suse.com:+];
	TAGGED_FROM(0.00)[bounces-2606-lists,live-patching=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_SEVEN(0.00)[10];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.com:dkim,suse.com:mid,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]

The commit 3dae09de4061 ("livepatch: Add stack_order sysfs attribute"),
merged in v6.14, introduced a new sysfs attribute.

In order to run the selftests on older kernels, check if given kernel
has support for the attribute. If the attribute is not supported, skip
the checks.

Moving the test up since the other checks change the default values
for MOD_LIVEPATCH and other variables.

Signed-off-by: Marcos Paulo de Souza <mpdesouza@suse.com>
---
 tools/testing/selftests/livepatch/test-sysfs.sh | 145 +++++++++++++-----------
 1 file changed, 76 insertions(+), 69 deletions(-)

diff --git a/tools/testing/selftests/livepatch/test-sysfs.sh b/tools/testing/selftests/livepatch/test-sysfs.sh
index 744c612a90d3..4185e2f489f3 100755
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
@@ -56,6 +61,75 @@ livepatch: '$MOD_LIVEPATCH': completing unpatching transition
 livepatch: '$MOD_LIVEPATCH': unpatching complete
 % rmmod $MOD_LIVEPATCH"
 
+if [[ "$HAS_STACK_ORDER_ATTR" == "1" ]]; then
+	start_test "sysfs test stack_order value"
+
+	load_lp $MOD_LIVEPATCH
+
+	check_sysfs_value  "$MOD_LIVEPATCH" "stack_order" "1"
+
+	load_lp $MOD_LIVEPATCH2
+
+	check_sysfs_value  "$MOD_LIVEPATCH2" "stack_order" "2"
+
+	load_lp $MOD_LIVEPATCH3
+
+	check_sysfs_value  "$MOD_LIVEPATCH3" "stack_order" "3"
+
+	disable_lp $MOD_LIVEPATCH2
+	unload_lp $MOD_LIVEPATCH2
+
+	check_sysfs_value  "$MOD_LIVEPATCH" "stack_order" "1"
+	check_sysfs_value  "$MOD_LIVEPATCH3" "stack_order" "2"
+
+	disable_lp $MOD_LIVEPATCH3
+	unload_lp $MOD_LIVEPATCH3
+
+	disable_lp $MOD_LIVEPATCH
+	unload_lp $MOD_LIVEPATCH
+
+	check_result "% insmod test_modules/$MOD_LIVEPATCH.ko
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
+% echo 0 > $SYSFS_KLP_DIR/$MOD_LIVEPATCH2/enabled
+livepatch: '$MOD_LIVEPATCH2': initializing unpatching transition
+$MOD_LIVEPATCH2: pre_unpatch_callback: vmlinux
+livepatch: '$MOD_LIVEPATCH2': starting unpatching transition
+livepatch: '$MOD_LIVEPATCH2': completing unpatching transition
+$MOD_LIVEPATCH2: post_unpatch_callback: vmlinux
+livepatch: '$MOD_LIVEPATCH2': unpatching complete
+% rmmod $MOD_LIVEPATCH2
+% echo 0 > $SYSFS_KLP_DIR/$MOD_LIVEPATCH3/enabled
+livepatch: '$MOD_LIVEPATCH3': initializing unpatching transition
+livepatch: '$MOD_LIVEPATCH3': starting unpatching transition
+livepatch: '$MOD_LIVEPATCH3': completing unpatching transition
+livepatch: '$MOD_LIVEPATCH3': unpatching complete
+% rmmod $MOD_LIVEPATCH3
+% echo 0 > $SYSFS_KLP_DIR/$MOD_LIVEPATCH/enabled
+livepatch: '$MOD_LIVEPATCH': initializing unpatching transition
+livepatch: '$MOD_LIVEPATCH': starting unpatching transition
+livepatch: '$MOD_LIVEPATCH': completing unpatching transition
+livepatch: '$MOD_LIVEPATCH': unpatching complete
+% rmmod $MOD_LIVEPATCH"
+fi
+
 if [[ "$HAS_PATCH_ATTR" == "1" ]]; then
 	start_test "sysfs test object/patched"
 
@@ -150,71 +224,4 @@ livepatch: '$MOD_LIVEPATCH': unpatching complete
 % rmmod $MOD_LIVEPATCH"
 fi
 
-start_test "sysfs test stack_order value"
-
-load_lp $MOD_LIVEPATCH
-
-check_sysfs_value  "$MOD_LIVEPATCH" "stack_order" "1"
-
-load_lp $MOD_LIVEPATCH2
-
-check_sysfs_value  "$MOD_LIVEPATCH2" "stack_order" "2"
-
-load_lp $MOD_LIVEPATCH3
-
-check_sysfs_value  "$MOD_LIVEPATCH3" "stack_order" "3"
-
-disable_lp $MOD_LIVEPATCH2
-unload_lp $MOD_LIVEPATCH2
-
-check_sysfs_value  "$MOD_LIVEPATCH" "stack_order" "1"
-check_sysfs_value  "$MOD_LIVEPATCH3" "stack_order" "2"
-
-disable_lp $MOD_LIVEPATCH3
-unload_lp $MOD_LIVEPATCH3
-
-disable_lp $MOD_LIVEPATCH
-unload_lp $MOD_LIVEPATCH
-
-check_result "% insmod test_modules/$MOD_LIVEPATCH.ko
-livepatch: enabling patch '$MOD_LIVEPATCH'
-livepatch: '$MOD_LIVEPATCH': initializing patching transition
-livepatch: '$MOD_LIVEPATCH': starting patching transition
-livepatch: '$MOD_LIVEPATCH': completing patching transition
-livepatch: '$MOD_LIVEPATCH': patching complete
-% insmod test_modules/$MOD_LIVEPATCH2.ko
-livepatch: enabling patch '$MOD_LIVEPATCH2'
-livepatch: '$MOD_LIVEPATCH2': initializing patching transition
-$MOD_LIVEPATCH2: pre_patch_callback: vmlinux
-livepatch: '$MOD_LIVEPATCH2': starting patching transition
-livepatch: '$MOD_LIVEPATCH2': completing patching transition
-$MOD_LIVEPATCH2: post_patch_callback: vmlinux
-livepatch: '$MOD_LIVEPATCH2': patching complete
-% insmod test_modules/$MOD_LIVEPATCH3.ko
-livepatch: enabling patch '$MOD_LIVEPATCH3'
-livepatch: '$MOD_LIVEPATCH3': initializing patching transition
-livepatch: '$MOD_LIVEPATCH3': starting patching transition
-livepatch: '$MOD_LIVEPATCH3': completing patching transition
-livepatch: '$MOD_LIVEPATCH3': patching complete
-% echo 0 > $SYSFS_KLP_DIR/$MOD_LIVEPATCH2/enabled
-livepatch: '$MOD_LIVEPATCH2': initializing unpatching transition
-$MOD_LIVEPATCH2: pre_unpatch_callback: vmlinux
-livepatch: '$MOD_LIVEPATCH2': starting unpatching transition
-livepatch: '$MOD_LIVEPATCH2': completing unpatching transition
-$MOD_LIVEPATCH2: post_unpatch_callback: vmlinux
-livepatch: '$MOD_LIVEPATCH2': unpatching complete
-% rmmod $MOD_LIVEPATCH2
-% echo 0 > $SYSFS_KLP_DIR/$MOD_LIVEPATCH3/enabled
-livepatch: '$MOD_LIVEPATCH3': initializing unpatching transition
-livepatch: '$MOD_LIVEPATCH3': starting unpatching transition
-livepatch: '$MOD_LIVEPATCH3': completing unpatching transition
-livepatch: '$MOD_LIVEPATCH3': unpatching complete
-% rmmod $MOD_LIVEPATCH3
-% echo 0 > $SYSFS_KLP_DIR/$MOD_LIVEPATCH/enabled
-livepatch: '$MOD_LIVEPATCH': initializing unpatching transition
-livepatch: '$MOD_LIVEPATCH': starting unpatching transition
-livepatch: '$MOD_LIVEPATCH': completing unpatching transition
-livepatch: '$MOD_LIVEPATCH': unpatching complete
-% rmmod $MOD_LIVEPATCH"
-
 exit 0

-- 
2.54.0


