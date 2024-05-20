Return-Path: <live-patching+bounces-279-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 85BBD8C999F
	for <lists+live-patching@lfdr.de>; Mon, 20 May 2024 10:01:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3F39A281948
	for <lists+live-patching@lfdr.de>; Mon, 20 May 2024 08:01:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1CEB61B7F4;
	Mon, 20 May 2024 08:01:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="JYRRQFeP"
X-Original-To: live-patching@vger.kernel.org
Received: from mout.web.de (mout.web.de [212.227.15.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC707EAF1;
	Mon, 20 May 2024 08:01:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716192068; cv=none; b=r2tpzdGJHrHoA5SdwoyyjKYnmypt1jTTkEWFfF9EhY0KDM6W3UEJYSp+UI93eUfZVhDpJLFZFdeXTTRFhWSnCBsQNc7z7BTwPme8KVK3d8Di8YRZCyjp6bR9zyOcwN/XSH2VLfGrIEfl/b8qzOQ8ZeEjOtmFg6kJeHoe4SCQoDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716192068; c=relaxed/simple;
	bh=HXoQhPqpAkaWlPvx77/Pe7iK4py1z16RYmHwOBdQZ2A=;
	h=Message-ID:Date:MIME-Version:To:Cc:References:Subject:From:
	 In-Reply-To:Content-Type; b=aWlORHQLaqEuZQY6ZcxKYikcev1KYZ2MZEXSX5PWe6MFdsnHeSBWjyh/lS4dW8Zb288ZYmfGv8XAVVnr5KgORi8UJEK4WQzyyQN/rKypcTUE0qddTtydQL8NyeV45vIWJxsfZDvbImfx+ORByudbwmWs/BiDUx/UytmOOJ9o6No=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=JYRRQFeP; arc=none smtp.client-ip=212.227.15.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1716192042; x=1716796842; i=markus.elfring@web.de;
	bh=m1O7qNjpXbTiSLCciZWoL6HuYyWekxoXYSN0Bs0YSVk=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:To:Cc:References:
	 Subject:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 cc:content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=JYRRQFeP0/4DMi3qsoF1n3FfHCwGxDwcKsyqbBcBn9SV8qUHBAGiF4tO51y9XjuV
	 ZAskPOtGuwjEZF8X/MGsd9MKJ3kd0f7gsSJ/levuu/OoxzHkO2B23MkdlA/MIWIPF
	 JqE03HK6Id18+KCJsnxM5sp0yAU26yp6ZN4gZWCpKzgDirB2jyn8kxzyyPzcDi9yt
	 Ar9TDKuXO9D72sltOGpB2Lq4aEE/apnSisodYkSHJcrP0MXyFMc/Ol6Yr4WBEEdeO
	 lhZ7ykS333jIqDMJhb7JRnMStuxVMxYXAUpf6F3xa/V+vsAO375QsFRNSxP+2qQLP
	 q6dGZ2Rs7ZOtLg+CyA==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.21] ([94.31.82.95]) by smtp.web.de (mrweb005
 [213.165.67.108]) with ESMTPSA (Nemesis) id 1N1Lwd-1sWaOX2lcB-00udIW; Mon, 20
 May 2024 10:00:42 +0200
Message-ID: <eb464408-5567-4130-b899-90ba9756adc1@web.de>
Date: Mon, 20 May 2024 10:00:27 +0200
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: Wardenjohn <zhangwarden@gmail.com>, live-patching@vger.kernel.org,
 kernel-janitors@vger.kernel.org, Jiri Kosina <jikos@kernel.org>,
 Joe Lawrence <joe.lawrence@redhat.com>, Josh Poimboeuf
 <jpoimboe@kernel.org>, Miroslav Benes <mbenes@suse.cz>,
 Petr Mladek <pmladek@suse.com>
Cc: LKML <linux-kernel@vger.kernel.org>
References: <20240520005826.17281-1-zhangwarden@gmail.com>
Subject: Re: [PATCH] livepatch: introduce klp_func called interface
Content-Language: en-GB
From: Markus Elfring <Markus.Elfring@web.de>
In-Reply-To: <20240520005826.17281-1-zhangwarden@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:DPRWWeXpFsZQ3K8p/zgQYyEDxVHbzbT/j6qkc2eSiAfrb40kCD5
 Z3V1upljGa97oHvOt1Etual6WudEUL2Tf3HFY0ZyVJuEdv0GleLOcRJb4clI+YDTTr66fPJ
 y1vYPfwTt2eGCjNB+H6KJf7QKFW/y8eFwoNXKVHF47gKKs/JwV7T8sxWcAp3jq0mBOiOHVT
 p2bCZMPnn8mDt/Atys3cA==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:2fVKSG8kbUc=;Yc9XRMoFlr+JvngYg8kDNyIu42d
 myrlfj1TUqSklkp8aKjC+xn6RtDf7mvqPN7/BSLc6EsFxonT1y5zdSt2rPtbXspqwx2G/+r6m
 VNNvJkbm/TRF6TmeWh5x0mlp+wmyCz2oxTiujdrOXsaEWwcid3OqOdj//GoUziUV6TOA9+ZNo
 RNoPj9qQf/JzgvNHQm9QCLIEw7aFq8vQ0IFUziiLmIKliRDGcAc4SqP3rCpYeoVOgbTKLXNTt
 rlsW5FWuJqNVwhyaSHszUZZBei/+KkApPssS1kpkIPVjPc5+o6JoEGdw1LJ3hjvaZIMMviDLJ
 UMggv8BRS8dBrBDEqrBqSIUvyjEZkKVs17g2MFkIXlVdkK9gqvksAvHJX20ZQ2L+nT1I7pA//
 A03nYNzFAftVXpm75/D8oOBVzH8jwx9pDn/OSbU+5xxTiM2q0T9VpHuKHNdVaH2mJVF320z+B
 wO8fbx4w+67l+apQBAPP8q2F82GptqLa7jjGihyERVx6p2l434tUE4ff8rde05beGpKSql5Sp
 mn/goIPYveDBm7ja9RfsF3k01ryaCmdG8j45k83gqz8kGKIU6wBZgLyWki8TEqWDHtgO/gxTf
 e/ctsUNtW0NulgM9FvAP3mU0h2YPIoJIPjzPa743EGd/oYWBwbJdS7yMJ7xSFaYQ99te9QbIv
 96a+sZev8Jkg9RG/AzNV1X0KrCZMk78w/bm9nPl5YdS51UFpsjoVrRk+pHfV0GpGs4PRCJN4Q
 60ypiW7ROGMmxPut+Zcb6YpwvGLTCjyOwloaoY7cHa0lxA8GMOta8xKvwTeMj9fwO1+K+FlDY
 SD6YbM7PvwZz62SGHJ0Buc6WOymOUe9pxNb2ErMOoCrgs=

Please add a version identifier to the message subject.


=E2=80=A6
> If the patched function have bug, it may cause serious result
> such as kernel crash.

Wording suggestion:

   If the patched function has a bug, it might cause serious side effects
   like a kernel crash.


> This is a kobject attribute of klp_func. Sysfs interface named
>  "called" is introduced to livepatch =E2=80=A6

Under which circumstances will imperative wordings be applied for
another improved change description?
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Do=
cumentation/process/submitting-patches.rst?h=3Dv6.9#n94


=E2=80=A6
> ---
>  include/linux/livepatch.h |  2 ++
=E2=80=A6

You may present version descriptions behind the marker line.
Would you like to indicate any adjustments according to your change approa=
ch
(from yesterday)?
https://lore.kernel.org/lkml/20240519074343.5833-1-zhangwarden@gmail.com/

Regards,
Markus

