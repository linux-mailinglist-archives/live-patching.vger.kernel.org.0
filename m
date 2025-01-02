Return-Path: <live-patching+bounces-948-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4A29A9FFAFC
	for <lists+live-patching@lfdr.de>; Thu,  2 Jan 2025 16:27:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3C8973A05B5
	for <lists+live-patching@lfdr.de>; Thu,  2 Jan 2025 15:27:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B07F1B4122;
	Thu,  2 Jan 2025 15:27:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Nvsjs2o/"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AB581B3948
	for <live-patching@vger.kernel.org>; Thu,  2 Jan 2025 15:27:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735831664; cv=none; b=CJnBjRmq1/QXswTGoHTOS1/PkMjh2clQkYEYwzrnOVLAALXGizQSgX0po6xOCAKlNLMHR0Ke+BU+wN5i10I8Y33mgmmbnyb4/gpj0joCvdPIvVwb+0lKNkwm365djgahSDd246yHqZOWMpSC3WVTVl5LbsaOzv6mWzvEthwOxss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735831664; c=relaxed/simple;
	bh=n+Gj8NdzfT6j/tuL1ZIoARiw552+ZjcUH8ctsmzGD2Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LBEFxFJXdNaOWuxzA/dY7zL0i5fvGxZD3XrpkAEPynrs+94w4rc8oQxKiSaaRij6Dj/8pYitKIarzNJpp4iPWxBFGL5FHoG5NoOXl45q6SG+8aLOvCjT3xy0YMnW9K+pPLbs2fZzj2U4QS03pHbFWgfWfeZyTOAqvqg4tZC/NVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Nvsjs2o/; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4362f61757fso114337745e9.2
        for <live-patching@vger.kernel.org>; Thu, 02 Jan 2025 07:27:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1735831661; x=1736436461; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=05upqEVJPolnyr/HoSHZRKWoniI8eKda58PhaQdla5Y=;
        b=Nvsjs2o/GLN5+oGmb64SN7c3a5HDtS8oU2w1l2X0BGXj+J7C67dJSQeEP2J0eIi/va
         DPg9FkqXtNEbpjGKZskeuYeeGl+h2odl4et+tnPWVHJzezneb5V7nOrBGRXVWBINHvaP
         GWtYwQid70k4s2Vk3cUPMb8/kaPBvlAH6LqkV4Re4qcyC2FBFzCqezPqRBvrtp3tq9m5
         IFYellCDkg5ySJLoVZCZvfumtgdhhRH0UQzNwtX8zUZm1CHonSWY3K4taNJgWOLelLrz
         oNssUzAAsUVxpXHbHWG/yOxj+A3bT4zR1vfrhYrRRAQiu+IbqTvkQRH6HJxMgpVGCfJv
         b/WA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735831661; x=1736436461;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=05upqEVJPolnyr/HoSHZRKWoniI8eKda58PhaQdla5Y=;
        b=Vn3B22xSzKINr1LIpfpAoJFNGNGBsWs+stkOx16eQuABbrB3jKbqcTV6+tk1IFuQf4
         PObLovq4waBamg3+leI9JZXb4z20NCIsgiUKYMUzp3F/2UumB9fKn82aEDNNuIP9IO4I
         Bv4WBLQIGhReeppREf14SpGl7sP3XbtUgHplcXfRXWj4TDv/kaDroRrRjFjAHThPGSr8
         1j7gZJ6Dxg3ZLS1xN4lRJQBmJEOLs53YC2Xxo8kaWyU2AoD2OfGXZszTuGk3r8WUcO8o
         o7B92RARQv0W0IiEBvrB8IQwPhcRc6nOCUNEf+k0mUFAGhQ+dLmHAD0G17JWnK7E99/8
         g7dQ==
X-Forwarded-Encrypted: i=1; AJvYcCXeq87W69gN7WheNObbYM872LX1ULlMb8Z/CH0h9s72f5gqXyMcjyO5XoFaTwWcIEQUnY/xeX3koK7GvXid@vger.kernel.org
X-Gm-Message-State: AOJu0Yz3rngMcWHvoorWz1D2Rvpse7/bFtkiNCrgkSc9VXJvSDYabgnX
	juLSFAGYTgBwUzKXYwq8Udj3SAsRoIcmhbu+afaUx8i9Ko+gdHJeMeoKTI/tYPMdXtuR2ocGaWD
	4
