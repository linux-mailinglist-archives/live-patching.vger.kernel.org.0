Return-Path: <live-patching+bounces-49-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DB49E7FD70E
	for <lists+live-patching@lfdr.de>; Wed, 29 Nov 2023 13:47:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 14E341C20987
	for <lists+live-patching@lfdr.de>; Wed, 29 Nov 2023 12:47:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7B351CA81;
	Wed, 29 Nov 2023 12:47:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="H6kDyq0G"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85D6795;
	Wed, 29 Nov 2023 04:47:24 -0800 (PST)
Received: by mail-pf1-x42d.google.com with SMTP id d2e1a72fcca58-6cdd9c53270so251136b3a.1;
        Wed, 29 Nov 2023 04:47:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1701262044; x=1701866844; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=2ck25N5VyiEQfTTbq0IG09TED0gOeZimM+CSOPSlwR8=;
        b=H6kDyq0G2Pb7eyULOZmj2rLPPlFzsOvKIdHlfZg0G9iskrRcLyvKlif3/Qd8bo0PmI
         x9Mev5gADonPSbwoqit0antPTJJQsiuxzK6bPJW4k0bhaTlWL15+M1ltvbHv/GmKZUhu
         W8nMpe4lN7+ckohfbMVXXghcIbRYC+P4fbOgnJTm7Qt9921ZMviZMSkWsno3xjMWqUXr
         vTsWOQrcupdKCgrJtaSvXBVyC4ls6xLZvbl8v2JcWuPrhNu68Kt4NmMlghTxxkMpwAWP
         zRxdN5Mr46nvzyOmQiTB9wkdBEj3mWxkKzs3O0W5VeR3lPAl2+ZLji6/TBXyC4gTCpX/
         WYzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701262044; x=1701866844;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2ck25N5VyiEQfTTbq0IG09TED0gOeZimM+CSOPSlwR8=;
        b=rv6N7h+ccKNn7HW0cctejJ8gpQgHECYZYoOxvs8CYWsg+jt3GPjZE3/8LY5uThmZOJ
         OWrnNLiicpjmaT9u6HXSa/rb6i+A7vKsy8TMX8IPfOM1K1y1hlBEYv2mc1zrL3lpUuyB
         uBAhUVteOzyqgU2J4TSqMn46or6y0EFQ9p8ZWp3mDlqoU5EsacK+2n+NYS3++LYJxE0w
         ftpNY4uxYQH1bYo1u9VHyJbtnpH1ddPweq4NAO6tqeJfgacNrFd4bo86jaiHBUDYV0zw
         YDWelifPizKvRJdVyqp7ZvbgNKfkMugEKyLaf31UJG19z8AjDnZyCTcv2xAWQjUmr552
         C8SQ==
X-Gm-Message-State: AOJu0YyadhDOTGL0vh4pW+h5yqEwu3KXMB1G6Xf2C/EgXQDYc6LH6Tbd
	c8p0fNl723BacSDnbhfvimMPFZ0+EICb+A==
X-Google-Smtp-Source: AGHT+IE+WgaEguchuhj6YT9T+Hqkp5MU16WACMs1AQTZBoRAX1jHyhUK7k+YKvihMK9Ien4Kg8JZgQ==
X-Received: by 2002:a05:6a20:e12a:b0:187:e646:4faf with SMTP id kr42-20020a056a20e12a00b00187e6464fafmr19379471pzb.14.1701262043767;
        Wed, 29 Nov 2023 04:47:23 -0800 (PST)
Received: from archie.me ([103.131.18.64])
        by smtp.gmail.com with ESMTPSA id c1-20020a170902d48100b001c9c8d761a3sm12100798plg.131.2023.11.29.04.47.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Nov 2023 04:47:23 -0800 (PST)
Received: by archie.me (Postfix, from userid 1000)
	id F1C4B10205C79; Wed, 29 Nov 2023 19:47:19 +0700 (WIB)
Date: Wed, 29 Nov 2023 19:47:19 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Miroslav Benes <mbenes@suse.cz>, Randy Dunlap <rdunlap@infradead.org>
Cc: Matthew Wilcox <willy@infradead.org>,
	attreyee-muk <tintinm2017@gmail.com>, jpoimboe@kernel.org,
	jikos@kernel.org, pmladek@suse.com, joe.lawrence@redhat.com,
	corbet@lwn.net, live-patching@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Took care of some grammatical mistakes
