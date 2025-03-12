Return-Path: <live-patching+bounces-1271-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 40545A5D43C
	for <lists+live-patching@lfdr.de>; Wed, 12 Mar 2025 02:53:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C27153B5EBE
	for <lists+live-patching@lfdr.de>; Wed, 12 Mar 2025 01:53:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F2AD1411EB;
	Wed, 12 Mar 2025 01:53:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="b9QHqrJ1"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57D9713C9D4
	for <live-patching@vger.kernel.org>; Wed, 12 Mar 2025 01:53:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741744399; cv=none; b=JuxSchx7b8vgwTfjWL3o07lAmfZ3FYhGUDussCARYHwickuWbPBHLv8/pdZuuiUXMRgHznquJaiLJs4fUVoYAklls4Uog/wJtk5fM6ePBKWNuRDkMhveY605+0BZOIj6e5xSkY3GqD7esrdOgTrCU4EJ0v0RijCyQmEENLq8oOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741744399; c=relaxed/simple;
	bh=VYGt35qTVOsA6c9AnrReg4RiVqScLvZKoC54q0LPeag=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ISidLOzW6rmQrLAfW1zT9z7prWxvd2ghnZjkMKNx/mk2ZAemVxuLiTewsU8SzVmZBv6p4FQbsuShcNK1N4AVvvDOzgRqsj/BOhkDkIschUQA7Gft7DcyLbMV92dZqsPyDZY7Jgc44viFhXoQT3hxouIRrt7sAohTHgMHDyMgAq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=b9QHqrJ1; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-3914bc3e01aso1494598f8f.2
        for <live-patching@vger.kernel.org>; Tue, 11 Mar 2025 18:53:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1741744395; x=1742349195; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=VYGt35qTVOsA6c9AnrReg4RiVqScLvZKoC54q0LPeag=;
        b=b9QHqrJ1rYoFNf+Pef18yOp6P3vh2yrj8jXuDgaEZzu5ZuQzgz2SnxjXDBrDX55wJT
         fW8qVh3meR36RrnANxUTC/o+eAbvOMar35AgZlLz5EfmBPmUuwabeD1xwzl5mltgh0LX
         Dqqrgm5qnfqTPo6gTW+wI682V7VMtsCR10HAJfSpdbm3CXKObU1Csj1SBnLixalNC0V7
         dUpXO2ToInrOIeMaP2KIIhKd1RD44Gj8cKRzNIJOKs4ogqbj6mO3Ga7a8ufjrCvjjrrS
         jm+emfxi2zV2qe0NHfvpXsKRdDK/tyIU4vH3hewF2QE4wAZQkisJ375b8gljg0ONtcVR
         tOpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741744395; x=1742349195;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=VYGt35qTVOsA6c9AnrReg4RiVqScLvZKoC54q0LPeag=;
        b=AWsSlpTLFNBK5ewDrRgcPoWbk1pTLNqLub+F8bPZsuopoSKjfjL45bWcK2NiDZNp5P
         Z/w3VX+mv+5U4BxecQBmvfbP0E8xSz2zvKiLY+Aj77kY3l4b1cWtm/wynr5tz8tbzsDA
         IE7w/U4VVPaVBI89Gxm9/Qvm4yHzKtFLGF731KwrWe0jOueONLZ0cXA1cM6ZVL+m8mjT
         2quTJHOA2YZZK0R75O719hXuF2bOIdvlplWE0tvh+s4UWEu5j7+yj7UEi222178lbOyV
         ryqJ3zTWYXYLZC4iwipLklYIbIG438c1cIpdhtHXFqd7MQeyH3Y/E67VCH9nY+gTWqJU
         ZcIw==
X-Gm-Message-State: AOJu0YxMWJRDLFZUhFCiR2rsezRCf4Shl9njZBzR5K0/slAzdYa291sa
	fdVQfuDHq9makCl3ez6krUIzp6ehGq5JSWndmhfNaIjmJgbKkKdN/uIlfKpsNjY=
