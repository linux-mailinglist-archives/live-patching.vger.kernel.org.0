Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 557D032311A
	for <lists+live-patching@lfdr.de>; Tue, 23 Feb 2021 20:04:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233489AbhBWTEZ (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 23 Feb 2021 14:04:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:33126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233352AbhBWTEZ (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Tue, 23 Feb 2021 14:04:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 770F364E20;
        Tue, 23 Feb 2021 19:03:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614107024;
        bh=OWVPRYx/qOGlQZaj3jZjY2pJ3FRZCCL+4Zo9GoZc5dU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NVfl5PP+/McAcbuTJ3Z3CtLtYj+sXgAKeQCNdCEipxyPvbJXkgqjqc8qywVMQzOuV
         QNg+5AQhkT1XTlp1YtyoTbTq7HVtrTcyd32r/BsxY15+QluKCbuVqqSqvob2iPETVG
         BJWA83TwNFgdFz+O9/DEs4D2RuNoFITDUeu3F4JGw/gZ81WQxZUHmoFngDyfTsTUYI
         /Mro2jz23aWKBpb/d3D1lI/Njnhl9uFVq5iWbBPlcn7o58G+lu2KOLT7l22wXK6fLj
         qLv6n6/5IooEORAna1KL3hpR42y1ea27UEh8l1r6FB1SaZkT8kldOcY1PncoIhTJK7
         5R+2jGlnzgFpA==
Date:   Tue, 23 Feb 2021 19:02:40 +0000
From:   Mark Brown <broonie@kernel.org>
To:     madvenka@linux.microsoft.com
Cc:     mark.rutland@arm.com, jpoimboe@redhat.com, jthierry@redhat.com,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v1 1/1] arm64: Unwinder enhancements for reliable
 stack trace
Message-ID: <20210223190240.GK5116@sirena.org.uk>
References: <bc4761a47ad08ab7fdd555fc8094beb8fc758d33>
 <20210223181243.6776-1-madvenka@linux.microsoft.com>
 <20210223181243.6776-2-madvenka@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="M9pltayyoy9lWEMH"
Content-Disposition: inline
In-Reply-To: <20210223181243.6776-2-madvenka@linux.microsoft.com>
X-Cookie: Kilroe hic erat!
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org


--M9pltayyoy9lWEMH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 23, 2021 at 12:12:43PM -0600, madvenka@linux.microsoft.com wrot=
e:
> From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
>=20
> Unwinder changes
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

This is making several different changes so should be split into a patch
series - for example the change to terminate on a specific function
pointer rather than NULL and the changes to the exception/interupt
detection should be split.  Please see submitting-patches.rst for some
discussion about how to split things up.  In general if you've got a
changelog enumerating a number of different changes in a patch that's a
warning sign that it might be good split things up.

You should also copy the architecture maintainers (Catalin and Will) on
any arch/arm64 submissions.

> 	Unwinder return value
> 	=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>=20
> 	Currently, the unwinder returns -EINVAL for stack trace termination
> 	as well as stack trace error. Return -ENOENT for stack trace
> 	termination and -EINVAL for error to disambiguate. This idea has
> 	been borrowed from Mark Brown.

You could just include my patch for this in your series.

> Reliable stack trace function
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
>=20
> Implement arch_stack_walk_reliable(). This function walks the stack like
> the existing stack trace functions with a couple of additional checks:
>=20
> 	Return address check
> 	--------------------
>=20
> 	For each frame, check the return address to see if it is a
> 	proper kernel text address. If not, return -EINVAL.
>=20
> 	Exception frame check
> 	---------------------
>=20
> 	Check each frame to see if it is an EL1 exception frame. If it is,
> 	return -EINVAL.

Again, this should be at least one separate patch.  How does this ensure
that we don't have any issues with any of the various probe mechanisms?
If there's no need to explicitly check anything that should be called
out in the changelog.

Since all these changes are mixed up this is a fairly superficial
review of the actual code.

> +static notrace struct pt_regs *get_frame_regs(struct task_struct *task,
> +					      struct stackframe *frame)
> +{
> +	unsigned long stackframe, regs_start, regs_end;
> +	struct stack_info info;
> +
> +	stackframe =3D frame->prev_fp;
> +	if (!stackframe)
> +		return NULL;
> +
> +	(void) on_accessible_stack(task, stackframe, &info);

Shouldn't we return NULL if we are not on an accessible stack?

> +static notrace int update_frame(struct task_struct *task,
> +				struct stackframe *frame)

This function really needs some documentation, the function is just
called update_frame() which doesn't say what sort of updates it's
supposed to do and most of the checks aren't explained, not all of them
are super obvious.

> +{
> +	unsigned long lsb =3D frame->fp & 0xf;
> +	unsigned long fp =3D frame->fp & ~lsb;
> +	unsigned long pc =3D frame->pc;
> +	struct pt_regs *regs;
> +
> +	frame->exception_frame =3D false;
> +
> +	if (fp =3D=3D (unsigned long) arm64_last_frame &&
> +	    pc =3D=3D (unsigned long) arm64_last_func)
> +		return -ENOENT;
> +
> +	if (!lsb)
> +		return 0;
> +	if (lsb !=3D 1)
> +		return -EINVAL;
> +
> +	/*
> +	 * This looks like an EL1 exception frame.

For clarity it would be good to spell out the properties of an EL1
exception frame.  It is not clear to me why we don't reference the frame
type information the unwinder already records as part of these checks.

In general, especially for the bits specific to reliable stack trace, I
think we want to err on the side of verbosity here so that it is crystal
clear what all the checks are supposed to be doing and it's that much
easier to tie everything through to the requirements document.

--M9pltayyoy9lWEMH
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmA1UU8ACgkQJNaLcl1U
h9DY+wf/XxqhEX5mlYvlYsFaJNVbABpQyIwMDAwPTJzbOtdlbHe6Cdd3n62K5YxI
aY5W+gtCkT2FmFeYJoWiTwnXrt7gQcECVMR7jCi8K7UU1buzIFxkj46ppa6IPxOf
6tGAHGOFQGqlQuqPCa86r2n5kaoiEY/GiAQSzjGnGytDQAzBOehlXkzCT2sp0zBk
Ghg8AUdK1JLguJrG+aZxm9G8OZQAdxhpFnddpOgrFBXQ5A/N0+lijoKfj+dm5blc
2ZrU/Q+TgQ9I+9O/a3Dn7YMozmh6dYa+lv3kDT+rSWSj2D7RYlBQAIZXmMuGqiPV
nHt5oqNv8tzROK78AlOmzX6IJyfJ+A==
=QkfM
-----END PGP SIGNATURE-----

--M9pltayyoy9lWEMH--
