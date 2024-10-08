Return-Path: <live-patching+bounces-722-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 15B8C993C77
	for <lists+live-patching@lfdr.de>; Tue,  8 Oct 2024 03:49:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 98EB71F23DE7
	for <lists+live-patching@lfdr.de>; Tue,  8 Oct 2024 01:49:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 93E1A1DFD1;
	Tue,  8 Oct 2024 01:49:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XtYczA0j"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AA071CD02;
	Tue,  8 Oct 2024 01:49:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728352147; cv=none; b=eCCbFyLvbEMEV0OxuJ6RoRBx4J9QhEvhv7B39vcPjlHFwuVp0b0xqaNiYUCjlb7xzf4HdE+5HtZ15Fwvas3YonrvLxwYAYwatJ1OQ0vaXNirxp5ET/HESwacDz46aK0WlklXeKOz+B3ZcGqqL7mknFvq63mw+DYBFABGbdSBKpc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728352147; c=relaxed/simple;
	bh=dsvj2frVr6MGiwtWhTRMsRmO1BwMNYYun3RBtTY467Q=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ITNa982x867vY00YiO/3ogZfnZgSGJLoqNXFOYxX+yJx+rGA/AoxTCs2YtByU1F2g15dO+6X1qpXnYLHb3KF+qUZeugKdExElDd3p/QhR9p4uzXh753sYOHM812Q6HgdVVsJW1soGBKURNRSCuEcen6Cy+eGCI8KTLDiZmCbcPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XtYczA0j; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-20b95359440so42955915ad.0;
        Mon, 07 Oct 2024 18:49:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728352145; x=1728956945; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hsdZK56BEuQGs9pXkV5YDLxOr/kjcEbLorwgkGs7QDg=;
        b=XtYczA0juU7zGBq/j9eqV70LOgEaI2dLFSE7kRhD9tHfMOhrF6wxrApA+4gxPVnspT
         dveM7TmRzsQCRM2jJnJnmZafHhb5PaeFRGf1zgp6ofRka/TyHX734jRFQaRD2safOxQ4
         OxBtIy1TdYyH7gQlh0jQdc5HQC+Os0PwGueprL8lL3WY87ReLEPVSGm7Hf3swLiD4D8O
         TYsZHKtNxiA2sE7zlyNRgBTGv5pwP8FOhnJNRpW/51szu7s7X6DSG2Jy7YAkK7C50J4w
         J5BM5/VZQJxb1SCCERUHKLyepyIkym/pPK3ErmNTDq4JzDJEKurXN64apetVZXEBJ0dx
         zzJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728352145; x=1728956945;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hsdZK56BEuQGs9pXkV5YDLxOr/kjcEbLorwgkGs7QDg=;
        b=eMeMUEdSebC42MqBqDKokbh9GlSlidZmEa5yYW0r10zT4w6SgJylypg5sgYPxItZvp
         L+PLf+T7oybvbNBgUUgggjRrrcg+wpWhNo57eYKuHajcAe4uQ1RcruzpbM9bqPmqyBzN
         aHrcpW7IbAq2c7c+iV4NwozAAnW9QAcqxOpvG9zw/oUu++jVVIDBv8JX50aEskVrEe8Y
         Cyb0H67yI2AeK1NF/A0tv5B1mySl7WXWsWzrHJ2OjlPrZNHgxmhq1ubQNEijuZIYgd3o
         /MyS67fJUqPkAPdV1xI1iS2H8k+kGxGsGc+ExSnu7LA//PnBx/Iu7wOCo0X0GqKhKTDg
         1FCQ==
X-Forwarded-Encrypted: i=1; AJvYcCW1fsriefCPnKbZ/J9RY1xOgBKzgmNxCpT3NuvBfaBFjpTWiEfrscjjtIpT2MVKV/oS7Akz42pnM/Qxu58=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx2obpDvDyEpaRc7Z9qHeqLinNKZ/tmrBV1cdGRtfw4kZB7vWRO
	//1s1uDirM/1+b6ZdYlLm2YCp24jfQK1lvtBbiS/NS4YOxS0sH6P
