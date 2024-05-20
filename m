Return-Path: <live-patching+bounces-280-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B35948C9A67
	for <lists+live-patching@lfdr.de>; Mon, 20 May 2024 11:34:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 791E728210A
	for <lists+live-patching@lfdr.de>; Mon, 20 May 2024 09:34:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C65A81CAB0;
	Mon, 20 May 2024 09:34:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KaXg0zs7"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-oa1-f43.google.com (mail-oa1-f43.google.com [209.85.160.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55192468E;
	Mon, 20 May 2024 09:34:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716197669; cv=none; b=VILilq0h1zKsouxozy3qthGN7W18wtMcSeHOpGMaVYzIoRm4/WafbfjYA13x95jFz+SRuDVKLf37ZnmU5QrbMpSIZsrPzlHgQDvaL8Gq1KEJjj6EsHme7i0BcPQY13Sj7gSwNT6N6KcMBNdcrowkbuS7G39hHTsC5vgP7XeMVbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716197669; c=relaxed/simple;
	bh=Zjn1F07rtTniBpTF31UU+SvXqEBiG8xGCtaMgsAMhmo=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=G0GO2Ybtgs3Gk//udFg3phGD5fJBYH72QIX/mdGwPvzkSMD6b7Yw+M9zq/kfh+BVe1eSk+bIHsimE9A0kEQS4rss4vMK2avS167fzTPF2jtKzyTmFz8t4qPS/wYuGFozeJnd3bbuugevSdJnWgrMtBCzUB65r27NYGOy9iPdQ1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KaXg0zs7; arc=none smtp.client-ip=209.85.160.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oa1-f43.google.com with SMTP id 586e51a60fabf-23d477a1a4fso2019745fac.3;
        Mon, 20 May 2024 02:34:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1716197667; x=1716802467; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4eZ825pnSzBKL6Z+MD7+agBNrXJhAhcfuzn1pCYFodw=;
        b=KaXg0zs7c1kS7NLLfsg206bYjY+5T8NVIgKhvwB3i9k+7KIfJ2bjMxuWu67pD85BAk
         Zr2ZQ9per9aGw+/KPa31Y5p/JbZTFOqRD2EaUgtTWHW1iu0cmYvYaKSR9Jup22/h4Sg2
         NkGmkoBSDuLBUmEoBK1DHf4DLdUoo+G15/G6+OQC2LC0Us6hnkhUCoYanX7S6SSa9M2b
         bWSL+GUudwkqjUP4+V98zMSXeiRCdL25xWSLynzCr3Hdyjrz1RqHiGF2YfjrduaOT3Bn
         0wVnHJMMGdzus5AnctX2fMYu7o8u03PkdnZbBzqwh6fSxF92zg2N1wuAp8lDXsDebL4V
         so7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716197667; x=1716802467;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4eZ825pnSzBKL6Z+MD7+agBNrXJhAhcfuzn1pCYFodw=;
        b=ZV64LHLjSnXXz4r6fB/wflGxXXN7/Vj8Bio3ks6MNDQhx7zOljhzSHbDhoquRzISS4
         Da+5uxvFbprtRhlAdnrAKYOtA3dgkAaUTolByRT3q2JwJDTFwhMvhTV9KjyyoZJDk5TS
         DYefDCSuB+++SiGCJ1uizKiBy5qNLFVADY2lQ3hUwLWz1L2uCSLNcZnPlMO6qDE4EYq1
         KUmYZwgCvf3h2eyHYPUwGg1P17ikVR9+VWxbUd0ToS7WEIPSlHuA3HlDYOSzxAgqFLnE
         SghxDCogPkwMd1xUdxrEqw3ULbarOxgztG8lgGDCwxmHatnashQ4UsISNA9QTWBcuzBJ
         Y/bw==
X-Forwarded-Encrypted: i=1; AJvYcCUzPHw4ZqHwj31Lar9XKKWBepiu/iwnNgwT3DIiAtRB09Kd7tiBGJLtAXY7EbkHeYHeOriWOUQNPEeiRoJPQP2zlawYPgiF4CnVB5Pxqq/tPkYcOiBMOY/NdReSK7X/it0BAEMMYZZ9IJSuikgD
X-Gm-Message-State: AOJu0YwuD/YTH6IAW73OJbQ6IsPVgJPX/Hqz0zhr1rUVOukhoM0r8kWW
	9oFCS0zFeFbp72dYfefSVx5V/ABqJwrJn5o64LKIqq7m9NkqaV+i
X-Google-Smtp-Source: AGHT+IHZpWo5mmzw/yMUCdQ4hm6LqOJHS0i7yylA7xFh8dTisfm7nyBUhZxtLmWQ2W4TSBBDIA7TnQ==
X-Received: by 2002:a05:6871:207:b0:221:96b2:5a4e with SMTP id 586e51a60fabf-241731118d4mr40095508fac.58.1716197667424;
        Mon, 20 May 2024 02:34:27 -0700 (PDT)
Received: from smtpclient.apple ([47.246.179.0])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-63411346c12sm16640737a12.80.2024.05.20.02.34.24
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 20 May 2024 02:34:26 -0700 (PDT)
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3774.500.171.1.1\))
Subject: Re: [PATCH] livepatch: introduce klp_func called interface
From: zhang warden <zhangwarden@gmail.com>
In-Reply-To: <eb464408-5567-4130-b899-90ba9756adc1@web.de>
Date: Mon, 20 May 2024 17:34:12 +0800
Cc: live-patching@vger.kernel.org,
 kernel-janitors@vger.kernel.org,
 Jiri Kosina <jikos@kernel.org>,
 Joe Lawrence <joe.lawrence@redhat.com>,
 Josh Poimboeuf <jpoimboe@kernel.org>,
 Miroslav Benes <mbenes@suse.cz>,
 Petr Mladek <pmladek@suse.com>,
 LKML <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <7F8BE9D1-D68E-4560-8D5C-9025122963B4@gmail.com>
References: <20240520005826.17281-1-zhangwarden@gmail.com>
 <eb464408-5567-4130-b899-90ba9756adc1@web.de>
To: Markus Elfring <Markus.Elfring@web.de>
X-Mailer: Apple Mail (2.3774.500.171.1.1)

OK, I will try to optimize my description after the patch is reviewed. I =
am sure there are something still need to be fix for that patch.

> On May 20, 2024, at 16:00, Markus Elfring <Markus.Elfring@web.de> =
wrote:
>=20
> Please add a version identifier to the message subject.
>=20
>=20
> =E2=80=A6
>> If the patched function have bug, it may cause serious result
>> such as kernel crash.
>=20
> Wording suggestion:
>=20
>   If the patched function has a bug, it might cause serious side =
effects
>   like a kernel crash.
>=20
>=20
>> This is a kobject attribute of klp_func. Sysfs interface named
>> "called" is introduced to livepatch =E2=80=A6
>=20
> Under which circumstances will imperative wordings be applied for
> another improved change description?
> =
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Do=
cumentation/process/submitting-patches.rst?h=3Dv6.9#n94
>=20
>=20
> =E2=80=A6
>> ---
>> include/linux/livepatch.h |  2 ++
> =E2=80=A6
>=20
> You may present version descriptions behind the marker line.
> Would you like to indicate any adjustments according to your change =
approach
> (from yesterday)?
> =
https://lore.kernel.org/lkml/20240519074343.5833-1-zhangwarden@gmail.com/
>=20
> Regards,
> Markus


