Return-Path: <live-patching+bounces-1958-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id uAXcGvRqgGkd8AIAu9opvQ
	(envelope-from <live-patching+bounces-1958-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Mon, 02 Feb 2026 10:14:28 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 95BEAC9FA1
	for <lists+live-patching@lfdr.de>; Mon, 02 Feb 2026 10:14:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 9D95A3001390
	for <lists+live-patching@lfdr.de>; Mon,  2 Feb 2026 09:14:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C253D3559F8;
	Mon,  2 Feb 2026 09:14:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="jR2QkiqC"
X-Original-To: live-patching@vger.kernel.org
Received: from sg-1-105.ptr.blmpb.com (sg-1-105.ptr.blmpb.com [118.26.132.105])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 568F11EDA2B
	for <live-patching@vger.kernel.org>; Mon,  2 Feb 2026 09:14:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=118.26.132.105
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770023661; cv=none; b=ED0t5eEYUVOCWxmQixzXKhypJohmxAlIbPHno2jppnMLxzlIc2aCpcjmHEzAqwzw36zAOW6Fro1DlcJSCqCp2cK7PNz84SMKrV9wo9cZDxOQB7IsZAVkkL/vF9plfnBdiSzLMpfMVOEi01w7/kNsf4Mc5gaMUxM2Fej3FCAyn/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770023661; c=relaxed/simple;
	bh=sPTEvWnva5n5CLrvZht4XWRG0J9xLIleuREsk1wT140=;
	h=From:Mime-Version:To:Content-Type:Subject:Date:Cc:Message-Id; b=jZj62710a3Twh0L6SvVQjN8J9IabBzqGDlGe6EnN6ulbrDKJqEalx2bY0cZAt942PiMck4gRQWO9wNcyXcgP5drNrKHaPRuos+2ARcdMqG6Dp6/puybTl28zpTw9r+qekdGRRBaQtJR1sFT4CqW/XQLqvuE/39MeWAw7KMeg6p8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=jR2QkiqC; arc=none smtp.client-ip=118.26.132.105
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1770023646; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=1k2P3758o5OptGHu6EC22LU4mqBsDuAUN1+em7tI2sM=;
 b=jR2QkiqCKYNOaHXEkAKPW+7/ZtkOtHmzAGMh0xZIu9vbpn1TMFBGqSdIJO4CVKKfoSYbGn
 ggpKpp0AzH6lmXTBjLJel6aaVKL8JY7Ceyos4TASnb3sbLeXadrbqs1214JInN9zSUo5XI
 8E51/2NL+Xv3e90k8J7FsHg/jjrdXf53bd2q42FS0JbwNW9mMCe5CpFtaY/xOpCdK2qCq6
 MPP/MLgwS+LtWgnrPEUpj/iNFaPAnhKCx8dAGYsjzsvOiU2caInOusz++l/iQoh8C7uk3W
 wLYli/AfyTTJXbwjHJwkrpLl/HoOqWFakG6diIRMptSCW4GEA/LkTcjiL1oOZQ==
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
From: "Li Zhe" <lizhe.67@bytedance.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
To: <jpoimboe@kernel.org>, <jikos@kernel.org>, <mbenes@suse.cz>, 
	<pmladek@suse.com>, <joe.lawrence@redhat.com>
X-Mailer: git-send-email 2.45.2
Content-Type: text/plain; charset=UTF-8
Subject: [PATCH] klp: use stop machine to check and expedite transition for running tasks
Date: Mon,  2 Feb 2026 17:13:34 +0800
X-Lms-Return-Path: <lba+269806adc+078a4c+vger.kernel.org+lizhe.67@bytedance.com>
Content-Transfer-Encoding: 7bit
Cc: <live-patching@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	<lizhe.67@bytedance.com>, <qirui.001@bytedance.com>
Message-Id: <20260202091334.60881-1-lizhe.67@bytedance.com>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[bytedance.com,quarantine];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	R_DKIM_ALLOW(-0.20)[bytedance.com:s=2212171451];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_COUNT_THREE(0.00)[3];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-1958-lists,live-patching=lfdr.de];
	DKIM_TRACE(0.00)[bytedance.com:+];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[lizhe.67@bytedance.com,live-patching@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	TO_DN_NONE(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	RCPT_COUNT_SEVEN(0.00)[9];
	NEURAL_HAM(-0.00)[-1.000];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,bytedance.com:email,bytedance.com:dkim,bytedance.com:mid]
X-Rspamd-Queue-Id: 95BEAC9FA1
X-Rspamd-Action: no action

In the current KLP transition implementation, the strategy for running
tasks relies on waiting for a context switch to attempt to clear the
TIF_PATCH_PENDING flag. Alternatively, determine whether the
TIF_PATCH_PENDING flag can be cleared by inspecting the stack once the
process has yielded the CPU. However, this approach proves problematic
in certain environments.

Consider a scenario where the majority of system CPUs are configured
with nohzfull and isolcpus, each dedicated to a VM with a vCPU pinned
to that physical core and configured with idle=poll within the guest.
Under such conditions, these vCPUs rarely leave the CPU. Combined with
the high core counts typical of modern server platforms, this results
in transition completion times that are not only excessively prolonged
but also highly unpredictable.

This patch resolves this issue by registering a callback with
stop_machine. The callback attempts to transition the associated running
task. In a VM environment configured with 32 CPUs, the live patching
operation completes promptly after the SIGNALS_TIMEOUT period with this
patch applied; without it, the process nearly fails to complete under
the same scenario.

Co-developed-by: Rui Qi <qirui.001@bytedance.com>
Signed-off-by: Rui Qi <qirui.001@bytedance.com>
Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
---
 kernel/livepatch/transition.c | 62 ++++++++++++++++++++++++++++++++---
 1 file changed, 58 insertions(+), 4 deletions(-)

diff --git a/kernel/livepatch/transition.c b/kernel/livepatch/transition.c
index 2351a19ac2a9..9c078b9bd755 100644
--- a/kernel/livepatch/transition.c
+++ b/kernel/livepatch/transition.c
@@ -10,6 +10,7 @@
 #include <linux/cpu.h>
 #include <linux/stacktrace.h>
 #include <linux/static_call.h>
+#include <linux/stop_machine.h>
 #include "core.h"
 #include "patch.h"
 #include "transition.h"
@@ -297,6 +298,61 @@ static int klp_check_and_switch_task(struct task_struct *task, void *arg)
 	return 0;
 }
 
