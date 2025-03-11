Return-Path: <live-patching+bounces-1269-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id CB8D4A5B790
	for <lists+live-patching@lfdr.de>; Tue, 11 Mar 2025 04:54:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 643DB18945F6
	for <lists+live-patching@lfdr.de>; Tue, 11 Mar 2025 03:54:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F16325A4D5;
	Tue, 11 Mar 2025 03:54:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PVUNdSmd"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56B281BDCF
	for <live-patching@vger.kernel.org>; Tue, 11 Mar 2025 03:54:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741665255; cv=none; b=PM9VP0/NIuOCc8GxaWh+d4ypAs3N1NUaRnmL5kYBuBQ8F4fX2jr4s1TkB1pJB58lWv1rCV3J1sFE0IxEvuTwekj6WI+WtsaSF4fYRSj2crDiKRjo6CSEASyNlDJ/G41er3vZkP80sIly3jmi3uxvkC/kBBKXH3FOjEqhxIPazm0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741665255; c=relaxed/simple;
	bh=iaiWjp307ozUri9KSafqTIhorNYMv/+cO+gJktPgyDk=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=aX1VDx/NvHD14HFHn0iN8btGnZX1ZhfsJJxwtaOe8MRywBIVdyYGvvTGvI0oHGtUupUdliETrKynawpBUSD9xfCG7E1yKQxnJadv2QxVIa8CkqeoPDfhfLQUgbQXyo3sqmScqsxTqleBAFuI0z2Ni1IjvqmzuIL2nqzpLo6CZJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PVUNdSmd; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-223959039f4so98858705ad.3
        for <live-patching@vger.kernel.org>; Mon, 10 Mar 2025 20:54:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741665253; x=1742270053; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mt8fioc8iLWd/7am9QvoMEwgKUhNLCczqWqgsgslaYQ=;
        b=PVUNdSmdPuUm6G0koioEgn+Hk/EPpbzighJ39grGjZiAoGHHS6W+UCdsKVjZrwgRDZ
         MuZQI9wnMYMS9KQ4khknjU+5MDqIMtO1hZGugiBBijudQeeWxIuzHKcuvOG5SNVqHc/y
         RHfkNQylmFZqGJ8amGmvISGhLzXZIf6baqzwMM8mPh+Q6f4iAVjKsxFBpcSGw332rp0y
         Mzgf5JJAtlVVZuCuHS+vBoFLnfdeAPR6V588JbTAArySREpkbxUwrrg4f92gyufc0Hsy
         yf4tSKvv4ELoXYK65F83dWtpbPJzP8fRx2haWH9YWcKZ1c9gl/nFhvmiL4UotbOIiMUd
         FsEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741665253; x=1742270053;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mt8fioc8iLWd/7am9QvoMEwgKUhNLCczqWqgsgslaYQ=;
        b=pdyMkp1p+9aqtG1jvvoBTQAhoDEKdZBXn/kbHwkZdMKLhRH6vn5xNRz3MEiVvqHSiY
         qOSJg9i8CIjI0p7dQAg/KnvT6XyZo7If7AC6NsZgbiTtMCYIY+4Z6iWuq3GnsWaCEeH8
         fyVHwhlZmWsQtvaj/06MMaaQeEQuoemtLCLwojchW6n2SaqqqNm3mpR8ui4SVBvO1cQ0
         m8LtJq/33oIgZ6WMRmVPMq8DVO0p1naJom7aFzBGxMFf3LC6uYuQeQi5fI0o3DL1Cepf
         EbyeNFCrkdx9FcEbIKRIMr6IaeWjfAJbykaaXmJsw4LOwVfM1dYU1X3D7FpaP50JthOR
         uh4w==
X-Forwarded-Encrypted: i=1; AJvYcCXXfnYC/xiqw4X+9SkPPNuOvMw48p7bKOEa4URU8Q5IphnIuQAItYFMbROyQ1xBhu1x/OPix5+EGJG4NHxG@vger.kernel.org
X-Gm-Message-State: AOJu0Yw0Z7F65S2CMm3Y3i14gy8XjqYOHxaKKcsOrmcPaA8RVPNPDttK
	pURVK69V1JL12zBKbnrgjSZdLhITXwwNl2fFm1R28xXB5yg7N1LK
