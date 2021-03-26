Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAF3D34A1DB
	for <lists+live-patching@lfdr.de>; Fri, 26 Mar 2021 07:32:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229812AbhCZGcE (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 26 Mar 2021 02:32:04 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:3053 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230043AbhCZGbq (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 26 Mar 2021 02:31:46 -0400
Received: from DGGEML402-HUB.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4F6Bqw6ZdTzWQGm;
        Fri, 26 Mar 2021 14:28:28 +0800 (CST)
Received: from dggpeml500026.china.huawei.com (7.185.36.106) by
 DGGEML402-HUB.china.huawei.com (10.3.17.38) with Microsoft SMTP Server (TLS)
 id 14.3.498.0; Fri, 26 Mar 2021 14:31:24 +0800
Received: from [10.67.110.102] (10.67.110.102) by
 dggpeml500026.china.huawei.com (7.185.36.106) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2106.2; Fri, 26 Mar 2021 14:31:24 +0800
Subject: Re: [PATCH] livepatch: klp_send_signal should treat PF_IO_WORKER like
 PF_KTHREAD
To:     Miroslav Benes <mbenes@suse.cz>
CC:     <jpoimboe@redhat.com>, <jikos@kernel.org>, <pmladek@suse.com>,
        <joe.lawrence@redhat.com>, <axboe@kernel.dk>,
        <live-patching@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20210325014836.40649-1-dongkai11@huawei.com>
 <alpine.LSU.2.21.2103251023320.30447@pobox.suse.cz>
From:   "dongkai (H)" <dongkai11@huawei.com>
Message-ID: <14a1601d-7ef1-1513-0d9c-f72315ca1f12@huawei.com>
Date:   Fri, 26 Mar 2021 14:31:24 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <alpine.LSU.2.21.2103251023320.30447@pobox.suse.cz>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.110.102]
X-ClientProxiedBy: dggeme713-chm.china.huawei.com (10.1.199.109) To
 dggpeml500026.china.huawei.com (7.185.36.106)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On 2021/3/25 17:26, Miroslav Benes wrote:
> On Thu, 25 Mar 2021, Dong Kai wrote:
> 
>> commit 15b2219facad ("kernel: freezer should treat PF_IO_WORKER like
>> PF_KTHREAD for freezing") is to fix the freezeing issue of IO threads
>> by making the freezer not send them fake signals.
>>
>> Here live patching consistency model call klp_send_signals to wake up
>> all tasks by send fake signal to all non-kthread which only check the
>> PF_KTHREAD flag, so it still send signal to io threads which may lead to
>> freezeing issue of io threads.
> 
> I suppose this could happen, but it will also affect the live patching
> transition if the io threads do not react to signals.
> 
> Are you able to reproduce it easily? I mean, is there a testcase I could
> use to take a closer look?
>   

Um... I tried but failed to reproduce this on real environment as i'm 
not familiar with the io uring usage.

So i use a tricky way to verify this possibility by the following patch 
which create a fake io thread in module and patch the func which is 
always within thread running stack. Then the stack check will failed 
when transition and trigger the klp_send_signal flow.

This example may not suitable, but you can get my point

Kai

Note: this patch export some symbols just for test via module because if 
i create io thread via sysinit, it will receive SIGKILL signal[set by 
zap_other_threads] when run init process and exit the loop, weird...

diff --git a/fs/exec.c b/fs/exec.c
index 18594f11c31f..a64af6cac43b 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1229,6 +1229,7 @@ void __set_task_comm(struct task_struct *tsk, 
const char *buf, bool exec)
  	task_unlock(tsk);
  	perf_event_comm(tsk, exec);
  }
+EXPORT_SYMBOL_GPL(__set_task_comm);

  /*
   * Calling this is the point of no return. None of the failures will be
diff --git a/kernel/fork.c b/kernel/fork.c
index 54cc905e5fe0..03064fef7bb1 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -2447,6 +2447,7 @@ struct task_struct *create_io_thread(int 
(*fn)(void *), void *arg, int node)
  	}
  	return tsk;
  }
+EXPORT_SYMBOL(create_io_thread);

  /*
   *  Ok, this is the main fork-routine.
index 98191218d891..8151d17149a0 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -3856,6 +3856,7 @@ void wake_up_new_task(struct task_struct *p)
  #endif
  	task_rq_unlock(rq, p, &rf);
  }
+EXPORT_SYMBOL_GPL(wake_up_new_task);

  #ifdef CONFIG_PREEMPT_NOTIFIERS

diff --git a/samples/test/Makefile b/samples/test/Makefile
new file mode 100644
index 000000000000..efbf01c6477e
--- /dev/null
+++ b/samples/test/Makefile
@@ -0,0 +1 @@
+obj-m += io_thread.o livepatch-sample.o
diff --git a/samples/test/io_thread.c b/samples/test/io_thread.c
new file mode 100644
index 000000000000..e7bdc51a4582
--- /dev/null
+++ b/samples/test/io_thread.c
@@ -0,0 +1,49 @@
+#include <linux/module.h>
+#include <linux/sched.h>
+#include <linux/sched/task.h>
+#include <linux/sched/signal.h>
+
+static __used noinline void func(void)
+{
+	printk("func\n");
+	schedule_timeout(HZ * 5);
+}
+
+static int io_worker(void *data)
+{
+	set_task_comm(current, "io_worker");
+	while (1) {
+		set_current_state(TASK_INTERRUPTIBLE);
+		func();
+
+		if (fatal_signal_pending(current))
+			break;
+	}
+
+	return 0;
+}
+
+static int __init io_thread_init(void)
+{
+	struct task_struct *task = NULL;
+
+	task = create_io_thread(io_worker, NULL, 0);
+	if (task == NULL)
+		return -EINVAL;
+	wake_up_new_task(task);
+
+	/* when insmod exit, io thread got SIGKILL and exit, so... */
+	while (1)
+		schedule_timeout(HZ);
+	return 0;
+}
+
+static void __exit io_thread_exit(void)
+{
+	return;
+}
+
+module_init(io_thread_init);
+module_exit(io_thread_exit);
+
+MODULE_LICENSE("GPL");
diff --git a/samples/test/livepatch-sample.c 
b/samples/test/livepatch-sample.c
new file mode 100644
index 000000000000..c35b494f5c5a
--- /dev/null
+++ b/samples/test/livepatch-sample.c
@@ -0,0 +1,43 @@
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/livepatch.h>
+
+static void new_func(void)
+{
+	schedule_timeout(HZ * 5);
+	printk("new_func\n");
+}
+
+static struct klp_func funcs[] = {
+	{
+		.old_name = "func",
+		.new_func = new_func,
+	}, { }
+};
+
+static struct klp_object objs[] = {
+	{
+		.name = "io_thread",
+		.funcs = funcs,
+	}, { }
+};
+
+static struct klp_patch patch = {
+	.mod = THIS_MODULE,
+	.objs = objs,
+};
+
+static int livepatch_init(void)
+{
+	return klp_enable_patch(&patch);
+}
+
+static void livepatch_exit(void)
+{
+}
+
+module_init(livepatch_init);
+module_exit(livepatch_exit);
+MODULE_INFO(livepatch, "Y");
+
+MODULE_LICENSE("GPL");
-- 

