Return-Path: <live-patching+bounces-851-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1E1759D1D77
	for <lists+live-patching@lfdr.de>; Tue, 19 Nov 2024 02:44:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D225428285B
	for <lists+live-patching@lfdr.de>; Tue, 19 Nov 2024 01:44:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E492D12F399;
	Tue, 19 Nov 2024 01:44:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kRdxe+/o"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D6CD8C0B;
	Tue, 19 Nov 2024 01:44:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731980656; cv=none; b=KfNrHKZEei9ZD4c0ENmele3Ywid3w8kmW+TCbrN48sO44Nrz26w1V9rH6GTbypQ5muU6fkJ7T5ltoGiLPm0k1uNS8Qbey41JxbgAO/JDlcZN5ohMDv7zD96runQ+Bu1P/0v+RwaBy1ClMlHyySSCpaO3m0tWs45kug9Ovnzvalc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731980656; c=relaxed/simple;
	bh=R1qQ0OBQz6CUZbICIx1Jgof2nor6NIrbN2iL+Kv4Iss=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=eF/EdBcIpioHKsDpSvZpaPtmVjKlmQInti5v3nJ4FufIFkYjJKneAffEjqmvxTEcRenuMX5tS+ot3TqOdUP27N/hB161eG8ZO6DThWXvRJrcOxY0QHFCG6ILE7IjgC4kIIgeFL93TPTbKmB2vKfATh5S/Ct/1IiUnGxM+QrUuvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kRdxe+/o; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-20cb47387ceso3237695ad.1;
        Mon, 18 Nov 2024 17:44:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731980653; x=1732585453; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6TLGZPhgwiSdTuoKO9EIOhX+7x+wgHfPfCEdlENWql4=;
        b=kRdxe+/oWM72BSHOOAqNjFVH9JHNDsq7mL8ToCrJJwB9d631NbdUrbouRb+UiyZY81
         ljVpT/h9gUjNSHJsK/fRJvETkYCFizUxFCaZCg4uh4cYkKkoCMKwXhwXLkC549SsKTZi
         q8R2LCG4kgajXDeA8/pAiHKoTadfdzzatWkFQf0cmVNg9+MR1URnQNoGYqVHaqriddtT
         hNVEDQwdX5rXRJps5mxvoG3XpkmECef8gzff8S3gxSoZtFbmRDRq7m2PH2LbYePnVPAD
         S9s3KZC/pr8z9q+kweJ7cusUmg6J8lGz4fLG4dRa1EdQekg02tnv3JOoWc1pX+BmzX+9
         edHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731980653; x=1732585453;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6TLGZPhgwiSdTuoKO9EIOhX+7x+wgHfPfCEdlENWql4=;
        b=LUsckyVXoSytBIwxb0o/PKCOb2uwYRi0YcRAiyU//AdZU5bg2Y+CN/NjXCPtEEXR+y
         C3yBxhLWZ1tYdfUHXkvJ+IIMoL0rn/OjjbIiWbxaJGPcDCWK1mvuNlxpsmc0dAo1fbgs
         Y+5M3vHpt92A8wxoRcoRUAv3/+wDs54q0rE259fA5x/VLgE3K4x1QJBvwKmh+JQst6yW
         MTBHXT4bYfclu0kEDT6YMFNR+jD9J+UrBb2EqJKaeWOjgZsjV2o+HZLeu2bZhdFYeOck
         +k5vCH9CQ75aHvadjakWzy0WdLgupZX/Y8u5ShGfa/uO8WL00t+s8WenkdT4XYe+5dGd
         Q8eg==
