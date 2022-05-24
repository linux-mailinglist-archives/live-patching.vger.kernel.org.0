Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E8DE531FAC
	for <lists+live-patching@lfdr.de>; Tue, 24 May 2022 02:17:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231970AbiEXARM (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 23 May 2022 20:17:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231740AbiEXAQ5 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 23 May 2022 20:16:57 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 741016D1BA;
        Mon, 23 May 2022 17:16:56 -0700 (PDT)
Received: from x64host.home (unknown [47.189.24.195])
        by linux.microsoft.com (Postfix) with ESMTPSA id 7E3B320B895E;
        Mon, 23 May 2022 17:16:55 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 7E3B320B895E
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1653351416;
        bh=YG6KQOAJyGOL922olQKuoXPzwcII9DtE7DpLrKl5nFA=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=rB6vq+eaexXeXKlEiEyPMzkVQcdNXoz1Ho/8mJ0EDHSarAy9/cFPKftW0GVjp4dQb
         qKlHQoWRsBJMW6rv/QaiguC/s+1qauw4KDmQGAKaoWEtDKq47wIVN4MLIQ2SkJGtc/
         OI7+yk41BA3C46ueOP9X3cP6w7uxttnYDLIhnOlw=
From:   madvenka@linux.microsoft.com
To:     jpoimboe@redhat.com, peterz@infradead.org, chenzhongjin@huawei.com,
        mark.rutland@arm.com, broonie@kernel.org, nobuta.keiya@fujitsu.com,
        sjitindarsingh@gmail.com, catalin.marinas@arm.com, will@kernel.org,
        jamorris@linux.microsoft.com, linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        madvenka@linux.microsoft.com
Subject: [RFC PATCH v2 09/20] objtool: arm64: Implement command to invoke the decoder
Date:   Mon, 23 May 2022 19:16:26 -0500
Message-Id: <20220524001637.1707472-10-madvenka@linux.microsoft.com>
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

Implement a built-in command called cmd_fpv() that can be invoked as
follows:

	objtool fpv generate file.o

The built-in command invokes decode_instructions() to walk each function
and decode the instructions of the function.

Signed-off-by: Madhavan T. Venkataraman <madvenka@linux.microsoft.com>
---
 tools/objtool/Build                     |  5 ++
 tools/objtool/Makefile                  |  6 ++-
 tools/objtool/builtin-fpv.c             | 71 +++++++++++++++++++++++++
 tools/objtool/fpv.c                     | 19 +++++++
 tools/objtool/include/objtool/builtin.h |  1 +
 tools/objtool/include/objtool/objtool.h |  1 +
 tools/objtool/objtool.c                 | 12 ++++-
 tools/objtool/weak.c                    |  5 ++
 8 files changed, 117 insertions(+), 3 deletions(-)
 create mode 100644 tools/objtool/builtin-fpv.c
 create mode 100644 tools/objtool/fpv.c

diff --git a/tools/objtool/Build b/tools/objtool/Build
index 9c2a332f61f3..a491f51c40b4 100644
--- a/tools/objtool/Build
+++ b/tools/objtool/Build
@@ -15,9 +15,14 @@ objtool-$(SUBCMD_ORC) += decode.o
 objtool-$(SUBCMD_ORC) += unwind_hints.o
 objtool-$(SUBCMD_ORC) += orc_gen.o
 objtool-$(SUBCMD_ORC) += orc_dump.o
+objtool-$(SUBCMD_FPV) += fpv.o
+objtool-$(SUBCMD_FPV) += cfi.o
+objtool-$(SUBCMD_FPV) += insn.o
+objtool-$(SUBCMD_FPV) += decode.o
 
 objtool-y += builtin-check.o
 objtool-y += builtin-orc.o
+objtool-y += builtin-fpv.o
 objtool-y += elf.o
 objtool-y += objtool.o
 
diff --git a/tools/objtool/Makefile b/tools/objtool/Makefile
index 0dbd397f319d..2511053245bc 100644
--- a/tools/objtool/Makefile
+++ b/tools/objtool/Makefile
@@ -47,7 +47,11 @@ ifeq ($(SRCARCH),x86)
 	SUBCMD_ORC := y
 endif
 
-export SUBCMD_CHECK SUBCMD_ORC
+ifeq ($(SRCARCH),arm64)
+	SUBCMD_FPV := y
+endif
+
+export SUBCMD_CHECK SUBCMD_ORC SUBCMD_FPV
 export srctree OUTPUT CFLAGS SRCARCH AWK
 include $(srctree)/tools/build/Makefile.include
 
diff --git a/tools/objtool/builtin-fpv.c b/tools/objtool/builtin-fpv.c
new file mode 100644
index 000000000000..ff57dde39587
--- /dev/null
+++ b/tools/objtool/builtin-fpv.c
@@ -0,0 +1,71 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Author: Madhavan T. Venkataraman (madvenka@linux.microsoft.com)
+ *
+ * Copyright (C) 2022 Microsoft Corporation
+ */
+
+/*
+ * objtool fp validation:
+ *
+ * This command analyzes a .o file and adds .orc_unwind and .orc_unwind_ip
+ * sections to it. The sections are used by the frame pointer-based in-kernel
+ * unwinder to validate the frame pointer.
+ */
+
+#include <string.h>
+#include <objtool/builtin.h>
+#include <objtool/objtool.h>
+
+static const char * const fpv_usage[] = {
+	"objtool fpv generate file.o",
+	NULL,
+};
+
+const struct option fpv_options[] = {
+	OPT_END(),
+};
+
+int cmd_fpv(int argc, const char **argv)
+{
+	const char *objname;
+	struct objtool_file *file;
+	int ret;
+
+	argc--; argv++;
+	if (argc <= 0)
+		usage_with_options(fpv_usage, fpv_options);
+
+	objname = argv[1];
+
+	file = objtool_open_read(objname);
+	if (!file)
+		return 1;
+
+	/* Supported architectures. */
+	switch (file->elf->ehdr.e_machine) {
+	case EM_AARCH64:
+		break;
+
+	default:
+		return 1;
+	}
+
+	if (!strncmp(argv[0], "gen", 3)) {
+		ret = fpv_decode(file);
+		if (ret)
+			return ret;
+
+		if (list_empty(&file->insn_list))
+			return 0;
+
+		if (!file->elf->changed)
+			return 0;
+
+		return elf_write(file->elf);
+	}
+
+	usage_with_options(fpv_usage, fpv_options);
+
+	return 0;
+}
diff --git a/tools/objtool/fpv.c b/tools/objtool/fpv.c
new file mode 100644
index 000000000000..76f0f2e611a8
--- /dev/null
+++ b/tools/objtool/fpv.c
@@ -0,0 +1,19 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Author: Madhavan T. Venkataraman (madvenka@linux.microsoft.com)
+ *
+ * Copyright (C) 2022 Microsoft Corporation
+ */
+
+#include <string.h>
+#include <stdlib.h>
+#include <sys/mman.h>
+
+#include <objtool/builtin.h>
+#include <objtool/insn.h>
+#include <objtool/warn.h>
+
+int fpv_decode(struct objtool_file *file)
+{
+	return decode_instructions(file);
+}
diff --git a/tools/objtool/include/objtool/builtin.h b/tools/objtool/include/objtool/builtin.h
index c39dbfaef6dc..bfd99e08c33b 100644
--- a/tools/objtool/include/objtool/builtin.h
+++ b/tools/objtool/include/objtool/builtin.h
@@ -16,5 +16,6 @@ extern int cmd_parse_options(int argc, const char **argv, const char * const usa
 
 extern int cmd_check(int argc, const char **argv);
 extern int cmd_orc(int argc, const char **argv);
+extern int cmd_fpv(int argc, const char **argv);
 
 #endif /* _BUILTIN_H */
diff --git a/tools/objtool/include/objtool/objtool.h b/tools/objtool/include/objtool/objtool.h
index 7a5c13a78f87..e00c8dcc6885 100644
--- a/tools/objtool/include/objtool/objtool.h
+++ b/tools/objtool/include/objtool/objtool.h
@@ -45,5 +45,6 @@ void objtool_pv_add(struct objtool_file *file, int idx, struct symbol *func);
 int check(struct objtool_file *file);
 int orc_dump(const char *objname);
 int orc_create(struct objtool_file *file);
+int fpv_decode(struct objtool_file *file);
 
 #endif /* _OBJTOOL_H */
diff --git a/tools/objtool/objtool.c b/tools/objtool/objtool.c
index b09946f4e1d6..974a9bc384e8 100644
--- a/tools/objtool/objtool.c
+++ b/tools/objtool/objtool.c
@@ -35,9 +35,17 @@ struct cmd_struct {
 static const char objtool_usage_string[] =
 	"objtool COMMAND [ARGS]";
 
+static const char check_help[] =
+	"Perform stack metadata validation on an object file";
+static const char orc_help[] =
+	"Generate in-place ORC unwind tables for an object file";
+static const char fpv_help[] =
+	"Generate in-place FP validation tables for an object file";
+
 static struct cmd_struct objtool_cmds[] = {
-	{"check",	cmd_check,	"Perform stack metadata validation on an object file" },
-	{"orc",		cmd_orc,	"Generate in-place ORC unwind tables for an object file" },
+	{"check",	cmd_check,	check_help },
+	{"orc",		cmd_orc,	orc_help },
+	{"fpv",		cmd_fpv,	fpv_help },
 };
 
 bool help;
diff --git a/tools/objtool/weak.c b/tools/objtool/weak.c
index 8314e824db4a..5e56ad5fe0fe 100644
--- a/tools/objtool/weak.c
+++ b/tools/objtool/weak.c
@@ -29,3 +29,8 @@ int __weak orc_create(struct objtool_file *file)
 {
 	UNSUPPORTED("orc");
 }
+
+int __weak fpv_decode(struct objtool_file *file)
+{
+	UNSUPPORTED("fpv");
+}
-- 
2.25.1

