Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F1F3687691
	for <lists+live-patching@lfdr.de>; Thu,  2 Feb 2023 08:42:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231876AbjBBHmx (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 2 Feb 2023 02:42:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231932AbjBBHmt (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 2 Feb 2023 02:42:49 -0500
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9F4F084950;
        Wed,  1 Feb 2023 23:42:34 -0800 (PST)
Received: from x64host.home (unknown [47.187.213.40])
        by linux.microsoft.com (Postfix) with ESMTPSA id AB75D20B74FE;
        Wed,  1 Feb 2023 23:42:33 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com AB75D20B74FE
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1675323754;
        bh=KaIKlI0UKpV8EYektSfNHyuf2dAhVB2Dmflmbr+t46g=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=dKp0FGp8fcilc2cU+rUUiFilgQqSIYYrFFMq9N5fbTNWTC7F/drDb/6gGAtDUCuCf
         Qn+Lq1vuSFzmJcbGi6t5+hcEBStvg4oCrb3dtKp4PGv+ISFV/3SEfZzVgXOmMmjE2f
         DQthM+Pdi/aKJ1vmI7rWPPEk/CAli8A474Mdk15I=
From:   madvenka@linux.microsoft.com
To:     jpoimboe@redhat.com, peterz@infradead.org, chenzhongjin@huawei.com,
        mark.rutland@arm.com, broonie@kernel.org, nobuta.keiya@fujitsu.com,
        sjitindarsingh@gmail.com, catalin.marinas@arm.com, will@kernel.org,
        jamorris@linux.microsoft.com, linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        madvenka@linux.microsoft.com
Subject: [RFC PATCH v3 09/22] objtool: arm64: Add basic definitions and compile
Date:   Thu,  2 Feb 2023 01:40:23 -0600
Message-Id: <20230202074036.507249-10-madvenka@linux.microsoft.com>
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

Add CFI definitions and Endianness for ARM64.

Add DYNAMIC_CHECK option for ARM64.

Provide stubs for arch_decode_instructions() and check() just to get
Objtool to build on ARM64.

Signed-off-by: Madhavan T. Venkataraman <madvenka@linux.microsoft.com>
---
 tools/objtool/Build                           |  1 +
 tools/objtool/Makefile                        |  6 +++++-
 tools/objtool/arch/arm64/Build                |  1 +
 tools/objtool/arch/arm64/decode.c             | 21 +++++++++++++++++++
 .../arch/arm64/include/arch/cfi_regs.h        | 13 ++++++++++++
 .../arch/arm64/include/arch/endianness.h      |  9 ++++++++
 tools/objtool/dcheck.c                        | 16 ++++++++++++++
 7 files changed, 66 insertions(+), 1 deletion(-)
 create mode 100644 tools/objtool/arch/arm64/Build
 create mode 100644 tools/objtool/arch/arm64/decode.c
 create mode 100644 tools/objtool/arch/arm64/include/arch/cfi_regs.h
 create mode 100644 tools/objtool/arch/arm64/include/arch/endianness.h
 create mode 100644 tools/objtool/dcheck.c

diff --git a/tools/objtool/Build b/tools/objtool/Build
index 974290dc4aac..fb0846b7d95e 100644
--- a/tools/objtool/Build
+++ b/tools/objtool/Build
@@ -4,6 +4,7 @@ objtool-y += weak.o
 
 objtool-$(STATIC_CHECK) += check.o
 objtool-$(STATIC_CHECK) += special.o
+objtool-$(DYNAMIC_CHECK) += dcheck.o
 objtool-y += builtin-check.o
 objtool-y += cfi.o
 objtool-y += insn.o
diff --git a/tools/objtool/Makefile b/tools/objtool/Makefile
index 797d1ea02db0..92583b82eb78 100644
--- a/tools/objtool/Makefile
+++ b/tools/objtool/Makefile
@@ -46,7 +46,11 @@ ifeq ($(SRCARCH),x86)
 	STATIC_CHECK := y
 endif
 
-export BUILD_ORC STATIC_CHECK
+ifeq ($(SRCARCH),arm64)
+	DYNAMIC_CHECK := y
+endif
+
+export BUILD_ORC STATIC_CHECK DYNAMIC_CHECK
 export srctree OUTPUT CFLAGS SRCARCH AWK
 include $(srctree)/tools/build/Makefile.include
 
diff --git a/tools/objtool/arch/arm64/Build b/tools/objtool/arch/arm64/Build
new file mode 100644
index 000000000000..3ff1f00c6a47
--- /dev/null
+++ b/tools/objtool/arch/arm64/Build
@@ -0,0 +1 @@
+objtool-y += decode.o
diff --git a/tools/objtool/arch/arm64/decode.c b/tools/objtool/arch/arm64/decode.c
new file mode 100644
index 000000000000..69f851337537
--- /dev/null
+++ b/tools/objtool/arch/arm64/decode.c
@@ -0,0 +1,21 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Author: Madhavan T. Venkataraman (madvenka@linux.microsoft.com)
+ *
+ * Copyright (C) 2022 Microsoft Corporation
+ */
+
+#include <stdio.h>
+#include <stdlib.h>
+
+#include <objtool/check.h>
+
+int arch_decode_instruction(struct objtool_file *file,
+			    const struct section *sec,
+			    unsigned long offset, unsigned int maxlen,
+			    unsigned int *len, enum insn_type *type,
+			    unsigned long *immediate,
+			    struct list_head *ops_list)
+{
+	return 0;
+}
diff --git a/tools/objtool/arch/arm64/include/arch/cfi_regs.h b/tools/objtool/arch/arm64/include/arch/cfi_regs.h
new file mode 100644
index 000000000000..cff3b04d7248
--- /dev/null
+++ b/tools/objtool/arch/arm64/include/arch/cfi_regs.h
@@ -0,0 +1,13 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+
+#ifndef _OBJTOOL_CFI_REGS_H
+#define _OBJTOOL_CFI_REGS_H
+
+#define CFI_FP			29
+#define CFI_BP			CFI_FP
+#define CFI_RA			30
+#define CFI_SP			31
+
+#define CFI_NUM_REGS		32
+
+#endif /* _OBJTOOL_CFI_REGS_H */
diff --git a/tools/objtool/arch/arm64/include/arch/endianness.h b/tools/objtool/arch/arm64/include/arch/endianness.h
new file mode 100644
index 000000000000..7c362527da20
--- /dev/null
+++ b/tools/objtool/arch/arm64/include/arch/endianness.h
@@ -0,0 +1,9 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+#ifndef _ARCH_ENDIANNESS_H
+#define _ARCH_ENDIANNESS_H
+
+#include <endian.h>
+
+#define __TARGET_BYTE_ORDER __LITTLE_ENDIAN
+
+#endif /* _ARCH_ENDIANNESS_H */
diff --git a/tools/objtool/dcheck.c b/tools/objtool/dcheck.c
new file mode 100644
index 000000000000..e2098c9ad282
--- /dev/null
+++ b/tools/objtool/dcheck.c
@@ -0,0 +1,16 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (C) 2015-2017 Josh Poimboeuf <jpoimboe@redhat.com>
+ */
+
+#include <string.h>
+#include <stdlib.h>
+#include <inttypes.h>
+#include <sys/mman.h>
+
+#include <objtool/objtool.h>
+
+int check(struct objtool_file *file)
+{
+	return 0;
+}
-- 
2.25.1

