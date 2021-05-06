Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 157F43757A4
	for <lists+live-patching@lfdr.de>; Thu,  6 May 2021 17:39:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235959AbhEFPkV (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 6 May 2021 11:40:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:49892 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236250AbhEFPjd (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Thu, 6 May 2021 11:39:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 756AF610A1;
        Thu,  6 May 2021 15:38:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620315513;
        bh=Q0AranOJ2+2R5VGGKS2I1dV1saSj95Pxw1bkJgk4TOw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=K1dYaLVfKwmMdywlq+dp4lgLL14sAB8nlpvKcKEPfl+/a7xB+/v/MiccBHrmR8g6X
         NGqmPtk9l4W1PbH4KpxwUA67EjnyJqksUqPw3gvxRJDIU8FD6LNhnHU0kSn+WBA3F4
         opWFJwZG+zhydS0F6nY1gpNgSDstCGtDLoBq6ApRtGEX4hSdJzLgYdpnxG/0w+l+Mn
         R5dvmmQNssVIYz2622Bzs2k+04fwHchUAaz+nYcpMLNSsmTzcameH7ojKVDYnr4Ccr
         dfCkk0CmirETJrI9dLPH7oY/XqiWP84SClNqsRX05e1/G/1sY1MlD/UAY5YWgFijh/
         ynC7OtLGhZUTA==
Date:   Thu, 6 May 2021 16:37:56 +0100
From:   Mark Brown <broonie@kernel.org>
To:     "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
Cc:     jpoimboe@redhat.com, mark.rutland@arm.com, jthierry@redhat.com,
        catalin.marinas@arm.com, will@kernel.org, jmorris@namei.org,
        pasha.tatashin@soleen.com, linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v3 3/4] arm64: Handle miscellaneous functions in
 .text and .init.text
Message-ID: <20210506153756.GA3377@sirena.org.uk>
References: <65cf4dfbc439b010b50a0c46ec500432acde86d6>
 <20210503173615.21576-1-madvenka@linux.microsoft.com>
 <20210503173615.21576-4-madvenka@linux.microsoft.com>
 <20210506141211.GE4642@sirena.org.uk>
 <8268fde8-5f3b-0781-971b-b29b5e0916cf@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="Dxnq1zWXvFF0Q93v"
Content-Disposition: inline
In-Reply-To: <8268fde8-5f3b-0781-971b-b29b5e0916cf@linux.microsoft.com>
X-Cookie: Is this really happening?
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org


--Dxnq1zWXvFF0Q93v
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, May 06, 2021 at 10:30:21AM -0500, Madhavan T. Venkataraman wrote:
> On 5/6/21 9:12 AM, Mark Brown wrote:
> > On Mon, May 03, 2021 at 12:36:14PM -0500, madvenka@linux.microsoft.com wrote:

> > I was thinking it'd be good to do this by modifying SYM_CODE_START() to
> > emit the section, that way nobody can forget to put any SYM_CODE into a
> > special section.  That does mean we'd have to first introduce a new

> OK. I could make the section an argument to SYM_CODE*() so that a developer
> will never miss that. Some documentation may be in order so the guidelines
> are clear. I will do the doc patch separately, if that is alright with
> you all.

I was thinking to have standard SYM_CODE default to a section then a
variant for anything that cares (like how we have SYM_FUNC_PI and
friends for the PI code for EFI).

> > We also have a bunch of things like __cpu_soft_restart which don't seem
> > to be called out here but need to be in .idmap.text.

> It is already in .idmap.text.

Right, I meant that I was expecting to see things that need to be in a
specific section other than .code.text called out separately here if
we're enumerating them.  Though if the annotations are done separately
then this patch wouldn't need to do that calling out at all, it'd be
covered as part of fiddling around with the annotations.

--Dxnq1zWXvFF0Q93v
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmCUDVMACgkQJNaLcl1U
h9Drpwf/SRzqFMWq22H1Ml8s27Hh49gC4CLFUccseoSmz/co/VzB6TRhYlOyIfHE
CquUlAiLLDlHRaIeZLOc9bPRdafdaXoC58VYe8TUsyKHl0+pmWo4X2A9ky2Ig9RM
pFFvTMAU2xA1wAh6JRpJVYU0tPZv5nrQ7HSOmoDkySeimDkMbE64RJLIrOr/uxMw
LPuqYgruwUirX05C7FPyEQHPCle7/IkJ448nrY9noXSJ5Qh69Mf5YyfKCvVQI1bC
mKhjwpj9r13kF0dpMa8haPuLNmu1pbFcCgTcwzpJ87w7AQ1LtGPy+Pmvzj7ESM6y
lu03JhhYAU9hJSRQAfMFkyb/FTqShg==
=HPop
-----END PGP SIGNATURE-----

--Dxnq1zWXvFF0Q93v--
