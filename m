Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8CD8351E45
	for <lists+live-patching@lfdr.de>; Thu,  1 Apr 2021 20:53:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237853AbhDASho (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 1 Apr 2021 14:37:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:57606 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237180AbhDASdC (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Thu, 1 Apr 2021 14:33:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B143A61365;
        Thu,  1 Apr 2021 15:27:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617290875;
        bh=6OyN9qDE9W6bki0U8Z4PuTzkFQGhqo+Vs3sw4cGUYWk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nKaF72NUeleGdNu0kKTVFRNk2MtPL/Ll8VRJjNCyJNTndvhTiuzsn5n81GUvaTwJT
         /5pI6YSDz4UTt1k/i+Bys6f73DM6ZnHszfmzjWATodd1GCZ9CaYUD6d6uhwqCkQqpc
         5nCl6HVjJgndYKdJDZXD0MBJivD93+q0cFuhVRQNylYJTzkGwVPhJyGrEUFeYqLnT+
         rIsGW9kB+ivAhhohQUCoVPMO3efByGG4PLeI0u23IitcVFHAUwWvXKyiBgJnhKgMv0
         2EYXufbsnlJBdjp7kjZYcp+a9eQnOfs75V/wt2NbPfnNq9oO3p7dMh/koSIJaVs2d+
         oH4OblOL2fsKQ==
Date:   Thu, 1 Apr 2021 16:27:41 +0100
From:   Mark Brown <broonie@kernel.org>
To:     madvenka@linux.microsoft.com
Cc:     mark.rutland@arm.com, jpoimboe@redhat.com, jthierry@redhat.com,
        catalin.marinas@arm.com, will@kernel.org,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v1 1/4] arm64: Implement infrastructure for stack
 trace reliability checks
Message-ID: <20210401152741.GK4758@sirena.org.uk>
References: <77bd5edeea72d44533c769b1e8c0fea7a9d7eb3a>
 <20210330190955.13707-1-madvenka@linux.microsoft.com>
 <20210330190955.13707-2-madvenka@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="NhBACjNc9vV+/oop"
Content-Disposition: inline
In-Reply-To: <20210330190955.13707-2-madvenka@linux.microsoft.com>
X-Cookie: You can't take damsel here now.
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org


--NhBACjNc9vV+/oop
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 30, 2021 at 02:09:52PM -0500, madvenka@linux.microsoft.com wrot=
e:
> From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
>=20
> Implement a check_reliability() function that will contain checks for the
> presence of various features and conditions that can render the stack tra=
ce
> unreliable.

This looks good to me with one minor stylistic thing:

> +/*
> + * Special functions where the stack trace is unreliable.
> + */
> +static struct function_range	special_functions[] =3D {
> +	{ 0, 0 }
> +};

Might be good to put a comment here saying that this is terminating the
list rather than detecting a NULL function pointer:

	{ /* sentinel */ }

is a common idiom for that.

Given that it's a fixed array we could also...

> +	for (func =3D special_functions; func->start; func++) {
> +		if (pc >=3D func->start && pc < func->end)

=2E..do these as

	for (i =3D 0; i < ARRAY_SIZE(special_functions); i++)=20

so you don't need something like that, though that gets awkward when you
have to write out special_functions[i].field a lot.

So many different potential colours for the bikeshed!

--NhBACjNc9vV+/oop
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmBl5mwACgkQJNaLcl1U
h9C7XAf8CStzmgOUDBXGUY/gd9BnKtuzEP7qyRDJ/4Qn521DOcsK5ga4CG1FGT9U
2BEaooZ5dqyee1IgpO3p4yTDQgLTARXeWK0No6mfiPoXTnR0NnODCclBW5jiYAkI
yMB4KzOexgmUnuYToDl0p3SDtKzHLtpo+bjgnfEom1sQlHfFursZhBVC9ERJnhF3
yw2Oe0yRTmKbkT7pKzSKspqOxlfRii9L8G/2phIDaQiTdDL/ul/1hPeLJmh/peiO
j4WM5WnXdCrHYwje1U3deGU5zx9eEBPQF6S32t6AuwTis5SfuNQ53bOaRda+GeZL
/MBvmhuX0TRqL5IzkAktpUtPPcZmFA==
=Wi9w
-----END PGP SIGNATURE-----

--NhBACjNc9vV+/oop--
