Return-Path: <live-patching+bounces-343-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BCA9B901941
	for <lists+live-patching@lfdr.de>; Mon, 10 Jun 2024 03:34:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6C5B42817FE
	for <lists+live-patching@lfdr.de>; Mon, 10 Jun 2024 01:34:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 38B7E628;
	Mon, 10 Jun 2024 01:34:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="G6BZZatr"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA1DA1879
	for <live-patching@vger.kernel.org>; Mon, 10 Jun 2024 01:34:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717983242; cv=none; b=f9sAWEKrz4DhOGW1QQa7yHHEk2k8+PStZB3RZk14OzJD5TUFLlIGpRIaz6NeeovTKMPymCU5XoQLR7zUJODwWjO7xi3xnkOLhrd7eTgSp0rsu4yXD0fGBFegAOqHdG5k39Fer8oBQ2bHzK7SZB0/v5e9NqNDPcOaZfeXA0hUAnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717983242; c=relaxed/simple;
	bh=wP6qVHWnC3eAhRw38TTVZxLML40yxP7nkX2UWb5uZfs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=tOhIJkcsXyKCqVL1DcKWuy2X1iRRFhI0XOQsNBwC5hY7lJbuWN2ZtQCk/KKlZvGrYeOWbgW7aX34uf/DKk2Qbx1Hb8dMKXAvPgmDYm2VKDPmSnNaBK0ViOgtRwq09xUnVqK7AGjqBn/wMTMl54JuNsh3MUvOHIlScP0mgwXD5Ko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=G6BZZatr; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-1f700e4cb92so7070595ad.2
        for <live-patching@vger.kernel.org>; Sun, 09 Jun 2024 18:34:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1717983240; x=1718588040; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/0N0YKxhtz8ECEyplgrntOzCAWjTrnbU3B5/UmBBLfw=;
        b=G6BZZatrlb0nmNupKH1nV96liEk0yd6A5Y2HxeRxddp2paxvBsA4M1KXTIndCA9nzj
         UykEe+kS8qi13IsEPap0ziwELjvXivNHs4CKyKgSE9YGm+F/oD/JGcjSvexMcOkbmt+Q
         i2N2wUw8jC4uI5mrqJH7GSIaAYFeN/w/uJo7LFBgwH/wAo1s2gEKSOal7JSSCeKaQt79
         ElcbfJMZI6OMuwwya+keTNe9yNuHcqtdBCIUDVNgzAZ0J0foi+gTzOnxuGWH/NgFGwqK
         T2EH3/SPZnGANA2+yRICRxZZywHtUZPP6rVKGHnEo6UjUut6SvUibCJOEs28OMRQLq+R
         EhJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717983240; x=1718588040;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/0N0YKxhtz8ECEyplgrntOzCAWjTrnbU3B5/UmBBLfw=;
        b=XzfZi0oWUj0K+Nlbh72f+GNwKw+UIX5uCrJsQtkgRl6hd/fHrUzACzNCMjivP56+UM
         etHd45F7YPEAmdmRQAfmR4OKNupk1we7Jy1gfOqTstIK0uKBuXgrk/1fBSmiMhOsDJ0g
         /RUsQMc+SxEfqXNCQ45m2CsuipAcv6kFUlwkEXA8UuH3zKiixtEYQX66AERgbX/KmAwU
         tpQXFNOR7jwOvl4h1xctVyqeZ6VWGehYK+lE0FpzYedKIInAy4GuFft2iH1TzSL8Bc0N
         b/fEZPhcQ/2pyOkpsYLtJyHuxN3pXTsq5bTit9IsMP/bYr+Wjieg3b7X1jd/LJaBtevm
         4oJg==
X-Gm-Message-State: AOJu0YzKaoWkQeW78yf7xCDvsinGHCptnuULn8JyhA6VNZvghD6Tzig0
	eVbu6nE5/eR4y0Hetb7nX1Ku8E1OkOS6a5wox0CxGFCjdQO7vANk
X-Google-Smtp-Source: AGHT+IGNupQQrmWQ+QeMsGzMIFFzWvy176bqerZiJ/c0gfBvh2WQXfV+icqfiUYyckAmPTu5SwWO3g==
X-Received: by 2002:a17:902:cecd:b0:1f7:18f4:8114 with SMTP id d9443c01a7336-1f718f4839fmr13080745ad.35.1717983240084;
        Sun, 09 Jun 2024 18:34:00 -0700 (PDT)
