Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D14E0736545
	for <lists+live-patching@lfdr.de>; Tue, 20 Jun 2023 09:51:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231487AbjFTHvE (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 20 Jun 2023 03:51:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230515AbjFTHua (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 20 Jun 2023 03:50:30 -0400
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D1249170F;
        Tue, 20 Jun 2023 00:50:27 -0700 (PDT)
Received: from loongson.cn (unknown [113.200.148.30])
        by gateway (Coremail) with SMTP id _____8BxpOhCWpFkpBsHAA--.4166S3;
        Tue, 20 Jun 2023 15:50:26 +0800 (CST)
Received: from bogon.localdomain (unknown [113.200.148.30])
        by localhost.localdomain (Coremail) with SMTP id AQAAf8AxPMo+WpFkp2chAA--.19067S4;
        Tue, 20 Jun 2023 15:50:25 +0800 (CST)
From:   Youling Tang <tangyouling@loongson.cn>
To:     Josh Poimboeuf <jpoimboe@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        madvenka@linux.microsoft.com
Cc:     chenzhongjin@huawei.com, WANG Xuerui <kernel@xen0n.name>,
        Xi Ruoyao <xry111@xry111.site>, live-patching@vger.kernel.org,
        linux-kernel@vger.kernel.org, loongarch@lists.linux.dev,
        tangyouling00@gmail.com, youling.tang@outlook.com
Subject: [RFC PATCH v1 12/23] LoongArch: bug: Add reachable annotation to warning macros
Date:   Tue, 20 Jun 2023 15:50:08 +0800
Message-Id: <1687247415-32057-3-git-send-email-tangyouling@loongson.cn>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1687247415-32057-1-git-send-email-tangyouling@loongson.cn>
References: <1687247415-32057-1-git-send-email-tangyouling@loongson.cn>
X-CM-TRANSID: AQAAf8AxPMo+WpFkp2chAA--.19067S4
X-CM-SenderInfo: 5wdqw5prxox03j6o00pqjv00gofq/
X-Coremail-Antispam: 1Uk129KBj9xXoWrKFyDJw18tr18tr1DXF13trc_yoWfGrg_A3
        W3tw48uw4rXFZrAw1DGan5Jr1j9F48GFnYyry3XwnFqFy5Ja15J3yDG3Z7Zw4vkr97Wrs0
        9FZ5tw45Cr17tosvyTuYvTs0mTUanT9S1TB71UUUUjDqnTZGkaVYY2UrUUUUj1kv1TuYvT
        s0mT0YCTnIWjqI5I8CrVACY4xI64kE6c02F40Ex7xfYxn0WfASr-VFAUDa7-sFnT9fnUUI
        cSsGvfJTRUUUbvxYFVCjjxCrM7AC8VAFwI0_Jr0_Gr1l1xkIjI8I6I8E6xAIw20EY4v20x
        vaj40_Wr0E3s1l1IIY67AEw4v_Jrv_JF1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxS
        w2x7M28EF7xvwVC0I7IYx2IY67AKxVWDJVCq3wA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxV
        W8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIEc7CjxVAF
        wI0_Gr1j6F4UJwAaw2AFwI0_JF0_Jw1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqjxCEc2
        xF0cIa020Ex4CE44I27wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_
        ZF0_GryDMcIj6I8E87Iv67AKxVW8Jr0_Cr1UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0x
        vY0x0EwIxGrwACjcxG6xCI17CEII8vrVW3JVW8Jr1lc7CjxVAaw2AFwI0_JF0_Jw1l42xK
        82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1l4IxYO2xFxVAFwI0_JF0_Jw1lx2
        IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v2
        6r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_tr0E3s1lIxAIcVC0I7IYx2
        IY6xkF7I0E14v26r4UJVWxJr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2
        jsIE14v26r4UJVWxJr1lIxAIcVC2z280aVCY1x0267AKxVW8Jr0_Cr1UYxBIdaVFxhVjvj
        DU0xZFpf9x07bOfHUUUUUU=
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

WARN* and BUG* both use `break 0x1` opcodes and the distinction is
provided by the contents of the bug table. This table is not accessible
to objtool, so add an annotation to WARN* macros to let objtool know
that break handler will return an resume the execution of the instructions
following the WARN's break.

Signed-off-by: Youling Tang <tangyouling@loongson.cn>
---
 arch/loongarch/include/asm/bug.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/loongarch/include/asm/bug.h b/arch/loongarch/include/asm/bug.h
index d4ca3ba25418..08388876ade4 100644
--- a/arch/loongarch/include/asm/bug.h
+++ b/arch/loongarch/include/asm/bug.h
@@ -44,6 +44,7 @@
 do {								\
 	instrumentation_begin();				\
 	__BUG_FLAGS(BUGFLAG_WARNING|(flags));			\
+	annotate_reachable();					\
 	instrumentation_end();					\
 } while (0)
 
-- 
2.39.2