X-Forwarded-Encrypted: i=1; AJvYcCUU0DtkWJtfKEDlBfRIzEuGUG8jqyxHgcmGWxRO/6FMrYjbLie2ux+Hkfn1JChm75LhzghzWunlBArQWJyyvLwQ@vger.kernel.org, AJvYcCUhf/QuDv+um6sovVPElJ6vXQ7Jc/k3pzOr69RbqLpHnKiE2e9jQHi3W6QsDuUZNP1Ou7ninAJX8DesWLc=@vger.kernel.org, AJvYcCUiTyaQ8DQlLAxEzfOsxecjghsc4H+kihMxxMB9IdhG4GuDo3/pJ+ho76Nk/NLkPFAAC6BDLN3f@vger.kernel.org, AJvYcCUpe7MmNoHeD+ko7v3lCmrgJPmlyZ0o35XJsWdZ6ktIHmLz5vGUrYX10ctUS+xfwirCkZ26/023VZ45A2XP@vger.kernel.org, AJvYcCUwEL/1dRAdNcilO8jQAYSQlaDi4XcDvU3IkP5hBEDPmjUEH5P2Es0sNFrKCkjMHAP1jF0TK+VQDTNFGpIWlQ==@vger.kernel.org, AJvYcCVZqNh1hY2Ba9cAE/MsL9Ous1pdie0DJzPY7vOSfrJ/Zn/xBNexNlK0P46SSr+rgBhK3J/4b3JC/rWK@vger.kernel.org, AJvYcCVksf6ZoypxieCEKzGz1kA2IfFUi0lBzhZ66SrgKZOn95zuSgitsjuD4CMsz/ellZkGKSeq+RGqMhrZH6A=@vger.kernel.org, AJvYcCVvcQMn8DzPL91B1qFSnNgUjKfv41XrUneDXY1ncpPaGr0kXKgqIVdpIGMHH37PbKzpHEDmomJqkJMriw==@vger.kernel.org, AJvYcCWQpZ3PMi3KvKWEb9VUeuDMibxA97iuzi9RImvKGGJysgLg3VItDT13PycPzXLeFCL3a0iKrL/IIA7BBGfqrMOP@vger.kernel.org, AJvYcCWqPebWEWvO
 TRhyz2vajRYvV3qjJTl+ox+wTwfjrlOGHdJBgixm+d+6Xn8eOzJbgf4lLQmWfxWikjMgAQ==@vger.kernel.org, AJvYcCWt2jF65xK7QSjQEymY23W7sAC8RQ2Kuw1YUqP1Dr/c9ARvZKDbu44rqv+rcIYCINvz/gpEpd0NSBdRwvBB1ek=@vger.kernel.org
X-Gm-Message-State: AOJu0YyBvoNMEoRPtJeri/z7snPp8hU3EUt+JXrJnieYOeGYKorNiBNJ
	st13yqQ0kWqsItJXSaUczWIgTwmWdxmPCpiMfKZgNjHnDGYx7gUK
X-Google-Smtp-Source: AGHT+IGKOuuVyAvdbfIttKIxJSv7PNCbNBMgaHYEIodVhJO4YNPmnFai9XI15Qs6QZqqMPXdK5RTjA==
X-Received: by 2002:a17:903:186:b0:212:46c2:632e with SMTP id d9443c01a7336-21246c26707mr25423135ad.15.1731980653295;
        Mon, 18 Nov 2024 17:44:13 -0800 (PST)
