Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3AE1810D1EB
	for <lists+live-patching@lfdr.de>; Fri, 29 Nov 2019 08:42:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726847AbfK2Hl5 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 29 Nov 2019 02:41:57 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:9584 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726789AbfK2Hl4 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 29 Nov 2019 02:41:56 -0500
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xAT7ftHr048973
        for <live-patching@vger.kernel.org>; Fri, 29 Nov 2019 02:41:55 -0500
Received: from e06smtp05.uk.ibm.com (e06smtp05.uk.ibm.com [195.75.94.101])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2wjvatvuyj-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <live-patching@vger.kernel.org>; Fri, 29 Nov 2019 02:41:55 -0500
Received: from localhost
        by e06smtp05.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <live-patching@vger.kernel.org> from <gor@linux.ibm.com>;
        Fri, 29 Nov 2019 07:41:52 -0000
Received: from b06cxnps4076.portsmouth.uk.ibm.com (9.149.109.198)
        by e06smtp05.uk.ibm.com (192.168.101.135) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 29 Nov 2019 07:41:48 -0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xAT7flUa50921702
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Nov 2019 07:41:47 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1C2CFA4051;
        Fri, 29 Nov 2019 07:41:47 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6A04BA404D;
        Fri, 29 Nov 2019 07:41:46 +0000 (GMT)
Received: from localhost (unknown [9.145.76.153])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Fri, 29 Nov 2019 07:41:46 +0000 (GMT)
Date:   Fri, 29 Nov 2019 08:41:44 +0100
From:   Vasily Gorbik <gor@linux.ibm.com>
To:     Miroslav Benes <mbenes@suse.cz>
Cc:     heiko.carstens@de.ibm.com, borntraeger@de.ibm.com,
        jpoimboe@redhat.com, joe.lawrence@redhat.com,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        jikos@kernel.org, pmladek@suse.com, nstange@suse.de,
        live-patching@vger.kernel.org
Subject: Re: [PATCH v3 4/4] s390/livepatch: Implement reliable stack tracing
 for the consistency model
References: <20191106095601.29986-5-mbenes@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20191106095601.29986-5-mbenes@suse.cz>
X-TM-AS-GCONF: 00
x-cbid: 19112907-0020-0000-0000-0000039081A1
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19112907-0021-0000-0000-000021E7928A
Message-Id: <cover.thread-a0061f.your-ad-here.call-01575012971-ext-9115@work.hours>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-29_01:2019-11-29,2019-11-29 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 clxscore=1015
 bulkscore=0 lowpriorityscore=0 priorityscore=1501 impostorscore=0
 adultscore=0 mlxlogscore=999 mlxscore=0 malwarescore=0 suspectscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911290066
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed, Nov 06, 2019 at 10:56:01AM +0100, Miroslav Benes wrote:
> The livepatch consistency model requires reliable stack tracing
> architecture support in order to work properly. In order to achieve
> this, two main issues have to be solved. First, reliable and consistent
> call chain backtracing has to be ensured. Second, the unwinder needs to
> be able to detect stack corruptions and return errors.

I tried to address that in a patch series I pushed here:
https://git.kernel.org/pub/scm/linux/kernel/git/s390/linux.git/log/?h=livepatch

It partially includes your changes from this patch which have been split
in 2 patches:
s390/unwind: add stack pointer alignment sanity checks
s390/livepatch: Implement reliable stack tracing for the consistency model

The primary goal was to make our backchain unwinder reliable itself. And
suitable for livepatching as is (we extra checks at the caller, see
below). Besides unwinder changes few things have been improved to avoid
special handling during unwinding.
- all tasks now have pt_regs at the bottom of task stack.
- final backchain always contains 0, no further references to no_dat stack.
- successful unwinding means reaching pt_regs at the bottom of task stack,
and unwinder guarantees that unwind_error() reflects that.
- final pt_regs at the bottom of task stack is never included in unwinding
results. It never was for user tasks. And kernel tasks cannot return to
that state anyway (and in some cases pt_regs are empty).
- unwinder starts unwinding from a reliable state (not "sp" passed as
an argument).
There is also s390 specific unwinder testing module.

> Idle tasks are a bit special. Their final back chains point to no_dat
> stacks. See for reference CALL_ON_STACK() in smp_start_secondary()
> callback used in __cpu_up(). The unwinding is stopped there and it is
> not considered to be a stack corruption.
I changed that with commit:
s390: avoid misusing CALL_ON_STACK for task stack setup
Now idle tasks are not special, final back chain contains 0.

