Return-Path: <live-patching+bounces-581-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0A96D96B1D7
	for <lists+live-patching@lfdr.de>; Wed,  4 Sep 2024 08:36:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B7A3A2889CA
	for <lists+live-patching@lfdr.de>; Wed,  4 Sep 2024 06:36:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6834E13E3F6;
	Wed,  4 Sep 2024 06:35:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lL8gap5n"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D379513E043;
	Wed,  4 Sep 2024 06:35:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725431702; cv=none; b=KrSXWUuFLs7LmHlGs1sC1tTk5uboqoo7XdaWME+btaZRweItCJXKjRKu0Nvsqw9R3iwn2/QDHwd/RzQXnPWmO5fk4EBXdoSqu3cvGd5LsVMCiFeHEEqxkn9nQXJ6ukJBsI4w432gboLXg1FNAu1mF3oQThDGZeKYRbVa7rFuQxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725431702; c=relaxed/simple;
	bh=pzWt2YVoXo96ojHGFXPqlS+NJRYI//tHEp9TugmINsk=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=TLV+t0scu5/xx8qLVaLUjMT2ICV25UMD5MTd9lVaXOTmetIDobTtYG8KEtpjpmR0Kab5Sg021KBEzof7kF1EGzVl7hzI4XHkZ76j6d2dtRrMIMgbBAE4EJiP4CNAoIsHT3pQMnJBXEYdWAZ+CWmeA0EKLUEVA3BNwyDU+BDSV44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lL8gap5n; arc=none smtp.client-ip=209.85.216.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-2d88c0f8e79so3111116a91.3;
        Tue, 03 Sep 2024 23:35:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1725431700; x=1726036500; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sf1py8tvSyI6/QZWxA+E1HrMmuG/sHo9zPGhA+HbV5s=;
        b=lL8gap5nib6PrG1qZ2gQGnRwTixq9Gvv0B3iU4b4QjpxgV5oBLfpnGlSvXWJCghjjR
         wazwSz/+934HtD7PhTsmSVx/iTJURn7DMnow/DSWR8wvwEdQvY/3T7ItIEO8WOZLOjiq
         qDShPLhlIK89io90I4nNVP+ahcYcu1qzdyt0Q9fT948pggA92lTKhdJdCxbmRiipfP33
         +KTw9uQo9bikCU4UUXbxTPPhgb2TUd6HHuSPTIaCvonrbTYvlOT+EjStlyNJuIMAyGto
         VyZgl7U6ylt7e95tdePcCAheI+A58dE6FPmCOBGlxU+fSWhB4OU1cqN0pfnnvjeWVsor
         C2JA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725431700; x=1726036500;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sf1py8tvSyI6/QZWxA+E1HrMmuG/sHo9zPGhA+HbV5s=;
        b=lGBmVYLgC7Sq2rsyUsASxAetSS+goRwut8hGLSMwGHUMYxz/QYM1zSBHElFsoWDFCb
         ApXWVko43tEuSgVeJ6PxoFrc2kdkXYtwUD6RUA6soVs0UEElHDkEjupfGzu0TCLLe1j9
         2iOQb72ziuvAt5at9zR1Sccao0/U2i4Iod6aSVtgyDlB4Nw4eWCwj5xZ4max6zSaLoYe
         U/IJJwE++PVibJDoxTzwdpnQN4p3g7y4HSCNCPWNm2k/yuHzTHBqEI/9SawmT0C9H4UL
         sQpEFm5kSm4iamhohi1Ug2HyRxT65I5VSS4x4fPRBq/IvOLLipL/CVsHasd1L/WNxlr5
         qJ0Q==
X-Forwarded-Encrypted: i=1; AJvYcCVpYHBpTk/PWGyRIubHgR8Y/wtiqb8cP0lwKxa6IaQgfftfl/fH6iMEZ5U7YRrBLxobRQiNbE9H2uogBgYySg==@vger.kernel.org, AJvYcCX7F0BBncOkSDoQrcUVJceelY5BkypmQ35jFHeM2EpZ4HKJNVStLCzkGOXkd7RPPxBtCcfWwK/Spc3rlgo=@vger.kernel.org
X-Gm-Message-State: AOJu0YzbG70z3Xpvx4E8n5u2+FaQr7nd22aJHsKpaa0cWJeVxVueT37s
	aj4mnJLUioUTQlHWML1ce4hbUxo0HJoNjE4ta5h25jinOaGCww7z
