Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05F1D42E6EB
	for <lists+live-patching@lfdr.de>; Fri, 15 Oct 2021 04:59:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233878AbhJODBK (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 14 Oct 2021 23:01:10 -0400
Received: from linux.microsoft.com ([13.77.154.182]:58120 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234124AbhJODBK (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 14 Oct 2021 23:01:10 -0400
Received: from x64host.home (unknown [47.187.212.181])
        by linux.microsoft.com (Postfix) with ESMTPSA id 6CCCA20B9D1C;
        Thu, 14 Oct 2021 19:59:03 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 6CCCA20B9D1C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1634266744;
        bh=0yghf4gyl+zuLPydKc3wkqnxys2UvYghl6oElnkiR2M=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=q92AH8yQOnrbpPu1+rvgRHk4kgLV3xQy81DDuXSYiOxlY03kc8BdrRq9Gpyh6wNQj
         av1dMLOD+/I/VCFJr0qk4jD8Flmagw5ycaIfNMFDXyjLJaCiDiN1TKF3n8WwE7nkJd
         T37iNdTqs7mrAPsgngHWYT8Gpd8Pa0eURvMQt55Q=
From:   madvenka@linux.microsoft.com
To:     mark.rutland@arm.com, broonie@kernel.org, jpoimboe@redhat.com,
        ardb@kernel.org, nobuta.keiya@fujitsu.com,
        sjitindarsingh@gmail.com, catalin.marinas@arm.com, will@kernel.org,
        jmorris@namei.org, linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        madvenka@linux.microsoft.com
Subject: [PATCH v10 01/11] arm64: Select STACKTRACE in arch/arm64/Kconfig
Date:   Thu, 14 Oct 2021 21:58:37 -0500
Message-Id: <20211015025847.17694-2-madvenka@linux.microsoft.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211015025847.17694-1-madvenka@linux.microsoft.com>
References: <c05ce30dcc9be1bd6b5e24a2ca8fe1d66246980b>
 <20211015025847.17694-1-madvenka@linux.microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>

Currently, there are multiple functions in ARM64 code that walk the
stack using start_backtrace() and unwind_frame() or start_backtrace()
and walk_stackframe(). They should all be converted to use
arch_stack_walk(). This makes maintenance easier.

To do that, arch_stack_walk() must always be defined. arch_stack_walk()
is within #ifdef CONFIG_STACKTRACE. So, select STACKTRACE in
arch/arm64/Kconfig.

Signed-off-by: Madhavan T. Venkataraman <madvenka@linux.microsoft.com>
---
 arch/arm64/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index fdcd54d39c1e..bfb0ce60d820 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -35,6 +35,7 @@ config ARM64
 	select ARCH_HAS_SET_DIRECT_MAP
 	select ARCH_HAS_SET_MEMORY
 	select ARCH_STACKWALK
+	select STACKTRACE
 	select ARCH_HAS_STRICT_KERNEL_RWX
 	select ARCH_HAS_STRICT_MODULE_RWX
 	select ARCH_HAS_SYNC_DMA_FOR_DEVICE
-- 
2.25.1

