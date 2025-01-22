Return-Path: <live-patching+bounces-1033-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E60CEA191BF
	for <lists+live-patching@lfdr.de>; Wed, 22 Jan 2025 13:51:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8040C7A5340
	for <lists+live-patching@lfdr.de>; Wed, 22 Jan 2025 12:51:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8129E212D8C;
	Wed, 22 Jan 2025 12:50:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="WrR3kIK2"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17662212D7A
	for <live-patching@vger.kernel.org>; Wed, 22 Jan 2025 12:50:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737550254; cv=none; b=NpTToiLUJKMrGKZE837KuE8HXdKTB7CNx6eiBxOCyCehtmeACZY5e2fzVjLVpfleze2iW2F5Py1ymoVxuYEtJWZxA06viOmLcTNz8PDU039QB/RLZhMKGC/J7GCQKAqMX08tSOiRB75dJdMoUC6PmqUjkvfzQ1TgvILGIZyC8WA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737550254; c=relaxed/simple;
	bh=EQyen9m2UqIESIDDKdEroLPYxy9uSbq3uiPukNbEvg4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NDT24GNc7neUhjV4krUDZbfIinFi543DbbybkreIj5TGjLVUcbNSEBWpKtDzmGBFze5d2D02h5fUXucb1pT8K9fFO3QWT9DDGDCC/KVD5mAbnVUHsCBIoNx6CETUYOfN3+YrruoEfC3MQDAhVt1S9i7qhPfJ0H0KLXvWirFaLBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=WrR3kIK2; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4361b6f9faeso5527755e9.1
        for <live-patching@vger.kernel.org>; Wed, 22 Jan 2025 04:50:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1737550250; x=1738155050; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=dynbQ+JnBpDGll3KH4ZuUsJnV7SqX0YtyA6hRZXRV8o=;
        b=WrR3kIK2gDmzN86aYW9CY68QLetUuvoh/uUIWkoZy+4uLOjJlG7sEgeBcI72hg6RH0
         /udoDK+nbG+T+hCcvBUz/CLtTtb401r9Cm3u8xr6RsXwU86PATCh+Aa0aue1IRAUe1rn
         6mwuGoZfvsDlfshpIjV5NIY2MVijGv+HVnNxfaGwyzpLaOYvAxWmNJphOp5ZhV5ZC2Jj
         emScw97lMZOySH5iC5va7E1SgBVO1A6YWvjwmk2/3nsymKORabr9iAWqXj0Y3Lqv5ebZ
         UQBH6LwUWffAbrvWywk7q1YpUooMns6TFF9LiYfx/58GhzZbE0Q/oczXoRLZrEiShomX
         NZlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737550250; x=1738155050;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dynbQ+JnBpDGll3KH4ZuUsJnV7SqX0YtyA6hRZXRV8o=;
        b=M2ngzK19iGqLZoq9ICPgjR4e8PEhUN20qnytcIYXy4fgU/wocUg5ggaVPqSuq1b1Aq
         QpfMt6yZ12x6qqlcetB/iUSVUYYCNiroEkaiX2vN7RycqxSX96haz1m76bAPkAL6jB3Y
         M/uMn/Z2feplVKD9SljTkOQfURBS9CGsp4YC6riflTWGjGFCl6t9IMA+J62//FdgUYow
         Yd6drR09EDNjMX5jQSyqOJU8ccZHyAt6qylJgJ+QPtRkgRnS6+zF5zVF5TLflxaadRtV
         +tUjdoQiQmQfzC3pSkPhcANHeiHqgFviYVnxC2Xlmk9ioJVF/Il2qxHqd+BEgrBK7hFk
         rN8Q==
X-Forwarded-Encrypted: i=1; AJvYcCVB3+2OvCWSn6Tu/k60/ELht/ryzgAQaRAwiwdGu4taadO+cR6KKp2h8WQdkOZffLeC+Wo83kIio3qTbBwo@vger.kernel.org
X-Gm-Message-State: AOJu0YzEPebh8kD4/HTocdnRk6favbB2LFXXlPqZFUakGzQ+NCWuAjWE
	PuS80/aoWb7v6lQmMeb5sjbPBPm4BsAqGwkM2oYlrdTT0L8rjCWKFBVKVtEdqRY=
