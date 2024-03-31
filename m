Return-Path: <live-patching+bounces-204-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 196858931B7
	for <lists+live-patching@lfdr.de>; Sun, 31 Mar 2024 15:39:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 876491F215AA
	for <lists+live-patching@lfdr.de>; Sun, 31 Mar 2024 13:39:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 920FA142E97;
	Sun, 31 Mar 2024 13:39:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Gek/8PDz"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05E2B77620;
	Sun, 31 Mar 2024 13:39:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711892379; cv=none; b=DRxckm0FlUZGBAllw+lTy5KfhfhNG8gxLYxHQTEpwgmLZ8a9IxkLZyw9v0EGemb9eiIwZOcXn2gDJU+vD95+4t76pZy1wtRsMwY5oMZQuS8Je/iqeCrJ6um8Gniep1B9lqX57Jt6iqn3P9oRM2eIMd4eD71XLXjQ1AqfjzjBwbY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711892379; c=relaxed/simple;
	bh=InENMLyEVj8LDUl4O3ZdCqTFX1wjOTf3pldDMrk1Xp4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=tUuqldESm5GaLXzmrWEd6gaMKtS8A7Q2gZGHEbtAcsIAlA3F2/aWGpxVUikZ3S4cnfYkYt2HOcn6hnWqi+OV6cL8FgOv1qAWvcbrzjM+xbgt/6LCzQI24tYPxbGedzPJSQs63VnbLv/M21NPyKaHbgNyy7glljRoqxSldQvNfIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Gek/8PDz; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-6eaf7c97738so764200b3a.2;
        Sun, 31 Mar 2024 06:39:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1711892377; x=1712497177; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=w9NaVh8gtRfzS1+NNHkWoqkIF1L86qwamtcfpVwuotk=;
        b=Gek/8PDzPuHciILXm/4QlbAolaRQP76y60OTV4bSd2WystTnnzzjZFTeeM5UJeVxM6
         Xk/JyZ9ka0weI2f4KwkOXdIowkYAoji4prbSIbP1+MUHV4pDO8mL2xQe+xCQmVwJNYIu
         wkpV+wlFjmn64UGl70Qxf8WXrgEOmDgngL+aHPQDo2VMcUrrixKHTfKKHa8TQqvER//3
         FUG1KiMQR/dB2TKlBCTUI3+D70oouvCvFO8VcVWCew2DcJE0a+uUlKVWNpKvxWzOtJ6k
         OzOfSoZoc75Sz3fKsvMk894bXFiwXoTJUcuP3vI/RMe/fV3eXiWdjTgEQ1g8UkNdtza+
         Ax0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711892377; x=1712497177;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=w9NaVh8gtRfzS1+NNHkWoqkIF1L86qwamtcfpVwuotk=;
        b=taAe/nAcyH209azUMqxiakME9bnGcEe32XtaYvBmjuzOaQvGtT3BSEvIk476LwlJ11
         xtIuLKOgcGB+vfpKkQ40ZGOPSvVsdHuRmRxHXavtNnV9f7TehTKlhAVKoGOqiSFarNdg
         He+dGj/R4fmEknbabKWZ6L8jejG3fCb/dC1pcAAJXXAR6pRSn6c7TiCP/jYd/oFzsPnj
         GznNKqbWgv2qAgqqfulYFIrisBpWhObxHusnl9jnhwrITd2sdENQmHS5fsEzcuQRiYc1
         3aDzuMOZcNHR3+WRCYqyZ/7U0UCwmsAXxc4fm4xuk4fKh69uo8HQINPvC5e34kAlRmOk
         joZg==
X-Forwarded-Encrypted: i=1; AJvYcCUiUvvTPMDxOk9D9FPt0COKyKV8zYCZdAW0v3K3p51Vw0DT9BrIZHKLGJinLIDQwoVV13kQdLFzkytTYeXAq4c1+kgj2RVUYGUEjkJ3UQ==
X-Gm-Message-State: AOJu0YxaXmWn+dzea6U7iTk5Z2Fx5z/VDnXrmLVSjXf3nAUfdmtHnMed
	Sbzj+cFOShlJKD/9ospIS/mhw0JT1owRWx7rrfgegQlZWDKOri3CBLGevoQRFxpBGA==
X-Google-Smtp-Source: AGHT+IEn4VdXcwvYZjmd7FZg4r3bvVG4brdLf+U8Hh/U4QlQBjzuvZ8GB1KwVBX0u4QddEkx6ifdoA==
X-Received: by 2002:a05:6a00:b4a:b0:6ea:b69a:7c48 with SMTP id p10-20020a056a000b4a00b006eab69a7c48mr8573072pfo.29.1711892377128;
        Sun, 31 Mar 2024 06:39:37 -0700 (PDT)
Received: from localhost.localdomain ([39.144.104.108])
        by smtp.gmail.com with ESMTPSA id p37-20020a631e65000000b005df41b00ee9sm5772899pgm.68.2024.03.31.06.39.24
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 31 Mar 2024 06:39:36 -0700 (PDT)
From: Yafang Shao <laoar.shao@gmail.com>
To: jpoimboe@kernel.org,
	jikos@kernel.org,
	mbenes@suse.cz,
	pmladek@suse.com,
	joe.lawrence@redhat.com,
	mcgrof@kernel.org
Cc: live-patching@vger.kernel.org,
	linux-modules@vger.kernel.org,
	Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH] livepatch: Delete the associated module when replacing an old livepatch
Date: Sun, 31 Mar 2024 21:38:39 +0800
Message-Id: <20240331133839.18316-1-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Enhance the functionality of kpatch to automatically remove the associated
module when replacing an old livepatch with a new one. This ensures that no
leftover modules remain in the system. For instance:

