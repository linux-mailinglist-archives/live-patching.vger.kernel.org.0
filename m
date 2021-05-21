Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC08138CBDE
	for <lists+live-patching@lfdr.de>; Fri, 21 May 2021 19:18:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230164AbhEURTg (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 21 May 2021 13:19:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:46190 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230014AbhEURTf (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Fri, 21 May 2021 13:19:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ED51E6109F;
        Fri, 21 May 2021 17:18:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621617492;
        bh=vkbnUCjalAV9JIDorYwWjpk0vHbw6VNs/bfMmImD4qo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FG7uyuUnmYoAejnNMJ9jxpsW7EWIvoK3HBjV3oga9yZYWsis6nh9Uga5//RH+RwJT
         0QykYE9l/e3tpfkl0NnOVgs6IuxMv1/YgcQNsNgBiDAIEYID5e/KejQ3h7fG0jwzWk
         PDpPUjLXRohXOBEYdWit2l30+wAn4EKFs1hCpXP/s6qeVLQWnCDL89E19Yxz7fstfE
         kdCCA63/6yZAGoFX52hocCMvEFCXHG7TEPgrnJj2zcADNDlpAm4cAU1nweskKw36Zj
         U1bRfunKYBD8kXeESyrT38Jer8LiykDquU0aGGdhq+lJvIRA4BSDF0YRBVyTswUppE
         mk9pmRIZv1uKg==
Date:   Fri, 21 May 2021 18:18:08 +0100
From:   Mark Brown <broonie@kernel.org>
To:     madvenka@linux.microsoft.com
Cc:     mark.rutland@arm.com, jpoimboe@redhat.com, ardb@kernel.org,
        jthierry@redhat.com, catalin.marinas@arm.com, will@kernel.org,
        jmorris@namei.org, pasha.tatashin@soleen.com,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v4 0/2] arm64: Stack trace reliability checks in the
 unwinder
Message-ID: <20210521171808.GC5825@sirena.org.uk>
References: <68eeda61b3e9579d65698a884b26c8632025e503>
 <20210516040018.128105-1-madvenka@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="jousvV0MzM2p6OtC"
Content-Disposition: inline
In-Reply-To: <20210516040018.128105-1-madvenka@linux.microsoft.com>
X-Cookie: Do not write below this line.
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org


--jousvV0MzM2p6OtC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, May 15, 2021 at 11:00:16PM -0500, madvenka@linux.microsoft.com wrot=
e:

> Special cases
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>=20
> Some special cases need to be mentioned:

I think it'd be good if more of this cover letter, especially sections
like this which cover the tricky bits, ended up in the code somehow -
it's recorded here and will be in the list archive but that's not the
most discoverable place so increases the maintainance burden.  It'd be
great to be able to compare the code directly with the reliable
stacktrace requirements document and see everything getting ticked off,
actually going all the way there might be too much and loose the code in
the comments but I think we can get closer to it than we are.  Given
that a lot of this stuff rests on the denylist perhaps some comments
just before it's called would be a good place to start?

> 	- EL1 interrupt and exception handlers end up in sym_code_ranges[].
> 	  So, all EL1 interrupt and exception stack traces will be considered
> 	  unreliable. This the correct behavior as interrupts and exceptions

This stuff about exceptions and preemption is a big one, rejecting any
exceptions makes a whole host of things easier (eg, Mark Rutland raised
interactions between non-AAPCS code and PLTs as being an issue but if
we're able to reliably reject stacks featuring any kind of preemption
anyway that should sidestep the issue).

> Performance
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

> Currently, unwinder_blacklisted() does a linear search through
> sym_code_functions[]. If reviewers prefer, I could sort the
> sym_code_functions[] array and perform a binary search for better
> performance. There are about 80 entries in the array.

If people are trying to live patch a very busy/big system then this
could be an issue, equally there's probably more people focused on
getting boot times as fast as possible than live patching.  Deferring
the initialisation to first use would help boot times with or without
sorting, without numbers I don't actually know that sorting is worth the
effort or needs doing immediately - obvious correctness is also a
benefit!  My instinct is that for now it's probably OK leaving it as a
linear scan and then revisiting if it's not adequately performant, but
I'd defer to actual users there.

--jousvV0MzM2p6OtC
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmCn608ACgkQJNaLcl1U
h9D0Zwf/QFxtuWGQtSmtAJiy3Fib/vh2CLbcYP0qvM25Ius+2M2/EcCvVEUrUyRH
fOgOy1PnzRQi/kQUiXia7XI5gT+0dhCm95ZqlNgXdMxDst0UPDgI3VTzA6Qc7NFq
RN0hZEei67BuAH0oLm3ZNQOxlhIas4JXZwf75un8C2rxT37sUSELBT17KqrooFJl
jgml5qc6jXo7uQk7uMzdv9zLYs/a2JYypEkF/FLLYZFVxWsOdAuWHxh8xUz65Rik
COA/k9MiAWZspXgnjIYnhL3864GtYwIArij1uM4uarq6uD2nav0ZVLgDMc63nTHb
basklX2I4DuTE2DVPIX6DNTpWcAK2g==
=hgtS
-----END PGP SIGNATURE-----

--jousvV0MzM2p6OtC--