X-Gm-Gg: ASbGncsnEkH5eyzpwwvu+7lsP+fEV/2oCcC4eUKm16nKgK0O7zLtIfo8PGyFxyEPoSw
	wJ7795YWl3NTOCoot+RAFxnQb8Qi1LVYXbDL4YOa6bZrCdq3l539lj1Hv5k/kK3o/iW1fNrGHqg
	ST+IVJ4xeZerNq/w5M/kHZPFtIC2dYvA+7EnMn1V/NmSTHll/AY3uoetSG1/gx+ncUhDfi+GWxc
	4fno9cMcxgrqHhq7E/wPuc4LIRlqqiOMhoEsdzr4LROmxTgWJXG/TlrQV8EQ7pvrcNXHvJmEdvz
	MBBfozjm0sVtt198t5stX7IZucE658GPJHGr5BjDLDEAMNCMxVWK2OfwHK5MaL3gcA==
X-Google-Smtp-Source: AGHT+IFOvGV53hCHc+cKCWkC5TDSoEwkVJ/HP3rLkxwk6KL1WYBAwyC7spmW8q9Ru2WHsQLjgHZF4g==
X-Received: by 2002:a17:903:2405:b0:223:66bb:8993 with SMTP id d9443c01a7336-22428bf1560mr261098305ad.43.1741665253444;
        Mon, 10 Mar 2025 20:54:13 -0700 (PDT)
Received: from smtpclient.apple ([205.204.117.123])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22410a91db3sm86975165ad.170.2025.03.10.20.54.11
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 10 Mar 2025 20:54:13 -0700 (PDT)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3774.500.171.1.1\))
Subject: Re: [RFC] Add target module check before livepatch module loading
From: zhang warden <zhangwarden@gmail.com>
In-Reply-To: <Z88JxGTGMcBEeHVP@pathway.suse.cz>
Date: Tue, 11 Mar 2025 11:53:59 +0800
Cc: Josh Poimboeuf <jpoimboe@kernel.org>,
 Jiri Kosina <jikos@kernel.org>,
 Miroslav Benes <mbenes@suse.cz>,
 Joe Lawrence <joe.lawrence@redhat.com>,
 live-patching@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <911AD123-9CA6-405A-8D63-6F0806C12F84@gmail.com>
References: <C746373C-96ED-47EE-94F2-00E930BE2E8B@gmail.com>
 <Z8r6AKBU4WPkPlaq@pathway.suse.cz>
 <3524E557-77AD-427C-82BA-6CA06968AC5B@gmail.com>
 <Z88JxGTGMcBEeHVP@pathway.suse.cz>
To: Petr Mladek <pmladek@suse.com>
X-Mailer: Apple Mail (2.3774.500.171.1.1)



> Why do you want to store the target module src version in an elf
> section, please?
>=20

Well, let me explain it again. Take fuse.ko as an example.

Now, the running system have fuse.ko(v1) inside.
I found fuse.ko(v1) have a bug, and try to fix it.
fuse.ko(v1) have srcversion(src_v1) to tag its build.

Now, I build an livepatch.ko for fuse.ko(v1). But how to
make sure that this livepatch.ko will only patch the fuse.ko(v1)?

( Becase in other system, there may be fuse.ko(v2) or fuse.ko(v3) in
the system. If this livepatch.ko patch to fuse.ko(v2) or fuse.ko(v3)
may cause bugs.)

To make sure this livepatch.ko will only patch the fuse.ko(v1), I=20
can store the target srcversion of fuse.ko(v1) into the livepatch.ko.

livepatch.ko now can carry its owner's information. When the system
loading livepatch module, the system can know that this livepatch module
can just only patch the target with srcversion(src_v1). And avoid the =
wrong
patching.


