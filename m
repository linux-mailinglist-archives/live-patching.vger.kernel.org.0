Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B4DF359E0D
	for <lists+live-patching@lfdr.de>; Fri,  9 Apr 2021 13:57:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232469AbhDIL5k (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 9 Apr 2021 07:57:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:51472 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231611AbhDIL5k (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Fri, 9 Apr 2021 07:57:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ABD266115B;
        Fri,  9 Apr 2021 11:57:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617969447;
        bh=xWpZMs8SF1KeRP75gFOHcEWwPPGqR29BI1NfJEUZSpM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=p5nvaFt2mOhhxiQsclwdeybVrho712FuWXR+NV8KhOzB2O7xRD4wLfZHp4HgW3ypz
         h6y1CTRkgOerE2hXcrD9b6oXIUxy4NRLcPnhmzkxyfix2DIFv2d9z/20+3QwcB7uTF
         j6QHEE7lXRZkW8rU7pVWXcyRBwFxUduEJ1uyGcwfevQISRDSN++5xjTdu7G6a0a7Zm
         JiSaOVX+TTq5oUkdkA/QsRSxqfP6E5paBUgkm0J6wGGead2CHJkVWACA2ValNdbUVW
         875sa8vPjaBibm7/DvjjFV5ZVwbB7RXDXWSTa1yv2xgI1BnkXF8DgpsRDIgHnSulfH
         jaNIv44yfKZsw==
Date:   Fri, 9 Apr 2021 12:57:08 +0100
From:   Mark Brown <broonie@kernel.org>
To:     "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
Cc:     mark.rutland@arm.com, jpoimboe@redhat.com, jthierry@redhat.com,
        catalin.marinas@arm.com, will@kernel.org,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 1/4] arm64: Implement infrastructure for stack
 trace reliability checks
Message-ID: <20210409115708.GB4499@sirena.org.uk>
References: <705993ccb34a611c75cdae0a8cb1b40f9b218ebd>
 <20210405204313.21346-1-madvenka@linux.microsoft.com>
 <20210405204313.21346-2-madvenka@linux.microsoft.com>
 <20210408171715.GQ4516@sirena.org.uk>
 <69b6924b-88f6-6c40-7b18-8cdf15d92bd1@linux.microsoft.com>
 <eb905f70-a963-6257-c597-89e008675539@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="GID0FwUMdk1T2AWN"
Content-Disposition: inline
In-Reply-To: <eb905f70-a963-6257-c597-89e008675539@linux.microsoft.com>
X-Cookie: Ring around the collar.
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org


--GID0FwUMdk1T2AWN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Apr 08, 2021 at 06:30:22PM -0500, Madhavan T. Venkataraman wrote:
> On 4/8/21 2:30 PM, Madhavan T. Venkataraman wrote:

> > 1. Create a common section (I will have to come up with an appropriate name) and put
> >    all such functions in that one section.

> > 2. Create one section for each logical type (exception section, ftrace section and
> >    kprobe section) or some such.

> For now, I will start with idea 2. I will create a special section for each class of
> functions (EL1 exception handlers, FTRACE trampolines, KPROBE trampolines). Instead of a
> special functions array, I will implement a special_sections array. The rest of the code
> should just fall into place.

> Let me know if you prefer something different.

It might be safer to start off by just putting all SYM_CODE into a
section then pulling bits we know to be safe out of the section as
needed - we know that anything that's SYM_CODE is doing something
non-standard and needs checking to verify that the unwinder will be
happy with it and I that should cover most if not all of the cases above
as well as anything else we didn't explicitly think of.

--GID0FwUMdk1T2AWN
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmBwQRMACgkQJNaLcl1U
h9CDkAf+M7uGGOV6l9nKclvAJwd8o31oulE0GngUxx7kQvOsTZvVfWVJOR921/x/
42gh2W7vxL7LOfQ37vMafyz3BtoO+aX29aRSfSfqskqufOk4KmbqZ2YmMTs5iiwy
r8Dr0POZ9NYuie7+f+aYLbYaLBStriNn6VamKJlomBaXmiZdvsEmmif8IrjrLLnR
Sz6+G0qFRd6VK30NB0dbpjLQzzHFDN8gc0IpPjmgSMysz+/Oe8XqGgdhq6Xti6Bl
T/A/VeO/+E3xDTwIooXm0pk95tRg8ef+gmYpFi01C63F6zEUk7/frUC/g0VZGzPL
7lxu5UFkpo8Bi9bvHxhk6LaTXjMAxw==
=y0XZ
-----END PGP SIGNATURE-----

--GID0FwUMdk1T2AWN--
