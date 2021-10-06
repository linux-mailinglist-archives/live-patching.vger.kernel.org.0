Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8EAA423D3A
	for <lists+live-patching@lfdr.de>; Wed,  6 Oct 2021 13:48:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238589AbhJFLuC (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 6 Oct 2021 07:50:02 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:50896 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238491AbhJFLtz (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 6 Oct 2021 07:49:55 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id F29E31FEA5;
        Wed,  6 Oct 2021 11:48:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1633520882; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=E6Nx1r2Gh5ycxErMm9n/vHXXqSqW2SER8moOwbQTNxg=;
        b=BmD5VMob3HKkgBPuNoqhQnMX5P4eXm3I8uDq2k8bDo2RAKDILLCQ0doPP6cN6e5/g3mTVH
        7KDWzCg9EyuOsB4bT5FEw5qsRCmU9lvf05PQ3kMtwTOxvKUkEh2eje0M5PqtzSS2unp7RJ
        /MZHjbhWg5TqYcffrCtHXi2lT0nti68=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1633520882;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=E6Nx1r2Gh5ycxErMm9n/vHXXqSqW2SER8moOwbQTNxg=;
        b=Q4MsK60IfKnkbkGnTovCxhR2LPx+bW54/OLM3rmzzBF0aPrxiC5uUvp27Qt4mr4ACUUpl2
        IiN0C1Oy5g57qTAQ==
Received: from pobox.suse.cz (pobox.suse.cz [10.100.2.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 8C257A3B8B;
        Wed,  6 Oct 2021 11:48:01 +0000 (UTC)
Date:   Wed, 6 Oct 2021 13:48:01 +0200 (CEST)
From:   Miroslav Benes <mbenes@suse.cz>
To:     Petr Mladek <pmladek@suse.com>
cc:     Peter Zijlstra <peterz@infradead.org>, gor@linux.ibm.com,
        jpoimboe@redhat.com, jikos@kernel.org, mingo@kernel.org,
        linux-kernel@vger.kernel.org, joe.lawrence@redhat.com,
        fweisbec@gmail.com, tglx@linutronix.de, hca@linux.ibm.com,
        svens@linux.ibm.com, sumanthk@linux.ibm.com,
        live-patching@vger.kernel.org, paulmck@kernel.org,
        rostedt@goodmis.org, x86@kernel.org
Subject: Re: [RFC][PATCH v2 09/11] context_tracking,livepatch: Dont disturb
 NOHZ_FULL
In-Reply-To: <YV16jKrB5Azu/nD+@alley>
Message-ID: <alpine.LSU.2.21.2110061323300.2311@pobox.suse.cz>
References: <20210929151723.162004989@infradead.org> <20210929152429.067060646@infradead.org> <YV1aYaHEynjSAUuI@alley> <YV1mmv5QbB/vf3/O@hirez.programming.kicks-ass.net> <YV16jKrB5Azu/nD+@alley>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

> > That's not sufficient, you need to tag the remote task with a ct_work
> > item to also runs klp_update_patch_state(), otherwise the remote CPU can
> > enter kernel space between checking is_ct_user() and doing
> > klp_update_patch_state():
> > 
> > 	CPU0				CPU1
> > 
> > 					<user>
> > 
> > 	if (is_ct_user()) // true
> > 					<kernel-entry>
> > 					  // run some kernel code
> > 	  klp_update_patch_state()
> > 	  *WHOOPSIE*
> > 
> > 
> > So it needs to be something like:
> > 
> > 
> > 	CPU0				CPU1
> > 
> > 					<user>
> > 
> > 	if (context_tracking_set_cpu_work(task_cpu(), CT_WORK_KLP))
> > 
> > 					<kernel-entry>
> > 	  klp_update_patch_state	  klp_update_patch_state()
> > 
> > 
> > So that CPU0 and CPU1 race to complete klp_update_patch_state() *before*
> > any regular (!noinstr) code gets run.
> 
> Grr, you are right. I thought that we migrated the task when entering
> kernel even before. But it seems that we do it only when leaving
> the kernel in exit_to_user_mode_loop().

That is correct. You are probably confused by the old kGraft 
implementation which added the TIF also to _TIF_WORK_SYSCALL_ENTRY so 
that syscall_trace_enter() processed it too. But upstream solution has 
always switched tasks only on their exit to user mode, because it was 
deemed sufficient.

Btw, just for fun, the old kGraft in one of its first incarnations also 
had the following horrible hack to exactly "solve" the problem.

+/*
+ * Tasks which are running in userspace after the patching has been started
+ * can immediately be marked as migrated to the new universe.
+ *
+ * If this function returns non-zero (i.e. also when error happens), the task
+ * needs to be migrated using kgraft lazy mechanism.
+ */
+static inline bool kgr_needs_lazy_migration(struct task_struct *p)
+{
+       unsigned long s[3];
+       struct stack_trace t = {
+               .nr_entries = 0,
+               .skip = 0,
+               .max_entries = 3,
+               .entries = s,
+       };
+
+       save_stack_trace_tsk(p, &t);
+
+       return t.nr_entries > 2;
+}

Miroslav
