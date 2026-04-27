Return-Path: <live-patching+bounces-2564-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id kAz5FBWs72lIDwEAu9opvQ
	(envelope-from <live-patching+bounces-2564-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Mon, 27 Apr 2026 20:33:57 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id EE7D2478A54
	for <lists+live-patching@lfdr.de>; Mon, 27 Apr 2026 20:33:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 4FA47306B3BA
	for <lists+live-patching@lfdr.de>; Mon, 27 Apr 2026 18:31:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1EDC93EC2CA;
	Mon, 27 Apr 2026 18:31:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="BAsQpS5a"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72F403EC2CB
	for <live-patching@vger.kernel.org>; Mon, 27 Apr 2026 18:31:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777314676; cv=none; b=sOWBPNtZ8Giq7IlZNVlVLrDzwpX1bZQK28owv7TqAPxXKQHvg2f6B01gqN6mWUGv/MCF8fYncpxLk0PI1g/Nh92XV73sNYjp4eqxfabRU7dO9v7sa3U1gPKcRT2MgAjq3rPn4QJJHrl4TkZ9AYzNwUec18G0Glk6CrYDyubWheY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777314676; c=relaxed/simple;
	bh=w+QsBT+5pcbBe5xVs0oaWXhZ1MdasOi3IXWJ4w5Ext4=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Q+ypJMwyNdW46U941tnjeqUPZspDJdpUhATT5pgPb7CD+17gRM8N6tRVmF586OSV3s2yv2nuISjqFnRzJ18qRo9ZhW19J4rZtzYW1fcM6krtqtzhkxUcKbn7lOTkPiNsO31ZUZBHZAsM6l+d1ixdiaKlpL74g6rpDsomi/9mVbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=BAsQpS5a; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-488b8bc6bc9so76455735e9.3
        for <live-patching@vger.kernel.org>; Mon, 27 Apr 2026 11:31:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1777314672; x=1777919472; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bJ2KT7kR4JMpZSd6AGblTMphpgunFcNpBlqPqv+V9cY=;
        b=BAsQpS5an2A4I+uWN+DKdRgVQc1flKX4XwEaHoWa0rauJqUZvddJTDTZjme97hXJoO
         DnlU2iZCtBlMsU4why2skBAuxaT/ggD9V7kFq/hRe+uiwPMTgSr6ZOhwZLP+MxHdq8th
         a8IpL3G8WpAQUEmPA+J1NvAVP9ii8H+MmG1YZgGFHexx0XFw/diz9kXCfNvdAQlPQl85
         24y7YRjvGPUkwg5d+gCYLjH94SLBZ1CtWwdy5hrfvGGOjknRbAg+FfbNwsFRIA3lpSCZ
         3gkNMhOvN1UG4fA4FA24g82HpHUf/c14Dpe6KvZ6RkFNjt0SLU2pFJtVkjjipi2rI1Vd
         yZGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777314672; x=1777919472;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=bJ2KT7kR4JMpZSd6AGblTMphpgunFcNpBlqPqv+V9cY=;
        b=acp062j2ZsixadOAdQqYiZ017sLkP9Rbq4MWgaCqNcLkf39dv8mKzkQM2wo9veNT60
         ivrqV00nP7UIJ+Z3ciD/03eNOI49Azwkh5VIRXMZcc8qJ6gG3gqScAxqgQ76e5ZKgNNe
         APwVHdM+ktRDm/e2jxRe8js2+dsWOvcjVxZ6/l++VZ781LjFQ9d+e0mXLpIFTWoejTd2
         OTUogi/cmGqe1r6mVSuGsHet7JdDI6NiP7behA7fOisyQmMqywfChKJRfzMh3jspLvqs
         afUxAUohQMGwiQoTYCq884JZIOk6fVUGdfbCgPwrlT1QwMH9GshCqvMuW1MrYt0ILQQG
         R3gw==
X-Gm-Message-State: AOJu0YykJDpUsTxQnUyb7O+H13Vz92s/CKXsPMPDX0LL9QIqSOiipOqv
	HBb8gUAyqBVSmgjqU4Rlu6r/5XtRZc+ytMXdoeB0OPzCT/nirk4ipuJoaF57+caGJXCANVv/n6g
	UXHIEGEQ=
X-Gm-Gg: AeBDievjC6CC1X25GH0TGCJ+tYRMCJscwh8KJneHU37sbUwfpjnG4WDO3iwPL4XH4Qe
	HRqTLClFy7zddhKMGB+KvDqwtwd85WCx4owM6eKLwlI/TiLaHnRXIGSNCeHdIoEKsV7xF6aDwis
	XEMVr9GHVurJ8sP8JxGXEYTxidd7zfmLQIXHQn2Q64Rys7dYnIsgXe4uFYzxzviSC4diYqy5aPa
	7xa2jVVgWOUWorsTzqcwpZzdfpMvXwTv9+Az31mV+UglIadmciyToN0CKvV5Z9e7qnufqIsU+tN
	ecYNqpzHqrvz/BqGB1CD9y+udF+eRw88X3GqXcK7DtTOJFIU+eTzo5f/2LCkcz5kaAdfo1tYC45
	TMKbcTIh1FpwhLwDd+kfghQnCA88seSLe6Sjqjo9itZlQSGioPrPu275+QvSmibivHS2tHkFZij
	pYkZo+tt4RTwo4xNlw5MY8u7xPCNUx8tL7Qw==
X-Received: by 2002:a05:600c:8b55:b0:486:fd5c:2b35 with SMTP id 5b1f17b1804b1-48a76f58b7emr6617765e9.13.1777314672133;
        Mon, 27 Apr 2026 11:31:12 -0700 (PDT)
Received: from [127.0.0.1] ([2804:1bc4:224:7800:585c:db3a:fcb:e21f])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48a7749cabdsm1182065e9.9.2026.04.27.11.31.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Apr 2026 11:31:11 -0700 (PDT)
From: Marcos Paulo de Souza <mpdesouza@suse.com>
Date: Mon, 27 Apr 2026 15:30:58 -0300
Subject: [PATCH v3 2/6] selftests: livepatch: Replace true/false module
 parameter by y/n
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260427-lp-tests-old-fixes-v3-2-ccf3c90f744c@suse.com>
References: <20260427-lp-tests-old-fixes-v3-0-ccf3c90f744c@suse.com>
In-Reply-To: <20260427-lp-tests-old-fixes-v3-0-ccf3c90f744c@suse.com>
To: Josh Poimboeuf <jpoimboe@kernel.org>, Jiri Kosina <jikos@kernel.org>, 
 Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>, 
 Joe Lawrence <joe.lawrence@redhat.com>, Shuah Khan <shuah@kernel.org>
Cc: live-patching@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Marcos Paulo de Souza <mpdesouza@suse.com>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1777314662; l=2032;
 i=mpdesouza@suse.com; s=20231031; h=from:subject:message-id;
 bh=w+QsBT+5pcbBe5xVs0oaWXhZ1MdasOi3IXWJ4w5Ext4=;
 b=B9Lwc6hBLmccaw55nIYMFkQtu5er8y4vkFnt2F55uQsp+G/8IM+ODlWB/cJP5DbnIMNnFkEQm
 6cAlXxrf/9WBvQBPlamL7ZjUB36HdWHV0TdtiUthgmhRV8tptPClzWs
X-Developer-Key: i=mpdesouza@suse.com; a=ed25519;
 pk=/Ni/TsKkr69EOmdZXkp1Q/BlzDonbOBRsfPa18ySIwU=
X-Rspamd-Queue-Id: EE7D2478A54
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
	TAGGED_FROM(0.00)[bounces-2564-lists,live-patching=lfdr.de];
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


