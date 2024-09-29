Return-Path: <live-patching+bounces-695-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7FB50989609
	for <lists+live-patching@lfdr.de>; Sun, 29 Sep 2024 16:44:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 701AE1C21739
	for <lists+live-patching@lfdr.de>; Sun, 29 Sep 2024 14:44:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B10F417DFF2;
	Sun, 29 Sep 2024 14:44:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KLHbXMnt"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F4AE17DFF1;
	Sun, 29 Sep 2024 14:43:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727621040; cv=none; b=qOZiGmelrUWbgC1aOmsAkPf9zI9ABjHoWI5dGG8RL706WfSWww/lVR16PJu+yLPhJhAb5cR2n5XJnQHutVIcRQmkZvCW6RpQ4fKSpuNj6Odwoqdar7FwEdRAiym0x1XIh1lTe6q1bZFcorOXVPaNPmr8UhUepmzUHI0V21ipWW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727621040; c=relaxed/simple;
	bh=oDy7gy322E2SDkjXYz9VgYEITwey0rq2gA7yo/roo3o=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=W8I194Nk7qg1czjwDU2DZac3cqhHDhIm/ouW/XuQRzeOdj3goRi1iclZkA8IBYuLqPFpvdqv+IKCv/0c1Ikf0mjYt5EZ4+oO+891mAtTVLhU1o7LwQlynxKBNjYYGkdYFODiSVE51uy1ofJqhnzH55jqKcBdAX9JvnLTbR1dR/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KLHbXMnt; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-20afdad26f5so45903435ad.1;
        Sun, 29 Sep 2024 07:43:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727621038; x=1728225838; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sifyMsnT9oKg2GxftZqik5G2CnpnmFS3kqY2rs0rnHk=;
        b=KLHbXMnt0GK0FdkOAq1ARW6j9yax0eEJrVqqBJmUbmELQ8TTyt4B5eISH4jw6FelhL
         1VK6FdkzlUyV+de0NNgE0f5Cv7OPRg9UIav5oN0S+1kKxOxlKBhtvwzYpYAyMDhgPet8
         fYHc+0St0bLz/T0GGTOoFR15RBnVeUFD2KV+Nmt7bvoh2IFHWfyPtESF4PLb3zqvsxeE
         awYUGJYfdHFZrL3j8khgh0RpGUmxHeuG4EplnG9NYH0uy24rh7Df9VsRIBwtttkFdyYO
         FrgM8q8HJfte+aJUWeg144QaDht1L2JsIh+Jm+WnoI6NrzazdmsPCNoaDpq5lh8VyMHC
         i5ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727621038; x=1728225838;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sifyMsnT9oKg2GxftZqik5G2CnpnmFS3kqY2rs0rnHk=;
        b=VMTw3Rp446RqGyCa+Nmc6QvpdsV0/JFVuPYuHOWZyXTUPeKQaytBtr1zBTstUi5x+8
         X2rhzdj94fnEFhVEI5PMGMhg7nko3xOmUaCenZex+u+aO6rrqCP5itZsDIh3h/Vev9pH
         KjDODlk90UU1YWOXFUvYTM9eY+QhfcecBfYLNul9SFhDWTqWOglPkvNdUEdSZHTdJ87i
         T2mesViQDrjxEj70O6O4DuJPjg+bYbAHkXFUUa/KDgbj9Ooi7Efhppz5TTWMZ/7eQ75r
         SbooFjmEUodjXs1GP5YD0xRt4yHoVQ7UX63WD3n5Ksmo63rNGAohpLf1e8R1CSK/mCjt
         OKAg==
X-Forwarded-Encrypted: i=1; AJvYcCXXPUpvkAZNR3luLlMj8UPJp6ClvZT3eXWy2gFDfku64zYhsMJ0sW0ewLV6OM30tLxASJ9cPW+npHUM0nw=@vger.kernel.org
X-Gm-Message-State: AOJu0YxDC4H5DkNaf0FUN2B/VRE63Wzp7qYw7jFb6amO0mQG5EBX71p7
	qfJQVBzwI0UiuNMjQlk+9zEWKBMTO/NN81XndK/sAubnxnRG/Gwi
X-Google-Smtp-Source: AGHT+IETnVUG019ioLfxUlVlZPBXTdm22M3ym+0opRSSeXAFz31ifCHFmUkCnU9xVIuq3PLd7NLjfQ==
X-Received: by 2002:a17:902:e5cd:b0:205:410c:f3b3 with SMTP id d9443c01a7336-20b37bda8d3mr166517885ad.59.1727621038227;
        Sun, 29 Sep 2024 07:43:58 -0700 (PDT)
