Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D696437849
	for <lists+live-patching@lfdr.de>; Fri, 22 Oct 2021 15:46:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232730AbhJVNsu (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 22 Oct 2021 09:48:50 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:52903 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231174AbhJVNsu (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 22 Oct 2021 09:48:50 -0400
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20211022134631euoutp018ccd5cbbb9f78ab2fa456eace61f9a83~wXlbMTMVr1665816658euoutp01G
        for <live-patching@vger.kernel.org>; Fri, 22 Oct 2021 13:46:31 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20211022134631euoutp018ccd5cbbb9f78ab2fa456eace61f9a83~wXlbMTMVr1665816658euoutp01G
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1634910391;
        bh=XEQGY/hsnuVaWg6dxCt5+dEzHZMaxJb/cQxEAFSFgpo=;
        h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
        b=Km2h7kANODOgGiA0Zvma+9NYdPv3pzoNP38K2MIJMjQKPt6pY9+y5qealXrH9inqT
         2xhrY4BKVcuAsrac/j6bKzcSdeAIYHTYRZzO813iHfwod2QLPh7LxwDneJSWXgK1ij
         Nmoek89qzUWL6ksxJV9NRI3a/Sz7YmHmClAbZo8Y=
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20211022134631eucas1p11b2e2e32abde2209ce7bc0905c7b6158~wXlatpR932914329143eucas1p1p;
        Fri, 22 Oct 2021 13:46:31 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges3new.samsung.com (EUCPMTA) with SMTP id 1C.08.56448.6B0C2716; Fri, 22
        Oct 2021 14:46:30 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20211022134630eucas1p2e79e2816587d182c580459d567c1f2a9~wXlaL1B_j0625206252eucas1p24;
        Fri, 22 Oct 2021 13:46:30 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20211022134630eusmtrp296c6a85a1a6081ba8f1ec7fb76f0e6a6~wXlaKx3oa0305403054eusmtrp2J;
        Fri, 22 Oct 2021 13:46:30 +0000 (GMT)
X-AuditID: cbfec7f5-d3bff7000002dc80-33-6172c0b62cbd
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms1.samsung.com (EUCPMTA) with SMTP id 81.9E.31287.6B0C2716; Fri, 22
        Oct 2021 14:46:30 +0100 (BST)
Received: from [106.210.134.192] (unknown [106.210.134.192]) by
        eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20211022134629eusmtip22439ad24ccb6abaf86b90267320fb827~wXlZTpR1S0528205282eusmtip2I;
        Fri, 22 Oct 2021 13:46:29 +0000 (GMT)
Message-ID: <ff361300-a390-651d-8316-1f4e8d390af3@samsung.com>
Date:   Fri, 22 Oct 2021 15:46:29 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0)
        Gecko/20100101 Thunderbird/91.2.0
Subject: Re: [PATCH v2 04/11] sched: Simplify wake_up_*idle*()
Content-Language: en-US
To:     Peter Zijlstra <peterz@infradead.org>, gor@linux.ibm.com,
        jpoimboe@redhat.com, jikos@kernel.org, mbenes@suse.cz,
        pmladek@suse.com, mingo@kernel.org
Cc:     linux-kernel@vger.kernel.org, joe.lawrence@redhat.com,
        fweisbec@gmail.com, tglx@linutronix.de, hca@linux.ibm.com,
        svens@linux.ibm.com, sumanthk@linux.ibm.com,
        live-patching@vger.kernel.org, paulmck@kernel.org,
        rostedt@goodmis.org, x86@kernel.org
From:   Marek Szyprowski <m.szyprowski@samsung.com>
In-Reply-To: <20210929152428.769328779@infradead.org>
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrPKsWRmVeSWpSXmKPExsWy7djPc7rbDhQlGkx/YWMx83U3k8WFWd9Y
        LV7PW8Vocet4K6PF9M2r2CwO/DzBaHF51xw2izMH77FZ3F1xg8li9b9TjBaflnxjsTjee4DJ
        4v/jr6wW+zoeMFmcvn6Q1WLZ+rXsFps3TWW2+LHhMauDkMfOWXfZPVr23WL32LxCy2PTqk42
        j3fnzrF7TFh0gNHj/b6rbB7rt1xl8Tiz4Ai7x+dNcgFcUVw2Kak5mWWpRfp2CVwZD3avZixY
        qFSxf+tmtgbGOTJdjJwcEgImEpNXX2TpYuTiEBJYwShx7uxcZgjnC6PE32nfoDKfGSU+XNrF
        DNNyfOpGNojEckaJPWsvQ1V9ZJRY3/KRqYuRg4NXwE6ibUcMSAOLgKrEzYc/wZp5BQQlTs58
        wgJiiwokScyf/YAdxBYGKl/V/IERxGYWEJe49WQ+E8hMEYHZjBKz114Du4lZ4D+jxOs1IKs5
        OdgEDCW63naB2ZwCphItiyHOYxaQl2jeOhusQULgFqfE9qsbWCDudpHYdHkHE4QtLPHq+BZ2
        CFtG4v9OiHUSAs2MEg/PrWWHcHoYJS43zWCEqLKWuHPuFxvIb8wCmhLrd+lDhB0ljp05DxaW
        EOCTuPFWEOIIPolJ26YzQ4R5JTrahCCq1SRmHV8Ht/bghUvMExiVZiEFzCykAJiF5J1ZCHsX
        MLKsYhRPLS3OTU8tNs5LLdcrTswtLs1L10vOz93ECEyTp/8d/7qDccWrj3qHGJk4GA8xSnAw
        K4nw7q7ITxTiTUmsrEotyo8vKs1JLT7EKM3BoiTOu2vrmnghgfTEktTs1NSC1CKYLBMHp1QD
        05z1S0rvlLVPvxXA3Hl8XmBr+5Me+xulpjp3fAvD+T+8CxFc0eWz/IuMuszc1SXaBWw6Kekh
        H2K2qdousdVeJbxDa5f0xltxhRfUAqx/sosvsOGa8VdQ41tr5bndf4NN9F9U3vh94rDEtNl9
        LNaVn5YXzDmXxxt11D1aWbEsQy54c4W3eN6P0mdbXN8v3PJr69KzCYF/g9K0/A8nT29eMf+z
        A5tP5jtOa6N9e2MtqsMEBdyWb61eONWz6Ge0ltQ3sX2P/Jpv8uXyMG+vTt4uuiD/db9T3v3P
        i8RFD7cZ714ww/PIjgT5w/PYNasrVy+x+J15QOOUZeHtN7V/JnWnp599yjHryZT0bqGSfXNW
        K7EUZyQaajEXFScCAFe7zLUCBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpgleLIzCtJLcpLzFFi42I5/e/4Pd1tB4oSDZ5cEbeY+bqbyeLCrG+s
        Fq/nrWK0uHW8ldFi+uZVbBYHfp5gtLi8aw6bxZmD99gs7q64wWSx+t8pRotPS76xWBzvPcBk
        8f/xV1aLfR0PmCxOXz/IarFs/Vp2i82bpjJb/NjwmNVByGPnrLvsHi37brF7bF6h5bFpVSeb
        x7tz59g9Jiw6wOjxft9VNo/1W66yeJxZcITd4/MmuQCuKD2bovzSklSFjPziElulaEMLIz1D
        Sws9IxNLPUNj81grI1MlfTublNSczLLUIn27BL2MB7tXMxYsVKrYv3UzWwPjHJkuRk4OCQET
        ieNTN7J1MXJxCAksZZTYtuAuK0RCRuLktAYoW1jiz7UuqKL3jBJXvx1h6mLk4OAVsJNo2xED
        UsMioCpx8+FPZhCbV0BQ4uTMJywgtqhAksTHDTPA4sJA5auaPzCC2MwC4hK3nsxnApkpIjCb
        UeJ4Wx8ziMMs8J9RYt6aVrBuIYF4ia9bp7GB2GwChhJdb7vAbE4BU4mWxbuYISaZSXRt7YKa
        Ki/RvHU28wRGoVlIDpmFZOEsJC2zkLQsYGRZxSiSWlqcm55bbKhXnJhbXJqXrpecn7uJEZgU
        th37uXkH47xXH/UOMTJxMB5ilOBgVhLh3V2RnyjEm5JYWZValB9fVJqTWnyI0RQYGhOZpUST
        84FpKa8k3tDMwNTQxMzSwNTSzFhJnHfr3DXxQgLpiSWp2ampBalFMH1MHJxSDUxMLK1G6/z/
        rHH+LVOd5/7LtTRT84ed1wMJpYiXcX90HTbsV/S7zHf7YFZEvys/w/W+VyuETL7IVS3foxny
        MlJKaam6smNaMe9dpkXF8fvnloistJjzaf72TdnzzrEnsDic2v/ha9eOXaKssieOhlqs0RO3
        To+vjn8mwupkMJvb1vNwVKn5B9ekW9tsLavKPUQLrLjY5Z/d8lr8zdXr6XN/gbr1gZv2rE36
        dkbjkHil4adVV06dXLNt7tyYcPG2CwtqnX5WGejGC0Y9OXhsh+TWt7bHa62+Muy9INum58XU
        zxaw+Ut0zQzNtYvt5C88WnFompUu/4uPmnPL/gmVqu6b0fJWWWDZKrVdCgvm1SqxFGckGmox
        FxUnAgD/7ZAJkwMAAA==
X-CMS-MailID: 20211022134630eucas1p2e79e2816587d182c580459d567c1f2a9
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20211022134630eucas1p2e79e2816587d182c580459d567c1f2a9
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20211022134630eucas1p2e79e2816587d182c580459d567c1f2a9
References: <20210929151723.162004989@infradead.org>
        <20210929152428.769328779@infradead.org>
        <CGME20211022134630eucas1p2e79e2816587d182c580459d567c1f2a9@eucas1p2.samsung.com>
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Hi

On 29.09.2021 17:17, Peter Zijlstra wrote:
> Simplify and make wake_up_if_idle() more robust, also don't iterate
> the whole machine with preempt_disable() in it's caller:
> wake_up_all_idle_cpus().
>
> This prepares for another wake_up_if_idle() user that needs a full
> do_idle() cycle.
>
> Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>

This patch landed recently in linux-next as commit 8850cb663b5c ("sched: 
Simplify wake_up_*idle*()"). It causes the following warning on the 
arm64 virt machine under qemu during the system suspend/resume cycle:

--->8---

  printk: Suspending console(s) (use no_console_suspend to debug)

  ============================================
  WARNING: possible recursive locking detected
  5.15.0-rc6-next-20211022 #10905 Not tainted
  --------------------------------------------
  rtcwake/1326 is trying to acquire lock:
  ffffd4e9192e8130 (cpu_hotplug_lock){++++}-{0:0}, at: 
wake_up_all_idle_cpus+0x24/0x98

  but task is already holding lock:
  ffffd4e9192e8130 (cpu_hotplug_lock){++++}-{0:0}, at: 
suspend_devices_and_enter+0x740/0x9f0

  other info that might help us debug this:
   Possible unsafe locking scenario:

         CPU0
         ----
    lock(cpu_hotplug_lock);
    lock(cpu_hotplug_lock);

   *** DEADLOCK ***

   May be due to missing lock nesting notation

  5 locks held by rtcwake/1326:
   #0: ffff54ad86a78438 (sb_writers#7){.+.+}-{0:0}, at: ksys_write+0x64/0xf0
   #1: ffff54ad84094a88 (&of->mutex){+.+.}-{3:3}, at: 
kernfs_fop_write_iter+0xf4/0x1a8
   #2: ffff54ad83b17a88 (kn->active#43){.+.+}-{0:0}, at: 
kernfs_fop_write_iter+0xfc/0x1a8
   #3: ffffd4e9192efab0 (system_transition_mutex){+.+.}-{3:3}, at: 
pm_suspend+0x214/0x3d0
   #4: ffffd4e9192e8130 (cpu_hotplug_lock){++++}-{0:0}, at: 
suspend_devices_and_enter+0x740/0x9f0

  stack backtrace:
  CPU: 0 PID: 1326 Comm: rtcwake Not tainted 5.15.0-rc6-next-20211022 #10905
  Hardware name: linux,dummy-virt (DT)
  Call trace:
   dump_backtrace+0x0/0x1d0
   show_stack+0x14/0x20
   dump_stack_lvl+0x88/0xb0
   dump_stack+0x14/0x2c
   __lock_acquire+0x171c/0x17b8
   lock_acquire+0x234/0x378
   cpus_read_lock+0x5c/0x150
   wake_up_all_idle_cpus+0x24/0x98
   suspend_devices_and_enter+0x748/0x9f0
   pm_suspend+0x2b0/0x3d0
   state_store+0x84/0x108
   kobj_attr_store+0x14/0x28
   sysfs_kf_write+0x60/0x70
   kernfs_fop_write_iter+0x124/0x1a8
   new_sync_write+0xe8/0x1b0
   vfs_write+0x1d0/0x408
   ksys_write+0x64/0xf0
   __arm64_sys_write+0x14/0x20
   invoke_syscall+0x40/0xf8
   el0_svc_common.constprop.3+0x8c/0x120
   do_el0_svc_compat+0x18/0x48
   el0_svc_compat+0x48/0x100
   el0t_32_sync_handler+0xec/0x140
   el0t_32_sync+0x170/0x174
  OOM killer enabled.
  Restarting tasks ... done.
  PM: suspend exit

--->8---

Let me know if there is anything I can help to debug and fix this issue.

> ---
>   kernel/sched/core.c |   14 +++++---------
>   kernel/smp.c        |    6 +++---
>   2 files changed, 8 insertions(+), 12 deletions(-)
>
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -3691,15 +3691,11 @@ void wake_up_if_idle(int cpu)
>   	if (!is_idle_task(rcu_dereference(rq->curr)))
>   		goto out;
>   
> -	if (set_nr_if_polling(rq->idle)) {
> -		trace_sched_wake_idle_without_ipi(cpu);
> -	} else {
> -		rq_lock_irqsave(rq, &rf);
> -		if (is_idle_task(rq->curr))
> -			smp_send_reschedule(cpu);
> -		/* Else CPU is not idle, do nothing here: */
> -		rq_unlock_irqrestore(rq, &rf);
> -	}
> +	rq_lock_irqsave(rq, &rf);
> +	if (is_idle_task(rq->curr))
> +		resched_curr(rq);
> +	/* Else CPU is not idle, do nothing here: */
> +	rq_unlock_irqrestore(rq, &rf);
>   
>   out:
>   	rcu_read_unlock();
> --- a/kernel/smp.c
> +++ b/kernel/smp.c
> @@ -1170,14 +1170,14 @@ void wake_up_all_idle_cpus(void)
>   {
>   	int cpu;
>   
> -	preempt_disable();
> +	cpus_read_lock();
>   	for_each_online_cpu(cpu) {
> -		if (cpu == smp_processor_id())
> +		if (cpu == raw_smp_processor_id())
>   			continue;
>   
>   		wake_up_if_idle(cpu);
>   	}
> -	preempt_enable();
> +	cpus_read_unlock();
>   }
>   EXPORT_SYMBOL_GPL(wake_up_all_idle_cpus);
>   
>
>
>
Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

