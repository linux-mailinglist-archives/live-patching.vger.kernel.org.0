Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0ECCB375509
	for <lists+live-patching@lfdr.de>; Thu,  6 May 2021 15:46:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233980AbhEFNrS (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 6 May 2021 09:47:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:52362 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233918AbhEFNrR (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Thu, 6 May 2021 09:47:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0F48B61027;
        Thu,  6 May 2021 13:46:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620308779;
        bh=DIhfGeaxAF5Hk1en/OO3GvL7gcgjS1Hb4ylbBzg5nFg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BP76V0dtuhX8xo3/WhwVAhFBvwQw/u0q/Bm4dNSZ7G+jWlXSGETVAWYMiWpc5FLLR
         JjrJ/ZmrdDfvr1yhrf0ckiraPrWFWODcxxdZGfyhxMDDS285T8WE563w85ZMv8oLxQ
         nbema7O1knM88idtTdkEuQ+dvPt95isyfmZR5UTHGpMeZt9ViZmIN6RxdzbqGfumbQ
         UzVj0LqXPvK+hbOGLlIGcicWuKbxuU62UVD0K4U5lqnC9z/7ZEHphFreZGpS3a6osC
         lXhqEng1JWhFws3MTGbSY2ha2AMZGG84+LTtq4QlkIA/ezLpwiItqYgG0QumEUOIZV
         8TuYmpLSNjF1g==
Date:   Thu, 6 May 2021 14:45:42 +0100
From:   Mark Brown <broonie@kernel.org>
To:     "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
Cc:     jpoimboe@redhat.com, mark.rutland@arm.com, jthierry@redhat.com,
        catalin.marinas@arm.com, will@kernel.org, jmorris@namei.org,
        pasha.tatashin@soleen.com, linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v3 2/4] arm64: Check the return PC against unreliable
 code sections
Message-ID: <20210506134542.GD4642@sirena.org.uk>
References: <65cf4dfbc439b010b50a0c46ec500432acde86d6>
 <20210503173615.21576-1-madvenka@linux.microsoft.com>
 <20210503173615.21576-3-madvenka@linux.microsoft.com>
 <20210504160508.GC7094@sirena.org.uk>
 <1bd2b177-509a-21d9-e349-9b2388db45eb@linux.microsoft.com>
 <0f72c4cb-25ef-ee23-49e4-986542be8673@linux.microsoft.com>
 <20210505164648.GC4541@sirena.org.uk>
 <9781011e-2d99-7f46-592c-621c66ea66c3@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="OaZoDhBhXzo6bW1J"
Content-Disposition: inline
In-Reply-To: <9781011e-2d99-7f46-592c-621c66ea66c3@linux.microsoft.com>
X-Cookie: If it ain't baroque, don't phiques it.
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org


--OaZoDhBhXzo6bW1J
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 05, 2021 at 01:48:21PM -0500, Madhavan T. Venkataraman wrote:
> On 5/5/21 11:46 AM, Mark Brown wrote:

> > I think that works even if it's hard to love the goto, might want some
> > defensiveness to ensure we can't somehow end up in an infinite loop with
> > a sufficiently badly formed stack.

> I could do something like this:

> unwind_frame()
> {
> 	int	i;
> 	...
>=20
> 	for (i =3D 0; i < MAX_CHECKS; i++) {
> 		if (!check_frame(tsk, frame))
> 			break;
> 	}

I think that could work, yes.  Have to see the actual code (and other
people's opinions!).

> If this is acceptable, then the only question is - what should be the val=
ue of
> MAX_CHECKS (I will rename it to something more appropriate)?

I'd expect something like 10 to be way more than we'd ever need, or we
could define it down to the 2 checks we expect to be possible ATM to be
conservative.  I'm tempted to be permissive if we have sufficient other
checks but I'm not 100% sure on that.

--OaZoDhBhXzo6bW1J
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmCT8wYACgkQJNaLcl1U
h9A5/Qf5AQzIK1iGk05+Ew7d4dR1Bd1YEuSiIlmDHZ+9WIWaZ0SR0GNG5mtqwX1B
pJhBkSXH7XsChPi1INElGPgOomaF8H2V2Z7C/QUI/KW1PqyQHmlFOQahHNPaRn6/
kxuuG1prGKfuPZ2+wFCdJZXHk1FWm/VpjVpiweX/E0kzx+V8NHNbKFwMuBSNCEH6
Jo8VMKsTSMghThbfpVAuYxPCaJB/kCaYU1KQL2Ktzq+n0CXsOdyHXolOE9D/0N8A
KgLCewUwIOpFXU+8gJspoxYXd1VIEzRG+lgKwCYuv6XBCZIOK2cXLvtPMU4xw9wj
mVA3fT2D8o0uPAQF+2Zy24K/f6wbgA==
=eeY2
-----END PGP SIGNATURE-----

--OaZoDhBhXzo6bW1J--