X-Gm-Gg: ASbGnctZfxwZ8Z4IF/2ZyhLVV8nG5UkCfkxc+lKAAx+JAezBmMha/GHtJTsUTpfEJwV
	X0vOEXmWZwlGEBzC+aLOvQRZinrJINySSfvPHze+BnD4p2LMK9S1YFP/3O/GCkbcdx8QIaroF81
	ndGn0xc66A4EnAQYCAAXbeEtLSRqyYW1PX5bGMbKU0yWeK1eOzG2PvXxDHFRVqJ7eKTV+wdM0RP
	+7NFuHwVbKaEasxOXoCMhcuDh2v6z9qfCeHGenGyltn7niC4ycmlUI8rmm2VMB17zEvvIAyq8jm
	KslanvuDu15vYsk1BluzKYDz72MiA189Ruboi1k/3OWwc1EOZg3PriI3IIyvlXfvebEO6sjdizK
	bumOhwbs=
X-Google-Smtp-Source: AGHT+IG88cW0bSsvG/lLs3Zu0XcM2ByGWX+m4X6L8KGTkFm3WjWL58mXweufMtUVmgd7CjozBN1Kaw==
X-Received: by 2002:a5d:6d8c:0:b0:391:275a:273f with SMTP id ffacd0b85a97d-39132d062ffmr12511792f8f.4.1741744395630;
        Tue, 11 Mar 2025 18:53:15 -0700 (PDT)
Received: from ?IPv6:2804:5078:802:e100:58f2:fc97:371f:2? ([2804:5078:802:e100:58f2:fc97:371f:2])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22410abc694sm104552195ad.257.2025.03.11.18.53.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Mar 2025 18:53:15 -0700 (PDT)
Message-ID: <fe554a6efe55d7a9fda58c3aebb56322f742b12d.camel@suse.com>
Subject: Re: [PATCH 0/2] selftests: livepatch: test if ftrace can trace a
 livepatched function
From: Marcos Paulo de Souza <mpdesouza@suse.com>
To: Filipe Xavier <felipeaggger@gmail.com>, Josh Poimboeuf
 <jpoimboe@kernel.org>,  Jiri Kosina <jikos@kernel.org>, Miroslav Benes
 <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>, Joe Lawrence
 <joe.lawrence@redhat.com>, Shuah Khan <shuah@kernel.org>
Cc: live-patching@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org, felipe_life@live.com
Date: Tue, 11 Mar 2025 22:53:10 -0300
In-Reply-To: <20250306-ftrace-sftest-livepatch-v1-0-a6f1dfc30e17@gmail.com>
References: <20250306-ftrace-sftest-livepatch-v1-0-a6f1dfc30e17@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.54.3 (by Flathub.org) 
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Thu, 2025-03-06 at 18:51 -0300, Filipe Xavier wrote:
> This patchset add ftrace helpers functions and
> add a new test makes sure that ftrace can trace
> a function that was introduced by a livepatch.
>=20
> Signed-off-by: Filipe Xavier <felipeaggger@gmail.com>
> ---
> Filipe Xavier (2):
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 selftests: livepatch: add new ftrace helpe=
rs functions
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 selftests: livepatch: test if ftrace can t=
race a livepatched
> function
>=20
> =C2=A0tools/testing/selftests/livepatch/functions.sh=C2=A0=C2=A0 | 45
> ++++++++++++++++++++++++
> =C2=A0tools/testing/selftests/livepatch/test-ftrace.sh | 35
> ++++++++++++++++++
> =C2=A02 files changed, 80 insertions(+)
>=20

Thanks for sending this new version! One interesting thing is that you
created a new patchset, instead of iterating on the same one, and this
triggered a bug on b4[1]!

You also missed the changelog since v2, but AFAICS you addressed all
comments from me, Joe and Petr, per [2].

For the two patches:

Reviewed-by: Marcos Paulo de Souza <mpdesouza@suse.com>

[1]: https://github.com/mricon/b4/issues/58
[2]:
https://lore.kernel.org/live-patching/b2637bad-9022-496a-9b83-0d348a6350b4@=
gmail.com/T/#m14bc5c118490c1b17e782a0f0173c1fb70d187c7

> ---
> base-commit: 848e076317446f9c663771ddec142d7c2eb4cb43
> change-id: 20250306-ftrace-sftest-livepatch-60d9dc472235
>=20
> Best regards,


