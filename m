Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA7AC33C2DF
	for <lists+live-patching@lfdr.de>; Mon, 15 Mar 2021 17:59:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234608AbhCOQ6r (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 15 Mar 2021 12:58:47 -0400
Received: from linux.microsoft.com ([13.77.154.182]:51084 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232220AbhCOQ6Q (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 15 Mar 2021 12:58:16 -0400
Received: from x64host.home (unknown [47.187.194.202])
        by linux.microsoft.com (Postfix) with ESMTPSA id 8650420B26FE;
        Mon, 15 Mar 2021 09:58:15 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 8650420B26FE
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1615827496;
        bh=jheyVZ/lUkxf4Ht1TtTUL0sobQn62YR0CVwzSLRcRdA=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=QJ42h8pS1O+0cURPnA4fdCqupwkpfS259xG/1wglI00VOExTU1uQoa03R3XOzBYrb
         lkMnRDAYrogw1NMDoZ7NnPHshtec1eFkIan34A5ppztxARo+x+Rg7Y2tjMJDA+p1am
         cYsgch6qRqbr/azncTfOJfhMUWYyvtO0UgZt21SI=
From:   madvenka@linux.microsoft.com
To:     broonie@kernel.org, mark.rutland@arm.com, jpoimboe@redhat.com,
        jthierry@redhat.com, catalin.marinas@arm.com, will@kernel.org,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        madvenka@linux.microsoft.com
Subject: [RFC PATCH v2 6/8] arm64: Check the return PC of every stack frame
Date:   Mon, 15 Mar 2021 11:57:58 -0500
Message-Id: <20210315165800.5948-7-madvenka@linux.microsoft.com>
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

If a function encountered in a stack trace is not a valid kernel text
address, the stack trace is considered unreliable. Mark the stack trace
as not reliable.

Signed-off-by: Madhavan T. Venkataraman <madvenka@linux.microsoft.com>
---
 arch/arm64/kernel/stacktrace.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/arm64/kernel/stacktrace.c b/arch/arm64/kernel/stacktrace.c
index 594806a0c225..358aae3906d7 100644
--- a/arch/arm64/kernel/stacktrace.c
+++ b/arch/arm64/kernel/stacktrace.c
@@ -101,6 +101,16 @@ static void check_if_reliable(unsigned long fp, struct stackframe *frame,
 		}
 	}
 #endif
+
+	/*
+	 * A NULL or invalid return address probably means there's some
+	 * generated code which __kernel_text_address() doesn't know about.
+	 * Mark the stack trace as not reliable.
+	 */
+	if (!__kernel_text_address(frame->pc)) {
+		frame->reliable = false;
+		return;
+	}
 }
 
 /*
-- 
2.25.1

