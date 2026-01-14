Return-Path: <live-patching+bounces-1908-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 4A8CFD1ECA2
	for <lists+live-patching@lfdr.de>; Wed, 14 Jan 2026 13:34:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id ECAC930057F7
	for <lists+live-patching@lfdr.de>; Wed, 14 Jan 2026 12:31:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A97FE395245;
	Wed, 14 Jan 2026 12:31:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="EdL1qTm9"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96211396B80
	for <live-patching@vger.kernel.org>; Wed, 14 Jan 2026 12:31:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768393917; cv=none; b=BuuJCCV9Mo6BBeIwv2zrMo40YmouJyxDYQVb/xAJseq1tXMskwfEh23LvjwkNwHwjsMO2CO8iaiXrfpG/LdOlI5/r4+dcMZ4WN6LKxqKV75EDIRkzeyW6U+YU3EIrC+3eca3Ec07kAxZTEKMrtTcHqDE4y8VDwLkIS8pj1JB9YM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768393917; c=relaxed/simple;
	bh=ZgJ1dEU6+ZGVdXM6hw4wKI+le2B582/kbyjLsCiprmo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n/2+K3jPUcvjEc2vhh5h7NzUonn8Nl4lFWz/hidfQFmKkdzT43CA/yzYOk5ECzgVox6UYHzO0T4YFRVfSbo8yhHKSzXdbQsNTulGJ66gJDqBwf5H/fr3R3JUnsBtQAxruQQjFk2frePXxGq8VI2T+6TV6gHRFVij1gBK4VpDTHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=EdL1qTm9; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-47ee937ecf2so855055e9.0
        for <live-patching@vger.kernel.org>; Wed, 14 Jan 2026 04:31:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1768393909; x=1768998709; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RR3YoD6WCTWgJohAhViTjBihhVdnHUrj5lJnB7qGoyI=;
        b=EdL1qTm9TFRSj5q3AdElTFnRhEhUbcnj2iYgVIl12twupqEltlfymYPnts2A3UeQgh
         lgvH2ElIJ4V9QslRuXYo8wrA00mkSUQf9NybDijPUhZTMHzuYPYGAQv5wLCYoxM1KiWJ
         og7f0fBVfu/saNOX6oC6xwWxCxDtMG8asOs+ChpYwFUf3XW5nf/HDC0eb1SkCXDMBUm7
         LFN7dBV9pjzSEEJULoWWuLLOPYmBVImjST1tzDOzctQBlg1ZJ8tnQrI8loKhh7Z1n61z
         eZ7RnHIhfAVdV9xz1NxHqQH5SdyF1cZSoiucN0xXP4YYe2ZVWfrfJ2mm9vlig0mjPj0m
         LAxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768393909; x=1768998709;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=RR3YoD6WCTWgJohAhViTjBihhVdnHUrj5lJnB7qGoyI=;
        b=DSMJjrDjZdzb7+bhPjy4vNPhQnSMGXkGV31bs1bacgkRYocYMN0UFacbJgPWzDbRVu
         RSKjA/k8q+w/WpubVx3eHIHdrUyyTnhTAzaIoaN0nxJPXZ98zbhfei412vV1bX9Vs+86
         hopnapUdRyKOSYqMXiGtCxrWSCaRqy67PhNk4eIMqLIjZFRQ7/Zgq6EUwSEKR9ldLYJE
         ZWcE4nt4/JLNMCkdIqAAlEgHuRB1//AKWBFzqGY1WGk/KJwimsI67vQTwCrsvxG8P053
         PquVvJXxVDuzMFzt9d+7d4QWR9RtLJNu+KbC2XfKQtnqVuhcwjqaxhsP3rb6dbScFIMO
         q0gg==
X-Forwarded-Encrypted: i=1; AJvYcCWMKpQcTggy/AHJi36c4hJfiMb4kdDH0UjOavZKGUnmsdTz5DCZfrY38Ctik1lyWfPybD3m8vO8xXIMdo0k@vger.kernel.org
X-Gm-Message-State: AOJu0Yy4NBAM5e9BdaOOgiYGuPoU7/32mD/BiApnIHW1/jfahaMNumWx
	9h8hLsjm5V490pNmnAfR92BU2MxFJpkfkCQYNcj2ROCP70t2H9nIcTi8P57afMs0Bnk=
