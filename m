Return-Path: <live-patching+bounces-330-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 135448FFC8C
	for <lists+live-patching@lfdr.de>; Fri,  7 Jun 2024 09:02:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9D7781C250B6
	for <lists+live-patching@lfdr.de>; Fri,  7 Jun 2024 07:02:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A67F380600;
	Fri,  7 Jun 2024 07:02:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MpjcuMUg"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CDA51095B
	for <live-patching@vger.kernel.org>; Fri,  7 Jun 2024 07:02:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717743728; cv=none; b=gN35u447XyuJahc2AYTMS/z2CN93KgVbtadmbzXHwScOHpzVm1vwn9gkMdtGpFjdzbRKigY3Kmo+h5Yod0UVy/FR7Nsgb88II3X+WdOPdncnHtB1HqxlbqRv9BIudXCfbkS+Qg8DG7usrPURMooS4VqJ6Fe8d5YiVPY9Whp2IAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717743728; c=relaxed/simple;
	bh=jg7JLaTh4CsAbv2pBV56pGeYtL0K2mhzUn8+cFjm1Ww=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=knirQ49OHIRd3ikBWJxKvHNikSLgbS78riU8ifxqiTotGepgrwHZQ7TugsiD9luz+AbcVVLjXAcXjPe+FVQSVHi9+Gu9mRs3GV2UseOXtgmCsC6fmjWOz0qCVgAtOw09Up4qu6OBNk/MtHzHngoArtrbFpUT1SmRi+90N3MgkRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MpjcuMUg; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-70413de08c7so157785b3a.0
        for <live-patching@vger.kernel.org>; Fri, 07 Jun 2024 00:02:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1717743726; x=1718348526; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=0ZGuYkiUkbI3m8PYrbJDYaedayOKhjMTcdEfvxG/gpQ=;
        b=MpjcuMUgrGvKtei0aXpRnEF2X72NsKk3ttqyeyzhm3yjR3lobtlpZnkJVSXJOv+S5y
         qmYaq+h1MGGh6VqS6zz4d5XhHoI70II79Wt9VuRY8XNmjwlwkulLZHyMgAtEJhBECTXm
         ZfO7Hcvwz1HBcDnybue8kBjav5LHwEf93xUXBr6HqTrSIqjYGR66f2KS+HHRsSZZ2KcI
         LZhab/hSh9k9LRqkQGNP5fNL6t/sfwXx9inWYfBBKbriQnX2HZIsjtMWRNxG9sBu92Pu
         zuZorYwkbIn8Sl5JqR8/0ayAytTshFwzCsjLD5QUiDD9GtDOBmw++AUSpwx0MIkPgi+I
         kWmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717743726; x=1718348526;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0ZGuYkiUkbI3m8PYrbJDYaedayOKhjMTcdEfvxG/gpQ=;
        b=QSqNp8xizQoZipJwWaETTQJbCxO1uVsI1omudXfJKvGx2tQmRQNIAbwFWX2WJA7JGB
         lAqHUc1f6U0L+gszsSYEkgYK4Gm4yBakCSIWe63MumLb91/Zw7ImKGOqVJvuEwQmHEOn
         A8SU5iGJ+oYhky3p1+vq73KKWmGfKYsDlIkJm53zyebBBE8KJIdUcdUyBBLdBvTugc9D
         A2O5D5LTjxsoi0ody44dTbwzFn26PhFwgbBinhkE1KXxYi/1LSApeh5lqLehqgcCePDp
         RKskhKKniN9RabzXUMrmdi+mao+jjtlJ9Xn4GdnCc+TnadQyc9/EN+KncyWLMkIlc/yb
         MAkw==
X-Gm-Message-State: AOJu0YzzVhWB/WBaRPTmL4o4ibh9HmahD0u2aBezWLFSY4Us0WjU9iqd
	OGPkgCczjI+h+du3a+rBSJirumkJGwiDAQM0Y3Zm36oMbVTwteDe8fe9+9fR
X-Google-Smtp-Source: AGHT+IE4q2zq+53oJNNiiXP4Oahm//fjN4fgezZv1G1ulPYVzwE93BCBIGrgBzQQlpimt19oDtNxMg==
X-Received: by 2002:a05:6a20:4328:b0:1af:d1f0:b34e with SMTP id adf61e73a8af0-1b2f969ed0amr1928301637.7.1717743726436;
        Fri, 07 Jun 2024 00:02:06 -0700 (PDT)
Received: from localhost.localdomain ([39.144.104.9])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-703fd53438esm2015881b3a.220.2024.06.07.00.02.02
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 07 Jun 2024 00:02:05 -0700 (PDT)
From: Yafang Shao <laoar.shao@gmail.com>
To: jpoimboe@kernel.org,
	jikos@kernel.org,
	mbenes@suse.cz,
	pmladek@suse.com,
	joe.lawrence@redhat.com
Cc: live-patching@vger.kernel.org,
	Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH] livepatch: Add a new sysfs interface replace
Date: Fri,  7 Jun 2024 15:01:57 +0800
Message-Id: <20240607070157.33828-1-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When building a livepatch, a user can set it to be either an atomic-replace
livepatch or a non-atomic-replace livepatch. However, it is not easy to
identify whether a livepatch is atomic-replace or not until it actually
replaces some old livepatches. This can lead to mistakes in a mixed
atomic-replace and non-atomic-replace environment, especially when
transitioning all livepatches from non-atomic-replace to atomic-replace in
a large fleet of servers.

To address this issue, a new sysfs interface called 'replace' is introduced
in this patch. The result after this change is as follows:

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
index 52426665eecc..0e9832f146f1 100644
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
+	return snprintf(buf, PAGE_SIZE-1, "%d\n", patch->replace);
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


