Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C0A142E6A2
	for <lists+live-patching@lfdr.de>; Fri, 15 Oct 2021 04:35:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235098AbhJOChF (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 14 Oct 2021 22:37:05 -0400
Received: from linux.microsoft.com ([13.77.154.182]:55460 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235105AbhJOChE (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 14 Oct 2021 22:37:04 -0400
Received: from x64host.home (unknown [47.187.212.181])
        by linux.microsoft.com (Postfix) with ESMTPSA id 6FC9420B9D22;
        Thu, 14 Oct 2021 19:34:57 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 6FC9420B9D22
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1634265298;
        bh=qZScEFTO+pORG9YKmb/gJbPlBbD1pvru4NrU3/YAom4=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=fPITtNCJx1AiyMyMCIsYoQM+nzWbH6BwA3I2FM3/ckjWOdtTOfl2VmSkZKZgDZCpG
         4FJkaRCfQMXmgBGF74uIlUh6Pw+U0iMGs9a5d//ARcfsgvSL5EscbhKxWdo335GpKt
         QSDnf+p7GwD71W+nzufJ69xTWYaL4ZlOseUHBWlU=
From:   madvenka@linux.microsoft.com
To:     mark.rutland@arm.com, broonie@kernel.org, jpoimboe@redhat.com,
        ardb@kernel.org, nobuta.keiya@fujitsu.com,
        sjitindarsingh@gmail.com, catalin.marinas@arm.com, will@kernel.org,
        jmorris@namei.org, linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        madvenka@linux.microsoft.com
Subject: [PATCH v9 04/11] arm64: Make return_address() use arch_stack_walk()
Date:   Thu, 14 Oct 2021 21:34:08 -0500
Message-Id: <20211015023413.16614-7-madvenka@linux.microsoft.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211015023413.16614-1-madvenka@linux.microsoft.com>
References: <c05ce30dcc9be1bd6b5e24a2ca8fe1d66246980b>
 <20211015023413.16614-1-madvenka@linux.microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>

Currently, return_address() in ARM64 code walks the stack using
start_backtrace() and walk_stackframe(). Make it use arch_stack_walk()
instead. This makes maintenance easier.

Signed-off-by: Madhavan T. Venkataraman <madvenka@linux.microsoft.com>
---
 arch/arm64/kernel/return_address.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/arch/arm64/kernel/return_address.c b/arch/arm64/kernel/return_address.c
index a6d18755652f..92a0f4d434e4 100644
--- a/arch/arm64/kernel/return_address.c
+++ b/arch/arm64/kernel/return_address.c
@@ -35,15 +35,11 @@ NOKPROBE_SYMBOL(save_return_addr);
 void *return_address(unsigned int level)
 {
 	struct return_address_data data;
-	struct stackframe frame;
 
 	data.level = level + 2;
 	data.addr = NULL;
 
-	start_backtrace(&frame,
-			(unsigned long)__builtin_frame_address(0),
-			(unsigned long)return_address);
-	walk_stackframe(current, &frame, save_return_addr, &data);
+	arch_stack_walk(save_return_addr, &data, current, NULL);
 
 	if (!data.level)
 		return data.addr;
-- 
2.25.1

