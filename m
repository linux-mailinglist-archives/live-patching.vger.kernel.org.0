Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D271E3E529F
	for <lists+live-patching@lfdr.de>; Tue, 10 Aug 2021 07:16:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237587AbhHJFQg (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 10 Aug 2021 01:16:36 -0400
Received: from mail-pl1-f182.google.com ([209.85.214.182]:42965 "EHLO
        mail-pl1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237565AbhHJFQc (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 10 Aug 2021 01:16:32 -0400
Received: by mail-pl1-f182.google.com with SMTP id t3so19390083plg.9;
        Mon, 09 Aug 2021 22:16:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wQt1CnZzk8dhkLT7cQmNWMCJfUJc307w8knIddqucXs=;
        b=poCc42g+RPLn7gfi4PDoNUJ5KTimKKazo0uWnftGM9RgjPkOA/2uR2XsdEfSjFbmkk
         R6AT+XDTDCWnrxwPmeUZBBr6nLvAkRdsJhiCgwSkp8Ehs1jLAUxEv18YTsZTBew/h/q9
         kjxcdiiQ5zzJPjbs5hdgWGHJcT81ROE3lRFkh8DNlojP29UO68F403tcFrjWJPf1l1xo
         m2Psg7utbjCqS/GSO5O2xP+bLfYB63uvYbPL+DLkkpY4xEAu2n8QMjIVvyh9AwXYH7aS
         /z/bXrz7HhrmNk+kp0c963fVhrVmAh1AIX2MvOSOCUD7j8lKtaaCAm845nckgvMijl9x
         uzvQ==
X-Gm-Message-State: AOAM532GGc6cZzygUpLErbXtr1GsbbZ3dbqlAXKIpOXOuKyWrJQmOQve
        N39bCXfg/urB2a9zDsnd+n4=
X-Google-Smtp-Source: ABdhPJyw8T8mU87Kc9ziVKThIIDmBNrpQROSSatvRp4lLLDp4B6Je5VKD++dj8h3L4/LMNWj6MYmoQ==
X-Received: by 2002:a63:164e:: with SMTP id 14mr274898pgw.246.1628572570797;
        Mon, 09 Aug 2021 22:16:10 -0700 (PDT)
Received: from localhost ([191.96.121.128])
        by smtp.gmail.com with ESMTPSA id i24sm22571622pfr.207.2021.08.09.22.16.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Aug 2021 22:16:09 -0700 (PDT)
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     lucas.demarchi@intel.com, linux-modules@vger.kernel.org
Cc:     live-patching@vger.kernel.org, fstests@vger.kernel.org,
        linux-block@vger.kernel.org, hare@suse.de, dgilbert@interlog.com,
        jeyu@kernel.org, osandov@fb.com, linux-kernel@vger.kernel.org,
        Luis Chamberlain <mcgrof@kernel.org>
Subject: [PATCH v2 2/3] libkmod/libkmod-module: add refcnt fd helper
Date:   Mon,  9 Aug 2021 22:16:01 -0700
Message-Id: <20210810051602.3067384-3-mcgrof@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210810051602.3067384-1-mcgrof@kernel.org>
References: <20210810051602.3067384-1-mcgrof@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

The first part of kmod_module_get_refcnt() is to open the
file descriptor for the refcnt file. Add a helper to do this
as it can then be used in other cases in the library.

Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
---
 libkmod/libkmod-module.c | 37 ++++++++++++++++++++++++-------------
 1 file changed, 24 insertions(+), 13 deletions(-)

diff --git a/libkmod/libkmod-module.c b/libkmod/libkmod-module.c
index 6e0ff1a..04bb4d9 100644
--- a/libkmod/libkmod-module.c
+++ b/libkmod/libkmod-module.c
@@ -1877,25 +1877,16 @@ done:
 	return size;
 }
 
-/**
- * kmod_module_get_refcnt:
- * @mod: kmod module
- *
- * Get the ref count of this @mod, as returned by Linux Kernel, by reading
- * /sys filesystem.
- *
- * Returns: the reference count on success or < 0 on failure.
- */
-KMOD_EXPORT int kmod_module_get_refcnt(const struct kmod_module *mod)
+static int kmod_module_get_refcnt_fd(const struct kmod_module *mod)
 {
 	char path[PATH_MAX];
-	long refcnt;
 	int fd, err;
 
 	if (mod == NULL)
 		return -ENOENT;
 
 	snprintf(path, sizeof(path), "/sys/module/%s/refcnt", mod->name);
+
 	fd = open(path, O_RDONLY|O_CLOEXEC);
 	if (fd < 0) {
 		err = -errno;
@@ -1903,12 +1894,32 @@ KMOD_EXPORT int kmod_module_get_refcnt(const struct kmod_module *mod)
 			path, strerror(errno));
 		return err;
 	}
+	return fd;
+}
+
+/**
+ * kmod_module_get_refcnt:
+ * @mod: kmod module
+ *
+ * Get the ref count of this @mod, as returned by Linux Kernel, by reading
+ * /sys filesystem.
+ *
+ * Returns: the reference count on success or < 0 on failure.
+ */
+KMOD_EXPORT int kmod_module_get_refcnt(const struct kmod_module *mod)
+{
+	long refcnt;
+	int fd, err;
+
+	fd = kmod_module_get_refcnt_fd(mod);
+	if (fd < 0)
+		return fd;
 
 	err = read_str_long(fd, &refcnt, 10);
 	close(fd);
 	if (err < 0) {
-		ERR(mod->ctx, "could not read integer from '%s': '%s'\n",
-			path, strerror(-err));
+		ERR(mod->ctx, "could not read integer from '/sys/module/%s/refcnt': '%s'\n",
+		    mod->name, strerror(-err));
 		return err;
 	}
 
-- 
2.30.2

