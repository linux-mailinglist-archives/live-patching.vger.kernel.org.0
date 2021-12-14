Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA554474D76
	for <lists+live-patching@lfdr.de>; Tue, 14 Dec 2021 23:02:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230478AbhLNWCU (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 14 Dec 2021 17:02:20 -0500
Received: from mail-qv1-f51.google.com ([209.85.219.51]:35434 "EHLO
        mail-qv1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229975AbhLNWCT (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 14 Dec 2021 17:02:19 -0500
Received: by mail-qv1-f51.google.com with SMTP id kj6so3307017qvb.2;
        Tue, 14 Dec 2021 14:02:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BzSKy6jl8ogryfzgo3M4f4Lg4MSaREeaYzRGvq53Q00=;
        b=2JF50y8Uj7ePavG7jkRnqr3UujPonmfrxHRdIx+t47nrvFUdtP4xgNWAmM9eAjGkpt
         cD6e9XMtwj72uqVrkXwZGJuB7QeXkhmNe6PlK8P0kCzj8QssZkLteIjQk9FNS3aWAMi3
         po3XxHpV1upX8SM8raBmKhTetqN/uvBYFNHqBxWMsFxHyHSDlLwGrx6PS/7/9Slkpd51
         uc5kcwozfFCFYUFxbJfY0Rg6i1Z+8YFLalB1K6v1At2sE0JoOOIQkyKiLDVHgC3llXvb
         tc3gCBGtPd//ExfUgPnRETNY1HbsMM1yYdz/HPBijSl69YcN1Vn8iqIs4qkkEEtRKiPE
         4uOw==
X-Gm-Message-State: AOAM530jxtpK4uOvOkaZh5YoF6nXaDJBd0uzf7xNF0RKxsIlWnfoveRq
        SA+Qo3+n6jr/QoeM1urckrr4m2obgeE48w==
X-Google-Smtp-Source: ABdhPJwZCQ6S3nTjm3PAci3cSf59mYQ7S1T+09xORi/L6LMHZjysp07k8knbhNyg2HJEz0ug8Mq55Q==
X-Received: by 2002:a05:6214:e4c:: with SMTP id o12mr8365129qvc.60.1639519338703;
        Tue, 14 Dec 2021 14:02:18 -0800 (PST)
Received: from localhost (fwdproxy-ash-009.fbsv.net. [2a03:2880:20ff:9::face:b00c])
        by smtp.gmail.com with ESMTPSA id i11sm16527qko.116.2021.12.14.14.02.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Dec 2021 14:02:18 -0800 (PST)
From:   David Vernet <void@manifault.com>
To:     pmladek@suse.com, live-patching@vger.kernel.org,
        linux-kernel@vger.kernel.org, jpoimboe@redhat.com,
        jikos@kernel.org, mbenes@suse.cz, joe.lawrence@redhat.com,
        corbet@lwn.net
Cc:     void@manifault.com, songliubraving@fb.com,
        gregkh@linuxfoundation.org
Subject: [PATCH v2] livepatch: Fix leak on klp_init_patch_early failure path
Date:   Tue, 14 Dec 2021 14:01:26 -0800
Message-Id: <20211214220124.2911264-1-void@manifault.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

When enabling a klp patch with klp_enable_patch(), klp_init_patch_early()
is invoked to initialize the kobjects for the patch itself, as well as the
'struct klp_object' and 'struct klp_func' objects that comprise it.
However, there are some error paths in klp_enable_patch() where some
kobjects may have been initialized with kobject_init(), but an error code
is still returned due to e.g. a 'struct klp_object' having a NULL funcs
pointer.

In these paths, the kobject of the 'struct klp_patch' may be leaked, along
with one or more of its objects and their functions, as kobject_put() is
not invoked on the cleanup path if klp_init_patch_early() returns an error
code.

For example, if an object entry such as the following were added to the
sample livepatch module's klp patch, it would cause the vmlinux klp_object,
and its klp_func which updates 'cmdline_proc_show', to be leaked:

static struct klp_object objs[] = {
	{
		/* name being NULL means vmlinux */
		.funcs = funcs,
	},
	{
		.name = "kvm",
		/* NULL funcs -- would cause leak */
	}, { }
};

Without this change, if CONFIG_DEBUG_KOBJECT is enabled, and the sample klp
patch is loaded, the kobjects (the patch, the vmlinux 'struct klp_obj', and
its func) are not observed to be released in the dmesg log output.  With
the change, the kobjects are observed to be released.

Signed-off-by: David Vernet <void@manifault.com>
---
v2:
  - Move try_module_get() and the patch->objs NULL check out of
    klp_init_patch_early() to ensure that it's safe to jump to the 'err' label
    on the error path in klp_enable_patch().
  - Fix the patch description to not use markdown, and to use imperative
    language.

 kernel/livepatch/core.c | 17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
index 335d988bd811..98c2b0d02770 100644
--- a/kernel/livepatch/core.c
+++ b/kernel/livepatch/core.c
@@ -867,9 +867,6 @@ static int klp_init_patch_early(struct klp_patch *patch)
 	struct klp_object *obj;
 	struct klp_func *func;
 
-	if (!patch->objs)
-		return -EINVAL;
-
 	INIT_LIST_HEAD(&patch->list);
 	INIT_LIST_HEAD(&patch->obj_list);
 	kobject_init(&patch->kobj, &klp_ktype_patch);
@@ -889,9 +886,6 @@ static int klp_init_patch_early(struct klp_patch *patch)
 		}
 	}
 
-	if (!try_module_get(patch->mod))
-		return -ENODEV;
-
 	return 0;
 }
 
@@ -1025,7 +1019,7 @@ int klp_enable_patch(struct klp_patch *patch)
 {
 	int ret;
 
-	if (!patch || !patch->mod)
+	if (!patch || !patch->mod || !patch->objs)
 		return -EINVAL;
 
 	if (!is_livepatch_module(patch->mod)) {
@@ -1051,11 +1045,12 @@ int klp_enable_patch(struct klp_patch *patch)
 		return -EINVAL;
 	}
 
+	if (!try_module_get(patch->mod))
+		return -ENODEV;
+
 	ret = klp_init_patch_early(patch);
-	if (ret) {
-		mutex_unlock(&klp_mutex);
-		return ret;
-	}
+	if (ret)
+		goto err;
 
 	ret = klp_init_patch(patch);
 	if (ret)
-- 
2.30.2