X-Gm-Gg: AY/fxX5wqcH+V2uKzloWTEcurCRGc3GAxZFesDPx0nCNjJNMD9I9I6tfZM1IciE2Te1
	6Dv9U3KKiE4chBvMolQ0Z7rA7rI4Wmtj/ySKdzIHKnVyff7heAgAF9EHrDBohaUSD4iBJTfH5oY
	W90UdWk7kwSerDlmLs3UtjphMl60N28m5WtyudXn3csOd5BxaRCwX3Qq2/36cdC/vhLMFzD9gjo
	7rmezGddg9+tgNH6f9y2kuVkAnMSZ/PAru0YEMss7D6cX7vCa18B5ivP10WFYS3EH3EReEbrZuu
	ImSiurR3ZTHGT/0jgU6hfrSgYo6WBxjyAytzQEiX2v1AX3ziJxWXqSY+BkUvVW+t6+IYc4Mq/T2
	iaSWPn9vdMInLQwZpxctdTsrSWLCM3Ha3F669dwoGyRY7ptQgDA7Ng/43zjguBzynfymVtC5D61
	sQ4Rh44PdAFtWsQuelXDi4w2sH4GuQMd0=
X-Received: by 2002:a05:600c:a44:b0:47b:deb9:163d with SMTP id 5b1f17b1804b1-47ee377d1damr26618985e9.7.1768393909141;
        Wed, 14 Jan 2026 04:31:49 -0800 (PST)
Received: from zovi.suse.cz (109-81-1-107.rct.o2.cz. [109.81.1.107])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-432bd5ee243sm50097772f8f.31.2026.01.14.04.31.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jan 2026 04:31:48 -0800 (PST)
From: Petr Pavlu <petr.pavlu@suse.com>
To: Josh Poimboeuf <jpoimboe@kernel.org>,
	Jiri Kosina <jikos@kernel.org>,
	Miroslav Benes <mbenes@suse.cz>,
	Petr Mladek <pmladek@suse.com>,
	Joe Lawrence <joe.lawrence@redhat.com>
Cc: Luis Chamberlain <mcgrof@kernel.org>,
	Petr Pavlu <petr.pavlu@suse.com>,
	Daniel Gomez <da.gomez@kernel.org>,
	Sami Tolvanen <samitolvanen@google.com>,
	Aaron Tomlin <atomlin@atomlin.com>,
	Peter Zijlstra <peterz@infradead.org>,
	live-patching@vger.kernel.org,
	linux-modules@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] livepatch: Fix having __klp_objects relics in non-livepatch modules
Date: Wed, 14 Jan 2026 13:29:53 +0100
Message-ID: <20260114123056.2045816-2-petr.pavlu@suse.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260114123056.2045816-1-petr.pavlu@suse.com>
References: <20260114123056.2045816-1-petr.pavlu@suse.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The linker script scripts/module.lds.S specifies that all input
__klp_objects sections should be consolidated into an output section of
the same name, and start/stop symbols should be created to enable
scripts/livepatch/init.c to locate this data.

This start/stop pattern is not ideal for modules because the symbols are
created even if no __klp_objects input sections are present.
Consequently, a dummy __klp_objects section also appears in the
resulting module. This unnecessarily pollutes non-livepatch modules.

Instead, since modules are relocatable files, the usual method for
locating consolidated data in a module is to read its section table.
This approach avoids the aforementioned problem.

The klp_modinfo already stores a copy of the entire section table with
the final addresses. Introduce a helper function that
scripts/livepatch/init.c can call to obtain the location of the
__klp_objects section from this data.

Signed-off-by: Petr Pavlu <petr.pavlu@suse.com>
---
 include/linux/livepatch.h |  3 +++
 kernel/livepatch/core.c   | 20 ++++++++++++++++++++
 scripts/livepatch/init.c  | 17 ++++++-----------
 scripts/module.lds.S      |  7 +------
 4 files changed, 30 insertions(+), 17 deletions(-)

diff --git a/include/linux/livepatch.h b/include/linux/livepatch.h
index 772919e8096a..ca90adbe89ed 100644
--- a/include/linux/livepatch.h
+++ b/include/linux/livepatch.h
@@ -175,6 +175,9 @@ int klp_enable_patch(struct klp_patch *);
 int klp_module_coming(struct module *mod);
 void klp_module_going(struct module *mod);
 