- Load the first livepatch
  $ kpatch load 6.9.0-rc1+/livepatch-test_0.ko
  loading patch module: 6.9.0-rc1+/livepatch-test_0.ko
  waiting (up to 15 seconds) for patch transition to complete...
  transition complete (2 seconds)

  $ kpatch list
  Loaded patch modules:
  livepatch_test_0 [enabled]

  $ lsmod |grep livepatch
  livepatch_test_0       16384  1

- Load a new livepatch
  $ kpatch load 6.9.0-rc1+/livepatch-test_1.ko
  loading patch module: 6.9.0-rc1+/livepatch-test_1.ko
  waiting (up to 15 seconds) for patch transition to complete...
  transition complete (2 seconds)

  $ kpatch list
  Loaded patch modules:
  livepatch_test_1 [enabled]

  $ lsmod |grep livepatch
  livepatch_test_1       16384  1
  livepatch_test_0       16384  0   <<<< leftover

With this improvement, executing
`kpatch load 6.9.0-rc1+/livepatch-test_1.ko` will automatically remove the
livepatch-test_0.ko module.

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
---
 include/linux/module.h  |  1 +
 kernel/livepatch/core.c | 11 +++++++++--
 kernel/module/main.c    | 43 ++++++++++++++++++++++++-----------------
 3 files changed, 35 insertions(+), 20 deletions(-)

diff --git a/include/linux/module.h b/include/linux/module.h
index 1153b0d99a80..9a95174a919b 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -75,6 +75,7 @@ extern struct module_attribute module_uevent;
 /* These are either module local, or the kernel's dummy ones. */
 extern int init_module(void);
 extern void cleanup_module(void);
+extern void delete_module(struct module *mod);
 
 #ifndef MODULE
 /**
diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
index ecbc9b6aba3a..f1edc999f3ef 100644
--- a/kernel/livepatch/core.c
+++ b/kernel/livepatch/core.c
@@ -711,6 +711,8 @@ static void klp_free_patch_start(struct klp_patch *patch)
  */
 static void klp_free_patch_finish(struct klp_patch *patch)
 {
+	struct module *mod = patch->mod;
+
 	/*
 	 * Avoid deadlock with enabled_store() sysfs callback by
 	 * calling this outside klp_mutex. It is safe because
@@ -721,8 +723,13 @@ static void klp_free_patch_finish(struct klp_patch *patch)
 	wait_for_completion(&patch->finish);
 
 	/* Put the module after the last access to struct klp_patch. */
-	if (!patch->forced)
-		module_put(patch->mod);
+	if (!patch->forced)  {
+		module_put(mod);
+		if (module_refcount(mod))
+			return;
+		mod->state = MODULE_STATE_GOING;
+		delete_module(mod);
+	}
 }
 
 /*
diff --git a/kernel/module/main.c b/kernel/module/main.c
index e1e8a7a9d6c1..e863e1f87dfd 100644
--- a/kernel/module/main.c
+++ b/kernel/module/main.c
@@ -695,12 +695,35 @@ EXPORT_SYMBOL(module_refcount);
 /* This exists whether we can unload or not */
 static void free_module(struct module *mod);
 
+void delete_module(struct module *mod)
+{
+	char buf[MODULE_FLAGS_BUF_SIZE];
+
+	/* Final destruction now no one is using it. */
+	if (mod->exit != NULL)
+		mod->exit();
+	blocking_notifier_call_chain(&module_notify_list,
+				     MODULE_STATE_GOING, mod);
+	klp_module_going(mod);
+	ftrace_release_mod(mod);
+
+	async_synchronize_full();
+
+	/* Store the name and taints of the last unloaded module for diagnostic purposes */
+	strscpy(last_unloaded_module.name, mod->name, sizeof(last_unloaded_module.name));
+	strscpy(last_unloaded_module.taints, module_flags(mod, buf, false),
+		sizeof(last_unloaded_module.taints));
+
+	free_module(mod);
+	/* someone could wait for the module in add_unformed_module() */
+	wake_up_all(&module_wq);
+}
+
 SYSCALL_DEFINE2(delete_module, const char __user *, name_user,
 		unsigned int, flags)
 {
 	struct module *mod;
 	char name[MODULE_NAME_LEN];
-	char buf[MODULE_FLAGS_BUF_SIZE];
 	int ret, forced = 0;
 
 	if (!capable(CAP_SYS_MODULE) || modules_disabled)
@@ -750,23 +773,7 @@ SYSCALL_DEFINE2(delete_module, const char __user *, name_user,
 		goto out;
 
 	mutex_unlock(&module_mutex);
-	/* Final destruction now no one is using it. */
-	if (mod->exit != NULL)
-		mod->exit();
-	blocking_notifier_call_chain(&module_notify_list,
-				     MODULE_STATE_GOING, mod);
-	klp_module_going(mod);
-	ftrace_release_mod(mod);
-
-	async_synchronize_full();
-
-	/* Store the name and taints of the last unloaded module for diagnostic purposes */
-	strscpy(last_unloaded_module.name, mod->name, sizeof(last_unloaded_module.name));
-	strscpy(last_unloaded_module.taints, module_flags(mod, buf, false), sizeof(last_unloaded_module.taints));
-
-	free_module(mod);
-	/* someone could wait for the module in add_unformed_module() */
-	wake_up_all(&module_wq);
+	delete_module(mod);
 	return 0;
 out:
 	mutex_unlock(&module_mutex);
-- 
2.39.1


