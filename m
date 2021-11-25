Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F10A145DC61
	for <lists+live-patching@lfdr.de>; Thu, 25 Nov 2021 15:32:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355775AbhKYOgC (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 25 Nov 2021 09:36:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:48214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352655AbhKYOeC (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Thu, 25 Nov 2021 09:34:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5FB7761041;
        Thu, 25 Nov 2021 14:30:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637850650;
        bh=0xFa/kwdXuhHGsjEJDOWGKhXNOfWoCQ4zX3oRmtXPxo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=i+pjcraC1g8STD7bshWvHBCH/nHgvcuDoiDHv5VWbW7Ei8uCUs9qaRx40KWQywqgX
         X/gAyXOaVJRDMwOMCvAgP88/3DBrZgO5GiepBqGbyoZmLEvuhkkDHaOukDFhCpcc1s
         COsh0Tf+dI/4Q3UFVTslcCOwc/DA8kLGtvZmgzTIBlD3XwPP17VPkB6XIvaR1YaO0O
         TcuUUGnKGEvJjCCWUA9WSspuqItCFf1Ia42z6THHPxgA2M3xLO7WYbEplOye464lC5
         Dgir5e2OKcNTJXmoOuBipFPrlJrUPDYbBCwNPbVBbAEDOmcuspaj9RYvlYTTKToX5H
         e+YqGFjWSUFWQ==
Date:   Thu, 25 Nov 2021 14:30:45 +0000
From:   Mark Brown <broonie@kernel.org>
To:     madvenka@linux.microsoft.com
Cc:     mark.rutland@arm.com, jpoimboe@redhat.com, ardb@kernel.org,
        nobuta.keiya@fujitsu.com, sjitindarsingh@gmail.com,
        catalin.marinas@arm.com, will@kernel.org, jmorris@namei.org,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v11 3/5] arm64: Make the unwind loop in unwind() similar
 to other architectures
Message-ID: <YZ+eFXEfTLa8KIHw@sirena.org.uk>
References: <8b861784d85a21a9bf08598938c11aff1b1249b9>
 <20211123193723.12112-1-madvenka@linux.microsoft.com>
 <20211123193723.12112-4-madvenka@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="N9fRGPaMmAWIuANF"
Content-Disposition: inline
In-Reply-To: <20211123193723.12112-4-madvenka@linux.microsoft.com>
X-Cookie: This bag is recyclable.
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org


--N9fRGPaMmAWIuANF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Nov 23, 2021 at 01:37:21PM -0600, madvenka@linux.microsoft.com wrote:

> 	unwind_start(&frame, fp, pc);
> 	while (unwind_continue(tsk, &frame, fn, data))
> 		unwind_next(tsk, &frame);

Other architectures seem to call their unwind_next() unwind_next_frame()
instead, and use a function unwind_done() rather than unwind_continue().
I appreciate that's actually a change carried through from one of the
earlier patches but might be worth considering.  I don't really *mind*
that, though if there's any work on pulling more code out of the
architecture into the generic code it'll need revisiting in at least
some of the architectures.

Reviwed-by: Mark Brown <broonie@kernel.org>

--N9fRGPaMmAWIuANF
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmGfnhQACgkQJNaLcl1U
h9ANJwf9F7OP5Y+O3J9bKoFwrSqLplZJrP0ez14Osw/lJI/amq5E68KgqEuqQ1jK
tvKaaL4x0akbB8U3gCZxif9mvy5TZTrnDxhusoRYQOX7FDGh6wsEynMTwQNBftGh
poSLi2vL4QfFo0ZsLrSvPNrN6zItHsvsDV7RAhogTNGu9N62v2Va7+cv22Oi0gXl
XfBjiCR7A4teQnsKmh8DJfw5ELOrsP2VfxU4iea8olOfPK51GgryEc2c911QrluX
Yq2720KDeM+lVbWOQaLXe9evEbg7utUR6sPHQw3w33HEUKDczFksLsH+8xBbltCq
WRM50262xBv0AiT5fVOpE2/9+lsRcQ==
=3X6L
-----END PGP SIGNATURE-----

--N9fRGPaMmAWIuANF--
