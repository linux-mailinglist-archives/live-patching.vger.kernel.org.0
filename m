Return-Path: <live-patching+bounces-1029-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9FFCBA18DDA
	for <lists+live-patching@lfdr.de>; Wed, 22 Jan 2025 09:52:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EDAD3163698
	for <lists+live-patching@lfdr.de>; Wed, 22 Jan 2025 08:52:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4CA5B1F561E;
	Wed, 22 Jan 2025 08:51:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PoiePm2S"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B06ED1CEE8D
	for <live-patching@vger.kernel.org>; Wed, 22 Jan 2025 08:51:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737535918; cv=none; b=mcwcE7QJ9OJXBzqyKo7xB+j1fywiQkHCDpLPq1agJWKS6iOcwBRpMpzraqqIYhzEEtsxWeCouWaQJA+LsePcqojtMefgICMVJLwpV9ndFoCbe9d+OfGblU3dCy33fB/b/8GfPvl/5YvWteplzlS/iSaO4490tS5JmqUw4tRVL7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737535918; c=relaxed/simple;
	bh=fdcEs3LlT68t1VXwp683ig1Xv/zZaQNSj0QpRsxGCPA=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Kapj3EgVaQspXMuvXBUHp7lJwLYHDbXk+r+qLIZLicc1VERCdN/U2272+cLk85NHUG44EIs4Aj5M2tuQsbxobOfnxNj3ZXsHQVvBUpIgBUjPMwOmruCg9yxLywIljihD/vsgriOfbPYC8UwPoSAJuoY0tGCNuqwhf0e7sPN69d0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PoiePm2S; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2164b1f05caso122819765ad.3
        for <live-patching@vger.kernel.org>; Wed, 22 Jan 2025 00:51:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1737535916; x=1738140716; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=HQIbY0NdkvPiDBIbaeC+HhUEOY4/woL99rzNBJqkK/A=;
        b=PoiePm2Sxz6sr+P0/4EfISG3nRlHqddqflNRJ0MhOuFhCWrLkm8Va+3b1pIZz/oacS
         woY0fjmC1GgaPfEE+6UPPwM7dbAEtnNP9VChzXoE/pj/zdsOb0IHPH8opO8T2Hx4Fvrf
         BeKt3VBLB6ts1LrprQaSXgvHfC7dsq316R7OZe8Z5gWdR05v7vcP5qvLDM2ufBTFCDyU
         VfMvhl0JqWkMUPUwKyVUOFZaA49spQmrqZoFR++Azq6raMcMhzYuRH3tNaVOiAZpxJQD
         iTz8XRkhQyyGQhWQ6oMOJFm1QW7P2bIPttH6K60YF71lbkq89PLQVUzV4U81506IVO1p
         YXXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737535916; x=1738140716;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HQIbY0NdkvPiDBIbaeC+HhUEOY4/woL99rzNBJqkK/A=;
        b=M0Tdhux/vebAQEdw9ZaBGyX+C7qtZiOnhyCW5HXx/N5YGIuslRWRoF9aqWKWTz2gSZ
         7KQCCZEOEZEfa1BJO5lhFY9qKrS7bth50Bn7fVo9DfHXy23cGWjrtikrLvuRfaE2Z5A0
         SztbdyTxCJDjdBV4Y6Q9rPcoiXmBDqUm6we9mRs76Ux6593nQ4i05wP4E4dGhe9YBsyB
         NBBo+3cAfID0Ys4gSQqgMLcJFA5nEzcQ+yz20ucwB1wv8pw8bDgRPHCgQwJF40HJPzkE
         njYbOvS9mcwrmuQbhz+C4yprwvUO/pZtmAhdsRbTYF/f1Ympkmv90G6sPvjXT41KZ+/j
         MinQ==
