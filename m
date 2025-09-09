Return-Path: <live-patching+bounces-1634-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B3D9AB4AC1E
	for <lists+live-patching@lfdr.de>; Tue,  9 Sep 2025 13:33:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 763FC17CAD9
	for <lists+live-patching@lfdr.de>; Tue,  9 Sep 2025 11:32:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B807D32A3FE;
	Tue,  9 Sep 2025 11:31:14 +0000 (UTC)
X-Original-To: live-patching@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F49832253F;
	Tue,  9 Sep 2025 11:31:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757417474; cv=none; b=C7RMmThS/b8kpENqWa+4QR8yoPcTxdiDu6hfYMetHnRSj1qOHkYBb85yXcJJV+IMwk7lu4Y+y+yqOiiVMGEhwrD1aLTI9zrivbC1PizqxkLszG/QSIAgD0FAOwIXtTjiWZTdZvR6ByYZkKeAJwYZyHFGEi1BpqvJsfHHAOINzF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757417474; c=relaxed/simple;
	bh=8p7Wd6c3+I8kTr0mAPAqIkAVJBhJflBxoJu7tgILsO8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=arfRIbUNedGDopI58Q1Ts2AYvXGCUVmy9n/Y6PnPk2xfyN+/AG+UIhYdmNX6q9ooUMf8ZENGtY/nR3nahSK5CUmV9KR6ZpUNGxe7YRZGeU4yv7kbDzPQ9H7+G7ifKGu0RBGqNNmz0TeOQMSMbgBiik9M71Lls0bo9mJGxg59M9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [113.200.148.30])
	by gateway (Coremail) with SMTP id _____8AxxtD9D8BouloIAA--.17361S3;
	Tue, 09 Sep 2025 19:31:09 +0800 (CST)
Received: from linux.localdomain (unknown [113.200.148.30])
	by front1 (Coremail) with SMTP id qMiowJBxjcH7D8BoviGKAA--.57546S4;
	Tue, 09 Sep 2025 19:31:08 +0800 (CST)
From: Tiezhu Yang <yangtiezhu@loongson.cn>
To: Josh Poimboeuf <jpoimboe@kernel.org>,
	Huacai Chen <chenhuacai@kernel.org>
Cc: Xi Zhang <zhangxi@kylinos.cn>,
	live-patching@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH v1 2/2] LoongArch: Return 0 for user tasks in arch_stack_walk_reliable()
Date: Tue,  9 Sep 2025 19:31:06 +0800
Message-ID: <20250909113106.22992-3-yangtiezhu@loongson.cn>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20250909113106.22992-1-yangtiezhu@loongson.cn>
References: <20250909113106.22992-1-yangtiezhu@loongson.cn>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJBxjcH7D8BoviGKAA--.57546S4
X-CM-SenderInfo: p1dqw3xlh2x3gn0dqz5rrqw2lrqou0/
X-Coremail-Antispam: 1Uk129KBj93XoWxZr4kGw4fJry7JrW7Ar15WrX_yoW5KFW7pr
	15uwnxJw4UJwnIq3Z2kr45uryrXw4kAr9xWF95K3sav3WDua48tr1vyw1jyw4Y9ryYkr17
	Xr1YqFy09a1xZ3XCm3ZEXasCq-sJn29KB7ZKAUJUUUUr529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUvEb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_
	GcCE3s1ln4kS14v26r1Y6r17M2AIxVAIcxkEcVAq07x20xvEncxIr21l57IF6xkI12xvs2
	x26I8E6xACxx1l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1q6rW5
	McIj6I8E87Iv67AKxVW8JVWxJwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr4
	1l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1l4IxYO2xFxVAFwI0_Jrv_
	JF1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17
	CE14v26r126r1DMIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Gr0_Xr1lIxAIcVC0
	I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I
	8E87Iv67AKxVW8JVWxJwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73
	UjIFyTuYvjxU4AhLUUUUU

When testing the kernel live patching with "modprobe livepatch-sample",
there is a timeout over 15 seconds from "starting patching transition"
to "patching complete", dmesg shows "unreliable stack" for user tasks
in debug mode. When executing "rmmod livepatch-sample", there exists
the similar issue.

