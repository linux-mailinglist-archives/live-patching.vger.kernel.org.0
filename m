Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B195490AE0
	for <lists+live-patching@lfdr.de>; Mon, 17 Jan 2022 15:57:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239957AbiAQO4i (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 17 Jan 2022 09:56:38 -0500
Received: from linux.microsoft.com ([13.77.154.182]:59488 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239983AbiAQO4b (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 17 Jan 2022 09:56:31 -0500
Received: from x64host.home (unknown [47.187.212.181])
        by linux.microsoft.com (Postfix) with ESMTPSA id DFFED20B913A;
        Mon, 17 Jan 2022 06:56:29 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com DFFED20B913A
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1642431390;
        bh=2pCZVm8MtKA36IH8thLS7DpFXD0j/nj2Mxtd3QCoxKQ=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=rCer+V83dEQpthi9Cg459ZrRToi90T/9efdI9SsiNnY3oGwYq+jHVn1Ea4f0nP6Wp
         l0Xr7Jr/1FzTl4uAoV95W35x1OudhGCfym/KFARfkD+BdDdT/TxSQZCexRc2kSI8Ho
         JYoYU2L6FszLjyeS4Nsr7MEY2xCmGTgayB1HJ4FA=
From:   madvenka@linux.microsoft.com
To:     mark.rutland@arm.com, broonie@kernel.org, jpoimboe@redhat.com,
        ardb@kernel.org, nobuta.keiya@fujitsu.com,
        sjitindarsingh@gmail.com, catalin.marinas@arm.com, will@kernel.org,
        jmorris@namei.org, linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        madvenka@linux.microsoft.com
Subject: [PATCH v13 06/11] arm64: Use stack_trace_consume_fn and rename args to unwind()
Date:   Mon, 17 Jan 2022 08:56:03 -0600
Message-Id: <20220117145608.6781-7-madvenka@linux.microsoft.com>
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

Rename the arguments to unwind() for better consistency. Also, use the
typedef stack_trace_consume_fn for the consume_entry function as it is
already defined in linux/stacktrace.h.

Signed-off-by: Madhavan T. Venkataraman <madvenka@linux.microsoft.com>
---
 arch/arm64/kernel/stacktrace.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kernel/stacktrace.c b/arch/arm64/kernel/stacktrace.c
index 1b32e55735aa..f772dac78b11 100644
--- a/arch/arm64/kernel/stacktrace.c
+++ b/arch/arm64/kernel/stacktrace.c
@@ -181,12 +181,12 @@ static int notrace unwind_next(struct unwind_state *state)
 NOKPROBE_SYMBOL(unwind_next);
 
 static void notrace unwind(struct unwind_state *state,
-			   bool (*fn)(void *, unsigned long), void *data)
+			   stack_trace_consume_fn consume_entry, void *cookie)
 {
 	while (1) {
 		int ret;
 
-		if (!fn(data, state->pc))
+		if (!consume_entry(cookie, state->pc))
 			break;
 		ret = unwind_next(state);
 		if (ret < 0)
-- 
2.25.1