>> Here we take the same fix action by treating PF_IO_WORKERS as PF_KTHREAD
>> within klp_send_signal function.
> 
> Yes, this sounds reasonable.
> 
> Miroslav
> 
>> Signed-off-by: Dong Kai <dongkai11@huawei.com>
>> ---
>> note:
>> the io threads freeze issue links:
>> [1] https://lore.kernel.org/io-uring/YEgnIp43%2F6kFn8GL@kevinlocke.name/
>> [2] https://lore.kernel.org/io-uring/d7350ce7-17dc-75d7-611b-27ebf2cb539b@kernel.dk/
>>
>>   kernel/livepatch/transition.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/kernel/livepatch/transition.c b/kernel/livepatch/transition.c
>> index f6310f848f34..0e1c35c8f4b4 100644
>> --- a/kernel/livepatch/transition.c
>> +++ b/kernel/livepatch/transition.c
>> @@ -358,7 +358,7 @@ static void klp_send_signals(void)
>>   		 * Meanwhile the task could migrate itself and the action
>>   		 * would be meaningless. It is not serious though.
>>   		 */
>> -		if (task->flags & PF_KTHREAD) {
>> +		if (task->flags & (PF_KTHREAD | PF_IO_WORKER)) {
>>   			/*
>>   			 * Wake up a kthread which sleeps interruptedly and
>>   			 * still has not been migrated.
> 

