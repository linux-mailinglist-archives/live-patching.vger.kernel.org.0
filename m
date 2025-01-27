Return-Path: <live-patching+bounces-1058-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 668A3A1D0F1
	for <lists+live-patching@lfdr.de>; Mon, 27 Jan 2025 07:35:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 910037A2D2A
	for <lists+live-patching@lfdr.de>; Mon, 27 Jan 2025 06:35:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BEF441FC11A;
	Mon, 27 Jan 2025 06:35:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AKtlTFcz"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C3451684B0;
	Mon, 27 Jan 2025 06:35:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737959743; cv=none; b=deemSEB0zPFu9ogSrhczEIGqdL78wfhfxSNHmlQ4/BMgdjvJx+3MCLjXcZM26tHcGBSSY73+81Tu2QCuqkJ4fXERWqn74USIy+uG9R2jce9UHQ5gdRGcFBz0vpCEvdUwjwxHVQ6Jk18EJCsgO9Dag5vD97yDWniChIC676a2w0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737959743; c=relaxed/simple;
	bh=ZMJNB8qcXvo7nLPXLs5dzsm3rGwbYUtNJ1DSr97OmLk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=GyRbFEJzJ6zbT2Chl1QYka31CJc39jg4+kkEr4mytRy7bZ0mUUoZ4+0DUIggW3biQ9J3Q/hwuMgfyYHABlh4Q8XLcv/+c65TrzFG8k/krU3bZW7S80Yk4z/v8ATNR5GUQDUcA9/BhHZxR5nUZ8on7S/7Hfc+BpgpBcm6cI1EI1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AKtlTFcz; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2167141dfa1so70163925ad.1;
        Sun, 26 Jan 2025 22:35:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1737959741; x=1738564541; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ez3tSvrde4/xlwnZmVuP+Fya4AZTGyJMn0fkkataWVU=;
        b=AKtlTFczvbFD0o+ga2/5Rq0JRpPWeXfcgQAtCdSY6bW4vAeeiJkTzGki2c47oM2lrj
         wZb46XO2HBeqofAR2jl8g7JpWPBNt8MI8DvO9XG8/mb+iAYc9ctSSS7bdSyP8BbGj6Vb
         YEaRKWt7WjaTuMhruSE152v85UIqL4IDBANIupiGBHw9iu6XYlJi3wZLoxjLV+tedtmc
         y03FSMRay7tahL0aPBEDwGLc3nb9q5PWSEiE/13vPAiG6bpdmhbOCotI7E5PUIUlwB0i
         rWT+jVYRFMpZuKvRMkwaEiTeLcP/dUBVyqtipEFPT6OQusIb8lc61H6PP0k+LiP4mjq8
         q9LQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737959741; x=1738564541;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ez3tSvrde4/xlwnZmVuP+Fya4AZTGyJMn0fkkataWVU=;
        b=vumyz3LFpxKoyqWW9AgAUSQJX4n1/oa8C7mL5vlAZ8ZF8OVo05qPpJXbBUAh6JpiXT
         SzBirYTuShTLWqeExYBjbd1kkVxL07AFywNeOLiGCi0IzXf7OZHi6kZFSSBwlsOJkxDn
         9J6iMqdTrJIdB0mwpqAAGg1zEVu7WK9ADI2dhHcjiOcI1KIYpTfmIuNBJ3zLhTGjmEHz
         MotpGwF+tA0Zh0oCatWfLTiaxhQPhhgj5F90hb1O/iATJyPLtRZcoGjBFS+0mFFP+k1K
         1MSTzvGuIswEEjPjyCiJbkCgx8fRJiifU9OF7c8+n3tbWjT3mMCjxpUvzgMeZPVTXf2f
         SZTQ==
X-Forwarded-Encrypted: i=1; AJvYcCWIjjbQrBm+EEsGRahnDnPVhez8jZDRwEI2PC3IdrWe1WrDobVUKoied2QuO0WF7/FVWPUeEfoXVPFAYgU=@vger.kernel.org
X-Gm-Message-State: AOJu0YxOD01oXyXFf15GxYewnvYhKeo6o1md31hSkDVrzf8xh3iPv+4O
	Bn260l7xkPQuWqqktjkczwIYexW9yZoF+rcSC/bV0ravSXyf6EhI
X-Gm-Gg: ASbGncuOxEPCJpNhZI99wuf8k+ATI3iHz6qUdpK2Ko8gQfbd3PMtj2+Jd1Cn+h3WCH+
	7gfBFqnlcnZMaHeOmBI2IgHEPJb4cl+nbHSA3KeOs4vYOsQ358pxKIUcXt6PhBujmp09cfTU4Ds
	hzwNzFT+/fCvTX+lRGs1GiJ3209SjDKbElsi+bWuDkljK9DGECwVUVjpYHBxyEi/a7cVCezQFmC
	1y6VteuSCT8aY7Lsp8fUdq9nWDHsSNIismJS1V+3EgV9kKeXAMBpSB7sfy82LQEYynY5Ffu0QAK
	gNToc6HYjVRyFW3zD4/YtLYhNgY=
