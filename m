Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1339531FC0
	for <lists+live-patching@lfdr.de>; Tue, 24 May 2022 02:18:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231140AbiEXARu (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 23 May 2022 20:17:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232091AbiEXAR3 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 23 May 2022 20:17:29 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BB3AD72213;
        Mon, 23 May 2022 17:17:07 -0700 (PDT)
Received: from x64host.home (unknown [47.189.24.195])
        by linux.microsoft.com (Postfix) with ESMTPSA id 8703720B8955;
        Mon, 23 May 2022 17:17:06 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 8703720B8955
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1653351427;
        bh=syoprsdej4CwEqysPiBnxYsuZxIUL2IqummhyMfwuKs=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=jmzMPJue8W13JKIJxHrm31Z+IrCiGzTbyg4geN4LH1l3NdMC7q8JIfO9+84Gl6MgK
         fd+S9ZmjkwUlbmBMoYsyd5JG7OzCHPiklaCOMchzYaMxMJxcWMFGpffAeXhTp7FXp9
         Gux9CKb7F8U5PAFtI2Xp6LA28/BW8ngSH98CFKuY=
From:   madvenka@linux.microsoft.com
To:     jpoimboe@redhat.com, peterz@infradead.org, chenzhongjin@huawei.com,
        mark.rutland@arm.com, broonie@kernel.org, nobuta.keiya@fujitsu.com,
        sjitindarsingh@gmail.com, catalin.marinas@arm.com, will@kernel.org,
        jamorris@linux.microsoft.com, linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        madvenka@linux.microsoft.com
Subject: [RFC PATCH v2 20/20] arm64: Enable livepatch for ARM64
Date:   Mon, 23 May 2022 19:16:37 -0500
Message-Id: <20220524001637.1707472-21-madvenka@linux.microsoft.com>
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

Enable livepatch in arch/arm64/Kconfig.

Signed-off-by: Madhavan T. Venkataraman <madvenka@linux.microsoft.com>
---
 arch/arm64/Kconfig | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index e6a7bfc85ff9..49e15402d8c1 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -225,6 +225,9 @@ config ARM64
 	select THREAD_INFO_IN_TASK
 	select HAVE_STACK_VALIDATION	if FRAME_POINTER_VALIDATION
 	select STACK_VALIDATION		if HAVE_STACK_VALIDATION
+	select HAVE_RELIABLE_STACKTRACE	if STACK_VALIDATION
+	select HAVE_LIVEPATCH		if HAVE_DYNAMIC_FTRACE_WITH_REGS && HAVE_RELIABLE_STACKTRACE
+
 	select HAVE_ARCH_USERFAULTFD_MINOR if USERFAULTFD
 	select TRACE_IRQFLAGS_SUPPORT
 	help
@@ -2160,3 +2163,5 @@ source "arch/arm64/kvm/Kconfig"
 if CRYPTO
 source "arch/arm64/crypto/Kconfig"
 endif
+
+source "kernel/livepatch/Kconfig"
-- 
2.25.1

