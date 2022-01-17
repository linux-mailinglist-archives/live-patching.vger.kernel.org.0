Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A928490AE5
	for <lists+live-patching@lfdr.de>; Mon, 17 Jan 2022 15:57:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240249AbiAQO4m (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 17 Jan 2022 09:56:42 -0500
Received: from linux.microsoft.com ([13.77.154.182]:59502 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240255AbiAQO4g (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 17 Jan 2022 09:56:36 -0500
Received: from x64host.home (unknown [47.187.212.181])
        by linux.microsoft.com (Postfix) with ESMTPSA id E010E20B9137;
        Mon, 17 Jan 2022 06:56:34 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com E010E20B9137
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1642431395;
        bh=BKQVFrzc9NWvFdLTdrRxXKa1sIlB+Nm5XhtURANzAOE=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=qWkTAEUEiL8JCNmJH4E+PQCIMLN6T1rZxsyo/jtsOmI/DWe2yh8ACu0wnbSHqTHza
         93pXi/I3ysWVdIWUYbHCyq8tGiQKq1epNuqM5xlFWMICH0UaFZkURHY5DDlkJQWn/e
         i0/KEsCdIURpWJ0Ddkh78hpBKfQ0Ehp2ZdhcpgcU=
From:   madvenka@linux.microsoft.com
To:     mark.rutland@arm.com, broonie@kernel.org, jpoimboe@redhat.com,
        ardb@kernel.org, nobuta.keiya@fujitsu.com,
        sjitindarsingh@gmail.com, catalin.marinas@arm.com, will@kernel.org,
        jmorris@namei.org, linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        madvenka@linux.microsoft.com
Subject: [PATCH v13 11/11] arm64: Select HAVE_RELIABLE_STACKTRACE
Date:   Mon, 17 Jan 2022 08:56:08 -0600
Message-Id: <20220117145608.6781-12-madvenka@linux.microsoft.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220117145608.6781-1-madvenka@linux.microsoft.com>
References: <95691cae4f4504f33d0fc9075541b1e7deefe96f>
 <20220117145608.6781-1-madvenka@linux.microsoft.com>
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
index f6e333b59314..bc7b3514b563 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -223,6 +223,7 @@ config ARM64
 	select THREAD_INFO_IN_TASK
 	select HAVE_ARCH_USERFAULTFD_MINOR if USERFAULTFD
 	select TRACE_IRQFLAGS_SUPPORT
+	select HAVE_RELIABLE_STACKTRACE if FRAME_POINTER && STACK_VALIDATION
 	help
 	  ARM 64-bit (AArch64) Linux support.
 
-- 
2.25.1

