Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15D5A358B2D
	for <lists+live-patching@lfdr.de>; Thu,  8 Apr 2021 19:17:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231715AbhDHRRp (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 8 Apr 2021 13:17:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:51272 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231566AbhDHRRp (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Thu, 8 Apr 2021 13:17:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DF573610CB;
        Thu,  8 Apr 2021 17:17:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617902253;
        bh=ykKp1akjkHmFVsCmmxHgAOTnse/yQ6LB91228cNNbSk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UJ2Z239J5RKZJxaT26Od0c6Kswl6XTFecrD5wjdIBagN3xZ4BcBQ4R8wT+we8fhn6
         NVJ2uOLRgUbWtUhm/6C87dPOX38sHrY3kPJtMW3MWdS4u3R1XtHvEgqfxK46JUsg28
         hx8YVr2yna/pLymvMyZp33oa8ReMp+PkfOH534BItQULMElZfvzI5/oU3Pd64ZJFj8
         uvBzDDbbI2oI49PYTGl8fYRBdrHaQvDw7sF8NIzIyjMxdv9tCOX3eHH7o7yYVQaZod
         mwv0hSmVyr2Jspfqmc/QT4SEl2RhAblsi+qtT6KTjoSfXUBIXQO5YjoDZ2HfpxUHGc
         vzv3teOLkfzfw==
Date:   Thu, 8 Apr 2021 18:17:15 +0100
From:   Mark Brown <broonie@kernel.org>
To:     madvenka@linux.microsoft.com
Cc:     mark.rutland@arm.com, jpoimboe@redhat.com, jthierry@redhat.com,
        catalin.marinas@arm.com, will@kernel.org,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 1/4] arm64: Implement infrastructure for stack
 trace reliability checks
Message-ID: <20210408171715.GQ4516@sirena.org.uk>
References: <705993ccb34a611c75cdae0a8cb1b40f9b218ebd>
 <20210405204313.21346-1-madvenka@linux.microsoft.com>
 <20210405204313.21346-2-madvenka@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="GJ7e10BhKqIkML+d"
Content-Disposition: inline
In-Reply-To: <20210405204313.21346-2-madvenka@linux.microsoft.com>
X-Cookie: Editing is a rewording activity.
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org


--GJ7e10BhKqIkML+d
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Apr 05, 2021 at 03:43:10PM -0500, madvenka@linux.microsoft.com wrote:

> These checks will involve checking the return PC to see if it falls inside
> any special functions where the stack trace is considered unreliable.
> Implement the infrastructure needed for this.

Following up again based on an off-list discussion with Mark Rutland:
while I think this is a reasonable implementation for specifically
listing functions that cause problems we could make life easier for
ourselves by instead using annotations at the call sites to put things
into sections which indicate that they're unsafe for unwinding, we can
then check for any address in one of those sections (or possibly do the
reverse and check for any address in a section we specifically know is
safe) rather than having to enumerate problematic functions in the
unwinder.  This also has the advantage of not having a list that's
separate to the functions themselves so it's less likely that the
unwinder will get out of sync with the rest of the code as things evolve.

We already have SYM_CODE_START() annotations in the code for assembly
functions that aren't using the standard calling convention which should
help a lot here, we could add a variant of that for things that we know
are safe on stacks (like those we expect to find at the bottom of
stacks).

--GJ7e10BhKqIkML+d
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmBvOpoACgkQJNaLcl1U
h9Cy0wf+OaavKzk9eiyW+tvh0GVkxjG8LWGiD62MLVU4FeD4f/FXOLAVN/2pU6ny
osBiQaNMt93X/Hi2G4X8cd44X2KXZn9mbnBraHNW0R2Wy87eom3+tZETgt6iNoHI
6h98B5fhCQ2iwWgkHSovqeHmZWBzwSRmDnMdecj1cxP+10Py8ba+P9X5ectWj4Ed
H6J6/JpwmKoFvneeG1E8i5gKLl+0dVEDcqZo/e1bcHHTqeCre+3/IHQcsVb4nKd4
+q8EfE6sfD5UkrkGg2oyuz3HJIVkkvcTXp/192h4p6FqvST8c2+ov1yno6nbZzYX
gjc7yQaQPM0L4mFoRH9G7z5IrAWXjQ==
=xayw
-----END PGP SIGNATURE-----

--GJ7e10BhKqIkML+d--
