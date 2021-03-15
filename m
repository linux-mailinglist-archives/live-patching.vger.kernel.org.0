Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3D4F33C2D7
	for <lists+live-patching@lfdr.de>; Mon, 15 Mar 2021 17:59:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234609AbhCOQ6p (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 15 Mar 2021 12:58:45 -0400
Received: from linux.microsoft.com ([13.77.154.182]:51050 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231590AbhCOQ6O (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 15 Mar 2021 12:58:14 -0400
Received: from x64host.home (unknown [47.187.194.202])
        by linux.microsoft.com (Postfix) with ESMTPSA id 0D28B20B26FA;
        Mon, 15 Mar 2021 09:58:12 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 0D28B20B26FA
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1615827493;
        bh=0gTjptmyQZ07PiZCSnD/YKcvyyL392ig4rm2FEjYn/Y=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=R91XTzYfYCb0ZGw7P5w4k2c0wPMwNZx0Cb+QOzipMegJEzUGor2RF4EgdBmkFiCl2
         myKycQk1amy6owG1HVBpw2L8EDnrxOhlsmEcvGJNMcxBmYgdrTzwMJWJ4ZHWh8xB4g
         +vEDShINtXTKrHlAz0KkHIh8BpePpQG/nsUveU70=
From:   madvenka@linux.microsoft.com
To:     broonie@kernel.org, mark.rutland@arm.com, jpoimboe@redhat.com,
        jthierry@redhat.com, catalin.marinas@arm.com, will@kernel.org,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        madvenka@linux.microsoft.com
Subject: [RFC PATCH v2 3/8] arm64: Terminate the stack trace at TASK_FRAME and EL0_FRAME
Date:   Mon, 15 Mar 2021 11:57:55 -0500
Message-Id: <20210315165800.5948-4-madvenka@linux.microsoft.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210315165800.5948-1-madvenka@linux.microsoft.com>
References: <5997dfe8d261a3a543667b83c902883c1e4bd270>
 <20210315165800.5948-1-madvenka@linux.microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>

Implement the following checks in the unwinder to detect the terminating
frame reliably:

	- The frame must end in task_pt_regs(task)->stackframe.

	- The frame type must be either TASK_FRAME or EL0_FRAME.

Signed-off-by: Madhavan T. Venkataraman <madvenka@linux.microsoft.com>
---
 arch/arm64/kernel/stacktrace.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kernel/stacktrace.c b/arch/arm64/kernel/stacktrace.c
index ad20981dfda4..504cd161339d 100644
--- a/arch/arm64/kernel/stacktrace.c
+++ b/arch/arm64/kernel/stacktrace.c
@@ -43,16 +43,22 @@ int notrace unwind_frame(struct task_struct *tsk, struct stackframe *frame)
 {
 	unsigned long fp = frame->fp;
 	struct stack_info info;
+	struct pt_regs *regs;
 
-	/* Terminal record; nothing to unwind */
-	if (!fp)
-		return -ENOENT;
+	if (!tsk)
+		tsk = current;
+	regs = task_pt_regs(tsk);
 
-	if (fp & 0xf)
+	/* Terminal record, nothing to unwind */
+	if (fp == (unsigned long) regs->stackframe) {
+		if (regs->frame_type == TASK_FRAME ||
+		    regs->frame_type == EL0_FRAME)
+			return -ENOENT;
 		return -EINVAL;
+	}
 
-	if (!tsk)
-		tsk = current;
+	if (!fp || fp & 0xf)
+		return -EINVAL;
 
 	if (!on_accessible_stack(tsk, fp, &info))
 		return -EINVAL;
-- 
2.25.1

