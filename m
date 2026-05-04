Return-Path: <live-patching+bounces-2699-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id gFkWBhLn+Gmt2wIAu9opvQ
	(envelope-from <live-patching+bounces-2699-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Mon, 04 May 2026 20:36:02 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id B9F7D4C29DD
	for <lists+live-patching@lfdr.de>; Mon, 04 May 2026 20:36:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id DC5843047BF2
	for <lists+live-patching@lfdr.de>; Mon,  4 May 2026 18:35:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4535A3E63A1;
	Mon,  4 May 2026 18:35:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="V7it2GiB"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C83BC3E638F
	for <live-patching@vger.kernel.org>; Mon,  4 May 2026 18:35:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777919715; cv=none; b=rZPvNN9OkTPeT3d6z0diA9VK32yrjJufs1TpVpMCq/tVeT6PMZv1pjqXyQhN4MAy7d+H9yDkhgcGLx1MepAfq5G47Ml2+TJO325i05cZXYo4FG2aQCdaxFqBbFd8Oj9eF+j8+5ydOtpeUk5UUfDn3Trq0ZucsIpvOquaDFYJ9cI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777919715; c=relaxed/simple;
	bh=w+QsBT+5pcbBe5xVs0oaWXhZ1MdasOi3IXWJ4w5Ext4=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=ZeYjV572jdUJekmN6vssT35/G5g+gQ2TTeGGx2J4NVKQEXnymZRi5upGNVUc96jfMo64nevsqPHgMv7WtjvuvKkV15wotJ+cgMzSaKlbuLKZsZpz1d+xvpN2hVQKrob/Fng/hpzj78uurTBScRACEoSMRrFnGvl7tt3E1CfJdWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=V7it2GiB; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-44a786a9a35so2132650f8f.3
        for <live-patching@vger.kernel.org>; Mon, 04 May 2026 11:35:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1777919710; x=1778524510; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bJ2KT7kR4JMpZSd6AGblTMphpgunFcNpBlqPqv+V9cY=;
        b=V7it2GiBs99GyLDTfPFEg4NeefHGSIKV75b4rWUr3HFdZkLO+d8DrqhZjmVWhHk+kp
         4d2QTpoatOToPf+/9TZLvtuPjp3ECOOT9nQyJ9DI/h7EYeCho9sG9UCeNP7cnWo0ZNmU
         CnH9zoRni7M/xSryskKrozi9zGZtdAKJ2REEWrJiBKpbUGCLDFo5E9rFat9QRgk5FzPe
         nVl9Gi/dOtDQSRxesH9dKarBCEiefnPQoQHAiD4a6zKwlSxCXTd/GXp0K5IUe9GEYaAk
         G1xB9r5k3qXWn1eaLMOSVVLsQ2WCh7splibrbZUUJGrqvHqC7r3LWyPtPxqnQfyWQax6
         OGcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777919710; x=1778524510;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=bJ2KT7kR4JMpZSd6AGblTMphpgunFcNpBlqPqv+V9cY=;
        b=NVhn+OzcSsslnioLlsFL7Oq0F9cE+WZb55JVy37hj3F0AGMStGA/knLry584IAF8cx
         8JjeudIQ8z+v2AdcE6YRATXlGX0weP1cpBSrF0JrU6r+fO60JAo/Zw7+dWmL3X/hwbPy
         MeZHFYyMpR4jFAZUTwbz+4vV//TrVY8v8Vx1U7s4K+rjMjYR7UQP/b6X7XRrMaiqbYPU
         QckVf5uhdxiYUZHw9kRVA2PLOVZ7kjRKOmDkP0s+UH23xDjcqFOWYs48inBzAon3wOgV
         G5C+aHzE7krYu4h99hBhDfAxi5z+QOuTXLE0fmZoXKydhrfcVe9kHEXMWhRiPm5CsR9l
         /Wwg==
X-Gm-Message-State: AOJu0YyturpUDJO3t8hsi5dLj2qinUXR37YpINne6f/xVV0R1juG8cTw
	yVUxELm8YfLlA40zaoxcsJGOKqXhnG5vOsptIY4dK27JX3863Yf3dIfxRkv43/PcX5E=
X-Gm-Gg: AeBDiet037AZY0nQJc3jDNftw7rYQb9Fyc1RKsAC82+5HhZnwK6kPKRHQdMj9v0f8G+
	ym+N/NQA5puC0bXprvnB3Rn4BvEPbrBb8MB3BWX4cD1j1rU0NwGKtHzOBCYZszhjMGR+QgYRotq
	/fggYAazaNTf48HteCTJRFTMuHu7enBPd18m8njR74IqXzIFdZlFfcQq/yq3XdpPHM0ofpqxpij
	z/tZVKXlwFglJeeSf1vX9ydd5lzsQ6WEKRy0E4dQxJxDzjRUjants5WsZw2T5mN6JqazccE2naz
	JqBEh+ODy4CXoFXgjTPXBrtaCTuZ8O/vLyjOu+lMiLcY4RO94YsOMmJwESxQeO90OJ+oav6Cym/
	v9AQ9D+uuP1ostx3yRftsZvvX5pIPnA0YOoxewWEE6ZYU3BaaUI8LJLf/r+bptixJE3D8oQBRdq
	I15obodOjMbAW9s7VwsDkCDaTn6dy+SrEKQw==
X-Received: by 2002:a05:6000:2410:b0:44a:247e:67b1 with SMTP id ffacd0b85a97d-44bb301c729mr17180781f8f.5.1777919710232;
        Mon, 04 May 2026 11:35:10 -0700 (PDT)
Received: from [127.0.0.1] ([2804:1bc4:224:7800:585c:db3a:fcb:e21f])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-44a98b76eddsm26745511f8f.34.2026.05.04.11.35.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 May 2026 11:35:09 -0700 (PDT)
From: Marcos Paulo de Souza <mpdesouza@suse.com>
Date: Mon, 04 May 2026 15:34:43 -0300
Subject: [PATCH v5 2/6] selftests: livepatch: Replace true/false module
 parameter by y/n
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260504-lp-tests-old-fixes-v5-2-0be26d94ab9a@suse.com>
References: <20260504-lp-tests-old-fixes-v5-0-0be26d94ab9a@suse.com>
In-Reply-To: <20260504-lp-tests-old-fixes-v5-0-0be26d94ab9a@suse.com>
To: Josh Poimboeuf <jpoimboe@kernel.org>, Jiri Kosina <jikos@kernel.org>, 
 Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>, 
 Joe Lawrence <joe.lawrence@redhat.com>, Shuah Khan <shuah@kernel.org>
Cc: live-patching@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Marcos Paulo de Souza <mpdesouza@suse.com>, 
 marcos@mpdesouza.com
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1777919697; l=2032;
 i=mpdesouza@suse.com; s=20231031; h=from:subject:message-id;
 bh=w+QsBT+5pcbBe5xVs0oaWXhZ1MdasOi3IXWJ4w5Ext4=;
 b=xVdv9+L5/kvmjiEbk0rJPyxV/31YQ4/7jB3XPtAOW4kkggtg8rTjFI1oSkIe5lwcMkJgwG2R9
 sCT5FVtenXMBIjpopKjX6gWCLIgfRMnUYKfuvAjwNxxiqzpYOSqmR3H
X-Developer-Key: i=mpdesouza@suse.com; a=ed25519;
 pk=/Ni/TsKkr69EOmdZXkp1Q/BlzDonbOBRsfPa18ySIwU=
X-Rspamd-Queue-Id: B9F7D4C29DD
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
	TAGGED_FROM(0.00)[bounces-2699-lists,live-patching=lfdr.de];
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