> ---
>  arch/s390/Kconfig             |  1 +
>  arch/s390/kernel/dumpstack.c  | 11 +++++++
>  arch/s390/kernel/stacktrace.c | 46 ++++++++++++++++++++++++++
>  arch/s390/kernel/unwind_bc.c  | 61 +++++++++++++++++++++++++++--------
>  4 files changed, 106 insertions(+), 13 deletions(-)
> 
> --- a/arch/s390/kernel/dumpstack.c
> +++ b/arch/s390/kernel/dumpstack.c
> @@ -94,12 +94,23 @@ int get_stack_info(unsigned long sp, struct task_struct *task,
>  	if (!sp)
>  		goto unknown;
>  
> +	/* Sanity check: ABI requires SP to be aligned 8 bytes. */
> +	if (sp & 0x7)
> +		goto unknown;
> +
This has been split in a separate commit:
s390/unwind: add stack pointer alignment sanity checks

> +	/*
> +	 * The reliable unwinding should not start on nodat_stack, async_stack
> +	 * or restart_stack. The task is either current or must be inactive.
> +	 */
> +	if (unwind_reliable)
> +		goto unknown;
I moved this check in arch_stack_walk_reliable itself. See below.

>  static bool unwind_use_regs(struct unwind_state *state)
> @@ -85,10 +94,13 @@ static bool unwind_use_frame(struct unwind_state *state, unsigned long sp,
>  	struct stack_frame *sf;
>  	unsigned long ip;
>  
> -	if (unlikely(outside_of_stack(state, sp))) {
> -		if (!update_stack_info(state, sp))
> -			goto out_err;
> -	}
> +	/*
> +	 * No need to update stack info when unwind_reliable is true. We should
> +	 * be on a task stack and everything else is an error.
> +	 */
> +	if (unlikely(outside_of_stack(state, sp)) &&
> +	    (unwind_reliable || !update_stack_info(state, sp)))
> +		goto out_err;
I moved this check in arch_stack_walk_reliable itself. See below.

> +	/* Unwind reliable */
> +	if ((unsigned long)regs != info->end - sizeof(struct pt_regs))
> +		goto out_err;
I moved this check in arch_stack_walk_reliable itself. See below.


> @@ -136,8 +162,17 @@ bool unwind_next_frame(struct unwind_state *state, bool unwind_reliable)
>  	sf = (struct stack_frame *) state->sp;
>  	sp = READ_ONCE_NOCHECK(sf->back_chain);
>  
> -	/* Non-zero back-chain points to the previous frame */
> -	if (likely(sp))
> +	/*
> +	 * Non-zero back-chain points to the previous frame
> +	 *
> +	 * unwind_reliable case: Idle tasks are special. The final
> +	 * back-chain points to nodat_stack.  See CALL_ON_STACK() in
> +	 * smp_start_secondary() callback used in __cpu_up(). We just
> +	 * accept it and look for pt_regs.
> +	 */
> +	if (likely(sp) &&
> +	    (!unwind_reliable || !(is_idle_task(state->task) &&
> +				   outside_of_stack(state, sp))))
>  		return unwind_use_frame(state, sp, unwind_reliable);
This is not needed anymore.

In the end this all boils down to arch_stack_walk_reliable
implementation. I made the following changes compaired to your version:
---
- use plain unwind_for_each_frame
- "state.stack_info.type != STACK_TYPE_TASK" guarantees that we are
  not leaving task stack.
- "if (state.regs)" guarantees that we have not met an program interrupt
  pt_regs (page faults) or preempted. Corresponds to yours:
> +	if ((unsigned long)regs != info->end - sizeof(struct pt_regs))
> +		goto out_err;
- I don't see a point in storing "kernel_thread_starter", am I missing
  something?

diff --git a/arch/s390/kernel/stacktrace.c b/arch/s390/kernel/stacktrace.c
index 79f323388e4d..fc5419ac64c8 100644
--- a/arch/s390/kernel/stacktrace.c
+++ b/arch/s390/kernel/stacktrace.c
@@ -36,9 +36,12 @@ int arch_stack_walk_reliable(stack_trace_consume_fn consume_entry,
        struct unwind_state state;
        unsigned long addr;
 
-       for (unwind_start(&state, task, NULL, 0, true);
-            !unwind_done(&state) && !unwind_error(&state);
-            unwind_next_frame(&state, true)) {
+       unwind_for_each_frame(&state, task, NULL, 0) {
+               if (state.stack_info.type != STACK_TYPE_TASK)
+                       return -EINVAL;
+
+               if (state.regs)
+                       return -EINVAL;
 
                addr = unwind_get_return_address(&state);
                if (!addr)
@@ -60,11 +63,5 @@ int arch_stack_walk_reliable(stack_trace_consume_fn consume_entry,
        /* Check for stack corruption */
        if (unwind_error(&state))
                return -EINVAL;
-
-       /* Store kernel_thread_starter, null for swapper/0 */
-       if ((task->flags & (PF_KTHREAD | PF_IDLE)) &&
-           !consume_entry(cookie, state.regs->psw.addr, false))
-               return -EINVAL;
-
        return 0;
 }
--
I'd appreciate if you could give those changes a spin. And check if
something is missing or broken. Or share your livepatching testing
procedure. If everything goes well, I might include these changes in
second pull request for this 5.5 merge window.

I did successfully run ./testing/selftests/livepatch/test-livepatch.sh

https://github.com/lpechacek/qa_test_klp seems outdated. I was able to
fix and run some tests of it but haven't had time to figure out all of
them. Is there a version that would run on top of current Linus tree?

Since I changed your last patch and split it in 2, could you please give
me your Signed-off-by for those 2 commits?

