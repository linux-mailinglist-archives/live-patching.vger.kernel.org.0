Return-Path: <live-patching+bounces-2338-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id MJ3yHEcn3WlpaQkAu9opvQ
	(envelope-from <live-patching+bounces-2338-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Mon, 13 Apr 2026 19:26:31 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 4D55A3F162D
	for <lists+live-patching@lfdr.de>; Mon, 13 Apr 2026 19:26:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 01BBA301E70B
	for <lists+live-patching@lfdr.de>; Mon, 13 Apr 2026 17:26:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4200234C83C;
	Mon, 13 Apr 2026 17:26:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="LlkZM9pY"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EDA034FF74
	for <live-patching@vger.kernel.org>; Mon, 13 Apr 2026 17:26:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776101188; cv=none; b=qAiiRb8xB8WCB37694xDFlgY9UYboL7Fiq3QZiTnB2Tj7k0AwidnOrk44FfRNAM9ikUrrcBkXLwD15/gLKR3x4br45hjqtJugbZdfzfzThj7MGB1alU8CykObdJ974sNww0u6vIwHTyVVutNq99HlBvpzd88zCg0hlHAp0q7qiw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776101188; c=relaxed/simple;
	bh=rr2RR+x0HeR1UdbTO0pKuZtUObXU97RoB+HEOcwaOdM=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=WBTH8tdKI/uggXYyKh36ieJjgVMoUfo/BmctVZUkZMGhxO87ZOOAPmXW10kMN7VV0EqH+/mAw7n9oZlstBskDw1qK3lT54EpEkaf3KVgILneF4BmLrpj9oaLszfufKVt1paXs62zQOR8W1up3TokowNVo40nli5DTImo0h/rO+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=LlkZM9pY; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-488b0e1b870so74560215e9.2
        for <live-patching@vger.kernel.org>; Mon, 13 Apr 2026 10:26:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1776101184; x=1776705984; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lT7L7ZV1IaRLBgX9aPy3VkyvToZXmMkItn9sA5MqUEw=;
        b=LlkZM9pYr+/bdBE623ije+y31ICCNO8C9PTd7pA3vxFTVtQe4Z5ZAYyXq4oR7FItnV
         HmsNbJ8QwaMDm3WBHg8vtHhz4WJ/76yRxYbnEK+w8fBJiFgl9F+eNR68zJwc0idZjGk1
         +F8LE9bpBPRZDS2gCszttXhlvZ9dhjk3IAMruSbqFWK/jKpEEJsKcdpvAHYpNB5PSrIm
         +4gJ/62XIOHftQZ5kEX79UAaRg4CthBGuRVtXEZO1wdwHBUlciVg3M16AwdqiFkr/6U/
         AhusHH1awTu0YxfaXwdjuLIecpNp70at/j+qrF5fOsVD7j7+YWHNUPBSilJWleJJAyeD
         vPmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776101184; x=1776705984;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=lT7L7ZV1IaRLBgX9aPy3VkyvToZXmMkItn9sA5MqUEw=;
        b=pX4QtdofKRuO5WtUylorSZhoEGWtelsDLWN2dDPYOFZK69qS+UBjy22c8yJxbiJKHh
         SB0+/m3M59lFdtPTPYJQNxHY0qRd5Grz92fsx8XuzzegEciDoRVX/imAT65quQaK6xUI
         J6OpF/fGYeWeubwg1Nd3h5+z5O/+1AxzilVOggGSkjzMw5IDVpt4uDeg7Y/xvubd+JIQ
         yew4fCMCTt9QvIRXQs5OdFHbem5b5zNx6fnq9mogviIW4lK6PZhD/sMSCUw7s4OUY+MG
         IhU2d1eDs4S4xpdy+9vhWOrAUxh/O7z1Hv41A4D8WUIofSCfXy1Vt4ENjC5BIhKOqMDz
         w5kA==
X-Gm-Message-State: AOJu0YzTkDw528QO9fH7+ANeboL1cVNfSAtRSTEv4Is2ZW9m92rFFeFh
	BazbD8pPGRzJ4Zp75+OTRUVRw/IpVRM4/1iGSNgAUvOeT/cj4BgDdjViRmPOL74/H8o=
X-Gm-Gg: AeBDievuOpZ6xefUva3pkbqCjcr0Q1Paa/5kfRon7NkLppn1nkoDYkA+H+IEFvmup01
	SIxol7zCWCnbmFAOaXFo3/0GcbbDNjJIGZ+6/RzKHUrAajdWvbn75PghjVShLKwT8elMO4XQbU0
	hEpMnQwe9PvVtD57AG7FAjWPq5uBf8ppIZw9G9GIJIL8MC84gVeGj183rXrBXI0d83ZeSMaU4Nr
	TC95fQdK2hVxqHHzvkUgdKMpkHWSa2AnbyI6QnniLZpACy92nmFF0HNnRxfRc+daizSghqcwqpF
	fud3LoV4Y0t51RSbYylB1zbHV5szAf/R9yv4eRx3vrt5ZMtmSCAiRw4k6Ij0c4l9mn6gnthkN9z
	MW0A1ESFeJbE7+gpiXh+FQaMDWBZudpM6b4HLul6zYHbHGFo8wKsmDZlEMOgZbuvhMTqRW+upda
	hh5P6CCbHUfYryF7Scpdx7JfY=
X-Received: by 2002:a05:600c:1c0a:b0:485:4388:3492 with SMTP id 5b1f17b1804b1-488d67f4e67mr195662795e9.11.1776101183656;
        Mon, 13 Apr 2026 10:26:23 -0700 (PDT)
Received: from [127.0.0.1] ([2804:1bc4:224:7800:585c:db3a:fcb:e21f])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-488d5734a94sm298657835e9.0.2026.04.13.10.26.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Apr 2026 10:26:23 -0700 (PDT)
From: Marcos Paulo de Souza <mpdesouza@suse.com>
Date: Mon, 13 Apr 2026 14:26:12 -0300
Subject: [PATCH v2 1/6] selftests: livepatch: Check for
 ARCH_HAS_SYSCALL_WRAPPER config
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260413-lp-tests-old-fixes-v2-1-367c7cb5006f@suse.com>
References: <20260413-lp-tests-old-fixes-v2-0-367c7cb5006f@suse.com>
In-Reply-To: <20260413-lp-tests-old-fixes-v2-0-367c7cb5006f@suse.com>
To: Josh Poimboeuf <jpoimboe@kernel.org>, Jiri Kosina <jikos@kernel.org>, 
 Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>, 
 Joe Lawrence <joe.lawrence@redhat.com>, Shuah Khan <shuah@kernel.org>
Cc: live-patching@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Marcos Paulo de Souza <mpdesouza@suse.com>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1776101176; l=1832;
 i=mpdesouza@suse.com; s=20231031; h=from:subject:message-id;
 bh=rr2RR+x0HeR1UdbTO0pKuZtUObXU97RoB+HEOcwaOdM=;
 b=hdn6jheR3lzQFjoGWchyhG3rl3D/g59+JC33wwwmYVHOSJ0XZJRcKHAbOHyDsKVA2+0/KLpbe
 0knQ66N73cYBunFNbaXFS/yCdrGwWgPCQHTsU+OG46Oo+otluUbxuTK
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
	TAGGED_FROM(0.00)[bounces-2338-lists,live-patching=lfdr.de];
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
X-Rspamd-Queue-Id: 4D55A3F162D
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Older kernels that lack CONFIG_ARCH_HAS_SYSCALL_WRAPPER config don't
have any prefixes for their syscalls. The same applies to current
powerpc and loongarch, covering all currently supported architectures
that support livepatch.

The other supported architectures have specific prefixes, so error out
when a new architecture adds livepatch support with wrappes but didn't
update the test to include it.

Signed-off-by: Marcos Paulo de Souza <mpdesouza@suse.com>
---
 .../selftests/livepatch/test_modules/test_klp_syscall.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/livepatch/test_modules/test_klp_syscall.c b/tools/testing/selftests/livepatch/test_modules/test_klp_syscall.c
index dd802783ea84..b5527a288a7c 100644
--- a/tools/testing/selftests/livepatch/test_modules/test_klp_syscall.c
+++ b/tools/testing/selftests/livepatch/test_modules/test_klp_syscall.c
@@ -12,15 +12,26 @@
 #include <linux/slab.h>
 #include <linux/livepatch.h>
 
-#if defined(__x86_64__)
+/*
+ * Before CONFIG_ARCH_HAS_SYSCALL_WRAPPER was introduced there were no
+ * prefixes for system calls.
+ * Both ppc and loongarch does not set prefixes for their system calls either.
+ */
+#if !defined(CONFIG_ARCH_HAS_SYSCALL_WRAPPER) ||  defined(__powerpc__) || \
+	defined(__loongarch__)
+#define FN_PREFIX
+#elif defined(__x86_64__)
 #define FN_PREFIX __x64_
 #elif defined(__s390x__)
 #define FN_PREFIX __s390x_
 #elif defined(__aarch64__)
 #define FN_PREFIX __arm64_
-#else
-/* powerpc does not select ARCH_HAS_SYSCALL_WRAPPER */
+#elif defined(__powerpc__)
+#define FN_PREFIX
+#elif defined(__loongarch__)
 #define FN_PREFIX
+#else
+#error "Missing syscall wrapper for the given architecture."
 #endif
 
 /* Protects klp_pids */

-- 
2.52.0


