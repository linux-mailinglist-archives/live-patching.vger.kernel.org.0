Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73C2A4D6FB5
	for <lists+live-patching@lfdr.de>; Sat, 12 Mar 2022 16:23:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231700AbiCLPYL (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Sat, 12 Mar 2022 10:24:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231678AbiCLPYK (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Sat, 12 Mar 2022 10:24:10 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98A512DE
        for <live-patching@vger.kernel.org>; Sat, 12 Mar 2022 07:22:44 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id gj15-20020a17090b108f00b001bef86c67c1so10713766pjb.3
        for <live-patching@vger.kernel.org>; Sat, 12 Mar 2022 07:22:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XRw+YAJ4GLl11xdBATgXVNGTmbm0rcp15o7Ojv9QUYU=;
        b=HrPTJCVhf/GjWoAVFjv1jesn4SLS7xZ6WBQSAqte9w3LiKSMPRIizxvT8wzrrhbToK
         9qRsJ3il+CNF+NGoQaVWkhPS6TbxTn2z4Z2Dbhx/qyzfYn2NvOLurKE82w2ZDQ3N9KGr
         EsKLfYxLzD1e0kiaoVZujjMVufCe4SUxn3osfNe2yYd8E23tHMTsQ53ObFGsaxpcLo8F
         i2gUm7tRiIThup7jJftVOQM3wmnSC75QoZieflOK2ZNVdLvXfjhboFFYt5xIRqe2A6s2
         J1qioIIsDwyy63tQd0njPVZdKOUQmgZZJ+rfkJkfVdcsH18vxmUufs3D06dg15TS7pnR
         O+2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XRw+YAJ4GLl11xdBATgXVNGTmbm0rcp15o7Ojv9QUYU=;
        b=PrgTxl/BCLBt7KYnxni0vTx8ggdbDBXhoHO2RYzd5fb0T6a/1QZbYdwVEIIB0TS/7l
         jEoS9rNAkW8tuQJHTHRgRY/XB9Ike9c/9d6BRsjE621NIn2qhxvN/Vj8PGFXFTAVIU3M
         ddRBkRiaut8BzjgePh/GjhsuvXzG6qqbadLpDZ/WMO8pttCrznQr0pS0TnFGBBpaWfDA
         ECOOrVHLXVieGtuPJBbO6lu+d34/7RIcGJloSqGwfYWxbW1twTkeBEXlZ8i9IiOy306A
         tVCXqGrSVNdd8TIIjXq9lFVX5Bfy5aWxVMYE9V6S1BXXLOOZ2KxfUZLx6a/XbGIiXPG6
         6LtQ==
X-Gm-Message-State: AOAM533lpfbUfnS3RQaND6t2aNb4x5ZmpV4Cs+GNOYnUzARVhVsMok6j
        oEAsi9tfnkWI3bU9xtuFqQV8Mg==
X-Google-Smtp-Source: ABdhPJw0PdBgilaHU0OIB9uq21V827X4Efg8i3Efs4jn/EtALEnLrO3LoCU+I0rWkT53YIuOYagbvQ==
X-Received: by 2002:a17:902:cec6:b0:151:e4a6:6af1 with SMTP id d6-20020a170902cec600b00151e4a66af1mr15233205plg.64.1647098563062;
        Sat, 12 Mar 2022 07:22:43 -0800 (PST)
Received: from localhost.localdomain ([2409:8a28:e63:f230:50dc:173d:c83a:7b2])
        by smtp.gmail.com with ESMTPSA id ay5-20020a056a00300500b004f6d510af4asm12974605pfb.124.2022.03.12.07.22.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Mar 2022 07:22:42 -0800 (PST)
From:   Chengming Zhou <zhouchengming@bytedance.com>
To:     jpoimboe@redhat.com, jikos@kernel.org, mbenes@suse.cz,
        pmladek@suse.com, joe.lawrence@redhat.com
Cc:     live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        songmuchun@bytedance.com, qirui.001@bytedance.com,
        Chengming Zhou <zhouchengming@bytedance.com>
Subject: [PATCH v3] livepatch: Don't block removal of patches that are safe to unload
Date:   Sat, 12 Mar 2022 23:22:20 +0800
Message-Id: <20220312152220.88127-1-zhouchengming@bytedance.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

module_put() is not called for a patch with "forced" flag. It should
block the removal of the livepatch module when the code might still
be in use after forced transition.

klp_force_transition() currently sets "forced" flag for all patches on
the list.

In fact, any patch can be safely unloaded when it passed through
the consistency model in KLP_UNPATCHED transition.

By other words, the "forced" flag must be set only for livepatches
that are being removed. In particular, set the "forced" flag:

  + only for klp_transition_patch when the transition to KLP_UNPATCHED
    state was forced.

  + all replaced patches when the transition to KLP_PATCHED state was
    forced and the patch was replacing the existing patches.

Signed-off-by: Chengming Zhou <zhouchengming@bytedance.com>
---
Changes in v3:
 - rewrite more clear commit message by Petr.

Changes in v2:
 - interact nicely with the atomic replace feature noted by Miroslav.
---
 kernel/livepatch/transition.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/kernel/livepatch/transition.c b/kernel/livepatch/transition.c
index 5683ac0d2566..7f25a5ae89f6 100644
--- a/kernel/livepatch/transition.c
+++ b/kernel/livepatch/transition.c
@@ -641,6 +641,18 @@ void klp_force_transition(void)
 	for_each_possible_cpu(cpu)
 		klp_update_patch_state(idle_task(cpu));
 
-	klp_for_each_patch(patch)
-		patch->forced = true;
+	/*
+	 * Only need to set forced flag for the transition patch
+	 * when force transition to KLP_UNPATCHED state, but
+	 * have to set forced flag for all replaced patches
+	 * when force atomic replace transition.
+	 */
+	if (klp_target_state == KLP_UNPATCHED)
+		klp_transition_patch->forced = true;
+	else if (klp_transition_patch->replace) {
+		klp_for_each_patch(patch) {
+			if (patch != klp_transition_patch)
+				patch->forced = true;
+		}
+	}
 }
-- 
2.20.1

