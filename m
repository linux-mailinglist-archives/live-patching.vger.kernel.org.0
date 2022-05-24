Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34565531FAF
	for <lists+live-patching@lfdr.de>; Tue, 24 May 2022 02:17:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230481AbiEXARQ (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 23 May 2022 20:17:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231893AbiEXARH (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 23 May 2022 20:17:07 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8FFA073574;
        Mon, 23 May 2022 17:17:00 -0700 (PDT)
Received: from x64host.home (unknown [47.189.24.195])
        by linux.microsoft.com (Postfix) with ESMTPSA id 840CD20B8968;
        Mon, 23 May 2022 17:16:59 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 840CD20B8968
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1653351420;
        bh=L/zVpQucNi7H5ecmmGZpBtWf3xyfz9caTMZwGZoyPb8=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=SCsal7wIoTOh0RTw4YSmNL6lsw6JYsOoXBp2B84WHf60eScEGnfiLPENyQW0TbnBF
         uCkG3E+ZnohnDGWGv/gmBU5Y0k/tr27GKAM/OyvN0h9KtFifJusnJzdZ0YzIVTjb40
         CCx4NNCfGg71eK/I099mC1w6dWDf5zWqXgGjqKL4=
From:   madvenka@linux.microsoft.com
To:     jpoimboe@redhat.com, peterz@infradead.org, chenzhongjin@huawei.com,
        mark.rutland@arm.com, broonie@kernel.org, nobuta.keiya@fujitsu.com,
        sjitindarsingh@gmail.com, catalin.marinas@arm.com, will@kernel.org,
        jamorris@linux.microsoft.com, linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        madvenka@linux.microsoft.com
Subject: [RFC PATCH v2 13/20] objtool: arm64: Dump ORC data present in object files
Date:   Mon, 23 May 2022 19:16:30 -0500
Message-Id: <20220524001637.1707472-14-madvenka@linux.microsoft.com>
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

Call orc_dump() from cmd_fpv() to dump the ORC sections in an object
file. This is for debug purposes.

Signed-off-by: Madhavan T. Venkataraman <madvenka@linux.microsoft.com>
---
 tools/objtool/Build         | 1 +
 tools/objtool/builtin-fpv.c | 4 ++++
 2 files changed, 5 insertions(+)

diff --git a/tools/objtool/Build b/tools/objtool/Build
index 5de79c76f3f0..d40ee95039cf 100644
--- a/tools/objtool/Build
+++ b/tools/objtool/Build
@@ -20,6 +20,7 @@ objtool-$(SUBCMD_FPV) += cfi.o
 objtool-$(SUBCMD_FPV) += insn.o
 objtool-$(SUBCMD_FPV) += decode.o
 objtool-$(SUBCMD_FPV) += orc_gen.o
+objtool-$(SUBCMD_FPV) += orc_dump.o
 
 objtool-y += builtin-check.o
 objtool-y += builtin-orc.o
diff --git a/tools/objtool/builtin-fpv.c b/tools/objtool/builtin-fpv.c
index bc8f88f204b5..7934c569e60a 100644
--- a/tools/objtool/builtin-fpv.c
+++ b/tools/objtool/builtin-fpv.c
@@ -19,6 +19,7 @@
 
 static const char * const fpv_usage[] = {
 	"objtool fpv generate file.o",
+	"objtool fpv dump file.o",
 	NULL,
 };
 
@@ -69,6 +70,9 @@ int cmd_fpv(int argc, const char **argv)
 		return elf_write(file->elf);
 	}
 
+	if (!strcmp(argv[0], "dump"))
+		return orc_dump(objname);
+
 	usage_with_options(fpv_usage, fpv_options);
 
 	return 0;
-- 
2.25.1

