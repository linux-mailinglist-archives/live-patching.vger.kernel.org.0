Return-Path: <live-patching+bounces-1149-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3024CA3038E
	for <lists+live-patching@lfdr.de>; Tue, 11 Feb 2025 07:25:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2190E16776B
	for <lists+live-patching@lfdr.de>; Tue, 11 Feb 2025 06:25:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3CD8F1E9900;
	Tue, 11 Feb 2025 06:24:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dgl/Q8X8"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 719151E3DFD
	for <live-patching@vger.kernel.org>; Tue, 11 Feb 2025 06:24:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739255094; cv=none; b=CsVtHlbOk2wd0n8ZbeFM+RmjTvZmK2y71CvElfYcMy48sX9gzqr8oahNmRu0e1q9IcOUHBTor6T1niia+zRus9G0xWDp39qtQF12qdW+PakFgkfz6/cbC6ggwtgsIZKZKRud/dUNlFo4TDZOmmMtWgs9QGVX8bpE1LWw5ScwiGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739255094; c=relaxed/simple;
	bh=lTA3yTQY4TjYUuJJzXIf+X+6A33/L+Jbt6VNkk+vuiw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=RGx0Au7rbzr3w+vqx2IuVOtNmdxwNf0c6FfmvrEIzVjOQ3CxhF9sDVzO94EFSA4Pg2hUpPIySUk/i+cjy213N8Nb24aAXYvi9L6Gog7edvV9af++0p7/xd+GGuWW14i94Z31NsxJNn2WFTowVBZnHTB7Bhyc/AZ9ylsW98QZQUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dgl/Q8X8; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-21f49bd087cso68407495ad.0
        for <live-patching@vger.kernel.org>; Mon, 10 Feb 2025 22:24:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1739255092; x=1739859892; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ehNBDWxyVXT9yXCqRioxuMf8z/+nF03nmrrSfE4VkFk=;
        b=dgl/Q8X8PQup4OqxahNXmSUFWckn1+xnA61059IkMHb2zN2naZt7DuoEJikSqEkrdo
         7Y+wKZ9PfBawW5+wXmLxXt5PjzRCyAksRG6Y7CKnySPT1U+S4ODhMrfSIFOVGr1+Lhnj
         uf5eLnXRR7QZUKwoGApZH06pwLOlmh2Q9EWVjxTqyNMov0RKABn9/KR071ZrYv4nO1wB
         FtxcJ8v2FeogncRKp3Jvk2aDtGGfcRiWRmh9ljPprrjL/ZdD7uwskrTRe+2Rmn/Nt5M6
         Xw2/mSAuM6IiPLvEE79HN8nHO0AFuwDrlIqQXfDPiW994aKcfGEp8hWYWrH9b8vWYf+g
         OUXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739255092; x=1739859892;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ehNBDWxyVXT9yXCqRioxuMf8z/+nF03nmrrSfE4VkFk=;
        b=Bf5KwcaMBwqzmk5BHdHumQPwF1OxfCuO8rhFMMBEmqHVsE3qFY6PHL9a8ksGV00Ebi
         rMb5e8asX952cJavKuUTktwzkylNkeqjzpl44vRReeWJhJzhxDsIErn6CPVt4G7M1jjk
         SvduwtPWq5Or1OmKkl2SKR0/MgHSm+/D5aLEwYqsxqPLq6aEfHTvZ8Rhhl2w3ifZ68yQ
         W288pBWuCM5WzDl+sdAeCOiLA9pFbWKtSJTTxchrg/mngjE0xhhgPiYLKhm0NHjpiaum
         BZLE3TqATxeSZIGsphQE9W9O1SQVvk58aUJSPqf6O+ybQafCBlt7he4K9blPc5aRylcZ
         Welg==
X-Gm-Message-State: AOJu0YytdpfY45JlKz4QiqMae5ylITTYlO1kDYTv10eUXQR09olCHjAy
	IvdwhK7fDUGXqS8oeUD+E8hh21XUIAAPPkkrbFYD4HBqW35CACx6
X-Gm-Gg: ASbGncsDdR1cM+l+1LrOd7hJCSnWdnL6pVJkkCbdrEq8845p3O4FM9xAIDXVgeMh8Q+
	dWZZEafn5Zox7aNzsayTZSiJqGfmMRpU9BbfEfzL2jUHvV+2Ega05w7bkEN3vHvGHC5ddsEZx18
	s9tqd+44KQDY0U3KGOkiOj0Wzdh4zIbTvv3PPgQq0jxBICqAXMYZKqqYWdt3MRFmS5+J9U2dbEr
	J2D7chZjT3EVtP50keXwCk55mUEXVgvOWceYu7pw92CuGc3tZFCa9RwXhWR/z3+sLtHC86qwHa5
	aFRgL6t5jxqnpEN1NvP0xc9OTJHmp84Mr+7AxTY=