+enum klp_stop_work_bit {
+	KLP_STOP_WORK_PENDING_BIT,
+};
+
+struct klp_stop_work_info {
+	struct task_struct *task;
+	unsigned long flag;
+};
+
+static DEFINE_PER_CPU(struct cpu_stop_work, klp_transition_stop_work);
+static DEFINE_PER_CPU(struct klp_stop_work_info, klp_stop_work_info);
+
+static int klp_check_task(struct task_struct *task, void *old_name)
+{
+	if (task == current)
+		return klp_check_and_switch_task(current, old_name);
+	else
+		return task_call_func(task, klp_check_and_switch_task, old_name);
+}
+
+static int klp_transition_stop_work_fn(void *arg)
+{
+	struct klp_stop_work_info *info = (struct klp_stop_work_info *)arg;
+	struct task_struct *task = info->task;
+	const char *old_name;
+
+	clear_bit(KLP_STOP_WORK_PENDING_BIT, &info->flag);
+
+	if (likely(klp_patch_pending(task)))
+		klp_check_task(task, &old_name);
+
+	put_task_struct(task);
+
+	return 0;
+}
+
+static void klp_try_transition_running_task(struct task_struct *task)
+{
+	int cpu = task_cpu(task);
+
+	if (klp_signals_cnt && !(klp_signals_cnt % SIGNALS_TIMEOUT)) {
+		struct klp_stop_work_info *info =
+			per_cpu_ptr(&klp_stop_work_info, cpu);
+
+		if (test_and_set_bit(KLP_STOP_WORK_PENDING_BIT, &info->flag))
+			return;
+
+		info->task = get_task_struct(task);
+		if (!stop_one_cpu_nowait(cpu, klp_transition_stop_work_fn, info,
+					 per_cpu_ptr(&klp_transition_stop_work,
+					 cpu)))
+			put_task_struct(task);
+	}
+}
+
 /*
  * Try to safely switch a task to the target patch state.  If it's currently
  * running, or it's sleeping on a to-be-patched or to-be-unpatched function, or
@@ -323,10 +379,7 @@ static bool klp_try_switch_task(struct task_struct *task)
 	 * functions.  If all goes well, switch the task to the target patch
 	 * state.
 	 */
-	if (task == current)
-		ret = klp_check_and_switch_task(current, &old_name);
-	else
-		ret = task_call_func(task, klp_check_and_switch_task, &old_name);
+	ret = klp_check_task(task, &old_name);
 
 	switch (ret) {
 	case 0:		/* success */
@@ -335,6 +388,7 @@ static bool klp_try_switch_task(struct task_struct *task)
 	case -EBUSY:	/* klp_check_and_switch_task() */
 		pr_debug("%s: %s:%d is running\n",
 			 __func__, task->comm, task->pid);
+		klp_try_transition_running_task(task);
 		break;
 	case -EINVAL:	/* klp_check_and_switch_task() */
 		pr_debug("%s: %s:%d has an unreliable stack\n",
-- 
2.20.1

