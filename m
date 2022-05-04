Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C44551ACD9
	for <lists+live-patching@lfdr.de>; Wed,  4 May 2022 20:30:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348106AbiEDSdJ (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 4 May 2022 14:33:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376680AbiEDScj (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 4 May 2022 14:32:39 -0400
Received: from mail-oi1-x231.google.com (mail-oi1-x231.google.com [IPv6:2607:f8b0:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B9AB5A2F2
        for <live-patching@vger.kernel.org>; Wed,  4 May 2022 11:08:42 -0700 (PDT)
Received: by mail-oi1-x231.google.com with SMTP id m11so1954314oib.11
        for <live-patching@vger.kernel.org>; Wed, 04 May 2022 11:08:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=digitalocean.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+H552I4GIPi5L5ZDmVgN+SQqrGNNUqdTynrkxAEOZ0E=;
        b=cxf6O0u8k7lflkwx23uuKJ05bXK92eRzLDF7Puf2ZoxNvdK+t4XDXH+ajQDF5mt2hH
         KpnsKpQrNoSp37QgP6ZT3jOkCi7ZtMDbJ4Isx4e8F4WJGaCfIfuibfTyiuI9HTnoHVwi
         uCr1JAnKtg2qP11jSTkrgXVLSMQwsZijPPbWI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+H552I4GIPi5L5ZDmVgN+SQqrGNNUqdTynrkxAEOZ0E=;
        b=BZN/h3LoodPrkjdy8pUDuzIwpNAhxU6UCN4TKZ/+/JvRzrZ1Rwv67QoJFvu2n2Tnpb
         deNgNjInlOEX9mC2Hea4qt1A0+QzJLRJxdWmq85Kw5ppDIdBLAUwkTPseIRCdBIgMIft
         GnysfBOaHHwdOo0lTL/Vdkw2gKRyON4NY60e59LzcA59KSfXGxbGX4cehmyAu9ny3WfX
         PDq3jcwJM3LXlcjha8xqYBSIFUMOGgc/KheK2+G5rh+zBy7pjYp14X2SHVLp4EbaqWBh
         jXIgvzmtePVCR4yDthZDeOmbpbTWUKp2IvwzEw51ESZiQ0OwZ+KXOBww8Z8ctE7L5m1v
         BiRQ==
X-Gm-Message-State: AOAM532vDmFFB59jQxLxMhGELXK0OQsHV8DeRoWu4s7ONdLBhuM5S8eM
        VxKsjnlrr0U238KuKYqtA93nzg==
X-Google-Smtp-Source: ABdhPJxJY1BcSSKsOcZVuE9EpZNIp3RAdg7UXIrlPjSqfxaibA4ryPHEEJzmAuyY80pqd+hpwrMw7Q==
X-Received: by 2002:a05:6808:1385:b0:325:efe5:b340 with SMTP id c5-20020a056808138500b00325efe5b340mr320442oiw.249.1651687721511;
        Wed, 04 May 2022 11:08:41 -0700 (PDT)
Received: from localhost ([2605:a601:ac0f:820:373b:a889:93d6:e756])
        by smtp.gmail.com with ESMTPSA id g2-20020a056870a70200b000e686d1389esm8061243oam.56.2022.05.04.11.08.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 May 2022 11:08:41 -0700 (PDT)
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
        Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        live-patching@vger.kernel.org, kvm@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [PATCH] entry/kvm: Exit to user mode when TIF_NOTIFY_SIGNAL is set
Date:   Wed,  4 May 2022 13:08:40 -0500
Message-Id: <20220504180840.2907296-1-sforshee@digitalocean.com>
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

A livepatch transition may stall indefinitely when a kvm vCPU is heavily
loaded. To the host, the vCPU task is a user thread which is spending a
very long time in the ioctl(KVM_RUN) syscall. During livepatch
transition, set_notify_signal() will be called on such tasks to
interrupt the syscall so that the task can be transitioned. This
interrupts guest execution, but when xfer_to_guest_mode_work() sees that
TIF_NOTIFY_SIGNAL is set but not TIF_SIGPENDING it concludes that an
exit to user mode is unnecessary, and guest execution is resumed without
transitioning the task for the livepatch.

This handling of TIF_NOTIFY_SIGNAL is incorrect, as set_notify_signal()
is expected to break tasks out of interruptible kernel loops and cause
them to return to userspace. Change xfer_to_guest_mode_work() to handle
TIF_NOTIFY_SIGNAL the same as TIF_SIGPENDING, signaling to the vCPU run
loop that an exit to userpsace is needed. Any pending task_work will be
run when get_signal() is called from exit_to_user_mode_loop(), so there
is no longer any need to run task work from xfer_to_guest_mode_work().

Suggested-by: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Petr Mladek <pmladek@suse.com>
Signed-off-by: Seth Forshee <sforshee@digitalocean.com>
---
 kernel/entry/kvm.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/kernel/entry/kvm.c b/kernel/entry/kvm.c
index 9d09f489b60e..2e0f75bcb7fd 100644
--- a/kernel/entry/kvm.c
+++ b/kernel/entry/kvm.c
@@ -9,12 +9,6 @@ static int xfer_to_guest_mode_work(struct kvm_vcpu *vcpu, unsigned long ti_work)
 		int ret;
 
 		if (ti_work & (_TIF_SIGPENDING | _TIF_NOTIFY_SIGNAL)) {
-			clear_notify_signal();
-			if (task_work_pending(current))
-				task_work_run();
-		}
-
-		if (ti_work & _TIF_SIGPENDING) {
 			kvm_handle_signal_exit(vcpu);
 			return -EINTR;
 		}
-- 
2.32.0

