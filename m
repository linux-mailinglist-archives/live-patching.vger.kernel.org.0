Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2ABB7687682
	for <lists+live-patching@lfdr.de>; Thu,  2 Feb 2023 08:42:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229761AbjBBHm2 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 2 Feb 2023 02:42:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229495AbjBBHm1 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 2 Feb 2023 02:42:27 -0500
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B68EB751AD;
        Wed,  1 Feb 2023 23:42:26 -0800 (PST)
Received: from x64host.home (unknown [47.187.213.40])
        by linux.microsoft.com (Postfix) with ESMTPSA id AC81120B74F7;
        Wed,  1 Feb 2023 23:42:25 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com AC81120B74F7
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1675323746;
        bh=KrZSg2bNqxWMiHZDDiwh5bJWJjaRLRpKmuEYjI5Br/E=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=j/su7JMbNc+4R20aW2hpwxnbcloXGFZlzmdtyO1JoBF0wIRExhA9W+ndzz00e88qy
         A/9GbYu6efRe+uezEvfN3dhaN/5crHTkHKcT5h3tmqFZ3p2WeqrvQuK8AQLYkGA0ag
         d4AreYpr5nAWD9AdM7TbqugHMbsWOdtPxLgTX1go=
From:   madvenka@linux.microsoft.com
To:     jpoimboe@redhat.com, peterz@infradead.org, chenzhongjin@huawei.com,
        mark.rutland@arm.com, broonie@kernel.org, nobuta.keiya@fujitsu.com,
        sjitindarsingh@gmail.com, catalin.marinas@arm.com, will@kernel.org,
        jamorris@linux.microsoft.com, linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        madvenka@linux.microsoft.com
Subject: [RFC PATCH v3 01/22] objtool: Reorganize CFI code
Date:   Thu,  2 Feb 2023 01:40:15 -0600
Message-Id: <20230202074036.507249-2-madvenka@linux.microsoft.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230202074036.507249-1-madvenka@linux.microsoft.com>
References: <0337266cf19f4c98388e3f6d09f590d9de258dc7>
 <20230202074036.507249-1-madvenka@linux.microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-19.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_FILL_THIS_FORM_SHORT,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
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
index 33f2ee5a46d3..21db9d79c69f 100644
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
index 43ec14c29a60..e6a2afa08748 100644
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
@@ -255,19 +249,6 @@ static bool dead_end_function(struct objtool_file *file, struct symbol *func)
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
@@ -283,75 +264,6 @@ static void init_insn_state(struct objtool_file *file, struct insn_state *state,
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
 
@@ -2006,14 +1918,6 @@ static int add_jump_table_alts(struct objtool_file *file)
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
index f11d1ac1dadf..58391a4c49d4 100644
--- a/tools/objtool/include/objtool/cfi.h
+++ b/tools/objtool/include/objtool/cfi.h
@@ -37,4 +37,16 @@ struct cfi_state {
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
2.25.1

