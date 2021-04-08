Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70E72358A61
	for <lists+live-patching@lfdr.de>; Thu,  8 Apr 2021 18:58:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231676AbhDHQ6z (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 8 Apr 2021 12:58:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:43868 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231566AbhDHQ6z (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Thu, 8 Apr 2021 12:58:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 32675610CB;
        Thu,  8 Apr 2021 16:58:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617901123;
        bh=PZNfTKA5x4FKKMhvyT5cCCUAlEeo8PRtWyGGv8cGvvo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=t61RSwV1ntvkbNH52ixOuqu9drh9ySIlZ/f5pq5wqtlgstkz/MWkNd1guMnGwXlZo
         O0AnUrJPDni8kfEheiGDsTDdVthmgTDVrrSh0d8aeY9yo23/ITcE8rvA988zp2IW6L
         vExr3mwpgkwaBXe1NtNroyDPUCQn0GKUz74GZt89FZDlMzy6dm/dius/VtwsqL/Q72
         sDFxiioJJQD+2k909GMSh6HZ4Vcgdcwo6HAElAYSs5qxbh9QEg/NoQstH+2E66ng8T
         aGSKUQikK8iXgGb5iMdbBe3+J4jt4q7Dd8jAU62Lq8HL1GCYbmePZBpt1+byF17ngs
         hT5PlHSlgnrQg==
Date:   Thu, 8 Apr 2021 17:58:25 +0100
From:   Mark Brown <broonie@kernel.org>
To:     madvenka@linux.microsoft.com, mark.rutland@arm.com
Cc:     jpoimboe@redhat.com, jthierry@redhat.com, catalin.marinas@arm.com,
        will@kernel.org, linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 3/4] arm64: Detect FTRACE cases that make the
 stack trace unreliable
Message-ID: <20210408165825.GP4516@sirena.org.uk>
References: <705993ccb34a611c75cdae0a8cb1b40f9b218ebd>
 <20210405204313.21346-1-madvenka@linux.microsoft.com>
 <20210405204313.21346-4-madvenka@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="LfQcPIWFRhGivmDw"
Content-Disposition: inline
In-Reply-To: <20210405204313.21346-4-madvenka@linux.microsoft.com>
X-Cookie: Editing is a rewording activity.
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org


--LfQcPIWFRhGivmDw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 05, 2021 at 03:43:12PM -0500, madvenka@linux.microsoft.com wrot=
e:
> From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
>=20
> When CONFIG_DYNAMIC_FTRACE_WITH_REGS is enabled and tracing is activated
> for a function, the ftrace infrastructure is called for the function at
> the very beginning. Ftrace creates two frames:

This looks good to me however I'd really like someone who has a firmer
understanding of what ftrace is doing to double check as it is entirely
likely that I am missing cases here, it seems likely that if I am
missing stuff it's extra stuff that needs to be added and we're not
actually making use of the reliability information yet.

--LfQcPIWFRhGivmDw
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmBvNjEACgkQJNaLcl1U
h9DvhAgAgAJBXnn2mXE3bqxCAxxZ0ON7WKXWJ4AqHOgUJMlSbwacx8qcSZk15YJG
yR02M4hQMPpKRHHSCfNvn1EoC2DHR/HbnibDN0hTe1RkYsPKUv85X+nwHLb1uW49
Yg/tpZ4OSFmMCQYQopW0bffgNK05i0cypnANyGM45qooTdOyMQOUf7Nw7FbUWjSK
aDHHHeWMCs/CZy6as3c1m5PDrgKncByRVcKT6o1eack0p6Ok6zPmSUe9uePVzLoB
NJ+QPh+s0SCltRZ0MG5cC/+NNC0d/Z9CMwzrcSMg+n9VzQIjX3C+cB+6wVxMdAv8
3KA3kaFHl1DWgtYLfdxdE0q/hkrBzg==
=xE1N
-----END PGP SIGNATURE-----

--LfQcPIWFRhGivmDw--
