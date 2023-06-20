Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F08E736549
	for <lists+live-patching@lfdr.de>; Tue, 20 Jun 2023 09:51:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231534AbjFTHvJ (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 20 Jun 2023 03:51:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231613AbjFTHut (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 20 Jun 2023 03:50:49 -0400
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 57EF11981;
        Tue, 20 Jun 2023 00:50:30 -0700 (PDT)
Received: from loongson.cn (unknown [113.200.148.30])
        by gateway (Coremail) with SMTP id _____8Cx8OhEWpFkuRsHAA--.12665S3;
        Tue, 20 Jun 2023 15:50:28 +0800 (CST)
Received: from bogon.localdomain (unknown [113.200.148.30])
        by localhost.localdomain (Coremail) with SMTP id AQAAf8AxPMo+WpFkp2chAA--.19067S6;
        Tue, 20 Jun 2023 15:50:28 +0800 (CST)
From:   Youling Tang <tangyouling@loongson.cn>
To:     Josh Poimboeuf <jpoimboe@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        madvenka@linux.microsoft.com
Cc:     chenzhongjin@huawei.com, WANG Xuerui <kernel@xen0n.name>,
        Xi Ruoyao <xry111@xry111.site>, live-patching@vger.kernel.org,
        linux-kernel@vger.kernel.org, loongarch@lists.linux.dev,
        tangyouling00@gmail.com, youling.tang@outlook.com
Subject: [RFC PATCH v1 14/23] objtool: Add orc_print_dump() package
Date:   Tue, 20 Jun 2023 15:50:10 +0800
Message-Id: <1687247415-32057-5-git-send-email-tangyouling@loongson.cn>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1687247415-32057-1-git-send-email-tangyouling@loongson.cn>
References: <1687247415-32057-1-git-send-email-tangyouling@loongson.cn>
X-CM-TRANSID: AQAAf8AxPMo+WpFkp2chAA--.19067S6
X-CM-SenderInfo: 5wdqw5prxox03j6o00pqjv00gofq/
X-Coremail-Antispam: 1Uk129KBj93XoWxZw4DGw17Kw47Zw4UWr4xXwc_yoW5Zw48pr
        nxGas7KrWUuF9xAw1kJanrC3y5Ganru34IkrnxC34Iyw1IqwnrXa1SyF1j9Fn5W3s5uasx
        ZFZIqr1UKFs7tFXCm3ZEXasCq-sJn29KB7ZKAUJUUUU3529EdanIXcx71UUUUU7KY7ZEXa
        sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
        0xBIdaVrnRJUUUmIb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
        IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
        e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
        0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26r4UJVWxJr1l84ACjcxK6I8E87Iv6xkF7I0E
        14v26r4UJVWxJr1ln4kS14v26r126r1DM2AIxVAIcxkEcVAq07x20xvEncxIr21l57IF6x
        kI12xvs2x26I8E6xACxx1l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v2
        6r45tVCq3wAv7VC2z280aVAFwI0_Gr1j6F4UJwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2
        IYc2Ij64vIr41lF7xvrVCFI7AF6II2Y40_Zr0_Gr1UMxkF7I0En4kS14v26r126r1DMxAI
        w28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMxCIbckI1I0E14v26r126r1DMI
        8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AK
        xVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26w1j6s0DMIIF0xvE2Ix0cI
        8IcVCY1x0267AKxVW8Jr0_Cr1UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E
        87Iv67AKxVW8Jr0_Cr1UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr1j6F4UJbIYCTnIWIevJa
        73UjIFyTuYvjxU9zpBDUUUU
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

There is no functional change, only operations such as orc_print_{sp,fp}
are encapsulated into orc_print_dump(). It is convenient to add LoongArch
support later (because it needs to add orc_print_ra()).

Signed-off-by: Youling Tang <tangyouling@loongson.cn>
---
 tools/objtool/arch/x86/orc.c        | 23 ++++++++++++++++++-----
 tools/objtool/include/objtool/orc.h |  5 +----
 tools/objtool/orc_dump.c            | 12 +-----------
 3 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/tools/objtool/arch/x86/orc.c b/tools/objtool/arch/x86/orc.c
index a0c00e136089..cf546b274a79 100644
--- a/tools/objtool/arch/x86/orc.c
+++ b/tools/objtool/arch/x86/orc.c
@@ -114,7 +114,7 @@ static const char *reg_name(unsigned int reg)
 	}
 }
 
