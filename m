Return-Path: <live-patching+bounces-2602-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id uLDaIIEZ8mljnwEAu9opvQ
	(envelope-from <live-patching+bounces-2602-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Wed, 29 Apr 2026 16:45:21 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 0A6E749615C
	for <lists+live-patching@lfdr.de>; Wed, 29 Apr 2026 16:45:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 009FE30ADD1F
	for <lists+live-patching@lfdr.de>; Wed, 29 Apr 2026 14:35:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 393EE35C1A6;
	Wed, 29 Apr 2026 14:35:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="I2BMZSNV"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5BDF332635
	for <live-patching@vger.kernel.org>; Wed, 29 Apr 2026 14:35:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777473340; cv=none; b=HGkcz/TfCxc1kf8ffDesIZ4o8DthORFG8ublz54y9Gxfw52E/ypvMxeCFbvO1tjPEE7RJX+l2RzKXIaJAalLTsrMOxREbfIqC59JknQ1LGAcRXg2T4XhXZtfgi4AjuUw0OQNH82xYPYdHvivT9b01f+oZFeXA6eMUBPPNWYGAos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777473340; c=relaxed/simple;
	bh=w+QsBT+5pcbBe5xVs0oaWXhZ1MdasOi3IXWJ4w5Ext4=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=dhWT8nDTqyc8Jd5crfCpzNQlLRYMXBH2BT/paXgreadRuZqnYuVx449wffqnr0/+TCodrRQqN3wOwctpQgR/RugiQh3f8vBH3dx1p0tGcRpwYneOgr3l/WvYHl/oYfFogiRfE66wFoTdxu9M3oy6PzUMVwl+/tjcwWl9Nlx7f8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=I2BMZSNV; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4890d945eb4so5984925e9.0
        for <live-patching@vger.kernel.org>; Wed, 29 Apr 2026 07:35:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1777473337; x=1778078137; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bJ2KT7kR4JMpZSd6AGblTMphpgunFcNpBlqPqv+V9cY=;
        b=I2BMZSNVfAqx/prE13w/4SvHwVaZCJfGpSTX7Glvd67G8Z6mqQpkSCKOIXRcohRRyW
         1Vs/mGfdQg6XTzD3JNH7qrlu6whl0G6dv93McHUrHLzSQ3sHRq1WRGPp2bsTSxMAW69H
         MR8KSV+J4O2HA1sUwmGtRWf1q2jls0U4U74DcSbz/tMt9iN+1G3qDuUoqXKaal1efJmE
         H8q9N+uSdpIMKNDJpf3Afr97w8w/IS5xz/h6NCOqGjb3M+pFDVjl8fDb/Vp8HZjo4eRy
         Px1B9Oe6/3dTnZyG/hYuPLoscucTA2MwlsjQSR5igRPnAKXXRlyzcmBK2ZzqoLqaYCXI
         A6tA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777473337; x=1778078137;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=bJ2KT7kR4JMpZSd6AGblTMphpgunFcNpBlqPqv+V9cY=;
        b=HBy2oLa6gD+AdOEark8yc2PiUYRZ3kXgD+rUGh184BWpoX4BxK1B/gX5m7X157LXyl
         sg9g+QMbpdKcXnBUPLr8lh1mH8EhT3I/Y1WdM/xoTdXG2EQzk2m3DPVGjfwoDYhSrJOo
         QSAlztJMjhhOPzq/kOIH5xIQkMr/neQLxFHIuhNcQRcbi0I4bGtz6o/4v23Mqva8LOsI
         ZMhT7xx/fTlQhbffN1uyAHdy51ADanHvotHqiDu0YQvjZwL8MgqmX+ubmFZZ7xY8mokD
         WC2plNoSP/iTLj9ATIpma7HKgED47EDZ1JV9tcsjYI2bBpMTg82+X4UY/MHd//SszFO2
         dpBg==
X-Gm-Message-State: AOJu0Yw08RhAWyJb6c2uX4sQmOoeyQIhl03Z8pP6zc/eGxqsrt+1+xJU
	+vpINjp5JdvTVq+4dbO8YbNY0bNVCX4LeCGfQEyPHZEGnR7+SYvgFFbUZEiVNcCVEQM=
X-Gm-Gg: AeBDietpFMRImgPxMkxZ3WO8mT2HqSzOIje142jtEP8LjHg6c8tDmYP+Oegh5eyuFk+
	aEqUjI7CBAvHx4sxdA2rP6EIf3d7eIHNCNsxhjKV89IPiaPnX4VfXdNUKuzGkwVoVz6TKwczxC2
	fOvDBt4DbFgCr6wnw6/gSa2cLB76GhIUxeR2mOWSWVDaX7pfGKoWkZ1IhC4PkjefHV21+lb8dQO
	UC7IkZAjCO9W3PoJFaEIXSYw+JUrpENOlG+wq+d/4mHcN2BGBR82xaVUWznsPAyKPa9UXVZAtPa
	oZ+HMf0TvorVBiKIe1YybRwx1x9ystfur3wg4VVz1KMzCyWZ3qS/RXHcTEtzUStpNEtakCGsrMl
	JhVQ61nZCeRsh7vkt2MJUNuciaGMEQxcEOY0yEf1+dlUeWnRcLvOErjTUhKFRMJNn69eD22fkpy
	1QjRgx+ykiNyaZnjsk0M2ipi+OhPqL3SUzCQ==
X-Received: by 2002:a05:600c:c048:b0:485:3c2e:60d5 with SMTP id 5b1f17b1804b1-48a7bf91187mr38773385e9.2.1777473336676;
        Wed, 29 Apr 2026 07:35:36 -0700 (PDT)
Received: from [127.0.0.1] ([2804:1bc4:224:7800:585c:db3a:fcb:e21f])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48a7c305371sm19982835e9.18.2026.04.29.07.35.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Apr 2026 07:35:35 -0700 (PDT)
From: Marcos Paulo de Souza <mpdesouza@suse.com>
Date: Wed, 29 Apr 2026 11:35:16 -0300
Subject: [PATCH v4 2/6] selftests: livepatch: Replace true/false module
 parameter by y/n
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260429-lp-tests-old-fixes-v4-2-59b9741989d0@suse.com>
References: <20260429-lp-tests-old-fixes-v4-0-59b9741989d0@suse.com>
In-Reply-To: <20260429-lp-tests-old-fixes-v4-0-59b9741989d0@suse.com>
To: Josh Poimboeuf <jpoimboe@kernel.org>, Jiri Kosina <jikos@kernel.org>, 
 Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>, 
 Joe Lawrence <joe.lawrence@redhat.com>, Shuah Khan <shuah@kernel.org>
Cc: live-patching@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Marcos Paulo de Souza <mpdesouza@suse.com>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1777473323; l=2032;
 i=mpdesouza@suse.com; s=20231031; h=from:subject:message-id;
 bh=w+QsBT+5pcbBe5xVs0oaWXhZ1MdasOi3IXWJ4w5Ext4=;
 b=95zGk4dUE08yhQ6fZ4mgdN34mdvwU54eFq2REZdixnpfbQm4EOHFV0K/kMTCH0gCan2HxOJYz
 sZ+HLAR4kbrB04uGACyfR8yEDZBFX0yjRLxhY1NMIAlmZ+3ZpiNHhQm
X-Developer-Key: i=mpdesouza@suse.com; a=ed25519;
 pk=/Ni/TsKkr69EOmdZXkp1Q/BlzDonbOBRsfPa18ySIwU=
X-Rspamd-Queue-Id: 0A6E749615C
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
	TAGGED_FROM(0.00)[bounces-2602-lists,live-patching=lfdr.de];
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

Older kernels don't support true/false for boolean module parameters
because they lack commit 0d6ea3ac94ca
("lib/kstrtox.c: add "false"/"true" support to kstrtobool()"). Replace
true/false by y/n so the test module can be loaded on older kernels.

No functional changes.

Signed-off-by: Marcos Paulo de Souza <mpdesouza@suse.com>
---
 tools/testing/selftests/livepatch/test-kprobe.sh | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/livepatch/test-kprobe.sh b/tools/testing/selftests/livepatch/test-kprobe.sh
index b67dfad03d97..7ced4082cff3 100755
--- a/tools/testing/selftests/livepatch/test-kprobe.sh
+++ b/tools/testing/selftests/livepatch/test-kprobe.sh
@@ -20,11 +20,11 @@ start_test "livepatch interaction with kprobed function with post_handler"
 
 echo 1 > "$SYSFS_KPROBES_DIR/enabled"
 
-load_mod $MOD_KPROBE has_post_handler=true
+load_mod $MOD_KPROBE has_post_handler=y
 load_failing_mod $MOD_LIVEPATCH
 unload_mod $MOD_KPROBE
 
-check_result "% insmod test_modules/test_klp_kprobe.ko has_post_handler=true
+check_result "% insmod test_modules/test_klp_kprobe.ko has_post_handler=y
 % insmod test_modules/$MOD_LIVEPATCH.ko
 livepatch: enabling patch '$MOD_LIVEPATCH'
 livepatch: '$MOD_LIVEPATCH': initializing patching transition
@@ -39,14 +39,14 @@ insmod: ERROR: could not insert module test_modules/$MOD_LIVEPATCH.ko: Device or
 
 start_test "livepatch interaction with kprobed function without post_handler"
 
-load_mod $MOD_KPROBE has_post_handler=false
+load_mod $MOD_KPROBE has_post_handler=n
 load_lp $MOD_LIVEPATCH
 
 unload_mod $MOD_KPROBE
 disable_lp $MOD_LIVEPATCH
 unload_lp $MOD_LIVEPATCH
 
-check_result "% insmod test_modules/test_klp_kprobe.ko has_post_handler=false
+check_result "% insmod test_modules/test_klp_kprobe.ko has_post_handler=n
 % insmod test_modules/$MOD_LIVEPATCH.ko
 livepatch: enabling patch '$MOD_LIVEPATCH'
 livepatch: '$MOD_LIVEPATCH': initializing patching transition

-- 
2.54.0


