Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FF1A3757CE
	for <lists+live-patching@lfdr.de>; Thu,  6 May 2021 17:45:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235293AbhEFPqY (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 6 May 2021 11:46:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:52576 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235136AbhEFPqY (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Thu, 6 May 2021 11:46:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 590E9610A1;
        Thu,  6 May 2021 15:45:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620315925;
        bh=N+L4ofDDI1G+Zqqt4iiEoQaYssGLMuuauZiJzlLQNz8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Nwyaf2ls7AhkjWIliP9lU0c59V33ES+tGuvVtKCvO+HGLs3n2vQ5q0K1GtfnCbn1Q
         dsx7mF2Dwk6yGS2BGObeM6+EkzYgD5GtSX+iLy5qWI77MiEutOpPxVSgXsX+YDwogf
         gaIYvcAnHzoN9/MTiGg+biW7WzYVsdIDw5xzqRgjJCAHcFdP6ze49PnDG9dXuEjVWg
         A06+XKMotjCXaMWpiLe2NRFBnjFBCKBw3ZdkoJvEXI2WFuVh6AZLXi3xpdd58w7NA2
         vn3OeFx4+MgLhSWdpOlGlPHHPAAkDdX7D7sT3rfk8pTC+kWtlTn5+jmeSniaxdKKAJ
         74uIouSQiFqww==
Date:   Thu, 6 May 2021 16:44:49 +0100
From:   Mark Brown <broonie@kernel.org>
To:     "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
Cc:     jpoimboe@redhat.com, mark.rutland@arm.com, jthierry@redhat.com,
        catalin.marinas@arm.com, will@kernel.org, jmorris@namei.org,
        pasha.tatashin@soleen.com, linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v3 3/4] arm64: Handle miscellaneous functions in
 .text and .init.text
Message-ID: <20210506154449.GB3377@sirena.org.uk>
References: <65cf4dfbc439b010b50a0c46ec500432acde86d6>
 <20210503173615.21576-1-madvenka@linux.microsoft.com>
 <20210503173615.21576-4-madvenka@linux.microsoft.com>
 <20210506141211.GE4642@sirena.org.uk>
 <8268fde8-5f3b-0781-971b-b29b5e0916cf@linux.microsoft.com>
 <cb2c47ee-97d7-15d8-05db-b8e3e260b782@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="Yylu36WmvOXNoKYn"
Content-Disposition: inline
In-Reply-To: <cb2c47ee-97d7-15d8-05db-b8e3e260b782@linux.microsoft.com>
X-Cookie: Is this really happening?
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org


--Yylu36WmvOXNoKYn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, May 06, 2021 at 10:32:30AM -0500, Madhavan T. Venkataraman wrote:
> On 5/6/21 10:30 AM, Madhavan T. Venkataraman wrote:

> > OK. I could make the section an argument to SYM_CODE*() so that a developer
> > will never miss that. Some documentation may be in order so the guidelines
> > are clear. I will do the doc patch separately, if that is alright with
> > you all.

> There is just one problem with this. Sometimes, there is some data in the
> same text section. That data will not get included when we do the SYM_CODE(section)
> change.

Yes, data would need to be handled separately still.  That doesn't seem
insurmountable though?

--Yylu36WmvOXNoKYn
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmCUDvAACgkQJNaLcl1U
h9BAzAf7BUQnElClcvmT+dBBRTWnYojAENyqbBPPEn6X+P179HYWy5WpwRmE1cTv
GE5ZFVMzSNzGrkv/jW+r8NAvNh2+xjyF7VMh+1M3w4qPdfs7bngWtdiUZNSnq8dk
ccdmrpwiFvkzju1N2FoRsXducBoL5nk9UNfhxxnrL0akSyx/8TLy3o3W0STLEzS3
YkKLj78Ztl53tHmcHyCNhUbzwUPg+X7hD5Wkpd2J4BUE5dxnH+e1jooM3LCfXO5a
T7dC01lilqwTczaO6uspqAy3iHAuJz0G4fspfzsO/kmnnxbNOcvys4YTYtBgyvE1
LvrwhEQvm4XDJzxlJffyFqRdjjFicQ==
=f9vv
-----END PGP SIGNATURE-----

--Yylu36WmvOXNoKYn--
