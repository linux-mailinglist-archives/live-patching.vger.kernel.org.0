Return-Path: <live-patching+bounces-933-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0C0439F6048
	for <lists+live-patching@lfdr.de>; Wed, 18 Dec 2024 09:39:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A50A91883D09
	for <lists+live-patching@lfdr.de>; Wed, 18 Dec 2024 08:39:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C0DE1922F6;
	Wed, 18 Dec 2024 08:38:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="E48j7aHT"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60C8914F9E2
	for <live-patching@vger.kernel.org>; Wed, 18 Dec 2024 08:38:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734511124; cv=none; b=aP0aQ9q5PMWnjthYrT1rjbFtcD+dVdulJpU3gIv3S9gqECYemQte9RMqAndH6B23KTHBMpJWt5oWQRG1PA+K5+YnT1UCIW4IyLaUKQqDL4/rBWWOeOz+6pCJsAbVgRUqXl1GpZ/et4XVYcaNRHF3sujLwX7XhWWfsNe5Qg1Tnrw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734511124; c=relaxed/simple;
	bh=lb++ULU1zjE304M7qhX++kz/MOQu3wU7e5YPxeu2jms=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SEyq6NI2/5b6edIV/uLWXG1oqcya+W8TL56USkeXbLjH7oP4GuNHmL0gyvQp0XERT6czqC3GZHM646WSGKWqmgEWHdqevNpCf7D4sxm/ZUZrcA+FsdexajVhtcZH8XI59ny60QE3flZyelneIhXnsDhfBpMb/ab21KNd2OqtcG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=E48j7aHT; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-385e3621518so3167103f8f.1
        for <live-patching@vger.kernel.org>; Wed, 18 Dec 2024 00:38:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1734511120; x=1735115920; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=wBpSCttl5XApEhToqmcNJtkyprOjG86smKXLL3EJFZQ=;
        b=E48j7aHThwim8LV3dAAiEHx70YfVACNcGhxVXoLkLclQ15SvTgQ7GcPF2dZEzNGsJC
         S1XD6+eCuXZiG/+k6pJAUgcZo+kgvUIo/HsAf3/q0kKIqe59tgtms54SIoiX69d+3HCC
         /dBNAy5Lo9qn55Uc7ZDCXuphyaysUDuJQwbNnvcGqIAWyTsqycpq9yunkoLUz03z8v9o
         1qj/shM8NmzJuDHdIw4DxbTdV5p1BX8rzh2Z6GEXMwTMaPt6+Kdm/Z/qpCVeUzeEN1hT
         qtVL0G/5AnXL9mRO+UIwciT3vRX7AqHUsrs3Y7MUA0ZfXAQnCvQ+vmZtCIL/vTaWeH4K
         flrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734511120; x=1735115920;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wBpSCttl5XApEhToqmcNJtkyprOjG86smKXLL3EJFZQ=;
        b=LFH1raaJ2PsZshyfdprw5mQ7bkZ8ghK7so0AW/L9Cxh77q4wIQ4SszjLJR1WRlxTMr
         S+0bKU+Z3opG1klSFbEWNSeSgma6DGTmIrkEJB3o5KHZHOGhSz4tu24JidHq60ISIA5L
         aI1jvQN0JWDHDf/huSzShYntxnyHXwB0R74NBJOmPRJzxE8Tx3uefwuvgShxL0/a3YEO
         GV03k8qCXNg0fodyZMTNIneVmGMUH1gGqXgHVm0RG9VPoYhFG7v4Vqqk9BDRYHAE5d19
         u69+hVxaajGLrxnq4KhOgoMxhNmyjFFezUtqxNMbokmyXKAReAFmVPGwn8CqhLSZv8pP
         7iBA==
X-Forwarded-Encrypted: i=1; AJvYcCWH901CfkmTZ4TcPMT7vK529cscDleIzjCnc2bFyNA1bU8pkEsPx4MCPAsqpOyzWExZsLUpOyDJKDszGC33@vger.kernel.org
X-Gm-Message-State: AOJu0Yxgq/cSSrFdRwF9sa2gRKsV3aNFP6k1bxMfD6ZhkdA15tC1zl/t
	riHd/MijTzHI5Fb9qQkbLTub0FWCSIBVlcTHytzyNjJHCxxaT5BmQpMr6ZNVgVw=
X-Gm-Gg: ASbGncsGu+pC8ZX7LDLJwHfkMhJtkoK2kiucuvjOmt4198dcplX+kDhdRjqcwMumyda
	plCgzhgT4pK9kai9WnT8pXrKju9h/sJTqa++9b1UKNyAASbq9lF7EbzHGCRZNDKzgItr1krXmzA
	KFR2DZl6ZMdjNEHqtS0n66Y3zeeOD+ZHdIxdpAl5YzzpDA2smSPLOgxAgZ/oU0JBhcHFb1hO6wJ
	YM4fA1LBgfxbVdW9IwFlsgDvOQ+PmjWPPTE1+qGtIgzCNcxNAk5n+ixFg==
X-Google-Smtp-Source: AGHT+IGZv957tf/6E1pmHKo8Ey++8iK3eKYAGbXan6MBdowdNu2QZBd/QHI2gsPVS8G3/KjoNN3pDA==
X-Received: by 2002:a05:6000:1fa7:b0:385:f6c7:90c6 with SMTP id ffacd0b85a97d-388e4d657acmr1551661f8f.20.1734511119950;
        Wed, 18 Dec 2024 00:38:39 -0800 (PST)
Received: from pathway.suse.cz ([176.114.240.50])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-388c801617bsm13304844f8f.39.2024.12.18.00.38.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Dec 2024 00:38:39 -0800 (PST)
Date: Wed, 18 Dec 2024 09:38:36 +0100
From: Petr Mladek <pmladek@suse.com>
To: Easwar Hariharan <eahariha@linux.microsoft.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Jiri Kosina <jikos@kernel.org>, Miroslav Benes <mbenes@suse.cz>,
	Joe Lawrence <joe.lawrence@redhat.com>, linux-s390@vger.kernel.org,
	linux-kernel@vger.kernel.org, live-patching@vger.kernel.org
Subject: Re: [PATCH v4 2/2] livepatch: Convert timeouts to secs_to_jiffies()
Message-ID: <Z2KJ8C7nOOK2tJ1X@pathway.suse.cz>
References: <20241217231000.228677-1-eahariha@linux.microsoft.com>
 <20241217231000.228677-3-eahariha@linux.microsoft.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241217231000.228677-3-eahariha@linux.microsoft.com>

On Tue 2024-12-17 23:09:59, Easwar Hariharan wrote:
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
> --- a/samples/livepatch/livepatch-callbacks-busymod.c
> +++ b/samples/livepatch/livepatch-callbacks-busymod.c
> @@ -44,8 +44,7 @@ static void busymod_work_func(struct work_struct *work)
>  static int livepatch_callbacks_mod_init(void)
>  {
>  	pr_info("%s\n", __func__);
> -	schedule_delayed_work(&work,
> -		msecs_to_jiffies(1000 * 0));
> +	schedule_work(&work);

Is it safe to use schedule_work() for struct delayed_work?

It might work in theory but I do not feel comfortable with it.
Also I would expect a compiler warning.

If you really want to use schedule_work() then please
also define the structure with DECLARE_WORK()
and use cancel_work_sync() in livepatch_callbacks_mod_exit().

Best Regards,
Petr

