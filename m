Return-Path: <live-patching+bounces-2565-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id EBcMNjms72kCDwEAu9opvQ
	(envelope-from <live-patching+bounces-2565-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Mon, 27 Apr 2026 20:34:33 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 1EF94478A64
	for <lists+live-patching@lfdr.de>; Mon, 27 Apr 2026 20:34:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 9179F300C34C
	for <lists+live-patching@lfdr.de>; Mon, 27 Apr 2026 18:31:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3548F3EC2E9;
	Mon, 27 Apr 2026 18:31:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="gk+EouAU"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3E613EC2EE
	for <live-patching@vger.kernel.org>; Mon, 27 Apr 2026 18:31:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777314679; cv=none; b=XBBa+YqJqX8NKtD2d/1VVbxxEKfIl05ZQfJ8kMRBbv4aKAiOH7tFQMBo0hwxt6llWXK555DF14VhwP0OipplIZmDMOXnpAMQEM/FGFfY4W5uk5GubNpQiZkb7XsnClGbaT16v7dGLY5HWhx2okaDKcwM6qf8ymD6xNj3yrtzDEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777314679; c=relaxed/simple;
	bh=zwVAcfIrB5gkKSQrtegRJbhzNles6rOGTmiKmx6GRWQ=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=n8g3NzlMXqJQNQc2lQmAehcIm8OhQo9Wg90FXlcKID24cPvIXxuUzDsCxSiNW+Q5G5EIp7JZnAMNhyYFTT6Skka6rrI4ETjtT6AcCgTiJkI0Pffm9RjBHbIgURv0V0IpmwqKh46DOgBnbKs+XQkxYbva9OOcHniWqt4xGLoYP4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=gk+EouAU; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-488ff90d6c7so90465015e9.2
        for <live-patching@vger.kernel.org>; Mon, 27 Apr 2026 11:31:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1777314676; x=1777919476; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/rb04HihRpFGGRez1OC1FkeRKyhSIjAaQFdeNYoGCmo=;
        b=gk+EouAUkmmw6ejIs0bZcaMtTLrPEmsQehq9QLSbxtM27d7LIJaV+wfCNYUNbUKaGd
         GSFFs541NbeJAjFQPdy89FbeXkQtECA3vEIzc5pc38qLkROsNg/yeCfhNhaSBMCGHWiI
         wPW++9UJWXSAwzGyx2E9kslvvPWAFVA3G02SG4vt7uKpVZCl0R48EtJeFpVu/YyNmZWw
         j31oOODSHrD3v70jNKvAOHmq6F59spTD3l0txUIboQc0uanTZg1AXWrPb7C+QdTg9Lti
         4CcUP8wJnE7wfbnfGLZTc2DHieeWQRJDc+2AxwUvC+7p0dvY3+lxPOli8vF/VmWsQteU
         6/Iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777314676; x=1777919476;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=/rb04HihRpFGGRez1OC1FkeRKyhSIjAaQFdeNYoGCmo=;
        b=oz0xc4xG15/4fLYZkEnFodOuujqNUsXuUPG/eCgbPEZCHhfmuQu+8WEGi06b0Zhl4e
         cUzRns3b4gWzpg9NKnAFV4KVKPhznu/O4JAN0k4Ruz8tK6t/ANZflXQSTNzmN7Z65/YY
         7UXOLQQOCfBj2Cg5OYkQH5ocNq9CLyXLaJsH/ZOdGZCoHHNvrofYa+bIsrrRZ6V9qszM
         ppiUcsIpRoEW2HdZ/lCoORID/UAcV/MHF4gJjFtKqZX7GJmiWODMsiLhNZjjH0TvJiwz
         in0xFeuBamJJmuWzg9/PeCO6oimuQ7DJKr1P4PY74CVnqp08uJmNnCHPKYqoGOqhWflN
         haNA==
X-Gm-Message-State: AOJu0YyLWsuUejw2OHWgwiYO18fxdfQPojLQdEzZKXO+OpKD8ajXvjvO
	kCjP3emTNqdh+3UAKMx+G/dMcDNYs8gpEa9qTqxv61Y225V/KSaONd/os4Kkp3fJ4GacTMgWtAK
	8SkC9zBI=
X-Gm-Gg: AeBDietcxKzPKXw3HCFoxgGDIbiBroIjblku/IjpQuB1EuuXpW5MzSeybticSJvP1hi
	PmYMdqf69dRjORlWsTuaDmEQNJkgj5p3eib3AibGbcj+fogKzy73K5V1FCfLXrTisTY3cg1KD1E
	AfMZe/BS81gRSQgYnBJAgVk56Jp90XKJ5nyekctZz5L/mKZ7IgKiTBU8nkzd6L9zmqv7cYBtY5O
	rTt54uzim7MD+PWB+w2DudZmXN4VXbaYUg9toOjhncIWb9wRtLH1oGjm71y2ntyft4oyeo31gOe
	RAXqSlPTnnv038FJFZpYXxKNSl7xE5wfiho755jS0zU6xt3UwVYVhTZfYKe9mHZo9xvMcisu0uD
	nWdLxb7y7Z+Bm8PZM5lpGDlE0RLU6M54vUrHLovweEdD4znUdKo5m+dle09WMFPMxB5rZWydMHP
	UllLufbEn2EkLPgpBd6lcjdivVi69A3PuYwQ==
X-Received: by 2002:a05:600c:8588:b0:48a:5821:5ffc with SMTP id 5b1f17b1804b1-48a76f4d4eamr5060945e9.2.1777314675876;
        Mon, 27 Apr 2026 11:31:15 -0700 (PDT)
Received: from [127.0.0.1] ([2804:1bc4:224:7800:585c:db3a:fcb:e21f])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48a7749cabdsm1182065e9.9.2026.04.27.11.31.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Apr 2026 11:31:15 -0700 (PDT)
From: Marcos Paulo de Souza <mpdesouza@suse.com>
Date: Mon, 27 Apr 2026 15:30:59 -0300
Subject: [PATCH v3 3/6] selftests: livepatch: Introduce does_sysfs_exist
 function
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260427-lp-tests-old-fixes-v3-3-ccf3c90f744c@suse.com>
References: <20260427-lp-tests-old-fixes-v3-0-ccf3c90f744c@suse.com>
In-Reply-To: <20260427-lp-tests-old-fixes-v3-0-ccf3c90f744c@suse.com>
To: Josh Poimboeuf <jpoimboe@kernel.org>, Jiri Kosina <jikos@kernel.org>, 
 Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>, 
 Joe Lawrence <joe.lawrence@redhat.com>, Shuah Khan <shuah@kernel.org>
Cc: live-patching@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Marcos Paulo de Souza <mpdesouza@suse.com>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1777314662; l=1087;
 i=mpdesouza@suse.com; s=20231031; h=from:subject:message-id;
 bh=zwVAcfIrB5gkKSQrtegRJbhzNles6rOGTmiKmx6GRWQ=;
 b=uwrNh3NOvNhP4CUH8KIrYnpyJhIr9yii3s+MOQSBeKBBfupCiNw+N5m+vDWSe3YLLzJ+5M8Pm
 YTUyXceBvuxCNGEsjLumSvbgeg9+B00KoUFrWE4V1EPy9JJVtaQDWPs
X-Developer-Key: i=mpdesouza@suse.com; a=ed25519;
 pk=/Ni/TsKkr69EOmdZXkp1Q/BlzDonbOBRsfPa18ySIwU=
X-Rspamd-Queue-Id: 1EF94478A64
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[suse.com,quarantine];
	R_DKIM_ALLOW(-0.20)[suse.com:s=google];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DKIM_TRACE(0.00)[suse.com:+];
	TAGGED_FROM(0.00)[bounces-2565-lists,live-patching=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_SEVEN(0.00)[10];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.com:dkim,suse.com:mid,sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]

Returns true if the livepatch sysfs attribute exists, and false otherwise.
This new function will be used in the next patches.

Signed-off-by: Marcos Paulo de Souza <mpdesouza@suse.com>
---
 tools/testing/selftests/livepatch/functions.sh | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/tools/testing/selftests/livepatch/functions.sh b/tools/testing/selftests/livepatch/functions.sh
index 8ec0cb64ad94..2bc50271729c 100644
--- a/tools/testing/selftests/livepatch/functions.sh
+++ b/tools/testing/selftests/livepatch/functions.sh
@@ -339,6 +339,16 @@ function check_result {
 	fi
 }
 
+# does_sysfs_exist(modname, attr) - check sysfs attribute existence
+#	modname - livepatch module creating the sysfs interface
+#	attr - attribute name to be checked
+function does_sysfs_exist() {
+	local mod="$1"; shift
+	local attr="$1"; shift
+
+	[[ -f "$SYSFS_KLP_DIR/$mod/$attr" ]]
+}
+
 # check_sysfs_rights(modname, rel_path, expected_rights) - check sysfs
 # path permissions
 #	modname - livepatch module creating the sysfs interface

-- 
2.54.0


