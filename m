Return-Path: <live-patching+bounces-223-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9CA0189AE5D
	for <lists+live-patching@lfdr.de>; Sun,  7 Apr 2024 05:58:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2A81F282B45
	for <lists+live-patching@lfdr.de>; Sun,  7 Apr 2024 03:58:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 02A5517C9;
	Sun,  7 Apr 2024 03:58:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HdjoggiV"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-il1-f171.google.com (mail-il1-f171.google.com [209.85.166.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F6431849;
	Sun,  7 Apr 2024 03:58:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712462284; cv=none; b=Kwfjz/BMLorXidinx7oXy+iADFlxigxHxVgcE2sjHhG0FYe3rr96zJgagj/KsoacNvPTCyxHurI+DuQ6fLkUHQylCrwa5RMXf+M51HYfGsR4yHErM0Ih1PJWG1LZe0kqxSYBq5xQ2SWAWnX4iqsyI0F//n+RtcfECl/i5/cn4vs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712462284; c=relaxed/simple;
	bh=YXScI5AXxp6v7+Wagg2vm2XuFbePhrlb0HlnrjE4fdg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=eIKdkhDcjAr37sijxWBRG/c3nmfqNilLNN+J/hV302ZarMkTm6d5r8C0OCJ8TzBSgKv3xE5RXdVs6ENXLTJdN/v1Qn7bsf9dEXWwuhAbdgX3nwxRgGa8oc6dttGqJi4Jtd+OTnXT7YByJrWJYb44pE+66YWFbi7oLtBqrNJn4a0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HdjoggiV; arc=none smtp.client-ip=209.85.166.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-il1-f171.google.com with SMTP id e9e14a558f8ab-369baba9c2cso5783135ab.3;
        Sat, 06 Apr 2024 20:58:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712462282; x=1713067082; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1zXkJkPQloWGiWzypXBId88gx51c4usQTOMRoUyQ3AQ=;
        b=HdjoggiVzjHYyBGck0/LH6U9Mn3QaV//hVhsxR/RY1OCF8t53o+6/0JXztdB2p8L7c
         X9wrZgMskGZwKtsjN01IeLhY0CNWK93pUssSIgRCC5xJ9Ax9NdJpmdYi2lU0r5vH45Gs
         emaCHfFdLCOvbpoAIVqygjfP6N++Y1yjEHi4sqxX8eh3por17yT/s3XRYC5B76DY6iFk
         RxRp9i7osd7GVz5PNwkLqQWyRi/2/ZibLqLyfZ/I8G4irNcBg7b7cntSWbLg+9cZidbU
         NC3Sk0dXqKbMn72tErwNvqECm/9P4UuGAWZ7uS+dD+KYsKiuQ95WBw4c2eOku/NozUhN
         /atg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712462282; x=1713067082;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1zXkJkPQloWGiWzypXBId88gx51c4usQTOMRoUyQ3AQ=;
        b=fRGj4EXSaXOSxclsWd+yeaIknLTkyTXZfL+wMViry/IDgm32N6fq0+4A1VjpJYux9F
         1Va2ytLgAc9ZQaosaP7QIw3E1od4zC+o9gRuq20/zk9fbvu+w/QHmEPid7Xa8MO4+plg
         79nlkERb8h61q9pj/u/1UxkCaD+c//x1hEhCmFc8/S/pqD7scEjba2R3+ZYdZiscyWXp
         jw7q0Hww9hXrYSF5mjUFrcNdTmBe/LWyL65/asx7biNa8GX2h9e3jVXZIb648nGUPNqP
         EXBDsaRlKq16/U9ghiJz/rDgpyF/HUC3f3B1eoU+d8mxMMhtpsNTRh7VfeUPMDXQHD8D
         QUog==
