Return-Path: <live-patching+bounces-368-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 578A5916CB1
	for <lists+live-patching@lfdr.de>; Tue, 25 Jun 2024 17:20:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0E8502880FD
	for <lists+live-patching@lfdr.de>; Tue, 25 Jun 2024 15:20:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 02F8D1779BD;
	Tue, 25 Jun 2024 15:12:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="M9Y8BaqR"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CA87170851
	for <live-patching@vger.kernel.org>; Tue, 25 Jun 2024 15:12:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719328328; cv=none; b=NO9Rm7E0/qDix25tWAusItFsTryX8m1Wn7H7XpYgcq0C0yJblgF23fWJsnYwB9hdvgi+PGViJ2CYaUzIAedNpxLeezv/0eCsqQ5/w//pok14xnvO1FR6VSteE3h6+qeGMs7LQq9xLkAyk8e4AcTS3epTRSoAJWaxiz5ffsran6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719328328; c=relaxed/simple;
	bh=5nIA7JB0PIWfnae6CC5H9PvOXJHr0l8vRInQGg0G3lo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=c02NyZMwAN270DuaKVOaJHizATts/XIJ5n4XHhmG4fCbExcAtTsOVrGd+AbDAxNDW5KicbI+Rx0Dr70ubLeJ2h65rdv7Fmm7pfNEAJIoIDPMHCIVdT780gwLKo+Bk4aYcLpy1UdnjHqUR15s6z/lTjU+ian4zYHLe/QDCdQ1X38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=M9Y8BaqR; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-1f9fb3ca81bso23678485ad.3
        for <live-patching@vger.kernel.org>; Tue, 25 Jun 2024 08:12:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1719328327; x=1719933127; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3VlV8/K880m9uYq0om3GIWRlMUZPSBalA3y3hwmFbXQ=;
        b=M9Y8BaqRGZgPs3Yu0e4uhyPxwksT5kktVTBBKvO1hPVRG4u0yordK63WLwPixSV7qG
         ka/BXu6GPKjkYMevmLlAvmZ5F1B56obShHu/KHl1Kbw0p/jOq2LNEQz/fkJEVsXoFyEz
         GjcJiS089RcUqrgoCkgqigWFEfUlCvIhzenzOsiAYoKzdc/5EUFrUfDXhgk3qW08+XAu
         gCmVOmWo9IPbxO0NrnGghd2ANQmTtE59Yz1TFOSITn0tJsgrInR5mLaoe+g7FZF6MHlr
         T1dymCB2sAKG+SCwH9fk4XpAE+AMbk6l2mPzxSFzXh8wax5S2XBnnH3LpuFfVIVJsh1k
         h+Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719328327; x=1719933127;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3VlV8/K880m9uYq0om3GIWRlMUZPSBalA3y3hwmFbXQ=;
        b=w5nwzxUvixUlTSJrnzcZEqUybvxw5nfm1mT4OtsHEFwuPps7VuD6g/3/rY9TQWtVtY
         +rkf2IbhnMSo4czXHuqV+tgnpMhoE8trKBmVytR1i9xVhQmWfTPySJY5Qzi/4wzNxoiN
         K9qGY1JyI9Jt9M7yYKWp2m3RBG7/HHEVgQfeduqna1mB4XKqrpTSGkDJ2c1B4T258PzA
         XaTjSbxKCNs9SGntdaQzi3B6e4Hx0B/KLk3Qy0xQjY1njW5TG/HP6TZi6OUUScA2boJo
         qOeUYYiPNY8b1HfmLMow7S7h5f0rYr+uh6vvNTdRyWY7UGHuoPhK5/OmDUGksYcyk931
         mLNw==
X-Gm-Message-State: AOJu0YynSLKncDjf2UPDG7V/mvD+LG7EBdYVw0WrOevkIhbIH5wHedGt
	HsM0uzER7mpZu6+Sujf/GW1ciHvBmcEc37wg+daWYi5molyfi6w5
X-Google-Smtp-Source: AGHT+IE6dH8qU7u7zfrKwyZtSEeQrsvA6CgTgUhCWPMmdYeVqbORDftJhfwfJx8S7aYe4RUsKgroOw==
X-Received: by 2002:a17:902:f685:b0:1fa:1edc:8fcc with SMTP id d9443c01a7336-1fa240e6c86mr81487225ad.54.1719328326561;
        Tue, 25 Jun 2024 08:12:06 -0700 (PDT)
Received: from localhost.localdomain ([183.193.176.237])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1f9eb323636sm82008935ad.102.2024.06.25.08.12.03
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 25 Jun 2024 08:12:06 -0700 (PDT)
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
Subject: [PATCH v3 1/3] livepatch: Add "replace" sysfs attribute
Date: Tue, 25 Jun 2024 23:11:21 +0800
Message-Id: <20240625151123.2750-2-laoar.shao@gmail.com>
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

There are situations when it might make sense to combine livepatches
with and without the atomic replace on the same system. For example,
the livepatch without the atomic replace might provide a hotfix
or extra tuning.

Managing livepatches on such systems might be challenging. And the
information which of the installed livepatches do not use the atomic
replace would be useful.

Add new sysfs interface 'replace'. It works as follows:

   $ cat /sys/kernel/livepatch/livepatch-non_replace/replace
   0

   $ cat /sys/kernel/livepatch/livepatch-replace/replace
   1

[ commit log improved by Petr ]

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
Reviewed-by: Petr Mladek <pmladek@suse.com>
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


