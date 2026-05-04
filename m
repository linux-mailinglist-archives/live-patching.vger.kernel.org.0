Return-Path: <live-patching+bounces-2700-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id wKGyGCfn+GnR2wIAu9opvQ
	(envelope-from <live-patching+bounces-2700-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Mon, 04 May 2026 20:36:23 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id BC06D4C2A01
	for <lists+live-patching@lfdr.de>; Mon, 04 May 2026 20:36:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id D00693052893
	for <lists+live-patching@lfdr.de>; Mon,  4 May 2026 18:35:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 18FA43E6396;
	Mon,  4 May 2026 18:35:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="MIh3YZgw"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C42753E6383
	for <live-patching@vger.kernel.org>; Mon,  4 May 2026 18:35:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777919720; cv=none; b=sJBBUw04VyX1Jmyi6qEP1t0KeNPzJpeKRw0miLs/Iqj1s1gTUZw6kg5/ZqM8uk2f9ZnjJ/wer3Ig3nNqLcCBG7yEGCZAJviAUKVp7d2BOgzKagrcYYvo4nw5i18RUdG73ELT89XPAkD5ZX/rdq3R1V8PO3NtjmnE66HZfv3ZOpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777919720; c=relaxed/simple;
	bh=zwVAcfIrB5gkKSQrtegRJbhzNles6rOGTmiKmx6GRWQ=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=B70W5jB+hdF0Ky44gkHSbCeo+FwUE+fsOD0tf/ziTuyJxFpYKTLB81pFKeDTDGL+gBXrh3SGUO7W8Z1RlljfnbpQhnr3DNhqv0bGUmCEJEZ+Ci/Yml5XXxUHrbVhn0S+3+2v2WGajftmoTJFM4cAVLtPq3ZuWaxXo1y/k4PymRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=MIh3YZgw; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-43d75312379so3039994f8f.1
        for <live-patching@vger.kernel.org>; Mon, 04 May 2026 11:35:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1777919714; x=1778524514; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/rb04HihRpFGGRez1OC1FkeRKyhSIjAaQFdeNYoGCmo=;
        b=MIh3YZgwcQY+lfaM6f/2hSjNmS2XHJyF7O8hU/VapEvteU/Rt6N/QGfx4aGCzuBfYE
         pjh6ALIieZjYS3HaNzZWM5NVqIiWBgejeDWeX0XYCcBdy3S8jPF80hyCSx2jEOCQRUw2
         L6wvau1W4Uda+1R3aRfxB6RhLlDby9UTwLG48Xjjf+duDavhiaWJ83fBlIKdyTJh6HT6
         F92hjbMKJ5/L7xi/li/5/iTArTckEK0MBs+aPJv6WNhH3+7wsklZaiGxhXngob7Qpxtc
         JGoEzd28R5s9YuEYSZBnI/dTx/CYkfpgq8knTeKWYlFepj4Ngrho4tH1HCtoFVhKMAqg
         JELQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777919714; x=1778524514;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=/rb04HihRpFGGRez1OC1FkeRKyhSIjAaQFdeNYoGCmo=;
        b=krm7q33Lw/4d+FZp4XzlW2vjLQ9QxxSjhYi6l+nESS/wY7DspePL6VJmkzaU+KN4sK
         gpBCUguKsQegKoZwNQolsGsg9p3MbuZXGORyjsJp21ugE8D0K+AQv6N7MjvtgByOSaGp
         nxpk4ebsgBuoz6cWa2ACz343BjF/t6fvllxv2BaYwhJcnXhDrqRiDlEDr4tA5qj7Chb0
         isztJSbMnE2yzigVydofKAIlJKMduCarIJUzOCCJHkt2E4gQHCw4/76uIC6nKsIm3EF+
         rQ9dpNMb9oIfUj0Tzia2ZF/Q8/8U9ydSfsTFmwwroLnFH1PUKSBGS422ifKR47R6e2WU
         /g5Q==
X-Gm-Message-State: AOJu0YzR4m8KrutAM/lNXnYn4bSi77oh17ZBg2HhYdEjR25mDOWcMM5w
	u6Fp9oSWFfxHNybnj5mWuXRk9CNrfhJjNiKyi6FSUaZX5fI5iarkhp0w0iB1bNp+TZdI3AZY4kS
	ydwpQp98=
X-Gm-Gg: AeBDieuTZmAZopxEFP6eafUCgscPkV9Rv4Qyam6BbxLS45kOZRyEEcinxochQ5l6zdo
	Xd9LVABhrMwHY1WY77BuKQTucaqYKyI9kmuUHHjwy6y5PVPPsRHgIuVjpQ6Voo8XrBQRQRfCswj
	PYNorcd5vsbKN5+v0tUQQk/+j5J5icMdbuortI4zzdHuxcATfZ8d3UroaLCBv3JAAmWYCzYTVb5
	Z88Vr7+s0x7gUjP5QsE/HqpLegHbK7PIq/HgQwgJSwg5spYPxOkGFh0CRf1rCJvY7lFISmR9YpF
	xl5ZSYL+CVYVpbHA5QoWvO/JirNiqJGmJmq0EPnN1EIqBL6G64X9DL9zNWXjW7VM1wINv5H+FOp
	fItZL6WI73mnehcYZ0SPMb68+1nYqfJjJCS+xCQdYUGL5T2Sm7Y3m60XazyptecmXDiu7OjIAq/
	vwBwv28VkgWyJPK4KRpk4HATbotySoj55y5w==
X-Received: by 2002:a05:6000:4185:b0:44b:5a37:36c4 with SMTP id ffacd0b85a97d-44fdf21c263mr846289f8f.26.1777919714291;
        Mon, 04 May 2026 11:35:14 -0700 (PDT)
Received: from [127.0.0.1] ([2804:1bc4:224:7800:585c:db3a:fcb:e21f])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-44a98b76eddsm26745511f8f.34.2026.05.04.11.35.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 May 2026 11:35:14 -0700 (PDT)
From: Marcos Paulo de Souza <mpdesouza@suse.com>
Date: Mon, 04 May 2026 15:34:44 -0300
Subject: [PATCH v5 3/6] selftests: livepatch: Introduce does_sysfs_exist
 function
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260504-lp-tests-old-fixes-v5-3-0be26d94ab9a@suse.com>
References: <20260504-lp-tests-old-fixes-v5-0-0be26d94ab9a@suse.com>
In-Reply-To: <20260504-lp-tests-old-fixes-v5-0-0be26d94ab9a@suse.com>
To: Josh Poimboeuf <jpoimboe@kernel.org>, Jiri Kosina <jikos@kernel.org>, 
 Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>, 
 Joe Lawrence <joe.lawrence@redhat.com>, Shuah Khan <shuah@kernel.org>
Cc: live-patching@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Marcos Paulo de Souza <mpdesouza@suse.com>, 
 marcos@mpdesouza.com
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1777919697; l=1087;
 i=mpdesouza@suse.com; s=20231031; h=from:subject:message-id;
 bh=zwVAcfIrB5gkKSQrtegRJbhzNles6rOGTmiKmx6GRWQ=;
 b=xEIWz0+yEclXAyLG6pKQNfJzvV5laNiryR+3nDpFPz3Hkej5nUD5QebhOsozzUiaV2yImPQaH
 T2/YF6b0iK7AH7VTr1yYJ3lUpYUvXehnHIm4+XwXRPlvqORNmFVNucP
X-Developer-Key: i=mpdesouza@suse.com; a=ed25519;
 pk=/Ni/TsKkr69EOmdZXkp1Q/BlzDonbOBRsfPa18ySIwU=
X-Rspamd-Queue-Id: BC06D4C2A01
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
	TAGGED_FROM(0.00)[bounces-2700-lists,live-patching=lfdr.de];
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


