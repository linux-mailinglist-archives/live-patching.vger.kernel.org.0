Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E914D45CAAE
	for <lists+live-patching@lfdr.de>; Wed, 24 Nov 2021 18:10:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242518AbhKXRNm (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 24 Nov 2021 12:13:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:56212 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236272AbhKXRNl (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Wed, 24 Nov 2021 12:13:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5590260F5B;
        Wed, 24 Nov 2021 17:10:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637773830;
        bh=/njBpvjHQON74J2FR4Ytl+O1BNa+DFPAn2wArZRfQB4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qlM3m0X/v3bSZrp1LPdjGscz7sQxH6/p6J+5hTbXWuKV7elZ5kybYO7c8ZpX7k99l
         fa/w8o2j28IkFL1vnBMa/UYh/zmXOSxzM5jQ1AUI9peBfITJHuhrqeU+Me+YVWDnha
         O7sCh22823yP+/ts+l4rrrd20wp9G4UR3a2lTY6Nl1AXUXSX/GZTdzgl51QylQ0VfZ
         9YM693BwDCLj9QF7JH3x2O/jJkiDdRUGpENxhi+x3Chvk9vcX80pbIQo3ohGBo1+u9
         TYMt07l7Irm2MQjwa+uqsXU09YnbQ9Lk459oXruCfUDT0RISUQWufAEB9cUOyNrida
         33NMGFlOXtRzg==
Date:   Wed, 24 Nov 2021 17:10:25 +0000
From:   Mark Brown <broonie@kernel.org>
To:     madvenka@linux.microsoft.com
Cc:     mark.rutland@arm.com, jpoimboe@redhat.com, ardb@kernel.org,
        nobuta.keiya@fujitsu.com, sjitindarsingh@gmail.com,
        catalin.marinas@arm.com, will@kernel.org, jmorris@namei.org,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v11 2/5] arm64: Rename unwinder functions
Message-ID: <YZ5yAanQrL17sYeN@sirena.org.uk>
References: <8b861784d85a21a9bf08598938c11aff1b1249b9>
 <20211123193723.12112-1-madvenka@linux.microsoft.com>
 <20211123193723.12112-3-madvenka@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="oGibfVigX0tUyvnS"
Content-Disposition: inline
In-Reply-To: <20211123193723.12112-3-madvenka@linux.microsoft.com>
X-Cookie: (null cookie
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org


--oGibfVigX0tUyvnS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 23, 2021 at 01:37:20PM -0600, madvenka@linux.microsoft.com wrot=
e:
> From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
>=20
> Rename unwinder functions for consistency and better naming.
>=20
> 	- Rename start_backtrace() to unwind_start().
> 	- Rename unwind_frame() to unwind_next().
> 	- Rename walk_stackframe() to unwind().

Reviewed-by: Mark Brown <broonie@kernel.org>

--oGibfVigX0tUyvnS
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmGecgAACgkQJNaLcl1U
h9CF8wf/eWTybYXBAR2qCs8GfVWNYuIkbhBhpiCmUkCOXJ/DRNfCHH30L5kuT+yO
8yDfMuB784chIi6YXanfsZ4jS8ER8VgXFq9EcOAMfqrCkbjQIPMo7P++qjQSymlD
491uNAWVeFP2PqZDyyvPpgY/OXjHUo/YM4bBuoG7G3weqfoWW6Rs1AH9ojJkXrmv
WTDIImLQCAbM6a/l19Gi2iHVwbCcfEe5MxP5znJCWnHSIFJz3bIe7C4RCTJ6vnKj
87pNdKmS8gDw25ryoILXDSM0Ec+6COBuU9YJmEA5C/AWtNQN4PL2nkrTJm7CgcYD
ubGb1heis2TwORnykJHajwrV17/iKg==
=lPKV
-----END PGP SIGNATURE-----

--oGibfVigX0tUyvnS--
