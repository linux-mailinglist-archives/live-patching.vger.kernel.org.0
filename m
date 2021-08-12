Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9FC33EA777
	for <lists+live-patching@lfdr.de>; Thu, 12 Aug 2021 17:24:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238052AbhHLPYZ (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 12 Aug 2021 11:24:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:39648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237954AbhHLPYQ (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Thu, 12 Aug 2021 11:24:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7AC686108C;
        Thu, 12 Aug 2021 15:23:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628781830;
        bh=acZbYeX5MRjY4RKNfZCIAUPWLL4YXsg1dpIXXPKpKg8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LaZJDMpq/mWuV4Z09OXtrLBxe0UEvA+4POyheCUlXFI43HEVfdMy8XitdzrrJTGRi
         kI4CtEPDr+yielPnHG1CUEpzu4Zr2ShVqm5ZW3fvCNuxPJVlgRgAoDMel8Jx3kvrhC
         NF6HDw9ly0YAZNT2JBmxAkFcBXKe8T5TJd8hnSdReeLY6Qz4Zhty2BngShZbWDZFuU
         EaLJuxOBDZcIieX7ICNOXTeFG5z1g4H7lAfdJ6gZ3qYK30fT1L9QzBUhOqAqTHn8S/
         2K5NEpfjQW9C312PRaYqv2AOWdaiUaiMU2JzT028r7l8I+XMPSi4KuJmjPwxPqGpJS
         p7u1GALb1Dv1Q==
Date:   Thu, 12 Aug 2021 16:23:31 +0100
From:   Mark Brown <broonie@kernel.org>
To:     madvenka@linux.microsoft.com
Cc:     mark.rutland@arm.com, jpoimboe@redhat.com, ardb@kernel.org,
        nobuta.keiya@fujitsu.com, sjitindarsingh@gmail.com,
        catalin.marinas@arm.com, will@kernel.org, jmorris@namei.org,
        pasha.tatashin@soleen.com, jthierry@redhat.com,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v7 1/4] arm64: Make all stack walking functions use
 arch_stack_walk()
Message-ID: <20210812152331.GA4239@sirena.org.uk>
References: <3f2aab69a35c243c5e97f47c4ad84046355f5b90>
 <20210812132435.6143-1-madvenka@linux.microsoft.com>
 <20210812132435.6143-2-madvenka@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="mP3DRpeJDSE+ciuQ"
Content-Disposition: inline
In-Reply-To: <20210812132435.6143-2-madvenka@linux.microsoft.com>
X-Cookie: Vote anarchist.
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org


--mP3DRpeJDSE+ciuQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 12, 2021 at 08:24:32AM -0500, madvenka@linux.microsoft.com wrot=
e:

> Here is the list of functions:
>=20
> 	perf_callchain_kernel()
> 	get_wchan()
> 	return_address()
> 	dump_backtrace()
> 	profile_pc()

I've not actually gone through this properly yet but my first thought is
that for clarity this should be split out into a patch per user plus one
to delete the old interface  - I'd not worry about it unless it needs to
get resubmitted though.

It'll definitely be good to get this done!

--mP3DRpeJDSE+ciuQ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmEVPPIACgkQJNaLcl1U
h9AePgf/VA+EigJwvwMqUEGijo5q4SHHlgzCEwAGXA9qCpe8ShyFjxQQdOTHb3R6
10ASH1AJEhmkXF4N95StpyTR/r5CyNnPPQJAldoKEgtoSV6QfIZm16kud8XlXWks
aQZjcbUwBLGXcQSLMnbVoqzM6Fk5ViivuYWfN96Z/nlciSMpg3grkMPrj+7PhJnt
ZVgN4L2GQWKjFU59CZhYtmp7886MiASDJ3jo34mJRmoCtbq+mMje0GpWrwX7c6Xk
0FNOYMNZ/I4KVNExxyQSu7DCxJ/K98Y08d1WXOCgNNO4bSpgC0pyJSTbGCpYoXbS
A/GpZiCia9Lt5U7a+6HzXwiFj0Cx6A==
=C9+3
-----END PGP SIGNATURE-----

--mP3DRpeJDSE+ciuQ--
