Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6B4A675FF4
	for <lists+live-patching@lfdr.de>; Fri, 20 Jan 2023 23:12:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229999AbjATWMj (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 20 Jan 2023 17:12:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229973AbjATWMh (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 20 Jan 2023 17:12:37 -0500
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 262A8EFAC
        for <live-patching@vger.kernel.org>; Fri, 20 Jan 2023 14:12:36 -0800 (PST)
Received: by mail-io1-xd2c.google.com with SMTP id b127so3101271iof.8
        for <live-patching@vger.kernel.org>; Fri, 20 Jan 2023 14:12:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=digitalocean.com; s=google;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4THOFKr/oi12Lh9VLujYmInaKqJLT8dgCNKdQB2cfmk=;
        b=T4T5wgg++tuZ/vEq0fZnEjrnICkN93HtNwM8BOci4baJ4tNoZUO7qzGEVTNBfA+zQu
         n+V3DygwoipkiGcrdikPsPg9EX2QlA0RNlOvWazocCNMxG+ELMunhJNN2QxkSiTowOD9
         0wWjNg+idMoxJJ1ObfK0zxrJuNMwQRT2ae9oY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4THOFKr/oi12Lh9VLujYmInaKqJLT8dgCNKdQB2cfmk=;
        b=RytQ+VkYbxjGTJgAUKAA1vU30fwky6fpuOFt2ssOPIV1HVQCFdtdlxO5H8xONpUAFN
         xEjSOKHJxYaAHgAK78n1MkT7ZdL4OWr638TRRmxeUVwiOBO0AkWXuhETSMwf0z2oJCTr
         22YkrfzsuoeogJmkti+rjlJ9PoE/pwWUIoz/uh1rpwqOm7nQGVcf8xfzNOEH7DNBY1v9
         ZMNS1bKwWZ4LJnSDe4cgbADRkl97Rh+oyZNC+3E0YHiZDlCGLW7YaSdUm5PBqo00/rWO
         LCVJqevEJAimMStuYMa7tXeV+OwBjMYAQOdXAoMAFBIDZf7Sw2YQqhyvF0ImPKB/DwZg
         K78g==
X-Gm-Message-State: AFqh2kpS8NQ6PCOA2IiMW4XYsbQETEFFZHf1gz0qC3yIYDTby2V1cyIg
        EBFlJlAE4vkWptDcvdK0Q1f/ug==
X-Google-Smtp-Source: AMrXdXuYH0nZSV1qNftw1CzohAHNXptoGk5ziEa4Bpij01Z0mb6PK5Xk5Fi9HVzcgmqxNrAazaw+Lg==
X-Received: by 2002:a5e:df08:0:b0:704:6e8d:4891 with SMTP id f8-20020a5edf08000000b007046e8d4891mr12238768ioq.3.1674252755532;
        Fri, 20 Jan 2023 14:12:35 -0800 (PST)
Received: from localhost ([136.37.131.79])
        by smtp.gmail.com with ESMTPSA id j5-20020a5d93c5000000b006bba42f7822sm13342047ioo.52.2023.01.20.14.12.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Jan 2023 14:12:35 -0800 (PST)
From:   "Seth Forshee (DigitalOcean)" <sforshee@digitalocean.com>
X-Google-Original-From: "Seth Forshee (DigitalOcean)" <sforshee@kernel.org>
Date:   Fri, 20 Jan 2023 16:12:22 -0600
Subject: [PATCH 2/2] vhost: check for pending livepatches from vhost worker
 kthreads
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20230120-vhost-klp-switching-v1-2-7c2b65519c43@kernel.org>
References: <20230120-vhost-klp-switching-v1-0-7c2b65519c43@kernel.org>
In-Reply-To: <20230120-vhost-klp-switching-v1-0-7c2b65519c43@kernel.org>
To:     Petr Mladek <pmladek@suse.com>, Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>
Cc:     virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        "Seth Forshee (DigitalOcean)" <sforshee@kernel.org>,
        netdev@vger.kernel.org, live-patching@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Mailer: b4 0.10.1
X-Developer-Signature: v=1; a=openpgp-sha256; l=1164; i=sforshee@kernel.org;
 h=from:subject:message-id; bh=4/niAYH6EV14H83dRR2LugTxSHfcyLm3BmgkkAhqns4=;
 b=owEBbQGS/pANAwAKAVMDma7l9DHJAcsmYgBjyxHO/ViIOpErIY20s4GDksHjnp6o0DAE12QlN8dK
 hhzTEKaJATMEAAEKAB0WIQSQnt+rKAvnETy4Hc9TA5mu5fQxyQUCY8sRzgAKCRBTA5mu5fQxyfOWB/
 0WuOaZX+X5hCUgwSQTrkcv8eFNZr4ccIejTsTobwcs5msz5xGxh69uUHYc01UIvAoWd1KmcPNRwrUQ
 L1d3KILMoPNtB9E1KUGutwyCKQ+II25ZpJEN4NwvS1ne/2RTuYLC3JAE/5KXJBPrgkYtamqmAlQigj
 qPsmksCw5XYnJL8mlFNPnKi7mRUrO5wzG6Nvfklg6ueJJ0RjChqfxx7ihMiyz/i6NYxwnWrdb81ThR
 bvCgejkYkOCxXGU141uIoNj8L/+LxSJt7V4fBLFhWS7StagI41mGFFMKQDYshldbxo3ni4dt209Pxc
 r41Nzfigh02pcyKBNKotRlwsrmhIEy
X-Developer-Key: i=sforshee@kernel.org; a=openpgp;
 fpr=2ABCA7498D83E1D32D51D3B5AB4800A62DB9F73A
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Livepatch relies on stack checking of sleeping tasks to switch kthreads,
so a busy kthread can block a livepatch transition indefinitely. We've
seen this happen fairly often with busy vhost kthreads.

Add a check to call klp_switch_current() from vhost_worker() when a
livepatch is pending. In testing this allowed vhost kthreads to switch
immediately when they had previously blocked livepatch transitions for
long periods of time.

Signed-off-by: Seth Forshee (DigitalOcean) <sforshee@kernel.org>
---
 drivers/vhost/vhost.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index cbe72bfd2f1f..d8624f1f2d64 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -30,6 +30,7 @@
 #include <linux/interval_tree_generic.h>
 #include <linux/nospec.h>
 #include <linux/kcov.h>
+#include <linux/livepatch.h>
 
 #include "vhost.h"
 
@@ -366,6 +367,9 @@ static int vhost_worker(void *data)
 			if (need_resched())
 				schedule();
 		}
+
+		if (unlikely(klp_patch_pending(current)))
+			klp_switch_current();
 	}
 	kthread_unuse_mm(dev->mm);
 	return 0;

-- 
b4 0.10.1
