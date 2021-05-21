Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C817938CCBB
	for <lists+live-patching@lfdr.de>; Fri, 21 May 2021 19:53:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237060AbhEURyr (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 21 May 2021 13:54:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:53474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234912AbhEURyq (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Fri, 21 May 2021 13:54:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B65DC608FE;
        Fri, 21 May 2021 17:53:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621619602;
        bh=d4iEeT3kENazUfx6vj5fy6JPv4wS8jBR0cwrDXv+FYk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WggyX5pUYy1jsxw7nVsbfw7cZlt5OajIOd+gRsgSNRX/LokMp+maZhTvwQwBfeV7C
         PrLpRO5zbAKj2sbs1rrzeRg17b/qWLI6ak/nDhp4nl1eA298HJ8gFcK6HTYyZq/iAB
         qPnNHk5Lt8r4l/uixt4RgjfzdLcw8evif1M8UNUlThuoFukpWcARi5SqmXCAXG6ld4
         7jL9irJQw33Tt9bf2a5RnL4gmH+3/gyHRCAfdDrD3BTeuCKX5kFK/Fv/bHSJaRFFkW
         ZQSEgLs3wowyzkveJNAQmsku6Llw6+fCSEuABO0yZ6z0Cc12VGB1cDToc6p/fCcqNR
         rSDHF/Rs8r0OQ==
Date:   Fri, 21 May 2021 18:53:18 +0100
From:   Mark Brown <broonie@kernel.org>
To:     "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
Cc:     mark.rutland@arm.com, jpoimboe@redhat.com, ardb@kernel.org,
        jthierry@redhat.com, catalin.marinas@arm.com, will@kernel.org,
        jmorris@namei.org, pasha.tatashin@soleen.com,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v4 1/2] arm64: Introduce stack trace reliability
 checks in the unwinder
Message-ID: <20210521175318.GF5825@sirena.org.uk>
References: <68eeda61b3e9579d65698a884b26c8632025e503>
 <20210516040018.128105-1-madvenka@linux.microsoft.com>
 <20210516040018.128105-2-madvenka@linux.microsoft.com>
 <20210521161117.GB5825@sirena.org.uk>
 <a2a32666-c27e-3a0f-06b2-b7a2baa7e0f1@linux.microsoft.com>
 <20210521174242.GD5825@sirena.org.uk>
 <26c33633-029e-6374-16e6-e9418099da95@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="1Ow488MNN9B9o/ov"
Content-Disposition: inline
In-Reply-To: <26c33633-029e-6374-16e6-e9418099da95@linux.microsoft.com>
X-Cookie: Do not write below this line.
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org


--1Ow488MNN9B9o/ov
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, May 21, 2021 at 12:47:13PM -0500, Madhavan T. Venkataraman wrote:
> On 5/21/21 12:42 PM, Mark Brown wrote:

> > Like I say we may come up with some use for the flag in error cases in
> > future so I'm not opposed to keeping the accounting there.

> So, should I leave it the way it is now? Or should I not set reliable = false
> for errors? Which one do you prefer?

> Josh,

> Are you OK with not flagging reliable = false for errors in unwind_frame()?

I think it's fine to leave it as it is.

--1Ow488MNN9B9o/ov
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmCn840ACgkQJNaLcl1U
h9B64Af+PKOojLf3mxi8xJnWbYRZtZbrmPoHiSiT/enzT0Y/XjSubDQOp0pxbeJT
ah0rvSPhTYWO7uUm2SmBcaWUN0eidHRotNWCvPadRISC6JwLGcS3qmAnTdZ8JNXE
4NT3oyLC8yAFI6vv5NXf9SwFW+puPPWS7quktVWiJ5Xb12vd+5x+n5lPcrMinImi
5sWIcINkCXrthJTudokrCtuaNLp0aDQVTwQTmLBQ7q2fjAxfiylvxi6J556/YUFQ
UvtgW9zT7JjhFuEoeiO3/QekwUijHzelN0inaw0kX8rtaD3FrPqSI8JYaBXDEC4u
/zkIcbJJEvSDyZG8v/yUD+CeN+9CwA==
=yZ+q
-----END PGP SIGNATURE-----

--1Ow488MNN9B9o/ov--
