Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B48445DBA4
	for <lists+live-patching@lfdr.de>; Thu, 25 Nov 2021 14:50:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355443AbhKYNxU (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 25 Nov 2021 08:53:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:60330 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1355332AbhKYNvS (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Thu, 25 Nov 2021 08:51:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C25DB60FD8;
        Thu, 25 Nov 2021 13:48:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637848087;
        bh=B8R3ztlbM99Jeh4nG9RnTDnVANUUkqCv0VxD/QuuUiM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FGnC/d2K5qPnnAUR9xnN+XK9P/Cbr75SurJrMFWoo5OoWvZsfBqWhvpPSwsWCcvG/
         2k+HtGk/xcIgVdTRKbLtgTR2CJ6PJr322Avr0ctdojJr2Kmr0vr8f+Ho8N0fMkGRME
         RO+ryfb0EspHf5OqCXJ6MYoXxqyFF9kbzxM7xhwzebnNp1sb/c8SJ9TX/DOIUZTdNH
         JgTR8YbpL2xA0mm4oBa5mYI/fJiAQ+MlutIJfE3rmipgX6jxRr5WC3m1hcKAO5FQyr
         ntOqYWucI7U6n6GNWOAbWbFJgNmQyoUyNbQHFICXX/ZX9O9Ys8SZ0VdFh9DVfYSK47
         cU1yFFuoszHzA==
Date:   Thu, 25 Nov 2021 13:48:01 +0000
From:   Mark Brown <broonie@kernel.org>
To:     madvenka@linux.microsoft.com
Cc:     mark.rutland@arm.com, jpoimboe@redhat.com, ardb@kernel.org,
        nobuta.keiya@fujitsu.com, sjitindarsingh@gmail.com,
        catalin.marinas@arm.com, will@kernel.org, jmorris@namei.org,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v11 1/5] arm64: Call stack_backtrace() only from within
 walk_stackframe()
Message-ID: <YZ+UEdW2Ss096HlJ@sirena.org.uk>
References: <8b861784d85a21a9bf08598938c11aff1b1249b9>
 <20211123193723.12112-1-madvenka@linux.microsoft.com>
 <20211123193723.12112-2-madvenka@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="AyrLmaYXnWaR0eCf"
Content-Disposition: inline
In-Reply-To: <20211123193723.12112-2-madvenka@linux.microsoft.com>
X-Cookie: This bag is recyclable.
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org


--AyrLmaYXnWaR0eCf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 23, 2021 at 01:37:19PM -0600, madvenka@linux.microsoft.com wrot=
e:
> From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
>=20
> Currently, arch_stack_walk() calls start_backtrace() and walk_stackframe()
> separately. There is no need to do that. Instead, call start_backtrace()
> from within walk_stackframe(). In other words, walk_stackframe() is the o=
nly
> unwind function a consumer needs to call.

Reviewed-by: Mark Brown <broonie@kernel.org>

--AyrLmaYXnWaR0eCf
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmGflBEACgkQJNaLcl1U
h9BeDwf8CLvHS4gPhTR0PESblCIfFkZQSUhKeQxobmrHQ5XnW6H7TDyzusjAxK8D
dVX4YbJxh3arUwPQXrU7uXqT+y+Wm1RotWJd0RcF2dUvcgrKOgVztxxfLRwfHY5f
raiFv06vqzDckVxLaW/4tqEkl9HR60VtHNhylTQtK1cZXGYiHFVm2aClRdzrbREC
GUqNvwnc8MMc/2QI2RYdN7iRSs21Up8bXxt9/PC9js+3Gc7XEW8Yk3r0Gz7vkygs
RJ5adaqSs3GBR44Y62f2UqE+FOK+EPRrlLYEeHPan0MhKnILOmGETC+F4ByYJrUW
n2Qtdjhgw10GqKHsVwZf8QWYRu1o8w==
=JQmW
-----END PGP SIGNATURE-----

--AyrLmaYXnWaR0eCf--