X-Google-Smtp-Source: AGHT+IHxIRF8aytIqG1HiVF4bvtW9Wn1hhTN94JgPmn7syQFenQE1BxOKAwU2lh65GKA1H5w1EYTOQ==
X-Received: by 2002:a17:903:1a30:b0:216:794f:6d7d with SMTP id d9443c01a7336-21f4e763c94mr257077755ad.48.1739255091539;
        Mon, 10 Feb 2025 22:24:51 -0800 (PST)
Received: from localhost.localdomain ([58.37.132.225])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21f363df2b4sm89016985ad.0.2025.02.10.22.24.49
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 10 Feb 2025 22:24:51 -0800 (PST)
From: Yafang Shao <laoar.shao@gmail.com>
To: jpoimboe@kernel.org,
	jikos@kernel.org,
	mbenes@suse.cz,
	pmladek@suse.com,
	joe.lawrence@redhat.com
Cc: live-patching@vger.kernel.org,
	Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH 2/3] livepatch: Avoid blocking tasklist_lock too long
Date: Tue, 11 Feb 2025 14:24:36 +0800
Message-Id: <20250211062437.46811-3-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
In-Reply-To: <20250211062437.46811-1-laoar.shao@gmail.com>
References: <20250211062437.46811-1-laoar.shao@gmail.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

I encountered a hard lockup when attempting to reproduce the panic issue
occurred on our production servers [0]. The hard lockup is as follows,

[15852778.150191] livepatch: klp_try_switch_task: grpc_executor:421106 is sleeping on function do_exit
[15852778.169471] livepatch: klp_try_switch_task: grpc_executor:421244 is sleeping on function do_exit
[15852778.188746] livepatch: klp_try_switch_task: grpc_executor:421457 is sleeping on function do_exit
[15852778.208021] livepatch: klp_try_switch_task: grpc_executor:422407 is sleeping on function do_exit
[15852778.227292] livepatch: klp_try_switch_task: grpc_executor:423184 is sleeping on function do_exit
[15852778.246576] livepatch: klp_try_switch_task: grpc_executor:423582 is sleeping on function do_exit
[15852778.265863] livepatch: klp_try_switch_task: grpc_executor:423738 is sleeping on function do_exit
[15852778.285149] livepatch: klp_try_switch_task: grpc_executor:423739 is sleeping on function do_exit
[15852778.304446] livepatch: klp_try_switch_task: grpc_executor:423833 is sleeping on function do_exit
[15852778.323738] livepatch: klp_try_switch_task: grpc_executor:423893 is sleeping on function do_exit
[15852778.343017] livepatch: klp_try_switch_task: grpc_executor:423894 is sleeping on function do_exit
[15852778.362292] livepatch: klp_try_switch_task: grpc_executor:423976 is sleeping on function do_exit
[15852778.381565] livepatch: klp_try_switch_task: grpc_executor:423977 is sleeping on function do_exit
[15852778.400847] livepatch: klp_try_switch_task: grpc_executor:424610 is sleeping on function do_exit
[15852778.412319] NMI watchdog: Watchdog detected hard LOCKUP on cpu 15
...
[15852778.412374] CPU: 15 PID: 1 Comm: systemd Kdump: loaded Tainted: G S      W  O  K    6.1.52-3
[15852778.412378] RIP: 0010:queued_write_lock_slowpath+0x75/0x135
...
[15852778.412397] Call Trace:
[15852778.412398]  <NMI>
[15852778.412400]  ? show_regs.cold+0x1a/0x1f
[15852778.412403]  ? watchdog_overflow_callback.cold+0x1e/0x70
[15852778.412406]  ? __perf_event_overflow+0x102/0x1e0
[15852778.412409]  ? perf_event_overflow+0x19/0x20
[15852778.412411]  ? x86_pmu_handle_irq+0xf7/0x160
[15852778.412415]  ? flush_tlb_one_kernel+0xe/0x30
[15852778.412418]  ? __set_pte_vaddr+0x2d/0x40
[15852778.412421]  ? set_pte_vaddr_p4d+0x3d/0x50
[15852778.412423]  ? set_pte_vaddr+0x6d/0xa0
[15852778.412424]  ? __native_set_fixmap+0x28/0x40
[15852778.412426]  ? native_set_fixmap+0x54/0x60
[15852778.412428]  ? ghes_copy_tofrom_phys+0x75/0x120
[15852778.412431]  ? __ghes_peek_estatus.isra.0+0x4e/0xb0
[15852778.412434]  ? ghes_in_nmi_queue_one_entry.constprop.0+0x3d/0x240
[15852778.412437]  ? amd_pmu_handle_irq+0x48/0xc0
[15852778.412438]  ? perf_event_nmi_handler+0x2d/0x50
[15852778.412440]  ? nmi_handle+0x60/0x120
[15852778.412443]  ? default_do_nmi+0x45/0x120
[15852778.412446]  ? exc_nmi+0x118/0x150
[15852778.412447]  ? end_repeat_nmi+0x16/0x67
[15852778.412450]  ? copy_process+0xf01/0x19f0
[15852778.412452]  ? queued_write_lock_slowpath+0x75/0x135
[15852778.412455]  ? queued_write_lock_slowpath+0x75/0x135
[15852778.412457]  ? queued_write_lock_slowpath+0x75/0x135
[15852778.412459]  </NMI>
[15852778.412460]  <TASK>
[15852778.412461]  _raw_write_lock_irq+0x43/0x50
[15852778.412463]  copy_process+0xf01/0x19f0
[15852778.412466]  kernel_clone+0x9d/0x3e0
[15852778.412468]  ? autofs_dev_ioctl_requester+0x100/0x100
[15852778.412471]  __do_sys_clone+0x66/0x90
[15852778.412475]  __x64_sys_clone+0x25/0x30
[15852778.412477]  do_syscall_64+0x38/0x90
[15852778.412478]  entry_SYSCALL_64_after_hwframe+0x64/0xce
[15852778.412481] RIP: 0033:0x7f426bb3b9c1
...

