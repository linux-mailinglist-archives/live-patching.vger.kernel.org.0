Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAF6135187A
	for <lists+live-patching@lfdr.de>; Thu,  1 Apr 2021 19:48:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235498AbhDARpx (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 1 Apr 2021 13:45:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:42942 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235599AbhDARnA (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Thu, 1 Apr 2021 13:43:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 46FF86136D;
        Thu,  1 Apr 2021 17:23:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617297830;
        bh=Xaq+PFMvaSLmYYTakUM+Wo3bxk9I4RER+hC85kYqeRA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=eMZxtUSWzR3JAHYDs7v+NIHX6E7liZNw9bkYy46pCPaTroA+oxawzuvD86QsEf/oE
         p5Vc+kUnECH03XfJZ/9TezHjdsdQLv9QVDZD7aoXMor5Vf5IxD0sfO4GVAsQddvlLS
         pfUvGKn/eRFSuFn0nadD27QL7V5h4NZoBnHMaeKYFBJ34r7YHE2Nm537M1x6XXYNWj
         N4jU7BssJD0E5VR62h7q0Nzww74feGRR9iPBZ/ZgE7bDtoCitHj6PKMUGRs1f/VX8P
         pKjfn3/ZApZ3p4NOVSvnUUR9dOkTng1dLGYVk7rOm29EK6XnUm/OeaOCTEG+2W/IyB
         GX6xZuJkhnqDA==
Date:   Thu, 1 Apr 2021 18:23:37 +0100
From:   Mark Brown <broonie@kernel.org>
To:     madvenka@linux.microsoft.com
Cc:     mark.rutland@arm.com, jpoimboe@redhat.com, jthierry@redhat.com,
        catalin.marinas@arm.com, will@kernel.org,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v1 4/4] arm64: Mark stack trace as unreliable if
 kretprobed functions are present
Message-ID: <20210401172337.GN4758@sirena.org.uk>
References: <77bd5edeea72d44533c769b1e8c0fea7a9d7eb3a>
 <20210330190955.13707-1-madvenka@linux.microsoft.com>
 <20210330190955.13707-5-madvenka@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="hNG1vEeyG8BCaHbQ"
Content-Disposition: inline
In-Reply-To: <20210330190955.13707-5-madvenka@linux.microsoft.com>
X-Cookie: You can't take damsel here now.
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org


--hNG1vEeyG8BCaHbQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 30, 2021 at 02:09:55PM -0500, madvenka@linux.microsoft.com wrot=
e:
> From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
>=20
> When a kretprobe is active for a function, the function's return address
> in its stack frame is modified to point to the kretprobe trampoline. When
> the function returns, the frame is popped and control is transferred
> to the trampoline. The trampoline eventually returns to the original retu=
rn
> address.

Reviewed-by: Mark Brown <broonie@kernel.org>

--hNG1vEeyG8BCaHbQ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmBmAZgACgkQJNaLcl1U
h9DNLgf9EjVfbJEbXcT1czVIISqZQ/VUQdmsEihE9aMX89+FMUyAfslCMNF0tk3z
fugyNqT47uJf0EpdoRti10YNBbltKT2EWC3CWciuA6UA4NWqnjw+nDRHFFZQ3Vy0
9rfXsW9DqAO3Mb6rHq3yAFlJC/MAiXLBGsg3Om2tSEvjOOzoUfJ6OMtkLCfPQe2k
JeyZx7dgHDuMPAuU4gdTruUm+ou6gbK4J0FjlJr+uJJ/CWbkbyeA4BcP5J/I8S4t
Vy1JjNWKABb4RYMT7yV4npNQBlOkn9NVp3vUqp21AivaUzD3oRSYEEieyynS/I/4
/WuEtg6fDPOXcU7mU5ctOMYhYUsuJA==
=fy6D
-----END PGP SIGNATURE-----

--hNG1vEeyG8BCaHbQ--
