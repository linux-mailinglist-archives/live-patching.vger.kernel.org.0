Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3831687697
	for <lists+live-patching@lfdr.de>; Thu,  2 Feb 2023 08:43:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232018AbjBBHnB (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 2 Feb 2023 02:43:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232014AbjBBHmw (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 2 Feb 2023 02:42:52 -0500
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E2E50841BE;
        Wed,  1 Feb 2023 23:42:37 -0800 (PST)
Received: from x64host.home (unknown [47.187.213.40])
        by linux.microsoft.com (Postfix) with ESMTPSA id A6A1320B9D4D;
        Wed,  1 Feb 2023 23:42:36 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com A6A1320B9D4D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1675323757;
        bh=4Oz2+1ZYx7D5K7SknLE3Ah83SAKi4AO9HhOoR9/v50Y=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=ereOmhQVPKXkr6Q/wbie7EuTjecB1QvtMyAGoNimgY3RtObxfhUPlePkFXkuXUT0k
         701f0VmYEOI0ApYjBEhQXQ8Mrjmmdfp3fiQZhxf7dlMeg1vqyw7PLO2b/f5ep3pBSx
         CC3U1QdNyRfpM+E0zs2igZ0BxDGco7KBj6reMcUI=
From:   madvenka@linux.microsoft.com
To:     jpoimboe@redhat.com, peterz@infradead.org, chenzhongjin@huawei.com,
        mark.rutland@arm.com, broonie@kernel.org, nobuta.keiya@fujitsu.com,
        sjitindarsingh@gmail.com, catalin.marinas@arm.com, will@kernel.org,
        jamorris@linux.microsoft.com, linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        madvenka@linux.microsoft.com
Subject: [RFC PATCH v3 12/22] objtool: arm64: Compute destinations for call and jump instructions
Date:   Thu,  2 Feb 2023 01:40:26 -0600
Message-Id: <20230202074036.507249-13-madvenka@linux.microsoft.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230202074036.507249-1-madvenka@linux.microsoft.com>
References: <0337266cf19f4c98388e3f6d09f590d9de258dc7>
 <20230202074036.507249-1-madvenka@linux.microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-19.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
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
 tools/objtool/dcheck.c            | 47 ++++++++++++++++++++++++++++++-
 2 files changed, 58 insertions(+), 1 deletion(-)

diff --git a/tools/objtool/arch/arm64/decode.c b/tools/objtool/arch/arm64/decode.c
index aaae16791807..81653ed3c323 100644
--- a/tools/objtool/arch/arm64/decode.c
+++ b/tools/objtool/arch/arm64/decode.c
@@ -20,6 +20,18 @@
 /* ARM64 instructions are all 4 bytes wide. */
 #define INSN_SIZE	4
 
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
 /* --------------------- instruction decode structs ------------------------ */
 
 struct decode_var {
diff --git a/tools/objtool/dcheck.c b/tools/objtool/dcheck.c
index cd2700153408..eb806a032a32 100644
--- a/tools/objtool/dcheck.c
+++ b/tools/objtool/dcheck.c
@@ -12,10 +12,55 @@
 #include <objtool/builtin.h>
 #include <objtool/insn.h>
 
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
 int check(struct objtool_file *file)
 {
+	int ret;
+
 	if (!opts.stackval)
 		return 1;
 
-	return decode_instructions(file);
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

