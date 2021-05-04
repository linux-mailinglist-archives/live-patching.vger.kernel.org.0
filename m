Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D528372D89
	for <lists+live-patching@lfdr.de>; Tue,  4 May 2021 18:05:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231274AbhEDQGj (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 4 May 2021 12:06:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:54142 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230501AbhEDQGj (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Tue, 4 May 2021 12:06:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AE419611AC;
        Tue,  4 May 2021 16:05:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620144344;
        bh=LQnqHtgDaRPNkjrKh1YzLKOz7oKbXuyUuFN79710JX0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RU7giC9qxC4+vQOZ+3/CorOhHdo9aKMH3Oi/5MmN6nao4PCFW6aP3xNS2LgW2yiwO
         VYH9AsOgV9lCu7jp2JgDAb5O6uq6lRgtsc/Dh9plbwHQ8tdXfNZ26ZdICT/Yg/yUpr
         CT0HKeZ1Lyi8u1cVswKkSy8S8Y2Ca2v4B9gzk/D48kjsFkEXZ9rjZlBXioZ1kHdo6p
         UoVK9DyyYhYtskyIYXDseuj+cBdevRdSSV0A5DOvttZcQ6eaEU1uY1Tior3fyZcEDC
         xHDkGl2rr2fg3xFK9CVDEU0zWzLfSAldBfuYS7wTHCYej+7mYdM9jTJjHgGzYSNOhz
         am1Uf60sNmyHg==
Date:   Tue, 4 May 2021 17:05:08 +0100
From:   Mark Brown <broonie@kernel.org>
To:     madvenka@linux.microsoft.com
Cc:     jpoimboe@redhat.com, mark.rutland@arm.com, jthierry@redhat.com,
        catalin.marinas@arm.com, will@kernel.org, jmorris@namei.org,
        pasha.tatashin@soleen.com, linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v3 2/4] arm64: Check the return PC against unreliable
 code sections
Message-ID: <20210504160508.GC7094@sirena.org.uk>
References: <65cf4dfbc439b010b50a0c46ec500432acde86d6>
 <20210503173615.21576-1-madvenka@linux.microsoft.com>
 <20210503173615.21576-3-madvenka@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="LwW0XdcUbUexiWVK"
Content-Disposition: inline
In-Reply-To: <20210503173615.21576-3-madvenka@linux.microsoft.com>
X-Cookie: MY income is ALL disposable!
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org


--LwW0XdcUbUexiWVK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, May 03, 2021 at 12:36:13PM -0500, madvenka@linux.microsoft.com wrot=
e:
> From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
>=20
> Create a sym_code_ranges[] array to cover the following text sections that
> contain functions defined as SYM_CODE_*(). These functions are low-level

This makes sense to me - a few of bikesheddy comments below but nothing
really substantive.

> +static struct code_range *lookup_range(unsigned long pc)

This feels like it should have a prefix on the name (eg, unwinder_)
since it looks collision prone.  Or lookup_code_range() rather than just
plain lookup_range().

> +{
+       struct code_range *range;
+        =20
+       for (range =3D sym_code_ranges; range->start; range++) {

It seems more idiomatic to use ARRAY_SIZE() rather than a sentinel here,
the array can't be empty.

> +	range =3D lookup_range(frame->pc);
> +
>  #ifdef CONFIG_FUNCTION_GRAPH_TRACER
>  	if (tsk->ret_stack &&
>  		frame->pc =3D=3D (unsigned long)return_to_handler) {
> @@ -118,9 +160,21 @@ int notrace unwind_frame(struct task_struct *tsk, st=
ruct stackframe *frame)
>  			return -EINVAL;
>  		frame->pc =3D ret_stack->ret;
>  		frame->pc =3D ptrauth_strip_insn_pac(frame->pc);
> +		return 0;
>  	}

Do we not need to look up the range of the restored pc and validate
what's being pointed to here?  It's not immediately obvious why we do
the lookup before handling the function graph tracer, especially given
that we never look at the result and there's now a return added skipping
further reliability checks.  At the very least I think this needs some
additional comments so the code is more obvious.

--LwW0XdcUbUexiWVK
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmCRcLMACgkQJNaLcl1U
h9Dlkwf/RkumClFzg2EgVwyfn1QnbdeIeQFq8pxNlNucXsw5TpKKKpftgrfRVQpb
utXdhG5e6UiZTj6cr9IOQ0um/2NFhgIiAEuPqn8A5JMR0f6NL/GqIZp5IdkeHr3K
URnnqzC4Z88+EEFJ9uzPEsyhJa805RCsBFCWc5Z373b8g59J4lau2u/z1JebgmC7
Su91Z8iIG/exZVGoeUBPo8HUgpcHoXh5YAqBFXbuabAAeJ7Z368wpLxTUu5M6hLM
MR9DObikmqXLRpax7l5uVTRYHKgE6LbfGBns99ASI0PrcP7N0sPBwBxiI0ALaBgz
Jx6slQ6vOHRl9MBVmPI8peoeaC+kPw==
=d+Gv
-----END PGP SIGNATURE-----

--LwW0XdcUbUexiWVK--
