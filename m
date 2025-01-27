Return-Path: <live-patching+bounces-1074-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B03C4A1FFEF
	for <lists+live-patching@lfdr.de>; Mon, 27 Jan 2025 22:34:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F313D3A4120
	for <lists+live-patching@lfdr.de>; Mon, 27 Jan 2025 21:34:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF6051DD889;
	Mon, 27 Jan 2025 21:33:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="H/RMbZVG"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42F4B1DCB09
	for <live-patching@vger.kernel.org>; Mon, 27 Jan 2025 21:33:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738013623; cv=none; b=GhoIP2GA/yjhrMFvwi38zFoMC0JqRI+/aPcA7Xy7QEeOXPRXSUEGweGkOzqkq/Cofw92iU1hVbfLAs1QmsC02CygQPHdGDRQ/LDDPOs3tHD+udp0cKwzDlTok+xxpjS0UKzFqHK8M4RW5l5JGNTtkp3b+ghXqtltlk48v4FtxPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738013623; c=relaxed/simple;
	bh=f0JKhNQwV53/GhmzpUTomtyLPYdsyZ5pafPvoAy0J6E=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=uyzox3+QbwdZTMMAa4qLmd1fBDQSQHjjY1WdDNu2Ey6FxJjhiPYca9ludl6JfSNQ3PDNhsz4WkGqctazxx8fejXIPBJEdEM9frAz1znaC/UqYnCOcoraESk6xPyFLKx7j5hEsh7Ip0p/RKgIn9jjrIoAXeZItn6SdERO4+u4gC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--wnliu.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=H/RMbZVG; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--wnliu.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-216717543b7so128823695ad.0
        for <live-patching@vger.kernel.org>; Mon, 27 Jan 2025 13:33:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1738013622; x=1738618422; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=rrEAyoRWIZk//3vjAjFd2Tppwtrq4EACKZ1CutvRWx8=;
        b=H/RMbZVGsKZEadYkMlYhMppTW+d/pWPbTXDpRM7tz7vmKj8fOlmfKWcc16C47hgebb
         YTNey0lrYVxSsGzNPe/gbKZL+bINL4XIRtFt6N32aYU9xx+5pwLqnXa/oQ39opmWPDMm
         2//ylrrNsEP8QVZ65LZ6LclK2TgwvVlIvGYGR4UisLY5O72noTtGZXu5tR0t8ywQBhnQ
         iqFEt2ewEJS/dOiDIjt2+gL0pG++D/03csTu/krns5i389kOQAlOKixt0cXcJw0B+7ch
         jk10TFO7Cn0ZFycrrsFjsPN5qKgVlEQjh7Zq50EzFSamzKoMdTW9ibDF/tyAhG+G83S6
         kI8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738013622; x=1738618422;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rrEAyoRWIZk//3vjAjFd2Tppwtrq4EACKZ1CutvRWx8=;
        b=g6OPoNh092Kq2tvm2cDgFNug1l9SYzS7GMyQabwuninPCn3g3DV5RVjgAGVifT/SwF
         vxkhb5cisijAUqB1B8fKzZ3sFBWBNpmUHLAUuc4gnklXKNvFA0W/2u+Nc88J4IliOqXd
         K9rMmgch6ilbay2qAVEFa91gyW9B8gPaLi45n8mRhZB4dmeyBOZU7LLsDWLG8wFZ4/oD
         ENtSBa1IzWR7pIufQoX/bAxiMCfBTWfyvkq8DxnHAObDjLzZqHryrivXAsIpBOFnOYOd
         dqYjseOsNV/yhlkKVm4NUrdgDaYVVa856kSLUYwjwddjBUfI31l6Yqfr6ju8Gx6vO+WB
         mE8w==
X-Forwarded-Encrypted: i=1; AJvYcCW2ly6bu05rmp9mVehZFJTwIKmza70WlipmfOmPbbBqFWNLhz5J9TZGCfip+AtRi5No910aexFQT/2K2H93@vger.kernel.org
X-Gm-Message-State: AOJu0YyBBt0IgecI2GlzX8c5w7gT+xL3vi/WTQ229xlCALW/Aw9vNQIY
	zxIlCiv7DOAHdUWHoaq6Ahhkv2h6Iy12E+7A3ME2I4raJOXT5yVkwZu+Qiv0fuDifgaVgEXz9A=
	=
