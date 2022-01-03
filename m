Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E21B948351E
	for <lists+live-patching@lfdr.de>; Mon,  3 Jan 2022 17:52:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231756AbiACQws (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 3 Jan 2022 11:52:48 -0500
Received: from linux.microsoft.com ([13.77.154.182]:53158 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231622AbiACQwp (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 3 Jan 2022 11:52:45 -0500
Received: from x64host.home (unknown [47.187.212.181])
        by linux.microsoft.com (Postfix) with ESMTPSA id CE75920B717A;
        Mon,  3 Jan 2022 08:52:44 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com CE75920B717A
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1641228765;
        bh=YL0/rwGfLusLcXbXJfaP6PJh5+D2PxMoErb3hzo3tiU=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=GDc/rmeHIUeY0VZNBUg9VQctr1fTXiY1RP9TcKim+A4HKwoeO7IpOVOYc+emp90Jt
         MjbIlZReiueS5r8yh0mV6DKoMdMcFU03C+PTtO5L9QKwJHIoNgLsNQVkuFO9mbOg1Y
         aqgiAHniikgTsfk3KTMqlhrmZWSCOrbpeGFe2m0k=
From:   madvenka@linux.microsoft.com
To:     mark.rutland@arm.com, broonie@kernel.org, jpoimboe@redhat.com,
        ardb@kernel.org, nobuta.keiya@fujitsu.com,
        sjitindarsingh@gmail.com, catalin.marinas@arm.com, will@kernel.org,
        jmorris@namei.org, linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        madvenka@linux.microsoft.com
Subject: [PATCH v12 01/10] arm64: Remove NULL task check from unwind_frame()
Date:   Mon,  3 Jan 2022 10:52:03 -0600
Message-Id: <20220103165212.9303-2-madvenka@linux.microsoft.com>
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

Currently, there is a check for a NULL task in unwind_frame(). It is not
needed since all current consumers pass a non-NULL task.

Signed-off-by: Madhavan T. Venkataraman <madvenka@linux.microsoft.com>
Reviewed-by: Mark Brown <broonie@kernel.org>
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

