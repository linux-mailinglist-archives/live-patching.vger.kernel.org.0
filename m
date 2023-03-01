Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FC186A6F1B
	for <lists+live-patching@lfdr.de>; Wed,  1 Mar 2023 16:14:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230126AbjCAPOt (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 1 Mar 2023 10:14:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230151AbjCAPOr (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 1 Mar 2023 10:14:47 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34E493D0A1
        for <live-patching@vger.kernel.org>; Wed,  1 Mar 2023 07:14:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D9F38B81081
        for <live-patching@vger.kernel.org>; Wed,  1 Mar 2023 15:14:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40C40C433A4;
        Wed,  1 Mar 2023 15:14:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677683677;
        bh=Rnt+TI16y2hPxUoK601ZHD46yqG2wtFz8qu5btMmC7U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BGh0AZc/nM3qppYbTgNvUGMAaCIoulW0EIUxq/W2HERjz+Vs9MLyUWGfYed7n4+R8
         V2rzIUuyIcxSbyeuf17E2dRBMU8eicoqE5jWdKxx+1OPNUdScGUWAEUklGLg57zX42
         a3MNxzyowX0bp22k75XUZ1bZM+b7NMHER3XlNuKx68pwNzmf/xe4SVFcnVTUUCsJ5i
         ElzLx8TWn0LUFLIDIwFEvIC+Sp55pC5YuTZIeUFXsao7iesTeJxO+LR648iY3qA8uA
         dnifPdXybGyxm+93ou1vIAbmDd1oehSIO3vSwAqYI7mxfAIRvIL+LfnaEqx0O3kGop
         acqFftjYsJWBA==
From:   Josh Poimboeuf <jpoimboe@kernel.org>
To:     x86@kernel.org
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Mark Rutland <mark.rutland@arm.com>,
        live-patching@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 2/6] objtool: Use relative pointers for annotations
Date:   Wed,  1 Mar 2023 07:13:08 -0800
Message-Id: <bed05c64e28200220c9b1754a2f3ce71f73076ea.1677683419.git.jpoimboe@kernel.org>
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

They produce the needed relocations while using half the space.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 arch/x86/include/asm/nospec-branch.h |  6 +++---
 include/linux/objtool.h              | 12 ++++++------
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/arch/x86/include/asm/nospec-branch.h b/arch/x86/include/asm/nospec-branch.h
index 3ef70e54a858..78ed1546b775 100644
--- a/arch/x86/include/asm/nospec-branch.h
+++ b/arch/x86/include/asm/nospec-branch.h
@@ -194,9 +194,9 @@
  * builds.
  */
 .macro ANNOTATE_RETPOLINE_SAFE
-	.Lannotate_\@:
+.Lhere_\@:
 	.pushsection .discard.retpoline_safe
-	_ASM_PTR .Lannotate_\@
+	.long .Lhere_\@ - .
 	.popsection
 .endm
 
@@ -318,7 +318,7 @@
 #define ANNOTATE_RETPOLINE_SAFE					\
 	"999:\n\t"						\
 	".pushsection .discard.retpoline_safe\n\t"		\
-	_ASM_PTR " 999b\n\t"					\
+	".long 999b - .\n\t"					\
 	".popsection\n\t"
 
 typedef u8 retpoline_thunk_t[RETPOLINE_THUNK_SIZE];
diff --git a/include/linux/objtool.h b/include/linux/objtool.h
index 8375792acfc0..2b0258d273fc 100644
--- a/include/linux/objtool.h
+++ b/include/linux/objtool.h
@@ -49,7 +49,7 @@
 #define ANNOTATE_NOENDBR					\
 	"986: \n\t"						\
 	".pushsection .discard.noendbr\n\t"			\
-	_ASM_PTR " 986b\n\t"					\
+	".long 986b - .\n\t"					\
 	".popsection\n\t"
 
 #define ASM_REACHABLE							\
@@ -67,7 +67,7 @@
 #define ANNOTATE_INTRA_FUNCTION_CALL				\
 	999:							\
 	.pushsection .discard.intra_function_calls;		\
-	.long 999b;						\
+	.long 999b - .;						\
 	.popsection;
 
 /*
@@ -92,10 +92,10 @@
  * inconsistencies.
  */
 .macro UNWIND_HINT type:req sp_reg=0 sp_offset=0 signal=0 end=0
-.Lunwind_hint_ip_\@:
+.Lhere_\@:
 	.pushsection .discard.unwind_hints
 		/* struct unwind_hint */
-		.long .Lunwind_hint_ip_\@ - .
+		.long .Lhere_\@ - .
 		.short \sp_offset
 		.byte \sp_reg
 		.byte \type
@@ -107,7 +107,7 @@
 
 .macro STACK_FRAME_NON_STANDARD func:req
 	.pushsection .discard.func_stack_frame_non_standard, "aw"
-	_ASM_PTR \func
+	.long \func - .
 	.popsection
 .endm
 
@@ -120,7 +120,7 @@
 .macro ANNOTATE_NOENDBR
 .Lhere_\@:
 	.pushsection .discard.noendbr
-	.quad	.Lhere_\@
+	.long	.Lhere_\@ - .
 	.popsection
 .endm
 
-- 
2.39.1

