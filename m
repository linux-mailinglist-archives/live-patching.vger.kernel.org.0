Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08B546A6F1C
	for <lists+live-patching@lfdr.de>; Wed,  1 Mar 2023 16:14:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229673AbjCAPOu (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 1 Mar 2023 10:14:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230191AbjCAPOs (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 1 Mar 2023 10:14:48 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9279F3E63C
        for <live-patching@vger.kernel.org>; Wed,  1 Mar 2023 07:14:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3BC0AB81037
        for <live-patching@vger.kernel.org>; Wed,  1 Mar 2023 15:14:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DB95C4339E;
        Wed,  1 Mar 2023 15:14:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677683677;
        bh=YnSTVU97Bjl/cMh6/t6T9f2fztbUlTSPgR2fMEBXWb4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SGpvihA4q94+Naidu4W2VCZnYMXmPrQOYS+hvh02a1mLhQST4PRIxzgJOpTt6gDke
         6KU2+ymligY2b/u4m4HaP91Fvzjz4Qj/ZrKxQ68oyOxyT0lACBoHb9awjJtZSLqjgW
         9aLbhuptpt2ahBFJFg1O0/g2vl1fLEmnuWMg27izOuNJ5B2MHL9T0Fq83Xm/h3erRj
         9SVGjYLC2uOb3EWTvSDtqfHpIYrOXrinKLwlAlwr+6X1fiZRc5bzW3GkLjF97UzgLQ
         W51gn6nkgHP70DobnbhQJMPmP/kZKlZjsE3s0jTxfxS9YoPOmvDro9pbrQmtu/wa3Y
         6XH+XJd0q5VeA==
From:   Josh Poimboeuf <jpoimboe@kernel.org>
To:     x86@kernel.org
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Mark Rutland <mark.rutland@arm.com>,
        live-patching@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 3/6] objtool: Change UNWIND_HINT() argument order
Date:   Wed,  1 Mar 2023 07:13:09 -0800
Message-Id: <d994f8c29376c5618c75698df28fc03b52d3a868.1677683419.git.jpoimboe@kernel.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <cover.1677683419.git.jpoimboe@kernel.org>
References: <cover.1677683419.git.jpoimboe@kernel.org>
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

The most important argument is 'type', make that one first.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 arch/x86/include/asm/unwind_hints.h | 2 +-
 include/linux/objtool.h             | 5 ++---
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/unwind_hints.h b/arch/x86/include/asm/unwind_hints.h
index e7c71750b309..97b392217c0f 100644
--- a/arch/x86/include/asm/unwind_hints.h
+++ b/arch/x86/include/asm/unwind_hints.h
@@ -67,7 +67,7 @@
 #else
 
 #define UNWIND_HINT_FUNC \
-	UNWIND_HINT(ORC_REG_SP, 8, UNWIND_HINT_TYPE_FUNC, 0, 0)
+	UNWIND_HINT(UNWIND_HINT_TYPE_FUNC, ORC_REG_SP, 8, 0, 0)
 
 #endif /* __ASSEMBLY__ */
 
diff --git a/include/linux/objtool.h b/include/linux/objtool.h
index 2b0258d273fc..725d7f0b6748 100644
--- a/include/linux/objtool.h
+++ b/include/linux/objtool.h
@@ -10,7 +10,7 @@
 
 #ifndef __ASSEMBLY__
 
-#define UNWIND_HINT(sp_reg, sp_offset, type, signal, end)	\
+#define UNWIND_HINT(type, sp_reg, sp_offset, signal, end)	\
 	"987: \n\t"						\
 	".pushsection .discard.unwind_hints\n\t"		\
 	/* struct unwind_hint */				\
@@ -137,8 +137,7 @@
 
 #ifndef __ASSEMBLY__
 
-#define UNWIND_HINT(sp_reg, sp_offset, type, signal, end) \
-	"\n\t"
+#define UNWIND_HINT(type, sp_reg, sp_offset, signal, end) "\n\t"
 #define STACK_FRAME_NON_STANDARD(func)
 #define STACK_FRAME_NON_STANDARD_FP(func)
 #define ANNOTATE_NOENDBR
-- 
2.39.1

