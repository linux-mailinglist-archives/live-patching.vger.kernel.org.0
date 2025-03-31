Return-Path: <live-patching+bounces-1347-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0674DA762ED
	for <lists+live-patching@lfdr.de>; Mon, 31 Mar 2025 11:06:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 56F603AB099
	for <lists+live-patching@lfdr.de>; Mon, 31 Mar 2025 09:05:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3AF981D88A4;
	Mon, 31 Mar 2025 09:06:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Ls2j7hF3"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-ed1-f68.google.com (mail-ed1-f68.google.com [209.85.208.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F470AD23
	for <live-patching@vger.kernel.org>; Mon, 31 Mar 2025 09:05:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.68
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743411960; cv=none; b=glBXUVPSM9G76LQhJI9JjSME+YjDNnlZ/d1R9VTdtNabG8+KMeJ4YEAweE9fhMUlm9xjqHHab8qc6Qe/ldpi1FXAvlyvLIOxvkP5ABCxZGNw9v4pN7SmFrtGhli30BNnO9k4DSZGO0M/xHe1Z5DwsPJqeBsQz9nU6Suw2IPswRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743411960; c=relaxed/simple;
	bh=zJ8Z+pdAxNUzJR1B1ibFK4msNtLxcqUN/V/IBVzo1+s=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uuZphwy45D8qw0+xcy3wSbteBMaQkR8TspuunJ7t2XEZPsm09qyEbgVXd43Wo8zLAJUKvvybfDYZBXV/LKx8N/Ey6Fc8HNJGDiMP0y9QTuNU4/OOV+eLw8NPG1XYmQjZJNH/FLafgDpOo+MFvlrel2K0f7CMBCGNOjfTvpvrP1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Ls2j7hF3; arc=none smtp.client-ip=209.85.208.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-ed1-f68.google.com with SMTP id 4fb4d7f45d1cf-5e5e1a38c1aso5646351a12.2
        for <live-patching@vger.kernel.org>; Mon, 31 Mar 2025 02:05:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1743411955; x=1744016755; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Llm9pma7GB9kBl93sCNj/g39MW9hKI2/XXZsXMDyXJU=;
        b=Ls2j7hF3Z0Fm59JwAkqMYUrTivYOiOibYsJEfTroceT8nY/htHh+094zzjXfLNoRHL
         u10s4VquO0n6x3SQIm3jXvXHuHmq1UtQMCqQkcldJYHAaQzM1L8HA90BSafSS98+tcdt
         ykNyZIblyzV4dNakFDteLa6mbV8U1RMPrE0RhKAdojkzMEzwlVgilMrKzeBvvpzoj7Vm
         QQsjULyWTAeefTTBvgbeqxlEi6msLuQtMQ+GQDqABbQ1ErLVQY3mXBwRbbkV1ifzi4Nb
         Z8ED9ss8yeusBJTiJk0Uf0kQFaFA/DFj6xo+xDVkVRVO5OVE8Qz+bA/uEil3HXWAYv67
         g4bQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743411955; x=1744016755;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Llm9pma7GB9kBl93sCNj/g39MW9hKI2/XXZsXMDyXJU=;
        b=BzP1GMYqoxeLmjDfz5kHq8uu2W5IAYZ9SGevM/pm4DwD7j1EmyDtgbKQYXqfzLQGsu
         /POB2jbAJMVj8WYh2GhtB0YPNEl9hBoKA2N0xB1TsxfxC1ae0+SbP/A3Y5TPlkzmOzlp
         K6Keu0NVpdtub2t33iayxUQIj8Nga3viU0f3c1akIqASvWpCJilnU6baDhgPS0p3zx04
         H8HKIcqKu95n7hTjnJXngaG40YSRUdPMZrwIlo8kLb80oAk+mT6G28dCPYC6qX1D/f9/
         mIPIs58N6FKt4mAok/qcIbMr1M9x6vIJb7vyncbWEawafmZmIwAq8gjrlIBgiEVOZR4m
         IDCA==
X-Forwarded-Encrypted: i=1; AJvYcCWg3opRuWnp/dW1iVIZNNq7nKFScek6x/klBVsBwWrkju1PQDjz5L0ads3e/LweIGobNHxrFjWxxuk2ge1s@vger.kernel.org
X-Gm-Message-State: AOJu0YxEGIwC9PmCkhkOfWsILwf6aiG+8sJ3sHeFDqJ4AFMDkwK20hn/
	eRymasmHizxbQXMTKvbj65jlOpNg25Aj/dOH/78HjqirqQCeNz7k5cFIi7xEV3ccuciZ2qqEqI4
	fnQRlQg==