X-Gm-Message-State: AOJu0YxsS2e7VnITXQDk23p4jnO1Hukk1LL2kf9vva25yE7IKEZSKBLx
	17oC5sWGT0MzZQJBojDMW2/L/YpIlQaPejEMUe3FZgivRXcnHYTo
X-Gm-Gg: ASbGnctLYHFk5Zlwfu2sN+cOSIDSBnklvgbFyOA5+hsPacBywELuce16XpRc0hpQiT+
	Tzw5XzRJP4yfYs3rcuInlKrb1/WMIbNeS/AkttVlO2j0vIipMSFGrDcaH+tprCKbHMzQA6FXtfb
	cUwmmS/M63I+18BpfqQYvmSbcQ8iWGmj4tGUyVU+E+/TmqJ8CiY68o4vUPFqGRzuQnDcnR5bVTF
	5YiLjd5mIuIxOyVn/y7mUw5OH5HGBT+7SNDxsHhbuG+o3tSOEc8SWiNBo0ihTjlPfkg7lkKNr2S
	IbXtCGcTFI+yO7Y7N2Lh
X-Google-Smtp-Source: AGHT+IEEIv9L1OLcyqVpoEPuUn8b3+1QIURbQSRpf6IFzz2NtLtFIoiH24xd7QPL4l1tdkv8M1mqig==
X-Received: by 2002:a05:6a00:a0c:b0:726:41e:b321 with SMTP id d2e1a72fcca58-72dafbdacadmr30907697b3a.21.1737535915812;
        Wed, 22 Jan 2025 00:51:55 -0800 (PST)
Received: from localhost.localdomain ([116.232.102.131])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-72dab7f190fsm10484147b3a.26.2025.01.22.00.51.52
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 22 Jan 2025 00:51:55 -0800 (PST)
From: Yafang Shao <laoar.shao@gmail.com>
To: jpoimboe@kernel.org,
	jikos@kernel.org,
	mbenes@suse.cz,
	pmladek@suse.com,
	joe.lawrence@redhat.com
Cc: live-patching@vger.kernel.org,
	Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH] livepatch: Avoid hard lockup caused by klp_try_switch_task()
Date: Wed, 22 Jan 2025 16:51:46 +0800
Message-Id: <20250122085146.41553-1-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

I encountered a hard lockup while attempting to reproduce the panic issue
that occurred on our production servers [0]. The hard lockup manifests as
follows:

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
[15852778.412377] Hardware name: New H3C Technologies Co., Ltd. H3C UniServer R4950 G5/RS45M2C9S, BIOS 5.12 10/15/2021
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

Notably, dynamic_debug is enabled to collect debug information when
applying a livepatch, resulting in a large amount of debug output.

The issue arises because klp_try_switch_task() holds the tasklist_lock, and
if another task attempts to acquire it, it must spin until it's available.
This becomes problematic in the copy_process() path, where IRQs are
disabled, leading to the hard lockup. To prevent this, we should implement
a check for spinlock contention before proceeding.

Link: https://lore.kernel.org/live-patching/CALOAHbA9WHPjeZKUcUkwULagQjTMfqAdAg+akqPzbZ7Byc=qrw@mail.gmail.com/ [0]
Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
---
 kernel/livepatch/transition.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/kernel/livepatch/transition.c b/kernel/livepatch/transition.c
index ba069459c101..774017825bb4 100644
--- a/kernel/livepatch/transition.c
+++ b/kernel/livepatch/transition.c
@@ -467,9 +467,14 @@ void klp_try_complete_transition(void)
 	 * unless the patch includes changes to a very common function.
 	 */
 	read_lock(&tasklist_lock);
-	for_each_process_thread(g, task)
+	for_each_process_thread(g, task) {
 		if (!klp_try_switch_task(task))
 			complete = false;
+		if (rwlock_is_contended(&tasklist_lock) || need_resched()) {
+			complete = false;
+			break;
+		}
+	}
 	read_unlock(&tasklist_lock);
 
 	/*
-- 
2.43.5


