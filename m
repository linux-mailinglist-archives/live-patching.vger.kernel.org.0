Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 557C2736548
	for <lists+live-patching@lfdr.de>; Tue, 20 Jun 2023 09:51:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229595AbjFTHvH (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 20 Jun 2023 03:51:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbjFTHus (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 20 Jun 2023 03:50:48 -0400
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A4557171B;
        Tue, 20 Jun 2023 00:50:29 -0700 (PDT)
Received: from loongson.cn (unknown [113.200.148.30])
        by gateway (Coremail) with SMTP id _____8Bxb+tEWpFkrxsHAA--.14646S3;
        Tue, 20 Jun 2023 15:50:28 +0800 (CST)
Received: from bogon.localdomain (unknown [113.200.148.30])
        by localhost.localdomain (Coremail) with SMTP id AQAAf8AxPMo+WpFkp2chAA--.19067S5;
        Tue, 20 Jun 2023 15:50:27 +0800 (CST)
From:   Youling Tang <tangyouling@loongson.cn>
To:     Josh Poimboeuf <jpoimboe@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        madvenka@linux.microsoft.com
Cc:     chenzhongjin@huawei.com, WANG Xuerui <kernel@xen0n.name>,
        Xi Ruoyao <xry111@xry111.site>, live-patching@vger.kernel.org,
        linux-kernel@vger.kernel.org, loongarch@lists.linux.dev,
        tangyouling00@gmail.com, youling.tang@outlook.com,
        Jinyang He <hejinyang@loongson.cn>
Subject: [RFC PATCH v1 13/23] objtool: Add next member in struct reloc
Date:   Tue, 20 Jun 2023 15:50:09 +0800
Message-Id: <1687247415-32057-4-git-send-email-tangyouling@loongson.cn>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1687247415-32057-1-git-send-email-tangyouling@loongson.cn>
References: <1687247415-32057-1-git-send-email-tangyouling@loongson.cn>
X-CM-TRANSID: AQAAf8AxPMo+WpFkp2chAA--.19067S5
X-CM-SenderInfo: 5wdqw5prxox03j6o00pqjv00gofq/
X-Coremail-Antispam: 1Uk129KBj93XoW7Zr4kGw1DZry8uFy5CF4rWFX_yoW8tw48pF
        srC39rKFW8XryxJ3WavF48G3yYkwnruFyIyr47G340vrsrXrn0qF4ayF1jyFyjqrWYgFWa
        qry5Kr40yr4UZagCm3ZEXasCq-sJn29KB7ZKAUJUUUU3529EdanIXcx71UUUUU7KY7ZEXa
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

In LoongArch, there may be multiple relocation information in one location,
so the next member is added to handle this situation.

The following warning appears when the next member is not added,
warning: objtool: unexpected relocation symbol type in .rela.discard.unreachable

Relocation section '.rela.discard.unreachable' at offset 0x1a58 contains 4 entries:
    Offset             Info             Type               Symbol's Value  Symbol's Name + Addend
0000000000000000  0000000200000032 R_LARCH_ADD32          0000000000000000 .text + 354
0000000000000000  0000000900000037 R_LARCH_SUB32          0000000000000000 L0^A + 0

Co-developed-by: Jinyang He <hejinyang@loongson.cn>
Signed-off-by: Jinyang He <hejinyang@loongson.cn>
Signed-off-by: Youling Tang <tangyouling@loongson.cn>
---
 tools/objtool/elf.c                 | 11 ++++++++++-
 tools/objtool/include/objtool/elf.h |  1 +
 2 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/tools/objtool/elf.c b/tools/objtool/elf.c
index 6806ce01d933..d345300d269b 100644
--- a/tools/objtool/elf.c
+++ b/tools/objtool/elf.c
@@ -895,7 +895,7 @@ static int read_relocs(struct elf *elf)
 {
 	unsigned long nr_reloc, max_reloc = 0, tot_reloc = 0;
 	struct section *sec;
-	struct reloc *reloc;
+	struct reloc *reloc, *next_reloc;
 	unsigned int symndx;
 	struct symbol *sym;
 	int i;
@@ -915,6 +915,7 @@ static int read_relocs(struct elf *elf)
 			return -1;
 		}
 
+		next_reloc = NULL;
 		sec->base->reloc = sec;
 
 		nr_reloc = 0;
@@ -946,6 +947,14 @@ static int read_relocs(struct elf *elf)
 				return -1;
 			}
 
+			if (next_reloc && reloc->offset == next_reloc->offset) {
+				next_reloc->next = reloc;
+				next_reloc = reloc;
+				continue;
+			}
+
+			next_reloc = reloc;
+
 			list_add_tail(&reloc->sym_reloc_entry, &sym->reloc_list);
 			list_add_tail(&reloc->list, &sec->reloc_list);
 			elf_hash_add(reloc, &reloc->hash, reloc_hash(reloc));
diff --git a/tools/objtool/include/objtool/elf.h b/tools/objtool/include/objtool/elf.h
index ad0024da262b..7877298fe401 100644
--- a/tools/objtool/include/objtool/elf.h
+++ b/tools/objtool/include/objtool/elf.h
@@ -68,6 +68,7 @@ struct symbol {
 struct reloc {
 	struct list_head list;
 	struct hlist_node hash;
+	struct reloc *next;
 	union {
 		GElf_Rela rela;
 		GElf_Rel  rel;
-- 
2.39.2

