Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED34A3896A8
	for <lists+live-patching@lfdr.de>; Wed, 19 May 2021 21:28:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229689AbhEST3g (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 19 May 2021 15:29:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:55356 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229543AbhEST3g (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Wed, 19 May 2021 15:29:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B05376112F;
        Wed, 19 May 2021 19:28:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621452496;
        bh=Lk3jBXuZ1fbFKB/aRqyOiK+TZ31lR6R/DqCsZCHeyEM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Q/MjRkDkEUJHWvk6moJrajtdTG8RF0swjf0bCI4Vdb4EmT6ylLtmd0iZsVEWtUaez
         N0zDtwsciGX9NKoSSWIW9vXCnlFYTucJ041dkBmZ7e1rJTw6V6L9o1eO4NJoZcwYev
         qS3DSPd1FpvaSI6Sfiz7ZEO3R3iPhp4J4g+F5HAeK6ySmSFrKH3HtotHWnMZnC7Gx6
         2tqNDQ5LHLPzEaEYmljAv0QvToq85+lyXOSOCfWls5vVeu302LIjsvszYSWAjCNW6K
         zEJ5dAIT8tkn2H3SmKz0NmdocR/BdTeZ71PtnhnxszAR309iQRJbOn9qXlzHOWKguW
         DeYimFe9qtJbA==
Date:   Wed, 19 May 2021 20:27:30 +0100
From:   Mark Brown <broonie@kernel.org>
To:     madvenka@linux.microsoft.com
Cc:     mark.rutland@arm.com, jpoimboe@redhat.com, ardb@kernel.org,
        jthierry@redhat.com, catalin.marinas@arm.com, will@kernel.org,
        jmorris@namei.org, pasha.tatashin@soleen.com,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v4 2/2] arm64: Create a list of SYM_CODE functions,
 blacklist them in the unwinder
Message-ID: <20210519192730.GI4224@sirena.org.uk>
References: <68eeda61b3e9579d65698a884b26c8632025e503>
 <20210516040018.128105-1-madvenka@linux.microsoft.com>
 <20210516040018.128105-3-madvenka@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="MPkR1dXiUZqK+927"
Content-Disposition: inline
In-Reply-To: <20210516040018.128105-3-madvenka@linux.microsoft.com>
X-Cookie: There's no time like the pleasant.
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org


--MPkR1dXiUZqK+927
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, May 15, 2021 at 11:00:18PM -0500, madvenka@linux.microsoft.com wrot=
e:
> From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
>=20
> The unwinder should check if the return PC falls in any function that
> is considered unreliable from an unwinding perspective. If it does,
> mark the stack trace unreliable.

Other than the naming issue this makes sense to me, I'll try to go
through the first patch properly in the next few days.

--MPkR1dXiUZqK+927
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmClZqEACgkQJNaLcl1U
h9B77Qf+M9+zHwxJNPl/vKY7Sle87Tgz3CrLIzIALiGlYZoKR6GmoGp1x+pA8XGw
M/yVldVJE3DfEwBe5mPKLX+35CbSSyoAzAC00+KV66IwxaDbiAIFAMCtDfMh0tCr
QFaglXXmWV6g4viO/v2+kpFY9PIhmUzyp3VtFFmaVaIdTmRiLx4+1UAGcmqMMopB
CRIgjuaf0wsvwnXFQNqMxjrCx1ndY3XTHwRkxX5+06b8vUoIsqbZ1kvhNQz/cu39
DWSn9OE2R1mIFwhG26yeONdeRUGXSYt7AmyRt7lcXX94v4J77FzrWfxJ5WaJPhz1
MzcC6sZOVksed1e2vOwEpcDz53Y/gg==
=+c7T
-----END PGP SIGNATURE-----

--MPkR1dXiUZqK+927--
