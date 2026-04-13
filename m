Return-Path: <live-patching+bounces-2339-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 2IoFJFgn3WlpaQkAu9opvQ
	(envelope-from <live-patching+bounces-2339-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Mon, 13 Apr 2026 19:26:48 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 30D0C3F1653
	for <lists+live-patching@lfdr.de>; Mon, 13 Apr 2026 19:26:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id D71253020746
	for <lists+live-patching@lfdr.de>; Mon, 13 Apr 2026 17:26:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D35E351C0C;
	Mon, 13 Apr 2026 17:26:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="XsYaF6E5"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D77134EF1C
	for <live-patching@vger.kernel.org>; Mon, 13 Apr 2026 17:26:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776101190; cv=none; b=D6DKTiI0OCThKKOZzVzraAATJaeEmVfnrXKhKY36hAS5TyIddQnHNTSxMSREHsbZBWk8qU1LEJdXSLGCcJoTz6Shkda04BfdXqTMVqB+yhmEMvnfmPc0G/HPmVX+ALV6KKsCRkaxBIOorWg1YgKoRfHoTVIVvD35kuNZ80kflnI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776101190; c=relaxed/simple;
	bh=Fi4+7AICroGl4vhocOQqTHqCQjKzyOoENh0mx4bHYLw=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=lzAuBT9k0Uf5Am8MJmpL1tTdeEEAunb+dhkd10B3sIRObkDPoHfRHwZlfgOI94kSYaSrqphbI7lm2CNL5CD2COaMr6Nq9CuvkeN+z9mh/ybujbMTbEtkKCCMgq478hJDePZc7Atdv1wsHIcEJU/jdfM5IrLI7bnu0dlv75cTnlQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=XsYaF6E5; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-48334ee0aeaso44857345e9.1
        for <live-patching@vger.kernel.org>; Mon, 13 Apr 2026 10:26:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1776101187; x=1776705987; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VaP2vHabUvVwwJ9A/fhi80sDXR9MK/2TXs2XnT7TBVQ=;
        b=XsYaF6E5lcETkbYwezzYRorO4hkuye+gcuxfj5r+6jPmGBTDnruQdsvvpTCuh9SiTe
         JpRL0ns5u5KeUvlU/Yv6Bbt6Wl7QawnwNeon9u5U1vuqXyuMPAp4NkrARlCI4E2iTM2m
         dwNoLPGOZuDGreHEv6Fb1Rt815bWpc7ni72Ni2i1d9ajYi29+/i2lDidjucKzcaleplo
         zSned0zgRFqtsvFaaShPzxdvSAWN/DtEnxYAD284Pd7FEOE8XxfWcBAiHQehEI60QBJH
         QmyafC/HGZ2AfODe5TwmeCTnGFTur9s3XVBijvpEtWnkmTfmBmJhmiulDMn3HRrEka7c
         S0lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776101187; x=1776705987;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=VaP2vHabUvVwwJ9A/fhi80sDXR9MK/2TXs2XnT7TBVQ=;
        b=iJH4xUwq56uGBo8Cj9G1hZuB6BicYo14AAIrnyA7UEhnDiN/KZA/9TwnR5mHjc92u6
         XcDK/W0aiZ4Bm2fB/eB9QaJ2IU4ceILFKzD1wQml5HOwfP0NOTAxrzpCcFMIBc65vMi1
         CLzxKZkV94YVh+dbABH2lEFDWKIB0leSlv3MyXB/GwtJpMKGgjhGuBoXg61S4wW4OUMo
         4CHSs4iqx5CWEJ0c4nwz8IJcYkx8Hk9RdeRoYxEP90CUrV0y9RDMWRZLYms6xXDWVOID
         sxIEMnrqev/gDP1lZg1ISYeBQh5yUD9Zv0+wnoUF2MT6WwGIycN1INXE7LZW/ouPYoux
         QGVQ==
X-Gm-Message-State: AOJu0Yx05Vdeud0G7f+JGE6zcg3NfUr03h1ygDP/TFyb7swgGhFUTpMS
	v49eWOpAKVuvA2NE6SJpT8aoOzJ43xGJlkJQ90Kr9XJlHbkHrOYz27cd32/RNjhh4kU=
X-Gm-Gg: AeBDieuKqhbIMMj7J2c6cp3nuK8pHdYLCzJwFIo5/ed+BtOkWl3bblij6K3JKB91uw3
	YlpFv2p2aNOFR5mn+a/lFTGBgVgxRbeyqlaqhyj0N8bVsObMwSO0/vd6imdNiCGvi5mZYc623cI
	wp4wm6gVMy49WrZLhYdlLLKSe4UepmdZu4vgvquxn9jQa+Jmm2ToBLAssC6ySuJQNQEqHhHrnBT
	caeCN37wxCyEV3yxR+tZnDjRqaMMFThv93gt2B/aK7L0vchlcEcyb0e0br2WC0U9Vbxlf0YP5YG
	hldDuh2xntYKj6avtUrrHXF2edRoAse7rASqCULROprGSkonFHXJqKPzA5nrR1Am5aLYzOmVlEY
	tTMlS2cZEpDiZOfjl+RT2uFRpvAnN8MotkGIglpmATt2tByipV+WkcMSLXexWY4z3b7p8R1bF2S
	WO5FEx4X2kxatd+Ji9+xAj+RA=
X-Received: by 2002:a05:600c:19cf:b0:485:2a4b:7bc3 with SMTP id 5b1f17b1804b1-488d67ebc6emr178850855e9.4.1776101187020;
        Mon, 13 Apr 2026 10:26:27 -0700 (PDT)
Received: from [127.0.0.1] ([2804:1bc4:224:7800:585c:db3a:fcb:e21f])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-488d5734a94sm298657835e9.0.2026.04.13.10.26.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Apr 2026 10:26:26 -0700 (PDT)
From: Marcos Paulo de Souza <mpdesouza@suse.com>
Date: Mon, 13 Apr 2026 14:26:13 -0300
Subject: [PATCH v2 2/6] selftests: livepatch: Replace true/false module
 parameter by y/n
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260413-lp-tests-old-fixes-v2-2-367c7cb5006f@suse.com>
References: <20260413-lp-tests-old-fixes-v2-0-367c7cb5006f@suse.com>
In-Reply-To: <20260413-lp-tests-old-fixes-v2-0-367c7cb5006f@suse.com>
To: Josh Poimboeuf <jpoimboe@kernel.org>, Jiri Kosina <jikos@kernel.org>, 
 Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>, 
 Joe Lawrence <joe.lawrence@redhat.com>, Shuah Khan <shuah@kernel.org>
Cc: live-patching@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Marcos Paulo de Souza <mpdesouza@suse.com>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1776101176; l=2032;
 i=mpdesouza@suse.com; s=20231031; h=from:subject:message-id;
 bh=Fi4+7AICroGl4vhocOQqTHqCQjKzyOoENh0mx4bHYLw=;
 b=JCSHLKl+cUG5/m3NOooT543BR/62amPmAKcy+Xsn7J91nX5HLQ2/4uwjmsVJXIet6d2T2D/xm
 /eyCINyZ7G2Bziq+545E6lk1yDwTvdavsP8dBeadjlgI95ajuau8qA5
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
	TAGGED_FROM(0.00)[bounces-2339-lists,live-patching=lfdr.de];
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
X-Rspamd-Queue-Id: 30D0C3F1653
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

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
2.52.0


