Return-Path: <live-patching+bounces-642-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 39C3A972BD6
	for <lists+live-patching@lfdr.de>; Tue, 10 Sep 2024 10:15:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AEDE91F23B1C
	for <lists+live-patching@lfdr.de>; Tue, 10 Sep 2024 08:15:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C634F184543;
	Tue, 10 Sep 2024 08:10:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GXJKtFvb"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C75D175D2D;
	Tue, 10 Sep 2024 08:10:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725955803; cv=none; b=XdI7LCYgqM7sSRC/4A8jjUFhbAiZIdTCZ5Z84ppkpaSSUlMJWKO8Wja6tcqOlSDU+vOpZ0gt60kOVqJKOHQsJEtlaNI+eCSCPQ3k1e9dUaf3iGD0DONPRSFJlBjbZWzHkeUmH+agwKtMNLbuUIc2tzb0BtvHVEEslTvn8ukSzug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725955803; c=relaxed/simple;
	bh=Uup9o4mP0opF2/S8Bgd71oRxM4Msxjr45y53Cz219xM=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=j1ADy/kmXnE8PyQ9eIF5w9Ijw9DpJ7x4movsUTFyAvoBcUjTUmj0+WaEWKfz1KOnqpzD7cosNS+UJ9qiPb+nPY6xa1c7gR0NTMJffFIEt/SdBU8GcgxHhty3rWcV34qv7/ntPfd8+vucM/7jYCM/aqveA2rg9nOmxUAPea1+Q0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GXJKtFvb; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-718d985b6bbso3459888b3a.2;
        Tue, 10 Sep 2024 01:10:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1725955801; x=1726560601; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fPG57gosX9k+xMxkP0xDLO+h+Jd1eOEeC6Vw8eeTQuY=;
        b=GXJKtFvb0Yrc/EiOcvr5hVI0Hxn5Uv0nc6vqbs/rvle9Uj1aEAsOMPSl2rfRGASvvS
         irbqFHOdZrKe0CTEzFzkyeiMhhzH0ccr6xEPsoyhvUElgD7dFnrUFDgHngNwvCIxL4LQ
         7iZgUr728k2kEx3Hofzrg5D+fM2HayWy3X5PcDMTRwFIj37+B/izSra5lSK7KR/N/OSQ
         5jhSqWJURZc5LKSbnPKUbwskuXGQEgSycVA+vYe6UZeSwbhJoYRkrolJ8Ry6XAxmKWj6
         FdcFDBwZFfNuTmYJYz7HzEBrUbb0vBj6lRyXHT6puS3FpnkGDL06foasynLob2ih+SW4
         lWgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725955801; x=1726560601;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fPG57gosX9k+xMxkP0xDLO+h+Jd1eOEeC6Vw8eeTQuY=;
        b=eLnhTNCec0Df0AfLZwqRn1WYrFt9DAR4Q/CXjCKv/4LTP/UBJKxsMowkBT/3/F5yPG
         b3rXLF1xRJ5oOGRZZPCMU4cybOyl9HbQn3mdbYRsBYjp6Y6OCc7doNxYxstxVCu/WW4i
         6C3CNFMGWlFFTDaKYkJvKu8e6wJTwqcFB2XFJeKPqmJiU7j5nP0koUGL89qHegXktNAi
         SoBqMRBlJQpJFCmmSnJ2FnwGQneGL8FSM6yUMx5xCetq29KNAW045WBS8gLDsv8YpaJ9
         EVsOLgA2NDcSu39NmWvjDyJQwDoFjZTiX7lhgoDgMh1Gy8wcufPz0tV5sqSDOkc4FTEM
         LQRQ==
X-Forwarded-Encrypted: i=1; AJvYcCWjivVj3Sn5DpmR1mQg1vuhcKFtsv5/U7a+qdDtDRyuUFwNMVa7rHtf+roIwlDfeWfqMuBpPwL2v1gBvgnDCQ==@vger.kernel.org, AJvYcCXRe/2v7k6we7MigSfafIDMWyk/z+tWS4403j7l05C60Xu7JkBx0Zh8xqAHpYrQ3HSwm0VWuy+aizoW0Uo=@vger.kernel.org
X-Gm-Message-State: AOJu0YyVK9U8QNMpxL3sHOKtMV/RSs8d0fIwMtRr9iKb/0n3VYteWlpm
	kEk2VMw88FMaQCvgMTFguUR9xLuQG7hAR5r5/LxB9TyJTHEzhtIr
X-Google-Smtp-Source: AGHT+IFYxdCfxP30R0kF9qQZXB2CJzl+758rCe9PYrjfZ7MBe4RwCVaiuS+HW3NLL1M7rGK69UNMVw==
X-Received: by 2002:a05:6a00:919c:b0:718:532f:5a3 with SMTP id d2e1a72fcca58-718d5e17b17mr16434372b3a.7.1725955801340;
        Tue, 10 Sep 2024 01:10:01 -0700 (PDT)
Received: from smtpclient.apple ([198.11.176.14])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7d823cf2f1fsm4362564a12.25.2024.09.10.01.09.58
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 10 Sep 2024 01:10:00 -0700 (PDT)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3774.500.171.1.1\))
Subject: Re: [PATCH v4 2/2] livepatch: Add using attribute to klp_func for
 using function show
From: zhang warden <zhangwarden@gmail.com>
In-Reply-To: <Zt_86rOMJN4UFEk-@pathway.suse.cz>
Date: Tue, 10 Sep 2024 16:09:46 +0800
Cc: Miroslav Benes <mbenes@suse.cz>,
 Josh Poimboeuf <jpoimboe@kernel.org>,
 Jiri Kosina <jikos@kernel.org>,
 Joe Lawrence <joe.lawrence@redhat.com>,
 live-patching@vger.kernel.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <35E63D8A-6C19-4EAC-94A3-0A5F74AE679F@gmail.com>
