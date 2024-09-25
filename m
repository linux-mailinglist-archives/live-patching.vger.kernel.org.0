Return-Path: <live-patching+bounces-682-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 1FCCC985311
	for <lists+live-patching@lfdr.de>; Wed, 25 Sep 2024 08:41:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A892FB229E5
	for <lists+live-patching@lfdr.de>; Wed, 25 Sep 2024 06:41:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7DC0015575D;
	Wed, 25 Sep 2024 06:41:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KCRpoM68"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-ot1-f49.google.com (mail-ot1-f49.google.com [209.85.210.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDF131553BB;
	Wed, 25 Sep 2024 06:41:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727246472; cv=none; b=h4M+tatXbV0MNT8rEd20LmRQwOJEq3ilBgbJWbASoiR1S3/LHsQPwpOEgbTmy3OSX4gNl82lQ6QV/qFmayO4/Xzk5+Q8nAQfh5TgCcHSsxLCf+Z4Zd+gzSr4i1002YW/ZWAkj+8T1Mb8hI0PVxDIZzmwx8S4prE6DVbb2X2IPyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727246472; c=relaxed/simple;
	bh=pCLIxfYW5IBkkaUHIqU+ylfiwus7SaHuJakuwo+VRDE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=dM6pmed5faBK8W8cY0OvFBJnJuqX+hGcANEdgBJYXxYE7axTZJZui+b0cvRmP51I0QHNGiq05cDnnmBulCvHMUOTpV45bOAthysAw/X8UfEvMqq4LQG7AjT3xZ86FXrpOMwBOfVgz6U9LKoiI3RdYBCNi7RXrPPRLvg2WOoyXP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KCRpoM68; arc=none smtp.client-ip=209.85.210.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ot1-f49.google.com with SMTP id 46e09a7af769-71100987d1cso3779510a34.2;
        Tue, 24 Sep 2024 23:41:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727246470; x=1727851270; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6mqpiVlblehgTvx0uzv7/HZu092AuDOFFDCGMF9SGbc=;
        b=KCRpoM680OsFm12kiUa7OCIpxMld6sQwAjgW47DOYLv1/uuv1HE7UaDKWRWs2nPI4C
         mjdn/M6hYvxyt7sR1a2nYLi84onNy6wkKI5YZOYAodiP8KP34eW1viMh1HCWukvmM0YK
         itkWBwSvb2GdrBBxZ0YMRTbtNuOO54bJkeD/ehcuzs+HoIZso1ZGVE7d0TaK/OA37QAF
         zuRzkX2bbyBD3a6DB0yJEgaAdTkSkcrvhFBoarR9HbjvQlu68zWE0K2clj5MilT05FLX
         zE8O3Cr2RVySI96GJG+sP7dxAGBZpzOnB0SmTw+nsodnQOWjJjcMOWMNJbpQy8ph9p+m
         CTIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727246470; x=1727851270;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6mqpiVlblehgTvx0uzv7/HZu092AuDOFFDCGMF9SGbc=;
        b=cJRktOc2THyZua/hjVtIzmaUQFt+vRZ75WNgt35R9t5Z4l06LCmP3ajXjICI+UNqmk
         AOSpwG0M/DaBEHOQrljE5XuWgduvpGTn6JOsTcDCXsHjyn88Ri+OIsdZLw/iok1XkMy/
         NeFGZKiQBx4PD52nMcJy4C8CT+2FWkXLIoQ0Hf4lHhdrdNK/kOVMhb6XynZTPD48sYcm
         hcDDJKKbhD5YRiybTsVV3Pc+4a1RJuW7UbUp8BbVdx357WYTdIgSD7FhiV3hxV7jBaoO
         TXesvwQVxqIghIATaEbukQxUTNECIOCeEz+WmKqc7rBegUgSes3KjTyDw/EYP0C1SYKJ
         m3Ig==
X-Forwarded-Encrypted: i=1; AJvYcCVkU/J8/p4yxmlA5Nbow8+SAp4Kl/zu7YhYaJjA1/ZOALAGfEollab+BaS+aTw7ujgn75GF3RVynbxhgY4=@vger.kernel.org
X-Gm-Message-State: AOJu0YwJe2u+XHy89u9IDJvG+dOZNAab9gJNrD82sHw6frjicwsnuGxu
	k0ufEuWYSxwQSEAh4HF7WXwIfUMmxlBeOKBLIq+c5j7UR3SOqzGC
X-Google-Smtp-Source: AGHT+IG0WtGE8svdsrWLNKx78r3GmDXgbfIVSMkyziVRUB1iikUxyvoSp556EWwTv2JwGukDpQsCIw==
X-Received: by 2002:a05:6830:438f:b0:713:6f24:39b8 with SMTP id 46e09a7af769-713c7dcfa15mr1414462a34.19.1727246469784;
        Tue, 24 Sep 2024 23:41:09 -0700 (PDT)
Received: from localhost.localdomain ([205.204.117.121])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71afc8443e0sm2139578b3a.62.2024.09.24.23.41.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Sep 2024 23:41:09 -0700 (PDT)
From: Wardenjohn <zhangwarden@gmail.com>
To: jpoimboe@kernel.org,
	mbenes@suse.cz,
	jikos@kernel.org,
	pmladek@suse.com,
	joe.lawrence@redhat.com
Cc: live-patching@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Wardenjohn <zhangwarden@gmail.com>
Subject: [PATCH] livepatch: introduce 'stack_order' sysfs interface to klp_patch
Date: Wed, 25 Sep 2024 14:40:46 +0800
Message-Id: <20240925064047.95503-2-zhangwarden@gmail.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20240925064047.95503-1-zhangwarden@gmail.com>
References: <20240925064047.95503-1-zhangwarden@gmail.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This feature can provide livepatch patch order information.
With the order of sysfs interface of one klp_patch, we can
use patch order to find out which function of the patch is
now activate.

After the discussion, we decided that patch-level sysfs
interface is the only accaptable way to introduce this
information.

This feature is like:
cat /sys/kernel/livepatch/livepatch_1/stack_order -> 1
means this livepatch_1 module is the 1st klp patch applied.

cat /sys/kernel/livepatch/livepatch_module/stack_order -> N
means this lviepatch_module is the Nth klp patch applied
to the system.

Suggested-by: Petr Mladek <pmladek@suse.com>
Suggested-by: Miroslav Benes <mbenes@suse.cz>
Suggested-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Wardenjohn <zhangwarden@gmail.com>

diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
index ecbc9b6aba3a..914b7cabf8fe 100644
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
+	/* make sure the calculate of patch order correct */
+	mutex_lock(&klp_mutex);
+
+	klp_for_each_patch(patch) {
+		stack_order++;
+		if (patch == this_patch)
+			break;
+	}
+
+	mutex_unlock(&klp_mutex);
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


