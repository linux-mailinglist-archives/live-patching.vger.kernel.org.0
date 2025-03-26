Return-Path: <live-patching+bounces-1337-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9E20DA71415
	for <lists+live-patching@lfdr.de>; Wed, 26 Mar 2025 10:49:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8AAD73B2E36
	for <lists+live-patching@lfdr.de>; Wed, 26 Mar 2025 09:49:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0584519D07E;
	Wed, 26 Mar 2025 09:49:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Os6QRL5+"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8A7B185920
	for <live-patching@vger.kernel.org>; Wed, 26 Mar 2025 09:49:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742982555; cv=none; b=Xipww6Kn4FWh/CsOU1WIXtZec2AHr9m6ebFsjPH1dHr1VFN6079nNpH+LhHB++z8c/sPPfNBmuvUiidX/dRWyhfMckwxUkT7p+8SHETqS13zQCOsYQqDTYnNTflBdkf7lXUZnaf3TLPSJgijh2CWdyoMfX2o7/I9cbq6oVczTtQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742982555; c=relaxed/simple;
	bh=blgLyvcFFzX3lL2NYcAaYVnF+2egtRAqz36Nl4gpGqs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NTz32Jz9PaIN0qSsApvVk5PKqOHeOJbPXxrNDeQbpXpZe0XRp3PNv5qUAsHHSeZG8kBgNAwMVJar6VItQxymORRplzga2D0IGEndsqDjtx5LYij7luQfSHpqQ5XR8YbIFMpTU3xo8YbigASuBGbUNAwOS2D/AFsYuX9LQu94iwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Os6QRL5+; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-43d07ca6a80so32991235e9.1
        for <live-patching@vger.kernel.org>; Wed, 26 Mar 2025 02:49:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1742982552; x=1743587352; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=AMf8LZah20pBW0IGNKJCh7GjeqLh0QSKun39aHvg0gk=;
        b=Os6QRL5+gdIuPCGaNWS4H+v4ko4JUHImORsYKgMf/LG+q+UXaleWXEe9Er2HEnAfv/
         pUM9JRKnDQLZGOf8zpFU3M8if7gPeTy1fxOFqlfAGz/S2Dkgyh5U4Q311UFFcBtBToMK
         YquaEi0nRNJI+e3uHSFsOMgk9oGgkIxZiXeGoScbDZOF060Sat7zlx01sLL5XEDlqkGY
         Wg5d6zULGnBb/9HMWkL+RsOBlC8QSJcbeSuWCiCTSamnS1QJrOJ+IauMqXVNxLQADfM7
         6vjD51SzaPMEL+B+MqRnOgSql2gPhOo/ggD3wkB9IeoYJ368PO2A2WjwZp0g4RoaEk5p
         52ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742982552; x=1743587352;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AMf8LZah20pBW0IGNKJCh7GjeqLh0QSKun39aHvg0gk=;
        b=bnVrNFvOFISYYsZdR9YeL/hryaoRH5CrQYJTYlTVPV0lsGVR+caf8K/WlkKBR6Dr0i
         Scqk0MVh+R+igx/8JJFQjoIxQRej+zPQYBYTyEGLWkoB+ovhY0SgpuS9jN7+UG0VKeqZ
         46FtyVXxW71cNgegYW/aLqZFPsNIHrd9i9e3J+j7lPiO4BNVdO7m1dWr4uTQX/Jv3I6f
         R2IV/UULurRhD51VYqtWZUQHv88MYJ4FcU32uVJ5hQ7wZYNAv+LeU5K94XYcYbSISz8A
         v4z/6uOU02e6Kxt4+Emtzc4mYhHt3yKmYjLrNvdlHiq3UanqVZINNq0mQkZSUS1xYN3a
         WKtw==
X-Forwarded-Encrypted: i=1; AJvYcCVEcqJeFWdj6cuHPwfdZClGBk0U+vV1Whnun47Tl8dUlLfCcWdPAKz4kHxQpwPXCtPTlLTS+L60PhneVYZz@vger.kernel.org
X-Gm-Message-State: AOJu0Yxw9cPBNyeEZBFSNp9tsRSbZqwmc1Na+DXI4/Jn4MerWM4mvlsU
	7g8zWz4Y/WdtCXmY3EiULi63syVhccgLSPaXgd2gbXfZoXIDPbXmNmg9uPuEEcuTgyA73rl1m2+
	Z
