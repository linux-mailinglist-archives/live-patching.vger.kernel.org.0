Return-Path: <live-patching+bounces-932-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F0009F5E9C
	for <lists+live-patching@lfdr.de>; Wed, 18 Dec 2024 07:30:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 984D27A24BC
	for <lists+live-patching@lfdr.de>; Wed, 18 Dec 2024 06:30:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B662E156F5E;
	Wed, 18 Dec 2024 06:30:08 +0000 (UTC)
X-Original-To: live-patching@vger.kernel.org
Received: from pegase2.c-s.fr (pegase2.c-s.fr [93.17.235.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D08E156F39;
	Wed, 18 Dec 2024 06:30:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=93.17.235.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734503408; cv=none; b=rPsP9aQFYw9bZsQwj1LKND1ZDbIjDqscTC2awlWv2UhSdvGUPpJaGR0B/WZq4SHNdU5dfX8RfaNxfw4OdiUtZJLz8XeYxWt0mR6J93CyWadGvTQERCGlGJXbqrKs/gL0xOXZLHzS8Gx3CJ/t/+C04sCXskVHFUgHaxMPtLRAc3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734503408; c=relaxed/simple;
	bh=S5bIwRiT8KbF4EN+dU9szsz5vRjDGh89/P0LHY/FYmM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sM2j1c6xIU96t8u32zEQMG7mLwPv9C8gDECkUA6ucAEdvaU5P7nP00Cepr+22nYRqwISnGOHRyIWBQ8cJpn2NacZgIWINu8Y7/hb6UQync0g70HYrKhl69ifaQ+7/NdBO0dXc8x0WpL8d0qOGZuEQTZTRaNtrX2BNXCG23U93XQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=csgroup.eu; spf=pass smtp.mailfrom=csgroup.eu; arc=none smtp.client-ip=93.17.235.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=csgroup.eu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=csgroup.eu
Received: from localhost (mailhub3.si.c-s.fr [172.26.127.67])
	by localhost (Postfix) with ESMTP id 4YCkLh3Ctlz9sPd;
	Wed, 18 Dec 2024 07:30:04 +0100 (CET)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from pegase2.c-s.fr ([172.26.127.65])
	by localhost (pegase2.c-s.fr [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id E7IDI2DzgVZM; Wed, 18 Dec 2024 07:30:04 +0100 (CET)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
	by pegase2.c-s.fr (Postfix) with ESMTP id 4YCkLh2HRlz9rvV;
	Wed, 18 Dec 2024 07:30:04 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by messagerie.si.c-s.fr (Postfix) with ESMTP id 3E0888B770;
	Wed, 18 Dec 2024 07:30:04 +0100 (CET)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
	by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
	with ESMTP id 1LBSUZsuu7uI; Wed, 18 Dec 2024 07:30:04 +0100 (CET)
Received: from [10.25.209.139] (unknown [10.25.209.139])
	by messagerie.si.c-s.fr (Postfix) with ESMTP id F1DF88B763;
	Wed, 18 Dec 2024 07:30:03 +0100 (CET)
Message-ID: <b06505de-e119-40a2-acc8-b0ac47d6c941@csgroup.eu>
Date: Wed, 18 Dec 2024 07:30:03 +0100
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 2/2] livepatch: Convert timeouts to secs_to_jiffies()
To: Easwar Hariharan <eahariha@linux.microsoft.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Sven Schnelle <svens@linux.ibm.com>, Josh Poimboeuf <jpoimboe@kernel.org>,
 Jiri Kosina <jikos@kernel.org>, Miroslav Benes <mbenes@suse.cz>,
 Petr Mladek <pmladek@suse.com>, Joe Lawrence <joe.lawrence@redhat.com>
Cc: linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
 live-patching@vger.kernel.org
References: <20241217231000.228677-1-eahariha@linux.microsoft.com>
 <20241217231000.228677-3-eahariha@linux.microsoft.com>
Content-Language: fr-FR
From: Christophe Leroy <christophe.leroy@csgroup.eu>
In-Reply-To: <20241217231000.228677-3-eahariha@linux.microsoft.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



Le 18/12/2024 à 00:09, Easwar Hariharan a écrit :
> Commit b35108a51cf7 ("jiffies: Define secs_to_jiffies()") introduced
> secs_to_jiffies(). As the value here is a multiple of 1000, use
> secs_to_jiffies() instead of msecs_to_jiffies to avoid the multiplication.
> 
> This is converted using scripts/coccinelle/misc/secs_to_jiffies.cocci with
> the following Coccinelle rules:
> 
> @@ constant C; @@
> 
> - msecs_to_jiffies(C * 1000)
> + secs_to_jiffies(C)
> 
> @@ constant C; @@
> 
> - msecs_to_jiffies(C * MSEC_PER_SEC)
> + secs_to_jiffies(C)
> 
> While here, replace the schedule_delayed_work() call with a 0 timeout
> with an immediate schedule_work() call.
> 
> Signed-off-by: Easwar Hariharan <eahariha@linux.microsoft.com>

Reviewed-by: Christophe Leroy <christophe.leroy@csgroup.eu>

> ---
>   samples/livepatch/livepatch-callbacks-busymod.c |  3 +--
>   samples/livepatch/livepatch-shadow-fix1.c       |  3 +--
>   samples/livepatch/livepatch-shadow-mod.c        | 15 +++++----------
>   3 files changed, 7 insertions(+), 14 deletions(-)
> 
> diff --git a/samples/livepatch/livepatch-callbacks-busymod.c b/samples/livepatch/livepatch-callbacks-busymod.c
> index 378e2d40271a..0220f7715fcc 100644
> --- a/samples/livepatch/livepatch-callbacks-busymod.c
> +++ b/samples/livepatch/livepatch-callbacks-busymod.c
> @@ -44,8 +44,7 @@ static void busymod_work_func(struct work_struct *work)
>   static int livepatch_callbacks_mod_init(void)
>   {
>   	pr_info("%s\n", __func__);
> -	schedule_delayed_work(&work,
> -		msecs_to_jiffies(1000 * 0));
> +	schedule_work(&work);
>   	return 0;
>   }
>   
> diff --git a/samples/livepatch/livepatch-shadow-fix1.c b/samples/livepatch/livepatch-shadow-fix1.c
> index 6701641bf12d..f3f153895d6c 100644
> --- a/samples/livepatch/livepatch-shadow-fix1.c
> +++ b/samples/livepatch/livepatch-shadow-fix1.c
> @@ -72,8 +72,7 @@ static struct dummy *livepatch_fix1_dummy_alloc(void)
>   	if (!d)
>   		return NULL;
>   
> -	d->jiffies_expire = jiffies +
> -		msecs_to_jiffies(1000 * EXPIRE_PERIOD);
> +	d->jiffies_expire = jiffies + secs_to_jiffies(EXPIRE_PERIOD);
>   
>   	/*
>   	 * Patch: save the extra memory location into a SV_LEAK shadow
> diff --git a/samples/livepatch/livepatch-shadow-mod.c b/samples/livepatch/livepatch-shadow-mod.c
> index 7e753b0d2fa6..5d83ad5a8118 100644
> --- a/samples/livepatch/livepatch-shadow-mod.c
> +++ b/samples/livepatch/livepatch-shadow-mod.c
> @@ -101,8 +101,7 @@ static __used noinline struct dummy *dummy_alloc(void)
>   	if (!d)
>   		return NULL;
>   
> -	d->jiffies_expire = jiffies +
> -		msecs_to_jiffies(1000 * EXPIRE_PERIOD);
> +	d->jiffies_expire = jiffies + secs_to_jiffies(EXPIRE_PERIOD);
>   
>   	/* Oops, forgot to save leak! */
>   	leak = kzalloc(sizeof(*leak), GFP_KERNEL);
> @@ -152,8 +151,7 @@ static void alloc_work_func(struct work_struct *work)
>   	list_add(&d->list, &dummy_list);
>   	mutex_unlock(&dummy_list_mutex);
>   
> -	schedule_delayed_work(&alloc_dwork,
> -		msecs_to_jiffies(1000 * ALLOC_PERIOD));
> +	schedule_delayed_work(&alloc_dwork, secs_to_jiffies(ALLOC_PERIOD));
>   }
>   
>   /*
> @@ -184,16 +182,13 @@ static void cleanup_work_func(struct work_struct *work)
>   	}
>   	mutex_unlock(&dummy_list_mutex);
>   
> -	schedule_delayed_work(&cleanup_dwork,
> -		msecs_to_jiffies(1000 * CLEANUP_PERIOD));
> +	schedule_delayed_work(&cleanup_dwork, secs_to_jiffies(CLEANUP_PERIOD));
>   }
>   
>   static int livepatch_shadow_mod_init(void)
>   {
> -	schedule_delayed_work(&alloc_dwork,
> -		msecs_to_jiffies(1000 * ALLOC_PERIOD));
> -	schedule_delayed_work(&cleanup_dwork,
> -		msecs_to_jiffies(1000 * CLEANUP_PERIOD));
> +	schedule_delayed_work(&alloc_dwork, secs_to_jiffies(ALLOC_PERIOD));
> +	schedule_delayed_work(&cleanup_dwork, secs_to_jiffies(CLEANUP_PERIOD));
>   
>   	return 0;
>   }


