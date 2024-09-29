Return-Path: <live-patching+bounces-693-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D72D989284
	for <lists+live-patching@lfdr.de>; Sun, 29 Sep 2024 03:51:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8157F2845F4
	for <lists+live-patching@lfdr.de>; Sun, 29 Sep 2024 01:51:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C85CBB660;
	Sun, 29 Sep 2024 01:51:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Gn9j4J51"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40DF128EF;
	Sun, 29 Sep 2024 01:51:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727574688; cv=none; b=BqIATblcMr3cxDnZ8mDPwj64C42ebra9LAvbTb9inT9KgWE5tlmmfAnjViOXEkI6xVNbEeXMjmBMjPhZlY0K+RuOnXmh9RWbhceYHnca4Jzc9ix12saX2LqALtYeHHZWEJhytuS2eSxaQ7I3aPRryhL2RgW7JK30iypdnR/mUjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727574688; c=relaxed/simple;
	bh=ISF5mY/X2zy1QRweU7f7/NLQ1VO3nI7ZQpnrZwOobWA=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=cJFSBM/7NHmm2xm/fO7U8gQaV4haRgK0MuaVoEVT8rXDoAlkntr1mg3v0cNO5epjGiBQ4zSDZ1AitV9eXbhPIUfCdRDwYjflH1LdOeW11uAKXFxgK75E05juaz2biPyiLvuE6my29Cp1ZtdHFSq92OSG2+sxG4tKZl413otuAG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Gn9j4J51; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-718d6ad6050so2756026b3a.0;
        Sat, 28 Sep 2024 18:51:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727574686; x=1728179486; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=21rcnj2ZyOGjbCXVWl/cWWdRIJLh4gM249ugqUOM8PU=;
        b=Gn9j4J51OUfrLee9JykkyZgAQqYtJAQyASED6zV8SJ5OZmsjf8XSRO4FmLiPgfq00q
         DBddMEZJIKaV79CU/0jJ8k6gUOMpuakobda6II6IVsIhcl/tUxdHag+TVZU7eENOCNiK
         NRNplc4fiWVKbfBWNQsAjj29Bq7VzUp6rAU9tH7WWwu02yu04sXCbmJqLR1Fb4yjnai+
         yZ922gL7ElPmfLqGFtSKukbmWIcYiKIdmpWnEGlcVVsPIPJSQfFEV93J/mpYUFywpWFc
         9/TVj/DG5eQfYyZ3BQhHNmXZflAuQnCSsrRf/LbDOl0pZYfzqEQdWsSPQ12M4zuUq8DZ
         U3Dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727574686; x=1728179486;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=21rcnj2ZyOGjbCXVWl/cWWdRIJLh4gM249ugqUOM8PU=;
        b=LlDBCaTwb9EIeIriyIb+Qy4nZDsBOKhgQTr3oL7NkuToqUYYmfhUYZ3O7QKjD8+3mz
         e7ZGggXm9nVmNj9p4shgJewnQnTWsQdeqBnWieRzCEGVNdddVjPwkZOLQW0aubIYFxUd
         4hsNr9xS6c1f/5qspT6N1YnuTqNku6G9Dn0eayrbRMVm6O7vl/hQGrq80w8f0a+kPNgm
         Uo0Refz1tFmIkXOx5s9r6dmGSIV9zgFEa0w2j8spp1d4Y87g1jgFbhjBeNC7ICJEMNpr
         RgiDlI9xFRmLbB7v7Luvzm37O8D/LtbGQR4KF7MHGh66/E2IxYry+EKA+jSSA7qChTDR
         aSiA==
X-Forwarded-Encrypted: i=1; AJvYcCVWvWNZhycZCoCsGfFmDOBRRZl7H0heK78YgeS4t3CeLHVzGxc/5///MVfH/2jx1m3mfhtgRjTiZeMiZKVpTA==@vger.kernel.org, AJvYcCVYxxFe373NHgCM4tve7+UO0MA6qZRPPNn24fCuZw/a+ECmNPZC1OU8NiQ1oX/1vibPns9D1qHj96fQWYw=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywnf9E9tkTPH0W++qz4QBdt83TRkk2Opm7dksK3zvgn+SL403r5
	tKSEfIKS829NShX2w9xYjglEh6q4JEltrXm00CIR2RaPIFEJzfpYK6cg1X4p1c8=
X-Google-Smtp-Source: AGHT+IFTf7Cg8aQrmiSvLt861+M6xP2hhbq4rulWgSru0qLO/+f/bEQEXZFdf1MnlqxCPr+6A2b/Ww==
X-Received: by 2002:a05:6a00:3e21:b0:70d:2796:bce8 with SMTP id d2e1a72fcca58-71b2604bfe5mr13304104b3a.20.1727574686399;
        Sat, 28 Sep 2024 18:51:26 -0700 (PDT)