X-Google-Smtp-Source: AGHT+IFSvjO5aIt45xbi4X/NYxH96k7WWgc2nubxFDRF6dFP58dT4skdOPLx9l622UIIfapkdrdKsw==
X-Received: by 2002:a17:90a:c7d0:b0:2d8:a672:186d with SMTP id 98e67ed59e1d1-2da74885568mr4085269a91.20.1725431699888;
        Tue, 03 Sep 2024 23:34:59 -0700 (PDT)
Received: from smtpclient.apple ([198.11.176.14])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2d8eb9ccbb9sm4989837a91.37.2024.09.03.23.34.56
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 03 Sep 2024 23:34:59 -0700 (PDT)
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
In-Reply-To: <20240904044807.nnfqlku5hnq5sx3m@treble>
Date: Wed, 4 Sep 2024 14:34:44 +0800
Cc: Miroslav Benes <mbenes@suse.cz>,
 Jiri Kosina <jikos@kernel.org>,
 Petr Mladek <pmladek@suse.com>,
 Joe Lawrence <joe.lawrence@redhat.com>,
 live-patching@vger.kernel.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <AAD198C9-210E-4E31-8FD7-270C39A974A8@gmail.com>
References: <20240828022350.71456-1-zhangwarden@gmail.com>
 <20240828022350.71456-3-zhangwarden@gmail.com>
 <20240904044807.nnfqlku5hnq5sx3m@treble>
To: Josh Poimboeuf <jpoimboe@kernel.org>
X-Mailer: Apple Mail (2.3774.500.171.1.1)



> On Sep 4, 2024, at 12:48, Josh Poimboeuf <jpoimboe@kernel.org> wrote:
>=20
> On Wed, Aug 28, 2024 at 10:23:50AM +0800, Wardenjohn wrote:
>> One system may contains more than one livepatch module. We can see
>> which patch is enabled. If some patches applied to one system
>> modifing the same function, livepatch will use the function enabled
>> on top of the function stack. However, we can not excatly know
>> which function of which patch is now enabling.
>>=20
>> This patch introduce one sysfs attribute of "using" to klp_func.
>> For example, if there are serval patches  make changes to function
>> "meminfo_proc_show", the attribute "enabled" of all the patch is 1.
>> With this attribute, we can easily know the version enabling belongs
>> to which patch.
>>=20
>> The "using" is set as three state. 0 is disabled, it means that this
>> version of function is not used. 1 is running, it means that this
>> version of function is now running. -1 is unknown, it means that
>> this version of function is under transition, some task is still
>> chaning their running version of this function.
>=20
> I'm missing how this is actually useful in the real world.  It feels
> like a solution in search of a problem.  And it adds significant
> maintenance burden.  Why?
>=20
> Do you not have any control over what order your patches are applied?
> If not, that sounds dangerous and you have much bigger problems.
>=20
> This "problem" needs to be managed in user space.
>=20
> --=20
> Josh

Hi, Josh.

First, introducing feature "using" is just a state of one klp_function =
is using or not in the system.
I think this state will not bring significant maintenance burden, right?

And then, this feature can tell user that which function is now running =
in this system. As we know, livepatch enable many patches for one =
function, and the stack top function of target function is the "using" =
function. Here will bring us some questions:=20
1. Since we patch some patches to one function, which version of this =
function A is my system exactly now using?=20
2. One patch may contains many function fixes, the "using" version of =
target function belongs to which patch now?=20
Livepatch now cannot tell us this information, although livepatch can do =
it.

In the scenario where multiple people work together to maintain the same =
system, or a long time running system, the patch sets will inevitably be =
cumulative. I think kernel can maintain and tell user this most accurate =
information by one sysfs interface.

A real case I met have been shown in the previous mail to explain the =
use in real world.

At the process I introduce this feature, we found that the function of =
klp_find_ops can be optimized. If we can move klp_ops structure into =
klp_func, we don't need to maintain one global list again. And if we =
want to find an klp_ops, we just need to get the klp_func (which we will =
already have). This will be a nice efficiency improvement.

Regards.
Wardenjohn.





