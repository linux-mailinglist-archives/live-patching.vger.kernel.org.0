Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 171726B8619
	for <lists+live-patching@lfdr.de>; Tue, 14 Mar 2023 00:33:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229698AbjCMXdw (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 13 Mar 2023 19:33:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229665AbjCMXdv (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 13 Mar 2023 19:33:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF6E3F768;
        Mon, 13 Mar 2023 16:33:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4BBF461556;
        Mon, 13 Mar 2023 23:33:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44485C433EF;
        Mon, 13 Mar 2023 23:33:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678750428;
        bh=W7MryJzHmQqDyin6xEvEG+fYO3n9hFFMrVefurQt1jY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uf3wDI9oCFy///wWmgJYlUQjm5PAWdng+Ebht/QiWeo+lDt2FuyRKpocj7tUgJNHM
         7RwJI+wOu+xwL0cl/N1s2ccVzTzTt10fc5S/5/UltRfiG/trRyRYkVNwPGBhDTsaFJ
         bWMInI7NcIHgMbXHZNTG5SFq3SQ9LanTw/AVLRaHqyCZ7D2pEiY3Ea/8IU1NmTR+tC
         95Sv/j7MVU8cGHXciePUjJcl9nXvoQjUcuQHXNfs328NcCpSkC3s2j/r6tzzbdH978
         tIw3WSickap6Od8l4cwYPMUJdfVzKIqIHSyKvy++OEyQib9cf06zcLpImCrpDnZKo3
         rDfUgYMxGiQAw==
Date:   Mon, 13 Mar 2023 16:33:46 -0700
From:   Josh Poimboeuf <jpoimboe@kernel.org>
To:     Petr Mladek <pmladek@suse.com>
Cc:     live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        Seth Forshee <sforshee@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Song Liu <song@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Miroslav Benes <mbenes@suse.cz>,
        Jiri Kosina <jikos@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Rik van Riel <riel@surriel.com>
Subject: [PATCH 0.5/3] livepatch: Convert stack entries array to percpu
Message-ID: <20230313233346.kayh4t2lpicjkpsv@treble>
References: <cover.1677257135.git.jpoimboe@kernel.org>
 <4ae981466b7814ec221014fc2554b2f86f3fb70b.1677257135.git.jpoimboe@kernel.org>
 <Y/zSgw5LOpbp7e/A@alley>
 <20230228165608.kumgxziaietsjaz3@treble>
 <ZAH9baGIOVL4/OHM@alley>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZAH9baGIOVL4/OHM@alley>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Fri, Mar 03, 2023 at 03:00:13PM +0100, Petr Mladek wrote:
> > MAX_STACK_ENTRIES is 100, which seems excessive.  If we halved that, the
> > array would be "only" 400 bytes, which is *almost* reasonable to
> > allocate on the stack?
> 
> It is just for the stack in the process context. Right?
> 
> I think that I have never seen a stack with over 50 entries. And in
> the worst case, a bigger amount of entries would "just" result in
> a non-reliable stack which might be acceptable.
> 
> It looks acceptable to me.
> 
> > Alternatively we could have a percpu entries array... :-/
> 
> That said, percpu entries would be fine as well. It sounds like
> a good price for the livepatching feature. I think that livepatching
> is used on big systems anyway.
> 
> I slightly prefer the per-cpu solution.

Booting a kernel with PREEMPT+LOCKDEP gave me a high-water mark of 60+
stack entries, seen when probing a device.  I decided not to mess with
MAX_STACK_ENTRIES, and instead just convert the entries to percpu.  This
patch could be inserted at the beginning of the set.

---8<---

Subject: [PATCH 0.5/3] livepatch: Convert stack entries array to percpu

The entries array in klp_check_stack() is static local because it's too
big to be reasonably allocated on the stack.  Serialized access is
enforced by the klp_mutex.

In preparation for calling klp_check_stack() without the mutex (from
cond_resched), convert it to a percpu variable.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 kernel/livepatch/transition.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/kernel/livepatch/transition.c b/kernel/livepatch/transition.c
index f1b25ec581e0..135fc73e2e5d 100644
--- a/kernel/livepatch/transition.c
+++ b/kernel/livepatch/transition.c
@@ -14,6 +14,8 @@
 #include "transition.h"
 
 #define MAX_STACK_ENTRIES  100
+DEFINE_PER_CPU(unsigned long[MAX_STACK_ENTRIES], klp_stack_entries);
+
 #define STACK_ERR_BUF_SIZE 128
 
 #define SIGNALS_TIMEOUT 15
@@ -240,12 +242,15 @@ static int klp_check_stack_func(struct klp_func *func, unsigned long *entries,
  */
 static int klp_check_stack(struct task_struct *task, const char **oldname)
 {
-	static unsigned long entries[MAX_STACK_ENTRIES];
+	unsigned long *entries = this_cpu_ptr(klp_stack_entries);
 	struct klp_object *obj;
 	struct klp_func *func;
 	int ret, nr_entries;
 
-	ret = stack_trace_save_tsk_reliable(task, entries, ARRAY_SIZE(entries));
+	/* Protect 'klp_stack_entries' */
+	lockdep_assert_preemption_disabled();
+
+	ret = stack_trace_save_tsk_reliable(task, entries, MAX_STACK_ENTRIES);
 	if (ret < 0)
 		return -EINVAL;
 	nr_entries = ret;
-- 
2.39.2