X-Gm-Gg: ASbGnctTwna0WQA4egKlY4+1NaY+d3UNz/I1UILt8lKB0wLkGzO9luZkkCgJkdR0Ju/
	Wh7ShR1bhqKn+on19sT2TGplkoO0e4dQUBjQtZqkyGfnWN+rUQ6DWR5V6QBwk00RmEEi74scNPj
	O7rN3O+/QWefTozgDD7GJmmAoUuhEXNci5caopsLpz/KtnyQBO0mB1atIrMQzn4ku3TtyIS6YKO
	kDpSj/GNBC9FGQ0/3YMXMI35Jwu2DCC8Nx/2WJFXevt3UFIaMKaA2pI3bt5Sr0YORqloiajSYUV
	/NgYi/CP6Ah7ZDo3j7y0viw23SQiGuNHQzzcQ7kMLVCIOnAjlrenK/AvSw==
X-Google-Smtp-Source: AGHT+IGRViDMKK6wKXb6OhyBa/rHykXthCXSj7KFfLD1Z+8vJvxSt4VQhKgttI4B1gO+tM6LXwgGbw==
X-Received: by 2002:a05:600c:1d81:b0:43d:10a:1b90 with SMTP id 5b1f17b1804b1-43d509f8691mr195871375e9.16.1742982552228;
        Wed, 26 Mar 2025 02:49:12 -0700 (PDT)
Received: from pathway.suse.cz ([176.114.240.130])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43d4fd27b59sm176543075e9.23.2025.03.26.02.49.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Mar 2025 02:49:11 -0700 (PDT)
Date: Wed, 26 Mar 2025 10:49:10 +0100
From: Petr Mladek <pmladek@suse.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>, mingo@kernel.com,
	juri.lelli@redhat.com, vincent.guittot@linaro.org,
	dietmar.eggemann@arm.com, rostedt@goodmis.org, bsegall@google.com,
	mgorman@suse.de, vschneid@redhat.com, jpoimboe@kernel.org,
	jikos@kernel.org, mbenes@suse.cz, joe.lawrence@redhat.com,
	linux-kernel@vger.kernel.org, live-patching@vger.kernel.org,
	Thomas Gleixner <tglx@linutronix.de>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: Re: [RFC][PATCH] sched,livepatch: Untangle cond_resched() and
 live-patching
Message-ID: <Z-PNll7fJQzCDH35@pathway.suse.cz>
References: <20250324134909.GA14718@noisy.programming.kicks-ass.net>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250324134909.GA14718@noisy.programming.kicks-ass.net>

On Mon 2025-03-24 14:49:09, Peter Zijlstra wrote:
> 
> With the goal of deprecating / removing VOLUNTARY preempt, live-patch
> needs to stop relying on cond_resched() to make forward progress.
> 
> Instead, rely on schedule() with TASK_FREEZABLE set. Just like
> live-patching, the freezer needs to be able to stop tasks in a safe /
> known state.

> Compile tested only.
> 
> Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> ---
>  include/linux/livepatch_sched.h | 15 +++++--------
>  include/linux/sched.h           |  6 -----
>  kernel/livepatch/transition.c   | 30 ++++++-------------------
>  kernel/sched/core.c             | 50 +++++++----------------------------------
>  4 files changed, 21 insertions(+), 80 deletions(-)
> 
> diff --git a/include/linux/livepatch_sched.h b/include/linux/livepatch_sched.h
> index 013794fb5da0..7e8171226dd7 100644
> --- a/include/linux/livepatch_sched.h
> +++ b/include/linux/livepatch_sched.h
> @@ -3,27 +3,24 @@
>  #define _LINUX_LIVEPATCH_SCHED_H_
>  
>  #include <linux/jump_label.h>
> -#include <linux/static_call_types.h>
> +#include <linux/sched.h>
> +
>  
>  #ifdef CONFIG_LIVEPATCH
>  
>  void __klp_sched_try_switch(void);
>  
> -#if !defined(CONFIG_PREEMPT_DYNAMIC) || !defined(CONFIG_HAVE_PREEMPT_DYNAMIC_CALL)
> -
>  DECLARE_STATIC_KEY_FALSE(klp_sched_try_switch_key);
>  
> -static __always_inline void klp_sched_try_switch(void)
> +static __always_inline void klp_sched_try_switch(struct task_struct *curr)
>  {
> -	if (static_branch_unlikely(&klp_sched_try_switch_key))
> +	if (static_branch_unlikely(&klp_sched_try_switch_key) &&
> +	    READ_ONCE(curr->__state) & TASK_FREEZABLE)
>  		__klp_sched_try_switch();
>  }

Do we really need to check the TASK_FREEZABLE state, please?

My understanding is that TASK_FREEZABLE is set when kernel kthreads go into
a "freezable" sleep, e.g. wait_event_freezable().

But __klp_sched_try_switch() should be safe when the task is not
running and the stack is reliable. IMHO, it should be safe anytime
it is being scheduled out.

Note that wait_event_freezable() is a good location. It is usually called in
the main loop of the kthread where the stack is small. So that the chance
that it is not running a livepatched function is higher than on
another random schedulable location.

But we actually wanted to have it in cond_resched() because
it might take a long time to reach the main loop, and sleep there.

Best Regards,
Petr