+struct klp_object_ext *klp_build_locate_init_objects(const struct module *mod,
+						     unsigned int *nr_objs);
+
 void klp_copy_process(struct task_struct *child);
 void klp_update_patch_state(struct task_struct *task);
 
diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
index 9917756dae46..4e0ac47b3623 100644
--- a/kernel/livepatch/core.c
+++ b/kernel/livepatch/core.c
@@ -1356,6 +1356,26 @@ void klp_module_going(struct module *mod)
 	mutex_unlock(&klp_mutex);
 }
 
+struct klp_object_ext *klp_build_locate_init_objects(const struct module *mod,
+						     unsigned int *nr_objs)
+{
+	struct klp_modinfo *info = mod->klp_info;
+
+	for (int i = 1; i < info->hdr.e_shnum; i++) {
+		Elf_Shdr *shdr = &info->sechdrs[i];
+
+		if (strcmp(info->secstrings + shdr->sh_name, "__klp_objects"))
+			continue;
+
+		*nr_objs = shdr->sh_size / sizeof(struct klp_object_ext);
+		return (struct klp_object_ext *)shdr->sh_addr;
+	}
+
+	*nr_objs = 0;
+	return NULL;
+}
+EXPORT_SYMBOL_GPL(klp_build_locate_init_objects);
+
 static int __init klp_init(void)
 {
 	klp_root_kobj = kobject_create_and_add("livepatch", kernel_kobj);
diff --git a/scripts/livepatch/init.c b/scripts/livepatch/init.c
index 2274d8f5a482..23e037d6de19 100644
--- a/scripts/livepatch/init.c
+++ b/scripts/livepatch/init.c
@@ -9,19 +9,16 @@
 #include <linux/slab.h>
 #include <linux/livepatch.h>
 
-extern struct klp_object_ext __start_klp_objects[];
-extern struct klp_object_ext __stop_klp_objects[];
-
 static struct klp_patch *patch;
 
 static int __init livepatch_mod_init(void)
 {
+	struct klp_object_ext *obj_exts;
 	struct klp_object *objs;
 	unsigned int nr_objs;
 	int ret;
 
-	nr_objs = __stop_klp_objects - __start_klp_objects;
-
+	obj_exts = klp_build_locate_init_objects(THIS_MODULE, &nr_objs);
 	if (!nr_objs) {
 		pr_err("nothing to patch!\n");
 		ret = -EINVAL;
@@ -41,7 +38,7 @@ static int __init livepatch_mod_init(void)
 	}
 
 	for (int i = 0; i < nr_objs; i++) {
-		struct klp_object_ext *obj_ext = __start_klp_objects + i;
+		struct klp_object_ext *obj_ext = obj_exts + i;
 		struct klp_func_ext *funcs_ext = obj_ext->funcs;
 		unsigned int nr_funcs = obj_ext->nr_funcs;
 		struct klp_func *funcs = objs[i].funcs;
@@ -90,12 +87,10 @@ static int __init livepatch_mod_init(void)
 
 static void __exit livepatch_mod_exit(void)
 {
-	unsigned int nr_objs;
-
-	nr_objs = __stop_klp_objects - __start_klp_objects;
+	struct klp_object *obj;
 
-	for (int i = 0; i < nr_objs; i++)
-		kfree(patch->objs[i].funcs);
+	klp_for_each_object_static(patch, obj)
+		kfree(obj->funcs);
 
 	kfree(patch->objs);
 	kfree(patch);
diff --git a/scripts/module.lds.S b/scripts/module.lds.S
index 3037d5e5527c..383d19beffb4 100644
--- a/scripts/module.lds.S
+++ b/scripts/module.lds.S
@@ -35,12 +35,7 @@ SECTIONS {
 	__patchable_function_entries : { *(__patchable_function_entries) }
 
 	__klp_funcs		0: ALIGN(8) { KEEP(*(__klp_funcs)) }
-
-	__klp_objects		0: ALIGN(8) {
-		__start_klp_objects = .;
-		KEEP(*(__klp_objects))
-		__stop_klp_objects = .;
-	}
+	__klp_objects		0: ALIGN(8) { KEEP(*(__klp_objects)) }
 
 #ifdef CONFIG_ARCH_USES_CFI_TRAPS
 	__kcfi_traps		: { KEEP(*(.kcfi_traps)) }
-- 
2.52.0


