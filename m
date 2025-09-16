Return-Path: <live-patching+bounces-1653-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BE165B59257
	for <lists+live-patching@lfdr.de>; Tue, 16 Sep 2025 11:36:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BED1B323674
	for <lists+live-patching@lfdr.de>; Tue, 16 Sep 2025 09:35:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1091D2BEC23;
	Tue, 16 Sep 2025 09:35:19 +0000 (UTC)
X-Original-To: live-patching@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D921D299A8F;
	Tue, 16 Sep 2025 09:35:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758015319; cv=none; b=sgqY/3XFDDsqz3AajVrIyLYwlZP/y3xvAe5xrBpf9kNXUZq7PEbBo5wtIMqM2iWt5MMM2CgmDZ/YOyphhVzyY0k/FAD/QHcDXHAa5gXPd6+OypXGzyp685Eczqxy+rjb8QVQrTc8w4LbR8wH9AjW9W9y+OzVeaKoGQafZLa2f/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758015319; c=relaxed/simple;
	bh=aTpnJ6Qp8KPI/iAnagCI5mpqRs+1bJ6DnZJJNiiWeto=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=dZ+eT0WsZ4nx8ydZRY5AdmQwUazNVOn7xPfVlhGD4eC3rBcoHPyX/FqKDcM5cFuexh2qNZ1k/qRbAITF+hLi0wFjohh3ig0fjmPNTPOSjJkLLY0vj0sr+HTnm0gv31eEfl2ILPGjsC3IrIjJY+PLIasNyVtiMa7cTyu4AX9ALh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [113.200.148.30])
	by gateway (Coremail) with SMTP id _____8Cx6tFRL8loP+QKAA--.23554S3;
	Tue, 16 Sep 2025 17:35:13 +0800 (CST)
Received: from linux.localdomain (unknown [113.200.148.30])
	by front1 (Coremail) with SMTP id qMiowJAxT+ZNL8loxhiZAA--.27899S2;
	Tue, 16 Sep 2025 17:35:12 +0800 (CST)
From: Tiezhu Yang <yangtiezhu@loongson.cn>
To: Huacai Chen <chenhuacai@kernel.org>
Cc: Xi Zhang <zhangxi@kylinos.cn>,
	live-patching@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2] LoongArch: Fix unreliable stack for live patching
Date: Tue, 16 Sep 2025 17:35:09 +0800
Message-ID: <20250916093509.17306-1-yangtiezhu@loongson.cn>
X-Mailer: git-send-email 2.42.0
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJAxT+ZNL8loxhiZAA--.27899S2
X-CM-SenderInfo: p1dqw3xlh2x3gn0dqz5rrqw2lrqou0/
X-Coremail-Antispam: 1Uk129KBj93XoWxZryUtFWfKF1xAFW3WrWfZwc_yoW5tw4Upr
	45Zwnxtw4UJw1qq3ZFkr4Uury8Zws3A3sxWF93K3s3Xw1Uua48trn2q3Wjya1jvr95Cr47
	Xr18tFy8Za18A3XCm3ZEXasCq-sJn29KB7ZKAUJUUUU5529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUkjb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_
	GcCE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqjxCEc2xF0cIa020Ex4CE44I27wAqx4
	xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jrv_JF1lYx0Ex4A2jsIE14v2
	6r1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvY0x0EwIxGrwCF04k20xvY0x0EwI
	xGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480
	Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1lIxkGc2Ij64vIr41lIxAIcVC0I7
	IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04k2
	6cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxV
	AFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x07j1WlkUUUUU=

When testing the kernel live patching with "modprobe livepatch-sample",
there is a timeout over 15 seconds from "starting patching transition"
to "patching complete", dmesg shows "unreliable stack" for user tasks
in debug mode, here is one of the messages:

  livepatch: klp_try_switch_task: bash:1193 has an unreliable stack

The "unreliable stack" is because it can not unwind from do_syscall()
to its previous frame handle_syscall(), it should use fp to find the
original stack top due to secondary stack in do_syscall(), but fp is
not used for some other functions, then fp can not be restored by the
next frame of do_syscall(), so it is necessary to save fp if task is
not current to get the stack top of do_syscall().

Here are the call chains:

  klp_enable_patch()
    klp_try_complete_transition()
      klp_try_switch_task()
        klp_check_and_switch_task()
          klp_check_stack()
            stack_trace_save_tsk_reliable()
              arch_stack_walk_reliable()

When executing "rmmod livepatch-sample", there exists the similar issue.
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
  [Tue Sep 16 16:19:30 2025] livepatch: 'livepatch_sample': starting patching transition
  [Tue Sep 16 16:19:31 2025] livepatch: 'livepatch_sample': patching complete

  # echo 0 > /sys/kernel/livepatch/livepatch_sample/enabled
  # rmmod livepatch_sample
  # dmesg -T | tail -2
  [Tue Sep 16 16:19:36 2025] livepatch: 'livepatch_sample': starting unpatching transition
  [Tue Sep 16 16:19:37 2025] livepatch: 'livepatch_sample': unpatching complete

Cc: stable@vger.kernel.org # v6.9+
Fixes: 199cc14cb4f1 ("LoongArch: Add kernel livepatching support")
Reported-by: Xi Zhang <zhangxi@kylinos.cn>
Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
---
 arch/loongarch/kernel/stacktrace.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/loongarch/kernel/stacktrace.c b/arch/loongarch/kernel/stacktrace.c
index 9a038d1070d7..387dc4d3c486 100644
--- a/arch/loongarch/kernel/stacktrace.c
+++ b/arch/loongarch/kernel/stacktrace.c
@@ -51,12 +51,13 @@ int arch_stack_walk_reliable(stack_trace_consume_fn consume_entry,
 	if (task == current) {
 		regs->regs[3] = (unsigned long)__builtin_frame_address(0);
 		regs->csr_era = (unsigned long)__builtin_return_address(0);
+		regs->regs[22] = 0;
 	} else {
 		regs->regs[3] = thread_saved_fp(task);
 		regs->csr_era = thread_saved_ra(task);
+		regs->regs[22] = task->thread.reg22;
 	}
 	regs->regs[1] = 0;
-	regs->regs[22] = 0;
 
 	for (unwind_start(&state, task, regs);
 	     !unwind_done(&state) && !unwind_error(&state); unwind_next_frame(&state)) {
-- 
2.42.0