References: <20240828022350.71456-1-zhangwarden@gmail.com>
 <20240828022350.71456-3-zhangwarden@gmail.com>
 <alpine.LSU.2.21.2409051215140.8559@pobox.suse.cz>
 <ZtsqLiJPy5e70Ows@pathway.suse.cz>
 <B250EB77-AFB0-4D32-BA4E-3B96976F8A82@gmail.com>
 <Zt_86rOMJN4UFEk-@pathway.suse.cz>
To: Petr Mladek <pmladek@suse.com>
X-Mailer: Apple Mail (2.3774.500.171.1.1)

Hi, Petr

> On Sep 10, 2024, at 16:01, Petr Mladek <pmladek@suse.com> wrote:
>=20
> On Sun 2024-09-08 10:51:14, zhang warden wrote:
>>=20
>> Hi, Petr
>>>=20
>>> The 1st patch adds the pointer to struct klp_ops into struct
>>> klp_func. We might check the state a similar way as =
klp_ftrace_handler().
>>>=20
>>> I had something like this in mind when I suggested to move the =
pointer:
>>>=20
>>> static ssize_t using_show(struct kobject *kobj,
>>> struct kobj_attribute *attr, char *buf)
>>> {
>>> struct klp_func *func, *using_func;
>>> struct klp_ops *ops;
>>> int using;
>>>=20
>>> func =3D container_of(kobj, struct klp_func, kobj);
>>>=20
>>> rcu_read_lock();
>>>=20
>>> if (func->transition) {
>>> using =3D -1;
>>> goto out;
>>> }
>>>=20
>>> # FIXME: This requires releasing struct klp_ops via call_rcu()
>=20
> This would require adding "struct rcu_head" into "struct klp_ops",
> like:
>=20
> struct klp_ops {
> struct list_head func_stack;
> struct ftrace_ops fops;
> struct rcu_head rcu;
> };
>=20
> and then freeing the structure using kfree_rcu():
>=20
> diff --git a/kernel/livepatch/patch.c b/kernel/livepatch/patch.c
> index 90408500e5a3..f096dd9390d2 100644
> --- a/kernel/livepatch/patch.c
> +++ b/kernel/livepatch/patch.c
> @@ -149,7 +149,7 @@ static void klp_unpatch_func(struct klp_func =
*func)
>=20
> list_del_rcu(&func->stack_node);
> list_del(&ops->node);
> - kfree(ops);
> + kfree_rcu(ops, rcu);
> } else {
> list_del_rcu(&func->stack_node);
> }
> @@ -223,7 +223,7 @@ static int klp_patch_func(struct klp_func *func)
> err:
> list_del_rcu(&func->stack_node);
> list_del(&ops->node);
> - kfree(ops);
> + kfree_rcu(ops, rcu);
> return ret;
> }
>=20
> With this the function should be safe against accessing an invalid
> pointer.
>=20
>>> ops =3D func->ops;
>>> if (!ops) {
>>> using =3D 0;
>>> goto out;
>>> }
>>>=20
>>> using_func =3D list_first_or_null_rcu(&ops->func_stack,
>>> struct klp_func, stack_node);
>>> if (func =3D=3D using_func)
>>> using =3D 1;
>>> else
>>> using =3D 0;
>>>=20
>>> out:
>>> rcu_read_unlock();
>>>=20
>>> return sysfs_emit(buf, "%d\n", func->using);
>>> }
>=20
> But the function is still not correct according the order of reading.
> A more correct solution would be something like:
>=20
> static ssize_t using_show(struct kobject *kobj,
> struct kobj_attribute *attr, char *buf)
> {
> struct klp_func *func, *using_func;
> struct klp_ops *ops;
> int using;
>=20
> func =3D container_of(kobj, struct klp_func, kobj);
>=20
> rcu_read_lock();
>=20
> /* This livepatch is used when the function is on top of the stack. */
> ops =3D func->ops;
> if (ops) {
> using_func =3D list_first_or_null_rcu(&ops->func_stack,
> struct klp_func, stack_node);
> if (func =3D=3D using_func)
> using =3D 1;
> else
> using =3D 0;
> }
>=20
> /*
>  * The function stack gives the right information only when there
>  * is no transition in progress.
>  *
>  * Make sure that we see the updated ops->func_stack when
>  * func->transition is cleared. This matches with:
>  *
>  * The write barrier in  __klp_enable_patch() between
>  * klp_init_transition() and klp_patch_object().
>  *
>  * The write barrier in  __klp_disable_patch() between
>  * klp_init_transition() and klp_start_transition().
>  *
>  * The write barrier in klp_complete_transition()
>  * between klp_unpatch_objects() and func->transition =3D false.
>  */
> smp_rmb();
>=20
> if (func->transition)
> using =3D -1;
>=20
> rcu_read_unlock();
>=20
> return sysfs_emit(buf, "%d\n", func->using);
> }
>=20
> Now, the question is whether we want to maintain such a barrier. Any
> lockless access and barrier adds a maintenance burden.
>=20
> You might try to put the above into a patch see what others tell
> about it.
>=20
> Best Regards,
> Petr

After the previous discussion, it seems that patch-level "order" feature
 is the more acceptable way to fulfill the patch order information.

Therefore, I am trying to go that way instead of adding "using" into =
klp_func.

Maybe patch-level interface will bring less maintenance burden.

Regards,
Wardenjohn.


