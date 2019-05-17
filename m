Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5877521DEB
	for <lists+live-patching@lfdr.de>; Fri, 17 May 2019 20:56:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727770AbfEQS4k (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 17 May 2019 14:56:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49162 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726293AbfEQS4j (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Fri, 17 May 2019 14:56:39 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 0DBB381E05;
        Fri, 17 May 2019 18:56:39 +0000 (UTC)
Received: from redhat.com (dhcp-17-208.bos.redhat.com [10.18.17.208])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 5732B5DD73;
        Fri, 17 May 2019 18:56:38 +0000 (UTC)
Date:   Fri, 17 May 2019 14:56:36 -0400
From:   Joe Lawrence <joe.lawrence@redhat.com>
To:     live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     jikos@kernel.org, jpoimboe@redhat.com, pmladek@suse.com,
        tglx@linutronix.de
Subject: Re: [PATCH] stacktrace: fix CONFIG_ARCH_STACKWALK
 stack_trace_save_tsk_reliable return
Message-ID: <20190517185636.GA24696@redhat.com>
References: <20190517185117.24642-1-joe.lawrence@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190517185117.24642-1-joe.lawrence@redhat.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.25]); Fri, 17 May 2019 18:56:39 +0000 (UTC)
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Fri, May 17, 2019 at 02:51:17PM -0400, Joe Lawrence wrote:
> Miroslav reported that the livepatch self-tests were failing,
> specifically a case in which the consistency model ensures that we do
> not patch a current executing function, "TEST: busy target module".
> 
> Recent renovations to stack_trace_save_tsk_reliable() left it returning
> only an -ERRNO success indication in some configuration combinations:
> 
>   klp_check_stack()
>     ret = stack_trace_save_tsk_reliable()
>       #ifdef CONFIG_ARCH_STACKWALK && CONFIG_HAVE_RELIABLE_STACKTRACE
>         stack_trace_save_tsk_reliable()
>           ret = arch_stack_walk_reliable()
>             return 0
>             return -EINVAL
>           ...
>           return ret;
>     ...
>     if (ret < 0)
>       /* stack_trace_save_tsk_reliable error */
>     nr_entries = ret;                               << 0
> 
> Previously (and currently for !CONFIG_ARCH_STACKWALK &&
> CONFIG_HAVE_RELIABLE_STACKTRACE) stack_trace_save_tsk_reliable()
> returned the number of entries that it consumed in the passed storage
> array.
> 
> In the case of the above config and trace, be sure to return the
> stacktrace_cookie.len on stack_trace_save_tsk_reliable() success.
> 
> Fixes: 25e39e32b0a3f ("livepatch: Simplify stack trace retrieval")
> Reported-by: Miroslav Benes <mbenes@suse.cz>
> Signed-off-by: Joe Lawrence <joe.lawrence@redhat.com>
> ---
>  kernel/stacktrace.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel/stacktrace.c b/kernel/stacktrace.c
> index 27bafc1e271e..90d3e0bf0302 100644
> --- a/kernel/stacktrace.c
> +++ b/kernel/stacktrace.c
> @@ -206,7 +206,7 @@ int stack_trace_save_tsk_reliable(struct task_struct *tsk, unsigned long *store,
>  
>  	ret = arch_stack_walk_reliable(consume_entry, &c, tsk);
>  	put_task_stack(tsk);
> -	return ret;
> +	return ret ? ret : c.len;
>  }
>  #endif
>  
> -- 
> 2.20.1
> 

Hi Thomas,

This change is *very* lightly tested.  It passes the livepatch
self-tests and a test driver that I wrote to debug this.  If a more
substantial change is needed, feel free to grab this one.

FWIW, here's the debugging module that I used to first verify that the
return code was always 0 (ie, no nr_entries) and then that I was getting
sane values back from the modified version.  It's simple, echo in a task
pointer and it will dump the stack trace to dmesg:

  % dmesg -C
  % echo 0xffff8a4107082f40 > /sys/module/checkstack/parameters/task_param 
  % dmesg
  [ 1909.546463] checkstack: task @ ffff8a4107082f40
  [ 1909.549280] checkstack: nr_entries = 7
  [ 1909.552268] checkstack:      [ffffffffa608fb29] schedule+0x29/0x90
  [ 1909.555583] checkstack:      [ffffffffa60941ed] schedule_hrtimeout_range_clock+0x18d/0x1a0
  [ 1909.556864] checkstack:      [ffffffffa5b27e38] ep_poll+0x428/0x450
  [ 1909.557645] checkstack:      [ffffffffa5b27f10] do_epoll_wait+0xb0/0xd0
  [ 1909.558454] checkstack:      [ffffffffa5b27f4a] __x64_sys_epoll_wait+0x1a/0x20
  [ 1909.559354] checkstack:      [ffffffffa58041e5] do_syscall_64+0x55/0x1a0
  [ 1909.560233] checkstack:      [ffffffffa620008c] entry_SYSCALL_64_after_hwframe+0x44/0xa9

-- Joe

-->8-- -->8-- -->8-- -->8-- -->8-- -->8-- -->8-- -->8-- -->8-- -->8--


#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt

#include <linux/kernel.h>
#include <linux/module.h>
#include <linux/cpu.h>
#include <linux/kallsyms.h>
#include <linux/stacktrace.h>

MODULE_LICENSE("GPL");
MODULE_AUTHOR("Joe Lawrence <joe.lawrence@stratus.com>");

#define MAX_STACK_ENTRIES  100

/* No exports, no fun */
static int (*p_stack_trace_save_tsk_reliable)(struct task_struct *tsk, unsigned long *store, unsigned int size);

int checkstack(struct task_struct *task)
{
	static unsigned long entries[MAX_STACK_ENTRIES];
	unsigned long address;
	int ret, nr_entries, i;

	if (!task)
		return 0;

	pr_info("task @ %lx\n", (unsigned long) task);

        ret = p_stack_trace_save_tsk_reliable(task, entries, ARRAY_SIZE(entries));
        WARN_ON_ONCE(ret == -ENOSYS);
        if (ret < 0) {
                pr_err("%s: %s:%d has an unreliable stack\n",
                         __func__, task->comm, task->pid);
                return ret;
        }
	nr_entries = ret;
	pr_info("nr_entries = %d\n", nr_entries); 

        for (i = 0; i < nr_entries; i++) {
                address = entries[i];
		pr_info("\t[%lx] %pS\n", address, (void *) address);
        }

	return 0;
}


static unsigned long task_param = 0;
static int task_param_set(const char *val, const struct kernel_param *kp)
{
        int ret;

        ret = param_set_ulong(val, kp);
        if (ret < 0)
                return ret;

	return checkstack((struct task_struct *)task_param);
}
static const struct kernel_param_ops task_param_ops = {
	.set = task_param_set,
	.get = param_get_ulong,
};
module_param_cb(task_param, &task_param_ops, &task_param, 0644);
MODULE_PARM_DESC(task_param, "task (default=0)");


int __init init_module(void)
{
	p_stack_trace_save_tsk_reliable = 
		(void *)kallsyms_lookup_name("stack_trace_save_tsk_reliable");
	if (!p_stack_trace_save_tsk_reliable) {
		pr_err("can't find stack_trace_save_tsk_reliable symbol\n");
		return -ENXIO;
	}
	pr_info("p_stack_trace_save_tsk_reliable @ %lx\n",
		(unsigned long) p_stack_trace_save_tsk_reliable);

	return 0;
}

void cleanup_module(void)
{
}
