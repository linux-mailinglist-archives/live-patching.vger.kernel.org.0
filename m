Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AEF76876A9
	for <lists+live-patching@lfdr.de>; Thu,  2 Feb 2023 08:43:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232063AbjBBHnp (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 2 Feb 2023 02:43:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232073AbjBBHnZ (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 2 Feb 2023 02:43:25 -0500
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3A61C8496B;
        Wed,  1 Feb 2023 23:42:46 -0800 (PST)
Received: from x64host.home (unknown [47.187.213.40])
        by linux.microsoft.com (Postfix) with ESMTPSA id 9414B2086206;
        Wed,  1 Feb 2023 23:42:44 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 9414B2086206
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1675323765;
        bh=Z5kdOOhYeHggthgMW9m8t9VXx+iuiwxiRYiTtxW8O8M=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=kcj3J5nb4s9m/mJpYcx+0xmHpuI0hmsAgZY7rDqHp4KBk9UntvO5DWZIY4Ba3OYzy
         w/5FolkML12UdtH3P82p7qTJ15h1CR7M44uMBLjDqdF4EKs85SaU1Amd2AvNxeoqYy
         sQ1P4XB3jXlRU53jMkGHziCHKr87eMymH/O7LmTY=
From:   madvenka@linux.microsoft.com
To:     jpoimboe@redhat.com, peterz@infradead.org, chenzhongjin@huawei.com,
        mark.rutland@arm.com, broonie@kernel.org, nobuta.keiya@fujitsu.com,
        sjitindarsingh@gmail.com, catalin.marinas@arm.com, will@kernel.org,
        jamorris@linux.microsoft.com, linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        madvenka@linux.microsoft.com
Subject: [RFC PATCH v3 20/22] arm64: Define HAVE_DYNAMIC_FTRACE_WITH_ARGS
Date:   Thu,  2 Feb 2023 01:40:34 -0600
Message-Id: <20230202074036.507249-21-madvenka@linux.microsoft.com>
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

	- Define HAVE_DYNAMIC_FTRACE_WITH_ARGS to support livepatch.

	- Supply the arch code for HAVE_DYNAMIC_FTRACE_WITH_ARGS.

Signed-off-by: Madhavan T. Venkataraman <madvenka@linux.microsoft.com>
---
 arch/arm64/Kconfig.debug        |  1 +
 arch/arm64/include/asm/ftrace.h | 20 ++++++++++++++++++++
 2 files changed, 21 insertions(+)

diff --git a/arch/arm64/Kconfig.debug b/arch/arm64/Kconfig.debug
index a50caabdb18e..6d5dc90a0a52 100644
--- a/arch/arm64/Kconfig.debug
+++ b/arch/arm64/Kconfig.debug
@@ -45,6 +45,7 @@ config FRAME_POINTER_VALIDATION
 	bool "Dynamic Frame pointer validation"
 	select UNWINDER_FRAME_POINTER
 	select UNWINDER_ORC
+	select HAVE_DYNAMIC_FTRACE_WITH_ARGS
 	help
 		This invokes objtool on every object file causing it to
 		generate ORC data for the object file. ORC data is in a custom
diff --git a/arch/arm64/include/asm/ftrace.h b/arch/arm64/include/asm/ftrace.h
index 329dbbd4d50b..0bc03ecfb257 100644
--- a/arch/arm64/include/asm/ftrace.h
+++ b/arch/arm64/include/asm/ftrace.h
@@ -78,6 +78,26 @@ static inline unsigned long ftrace_call_adjust(unsigned long addr)
 	return addr;
 }
 
+#ifdef CONFIG_HAVE_DYNAMIC_FTRACE_WITH_ARGS
+
+struct ftrace_regs {
+	struct pt_regs		regs;
+};
+
+static __always_inline struct pt_regs *
+arch_ftrace_get_regs(struct ftrace_regs *fregs)
+{
+	return &fregs->regs;
+}
+
+static __always_inline void ftrace_instruction_pointer_set(
+				struct ftrace_regs *fregs, unsigned long pc)
+{
+	fregs->regs.pc = pc;
+}
+
+#endif
+
 #ifdef CONFIG_DYNAMIC_FTRACE_WITH_REGS
 struct dyn_ftrace;
 struct ftrace_ops;
-- 
2.25.1

