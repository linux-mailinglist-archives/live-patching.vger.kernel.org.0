Return-Path: <live-patching+bounces-2201-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id IIwMHwh7tGmOogAAu9opvQ
	(envelope-from <live-patching+bounces-2201-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Fri, 13 Mar 2026 22:00:56 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id F21EE289FB7
	for <lists+live-patching@lfdr.de>; Fri, 13 Mar 2026 22:00:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id A9DAB31E6D6D
	for <lists+live-patching@lfdr.de>; Fri, 13 Mar 2026 20:59:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 44A583822BA;
	Fri, 13 Mar 2026 20:59:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Xg/259g9"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32E7A381AEF
	for <live-patching@vger.kernel.org>; Fri, 13 Mar 2026 20:58:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773435544; cv=none; b=RP0jRbV1c+oHw1L2gHTXmNT7Z73h+SChi25JWLfCXzSkXGQ69SsAtoZaf8a75VA/P/m4IQ4bzJpXMLkKpBTfvf1+V0TWQoKWheBcKYyQFzhq37gm40XP+j1shibQhy08pZ/xG8zgojeMQYKwCGhDGHf4UCe1XFsUKeln/vLnYZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773435544; c=relaxed/simple;
	bh=VRVN7RkiGrgm69aDuMpcOshBDCo1eHbzdD2OnFzwxC8=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=S4eLNrNne9RB7uhODm729u5qsadTZ7/b2+azfYLJ3g37PU29FQqMYqFmq56xA5Uzr+0sLlmcm8HO8mNtiuMxg4BxkE/AWFM6omwHr83FfxgIeHAdy8wvsM1VfbdHzlMObg53++wSkv8A5vb87tYvCVcb89J/u8JVBiotNyUuGS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Xg/259g9; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4852a9c6309so21248365e9.0
        for <live-patching@vger.kernel.org>; Fri, 13 Mar 2026 13:58:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1773435538; x=1774040338; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YSXSOnbGFJdo6hwFszubEP6hGZ4DJRtieMzbVIvPjZM=;
        b=Xg/259g9Ew2Fi/sRw8BaWvyPSe4FmFyRaDqWQ7GNS5i9uoS2bPqInTy9CAT75DnKX1
         4pDzT9b8oo4UskjRuJkORsGlkQNsQ+0N/ZHBcpT6bJaqoCIIqXG+IAWBotGKp/UQJlQg
         leXUq1leggs5NjmrO5Jy9T1bBUPpj92MIi7VNcH0TZIMGdrQ+z9GJTGcda0sW4C+IIDE
         ihRZWM0cY7KMVhqOz/iZXTB1szOY+MOvclwDnnAo1LyvYBmTfwdnLpw9sHFb/zXCRrpb
         MmBXUFyNcoHKSQBrZRsjMCRGBbydJ7hvMjFIwm3tLlnucisb3UVwrYriPEubCxeVSw4Y
         ZK0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773435538; x=1774040338;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=YSXSOnbGFJdo6hwFszubEP6hGZ4DJRtieMzbVIvPjZM=;
        b=UsXq/+748Zc1GmBYSmXSN1i2FRQBxJPI3nqV7s0ZRTMUHTDkO/j0TIp737QoYFs9sJ
         IYV5sBO3YEvbxRw228d6Ek7FufimaIHggJ0Urr8Ezx/cT3B04Q5dtHOoVZnyhKEb2Bg1
         Wr1sJFKxmmMC3ruqvjltmvcVAZCSG89xGGz2khscUm+Gkx4ZzNVUew8mNuf1VNX8d8Pu
         uNxp3iqoIeqV1IBG7QVJVkFTsYFRb2k2ffr88W4eiwXWuiLDFszacQMv9lvsMsARQdMy
         OvzcQ1lhtUOEifEAG6ToqDK4/5Jb7hybZtZ/uZUN9MHy39SjnIOjCPyUxFWQkhzgSwQt
         njdw==
X-Gm-Message-State: AOJu0Yww3ETva/k/zyLg84HbwTiB67VREQtkDLR3xAM/Ay0lBUP+vI/G
	0VieROO2YatRI7eeVYwQvhnV+IYvmP+xtJ1VquFq65L3HIRGvsXi3fLyg6JqOiczrkg=
X-Gm-Gg: ATEYQzyBZbo33BWpZCcjuj42EqC+xv0At8pi/3tOOos241XHbMt2BiYZrFOvhWuye/H
	EjAvhSXgS96KxgTla/YsrR67KpMiPNfQa3so4T1RFnXKjiDFH1c3qzDrUfFBNnpiTJIyA1PvEa8
	44IwOXFgM7SZt4e616UB8Iq6NboK7iD/kL+NNfORrXgQfFy2C3YIfcYQGwZq660Tyf0wnRFD1ud
	AS6sTFRxhAr5zYP+0P4G0VHst0/1ezUQsv/D2PUvv+atKIvXgNBIr2rFvIAI7MexiTrhs0AqPuU
	MyggvIRICT0Rhax0jQGB8ENg6ZkQC5OzS/AXkjvfA+dUFmh4I/fhRpRy6nQuaMei/XaMjnHzoC7
	KzOfSi9qj/peIPgziD+qq72muyMY0KxvC+RDQnbc5DGa2e7fo8ABHExi4rUTqaJg/9eokevXIwB
	8b96WLFC+oxvt36TO97YuG
X-Received: by 2002:a05:600c:1f8d:b0:477:7af8:c8ad with SMTP id 5b1f17b1804b1-48556711419mr77064255e9.31.1773435538040;
        Fri, 13 Mar 2026 13:58:58 -0700 (PDT)
Received: from [127.0.0.1] ([2804:5078:834:1300:58f2:fc97:371f:3])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2beab526d3csm4042611eec.18.2026.03.13.13.58.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Mar 2026 13:58:56 -0700 (PDT)
From: Marcos Paulo de Souza <mpdesouza@suse.com>
Date: Fri, 13 Mar 2026 17:58:35 -0300
Subject: [PATCH 4/8] selftests: livepatch: functions: Introduce
 check_sysfs_exists
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260313-lp-tests-old-fixes-v1-4-71ac6dfb3253@suse.com>
References: <20260313-lp-tests-old-fixes-v1-0-71ac6dfb3253@suse.com>
In-Reply-To: <20260313-lp-tests-old-fixes-v1-0-71ac6dfb3253@suse.com>
To: Josh Poimboeuf <jpoimboe@kernel.org>, Jiri Kosina <jikos@kernel.org>, 
 Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>, 
 Joe Lawrence <joe.lawrence@redhat.com>, Shuah Khan <shuah@kernel.org>
Cc: live-patching@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Marcos Paulo de Souza <mpdesouza@suse.com>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1773435515; l=1140;
 i=mpdesouza@suse.com; s=20231031; h=from:subject:message-id;
 bh=VRVN7RkiGrgm69aDuMpcOshBDCo1eHbzdD2OnFzwxC8=;
 b=j44w73MHAVUmex0H1jUYBDxUa2M7EmxhvQ7ovZCyWcxRTXhf661foGU7zlt8GToTphwQO3QH+
 9qbyHFqgc/mCDhnhbX2ucfZhx1+sGhqjDLZRV/6h3nOQKdO9mPtiBNM
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
	DKIM_TRACE(0.00)[suse.com:+];
	TAGGED_FROM(0.00)[bounces-2201-lists,live-patching=lfdr.de];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,suse.com:dkim,suse.com:email,suse.com:mid]
