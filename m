Return-Path: <live-patching+bounces-2205-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 6Ko6CmV7tGmOogAAu9opvQ
	(envelope-from <live-patching+bounces-2205-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Fri, 13 Mar 2026 22:02:29 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id BDD8E28A029
	for <lists+live-patching@lfdr.de>; Fri, 13 Mar 2026 22:02:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 806EB327824F
	for <lists+live-patching@lfdr.de>; Fri, 13 Mar 2026 20:59:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 61EBF3A2573;
	Fri, 13 Mar 2026 20:59:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="D3Uwbq4C"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 292073CF023
	for <live-patching@vger.kernel.org>; Fri, 13 Mar 2026 20:59:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773435561; cv=none; b=oE4N5cSK5VWCFV35FV+wB5AsafwvtKwehxYUiCWc2xsgCPgoI/BARAMDDdPm+VCn4nv+kj23dfh7xoGh3jUOqMBlrfqUVXENY8kiH+4hmnKNjyRF//urMruYaVC1RZ3dKwjUsVt44o/pAJvJ6Dy3I9h2hyaIdPXv2ZAdGf88D+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773435561; c=relaxed/simple;
	bh=csQBdTnyzr0JSm7zjXTuth96BuITEbEVBybFpbpIwyk=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=jW85JRyAHb8S/3gOZsUdu1QQyifN3ad4sZamyMeI4zgF35tgU6x2JUQNT6dcI4VkqLXuxh5qVSTNdL+OK6RQTMjoH6MVBWC+nYHcq+Ky+tuZEiopS9iV/5IwA7/UH1ZUveo/OWTenYqTB9KBOQeq9Ci11vg1SGcLj9WDPxgP0po=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=D3Uwbq4C; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4852fdb36a8so29620125e9.2
        for <live-patching@vger.kernel.org>; Fri, 13 Mar 2026 13:59:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1773435556; x=1774040356; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/dCEg0dd6B9Tjl1kgEu3NhdDbbVSDX6h4iOv2b5vp0o=;
        b=D3Uwbq4CEtNyw1GcsJQB8sOGJX5Fa4kmaGYo+SHnQeb4vdlB7BV+VhAunyHWi7tNce
         qGpgY1sX67tu1JoeRP5NPeTBhX3JjzsJQLo9ehbGEnsBPI3rKdJsQKqOHdvxHVrbH2rU
         mYQJ2o817IsuNWxZIeVpevWdOS/BSOaGVd/yTX5nwurbhLIIt7hdWolBDfuoIXuPxSW0
         lz3Gn6UWzhNQoHJPKYS1Vw802Wb8u3QKqIFQIDdkCcWvpRVbbBq1DiUCLzrWnSokyHv7
         V9kibxIjF9XJzb84MvGw/zR2fDjUF+bUZ0QX4zRqrVhfUAoApGwbreaALFrGp+foEMX0
         Jrgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773435556; x=1774040356;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=/dCEg0dd6B9Tjl1kgEu3NhdDbbVSDX6h4iOv2b5vp0o=;
        b=rg5mxcVXncQAepnpeoK9BkjlK9pJvAN+6VD/JSjn5ZmF1gTXpgQO9VXEcTVh0HOUy3
         RWcFFZDM5EwKFYNDJFEk5Pg2RBpNdMCV6kAGdpxb/XY12dkn5zJBRaAQWVewT6K8IhoA
         05wVbiBQSS1p0r49cADmGKifZLJGJjr9xEpPqz6lom6E81NjKfaCsO4iZKDxJKVW+I1Q
         d7V/4lWjPoZn/D7jMawPQJSNBLpghqb5kECOARJfoJ3+NcCleaTvT6wHCRIWkYDZ1Pnt
         t4UV9CzBQoTVP8FgTYT5K4zDEFBwDz7rHjlb3sfMjK8TPJ2VhKMlxp44OcmGhFFDtY8T
         70Nw==
X-Gm-Message-State: AOJu0YyZgGLlQrF4WO1qLJ9qD8++RZBOxSbWoAYAo7cOdgifTRkY1mXn
	+n56IQwVMetYBBlvtSKJzHhD78v+0Ef/RzFC/bKat3DuG/xU7y2M5ZUZcRQEoC5blhw=
X-Gm-Gg: ATEYQzzjaEtEOqq+iEWPyS2eRMjYj3Xn5YiiuNlOBmnWT31a9YCD1ocaa0q+4Rj8gFN
	XuQuJvU16HvcxfFhhkL3YwQkNG1OTiTV3evXZfm1LycRVK7TnsCO5hICetWDGW4GlcmnCpRYCIc
	Q6CYgFHSlT3laq1pyLOacWbLJUfNLhnniXuGXUV8kZBNU9jnUvAfqGOQFp7gzqFNli0w73Tyc93
	qfuxoqlYJFtkhkHE8YkkJP97FPsEzPoXmcyYuw5hNCw/eB25wHC8L9LpY2CLvjjTVjvNK381ljj
	08AlvEagi9Qe46p5x8a4DyIg4NRK1XlKSSoaoxf2C2LQZwGEXGiu8omhdKtZglGSG/ceq7IANOt
	1UH+yuovt7D6Wscc77iPoc1/eca1h9UzldNTWqyQPJLmJ8SAduoJ3jK8G0CTUV80pEn4AH7Qjl/
	2PVk6mSXnEwnYvZ/EBHGKj
X-Received: by 2002:a05:600c:c0c3:20b0:485:5981:1411 with SMTP id 5b1f17b1804b1-4855981166bmr45853985e9.23.1773435556207;
        Fri, 13 Mar 2026 13:59:16 -0700 (PDT)
Received: from [127.0.0.1] ([2804:5078:834:1300:58f2:fc97:371f:3])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2beab526d3csm4042611eec.18.2026.03.13.13.59.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Mar 2026 13:59:15 -0700 (PDT)
From: Marcos Paulo de Souza <mpdesouza@suse.com>
Date: Fri, 13 Mar 2026 17:58:39 -0300
Subject: [PATCH 8/8] selftests: livepatch: functions.sh: Extend check for
 taint flag kernel message
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260313-lp-tests-old-fixes-v1-8-71ac6dfb3253@suse.com>
References: <20260313-lp-tests-old-fixes-v1-0-71ac6dfb3253@suse.com>
In-Reply-To: <20260313-lp-tests-old-fixes-v1-0-71ac6dfb3253@suse.com>
To: Josh Poimboeuf <jpoimboe@kernel.org>, Jiri Kosina <jikos@kernel.org>, 
 Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>, 
 Joe Lawrence <joe.lawrence@redhat.com>, Shuah Khan <shuah@kernel.org>
Cc: live-patching@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Marcos Paulo de Souza <mpdesouza@suse.com>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1773435515; l=1115;
 i=mpdesouza@suse.com; s=20231031; h=from:subject:message-id;
 bh=csQBdTnyzr0JSm7zjXTuth96BuITEbEVBybFpbpIwyk=;
 b=GZFkqsGQmRtJSxuKY0Pl1xY69C7WZjWhDrYyBHAZcepdSz5AAxV1bkP9VYtsNctvJ/lXx7vQA
 zFraRerPgyFCgu8ZkptriwDws9SBHSt1Pf6+hqhdMjA4CoGvDgEyv7+
X-Developer-Key: i=mpdesouza@suse.com; a=ed25519;
 pk=/Ni/TsKkr69EOmdZXkp1Q/BlzDonbOBRsfPa18ySIwU=
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[suse.com,quarantine];
	R_DKIM_ALLOW(-0.20)[suse.com:s=google];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DKIM_TRACE(0.00)[suse.com:+];
	TAGGED_FROM(0.00)[bounces-2205-lists,live-patching=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_SEVEN(0.00)[10];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,suse.com:dkim,suse.com:email,suse.com:mid]
X-Rspamd-Queue-Id: BDD8E28A029
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On SLE kernels there is a warning when a livepatch is disabled:
  livepatch: attempt to disable live patch test_klp_livepatch, setting
  NO_SUPPORT taint flag

Extend lightly the detection of messages when a livepatch is disabled
to cover this case as well.

Signed-off-by: Marcos Paulo de Souza <mpdesouza@suse.com>
---
 tools/testing/selftests/livepatch/functions.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/livepatch/functions.sh b/tools/testing/selftests/livepatch/functions.sh
index 781346d6e94e0..73a1d4e6acaeb 100644
--- a/tools/testing/selftests/livepatch/functions.sh
+++ b/tools/testing/selftests/livepatch/functions.sh
@@ -324,7 +324,7 @@ function check_result {
 	# - filter out dmesg timestamp prefixes
 	result=$(dmesg | awk -v last_dmesg="$LAST_DMESG" 'p; $0 == last_dmesg { p=1 }' | \
 		 grep -e 'livepatch:' -e 'test_klp' | \
-		 grep -v '\(tainting\|taints\) kernel' | \
+		 grep -v '\(tainting\|taints\|taint\) \(kernel\|flag\)' | \
 		 sed 's/^\[[ 0-9.]*\] //' | \
 		 sed 's/^\[[ ]*[CT][0-9]*\] //')
 

-- 
2.52.0


