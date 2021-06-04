Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 839CB39BBDF
	for <lists+live-patching@lfdr.de>; Fri,  4 Jun 2021 17:29:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229881AbhFDPbG (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 4 Jun 2021 11:31:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:33372 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229864AbhFDPbG (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Fri, 4 Jun 2021 11:31:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A398261404;
        Fri,  4 Jun 2021 15:29:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622820560;
        bh=lF4mEdpv40AVgxloddBAIZmv5h6QsjqNCuxmyL/C2ns=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=aOCrj9Tan4ZVE8PMWzo2XOPSNN7dVx6/G/zS2m/oNEYrpsT9ZQXCTxG9qZJpZEHMf
         EsooQBTC77ZjjIUSZN+yZsEJDeD6c/Meua8qXEGk+KJKYBYerpNvu6s0XFT5PvkdL6
         x53JJexHYQe9IR679Fb7KcCiiMIcDkiDCdIe67DFK2jHLnvTq8hctE49DDD/IsIlT9
         pJwYpKQc4YqJRwFkV8Nazq4siorZ2oI6eWbCx8bAU/ggg9cLHIP+FbRGR8bVYLAvQh
         hW36ldhEb4fgv9rzqtR+vTPaWqvoV37B53vJORZTw5M+Pb9lpMSnl8Fm49m7MI0tOJ
         AtjXW8h3PjKuQ==
Date:   Fri, 4 Jun 2021 16:29:08 +0100
From:   Mark Brown <broonie@kernel.org>
To:     madvenka@linux.microsoft.com
Cc:     mark.rutland@arm.com, jpoimboe@redhat.com, ardb@kernel.org,
        nobuta.keiya@fujitsu.com, catalin.marinas@arm.com, will@kernel.org,
        jmorris@namei.org, pasha.tatashin@soleen.com, jthierry@redhat.com,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v5 0/2] arm64: Implement stack trace reliability
 checks
Message-ID: <20210604152908.GD4045@sirena.org.uk>
References: <ea0ef9ed6eb34618bcf468fbbf8bdba99e15df7d>
 <20210526214917.20099-1-madvenka@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="hoZxPH4CaxYzWscb"
Content-Disposition: inline
In-Reply-To: <20210526214917.20099-1-madvenka@linux.microsoft.com>
X-Cookie: There is a fly on your nose.
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org


--hoZxPH4CaxYzWscb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 26, 2021 at 04:49:15PM -0500, madvenka@linux.microsoft.com wrot=
e:
> From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
>=20
> There are a number of places in kernel code where the stack trace is not
> reliable. Enhance the unwinder to check for those cases and mark the
> stack trace as unreliable. Once all of the checks are in place, the unwin=
der

Reviewed-by: Mark Brown <broonie@kernel.org>

--hoZxPH4CaxYzWscb
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmC6RsMACgkQJNaLcl1U
h9CYNgf9Hwof1h/Xqtj4jkOFrpz2t6naEeqX3Mx6TSlmC5EyGscqgW6GBZxgFzGT
trmeIBvno1J2hWcAatHYcw+zIwbsQuZCPi5489xduLPwkEzPDALElZroipJFmkCv
m2KRKHr/ED6B+Ea6Kx+lgqv5xFSf3S9yPH8it2rBI+H6J2FPt42384Z72vqn4nGb
DExKvoL/NxHKmyWxR2GeMJ6Lool40FOdcqpvBkIlsUa0UxUuVgTyIKbQL/F0YDnt
HcyRMP745nhp0w5J85wo209LcmvHVJ+ti5d+ySCCezd9U0+RkrpgACxe6ivRNHbb
w4RGHSLtZMD9H9TGmquniIkZ23fCUQ==
=kfuX
-----END PGP SIGNATURE-----

--hoZxPH4CaxYzWscb--
