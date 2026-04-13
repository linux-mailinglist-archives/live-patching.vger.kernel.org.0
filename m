Return-Path: <live-patching+bounces-2340-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 0OygGi8q3WmVaQkAu9opvQ
	(envelope-from <live-patching+bounces-2340-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Mon, 13 Apr 2026 19:38:55 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 0126B3F1948
	for <lists+live-patching@lfdr.de>; Mon, 13 Apr 2026 19:38:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id EC21130D6507
	for <lists+live-patching@lfdr.de>; Mon, 13 Apr 2026 17:27:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8802A35F167;
	Mon, 13 Apr 2026 17:26:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="e12BehCn"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBD1335CB87
	for <live-patching@vger.kernel.org>; Mon, 13 Apr 2026 17:26:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776101193; cv=none; b=ECXFDMFUIHe9hM57jzn2OCgAk1WdWRSfN5eHODn1FV7eM214L0pY0vNKcfVwqCp6KaqVltaqJphN3hA/n2p7nPZj5eLrw39rQyf9Vx2ceDLZFQk9E5hp8LWyPP0KK6Y4hJtKMKvhOto72oKjpkp4jZ5+NC+yO5893VC1Q7YT4MA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776101193; c=relaxed/simple;
	bh=m8oJEkUhz0J3w0JnIvC2DIbk+EyHDWrxfKUyFDm6LMU=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=OwPQoE0kZFU4pv8UN7ITiWwVFUK2tf+5RzcXjU3Y7ut2Qy5VUJM7Uv/TWW0dqNx+VvxCRtti7PDVvLxfraMvvO+lfnqS0CfRLQuXOCvi3hTu28Yvw4tvNHrCW8Gd9Ez2+MGtw5L/iHA29zkfI7MDvs59C8cEBHwYkYaPIKW2O+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=e12BehCn; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-488aa77a06eso79184265e9.0
        for <live-patching@vger.kernel.org>; Mon, 13 Apr 2026 10:26:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1776101190; x=1776705990; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JgiVkg9WGgr3F/ZbVGibYK5V16DNFcA2b+vbpj5Bubk=;
        b=e12BehCngtdmSwGPZg9lXSh6leAANYtBv6xxMepu/vWJd4q5+7htzLos/F166qsGnl
         fldnga2GrylaM6UZ9cBQeBAH70QmyRgMxJAv/PfNNJdc/uQ/7CMfdzh74cjwksieAy0b
         CxAfZUgGKPvt04vLIVqT8LuG0Id+HDFaKVj86wvkJnuAo1PkFNWTS4/vplU9pvoV28xM
         4Ui2xoObkGfMcVV/pGo5XaTRDmxlHFhj3/HaIce277AAYgdcQpLVRJg05mAB1rks3oBn
         OfMByVvlNC3+KA9PgaBIYbzOPS0a+GbQ7HxdHfs/k9+6G5Yj2rDFM85x9IhRsKkzr0Yz
         /6gA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776101190; x=1776705990;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=JgiVkg9WGgr3F/ZbVGibYK5V16DNFcA2b+vbpj5Bubk=;
        b=q6Tcv31NOHSktM8CVTbo5oB7/4Nkn+5O9Znn74IahqoCvicjy21RBHBN/6T/pXNCHI
         k7ICwEKRj7+1u217cuhf1YQz6RnX2SgYQTv0gtJfHNNuOOn/2Y1f75rNAazuspYEMwAF
         TNjljyiovC/BE8rpPKiCkXKk5oCsTSqxKnGsMfb3bpnvzC5rEuMM05ibXVBXEh5YF+em
         evBbyt9LsBNU94ku+HJtLFMOKLyreMHCHU35ETHjH90AGOiXna2BL9q6IKTMjOt5vFqw
         ScZ+V9YTumqAQoliFI4gmcaj4Cv61FfoaBsDOrMMy8Nss8Xz7KBRehtv7o3cCQfbpPje
         i3DQ==
X-Gm-Message-State: AOJu0Ywt5kgbQR8LwO+10ilW8BYPV9UQ5ib8reHYxAwNOD1jDQOe/TxJ
	akJx3KxQhCHPoxKIjMYw/M9XbHNECJTmrpgQkxeeYyu4U40d6S/5Ry1sqRVoky35CA8=
X-Gm-Gg: AeBDiet+FxeYeQxc0jVHz56IeMT91AOasCjZDuE72ejGggrYWEHHTnsx4RO3T1mjMdi
	0RzW6jwBw2QLlWLGmsy/dmmx/Q153pzPayOXRtmjDK8llX6Uz7gL1CuGj0qK4VlHUn7dTUZsbw3
	19QxY35iwUk7PaMv1slWF1YN0lgbC+lirkLZQGOFqyTauTrOsKNzg031+ikIcs2nQlscv8XVyxr
	BWjRDhHjA7d1qbohAKdWzQuH+lOz+I1QFXkYO/+Hf1DtgDjCtlCDrPy5ZTxZxVmB48I1RQhNnnL
	4cCK9iV18a8ERqDn2EHp+OGd3b6Cm3xNNx+VIMQIt2HuIEuPj+Gv/SILvM1niLDIwQ+hsjpeitb
	dSHIJib+WVGNN5fJkk3P5k57Ml70pYGBWqFH7X313LuInSF+rp/e41OxZbrytrD0sKsVa4pIot1
	vVFuOjiv7nAEzn6XuHybeSDUhDFmVCd5Xc3w==
X-Received: by 2002:a05:600c:3ba1:b0:488:90ac:8f71 with SMTP id 5b1f17b1804b1-488d67c704amr205896245e9.5.1776101190311;
        Mon, 13 Apr 2026 10:26:30 -0700 (PDT)
Received: from [127.0.0.1] ([2804:1bc4:224:7800:585c:db3a:fcb:e21f])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-488d5734a94sm298657835e9.0.2026.04.13.10.26.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Apr 2026 10:26:30 -0700 (PDT)
From: Marcos Paulo de Souza <mpdesouza@suse.com>
Date: Mon, 13 Apr 2026 14:26:14 -0300
Subject: [PATCH v2 3/6] selftests: livepatch: Introduce does_sysfs_exists
 function
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260413-lp-tests-old-fixes-v2-3-367c7cb5006f@suse.com>
References: <20260413-lp-tests-old-fixes-v2-0-367c7cb5006f@suse.com>
In-Reply-To: <20260413-lp-tests-old-fixes-v2-0-367c7cb5006f@suse.com>
To: Josh Poimboeuf <jpoimboe@kernel.org>, Jiri Kosina <jikos@kernel.org>, 
 Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>, 
 Joe Lawrence <joe.lawrence@redhat.com>, Shuah Khan <shuah@kernel.org>
Cc: live-patching@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Marcos Paulo de Souza <mpdesouza@suse.com>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1776101176; l=1081;
 i=mpdesouza@suse.com; s=20231031; h=from:subject:message-id;
 bh=m8oJEkUhz0J3w0JnIvC2DIbk+EyHDWrxfKUyFDm6LMU=;
 b=E93oe1YNo+RSYupe5HX5Y5o4BZx0ByITywWIL0YtM5glH0NYRv3YYBExa+tGYCGnkgWIAUF/M
 kQwUY0KIZg3Bm1wyJkF46y7IN2sfWAMjLZ5bdxX85rgQ8Chnwy1dxX5
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
	TAGGED_FROM(0.00)[bounces-2340-lists,live-patching=lfdr.de];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:dkim,suse.com:email,suse.com:mid,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 0126B3F1948
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Return 1 if the livepatch sysfs attribute exists, and 0 otherwise. This
new function will be used in the next patches.

Signed-off-by: Marcos Paulo de Souza <mpdesouza@suse.com>
---
 tools/testing/selftests/livepatch/functions.sh | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/tools/testing/selftests/livepatch/functions.sh b/tools/testing/selftests/livepatch/functions.sh
index 8ec0cb64ad94..382596eaaf01 100644
--- a/tools/testing/selftests/livepatch/functions.sh
+++ b/tools/testing/selftests/livepatch/functions.sh
@@ -339,6 +339,16 @@ function check_result {
 	fi
 }
 
+# does_sysfs_exists(modname, attr) - check sysfs attribute existence
+#	modname - livepatch module creating the sysfs interface
+#	attr - attribute name to be checked
+function does_sysfs_exists() {
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
2.52.0