Received: from smtpclient.apple ([198.11.178.15])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-211d0f6182bsm62977715ad.277.2024.11.18.17.43.45
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 18 Nov 2024 17:44:12 -0800 (PST)
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3774.500.171.1.1\))
Subject: Re: [PATCH v2 19/21] livepatch: Convert timeouts to secs_to_jiffies()
From: zhang warden <zhangwarden@gmail.com>
In-Reply-To: <96f3b51b-c28c-4ea8-b61e-a4982196215f@linux.microsoft.com>
Date: Tue, 19 Nov 2024 09:43:32 +0800
Cc: Petr Mladek <pmladek@suse.com>,
 Christophe Leroy <christophe.leroy@csgroup.eu>,
 Pablo Neira Ayuso <pablo@netfilter.org>,
 Jozsef Kadlecsik <kadlec@netfilter.org>,
 "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>,
 Simon Horman <horms@kernel.org>,
 Julia Lawall <Julia.Lawall@inria.fr>,
 Nicolas Palix <nicolas.palix@imag.fr>,
 Daniel Mack <daniel@zonque.org>,
 Haojian Zhuang <haojian.zhuang@gmail.com>,
 Robert Jarzmik <robert.jarzmik@free.fr>,
 Russell King <linux@armlinux.org.uk>,
 Heiko Carstens <hca@linux.ibm.com>,
 Vasily Gorbik <gor@linux.ibm.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Sven Schnelle <svens@linux.ibm.com>,
 Ofir Bitton <obitton@habana.ai>,
 Oded Gabbay <ogabbay@kernel.org>,
 Lucas De Marchi <lucas.demarchi@intel.com>,
 =?utf-8?Q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
 Rodrigo Vivi <rodrigo.vivi@intel.com>,
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
 Maxime Ripard <mripard@kernel.org>,
 Thomas Zimmermann <tzimmermann@suse.de>,
 David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>,
 Jeroen de Borst <jeroendb@google.com>,
 Praveen Kaligineedi <pkaligineedi@google.com>,
 Shailend Chand <shailend@google.com>,
 Andrew Lunn <andrew+netdev@lunn.ch>,
 James Smart <james.smart@broadcom.com>,
 Dick Kennedy <dick.kennedy@broadcom.com>,
 "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 =?utf-8?Q?Roger_Pau_Monn=C3=A9?= <roger.pau@citrix.com>,
 Jens Axboe <axboe@kernel.dk>,
 Kalle Valo <kvalo@kernel.org>,
 Jeff Johnson <jjohnson@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Jack Wang <jinpu.wang@cloud.ionos.com>,
 Marcel Holtmann <marcel@holtmann.org>,
 Johan Hedberg <johan.hedberg@gmail.com>,
 Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Florian Fainelli <florian.fainelli@broadcom.com>,
 Ray Jui <rjui@broadcom.com>,
 Scott Branden <sbranden@broadcom.com>,
 Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
 Xiubo Li <xiubli@redhat.com>,
 Ilya Dryomov <idryomov@gmail.com>,
 Josh Poimboeuf <jpoimboe@kernel.org>,
 Jiri Kosina <jikos@kernel.org>,
 Miroslav Benes <mbenes@suse.cz>,
 Joe Lawrence <joe.lawrence@redhat.com>,
 Jaroslav Kysela <perex@perex.cz>,
 Takashi Iwai <tiwai@suse.com>,
 Lucas Stach <l.stach@pengutronix.de>,
 Russell King <linux+etnaviv@armlinux.org.uk>,
 Christian Gmeiner <christian.gmeiner@gmail.com>,
 Louis Peens <louis.peens@corigine.com>,
 Michael Ellerman <mpe@ellerman.id.au>,
 Nicholas Piggin <npiggin@gmail.com>,
 Naveen N Rao <naveen@kernel.org>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 netfilter-devel@vger.kernel.org,
 coreteam@netfilter.org,
 netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 cocci@inria.fr,
 linux-arm-kernel@lists.infradead.org,
 linux-s390@vger.kernel.org,
 dri-devel@lists.freedesktop.org,
 intel-xe@lists.freedesktop.org,
 linux-scsi@vger.kernel.org,
 xen-devel@lists.xenproject.org,
 linux-block@vger.kernel.org,
 linux-wireless@vger.kernel.org,
 ath11k@lists.infradead.org,
 linux-mm@kvack.org,
 linux-bluetooth@vger.kernel.org,
 linux-staging@lists.linux.dev,
 linux-rpi-kernel@lists.infradead.org,
 ceph-devel@vger.kernel.org,
 live-patching@vger.kernel.org,
 linux-sound@vger.kernel.org,
 etnaviv@lists.freedesktop.org,
 oss-drivers@corigine.com,
 linuxppc-dev@lists.ozlabs.org,
 Anna-Maria Behnsen <anna-maria@linutronix.de>
