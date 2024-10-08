Return-Path: <live-patching+bounces-720-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6DB78993C73
	for <lists+live-patching@lfdr.de>; Tue,  8 Oct 2024 03:47:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 878A4B214D4
	for <lists+live-patching@lfdr.de>; Tue,  8 Oct 2024 01:47:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0EE0D1DA5F;
	Tue,  8 Oct 2024 01:47:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DJImDytc"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 820271CD0C;
	Tue,  8 Oct 2024 01:47:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728352045; cv=none; b=sZz6/DB/MzcvtPhRBUJKqERckKlhZbCU5GF5MV/kO+djOgnK7p+XwHA7jYTpCTfvdIDkzVrCjjSeGO4n2DjTXGGqPz8A/9APQBDv3kma6HI0eJjldxdMfmpGYEMq1G/fAiuQhI30SK6K9jmbs3wYDTmDF1Ub/MViR12hzznJbA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728352045; c=relaxed/simple;
	bh=dsvj2frVr6MGiwtWhTRMsRmO1BwMNYYun3RBtTY467Q=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=vC8rAANJCi2++j9BweQRxSWS5ikFPnJeBhnGCrFSRL2fZgaqBnXYVbeI/iDDHfjvLMeAt/EWNzUMh4BzqXUN1BwlM78qxt6y5was3+zbdlEJaCbOTrFE94huURwBR0quX5dCxDB5qAVClu9yxm/T34xP2UvJYr2Ti5pzgz9QDQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DJImDytc; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-71dfc250001so1583327b3a.2;
        Mon, 07 Oct 2024 18:47:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728352043; x=1728956843; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hsdZK56BEuQGs9pXkV5YDLxOr/kjcEbLorwgkGs7QDg=;
        b=DJImDytcopys66S5TnA/kEXZfZ1fy7Zzw8VV2MrcYd/gxvyY5qPfZ4OHsosYfBMyoB
         DA1AvJ3Z2KFb9ItWvfFQ60EWl8gu6pdfsawRyBlHrJZlYwz0CwKfceEEa24Dbv/hR8xh
         aOyE2oG7m2br/gDN8cDAHh+Zh642Z0P7U1FJuhSuZ1qmqJGPwK3jcsW+c9fWOIuTrNxp
         tutnHCCNgFD6gmwJt07eBGc3aGsf5mHU9gz5y6LmucQLgf+Y2ocrVP393ZLJIHAy3v9U
         Ueb8qNtkcLsAofI9J8uwB4MJ9fLJ6ZuxKCAYzjsGHSc8l7TmN5knmmOSshDdb6WZSOgX
         xWYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728352043; x=1728956843;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hsdZK56BEuQGs9pXkV5YDLxOr/kjcEbLorwgkGs7QDg=;
        b=v6dfef7yUV3jElC4hkpocZ3a8zwNeB3nIh0iGrG596XDetdtocn3ABy1wn8egVcdot
         +RFTGTioagMYTpV92XOVift/UacWfT/Qa/p9omOB+PAL9mRAPmE356d2/r4OhukMXqBG
         kJ0CdSkOYgZPqZ/y2Q18f+OlWJWqhP58mjy/344a8itix0wturljdB+MZYvpR15wSBt6
         eMHiuiPkR6CbSOtHs4joCDLWES6EhBL5w3qbJkSLSWIV80rYaTN9S4zNJXn7PUJP7K3T
         6l10M/g7MAD8bOkk3g+UsXzp0+5n2Xa0SAVCTion4bdlS5WGmJSBr6YCHyBfD8heviYY
         /A4w==
X-Forwarded-Encrypted: i=1; AJvYcCXIMoBy8uZwlb3ldsoDkkKAxFPahTSxNAc9aayO7tRVb50rVG3hceH7QyCDLvqg8DzZ5ftnZRbNWWTndeU=@vger.kernel.org
X-Gm-Message-State: AOJu0YzSvlMwcU/SAZqF/7O3vP93yCs03VAIHSjEdVbhyegN7QpuLl+v
	wZmMrrd9TJdlagzqyeR0sd+Mo/rDP7lrvn7VuOz4jzOb03mCoa+u
X-Google-Smtp-Source: AGHT+IGuHHX5sRH/OaT7vryo8dVawPFqQIgVH67akZQkhIF4Phvmh5OuHSUiCqo0fLXG1lG0DE5yhA==
X-Received: by 2002:a05:6a20:438f:b0:1cf:6c64:ee6b with SMTP id adf61e73a8af0-1d6dfa426damr18828915637.27.1728352042869;
        Mon, 07 Oct 2024 18:47:22 -0700 (PDT)
Received: from localhost.localdomain ([205.204.117.123])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71df0d453bbsm5070235b3a.130.2024.10.07.18.47.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Oct 2024 18:47:22 -0700 (PDT)
From: Wardenjohn <zhangwarden@gmail.com>
To: jpoimboe@kernel.org,
	mbenes@suse.cz,
	jikos@kernel.org,
	pmladek@suse.com,
	joe.lawrence@redhat.com
Cc: live-patching@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Wardenjohn <zhangwarden@gmail.com>
Subject: [PATCH V4 1/1] livepatch: Add stack_order sysfs attribute
Date: Tue,  8 Oct 2024 09:47:06 +0800
Message-Id: <20241008014706.3543-2-zhangwarden@gmail.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20241008014706.3543-1-zhangwarden@gmail.com>
References: <20241008014706.3543-1-zhangwarden@gmail.com>
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


