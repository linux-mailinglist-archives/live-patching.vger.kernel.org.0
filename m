Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37BD8531FB3
	for <lists+live-patching@lfdr.de>; Tue, 24 May 2022 02:17:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232308AbiEXARi (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 23 May 2022 20:17:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231890AbiEXARM (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 23 May 2022 20:17:12 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id EC51E8FD62;
        Mon, 23 May 2022 17:17:03 -0700 (PDT)
Received: from x64host.home (unknown [47.189.24.195])
        by linux.microsoft.com (Postfix) with ESMTPSA id 860F520B87F3;
        Mon, 23 May 2022 17:17:02 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 860F520B87F3
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1653351423;
        bh=noSnCslKB9fq6Jf14ZT65t1WySif9JO6D3Dr/3SMpII=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=a6zAzEx/ijezFj5miAVlU0T+oHhC3mhtty4wPz5a2txcX8dCzGuYWO5BmypAhLcDz
         pfmjTlOHui8ZtBFm3whzL6Pu1pFdgPbEXj+TC8Ozg2rWLpR/549XSTj5MApKh2aTjK
         t1mDUmpa6P++0NrSzoCjr6EvQY9fBmCt/ir2FZEA=
From:   madvenka@linux.microsoft.com
To:     jpoimboe@redhat.com, peterz@infradead.org, chenzhongjin@huawei.com,
        mark.rutland@arm.com, broonie@kernel.org, nobuta.keiya@fujitsu.com,
        sjitindarsingh@gmail.com, catalin.marinas@arm.com, will@kernel.org,
        jamorris@linux.microsoft.com, linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        madvenka@linux.microsoft.com
Subject: [RFC PATCH v2 16/20] arm64: Add kernel and module support for ORC
Date:   Mon, 23 May 2022 19:16:33 -0500
Message-Id: <20220524001637.1707472-17-madvenka@linux.microsoft.com>
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
index f2d4bb14bfab..d5ca2fa13156 100644
--- a/arch/arm64/kernel/module.c
+++ b/arch/arm64/kernel/module.c
@@ -19,6 +19,7 @@
 #include <asm/alternative.h>
 #include <asm/insn.h>
 #include <asm/sections.h>
+#include <asm-generic/orc_lookup.h>
 
 void *module_alloc(unsigned long size)
 {
@@ -524,10 +525,20 @@ int module_finalize(const Elf_Ehdr *hdr,
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
index 3505789cf4bd..9094b941f6ed 100644
--- a/arch/arm64/kernel/setup.c
+++ b/arch/arm64/kernel/setup.c
@@ -51,6 +51,7 @@
 #include <asm/efi.h>
 #include <asm/xen/hypervisor.h>
 #include <asm/mmu_context.h>
+#include <asm-generic/orc_lookup.h>
 
 static int num_standard_resources;
 static struct resource *standard_resources;
@@ -389,6 +390,7 @@ void __init __no_sanitize_address setup_arch(char **cmdline_p)
 			"This indicates a broken bootloader or old kernel\n",
 			boot_args[1], boot_args[2], boot_args[3]);
 	}
+	orc_lookup_init();
 }
 
 static inline bool cpu_can_disable(unsigned int cpu)
-- 
2.25.1