Received: from localhost.localdomain ([120.229.27.0])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20b37e0d5b9sm40620625ad.174.2024.09.29.07.43.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Sep 2024 07:43:57 -0700 (PDT)
From: Wardenjohn <zhangwarden@gmail.com>
To: jpoimboe@kernel.org,
	mbenes@suse.cz,
	jikos@kernel.org,
	pmladek@suse.com,
	joe.lawrence@redhat.com
Cc: live-patching@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Wardenjohn <zhangwarden@gmail.com>
Subject: [PATCH V3 1/1] livepatch: Add "stack_order" sysfs attribute
Date: Sun, 29 Sep 2024 22:43:34 +0800
Message-Id: <20240929144335.40637-2-zhangwarden@gmail.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20240929144335.40637-1-zhangwarden@gmail.com>
References: <20240929144335.40637-1-zhangwarden@gmail.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add "stack_order" sysfs attribute which holds the order in which a live
patch module was loaded into the system. A user can then determine an
active live patched version of a function.

cat /sys/kernel/livepatch/livepatch_1/stack_order -> 1

means that livepatch_1 is the first live patch applied

cat /sys/kernel/livepatch/livepatch_module/stack_order -> N

means that livepatch_module is the Nth live patch applied

Suggested-by: Petr Mladek <pmladek@suse.com>
Suggested-by: Miroslav Benes <mbenes@suse.cz>
Suggested-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Wardenjohn <zhangwarden@gmail.com>
---
 .../ABI/testing/sysfs-kernel-livepatch        |  8 ++++++
 kernel/livepatch/core.c                       | 25 +++++++++++++++++++
 2 files changed, 33 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-kernel-livepatch b/Documentation/ABI/testing/sysfs-kernel-livepatch
index a5df9b4910dc..2a60b49aa9a5 100644
--- a/Documentation/ABI/testing/sysfs-kernel-livepatch
+++ b/Documentation/ABI/testing/sysfs-kernel-livepatch
@@ -47,6 +47,14 @@ Description:
 		disabled when the feature is used. See
 		Documentation/livepatch/livepatch.rst for more information.
 
+What:           /sys/kernel/livepatch/<patch>/stack_order
+Date:           Sep 2024
+KernelVersion:  6.12.0
+Contact:        live-patching@vger.kernel.org
+Description:
+		This attribute holds the stack order of a livepatch module applied
+		to the running system.
+
 What:		/sys/kernel/livepatch/<patch>/<object>
 Date:		Nov 2014
 KernelVersion:	3.19.0
diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
index ecbc9b6aba3a..30ab3668c59e 100644
--- a/kernel/livepatch/core.c
+++ b/kernel/livepatch/core.c
@@ -346,6 +346,7 @@ int klp_apply_section_relocs(struct module *pmod, Elf_Shdr *sechdrs,
  * /sys/kernel/livepatch/<patch>/enabled
  * /sys/kernel/livepatch/<patch>/transition
  * /sys/kernel/livepatch/<patch>/force
+ * /sys/kernel/livepatch/<patch>/stack_order
  * /sys/kernel/livepatch/<patch>/<object>
  * /sys/kernel/livepatch/<patch>/<object>/patched
  * /sys/kernel/livepatch/<patch>/<object>/<function,sympos>
@@ -443,13 +444,37 @@ static ssize_t force_store(struct kobject *kobj, struct kobj_attribute *attr,
 	return count;
 }
 
+static ssize_t stack_order_show(struct kobject *kobj,
+				struct kobj_attribute *attr, char *buf)
+{
+	struct klp_patch *patch, *this_patch;
+	int stack_order = 0;
+
+	this_patch = container_of(kobj, struct klp_patch, kobj);
+
+	mutex_lock(&klp_mutex);
+
+	klp_for_each_patch(patch) {
+		stack_order++;
+		if (patch == this_patch)
+			break;
+	}
+
+	mutex_unlock(&klp_mutex);
+
+	return sysfs_emit(buf, "%d\n", stack_order);
+}
+
+
 static struct kobj_attribute enabled_kobj_attr = __ATTR_RW(enabled);
 static struct kobj_attribute transition_kobj_attr = __ATTR_RO(transition);
 static struct kobj_attribute force_kobj_attr = __ATTR_WO(force);
+static struct kobj_attribute stack_order_kobj_attr = __ATTR_RO(stack_order);
 static struct attribute *klp_patch_attrs[] = {
 	&enabled_kobj_attr.attr,
 	&transition_kobj_attr.attr,
 	&force_kobj_attr.attr,
+	&stack_order_kobj_attr.attr,
 	NULL
 };
 ATTRIBUTE_GROUPS(klp_patch);
-- 
2.18.2


