Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30B376876A4
	for <lists+live-patching@lfdr.de>; Thu,  2 Feb 2023 08:43:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229618AbjBBHnh (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 2 Feb 2023 02:43:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232034AbjBBHnR (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 2 Feb 2023 02:43:17 -0500
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C5DAB757BC;
        Wed,  1 Feb 2023 23:42:42 -0800 (PST)
Received: from x64host.home (unknown [47.187.213.40])
        by linux.microsoft.com (Postfix) with ESMTPSA id 9BD7020B2EE3;
        Wed,  1 Feb 2023 23:42:41 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 9BD7020B2EE3
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1675323762;
        bh=ja7iCXZAYSBOw6CRsMiBOuCjJ6dS1/OpL4Jd5Usm8GU=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=AxPvm8rrHwawA3/KKIY7ZxCMnGqba6n07XjZ9NbXNZbZs3YZAyo4jdIfvP/Z9+TaN
         NQljocc3i94+iHdRznNOca41Vm/vOTmQeQ95hKo9MIe3KwdU5c9dBEDoUOyRkyXXFr
         eDWGS+0t8/WS7HFhWMHvZRSRkBDpcoLMdCCRk1u4=
From:   madvenka@linux.microsoft.com
To:     jpoimboe@redhat.com, peterz@infradead.org, chenzhongjin@huawei.com,
        mark.rutland@arm.com, broonie@kernel.org, nobuta.keiya@fujitsu.com,
        sjitindarsingh@gmail.com, catalin.marinas@arm.com, will@kernel.org,
        jamorris@linux.microsoft.com, linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        madvenka@linux.microsoft.com
Subject: [RFC PATCH v3 17/22] arm64: Add kernel and module support for ORC
Date:   Thu,  2 Feb 2023 01:40:31 -0600
Message-Id: <20230202074036.507249-18-madvenka@linux.microsoft.com>
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

Call orc_lookup_init() from setup_arch() to perform ORC lookup
initialization for vmlinux.

Call orc_lookup_module_init() in module load to perform ORC lookup
initialization for modules.

Signed-off-by: Madhavan T. Venkataraman <madvenka@linux.microsoft.com>
---
 arch/arm64/kernel/module.c | 13 ++++++++++++-
 arch/arm64/kernel/setup.c  |  2 ++
 2 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kernel/module.c b/arch/arm64/kernel/module.c
index 76b41e4ca9fa..71264a181f61 100644
--- a/arch/arm64/kernel/module.c
+++ b/arch/arm64/kernel/module.c
@@ -19,6 +19,7 @@
 #include <asm/alternative.h>
 #include <asm/insn.h>
 #include <asm/sections.h>
+#include <asm-generic/orc_lookup.h>
 
 void *module_alloc(unsigned long size)
 {
@@ -509,10 +510,20 @@ int module_finalize(const Elf_Ehdr *hdr,
 		    const Elf_Shdr *sechdrs,
 		    struct module *me)
 {
-	const Elf_Shdr *s;
+	const Elf_Shdr *s, *orc, *orc_ip;
+
 	s = find_section(hdr, sechdrs, ".altinstructions");
 	if (s)
 		apply_alternatives_module((void *)s->sh_addr, s->sh_size);
 
+	orc = find_section(hdr, sechdrs, ".orc_unwind");
+	orc_ip = find_section(hdr, sechdrs, ".orc_unwind_ip");
+
+	if (orc && orc_ip) {
+		orc_lookup_module_init(me,
+				       (void *)orc_ip->sh_addr, orc_ip->sh_size,
+				       (void *)orc->sh_addr, orc->sh_size);
+	}
+
 	return module_init_ftrace_plt(hdr, sechdrs, me);
 }
diff --git a/arch/arm64/kernel/setup.c b/arch/arm64/kernel/setup.c
index fea3223704b6..360304dcd8c2 100644
--- a/arch/arm64/kernel/setup.c
+++ b/arch/arm64/kernel/setup.c
@@ -51,6 +51,7 @@
 #include <asm/efi.h>
 #include <asm/xen/hypervisor.h>
 #include <asm/mmu_context.h>
+#include <asm-generic/orc_lookup.h>
 
 static int num_standard_resources;
 static struct resource *standard_resources;
@@ -378,6 +379,7 @@ void __init __no_sanitize_address setup_arch(char **cmdline_p)
 			"This indicates a broken bootloader or old kernel\n",
 			boot_args[1], boot_args[2], boot_args[3]);
 	}
+	orc_lookup_init();
 }
 
 static inline bool cpu_can_disable(unsigned int cpu)
-- 
2.25.1