X-Google-Smtp-Source: AGHT+IHMYiTgJbKi8YrF6tRGzx3ZAxR6DUAWDqNCls5ug50C+Y3/E2BW09RC0ptkG7j5zy+G8LB34Q==
X-Received: by 2002:a17:903:244d:b0:20b:8510:bf4d with SMTP id d9443c01a7336-20bfde55570mr249473665ad.6.1728352145310;
        Mon, 07 Oct 2024 18:49:05 -0700 (PDT)
Received: from localhost.localdomain ([205.204.117.123])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20c139891b9sm45755095ad.246.2024.10.07.18.49.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Oct 2024 18:49:04 -0700 (PDT)
From: Wardenjohn <zhangwarden@gmail.com>
To: jpoimboe@kernel.org,
	mbenes@suse.cz,
	jikos@kernel.org,
	pmladek@suse.com,
	joe.lawrence@redhat.com
Cc: live-patching@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Wardenjohn <zhangwarden@gmail.com>
Subject: [PATCH V5 1/1] livepatch: Add stack_order sysfs attribute
Date: Tue,  8 Oct 2024 09:48:56 +0800
Message-Id: <20241008014856.3729-2-zhangwarden@gmail.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20241008014856.3729-1-zhangwarden@gmail.com>
References: <20241008014856.3729-1-zhangwarden@gmail.com>
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
 .../ABI/testing/sysfs-kernel-livepatch        |  9 +++++++
 kernel/livepatch/core.c                       | 24 +++++++++++++++++++
 2 files changed, 33 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-kernel-livepatch b/Documentation/ABI/testing/sysfs-kernel-livepatch
index 3735d868013d..73e40d02345e 100644
--- a/Documentation/ABI/testing/sysfs-kernel-livepatch
+++ b/Documentation/ABI/testing/sysfs-kernel-livepatch
@@ -55,6 +55,15 @@ Description:
 		An attribute which indicates whether the patch supports
 		atomic-replace.
 
+What:		/sys/kernel/livepatch/<patch>/stack_order
+Date:		Oct 2024
+KernelVersion:	6.13.0
+Description:
+		This attribute specifies the sequence in which live patch modules
+		are applied to the system. If multiple live patches modify the same
+		function, the implementation with the biggest 'stack_order' number
+		is used, unless a transition is currently in progress.
+
 What:		/sys/kernel/livepatch/<patch>/<object>
 Date:		Nov 2014
 KernelVersion:	3.19.0
diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
index 3c21c31796db..0cd39954d5a1 100644
--- a/kernel/livepatch/core.c
+++ b/kernel/livepatch/core.c
@@ -347,6 +347,7 @@ int klp_apply_section_relocs(struct module *pmod, Elf_Shdr *sechdrs,
  * /sys/kernel/livepatch/<patch>/transition
  * /sys/kernel/livepatch/<patch>/force
  * /sys/kernel/livepatch/<patch>/replace
+ * /sys/kernel/livepatch/<patch>/stack_order
  * /sys/kernel/livepatch/<patch>/<object>
  * /sys/kernel/livepatch/<patch>/<object>/patched
  * /sys/kernel/livepatch/<patch>/<object>/<function,sympos>
@@ -452,15 +453,38 @@ static ssize_t replace_show(struct kobject *kobj,
 	return sysfs_emit(buf, "%d\n", patch->replace);
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
 static struct kobj_attribute enabled_kobj_attr = __ATTR_RW(enabled);
 static struct kobj_attribute transition_kobj_attr = __ATTR_RO(transition);
 static struct kobj_attribute force_kobj_attr = __ATTR_WO(force);
 static struct kobj_attribute replace_kobj_attr = __ATTR_RO(replace);
+static struct kobj_attribute stack_order_kobj_attr = __ATTR_RO(stack_order);
 static struct attribute *klp_patch_attrs[] = {
 	&enabled_kobj_attr.attr,
 	&transition_kobj_attr.attr,
 	&force_kobj_attr.attr,
 	&replace_kobj_attr.attr,
+	&stack_order_kobj_attr.attr,
 	NULL
 };
 ATTRIBUTE_GROUPS(klp_patch);
-- 
2.18.2


