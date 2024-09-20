Return-Path: <live-patching+bounces-667-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3DC4697D348
	for <lists+live-patching@lfdr.de>; Fri, 20 Sep 2024 11:04:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 60DFB1C23A62
	for <lists+live-patching@lfdr.de>; Fri, 20 Sep 2024 09:04:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C57A4537FF;
	Fri, 20 Sep 2024 09:04:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PKiyl1Nh"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C84B81AC8;
	Fri, 20 Sep 2024 09:04:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726823067; cv=none; b=rX8/LxbnArM8YYfrTJFisGoYvcAFjvgMRLprSmr/O+5fFNS2GCcRm9PJGruIdohJu3jjgaX8SWkhvAaUC06pEf5JMeBEmWkXgzs2XIBJ0klhI8WmL5ILRujAeitLpUtjpjDDrFd/Y+2kPEssB2aWkwbdejEAFcnPlhS16BvrboQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726823067; c=relaxed/simple;
	bh=9NJ5dr4515VjHxI4GujigX0TXiflOzrd6cWTobOJIaY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=rc7L9/tsR7xunoXhqZIBAg70/4b1JV/pxil6YtmFla6wRsh2jRbBXUY2gwvoKrPehmfzRzKGCiltWhP1bVhircQffifePv9RBR/+xNhj4KIBT9sC0Py8NOOKFRWimH3BjUf0xLQhJwOfxj6mKEZwS3O7WUfVHmP+ncQtu4aNXvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PKiyl1Nh; arc=none smtp.client-ip=209.85.216.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-2d8818337a5so2156296a91.1;
        Fri, 20 Sep 2024 02:04:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1726823065; x=1727427865; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3PsVc2JzGrOPcWfSBUJtiPHgH2cNuRTU0FBqsQOokmw=;
        b=PKiyl1NhBLwPa0xbk6VoMJ/HxzyOOG6/J0KbwgtBQehuB0SotFOGcHco8/ryJSkbDz
         pJ2qM3JDqDv+3u8k9JnQWo7aZHnc6bd9yuoiTZ1MaIPNi09SwXK/iuVz6QWj/9pp92VS
         mmHnDWzUnVNn/cID4ru6EQtZyQuZXcwjx7LPB99YvnEiFTrUlwU/+1qO/3C4ZY/i5IJD
         OwlhU/u0m9ZvWIkFaSLMnW7zQyFm25tkaO1SMpVoFbXFwdrJllV08H7DcPpWAbyZVagp
         Rqqwfz1XgqYS1iXD/ZxEfFJ/ajNvBqKqmbRn0b5mR4hiRrcgtd+u8hTuo3qP1XN9sA+p
         lfIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726823065; x=1727427865;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3PsVc2JzGrOPcWfSBUJtiPHgH2cNuRTU0FBqsQOokmw=;
        b=KDhFqoTSUKwkCKn1W3JtdAKa9wly4W86DAh2kHDgwba9pTSo3C73/8VqfbbNg2NeD+
         ntx0ZanKuRhrXDEVLa9dbM1MYUVHRm3G17LGX/BGznVVgY7/09McPlD7a0Nj5DizOjOK
         7A4hd3tH5f4d8MI3heOmHGTX9+XoNfp3frxzaBCi57rNiHGESUKLNryo4CovdQIskjgd
         irmwtVxPBV+iZGqNlGnPg63GsJJFJGCNHqI0ZZYFuNE3nX8GL6f7nhf160EidwRDreFA
         MqYA++chZ/SqACLY+JBtlzHnnSOkhPOORvfdJlEXtQ73FhRRnvmC2s8UTk0dAE9wyPn5
         kCcw==
X-Forwarded-Encrypted: i=1; AJvYcCWZBLwnuokC0R65XXF278nm6eeJ18Y+tXYdOYGWBQj0xlzO1XbpOfXuwf1xRgI+01HKyI97bavw3lwJ6QU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx8C6dx/7tgCjkyo1caguK2dznqrbVY6CXpwr9xsiw1Mqtoi7i4
	A2rVTU6nQNYoZYMvm9Lf5XIKxt+yZPDvX29Bqp3cRXDs93GKhiwF
X-Google-Smtp-Source: AGHT+IEgIhSazdyT/CQMBAEXmtMfp2ph9x4krZZ2KxGb9UVFyY6QgNzLk9GQHX0nyU79DXUnls0aww==
X-Received: by 2002:a17:90a:cf09:b0:2c9:5a71:1500 with SMTP id 98e67ed59e1d1-2dd7ebce1d6mr3808247a91.0.1726823065196;
        Fri, 20 Sep 2024 02:04:25 -0700 (PDT)
Received: from localhost.localdomain ([205.204.117.126])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2dd6ee9d8ffsm3483881a91.23.2024.09.20.02.04.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Sep 2024 02:04:24 -0700 (PDT)
From: Wardenjohn <zhangwarden@gmail.com>
To: jpoimboe@kernel.org,
	mbenes@suse.cz,
	jikos@kernel.org,
	pmladek@suse.com,
	joe.lawrence@redhat.com
