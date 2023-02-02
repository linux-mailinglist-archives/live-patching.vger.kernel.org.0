Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 951E76876AF
	for <lists+live-patching@lfdr.de>; Thu,  2 Feb 2023 08:44:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232177AbjBBHn7 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 2 Feb 2023 02:43:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232195AbjBBHnj (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 2 Feb 2023 02:43:39 -0500
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7A2A45FD3;
        Wed,  1 Feb 2023 23:43:00 -0800 (PST)
Received: from x64host.home (unknown [47.187.213.40])
        by linux.microsoft.com (Postfix) with ESMTPSA id 902872086209;
        Wed,  1 Feb 2023 23:42:46 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 902872086209
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1675323767;
        bh=rKRdvIoFhmLu94J10M1hjhJkCmPu9SVBqnqj3sarP8g=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=AwuokGIE5/2zTLGGDfA54LPomEEh7qwCRkhTmJIYot2YL+G8Pxg6t00zBSx9ozfwn
         XAIDCY11tyypgPR9qacDC3jkRNwqdF08iZzegu5yEpvWZIN+T5IQuLMTIpB3RPDkqR
         AQkghR7HK3d+Ht9bmmE8omlP23da//sjAl2DHYkc=
From:   madvenka@linux.microsoft.com
To:     jpoimboe@redhat.com, peterz@infradead.org, chenzhongjin@huawei.com,
        mark.rutland@arm.com, broonie@kernel.org, nobuta.keiya@fujitsu.com,
        sjitindarsingh@gmail.com, catalin.marinas@arm.com, will@kernel.org,
        jamorris@linux.microsoft.com, linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        madvenka@linux.microsoft.com
Subject: [RFC PATCH v3 22/22] arm64: Enable livepatch for ARM64
Date:   Thu,  2 Feb 2023 01:40:36 -0600
Message-Id: <20230202074036.507249-23-madvenka@linux.microsoft.com>
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

Enable livepatch in arch/arm64/Kconfig.

Signed-off-by: Madhavan T. Venkataraman <madvenka@linux.microsoft.com>
---
 arch/arm64/Kconfig | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 73c3f30a37c7..01f802935dda 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -232,6 +232,8 @@ config ARM64
 	select HAVE_SOFTIRQ_ON_OWN_STACK
 	select HAVE_STACK_VALIDATION	if FRAME_POINTER_VALIDATION
 	select STACK_VALIDATION		if HAVE_STACK_VALIDATION
+	select HAVE_RELIABLE_STACKTRACE	if STACK_VALIDATION
+	select HAVE_LIVEPATCH		if HAVE_DYNAMIC_FTRACE_WITH_REGS && HAVE_RELIABLE_STACKTRACE
 	help
 	  ARM 64-bit (AArch64) Linux support.
 
@@ -2269,3 +2271,4 @@ source "drivers/acpi/Kconfig"
 
 source "arch/arm64/kvm/Kconfig"
 
+source "kernel/livepatch/Kconfig"
-- 
2.25.1

