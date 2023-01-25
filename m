Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 860F267A94C
	for <lists+live-patching@lfdr.de>; Wed, 25 Jan 2023 04:38:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231281AbjAYDiX (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 24 Jan 2023 22:38:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233279AbjAYDiW (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 24 Jan 2023 22:38:22 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7085CCA26;
        Tue, 24 Jan 2023 19:38:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ED74D61444;
        Wed, 25 Jan 2023 03:38:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A1AAC433A0;
        Wed, 25 Jan 2023 03:38:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674617892;
        bh=7M3ieHPKjncgevNaIxm++BYHAAhc0S9LqYRA8tUI6Pc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P9J1452odLsdx9doxYgTkxrLdCcOxbiWEcNN3c1SS4mdkU1oxRzvV4a4XV/0BbQ9l
         SBxFaspcH9MniyYLQbBXgGXc/40u0BVnlosMkZ59hGsQD2ZtlCSgjxkQ6YRqMLPlSZ
         PrGLsThlzNCrIgruY4wNOh2EKMnjXOqodtyk565vVkwRA9c3ZM9fgB+A5DldgqdSYt
         tQw6v6Rp0lqJA5umtMy0jcsmp3utJc6DJPUHg7Qip/IOYG6z7+TqLVowgk8ynnZS3N
         8r+3N4ZEqgI0VoBXDnvPlvm6BvZES1t+sHzbRcI1WtgVfxlZ53ysJD7yxDpif/2MR6
         Y9i+Oqrub8C7Q==
From:   Josh Poimboeuf <jpoimboe@kernel.org>
To:     Michael Ellerman <mpe@ellerman.id.au>
Cc:     live-patching@vger.kernel.org, Nicholas Piggin <npiggin@gmail.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Song Liu <song@kernel.org>
Subject: [PATCH 2/2] powerpc/module_64: Fix "expected nop" error on module re-patching
Date:   Tue, 24 Jan 2023 19:38:05 -0800
Message-Id: <2f6329ffd9674df6ff57e03edeb2ca54414770ab.1674617130.git.jpoimboe@kernel.org>
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

When a module with a livepatched function is unloaded and then reloaded,
klp attempts to dynamically re-patch it.  On ppc64, that fails with the
following error:

  module_64: livepatch_nfsd: Expected nop after call, got e8410018 at e_show+0x60/0x548 [livepatch_nfsd]
  livepatch: failed to initialize patch 'livepatch_nfsd' for module 'nfsd' (-8)
  livepatch: patch 'livepatch_nfsd' failed for module 'nfsd', refusing to load module 'nfsd'

The error happens because the restore r2 instruction had already
previously been written into the klp module's replacement function when
the original function was patched the first time.  So the instruction
wasn't a nop as expected.

When the restore r2 instruction has already been patched in, detect that
and skip the warning and the instruction write.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 arch/powerpc/kernel/module_64.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/kernel/module_64.c b/arch/powerpc/kernel/module_64.c
index 016e79bba531..bf1da99fff74 100644
--- a/arch/powerpc/kernel/module_64.c
+++ b/arch/powerpc/kernel/module_64.c
@@ -502,6 +502,7 @@ static unsigned long stub_for_addr(const Elf64_Shdr *sechdrs,
 static int restore_r2(const char *name, u32 *instruction, struct module *me)
 {
 	u32 *prev_insn = instruction - 1;
+	u32 insn_val = *instruction;
 
 	if (is_mprofile_ftrace_call(name))
 		return 0;
@@ -514,9 +515,18 @@ static int restore_r2(const char *name, u32 *instruction, struct module *me)
 	if (!instr_is_relative_link_branch(ppc_inst(*prev_insn)))
 		return 0;
 
-	if (*instruction != PPC_RAW_NOP()) {
+	/*
+	 * For livepatch, the restore r2 instruction might have already been
+	 * written previously, if the referenced symbol is in a previously
+	 * unloaded module which is now being loaded again.  In that case, skip
+	 * the warning and the instruction write.
+	 */
+	if (insn_val == PPC_INST_LD_TOC)
+		return 0;
+
+	if (insn_val != PPC_RAW_NOP()) {
 		pr_err("%s: Expected nop after call, got %08x at %pS\n",
-			me->name, *instruction, instruction);
+			me->name, insn_val, instruction);
 		return -ENOEXEC;
 	}
 
-- 
2.39.0

