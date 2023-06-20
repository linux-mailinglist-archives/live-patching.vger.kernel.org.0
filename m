Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03F3473651E
	for <lists+live-patching@lfdr.de>; Tue, 20 Jun 2023 09:47:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230380AbjFTHr0 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 20 Jun 2023 03:47:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230405AbjFTHrV (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 20 Jun 2023 03:47:21 -0400
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 654EF10F9;
        Tue, 20 Jun 2023 00:47:17 -0700 (PDT)
Received: from loongson.cn (unknown [113.200.148.30])
        by gateway (Coremail) with SMTP id _____8Dxh+mAWZFkjBoHAA--.12756S3;
        Tue, 20 Jun 2023 15:47:12 +0800 (CST)
Received: from bogon.localdomain (unknown [113.200.148.30])
        by localhost.localdomain (Coremail) with SMTP id AQAAf8DxK8pvWZFkJGYhAA--.19652S3;
        Tue, 20 Jun 2023 15:47:10 +0800 (CST)
From:   Youling Tang <tangyouling@loongson.cn>
To:     Josh Poimboeuf <jpoimboe@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        madvenka@linux.microsoft.com
Cc:     chenzhongjin@huawei.com, WANG Xuerui <kernel@xen0n.name>,
        Xi Ruoyao <xry111@xry111.site>, live-patching@vger.kernel.org,
        linux-kernel@vger.kernel.org, loongarch@lists.linux.dev,
        tangyouling00@gmail.com, youling.tang@outlook.com
Subject: [RFC PATCH v1 01/23] objtool: Reorganize CFI code
Date:   Tue, 20 Jun 2023 15:46:27 +0800
Message-Id: <1687247209-31676-2-git-send-email-tangyouling@loongson.cn>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1687247209-31676-1-git-send-email-tangyouling@loongson.cn>
References: <1687247209-31676-1-git-send-email-tangyouling@loongson.cn>
X-CM-TRANSID: AQAAf8DxK8pvWZFkJGYhAA--.19652S3
X-CM-SenderInfo: 5wdqw5prxox03j6o00pqjv00gofq/
X-Coremail-Antispam: 1Uk129KBj93XoW3Ar15CF1fXr4Dtr48Kr4UGFX_yoW3Cw48pa
        sxC3y5GF4rXr40gwnrtrWYkrZxKr4Sgryjqry7G34rt3W7Kr15XFsxKry8ZF4Yv3yrWw12
        qFsFgFyUJr4xtFXCm3ZEXasCq-sJn29KB7ZKAUJUUUU3529EdanIXcx71UUUUU7KY7ZEXa
        sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
        0xBIdaVrnRJUUUBIb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
        IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
        e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
        0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x0267AK
        xVW8Jr0_Cr1UM2kKe7AKxVWUAVWUtwAS0I0E0xvYzxvE52x082IY62kv0487Mc804VCY07
        AIYIkI8VC2zVCFFI0UMc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWU
        tVWrXwAv7VC2z280aVAFwI0_Gr0_Cr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcxkI7V
        AKI48JMxkF7I0En4kS14v26r126r1DMxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY
        6r1j6r4UMxCIbckI1I0E14v26r126r1DMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7
        xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xII
        jxv20xvE14v26r4j6ryUMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAIw2
        0EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Gr0_Cr1lIxAIcVC2z280aVCY1x02
        67AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7IU8_gA5UUUUU==
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_FILL_THIS_FORM_SHORT,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>

check.c implements static stack validation. But the CFI code that it
contains can be shared with other types of validation. E.g., dynamic FP
validation. Move the CFI code to its own files - cfi.h and cfi.c.

Signed-off-by: Madhavan T. Venkataraman <madvenka@linux.microsoft.com>
---
 tools/objtool/Build                 |   1 +
 tools/objtool/cfi.c                 | 108 ++++++++++++++++++++++++++++
 tools/objtool/check.c               |  96 -------------------------
 tools/objtool/include/objtool/cfi.h |  12 ++++
 4 files changed, 121 insertions(+), 96 deletions(-)
 create mode 100644 tools/objtool/cfi.c

diff --git a/tools/objtool/Build b/tools/objtool/Build
index a3cdf8af6635..9f23d1f4c716 100644
--- a/tools/objtool/Build
+++ b/tools/objtool/Build
@@ -5,6 +5,7 @@ objtool-y += weak.o
 objtool-y += check.o
 objtool-y += special.o
 objtool-y += builtin-check.o
+objtool-y += cfi.o
 objtool-y += elf.o
 objtool-y += objtool.o
 
diff --git a/tools/objtool/cfi.c b/tools/objtool/cfi.c
new file mode 100644
index 000000000000..18b460e066c8
--- /dev/null
+++ b/tools/objtool/cfi.c
@@ -0,0 +1,108 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (C) 2015-2017 Josh Poimboeuf <jpoimboe@redhat.com>
+ */
+
+#include <stdlib.h>
+#include <sys/mman.h>
+
+#include <objtool/cfi.h>
+#include <objtool/builtin.h>
+#include <objtool/warn.h>
+
+unsigned long nr_cfi, nr_cfi_reused, nr_cfi_cache;
+
+struct cfi_init_state initial_func_cfi;
+struct cfi_state init_cfi;
+struct cfi_state func_cfi;
+
+void init_cfi_state(struct cfi_state *cfi)
+{
+	int i;
+
+	for (i = 0; i < CFI_NUM_REGS; i++) {
+		cfi->regs[i].base = CFI_UNDEFINED;
+		cfi->vals[i].base = CFI_UNDEFINED;
+	}
+	cfi->cfa.base = CFI_UNDEFINED;
+	cfi->drap_reg = CFI_UNDEFINED;
+	cfi->drap_offset = -1;
+}
+
+static struct cfi_state *cfi_alloc(void)
+{
+	struct cfi_state *cfi = calloc(sizeof(struct cfi_state), 1);
+
+	if (!cfi) {
+		WARN("calloc failed");
+		exit(1);
+	}
+	nr_cfi++;
+	return cfi;
+}
+
+static int cfi_bits;
+static struct hlist_head *cfi_hash;
+
+inline bool cficmp(struct cfi_state *cfi1, struct cfi_state *cfi2)
+{
+	return memcmp((void *)cfi1 + sizeof(cfi1->hash),
+		      (void *)cfi2 + sizeof(cfi2->hash),
+		      sizeof(struct cfi_state) - sizeof(struct hlist_node));
+}
+
+static inline u32 cfi_key(struct cfi_state *cfi)
+{
+	return jhash((void *)cfi + sizeof(cfi->hash),
+		     sizeof(*cfi) - sizeof(cfi->hash), 0);
+}
+
+struct cfi_state *cfi_hash_find_or_add(struct cfi_state *cfi)
+{
+	struct hlist_head *head = &cfi_hash[hash_min(cfi_key(cfi), cfi_bits)];
+	struct cfi_state *obj;
+
+	hlist_for_each_entry(obj, head, hash) {
+		if (!cficmp(cfi, obj)) {
+			nr_cfi_cache++;
+			return obj;
+		}
+	}
+
+	obj = cfi_alloc();
+	*obj = *cfi;
+	hlist_add_head(&obj->hash, head);
+
+	return obj;
+}
+
+void cfi_hash_add(struct cfi_state *cfi)
+{
+	struct hlist_head *head = &cfi_hash[hash_min(cfi_key(cfi), cfi_bits)];
+
+	hlist_add_head(&cfi->hash, head);
+}
+
+void *cfi_hash_alloc(unsigned long size)
+{
+	cfi_bits = max(10, ilog2(size));
+	cfi_hash = mmap(NULL, sizeof(struct hlist_head) << cfi_bits,
+			PROT_READ|PROT_WRITE,
+			MAP_PRIVATE|MAP_ANON, -1, 0);
+	if (cfi_hash == (void *)-1L) {
+		WARN("mmap fail cfi_hash");
+		cfi_hash = NULL;
+	}  else if (opts.stats) {
+		printf("cfi_bits: %d\n", cfi_bits);
+	}
+
+	return cfi_hash;
+}
+
+void set_func_state(struct cfi_state *state)
+{
+	state->cfa = initial_func_cfi.cfa;
+	memcpy(&state->regs, &initial_func_cfi.regs,
+	       CFI_NUM_REGS * sizeof(struct cfi_reg));
+	state->stack_size = initial_func_cfi.cfa.offset;
+}
diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index f937be1afe65..803764f4d4d8 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -28,12 +28,6 @@ struct alternative {
 	bool skip_orig;
 };
 
-static unsigned long nr_cfi, nr_cfi_reused, nr_cfi_cache;
-
-static struct cfi_init_state initial_func_cfi;
-static struct cfi_state init_cfi;
-static struct cfi_state func_cfi;
-
 struct instruction *find_insn(struct objtool_file *file,
 			      struct section *sec, unsigned long offset)
 {
@@ -288,19 +282,6 @@ static bool dead_end_function(struct objtool_file *file, struct symbol *func)
 	return __dead_end_function(file, func, 0);
 }
 
-static void init_cfi_state(struct cfi_state *cfi)
-{
-	int i;
-
-	for (i = 0; i < CFI_NUM_REGS; i++) {
-		cfi->regs[i].base = CFI_UNDEFINED;
-		cfi->vals[i].base = CFI_UNDEFINED;
-	}
-	cfi->cfa.base = CFI_UNDEFINED;
-	cfi->drap_reg = CFI_UNDEFINED;
-	cfi->drap_offset = -1;
-}
-
 static void init_insn_state(struct objtool_file *file, struct insn_state *state,
 			    struct section *sec)
 {
@@ -316,75 +297,6 @@ static void init_insn_state(struct objtool_file *file, struct insn_state *state,
 		state->noinstr = sec->noinstr;
 }
 
-static struct cfi_state *cfi_alloc(void)
-{
-	struct cfi_state *cfi = calloc(sizeof(struct cfi_state), 1);
-	if (!cfi) {
-		WARN("calloc failed");
-		exit(1);
-	}
-	nr_cfi++;
-	return cfi;
-}
-
-static int cfi_bits;
-static struct hlist_head *cfi_hash;
-
-static inline bool cficmp(struct cfi_state *cfi1, struct cfi_state *cfi2)
-{
-	return memcmp((void *)cfi1 + sizeof(cfi1->hash),
-		      (void *)cfi2 + sizeof(cfi2->hash),
-		      sizeof(struct cfi_state) - sizeof(struct hlist_node));
-}
-
-static inline u32 cfi_key(struct cfi_state *cfi)
-{
-	return jhash((void *)cfi + sizeof(cfi->hash),
-		     sizeof(*cfi) - sizeof(cfi->hash), 0);
-}
-
-static struct cfi_state *cfi_hash_find_or_add(struct cfi_state *cfi)
-{
-	struct hlist_head *head = &cfi_hash[hash_min(cfi_key(cfi), cfi_bits)];
-	struct cfi_state *obj;
-
-	hlist_for_each_entry(obj, head, hash) {
-		if (!cficmp(cfi, obj)) {
-			nr_cfi_cache++;
-			return obj;
-		}
-	}
-
-	obj = cfi_alloc();
-	*obj = *cfi;
-	hlist_add_head(&obj->hash, head);
-
-	return obj;
-}
-
-static void cfi_hash_add(struct cfi_state *cfi)
-{
-	struct hlist_head *head = &cfi_hash[hash_min(cfi_key(cfi), cfi_bits)];
-
-	hlist_add_head(&cfi->hash, head);
-}
-
-static void *cfi_hash_alloc(unsigned long size)
-{
-	cfi_bits = max(10, ilog2(size));
-	cfi_hash = mmap(NULL, sizeof(struct hlist_head) << cfi_bits,
-			PROT_READ|PROT_WRITE,
-			MAP_PRIVATE|MAP_ANON, -1, 0);
-	if (cfi_hash == (void *)-1L) {
-		WARN("mmap fail cfi_hash");
-		cfi_hash = NULL;
-	}  else if (opts.stats) {
-		printf("cfi_bits: %d\n", cfi_bits);
-	}
-
-	return cfi_hash;
-}
-
 static unsigned long nr_insns;
 static unsigned long nr_insns_visited;
 
@@ -2236,14 +2148,6 @@ static int add_jump_table_alts(struct objtool_file *file)
 	return 0;
 }
 
-static void set_func_state(struct cfi_state *state)
-{
-	state->cfa = initial_func_cfi.cfa;
-	memcpy(&state->regs, &initial_func_cfi.regs,
-	       CFI_NUM_REGS * sizeof(struct cfi_reg));
-	state->stack_size = initial_func_cfi.cfa.offset;
-}
-
 static int read_unwind_hints(struct objtool_file *file)
 {
 	struct cfi_state cfi = init_cfi;
diff --git a/tools/objtool/include/objtool/cfi.h b/tools/objtool/include/objtool/cfi.h
index b1258e79a1b7..28c70daa3965 100644
--- a/tools/objtool/include/objtool/cfi.h
+++ b/tools/objtool/include/objtool/cfi.h
@@ -38,4 +38,16 @@ struct cfi_state {
 	bool end;
 };
 
+void init_cfi_state(struct cfi_state *cfi);
+bool cficmp(struct cfi_state *cfi1, struct cfi_state *cfi2);
+struct cfi_state *cfi_hash_find_or_add(struct cfi_state *cfi);
+void cfi_hash_add(struct cfi_state *cfi);
+void *cfi_hash_alloc(unsigned long size);
+void set_func_state(struct cfi_state *state);
+
+extern unsigned long nr_cfi, nr_cfi_reused, nr_cfi_cache;
+extern struct cfi_init_state initial_func_cfi;
+extern struct cfi_state init_cfi;
+extern struct cfi_state func_cfi;
+
 #endif /* _OBJTOOL_CFI_H */
-- 
2.39.2

