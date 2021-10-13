Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A25E42C351
	for <lists+live-patching@lfdr.de>; Wed, 13 Oct 2021 16:33:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237030AbhJMOfB (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 13 Oct 2021 10:35:01 -0400
Received: from alexa-out.qualcomm.com ([129.46.98.28]:31591 "EHLO
        alexa-out.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237700AbhJMOee (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 13 Oct 2021 10:34:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=quicinc.com; i=@quicinc.com; q=dns/txt; s=qcdkim;
  t=1634135551; x=1665671551;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=jxIqZWJHb3DoiW2AaZF9sAuP6FNHBTjv1LCrBUajA6o=;
  b=MtE6Gjvm2CAdtRptKsLKyBx2h8jgUcg5RhzmAk/2Q4xXHqJ9HJyNvcCB
   UVX/YKotLx9xe7wv4kyQa9lbH5RdMy6TydRFeo3MhkQv558xVdu7NZmcN
   SWCMq+MI0xi3QXjWGTVPTPUh3nijV0sNZ+DmCIWT3lNnfbloBgsBGq1ad
   A=;
Received: from ironmsg-lv-alpha.qualcomm.com ([10.47.202.13])
  by alexa-out.qualcomm.com with ESMTP; 13 Oct 2021 07:32:30 -0700
X-QCInternal: smtphost
Received: from nalasex01a.na.qualcomm.com ([10.47.209.196])
  by ironmsg-lv-alpha.qualcomm.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Oct 2021 07:32:29 -0700
Received: from [10.111.161.132] (10.80.80.8) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.922.7; Wed, 13 Oct 2021
 07:32:27 -0700
Message-ID: <ba4ca17f-100e-bef7-6d7b-4de0f5a515b9@quicinc.com>
Date:   Wed, 13 Oct 2021 10:32:26 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH v2 04/11] sched: Simplify wake_up_*idle*()
Content-Language: en-US
To:     Peter Zijlstra <peterz@infradead.org>, <gor@linux.ibm.com>,
        <jpoimboe@redhat.com>, <jikos@kernel.org>, <mbenes@suse.cz>,
        <pmladek@suse.com>, <mingo@kernel.org>
CC:     <linux-kernel@vger.kernel.org>, <joe.lawrence@redhat.com>,
        <fweisbec@gmail.com>, <tglx@linutronix.de>, <hca@linux.ibm.com>,
        <svens@linux.ibm.com>, <sumanthk@linux.ibm.com>,
        <live-patching@vger.kernel.org>, <paulmck@kernel.org>,
        <rostedt@goodmis.org>, <x86@kernel.org>
References: <20210929151723.162004989@infradead.org>
 <20210929152428.769328779@infradead.org>
From:   Qian Cai <quic_qiancai@quicinc.com>
In-Reply-To: <20210929152428.769328779@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org



On 9/29/2021 11:17 AM, Peter Zijlstra wrote:
> --- a/kernel/smp.c
> +++ b/kernel/smp.c
> @@ -1170,14 +1170,14 @@ void wake_up_all_idle_cpus(void)
>  {
>  	int cpu;
>  
> -	preempt_disable();
> +	cpus_read_lock();
>  	for_each_online_cpu(cpu) {
> -		if (cpu == smp_processor_id())
> +		if (cpu == raw_smp_processor_id())
>  			continue;
>  
>  		wake_up_if_idle(cpu);
>  	}
> -	preempt_enable();
> +	cpus_read_unlock();

Peter, it looks like this thing introduced a deadlock during CPU online/offline.

[  630.145166][  T129] WARNING: possible recursive locking detected
[  630.151164][  T129] 5.15.0-rc5-next-20211013+ #145 Not tainted
[  630.156988][  T129] --------------------------------------------
[  630.162984][  T129] cpuhp/21/129 is trying to acquire lock:
[  630.168547][  T129] ffff800011f466d0 (cpu_hotplug_lock){++++}-{0:0}, at: wake_up_all_idle_cpus+0x40/0xe8
wake_up_all_idle_cpus at /usr/src/linux-next/kernel/smp.c:1174
[  630.178040][  T129]
[  630.178040][){++++}-{0:0}, at help us debug this:
[  630.202292][  T129]  Possible unsafe locking scenario:
[  630.202292][  T129]
[  630.209590][  T129]        CPU0
[  630.212720][  T129]        ----
[  630.215851][  T129]   lock(cpu_hotplug_lock);
[  630.220202][  T129]   lock(cpu_hotplug_lock);
[  630.224553][  T129]
[  630.224553][  T129]  *** DEADLOCK ***
[  630.224553][  T129]
[  630.232545][  T129]  May be due to missing lock nesting notation
[  630.232545][  T129]
[  630.240711][  T129] 3 locks held by cpuhp/21/129:
[  630.245406][  T129]  #0: ffff800011f466d0 (cpu_hotplug_lock){++++}-{0:0}, at: cpuhp_thread_fun+0xe0/0x588
[  630.254976][  T129]  #1: ffff800011f46780 (cpuhp_state-up){+.+.}-{0:0}, at: cpuhp_thread_fun+0xe0/0x588
[  630.264372][  T129]  #2: ffff8000191fb9c8 (cpuidle_lock){+.+.}-{3:3}, at: cpuidle_pause_and_lock+0x24/0x38
[  630.274031][  T129]
[  630.274031][  T129] stack backtrace:
[  630.279767][  T129] CPU: 21 PID: 129 Comm: cpuhp/21 Not tainted 5.15.0-rc5-next-20211013+ #145
[  630.288371][  T129] Hardware name: MiTAC RAPTOR EV-883832-X3-0001/RAPTOR, BIOS 1.6 06/28/2020
[  630.296886][  T129] Call trace:
[  630.300017][  T129]  dump_backtrace+0x0/0x3b8
[  630.304369][  T129]  show_stack+0x20/0x30
[  630.308371][  T129]  dump_stack_lvl+0x8c/0xb8
[  630.312722][  T129]  dump_stack+0x1c/0x38
[  630.316723][  T129]  validate_chain+0x1d84/0x1da0
[  630.321421][  T129]  __lock_acquire+0xab0/0x2040
[  630.326033][  T129]  lock_acquire+0x32c/0xb08
[  630.330390][  T129]  cpus_read_lock+0x94/0x308
[  630.334827][  T129]  wake_up_all_idle_cpus+0x40/0xe8
[  630.339784][  T129]  cpuidle_uninstall_idle_handler+0x3c/0x50
[  630.345524][  T129]  cpuidle_pause_and_lock+0x28/0x38
[  630.350569][  T129]  acpi_processor_hotplug+0xc0/0x170
[  630.355701][  T129]  acpi_soft_cpu_online+0x124/0x250
[  630.360745][  T129]  cpuhp_invoke_callback+0x51c/0x2ab8
[  630.365963][  T129]  cpuhp_thread_fun+0x204/0x588
[  630.370659][  T129]  smpboot_thread_fn+0x3f0/0xc40
[  630.375444][  T129]  kthread+0x3d8/0x488
[  630.379360][  T129]  ret_from_fork+0x10/0x20
[  863.525716][  T191] INFO: task cpuhp/21:129 blocked for more than 122 seconds.
[  863.532954][  T191]       Not tainted 5.15.0-rc5-next-20211013+ #145
[  863.539361][  T191] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  863.547927][  T191] task:cpuhp/21        state:D stack:59104 pid:  129 ppid:     2 flags:0x00000008
[  863.557029][  T191] Call trace:
[  863.560171][  T191]  __switch_to+0x184/0x400
[  863.564448][  T191]  __schedule+0x74c/0x1940
[  863.568753][  T191]  schedule+0x110/0x318
[  863.572764][  T191]  percpu_rwsem_wait+0x1b8/0x348
[  863.577592][  T191]  __percpu_down_read+0xb0/0x148
[  863.582386][  T191]  cpus_read_lock+0x2b0/0x308
[  863.586961][  T191]  wake_up_all_idle_cpus+0x40/0xe8
[  863.591931][  T191]  cpuidle_uninstall_idle_handler+0x3c/0x50
[  863.597716][  T191]  cpuidle_pause_and_lock+0x28/0x38
[  863.602771][  T191]  acpi_processor_hotplug+0xc0/0x170
[  863.607946][  T191]  acpi_soft_cpu_online+0x124/0x250
[  863.613001][  T191]  cpuhp_invoke_callback+0x51c/0x2ab8
[  863.618261][  T191]  cpuhp_thread_fun+0x204/0x588
[  863.622967][  T191]  smpboot_thread_fn+0x3f0/0xc40
[  863.627787][  T191]  kthread+0x3d8/0x488
[  863.631712][  T191]  ret_from_fork+0x10/0x20
[  863.636020][  T191] INFO: task kworker/0:2:189 blocked for more than 122 seconds.
[  863.643500][  T191]       Not tainted 5.15.0-rc5-next-20211013+ #145
[  863.649882][  T191] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  863.658425][  T191] task:kworker/0:2     state:D stack:58368 pid:  189 ppid:     2 flags:0x00000008
[  863.667516][  T191] Workqueue: events vmstat_shepherd
[  863.672573][  T191] Call trace:
[  863.675731][  T191]  __switch_to+0x184/0x400
[  863.680001][  T191]  __schedule+0x74c/0x1940
[  863.684268][  T191]  schedule+0x110/0x318
[  863.688295][  T191]  percpu_rwsem_wait+0x1b8/0x348
[  863.693085][  T191]  __percpu_down_read+0xb0/0x148
[  863.697892][  T191]  cpus_read_lock+0x2b0/0x308
[  863.702421][  T191]  vmstat_shepherd+0x5c/0x1a8
[  863.706977][  T191]  process_one_work+0x808/0x19d0
[  863.711767][  T191]  worker_thread+0x334/0xae0
[  863.716227][  T191]  kthread+0x3d8/0x488
[  863.720149][  T191]  ret_from_fork+0x10/0x20
[  863.724487][  T191] INFO: task lsbug:4642 blocked for more than 123 seconds.
[  863.731565][  T191]       Not tainted 5.15.0-rc5-next-20211013+ #145
[  863.737938][  T191] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  863.746490][  T191] task:lsbug           state:D stack:55536 pid: 4642 ppid:  4638 flags:0x00000008
[  863.755549][  T191] Call trace:
[  863.758712][  T191]  __switch_to+0x184/0x400
[  863.762984][  T191]  __schedule+0x74c/0x1940
[  863.767286][  T191]  schedule+0x110/0x318
[  863.771294][  T191]  schedule_timeout+0x188/0x238
[  863.776016][  T191]  wait_for_completion+0x174/0x290
[  863.780979][  T191]  __cpuhp_kick_ap+0x158/0x1a8
[  863.785592][  T191]  cpuhp_kick_ap+0x1f0/0x828
[  863.790053][  T191]  bringup_cpu+0x180/0x1e0
[  863.794320][  T191]  cpuhp_invoke_callback+0x51c/0x2ab8
[  863.799561][  T191]  cpuhp_invoke_callback_range+0xa4/0x108
[  863.805130][  T191]  cpu_up+0x528/0xd78
[  863.808982][  T191]  cpu_device_up+0x4c/0x68
[  863.813249][  T191]  cpu_subsys_online+0xc0/0x1f8
[  863.817972][  T191]  device_online+0x10c/0x180
[  863.822413][  T191]  online_store+0x10c/0x118
[  863.826791][  T191]  dev_attr_store+0x44/0x78
[  863.831148][  T191]  sysfs_kf_write+0xe8/0x138
[  863.835590][  T191]  kernfs_fop_write_iter+0x26c/0x3d0
[  863.840745][  T191]  new_sync_write+0x2bc/0x4f8
[  863.845275][  T191]  vfs_write+0x714/0xcd8
[  863.849387][  T191]  ksys_write+0xf8/0x1e0
[  863.853481][  T191]  __arm64_sys_write+0x74/0xa8
[  863.858113][  T191]  invoke_syscall.constprop.0+0xdc/0x1d8
[  863.863597][  T191]  do_el0_svc+0xe4/0x298
[  863.867710][  T191]  el0_svc+0x64/0x130
[  863.871545][  T191]  el0t_64_sync_handler+0xb0/0xb8
[  863.876437][  T191]  el0t_64_sync+0x180/0x184
[  863.880798][  T191] INFO: task mount:4682 blocked for more than 123 seconds.
[  863.887881][  T191]       Not tainted 5.15.0-rc5-next-20211013+ #145
[  863.894232][  T191] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  863.902776][  T191] task:mount           state:D stack:55856 pid: 4682 ppid:  1101 flags:0x00000000
[  863.911865][  T191] Call trace:
[  863.915003][  T191]  __switch_to+0x184/0x400
[  863.919296][  T191]  __schedule+0x74c/0x1940
[  863.923564][  T191]  schedule+0x110/0x318
[  863.927590][  T191]  percpu_rwsem_wait+0x1b8/0x348
[  863.932380][  T191]  __percpu_down_read+0xb0/0x148
[  863.937187][  T191]  cpus_read_lock+0x2b0/0x308
[  863.941715][  T191]  alloc_workqueue+0x730/0xd48
[  863.946357][  T191]  loop_configure+0x2d4/0x1180 [loop]
[  863.951592][  T191]  lo_ioctl+0x5dc/0x1228 [loop]
[  863.956321][  T191]  blkdev_ioctl+0x258/0x820
[  863.960678][  T191]  __arm64_sys_ioctl+0x114/0x180
[  863.965468][  T191]  invoke_syscall.constprop.0+0xdc/0x1d8
[  863.970974][  T191]  do_el0_svc+0xe4/0x298
[  863.975069][  T191]  el0_svc+0x64/0x130
[  863.978922][  T191]  el0t_64_sync_handler+0xb0/0xb8
[  863.983798][  T191]  el0t_64_sync+0x180/0x184
[  863.988172][  T191] INFO: lockdep is turned off.
