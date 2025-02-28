Return-Path: <live-patching+bounces-1246-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4B705A48E47
	for <lists+live-patching@lfdr.de>; Fri, 28 Feb 2025 03:04:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9FCB9188ABA0
	for <lists+live-patching@lfdr.de>; Fri, 28 Feb 2025 02:04:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 76BDF28DD0;
	Fri, 28 Feb 2025 02:04:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="h2MJx2+R"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02228125B2;
	Fri, 28 Feb 2025 02:04:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740708256; cv=none; b=vBX6DKFgiW99WwnwiyvqmlVRkbvk0CV8KUNm0owmALyxAFW4hMnnX9nTO1OgYVjGH5nMs7xEh0CF/Md4gI6XC82gL1KicPa97AqDVLZXuBnhfsI42tLhUQ8lQ0VK17ruXR5rXclUvKrzz/7NJegvKOb3bBxRUnzAHqfVBx6KTSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740708256; c=relaxed/simple;
	bh=pttPMi2OGMYeRMexHzwLllEh+UDP/eVvvhW58rJRU6Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MORUua00A+oWUwH7eH2mNDnVULcjCNLSNSvtmG+ZdxyldiRnhb4kSpYic6kJDmpTSxgB/VxFNJG4/KonXwdJdPvVFRx8fAqnv5px8B5/1Rez/PZ47VXEyjC0rzHawyrYdAkykM4tJmEvdTjA4hNljVdsjRrfhNZxiDoHbRlwj8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=h2MJx2+R; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-22355618fd9so24792915ad.3;
        Thu, 27 Feb 2025 18:04:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740708254; x=1741313054; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=DO4u9Pvzwx6HigYVezagh1f5xC7V2c+sTGulXIlhhlg=;
        b=h2MJx2+RH02CP1NQ1QbVMFUz7FA4FR+jaAFGvBK9LxPpeOV6LaHSH5IUyHrMTvXJS0
         GocK6YlZhxLQZGhYzVeONqOq4ONDS8OnytcN0MVsaj+9Caikxh0/SfmlqlnPtCdKi8QX
         nPI/mQ96OiURxPbUfK6RpG0BH9cYqBrmhvro10XT/JgqO1i83ikTMTZTP1/gXoXxXFdp
         D2O4BSLbkIk2ruJooHRbwR7vV58nveG0JYjbIxKOlxOXIzpNjyDVHbuqd6SSO8PaoctZ
         Myo29GJXBoD8sV4Z+JDLlf5+d0oJpj8I8SE8ZlU0yrLd1mPBgK2LCrX5nN2zwtW4lB7Y
         uebg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740708254; x=1741313054;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DO4u9Pvzwx6HigYVezagh1f5xC7V2c+sTGulXIlhhlg=;
        b=Oiwi3O1wUgxIrptMzsaL1CAXshfhH0Eapm+PCSpZQM8KtoCarlZxHPZGRaZvu/zPsE
         KPmp9uPhvrkK8N9SUGNEMOI2EtNGXPaAreI9ibqfIRlFtNnpnQHqUKirZdJnir2FLbk1
         zlfIuNgQV1r/cEoC6Y8BBGTXC5zQCg23333VOPXIIVuVGaQ+/VRUdji6T3an7A0qtvYM
         H3h1YXAXvQ6Npii1BZJPgRp5NQOyc2L8PLTkFp2lSsQ9AcCEESHzlopjNsuDry0lK/ET
         4TcGtrig/34ow6+uMGtCo1v1eW6Hov42+XGDY60RXPTugxs1eySEBv4efiIDfPscJB4V
         UYzw==
X-Forwarded-Encrypted: i=1; AJvYcCUawoFH82tbQIFOg/WC09eoRUn5iRv/FApvOM3qywE/7+QN8071VJddlqOgxunYRTbg1Zy1erWMpxg=@vger.kernel.org, AJvYcCXJVJajBou5q0UNHM4jyOLq30zRbj6RxDNYXVyLh7DTUhiNLhm/rav55qyI/R4TxCkQaruYry9uFWtR13uOmw==@vger.kernel.org, AJvYcCXodkh5JFBg0O2gZ0dSGmKMusNaUxNz3GdCnR55m0Cr7EyckXhEh2f58SCQAXo/R8MqZwseDILMFOA+daQM@vger.kernel.org
X-Gm-Message-State: AOJu0Yxh6gtEvt/Zjcvhs1CHGxWcaqGndUxgJyANotG1nsVsV+UavpZD
	Nj4/9wnK9laN4hsO84ePY+IEl3H9R5bvYhlAkyHfRDO2xN+hihbARbxQLw==