Message-ID: <ZWcy1wg68xKFOyDa@archie.me>
References: <20231127155758.33070-1-tintinm2017@gmail.com>
 <202dbdf5-1adf-4ffa-a50d-0424967286ba@infradead.org>
 <ZWX1ZB5p5Vhz7WD2@casper.infradead.org>
 <0e7941d8-d9b2-4253-9ad5-0f7806e45e2e@infradead.org>
 <alpine.LSU.2.21.2311291105430.12159@pobox.suse.cz>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="yTYQjTtA5F/R5Chg"
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.21.2311291105430.12159@pobox.suse.cz>


--yTYQjTtA5F/R5Chg
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 29, 2023 at 11:08:46AM +0100, Miroslav Benes wrote:
> On Tue, 28 Nov 2023, Randy Dunlap wrote:
>=20
> >=20
> >=20
> > On 11/28/23 06:12, Matthew Wilcox wrote:
> > > On Mon, Nov 27, 2023 at 11:41:31AM -0800, Randy Dunlap wrote:
> > >> Hi,
> > >>
> > >> On 11/27/23 07:57, attreyee-muk wrote:
> > >>> Respected Maintainers,=20
> > >>>
> > >>> I have made some grammatical changes in the livepatch.rst file wher=
e I
> > >>> felt that the sentence would have sounded more correct and would ha=
ve become easy for
> > >>> beginners to understand by reading.=20
> > >>> Requesting review of my proposed changes from the mainatiners.=20
> > >>>
> > >>> Thank You
> > >>> Attreyee Mukherjee
> > >>>
> > >>> Signed-off-by: attreyee-muk <tintinm2017@gmail.com>
> > >>> ---
> > >>>  Documentation/livepatch/livepatch.rst | 8 ++++----
> > >>>  1 file changed, 4 insertions(+), 4 deletions(-)
> > >>>
> > >>> diff --git a/Documentation/livepatch/livepatch.rst b/Documentation/=
livepatch/livepatch.rst
> > >>> index 68e3651e8af9..a2d2317b7d6b 100644
> > >>> --- a/Documentation/livepatch/livepatch.rst
> > >>> +++ b/Documentation/livepatch/livepatch.rst
> > >>> @@ -35,11 +35,11 @@ and livepatching:
> > >>> =20
> > >>>  All three approaches need to modify the existing code at runtime. =
Therefore
> > >>> -they need to be aware of each other and not step over each other's=
 toes.
> > >>> +they need to be aware of each other and not step over each others'=
 toes.
> > >>
> > >> I've never seen that written like that, so I disagree here. FWIW.
> > >=20
> > > "Step over" is new to me too.  I see "step on" much more often.
> >=20
> > Agreed.
>=20
> Yes. Attreyee, please fix this instead.
> =20
> > > As far as placement of the apostrophe,
> > > https://ludwig.guru/s/step+on+each+others+toes
> > > suggests either omitting the apostrophe or placing it after the s,
> > > as attreyee-muk has done is most common.
> >=20
> > Apparently you can find anything on the internet.  :)
> >=20
> > Here's the other side:
> >=20
> > https://jakubmarian.com/each-others-vs-each-others-in-english/
>=20
> I am not a native speaker, but "step on each other's toe" sounds the best=
=20
> to me. Or perhaps even "they need to be aware of each other and not step=
=20
> on their toes" since it is then kind of implied? English is difficult :).
>=20

I agree with yours and Jakub's blogpost, since 'each other' refers to
every single individual.

Thanks.

--=20
An old man doll... just what I always wanted! - Clara

--yTYQjTtA5F/R5Chg
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZWcy1wAKCRD2uYlJVVFO
oyGpAP4kgfEso2+zbnQS0HyG60Q4+zjNQhE3A2TjFS57TzpBQgEAslKjk1drpxdh
cMB6AHt0Id3vEQlacCw424M49hfpZQ4=
=YaJg
-----END PGP SIGNATURE-----

--yTYQjTtA5F/R5Chg--

