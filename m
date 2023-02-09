Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65585691121
	for <lists+live-patching@lfdr.de>; Thu,  9 Feb 2023 20:18:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230040AbjBITSa (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 9 Feb 2023 14:18:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230032AbjBITS2 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 9 Feb 2023 14:18:28 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67CED6A70A;
        Thu,  9 Feb 2023 11:18:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F1D84B82292;
        Thu,  9 Feb 2023 19:18:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37C81C4339C;
        Thu,  9 Feb 2023 19:18:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675970304;
        bh=NKdf/DmfCqhfyz+hBsxyGBbopa789ZG35qd6K94RXng=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HhkyRF/zpOvo8qUME/yQOqPMB6OJmc0Y3wrOPwQq1Vr/2TcutOLZE3GpTVo62y4lO
         2gvB4xNDXS2ufFFu5kXwzZNoOiQS/i9vMVtPDplVuPySNv9x+R47NjGWT0+1wXpQok
         aMFqCqjmZQ5f9fvJATem7WCQgWTDMfNQzUCS95WFr8LOtYhZ3m162G1Y661kqo9tBR
         F14sKAf4/89QjrMiQR3lfp8hdrWL5mBMywnjI854U/NXvcLJ6kl6JZoEHH8L4x1ReU
         4uD1foRL8a9CDRhcg3d9BIUdU0btJTfSohGG6D5VhDEMNxmUIZMvgA4jNofd5vrdlo
         AzeyI4X9Xs/dA==
From:   Josh Poimboeuf <jpoimboe@kernel.org>
To:     live-patching@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Seth Forshee <sforshee@digitalocean.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Song Liu <song@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Petr Mladek <pmladek@suse.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Miroslav Benes <mbenes@suse.cz>,
        Jiri Kosina <jikos@kernel.org>, Ingo Molnar <mingo@redhat.com>
Subject: [PATCH 3/3] vhost: Fix livepatch timeouts in vhost_worker()
Date:   Thu,  9 Feb 2023 11:17:49 -0800
Message-Id: <76622971662bbd42abc9a1b25a73a8c3ac929ca3.1675969869.git.jpoimboe@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <cover.1675969869.git.jpoimboe@kernel.org>
References: <cover.1675969869.git.jpoimboe@kernel.org>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Livepatch timeouts were reported due to busy vhost_worker() kthreads.
Now that cond_resched() can do livepatch task switching, use
cond_resched() in vhost_worker().  That's the better way to
conditionally call schedule() anyway.

Reported-by: Seth Forshee (DigitalOcean) <sforshee@digitalocean.com>
Link: https://lkml.kernel.org/lkml/20230120-vhost-klp-switching-v1-0-7c2b65519c43@kernel.org
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 drivers/vhost/vhost.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index cbe72bfd2f1f..424c0c939f57 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -363,8 +363,7 @@ static int vhost_worker(void *data)
 			kcov_remote_start_common(dev->kcov_handle);
 			work->fn(work);
 			kcov_remote_stop();
-			if (need_resched())
-				schedule();
+			cond_resched();
 		}
 	}
 	kthread_unuse_mm(dev->mm);
-- 
2.39.0