X-Rspamd-Queue-Id: F21EE289FB7
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Return 0 if the livepatch sysfs attribute don't exists, and 1 otherwise.
This new function will be used in the next patches.

Signed-off-by: Marcos Paulo de Souza <mpdesouza@suse.com>
---
 tools/testing/selftests/livepatch/functions.sh | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/tools/testing/selftests/livepatch/functions.sh b/tools/testing/selftests/livepatch/functions.sh
index 8ec0cb64ad94a..781346d6e94e0 100644
--- a/tools/testing/selftests/livepatch/functions.sh
+++ b/tools/testing/selftests/livepatch/functions.sh
@@ -339,6 +339,20 @@ function check_result {
 	fi
 }
 
+# check_sysfs_exists(modname, attr) - check sysfs attribute existence
+#	modname - livepatch module creating the sysfs interface
+#	attr - attribute name to be checked
+function check_sysfs_exists() {
+	local mod="$1"; shift
+	local attr="$1"; shift
+
+	if [[ ! -f "$SYSFS_KLP_DIR/$mod/$attr" ]]; then
+		return 0
+	fi
+
+	return 1
+}
+
 # check_sysfs_rights(modname, rel_path, expected_rights) - check sysfs
 # path permissions
 #	modname - livepatch module creating the sysfs interface

-- 
2.52.0


