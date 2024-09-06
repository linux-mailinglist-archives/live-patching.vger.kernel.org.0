Return-Path: <live-patching+bounces-618-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BE84B96EFFC
	for <lists+live-patching@lfdr.de>; Fri,  6 Sep 2024 11:45:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7E634282929
	for <lists+live-patching@lfdr.de>; Fri,  6 Sep 2024 09:45:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B4B241C9DC2;
	Fri,  6 Sep 2024 09:44:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iQAie+tA"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-oa1-f54.google.com (mail-oa1-f54.google.com [209.85.160.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D5DF1C8FA1;
	Fri,  6 Sep 2024 09:44:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725615875; cv=none; b=WKNo0JVmriBzN6bRrSk+CQy49Pv7XVF6czf7BiNvK7IpzQh/o7+5gObWcH31V/X6lR961ky2bSitoHqpCkPLECNL38xmxoUSDlF5Syos0VgbSYC08ER0QGlwuUyeV1BwjbQaL9m953BuW28lhjL33J+PTT3j0QeP9RMnRzEvjcw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725615875; c=relaxed/simple;
	bh=jMxXxMRP05BxNfr0rgYsI9fsUas4cRrtArUMzOwVjWs=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=hibrfHsqg8x2qI6TcfYCulp3pVnipun86hpl1xCjRnngZLVVn0nXFLVtynbm+7T3BQRHQId6UvKFCu0ptD5pMa/z9daE2nODRSj5jTK7tA0rCVtt6q1/FpzwyU/uXE8/z61hD63VeWiY1eWx2EnEYHoEZqosvtXChSdHkmt+WTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iQAie+tA; arc=none smtp.client-ip=209.85.160.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oa1-f54.google.com with SMTP id 586e51a60fabf-277e6002b7dso1030231fac.1;
        Fri, 06 Sep 2024 02:44:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1725615873; x=1726220673; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=A5Fr6Ylhqat7EiJp6HArSc39dt7M4u0mIFR+JQKvwXQ=;
        b=iQAie+tA7NT6QyscG0m5BGyVN0eiM0SREwm8uxxtTzsa3ajhdffr3XHx0VsUY+lqxB
         ZKHwxUJA/ZA2beVuFFiB8iRxkwg8RAs6PczVskU7vA1TRx63TjrlOd/u1M0orYye640A
         caSrl1j+M87DiacK2OE4jMUo7myFIl0R9wL2VLG0ivFdq7m7bW5oXS679oXucGyav+Bs
         QeuzRtOI5jRS5Yt5/ee3QtLddxLtqVvaVW+EPaWD4LK8GEemrioJ51yel1P5WoxLemsI
         6DkBV5nkHrGm9NZOqdIKHoYURK9ISS4lZLW2e9LCoiqBl6czy4eBp6NlVJE4B9v7qFtN
         uAiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725615873; x=1726220673;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=A5Fr6Ylhqat7EiJp6HArSc39dt7M4u0mIFR+JQKvwXQ=;
        b=aDlGTxn47wEgMj0ya1E/x8OUtthdCx8Jue1Dda8UmnlXUd4dIWAVg5uUxuch+nc9ZZ
         VrSO9lS8g2o/ElZmngadXBiFB3mr2ymkgkYyLinMOcuaCRqqA0Ay0vpDFpLE9vM3imgX
         fwEvYTwESodP5An8yyVTSU/KFDX+ZPF26Ra7nRtEFrrPX/jAxwW1j2PNw/q8m+z8vhtk
         tMgd9Xe97Frdxru0nIyR10hCpKXV0IbzvJ4ByBhMF547FqCCdkcgRybyo7N8YIC3RNze
         uZL04T0MXhT2BvsILvtLZgVPvFl5w7X16vZyQ/54MFP+NPNjthx1AE+pN/bb40u98KD6
         KmWA==
