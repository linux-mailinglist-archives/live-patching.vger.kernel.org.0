Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E99C84734C6
	for <lists+live-patching@lfdr.de>; Mon, 13 Dec 2021 20:18:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242234AbhLMTSB (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 13 Dec 2021 14:18:01 -0500
Received: from mail-qk1-f180.google.com ([209.85.222.180]:39749 "EHLO
        mail-qk1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242219AbhLMTR6 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 13 Dec 2021 14:17:58 -0500
Received: by mail-qk1-f180.google.com with SMTP id b67so14876070qkg.6;
        Mon, 13 Dec 2021 11:17:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ZdDsue3rdtYrdCoUMZ9VwBkGQMAsRFep+AIp/S8CTaM=;
        b=guRbQyiLfSeITN8EnSAfQoXkwwMday74GWUbtsRU2o/IDYa68PHmzShkF3Y+EZ/a5L
         UiF2YvKF1VRlDbrvC2i7ChmXEfymu8HFKfiDsplFE0LOA0obJ+z6oicreDUtWG3e+GqD
         LlTU0enRR//4UyYDoE0tZ1dUjsoqIGjASzCB4i6YMZ9qfL/PihAM/64GWjUpGHfJk0kR
         IQxW8sgtRBm79pb07XmAl5q+CP1KeJaTC8uzxiE1+QIeApNF1RjAGqlc9y216Yh3zVB7
         Lko+sTDtFzynypw1YcarVGSnJTyVXrf2HWoWtV5wosO9i3K+Y8FIQP1zm1TGG5LWxvl6
         XIiA==
X-Gm-Message-State: AOAM531n/WVZFlpOdU186kr1psjTz6+6u4DmjNDmRx6NyStoYHqgoQG2
        hJ0UiKysR/EimHzd+vlYYPo=
X-Google-Smtp-Source: ABdhPJwD9gPdGR9osSmzXzDMpxR72RO/z0K+vqJZz4VOS+YSst+UdjoRVvDX+9dE/KZT0pcn2u9Caw==
X-Received: by 2002:a37:410:: with SMTP id 16mr150839qke.672.1639423077763;
        Mon, 13 Dec 2021 11:17:57 -0800 (PST)
Received: from localhost (fwdproxy-ash-004.fbsv.net. [2a03:2880:20ff:4::face:b00c])
        by smtp.gmail.com with ESMTPSA id t30sm4730587qkj.125.2021.12.13.11.17.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Dec 2021 11:17:57 -0800 (PST)
From:   David Vernet <void@manifault.com>
To:     pmladek@suse.com, linux-doc@vger.kernel.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        jpoimboe@redhat.com, jikos@kernel.org, mbenes@suse.cz,
        joe.lawrence@redhat.com, corbet@lwn.net
Cc:     void@manifault.com, yhs@fb.com, songliubraving@fb.com
Subject: [PATCH] livepatch: Fix leak on klp_init_patch_early failure path
Date:   Mon, 13 Dec 2021 11:17:35 -0800
Message-Id: <20211213191734.3238783-1-void@manifault.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

When enabling a KLP patch with `klp_enable_patch`, we invoke
`klp_init_patch_early` to initialize the kobjects for the patch itself, as
well as the `struct klp_object*`'s and `struct klp_func*`'s that comprise
it. However, there are some paths where we may fail to do an
early-initialization of an object or its functions if certain conditions
are not met, such as an object having a `NULL` funcs pointer. In these
paths, we may currently leak the `struct klp_patch*`'s kobject, as well as
any of its objects or functions, as we don't free the patch in
`klp_enable_patch` if `klp_init_patch_early` returns an error code. For
example, if we added the following object entry to the sample livepatch
code, it would cause us to leak the vmlinux `klp_object`, and its `struct
klp_func` which updates `cmdline_proc_show`:

```
static struct klp_object objs[] = {
        {
                .name = "kvm",
        }, { }
};
```

Without this change, if we enable `CONFIG_DEBUG_KOBJECT` and try to `kpatch
load livepatch-sample.ko`, we don't observe the kobjects being released
(though of course we do observe `insmod` failing to insert the module).
With the change, we do observe that the `kobject` for the patch and its
`vmlinux` object are released.

Signed-off-by: David Vernet <void@manifault.com>
---
 kernel/livepatch/core.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
index 335d988bd811..16e96836a825 100644
--- a/kernel/livepatch/core.c
+++ b/kernel/livepatch/core.c
@@ -1052,10 +1052,7 @@ int klp_enable_patch(struct klp_patch *patch)
 	}
 
 	ret = klp_init_patch_early(patch);
-	if (ret) {
-		mutex_unlock(&klp_mutex);
-		return ret;
-	}
+		goto err;
 
 	ret = klp_init_patch(patch);
 	if (ret)
-- 
2.30.2

