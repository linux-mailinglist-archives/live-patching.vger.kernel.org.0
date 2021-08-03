Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F6C63DEFF6
	for <lists+live-patching@lfdr.de>; Tue,  3 Aug 2021 16:17:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236665AbhHCORa (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 3 Aug 2021 10:17:30 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:57148 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236592AbhHCORY (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 3 Aug 2021 10:17:24 -0400
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1628000232;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=P65i0gbKnhTxPKHg3SSzE6N4pinsJNni4QQoI0J6eF8=;
        b=JiWp6P+50wwCOHKHwPEHFju5X3ZiQT/XoOY6uZNPAfn3hQwYToLffVzzJ8adMxohpPtxU5
        5vQyThrPq9M8LQCvg2oEgPoNU6asA2PyUbVP24207B6YPp86tHqxG5+e+c2zkvCanHO8m5
        /4dAe1N/myW+AdFkF+/sjUy7bJFs0kW0DvHZlOyrDkVsw/D4yqRlVSOKj56XqT+FIWkhka
        K20jSKCEollkUB22ENzheBNqnTKzUrg1oM0zCRaA1TltOlb2VKhvYXAnabo6BOsYiDdrq4
        WfGjFeWCh+WY0svH1pztdh5HBMlJBrM28op9j/Z4yNdWOmaov1jinvEpqGLsOA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1628000232;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=P65i0gbKnhTxPKHg3SSzE6N4pinsJNni4QQoI0J6eF8=;
        b=mESumFs4eF6qYKUducYMb0eOx+3AjcXP187Herw9jmTdz2xqxRqKdIZoffpc/Ux+I2KTmB
        ykvLmw2cTGQ085Cg==
To:     linux-kernel@vger.kernel.org
Cc:     tglx@linutronix.de, Peter Zijlstra <peterz@infradead.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        live-patching@vger.kernel.org
Subject: [PATCH 26/38] livepatch: Replace deprecated CPU-hotplug functions.
Date:   Tue,  3 Aug 2021 16:16:09 +0200
Message-Id: <20210803141621.780504-27-bigeasy@linutronix.de>
In-Reply-To: <20210803141621.780504-1-bigeasy@linutronix.de>
References: <20210803141621.780504-1-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

The functions get_online_cpus() and put_online_cpus() have been
deprecated during the CPU hotplug rework. They map directly to
cpus_read_lock() and cpus_read_unlock().

Replace deprecated CPU-hotplug functions with the official version.
The behavior remains unchanged.

Cc: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Jiri Kosina <jikos@kernel.org>
Cc: Miroslav Benes <mbenes@suse.cz>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Joe Lawrence <joe.lawrence@redhat.com>
Cc: live-patching@vger.kernel.org
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 kernel/livepatch/transition.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/livepatch/transition.c b/kernel/livepatch/transition.c
index 3a4beb9395c48..291b857a6e201 100644
--- a/kernel/livepatch/transition.c
+++ b/kernel/livepatch/transition.c
@@ -411,7 +411,7 @@ void klp_try_complete_transition(void)
 	/*
 	 * Ditto for the idle "swapper" tasks.
 	 */
-	get_online_cpus();
+	cpus_read_lock();
 	for_each_possible_cpu(cpu) {
 		task =3D idle_task(cpu);
 		if (cpu_online(cpu)) {
@@ -423,7 +423,7 @@ void klp_try_complete_transition(void)
 			task->patch_state =3D klp_target_state;
 		}
 	}
-	put_online_cpus();
+	cpus_read_unlock();
=20
 	if (!complete) {
 		if (klp_signals_cnt && !(klp_signals_cnt % SIGNALS_TIMEOUT))
--=20
2.32.0

