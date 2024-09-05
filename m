Return-Path: <live-patching+bounces-609-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A092E96DB90
	for <lists+live-patching@lfdr.de>; Thu,  5 Sep 2024 16:18:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 59F5B28C0E5
	for <lists+live-patching@lfdr.de>; Thu,  5 Sep 2024 14:18:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 41A9519F408;
	Thu,  5 Sep 2024 14:17:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="H8o6q1Ai"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6E5D19EED4;
	Thu,  5 Sep 2024 14:17:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725545864; cv=none; b=UPG2z/f/lFu469flh0DNrzTOlB6w9J8fkK5rxhBWbwNluOI5Ir8mQ5UMKam+xxoNzk1KW0ppTooG14AMBj10s8L1Uu+kYkBt2gvqwXoufIDbneTfzeBmxJD+XZidwAZFcOxMvgedrWibn3kMmCNE0pYOYsNknuFX3jTYLhrO1+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725545864; c=relaxed/simple;
	bh=h8zZ7hfh2rSqS2KNTIJtngjH3e5wPWm2Rh5d/8YY/1U=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=JxPoSabdv6Ji4AKOaNH9iBt3sZVZbXm9GHlzTFQuxBKctra9CdsqibjMDfmE3hzIFszKul17gQpz2IvO3pKjbvaoV4miQg/bm5I0EwFzdD3a6lKCZaENw7Z4mOGObxL9sS7Sy79VBdUI04nHiAuEdHSjp+ijLDoiRFJjsvG5M6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=H8o6q1Ai; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-1fee6435a34so8313565ad.0;
        Thu, 05 Sep 2024 07:17:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1725545862; x=1726150662; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=h8zZ7hfh2rSqS2KNTIJtngjH3e5wPWm2Rh5d/8YY/1U=;
        b=H8o6q1AilXYRVmmp98QGZE8SuujCkF7td6y97DtJKKTe9w3xtC+QR83i1WW09XiNo7
         QBKWY2lLjNCkqA6aMEKCK8JFcUs20mksQDNi8yJsiSzdVj9wsF2gluh/hL3c9HQuf3VA
         LRfvHo2A3DPvFlzFyK0zc0hHWh9CZGfWenaaMCGZ59DLsRo30tNly2pB05Qes78uBPZo
         V2IDrMXIQLJIqgtMVDG2wxSX8plX6x0WcK5VPJsOEhgiLbT7s+cfRQ0Q2dQxo3KF4zXt
         sSp0UzjpEhFA0v2pBOW/u2+dvHxohk1ie9nR32OBIXUotLKFgyslLsV18jqgxOtLsVBS
         Am1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725545862; x=1726150662;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=h8zZ7hfh2rSqS2KNTIJtngjH3e5wPWm2Rh5d/8YY/1U=;
        b=ry3ZqkfpwPmrk4ChzE6NEjBZmk4K2bU9Ghb3lM7GWXIZYhlnJaGcB4L+zeMTKJxT2j
         9Zn9ImX/AFl0lnbTwlLl8aKS4oxaA6xx7ZjBx5xs+6TP8YfVOwye9ULMKTK/04EDdILu
         KXURB7I3SYnsERmSrY/BqlC71TXA9ZEkcpJ+xeo9qzrZSMDmbsFN1Ry8BCbvz86ITFoK
         dAxx/z7LnC2BCtLo0GcyftbsEb6Frs/7Qf4rX+z9afZ7mPVYaAi8741dXsx/NrpVZr90
         SK8lHfjinVW8r15kUieCPefUVOhi9th9+TpW8cg3MkOgP3KwVUoOvCLAtVzGjAzxfsfL
         f3vg==
X-Forwarded-Encrypted: i=1; AJvYcCUJ9mxf4PndRkvoFFUDSt/ftKSh1xcYJJOWw1ZV3rrd8BRzR+0ahcLKK8nF64V+tx1lCax7fopWMgPVKEk=@vger.kernel.org, AJvYcCV6mBA4R+8sEfzlLLPEFKe1iwGrffx1zqcI0twZUfFoitFc3L7p9a/HYQA4FQxJE9jMvBpSBEP9HFVuuTC4Bg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yz2ITo3af4NJm0MchI/bCVJmbEps0Afh8D6JNfKfF8HJ3N9YeR5
	Adu6NeKWOH2cR3TO+6ZL2MaeG0Td9bUaNUloWrrrEI4RV99Nr2tY
X-Google-Smtp-Source: AGHT+IFKnQTIIWx7RGO9WFKBUE+9gSzHiEQBgbPGNsfc255oRzzvwwvzbs8bxN2YycHoN5Gt+sVqng==
X-Received: by 2002:a17:902:f693:b0:205:7b04:ddf2 with SMTP id d9443c01a7336-20699af10b2mr96356295ad.29.1725545861915;
        Thu, 05 Sep 2024 07:17:41 -0700 (PDT)
Received: from smtpclient.apple ([198.11.178.15])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-206bbc91323sm25023615ad.272.2024.09.05.07.17.38
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 05 Sep 2024 07:17:41 -0700 (PDT)
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
In-Reply-To: <alpine.LSU.2.21.2409051215140.8559@pobox.suse.cz>
Date: Thu, 5 Sep 2024 22:17:26 +0800
Cc: Josh Poimboeuf <jpoimboe@kernel.org>,
 Jiri Kosina <jikos@kernel.org>,
 Petr Mladek <pmladek@suse.com>,
 Joe Lawrence <joe.lawrence@redhat.com>,
 live-patching@vger.kernel.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <FF185094-10E0-4898-96C4-184F96D5B56C@gmail.com>
References: <20240828022350.71456-1-zhangwarden@gmail.com>
 <20240828022350.71456-3-zhangwarden@gmail.com>
 <alpine.LSU.2.21.2409051215140.8559@pobox.suse.cz>
To: Miroslav Benes <mbenes@suse.cz>
X-Mailer: Apple Mail (2.3774.500.171.1.1)


Hi Miroslav,
>=20
>=20
> I am not a fan. Josh wrote most of my objections already so I will not=20=

> repeat them. I understand that the attribute might be useful but the=20=

> amount of code it adds to sensitive functions like=20
> klp_complete_transition() is no fun.
>=20
OK, the point I make changes to klp_complete_transition is that when a =
transition is going to be complete, we can make sure the function state =
can go to an end state (0 or 1), which is the most easy way to do =
so...lol...

> Would it be possible to just use klp_transition_patch and implement =
the=20
> logic just in using_show()? I have not thought through it completely =
but=20
> klp_transition_patch is also an indicator that there is a transition =
going=20
> on. It is set to NULL only after all func->transition are false. So if =
you=20
> check that, you can assign -1 in using_show() immediately and then =
just=20
> look at the top of func_stack.
>=20

I will consider it later. If you have any suggestions or other =
solutions, please let me know.

> If possible (and there are corner cases everywhere. Just take a look =
at=20
> barriers in all those functions.) and the resulting code is much =
simpler,=20
> we might take it. But otherwise this should really be solved in =
userspace=20
> using some live patch management tool as Josh said. I mean generally=20=

> because you have much more serious problems without it.
>=20

I replied to Josh to explain my reason of not using user space tools to =
maintain livepatch information. Of cause, I put my patch here and tell =
you the problem I am facing, maybe there some people may face the same =
problem as me...hah...

We can discuss it, if you have a better idea for that patch, please fell =
free to tell me.

Also, I forgot to sign at the end of the email I sent Josh, I'm sorry...

Thanks.
Wardenjohn.