X-Forwarded-Encrypted: i=1; AJvYcCUKthog1QbvBvnV7Mei5Quylq3zvJN/wCOEp6WDTl5uY5FYTSDeN1J2YF6wdnQEpGfZqrenY2ArA+vGR3is9A==@vger.kernel.org, AJvYcCXWJ2EwNlQIcS7f4MEUqoTsaRkLBp0z0o8DZItcgrFHfYU2rh6CZIMGb5JII6fiKgqlU1iEvJKQv9iy1Aw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxd4g0+YD8I6yJDtFMrZ9iklplwzxGAO08SKRBvycFHzmakKVPS
	nJBTq5HX0uDcH9mHanvCm5/U7GzHLVzCgFhyPt1buecZDuNo3+wN
X-Google-Smtp-Source: AGHT+IHWNhysmerhtGgrQ7Po0968uCcoK9g7XJOix4JHWyVqJlQmV7+TlwN7RNnTpd8wKuaoMCJKcA==
X-Received: by 2002:a05:6870:610b:b0:260:fd20:a880 with SMTP id 586e51a60fabf-27b82ffa8c5mr2237525fac.42.1725615873119;
        Fri, 06 Sep 2024 02:44:33 -0700 (PDT)
Received: from smtpclient.apple ([47.254.32.37])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-718dd273e3fsm312148b3a.190.2024.09.06.02.44.30
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 06 Sep 2024 02:44:32 -0700 (PDT)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3774.500.171.1.1\))
Subject: Re: [PATCH v4 1/2] Introduce klp_ops into klp_func structure
From: zhang warden <zhangwarden@gmail.com>
In-Reply-To: <alpine.LSU.2.21.2409060857130.1385@pobox.suse.cz>
Date: Fri, 6 Sep 2024 17:44:26 +0800
Cc: Josh Poimboeuf <jpoimboe@kernel.org>,
 Jiri Kosina <jikos@kernel.org>,
 Petr Mladek <pmladek@suse.com>,
 Joe Lawrence <joe.lawrence@redhat.com>,
 live-patching@vger.kernel.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <7F83CD32-3965-4F15-B4FA-44503EF6EA9D@gmail.com>
References: <20240828022350.71456-1-zhangwarden@gmail.com>
 <20240828022350.71456-2-zhangwarden@gmail.com>
 <alpine.LSU.2.21.2409051139540.8559@pobox.suse.cz>
 <EF43117B-DF46-4001-A5D4-49304EFF21AD@gmail.com>
 <alpine.LSU.2.21.2409060857130.1385@pobox.suse.cz>
To: Miroslav Benes <mbenes@suse.cz>
X-Mailer: Apple Mail (2.3774.500.171.1.1)

Hi Miroslav

>=20
> node member. You removed the global list, hence this member is not =
needed=20
> anymore.

OK, I got it.

>=20
>>>=20
>>>> +       struct list_head func_stack;
>>>> +       struct ftrace_ops fops;
>>>> +};
>>>> +
>>>>=20
>>>> diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
>>>> index 52426665eecc..e4572bf34316 100644
>>>> --- a/kernel/livepatch/core.c
>>>> +++ b/kernel/livepatch/core.c
>>>> @@ -760,6 +760,8 @@ static int klp_init_func(struct klp_object =
*obj, struct klp_func *func)
>>>> if (!func->old_name)
>>>> return -EINVAL;
>>>>=20
>>>> + func->ops =3D NULL;
>>>> +
>>>=20
>>> Any reason why it is not added a couple of lines later alongside the =
rest=20
>>> of the initialization?
>>=20
>> Do you mean I should add couple of lines after 'return -EINVAL' ?
>=20
> No, I am asking if there is a reason why you added 'func->ops =3D =
NULL;'=20
> here and not right after the rest of func initializations
>=20
>        INIT_LIST_HEAD(&func->stack_node);
>        func->patched =3D false;
>        func->transition =3D false;
>=20

Hah... it just my habit to do so. Will fix it later.

>>=20
>> Maybe there still other places will call this klp_find_ops? Is it =
safe to delete it?
>=20
> If you have no other plans with it, then it can be removed since there =
is=20
> no user after the patch.
>=20

> Wardenjohn, you should then get all the information that you need. =
Also,=20
> please test your patches with livepatch kselftests before a submission=20=

> next time. New sysfs attributes need to be documented in=20
> Documentation/ABI/testing/sysfs-kernel-livepatch and there should be a =
new=20
> kselftest for them.

OK, will do it.

Regards.
Wardenjohn.


