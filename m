Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13DEB34679D
	for <lists+live-patching@lfdr.de>; Tue, 23 Mar 2021 19:28:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231979AbhCWS2M (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 23 Mar 2021 14:28:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:48770 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231862AbhCWS2B (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Tue, 23 Mar 2021 14:28:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3C94B619C0;
        Tue, 23 Mar 2021 18:28:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616524080;
        bh=ZZ/sbfEWjmjWbM+sY6+EEzhfSIm8CwgOZMeCjqk2aiI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TM9WZvHfrbZ7xt0+5JhUBYMBSINu9iyvAhbMK1MmUCUz229ezyqdJ5EFldRL6nWhf
         GHHG1R9tjP5EqrCPsbN4x0+cpC7nNDCBGZrczhMp2Xd0CkCY2zNu7Jz4vYgJ5tOvnH
         eO/2H6cWdzfaLX1B4hp+4Kp55X7o0WnVxZKoVqOzy78GuhsjQfYbqUQTDcieIZL4lC
         5Em5Pru//FeQnUHJXRgJohWNLh48hb1dYzEbYOZLT5WOdVDdd2uSaJpHzbVicpyU3f
         VHP3yT5Ar9uPls7uW6U6qiF9SKyohmEJIx8YFdvnDk5NTSibPlCpACTAESne9oiKcp
         DeNsi8r94EC0A==
Date:   Tue, 23 Mar 2021 18:27:53 +0000
From:   Mark Brown <broonie@kernel.org>
To:     "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
Cc:     Mark Rutland <mark.rutland@arm.com>, jpoimboe@redhat.com,
        jthierry@redhat.com, catalin.marinas@arm.com, will@kernel.org,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 5/8] arm64: Detect an FTRACE frame and mark a
 stack trace unreliable
Message-ID: <20210323182753.GE5490@sirena.org.uk>
References: <20210323105118.GE95840@C02TD0UTHF1T.local>
 <2167f3c5-e7d0-40c8-99e3-ae89ceb2d60e@linux.microsoft.com>
 <20210323133611.GB98545@C02TD0UTHF1T.local>
 <ccd5ee66-6444-fac9-4c7b-b3bdabf1b149@linux.microsoft.com>
 <f9e21fe1-e646-bb36-c711-94cbbc60af8a@linux.microsoft.com>
 <20210323145734.GD98545@C02TD0UTHF1T.local>
 <a21e701d-dbcb-c48d-4ba6-774cfcfe1543@linux.microsoft.com>
 <a38e4966-9b0d-3e51-80bd-acc36d8bee9b@linux.microsoft.com>
 <20210323170236.GF98545@C02TD0UTHF1T.local>
 <bc450f09-1881-9a9c-bfbc-5bb31c01d8ce@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="+SfteS7bOf3dGlBC"
Content-Disposition: inline
In-Reply-To: <bc450f09-1881-9a9c-bfbc-5bb31c01d8ce@linux.microsoft.com>
X-Cookie: Formatted to fit your screen.
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org


--+SfteS7bOf3dGlBC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Mar 23, 2021 at 12:23:34PM -0500, Madhavan T. Venkataraman wrote:
> On 3/23/21 12:02 PM, Mark Rutland wrote:

> > 3. Figure out exception boundary handling. I'm currently working to
> >    simplify the entry assembly down to a uniform set of stubs, and I'd
> >    prefer to get that sorted before we teach the unwinder about
> >    exception boundaries, as it'll be significantly simpler to reason
> >    about and won't end up clashing with the rework.

> So, here is where I still have a question. Is it necessary for the unwinder
> to know the exception boundaries? Is it not enough if it knows if there are
> exceptions present? For instance, using something like num_special_frames
> I suggested above?

For reliable stack trace we can live with just flagging things as
unreliable when we know there's an exception boundary somewhere but (as
Mark mentioned elsewhere) being able to actually go through a subset of
exception boundaries safely is likely to help usefully improve the
performance of live patching, and for defensiveness we want to try to
detect during an actual unwind anyway so it ends up being a performance
improvment and double check rather than saving us code.  Better
understanding of what's going on in the presence of exceptions may also
help other users of the unwinder which can use stacks which aren't
reliable get better results.

--+SfteS7bOf3dGlBC
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmBaMygACgkQJNaLcl1U
h9DlBAf/VDhf95shcrw6CnGs6PtiVyFMVP2UhH5a5mOOodvlWpsmf6mo+iGsWAvO
Hp8mEVFU/FTSVBgmDjoyI52XzwYaqrGF0dwPSVu7NarlElFtk0ZcTKgO20bOfqPb
SVfgGp+eOwe/Tcs0VZm7nNmxU+1UJ8R8quEqQ5hsxR5C0USubAV8MQcRmhie3kiG
XzWKXeUcrchV8LnB42XyMRZNDSYf1DpEyB17+zYCNadHGrgBc7T186G3/Ace/R+g
LsgS+JqZS6/K5RnxbUVz4WCI1CzC1e7gvNAN+ItCFWGJ3cH6d/Bazo6Tqu37ZQEj
BaepHrBhtSiqvSTW85A/J2DsUYLi6Q==
=cyeR
-----END PGP SIGNATURE-----

--+SfteS7bOf3dGlBC--
