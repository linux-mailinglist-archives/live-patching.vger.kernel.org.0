Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A202942FAF7
	for <lists+live-patching@lfdr.de>; Fri, 15 Oct 2021 20:28:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242559AbhJOSaY (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 15 Oct 2021 14:30:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:46692 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237667AbhJOSaX (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Fri, 15 Oct 2021 14:30:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4412360F36;
        Fri, 15 Oct 2021 18:28:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634322496;
        bh=vlXFCcBoyVQ7iQiLse67gO6LLe1CSZH6R8FPMdiU0yE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CGfJXlXTJ9OVFEU2EBteumRtqnc1EoMesBUzy2+do6QV6OkaO1pps3fDuSc7hdN61
         xICU37Xoju6jvaikQsuleeh/oRFuRjToYPg7ThZQC+IimT3QB6Mm16CXP1FASJ1/ar
         yGCzkf3f+x9BgVBcp5Fnx66pbze/Lfu+2bNGQ1K4gEAMUyHYtvMWLGzz9itXFynscc
         hz+RpWX5KvMQhTHvcgLh3Uub2QMEY7yVcqKi8Ie+fiQXgKS5LmrSnJvcPAc+6SeCkD
         m9JAYZtzLKN7EHbIXdZiRs5TS/pciCRWzE+6udTEk/kQWrnhaHa5SukBM3v6Xwt/iR
         dMKe6wyAaMpaA==
Date:   Fri, 15 Oct 2021 19:28:13 +0100
From:   Mark Brown <broonie@kernel.org>
To:     madvenka@linux.microsoft.com
Cc:     mark.rutland@arm.com, jpoimboe@redhat.com, ardb@kernel.org,
        nobuta.keiya@fujitsu.com, sjitindarsingh@gmail.com,
        catalin.marinas@arm.com, will@kernel.org, jmorris@namei.org,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v10 01/11] arm64: Select STACKTRACE in arch/arm64/Kconfig
Message-ID: <YWnIPU4dRmJHTkXZ@sirena.org.uk>
References: <c05ce30dcc9be1bd6b5e24a2ca8fe1d66246980b>
 <20211015025847.17694-1-madvenka@linux.microsoft.com>
 <20211015025847.17694-2-madvenka@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="zvxU7vCc3P+aDYhz"
Content-Disposition: inline
In-Reply-To: <20211015025847.17694-2-madvenka@linux.microsoft.com>
X-Cookie: 1: No code table for op: ++post
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org


--zvxU7vCc3P+aDYhz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 14, 2021 at 09:58:37PM -0500, madvenka@linux.microsoft.com wrot=
e:
> From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
>=20
> Currently, there are multiple functions in ARM64 code that walk the
> stack using start_backtrace() and unwind_frame() or start_backtrace()
> and walk_stackframe(). They should all be converted to use
> arch_stack_walk(). This makes maintenance easier.

Reviwed-by: Mark Brown <broonie@kernel.org>

Arguably this should be squashed in with the first user but that's
getting bikesheddy and could make hassle merging things in so meh.

--zvxU7vCc3P+aDYhz
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmFpyD0ACgkQJNaLcl1U
h9AaDQgAgGtwF4e6Cy8OuH+Y3EjvGOYWHK1l4qaJrL3MSElhZEt9xRNmyG5Kyx8f
tM7BVjn3M1CCnxh4hsjQDvIIbtYhDioRhFpGZaSvXkfblLLVtlUC93+gGl00jVAF
Uylnps1nQh2z9rMyBt1kiM1vnOJTLfz6SstxE7RDeZfJlXovAJJT4tXHG3Bsq6uB
iXn6Ejp+eegbzOGYLMPcvHvFIMz/MIGfnkZPjwcGEgRhYomG1MKdczAJnCAdMAwx
3o6iLc3g/Gqd4b9J4BNfj1OWaehyEC9+Q7fwtfZEiEo7LSEiUDT+Pl/p4wy9nZsJ
3vS1Uij/5VZvA2dlbqwogAarLoBk/w==
=FSRi
-----END PGP SIGNATURE-----

--zvxU7vCc3P+aDYhz--