X-Google-Smtp-Source: AGHT+IFFYVquifAUjWGrSZ5hEYAV0U5je02EgbAStisFUtw2EXTxIW8KfHqT+GqGJXHAuJ9zxlbXu/WPRQ==
X-Received: from plblq6.prod.google.com ([2002:a17:903:1446:b0:215:515c:124e])
 (user=wnliu job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:d2d2:b0:215:b01a:627f
 with SMTP id d9443c01a7336-21c352de4c0mr685131525ad.4.1738013621760; Mon, 27
 Jan 2025 13:33:41 -0800 (PST)
Date: Mon, 27 Jan 2025 21:33:09 +0000
In-Reply-To: <20250127213310.2496133-1-wnliu@google.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250127213310.2496133-1-wnliu@google.com>
X-Mailer: git-send-email 2.48.1.262.g85cc9f2d1e-goog
Message-ID: <20250127213310.2496133-8-wnliu@google.com>
Subject: [PATCH 7/8] arm64: Define TIF_PATCH_PENDING for livepatch
From: Weinan Liu <wnliu@google.com>
To: Josh Poimboeuf <jpoimboe@kernel.org>, Steven Rostedt <rostedt@goodmis.org>, 
	Indu Bhagat <indu.bhagat@oracle.com>, Peter Zijlstra <peterz@infradead.org>
Cc: Mark Rutland <mark.rutland@arm.com>, roman.gushchin@linux.dev, 
	Will Deacon <will@kernel.org>, Ian Rogers <irogers@google.com>, linux-toolchains@vger.kernel.org, 
	linux-kernel@vger.kernel.org, live-patching@vger.kernel.org, 
	joe.lawrence@redhat.com, linux-arm-kernel@lists.infradead.org, 
	"Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>, 
	Suraj Jitindar Singh <sjitindarsingh@gmail.com>, Weinan Liu <wnliu@google.com>
Content-Type: text/plain; charset="UTF-8"

From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>

	- Define TIF_PATCH_PENDING in arch/arm64/include/asm/thread_info.h
	  for livepatch.

	- Check TIF_PATCH_PENDING in do_notify_resume() to patch the
	  current task for livepatch.

Signed-off-by: Suraj Jitindar Singh <sjitindarsingh@gmail.com>
Signed-off-by: Madhavan T. Venkataraman <madvenka@linux.microsoft.com>
Signed-off-by: Weinan Liu <wnliu@google.com>
---
 arch/arm64/include/asm/thread_info.h | 4 +++-
 arch/arm64/kernel/entry-common.c     | 4 ++++
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/thread_info.h b/arch/arm64/include/asm/thread_info.h
index 1114c1c3300a..3810c2f3914e 100644
--- a/arch/arm64/include/asm/thread_info.h
+++ b/arch/arm64/include/asm/thread_info.h
@@ -64,6 +64,7 @@ void arch_setup_new_exec(void);
 #define TIF_UPROBE		4	/* uprobe breakpoint or singlestep */
 #define TIF_MTE_ASYNC_FAULT	5	/* MTE Asynchronous Tag Check Fault */
 #define TIF_NOTIFY_SIGNAL	6	/* signal notifications exist */
+#define TIF_PATCH_PENDING	7	/* pending live patching update */
 #define TIF_SYSCALL_TRACE	8	/* syscall trace active */
 #define TIF_SYSCALL_AUDIT	9	/* syscall auditing */
 #define TIF_SYSCALL_TRACEPOINT	10	/* syscall tracepoint for ftrace */
@@ -99,11 +100,12 @@ void arch_setup_new_exec(void);
 #define _TIF_MTE_ASYNC_FAULT	(1 << TIF_MTE_ASYNC_FAULT)
 #define _TIF_NOTIFY_SIGNAL	(1 << TIF_NOTIFY_SIGNAL)
 #define _TIF_TSC_SIGSEGV	(1 << TIF_TSC_SIGSEGV)
+#define _TIF_PATCH_PENDING	(1 << TIF_PATCH_PENDING)
 
 #define _TIF_WORK_MASK		(_TIF_NEED_RESCHED | _TIF_SIGPENDING | \
 				 _TIF_NOTIFY_RESUME | _TIF_FOREIGN_FPSTATE | \
 				 _TIF_UPROBE | _TIF_MTE_ASYNC_FAULT | \
-				 _TIF_NOTIFY_SIGNAL)
+				 _TIF_NOTIFY_SIGNAL | _TIF_PATCH_PENDING)
 
 #define _TIF_SYSCALL_WORK	(_TIF_SYSCALL_TRACE | _TIF_SYSCALL_AUDIT | \
 				 _TIF_SYSCALL_TRACEPOINT | _TIF_SECCOMP | \
diff --git a/arch/arm64/kernel/entry-common.c b/arch/arm64/kernel/entry-common.c
index b260ddc4d3e9..b537af333b42 100644
--- a/arch/arm64/kernel/entry-common.c
+++ b/arch/arm64/kernel/entry-common.c
@@ -8,6 +8,7 @@
 #include <linux/context_tracking.h>
 #include <linux/kasan.h>
 #include <linux/linkage.h>
+#include <linux/livepatch.h>
 #include <linux/lockdep.h>
 #include <linux/ptrace.h>
 #include <linux/resume_user_mode.h>
@@ -144,6 +145,9 @@ static void do_notify_resume(struct pt_regs *regs, unsigned long thread_flags)
 				       (void __user *)NULL, current);
 		}
 
+		if (thread_flags & _TIF_PATCH_PENDING)
+			klp_update_patch_state(current);
+
 		if (thread_flags & (_TIF_SIGPENDING | _TIF_NOTIFY_SIGNAL))
 			do_signal(regs);
 
-- 
2.48.1.262.g85cc9f2d1e-goog


