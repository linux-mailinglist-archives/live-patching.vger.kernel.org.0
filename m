Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C54D71716E
	for <lists+live-patching@lfdr.de>; Wed, 31 May 2023 01:16:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233783AbjE3XQL (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 30 May 2023 19:16:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231843AbjE3XQK (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 30 May 2023 19:16:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8724CAA;
        Tue, 30 May 2023 16:16:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0F05863508;
        Tue, 30 May 2023 23:16:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04EE2C433EF;
        Tue, 30 May 2023 23:16:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685488568;
        bh=e0CUxh2mVxfA/1Jqa3mCpXdqKlK7OJCF9M+9+uvD3e8=;
        h=From:To:Cc:Subject:Date:From;
        b=mtVhqmSh/FxtvcNO2dS318420LYe9zXJwprsV6aslB/NCw96f7b0j0eru+rU67Mmn
         HYFvT37eIHSw7S1btjOwjDqDJ2Tf7fwuD8wlAm/Zc40ypVplZ3wIRwwq5aJk+/LWds
         wyYdHvFoRSXpaPvsgK48yAMsvDqSpBwM1yI0FaIHkPV7LOPRqGNgS0q7TIwdYy4SQG
         9g3D3pBo8lfGfDmsOArYDAmxPXqUL/jR4O5oJOjjib4r8i8gTNtw+kz5Y/efLjYs8r
         5QQLnlirFWcv1lfmoYf/0Gyl33YBl87b/XVjlny1OIG23i5Epl/ofMCw3DP2gnxj4H
         7vkBGDnLYyhkw==
From:   Josh Poimboeuf <jpoimboe@kernel.org>
To:     live-patching@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, kernel test robot <lkp@intel.com>
Subject: [PATCH] livepatch: Make 'klp_stack_entries' static
Date:   Tue, 30 May 2023 16:15:58 -0700
Message-Id: <5115752fca6537720700f4bf5b178959dfbca41a.1685488550.git.jpoimboe@kernel.org>
X-Mailer: git-send-email 2.40.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

The 'klp_stack_entries' percpu array is only used in transition.c.  Make
it static.

Fixes: e92606fa172f ("livepatch: Convert stack entries array to percpu")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202305171329.i0UQ4TJa-lkp@intel.com/
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 kernel/livepatch/transition.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/livepatch/transition.c b/kernel/livepatch/transition.c
index e9fd83a02228..e54c3d60a904 100644
--- a/kernel/livepatch/transition.c
+++ b/kernel/livepatch/transition.c
@@ -15,7 +15,7 @@
 #include "transition.h"
 
 #define MAX_STACK_ENTRIES  100
-DEFINE_PER_CPU(unsigned long[MAX_STACK_ENTRIES], klp_stack_entries);
+static DEFINE_PER_CPU(unsigned long[MAX_STACK_ENTRIES], klp_stack_entries);
 
 #define STACK_ERR_BUF_SIZE 128
 
-- 
2.40.1

