Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E98E85184A8
	for <lists+live-patching@lfdr.de>; Tue,  3 May 2022 14:57:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235637AbiECNBF (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 3 May 2022 09:01:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235642AbiECNBE (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 3 May 2022 09:01:04 -0400
Received: from mail-il1-x12d.google.com (mail-il1-x12d.google.com [IPv6:2607:f8b0:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7986C38D8C
        for <live-patching@vger.kernel.org>; Tue,  3 May 2022 05:57:31 -0700 (PDT)
Received: by mail-il1-x12d.google.com with SMTP id s14so3463646ild.6
        for <live-patching@vger.kernel.org>; Tue, 03 May 2022 05:57:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=digitalocean.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=k3hjIGc98aGiWVuDcDXHBqc9tZBRnu/2US5kxHnNwy0=;
        b=g1CaqJLilGnqsQUIk3eHeGaaAVDveaj9E472eEvs7gveopLPlzYMXVU2zvLL8PAj2i
         cOMCwsKCg22v4EjYs3tMGvPcip11/JxTYXpGGQLL7Yc2O4JfKRLke/Mm5W/qGI7Fiex4
         7fFqZbO7Y5C/wIbDpafoslf2Dp2ZCd8FCVQ+8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=k3hjIGc98aGiWVuDcDXHBqc9tZBRnu/2US5kxHnNwy0=;
        b=16AKyCSabQhZcMYkjAf4eFZvjdsUsKIfODOjkohZUYjWLnYSXEICjkYWYO18+T2jU4
         KPUIRy+tGdkbhLlscYITE4losKOz5+xoQh3IszuPe/gmcFlbDIhYw/UCEfJdXwR+Aat8
         uf3NaxZXCSzTI35GyE5i6O+418NPy/aBW5VK6tdLs/83DdtYaW/ibmtqS4S0rVShHq4g
         NJ4FYweI7mlopWvjUv0Qn7bnw1u9Y6mDTcHm83iY3j6Ul0uf98Mrv9Ljsel2ZgoiYvd/
         iWYkFZeaQdHOCAg9Mu7X3jzMQQeirK6GAUK6QZCRI9nyvlsyTpjcc2kAa9T1A7G5IHWv
         GyhA==
X-Gm-Message-State: AOAM5303ycT0IvtHdfSvHlpha+V99Zrdj/S9CHGEpTBytP9v++7p8p5r
        TgiGMGFEHB1MSZAlguccrH6/Kg==
X-Google-Smtp-Source: ABdhPJxz20K24XHCZ9JE+Zxs7lTLTqtutf6zphBovISBhMDYZIjwu43VFPOB/45pWi/dbA9pnSFaXA==
X-Received: by 2002:a05:6e02:11ad:b0:2cd:f8ad:de1b with SMTP id 13-20020a056e0211ad00b002cdf8adde1bmr6355724ilj.159.1651582650865;
        Tue, 03 May 2022 05:57:30 -0700 (PDT)
Received: from localhost ([2605:a601:ac0f:820:80d8:f53c:c84d:deaa])
        by smtp.gmail.com with ESMTPSA id f13-20020a056e020c6d00b002cde6e352ccsm3419323ilj.22.2022.05.03.05.57.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 May 2022 05:57:30 -0700 (PDT)
From:   Seth Forshee <sforshee@digitalocean.com>
To:     Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Andy Lutomirski <luto@kernel.org>
Cc:     Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel@vger.kernel.org, live-patching@vger.kernel.org,
        kvm@vger.kernel.org
Subject: [PATCH] entry/kvm: Make vCPU tasks exit to userspace when a livepatch is pending
Date:   Tue,  3 May 2022 07:57:29 -0500
Message-Id: <20220503125729.2556498-1-sforshee@digitalocean.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

A livepatch migration for a task can only happen when the task is
sleeping or it exits to userspace. This may happen infrequently for a
heavily loaded vCPU task, leading to livepatch transition failures.

Fake signals will be sent to tasks which fail to migrate via stack
checking. This will cause running vCPU tasks to exit guest mode, but
since no signal is pending they return to guest execution without
exiting to userspace. Fix this by treating a pending livepatch migration
like a pending signal, exiting to userspace with EINTR. This allows the
migration to complete, and userspace should re-excecute KVM_RUN to
resume guest execution.

In my testing, systems where livepatching would timeout after 60 seconds
were able to load livepatches within a couple of seconds with this
change.

Signed-off-by: Seth Forshee <sforshee@digitalocean.com>
---
 kernel/entry/kvm.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/kernel/entry/kvm.c b/kernel/entry/kvm.c
index 9d09f489b60e..efe4b791c253 100644
--- a/kernel/entry/kvm.c
+++ b/kernel/entry/kvm.c
@@ -14,7 +14,12 @@ static int xfer_to_guest_mode_work(struct kvm_vcpu *vcpu, unsigned long ti_work)
 				task_work_run();
 		}
 
-		if (ti_work & _TIF_SIGPENDING) {
+		/*
+		 * When a livepatch migration is pending, force an exit to
+		 * userspace as though a signal is pending to allow the
+		 * migration to complete.
+		 */
+		if (ti_work & (_TIF_SIGPENDING | _TIF_PATCH_PENDING)) {
 			kvm_handle_signal_exit(vcpu);
 			return -EINTR;
 		}
-- 
2.32.0

