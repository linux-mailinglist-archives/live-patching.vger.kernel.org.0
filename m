Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7DFF45DCE3
	for <lists+live-patching@lfdr.de>; Thu, 25 Nov 2021 16:07:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239647AbhKYPKp (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 25 Nov 2021 10:10:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:52302 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229934AbhKYPIm (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Thu, 25 Nov 2021 10:08:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EED2361052;
        Thu, 25 Nov 2021 15:05:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637852731;
        bh=ZvTvHI4iJTlENlblfH9I2GcOCGsrQBGcnKtEXr3b82Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sEk12V4xnDFOZy15cdhhUPwIJiPNMlztpjrG4a16Ju6WNgSDadkAYuDDbzSi89Wme
         QWzMWi0WuaKirFWaEJKj8TxZYSIzc2nEVMWSZrEch7mU7jtpfhvKeLrzGbMPhqMQsQ
         uddRYoVDdEnRMOW1MQ3iW0RqugY6zX69M+VB37H4W1TyRZ1d4Ei0ROFK3V3KPYZdBJ
         jUlJALs5c7O9wENU5v/LQibq7O2B0HdE8N9GxF9FnOq7/d++y56MfGAj8jBunJKZ8b
         4IgiKfqixoswBy7w+N8PMf7NaPIUzsZUHkcATZcbgr/nDbbUeBd02JB2UcHtiYb/ye
         UzOvFwegSAyzQ==
Date:   Thu, 25 Nov 2021 15:05:25 +0000
From:   Mark Brown <broonie@kernel.org>
To:     madvenka@linux.microsoft.com
Cc:     mark.rutland@arm.com, jpoimboe@redhat.com, ardb@kernel.org,
        nobuta.keiya@fujitsu.com, sjitindarsingh@gmail.com,
        catalin.marinas@arm.com, will@kernel.org, jmorris@namei.org,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v11 5/5] arm64: Create a list of SYM_CODE functions,
 check return PC against list
Message-ID: <YZ+mNXhavXt/mNZ3@sirena.org.uk>
References: <8b861784d85a21a9bf08598938c11aff1b1249b9>
 <20211123193723.12112-1-madvenka@linux.microsoft.com>
 <20211123193723.12112-6-madvenka@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="m2fLEeg5NIztZTxh"
Content-Disposition: inline
In-Reply-To: <20211123193723.12112-6-madvenka@linux.microsoft.com>
X-Cookie: This bag is recyclable.
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org


--m2fLEeg5NIztZTxh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 23, 2021 at 01:37:23PM -0600, madvenka@linux.microsoft.com wrot=
e:
> From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
>=20
> SYM_CODE functions don't follow the usual calling conventions. Check if t=
he
> return PC in a stack frame falls in any of these. If it does, consider the
> stack trace unreliable.

Reviewed-by: Mark Brown <broonie@kernel.org>

--m2fLEeg5NIztZTxh
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmGfpjQACgkQJNaLcl1U
h9ATOwf/e90v9GMGBwGdJq9+GSfeO9GigM+x7IV126yW84IFZoWXy0yCgjHBhjgR
yz4DDd/2u8fAvVzM4Z2cHRx7Av74JeaMlLyNY1G2RXgrvoty/Ff11dw1p60gVYxq
Xso0YX2PNmTST0IQ5HVw6YwTL42d3BKBQppHqai3C8z5DL5ihBhl9pllCmklQfmk
5XMqMW0a9AUJYUmFtQTHwE4PxeZRxOdxJxNf583jAIJCWJ55M26O1kgFVsno6p7x
g07sWhI7YSV4o86T1W74vL4hmP0YyO2XO0q3rHihTfpXPPQapbWUj/rqnYhdVVYp
dQrMCptiPfNVCxQPee1+HtfJg83lSQ==
=1le9
-----END PGP SIGNATURE-----

--m2fLEeg5NIztZTxh--
