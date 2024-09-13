Return-Path: <live-patching+bounces-654-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 60076977C87
	for <lists+live-patching@lfdr.de>; Fri, 13 Sep 2024 11:46:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9D5FEB28CD2
	for <lists+live-patching@lfdr.de>; Fri, 13 Sep 2024 09:46:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E9FD1D79B6;
	Fri, 13 Sep 2024 09:46:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GjQ6m1Mc"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09E241D6DC7;
	Fri, 13 Sep 2024 09:46:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726220795; cv=none; b=BtKZKaFronwiMivUUtDtyONQF3UNlsNgvsfl3zCNxktgd5OlEPaJgIgCFlbFDIw9pXUH2LJKYsKL8HDsYprtkxkdbCf9NzhVqAlXLjYt7p5DGJEdUNy0QtmlRIKrVgtluPqv20vtal0+2wCW0Lxl1nvLjEGK8id5F4qZdpOY7/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726220795; c=relaxed/simple;
	bh=SpTLhMO6j66o3+xScd23c48WvV16dlRuSCXpDT5Y07U=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=d7G+0n6fLG6Y/HVXvN0Lx78s+bltKLeLwm9U4F0XjBAMy6YvfJ/rNTSibR+mk4nKb6hNkkqWgn87RCzSad5Mm292jIu4c1YIutZJVujavZ8qgHYlt+PRFF/vtyCqDo0pfjCUVuxowfKfeS9FfiVMkcpmGEroFCKJsBOIDIAP+GU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GjQ6m1Mc; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-718e11e4186so1799795b3a.2;
        Fri, 13 Sep 2024 02:46:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1726220793; x=1726825593; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rqaauTMIDTPV21BRKhA/3QJ3YyV89QISvl8QB3WPX8I=;
        b=GjQ6m1McNsk+futJrrfgz1fIeacFpAQWRYBRPt2vMp8BlZtpdUnk8B+K64F6D2nQuS
         khV/azEvMN+jUCKJfVcZI7hOAg3xLkYwaYo4N8RCgTr3m30NYjXSXLoSOvzXkgfN34kk
         3evKfRqFVBIV5pBvkiYqC9dMIpST62TlQldTt1EZ8DridStMjGHLsbXTEpUtUV5BQuuO
         c8p8llA7wbQWA0yrPfe3tyhV9fI/qF68cZFzQbAGUXR+5bcwddTV9FBwaY7JQW6nXP76
         5Y3oQfZTXzikiW64w/RJMeThALPf+yna/bx1s/pF2zBT5BlmmUwnpUP8GtZ6JzWB9SGi
         r1dQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726220793; x=1726825593;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rqaauTMIDTPV21BRKhA/3QJ3YyV89QISvl8QB3WPX8I=;
        b=IfyiQTbpkXPLz6J6v2usgaAOkKXtw9JgVl4wHqEvTdUWL/zjThxHvSI8w+PlM4m0Ys
         +iaNzWK0uTvEaIMHZKZ7c36aPSupHwxthjTD1qLTp4KHCvdbZwqxjRRiXClynm+4dGYe
         NYjcS0p6wvanG70Fpxsg5wZtLJ/Yh9AGtdg3Ig2tRYjlsEJgswSeIC7nwDnVle2Ovffz
         mz4QXKycGkLfU0oguCqVfERXauOcrw694wDigd/2R2BdDAtuz8yDRqlu7WZIyd6xMLYy
         oR6JAzd0F6tdoM7Q+xABF3akrmPiBnEKCmlwVMeJOd7VkykuyxyakaiHLU0LHmCHJVVE
         DFmg==
X-Forwarded-Encrypted: i=1; AJvYcCUTynS38tHIEmNX2mVFCBgT7RrSeaKWK21wlMLd5BDUh43Q028qEtezoT/MJukmDgq9amIjerat7N4JYyrOdA==@vger.kernel.org, AJvYcCXvO7BSJayDUSVJx5OfBEDJwCFmsEXTHxumSP1S8Efk8DDBDh8CAxN0OJMeoGM3I7xjs4Q2cG/hPWHRfGs=@vger.kernel.org
X-Gm-Message-State: AOJu0YxoXJ0fB2Dp5RIWW3IlD8lbmSmgCNMf2l6jEY+ayfLRU/U44luX
	i9DI/9dcynIOWeA1GP25x0OvYi48wZ/ubWYWQjOjN577s1CaKwr2
