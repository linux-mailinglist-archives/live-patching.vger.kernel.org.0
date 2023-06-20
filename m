Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1125F7365EE
	for <lists+live-patching@lfdr.de>; Tue, 20 Jun 2023 10:18:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231837AbjFTISr (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 20 Jun 2023 04:18:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231416AbjFTISp (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 20 Jun 2023 04:18:45 -0400
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D7719127;
        Tue, 20 Jun 2023 01:18:43 -0700 (PDT)
Received: from loongson.cn (unknown [113.200.148.30])
        by gateway (Coremail) with SMTP id _____8CxPuviYJFk1B4HAA--.14548S3;
        Tue, 20 Jun 2023 16:18:42 +0800 (CST)
Received: from bogon.localdomain (unknown [113.200.148.30])
        by localhost.localdomain (Coremail) with SMTP id AQAAf8CxReThYJFkJ3AhAA--.28832S3;
        Tue, 20 Jun 2023 16:18:42 +0800 (CST)
From:   Youling Tang <tangyouling@loongson.cn>
To:     Josh Poimboeuf <jpoimboe@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        madvenka@linux.microsoft.com
Cc:     chenzhongjin@huawei.com, WANG Xuerui <kernel@xen0n.name>,
        Xi Ruoyao <xry111@xry111.site>, live-patching@vger.kernel.org,
        linux-kernel@vger.kernel.org, loongarch@lists.linux.dev,
        tangyouling00@gmail.com, youling.tang@outlook.com
Subject: [RFC PATCH v1 21/23] objtool: Add arch-specific "noreturn" function handling
Date:   Tue, 20 Jun 2023 16:18:30 +0800
Message-Id: <1687249112-2790-2-git-send-email-tangyouling@loongson.cn>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1687249112-2790-1-git-send-email-tangyouling@loongson.cn>
References: <1687249112-2790-1-git-send-email-tangyouling@loongson.cn>
X-CM-TRANSID: AQAAf8CxReThYJFkJ3AhAA--.28832S3
X-CM-SenderInfo: 5wdqw5prxox03j6o00pqjv00gofq/
X-Coremail-Antispam: 1Uk129KBj93XoWxXFyrJrWkWr1kXrW5XF18Zwc_yoW5Kw43pF
        1DC348uFyjga43Jw1UJw15WrW5uw12gry8Kr1jvr9xAr4aq39rtF4Sy3WqvF1Fqw4Fga4I
        yF4S9F4jyFWvvwcCm3ZEXasCq-sJn29KB7ZKAUJUUUU3529EdanIXcx71UUUUU7KY7ZEXa
        sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
        0xBIdaVrnRJUUUPEb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
        IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
        e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
        0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x0267AK
        xVWxJr0_GcWln4kS14v26r126r1DM2AIxVAIcxkEcVAq07x20xvEncxIr21l57IF6xkI12
        xvs2x26I8E6xACxx1l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1q
        6rW5McIj6I8E87Iv67AKxVW8Jr0_Cr1UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvY0x
        0EwIxGrwACjcxG6xCI17CEII8vrVW3JVW8Jr1lc7CjxVAaw2AFwI0_JF0_Jw1l42xK82IY
        c2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1l4IxYO2xFxVAFwI0_JF0_Jw1lx2IqxV
        Aqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q
        6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Gr0_Xr1lIxAIcVC0I7IYx2IY6x
        kF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AK
        xVW8Jr0_Cr1UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr1j6F4UJbIYCTnIWIevJa73UjIFyT
        uYvjxUDdOzDUUUU
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Fix the following warnings:
arch/loongarch/mm/fault.o: warning: objtool: no_context.part.0() falls through to
next function do_sigsegv()

It should mark 'dead_end' when the function is "noreturn/__noreturn".

Signed-off-by: Youling Tang <tangyouling@loongson.cn>
---
 tools/objtool/arch/loongarch/special.c  | 5 +++++
 tools/objtool/arch/powerpc/special.c    | 3 +++
 tools/objtool/arch/x86/special.c        | 4 ++++
 tools/objtool/check.c                   | 7 ++++++-
 tools/objtool/include/objtool/special.h | 3 +++
 5 files changed, 21 insertions(+), 1 deletion(-)

diff --git a/tools/objtool/arch/loongarch/special.c b/tools/objtool/arch/loongarch/special.c
index 8669dbe44459..be4d5d83e331 100644
--- a/tools/objtool/arch/loongarch/special.c
+++ b/tools/objtool/arch/loongarch/special.c
@@ -5,6 +5,11 @@
 #include <objtool/special.h>
 #include <objtool/builtin.h>
 
+/* Architecture specific "noreturn" function */
+const char * const arch_noreturns[] = {
+	"die",
+};
+int arch_noreturns_size = ARRAY_SIZE(arch_noreturns);
 
 bool arch_support_alt_relocation(struct special_alt *special_alt,
 				 struct instruction *insn,
diff --git a/tools/objtool/arch/powerpc/special.c b/tools/objtool/arch/powerpc/special.c
index d33868147196..35107e6ae2f1 100644
--- a/tools/objtool/arch/powerpc/special.c
+++ b/tools/objtool/arch/powerpc/special.c
@@ -4,6 +4,9 @@
 #include <objtool/special.h>
 #include <objtool/builtin.h>
 
+/* Architecture specific "noreturn" function */
+const char * const arch_noreturns[] = {};
+int arch_noreturns_size = ARRAY_SIZE(arch_noreturns);
 
 bool arch_support_alt_relocation(struct special_alt *special_alt,
 				 struct instruction *insn,
diff --git a/tools/objtool/arch/x86/special.c b/tools/objtool/arch/x86/special.c
index 7c97b7391279..48fa72f564f9 100644
--- a/tools/objtool/arch/x86/special.c
+++ b/tools/objtool/arch/x86/special.c
@@ -7,6 +7,10 @@
 #define X86_FEATURE_POPCNT (4 * 32 + 23)
 #define X86_FEATURE_SMAP   (9 * 32 + 20)
 
+/* Architecture specific "noreturn" function */
+const char * const arch_noreturns[] = {};
+int arch_noreturns_size = ARRAY_SIZE(arch_noreturns);
+
 void arch_handle_alternative(unsigned short feature, struct special_alt *alt)
 {
 	switch (feature) {
diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index f91723010d6b..c637e54088f6 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -110,11 +110,16 @@ static bool __dead_end_function(struct objtool_file *file, struct symbol *func,
 	if (func->bind == STB_WEAK)
 		return false;
 
-	if (func->bind == STB_GLOBAL)
+	if (func->bind == STB_GLOBAL) {
 		for (i = 0; i < ARRAY_SIZE(global_noreturns); i++)
 			if (!strcmp(func->name, global_noreturns[i]))
 				return true;
 
+		for (i = 0; i < arch_noreturns_size; i++)
+			if (!strcmp(func->name, arch_noreturns[i]))
+				return true;
+	}
+
 	if (!func->len)
 		return false;
 
diff --git a/tools/objtool/include/objtool/special.h b/tools/objtool/include/objtool/special.h
index 86d4af9c5aa9..f800817f0ed8 100644
--- a/tools/objtool/include/objtool/special.h
+++ b/tools/objtool/include/objtool/special.h
@@ -30,6 +30,9 @@ struct special_alt {
 	unsigned int orig_len, new_len; /* group only */
 };
 
+extern const char * const arch_noreturns[];
+extern int arch_noreturns_size;
+
 int special_get_alts(struct elf *elf, struct list_head *alts);
 
 void arch_handle_alternative(unsigned short feature, struct special_alt *alt);
-- 
2.39.2

