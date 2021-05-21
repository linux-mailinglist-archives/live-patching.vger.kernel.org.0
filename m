Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9877438CC6D
	for <lists+live-patching@lfdr.de>; Fri, 21 May 2021 19:42:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231508AbhEURoK (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 21 May 2021 13:44:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:50374 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235879AbhEURoJ (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Fri, 21 May 2021 13:44:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D018A61261;
        Fri, 21 May 2021 17:42:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621618966;
        bh=QG3NpUtd2fBzJ2KrQhMF9lJqFRi0bzTl/wKZyrlN1nE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=En9neZlCwfoRc+c8iB+o+VCK0bpQdTF0pHoA5/TU6lIuDW6JZsww1gmak22Ak6K8Z
         pjxM9cTmjiQFIK+ayJcdAPb9qPyp/8PxLoimxc00bxZ80oj2e7QMOLGiPRgi72VXcn
         Wpru4RRd8MluLRWB1qlEh8Vz9jqGLuQ/NB9iNRttOmB9fwDNIywwMkegD4jCEDE6UP
         TUYM4fcSEpPeuAukj6Rzeoxy61qrYoSi6JKVpIXSLWHJqjjQpzzXT5jScoCbEa+Bbj
         vesOgPcLgbJuOsIFwJxTRETNE+ulyfOBQro/TxICkhr0/9B+uAuht50dOfUs7GlV4x
         BJsnE3W8ULdkw==
Date:   Fri, 21 May 2021 18:42:42 +0100
From:   Mark Brown <broonie@kernel.org>
To:     "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
Cc:     mark.rutland@arm.com, jpoimboe@redhat.com, ardb@kernel.org,
        jthierry@redhat.com, catalin.marinas@arm.com, will@kernel.org,
        jmorris@namei.org, pasha.tatashin@soleen.com,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v4 1/2] arm64: Introduce stack trace reliability
 checks in the unwinder
Message-ID: <20210521174242.GD5825@sirena.org.uk>
References: <68eeda61b3e9579d65698a884b26c8632025e503>
 <20210516040018.128105-1-madvenka@linux.microsoft.com>
 <20210516040018.128105-2-madvenka@linux.microsoft.com>
 <20210521161117.GB5825@sirena.org.uk>
 <a2a32666-c27e-3a0f-06b2-b7a2baa7e0f1@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="DrWhICOqskFTAXiy"
Content-Disposition: inline
In-Reply-To: <a2a32666-c27e-3a0f-06b2-b7a2baa7e0f1@linux.microsoft.com>
X-Cookie: Do not write below this line.
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org


--DrWhICOqskFTAXiy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, May 21, 2021 at 12:23:52PM -0500, Madhavan T. Venkataraman wrote:
> On 5/21/21 11:11 AM, Mark Brown wrote:
> > On Sat, May 15, 2021 at 11:00:17PM -0500, madvenka@linux.microsoft.com wrote:

> >> +	frame->reliable = true;

> > All these checks are good checks but as you say there's more stuff that
> > we need to add (like your patch 2 here) so I'm slightly nervous about

> OK. So how about changing the field from a flag to an enum that says exactly
> what happened with the frame?

TBH I think the code is fine, or rather will be fine when it gets as far
as actually being used - this was more a comment about when we flip this
switch.

> Also, the caller can get an exact idea of why the stack trace failed.

I'm not sure anything other than someone debugging things will care
enough to get the code out and then decode it so it seems like it'd be
more trouble than it's worth, we're unlikely to be logging the code as
standard.

> > The other thing I guess is the question of if we want to bother flagging
> > frames as unrelaible when we return an error; I don't see an issue with
> > it and it may turn out to make it easier to do something in the future
> > so I'm fine with that

> Initially, I thought that there is no need to flag it for errors. But Josh
> had a comment that the stack trace is indeed unreliable on errors. Again, the
> word unreliable is the one causing the problem.

My understanding there is that arch_stack_walk_reliable() should be
returning an error if either the unwinder detected an error or if any
frame in the stack is flagged as unreliable so from the point of view of
users it's just looking at the error code, it's more that there's no
need for arch_stack_walk_reliable() to consider the reliability
information if an error has been detected and nothing else looks at the
reliability information.

Like I say we may come up with some use for the flag in error cases in
future so I'm not opposed to keeping the accounting there.

--DrWhICOqskFTAXiy
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmCn8REACgkQJNaLcl1U
h9CTFAf9G4Fenbj3nIkJBzuFEgOU33kLEQzVojBeW3FjvS7De9zgVhG9oaL8McKP
vAzwcsYTuX7G/f0cTEv1ZMp4f4vkOAq1wEUMVnFV0tu89AMmufviXy4i9s5J44W8
7MeUwQYw3+ObKY8fHebqBCRkRb5dwCblappISAf51zMD8HQcxj6lg5Zut0SMzmFs
azwaf89NVgvr68J6xMoO/j39x6dd1Ksm6Wbkr6FsML0bvTVwFu3wwYlUShTeOBIv
MwEtoL5M7UW9Gi4tz7rYOpLNpsT/5U8mc8JRwPPzwyw1W6bKwnoKrFN/h4ETWUQQ
Lrx0Ly7XX4CQoBKaMWgVIk0QZjqOEA==
=B4M/
-----END PGP SIGNATURE-----

--DrWhICOqskFTAXiy--