X-Google-Smtp-Source: AGHT+IHVrjhssAxhMsKFcD0w/CFvel+1Dv2vXOfUI8/qlpXWzJ9rHhly19NHjbOGeNbKG/OV4fbwkw==
X-Received: by 2002:a05:6a00:92a6:b0:714:25ee:df58 with SMTP id d2e1a72fcca58-719261e772amr9062368b3a.18.1726220793112;
        Fri, 13 Sep 2024 02:46:33 -0700 (PDT)
Received: from smtpclient.apple ([205.204.117.121])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-719090b281fsm5961160b3a.171.2024.09.13.02.46.30
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 13 Sep 2024 02:46:32 -0700 (PDT)
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
In-Reply-To: <7F83CD32-3965-4F15-B4FA-44503EF6EA9D@gmail.com>
Date: Fri, 13 Sep 2024 17:46:18 +0800
Cc: Josh Poimboeuf <jpoimboe@kernel.org>,
 Jiri Kosina <jikos@kernel.org>,
 Petr Mladek <pmladek@suse.com>,
 Joe Lawrence <joe.lawrence@redhat.com>,
 live-patching@vger.kernel.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <D2C635CE-4530-492C-B9CF-CFF78FE116A1@gmail.com>
References: <20240828022350.71456-1-zhangwarden@gmail.com>
 <20240828022350.71456-2-zhangwarden@gmail.com>
 <alpine.LSU.2.21.2409051139540.8559@pobox.suse.cz>
 <EF43117B-DF46-4001-A5D4-49304EFF21AD@gmail.com>
 <alpine.LSU.2.21.2409060857130.1385@pobox.suse.cz>
 <7F83CD32-3965-4F15-B4FA-44503EF6EA9D@gmail.com>
To: Miroslav Benes <mbenes@suse.cz>
X-Mailer: Apple Mail (2.3774.500.171.1.1)

Hi, Miroslav & Petr

> On Sep 6, 2024, at 17:44, zhang warden <zhangwarden@gmail.com> wrote:
>=20
>>=20
>>>>=20
>>>>> +       struct list_head func_stack;
>>>>> +       struct ftrace_ops fops;
>>>>> +};
>>>>> +
>>>>>=20
>>>>> diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
>>>>> index 52426665eecc..e4572bf34316 100644
>>>>> --- a/kernel/livepatch/core.c
>>>>> +++ b/kernel/livepatch/core.c
>>>>> @@ -760,6 +760,8 @@ static int klp_init_func(struct klp_object =
*obj, struct klp_func *func)
>>>>> if (!func->old_name)
>>>>> return -EINVAL;
>>>>>=20
>>>>> + func->ops =3D NULL;
>>>>> +
>>>>=20
>>>> Any reason why it is not added a couple of lines later alongside =
the rest=20
>>>> of the initialization?
>>>=20
>>> Do you mean I should add couple of lines after 'return -EINVAL' ?
>>=20
>> No, I am asking if there is a reason why you added 'func->ops =3D =
NULL;'=20
>> here and not right after the rest of func initializations
>>=20
>>       INIT_LIST_HEAD(&func->stack_node);
>>       func->patched =3D false;
>>       func->transition =3D false;
>>=20
>=20

I think I found a bug in my patch.

I move struct klp_ops to klp_func. But every time, klp_func
will init klp_func->ops to NULL. Which will make the test branch
 `if(! ops)` always true in function klp_patch_func.

An alternative solution should be something like
 (as Peter suggested before)=20

=
https://lore.kernel.org/live-patching/20240805064656.40017-1-zhangyongde.z=
yd@alibaba-inc.com/T/#t


 static struct klp_ops *klp_find_ops(void *old_func)
 {
       struct klp_patch *patch;
       struct klp_object *obj;
       struct klp_func *func;
       struct klp_ops *ops;
=20
        klp_for_each_patch(patch)
                klp_for_each_object(patch, obj)
                        klp_for_each_func(obj, func)
                               if(func->old_func =3D=3D old_func)
                                        return func->ops;
        return NULL;
 }

and  klp_ops should be initialize in klp_init_func:

        func->patched =3D false;
        func->transition =3D false;
+       func->ops =3D klp_find_ops(func->old_func);

Here, func->ops should not init as NULL, it should be initialize with=20
the existed ops (if klp_find_ops returns NULL, this patch is the first
time to be patched).

Regards.
Wardenjohn.