X-Gm-Gg: ASbGncu00qGarF4Zw3UqD2wZXQCqgGZ369pUOotKwLOGNqQRqtE1ByRtDitePKL/GFe
	BUAaZsZsWIKRxwoJwxkgFQ1S7vWmgNd3WXVNpHnZQKYp2f28vfvVBSDTHlgJ7WV/wRkIYDcDTKR
	EY+YevEmGbCjOlBMdL2Guuwa2uO8ak3XN0kacXbumopwxKBlw6ilcxzbBPTDEgljGQzt7id8PhI
	fwFN/1uGkLzKyq2eJOD9wrPUzw90Xrf6qAZp+8hdaac3ZsbAIkDdL3oR5QgEa4yWUanoYHZct2v
	QcRFXSFFKOXewVNWUzXF1fn2cQrON+YckgMoTkG9l2kcRDymp3Vb2dySFX6xj201UwEtWV77BGr
	kHx5FswFnxC/E
X-Google-Smtp-Source: AGHT+IGHsMCAoVAwG4CE1fni04ClvtPYfCFVP4V9SvKvPyt4K6GKejVrsoR2ClYLTTrY2bxgzG9t7g==
X-Received: by 2002:a05:6402:2793:b0:5ec:939e:a60e with SMTP id 4fb4d7f45d1cf-5edfb36bf62mr6145611a12.0.1743411954999;
        Mon, 31 Mar 2025 02:05:54 -0700 (PDT)
Received: from localhost (host-87-5-222-245.retail.telecomitalia.it. [87.5.222.245])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5edc16d41f6sm5579663a12.25.2025.03.31.02.05.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Mar 2025 02:05:54 -0700 (PDT)
From: Andrea della Porta <andrea.porta@suse.com>
X-Google-Original-From: Andrea della Porta <aporta@suse.de>
Date: Mon, 31 Mar 2025 11:07:12 +0200
To: Song Liu <song@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-toolchains@vger.kernel.org, live-patching@vger.kernel.org,
	indu.bhagat@oracle.com, puranjay@kernel.org, wnliu@google.com,
	irogers@google.com, joe.lawrence@redhat.com, jpoimboe@kernel.org,
	mark.rutland@arm.com, peterz@infradead.org,
	roman.gushchin@linux.dev, rostedt@goodmis.org, will@kernel.org,
	kernel-team@meta.com, Suraj Jitindar Singh <surajjs@amazon.com>,
	Torsten Duwe <duwe@suse.de>, Miroslav Benes <mbenes@suse.cz>,
	Breno Leitao <leitao@debian.org>
Subject: Re: [PATCH v3 2/2] arm64: Implement HAVE_LIVEPATCH
Message-ID: <Z-pbQJtwdAxyR0Fg@apocalypse>
References: <20250320171559.3423224-1-song@kernel.org>
 <20250320171559.3423224-3-song@kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250320171559.3423224-3-song@kernel.org>

