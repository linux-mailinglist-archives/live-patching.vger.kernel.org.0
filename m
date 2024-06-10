Return-Path: <live-patching+bounces-345-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 66A15901944
	for <lists+live-patching@lfdr.de>; Mon, 10 Jun 2024 03:34:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 160DF1F21A70
	for <lists+live-patching@lfdr.de>; Mon, 10 Jun 2024 01:34:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3CC6628;
	Mon, 10 Jun 2024 01:34:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Hnxv106b"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52E7F1852
	for <live-patching@vger.kernel.org>; Mon, 10 Jun 2024 01:34:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717983250; cv=none; b=tSDw/RK9MFLZwN9ak81eKEDUsYG/Zr2THJmFs3eap4xYSaHsZ1dqaMW/kBx1lhaUULoUpey1e7/JhA0uqc1fGORgqMgFMH/hTsEu5J+jkyUxtPUdEBKJ3+zT/RUNkEPmPJtQpdDWEb5Q3eI7V5K28GH9YkTWOgBWkaXNM5UfcOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717983250; c=relaxed/simple;
	bh=bdq7gT39CyevTD0xDLykWszeo+5EnVaNEoyG24I2pmE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=u/eUvhXnKbif+kxxdUN7R6DtSNyImNDNlmIEPtzpePD0q3tNGwp17coGwncPEVXLdx7+u4ljP30SJsKjrtKkrnoqqJd2TazoUfwopfk9PJIdLCKKQjB3QS12AFy9hR10zLi/olVDZObmhIZIfuSfGcsw107KaREQ87xj/A2/KEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Hnxv106b; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-1f32a3b9491so27424495ad.0
        for <live-patching@vger.kernel.org>; Sun, 09 Jun 2024 18:34:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1717983249; x=1718588049; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9DrL+IGjsrfkGc6JcdGDjbtWbycIDbaaFkJ3JIRPWPs=;
        b=Hnxv106boTGvteuv1s87yVBr9Jkouc/fw/jgwZYysYrFAcWgZ0UkTaLV/wSpfeTjf2
         aKuhTfNtTPR/f4i4aO2vMivDD7/nh1hAqLj2bz29bW0TsXVmnX/9EOakJz6ZWGDKxatd
         gd05+AnZdXMzogd2xm6DInD9vN0ColX9DIrcnlfahw52pgh2SN44Ecj9FebTcFuDLUBO
         zXCpZJ3msFxlkDi/WhjlxUpLz7Bp8Pkmy6MpKYdIcTRVyxr5BfcIdMibRO0hVAcQzw3a
         nqFp1VJKa1RUzSm4Yktv1fekRckFTmKeVoYlu2SkPjFTb9hOulXEn4//qwfIPE4xyOxz
         6HiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717983249; x=1718588049;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9DrL+IGjsrfkGc6JcdGDjbtWbycIDbaaFkJ3JIRPWPs=;
        b=U2YvtWi4yFPboEhqttPIs6x8z7WAtXsCX/IHeAGoIvEbcMGJA3EYSgLMF40dThvcyY
         DUBqIyegjtTYtcZjLr8uNkI6KkTym/tukkbG+ncaP5P42RI4Q5q5MN2wWefHPJuOvnnR
         mxjBsxe6qSQGhD3IIhzrAi1Jk3QaF7oJnDwlEeZl3IyyGs8iy8h71JN8cNkpzQutD+Fo
         UhbNLlo90ZVl83z5HXNDlLOy7NinO+cNOnfLe06FRpQ3F3j6k8co+cmbBa7yNwF7t9HM
         VDPRj6u0oyM+yNmC+U4SSCxAmgX54SN4epiYc4XhrsS6F0RJWah4+c7DdnpLAkE2qXZh
         SQlA==
X-Gm-Message-State: AOJu0YxSq+9v8OEbdHfLhoZUdJSuZ5aTFxSB2otj7CMZJU1QyoLnOufM
	81lPaagr/8wNDt6VXplC8/P0ZREHxG22U86bH2zZTipA2gpRPz/G
X-Google-Smtp-Source: AGHT+IGBAEdV5ORI4gwzot1/Hx2dFhX7CZrWNC9X4YwLn8NL+PLUHQwNIsRTlRqzmrORpIgNB6GlLw==
X-Received: by 2002:a17:902:f54e:b0:1f6:7f8f:65c7 with SMTP id d9443c01a7336-1f6d02e0c84mr91197485ad.26.1717983248730;
        Sun, 09 Jun 2024 18:34:08 -0700 (PDT)
Received: from 192.168.124.8 ([125.121.34.85])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1f6bd7fd9b4sm71326555ad.281.2024.06.09.18.34.05
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 09 Jun 2024 18:34:08 -0700 (PDT)
From: Yafang Shao <laoar.shao@gmail.com>
To: jpoimboe@kernel.org,
	jikos@kernel.org,
	mbenes@suse.cz,
	pmladek@suse.com,
	joe.lawrence@redhat.com
Cc: live-patching@vger.kernel.org,
	Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH v2 3/3] livepatch: Replace snprintf() with sysfs_emit()
Date: Mon, 10 Jun 2024 09:32:37 +0800
Message-Id: <20240610013237.92646-4-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
In-Reply-To: <20240610013237.92646-1-laoar.shao@gmail.com>
References: <20240610013237.92646-1-laoar.shao@gmail.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Let's use sysfs_emit() instead of snprintf().

Suggested-by: Miroslav Benes <mbenes@suse.cz>
Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
---
 kernel/livepatch/core.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
index ad28617bfd75..3c21c31796db 100644
--- a/kernel/livepatch/core.c
+++ b/kernel/livepatch/core.c
@@ -402,7 +402,7 @@ static ssize_t enabled_show(struct kobject *kobj,
 	struct klp_patch *patch;
 
 	patch = container_of(kobj, struct klp_patch, kobj);
-	return snprintf(buf, PAGE_SIZE-1, "%d\n", patch->enabled);
+	return sysfs_emit(buf, "%d\n", patch->enabled);
 }
 
 static ssize_t transition_show(struct kobject *kobj,
@@ -411,8 +411,7 @@ static ssize_t transition_show(struct kobject *kobj,
 	struct klp_patch *patch;
 
 	patch = container_of(kobj, struct klp_patch, kobj);
-	return snprintf(buf, PAGE_SIZE-1, "%d\n",
-			patch == klp_transition_patch);
+	return sysfs_emit(buf, "%d\n", patch == klp_transition_patch);
 }
 
 static ssize_t force_store(struct kobject *kobj, struct kobj_attribute *attr,
-- 
2.39.1


