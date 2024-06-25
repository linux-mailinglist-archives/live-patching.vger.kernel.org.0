Return-Path: <live-patching+bounces-370-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3BA73916CB3
	for <lists+live-patching@lfdr.de>; Tue, 25 Jun 2024 17:20:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EC10528376E
	for <lists+live-patching@lfdr.de>; Tue, 25 Jun 2024 15:20:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 26BCE170851;
	Tue, 25 Jun 2024 15:12:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SrJ2mn8u"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B61C4178396
	for <live-patching@vger.kernel.org>; Tue, 25 Jun 2024 15:12:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719328335; cv=none; b=pOcNDOzpLR5T/Cci4nBBXgznw/XdVDWwvy1/AkdTDTLZo3vLj5E3W8eMT19gfaT41tvwDDQ7wvRwnZrFXz8uaYSeKxZ6sJ+krpFT9jE6atVXAbz80LtVxlbrVaxfWa48Q7sW+dK0GdZFvmy+96CTYSpfmG8w88joUCalTPedMmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719328335; c=relaxed/simple;
	bh=OaTNjlYOqfIGlpmobbgjepmmCo8OOC7jP2Icfr07G0g=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=cgp3z08nrWRS/NFebYEyZqthdGntZg6flIEV1A7JVB9XErKjx4PxhUv4o4Lg7Jp34QWFsH4nhUZwXd7pOg1ft9gAoGnTpywz28j9y4G9dYFC0muXMgAGshV3zEDJFLRmh1k3egIAIu5tJJRIrWTMddaPln2/ei0/QancrUDci00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SrJ2mn8u; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-1fa55dbf2e7so15014045ad.2
        for <live-patching@vger.kernel.org>; Tue, 25 Jun 2024 08:12:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1719328333; x=1719933133; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ubpjecIdjLqG6977Xx6r9Pw+Nsm9dOvGdl9eOAibqLY=;
        b=SrJ2mn8ufnzh6pcl2qKCherNjD0EPXwHRpk7Og+v/nrlBBsTEiU84a//AN8dJUvE7o
         RIw8IU9B9Wm9178Dk/ku0PS9mgb45qf+9OaA6OuVq0Nn85tHcC8b4Ly+od+1UAmeGvsJ
         lI6rFqFVeksDINaxkkDxDGU96/x9Qkn/NdOPKUMF067MxXk7dXXWOaIEdf/TBgRYedyd
         PbchqOw84/+U3oOQNi0fvgtTcdQz+eOrVfQsTk3zkY9o6AGMydijdTJMWY5E3LKu2h6J
         7ZvOjk/4NorjPyRiLhE+Ao6Ub3qv5wxMzhWDxTInHXcaH7AhMXBVCpKM+rTUke+7T/tD
         +Gzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719328333; x=1719933133;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ubpjecIdjLqG6977Xx6r9Pw+Nsm9dOvGdl9eOAibqLY=;
        b=n1cn/XloZZbXduGTHJkGmqpNTL9Nq29xoHGi7NkeWWF+mCdAnkgntOfJS0YGqeDv/B
         OSIsdK0WWYBk3oWm4J+v3Cg4nVOWD5mrefySONhX9XlR/yzA8Sv/18a1/Cvn5HYQ8O5t
         +yNn6CbB0LzjlJXL6hPObpe5pzvy52oginQPE+uvkgufz8ej4UJ8/X6czU7poLeIaqiE
         pY1mkHw6PQ+Bipc1fveQ7UeXUudXbL1Ah014UEaG+XVckXLe4GFkVpWY9RHvHwzoWk06
         CloB3bJACBGJOPqj2Mo8453JRIDMxkg/Aow6CUW02brMygpGKOCxLKtySPk0yukQRB9G
         CXxA==
X-Gm-Message-State: AOJu0YxyfFWI5A09dVda7Kyeb/+eKK9IdUdfXcpzqr4P9J3PmnwSmNeG
	Y8XH39sIYpjmi0WEIch/ULxerbN3Dskv6eLp+8b+O7MMv7tknIl/
X-Google-Smtp-Source: AGHT+IFF+CDHMAZzE+q7xH6ebSnDKkUcW4JXpT7/gg+Emt+HN60khEdP5q1L9iDziP7y4vQm4vtDUw==
X-Received: by 2002:a17:902:d48a:b0:1f7:c33:aaa5 with SMTP id d9443c01a7336-1fa158d0d05mr94027735ad.10.1719328332852;
        Tue, 25 Jun 2024 08:12:12 -0700 (PDT)
Received: from localhost.localdomain ([183.193.176.237])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1f9eb323636sm82008935ad.102.2024.06.25.08.12.10
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 25 Jun 2024 08:12:12 -0700 (PDT)
From: Yafang Shao <laoar.shao@gmail.com>
To: jpoimboe@kernel.org,
	jikos@kernel.org,
	mbenes@suse.cz,
	pmladek@suse.com,
	joe.lawrence@redhat.com,
	song@kernel.org,
	mpdesouza@suse.com
Cc: live-patching@vger.kernel.org,
	Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH v3 3/3] livepatch: Replace snprintf() with sysfs_emit()
Date: Tue, 25 Jun 2024 23:11:23 +0800
Message-Id: <20240625151123.2750-4-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
In-Reply-To: <20240625151123.2750-1-laoar.shao@gmail.com>
References: <20240625151123.2750-1-laoar.shao@gmail.com>
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
Reviewed-by: Petr Mladek <pmladek@suse.com>
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