X-Gm-Gg: ASbGncsOZjp6VenMT167gtOPxGVZ5+1bG589e4tj7LaJw7+JyWDrbzzIYpRsnL/oOAM
	Zy88YyW2NlmuMx64IOBtae6GcZ+RNcrNRHVcMOB9QFtiJlP+csbg4NREIYSx+QPjFwst/ncIDk+
	wz+N3REGQhqxnufsfLbqE5f98eoLaprw9ck6KAENUX/a0CppalWfrRxb3+HLD3oBXzqMKpMaC9Q
	F5Qzu4toYq03Q73pNxhcKotZYXBX9oS4ycchpjq0uOUnPQIy6CwlSdLfrHLW1OkFNhIci4=
X-Google-Smtp-Source: AGHT+IHIKx21KwUgFyEbEag6SvYR6o5SHBBGf9xuC5/Z1eV3Ap53rAsV/Ri1hUx9MRlkMOQlDUQZrw==
X-Received: by 2002:a05:600c:4f53:b0:434:fa73:a906 with SMTP id 5b1f17b1804b1-438918c5d0fmr178105475e9.4.1737550250270;
        Wed, 22 Jan 2025 04:50:50 -0800 (PST)
Received: from pathway.suse.cz ([176.114.240.50])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38bf3279388sm16133512f8f.75.2025.01.22.04.50.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jan 2025 04:50:49 -0800 (PST)
Date: Wed, 22 Jan 2025 13:50:48 +0100
From: Petr Mladek <pmladek@suse.com>
To: Yafang Shao <laoar.shao@gmail.com>
Cc: jpoimboe@kernel.org, jikos@kernel.org, mbenes@suse.cz,
	joe.lawrence@redhat.com, live-patching@vger.kernel.org
Subject: Re: [PATCH] livepatch: Avoid hard lockup caused by
 klp_try_switch_task()
Message-ID: <Z5DpqC7sm5qCJFtj@pathway.suse.cz>
References: <20250122085146.41553-1-laoar.shao@gmail.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250122085146.41553-1-laoar.shao@gmail.com>