X-Gm-Gg: ASbGncsg52WZUpjtYybFO6Nv6JBh3n9lmCvRq84L9UlTbEaaIv1Az5asyF7CzZv2Xwx
	UTTBZsEZOippd4EiCvOW+bl1zmyzZZmChCOe43DeBHoC2lHENgBsTCjs3uR/WrdOrvEX4R6wLAB
	AQZ3S9HCheKfkD6J8H1LxlIcza7Tvm2/chKqTiK3b35onM5OmSjo5O6WaUOj6VvS9igvbKKDa2e
	fe0X2WyxXN8bWYDCxt/05LWleFCFG++SGodSXhsrdgxE2plynwg1Ru+Fg==
X-Google-Smtp-Source: AGHT+IFcM1oKMh1kjxBO7ycMH/tQaCFmKpK0dg2zqRMgKTMW78Q/ZGzddqirXlD2dJ4tXVJnV9Cs1Q==
X-Received: by 2002:a05:600c:35d2:b0:435:d22:9c9e with SMTP id 5b1f17b1804b1-43668646335mr389612275e9.19.1735831660707;
        Thu, 02 Jan 2025 07:27:40 -0800 (PST)
Received: from pathway.suse.cz ([176.114.240.50])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43661218f43sm458314275e9.19.2025.01.02.07.27.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jan 2025 07:27:39 -0800 (PST)
Date: Thu, 2 Jan 2025 16:27:36 +0100
From: Petr Mladek <pmladek@suse.com>
To: Easwar Hariharan <eahariha@linux.microsoft.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>,
	Andrew Morton <akpm@linux-foundation.org>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
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
Message-ID: <Z3awaFzhgvY3bypu@pathway.suse.cz>
References: <20241217231000.228677-1-eahariha@linux.microsoft.com>
 <20241217231000.228677-3-eahariha@linux.microsoft.com>
 <Z2KJ8C7nOOK2tJ1X@pathway.suse.cz>
 <f54d34f8-05cd-4081-92a2-85df3f76a35b@csgroup.eu>
 <195abda2-8209-45aa-9652-f981a5de2eae@linux.microsoft.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <195abda2-8209-45aa-9652-f981a5de2eae@linux.microsoft.com>

On Wed 2024-12-18 09:35:46, Easwar Hariharan wrote:
> On 12/18/2024 12:48 AM, Christophe Leroy wrote:
> > 
> > 
> > Le 18/12/2024 à 09:38, Petr Mladek a écrit :
> >> On Tue 2024-12-17 23:09:59, Easwar Hariharan wrote:
> >>> Commit b35108a51cf7 ("jiffies: Define secs_to_jiffies()") introduced
> >>> secs_to_jiffies(). As the value here is a multiple of 1000, use
> >>> secs_to_jiffies() instead of msecs_to_jiffies to avoid the
> >>> multiplication.
> >>>
> >>> This is converted using scripts/coccinelle/misc/secs_to_jiffies.cocci
> >>> with
> >>> the following Coccinelle rules:
> >>>
> >>> @@ constant C; @@
> >>>
> >>> - msecs_to_jiffies(C * 1000)
> >>> + secs_to_jiffies(C)
> >>>
> >>> @@ constant C; @@
> >>>
> >>> - msecs_to_jiffies(C * MSEC_PER_SEC)
> >>> + secs_to_jiffies(C)
> >>>
> >>> While here, replace the schedule_delayed_work() call with a 0 timeout
> >>> with an immediate schedule_work() call.
> >>>
> >>> --- a/samples/livepatch/livepatch-callbacks-busymod.c
> >>> +++ b/samples/livepatch/livepatch-callbacks-busymod.c
> >>> @@ -44,8 +44,7 @@ static void busymod_work_func(struct work_struct
> >>> *work)
> >>>   static int livepatch_callbacks_mod_init(void)
> >>>   {
> >>>       pr_info("%s\n", __func__);
> >>> -    schedule_delayed_work(&work,
> >>> -        msecs_to_jiffies(1000 * 0));
> >>> +    schedule_work(&work);
> >>
> >> Is it safe to use schedule_work() for struct delayed_work?
> > 
> > Should be, but you are right it should then be a standard work not a
> > delayed work.
> > 
> > So probably the easiest is to keep
> > 
> >     schedule_delayed_work(&work, 0)
> > 
> > And eventually changing it to a not delayed work could be a follow-up
> > patch.
> > 
> >>
> 
> Thanks for the catch, Petr! This suggestion would effectively revert
> this patch to the v3 version, albeit with some extra explanation in the
> commit message. I'd propose just keeping the v3 in the next branch where
> it is.
> 
> Andrew, Petr, Christophe, what do you think?

I am fine with keeping v3 in next.

Best Regards,
Petr

