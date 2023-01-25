Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49B9967A94D
	for <lists+live-patching@lfdr.de>; Wed, 25 Jan 2023 04:38:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234171AbjAYDiY (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 24 Jan 2023 22:38:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229534AbjAYDiX (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 24 Jan 2023 22:38:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E569E39E;
        Tue, 24 Jan 2023 19:38:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4BF73B81894;
        Wed, 25 Jan 2023 03:38:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA63EC4339B;
        Wed, 25 Jan 2023 03:38:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674617891;
        bh=ruVwyKu5r4Ho2K3Po1rwNTyU1GonlvOJe83MwngFuEc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QQ5MUOhZsTGTNvx7meE+NywZEQQIvOZZka611CH+C5ghKPCbcIScqQ2e+k1N4h/vy
         Bc8eHDGq19u7fMKXy/f5BsHXtm8MxeAVAqamvYn7GDTbpKj6FIitkVWiNZiPNYJHOz
         UcHudz0NMmCYZcV3+45a0E9FISyJrgUnrJs30QzyeK79da3K7qdSDw0Y+gXPMfQCnM
         TCqRQdXphPGuN/bvq/VkvzMPDN77GbcRzG8sFnOzMsLzm7vA7+jH1hbOfxXapiAXyL
         Z2OFRHjhIpvbAJ2Wc1AJXhpu2ZvbowIKuJlC8labNnEkDlnPT0xqBjAarIwBFMJ0Q1
         MH55q5qylN0lw==
From:   Josh Poimboeuf <jpoimboe@kernel.org>
To:     Michael Ellerman <mpe@ellerman.id.au>
Cc:     live-patching@vger.kernel.org, Nicholas Piggin <npiggin@gmail.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Song Liu <song@kernel.org>
Subject: [PATCH 1/2] powerpc/module_64: Improve restore_r2() return semantics
Date:   Tue, 24 Jan 2023 19:38:04 -0800
Message-Id: <15baf76c271a0ae09f7b8556e50f2b4251e7049d.1674617130.git.jpoimboe@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <cover.1674617130.git.jpoimboe@kernel.org>
References: <cover.1674617130.git.jpoimboe@kernel.org>
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

restore_r2() returns 1 on success, which is surprising for a non-boolean
function.  Change it to return 0 on success and -errno on error to match
kernel coding convention.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 arch/powerpc/kernel/module_64.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/arch/powerpc/kernel/module_64.c b/arch/powerpc/kernel/module_64.c
index 1096d6b3a62c..016e79bba531 100644
--- a/arch/powerpc/kernel/module_64.c
+++ b/arch/powerpc/kernel/module_64.c
@@ -504,7 +504,7 @@ static int restore_r2(const char *name, u32 *instruction, struct module *me)
 	u32 *prev_insn = instruction - 1;
 
 	if (is_mprofile_ftrace_call(name))
-		return 1;
+		return 0;
 
 	/*
 	 * Make sure the branch isn't a sibling call.  Sibling calls aren't
@@ -512,19 +512,16 @@ static int restore_r2(const char *name, u32 *instruction, struct module *me)
 	 * restore afterwards.
 	 */
 	if (!instr_is_relative_link_branch(ppc_inst(*prev_insn)))
-		return 1;
+		return 0;
 
 	if (*instruction != PPC_RAW_NOP()) {
 		pr_err("%s: Expected nop after call, got %08x at %pS\n",
 			me->name, *instruction, instruction);
-		return 0;
+		return -ENOEXEC;
 	}
 
 	/* ld r2,R2_STACK_OFFSET(r1) */
-	if (patch_instruction(instruction, ppc_inst(PPC_INST_LD_TOC)))
-		return 0;
-
-	return 1;
+	return patch_instruction(instruction, ppc_inst(PPC_INST_LD_TOC));
 }
 
 int apply_relocate_add(Elf64_Shdr *sechdrs,
@@ -648,8 +645,8 @@ int apply_relocate_add(Elf64_Shdr *sechdrs,
 						strtab + sym->st_name);
 				if (!value)
 					return -ENOENT;
-				if (!restore_r2(strtab + sym->st_name,
-							(u32 *)location + 1, me))
+				if (restore_r2(strtab + sym->st_name,
+					       (u32 *)location + 1, me))
 					return -ENOEXEC;
 			} else
 				value += local_entry_offset(sym);
-- 
2.39.0

