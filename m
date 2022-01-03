Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BF1948352B
	for <lists+live-patching@lfdr.de>; Mon,  3 Jan 2022 17:53:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234914AbiACQw6 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 3 Jan 2022 11:52:58 -0500
Received: from linux.microsoft.com ([13.77.154.182]:53338 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234954AbiACQwz (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 3 Jan 2022 11:52:55 -0500
Received: from x64host.home (unknown [47.187.212.181])
        by linux.microsoft.com (Postfix) with ESMTPSA id CD85420B718D;
        Mon,  3 Jan 2022 08:52:53 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com CD85420B718D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1641228774;
        bh=L7BINNZKLPpPqJ8YVvJ1Ceh6JZSHPJZT929hJRDYxLM=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=BgFvMnffEcMsB/tWPa67ElUGVIsgWCNjz/7jBojGCmyp8WVfd9ecskZUTib1C/D9q
         IdSIOQcqGxJyN9uN0YakvIL7Ho5+/cB6O+nYX7wKJAGN9jpyKN53eQZavQH8QZCDJO
         JQfKtpbSY0cCCJnMkI+AeRtHSi8omCIxkRskEaYI=
From:   madvenka@linux.microsoft.com
To:     mark.rutland@arm.com, broonie@kernel.org, jpoimboe@redhat.com,
        ardb@kernel.org, nobuta.keiya@fujitsu.com,
        sjitindarsingh@gmail.com, catalin.marinas@arm.com, will@kernel.org,
        jmorris@namei.org, linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        madvenka@linux.microsoft.com
Subject: [PATCH v12 10/10] arm64: Select HAVE_RELIABLE_STACKTRACE
Date:   Mon,  3 Jan 2022 10:52:12 -0600
Message-Id: <20220103165212.9303-11-madvenka@linux.microsoft.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220103165212.9303-1-madvenka@linux.microsoft.com>
References: <0d0eb36f348fb5a6af6eb592c0525f6e94007328>
 <20220103165212.9303-1-madvenka@linux.microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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
index c4207cf9bb17..4f6312784650 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -222,6 +222,7 @@ config ARM64
 	select THREAD_INFO_IN_TASK
 	select HAVE_ARCH_USERFAULTFD_MINOR if USERFAULTFD
 	select TRACE_IRQFLAGS_SUPPORT
+	select HAVE_RELIABLE_STACKTRACE if FRAME_POINTER && STACK_VALIDATION
 	help
 	  ARM 64-bit (AArch64) Linux support.
 
-- 
2.25.1

