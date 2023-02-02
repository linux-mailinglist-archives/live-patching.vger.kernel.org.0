Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB31068768F
	for <lists+live-patching@lfdr.de>; Thu,  2 Feb 2023 08:42:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232000AbjBBHmv (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 2 Feb 2023 02:42:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231917AbjBBHmm (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 2 Feb 2023 02:42:42 -0500
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B34268494A;
        Wed,  1 Feb 2023 23:42:33 -0800 (PST)
Received: from x64host.home (unknown [47.187.213.40])
        by linux.microsoft.com (Postfix) with ESMTPSA id AD63B20B74FF;
        Wed,  1 Feb 2023 23:42:32 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com AD63B20B74FF
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1675323753;
        bh=52SrY+gLkGQ+qY0RKHseR68Es2aziku7Iq+7Kj3IvpA=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=RUt80pjNp8C7trJI0sPTY1QI6sO7KgTQpWVd5pInOxNNd/XWFYJ1TUZS+69s9qN/6
         OwruZ8I1N1PDYZXxQsgW6hzU2KESnVVqsn6j1IOeCcdNnEDAKF8o/BokI8HmeiETUG
         btkxQ9AB+SmHdZ4i2C8s/js9ajspwZApYakUgFK0=
From:   madvenka@linux.microsoft.com
To:     jpoimboe@redhat.com, peterz@infradead.org, chenzhongjin@huawei.com,
        mark.rutland@arm.com, broonie@kernel.org, nobuta.keiya@fujitsu.com,
        sjitindarsingh@gmail.com, catalin.marinas@arm.com, will@kernel.org,
        jamorris@linux.microsoft.com, linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        madvenka@linux.microsoft.com
Subject: [RFC PATCH v3 08/22] objtool: Introduce STATIC_CHECK
Date:   Thu,  2 Feb 2023 01:40:22 -0600
Message-Id: <20230202074036.507249-9-madvenka@linux.microsoft.com>
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

Objtool currently implements static stack validation. Another method called
dynamic validation can be supported for other architectures.

Define STATIC_CHECK to select the files required for static validation
in objtool build.

Signed-off-by: Madhavan T. Venkataraman <madvenka@linux.microsoft.com>
---
 tools/objtool/Build    | 6 +++---
 tools/objtool/Makefile | 3 ++-
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/tools/objtool/Build b/tools/objtool/Build
index c4666d0b40ba..974290dc4aac 100644
--- a/tools/objtool/Build
+++ b/tools/objtool/Build
@@ -2,13 +2,13 @@ objtool-y += arch/$(SRCARCH)/
 
 objtool-y += weak.o
 
-objtool-y += check.o
-objtool-y += special.o
+objtool-$(STATIC_CHECK) += check.o
+objtool-$(STATIC_CHECK) += special.o
 objtool-y += builtin-check.o
 objtool-y += cfi.o
 objtool-y += insn.o
 objtool-y += decode.o
-objtool-y += unwind_hints.o
+objtool-$(STATIC_CHECK) += unwind_hints.o
 objtool-y += elf.o
 objtool-y += objtool.o
 
diff --git a/tools/objtool/Makefile b/tools/objtool/Makefile
index a3a9cc24e0e3..797d1ea02db0 100644
--- a/tools/objtool/Makefile
+++ b/tools/objtool/Makefile
@@ -43,9 +43,10 @@ BUILD_ORC := n
 
 ifeq ($(SRCARCH),x86)
 	BUILD_ORC := y
+	STATIC_CHECK := y
 endif
 
-export BUILD_ORC
+export BUILD_ORC STATIC_CHECK
 export srctree OUTPUT CFLAGS SRCARCH AWK
 include $(srctree)/tools/build/Makefile.include
 
-- 
2.25.1

