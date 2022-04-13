Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D62F4FF886
	for <lists+live-patching@lfdr.de>; Wed, 13 Apr 2022 16:06:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236042AbiDMOIM (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 13 Apr 2022 10:08:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236032AbiDMOIL (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 13 Apr 2022 10:08:11 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9ACF9606D8;
        Wed, 13 Apr 2022 07:05:49 -0700 (PDT)
Received: from x64host.home (unknown [47.189.24.195])
        by linux.microsoft.com (Postfix) with ESMTPSA id AB40620C34D6;
        Wed, 13 Apr 2022 07:05:48 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com AB40620C34D6
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1649858749;
        bh=8+0+tmm79ZrOnS9Zex8wU0cF214m6bSiOKEXuw55Khc=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=Pw/QzKvPDTcghlquUWShrj8eWjhVvq+I6/fEsHWC7vHYZj3fZi5gHMm1Eu4Bhioh1
         jL2NcGP4CU7Av09C35RGurajGnUFZXPW2rgAChufHAM9pdhrbEUclP1kZEsVXFBZkC
         5+KYLZz1GWTmC80X0mkhryl4YonZFe8f/AHvuYgg=
From:   madvenka@linux.microsoft.com
To:     mark.rutland@arm.com, broonie@kernel.org, jpoimboe@redhat.com,
        ardb@kernel.org, nobuta.keiya@fujitsu.com,
        sjitindarsingh@gmail.com, catalin.marinas@arm.com, will@kernel.org,
        jmorris@namei.org, linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        madvenka@linux.microsoft.com
Subject: [PATCH v14 7/7] arm64: Select HAVE_RELIABLE_STACKTRACE
Date:   Wed, 13 Apr 2022 09:05:28 -0500
Message-Id: <20220413140528.3815-8-madvenka@linux.microsoft.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220413140528.3815-1-madvenka@linux.microsoft.com>
References: <f460a35f88195413bcf7305e5083480aab3ca858>
 <20220413140528.3815-1-madvenka@linux.microsoft.com>
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

Select HAVE_RELIABLE_STACKTRACE in arm64/Kconfig to allow
arch_stack_walk_reliable() to be used.

Note that this is conditional upon STACK_VALIDATION which will be added
when frame pointer validation is implemented (say via objtool).

Signed-off-by: Madhavan T. Venkataraman <madvenka@linux.microsoft.com>
---
 arch/arm64/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 57c4c995965f..f7b9d0fecf95 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -225,6 +225,7 @@ config ARM64
 	select THREAD_INFO_IN_TASK
 	select HAVE_ARCH_USERFAULTFD_MINOR if USERFAULTFD
 	select TRACE_IRQFLAGS_SUPPORT
+	select HAVE_RELIABLE_STACKTRACE if FRAME_POINTER && STACK_VALIDATION
 	help
 	  ARM 64-bit (AArch64) Linux support.
 
-- 
2.25.1