X-Gm-Gg: ASbGncusA3Ojdr1IrOSudKrlHAyDX7a/XKfYgBCPDkCSBfXnecfgxdFn/GqLB4jN6sE
	ZC5sLsMf1lC4lEboEBwxV3rTIYXAsPZk6343SRc5DOtsi7CxPBHzAKOuoawNWZthcwwdEn+c+K4
	sJcfkk5+y2cG61/QOkekwL67C4AM0rafbqVkxFr13g4MWdh7eVPPyjk4YF0E73fxUscgx3zc2lW
	As08HDmHLvRrDDUoijK5gfd7ohDauUWKd2OfW3p7Kxou9eI33ZI3AMQ/BR5YJa/z3ih73Ed5Cjh
	PL3+UtFgJ/C6ffkGbGn/0eKmEA==
X-Google-Smtp-Source: AGHT+IF7AKdsmEQqtj6UYHITURHyn9gUthf6RS67BxodfjGc0ZQH4wboAO5Vc51/FxngbDwVPS+EzQ==
X-Received: by 2002:a17:902:e750:b0:220:e9ac:e746 with SMTP id d9443c01a7336-2236927f595mr28831515ad.53.1740708254010;
        Thu, 27 Feb 2025 18:04:14 -0800 (PST)
Received: from archie.me ([103.124.138.155])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-223501fa95asm22582245ad.73.2025.02.27.18.04.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Feb 2025 18:04:13 -0800 (PST)
Received: by archie.me (Postfix, from userid 1000)
	id 6366F412B0AC; Fri, 28 Feb 2025 09:04:11 +0700 (WIB)
Date: Fri, 28 Feb 2025 09:04:11 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Vincenzo MEZZELA <vincenzo.mezzela@suse.com>,
	live-patching@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: jpoimboe@kernel.org, jikos@kernel.org, mbenes@suse.cz, pmladek@suse.com,
	joe.lawrence@redhat.com, corbet@lwn.net
Subject: Re: [PATCH v2] docs: livepatch: move text out of code block
Message-ID: <Z8EZm2CXB6yVRoue@archie.me>
References: <20250227163929.141053-1-vincenzo.mezzela@suse.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="tKj0ZzgmyVi1MADl"
Content-Disposition: inline
In-Reply-To: <20250227163929.141053-1-vincenzo.mezzela@suse.com>


--tKj0ZzgmyVi1MADl
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 27, 2025 at 05:39:29PM +0100, Vincenzo MEZZELA wrote:
> diff --git a/Documentation/livepatch/module-elf-format.rst b/Documentatio=
n/livepatch/module-elf-format.rst
> index a03ed02ec57e..5d48778d4dfc 100644
> --- a/Documentation/livepatch/module-elf-format.rst
> +++ b/Documentation/livepatch/module-elf-format.rst
> @@ -217,16 +217,19 @@ livepatch relocation section refer to their respect=
ive symbols with their symbol
>  indices, and the original symbol indices (and thus the symtab ordering) =
must be
>  preserved in order for apply_relocate_add() to find the right symbol.
> =20
> -For example, take this particular rela from a livepatch module:::
> +For example, take this particular rela from a livepatch module::
> =20
>    Relocation section '.klp.rela.btrfs.text.btrfs_feature_attr_show' at o=
ffset 0x2ba0 contains 4 entries:
>        Offset             Info             Type               Symbol's Va=
lue  Symbol's Name + Addend
>    000000000000001f  0000005e00000002 R_X86_64_PC32          000000000000=
0000 .klp.sym.vmlinux.printk,0 - 4
> =20
> -  This rela refers to the symbol '.klp.sym.vmlinux.printk,0', and the sy=
mbol index is encoded
> -  in 'Info'. Here its symbol index is 0x5e, which is 94 in decimal, whic=
h refers to the
> -  symbol index 94.
> -  And in this patch module's corresponding symbol table, symbol index 94=
 refers to that very symbol:
> +This rela refers to the symbol '.klp.sym.vmlinux.printk,0', and the symb=
ol
> +index is encoded in 'Info'. Here its symbol index is 0x5e, which is 94 in
> +decimal, which refers to the symbol index 94.
> +
> +And in this patch module's corresponding symbol table, symbol index 94 r=
efers
> +to that very symbol::
> +
>    [ snip ]
>    94: 0000000000000000     0 NOTYPE  GLOBAL DEFAULT OS [0xff20] .klp.sym=
=2Evmlinux.printk,0
>    [ snip ]

LGTM, thanks!

Reviewed-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--tKj0ZzgmyVi1MADl
Content-Type: application/pgp-signature; name=signature.asc

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZ8EZmwAKCRD2uYlJVVFO
ownAAQDyLeqKMUb6Yuhq8W/qmxH1ELSo4SEB64yCA4NSt88epQEAlF8kXX7FR59i
DIs8FAedjxwBYTmqlS/jpOZMpnPSkwo=
=5LGe
-----END PGP SIGNATURE-----

--tKj0ZzgmyVi1MADl--

