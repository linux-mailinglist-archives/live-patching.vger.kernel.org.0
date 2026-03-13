Return-Path: <live-patching+bounces-2199-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 0AZEDdt6tGmOogAAu9opvQ
	(envelope-from <live-patching+bounces-2199-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Fri, 13 Mar 2026 22:00:11 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 8D6B1289F77
	for <lists+live-patching@lfdr.de>; Fri, 13 Mar 2026 22:00:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id DA0243037D42
	for <lists+live-patching@lfdr.de>; Fri, 13 Mar 2026 20:59:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E85D382363;
	Fri, 13 Mar 2026 20:58:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Gh01QykV"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4EB8381AED
	for <live-patching@vger.kernel.org>; Fri, 13 Mar 2026 20:58:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773435533; cv=none; b=JtuWzlT7xOFv9iPXGehMrsyNKgnMc3xeTlCFdWdvrr4m3QrLMcH67/owVQgM1CSDzzVkjiN9IxpXWsaB3ORbWBgy4FFJC5G2+du6hPHS8rjL0v1Ovk5myF2i2BE/f8EkX0v7e1ZXrbg6VgI7bO4zyoYtluF72lZtTvhIkpEfjJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773435533; c=relaxed/simple;
	bh=1RfbEstq7Ctycg2Jjjbdik5k6wt6QjUzw7dgsIUK4B0=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=NdBfNbWfzz8r7F6cyTbAOzllcA+HGeFER7zr8DAn+NUmiM5LioOCNO7vDDyYJrM9DNFAkhH71RcZfVImuynV7xJm0Rv7WGoePL4S/rZVs4XhI5EG77ndJpFHeVLEwuMu2vW+6dJ9PymULNsGsduXd0T3neK3FPKAW3yQ0DjfKbw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Gh01QykV; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4852f8ac7e9so30090765e9.1
        for <live-patching@vger.kernel.org>; Fri, 13 Mar 2026 13:58:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1773435529; x=1774040329; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iETlcb04uVTRpZaVmkcYa5KMez1NknEs+5aPJ6reEiA=;
        b=Gh01QykVHQt/Jmjc8t4Jh+wE9xEjnw99M9n3Yu2B0QxzcwDWP8AO8ZyKFJ9jxw5Sjn
         39//qw5978H0u1V+IR6BFQbpsiaoar1SWHOAM2y/Zq1IOsvROMeQIENZ7VA7/aXoyD56
         YNnDZR5WcdgCNvLg7J4TaTFqOqZNp5QGxdPW/k12DQ6fMb7KFxGmXmARFpRWR1mh/4cv
         GQ6a43Ag9JsK5bO2C3fWtsdYM8BYNgsTsYhg/2lrxKa0zs7YKPqMFnINYDSUTap9q8eS
         JrD0CBLviiJC1UQugSLEbN/vxFE0qUdwvmoVvLar7cLZLaSuYrwriS+IiDypwFZKmAtw
         LQtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773435529; x=1774040329;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=iETlcb04uVTRpZaVmkcYa5KMez1NknEs+5aPJ6reEiA=;
        b=T0lL2Ujk9tZyIb3nqWICkGrjc2+HOxEAeY3DcOI9IBN6FkWI9HEQGWZBpqdhgh65oi
         eylmzWebVqMOuj8W94tTyLaXrfO0SqeOVThrdqQ1+H16MbkWtjtyn+LyPGnQTkZDOwjN
         4yWJOTpInvZLlNjafTjEjnr7sKkUHO/vqDRA58zaNwWCKc2QtEx4IqSb6ayNqFzdKVp1
         Yiwy3bZJ056xzNayMYBCwTfCk90luNyf2x0YCmi16uDBuZ/ELhMRODg77RNUHxM13K/E
         OedhNTwwnudXOutq8nFt48T+icuckE15UuCdX+1Q4RnRsL0H0gGkBUVviYNVoUc3ukEB
         NgQg==
X-Gm-Message-State: AOJu0YwxXkBxMpm+IAVPJwKdpvzTlUfSybL13uTg9sOMluJCeOUk+Lgf
	wLD308K2iNRWJQXPaFij5EoGvKCsd81yW8yABdNQKttfZhO6aXpyA2E9olIMqCFVqcU=
X-Gm-Gg: ATEYQzw1bxjv+tJJ88cwkm5isuIyXvetqGu4+DY06TiA/m22SShbgzuykhpIIO/3/FX
	zJ66wERIV43GdPNfYZW+cUiib7y6LqH8vR6NIcV4pmzI8i4ge24tGVrWskNnj4Zqn+G/A1FXOiT
	tmQqmjg543JZzpq0ZtXQaTxahG7QMAP3MhB4wYBGFtvx8CFDE8yR4S4gU1Ecp/PWxKBUp4fgO1q
	VqnYYwRKIDxjLu0ZokxwlqyTcuT7KX8TElcAKqF2uh2/X31md8FgN+VoS9JGSlg6jXLTmgcKeqe
	DKsyjaqcycMpOr6rD2ukWXfYxSOkp1nSPBdn6qjteK09n2qwx5I6V81q93h16v7aKVoIwOUCsuR
	PhbRQas48AArdmmd4B7rUdbdX0RDvZ6m+73aXEekZ13upia9lOpNRQRJT4RjeOTSfU5cv9Ac7rL
	R1giljLZ5mqIL2MgxI9BIa
X-Received: by 2002:a05:600c:a45:b0:485:4006:960c with SMTP id 5b1f17b1804b1-48556702a7dmr80842015e9.16.1773435528862;
        Fri, 13 Mar 2026 13:58:48 -0700 (PDT)
Received: from [127.0.0.1] ([2804:5078:834:1300:58f2:fc97:371f:3])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2beab526d3csm4042611eec.18.2026.03.13.13.58.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Mar 2026 13:58:47 -0700 (PDT)
From: Marcos Paulo de Souza <mpdesouza@suse.com>
Date: Fri, 13 Mar 2026 17:58:33 -0300
Subject: [PATCH 2/8] selftests: livepatch: test-kprobe: Replace true/false
 mod param by 1/0
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260313-lp-tests-old-fixes-v1-2-71ac6dfb3253@suse.com>
References: <20260313-lp-tests-old-fixes-v1-0-71ac6dfb3253@suse.com>
In-Reply-To: <20260313-lp-tests-old-fixes-v1-0-71ac6dfb3253@suse.com>
To: Josh Poimboeuf <jpoimboe@kernel.org>, Jiri Kosina <jikos@kernel.org>, 
 Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>, 
 Joe Lawrence <joe.lawrence@redhat.com>, Shuah Khan <shuah@kernel.org>
Cc: live-patching@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Marcos Paulo de Souza <mpdesouza@suse.com>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1773435515; l=2034;
 i=mpdesouza@suse.com; s=20231031; h=from:subject:message-id;
 bh=1RfbEstq7Ctycg2Jjjbdik5k6wt6QjUzw7dgsIUK4B0=;
 b=R/GLdILhXCj8zr9ANzfi18u0WJVrCq1VW4lQo+ZqgoW+db89pYy4Iz86oJs/y0P/+VEgo2FKf
 LOOHZgWkIL8Dsc4KGGsnzlUUdTL2ENdD52Z9KhNOzQydZXdxZIg7thn
X-Developer-Key: i=mpdesouza@suse.com; a=ed25519;
 pk=/Ni/TsKkr69EOmdZXkp1Q/BlzDonbOBRsfPa18ySIwU=
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[suse.com,quarantine];
	R_DKIM_ALLOW(-0.20)[suse.com:s=google];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[suse.com:+];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2199-lists,live-patching=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
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
X-Rspamd-Queue-Id: 8D6B1289F77
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Older kernels don't support true/false for boolean module parameters
because they lack commit 0d6ea3ac94ca
("lib/kstrtox.c: add "false"/"true" support to kstrtobool()"). Replace
true/false by 1/0 so the test module can be loaded on older kernels.

No functional changes.

Signed-off-by: Marcos Paulo de Souza <mpdesouza@suse.com>
---
 tools/testing/selftests/livepatch/test-kprobe.sh | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/livepatch/test-kprobe.sh b/tools/testing/selftests/livepatch/test-kprobe.sh
index b67dfad03d97f..cdf31d0e51955 100755
--- a/tools/testing/selftests/livepatch/test-kprobe.sh
+++ b/tools/testing/selftests/livepatch/test-kprobe.sh
@@ -20,11 +20,11 @@ start_test "livepatch interaction with kprobed function with post_handler"
 
 echo 1 > "$SYSFS_KPROBES_DIR/enabled"
 
-load_mod $MOD_KPROBE has_post_handler=true
+load_mod $MOD_KPROBE has_post_handler=1
 load_failing_mod $MOD_LIVEPATCH
 unload_mod $MOD_KPROBE
 
-check_result "% insmod test_modules/test_klp_kprobe.ko has_post_handler=true
+check_result "% insmod test_modules/test_klp_kprobe.ko has_post_handler=1
 % insmod test_modules/$MOD_LIVEPATCH.ko
 livepatch: enabling patch '$MOD_LIVEPATCH'
 livepatch: '$MOD_LIVEPATCH': initializing patching transition
@@ -39,14 +39,14 @@ insmod: ERROR: could not insert module test_modules/$MOD_LIVEPATCH.ko: Device or
 
 start_test "livepatch interaction with kprobed function without post_handler"
 
-load_mod $MOD_KPROBE has_post_handler=false
+load_mod $MOD_KPROBE has_post_handler=0
 load_lp $MOD_LIVEPATCH
 
 unload_mod $MOD_KPROBE
 disable_lp $MOD_LIVEPATCH
 unload_lp $MOD_LIVEPATCH
 
-check_result "% insmod test_modules/test_klp_kprobe.ko has_post_handler=false
+check_result "% insmod test_modules/test_klp_kprobe.ko has_post_handler=0
 % insmod test_modules/$MOD_LIVEPATCH.ko
 livepatch: enabling patch '$MOD_LIVEPATCH'
 livepatch: '$MOD_LIVEPATCH': initializing patching transition

-- 
2.52.0