X-Forwarded-Encrypted: i=1; AJvYcCUcoxbsbz/Qv4a65YKYo5OviNEqtwpZLm9QgCdvqx+DOLGmaXtAw4sE57D0gPYWpdDpvw28yJloHn3P4aptZwRLKAoCXFP0QN5Rgncwiw==
X-Gm-Message-State: AOJu0YyJIw0xBFAE83m7otYkAYIpSDrp30BNtlj7nLlOR4HNbxAff7W9
	m+p0Nu7C3EnXIBlK+txZihZiLQK/O5oNcrbuQTDxCQv3mX8L8j6o
X-Google-Smtp-Source: AGHT+IHaWc/SY07TNuBaayzpcJ8YBg+OSL25KLi2aDjY10f3iyUwdVZsEXGKxU1ef5mzqevokpniFw==
X-Received: by 2002:a05:6e02:1c88:b0:36a:d29:5401 with SMTP id w8-20020a056e021c8800b0036a0d295401mr6488307ill.3.1712462282433;
        Sat, 06 Apr 2024 20:58:02 -0700 (PDT)
Received: from localhost.localdomain ([39.144.103.93])
        by smtp.gmail.com with ESMTPSA id w8-20020a170902e88800b001e27462b988sm3731093plg.61.2024.04.06.20.57.53
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 06 Apr 2024 20:58:01 -0700 (PDT)
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
Subject: [PATCH v2 1/2] module: Add a new helper delete_module()
Date: Sun,  7 Apr 2024 11:57:29 +0800
Message-Id: <20240407035730.20282-2-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
In-Reply-To: <20240407035730.20282-1-laoar.shao@gmail.com>
References: <20240407035730.20282-1-laoar.shao@gmail.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Introduce a new helper function, delete_module(), designed to delete kernel
modules from locations outside of the `kernel/module` directory.

No functional change.

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
---
 include/linux/module.h |  1 +
 kernel/module/main.c   | 82 ++++++++++++++++++++++++++++++++----------
 2 files changed, 65 insertions(+), 18 deletions(-)

diff --git a/include/linux/module.h b/include/linux/module.h
index 1153b0d99a80..c24557f1b795 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -75,6 +75,7 @@ extern struct module_attribute module_uevent;
 /* These are either module local, or the kernel's dummy ones. */
 extern int init_module(void);
 extern void cleanup_module(void);
+extern int delete_module(struct module *mod);
 
 #ifndef MODULE
 /**
diff --git a/kernel/module/main.c b/kernel/module/main.c
index e1e8a7a9d6c1..3b48ee66db41 100644
--- a/kernel/module/main.c
+++ b/kernel/module/main.c
@@ -695,12 +695,74 @@ EXPORT_SYMBOL(module_refcount);
 /* This exists whether we can unload or not */
 static void free_module(struct module *mod);
 
+static void __delete_module(struct module *mod)
+{
+	char buf[MODULE_FLAGS_BUF_SIZE];
+
+	WARN_ON_ONCE(mod->state != MODULE_STATE_GOING);
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
+int delete_module(struct module *mod)
+{
+	int ret;
+
+	mutex_lock(&module_mutex);
+	if (!list_empty(&mod->source_list)) {
+		/* Other modules depend on us: get rid of them first. */
+		ret = -EWOULDBLOCK;
+		goto out;
+	}
+
+	/* Doing init or already dying? */
+	if (mod->state != MODULE_STATE_LIVE) {
+		ret = -EBUSY;
+		goto out;
+	}
+
+	/* If it has an init func, it must have an exit func to unload */
+	if (mod->init && !mod->exit) {
+		ret = -EBUSY;
+		goto out;
+	}
+
+	if (try_release_module_ref(mod) != 0) {
+		ret = -EWOULDBLOCK;
+		goto out;
+	}
+	mod->state = MODULE_STATE_GOING;
+	mutex_unlock(&module_mutex);
+	__delete_module(mod);
+	return 0;
+
+out:
+	mutex_unlock(&module_mutex);
+	return ret;
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
@@ -750,23 +812,7 @@ SYSCALL_DEFINE2(delete_module, const char __user *, name_user,
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
+	__delete_module(mod);
 	return 0;
 out:
 	mutex_unlock(&module_mutex);
-- 
2.39.1