Content-Transfer-Encoding: quoted-printable
Message-Id: <99755FD2-270C-4122-8A22-6C73A81028F6@gmail.com>
References: <20241115-converge-secs-to-jiffies-v2-0-911fb7595e79@linux.microsoft.com>
 <20241115-converge-secs-to-jiffies-v2-19-911fb7595e79@linux.microsoft.com>
 <718febc4-59ee-4701-ad62-8b7a8fa7a910@csgroup.eu>
 <Zzsfuuv3AVomkMxn@pathway.suse.cz>
 <96f3b51b-c28c-4ea8-b61e-a4982196215f@linux.microsoft.com>
To: Easwar Hariharan <eahariha@linux.microsoft.com>
X-Mailer: Apple Mail (2.3774.500.171.1.1)



> On Nov 19, 2024, at 02:18, Easwar Hariharan =
<eahariha@linux.microsoft.com> wrote:
>=20
> On 11/18/2024 3:06 AM, Petr Mladek wrote:
>> On Sat 2024-11-16 11:10:52, Christophe Leroy wrote:
>>>=20
>>>=20
>>> Le 15/11/2024 =C3=A0 22:26, Easwar Hariharan a =C3=A9crit :
>>>> [Vous ne recevez pas souvent de courriers de =
eahariha@linux.microsoft.com. D=C3=A9couvrez pourquoi ceci est important =
=C3=A0 https://aka.ms/LearnAboutSenderIdentification ]
>>>>=20
>>>> Changes made with the following Coccinelle rules:
>>>>=20
>>>> @@ constant C; @@
>>>>=20
>>>> - msecs_to_jiffies(C * 1000)
>>>> + secs_to_jiffies(C)
>>>>=20
>>>> @@ constant C; @@
>>>>=20
>>>> - msecs_to_jiffies(C * MSEC_PER_SEC)
>>>> + secs_to_jiffies(C)
>>>>=20
>>>> Signed-off-by: Easwar Hariharan <eahariha@linux.microsoft.com>
>>>> ---
>>>>  samples/livepatch/livepatch-callbacks-busymod.c |  2 +-
>>>>  samples/livepatch/livepatch-shadow-fix1.c       |  2 +-
>>>>  samples/livepatch/livepatch-shadow-mod.c        | 10 +++++-----
>>>>  3 files changed, 7 insertions(+), 7 deletions(-)
>>>>=20
>>>> diff --git a/samples/livepatch/livepatch-callbacks-busymod.c =
b/samples/livepatch/livepatch-callbacks-busymod.c
>>>> index =
378e2d40271a9717d09eff51d3d3612c679736fc..d0fd801a7c21b7d7939c29d83f9d993b=
adcc9aba 100644
>>>> --- a/samples/livepatch/livepatch-callbacks-busymod.c
>>>> +++ b/samples/livepatch/livepatch-callbacks-busymod.c
>>>> @@ -45,7 +45,7 @@ static int livepatch_callbacks_mod_init(void)
>>>>  {
>>>>         pr_info("%s\n", __func__);
>>>>         schedule_delayed_work(&work,
>>>> -               msecs_to_jiffies(1000 * 0));
>>>> +               secs_to_jiffies(0));
>>>=20
>>> Using secs_to_jiffies() is pointless, 0 is universal, should become
>>> schedule_delayed_work(&work, 0);
>>=20
>> Yes, schedule_delayed_work(&work, 0) looks like the right solution.
>>=20
>> Or even better, it seems that the delayed work might get replaced by
>> a normal workqueue work.
>>=20
>> Anyway, I am working on a patchset which would remove this sample
>> module. There is no need to put much effort into the clean up
>> of this particular module. Do whatever is easiest for you.
>>=20
>> Best Regards,
>> Petr
>=20
> If we're removing the module, I'll drop it from the series. Just to
> clarify, do you mean to remove all of samples/livepatch/* or some
> particular file(s)?
>=20
> Thanks,
> Easwar
>=20

Hi Easwar!

I think Petr is going to remove just this module away. Anyway, I don't =
think
removing all of them is a good idea.

Thanks.
Wardenjohn.=20


