Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FB9F6A6F17
	for <lists+live-patching@lfdr.de>; Wed,  1 Mar 2023 16:14:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229577AbjCAPOo (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 1 Mar 2023 10:14:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229563AbjCAPOn (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 1 Mar 2023 10:14:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D7693D90C
        for <live-patching@vger.kernel.org>; Wed,  1 Mar 2023 07:14:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D1F79613B3
        for <live-patching@vger.kernel.org>; Wed,  1 Mar 2023 15:14:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 082ECC4339B;
        Wed,  1 Mar 2023 15:14:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677683678;
        bh=gJOqYHdS6PhSgN8sTTyX9FIyQvNjdUAMHzpXVF7gTTY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BxsxP979cgu8Zi1tAMTMVSR/TylmuGXkuR6gAC/AinNLmHHb77yyObj3OuSla6Tb2
         JieAtAW3Twi8tCeuoUd62rFA6llD/OxyLK4rxOpRyjnE7sT3urNOlfuS5jTwBYcy9F
         BzmCr3PU0ciAJ5zSdN4KlHHfx0+HQ6WfuO86Xlbez87ImP1RPOQaVUE4prPRwaeo1w
         NzCQ5cbqsv4EN9D/obQLVCb33Y7PY06yj9VHGAD05rbf+SmhGxZ0sk6gWWWm4ICvOG
         gYyCnYvtkGknulLqLc9XJrr5V2DjRxCQ4lOmGxqiaN4XmCZxetnT8KHyLMpFc9kQoG
         k3FDNHSLpk1Zg==
From:   Josh Poimboeuf <jpoimboe@kernel.org>
To:     x86@kernel.org
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Mark Rutland <mark.rutland@arm.com>,
        live-patching@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 4/6] x86,objtool: Introduce ORC_TYPE_*
Date:   Wed,  1 Mar 2023 07:13:10 -0800
Message-Id: <cc879d38fff8a43f8f7beb2fd56e35a5a384d7cd.1677683419.git.jpoimboe@kernel.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <cover.1677683419.git.jpoimboe@kernel.org>
References: <cover.1677683419.git.jpoimboe@kernel.org>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_FILL_THIS_FORM_SHORT autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Unwind hints and ORC entry types are two distinct things.  Separate them
out more explicitly.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 arch/x86/include/asm/orc_types.h       |  4 ++++
 arch/x86/kernel/unwind_orc.c           | 12 ++++++------
 include/linux/objtool_types.h          |  1 +
 tools/arch/x86/include/asm/orc_types.h |  4 ++++
 tools/include/linux/objtool_types.h    |  1 +
 tools/objtool/orc_dump.c               |  7 +++----
 tools/objtool/orc_gen.c                | 19 +++++++++++++++++--
 7 files changed, 36 insertions(+), 12 deletions(-)

diff --git a/arch/x86/include/asm/orc_types.h b/arch/x86/include/asm/orc_types.h
index 1343a62106de..b4d4ec78589e 100644
--- a/arch/x86/include/asm/orc_types.h
+++ b/arch/x86/include/asm/orc_types.h
@@ -39,6 +39,10 @@
 #define ORC_REG_SP_INDIRECT		9
 #define ORC_REG_MAX			15
 
+#define ORC_TYPE_CALL			0
+#define ORC_TYPE_REGS			1
+#define ORC_TYPE_REGS_PARTIAL		2
+
 #ifndef __ASSEMBLY__
 #include <asm/byteorder.h>
 
diff --git a/arch/x86/kernel/unwind_orc.c b/arch/x86/kernel/unwind_orc.c
index 37307b40f8da..8348ac581de3 100644
--- a/arch/x86/kernel/unwind_orc.c
+++ b/arch/x86/kernel/unwind_orc.c
@@ -133,7 +133,7 @@ static struct orc_entry null_orc_entry = {
 	.sp_offset = sizeof(long),
 	.sp_reg = ORC_REG_SP,
 	.bp_reg = ORC_REG_UNDEFINED,
-	.type = UNWIND_HINT_TYPE_CALL
+	.type = ORC_TYPE_CALL
 };
 
 #ifdef CONFIG_CALL_THUNKS
@@ -153,7 +153,7 @@ static struct orc_entry *orc_callthunk_find(unsigned long ip)
 
 /* Fake frame pointer entry -- used as a fallback for generated code */
 static struct orc_entry orc_fp_entry = {
-	.type		= UNWIND_HINT_TYPE_CALL,
+	.type		= ORC_TYPE_CALL,
 	.sp_reg		= ORC_REG_BP,
 	.sp_offset	= 16,
 	.bp_reg		= ORC_REG_PREV_SP,
@@ -554,7 +554,7 @@ bool unwind_next_frame(struct unwind_state *state)
 
 	/* Find IP, SP and possibly regs: */
 	switch (orc->type) {
-	case UNWIND_HINT_TYPE_CALL:
+	case ORC_TYPE_CALL:
 		ip_p = sp - sizeof(long);
 
 		if (!deref_stack_reg(state, ip_p, &state->ip))
@@ -567,7 +567,7 @@ bool unwind_next_frame(struct unwind_state *state)
 		state->prev_regs = NULL;
 		break;
 
-	case UNWIND_HINT_TYPE_REGS:
+	case ORC_TYPE_REGS:
 		if (!deref_stack_regs(state, sp, &state->ip, &state->sp)) {
 			orc_warn_current("can't access registers at %pB\n",
 					 (void *)orig_ip);
@@ -590,13 +590,13 @@ bool unwind_next_frame(struct unwind_state *state)
 		state->full_regs = true;
 		break;
 
-	case UNWIND_HINT_TYPE_REGS_PARTIAL:
+	case ORC_TYPE_REGS_PARTIAL:
 		if (!deref_stack_iret_regs(state, sp, &state->ip, &state->sp)) {
 			orc_warn_current("can't access iret registers at %pB\n",
 					 (void *)orig_ip);
 			goto err;
 		}
-		/* See UNWIND_HINT_TYPE_REGS case comment. */
+		/* See ORC_TYPE_REGS case comment. */
 		state->ip = unwind_recover_rethook(state, state->ip,
 				(unsigned long *)(state->sp - sizeof(long)));
 
diff --git a/include/linux/objtool_types.h b/include/linux/objtool_types.h
index 8513537a30ed..9a83468c0039 100644
--- a/include/linux/objtool_types.h
+++ b/include/linux/objtool_types.h
@@ -40,6 +40,7 @@ struct unwind_hint {
 #define UNWIND_HINT_TYPE_CALL		0
 #define UNWIND_HINT_TYPE_REGS		1
 #define UNWIND_HINT_TYPE_REGS_PARTIAL	2
+/* The below hint types don't have corresponding ORC types */
 #define UNWIND_HINT_TYPE_FUNC		3
 #define UNWIND_HINT_TYPE_ENTRY		4
 #define UNWIND_HINT_TYPE_SAVE		5
diff --git a/tools/arch/x86/include/asm/orc_types.h b/tools/arch/x86/include/asm/orc_types.h
index 1343a62106de..b4d4ec78589e 100644
--- a/tools/arch/x86/include/asm/orc_types.h
+++ b/tools/arch/x86/include/asm/orc_types.h
@@ -39,6 +39,10 @@
 #define ORC_REG_SP_INDIRECT		9
 #define ORC_REG_MAX			15
 
+#define ORC_TYPE_CALL			0
+#define ORC_TYPE_REGS			1
+#define ORC_TYPE_REGS_PARTIAL		2
+
 #ifndef __ASSEMBLY__
 #include <asm/byteorder.h>
 
diff --git a/tools/include/linux/objtool_types.h b/tools/include/linux/objtool_types.h
index 8513537a30ed..9a83468c0039 100644
--- a/tools/include/linux/objtool_types.h
+++ b/tools/include/linux/objtool_types.h
@@ -40,6 +40,7 @@ struct unwind_hint {
 #define UNWIND_HINT_TYPE_CALL		0
 #define UNWIND_HINT_TYPE_REGS		1
 #define UNWIND_HINT_TYPE_REGS_PARTIAL	2
+/* The below hint types don't have corresponding ORC types */
 #define UNWIND_HINT_TYPE_FUNC		3
 #define UNWIND_HINT_TYPE_ENTRY		4
 #define UNWIND_HINT_TYPE_SAVE		5
diff --git a/tools/objtool/orc_dump.c b/tools/objtool/orc_dump.c
index 9f6c528c26f2..97ecbb8b9034 100644
--- a/tools/objtool/orc_dump.c
+++ b/tools/objtool/orc_dump.c
@@ -4,7 +4,6 @@
  */
 
 #include <unistd.h>
-#include <linux/objtool_types.h>
 #include <asm/orc_types.h>
 #include <objtool/objtool.h>
 #include <objtool/warn.h>
@@ -39,11 +38,11 @@ static const char *reg_name(unsigned int reg)
 static const char *orc_type_name(unsigned int type)
 {
 	switch (type) {
-	case UNWIND_HINT_TYPE_CALL:
+	case ORC_TYPE_CALL:
 		return "call";
-	case UNWIND_HINT_TYPE_REGS:
+	case ORC_TYPE_REGS:
 		return "regs";
-	case UNWIND_HINT_TYPE_REGS_PARTIAL:
+	case ORC_TYPE_REGS_PARTIAL:
 		return "regs (partial)";
 	default:
 		return "?";
diff --git a/tools/objtool/orc_gen.c b/tools/objtool/orc_gen.c
index f49630a21e0f..e85bbb996f6c 100644
--- a/tools/objtool/orc_gen.c
+++ b/tools/objtool/orc_gen.c
@@ -26,6 +26,22 @@ static int init_orc_entry(struct orc_entry *orc, struct cfi_state *cfi,
 		return 0;
 	}
 
+	switch (cfi->type) {
+	case UNWIND_HINT_TYPE_CALL:
+		orc->type = ORC_TYPE_CALL;
+		break;
+	case UNWIND_HINT_TYPE_REGS:
+		orc->type = ORC_TYPE_REGS;
+		break;
+	case UNWIND_HINT_TYPE_REGS_PARTIAL:
+		orc->type = ORC_TYPE_REGS_PARTIAL;
+		break;
+	default:
+		WARN_FUNC("unknown unwind hint type %d",
+			  insn->sec, insn->offset, cfi->type);
+		return -1;
+	}
+
 	orc->end = cfi->end;
 	orc->signal = cfi->signal;
 
@@ -83,7 +99,6 @@ static int init_orc_entry(struct orc_entry *orc, struct cfi_state *cfi,
 
 	orc->sp_offset = cfi->cfa.offset;
 	orc->bp_offset = bp->offset;
-	orc->type = cfi->type;
 
 	return 0;
 }
@@ -151,7 +166,7 @@ int orc_create(struct objtool_file *file)
 	struct orc_entry null = {
 		.sp_reg  = ORC_REG_UNDEFINED,
 		.bp_reg  = ORC_REG_UNDEFINED,
-		.type    = UNWIND_HINT_TYPE_CALL,
+		.type    = ORC_TYPE_CALL,
 	};
 
 	/* Build a deduplicated list of ORC entries: */
-- 
2.39.1

