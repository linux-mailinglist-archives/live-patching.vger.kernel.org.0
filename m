Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B9A56A2003
	for <lists+live-patching@lfdr.de>; Fri, 24 Feb 2023 17:50:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230023AbjBXQuU (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 24 Feb 2023 11:50:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230038AbjBXQuT (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 24 Feb 2023 11:50:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 135753BDA0;
        Fri, 24 Feb 2023 08:50:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8B10561948;
        Fri, 24 Feb 2023 16:50:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78DFFC4339B;
        Fri, 24 Feb 2023 16:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677257415;
        bh=/+ANatHz1yxjGMA7ryG0c/Km7p/0KZLeF6+BAXFBfTI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KNED18r35Unvo+Qk0w/kUt4niIy+qGdq7n1WVYiFX8mYQr2zorPEDVvNDAVDWoe+c
         5mZUrQaTmP02Iw8M7rLdZcskZisWBbCmhGDqJYQKbrNztHpK997MnXF4an8vO4KPBS
         swLEUfOGaLQs5qEDFjkT2Bb+47nGCUFSrLipv8EWdVfUK2Ra7ExpuGMmNetJOHC/nV
         5OrL4kgoeJ75Rpk+B7KlR6axpuuMupEUjsSOtu1F9PP16R0BEUDPqotDDrx/ZooKEO
         V3n6C77MJccDDfp1xu98Gyd/U9hTJJzziFAyXzYtdWsGyUVGKvrR7HqyGzz4SAgkLU
         j34oE4YW78mgg==
From:   Josh Poimboeuf <jpoimboe@kernel.org>
To:     live-patching@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Seth Forshee <sforshee@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Song Liu <song@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Petr Mladek <pmladek@suse.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Miroslav Benes <mbenes@suse.cz>,
        Jiri Kosina <jikos@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Rik van Riel <riel@surriel.com>
Subject: [PATCH v3 3/3] vhost: Fix livepatch timeouts in vhost_worker()
Date:   Fri, 24 Feb 2023 08:50:01 -0800
Message-Id: <509f6ea6fe6505f0a75a66026ba531c765ef922f.1677257135.git.jpoimboe@kernel.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <cover.1677257135.git.jpoimboe@kernel.org>
References: <cover.1677257135.git.jpoimboe@kernel.org>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
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

Reported-by: Seth Forshee (DigitalOcean) <sforshee@kernel.org>
Link: https://lkml.kernel.org/lkml/20230120-vhost-klp-switching-v1-0-7c2b65519c43@kernel.org
Tested-by: Seth Forshee (DigitalOcean) <sforshee@kernel.org>
Reviewed-by: Petr Mladek <pmladek@suse.com>
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 drivers/vhost/vhost.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index 43c9770b86e5..87e3cf12da1c 100644
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
2.39.1

