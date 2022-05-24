Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B46A5531FAA
	for <lists+live-patching@lfdr.de>; Tue, 24 May 2022 02:17:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231881AbiEXARL (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 23 May 2022 20:17:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231866AbiEXARG (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 23 May 2022 20:17:06 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7BA0F7356E;
        Mon, 23 May 2022 17:16:57 -0700 (PDT)
Received: from x64host.home (unknown [47.189.24.195])
        by linux.microsoft.com (Postfix) with ESMTPSA id 840BF20B8961;
        Mon, 23 May 2022 17:16:56 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 840BF20B8961
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1653351417;
        bh=R+hlXlIgmzD2z81ekWg5REk7Zg6/92uCUr3rLRNg/rg=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=QAAfP8w12GLVb9uPNNedsIVKNCQj6aLqSkeHejW1GXkuc4iLXRtACFewvA5oBKo+/
         d/uWxOfrtdguU0ytD3rjVxdOpumo2FbWjhfnqCwQLdqUaBe1mPIBbH42pQ5uVK0CGL
         rmuUO+gvuvU2BmRtg5gtEOMec8dRs6SzyF7EwiuM=
From:   madvenka@linux.microsoft.com
To:     jpoimboe@redhat.com, peterz@infradead.org, chenzhongjin@huawei.com,
        mark.rutland@arm.com, broonie@kernel.org, nobuta.keiya@fujitsu.com,
        sjitindarsingh@gmail.com, catalin.marinas@arm.com, will@kernel.org,
        jamorris@linux.microsoft.com, linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        madvenka@linux.microsoft.com
Subject: [RFC PATCH v2 10/20] objtool: arm64: Compute destinations for call and jump instructions
Date:   Mon, 23 May 2022 19:16:27 -0500
Message-Id: <20220524001637.1707472-11-madvenka@linux.microsoft.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220524001637.1707472-1-madvenka@linux.microsoft.com>
References: <e81e773678f88f7c2ff7480e2eb096973ec198db>
 <20220524001637.1707472-1-madvenka@linux.microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-19.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>

Compute the destination address of each call and jump instruction after
decoding all the instructions.

Signed-off-by: Madhavan T. Venkataraman <madvenka@linux.microsoft.com>
---
 tools/objtool/arch/arm64/decode.c | 12 ++++++++
 tools/objtool/fpv.c               | 47 ++++++++++++++++++++++++++++++-
 2 files changed, 58 insertions(+), 1 deletion(-)

diff --git a/tools/objtool/arch/arm64/decode.c b/tools/objtool/arch/arm64/decode.c
index 8a9ff030085d..f9df8b321659 100644
--- a/tools/objtool/arch/arm64/decode.c
+++ b/tools/objtool/arch/arm64/decode.c
@@ -33,6 +33,18 @@ struct decode {
 				s64 *imm, struct list_head *stack_ops);
 };
 
+/* --------------------- arch support functions ------------------------- */
+
+unsigned long arch_dest_reloc_offset(int addend)
+{
+	return addend;
+}
+
+unsigned long arch_jump_destination(struct instruction *insn)
+{
+	return insn->offset + insn->immediate;
+}
+
 /* --------------------- miscellaneous functions --------------------------- */
 
 static void reg_check(unsigned int sp_check, unsigned int fp_check,
diff --git a/tools/objtool/fpv.c b/tools/objtool/fpv.c
index 76f0f2e611a8..92ad0d0aac8e 100644
--- a/tools/objtool/fpv.c
+++ b/tools/objtool/fpv.c
@@ -13,7 +13,52 @@
 #include <objtool/insn.h>
 #include <objtool/warn.h>
 
+/*
+ * Find the destination instructions for all jumps.
+ */
+static void add_jump_destinations(struct objtool_file *file)
+{
+	struct instruction *insn;
+	struct reloc *reloc;
+	struct section *dest_sec;
+	unsigned long dest_off;
+
+	for_each_insn(file, insn) {
+		if (insn->type != INSN_CALL &&
+		    insn->type != INSN_JUMP_CONDITIONAL &&
+		    insn->type != INSN_JUMP_UNCONDITIONAL) {
+			continue;
+		}
+
+		reloc = insn_reloc(file, insn);
+		if (!reloc) {
+			dest_sec = insn->sec;
+			dest_off = arch_jump_destination(insn);
+		} else if (reloc->sym->type == STT_SECTION) {
+			dest_sec = reloc->sym->sec;
+			dest_off = arch_dest_reloc_offset(reloc->addend);
+		} else if (reloc->sym->sec->idx) {
+			dest_sec = reloc->sym->sec;
+			dest_off = reloc->sym->sym.st_value +
+				   arch_dest_reloc_offset(reloc->addend);
+		} else {
+			/* non-func asm code jumping to another file */
+			continue;
+		}
+
+		insn->jump_dest = find_insn(file, dest_sec, dest_off);
+	}
+}
+
 int fpv_decode(struct objtool_file *file)
 {
-	return decode_instructions(file);
+	int ret;
+
+	ret = decode_instructions(file);
+	if (ret)
+		return ret;
+
+	add_jump_destinations(file);
+
+	return 0;
 }
-- 
2.25.1

