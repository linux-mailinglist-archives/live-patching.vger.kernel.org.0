Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3699490AD5
	for <lists+live-patching@lfdr.de>; Mon, 17 Jan 2022 15:56:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239349AbiAQO41 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 17 Jan 2022 09:56:27 -0500
Received: from linux.microsoft.com ([13.77.154.182]:59402 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239064AbiAQO40 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 17 Jan 2022 09:56:26 -0500
Received: from x64host.home (unknown [47.187.212.181])
        by linux.microsoft.com (Postfix) with ESMTPSA id DF10920B9132;
        Mon, 17 Jan 2022 06:56:24 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com DF10920B9132
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1642431385;
        bh=rhBHT4pWL2EtwnMnXHgdH8kKNewQrrrjf2uA0J7NbA8=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=nzZvszMwzJPT/hLbYHnUV+wx3gVYk8YiVpdlSWKnEYVEkPOL6BXk0LyNvI53jiIRX
         HAtLP1HZ/n2AuOxl9SG6RP+sKkBrQOovtM/JaZITY4DP0pVsyU3EcVVVpa9vHX9crB
         sprEvRzK63heR62MevwiNV04lF9xlOO0Kf74QCqA=
From:   madvenka@linux.microsoft.com
To:     mark.rutland@arm.com, broonie@kernel.org, jpoimboe@redhat.com,
        ardb@kernel.org, nobuta.keiya@fujitsu.com,
        sjitindarsingh@gmail.com, catalin.marinas@arm.com, will@kernel.org,
        jmorris@namei.org, linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        madvenka@linux.microsoft.com
Subject: [PATCH v13 01/11] arm64: Remove NULL task check from unwind_frame()
Date:   Mon, 17 Jan 2022 08:55:58 -0600
Message-Id: <20220117145608.6781-2-madvenka@linux.microsoft.com>
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

Currently, there is a check for a NULL task in unwind_frame(). It is not
needed since all current consumers pass a non-NULL task.

Signed-off-by: Madhavan T. Venkataraman <madvenka@linux.microsoft.com>
Reviewed-by: Mark Brown <broonie@kernel.org>
Reviewed-by: Mark Rutland <mark.rutland@arm.com>
---
 arch/arm64/kernel/stacktrace.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/arm64/kernel/stacktrace.c b/arch/arm64/kernel/stacktrace.c
index 0fb58fed54cb..5f5bb35b7b41 100644
--- a/arch/arm64/kernel/stacktrace.c
+++ b/arch/arm64/kernel/stacktrace.c
@@ -69,9 +69,6 @@ static int notrace unwind_frame(struct task_struct *tsk,
 	unsigned long fp = frame->fp;
 	struct stack_info info;
 
-	if (!tsk)
-		tsk = current;
-
 	/* Final frame; nothing to unwind */
 	if (fp == (unsigned long)task_pt_regs(tsk)->stackframe)
 		return -ENOENT;
-- 
2.25.1