X-Google-Smtp-Source: AGHT+IGzGMI3t4zpaFFXPEQC5PEbkmuJ1vNmXDAEw9ZeDHwySjkS7/yGxVEraKAC9rMgzVcXVw/daw==
X-Received: by 2002:a17:903:1206:b0:215:2d2c:dd0c with SMTP id d9443c01a7336-21da4a54381mr207318805ad.14.1737959741352;
        Sun, 26 Jan 2025 22:35:41 -0800 (PST)
Received: from localhost.localdomain ([58.38.78.239])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21da3ea3076sm55875605ad.68.2025.01.26.22.35.39
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 26 Jan 2025 22:35:40 -0800 (PST)
From: Yafang Shao <laoar.shao@gmail.com>
To: jpoimboe@kernel.org,
	jikos@kernel.org,
	mbenes@suse.cz,
	pmladek@suse.com,
	joe.lawrence@redhat.com
Cc: live-patching@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yafang Shao <laoar.shao@gmail.com>
Subject: [RFC PATCH 1/2] livepatch: Add replaceable attribute
Date: Mon, 27 Jan 2025 14:35:25 +0800
Message-Id: <20250127063526.76687-2-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
In-Reply-To: <20250127063526.76687-1-laoar.shao@gmail.com>
References: <20250127063526.76687-1-laoar.shao@gmail.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a new attribute "replaceable" to allow the coexsist of both atomic
replace livepatch and non atomic replace livepatch. If the replaceable is
set to 0, the livepatch won't be replaced by a atomic replace livepatch.

This is a preparation for the followup patch.

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
---
 include/linux/livepatch.h |  2 ++
 kernel/livepatch/core.c   | 44 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 46 insertions(+)

diff --git a/include/linux/livepatch.h b/include/linux/livepatch.h
index 51a258c24ff5..f2e962aab5b0 100644
--- a/include/linux/livepatch.h
+++ b/include/linux/livepatch.h
@@ -147,6 +147,7 @@ struct klp_state {
  * @objs:	object entries for kernel objects to be patched
  * @states:	system states that can get modified
  * @replace:	replace all actively used patches
+ * @replaceable:	whether this patch can be replaced or not
  * @list:	list node for global list of actively used patches
  * @kobj:	kobject for sysfs resources
  * @obj_list:	dynamic list of the object entries
@@ -161,6 +162,7 @@ struct klp_patch {
 	struct klp_object *objs;
 	struct klp_state *states;
 	bool replace;
+	bool replaceable;
 
 	/* internal */
 	struct list_head list;
diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
index 0cd39954d5a1..5e0c2caa0af8 100644
--- a/kernel/livepatch/core.c
+++ b/kernel/livepatch/core.c
@@ -347,6 +347,7 @@ int klp_apply_section_relocs(struct module *pmod, Elf_Shdr *sechdrs,
  * /sys/kernel/livepatch/<patch>/transition
  * /sys/kernel/livepatch/<patch>/force
  * /sys/kernel/livepatch/<patch>/replace
+ * /sys/kernel/livepatch/<patch>/replaceable
  * /sys/kernel/livepatch/<patch>/stack_order
  * /sys/kernel/livepatch/<patch>/<object>
  * /sys/kernel/livepatch/<patch>/<object>/patched
@@ -474,17 +475,60 @@ static ssize_t stack_order_show(struct kobject *kobj,
 	return sysfs_emit(buf, "%d\n", stack_order);
 }
 
+static ssize_t replaceable_store(struct kobject *kobj, struct kobj_attribute *attr,
+				const char *buf, size_t count)
+{
+	struct klp_patch *patch;
+	bool replaceable;
+	int ret;
+
+	ret = kstrtobool(buf, &replaceable);
+	if (ret)
+		return ret;
+
+	patch = container_of(kobj, struct klp_patch, kobj);
+
+	mutex_lock(&klp_mutex);
+
+	if (patch->replaceable == replaceable)
+		goto out;
+
+	if (patch == klp_transition_patch) {
+		ret = -EAGAIN;
+		goto out;
+	}
+
+	patch->replaceable = replaceable;
+
+out:
+	mutex_unlock(&klp_mutex);
+
+	if (ret)
+		return ret;
+	return count;
+}
+static ssize_t replaceable_show(struct kobject *kobj,
+			       struct kobj_attribute *attr, char *buf)
+{
+	struct klp_patch *patch;
+
+	patch = container_of(kobj, struct klp_patch, kobj);
+	return sysfs_emit(buf, "%d\n", patch->replaceable);
+}
+
 static struct kobj_attribute enabled_kobj_attr = __ATTR_RW(enabled);
 static struct kobj_attribute transition_kobj_attr = __ATTR_RO(transition);
 static struct kobj_attribute force_kobj_attr = __ATTR_WO(force);
 static struct kobj_attribute replace_kobj_attr = __ATTR_RO(replace);
 static struct kobj_attribute stack_order_kobj_attr = __ATTR_RO(stack_order);
+static struct kobj_attribute replaceable_kobj_attr = __ATTR_RW(replaceable);
 static struct attribute *klp_patch_attrs[] = {
 	&enabled_kobj_attr.attr,
 	&transition_kobj_attr.attr,
 	&force_kobj_attr.attr,
 	&replace_kobj_attr.attr,
 	&stack_order_kobj_attr.attr,
+	&replaceable_kobj_attr.attr,
 	NULL
 };
 ATTRIBUTE_GROUPS(klp_patch);
-- 
2.43.5


