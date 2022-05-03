Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79D32518B81
	for <lists+live-patching@lfdr.de>; Tue,  3 May 2022 19:50:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240711AbiECRxm (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 3 May 2022 13:53:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240674AbiECRxh (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 3 May 2022 13:53:37 -0400
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC02C3B29F
        for <live-patching@vger.kernel.org>; Tue,  3 May 2022 10:50:04 -0700 (PDT)
Received: by mail-il1-x132.google.com with SMTP id s14so4022219ild.6
        for <live-patching@vger.kernel.org>; Tue, 03 May 2022 10:50:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=digitalocean.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gw+un10uJqUNP/SbL+e25B/lzjHm7kiGfOYsGY9F7XM=;
        b=IQ5l1Tw0QCU5PbCxVcnsc+tTDYVs0hkTHeCetz8NmOg+tc+WmC7hJ9Db1EH0ffn3vt
         lWg5GdxzYnone+VZISJSZcdXLdgw+/rkq0ScHAzuDlP8aaHL8YJrpDCusQSa2CwLTYVQ
         5kiLmnnxp6CBthc47Q1I3FP1g2FAl3KmjJcy0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gw+un10uJqUNP/SbL+e25B/lzjHm7kiGfOYsGY9F7XM=;
        b=pnE5Q3y2RiFUR8mrMZBiFXuM+fjLzM44tzgoVGS6NsWIUR9uVOED3An6eXI1ACLzG7
         HTp4ZH3wRnRmVnR622jzrCmdMmlJ2wfubHklWbA58laDWyMISCJFaljW9UMBG/JnfH2y
         QZf6aYzbdOP5MJfUXH7vucF9nhWqZNGtRxnPIEi20dmh3LZ2rz6VPEAw4z+UEhOqX77E
         bu/LEvFmleMkHQjQY6s/JY8NL7a9dtJzSqjzP7utDyjJhRdqzL9qbr+sTSzOli5fkSOF
         rNSUzU3kJdJw0FqRuHz4G/gT5ltaG0WPfA6qblVwxlvVdGR1xkoGGZm1zOtqmnHlg6IJ
         zZgg==
X-Gm-Message-State: AOAM532DzjW2BDqk/omGhs7aJALI3EE92gYD6tzhwgVYjsmoSZWLTPfg
        cRNHEXXKLS7alIrt5LnoiDUYAA==
X-Google-Smtp-Source: ABdhPJzh+zb6aoHIl3yp5z+2hS5YP62Z1ngPLTw5+X3w+daEd6SSNy6hBReYVKdBs4/XoKgoLBqttA==
X-Received: by 2002:a05:6e02:20e4:b0:2cc:4535:9d22 with SMTP id q4-20020a056e0220e400b002cc45359d22mr7443763ilv.195.1651600203864;
        Tue, 03 May 2022 10:50:03 -0700 (PDT)
Received: from localhost ([2605:a601:ac0f:820:80d8:f53c:c84d:deaa])
        by smtp.gmail.com with ESMTPSA id u6-20020a02aa86000000b0032b3a78176dsm4049997jai.49.2022.05.03.10.49.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 May 2022 10:49:48 -0700 (PDT)
From:   Seth Forshee <sforshee@digitalocean.com>
To:     Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Andy Lutomirski <luto@kernel.org>
Cc:     Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        linux-kernel@vger.kernel.org, live-patching@vger.kernel.org,
        kvm@vger.kernel.org
Subject: [PATCH v2] entry/kvm: Make vCPU tasks exit to userspace when a livepatch is pending
Date:   Tue,  3 May 2022 12:49:34 -0500
Message-Id: <20220503174934.2641605-1-sforshee@digitalocean.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

A task can be livepatched only when it is sleeping or it exits to
userspace. This may happen infrequently for a heavily loaded vCPU task,
leading to livepatch transition failures.

Fake signals will be sent to tasks which fail patching via stack
checking. This will cause running vCPU tasks to exit guest mode, but
since no signal is pending they return to guest execution without
exiting to userspace. Fix this by treating a pending livepatch migration
like a pending signal, exiting to userspace with EINTR. This allows the
task to be patched, and userspace should re-excecute KVM_RUN to resume
guest execution.

In my testing, systems where livepatching would timeout after 60 seconds
were able to load livepatches within a couple of seconds with this
change.

Signed-off-by: Seth Forshee <sforshee@digitalocean.com>
---
Changes in v2:
 - Added _TIF_SIGPENDING to XFER_TO_GUEST_MODE_WORK
 - Reworded commit message and comments to avoid confusion around the
   term "migrate"

 include/linux/entry-kvm.h | 4 ++--
 kernel/entry/kvm.c        | 7 ++++++-
 2 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/include/linux/entry-kvm.h b/include/linux/entry-kvm.h
index 6813171afccb..bf79e4cbb5a2 100644
--- a/include/linux/entry-kvm.h
+++ b/include/linux/entry-kvm.h
@@ -17,8 +17,8 @@
 #endif
 
 #define XFER_TO_GUEST_MODE_WORK						\
-	(_TIF_NEED_RESCHED | _TIF_SIGPENDING | _TIF_NOTIFY_SIGNAL |	\
-	 _TIF_NOTIFY_RESUME | ARCH_XFER_TO_GUEST_MODE_WORK)
+	(_TIF_NEED_RESCHED | _TIF_SIGPENDING | _TIF_PATCH_PENDING |	\
+	 _TIF_NOTIFY_SIGNAL | _TIF_NOTIFY_RESUME | ARCH_XFER_TO_GUEST_MODE_WORK)
 
 struct kvm_vcpu;
 
diff --git a/kernel/entry/kvm.c b/kernel/entry/kvm.c
index 9d09f489b60e..98439dfaa1a0 100644
--- a/kernel/entry/kvm.c
+++ b/kernel/entry/kvm.c
@@ -14,7 +14,12 @@ static int xfer_to_guest_mode_work(struct kvm_vcpu *vcpu, unsigned long ti_work)
 				task_work_run();
 		}
 
-		if (ti_work & _TIF_SIGPENDING) {
+		/*
+		 * When a livepatch is pending, force an exit to userspace
+		 * as though a signal is pending to allow the task to be
+		 * patched.
+		 */
+		if (ti_work & (_TIF_SIGPENDING | _TIF_PATCH_PENDING)) {
 			kvm_handle_signal_exit(vcpu);
 			return -EINTR;
 		}
-- 
2.32.0

