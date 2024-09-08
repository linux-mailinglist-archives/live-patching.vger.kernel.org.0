Return-Path: <live-patching+bounces-633-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 4857A9704D7
	for <lists+live-patching@lfdr.de>; Sun,  8 Sep 2024 04:32:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 85164B20A89
	for <lists+live-patching@lfdr.de>; Sun,  8 Sep 2024 02:32:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 70A5E4C98;
	Sun,  8 Sep 2024 02:32:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JKsAnic/"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1C6429A0;
	Sun,  8 Sep 2024 02:31:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725762720; cv=none; b=jYfgKXGHak+oDmLpkCDMjrw5tzsMakPYZQbLSuRlnLLm0S4Aw4jiNiW6tvGwlHewmqge8mbbzDCdxYaG8ZAS34fQOY/sez12Is0p0n1frDGueeN0qXt36A1R327DZtw5l0y2zwW7GdVOsZIDlVvGk8xwkm+smHF8+OxzApD7FC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725762720; c=relaxed/simple;
	bh=+gqU3t9RnxCCRloie90vB91nyAZ71SfWne/rn1qERXE=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=mg0Ecjk+xRd5x0+jXW0obgYD6hrNc3sXBTEUJtGEJgbXLRpVqikWjOUbRTJZ9Lkf1tu32adXmfs1VRrJaEdDTxClqQ6vgcf/Z8zzbmSHZGKMcuK28pot1Okbux4/gCcCJtYVyUiNskoBgBrdOigm58Qp98dZuWnljI5AHPosbAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JKsAnic/; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2068a7c9286so29892295ad.1;
        Sat, 07 Sep 2024 19:31:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1725762718; x=1726367518; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1NMMLMX4o0piSKyjCJad9XUzjBltmT/gvFww3HdzydI=;
        b=JKsAnic/U/zcQAjWfHDl5eNe4wN5Zul5onqAfVgx06NeVE6R8G13qGi4hICDDPfPwy
         65VRNCqZeET4mGfAmlsPIyhzOQOqEGYtNGrA9koJQcHgJa+xtto6Uvu0zJaFQE1LJA+H
         fVNu5ymcEz01aysDtnMW+9Wr4BsazYrbmogUpyO8DlaNbA/DSC2TThJGNo9uCSg8B8BP
         FW7QSW7uUNpy4T6QY21SpkiEr8Duwsf75eaQVmgzQjio2LLVWb2re26Oz6WGL6G4KhRV
         SVz7Kd0oU/YWGB8tidLiB37YWLmhaOxqjVwr6/HGQ1R4Kjo4H+zXnRajtbaD6P6/Q4hF
         WkdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725762718; x=1726367518;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1NMMLMX4o0piSKyjCJad9XUzjBltmT/gvFww3HdzydI=;
        b=isCQKajv9FdC9B6mRS+ZqWKhGLwDEuCDx3+T76zUdO1V3hjig26GuUUElmt5s4zU9d
         4ffsrM9CYNV4DmqYBnMwQ0/Y86iGkUKc47+UnBeT7PWWJpCRLTqox+0tZZcjk50aNJjH
         0yGb5SOz9KDGp08eP0IhaBN6TZFBLuSf7s62gUKtVrO1bCgINyaDd3qXbPVnUdluEW5j
         L7vc8n0JrFk5AgpFcThSX1Hr4/BCZdImCeWoMYsAY1BVhFebZlSVtdzx2S/ULjAuQxX8
         SN7Bo/gl9M8gJLgGePNq2+9M8pv8amGFxJ3Eu1aW0eVylO3HINJh/34K+CIIAri7kEdX
         ahLA==
X-Forwarded-Encrypted: i=1; AJvYcCWatZxjKGoZ89bYMOSIxKho9kCMmE7CEbbBbwUP4a4Vxqb2XI8rF7nRWoi4zCgtYnA9oh3blNwIwEW7Hzs=@vger.kernel.org, AJvYcCWwlNLaHb31N1lMKvThORnsf8vK6BHxOUQZwkjPaN9ojj4MCyT5dzzfmaBJUKVimUIQDzqVd3F3H76CdsoW7Q==@vger.kernel.org
X-Gm-Message-State: AOJu0YxEt68je2b+jZ6tb1DkDwPbIKcVnyHArxcjucv107CKYHfS6I9O
	bNN/TykdvwlFqtFsw7x/J5zqYGb5cHDSjxS6zBuJwG2IHDr5LEK79fRDoTVoQOw=