On 10:15 Thu 20 Mar     , Song Liu wrote:
> This is largely based on [1] by Suraj Jitindar Singh.
> 
> Test coverage:
> 
> - Passed manual tests with samples/livepatch.
> - Passed all but test-kprobe.sh in selftests/livepatch.
>   test-kprobe.sh is expected to fail, because arm64 doesn't have
>   KPROBES_ON_FTRACE.
> - Passed tests with kpatch-build [2]. (This version includes commits that
>   are not merged to upstream kpatch yet).
> 
> [1] https://lore.kernel.org/all/20210604235930.603-1-surajjs@amazon.com/
> [2] https://github.com/liu-song-6/kpatch/tree/fb-6.13
> Cc: Suraj Jitindar Singh <surajjs@amazon.com>
> Cc: Torsten Duwe <duwe@suse.de>
> Signed-off-by: Song Liu <song@kernel.org>
> Acked-by: Miroslav Benes <mbenes@suse.cz>
> Tested-by: Breno Leitao <leitao@debian.org>
> ---
>  arch/arm64/Kconfig                   | 3 +++
>  arch/arm64/include/asm/thread_info.h | 4 +++-
>  arch/arm64/kernel/entry-common.c     | 4 ++++
>  3 files changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> index 31d5e1ee6089..dbd237b13b21 100644
> --- a/arch/arm64/Kconfig
> +++ b/arch/arm64/Kconfig
> @@ -277,6 +277,7 @@ config ARM64
>  	select USER_STACKTRACE_SUPPORT
>  	select VDSO_GETRANDOM
>  	select HAVE_RELIABLE_STACKTRACE
> +	select HAVE_LIVEPATCH
>  	help
>  	  ARM 64-bit (AArch64) Linux support.
>  
> @@ -2501,3 +2502,5 @@ endmenu # "CPU Power Management"
>  source "drivers/acpi/Kconfig"
>  
>  source "arch/arm64/kvm/Kconfig"
> +
> +source "kernel/livepatch/Kconfig"
> diff --git a/arch/arm64/include/asm/thread_info.h b/arch/arm64/include/asm/thread_info.h
> index 1114c1c3300a..4ac42e13032b 100644
> --- a/arch/arm64/include/asm/thread_info.h
> +++ b/arch/arm64/include/asm/thread_info.h
> @@ -64,6 +64,7 @@ void arch_setup_new_exec(void);
>  #define TIF_UPROBE		4	/* uprobe breakpoint or singlestep */
>  #define TIF_MTE_ASYNC_FAULT	5	/* MTE Asynchronous Tag Check Fault */
>  #define TIF_NOTIFY_SIGNAL	6	/* signal notifications exist */
> +#define TIF_PATCH_PENDING	7	/* pending live patching update */
>  #define TIF_SYSCALL_TRACE	8	/* syscall trace active */
>  #define TIF_SYSCALL_AUDIT	9	/* syscall auditing */
>  #define TIF_SYSCALL_TRACEPOINT	10	/* syscall tracepoint for ftrace */
> @@ -92,6 +93,7 @@ void arch_setup_new_exec(void);
>  #define _TIF_SYSCALL_TRACEPOINT	(1 << TIF_SYSCALL_TRACEPOINT)
>  #define _TIF_SECCOMP		(1 << TIF_SECCOMP)
>  #define _TIF_SYSCALL_EMU	(1 << TIF_SYSCALL_EMU)
> +#define _TIF_PATCH_PENDING	(1 << TIF_PATCH_PENDING)
>  #define _TIF_UPROBE		(1 << TIF_UPROBE)
>  #define _TIF_SINGLESTEP		(1 << TIF_SINGLESTEP)
>  #define _TIF_32BIT		(1 << TIF_32BIT)
> @@ -103,7 +105,7 @@ void arch_setup_new_exec(void);
>  #define _TIF_WORK_MASK		(_TIF_NEED_RESCHED | _TIF_SIGPENDING | \
>  				 _TIF_NOTIFY_RESUME | _TIF_FOREIGN_FPSTATE | \
>  				 _TIF_UPROBE | _TIF_MTE_ASYNC_FAULT | \
> -				 _TIF_NOTIFY_SIGNAL)
> +				 _TIF_NOTIFY_SIGNAL | _TIF_PATCH_PENDING)
>  
>  #define _TIF_SYSCALL_WORK	(_TIF_SYSCALL_TRACE | _TIF_SYSCALL_AUDIT | \
>  				 _TIF_SYSCALL_TRACEPOINT | _TIF_SECCOMP | \
> diff --git a/arch/arm64/kernel/entry-common.c b/arch/arm64/kernel/entry-common.c
> index b260ddc4d3e9..b537af333b42 100644
> --- a/arch/arm64/kernel/entry-common.c
> +++ b/arch/arm64/kernel/entry-common.c
> @@ -8,6 +8,7 @@
>  #include <linux/context_tracking.h>
>  #include <linux/kasan.h>
>  #include <linux/linkage.h>
> +#include <linux/livepatch.h>
>  #include <linux/lockdep.h>
>  #include <linux/ptrace.h>
>  #include <linux/resume_user_mode.h>
> @@ -144,6 +145,9 @@ static void do_notify_resume(struct pt_regs *regs, unsigned long thread_flags)
>  				       (void __user *)NULL, current);
>  		}
>  
> +		if (thread_flags & _TIF_PATCH_PENDING)
> +			klp_update_patch_state(current);
> +
>  		if (thread_flags & (_TIF_SIGPENDING | _TIF_NOTIFY_SIGNAL))
>  			do_signal(regs);
>  
> -- 
> 2.47.1
> 

Tested-by: Andrea della Porta <andrea.porta@suse.com>

Thanks,
Andrea