> IMHO, it would be much easier to store it in struct klp_object
> as I proposed above. Then the check might be as simple as:
>=20
> diff --git a/include/linux/livepatch.h b/include/linux/livepatch.h
> index 51a258c24ff5..dfd7132eec4e 100644
> --- a/include/linux/livepatch.h
> +++ b/include/linux/livepatch.h
> @@ -104,6 +104,7 @@ struct klp_callbacks {
> /**
>  * struct klp_object - kernel object structure for live patching
>  * @name: module name (or NULL for vmlinux)
> + * @srcversion  compactible srcversion (optional)
>  * @funcs: function entries for functions to be patched in the object
>  * @callbacks: functions to be executed pre/post (un)patching
>  * @kobj: kobject for sysfs resources
> @@ -117,6 +118,7 @@ struct klp_callbacks {
> struct klp_object {
> /* external */
> const char *name;
> + const char *srcversion;
> struct klp_func *funcs;
> struct klp_callbacks callbacks;
>=20
> diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
> index 0cd39954d5a1..61004502e72d 100644
> --- a/kernel/livepatch/core.c
> +++ b/kernel/livepatch/core.c
> @@ -66,6 +66,13 @@ static void klp_find_object_module(struct =
klp_object *obj)
>  * klp_module_going() instead.
>  */
> mod =3D find_module(obj->name);
> +
> + /* Do not livepatch an incompatible object. */
> + if (mod && obj->srcversion && mod->srcversion) {
> + if (strcmp(obj->srcversion, mod->srcversion) !=3D 0)
> + goto out;
> + }
> +
> /*
>  * Do not mess work of klp_module_coming() and klp_module_going().
>  * Note that the patch might still be needed before klp_module_going()
> @@ -75,7 +82,7 @@ static void klp_find_object_module(struct klp_object =
*obj)
>  */
> if (mod && mod->klp_alive)
> obj->mod =3D mod;
> -
> +out:
> rcu_read_unlock_sched();
> }
>=20
> The above code causes that the livepatch would ignore an incompatible
> object.
>=20
> Maybe, you want to return an error instead and block the incompatible
> module load.
>=20

Oh, I got your point. Because I usually use livepatch to fix problems
point to point, it is rare that all fixes are put in one patch....lol...

So, I admit my design have shortcomings, which is ignored the situation
that one livepatch module can patch many functions in one module...


>>> It would be optional. I made just a quick look. It might be enough
>>> to check it in klp_find_object_module() and do not set obj->mod
>>> when obj->srcversion !=3D NULL and does not match mod->srcversion.
>>>=20
>>> Wait! We need to check it also in klp_write_section_relocs().
>>> Otherwise, klp_apply_section_relocs() might apply the relocations
>>> for non-compatible module.
>>>=20
>>=20
>> As previously mentioned, if we can check the srcversion when calling
>> the syscall `init_module`, refuse to load the module if the livepatch
>> module have srcversion and the srcversion is not equal to the target
>> in the system. Can it avoid such relocations problem?
>=20
> Honestly, I am not sure what you mean by target module src version.
>=20
> Anyway, you could prevent the module load also when
> klp_find_object_module() returns an error.
>=20

Well, my target module srcversion is the fuse.ko(v1) as previous =
mentioned.
Is it clear now?

>=20
> I do not understand this urgument.
>=20
> vmlinux can be identified by build_id stored in "vmlinux_build_id".
>=20
> And modules can be identified by both build_id and srcversion. Both
> information are stored in struct module.
>=20
> A single livepatch could modify more objects: vmlinux and several
> modules. The metadata for each modified object are in "struct
> klp_object". The related obect is currently identified only by =
obj->name.
> And we could add more precision identification by setting
> also "obj->srcversion" and/or "obj->build_id".
>=20

Yep, but how can we get the obj->srcversion? If we tring to store it=20
in klp_object, the information should be carried when livepatch is being =
build.
Otherwise, we don't know which srcversion is good to patch, isn't it?

>=20
> My understanding is that "srcversion" a kind of checksum of the
> sources. I guess that it will be always the same for the sources.
> I guess that it is not affected by the compiler or compiler options.
>=20

You are right, Petr. I made some tests on a module, and seems that =
srcversion=20
depends on the source code.=20

> But build_id should be unique with each rebuild. It should be
> afftected by the compiler or compiler options.
>=20
> Note that the compiler options might affect how the functions are
> opimized (inlining). And it might affect compactibility of the =
livepatch.

IMHO, we just need to make sure the target version (using srcversion) is =
correct=20
will be  enough?



