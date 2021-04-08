Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B4BF3587FD
	for <lists+live-patching@lfdr.de>; Thu,  8 Apr 2021 17:15:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232047AbhDHPP6 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 8 Apr 2021 11:15:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:44286 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231843AbhDHPP5 (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Thu, 8 Apr 2021 11:15:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7CF65610F9;
        Thu,  8 Apr 2021 15:15:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617894946;
        bh=+VnzUMOXfz6cU/wT1PfU8iaaqhFnOpYzmjaxX8vrP8Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GT6L4+5nBdYVQcHEaSAqiJUYEY4UPNppgX7G9qgRGmLatFfn+shgEsVEgKjrd2j6U
         S3t719YAa6W7WYsLT9pqPg/gVb+PUpJqGyxEpjvgGgoC6SuYreTL2KwNFzcGACgmdc
         dZJv73bwI3t/gmvKCSO5gjWOetnUWrsXFSiM38GUIF86KalfQWXS9xzLBi3aYm3L0f
         O/DimPMVLh6nRyY5HpT/I+Om1Iri3mLXf/ksUYb/zWVuHAQhT3KNCoMdGxunL0mbM5
         UY12d6IyxhVPOISLprcRderHr+83RtsqeHnJwrDZU1DzBhPFZrN3gUclge5UMiVy30
         7V7QqAq8+Otew==
Date:   Thu, 8 Apr 2021 16:15:27 +0100
From:   Mark Brown <broonie@kernel.org>
To:     madvenka@linux.microsoft.com
Cc:     mark.rutland@arm.com, jpoimboe@redhat.com, jthierry@redhat.com,
        catalin.marinas@arm.com, will@kernel.org,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 1/4] arm64: Implement infrastructure for stack
 trace reliability checks
Message-ID: <20210408151527.GM4516@sirena.org.uk>
References: <705993ccb34a611c75cdae0a8cb1b40f9b218ebd>
 <20210405204313.21346-1-madvenka@linux.microsoft.com>
 <20210405204313.21346-2-madvenka@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="Nj4mAaUCx+wbOcQD"
Content-Disposition: inline
In-Reply-To: <20210405204313.21346-2-madvenka@linux.microsoft.com>
X-Cookie: Editing is a rewording activity.
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org


--Nj4mAaUCx+wbOcQD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 05, 2021 at 03:43:10PM -0500, madvenka@linux.microsoft.com wrot=
e:
> From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
>=20
> Implement a check_reliability() function that will contain checks for the
> presence of various features and conditions that can render the stack tra=
ce
> unreliable.

Reviewed-by: Mark Brown <broonie@kernel.org>

--Nj4mAaUCx+wbOcQD
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmBvHg8ACgkQJNaLcl1U
h9AF5Af8DWPBEFzpSZysV+a5rMgKPdkt45zUiUTOR4BSiKWB90wcQHxGE+nMhfla
G1CUyjkXcyIyKxxBb3lh6ZQ1DRZHRQf4JeoaGD7s4Bf9bMQ0zs0DGrrLwPArB1FI
C81PkNkWD6cOho37CORL6kI9Ph5RO4hF/iaiAbWm+QYGxmXwVAw6waGs2NWN/tgd
q/OAlH6eM3faT93DnkvPlVaalBmQ6aebBMfsgGAawaub7jn89EbkUd5BDFZckN+Q
ymMZYN6H0C6rH/+wB/7z4Tcxm/c9P8qIu815hNYsBCVQ+Wad8YXJjvLN02MFFnGi
/flePCm/vA4mgAg2NTl5g6HI1Zi/iA==
=PPRu
-----END PGP SIGNATURE-----

--Nj4mAaUCx+wbOcQD--
