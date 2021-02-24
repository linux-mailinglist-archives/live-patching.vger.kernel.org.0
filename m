Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 183E7323BEA
	for <lists+live-patching@lfdr.de>; Wed, 24 Feb 2021 13:36:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233159AbhBXMfV (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 24 Feb 2021 07:35:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:46340 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232767AbhBXMfV (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Wed, 24 Feb 2021 07:35:21 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BBD9064ED3;
        Wed, 24 Feb 2021 12:34:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614170079;
        bh=+54c20/fHB+vsC4mh/3vecMne45w1iE6dDHMbiH1IKM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZVbyWGvGLLfWL2PVsf+dQ5uYXW9n6+Ecyob0kYfIptlZew0mV7KLGaO8ePQz5dTY2
         H6LI+Ui6ZdqQvF0HRNnfb+PAiqmU6ffIEMahAUUlL7gR/B5BX8wsmW/GlICCSFznoP
         yN8Mvd/ZkZa/0EOV+rtB+o9ojCnDLx6AixvmKBLe+ZbPLF3mm3al1q+ppJs24Dw6VX
         4Ff1tbsf3cPYyFwTBHLUlV5OdoLP0JaxD2lBHXlPcvjTMRPcDSH+nytWW81g/t5PdW
         Uot5gaDbG+ppItW0Zp5LE7AcF/37vD3e8P6UkaSt4TPdc1cxI7obLacSmUUd+rOP0H
         0LH3ZBTZPH5Ow==
Date:   Wed, 24 Feb 2021 12:33:36 +0000
From:   Mark Brown <broonie@kernel.org>
To:     "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
Cc:     mark.rutland@arm.com, jpoimboe@redhat.com, jthierry@redhat.com,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v1 1/1] arm64: Unwinder enhancements for reliable
 stack trace
Message-ID: <20210224123336.GA4504@sirena.org.uk>
References: <bc4761a47ad08ab7fdd555fc8094beb8fc758d33>
 <20210223181243.6776-1-madvenka@linux.microsoft.com>
 <20210223181243.6776-2-madvenka@linux.microsoft.com>
 <20210223190240.GK5116@sirena.org.uk>
 <08e8e02c-8ef0-26bb-1d0d-7dda54b5fefd@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="7JfCtLOvnd9MIVvH"
Content-Disposition: inline
In-Reply-To: <08e8e02c-8ef0-26bb-1d0d-7dda54b5fefd@linux.microsoft.com>
X-Cookie: He's dead, Jim.
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org


--7JfCtLOvnd9MIVvH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Feb 23, 2021 at 01:20:49PM -0600, Madhavan T. Venkataraman wrote:
> On 2/23/21 1:02 PM, Mark Brown wrote:
> > On Tue, Feb 23, 2021 at 12:12:43PM -0600, madvenka@linux.microsoft.com wrote:

> >> Reliable stack trace function
> >> =============================
> >>
> >> Implement arch_stack_walk_reliable(). This function walks the stack like
> >> the existing stack trace functions with a couple of additional checks:

> > Again, this should be at least one separate patch.  How does this ensure
> > that we don't have any issues with any of the various probe mechanisms?
> > If there's no need to explicitly check anything that should be called
> > out in the changelog.

> I am trying to do this in an incremental fashion. I have to study the probe
> mechanisms a little bit more before I can come up with a solution. But
> if you want to see that addressed in this patch set, I could do that.
> It will take a little bit of time. That is all.

Handling of the probes stuff seems like it's critical to reliable stack
walk so we shouldn't claim to have support for reliable stack walk
without it.  If it was a working implementation we could improve that'd
be one thing but this would be buggy which is a different thing.

> >> +	(void) on_accessible_stack(task, stackframe, &info);

> > Shouldn't we return NULL if we are not on an accessible stack?

> The prev_fp has already been checked by the unwinder in the previous
> frame. That is why I don't check the return value. If that is acceptable,
> I will add a comment.

TBH if you're adding the comment it seems like you may as well add the
check, it's not like it's expensive and it means there's no possibility
that some future change could result in this assumption being broken.

--7JfCtLOvnd9MIVvH
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmA2R58ACgkQJNaLcl1U
h9AblQf+Ip4D1mZLod2Rli2j6mPrZU5hrwGsSqkDASVi8ze3oU8RMi6w/6s3MOFs
IBMU7ReV/znwM0f4MHHxXR3HH+pB+m2OgbwTMxZf4iPk+9PFlIkt4QZXVTRV0t8A
L28n9lbVfjnfScmcHVYo8Kkrs9wO+fzfSXG7ApIPyg0OO1fFTSkRcVM+2UIQ2yPj
7he+avWS1b+G44VeQxKj0/MYzOuDq4tZOScblOaVVv5P6CaHwlIpPGYL2f9lLd/N
vbVck3dHthYs1wcyiMpOr5SUIS7TfWa851mgknTQYIf9eL4eqVZz12ERff06FBn/
NT20sMWw/G/W5YgTfY1aFJzEfjXEzA==
=WGh3
-----END PGP SIGNATURE-----

--7JfCtLOvnd9MIVvH--