X-Google-Smtp-Source: AGHT+IHKfSPoo0yHXelm/gZXtpVhE3DaMPfLC0jGTwGUPfHCCoqCZKZ8i4afcD3DO9n1hJ4BNNcYLg==
X-Received: by 2002:a17:902:e849:b0:1fd:69e0:a8e5 with SMTP id d9443c01a7336-206f05b3356mr89131285ad.41.1725762718046;
        Sat, 07 Sep 2024 19:31:58 -0700 (PDT)
Received: from smtpclient.apple ([47.89.225.180])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20710f3176fsm13981395ad.264.2024.09.07.19.31.55
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 07 Sep 2024 19:31:57 -0700 (PDT)
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
In-Reply-To: <ZtswXFD3xud0i6AO@pathway.suse.cz>
Date: Sun, 8 Sep 2024 10:31:42 +0800
Cc: Josh Poimboeuf <jpoimboe@kernel.org>,
 Miroslav Benes <mbenes@suse.cz>,
 Jiri Kosina <jikos@kernel.org>,
 Joe Lawrence <joe.lawrence@redhat.com>,
 live-patching@vger.kernel.org,
 LKML <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <D022A707-3C81-4CBD-B438-C8F2DF0A9151@gmail.com>
References: <20240828022350.71456-1-zhangwarden@gmail.com>
 <20240828022350.71456-3-zhangwarden@gmail.com>
 <alpine.LSU.2.21.2409051215140.8559@pobox.suse.cz>
 <20240905163449.ly6gbpizooqwwvt6@treble>
 <285979BA-2A85-495F-8888-47EAFC061BE9@gmail.com>
 <ZtswXFD3xud0i6AO@pathway.suse.cz>
To: Petr Mladek <pmladek@suse.com>
X-Mailer: Apple Mail (2.3774.500.171.1.1)


Hi, Petr

> On Sep 7, 2024, at 00:39, Petr Mladek <pmladek@suse.com> wrote:
>=20
> On Fri 2024-09-06 17:39:46, zhang warden wrote:
>> Hi, John & Miroslav
>>=20
>>>>=20
>>>> Would it be possible to just use klp_transition_patch and implement =
the=20
>>>> logic just in using_show()?
>>>=20
>>> Yes, containing the logic to the sysfs file sounds a lot better.
>>=20
>> Maybe I can try to use the state of klp_transition_patch to update =
the function's state instead of changing code in =
klp_complete_transition?
>>=20
>>>=20
>>>> I have not thought through it completely but=20
>>>> klp_transition_patch is also an indicator that there is a =
transition going=20
>>>> on. It is set to NULL only after all func->transition are false. So =
if you=20
>>>> check that, you can assign -1 in using_show() immediately and then =
just=20
>>>> look at the top of func_stack.
>>>=20
>>> sysfs already has per-patch 'transition' and 'enabled' files so I =
don't
>>> like duplicating that information.
>>>=20
>>> The only thing missing is the patch stack order.  How about a simple
>>> per-patch file which indicates that?
>>>=20
>>> /sys/kernel/livepatch/<patchA>/order =3D> 1
>>> /sys/kernel/livepatch/<patchB>/order =3D> 2
>>>=20
>>> The implementation should be trivial with the use of
>>> klp_for_each_patch() to count the patches.
>>>=20
>> I think this is the second solution. It seems that adding an
>> interface to patch level is an acceptable way.
>=20
> It seems to be the only acceptable idea at the moment.
>=20
>> And if patch order
>> is provided in /sys/kernel/livepatch/<patchA>/order, we should
>> make a user space tool to calculate the function that
>> is activate in the system. =46rom my point to the original
>> problem, it is more look like a workaround.
>=20
> It is always a compromise between the complexity and the benefit.
> Upstream will accept only changes which are worth it.
>=20
> Here, the main problem is that you do not have coordinated =
developement
> and installation of livepatches. This is dangerous and you should
> not do it! Upstream will never support such a wild approach.
>=20
> You could get upstream some features which would make your life
> easier. But the features must be worth the effort.

Yep, I have the same idea as you here. The problem we face now as Josh =
describes, livepatch now missing the information of patch order. If we =
can have it, the rest information user need can be processed my the =
original information from the kernel.

My intention to introduce "using" feature is to solve the missing info =
of livepatch, facing the original problem I met. But as livepatch =
becomes more and more widely used, this is a real problem that may be =
widely encountered.

If maintainer thinks the way changing klp_transition_patch is not worth =
it. Maybe I can try another way to fix this problem. ( For example, the =
patch-level order interface?) :)=20

=46rom my point of view, this information have its worth it provide, =
what we need to consider is how to implement this function specifically. =
Do you agree with me?

Best Regards,
Wardenjohn.