-const char *orc_type_name(unsigned int type)
+static const char *orc_type_name(unsigned int type)
 {
 	switch (type) {
 	case UNWIND_HINT_TYPE_CALL:
@@ -128,7 +128,7 @@ const char *orc_type_name(unsigned int type)
 	}
 }
 
-void orc_print_reg(unsigned int reg, int offset)
+static void orc_print_reg(unsigned int reg, int offset)
 {
 	if (reg == ORC_REG_BP_INDIRECT)
 		printf("(bp%+d)", offset);
@@ -140,12 +140,25 @@ void orc_print_reg(unsigned int reg, int offset)
 		printf("%s%+d", reg_name(reg), offset);
 }
 
-void orc_print_sp(void)
+static void orc_print_sp(void)
 {
 	printf(" sp:");
 }
-
-void orc_print_fp(void)
+static void orc_print_fp(void)
 {
 	printf(" bp:");
 }
+
+void orc_print_dump(struct elf *dummy_elf, struct orc_entry *orc, int i)
+{
+	orc_print_sp();
+
+	orc_print_reg(orc[i].sp_reg, bswap_if_needed(dummy_elf, orc[i].sp_offset));
+
+	orc_print_fp();
+
+	orc_print_reg(orc[i].bp_reg, bswap_if_needed(dummy_elf, orc[i].bp_offset));
+
+	printf(" type:%s signal:%d end:%d\n",
+	       orc_type_name(orc[i].type), orc[i].signal, orc[i].end);
+}
diff --git a/tools/objtool/include/objtool/orc.h b/tools/objtool/include/objtool/orc.h
index bf141134c56f..53a037bdfc35 100644
--- a/tools/objtool/include/objtool/orc.h
+++ b/tools/objtool/include/objtool/orc.h
@@ -10,9 +10,6 @@
 
 int init_orc_entry(struct orc_entry *orc, struct cfi_state *cfi,
 		   struct instruction *insn);
-const char *orc_type_name(unsigned int type);
-void orc_print_reg(unsigned int reg, int offset);
-void orc_print_sp(void);
-void orc_print_fp(void);
+void orc_print_dump(struct elf *dummy_elf, struct orc_entry *orc, int i);
 
 #endif /* _OBJTOOL_ORC_H */
diff --git a/tools/objtool/orc_dump.c b/tools/objtool/orc_dump.c
index 82bdd33dbc39..c274c0577427 100644
--- a/tools/objtool/orc_dump.c
+++ b/tools/objtool/orc_dump.c
@@ -151,17 +151,7 @@ int orc_dump(const char *_objname)
 			printf("%llx:", (unsigned long long)(orc_ip_addr + (i * sizeof(int)) + orc_ip[i]));
 		}
 
-
-		orc_print_sp();
-
-		orc_print_reg(orc[i].sp_reg, bswap_if_needed(&dummy_elf, orc[i].sp_offset));
-
-		orc_print_fp();
-
-		orc_print_reg(orc[i].bp_reg, bswap_if_needed(&dummy_elf, orc[i].bp_offset));
-
-		printf(" type:%s signal:%d end:%d\n",
-		       orc_type_name(orc[i].type), orc[i].signal, orc[i].end);
+		orc_print_dump(&dummy_elf, orc, i);
 	}
 
 	elf_end(elf);
-- 
2.39.2

