Return-Path: <live-patching+bounces-108-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D278A81E4E6
	for <lists+live-patching@lfdr.de>; Tue, 26 Dec 2023 05:52:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 43CAE282ABA
	for <lists+live-patching@lfdr.de>; Tue, 26 Dec 2023 04:52:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF8064AF7C;
	Tue, 26 Dec 2023 04:52:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AMUb1Hbw"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-ot1-f41.google.com (mail-ot1-f41.google.com [209.85.210.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84DF44AF76;
	Tue, 26 Dec 2023 04:52:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ot1-f41.google.com with SMTP id 46e09a7af769-6dbed9bb54eso609196a34.3;
        Mon, 25 Dec 2023 20:52:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1703566319; x=1704171119; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=XLmOglPALjr/Eavo/1Xi1Ed57HvzvrXo82CPHH8hSGk=;
        b=AMUb1HbwKFL/L+Vj6MTqkpxzwAQiIjIM9lNC/Z5jzi5astIbhQ4tlEcPzMNQWn8boU
         KZzXiJ+gpOsN1V0a6AFOYJVf7gx2l7cg7z9/y7MHNz/LSEMO9Xr8/Z0kYCwvr4+wLus3
         HSA5m4CunAlpxg4CKFenuyWz7Bo/TOsxJ4nE3KPQLoPHBuv9tzHaRcj6ADkK8UpCNn99
         t7Ijy9qnE2yilho71RN/ZxW65YL2bMGH+oOpaKaprgLY9pRtByUb+UkwkDRZxp8n66LM
         P16YRR7I4sprPkowahrGjF3iZ3RPELVajq3u96YoGWV+aYM5ePXPnfw3MrV8mrdsVr1O
         B7gA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703566319; x=1704171119;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XLmOglPALjr/Eavo/1Xi1Ed57HvzvrXo82CPHH8hSGk=;
        b=awNeKqdEoMdfNXsxEUPe2NUUutN7zRPqse5hRZmbt4IcdOAQ/LiIia4cfg2eBcDRgL
         reEFCP1hZH2uYwhGetss37e2z8oaYM5GOiw0QU7V8w7VwpSbxTzPxKMKZ93YfOUg3/nW
         zs41Vd5H4eW6MtfUteLrhVf8pBiuo/ljNBAxb57nCWDhWlnwNXOp98ZxO9+3R7umq78j
         XaV3Q6lk/G6yIs7ThPMxUbB0Y8EKJ3EZJ1L5qmZCsWhIY4CAGU4SuIMucOS1IoDVQV3f
         3Zzn+2+p8wIUWkp3jL/fq1/V4J85CzTyvrq794rs6eo/bV8b1x8Wlrah+ByEADDaQNBN
         FXbw==
X-Gm-Message-State: AOJu0YwWAUrRy7xLX9gq2vH/fIPFzzQ+O+SRa7NoVh6Nmx4FewvU/nN1
	wgz4TejGwG+yBjC02va4wko=
X-Google-Smtp-Source: AGHT+IG/JTrx8pHnMDu08slp/yMl1arkP/6FcgiO/M2e/EgKzSvSjvdFdHNFiSWZSkBvTxy8CEhKSg==
X-Received: by 2002:a05:6358:63aa:b0:174:fdd1:9eec with SMTP id k42-20020a05635863aa00b00174fdd19eecmr503262rwh.8.1703566319268;
        Mon, 25 Dec 2023 20:51:59 -0800 (PST)
Received: from archie.me ([103.131.18.64])
        by smtp.gmail.com with ESMTPSA id l17-20020a17090aaa9100b0028be5732f01sm9190426pjq.0.2023.12.25.20.51.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Dec 2023 20:51:58 -0800 (PST)
Received: by archie.me (Postfix, from userid 1000)
	id DF09D101CEC4B; Tue, 26 Dec 2023 11:51:53 +0700 (WIB)
Date: Tue, 26 Dec 2023 11:51:53 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Jonathan Corbet <corbet@lwn.net>, attreyee-muk <tintinm2017@gmail.com>,
	jpoimboe@kernel.org, jikos@kernel.org, mbenes@suse.cz,
	pmladek@suse.com, joe.lawrence@redhat.com
Cc: linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
	live-patching@vger.kernel.org
Subject: Re: [PATCH] Documentation/livepatch: Update terminology in livepatch
Message-ID: <ZYpb6Woh45ZnEvCP@archie.me>
References: <20231223205813.32083-1-tintinm2017@gmail.com>
 <87o7eg607d.fsf@meer.lwn.net>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="CoH5zxFFOOKX9bt+"
Content-Disposition: inline
In-Reply-To: <87o7eg607d.fsf@meer.lwn.net>


--CoH5zxFFOOKX9bt+
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Dec 23, 2023 at 03:08:54PM -0700, Jonathan Corbet wrote:
> attreyee-muk <tintinm2017@gmail.com> writes:
>=20
> > Update the sentence in livepatch.rst to: "Functions are there for a rea=
son. Take some input parameters, acquire or release locks, read, process, a=
nd write some data in a defined way."
> >
> > Signed-off-by: Attreyee Mukherjee <tintinm2017@gmail.com>
> > ---
> >  Documentation/livepatch/livepatch.rst | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> So this is a classic example of saying what you have done, but not why.
> What makes this a change that we want?

I think what he intended was "The word 'get' is not the correct antonym to
'release' in the context of locking. Replace it with 'acquire'".

Thanks.

--=20
An old man doll... just what I always wanted! - Clara

--CoH5zxFFOOKX9bt+
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZYpb5QAKCRD2uYlJVVFO
o6HXAP98Mo4gHQGHVilAPOcKYfra6Uc9RDFtePq4HOXrTGnR7gEAw89s1qcoE3LV
i60sBetZrS0VWBBNkDAbCEwb3k5tUAA=
=RCMa
-----END PGP SIGNATURE-----

--CoH5zxFFOOKX9bt+--

