Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 989684F89BA
	for <lists+live-patching@lfdr.de>; Fri,  8 Apr 2022 00:15:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229972AbiDGUkK (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 7 Apr 2022 16:40:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230052AbiDGUj5 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 7 Apr 2022 16:39:57 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 14E93354D17;
        Thu,  7 Apr 2022 13:26:09 -0700 (PDT)
Received: from x64host.home (unknown [47.189.24.195])
        by linux.microsoft.com (Postfix) with ESMTPSA id 324E6201CBCC;
        Thu,  7 Apr 2022 13:26:08 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 324E6201CBCC
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1649363168;
        bh=pBJjoP6HBM9BMHnhHHaiEURpWVqcRsKUpUuk8SoRtTQ=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=a6NRBZTILpb2I0lPawXCowwNYiD5FEHMK9pnYTYL3zeo3UtYuyZDY/GujINlEz7wv
         qFozDl4KHfDQ8vp5BnZmx++lCPlxttAFcDLT01GS2qmbo8vbFLwFaYM821aRGiAxuV
         JSfKebUPQR2MinG3+tfTzHuG2JDatLISytOmUJ74=
From:   madvenka@linux.microsoft.com
To:     mark.rutland@arm.com, broonie@kernel.org, jpoimboe@redhat.com,
        ardb@kernel.org, nobuta.keiya@fujitsu.com,
        sjitindarsingh@gmail.com, catalin.marinas@arm.com, will@kernel.org,
        jmorris@namei.org, linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        madvenka@linux.microsoft.com
Subject: [RFC PATCH v1 9/9] dwarf: Enable livepatch for ARM64
Date:   Thu,  7 Apr 2022 15:25:18 -0500
Message-Id: <20220407202518.19780-10-madvenka@linux.microsoft.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220407202518.19780-1-madvenka@linux.microsoft.com>
References: <95691cae4f4504f33d0fc9075541b1e7deefe96f>
 <20220407202518.19780-1-madvenka@linux.microsoft.com>
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

Enable livepatch in arch/arm64/Kconfig.

Signed-off-by: Madhavan T. Venkataraman <madvenka@linux.microsoft.com>
---
 arch/arm64/Kconfig | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index c82a3a93297f..6cb00b3770cf 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -222,6 +222,9 @@ config ARM64
 	select THREAD_INFO_IN_TASK
 	select HAVE_STACK_VALIDATION	if DWARF_FP
 	select STACK_VALIDATION		if HAVE_STACK_VALIDATION
+	select HAVE_RELIABLE_STACKTRACE	if STACK_VALIDATION
+	select HAVE_LIVEPATCH		if HAVE_DYNAMIC_FTRACE_WITH_REGS && HAVE_RELIABLE_STACKTRACE
+
 	select HAVE_ARCH_USERFAULTFD_MINOR if USERFAULTFD
 	select TRACE_IRQFLAGS_SUPPORT
 	help
@@ -2066,3 +2069,5 @@ source "arch/arm64/kvm/Kconfig"
 if CRYPTO
 source "arch/arm64/crypto/Kconfig"
 endif
+
+source "kernel/livepatch/Kconfig"
-- 
2.25.1