Notebly, the dynamic_debug is enabled to collect the debug information
when applying a livepatch. Therefore, there're numerous debug
information.

As the execution of klp_try_switch_task() has been holding the
tasklist_lock, if another task is trying to hold it again, it will have to
spin on it. In the copy_process() path, the irq lock is disabled as well,
and thus this hard lockup occurs. We can avoid this hard lockup by checking
the spinlock contention.

This change is based on code originally developed by Petr[1].

Link: https://lore.kernel.org/all/CALOAHbA9WHPjeZKUcUkwULagQjTMfqAdAg+akqPzbZ7Byc=qrw@mail.gmail.com/ [0]
Link: https://lore.kernel.org/all/Z6Tmqro6CSm0h-E3@pathway.suse.cz/ [1]
Originally-by: Petr Mladek <pmladek@suse.com>
Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
---
 kernel/livepatch/transition.c | 24 +++++++++++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)

diff --git a/kernel/livepatch/transition.c b/kernel/livepatch/transition.c
index ba069459c101..04704a19dcfe 100644
--- a/kernel/livepatch/transition.c
+++ b/kernel/livepatch/transition.c
@@ -450,6 +450,7 @@ static void klp_send_signals(void)
  */
 void klp_try_complete_transition(void)
 {
+	unsigned long timeout, proceed_pending_processes;
 	unsigned int cpu;
 	struct task_struct *g, *task;
 	struct klp_patch *patch;
@@ -467,9 +468,30 @@ void klp_try_complete_transition(void)
 	 * unless the patch includes changes to a very common function.
 	 */
 	read_lock(&tasklist_lock);
-	for_each_process_thread(g, task)
+	timeout = jiffies + HZ;
+	proceed_pending_processes = 0;
+	for_each_process_thread(g, task) {
+		/* check if this task has already switched over */
+		if (task->patch_state == klp_target_state)
+			continue;
+
+		proceed_pending_processes++;
+
 		if (!klp_try_switch_task(task))
 			complete = false;
+
+		/*
+		 * Prevent hardlockup by not blocking tasklist_lock for too long.
+		 * But guarantee the forward progress by making sure at least
+		 * some pending processes were checked.
+		 */
+		if (rwlock_is_contended(&tasklist_lock) &&
+		    time_after(jiffies, timeout) &&
+		    proceed_pending_processes > 100) {
+			complete = false;
+			break;
+		}
+	}
 	read_unlock(&tasklist_lock);
 
 	/*
-- 
2.43.5