Cc: live-patching@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Wardenjohn <zhangwarden@gmail.com>
Subject: [PATCH 1/2] livepatch: introduce 'order' sysfs interface to klp_patch
Date: Fri, 20 Sep 2024 17:04:03 +0800
Message-Id: <20240920090404.52153-2-zhangwarden@gmail.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20240920090404.52153-1-zhangwarden@gmail.com>
References: <20240920090404.52153-1-zhangwarden@gmail.com>
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
cat /sys/kernel/livepatch/livepatch_1/order -> 1
means this livepatch_1 module is the 1st klp patch applied.

cat /sys/kernel/livepatch/livepatch_module/order -> N
means this lviepatch_module is the Nth klp patch applied
to the system.

Suggested-by: Petr Mladek <pmladek@suse.com>
Suggested-by: Miroslav Benes <mbenes@suse.cz>
Suggested-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Wardenjohn <zhangwarden@gmail.com>

diff --git a/include/linux/livepatch.h b/include/linux/livepatch.h
index 51a258c24ff5..0fbbc1636ebe 100644
--- a/include/linux/livepatch.h
+++ b/include/linux/livepatch.h
@@ -154,6 +154,7 @@ struct klp_state {
  * @forced:	was involved in a forced transition
  * @free_work:	patch cleanup from workqueue-context
  * @finish:	for waiting till it is safe to remove the patch module
+ * @order:	the order of this patch applied to the system
  */
 struct klp_patch {
 	/* external */
@@ -170,6 +171,7 @@ struct klp_patch {
 	bool forced;
 	struct work_struct free_work;
 	struct completion finish;
+	int order;
 };
 
 #define klp_for_each_object_static(patch, obj) \
diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
index 3c21c31796db..024853aa43a8 100644
--- a/kernel/livepatch/core.c
+++ b/kernel/livepatch/core.c
@@ -347,6 +347,7 @@ int klp_apply_section_relocs(struct module *pmod, Elf_Shdr *sechdrs,
  * /sys/kernel/livepatch/<patch>/transition
  * /sys/kernel/livepatch/<patch>/force
  * /sys/kernel/livepatch/<patch>/replace
+ * /sys/kernel/livepatch/<patch>/order
  * /sys/kernel/livepatch/<patch>/<object>
  * /sys/kernel/livepatch/<patch>/<object>/patched
  * /sys/kernel/livepatch/<patch>/<object>/<function,sympos>
@@ -452,15 +453,26 @@ static ssize_t replace_show(struct kobject *kobj,
 	return sysfs_emit(buf, "%d\n", patch->replace);
 }
 
+static ssize_t order_show(struct kobject *kobj,
+			struct kobj_attribute *attr, char *buf)
+{
+	struct klp_patch *patch;
+
+	patch = container_of(kobj, struct klp_patch, kobj);
+	return sysfs_emit(buf, "%d\n", patch->order);
+}
+
 static struct kobj_attribute enabled_kobj_attr = __ATTR_RW(enabled);
 static struct kobj_attribute transition_kobj_attr = __ATTR_RO(transition);
 static struct kobj_attribute force_kobj_attr = __ATTR_WO(force);
 static struct kobj_attribute replace_kobj_attr = __ATTR_RO(replace);
+static struct kobj_attribute order_kobj_attr = __ATTR_RO(order);
 static struct attribute *klp_patch_attrs[] = {
 	&enabled_kobj_attr.attr,
 	&transition_kobj_attr.attr,
 	&force_kobj_attr.attr,
 	&replace_kobj_attr.attr,
+	&order_kobj_attr.attr,
 	NULL
 };
 ATTRIBUTE_GROUPS(klp_patch);
diff --git a/kernel/livepatch/transition.c b/kernel/livepatch/transition.c
index ba069459c101..73bce68d22f8 100644
--- a/kernel/livepatch/transition.c
+++ b/kernel/livepatch/transition.c
@@ -46,6 +46,15 @@ EXPORT_SYMBOL(klp_sched_try_switch_key);
 
 #endif /* CONFIG_PREEMPT_DYNAMIC && CONFIG_HAVE_PREEMPT_DYNAMIC_CALL */
 
+static inline int klp_get_patch_order(struct klp_patch *patch)
+{
+	int order = 0;
+
+	klp_for_each_patch(patch)
+		order = order + 1;
+	return order;
+}
+
 /*
  * This work can be performed periodically to finish patching or unpatching any
  * "straggler" tasks which failed to transition in the first attempt.
@@ -591,6 +600,8 @@ void klp_init_transition(struct klp_patch *patch, int state)
 	pr_debug("'%s': initializing %s transition\n", patch->mod->name,
 		 klp_target_state == KLP_TRANSITION_PATCHED ? "patching" : "unpatching");
 
+	patch->order = klp_get_patch_order(patch);
+
 	/*
 	 * Initialize all tasks to the initial patch state to prepare them for
 	 * switching to the target state.
-- 
2.18.2