Received: from smtpclient.apple ([205.204.117.124])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71b264bc1a3sm3785448b3a.75.2024.09.28.18.51.24
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 28 Sep 2024 18:51:26 -0700 (PDT)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3774.500.171.1.1\))
Subject: Re: [PATCH] livepatch: introduce 'stack_order' sysfs interface to
 klp_patch
From: zhang warden <zhangwarden@gmail.com>
In-Reply-To: <alpine.LSU.2.21.2409271555430.15317@pobox.suse.cz>
Date: Sun, 29 Sep 2024 09:51:12 +0800
Cc: Josh Poimboeuf <jpoimboe@kernel.org>,
 Jiri Kosina <jikos@kernel.org>,
 Petr Mladek <pmladek@suse.com>,
 Joe Lawrence <joe.lawrence@redhat.com>,
 live-patching@vger.kernel.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <D229E2D7-31DC-4420-AC78-5146048E6ABE@gmail.com>
References: <20240925064047.95503-1-zhangwarden@gmail.com>
 <20240925064047.95503-2-zhangwarden@gmail.com>
 <alpine.LSU.2.21.2409271555430.15317@pobox.suse.cz>
To: Miroslav Benes <mbenes@suse.cz>
X-Mailer: Apple Mail (2.3774.500.171.1.1)

Hi, Miroslav!
>=20
> Perhaps something like
>=20
> "
> Add "stack_order" sysfs attribute which holds the order in which a =
live=20
> patch module was loaded into the system. A user can then determine an=20=

> active live patched version of a function.
>=20
> cat /sys/kernel/livepatch/livepatch_1/stack_order -> 1
>=20
> means that livepatch_1 is the first live patch applied
>=20
> cat /sys/kernel/livepatch/livepatch_module/stack_order -> N
>=20
> means that livepatch_module is the Nth live patch applied
> "
> ?
>=20
>> Suggested-by: Petr Mladek <pmladek@suse.com>
>> Suggested-by: Miroslav Benes <mbenes@suse.cz>
>> Suggested-by: Josh Poimboeuf <jpoimboe@kernel.org>
>> Signed-off-by: Wardenjohn <zhangwarden@gmail.com>
>=20
> How do you prepare your patches?
>=20
> "---" delimiter is missing here.

I will commit my changes with 'git commit -m' option.
Then, I use 'git format-patch' to generate my patches.
After my patches is ready, I would use 'git send-email' to=20
send my directory containing my patches and cover letter.

Is there any step I missed?

>=20
>> diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
>> index ecbc9b6aba3a..914b7cabf8fe 100644
>> --- a/kernel/livepatch/core.c
>> +++ b/kernel/livepatch/core.c
>> @@ -346,6 +346,7 @@ int klp_apply_section_relocs(struct module *pmod, =
Elf_Shdr *sechdrs,
>>  * /sys/kernel/livepatch/<patch>/enabled
>>  * /sys/kernel/livepatch/<patch>/transition
>>  * /sys/kernel/livepatch/<patch>/force
>> + * /sys/kernel/livepatch/<patch>/stack_order
>>  * /sys/kernel/livepatch/<patch>/<object>
>>  * /sys/kernel/livepatch/<patch>/<object>/patched
>>  * /sys/kernel/livepatch/<patch>/<object>/<function,sympos>
>> @@ -443,13 +444,37 @@ static ssize_t force_store(struct kobject =
*kobj, struct kobj_attribute *attr,
>> return count;
>> }
>>=20
>> +static ssize_t stack_order_show(struct kobject *kobj,
>> + struct kobj_attribute *attr, char *buf)
>> +{
>> + struct klp_patch *patch, *this_patch;
>> + int stack_order =3D 0;
>> +
>> + this_patch =3D container_of(kobj, struct klp_patch, kobj);
>> +
>> + /* make sure the calculate of patch order correct */
>=20
> The comment is not necessary.
>=20
>> + mutex_lock(&klp_mutex);
>> +
>> + klp_for_each_patch(patch) {
>> + stack_order++;
>> + if (patch =3D=3D this_patch)
>> + break;
>> + }
>> +
>> + mutex_unlock(&klp_mutex);
>=20
> Please add an empty line before return here.
>=20
>> +       return sysfs_emit(buf, "%d\n", stack_order);
>> +}
>=20
> Miroslav

And the rest of the suggestions will be fix in the next version.

Regards.
Wardenjohn.