Like x86, arch_stack_walk_reliable() should return 0 for user tasks.
It is necessary to set regs->csr_prmd as task->thread.csr_prmd first,
then use user_mode() to check whether the task is in userspace.

Here are the call chains:

  klp_enable_patch()
    klp_try_complete_transition()
      klp_try_switch_task()
        klp_check_and_switch_task()
          klp_check_stack()
            stack_trace_save_tsk_reliable()
              arch_stack_walk_reliable()

With this patch, it takes a short time for patching and unpatching.

Before:

  # modprobe livepatch-sample
  # dmesg -T | tail -3
  [Sat Sep  6 11:00:20 2025] livepatch: 'livepatch_sample': starting patching transition
  [Sat Sep  6 11:00:35 2025] livepatch: signaling remaining tasks
  [Sat Sep  6 11:00:36 2025] livepatch: 'livepatch_sample': patching complete

  # echo 0 > /sys/kernel/livepatch/livepatch_sample/enabled
  # rmmod livepatch_sample
  rmmod: ERROR: Module livepatch_sample is in use
  # rmmod livepatch_sample
  # dmesg -T | tail -3
  [Sat Sep  6 11:06:05 2025] livepatch: 'livepatch_sample': starting unpatching transition
  [Sat Sep  6 11:06:20 2025] livepatch: signaling remaining tasks
  [Sat Sep  6 11:06:21 2025] livepatch: 'livepatch_sample': unpatching complete

After:

  # modprobe livepatch-sample
  # dmesg -T | tail -2
  [Sat Sep  6 11:19:00 2025] livepatch: 'livepatch_sample': starting patching transition
  [Sat Sep  6 11:19:01 2025] livepatch: 'livepatch_sample': patching complete

  # echo 0 > /sys/kernel/livepatch/livepatch_sample/enabled
  # rmmod livepatch_sample
  # dmesg -T | tail -2
  [Sat Sep  6 11:21:10 2025] livepatch: 'livepatch_sample': starting unpatching transition
  [Sat Sep  6 11:21:11 2025] livepatch: 'livepatch_sample': unpatching complete

While at it, do the similar thing for arch_stack_walk() to avoid
potential issues.

Cc: stable@vger.kernel.org # v6.9+
Fixes: 199cc14cb4f1 ("LoongArch: Add kernel livepatching support")
Reported-by: Xi Zhang <zhangxi@kylinos.cn>
Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
---
 arch/loongarch/kernel/stacktrace.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/loongarch/kernel/stacktrace.c b/arch/loongarch/kernel/stacktrace.c
index 9a038d1070d7..0454cce3b667 100644
--- a/arch/loongarch/kernel/stacktrace.c
+++ b/arch/loongarch/kernel/stacktrace.c
@@ -30,10 +30,15 @@ void arch_stack_walk(stack_trace_consume_fn consume_entry, void *cookie,
 		}
 		regs->regs[1] = 0;
 		regs->regs[22] = 0;
+		regs->csr_prmd = task->thread.csr_prmd;
 	}
 
 	for (unwind_start(&state, task, regs);
 	     !unwind_done(&state); unwind_next_frame(&state)) {
+		/* Success path for user tasks */
+		if (user_mode(regs))
+			return;
+
 		addr = unwind_get_return_address(&state);
 		if (!addr || !consume_entry(cookie, addr))
 			break;
@@ -57,9 +62,14 @@ int arch_stack_walk_reliable(stack_trace_consume_fn consume_entry,
 	}
 	regs->regs[1] = 0;
 	regs->regs[22] = 0;
+	regs->csr_prmd = task->thread.csr_prmd;
 
 	for (unwind_start(&state, task, regs);
 	     !unwind_done(&state) && !unwind_error(&state); unwind_next_frame(&state)) {
+		/* Success path for user tasks */
+		if (user_mode(regs))
+			return 0;
+
 		addr = unwind_get_return_address(&state);
 
 		/*
-- 
2.42.0


