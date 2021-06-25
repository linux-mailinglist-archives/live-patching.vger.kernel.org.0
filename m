Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD4533B46FA
	for <lists+live-patching@lfdr.de>; Fri, 25 Jun 2021 17:51:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229759AbhFYPyN (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 25 Jun 2021 11:54:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:45138 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229774AbhFYPyN (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Fri, 25 Jun 2021 11:54:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E28C56195D;
        Fri, 25 Jun 2021 15:51:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624636312;
        bh=Q6AwIy7XeT7mjSj18u1iyC3ch7ZFJBonoUlzckIGJz0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pPYAhl3YvsV9Mx6354i5NxPxvzH84VwzuxVv6pFzswdd4gal4OHM9RH6y8ra0PUMb
         dyx7Jy+fparTreYxynyFKh+dXu3NkK71FXlJ7cxU22kb7SiVJjinngh1OVXY+a1Dhu
         Xtjmm1KEUUdLSHpivR3oxXlhK+EkVXsRIY/CBlVuxQ1a6O8290ZsLyKUqnrypn3XrY
         R+QIHzZvs3BSAS+2u712PXr6jdHCfnYnZTXhO8SxKl5cdRa6XvS6UOA0AlW+3x23Q0
         eLgen7qddzwPa3nSVhaOA0nYl5pKZfZ4eew9dLHWCcRtV0q5SlLQ3H266GX8YC+yz3
         jcL7OCDZ0FfdQ==
Date:   Fri, 25 Jun 2021 16:51:27 +0100
From:   Mark Brown <broonie@kernel.org>
To:     "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
Cc:     Mark Rutland <mark.rutland@arm.com>, jpoimboe@redhat.com,
        ardb@kernel.org, nobuta.keiya@fujitsu.com, catalin.marinas@arm.com,
        will@kernel.org, jmorris@namei.org, pasha.tatashin@soleen.com,
        jthierry@redhat.com, linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v5 1/2] arm64: Introduce stack trace reliability
 checks in the unwinder
Message-ID: <20210625155127.GC4492@sirena.org.uk>
References: <ea0ef9ed6eb34618bcf468fbbf8bdba99e15df7d>
 <20210526214917.20099-1-madvenka@linux.microsoft.com>
 <20210526214917.20099-2-madvenka@linux.microsoft.com>
 <20210624144021.GA17937@C02TD0UTHF1T.local>
 <da0a2d95-a8cd-7b39-7bba-41cfa8782eaa@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="Izn7cH1Com+I3R9J"
Content-Disposition: inline
In-Reply-To: <da0a2d95-a8cd-7b39-7bba-41cfa8782eaa@linux.microsoft.com>
X-Cookie: HELLO, everybody, I'm a HUMAN!!
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org


--Izn7cH1Com+I3R9J
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jun 25, 2021 at 10:39:57AM -0500, Madhavan T. Venkataraman wrote:
> On 6/24/21 9:40 AM, Mark Rutland wrote:

> > At a high-level, I'm on-board with keeping track of this per unwind
> > step, but if we do that then I want to be abel to use this during
> > regular unwinds (e.g. so that we can have a backtrace idicate when a
> > step is not reliable, like x86 does with '?'), and to do that we need to
> > be a little more accurate.

> The only consumer of frame->reliable is livepatch. So, in retrospect, my
> original per-frame reliability flag was an overkill. I was just trying to
> provide extra per-frame debug information which is not really a requirement
> for livepatch.

It's not a requirement for livepatch but if it's there a per frame
reliability flag would have other uses - for example Mark has mentioned
the way x86 prints a ? next to unreliable entries in oops output for
example, that'd be handy for people debugging issues and would have the
added bonus of ensuring that there's more constant and widespread
exercising of the reliability stuff than if it's just used for livepatch
which is a bit niche.

> So, let us separate the two. I will rename frame->reliable to frame->livepatch_safe.
> This will apply to the whole stacktrace and not to every frame.

I'd rather keep it as reliable, even with only the livepatch usage I
think it's clearer.

> Finally, it might be a good idea to perform reliability checks even in
> start_backtrace() so we don't assume that the starting frame is reliable even
> if the caller passes livepatch_safe=true. What do you think?

That makes sense to me.

--Izn7cH1Com+I3R9J
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmDV+34ACgkQJNaLcl1U
h9Ch+wf7BDR5lejSlhWSQ/gqNm01WBJhVAeZE6s4y9+c0vbutI3yLY2OcMHxA4n7
AqJifvW72eAeiGM4ZvtlFWdOTOjLc6vSMId9hn69OU5hI//Jdlrg2uC8pntVuIP3
qMPKXD54YRlIKNPvyDYaxOr9LbrCRzjA7Ixoobo5i35gnqp/506vX1Lc5dP3/XBR
b3jfNzy+XgnDAhNqaCwOCrzEhP4JbbmQsSF5/MiwAFkFmyMFR7hyjO9ElkFY2hOW
n3Tmzc5gXdR8mm7nFO9d3OrvmW5/xHGcnr8Y24d5aX3/QLMtl1koMw++rlgtBFKn
fiqKgwytD3K3JoHK4WsStDCWOsS3ug==
=dFiB
-----END PGP SIGNATURE-----

--Izn7cH1Com+I3R9J--
