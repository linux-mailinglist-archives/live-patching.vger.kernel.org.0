Return-Path: <live-patching+bounces-756-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BE0E29ADB13
	for <lists+live-patching@lfdr.de>; Thu, 24 Oct 2024 06:43:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7A3DC283631
	for <lists+live-patching@lfdr.de>; Thu, 24 Oct 2024 04:43:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 99669167271;
	Thu, 24 Oct 2024 04:43:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kGmXRule"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96A69A932;
	Thu, 24 Oct 2024 04:43:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729745017; cv=none; b=rTPRZJgJTuOO6w+JkeQjkzDBl0a0CmxUTOXJKZdtY05DsRXnpCus9G4ptZXtO05IHEIylqKMOSfFCuJcWUssLCPYjLqp18FtRmikbSnFCH1PukohG1k7COjmkdDgOPK1cxuBTuidCTv1YJ0S0euEWqR/hHFiXZsjSa7Ual8i8A8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729745017; c=relaxed/simple;
	bh=dsvj2frVr6MGiwtWhTRMsRmO1BwMNYYun3RBtTY467Q=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=BfXMlaJgWXjomFc7416wUyY/YQg57dhv2WcW//pye/PwX7bKPsuEMBd7GXoLrhqGvDy4egy3lHFAhcdX+c7TZRtmK+jJCmcNuw1zvJkcYXZXM0C7ePOl9PXLd3jXSiuUd/cojqK+Ve/B6UzN6jKzPMdum8E0SPm5bXJ9m3Ta7Nw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kGmXRule; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-20cb89a4e4cso3125055ad.3;
        Wed, 23 Oct 2024 21:43:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729745015; x=1730349815; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=hsdZK56BEuQGs9pXkV5YDLxOr/kjcEbLorwgkGs7QDg=;
        b=kGmXRulezCuf/I1PDbLOWyBYN7hV5BYkHnsnmayp3kmRvZElQPRGaBZ1konY9t8kcm
         8Y1u8gXBj2+0eV2M626/9Jk236GtK5JW7AlZmFyPfhE9yrYscStXC5g4n+uRVk/WAiOF
         in77PSAsJiWp8VZF/Cx1KUe32eNx8fKCsJqR/bVVVBl+norBdxS4gFji1zkkS8iAKgst
         mnvjwoaR7vTQAMnv0QDrPutmKG9AfvPYZSuLI+y6CnuC145zMLSBGWYnFJgkzwMPFDsR
         QleNoUOmRPsHZnJhCYqWeZw7wEERdh4p0pZD1zzKJgUGZ3Jt5bZkJJKKWQTZkZ0CGMOm
         xtBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729745015; x=1730349815;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hsdZK56BEuQGs9pXkV5YDLxOr/kjcEbLorwgkGs7QDg=;
        b=rSPiTo9i+9BBZp0tsCDLacPk/jFXEmrlh7yliGAuT6UBnjeKLG2/Xo6fCvp6KcVufp
         4lleX1tTKjHOsCYI9up1wyfkwfTLqe0a9u9fTzzMJC473C4Utf1GpkbD4wnfU/0F1Cz6
         m2HzRXQYCQjG1hOqL5Snu3vPshIm8t3dNk0ykXz4peXiwc8xm4hp/T0Z1AuoWLctojAp
         F2k1Ej4K1syYFUamHyqkXM+Do+Om86ATlPNGvhga/9gTGJqv48zZqZtj7NUxSZpJZCHH
         o9F9Q4lII0OLUYC6qdCYnh+QgLBLOnym0j/vN/r9pMXnRr/oA1zHGhijyMeP0VWsq+cF
         p+iw==
X-Forwarded-Encrypted: i=1; AJvYcCU0CIQ7XR+puY3m2ThcOY7TSnfP3Fjel5wDibTMKKgAlgSUVoEH/Qav90KleEieNhBlmTBoNX5Xb1CP6VM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzvob9/vavKOZQ4FiOT4JC6MpzP3ZLuJqdb+uaK3FVQN71FsoTP
	cpNnjcuYjTwk73CYvDi6BSch+s/LeJQMbrXc8uR7Zw6i/tnRCpJU
X-Google-Smtp-Source: AGHT+IFhd1LVeCpI98B+kq66fGKIf+51vfR8n7NUeM6sGz6VTcOLtZWSKoH4tM/jf+26O4u3v5NWlw==
X-Received: by 2002:a17:903:18e:b0:20c:7661:dcbf with SMTP id d9443c01a7336-20fb9b0d10cmr5034345ad.55.1729745014722;
        Wed, 23 Oct 2024 21:43:34 -0700 (PDT)
Received: from localhost.localdomain ([205.204.117.124])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20e7eee63a1sm65582835ad.18.2024.10.23.21.43.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Oct 2024 21:43:34 -0700 (PDT)
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
Date: Thu, 24 Oct 2024 12:43:16 +0800
Message-Id: <20241024044317.46666-1-zhangwarden@gmail.com>
X-Mailer: git-send-email 2.37.3
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