Received: from 192.168.124.8 ([125.121.34.85])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1f6bd7fd9b4sm71326555ad.281.2024.06.09.18.33.55
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 09 Jun 2024 18:33:59 -0700 (PDT)
From: Yafang Shao <laoar.shao@gmail.com>
To: jpoimboe@kernel.org,
	jikos@kernel.org,
	mbenes@suse.cz,
	pmladek@suse.com,
	joe.lawrence@redhat.com
Cc: live-patching@vger.kernel.org,
	Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH v2 1/3] livepatch: Add "replace" sysfs attribute
Date: Mon, 10 Jun 2024 09:32:35 +0800
Message-Id: <20240610013237.92646-2-laoar.shao@gmail.com>
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

When building a livepatch, a user can set it to be either an atomic replace
livepatch or a non atomic replace livepatch. However, it is not easy to
identify whether a livepatch is atomic replace or not until it actually
replaces some old livepatches. It will be beneficial to show it directly.

A new sysfs interface called 'replace' is introduced in this patch. The
result after this change is as follows:

  $ cat /sys/kernel/livepatch/livepatch-non_replace/replace
  0

  $ cat /sys/kernel/livepatch/livepatch-replace/replace
  1

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
---
 Documentation/ABI/testing/sysfs-kernel-livepatch |  8 ++++++++
 kernel/livepatch/core.c                          | 12 ++++++++++++
 2 files changed, 20 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-kernel-livepatch b/Documentation/ABI/testing/sysfs-kernel-livepatch
index a5df9b4910dc..3735d868013d 100644
--- a/Documentation/ABI/testing/sysfs-kernel-livepatch
+++ b/Documentation/ABI/testing/sysfs-kernel-livepatch
@@ -47,6 +47,14 @@ Description:
 		disabled when the feature is used. See
 		Documentation/livepatch/livepatch.rst for more information.
 
+What:		/sys/kernel/livepatch/<patch>/replace
+Date:		Jun 2024
+KernelVersion:	6.11.0
+Contact:	live-patching@vger.kernel.org
+Description:
+		An attribute which indicates whether the patch supports
+		atomic-replace.
+
 What:		/sys/kernel/livepatch/<patch>/<object>
 Date:		Nov 2014
 KernelVersion:	3.19.0
diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
index 52426665eecc..ad28617bfd75 100644
--- a/kernel/livepatch/core.c
+++ b/kernel/livepatch/core.c
@@ -346,6 +346,7 @@ int klp_apply_section_relocs(struct module *pmod, Elf_Shdr *sechdrs,
  * /sys/kernel/livepatch/<patch>/enabled
  * /sys/kernel/livepatch/<patch>/transition
  * /sys/kernel/livepatch/<patch>/force
+ * /sys/kernel/livepatch/<patch>/replace
  * /sys/kernel/livepatch/<patch>/<object>
  * /sys/kernel/livepatch/<patch>/<object>/patched
  * /sys/kernel/livepatch/<patch>/<object>/<function,sympos>
@@ -443,13 +444,24 @@ static ssize_t force_store(struct kobject *kobj, struct kobj_attribute *attr,
 	return count;
 }
 
+static ssize_t replace_show(struct kobject *kobj,
+			    struct kobj_attribute *attr, char *buf)
+{
+	struct klp_patch *patch;
+
+	patch = container_of(kobj, struct klp_patch, kobj);
+	return sysfs_emit(buf, "%d\n", patch->replace);
+}
+
 static struct kobj_attribute enabled_kobj_attr = __ATTR_RW(enabled);
 static struct kobj_attribute transition_kobj_attr = __ATTR_RO(transition);
 static struct kobj_attribute force_kobj_attr = __ATTR_WO(force);
+static struct kobj_attribute replace_kobj_attr = __ATTR_RO(replace);
 static struct attribute *klp_patch_attrs[] = {
 	&enabled_kobj_attr.attr,
 	&transition_kobj_attr.attr,
 	&force_kobj_attr.attr,
+	&replace_kobj_attr.attr,
 	NULL
 };
 ATTRIBUTE_GROUPS(klp_patch);
-- 
2.39.1


