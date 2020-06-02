Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 353CA1EBCD0
	for <lists+live-patching@lfdr.de>; Tue,  2 Jun 2020 15:15:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728103AbgFBNPE (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 2 Jun 2020 09:15:04 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:56749 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725958AbgFBNPD (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 2 Jun 2020 09:15:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591103702;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8+xkXD/89f3E/jLx1RHCiW0SRJppAJLBRgRaNSAEXLI=;
        b=EgyxhnObc1Y088q0+ER2S4ozADOdK2ftsW+INAAEJpWJwJN0e1ZttoDoTZQeT2xOJNj1ji
        4eMMvGXOP+ovd2Zsbq60OVkWvt7M+T26dX/Oc6MnjKav5/ifm96d/jC/pa3EscnczlYa3y
        SS13ki4a5x2s6b+f0tMGnUyG8+Pjiew=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-133-dTvVxfvtPVO5Ym7N0GU9GA-1; Tue, 02 Jun 2020 09:14:58 -0400
X-MC-Unique: dTvVxfvtPVO5Ym7N0GU9GA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D47BB800053;
        Tue,  2 Jun 2020 13:14:56 +0000 (UTC)
Received: from treble (ovpn-116-170.rdu2.redhat.com [10.10.116.170])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 98B075C1D6;
        Tue,  2 Jun 2020 13:14:52 +0000 (UTC)
Date:   Tue, 2 Jun 2020 08:14:50 -0500
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     "Wangshaobo (bobo)" <bobo.shaobowang@huawei.com>
Cc:     huawei.libin@huawei.com, xiexiuqi@huawei.com,
        cj.chengjian@huawei.com, mingo@redhat.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, live-patching@vger.kernel.org,
        mbenes@suse.cz, devel@etsukata.com, viro@zeniv.linux.org.uk,
        esyr@redhat.com
Subject: Re: Question: livepatch failed for new fork() task stack unreliable
Message-ID: <20200602131450.oydrydelpdaval4h@treble>
References: <20200529101059.39885-1-bobo.shaobowang@huawei.com>
 <20200529174433.wpkknhypx2bmjika@treble>
 <a9ed9157-f3cf-7d2c-7a8e-56150a2a114e@huawei.com>
 <20200601180538.o5agg5trbdssqken@treble>
 <a5e0f476-02b5-cc44-8d4e-d33ff2138143@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <a5e0f476-02b5-cc44-8d4e-d33ff2138143@huawei.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue, Jun 02, 2020 at 09:22:30AM +0800, Wangshaobo (bobo) wrote:
> so i think this question is related to ORC unwinder, could i ask if you have
> strategy or plan to avoid this problem ?

I suspect something like this would fix it (untested):

diff --git a/arch/x86/kernel/stacktrace.c b/arch/x86/kernel/stacktrace.c
index 6ad43fc44556..8cf95ded1410 100644
--- a/arch/x86/kernel/stacktrace.c
+++ b/arch/x86/kernel/stacktrace.c
@@ -50,7 +50,7 @@ int arch_stack_walk_reliable(stack_trace_consume_fn consume_entry,
 		if (regs) {
 			/* Success path for user tasks */
 			if (user_mode(regs))
-				return 0;
+				break;
 
 			/*
 			 * Kernel mode registers on the stack indicate an
@@ -81,10 +81,6 @@ int arch_stack_walk_reliable(stack_trace_consume_fn consume_entry,
 	if (unwind_error(&state))
 		return -EINVAL;
 
-	/* Success path for non-user tasks, i.e. kthreads and idle tasks */
-	if (!(task->flags & (PF_KTHREAD | PF_IDLE)))
-		return -EINVAL;
-
 	return 0;
 }
 
diff --git a/arch/x86/kernel/unwind_orc.c b/arch/x86/kernel/unwind_orc.c
index 7f969b2d240f..d7396431261a 100644
--- a/arch/x86/kernel/unwind_orc.c
+++ b/arch/x86/kernel/unwind_orc.c
@@ -540,7 +540,7 @@ bool unwind_next_frame(struct unwind_state *state)
 		state->sp = sp;
 		state->regs = NULL;
 		state->prev_regs = NULL;
-		state->signal = false;
+		state->signal = ((void *)state->ip == ret_from_fork);
 		break;
 
 	case ORC_TYPE_REGS:

