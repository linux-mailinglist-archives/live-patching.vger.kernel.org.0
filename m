Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 100E2434FC6
	for <lists+live-patching@lfdr.de>; Wed, 20 Oct 2021 18:10:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229817AbhJTQMu (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 20 Oct 2021 12:12:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:46554 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231153AbhJTQMu (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Wed, 20 Oct 2021 12:12:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 47FE6611C7;
        Wed, 20 Oct 2021 16:10:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634746235;
        bh=z6PY8llaZwmywwJZWrwXZV/7u2OHh47ZPV0U+0N3ZI4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oRxgXrDJjG9VAK5tvuy9sb66+ZN59gaYZoHn1SsDhC5Q/t7hfPnBBgkytqOmqgWpI
         HAiowPp02mPPnM/3gCj5gZCVuimSMVyy90JWDW2aS2Y/5rgvncfZWtgbDUYLP6NztA
         qqEkaHOO9RZNfn1xqd74fapxWsYMW2mckXeZny0XC2Sfhz9wEYLWpLET01dthWf5Pi
         z2IT8MOyVB7tx8h1DQg5AFp7B1THZSgbx3xmFP6i/+z+CX9b7vOtQ+R958Y1DLoUX1
         H5FlPFlw8/8DZ+Bs6F2WCAHMLtUwCaGMtivs98IomtxgFDU6oVvRtpjd8l0Vjk09on
         xr5gxNweqYOVg==
Date:   Wed, 20 Oct 2021 17:10:33 +0100
From:   Mark Brown <broonie@kernel.org>
To:     madvenka@linux.microsoft.com
Cc:     mark.rutland@arm.com, jpoimboe@redhat.com, ardb@kernel.org,
        nobuta.keiya@fujitsu.com, sjitindarsingh@gmail.com,
        catalin.marinas@arm.com, will@kernel.org, jmorris@namei.org,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v10 03/11] arm64: Make get_wchan() use arch_stack_walk()
Message-ID: <YXA/eepRCCzL+/jD@sirena.org.uk>
References: <c05ce30dcc9be1bd6b5e24a2ca8fe1d66246980b>
 <20211015025847.17694-1-madvenka@linux.microsoft.com>
 <20211015025847.17694-4-madvenka@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="O/pViJGvRkkdBw9F"
Content-Disposition: inline
In-Reply-To: <20211015025847.17694-4-madvenka@linux.microsoft.com>
X-Cookie: I program, therefore I am.
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org


--O/pViJGvRkkdBw9F
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 14, 2021 at 09:58:39PM -0500, madvenka@linux.microsoft.com wrot=
e:
> From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
>=20
> Currently, get_wchan() in ARM64 code walks the stack using start_backtrac=
e()
> and unwind_frame(). Make it use arch_stack_walk() instead. This makes
> maintenance easier.

This overlaps with some very similar updates that Peter Zijlstra is
working on which addresses some existing problems with wchan:

	https://lore.kernel.org/all/20211008111527.438276127@infradead.org/

It probably makes sense for you to coordinate with Peter here, some of
that series is already merged up to his patch 6 which looks very
similar to what you've got here.  In that thread you'll see that Mark
Rutland spotted an issue with the handling of __switch_to() on arm64
which probably also applies to your change.

--O/pViJGvRkkdBw9F
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmFwP3gACgkQJNaLcl1U
h9AD2Af/cYDwqWJMHFvpAMcH68EcA1Z9pEkv8BxhV1zFhZ5CwFxiJSaY24/lDnCn
HaWOYTMkNnwSJYbn4Jb6SP1m9M9HYnxPDE5DxQLV/JZAqf9zQ3VCcF4xBgvKUyOy
m+aWvHSPp6M8EMGXWFiah7nlDb7bX80RIVddLGNs9cQHVrLaS/mOxmcjsJ1JWmMR
ZQ93tT5kJ+s3ILnQq3azYZ1rbRQCtGQN4zTC4qEJT8iD3sY9ov+28JAgVqrrCOfE
32z6mtBLvH5exVlJe3LS5Irf6ki20DffofCLmoS8lbCexFqPv4LfGsRRYNr/3ooh
eaY50Wv0UxQ3stzu9PsMtUW42eUmtg==
=tBaY
-----END PGP SIGNATURE-----

--O/pViJGvRkkdBw9F--
