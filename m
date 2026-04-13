Return-Path: <live-patching+bounces-2342-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id CFYoFX4n3WmJaQkAu9opvQ
	(envelope-from <live-patching+bounces-2342-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Mon, 13 Apr 2026 19:27:26 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 2FFEE3F16AC
	for <lists+live-patching@lfdr.de>; Mon, 13 Apr 2026 19:27:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 8AE76301D0B7
	for <lists+live-patching@lfdr.de>; Mon, 13 Apr 2026 17:27:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E4CB36215E;
	Mon, 13 Apr 2026 17:26:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Vi8WbX1N"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F3B43630A1
	for <live-patching@vger.kernel.org>; Mon, 13 Apr 2026 17:26:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776101202; cv=none; b=ROwD1Y6ilEVuKHYgzKl2o6bkAo6UmX1Ra3DVPKXVabTQhP1wFbfSduHW+nt11DlXekAaxDRqB6A3cIdE/gYPmU1wCGd3xhadTWqVScfEHg++qJAhbZwiYhdCZZwpzjbeDT+9rQN+qCUXgMz0mzuoU1N21V+QN9w5gAwaW14s8+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776101202; c=relaxed/simple;
	bh=GWGq7P7bvRfSD22bdYnyvNbQAb8tVilIkrfjkEJwIjY=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=jzMhX5jdK9Bu/tdZ8q4M4ve5a2Opu9BSRt2t6egf2Z+KCtlCj6nnc2wZB12iVYi59jglU6Pz78eiI8Ke3jLiB3Bsd4xTBia9WE8szTrrIqcW6FJLtf9AYmWFLKbgjxQtouhDFuLWOtafW41FC5VlTX6VoRNyf59K1p8SIVbkBew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Vi8WbX1N; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-48896199cbaso50518475e9.1
        for <live-patching@vger.kernel.org>; Mon, 13 Apr 2026 10:26:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1776101197; x=1776705997; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PO2pGCWxGzIXon/onQ1T7QGLeTxZ3Xf5Ie8qcBJrTk0=;
        b=Vi8WbX1NB7uFwv7UUnudnAk67pgWoJvXA69MIkVBak3HeBbNWKnN1ADtTp6q/ifmI8
         Jmr10cH9oJRQMb2vLPcoUtlBYF1abJTimXH7CsXf6V2om0y0RgP0wdGhswImzQLpaX9F
         JSnP+7KzcTKoBJzMP3yW0O54nPqRA3F59pd7xUUfbgssa3ATXpFmDYo70cwhrtAzA8ho
         X5wzryuaoHiCRTFTsjY41fAe2QhHYOH5s6uC7/jAsX8M+QEw9b5xa9UHjzHb1IRbARKf
         5mPm9RJIoFKAqwGtYrt6VLMlTg1O59GWYU9TedTW+Va69mvVP0FcRK4MKwNAzU1s40fo
         GbkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776101197; x=1776705997;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=PO2pGCWxGzIXon/onQ1T7QGLeTxZ3Xf5Ie8qcBJrTk0=;
        b=so6VAUaymy86pgPN3sXop9Y4iltL3WAJXfzFg0pkXHXQeB+6hpsoQTnO7HkzyO7pFz
         pB+Ub6wQFyTHGmoFxXhPvIMiLz35e7ZEnAaoLS3g4DS6CXeWr257P5tmMuA0wBQ2Wobk
         bAoZE2sS+dBYLCx4+UeXilVjib4Ra8FnGWw9VXyHZK5DxTnqnQu9vXRLVc17iMBJiEgk
         JZTWCB0q+YthKRZm1YwvXn13mpLqz6lNzQherPO2pSsb4Zdvcy4FERL+P0foF3+nhcqH
         KcDv8JEnWsjAtISC8245ASmjNPKh1SIbPr2n6YRrM9ssWUpIlkoxOWHmKJGQRTI6F+EH
         1hnw==
X-Gm-Message-State: AOJu0YxhEy0dmC92LG9MoHbyK/gVXaiTv9fS++jKKZ4vCkhfjIsDA2lx
	SBUnwRu73AggCTO1daYdsrlaEQQ4IwYJboDzwSnr8BnlNVbzkEIhrqm4dxPHAbZKixM=
X-Gm-Gg: AeBDieuhmoQuK4wPAKo00xWt0JtPKwcXf/46HQc9VdTN7Ubychk5V43uqoI3CO7QsnV
	zOP5sghdTBL4Cp/E2mqrlxr/MuWkSiZxPRPIr1d/d4GIGiC3AV0Yx41gJWF8lVlk65ME5ud36Qx
	ED+CBy22BaqQEkurSlN+Hq0YOTTqbMxKoW01qSgCDxwxvFNVT0NytT+s+Vm0Yf2YVDZ/opm+4Yr
	0GBhGGpcM7dZVXHOrU/n7JalJ2GjFR4/RnT36+tAzUoC1t7TbKbIuIj/0AoKATCbns0P6hkpVMJ
	/NU90scbirT6jeKML7GLtSGnUAtSIvTGgbaGdNPtA5smNC6aQTRiuH8O2Gok6dPqdkosKSySPp2
	jvO9vC6J1M/zYOIWCHrmWMlh9L96GljBiYxft7jM1SMsifXwDERI0BFeeSV7uoeFy5CYdhqwujb
	TRrAOnhZLcESbwxq07icpH8RI=
X-Received: by 2002:a05:600c:871a:b0:488:c683:be89 with SMTP id 5b1f17b1804b1-488d67f0b8fmr208758455e9.9.1776101197444;
        Mon, 13 Apr 2026 10:26:37 -0700 (PDT)
Received: from [127.0.0.1] ([2804:1bc4:224:7800:585c:db3a:fcb:e21f])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-488d5734a94sm298657835e9.0.2026.04.13.10.26.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Apr 2026 10:26:37 -0700 (PDT)
From: Marcos Paulo de Souza <mpdesouza@suse.com>
Date: Mon, 13 Apr 2026 14:26:16 -0300
Subject: [PATCH v2 5/6] selftests: livepatch: Check if replace sysfs
 attribute exists
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260413-lp-tests-old-fixes-v2-5-367c7cb5006f@suse.com>
References: <20260413-lp-tests-old-fixes-v2-0-367c7cb5006f@suse.com>
In-Reply-To: <20260413-lp-tests-old-fixes-v2-0-367c7cb5006f@suse.com>
To: Josh Poimboeuf <jpoimboe@kernel.org>, Jiri Kosina <jikos@kernel.org>, 
 Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>, 
 Joe Lawrence <joe.lawrence@redhat.com>, Shuah Khan <shuah@kernel.org>
Cc: live-patching@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Marcos Paulo de Souza <mpdesouza@suse.com>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1776101176; l=3906;
 i=mpdesouza@suse.com; s=20231031; h=from:subject:message-id;
 bh=GWGq7P7bvRfSD22bdYnyvNbQAb8tVilIkrfjkEJwIjY=;
 b=31e9o5gk39vFNf/aLfmX++1HUFH1FpphvTSYVJPQIeReWeQ5AWglhubic42TxsKGFICzx1Y+Q
 dstt69BNPmtBOlz3v9V1vvTgBnmNtUkKTAkOVZycJgLpNzciggYVOl8
X-Developer-Key: i=mpdesouza@suse.com; a=ed25519;
 pk=/Ni/TsKkr69EOmdZXkp1Q/BlzDonbOBRsfPa18ySIwU=
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[suse.com,quarantine];
	R_DKIM_ALLOW(-0.20)[suse.com:s=google];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DKIM_TRACE(0.00)[suse.com:+];
	TAGGED_FROM(0.00)[bounces-2342-lists,live-patching=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_SEVEN(0.00)[10];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,suse.com:dkim,suse.com:email,suse.com:mid]
X-Rspamd-Queue-Id: 2FFEE3F16AC
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

In order to run the selftests on older kernels, check if given kernel
has support for the attribute. If the attribute is not supported, skip
the checks.

Signed-off-by: Marcos Paulo de Souza <mpdesouza@suse.com>
---
 tools/testing/selftests/livepatch/test-sysfs.sh | 39 +++++++++++++++----------
 1 file changed, 23 insertions(+), 16 deletions(-)

diff --git a/tools/testing/selftests/livepatch/test-sysfs.sh b/tools/testing/selftests/livepatch/test-sysfs.sh
index a2d649404a63..0cdaeef00983 100755
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
@@ -34,6 +34,11 @@ if does_sysfs_exists "$MOD_LIVEPATCH/vmlinux" "patched"; then
 	HAS_PATCH_ATTR=1
 fi
 
+if does_sysfs_exists "$MOD_LIVEPATCH" "replace"; then
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
2.52.0