On Wed 2025-01-22 16:51:46, Yafang Shao wrote:
> I encountered a hard lockup while attempting to reproduce the panic issue
> that occurred on our production servers [0]. The hard lockup manifests as
> follows:
> 
> [15852778.150191] livepatch: klp_try_switch_task: grpc_executor:421106 is sleeping on function do_exit
> [15852778.169471] livepatch: klp_try_switch_task: grpc_executor:421244 is sleeping on function do_exit
> [15852778.188746] livepatch: klp_try_switch_task: grpc_executor:421457 is sleeping on function do_exit
> [15852778.208021] livepatch: klp_try_switch_task: grpc_executor:422407 is sleeping on function do_exit
> [15852778.227292] livepatch: klp_try_switch_task: grpc_executor:423184 is sleeping on function do_exit
> [15852778.246576] livepatch: klp_try_switch_task: grpc_executor:423582 is sleeping on function do_exit
> [15852778.265863] livepatch: klp_try_switch_task: grpc_executor:423738 is sleeping on function do_exit
> [15852778.285149] livepatch: klp_try_switch_task: grpc_executor:423739 is sleeping on function do_exit
> [15852778.304446] livepatch: klp_try_switch_task: grpc_executor:423833 is sleeping on function do_exit
> [15852778.323738] livepatch: klp_try_switch_task: grpc_executor:423893 is sleeping on function do_exit
> [15852778.343017] livepatch: klp_try_switch_task: grpc_executor:423894 is sleeping on function do_exit
> [15852778.362292] livepatch: klp_try_switch_task: grpc_executor:423976 is sleeping on function do_exit
> [15852778.381565] livepatch: klp_try_switch_task: grpc_executor:423977 is sleeping on function do_exit
> [15852778.400847] livepatch: klp_try_switch_task: grpc_executor:424610 is sleeping on function do_exit
> [15852778.412319] NMI watchdog: Watchdog detected hard LOCKUP on cpu 15
> ...
> [15852778.412374] CPU: 15 PID: 1 Comm: systemd Kdump: loaded Tainted: G S      W  O  K    6.1.52-3
> [15852778.412377] Hardware name: New H3C Technologies Co., Ltd. H3C UniServer R4950 G5/RS45M2C9S, BIOS 5.12 10/15/2021
> [15852778.412378] RIP: 0010:queued_write_lock_slowpath+0x75/0x135
> ...
> [15852778.412397] Call Trace:
> [15852778.412398]  <NMI>
> [15852778.412400]  ? show_regs.cold+0x1a/0x1f
> [15852778.412403]  ? watchdog_overflow_callback.cold+0x1e/0x70
> [15852778.412406]  ? __perf_event_overflow+0x102/0x1e0
> [15852778.412409]  ? perf_event_overflow+0x19/0x20
> [15852778.412411]  ? x86_pmu_handle_irq+0xf7/0x160
> [15852778.412415]  ? flush_tlb_one_kernel+0xe/0x30
> [15852778.412418]  ? __set_pte_vaddr+0x2d/0x40
> [15852778.412421]  ? set_pte_vaddr_p4d+0x3d/0x50
> [15852778.412423]  ? set_pte_vaddr+0x6d/0xa0
> [15852778.412424]  ? __native_set_fixmap+0x28/0x40
> [15852778.412426]  ? native_set_fixmap+0x54/0x60
> [15852778.412428]  ? ghes_copy_tofrom_phys+0x75/0x120
> [15852778.412431]  ? __ghes_peek_estatus.isra.0+0x4e/0xb0
> [15852778.412434]  ? ghes_in_nmi_queue_one_entry.constprop.0+0x3d/0x240
> [15852778.412437]  ? amd_pmu_handle_irq+0x48/0xc0
> [15852778.412438]  ? perf_event_nmi_handler+0x2d/0x50
> [15852778.412440]  ? nmi_handle+0x60/0x120
> [15852778.412443]  ? default_do_nmi+0x45/0x120
> [15852778.412446]  ? exc_nmi+0x118/0x150
> [15852778.412447]  ? end_repeat_nmi+0x16/0x67
> [15852778.412450]  ? copy_process+0xf01/0x19f0
> [15852778.412452]  ? queued_write_lock_slowpath+0x75/0x135
> [15852778.412455]  ? queued_write_lock_slowpath+0x75/0x135
> [15852778.412457]  ? queued_write_lock_slowpath+0x75/0x135
> [15852778.412459]  </NMI>
> [15852778.412460]  <TASK>
> [15852778.412461]  _raw_write_lock_irq+0x43/0x50
> [15852778.412463]  copy_process+0xf01/0x19f0
> [15852778.412466]  kernel_clone+0x9d/0x3e0
> [15852778.412468]  ? autofs_dev_ioctl_requester+0x100/0x100
> [15852778.412471]  __do_sys_clone+0x66/0x90
> [15852778.412475]  __x64_sys_clone+0x25/0x30
> [15852778.412477]  do_syscall_64+0x38/0x90
> [15852778.412478]  entry_SYSCALL_64_after_hwframe+0x64/0xce
> [15852778.412481] RIP: 0033:0x7f426bb3b9c1
> ...
> 
> Notably, dynamic_debug is enabled to collect debug information when
> applying a livepatch, resulting in a large amount of debug output.
> 
> The issue arises because klp_try_switch_task() holds the tasklist_lock, and
> if another task attempts to acquire it, it must spin until it's available.
> This becomes problematic in the copy_process() path, where IRQs are
> disabled, leading to the hard lockup. To prevent this, we should implement
> a check for spinlock contention before proceeding.
> 
> Link: https://lore.kernel.org/live-patching/CALOAHbA9WHPjeZKUcUkwULagQjTMfqAdAg+akqPzbZ7Byc=qrw@mail.gmail.com/ [0]
> Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
> ---
>  kernel/livepatch/transition.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/livepatch/transition.c b/kernel/livepatch/transition.c
> index ba069459c101..774017825bb4 100644
> --- a/kernel/livepatch/transition.c
> +++ b/kernel/livepatch/transition.c
> @@ -467,9 +467,14 @@ void klp_try_complete_transition(void)
>  	 * unless the patch includes changes to a very common function.
>  	 */
>  	read_lock(&tasklist_lock);
> -	for_each_process_thread(g, task)
> +	for_each_process_thread(g, task) {
>  		if (!klp_try_switch_task(task))
>  			complete = false;
> +		if (rwlock_is_contended(&tasklist_lock) || need_resched()) {

Are you able to finish the livepatch transition with this patch?

> +			complete = false;
> +			break;
> +		}
> +	}
>  	read_unlock(&tasklist_lock);
>  
>  	/*

With this patch, any operation which takes the tasklist_lock might
break klp_try_complete_transition(). I am afraid that this might
block the transition for a long time on huge systems with some
specific loads.

And the problem is caused by a printk() added just for debugging.
I wonder if you even use a slow serial port.

You might try to use printk_deferred() instead. Also you might need
to disable interrupts around the read_lock()/read_unlock() to
make sure that the console handling will be deferred after
the tasklist_lock gets released.

Anyway, I am against this patch.

Best Regards,
Petr

