Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6086435F3B3
	for <lists+live-patching@lfdr.de>; Wed, 14 Apr 2021 14:29:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350879AbhDNMYx (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 14 Apr 2021 08:24:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:59526 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350878AbhDNMYu (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Wed, 14 Apr 2021 08:24:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F17706105A;
        Wed, 14 Apr 2021 12:24:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618403068;
        bh=j9wxhOwuWa7eyWiZdHRpPOIyObN63pRYdbSKNnanZqs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UKg3kofB3tFoKw8vYxOlvzZXWsnMbj5YRHpcbHvD6QZ2pgMwPoRWUhNdryU98YVFX
         qzQul+qj+u6It+YsW2xxYF2Q6iN9epOcYtOkVEBwba0pbfZCIoPdJzsb3ZDkRZCzJ+
         DchJ0mXbb6U5QPXFsYDhRrvrJeoNkZn3Hhz00L9b6QY/jTjyOx/AJ0EDm7hPIpGjDQ
         wS4VG95syoTpaWAUUseKNBipFho0jbhP2Js4lfydHQs6njuqhNlYGziZoPHvrawU8B
         DTv5kwgumvc8R/NMGCW4MA3xvUYZJOl4XTu6GLpjxSfJoodz011tNRgmoKpleCc7Lw
         eIPAuVDrpvwBw==
Date:   Wed, 14 Apr 2021 13:24:05 +0100
From:   Mark Brown <broonie@kernel.org>
To:     Josh Poimboeuf <jpoimboe@redhat.com>
Cc:     "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>,
        Mark Rutland <mark.rutland@arm.com>, jthierry@redhat.com,
        catalin.marinas@arm.com, will@kernel.org,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [RFC PATCH v2 0/4] arm64: Implement stack trace reliability
 checks
Message-ID: <20210414122405.GB4535@sirena.org.uk>
References: <705993ccb34a611c75cdae0a8cb1b40f9b218ebd>
 <20210405204313.21346-1-madvenka@linux.microsoft.com>
 <20210409120859.GA51636@C02TD0UTHF1T.local>
 <20210409213741.kqmwyajoppuqrkge@treble>
 <8c30ec5f-b51e-494f-5f6c-d2f012135f69@linux.microsoft.com>
 <20210409223227.rvf6tfhvgnpzmabn@treble>
 <20210412165933.GD5379@sirena.org.uk>
 <20210413225310.k64wqjnst7cia4ft@treble>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="b5gNqxB1S1yM7hjW"
Content-Disposition: inline
In-Reply-To: <20210413225310.k64wqjnst7cia4ft@treble>
X-Cookie: George Orwell was an optimist.
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org


--b5gNqxB1S1yM7hjW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 13, 2021 at 05:53:10PM -0500, Josh Poimboeuf wrote:
> On Mon, Apr 12, 2021 at 05:59:33PM +0100, Mark Brown wrote:

> > Some more explict pointer to live patching as the only user would
> > definitely be good but I think the more important thing would be writing
> > down any assumptions in the API that aren't already written down and

> Something like so?

Yeah, looks reasonable - it'll need rebasing against current code as I
moved the docs in the source out of the arch code into the header this
cycle (they were copied verbatim in a couple of places).

>  #ifdef CONFIG_ARCH_STACKWALK
> =20
>  /**
> - * stack_trace_consume_fn - Callback for arch_stack_walk()
> + * stack_trace_consume_fn() - Callback for arch_stack_walk()
>   * @cookie:	Caller supplied pointer handed back by arch_stack_walk()
>   * @addr:	The stack entry address to consume
>   *

> @@ -35,7 +35,7 @@ unsigned int stack_trace_save_user(unsigned long *store=
, unsigned int size);
>   */
>  typedef bool (*stack_trace_consume_fn)(void *cookie, unsigned long addr);
>  /**
> - * arch_stack_walk - Architecture specific function to walk the stack
> + * arch_stack_walk() - Architecture specific function to walk the stack
>   * @consume_entry:	Callback which is invoked by the architecture code for
>   *			each entry.
>   * @cookie:		Caller supplied pointer which is handed back to

These two should be separated.

--b5gNqxB1S1yM7hjW
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmB23uQACgkQJNaLcl1U
h9DcIQf7BVTnQ3HyLZEooh8Z6mZHAE99J+dWe2aRydUFd3uPgEbKAXt1TAVF1c6f
H9FtaFpd5if0z1Dz3WSsDqSoSqn7aX5znp8ZtYouehvObP5Xmce7mSXqGV1F7ulC
B2nAG8yjFICW9UgdOf8koEFK/flWiueSQwV5Q0DlX+QewBk3e+ziCc/CeC7S5jnk
8mmGpaMVB1E6g3Mu95ShYWLir8Hl4cM+50IOvHq4Smqr9Mm/ma36NtLYI2ecYpS5
JjsXrRCrUnjBOF95vg16MuD6OLTUhR8A4/cIwDbLn1Rj1iM1gd29xRtZPdAF1l3p
VqXJIEXWXBuV5rUljTfRYctLOm7qXg==
=W+NU
-----END PGP SIGNATURE-----

--b5gNqxB1S1yM7hjW--
